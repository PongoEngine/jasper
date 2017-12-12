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

package jasper.constraint;

import jasper.Hashable;
import jasper.ClStrength;
import jasper.error.ExCLTooDifficult;
import jasper.Stringable;
import jasper.solver.ClSimplexSolver;

class ClConstraint implements Hashable implements Stringable
{
    public var hashcode (default, null) :Int;

	public var strength :ClStrength;
	public var weight :Float;
	public var timesAdded (default, null):Int;
	public var attachedObject :Dynamic;

    public function new(strength :ClStrength, weight :Null<Float>) : Void
    {
    	this.hashcode = ClConstraint.iConstraintNumber++;

    	this.strength = strength;
    	this.weight = weight;
    	this.timesAdded = 0;
    	this.attachedObject = null;
    }

	public function isEditConstraint() : Bool
	{
		return false;
	}

	public function isInequality() : Bool
	{
		return false;
	}

	public function isRequired() : Bool
	{
		return this.strength.isRequired();
	}

	public function isStayConstraint() : Bool
	{
		return false;
	}

	public function expression_() : ClLinearExpression
	{
		throw "err";
	}

	public function changeStrength(strength :ClStrength) : Void
	{
		if (this.timesAdded == 0) {
			this.strength = strength;
		} 
		else {
			throw new ExCLTooDifficult();
		}
	}

	public function addedTo(solver :ClSimplexSolver) : Void
	{
		++this.timesAdded;
	}

	public function removedFrom(solver :ClSimplexSolver) : Void
	{
		--this.timesAdded;
	}

	public function toString() : String
	{
		return this.strength + ' {' + this.weight + '} (' + this.expression_() +')';
	}

    public static var iConstraintNumber :Int = 1;
}