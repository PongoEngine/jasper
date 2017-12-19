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

import jasper.variable.ClAbstractVariable;
import jasper.variable.ClVariable;
import jasper.Hashtable;
import jasper.error.ExCLNonlinearExpression;
import jasper.error.ExCLInternalError;
import jasper.Stringable;
import jasper.solver.ClTableau;

import haxe.macro.Expr;
import haxe.macro.Context;

class ClLinearExpression
{
	private var _constant :Float;
	private var _terms :Hashtable<ClAbstractVariable, Float>;

	public function new(?clv :Dynamic, ?value :Dynamic, ?constant :Dynamic) {
		this._constant = (constant != null) ? constant : 0;
		this._terms = new Hashtable();
		var val = (value != null) ? value : 1;
		if (Std.is(clv, ClAbstractVariable)) {
			this._terms.put(clv, val);
		}
		else if (Std.is(clv, Float)) {
			this._constant = clv;
		}
	}

	public function initializeFromHash(constant :Float, terms :Hashtable<ClAbstractVariable, Float>) :ClLinearExpression
	{
		this._constant = constant;
		this._terms = terms.clone();
		return this;
	}

	public function multiplyMe(x :Float) :ClLinearExpression
	{
		var that = this;
		this._constant *= x;
		this._terms.each(function(clv, coeff) {
			that._terms.put(clv, coeff * x);
		});
		return this;
	}

	public function clone() :ClLinearExpression
	{
		return new ClLinearExpression().initializeFromHash(this._constant, this._terms);
	}

	public function times(x :Dynamic) :ClLinearExpression
	{
		var expr = null;
		if (Std.is(x, Float)) {
			return (this.clone()).multiplyMe(x);
		} 
		else {
			if (this.isConstant()) {
				expr = x;
				return expr.times(this._constant);
			} 
			else if (expr.isConstant()) {
				return this.times(expr._constant);
			} 
			else {
				throw new ExCLNonlinearExpression();
			}
		}
	}

	public function plus(expr :Dynamic) :ClLinearExpression
	{
		if (Std.is(expr, ClLinearExpression)) {
			return this.clone().addExpression(expr, 1.0);
		} 
		else if (Std.is(expr, ClVariable)) {
			return this.clone().addVariable(expr, 1.0);
		}
		throw "err";
	}

	public function minus(expr :Dynamic) :ClLinearExpression
	{
		if (Std.is(expr, ClLinearExpression)) {
			return this.clone().addExpression(expr, -1.0);
		} 
		else if (Std.is(expr, ClVariable)) {
			return this.clone().addVariable(expr, -1.0);
		}
		throw "err";
	}

	public function divide(x :Dynamic) :ClLinearExpression
	{
		if (Std.is(x, Float)) {
			if (CL.approx(x, 0.0)) {
				throw new ExCLNonlinearExpression();
			}
			return this.times(1.0 / x);
		} 
		else if (Std.is(x, ClLinearExpression)) {
			if (!x.isConstant) {
				throw new ExCLNonlinearExpression();
			}
			return this.times(1.0 / x._constant);
		}
		throw "err";
	}

	public function divFrom(expr :ClLinearExpression) :ClLinearExpression
	{
		if (!this.isConstant() || CL.approx(this._constant, 0.0)) {
			throw new ExCLNonlinearExpression();
		}
		return expr.divide(this._constant);
	}

	public function subtractFrom(expr :ClLinearExpression) :ClLinearExpression
	{
		return expr.minus(this);
	}

	public function addExpression(expr :Dynamic, n :Float, ?subject :ClAbstractVariable, ?solver :ClTableau) :ClLinearExpression
	{
		if (Std.is(expr, ClAbstractVariable)) {
			expr = new ClLinearExpression(expr);
		}
		this.incrementConstant(n * expr.constant());
		n = (n!=null) ? n : 1;
		var that = this;
		expr.terms().each(function(clv, coeff) {
			that.addVariable(clv, coeff*n, subject, solver);
		});
		return this;
	}

