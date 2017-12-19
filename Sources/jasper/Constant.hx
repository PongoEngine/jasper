/*
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
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

package jasper;

abstract Constant(Float) 
{
    
    inline public function new(const:Float) : Void
    {
        this = const;
    }

    @:op(A - B) static function subtract( a:Constant, b:Constant ) : Constant;
    @:op(A + B) static function add( a:Constant, b:Constant ) : Constant;
    @:op(A * B) static function times( a:Constant, b:Constant ) : Constant;
    @:op(A / B) static function divide( a:Constant, b:Constant ) : Constant;
    @:op(-A) static function negate(a:Constant) : Constant;

    @:op(A + B) static inline function addFloat(a:Constant, b:Float) : Constant
    {
        return new Constant(a.toFloat() + b);
    }

    @:commutative @:op(A + B) static inline function addValue(a:Constant, b:Value) : Constant
    {
        return new Constant(a.toFloat() + b.toFloat());
    }

    @:commutative @:op(A * B) static inline function timesFloat(a:Constant, b:Float) : Constant
    {
        return new Constant(a.toFloat() * b);
    }

    public inline function toValue() : Value
    {
        return new Value(this);
    }

    public inline function toFloat() : Float
    {
        return this;
    }
}