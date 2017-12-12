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

class ClLinearInequality extends ClLinearConstraint
{
	public function new(a1, a2, a3, a4, a5) : Void
	{
		super(null,null,null);
	}

	override public function isInequality() : Bool
	{
		return true;
	}

	override public function toString() : String 
	{
		return super.toString() + " >= 0 )";
	}
}

	


// var ClLinearInequality = new Class({
//   Extends: ClLinearConstraint,

//   initialize: function(a1, a2, a3, a4, a5) {
//     if (a1 instanceof ClLinearExpression &&
//         a3 instanceof ClAbstractVariable) {
//       var cle = a1, op = a2, clv = a3, strength = a4, weight = a5;
//       this.parent(cle.clone(), strength, weight);
//       if (op == CL.LEQ) {
//         this._expression.multiplyMe(-1);
//         this._expression.addVariable(clv);
//       } else if (op == CL.GEQ) {
//         this._expression.addVariable(clv, -1);
//       } else {
//         throw new ExCLInternalError("Invalid operator in ClLinearInequality constructor");
//       }
//     } else if (a1 instanceof ClLinearExpression) {
//       return this.parent(a1, a2, a3);
//     } else if (a2 == CL.GEQ) {
//       this.parent(new ClLinearExpression(a3), a4, a5);
//       this._expression.multiplyMe(-1.0);
//       this._expression.addVariable(a1);
//     } else if (a2 == CL.LEQ) {
//       this.parent(new ClLinearExpression(a3), a4, a5);
//       this._expression.addVariable(a1,-1.0);
//     } else {
//       throw new ExCLInternalError("Invalid operator in ClLinearInequality constructor");
//     }
//   },
