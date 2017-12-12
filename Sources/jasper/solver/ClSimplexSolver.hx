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

package jasper.solver;

import jasper.solver.ClTableau;

import jasper.variable.ClAbstractVariable;
import jasper.variable.ClObjectiveVariable;
import jasper.variable.ClVariable;
import jasper.ClEditInfo;
import jasper.ClLinearExpression;
import jasper.constraint.ClConstraint;
import jasper.constraint.ClEditConstraint;
import jasper.error.ExCLRequiredFailure;
import jasper.error.ExCLConstraintNotFound;
import jasper.error.ExCLInternalError;
import jasper.error.ExCLError;
import jasper.Util;
import jasper.Hashable;

class ClSimplexSolver extends ClTableau
{
	public var stayMinusErrorVars :Array<ClAbstractVariable>;
	public var stayPlusErrorVars :Array<ClAbstractVariable>;
	public var errorVars :Hashtable<Hashable,HashSet<ClAbstractVariable>>;
	public var markerVars :Hashtable<ClAbstractVariable,ClVariable>;
	public var objective :ClObjectiveVariable;
	public var editVarMap :Hashtable<ClVariable,ClEditInfo>;
	public var slackCounter :Float;
	public var artificialCounter :Float;
	public var dummyCounter :Float;
	public var resolvePair_ :Array<Float>;
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
		this.objective = new ClObjectiveVariable();
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

	public function addLowerBound(v :ClAbstractVariable, lower :Float) 
	{
		// var cn = new ClLinearInequality(v, CL.GEQ, new ClLinearExpression(lower));
		var cn = null;
		return this.addConstraint(cn);
	}

	public function addUpperBound(v :ClAbstractVariable, upper :Float) 
	{
		// var cn = new ClLinearInequality(v, CL.LEQ, new ClLinearExpression(upper));
		var cn = null;
		return this.addConstraint(cn);
	}

	public function addBounds(v :ClAbstractVariable, lower :Float, upper :Float) : ClSimplexSolver
	{
		this.addLowerBound(v, lower);
		this.addUpperBound(v, upper);
		return this;
	}

	public function addConstraint(cn :ClConstraint) : ClSimplexSolver
	{
		// if (CL.fTraceOn) CL.fnenterprint("addConstraint: " + cn);
		// var eplus_eminus = new Array(2);
		// var prevEConstant = new Array(1); // so it can be output to
		// var expr = this.newExpression(cn, /*output to*/ eplus_eminus, prevEConstant);
		// prevEConstant = prevEConstant[0];
		// var fAddedOkDirectly = false;
		// fAddedOkDirectly = this.tryAddingDirectly(expr);
		// if (!fAddedOkDirectly) {
		// this.addWithArtificialVariable(expr);
		// }
		// this._fNeedsSolving = true;
		// if (cn.isEditConstraint()) {
		// var i = this._editVarMap.size();
		// var clvEplus = /* ClSlackVariable */eplus_eminus[0];
		// var clvEminus = /* ClSlackVariable */eplus_eminus[1];
		// if (!clvEplus instanceof ClSlackVariable) {
		// print("clvEplus not a slack variable = " + clvEplus);
		// }
		// if (!clvEminus instanceof ClSlackVariable) {
		// print("clvEminus not a slack variable = " + clvEminus);
		// }
		// this._editVarMap.put(cn.variable(),
		// new ClEditInfo(cn, clvEplus, clvEminus, prevEConstant, i));
		// }
		// if (this._fOptimizeAutomatically) {
		// this.optimize(this._objective);
		// this.setExternalVariables();
		// }
		// cn.addedTo(this);
		return this;
	}

	public function addConstraintNoException(cn :ClConstraint) : Bool
	{
		try {
			this.addConstraint(cn);
			return true;
		}
		catch (e :ExCLRequiredFailure){
			return false;
		}
	}

	public function addEditVar(v :ClVariable, strength :ClStrength)
	{
		var cnEdit = new ClEditConstraint(v, strength, 1.0);
		return this.addConstraint(cnEdit);
	}

	public function removeEditVar(v :ClVariable) : ClSimplexSolver
	{
		var cei = this.editVarMap.get(v);
		var cn = cei.constraint;
		this.removeConstraint(cn);
		return this;
	}

