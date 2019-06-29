/*
 * Copyright (c) 2013-2017, Nucleic Development Team.
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Distributed under the terms of the Modified BSD License.
 *  
 * The full license is in the file COPYING.txt, distributed with this software.
*/

package jasper;

class _Expression_
{
    public var m_terms (default, null):Array<Term>;
    public var m_constant (default, null):Float;

    /**
     *  [Description]
     *  @param terms - 
     *  @param constant - 
     */
    @:allow(jasper.Expression)
    private function new(terms :Array<Term>, constant :Float) : Void
    {
        this.m_terms = terms;
        this.m_constant = constant;
    }

    /**
     *  [Description]
     *  @return Float
     */
    public function value() : Float
    {
        var result :Float = m_constant;
        for(term in m_terms)
            result += term.value();
        return result;
    }
}

//*********************************************************************************************************

@:forward
@:forwardStatics
@:notNull
abstract Expression(_Expression_)
{
    public inline function new(terms :Array<Term>, constant :Float = 0.0) : Void
    {        
        this = new jasper._Expression_(terms, constant);
    }

    @:op(A*B) @:commutative static function multiplyValue(expression :Expression, coefficient :Value) : Expression
    {
        var terms = new Array<Term>();

        for (term in expression.m_terms) {
            terms.push(term * coefficient);
        }

        return new Expression(terms, expression.m_constant * coefficient);
    }

    @:op(A/B) static inline function divideValue(expression :Expression, denominator :Value) : Expression
    {
        return expression * ( 1.0 / denominator );
    }

    @:op(-A) static inline function negateExpression(expression :Expression) : Expression
    {
        return expression * -1.0;
    }

    @:op(A+B) static function addExpression(first :Expression, second :Expression) : Expression
    {
        var terms = new Array<Term>();

        for(t in first.m_terms) terms.push(t);
        for(t in second.m_terms) terms.push(t);

        return new Expression(terms, first.m_constant + second.m_constant);
    }

    @:op(A+B) @:commutative static function addTerm(first :Expression, second :Term) : Expression
    {
        var terms = new Array<Term>();
        for(t in first.m_terms) terms.push(t);
        terms.push(second);
        return new Expression(terms, first.m_constant);
    }

    @:op(A+B) @:commutative static inline function addVariable(expression :Expression, variable :Variable) : Expression
    {
        return expression + new Term(variable);
    }

    @:op(A+B) @:commutative static inline function addValue(expression :Expression, constant :Value) : Expression
    {
        return new Expression( expression.m_terms, expression.m_constant + constant );
    }

    @:op(A-B) static inline function subtractExpression(first :Expression, second :Expression) : Expression
    {
        return first + -second;
    }

    @:op(A-B) static inline function subtractTerm(expression :Expression, term :Term) : Expression
    {
        return expression + -term;
    }

    @:op(A-B) static inline function subtractVariable(expression :Expression, variable :Variable) : Expression
    {
        return expression + -variable;
    }

    @:op(A-B) static inline function subtractValue(expression :Expression, constant :Value) : Expression
    {
        return expression + -constant;
    }

    @:op(A==B) static inline function equalsExpression(first :Expression, second :Expression) : Constraint
    {
        return new Constraint( first - second, OP_EQ );
    }

    @:op(A==B) @:commutative static inline function equalsTerm(expression :Expression, term :Term) : Constraint
    {
        return expression == new Expression([term]);
    }

    @:op(A==B) @:commutative static inline function equalsVariable(expression :Expression, variable :Variable) : Constraint
    {
        return expression == new Term(variable);
    }

    @:op(A==B) @:commutative static inline function equalsValue(expression :Expression, constant :Value) : Constraint
    {
        return expression == new Expression([], constant);
    }

    @:op(A<=B) static inline function lteExpression(first :Expression, second :Expression) : Constraint
    {
        return new Constraint( first - second, OP_LE );
    }

    @:op(A<=B) static inline function lteTerm(expression :Expression, term :Term) : Constraint
    {
        return expression <= new Expression([term]);
    }

    @:op(A<=B) static inline function lteVariable(expression :Expression, variable :Variable) : Constraint
    {
        return expression <= new Term(variable);
    }

    @:op(A<=B) static inline function lteValue(expression :Expression, constant :Value) : Constraint
    {
        return expression <= new Expression([], constant);
    }

    @:op(A>=B) static inline function gteExpression(first :Expression, second :Expression) : Constraint
    {
        return new Constraint( first - second, OP_GE );
    }

    @:op(A>=B) static inline function gteTerm(expression :Expression, term :Term) : Constraint
    {
        return expression >= new Expression([term]);
    }

    @:op(A>=B) static inline function gteVariable(expression :Expression, variable :Variable) : Constraint
    {
        return expression >= new Term(variable);
    }

    @:op(A>=B) static inline function gteValue(expression :Expression, constant :Value) : Constraint
    {
        return expression >= new Expression([], constant);
    }
}