	public function addVariable(?v :Dynamic, ?c :Dynamic, ?subject, ?solver) :ClLinearExpression
	{
		c = (c != null) ? c : 1.0;
		var coeff = this._terms.get(v);
		if (coeff != null) {
			var new_coefficient = coeff + c;
			if (CL.approx(new_coefficient, 0.0)) {
				if (solver != null) {
					solver.noteRemovedVariable(v, subject);
				}
				this._terms.remove(v);
			} 
			else {
				this._terms.put(v, new_coefficient);
			}
		} 
		else {
			if (!CL.approx(c, 0.0)) {
				this._terms.put(v, c);
				if (solver != null) {
					solver.noteAddedVariable(v, subject);
				}
			}
		}
		return this;
	}

	public function setVariable(v :ClAbstractVariable, c :Float) : ClLinearExpression
	{
		this._terms.put(v, c);
		return this;
	}

	public function anyPivotableVariable() {
		if (this.isConstant()) {
		throw new ExCLInternalError("anyPivotableVariable called on a constant");
		} 

		var _clv = null;
		this._terms.each(function(clv, c) {
			if (clv.isPivotable() && _clv == null) {
				 _clv = clv;
			}
		});
		return _clv;
	}

	public function substituteOut(outvar :ClAbstractVariable, expr :ClLinearExpression, subject :ClAbstractVariable, solver :ClTableau) : Void
	{
		var that = this;
		var multiplier = this._terms.remove(outvar);
		this.incrementConstant(multiplier * expr.constant());
		expr.terms().each(function(clv, coeff) {
		var old_coeff = that._terms.get(clv);
		if (old_coeff != null) {
		var newCoeff = old_coeff + multiplier * coeff;
		if (CL.approx(newCoeff, 0.0)) {
		solver.noteRemovedVariable(clv, subject);
		that._terms.remove(clv);
		} else {
		that._terms.put(clv, newCoeff);
		}
		} else {
		that._terms.put(clv, multiplier * coeff);
		solver.noteAddedVariable(clv, subject);
		}
		});
	}

	public function changeSubject(old_subject :ClAbstractVariable, new_subject :ClAbstractVariable) : Void
	{
		this._terms.put(old_subject, this.newSubject(new_subject));
	}

	public function newSubject(subject :ClAbstractVariable) : Float
	{
		var reciprocal = 1.0 / this._terms.remove(subject);
		this.multiplyMe(-reciprocal);
		return reciprocal;
	}

	public function coefficientFor(clv :ClAbstractVariable) : Float
	{
		var val = this._terms.get(clv);
		return (val != null) ? val : 0;
	}

	public function constant() : Float
	{
		return this._constant;
	}

	public function set_constant(c :Float) : Void
	{
		this._constant = c;
	}

	public function terms() : Hashtable<ClAbstractVariable, Float>
	{
		return this._terms;
	}

	public function incrementConstant(c :Float) : Void
	{
		this._constant += c;
	}

	public function isConstant() : Bool
	{
		return this._terms.size() == 0;
	}

	public function toString() : String
	{
		var bstr = ''; // answer
		var needsplus = false;
		if (!CL.approx(this._constant, 0.0) || this.isConstant()) {
			bstr += this._constant;
			if (this.isConstant()) {
				return bstr;
			} else {
				needsplus = true;
			}
		} 
		this._terms.each( function(clv, coeff) {
			if (needsplus) {
				bstr += " + ";
			}
			bstr += coeff + "*" + clv;
			needsplus = true;
		});
		return bstr;
	}

	public static function Plus(e1 /*ClLinearExpression*/, e2 /*ClLinearExpression*/) {
		return e1.plus(e2);
	}
	public static function Minus(e1 /*ClLinearExpression*/, e2 /*ClLinearExpression*/) {
		return e1.minus(e2);
	}
	public static function Times(e1 /*ClLinearExpression*/, e2 /*ClLinearExpression*/) {
		return e1.times(e2);
	}
	public static function Divide(e1 /*ClLinearExpression*/, e2 /*ClLinearExpression*/) {
		return e1.divide(e2);
	}
}


