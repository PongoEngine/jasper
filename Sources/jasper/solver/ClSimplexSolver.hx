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
import jasper.constraint.ClStayConstraint;
import jasper.constraint.linear.ClLinearInequality;
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

	/**
	 *  [Description]
	 */
	public function new() : Void
	{
		super();
	}

	/**
	 *  [Description]
	 *  @param v - 
	 *  @param lower - 
	 */
	public function addLowerBound(v :ClAbstractVariable, lower :Float) 
	{
		var cn = new ClLinearInequality(v, CL.GEQ, ClLinearExpression.initializeFromConstant(lower));
		return this.addConstraint(cn);
	}

	/**
	 *  [Description]
	 *  @param v - 
	 *  @param upper - 
	 */
	public function addUpperBound(v :ClAbstractVariable, upper :Float) 
	{
		var cn = new ClLinearInequality(v, CL.LEQ, ClLinearExpression.initializeFromConstant(upper));
		return this.addConstraint(cn);
	}

	/**
	 *  [Description]
	 *  @param v - 
	 *  @param lower - 
	 *  @param upper - 
	 *  @return ClSimplexSolver
	 */
	public function addBounds(v :ClAbstractVariable, lower :Float, upper :Float) : ClSimplexSolver
	{
		this.addLowerBound(v, lower);
		this.addUpperBound(v, upper);
		return this;
	}

	public function addConstraint(cn :ClConstraint) : ClSimplexSolver
	{
		return this;
	}

	/**
	 *  [Description]
	 *  @param cn - 
	 *  @return Bool
	 */
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

	/**
	 *  [Description]
	 *  @param v - 
	 *  @param strength - 
	 */
	public function addEditVar(v :ClVariable, strength :ClStrength)
	{
		var cnEdit = new ClEditConstraint(v, strength, 1.0);
		return this.addConstraint(cnEdit);
	}

	/**
	 *  [Description]
	 *  @param v - 
	 *  @return ClSimplexSolver
	 */
	public function removeEditVar(v :ClVariable) : ClSimplexSolver
	{
		var cei = /* ClEditInfo */this.editVarMap.get(v);
		var cn = cei.Constraint();
		this.removeConstraint(cn);
		return this;
	}

	/**
	 *  [Description]
	 *  @return ClSimplexSolver
	 */
	public function beginEdit() : ClSimplexSolver
	{
		Util.Assert(this.editVarMap.size() > 0, "_editVarMap.size() > 0");
		this.infeasibleRows.clear();
		this.resetStayConstants();
		this.stkCedcns.push(this.editVarMap.size());
		return this;
	}

	/**
	 *  [Description]
	 *  @return ClSimplexSolver
	 */
	public function endEdit() : ClSimplexSolver
	{
		Util.Assert(this.editVarMap.size() > 0, "_editVarMap.size() > 0");
		this.resolve();
		this.stkCedcns.pop();
		var n = this.stkCedcns[this.stkCedcns.length - 1]; // top
		this.removeEditVarsTo(n);
		return this;
	}

	/**
	 *  [Description]
	 */
	public function removeAllEditVars() 
	{
		return this.removeEditVarsTo(0);
	}

	/**
	 *  [Description]
	 *  @param n - 
	 *  @return ClSimplexSolver
	 */
	public function removeEditVarsTo(n :Int) : ClSimplexSolver
	{
		try {
			var that = this;
			this.editVarMap.each(function(v, cei) {
				if (cei.Index() >= n) {
					that.removeEditVar(v);
				}
			});
			Util.Assert(this.editVarMap.size() == n, "editVarMap.size() == n");
			return this;
		}
		catch (e :ExCLConstraintNotFound){
			throw new ExCLInternalError("Constraint not found in removeEditVarsTo");
		}
	}

	/**
	 *  [Description]
	 *  @param listOfPoints - 
	 *  @return ClSimplexSolver
	 */
	public function addPointStays(listOfPoints :Array<Int>) : ClSimplexSolver
	{
		var weight = 1.0;
		var multiplier = 2.0;
		for (i in 0...listOfPoints.length) {
			this.addPointStay(listOfPoints[i], weight);
			weight *= multiplier;
		}
		return this;
	}

	public function addPointStay(a1, a2, ?a3) : ClSimplexSolver
	{
		return this;
	}

	/**
	 *  [Description]
	 *  @param v - 
	 *  @param strength - 
	 *  @param weight - 
	 */
	public function addStay(v :ClVariable, strength :ClStrength, weight :Float) 
	{
		var cn = new ClStayConstraint(v, strength, weight);
		return this.addConstraint(cn);
	}

	/**
	 *  [Description]
	 *  @param cn - 
	 *  @return ClSimplexSolver
	 */
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

	/**
	 *  [Description]
	 */
	public function reset() 
	{
    	throw new ExCLInternalError("reset not implemented");
	}

	/**
	 *  [Description]
	 *  @param newEditConstants - 
	 */
	public function resolveArray(newEditConstants :Array<Float>) 
	{
		var that = this;
		this.editVarMap.each(function(v, cei) {
			var i = cei.Index();
			if (i < newEditConstants.length) 
				that.suggestValue(v, newEditConstants[i]);
			});
		this.resolve();
	}

	/**
	 *  [Description]
	 *  @param x - 
	 *  @param y - 
	 */
	public function resolvePair(x :Float, y :Float) : Void
	{
		this.resolvePair_[0] = x;
		this.resolvePair_[1] = y;
		this.resolveArray(this.resolvePair_);
	}

	/**
	 *  [Description]
	 */
	public function resolve() : Void
	{
		this.dualOptimize();
		this.setExternalVariables();
		this.infeasibleRows.clear();
		this.resetStayConstants();
	}

	/**
	 *  [Description]
	 *  @param v - 
	 *  @param x - 
	 *  @return ClSimplexSolver
	 */
	public function suggestValue(v :ClVariable, x :Float) : ClSimplexSolver
	{
		var cei = this.editVarMap.get(v);
		if (cei == null) {
			throw new ExCLError();
		}
		var i = cei.Index();
		var clvEditPlus = cei.ClvEditPlus();
		var clvEditMinus = cei.ClvEditMinus();
		var delta = x - cei.PrevEditConstant();
		cei.SetPrevEditConstant(x);
		this.deltaEditConstant(delta, clvEditPlus, clvEditMinus);
		return this;
	}

	/**
	 *  [Description]
	 *  @param f - 
	 *  @return ClSimplexSolver
	 */
	public function setAutosolve(f :Bool) : ClSimplexSolver
	{
		this.fOptimizeAutomatically = f;
		return this;
	}

	/**
	 *  [Description]
	 *  @return Bool
	 */
	public function fIsAutosolving() : Bool
	{
		return this.fOptimizeAutomatically;
	}

	/**
	 *  [Description]
	 *  @return ClSimplexSolver
	 */
	public function solve() : ClSimplexSolver
	{
		if (this.fNeedsSolving) {
			this.optimize(this.objective);
			this.setExternalVariables();
		}
		return this;
	}

	/**
	 *  [Description]
	 *  @param v - 
	 *  @param n - 
	 *  @return ClSimplexSolver
	 */
	public function setEditedValue(v :ClVariable, n :Float) : ClSimplexSolver
	{
		return this;
	}

	/**
	 *  [Description]
	 *  @param v - 
	 *  @return Bool
	 */
	public function fContainsVariable(v :ClVariable) : Bool
	{
		return this.columnsHasKey(v) || (this.rowExpression(v) != null);
	}

	/**
	 *  [Description]
	 *  @param v - 
	 *  @return ClSimplexSolver
	 */
	public function addVar(v :ClVariable) : ClSimplexSolver
	{
		if (!this.fContainsVariable(v)) {
			try {
				this.addStay(v, ClStrength.weak, 1.0);
			}
			catch (e :ExCLRequiredFailure){
				throw new ExCLInternalError("Error in addVar -- required failure is impossible");
			}
		}
		return this;
	}

	/**
	 *  [Description]
	 *  @return String
	 */
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

	/**
	 *  [Description]
	 *  @return String
	 */
	public function getDebugInfo() : String
	{
		var bstr = this.toString();
		bstr += this.getInternalInfo();
		bstr += "\n";
		return bstr;
	}

	/**
	 *  [Description]
	 *  @return String
	 */
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

	/**
	 *  [Description]
	 */
	public function getConstraintMap() {
		return this.markerVars;
	}

	public function addWithArtificialVariable(expr :ClLinearExpression) : Void
	{
	}

	/**
	 *  [Description]
	 *  @param expr - 
	 *  @return Bool
	 */
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

	/**
	 *  [Description]
	 *  @param entryVar - 
	 *  @param exitVar - 
	 */
	public function pivot(entryVar :ClAbstractVariable, exitVar :ClAbstractVariable) : Void 
	{
		var pexpr = this.removeRow(exitVar);
		pexpr.changeSubject(exitVar, entryVar);
		this.substituteOut(entryVar, pexpr);
		this.addRow(entryVar, pexpr);
	}

	/**
	 *  [Description]
	 */
	public function resetStayConstants() : Void 
	{
		for (i in 0...stayPlusErrorVars.length) {
			var expr = this.rowExpression(/* ClAbstractVariable */this.stayPlusErrorVars[i]);
			if (expr == null) expr = this.rowExpression(/* ClAbstractVariable */this.stayMinusErrorVars[i]);
			if (expr != null) expr.constant = 0.0;
		}
	}

	/**
	 *  [Description]
	 */
	public function setExternalVariables() : Void
	{
	}

	/**
	 *  [Description]
	 *  @param cn - 
	 *  @param aVar - 
	 */
	public function insertErrorVar(cn :ClConstraint, aVar :ClAbstractVariable) : Void
	{
		var cnset = /* Set */this.errorVars.get(aVar);
		if (cnset == null) {
			this.errorVars.put(cn,cnset = new HashSet());
		}
		cnset.add(aVar);
	}
}