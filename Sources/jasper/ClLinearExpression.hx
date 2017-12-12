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

using jasper.Util;

class ClLinearExpression implements Stringable
{
	public var constant :Float;
	public var terms :Hashtable<ClAbstractVariable, Float>;

	private function new(constant :Float) : Void
	{
		this.constant = constant;
	}

	/**
	 *  [Description]
	 *  @param constant - 
	 *  @return ClLinearExpression
	 */
	public static function initializeFromConstant(constant :Float) : ClLinearExpression
	{
		var expr = new ClLinearExpression(constant);
		expr.terms = new Hashtable<ClAbstractVariable, Float>();
		return expr;
	}

	/**
	 *  [Description]
	 *  @param clv - 
	 *  @param value - 
	 *  @param constant - 
	 *  @return ClLinearExpression
	 */
	public static function initializeFromVariable(clv :ClAbstractVariable, value :Float, constant :Float) : ClLinearExpression
	{
		var expr = new ClLinearExpression(constant);
		expr.terms = new Hashtable<ClAbstractVariable, Float>();
		expr.terms.put(clv, value);
		return expr;
	}

	/**
	 *  [Description]
	 *  @param constant - 
	 *  @param terms - 
	 *  @return ClLinearExpression
	 */
	public static function initializeFromHash(constant :Float, terms :Hashtable<ClAbstractVariable, Float>) : ClLinearExpression
	{
		var expr = new ClLinearExpression(constant);
		expr.terms = terms.clone();
		return expr;
	}

	/**
	 *  [Description]
	 *  @param x - 
	 *  @return ClLinearExpression
	 */
	public function multiplyMe(x :Float) : ClLinearExpression
	{
		var that = this;
		this.constant *= x;
		this.terms.each(function(clv, coeff) {
			that.terms.put(clv, coeff * x);
		});
		return this;
	}

	/**
	 *  [Description]
	 *  @return ClLinearExpression
	 */
	public function clone() : ClLinearExpression
	{
		return ClLinearExpression.initializeFromHash(this.constant, this.terms);
	}

	/**
	 *  [Description]
	 *  @param self - 
	 *  @param constant_or_expression - 
	 *  @return Expr
	 */
	macro public function times(self:Expr, constant_or_expression :Expr) : Expr
	{
		return switch(constant_or_expression.expr) {
			case EConst(const):
				switch const {
					case CIdent(s): {
						switch Context.typeof(macro $constant_or_expression)
						{
							case TInst(a,b): 
								(a.toString() == "jasper.ClLinearExpression")
									? macro $self.__timesExpression__($constant_or_expression)
									: throw "times class err";
							case _:
								throw "times class err";
						}
					}
					case CInt(val): macro $self.__timesConstant__($constant_or_expression);
					case CFloat(val): macro $self.__timesConstant__($constant_or_expression);
					case _: throw "times class err";
				}
			case _: throw "times class err";
		}
	}

	/**
	 *  [Description]
	 *  @param self - 
	 *  @param variable_or_expression - 
	 *  @return Expr
	 */
	macro public function plus(self:Expr, variable_or_expression :Expr) : Expr
	{
		return switch Context.typeof(macro $variable_or_expression) {
			case TInst(a,b): 
				if (a.toString() == "jasper.ClLinearExpression") {
					macro $self.__plusExpression__($variable_or_expression);
				}
				else if (a.toString() == "jasper.ClVariable") {
					macro $self.__plusVariable__($variable_or_expression);
				}
				else {
					throw "plus class err";
				}
			case _:
				throw "plus class err";
		}
	}

	/**
	 *  [Description]
	 *  @param self - 
	 *  @param variable_or_expression - 
	 *  @return Expr
	 */
	macro public function minus(self:Expr, variable_or_expression :Expr) : Expr
	{
		return switch Context.typeof(macro $variable_or_expression) {
			case TInst(a,b): 
				if (a.toString() == "jasper.ClLinearExpression") {
					macro $self.__minusExpression__($variable_or_expression);
				}
				else if (a.toString() == "jasper.ClVariable") {
					macro $self.__minusVariable__($variable_or_expression);
				}
				else {
					throw "minus class err";
				}
			case _:
				throw "minus class err";
		}
	}

