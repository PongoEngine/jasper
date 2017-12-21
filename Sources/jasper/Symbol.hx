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

/**
 * Created by alex on 30/01/15.
 */
@:notNull
abstract Symbol(SymbolType) to Int
{
    /**
     *  [Description]
     *  @param type - 
     */
    public inline function new(type :SymbolType) : Void
    {
        this = type;
    }

    /**
     *  [Description]
     *  @return Symbol
     */
    public static inline function invalidSymbol() : Symbol
    {
        return new Symbol(SymbolType.INVALID);
    }

    public static inline function nothing() : Symbol
    {
        return new Symbol(SymbolType.NOTHING);
    }

    /**
     *  [Description]
     *  @return SymbolType
     */
    public inline function getType() :SymbolType
    {
        return this;
    }
}

@:enum
abstract SymbolType(Int) to Int
{
    var INVALID = 0;
    var EXTERNAL = 1;
    var SLACK = 2;
    var ERROR = 3;
    var DUMMY = 4;
    var NOTHING = 5;
}