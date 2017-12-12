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

import jasper.error.ExCLInternalError;

class Util
{
	/**
	 *  [Description]
	 *  @param a - 
	 *  @param b - 
	 *  @return Bool
	 */
	public static function approx(a :Float, b :Float) :Bool
	{
		var epsilon = 1.0e-8;

		if (a == 0.0) {
			return (Math.abs(b) < epsilon);
		} 
		else if (b == 0.0) {
			return (Math.abs(a) < epsilon);
		} 
		else {
			return (Math.abs(a - b) < Math.abs(a) * epsilon);
		}
	}

	/**
	 *  [Description]
	 *  @param f - 
	 *  @param description - 
	 */
	public static function Assert(f :Bool, description :String) : Void
	{
		if (!f) {
			throw new ExCLInternalError("Assertion failed:" + description);
		}
	}
}