	public function beginEdit() : ClSimplexSolver
	{
		Util.Assert(this.editVarMap.size() > 0, "_editVarMap.size() > 0");
		this.infeasibleRows.clear();
		this.resetStayConstants();
		this.stkCedcns.push(this.editVarMap.size());
		return this;
	}

	public function endEdit() : ClSimplexSolver
	{
		Util.Assert(this.editVarMap.size() > 0, "editVarMap.size() > 0");
		this.resolve();
		this.stkCedcns.pop();
		var n = this.stkCedcns[this.stkCedcns.length - 1]; // top
		this.removeEditVarsTo(n);
		return this;
	}

	public function removeAllEditVars() 
	{
		return this.removeEditVarsTo(0);
	}

	public function removeEditVarsTo(n :Int) : ClSimplexSolver
	{
		try {
			var that = this;
			this.editVarMap.each(function(v, cei) {
				if (cei.index >= n) {
					that.removeEditVar(v);
				}
			});
			Util.Assert(this.editVarMap.size() == n, "_editVarMap.size() == n");
			return this;
		}
		catch (e :ExCLConstraintNotFound){
			throw new ExCLInternalError("Constraint not found in removeEditVarsTo");
		}
	}

	public function addPointStays(listOfPoints :Array<Int>) : ClSimplexSolver
	{
		var weight = 1.0;
		var multiplier = 2.0;
		for (i in 0...listOfPoints.length) {
			// this.addPointStay(/* ClPoint */listOfPoints[i], weight);
			weight *= multiplier;
		}
		return this;
	}

	public function addPointStay(a1, a2, a3) : ClSimplexSolver
	{
		// if (a1 instanceof ClPoint) {
		// 	var clp = a1, weight = a2;
		// 	this.addStay(clp.X(), ClStrength.weak, weight || 1.0);
		// 	this.addStay(clp.Y(), ClStrength.weak, weight || 1.0);
		// } else { // 
		// 	var vx = a1, vy = a2, weight = a3;
		// 	this.addStay(vx, ClStrength.weak, weight || 1.0);
		// 	this.addStay(vy, ClStrength.weak, weight || 1.0);
		// }
		return this;
	}

	public function addStay(v :ClVariable, strength :ClStrength, weight :Float) 
	{
		// var cn = new ClStayConstraint(v, strength || ClStrength.weak, weight || 1.0);
		// return this.addConstraint(cn);
	}

	public function removeConstraint(cn :ClConstraint) : ClSimplexSolver
	{
		this.removeConstraintInternal(cn);
		cn.removedFrom(this);
		return this;
	}

	public function removeConstraintInternal(cn :ClConstraint) : ClSimplexSolver
	{
		return this;
	}

	public function reset() 
	{
		throw new ExCLInternalError("reset not implemented");
	}

	public function resolveArray(newEditConstants :Array<Float>) 
	{
		var that = this;
		this.editVarMap.each(function(v, cei) {
			var i = cei.index;
			if (i < newEditConstants.length) {
				that.suggestValue(v, newEditConstants[i]);
			}
		});
		this.resolve();
	}

	public function resolvePair(x :Float, y :Float) : Void
	{
		this.resolvePair_[0] = x;
		this.resolvePair_[1] = y;
		this.resolveArray(this.resolvePair_);
	}

	public function resolve() : Void
	{
		this.dualOptimize();
		this.setExternalVariables();
		this.infeasibleRows.clear();
		this.resetStayConstants();
	}

	public function suggestValue(v :ClVariable, x :Float) : ClSimplexSolver
	{
		var cei = this.editVarMap.get(v);
		if (cei == null) {
			throw new ExCLError();
		}
		var i = cei.index;
		var clvEditPlus = cei.clvEditPlus;
		var clvEditMinus = cei.clvEditMinus;
		var delta = x - cei.prevEditConstant;
		cei.prevEditConstant = x;
		this.deltaEditConstant(delta, clvEditPlus, clvEditMinus);

		return this;
	}

	public function setAutosolve(f :Bool) : ClSimplexSolver
	{
		this.fOptimizeAutomatically = f;
		return this;
	}