	/**
	 *  [Description]
	 *  @param self - 
	 *  @param float_or_expression - 
	 *  @return Expr
	 */
	macro public function divide(self:Expr, float_or_expression :Expr) : Expr
	{
		return switch(float_or_expression.expr) {
			case EConst(const):
				switch const {
					case CIdent(s): {
						switch Context.typeof(macro $float_or_expression)
						{
							case TInst(a,b): 
								(a.toString() == "jasper.ClLinearExpression")
									? macro $self.__divideExpression__($float_or_expression)
									: throw "divide class err";
							case _:
								throw "divide class err";
						}
					}
					case CInt(val): macro $self.__divideNumber__($float_or_expression);
					case CFloat(val): macro $self.__divideNumber__($float_or_expression);
					case _: throw "divide class err";
				}
			case _: throw "divide class err";
		}
	}

	/**
	 *  [Description]
	 *  @param expr - 
	 *  @return ClLinearExpression
	 */
	public function divFrom(expr :ClLinearExpression) : ClLinearExpression
	{
		if (!this.isConstant() || this.constant.approx(0.0)) {
			throw new ExCLNonlinearExpression();
		}
		return expr.__divideNumber__(this.constant);
	}

	/**
	 *  [Description]
	 *  @param expr - 
	 *  @return ClLinearExpression
	 */
	public function subtractFrom(expr :ClLinearExpression) : ClLinearExpression
	{
		return expr.__minusExpression__(this);
	}

	/**
	 *  [Description]
	 *  @param expr - 
	 *  @param n - 
	 *  @param subject - 
	 *  @param solver - 
	 *  @return ClLinearExpression
	 */
	public function addExpression(expr :ClLinearExpression, n :Float, ?subject :ClAbstractVariable, ?solver :ClTableau) : ClLinearExpression
	{
		this.incrementConstant(n * expr.constant);
		var that = this;

		expr.terms.each(function(clv, coeff) {
			that.addVariable(clv, coeff*n, subject, solver);
		});

		return this;
	}

	/**
	 *  [Description]
	 *  @param v - 
	 *  @param c - 
	 *  @param subject - 
	 *  @param solver - 
	 *  @return ClLinearExpression
	 */
	public function addVariable(v :ClAbstractVariable, c :Float, ?subject :ClAbstractVariable, ?solver :ClTableau) : ClLinearExpression
	{
		var coeff = this.terms.get(v);

		if (coeff != null) {
			var new_coefficient = coeff + c;
			if (new_coefficient.approx(0.0)) {
				if (solver != null) {
					solver.noteRemovedVariable(v, subject);
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
					solver.noteAddedVariable(v, subject);
				}
			}
		}

		return this;
	}

	/**
	 *  [Description]
	 *  @param v - 
	 *  @param c - 
	 *  @return ClLinearExpression
	 */
	public function setVariable(v :ClAbstractVariable, c :Float) : ClLinearExpression
	{
		this.terms.put(v, c);
		return this;
	}

	/**
	 *  [Description]
	 *  @return ClAbstractVariable
	 */
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

	/**
	 *  [Description]
	 *  @param outvar - 
	 *  @param expr - 
	 *  @param subject - 
	 *  @param solver - 
	 */
	public function substituteOut(outvar :ClAbstractVariable, expr :ClLinearExpression, subject :ClAbstractVariable, solver :ClTableau) : Void
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

	/**
	 *  [Description]
	 *  @param oldSubject - 
	 *  @param newSubject - 
	 */
	public function changeSubject(oldSubject :ClAbstractVariable, newSubject :ClAbstractVariable) : Void
	{
		this.terms.put(oldSubject, this.newSubject(newSubject));
	}

	/**
	 *  [Description]
	 *  @param subject - 
	 *  @return Float
	 */
	public function newSubject(subject :ClAbstractVariable) : Float
	{
		var reciprocal = 1.0 / this.terms.remove(subject);
		this.multiplyMe(-reciprocal);
		return reciprocal;
	}

	/**
	 *  [Description]
	 *  @param clv - 
	 *  @return Float
	 */
	public function coefficientFor(clv :ClAbstractVariable) : Float
	{
		var val = this.terms.get(clv);
		return (val == null)
			? 0
			: val;
	}

