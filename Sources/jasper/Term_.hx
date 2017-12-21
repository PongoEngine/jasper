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

import jasper.symbolics.Variable;
import jasper.symbolics.Term;

class Term_
{
    public var variable :Variable;
    public var coefficient :Float;

    /**
     *  [Description]
     *  @param variable - 
     *  @param coefficient - 
     */
    public function new(variable :Variable, coefficient :Float) : Void
    {
        this.variable = variable;
        this.coefficient = coefficient;
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @return Term
     */
    public static inline function fromVariable(variable :Variable) : Term
    {
        return new Term(variable, 1.0);
    }

    /**
     *  [Description]
     *  @return Float
     */
    public function getValue() : Float
    {
        return coefficient * variable.value;
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() : String
    {
        return "variable: (" + variable + ") coefficient: "  + coefficient;
    }
}


