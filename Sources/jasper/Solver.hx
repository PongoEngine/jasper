/*
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package jasper;

import jasper.exception.DuplicateConstraintException;
import jasper.exception.DuplicateEditVariableException;
import jasper.exception.UnknownConstraintException;
import jasper.exception.UnknownEditVariableException;
import jasper.exception.UnsatisfiableConstraintException;
import jasper.exception.RequiredFailureException;

using Lambda;

/**
 * Created by alex on 30/01/15.
 */
class Solver 
{
   private var cns :Map<Constraint, Tag>;
   private var rows :Map<Symbol, Row>;
   private var vars :Map<Variable, Symbol>;
   private var edits :Map<Variable, EditInfo>;
   private var infeasibleRows :Array<Symbol>;
   private var objective :Row;
   private var artificial :Row;

   /**
    *  [Description]
    */
   public function new() : Void
   {
      cns = new Map<Constraint, Tag>();
      rows = new Map<Symbol, Row>();
      vars = new Map<Variable, Symbol>();
      edits = new Map<Variable, EditInfo>();
      infeasibleRows = new Array<Symbol>();
      objective = Row.empty();
      artificial = null;
   }

   /**
    *  [Description]
    *  @param constraint - 
    */
   public function addConstraint(constraint :Constraint) : Void 
   {

      if (cns.exists(constraint)) {
         throw new DuplicateConstraintException(constraint);
      }

      var tag = new Tag();
      var row = createRow(constraint, tag);
      var subject = chooseSubject(row, tag);

      if(subject.getType() == Symbol.SymbolType.INVALID && allDummies(row)){
         if (!Util.nearZero(row.getConstant())) {
            throw new UnsatisfiableConstraintException(constraint);
         } else {
            subject = tag.marker;
         }
      }

      if (subject.getType() == Symbol.SymbolType.INVALID) {
         if (!addWithArtificialVariable(row)) {
            throw new UnsatisfiableConstraintException(constraint);
         }
      } else {
         row.solveFor(subject);
         substitute(subject, row);
         this.rows.set(subject, row);
      }

      this.cns.set(constraint, tag);

      optimize(objective);
   }

    /**
     *  [Description]
     *  @param constraint - 
     */
    public function removeConstraint(constraint :Constraint) : Void
    {
        var tag = cns.get(constraint);
        if(tag == null){
            throw new UnknownConstraintException(constraint);
        }

        cns.remove(constraint);
        removeConstraintEffects(constraint, tag);

        var row = rows.get(tag.marker);
        if(row != null){
            rows.remove(tag.marker);
        }
        else{
            row = getMarkerLeavingRow(tag.marker);
            if(row == null){
                throw new InternalSolverError("internal solver error");
            }

            var leaving :Symbol = null;
            for(s in rows.keys()){
                if(rows.get(s) == row){
                    leaving = s;
                }
            }
            if(leaving == null){
                throw new InternalSolverError("internal solver error");
            }

            rows.remove(leaving);
            row.solveForSymbols(leaving, tag.marker);
            substitute(tag.marker, row);
        }
        optimize(objective);
    }

   /**
    *  [Description]
    *  @param constraint - 
    *  @param tag - 
    */
   public function removeConstraintEffects(constraint :Constraint, tag :Tag) : Void
   {
      if(tag.marker.getType() == Symbol.SymbolType.ERROR){
         removeMarkerEffects(tag.marker, constraint.getStrength());
      }
      else if(tag.other.getType() == Symbol.SymbolType.ERROR){
         removeMarkerEffects(tag.other, constraint.getStrength());
      }
   }

   /**
    *  [Description]
    *  @param marker - 
    *  @param strength - 
    */
   public function removeMarkerEffects(marker :Symbol, strength :Float) : Void
   {
      var row = rows.get(marker);
      if(row != null){
         objective.insertRow(row, -strength);
      } else {
         objective.insertSymbol(marker, -strength);
      }
   }

   /**
    *  [Description]
    *  @param marker - 
    *  @return Row
    */
   public function getMarkerLeavingRow(marker :Symbol) : Row
   {
      var dmax = Util.FLOAT_MAX;
      var r1 = dmax;
      var r2 = dmax;

      var first :Row = null;
      var second :Row = null;
      var third :Row = null;

      for(s in rows.keys()){
         var candidateRow = rows.get(s);
         var c = candidateRow.coefficientFor(marker);
         if(c == 0.0){
            continue;
         }
         if(s.getType() == Symbol.SymbolType.EXTERNAL){
            third = candidateRow;
         }
         else if(c < 0.0){
            var r = - candidateRow.getConstant() / c;
            if(r < r1){
               r1 = r;
               first = candidateRow;
            }
         }
         else{
            var r = candidateRow.getConstant() / c;
            if(r < r2){
               r2 = r;
               second = candidateRow;
            }
         }
      }

      if(first != null){
         return first;
      }
      if(second != null){
         return second;
      }
      return third;
   }

