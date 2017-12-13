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

import jasper.Stringable;

class ClSymbolicWeight implements Stringable
{
    private var _values :Array<Float>;

    public inline function new(w1 :Float, w2 :Float, w3 :Float) : Void
    {
        this._values = [w1, w2, w3];
    }

    public function times(n :Float) : ClSymbolicWeight
    {
        return new ClSymbolicWeight(this._values[0]*n,
            this._values[1]*n,
            this._values[2]*n);
    }

    public function divideBy(n : Float) : ClSymbolicWeight
    {
        return new ClSymbolicWeight(this._values[0]/n,
            this._values[1]/n,
            this._values[2]/n);
    }

    public function add(c :ClSymbolicWeight) : ClSymbolicWeight 
    {
        return new ClSymbolicWeight(this._values[0]+c._values[0],
            this._values[1]+c._values[1],
            this._values[2]+c._values[2]);
    }

    public function subtract(c :ClSymbolicWeight) : ClSymbolicWeight
    {
        return new ClSymbolicWeight(this._values[0]-c._values[0],
            this._values[1]-c._values[1],
            this._values[2]-c._values[2]);
    }

    public function lessThan(c :ClSymbolicWeight) : Bool
    {
        for (i in 0...this._values.length) {
            if (this._values[i] < c._values[i]) {
                return true;
            } else if (this._values[i] > c._values[i]) {
                return false;
            }
        }
        return false; // equal
    }

    public function lessThanOrEqual(c :ClSymbolicWeight) : Bool
    {
        for (i in 0...this._values.length) {
            if (this._values[i] < c._values[i]) {
                return true;
            } else if (this._values[i] > c._values[i]) {
                return false;
            }
        }
        return true; // equal
    }

    public function equal(c :ClSymbolicWeight) : Bool
    {
        for (i in 0...this._values.length) {
            if (this._values[i] != c._values[i]) {
                return false;
            }
        }
        return true;
    }

    public function greaterThan(c :ClSymbolicWeight) : Bool
    {
        return !this.lessThanOrEqual(c);
    }

    public function greaterThanOrEqual(c :ClSymbolicWeight) : Bool
    {
        return !this.lessThan(c);
    }

    public function isNegative() : Bool
    {
        return this.lessThan(ClSymbolicWeight.clsZero);
    }

    public function toDouble() : Float
    {
        var sum :Float =  0;
        var factor = 1;
        var multiplier = 1000;

        var i = this._values.length - 1;
        while (i >= 0) {
            sum += this._values[i] * factor;
            factor *= multiplier;
            --i;
        }
        return sum;
    }

    public function toString() : String
    {
        return '[' + this._values[0] + ','
            + this._values[1] + ','
            + this._values[2] + ']';
    }
  
    public function cLevels() : Int { return 3; }

    public static var clsZero = new ClSymbolicWeight(0, 0, 0);
}