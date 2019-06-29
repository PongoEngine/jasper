/*
 * MIT License
 *
 * Copyright (c) 2019 Jeremy Meltingtallow
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

@:notNull
abstract Strength(Float) to Float from Float
{
    public inline function new(str :Float) : Void
    {
        this = str;
    }

    @:op(A < B) static function lt(a :Strength, b :Strength) : Bool;
    @:op(A > B) static function gt(a :Strength, b :Strength) : Bool;
    @:op(-A) function negate() : Strength;

    public static inline var REQUIRED :Strength = 1001001000;
    public static inline var STRONG :Strength = 1000000;
    public static inline var MEDIUM :Strength = 1000;
    public static inline var WEAK :Strength = 1;

    public static function create(a :Float, b :Float, c :Float, w :Float = 1.0) : Strength
    {
        var result = 0.0;
        result += Math.max( 0.0, Math.min( 1000.0, a * w ) ) * 1000000.0;
        result += Math.max( 0.0, Math.min( 1000.0, b * w ) ) * 1000.0;
        result += Math.max( 0.0, Math.min( 1000.0, c * w ) );
        return new Strength(result);
    }

    public static function clip(value :Strength) :Strength
    {
        return new Strength(Math.max( 0.0, Math.min( REQUIRED, value ) ));
    }
}
