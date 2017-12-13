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

package jasper.variable;

class ClVariable extends ClAbstractVariable
{
	public var value_ :Float;
	public var attachedObject :Dynamic;

	/**
	 *  [Description]
	 *  @param value - 
	 */
	public function new(value :Dynamic, ?a :Dynamic) : Void
	{
		super();
		this.value_ = value;
	}

	public function value() : Dynamic
	{
		return null;
	}

	public function set_value(x :Dynamic) : Void
	{}

	/**
	 *  [Description]
	 *  @return Bool
	 */
	override public inline function isDummy() :Bool
	{
		return false;
	}

	/**
	 *  [Description]
	 *  @return Bool
	 */
	override public inline function isExternal() :Bool
	{
		return true;
	}

	/**
	 *  [Description]
	 *  @return Bool
	 */
	override public inline function isPivotable() :Bool
	{
		return false;
	}

	/**
	 *  [Description]
	 *  @return Bool
	 */
	override public inline function isRestricted() :Bool
	{
		return false;
	}

	/**
	 *  [Description]
	 *  @return String
	 */
	override public function toString() : String
	{
		return "[" + this.hashcode + ":" + this.value_ + "]";
	}

	/**
	 *  [Description]
	 *  @param value - 
	 *  @return Float
	 */
	override public function changeValue(value :Float) : Void
	{
		this.value_ = value;
	}
}