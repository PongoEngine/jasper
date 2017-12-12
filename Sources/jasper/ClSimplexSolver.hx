/*
 * Copyright (c) 2017 Jeremy Meltingtallow
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

// FILE: EDU.Washington.grad.gjb.cassowary
// package EDU.Washington.grad.gjb.cassowary;

package jasper;

import jasper.ClTableau;

import jasper.variable.ClAbstractVariable;
import jasper.variable.ClObjectiveVariable;
import jasper.variable.ClVariable;
import jasper.ClEditInfo;
import jasper.ClLinearExpression;

class ClSimplexSolver extends ClTableau
{

	public var stayMinusErrorVars :Array<ClAbstractVariable>;
	public var stayPlusErrorVars :Array<ClAbstractVariable>;
	public var errorVars :Hashtable<ClAbstractVariable,ClVariable>;
	public var markerVars :Hashtable<ClAbstractVariable,ClVariable>;
	public var objective :ClObjectiveVariable;
	public var editVarMap :Hashtable<ClVariable,ClEditInfo>;
	public var slackCounter :Float;
	public var artificialCounter :Float;
	public var dummyCounter :Float;
	public var resolve_pair :Array<ClAbstractVariable>;
	public var epsilon :Float;
	public var fOptimizeAutomatically :Bool;
	public var fNeedsSolving :Bool;
	public var stkCedcns :Array<Int>;

	public function new() : Void
	{
		super();
		this.stayMinusErrorVars = new Array();
		this.stayPlusErrorVars = new Array();
		this.errorVars = new Hashtable(); // cn -> Set of clv
		this.markerVars = new Hashtable(); // cn -> Set of clv
		// this.resolve_pair = new Array(0,0); 
		// this.objective = new ClObjectiveVariable("Z");
		this.editVarMap = new Hashtable(); // clv -> ClEditInfo
		this.slackCounter = 0;
		this.artificialCounter = 0;
		this.dummyCounter = 0;
		this.epsilon = 1e-8;
		this.fOptimizeAutomatically = true;
		this.fNeedsSolving = false;
		this.rows = new Hashtable<ClAbstractVariable, ClLinearExpression>(); // clv -> expression
		// this.rows.put(this.objective, new ClLinearExpression());
		this.stkCedcns = new Array(); // Stack
		this.stkCedcns.push(0);
	}

}


// var ClSimplexSolver = new Class({
//   Extends: ClTableau,
//   /* FIELDS:


//   addLowerBound: function(v /*ClAbstractVariable*/, lower /*double*/) {
//     var cn = new ClLinearInequality(v, CL.GEQ, new ClLinearExpression(lower));
//     return this.addConstraint(cn);
//   },
//   addUpperBound: function(v /*ClAbstractVariable*/, upper /*double*/) {
//     var cn = new ClLinearInequality(v, CL.LEQ, new ClLinearExpression(upper));
//     return this.addConstraint(cn);
//   },
//   addBounds: function(v /*ClAbstractVariable*/, lower /*double*/, upper /*double*/) {
//     this.addLowerBound(v, lower);
//     this.addUpperBound(v, upper);
//     return this;
//   },
//   addConstraint: function(cn /*ClConstraint*/) {
//     if (CL.fTraceOn) CL.fnenterprint("addConstraint: " + cn);
//     var eplus_eminus = new Array(2);
//     var prevEConstant = new Array(1); // so it can be output to
//     var expr = this.newExpression(cn, /*output to*/ eplus_eminus, prevEConstant);
//     prevEConstant = prevEConstant[0];
//     var fAddedOkDirectly = false;
// //    try {
//       fAddedOkDirectly = this.tryAddingDirectly(expr);
//       if (!fAddedOkDirectly) {
//         this.addWithArtificialVariable(expr);
//       }
// //    }
// //    catch (err /*ExCLRequiredFailure*/){
// //      throw err;
// //    }
//     this._fNeedsSolving = true;
//     if (cn.isEditConstraint()) {
//       var i = this._editVarMap.size();
//       var clvEplus = /* ClSlackVariable */eplus_eminus[0];
//       var clvEminus = /* ClSlackVariable */eplus_eminus[1];
//       if (!clvEplus instanceof ClSlackVariable) {
//         print("clvEplus not a slack variable = " + clvEplus);
//       }
//       if (!clvEminus instanceof ClSlackVariable) {
//         print("clvEminus not a slack variable = " + clvEminus);
//       }
//       this._editVarMap.put(cn.variable(),
//                            new ClEditInfo(cn, clvEplus, clvEminus, prevEConstant, i));
//     }
//     if (this._fOptimizeAutomatically) {
//       this.optimize(this._objective);
//       this.setExternalVariables();
//     }
//     cn.addedTo(this);
//     return this;
//   },
//   addConstraintNoException: function(cn /*ClConstraint*/) {
//     if (CL.fTraceOn) CL.fnenterprint("addConstraintNoException: " + cn);
//     try {
//       this.addConstraint(cn);
//       return true;
//     }
//     catch (e /*ExCLRequiredFailure*/){
//       return false;
//     }
//   },
//   addEditVar: function(v /*ClVariable*/, strength /*ClStrength*/) {
//     if (CL.fTraceOn) CL.fnenterprint("addEditVar: " + v + " @ " + strength);
//     strength = strength || ClStrength.strong;
// //    try {
//       var cnEdit = new ClEditConstraint(v, strength);
//       return this.addConstraint(cnEdit);
// //    }
// //    catch (e /*ExCLRequiredFailure*/){
// //      throw new ExCLInternalError("Required failure when adding an edit variable");
// //    }
//   },
//   removeEditVar: function(v /*ClVariable*/) {
//     var cei = /* ClEditInfo */this._editVarMap.get(v);
//     var cn = cei.Constraint();
//     this.removeConstraint(cn);
//     return this;
//   },
//   beginEdit: function() {
//     CL.Assert(this._editVarMap.size() > 0, "_editVarMap.size() > 0");
//     this._infeasibleRows.clear();
//     this.resetStayConstants();
//     this._stkCedcns.push(this._editVarMap.size());
//     return this;
//   },
//   endEdit: function() {
//     CL.Assert(this._editVarMap.size() > 0, "_editVarMap.size() > 0");
//     this.resolve();
//     this._stkCedcns.pop();
//     var n = this._stkCedcns[this._stkCedcns.length - 1]; // top
//     this.removeEditVarsTo(n);
//     return this;
//   },
//   removeAllEditVars: function() {
//     return this.removeEditVarsTo(0);
//   },
//   removeEditVarsTo: function(n /*int*/) {
//     try {
//       var that = this;
//       this._editVarMap.each(function(v, cei) {
//         if (cei.Index() >= n) {
//           that.removeEditVar(v);
//         }
//       });
//       CL.Assert(this._editVarMap.size() == n, "_editVarMap.size() == n");
//       return this;
//     }
//     catch (e /*ExCLConstraintNotFound*/){
//       throw new ExCLInternalError("Constraint not found in removeEditVarsTo");
//     }
//   },
//   addPointStays: function(listOfPoints /*Vector*/) {
//     if (CL.fTraceOn) CL.fnenterprint("addPointStays" + listOfPoints);
//     var weight = 1.0;
//     var multiplier = 2.0;
//     for (var i = 0; i < listOfPoints.length; i++)
//     {
//       this.addPointStay(/* ClPoint */listOfPoints[i], weight);
//       weight *= multiplier;
//     }
//     return this;
//   },
//   addPointStay: function(a1, a2, a3) {
//     if (a1 instanceof ClPoint) {
//       var clp = a1, weight = a2;
//       this.addStay(clp.X(), ClStrength.weak, weight || 1.0);
//       this.addStay(clp.Y(), ClStrength.weak, weight || 1.0);
//     } else { // 
//       var vx = a1, vy = a2, weight = a3;
//       this.addStay(vx, ClStrength.weak, weight || 1.0);
//       this.addStay(vy, ClStrength.weak, weight || 1.0);
//     }
//     return this;
//   },
//   addStay: function(v /*ClVariable*/, strength /*ClStrength*/, weight /*double*/) {
//     var cn = new ClStayConstraint(v, strength || ClStrength.weak, weight || 1.0);
//     return this.addConstraint(cn);
//   },
//   removeConstraint: function(cn /*ClConstraint*/) {
//     this.removeConstraintInternal(cn);
//     cn.removedFrom(this);
//     return this;
//   },
//   removeConstraintInternal: function(cn /*ClConstraint*/) {
//     var that = this;
//     if (CL.fTraceOn) CL.fnenterprint("removeConstraint: " + cn);
//     if (CL.fTraceOn) CL.traceprint(this.toString());
//     this._fNeedsSolving = true;
//     this.resetStayConstants();
//     var zRow = this.rowExpression(this._objective);
//     var eVars = /* Set */this._errorVars.get(cn);
//     if (CL.fTraceOn) CL.traceprint("eVars == " + CL.setToString(eVars));
//     if (eVars != null) {
//       eVars.each(function(clv) {
//         var expr = that.rowExpression(clv);
//         if (expr == null) {
//           zRow.addVariable(clv, -cn.weight() * cn.strength().symbolicWeight().toDouble(), that._objective, that);
//         } else {
//           zRow.addExpression(expr, -cn.weight() * cn.strength().symbolicWeight().toDouble(), that._objective, that);
//         }
//         if (CL.fTraceOn) CL.traceprint("now eVars == " + CL.setToString(eVars));
//       });
//     }
//     var marker = this._markerVars.remove(cn);
//     if (marker == null) {
//       throw new ExCLConstraintNotFound();
//     }
//     if (CL.fTraceOn) CL.traceprint("Looking to remove var " + marker);
//     if (this.rowExpression(marker) == null) {
//       var col = this._columns.get(marker);
//       if (CL.fTraceOn) CL.traceprint("Must pivot -- columns are " + col);
//       var exitVar = null;
//       var minRatio = 0.0;
//       col.each(function(v) {
//         if (v.isRestricted()) {
//           var expr = that.rowExpression(v);
//           var coeff = expr.coefficientFor(marker);
//           if (that.fTraceOn) that.traceprint("Marker " + marker + "'s coefficient in " + expr + " is " + coeff);
//           if (coeff < 0.0) {
//             var r = -expr.constant() / coeff;
//             if (exitVar == null || r < minRatio || (CL.approx(r, minRatio) && v.hashCode() < exitVar.hashCode())) {
//               minRatio = r;
//               exitVar = v;
//             }
//           }
//         }
//       });
//       if (exitVar == null) {
//         if (CL.fTraceOn) CL.traceprint("exitVar is still null");
//         col.each(function(v) {
//           if (v.isRestricted()) {
//             var expr = that.rowExpression(v);
//             var coeff = expr.coefficientFor(marker);
//             var r = expr.constant() / coeff;
//             if (exitVar == null || r < minRatio) {
//               minRatio = r;
//               exitVar = v;
//             }
//           }
//         });
//       }
//       if (exitVar == null) {
//         if (col.size() == 0) {
//           this.removeColumn(marker);
//         }
//         else {
//           col.escapingEach(function(v) {
//             if (v != that._objective) {
//               exitVar = v;
//               return {brk:true};
//             }
//           });
//         }
//       }
//       if (exitVar != null) {
//         this.pivot(marker, exitVar);
//       }
//     }
//     if (this.rowExpression(marker) != null) {
//       var expr = this.removeRow(marker);
//       expr = null;
//     }
//     if (eVars != null) {
//       eVars.each(function(v) {
//         if (v != marker) {
//           that.removeColumn(v);
//           v = null;
//         }
//       });
//     }
//     if (cn.isStayConstraint()) {
//       if (eVars != null) {
//         for (var i = 0; i < this._stayPlusErrorVars.length; i++)
//         {
//           eVars.remove(this._stayPlusErrorVars[i]);
//           eVars.remove(this._stayMinusErrorVars[i]);
//         }
//       }
//     }
//     else if (cn.isEditConstraint()) {
//       CL.Assert(eVars != null, "eVars != null");
//       var cnEdit = /* ClEditConstraint */cn;
//       var clv = cnEdit.variable();
//       var cei = this._editVarMap.get(clv);
//       var clvEditMinus = cei.ClvEditMinus();
//       this.removeColumn(clvEditMinus);
//       this._editVarMap.remove(clv);
//     }
//     if (eVars != null) {
//       this._errorVars.remove(eVars);
//     }
//     marker = null;
//     if (this._fOptimizeAutomatically) {
//       this.optimize(this._objective);
//       this.setExternalVariables();
//     }
//     return this;
//   },
//   reset: function() {
//     if (CL.fTraceOn) CL.fnenterprint("reset");
//     throw new ExCLInternalError("reset not implemented");
//   },
//   resolveArray: function(newEditConstants /*Vector*/) {
//     if (CL.fTraceOn) CL.fnenterprint("resolveArray" + newEditConstants);
//     var that = this;
//     this._editVarMap.each(function(v, cei) {
//       var i = cei.Index();
// //      try {
//         if (i < newEditConstants.length) 
//           that.suggestValue(v, newEditConstants[i]);
// //      }
// //      catch (err /*ExCLError*/){
// //        throw new ExCLInternalError("Error during resolve");
// //      }
//     });
//     this.resolve();
//   },
//   resolvePair: function(x /*double*/, y /*double*/) {
//     this._resolve_pair[0] = x;
//     this._resolve_pair[1] = y;
//     this.resolveArray(this._resolve_pair);
//   },

//   resolve: function() {
//     if (CL.fTraceOn) CL.fnenterprint("resolve()");
//     this.dualOptimize();
//     this.setExternalVariables();
//     this._infeasibleRows.clear();
//     this.resetStayConstants();
//   },

//   suggestValue: function(v /*ClVariable*/, x /*double*/) {
//     if (CL.fTraceOn) CL.fnenterprint("suggestValue(" + v + ", " + x + ")");
//     var cei = this._editVarMap.get(v);
//     if (cei == null) {
//       print("suggestValue for variable " + v + ", but var is not an edit variable\n");
//       throw new ExCLError();
//     }
//     var i = cei.Index();
//     var clvEditPlus = cei.ClvEditPlus();
//     var clvEditMinus = cei.ClvEditMinus();
//     var delta = x - cei.PrevEditConstant();
//     cei.SetPrevEditConstant(x);
//     this.deltaEditConstant(delta, clvEditPlus, clvEditMinus);
//     return this;
//   },
//   setAutosolve: function(f /*boolean*/) {
//     this._fOptimizeAutomatically = f;
//     return this;
//   },
//   FIsAutosolving: function() {
//     return this._fOptimizeAutomatically;
//   },
//   solve: function() {
//     if (this._fNeedsSolving) {
//       this.optimize(this._objective);
//       this.setExternalVariables();
//     }
//     return this;
//   },
//   setEditedValue: function(v /*ClVariable*/, n /*double*/) {
//     if (!this.FContainsVariable(v)) {
//       v.change_value(n);
//       return this;
//     }
//     if (!CL.approx(n, v.value())) {
//       this.addEditVar(v);
//       this.beginEdit();
//       try {
//         this.suggestValue(v, n);
//       }
//       catch (e /*ExCLError*/){
//         throw new ExCLInternalError("Error in setEditedValue");
//       }
//       this.endEdit();
//     }
//     return this;
//   },
//   FContainsVariable: function(v /*ClVariable*/) {
//     return this.columnsHasKey(v) || (this.rowExpression(v) != null);
//   },
//   addVar: function(v /*ClVariable*/) {
//     if (!this.FContainsVariable(v)) {
//       try {
//         this.addStay(v);
//       }
//       catch (e /*ExCLRequiredFailure*/){
//         throw new ExCLInternalError("Error in addVar -- required failure is impossible");
//       }
//       if (CL.fTraceOn) {
//         CL.traceprint("added initial stay on " + v);
//       }
//     }
//     return this;
//   },
//   getInternalInfo: function() {
//     var retstr = this.parent();
//     retstr += "\nSolver info:\n";
//     retstr += "Stay Error Variables: ";
//     retstr += this._stayPlusErrorVars.length + this._stayMinusErrorVars.length;
//     retstr += " (" + this._stayPlusErrorVars.length + " +, ";
//     retstr += this._stayMinusErrorVars.length + " -)\n";
//     retstr += "Edit Variables: " + this._editVarMap.size();
//     retstr += "\n";
//     return retstr;
//   },
//   getDebugInfo: function() {
//     var bstr = this.toString();
//     bstr += this.getInternalInfo();
//     bstr += "\n";
//     return bstr;
//   },
//   toString: function() {
//     var bstr = this.parent();
//     bstr += "\n_stayPlusErrorVars: ";
//     bstr += '[' + this._stayPlusErrorVars + ']';
//     bstr += "\n_stayMinusErrorVars: ";
//     bstr += '[' + this._stayMinusErrorVars + ']';
//     bstr += "\n";
//     bstr += "_editVarMap:\n" + CL.hashToString(this._editVarMap);
//     bstr += "\n";
//     return bstr;
//   },
//   getConstraintMap: function() {
//     return this._markerVars;
//   },
//   addWithArtificialVariable: function(expr /*ClLinearExpression*/) {
//     if (CL.fTraceOn) CL.fnenterprint("addWithArtificialVariable: " + expr);
//     var av = new ClSlackVariable(++this._artificialCounter, "a");
//     var az = new ClObjectiveVariable("az");
//     var azRow = /* ClLinearExpression */expr.clone();
//     if (CL.fTraceOn) CL.traceprint("before addRows:\n" + this);
//     this.addRow(az, azRow);
//     this.addRow(av, expr);
//     if (CL.fTraceOn) CL.traceprint("after addRows:\n" + this);
//     this.optimize(az);
//     var azTableauRow = this.rowExpression(az);
//     if (CL.fTraceOn) CL.traceprint("azTableauRow.constant() == " + azTableauRow.constant());
//     if (!CL.approx(azTableauRow.constant(), 0.0)) {
//       this.removeRow(az);
//       this.removeColumn(av);
//       throw new ExCLRequiredFailure();
//     }
//     var e = this.rowExpression(av);
//     if (e != null) {
//       if (e.isConstant()) {
//         this.removeRow(av);
//         this.removeRow(az);
//         return;
//       }
//       var entryVar = e.anyPivotableVariable();
//       this.pivot(entryVar, av);
//     }
//     CL.Assert(this.rowExpression(av) == null, "rowExpression(av) == null");
//     this.removeColumn(av);
//     this.removeRow(az);
//   },
//   tryAddingDirectly: function(expr /*ClLinearExpression*/) {
//     if (CL.fTraceOn) CL.fnenterprint("tryAddingDirectly: " + expr);
//     var subject = this.chooseSubject(expr);
//     if (subject == null) {
//       if (CL.fTraceOn) CL.fnexitprint("returning false");
//       return false;
//     }
//     expr.newSubject(subject);
//     if (this.columnsHasKey(subject)) {
//       this.substituteOut(subject, expr);
//     }
//     this.addRow(subject, expr);
//     if (CL.fTraceOn) CL.fnexitprint("returning true");
//     return true;
//   },
//   chooseSubject: function(expr /*ClLinearExpression*/) {
//     var that=this;
//     if (CL.fTraceOn) CL.fnenterprint("chooseSubject: " + expr);
//     var subject = null;
//     var foundUnrestricted = false;
//     var foundNewRestricted = false;
//     var terms = expr.terms();
//     var rv = terms.escapingEach(function(v, c) {
//       if (foundUnrestricted) {
//         if (!v.isRestricted()) {
//           if (!that.columnsHasKey(v)) {
//             return {retval: v};
//           }
//         }
//       } else {
//         if (v.isRestricted()) {
//           if (!foundNewRestricted && !v.isDummy() && c < 0.0) {
//             var col = that._columns.get(v);
//             if (col == null || (col.size() == 1 && that.columnsHasKey(that._objective))) {
//               subject = v;
//               foundNewRestricted = true;
//             }
//           }
//         } else {
//           subject = v;
//           foundUnrestricted = true;
//         }
//       }
//     });
//     if (rv && rv.retval !== undefined) return rv.retval;

//     if (subject != null) 
//       return subject;

//     var coeff = 0.0;

//   // subject is nil. 
//   // Make one last check -- if all of the variables in expr are dummy
//   // variables, then we can pick a dummy variable as the subject
//     var rv = terms.escapingEach(function(v,c) {
//       if (!v.isDummy())  {
//         return {retval:null};
//       }
//       if (!that.columnsHasKey(v)) {
//         subject = v;
//         coeff = c;
//       }
//     });
//     if (rv && rv.retval !== undefined) return rv.retval;

//     if (!CL.approx(expr.constant(), 0.0)) {
//       throw new ExCLRequiredFailure();
//     }
//     if (coeff > 0.0) {
//       expr.multiplyMe(-1);
//     }
//     return subject;
//   },

//   deltaEditConstant: function(delta /*double*/, plusErrorVar /*ClAbstractVariable*/, minusErrorVar /*ClAbstractVariable*/) {
//     var that = this;
//     if (CL.fTraceOn) CL.fnenterprint("deltaEditConstant :" + delta + ", " + plusErrorVar + ", " + minusErrorVar);
//     var exprPlus = this.rowExpression(plusErrorVar);
//     if (exprPlus != null) {
//       exprPlus.incrementConstant(delta);
//       if (exprPlus.constant() < 0.0) {
//         this._infeasibleRows.add(plusErrorVar);
//       }
//       return;
//     }
//     var exprMinus = this.rowExpression(minusErrorVar);
//     if (exprMinus != null) {
//       exprMinus.incrementConstant(-delta);
//       if (exprMinus.constant() < 0.0) {
//         this._infeasibleRows.add(minusErrorVar);
//       }
//       return;
//     }
//     var columnVars = this._columns.get(minusErrorVar);
//     if (!columnVars) {
//       print("columnVars is null -- tableau is:\n" + this);
//     }
//     columnVars.each(function(basicVar) {
//       var expr = that.rowExpression(basicVar);
//       var c = expr.coefficientFor(minusErrorVar);
//       expr.incrementConstant(c * delta);
//       if (basicVar.isRestricted() && expr.constant() < 0.0) {
//         that._infeasibleRows.add(basicVar);
//       }
//     });
//   },

//   dualOptimize: function() {
//     if (CL.fTraceOn) CL.fnenterprint("dualOptimize:");
//     var zRow = this.rowExpression(this._objective);
//     while (!this._infeasibleRows.isEmpty()) {
//       var exitVar = this._infeasibleRows.values()[0];
//       this._infeasibleRows.remove(exitVar);
//       var entryVar = null;
//       var expr = this.rowExpression(exitVar);
//       if (expr != null) {
//         if (expr.constant() < 0.0) {
//           var ratio = Number.MAX_VALUE;
//           var r;
//           var terms = expr.terms();
//           terms.each(function(v, c) {
//             if (c > 0.0 && v.isPivotable()) {
//               var zc = zRow.coefficientFor(v);
//               r = zc / c;
//               if (r < ratio || (CL.approx(r, ratio) && v.hashCode() < entryVar.hashCode())) {
//                 entryVar = v;
//                 ratio = r;
//               }
//             }
//           });
//           if (ratio == Number.MAX_VALUE) {
//             throw new ExCLInternalError("ratio == nil (MAX_VALUE) in dualOptimize");
//           }
//           this.pivot(entryVar, exitVar);
//         }
//       }
//     }
//   },
//   newExpression: function(cn /*ClConstraint*/, /** outputs to **/ 
//                           eplus_eminus /*Vector*/, prevEConstant /*ClDouble*/) {
//     var that = this;
//     if (CL.fTraceOn) CL.fnenterprint("newExpression: " + cn);
//     if (CL.fTraceOn) CL.traceprint("cn.isInequality() == " + cn.isInequality());
//     if (CL.fTraceOn) CL.traceprint("cn.isRequired() == " + cn.isRequired());
//     var cnExpr = cn.expression();
//     var expr = new ClLinearExpression(cnExpr.constant());
//     var slackVar = new ClSlackVariable();
//     var dummyVar = new ClDummyVariable();
//     var eminus = new ClSlackVariable();
//     var eplus = new ClSlackVariable();
//     var cnTerms = cnExpr.terms();
//     cnTerms.each(function(v,c) {
//       var e = that.rowExpression(v);
//       if (e == null) expr.addVariable(v, c);
//       else expr.addExpression(e, c);
//     });
//     if (cn.isInequality()) {
//       ++this._slackCounter;
//       slackVar = new ClSlackVariable(this._slackCounter, "s");
//       expr.setVariable(slackVar, -1);
//       this._markerVars.put(cn, slackVar);
//       if (!cn.isRequired()) {
//         ++this._slackCounter;
//         eminus = new ClSlackVariable(this._slackCounter, "em");
//         expr.setVariable(eminus, 1.0);
//         var zRow = this.rowExpression(this._objective);
//         var sw = cn.strength().symbolicWeight().times(cn.weight());
//         zRow.setVariable(eminus, sw.toDouble());
//         this.insertErrorVar(cn, eminus);
//         this.noteAddedVariable(eminus, this._objective);
//       }
//     } else {
//       if (cn.isRequired()) {
//         ++this._dummyCounter;
//         dummyVar = new ClDummyVariable(this._dummyCounter, "d");
//         expr.setVariable(dummyVar, 1.0);
//         this._markerVars.put(cn, dummyVar);
//         if (CL.fTraceOn) CL.traceprint("Adding dummyVar == d" + this._dummyCounter);
//       } else {
//         ++this._slackCounter;
//         eplus = new ClSlackVariable(this._slackCounter, "ep");
//         eminus = new ClSlackVariable(this._slackCounter, "em");
//         expr.setVariable(eplus, -1.0);
//         expr.setVariable(eminus, 1.0);
//         this._markerVars.put(cn, eplus);
//         var zRow = this.rowExpression(this._objective);
//         var sw = cn.strength().symbolicWeight().times(cn.weight());
//         var swCoeff = sw.toDouble();
//         if (swCoeff == 0) {
//           if (CL.fTraceOn) CL.traceprint("sw == " + sw);
//           if (CL.fTraceOn) CL.traceprint("cn == " + cn);
//           if (CL.fTraceOn) CL.traceprint("adding " + eplus + " and " + eminus + " with swCoeff == " + swCoeff);
//         }
//         zRow.setVariable(eplus, swCoeff);
//         this.noteAddedVariable(eplus, this._objective);
//         zRow.setVariable(eminus, swCoeff);
//         this.noteAddedVariable(eminus, this._objective);
//         this.insertErrorVar(cn, eminus);
//         this.insertErrorVar(cn, eplus);
//         if (cn.isStayConstraint()) {
//           this._stayPlusErrorVars.push(eplus);
//           this._stayMinusErrorVars.push(eminus);
//         } else if (cn.isEditConstraint()) {
//           eplus_eminus[0] = eplus;
//           eplus_eminus[1] = eminus;
//           prevEConstant[0] = cnExpr.constant();
//         }
//       }
//     }
//     if (expr.constant() < 0) expr.multiplyMe(-1);
//     if (CL.fTraceOn) CL.fnexitprint("returning " + expr);
//     return expr;
//   },
//   optimize: function(zVar /*ClObjectiveVariable*/) {
//     var that=this;
//     if (CL.fTraceOn) CL.fnenterprint("optimize: " + zVar);
//     if (CL.fTraceOn) CL.traceprint(this.toString());
//     var zRow = this.rowExpression(zVar);
//     CL.Assert(zRow != null, "zRow != null");
//     var entryVar = null;
//     var exitVar = null;
//     while  (true) {
//       var objectiveCoeff = 0;
//       var terms = zRow.terms();
//       terms.escapingEach(function(v, c) {
// //        if (v.isPivotable() && c < 0.0 && (entryVar == null || v.hashCode() < entryVar.hashCode())) {
//         if (v.isPivotable() && c < objectiveCoeff) {
//           objectiveCoeff = c;
//           entryVar = v;
//           return {brk:true};
//         }
//       });
//       if (objectiveCoeff >= -this._epsilon) 
//         return;
//       if (CL.fTraceOn) {
//         CL.traceprint("entryVar == " + entryVar + ", objectiveCoeff == " + objectiveCoeff);
//       }
//       var minRatio = Number.MAX_VALUE;
//       var columnVars = this._columns.get(entryVar);
//       var r = 0.0;
//       columnVars.each(function(v) {
//         if (that.fTraceOn) that.traceprint("Checking " + v);
//         if (v.isPivotable()) {
//           var expr = that.rowExpression(v);
//           var coeff = expr.coefficientFor(entryVar);
//           if (that.fTraceOn) that.traceprint("pivotable, coeff = " + coeff);
//           if (coeff < 0.0) {
//             r = -expr.constant() / coeff;
//             if (r < minRatio || (CL.approx(r, minRatio) && v.hashCode() < exitVar.hashCode())) {
//               minRatio = r;
//               exitVar = v;
//             }
//           }
//         }
//       });
//       if (minRatio == Number.MAX_VALUE) {
//         throw new ExCLInternalError("Objective function is unbounded in optimize");
//       }
//       this.pivot(entryVar, exitVar);
//       if (CL.fTraceOn) CL.traceprint(this.toString());
//     }
//   },
//   pivot: function(entryVar /*ClAbstractVariable*/, exitVar /*ClAbstractVariable*/) {
//     if (CL.fTraceOn) CL.fnenterprint("pivot: " + entryVar + ", " + exitVar);
//     if (entryVar == null) {
//       console.log.warning("pivot: entryVar == null");
//     }
//     if (exitVar == null) {
//       console.log.warning("pivot: exitVar == null");
//     }
//     var pexpr = this.removeRow(exitVar);
//     pexpr.changeSubject(exitVar, entryVar);
//     this.substituteOut(entryVar, pexpr);
//     this.addRow(entryVar, pexpr);
//   },
//   resetStayConstants: function() {
//     if (CL.fTraceOn) CL.fnenterprint("resetStayConstants");
//     for (var i = 0; i < this._stayPlusErrorVars.length; i++)
//     {
//       var expr = this.rowExpression(/* ClAbstractVariable */this._stayPlusErrorVars[i]);
//       if (expr == null) expr = this.rowExpression(/* ClAbstractVariable */this._stayMinusErrorVars[i]);
//       if (expr != null) expr.set_constant(0.0);
//     }
//   },
//   setExternalVariables: function() {
//     var that=this;
//     if (CL.fTraceOn) CL.fnenterprint("setExternalVariables:");
//     if (CL.fTraceOn) CL.traceprint(this.toString());
//     this._externalParametricVars.each(function(v) {
//       if (that.rowExpression(v) != null) {
//         print("Error: variable" + v + " in _externalParametricVars is basic");
//       } else {
//         v.change_value(0.0);
//       }
//     });
//     this._externalRows.each(function(v) {
//       var expr = that.rowExpression(v);
//       if (CL.fTraceOn) CL.debugprint("v == " + v);
//       if (CL.fTraceOn) CL.debugprint("expr == " + expr);
//       v.change_value(expr.constant());
//     });
//     this._fNeedsSolving = false;
//   },
//   insertErrorVar: function(cn /*ClConstraint*/, aVar /*ClAbstractVariable*/) {
//     if (CL.fTraceOn) CL.fnenterprint("insertErrorVar:" + cn + ", " + aVar);
//     var cnset = /* Set */this._errorVars.get(aVar);
//     if (cnset == null) 
//       this._errorVars.put(cn,cnset = new HashSet());
//     cnset.add(aVar);
//   },
// });
