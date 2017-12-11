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

class ClSymbolicWeight
{
    public var _w1 :Float;
    public var _w2 :Float;
    public var _w3 :Float;

    /**
     *  [Description]
     *  @param w1 - 
     *  @param w2 - 
     *  @param w3 - 
     */
    public inline function new(w1 :Float, w2 :Float, w3 :Float) : Void
    {
        this._w1 = w1;
        this._w2 = w2;
        this._w3 = w3;
    }

    /**
     *  [Description]
     *  @param n - 
     *  @return ClSymbolicWeight
     */
    @:extern public inline function times(n :Float) : ClSymbolicWeight
    {
        return new ClSymbolicWeight(_w1*n, _w2*n, _w3*n);
    }

    /**
     *  [Description]
     *  @param n - 
     *  @return ClSymbolicWeight
     */
    @:extern public inline function divideBy(n :Float) : ClSymbolicWeight
    {
        return new ClSymbolicWeight(_w1/n, _w2/n, _w3/n);
    }

    /**
     *  [Description]
     *  @param c - 
     *  @return ClSymbolicWeight
     */
    @:extern public inline function add(c :ClSymbolicWeight) : ClSymbolicWeight
    {
        return new ClSymbolicWeight(_w1+c._w1, _w2+c._w2, _w3+c._w3);
    }

    /**
     *  [Description]
     *  @param c - 
     *  @return ClSymbolicWeight
     */
    @:extern public inline function subtract(c :ClSymbolicWeight) : ClSymbolicWeight
    {
        return new ClSymbolicWeight(_w1-c._w1, _w2-c._w2, _w3-c._w3);
    }

    /**
     *  [Description]
     *  @param c - 
     *  @return Bool
     */
    @:extern public inline function lessThan(c :ClSymbolicWeight) : Bool
    {
        if(this._w1 < c._w1) return true;
        if(this._w1 > c._w1) return false;

        if(this._w2 < c._w2) return true;
        if(this._w2 > c._w2) return false;

        if(this._w3 < c._w3) return true;
        if(this._w3 > c._w3) return false;

        return  false; // equal
    }

    /**
     *  [Description]
     *  @param c - 
     *  @return Bool
     */
    @:extern public inline function lessThanOrEqual(c :ClSymbolicWeight) : Bool
    {
        if(this._w1 < c._w1) return true;
        if(this._w1 > c._w1) return false;

        if(this._w2 < c._w2) return true;
        if(this._w2 > c._w2) return false;

        if(this._w3 < c._w3) return true;
        if(this._w3 > c._w3) return false;

        return  true; // equal
    }

    /**
     *  [Description]
     *  @param c - 
     *  @return Bool
     */
    @:extern public inline function equal(c :ClSymbolicWeight) : Bool
    {
        return (this._w1 == c._w1) && (this._w2 == c._w2) && (this._w3 == c._w3);
    }

    /**
     *  [Description]
     *  @param c - 
     *  @return Bool
     */
    @:extern public inline function greaterThan(c :ClSymbolicWeight) : Bool
    {
        return !this.lessThanOrEqual(c);
    }

    /**
     *  [Description]
     *  @param c - 
     *  @return Bool
     */
    @:extern public inline function greaterThanOrEqual(c :ClSymbolicWeight) : Bool
    {
        return !this.lessThan(c);
    }

    /**
     *  [Description]
     *  @return Bool
     */
    @:extern public inline function isNegative() : Bool
    {
        return this.lessThan(new ClSymbolicWeight(0,0,0));
    }

    /**
     *  [Description]
     *  @return Float
     */
    @:extern public inline function toDouble() : Float
    {
        var sum  :Float = 0;
        var factor :Int = 1;
        var multiplier = 1000;

        sum += this._w1 * factor;
        factor *= multiplier;
        sum += this._w2 * factor;
        factor *= multiplier;
        sum += this._w3 * factor;
        factor *= multiplier;

        return sum;
    }

    /**
     *  [Description]
     *  @return String
     */
    @:extern public inline function toString() : String
    {
        return '[' + this._w1 + ','
            + this._w2 + ','
            + this._w3 + ']';
    }    

}