   /**
    *  [Description]
    *  @param constraint - 
    *  @return Bool
    */
   public function hasConstraint(constraint :Constraint) : Bool
   {
      return cns.exists(constraint);
   }

   /**
    *  [Description]
    *  @param variable - 
    *  @param strength - 
    */
   public function addEditVariable(variable :Variable, strength :Float) : Void
   {
      if(edits.exists(variable)){
         throw new DuplicateEditVariableException();
      }

      strength = Strength.clip(strength);

      if(strength == Strength.REQUIRED){
         throw new RequiredFailureException();
      }

      var terms = new List<Term>();
      terms.add(Term.fromVariable(variable));
      var constraint = new Constraint(Expression.fromTerms(terms), RelationalOperator.OP_EQ, strength);

      try {
         addConstraint(constraint);
      } catch (e :DuplicateConstraintException) {
         trace(e);
      } catch (e :UnsatisfiableConstraintException) {
         trace(e);

      }

      var info = new EditInfo(constraint, cns.get(constraint), 0.0);
      edits.set(variable, info);
   }

   /**
    *  [Description]
    *  @param variable - 
    */
   public function removeEditVariable(variable :Variable) : Void
   {
      var edit = edits.get(variable);
      if(edit == null){
         throw new UnknownEditVariableException();
      }

      try {
         removeConstraint(edit.constraint);
      } catch (e :UnknownConstraintException) {
         trace(e);
      }

      edits.remove(variable);
   }

   /**
    *  [Description]
    *  @param variable - 
    *  @return Bool
    */
   public function hasEditVariable(variable :Variable) : Bool
   {
      return edits.exists(variable);
   }

   /**
    *  [Description]
    *  @param variable - 
    *  @param value - 
    */
   public function suggestValue(variable :Variable, value : Float) : Void
   {
      var info = edits.get(variable);
      if(info == null){
         throw new UnknownEditVariableException();
      }

      var delta = value - info.constant;
      info.constant = value;

      var row = rows.get(info.tag.marker);
      if(row != null){
         if(row.add(-delta) < 0.0){
            infeasibleRows.push(info.tag.marker);
         }
         dualOptimize();
         return;
      }

      row = rows.get(info.tag.other);
      if(row != null){
         if(row.add(delta) < 0.0){
            infeasibleRows.push(info.tag.other);
         }
         dualOptimize();
         return;
      }

      for(s in rows.keys()){
         var currentRow = rows.get(s);
         var coefficient = currentRow.coefficientFor(info.tag.marker);
         if(coefficient != 0.0 && currentRow.add(delta * coefficient) < 0.0 && s.getType() != Symbol.SymbolType.EXTERNAL){
            infeasibleRows.push(s);
         }
      }

      dualOptimize();
   }

   /**
    *  [Description]
    */
   public function updateVariables() : Void
   {
      for (key in vars.keys()) {
         var variable = key;
         var row = this.rows.get(vars.get(key));

         if (row == null) {
            variable.setValue(0);
         } else {
            variable.setValue(row.getConstant());
         }
      }
   }

