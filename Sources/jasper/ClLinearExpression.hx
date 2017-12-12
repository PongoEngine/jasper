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
import jasper.Hashable;
import jasper.error.ExCLNonlinearExpression;
import jasper.error.ExCLInternalError;
import jasper.Stringable;

using jasper.Util;

class ClLinearExpression implements Stringable
{
	public var constant :Float;
	public var terms :Hashtable<ClAbstractVariable, Float>;

	private function new(constant :Float) : Void
	{
		this.constant = constant;
	}

	public static function initializeFromVariable(clv :ClAbstractVariable, value :Float, constant :Float) : ClLinearExpression
	{
		var expr = new ClLinearExpression(constant);

		expr.terms = new Hashtable<ClAbstractVariable, Float>();
		expr.terms.put(clv, value);
		return expr;
	}

	public static function initializeFromHash(constant :Float, terms :Hashtable<ClAbstractVariable, Float>) : ClLinearExpression
	{
		var expr = new ClLinearExpression(constant);

		expr.terms = terms.clone();
		return expr;
	}

	public function multiplyMe(x :Float) : ClLinearExpression
	{
		var that = this;
		this.constant *= x;
		this.terms.each(function(clv :ClAbstractVariable, coeff :Float) {
			that.terms.put(clv, coeff * x);
		});

		return this;
	}

	public function clone() : ClLinearExpression
	{
		return ClLinearExpression.initializeFromHash(this.constant, this.terms);
	}

	public function timesConstant(constant :Float) : ClLinearExpression
	{
		return (this.clone()).multiplyMe(constant);
	}

	public function timesExpression(expr :ClLinearExpression) : ClLinearExpression
	{
		if (this.isConstant()) {
			return expr.timesConstant(this.constant);
		} 
		else if (expr.isConstant()) {
			return this.timesConstant(expr.constant);
		} 
		else {
			throw new ExCLNonlinearExpression();
		}
	}

	public function plusExpression(expr :ClLinearExpression) : ClLinearExpression
	{
		return this.clone().addExpression(expr, 1.0);
	}

	public function plusVariable(clv :ClVariable) : ClLinearExpression
	{
		return this.clone().addVariable(clv, 1.0);
	}

	public function minusExpression(expr :ClLinearExpression) : ClLinearExpression
	{
		return this.clone().addExpression(expr, -1.0);
	}

	public function minusVariable(clv :ClVariable) : ClLinearExpression
	{
		return this.clone().addVariable(clv, -1.0);
	}

	public function divideNumber(x :Float) : ClLinearExpression
	{
		if (x.approx(0.0)) {
			throw new ExCLNonlinearExpression();
		}
		return this.timesConstant(1.0 / x);
	}

	public function divideExpression(expr :ClLinearExpression) : ClLinearExpression
	{
		if (!expr.isConstant()) {
			throw new ExCLNonlinearExpression();
		}
		return this.timesConstant(1.0 / expr.constant);
	}

	public function divFrom(expr :ClLinearExpression) : ClLinearExpression
	{
		if (!this.isConstant() || this.constant.approx(0.0)) {
			throw new ExCLNonlinearExpression();
		}
		return expr.divideNumber(this.constant);
	}

	public function subtractFrom(expr :ClLinearExpression) : ClLinearExpression
	{
		return expr.minusExpression(this);
	}

	public function addExpression(expr :ClLinearExpression, n :Float, ?subject, ?solver) : ClLinearExpression
	{
		this.incrementConstant(n * expr.constant);
		var that = this;

		expr.terms.each(function(clv, coeff) {
			that.addVariable(clv, coeff*n, subject, solver);
		});

		return this;
	}

	public function addVariable(v :ClAbstractVariable, c :Float, ?subject, ?solver) : ClLinearExpression
	{
		var coeff = this.terms.get(v);

		if (coeff != null) {
			var new_coefficient = coeff + c;
			if (new_coefficient.approx(0.0)) {
				if (solver != null) {
					// solver.noteRemovedVariable(v, subject);
				}
				this.terms.remove(v);
			} 
			else {
				this.terms.put(v, new_coefficient);
			}
		} 
		else {
			if (!c.approx(0.0)) {
				this.terms.put(v, c);
				if (solver != null) {
					// solver.noteAddedVariable(v, subject);
				}
			}
		}

		return this;
	}

	public function setVariable(v :ClAbstractVariable, c :Float) : ClLinearExpression
	{
		this.terms.put(v, c);
		return this;
	}

	public function anyPivotableVariable() : ClAbstractVariable
	{
		if (this.isConstant()) {
			throw new ExCLInternalError("anyPivotableVariable called on a constant");
		} 

		var val :ClAbstractVariable = null;
		this.terms.each(function(clv, c) {
			if (clv.isPivotable() && val != null) {
				val = clv;
			}
		});

		return val;
	}

	public function substituteOut(outvar :ClAbstractVariable, expr :ClLinearExpression, subject :ClAbstractVariable, solver /*ClTableau*/) : Void
	{
		var that = this;
		var multiplier = this.terms.remove(outvar);
		this.incrementConstant(multiplier * expr.constant);

		expr.terms.each(function(clv, coeff) {
			var old_coeff = that.terms.get(clv);
			if (old_coeff != null) {
				var newCoeff = old_coeff + multiplier * coeff;
				if (newCoeff.approx(0.0)) {
					solver.noteRemovedVariable(clv, subject);
					that.terms.remove(clv);
				} 
				else {
					that.terms.put(clv, newCoeff);
				}
			} 
			else {
				that.terms.put(clv, multiplier * coeff);
				solver.noteAddedVariable(clv, subject);
			}
		});
	}

	public function changeSubject(oldSubject :ClAbstractVariable, newSubject :ClAbstractVariable) : Void
	{
		this.terms.put(oldSubject, this.newSubject(newSubject));
	}

	public function newSubject(subject :ClAbstractVariable) : Float
	{
		var reciprocal = 1.0 / this.terms.remove(subject);
		this.multiplyMe(-reciprocal);
		return reciprocal;
	}

	public function coefficientFor(clv :ClAbstractVariable) : Float
	{
		var val = this.terms.get(clv);
		return (val == null)
			? 0
			: val;
	}

	public inline function incrementConstant(c :Float) : Void
	{
		this.constant += c;
	}

	public inline function isConstant() : Bool
	{
		return this.terms.size() == 0;
	}

	public function toString() : String
	{
		var bstr = ''; // answer
		var needsplus = false;

		if (!this.constant.approx(0.0) || this.isConstant()) {
			bstr += this.constant;
			if (this.isConstant()) {
				return bstr;
			} 
			else {
				needsplus = true;
			}
		} 

		this.terms.each(function(clv :ClAbstractVariable, coeff :Float) {
			if (needsplus) {
				bstr += " + ";
			}
			bstr += coeff + "*" + clv;
			needsplus = true;
		});

		return bstr;
	}
	
	public function Plus(e1 :ClLinearExpression, e2 :ClLinearExpression) : ClLinearExpression
	{
		return e1.plusExpression(e2);
	}

	public function Minus(e1 :ClLinearExpression, e2 :ClLinearExpression) : ClLinearExpression
	{
		return e1.minusExpression(e2);
	}

	public function Times(e1 :ClLinearExpression, e2 :ClLinearExpression) : ClLinearExpression
	{
		return e1.timesExpression(e2);
	}

	public function Divide(e1 :ClLinearExpression, e2 :ClLinearExpression) : ClLinearExpression
	{
		return e1.divideExpression(e2);
	}
}

