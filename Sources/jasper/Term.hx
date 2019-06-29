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

class _Term_
{
    public var m_variable (default, null):Variable;
    public var m_coefficient (default, null):Float;

    /**
     *  [Description]
     *  @param variable - 
     *  @param coefficient - 
     */
    @:allow(jasper.Term)
    private function new(variable :Variable, coefficient :Float) : Void
    {
        this.m_variable = variable;
        this.m_coefficient = coefficient;
    }

    /**
     *  [Description]
     *  @return Float
     */
    public function value() : Float
    {
        return m_coefficient * m_variable.m_value;
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() : String
    {
        return "variable: (" + m_variable + ") coefficient: "  + m_coefficient;
    }
}

//*********************************************************************************************************

@:forward
@:forwardStatics
@:notNull
abstract Term(_Term_)
{
    public inline function new(variable :Variable, coefficient :Float = 1.0) : Void
    {
        this = new _Term_(variable, coefficient);
    }

    @:op(A*B) @:commutative static function multiplyValue(term :Term, coefficient :Value) : Term
    {
        return new Term( term.m_variable, term.m_coefficient * coefficient );
    }

    @:op(A/B) static function divideValue(term :Term, denominator :Value) : Term
    {
        return term * ( 1.0 / denominator );
    }

    @:op(-A) static function negateTerm(term :Term) : Term
    {
        return term * -1.0;
    }

    @:op(A+B) static function addTerm(first :Term, second :Term) : Expression
    {
        var terms = new Array<Term>();
        terms.push(first);
        terms.push(second);

        return new Expression(terms);
    }

    @:op(A+B) @:commutative static inline function addVariable(term :Term, variable :Variable) : Expression
    {
        return term + new Term(variable);
    }

    @:op(A+B) @:commutative static inline function addValue(term :Term, constant :Value) : Expression
    {
        return new Expression([term], constant);
    }

    @:op(A-B) static inline function subtractExpression(term :Term, expression :Expression) : Expression
    {
        return -expression + term;
    }

    @:op(A-B) static inline function subtractTerm(first :Term, second :Term) : Expression
    {
        return first + -second;
    }

    @:op(A-B) static inline function subtractVariable(term :Term, variable :Variable) : Expression
    {
        return term + -variable;
    }

    @:op(A-B) static inline function subtractValue(term :Term, constant :Value) : Expression
    {
        return term + -constant;
    }

    @:op(A==B) static inline function equalsTerm(first :Term, second :Term) : Constraint
    {
        return new Expression([first]) == second;
    }

    @:op(A==B) @:commutative static inline function equalsVariable(term :Term, variable :Variable) : Constraint
    {
        return new Expression([term]) == variable;
    }

    @:op(A==B) @:commutative static inline function equalsValue(term :Term, constant :Value) : Constraint
    {
        return new Expression([term]) == constant;
    }

    @:op(A<=B) static inline function lteExpression(term :Term, expression :Expression) : Constraint
    {
        return expression >= term;
    }

    @:op(A<=B) static inline function lteTerm(first :Term, second :Term) : Constraint
    {
        return new Expression([first]) <= second;
    }

    @:op(A<=B) static inline function lteVariable(term :Term, variable :Variable) : Constraint
    {
        return new Expression([term]) <= variable;
    }

    @:op(A<=B) static inline function lteValue(term :Term, constant :Value) : Constraint
    {
        return new Expression([term]) <= constant;
    }

    @:op(A>=B) static inline function gteExpression(term :Term, expression :Expression) : Constraint
    {
        return expression <= term;
    }

    @:op(A>=B) static inline function gteTerm(first :Term, second :Term) : Constraint
    {
        return new Expression([first]) >= second;
    }

    @:op(A>=B) static inline function gteVariable(term :Term, variable :Variable) : Constraint
    {
        return new Expression([term]) >= variable;
    }

    @:op(A>=B) static inline function gteValue(term :Term, constant :Value) : Constraint
    {
        return new Expression([term]) >= constant;
    }
}