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

import jasper.variable.ClVariable;
import jasper.Stringable;

class ClPoint implements Stringable
{
    private var x :ClVariable;
    private var y :ClVariable;

    public function new(x :Dynamic, y :Dynamic, ?suffix :String) : Void
    {
        if (Std.is(x, ClVariable)) {
            this.x = x;
        } 
        else {
            if (suffix != null) {
                this.x = new ClVariable("x"+suffix, x);
            } else {
                this.x = new ClVariable(x);
            }
        }

        if (Std.is(y, ClVariable)) {
            this.y = y;
        } else {
            if (suffix != null) {
                this.y = new ClVariable("y"+suffix, y);
            } else {
                this.y = new ClVariable(y);
            }
        }
    }

    public function SetXY(x, y) : Void
    {
        if (Std.is(x, ClVariable)) {
            this.x = x;
        } else {
            this.x.set_value(x);
        }
        if (Std.is(y, ClVariable)) {
            this.y = y;
        } else {
            this.y.set_value(y);
        }
    }

    public function X() :ClVariable { return this.x; }

    public function Y() :ClVariable { return this.y; }

    public function Xvalue() : Dynamic
    {
        return this.x.value();
    }

    public function Yvalue() : Dynamic
    {
        return this.y.value();
    }

    public function toString() : String
    {
        return "(" + this.x + ", " + this.y + ")";
    }
}