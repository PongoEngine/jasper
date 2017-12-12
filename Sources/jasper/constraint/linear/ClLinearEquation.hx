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

class ClLinearEquation extends ClLinearConstraint
{
	public function new(a1, a2, a3, a4) : Void
	{
		super(null,null,null);

		//     if (a1 instanceof ClLinearExpression && !a2 || a2 instanceof ClStrength) {
//       this.parent(a1, a2, a3);
//     } else if ((a1 instanceof ClAbstractVariable) &&
//                (a2 instanceof ClLinearExpression)) {
//       var clv = a1, cle = a2, strength = a3, weight = a4;
//       this.parent(cle, strength, weight);
//       this._expression.addVariable(clv, -1);
//     } else if ((a1 instanceof ClAbstractVariable) &&
//                (typeof(a2) == 'number')) {
//       var clv = a1, val = a2, strength = a3, weight = a4;
//       this.parent(new ClLinearExpression(val), strength, weight);
//       this._expression.addVariable(clv, -1);
//     } else if ((a1 instanceof ClLinearExpression) &&
//                (a2 instanceof ClAbstractVariable)) {
//       var cle = a1, clv = a2, strength = a3, weight = a4;
//       this.parent(cle.clone(), strength, weight);
//       this._expression.addVariable(clv, -1);
//     } else if (((a1 instanceof ClLinearExpression) || (a1 instanceof ClAbstractVariable) ||
//                 (typeof(a1) == 'number')) &&
//                ((a2 instanceof ClLinearExpression) || (a2 instanceof ClAbstractVariable) ||
//                 (typeof(a2) == 'number'))) {
//       if (a1 instanceof ClLinearExpression) {
//         a1 = a1.clone();
//       } else {
//         a1 = new ClLinearExpression(a1);
//       }
//       if (a2 instanceof ClLinearExpression) {
//         a2 = a2.clone();
//       } else {
//         a2 = new ClLinearExpression(a2);
//       }
//       this.parent(a1, a3, a4);
//       this._expression.addExpression(a2, -1);
//     } else {
//       throw "Bad initializer to ClLinearEquation";
//     }
//     CL.Assert(this._strength instanceof ClStrength, "_strength not set");


	}

	override public function toString() : String 
	{
		return super.toString() + " = 0 )";
	}
}