   /**
    *  [Description]
    *  @param constraint - 
    *  @param tag - 
    *  @return Row
    */
   public function createRow(constraint :Constraint, tag :Tag) : Row
   {
      var expression = constraint.getExpression();
      var row = Row.fromConstant(expression.getConstant());


      for (term in expression.getTerms()) {
         if (!Util.nearZero(term.getCoefficient())) {
            var symbol = getVarSymbol(term.getVariable());

            var otherRow = rows.get(symbol);

            if (otherRow == null) {
               row.insertSymbol(symbol, term.getCoefficient());
            } else {
               row.insertRow(otherRow, term.getCoefficient());
            }
         }
      }

      switch (constraint.getOp()) {
         case OP_LE:

         case OP_GE: {
            var coeff = constraint.getOp() == RelationalOperator.OP_LE ? 1.0 : -1.0;
            var slack = new Symbol(Symbol.SymbolType.SLACK);
            tag.marker = slack;
            row.insertSymbol(slack, coeff);
            if (constraint.getStrength() < Strength.REQUIRED) {
               var error = new Symbol(Symbol.SymbolType.ERROR);
               tag.other = error;
               row.insertSymbol(error, -coeff);
               this.objective.insertSymbol(error, constraint.getStrength());
            }
         }

         case OP_EQ: {
            if (constraint.getStrength() < Strength.REQUIRED) {
               var errplus = new Symbol(Symbol.SymbolType.ERROR);
               var errminus = new Symbol(Symbol.SymbolType.ERROR);
               tag.marker = errplus;
               tag.other = errminus;
               row.insertSymbol(errplus, -1.0); // v = eplus - eminus
               row.insertSymbol(errminus, 1.0); // v - eplus + eminus = 0
               this.objective.insertSymbol(errplus, constraint.getStrength());
               this.objective.insertSymbol(errminus, constraint.getStrength());
            } else {
               var dummy = new Symbol(Symbol.SymbolType.DUMMY);
               tag.marker = dummy;
               row.insertSymbolWithDefault(dummy);
            }
         }
      }

      // Ensure the row as a positive constant.
      if (row.getConstant() < 0.0) {
         row.reverseSign();
      }

      return row;
   }

   /**
    *  [Description]
    *  @param row - 
    *  @param tag - 
    *  @return Symbol
    */
   private static function chooseSubject(row :Row, tag :Tag) : Symbol
   {

      for (key in row.getCells().keys()) {
         if (key.getType() == Symbol.SymbolType.EXTERNAL) {
            return key;
         }
      }

      if (tag.marker.getType() == Symbol.SymbolType.SLACK || tag.marker.getType() == Symbol.SymbolType.ERROR) {
         if (row.coefficientFor(tag.marker) < 0.0)
            return tag.marker;
      }
      if (tag.other != null && (tag.other.getType() == Symbol.SymbolType.SLACK || tag.other.getType() == Symbol.SymbolType.ERROR)) {
         if (row.coefficientFor(tag.other) < 0.0)
            return tag.other;
      }
      return Symbol.invalidSymbol();
   }

   /**
    *  [Description]
    *  @param row - 
    *  @return Bool
    */
   private function addWithArtificialVariable(row :Row) : Bool
   {
      var art = new Symbol(Symbol.SymbolType.SLACK);
      rows.set(art, Row.fromRow(row));

      this.artificial = Row.fromRow(row);

      optimize(this.artificial);
      var success = Util.nearZero(artificial.getConstant());
      artificial = null;

      var rowptr = this.rows.get(art);

      if (rowptr != null) {

         var deleteQueue = new List<Symbol>();
         for(s in rows.keys()){
            if(rows.get(s) == rowptr){
               deleteQueue.add(s);
            }
         }
         while(!deleteQueue.isEmpty()){
            rows.remove(deleteQueue.pop());
         }
         deleteQueue.clear();

         var cellsLength = Lambda.array(rowptr.getCells()).length; //not optimal
         if (cellsLength == 0) {
            return success;
         }

         var entering = anyPivotableSymbol(rowptr);
         if (entering.getType() == Symbol.SymbolType.INVALID) {
            return false; // unsatisfiable (will this ever happen?)
         }
         rowptr.solveForSymbols(art, entering);
         substitute(entering, rowptr);
         this.rows.set(entering, rowptr);
      }

      for (value in rows.iterator()) {
         value.remove(art);
      }

      objective.remove(art);

      return success;
   }

   /**
    *  [Description]
    *  @param symbol - 
    *  @param row - 
    */
   public function substitute(symbol :Symbol, row :Row) : Void
   {
      for (key in rows.keys()) {
         rows.get(key).substitute(symbol, row);
         if (key.getType() != Symbol.SymbolType.EXTERNAL && rows.get(key).getConstant() < 0.0) {
            infeasibleRows.push(key);
         }
      }

      objective.substitute(symbol, row);

      if (artificial != null) {
         artificial.substitute(symbol, row);
      }
   }

   /**
    *  [Description]
    *  @param objective - 
    */
   public function optimize(objective :Row) : Void
   {
      while (true) {
         var entering = getEnteringSymbol(objective);
         if (entering.getType() == Symbol.SymbolType.INVALID) {
            return;
         }

         var entry = getLeavingRow(entering);
         if(entry == null){
            throw  new InternalSolverError("The objective is unbounded.");
         }
         var leaving :Symbol = null;

         for(key in rows.keys()){
            if(rows.get(key) == entry){
               leaving = key;
            }
         }

         var entryKey :Symbol = null;
         for(key in rows.keys()){
            if(rows.get(key) == entry){
               entryKey = key;
            }
         }

         rows.remove(entryKey);
         entry.solveForSymbols(leaving, entering);
         substitute(entering, entry);
         rows.set(entering, entry);
      }
   }

