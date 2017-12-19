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

package jasper.constraint.linear;

import jasper.variable.ClAbstractVariable;
import jasper.error.ExCLInternalError;

class ClLinearEquation extends ClLinearConstraint
{
	public function new(?a1 :Dynamic, ?a2 :Dynamic, ?a3 :Dynamic, ?a4 :Dynamic) : Void
	{
		if (Std.is(a1, ClLinearExpression) && (a2 == null) || Std.is(a2, ClStrength)) {
			super(a1, a2, a3);
		} 
		else if ((Std.is(a1, ClAbstractVariable)) && (Std.is(a2, ClLinearExpression))) {
			var clv = a1, cle = a2, strength = a3, weight = a4;
			super(cle, strength, weight);
			this._expression.addVariable(clv, -1);
		} 
		else if ((Std.is(a1, ClAbstractVariable)) && (Std.is(a2, Float))) {
			var clv = a1, val = a2, strength = a3, weight = a4;
			super(new ClLinearExpression(val), strength, weight);
			this._expression.addVariable(clv, -1);
		} 
		else if ((Std.is(a1, ClLinearExpression)) && (Std.is(a2, ClAbstractVariable))) {
			var cle = a1, clv = a2, strength = a3, weight = a4;
			super(cle.clone(), strength, weight);
			this._expression.addVariable(clv, -1);
		} 
		else if (((Std.is(a1, ClLinearExpression)) || (Std.is(a1, ClAbstractVariable)) ||
			(Std.is(a1, Float))) &&
			((Std.is(a2, ClLinearExpression)) || (Std.is(a2, ClAbstractVariable)) ||
			(Std.is(a2, Float)))) {

			if (Std.is(a1, ClLinearExpression)) {
				a1 = a1.clone();
			} 
			else {
				a1 = new ClLinearExpression(a1);
			}
			if (Std.is(a2, ClLinearExpression)) {
				a2 = a2.clone();
			} else {
				a2 = new ClLinearExpression(a2);
			}
			super(a1, a3, a4);
			this._expression.addExpression(a2, -1);
		} 
		else {
			throw "Bad initializer to ClLinearEquation";
		}
		
		CL.Assert(Std.is(_strength, ClStrength), "_strength not set");
	}

	override public function toString() : String
	{
		return super.toString() + " = 0 )";
	}
}