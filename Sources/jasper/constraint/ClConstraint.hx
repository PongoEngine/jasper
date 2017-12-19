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
    public var hash_code (default, null) :Int;

	private var _strength :ClStrength;
	private var _weight :Float;
	private var _attachedObject :Dynamic;
	private var _times_added :Int;


	public function new(strength :ClStrength, weight :Float) : Void
	{
		this.hash_code = ClConstraint.iConstraintNumber++;
		this._strength = (strength != null) ? strength : ClStrength.required;
		this._weight = (weight != null) ? weight : 1.0;
		this._times_added = 0;
	}

	public function hashCode() : Int
	{
		return this.hash_code;
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
		return this._strength.isRequired();
	}

	public function isStayConstraint() : Bool
	{
		return false;
	}

	public function strength() : ClStrength
	{
		return this._strength;
	}

	public function weight() : Float
	{
		return this._weight;
	}

	public function toString() : String
	{
		// this is abstract -- it intentionally leaves the parens unbalanced for
		// the subclasses to complete (e.g., with ' = 0', etc.
		return this._strength + ' {' + this._weight + '} (' + this.expression() +')';
	}

	public function expression() : ClLinearExpression {throw "expression() called ClConstraint";}

	public function setAttachedObject(o :Dynamic) : Void
	{
		this._attachedObject = o;
	}

	public function getAttachedObject() : Dynamic
	{
		return this._attachedObject;
	}

	public function changeStrength(strength :ClStrength) : Void
	{
		if (this._times_added == 0) {
			this.setStrength(strength);
		} else {
			throw new ExCLTooDifficult();
		}
	}

	public function addedTo(solver :ClSimplexSolver) : Void
	{
		++this._times_added;
	}

	public function removedFrom(solver :ClSimplexSolver) : Void
	{
		--this._times_added;
	}

	public function setStrength(strength :ClStrength) : Void
	{
		this._strength = strength;
	}

	public function setWeight(weight :Float) : Void
	{
		this._weight = weight;
	}

	public static var iConstraintNumber : Int = 1;
}