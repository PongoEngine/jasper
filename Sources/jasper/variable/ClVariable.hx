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
	private var _value :Dynamic;
	private var _attachedObject :Dynamic;

	public function new(name_or_val :Dynamic, ?value :Dynamic) : Void
	{
		super();

		this._name = "";
		this._value = 0.0;
		if (Std.is(name_or_val, String)) {
			super(name_or_val);
			this._value = (value != null) ? value : 0.0;
		} else if (Std.is(name_or_val, Float)) {
			super();
			this._value = name_or_val;
		} else {
			super();
		}
	}

	override public function isDummy() : Bool 
	{
		return false;
	}

	override public function isExternal() : Bool 
	{
		return true;
	}

	override public function isPivotable() : Bool 
	{
		return false;
	}

	override public function isRestricted() : Bool 
	{
		return false;
	}

	override public function toString() : String
	{
		return "[" + this.name() + ":" + this._value + "]";
	}

	public function value() : Dynamic
	{
		return this._value;
	}

	public function set_value(value: Dynamic) : Void
	{
		this._value = value;
	}

	public function change_value(value) {
		this._value = value;
	}

	public function setAttachedObject(o : Dynamic) : Void
	{
		this._attachedObject = o;
	}

	public function getAttachedObject() : Dynamic
	{
		return this._attachedObject;
	}
}