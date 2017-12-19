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

import jasper.Hashable;
import jasper.Stringable;

class ClAbstractVariable implements Hashable implements Stringable
{
	public var hash_code (default, null) :Int;

	private var _name :String;

	public function new(?a1 :Dynamic, ?a2 :Dynamic) : Void
	{
		this.hash_code = ClAbstractVariable.iVariableNumber++;
		if (Std.is(a1, String) || (a1 == null)) {
			this._name = (a1 != null)
				? a1
				: "v" + this.hash_code;
		} else {
			var varnumber = a1, prefix = a2;
			this._name = prefix + varnumber;
		}
	}

	public function hashCode() : Int
	{
		return this.hash_code;
	}

	public function name() : String
	{
		return this._name;
	}

	public function setName(name :String) : Void
	{
		this._name = name;
	}

	public function isDummy() {
		return false;
	}

	public function isExternal() : Bool
	{
		throw "abstract isExternal";
	}

	public function isPivotable() : Bool
	{
		throw "abstract isPivotable";
	}

	public function isRestricted() : Bool
	{
		throw "abstract isRestricted";
	}

	public function toString() : String
	{
		return "ABSTRACT[" + this._name + "]";
	}

	public static var iVariableNumber :Int = 1;
}