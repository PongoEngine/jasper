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

class _Variable_
{
    public var m_name (default, null):String;
    public var m_value :Float;

    /**
     *  [Description]
     *  @param name - 
     */
    @:allow(jasper.Variable)
    private function new(name :String) : Void
    {
        this.m_name = name;
        this.m_value = 0.0;
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() : String
    {
        return "name: " + m_name + " value: " + m_value;
    }
}

//*********************************************************************************************************

@:forward
@:notNull
abstract Variable(_Variable_) to _Variable_
{
    public inline function new(name :String = "") : Void
    {
        this = new _Variable_(name);
    }

    @:op(A*B) @:commutative static inline function multiplyValue(variable :Variable, coefficient :Value) : Term
    {
        return new Term( variable, coefficient );
    }

    @:op(A/B) static inline function divideValue(variable :Variable, denominator :Value) : Term
    {
        return variable * ( 1.0 / denominator );
    }

    @:op(-A) static inline function negateVariable(variable :Variable) : Term
    {
        return variable * -1.0;
    }

    @:op(A+B) static inline function addVariable(first :Variable, second :Variable) : Expression
    {
        return new Term(first) + second;
    }

    @:op(A+B) @:commutative static inline function addValue(variable :Variable, constant :Value) : Expression
    {
        return new Term(variable) + constant;
    }

    @:op(A-B) static inline function subtractExpression(variable :Variable, expression :Expression) : Expression
    {
        return variable + -expression;
    }

    @:op(A-B) static inline function subtractTerm(variable :Variable, term :Term) : Expression
    {
        return variable + -term;
    }

    @:op(A-B) static inline function subtractVariable(first :Variable, second :Variable) : Expression
    {
        return first + -second;
    }

    @:op(A-B) static inline function subtractValue(variable :Variable, constant :Value) : Expression
    {
        return variable + -constant;
    }

    @:op(A==B) static inline function equalsVariable(first :Variable, second :Variable) : Constraint
    {
        return new Term(first) == second;
    }

    @:op(A==B) @:commutative static inline function equalsValue(variable :Variable, constant :Value) : Constraint
    {
        return new Term(variable) == constant;
    }

    @:op(A<=B) static inline function lteExpression(variable :Variable, expression :Expression) : Constraint
    {
        return expression >= variable;
    }

    @:op(A<=B) static inline function lteTerm(variable :Variable, term :Term) : Constraint
    {
        return term >= variable;
    }

    @:op(A<=B) static inline function lteVariable(first :Variable, second :Variable) : Constraint
    {
        return new Term(first) <= second;
    }

    @:op(A<=B) static inline function lteValue(variable :Variable, constant :Value) : Constraint
    {
        return new Term(variable) <= constant;
    }

    @:op(A>=B) static inline function gteExpression(variable :Variable, expression :Expression) : Constraint
    {
        return expression <= variable;
    }

    @:op(A>=B) static inline function gteTerm(variable :Variable, term :Term) : Constraint
    {
        return term <= variable;
    }

    @:op(A>=B) static inline function gteVariable(first :Variable, second :Variable) : Constraint
    {
        return new Term(first) >= second;
    }

    @:op(A>=B) static inline function gteValue(variable :Variable, constant :Value) : Constraint
    {
        return new Term(variable) >= constant;
    }
}