   /**
    *  [Description]
    */
   public function dualOptimize() : Void
   {
      while(infeasibleRows.length != 0){
         var leaving = infeasibleRows.pop();
         var row = rows.get(leaving);
         if(row != null && row.getConstant() < 0.0){
            var entering = getDualEnteringSymbol(row);
            if(entering.getType() == Symbol.SymbolType.INVALID){
               throw new InternalSolverError("internal solver error");
            }
            rows.remove(leaving);
            row.solveForSymbols(leaving, entering);
            substitute(entering, row);
            rows.set(entering, row);
         }
      }
   }

   /**
    *  [Description]
    *  @param objective - 
    *  @return Symbol
    */
   private static function getEnteringSymbol(objective :Row) : Symbol
   {
      for (key in objective.getCells().keys()) {
         if (key.getType() != Symbol.SymbolType.DUMMY && objective.getCells().get(key) < 0.0) {
            return key;
         }
      }
      return Symbol.invalidSymbol();
   }

   /**
    *  [Description]
    *  @param row - 
    *  @return Symbol
    */
   private function getDualEnteringSymbol(row :Row) :Symbol
   {
      var entering = Symbol.invalidSymbol();
      var ratio = Util.FLOAT_MAX;
      for(s in row.getCells().keys()){
         if(s.getType() != Symbol.SymbolType.DUMMY){
            var currentCell = row.getCells().get(s);
            if(currentCell > 0.0){
               var coefficient = objective.coefficientFor(s);
               var r = coefficient / currentCell;
               if(r < ratio){
                  ratio = r;
                  entering = s;
               }
            }
         }  
      }
      return entering;
   }

   /**
    *  [Description]
    *  @param row - 
    *  @return Symbol
    */
   private function anyPivotableSymbol(row :Row) : Symbol
   {
      var symbol :Symbol = null;
      for (key in row.getCells().keys()) {
         if (key.getType() == Symbol.SymbolType.SLACK || key.getType() == Symbol.SymbolType.ERROR) {
            symbol = key;
         }
      }
      if (symbol == null) {
         symbol = Symbol.invalidSymbol();
      }
      return symbol;
   }

   /**
    *  [Description]
    *  @param entering - 
    *  @return Row
    */
   private function getLeavingRow(entering :Symbol) : Row
   {
      var ratio = Util.FLOAT_MAX;
      var row :Row = null;

      for(key in rows.keys()){
         if(key.getType() != Symbol.SymbolType.EXTERNAL){
            var candidateRow = rows.get(key);
            var temp = candidateRow.coefficientFor(entering);
            if(temp < 0){
               var temp_ratio = (-candidateRow.getConstant() / temp);
               if(temp_ratio < ratio){
                  ratio = temp_ratio;
                  row = candidateRow;
               }
            }
         }
      }
      return row;
   }

   /**
    *  [Description]
    *  @param variable - 
    *  @return Symbol
    */
   private function getVarSymbol(variable :Variable) : Symbol
   {
      var symbol :Symbol = null;
      if (vars.exists(variable)) {
         symbol = vars.get(variable);
      } else {
         symbol = new Symbol(Symbol.SymbolType.EXTERNAL);
         vars.set(variable, symbol);
      }
      return symbol;
   }

    /**
     *  [Description]
     *  @param row - 
     *  @return Bool
     */
    private static function allDummies(row :Row) : Bool
    {
        for (key in row.getCells().keys()) {
            if (key.getType() != Symbol.SymbolType.DUMMY) {
                return false;
            }
        }
        return true;
    }

}

private class Tag 
{
   public var marker :Symbol;
   public var other :Symbol;

   /**
    *  [Description]
    */
   public function new() : Void
   {
      marker = Symbol.invalidSymbol();
      other = Symbol.invalidSymbol();
   }
}

private class EditInfo 
{
   public var tag :Tag;
   public var constraint :Constraint;
   public var constant :Float;

   /**
    *  [Description]
    *  @param constraint - 
    *  @param tag - 
    *  @param constant - 
    */
   public function new(constraint :Constraint, tag :Tag, constant : Float) : Void
   {
      this.constraint = constraint;
      this.tag = tag;
      this.constant = constant;
   }
}
