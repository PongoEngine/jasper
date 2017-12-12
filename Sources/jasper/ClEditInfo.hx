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

import jasper.constraint.ClConstraint;
import jasper.variable.ClSlackVariable;
import jasper.Stringable;

class ClEditInfo implements Stringable
{
	public var constraint (default, null):ClConstraint;
	public var clvEditPlus (default, null):ClSlackVariable;
	public var clvEditMinus (default, null):ClSlackVariable;
	public var prevEditConstant :Float;
	public var index (default, null):Int;

	/**
	 *  [Description]
	 *  @param constraint - 
	 *  @param clvEditPlus - 
	 *  @param clvEditMinus - 
	 *  @param prevEditConstant - 
	 *  @param index - 
	 */
	public function new(constraint :ClConstraint, clvEditPlus :ClSlackVariable, clvEditMinus :ClSlackVariable, prevEditConstant :Float, index :Int) : Void
	{
		this.constraint = constraint;
		this.clvEditPlus = clvEditPlus;
		this.clvEditMinus = clvEditMinus;
		this.prevEditConstant = prevEditConstant;
		this.index = index;
	}

	/**
	 *  [Description]
	 *  @return String
	 */
	public function toString() : String
	{
		return "<cn="+this.constraint+",ep="+this.clvEditPlus+",em="+this.clvEditMinus+",pec="+this.prevEditConstant+",i="+index+">";
	}
}