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
abstract Value(Float) to Float from Float
{
    @:op(A*B) static function multiply(a:Value,B:Value):Value;
    @:op(A/B) static function divide(a:Value,B:Value):Value;
    @:op(A+B) static function add(a:Value,B:Value):Value;
    @:op(-A) static function negate(a:Value):Value;

    @:op(A-B) static inline function subtractExpression(constant :Value, expression :Expression) : Expression
    {
        return -expression + constant;
    }

    @:op(A-B) static inline function subtractTerm(constant :Value, term :Term) : Expression
    {
        return -term + constant;
    }

    @:op(A-B) static inline function subtractVariable(constant :Value, variable :Variable) : Expression
    {
        return -variable + constant;
    }

    @:op(A<=B) static inline function lteExpression(constant :Value, expression :Expression) : Constraint
    {
        return expression >= constant;
    }

    @:op(A<=B) static inline function lteTerm(constant :Value, term :Term) : Constraint
    {
        return term >= constant;
    }

    @:op(A<=B) static inline function lteVariable(constant :Value, variable :Variable) : Constraint
    {
        return variable >= constant;
    }

    @:op(A>=B) static inline function gteExpression(constant :Value, expression :Expression) : Constraint
    {
        return expression <= constant;
    }

    @:op(A>=B) static inline function gteTerm(constant :Value, term :Term) : Constraint
    {
        return term <= constant;
    }

    @:op(A>=B) static inline function gteVariable(constant :Value, variable :Variable) : Constraint
    {
        return variable <= constant;
    }
}