	public function fIsAutosolving() : Bool
	{
		return this.fOptimizeAutomatically;
	}

	public function solve() : ClSimplexSolver
	{
		if (this.fNeedsSolving) {
			this.optimize(this.objective);
			this.setExternalVariables();
		}
		return this;
	}

	public function setEditedValue(v :ClVariable, n :Float) : ClSimplexSolver
	{
		if (!this.fContainsVariable(v)) {
			v.value = n;
			return this;
		}
		if (!Util.approx(n, v.value)) {
			// this.addEditVar(v);
			this.beginEdit();

			try {
				this.suggestValue(v, n);
			}
			catch (e :ExCLError){
				throw new ExCLInternalError("Error in setEditedValue");
			}

			this.endEdit();
		}
		return this;
	}

	public function fContainsVariable(v :ClVariable) : Bool
	{
		return this.columnsHasKey(v) || (this.rowExpression(v) != null);
	}

	public function addVar(v :ClVariable) : ClSimplexSolver
	{
		if (!this.fContainsVariable(v)) {
			try {
				// this.addStay(v);
			}
			catch (e :ExCLRequiredFailure){
				throw new ExCLInternalError("Error in addVar -- required failure is impossible");
			}
		}
		return this;
	}

	override public function getInternalInfo() : String
	{
		var retstr = super.getInternalInfo();
		retstr += "\nSolver info:\n";
		retstr += "Stay Error Variables: ";
		retstr += this.stayPlusErrorVars.length + this.stayMinusErrorVars.length;
		retstr += " (" + this.stayPlusErrorVars.length + " +, ";
		retstr += this.stayMinusErrorVars.length + " -)\n";
		retstr += "Edit Variables: " + this.editVarMap.size();
		retstr += "\n";
		return retstr;
	}

	public function getDebugInfo() : String
	{
		var bstr = this.toString();
		bstr += this.getInternalInfo();
		bstr += "\n";
		return bstr;
	}

	override public function toString() : String
	{
		var bstr = super.toString();
		bstr += "\nstayPlusErrorVars: ";
		bstr += '[' + this.stayPlusErrorVars + ']';
		bstr += "\nstayMinusErrorVars: ";
		bstr += '[' + this.stayMinusErrorVars + ']';
		bstr += "\n";
		bstr += "editVarMap:\n" + this.editVarMap.toString();
		bstr += "\n";
		return bstr;
	}

	public function getConstraintMap() {
		return this.markerVars;
	}

	public function addWithArtificialVariable(expr :ClLinearExpression) : Void
	{
	}

	public function tryAddingDirectly(expr :ClLinearExpression) : Bool
	{
		var subject = this.chooseSubject(expr);
		if (subject == null) {
			return false;
		}
		expr.newSubject(subject);
		if (this.columnsHasKey(subject)) {
			this.substituteOut(subject, expr);
		}
		this.addRow(subject, expr);
		return true;
	}

	public function chooseSubject(expr :ClLinearExpression) 
	{
		return null;
	}

	public function deltaEditConstant(delta :Float, plusErrorVar :ClAbstractVariable, minusErrorVar :ClAbstractVariable) : Void
	{
	}

	public function dualOptimize() : Void
	{
	}

	public function newExpression(cn :ClConstraint, eplus_eminus :Array<Int>, prevEConstant :Float) 
	{
		return null;
	}

	public function optimize(zVar :ClObjectiveVariable) : Void
	{
	}

	public function pivot(entryVar :ClAbstractVariable, exitVar :ClAbstractVariable) : Void 
	{
		var pexpr = this.removeRow(exitVar);
		pexpr.changeSubject(exitVar, entryVar);
		this.substituteOut(entryVar, pexpr);
		this.addRow(entryVar, pexpr);
	}

	public function resetStayConstants() : Void 
	{
	}

	public function setExternalVariables() : Void
	{

	}

	public function insertErrorVar(cn :ClConstraint, aVar :ClAbstractVariable) : Void
	{
		var cnset = this.errorVars.get(aVar);
		if (cnset == null) 
		this.errorVars.put(cn, cnset = new HashSet());
		cnset.add(aVar);
	}
}