	/**
	 *  [Description]
	 *  @param c - 
	 */
	public inline function incrementConstant(c :Float) : Void
	{
		this.constant += c;
	}

	/**
	 *  [Description]
	 *  @return Bool
	 */
	public inline function isConstant() : Bool
	{
		return this.terms.size() == 0;
	}

	/**
	 *  [Description]
	 *  @return String
	 */
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
	
	/**
	 *  [Description]
	 *  @param e1 - 
	 *  @param e2 - 
	 *  @return ClLinearExpression
	 */
	public function Plus(e1 :ClLinearExpression, e2 :ClLinearExpression) : ClLinearExpression
	{
		return e1.__plusExpression__(e2);
	}

	/**
	 *  [Description]
	 *  @param e1 - 
	 *  @param e2 - 
	 *  @return ClLinearExpression
	 */
	public function Minus(e1 :ClLinearExpression, e2 :ClLinearExpression) : ClLinearExpression
	{
		return e1.__minusExpression__(e2);
	}

	/**
	 *  [Description]
	 *  @param e1 - 
	 *  @param e2 - 
	 *  @return ClLinearExpression
	 */
	public function Times(e1 :ClLinearExpression, e2 :ClLinearExpression) : ClLinearExpression
	{
		return e1.__timesExpression__(e2);
	}

	/**
	 *  [Description]
	 *  @param e1 - 
	 *  @param e2 - 
	 *  @return ClLinearExpression
	 */
	public function Divide(e1 :ClLinearExpression, e2 :ClLinearExpression) : ClLinearExpression
	{
		return e1.__divideExpression__(e2);
	}

	//---------------------------------------------------------------------------
	//---------------------------------------------------------------------------
	//---------------------------------------------------------------------------

	/**
	 *  [Description]
	 *  @param constant - 
	 *  @return ClLinearExpression
	 */
	public function __timesConstant__(constant :Float) : ClLinearExpression
	{
		return this.clone().multiplyMe(constant);
	}

	/**
	 *  [Description]
	 *  @param expr - 
	 *  @return ClLinearExpression
	 */
	public function __timesExpression__(expr :ClLinearExpression) : ClLinearExpression
	{
		if (this.isConstant()) {
			return expr.__timesConstant__(this.constant);
		} 
		else if (expr.isConstant()) {
			return this.__timesConstant__(expr.constant);
		} 
		else {
			throw new ExCLNonlinearExpression();
		}
	}

	/**
	 *  [Description]
	 *  @param expr - 
	 *  @return ClLinearExpression
	 */
	public function __plusExpression__(expr :ClLinearExpression) : ClLinearExpression
	{
		return this.clone().addExpression(expr, 1.0);
	}

	/**
	 *  [Description]
	 *  @param clv - 
	 *  @return ClLinearExpression
	 */
	public function __plusVariable__(clv :ClVariable) : ClLinearExpression
	{
		return this.clone().addVariable(clv, 1.0);
	}

	/**
	 *  [Description]
	 *  @param expr - 
	 *  @return ClLinearExpression
	 */
	public function __minusExpression__(expr :ClLinearExpression) : ClLinearExpression
	{
		return this.clone().addExpression(expr, -1.0);
	}

	/**
	 *  [Description]
	 *  @param clv - 
	 *  @return ClLinearExpression
	 */
	public function __minusVariable__(clv :ClVariable) : ClLinearExpression
	{
		return this.clone().addVariable(clv, -1.0);
	}

	/**
	 *  [Description]
	 *  @param x - 
	 *  @return ClLinearExpression
	 */
	public function __divideNumber__(x :Float) : ClLinearExpression
	{
		if (x.approx(0.0)) {
			throw new ExCLNonlinearExpression();
		}
		return this.__timesConstant__(1.0 / x);
	}

	/**
	 *  [Description]
	 *  @param expr - 
	 *  @return ClLinearExpression
	 */
	public function __divideExpression__(expr :ClLinearExpression) : ClLinearExpression
	{
		if (!expr.isConstant()) {
			throw new ExCLNonlinearExpression();
		}
		return this.__timesConstant__(1.0 / expr.constant);
	}
}

