/*
 * Copyright (c) 2013-2017, Nucleic Development Team.
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Distributed under the terms of the Modified BSD License.
 *  
 *  The full license is in the file COPYING.txt, distributed with this software.
*/

package jasper;

@:notNull
abstract Value(Float) to Float from Float
{
    @:op(A*B) static function multiply(a:Value,B:Value):Value;
    @:op(A/B) static function divide(a:Value,B:Value):Value;
    @:op(A+B) static function add(a:Value,B:Value):Value;
    @:op(-A) static function negate(a:Value):Value;

    @:op(A*B) static function multiplyExpression(coefficient :Value, expression :Expression) : Expression
    {

        return expression * coefficient;
    }

    @:op(A*B) static function multiplyTerm(coefficient :Value, term :Term) : Term
    {
        
        return term * coefficient;
    }

    @:op(A*B) static function multiplyVariable(coefficient :Value, variable :Variable) : Term
    {
        
        return variable * coefficient;
    }

    @:op(A+B) static function addExpression(constant :Value, expression :Expression) : Expression
    {
        
        return expression + constant;
    }

    @:op(A+B) static function addTerm(constant :Value, term :Term) : Expression
    {
        
        return term + constant;
    }

    @:op(A+B) static function addVariable(constant :Value, variable :Variable) : Expression
    {
        
        return variable + constant;
    }

    @:op(A-B) static function subtractExpression(constant :Value, expression :Expression) : Expression
    {
        
        return -expression + constant;
    }

    @:op(A-B) static function subtractTerm(constant :Value, term :Term) : Expression
    {
        
        return -term + constant;
    }

    @:op(A-B) static function subtractVariable(constant :Value, variable :Variable) : Expression
    {
        
        return -variable + constant;
    }

    @:op(A==B) static function equalsExpression(constant :Value, expression :Expression) : Constraint
    {
        
        return expression == constant;
    }

    @:op(A==B) static function equalsTerm(constant :Value, term :Term) : Constraint
    {
        
        return term == constant;
    }

    @:op(A==B) static function equalsVariable(constant :Value, variable :Variable) : Constraint
    {
        
        return variable == constant;
    }

    @:op(A<=B) static function lteExpression(constant :Value, expression :Expression) : Constraint
    {
        
        return expression >= constant;
    }

    @:op(A<=B) static function lteTerm(constant :Value, term :Term) : Constraint
    {
        
        return term >= constant;
    }

    @:op(A<=B) static function lteVariable(constant :Value, variable :Variable) : Constraint
    {
        
        return variable >= constant;
    }

    @:op(A>=B) static function gteExpression(constant :Value, expression :Expression) : Constraint
    {
        
        return expression <= constant;
    }

    @:op(A>=B) static function gteTerm(constant :Value, term :Term) : Constraint
    {
        
        return term <= constant;
    }

    @:op(A>=B) static function gteVariable(constant :Value, variable :Variable) : Constraint
    {
        
        return variable <= constant;
    }
}

//*********************************************************************************************************

@:forward
@:forwardStatics
@:notNull
abstract Term(jasper._Term_)
{
    public inline function new(variable :Variable, coefficient :Float = 1.0) : Void
    {
        this = new _Term_(variable, coefficient);
    }

    @:op(A*B) static function multiplyValue(term :Term, coefficient :Value) : Term
    {
        
        return new Term( term.variable, term.coefficient * coefficient );
    }

    @:op(A/B) static function divideValue(term :Term, denominator :Value) : Term
    {

        return term * ( 1.0 / denominator );
    }

    @:op(-A) static function negateTerm(term :Term) : Term
    {
        
        return term * -1.0;
    }

    @:op(A+B) static function addExpression(term :Term, expression :Expression) : Expression
    {
        
        return expression + term;
    }

    @:op(A+B) static function addTerm(first :Term, second :Term) : Expression
    {
        
        var terms = new Array<Term>();
        terms.push(first);
        terms.push(second);

        return new Expression(terms);
    }

    @:op(A+B) static function addVariable(term :Term, variable :Variable) : Expression
    {
        
        return term + new Term(variable);
    }

    @:op(A+B) static function addValue(term :Term, constant :Value) : Expression
    {
        
        return Expression.fromTerm( term, constant );
    }

    @:op(A-B) static function subtractExpression(term :Term, expression :Expression) : Expression
    {
        
        return -expression + term;
    }

    @:op(A-B) static function subtractTerm(first :Term, second :Term) : Expression
    {
        
        return first + -second;
    }

    @:op(A-B) static function subtractVariable(term :Term, variable :Variable) : Expression
    {
        
        return term + -variable;
    }

    @:op(A-B) static function subtractValue(term :Term, constant :Value) : Expression
    {
        
        return term + -constant;
    }

    @:op(A==B) static function equalsExpression(term :Term, expression :Expression) : Constraint
    {
        
        return expression == term;
    }

    @:op(A==B) static function equalsTerm(first :Term, second :Term) : Constraint
    {
        
        return Expression.fromTerm(first) == second;
    }

    @:op(A==B) static function equalsVariable(term :Term, variable :Variable) : Constraint
    {
        
        return Expression.fromTerm(term) == variable;
    }

    @:op(A==B) static function equalsValue(term :Term, constant :Value) : Constraint
    {
        
        return Expression.fromTerm(term) == constant;
    }

    @:op(A<=B) static function lteExpression(term :Term, expression :Expression) : Constraint
    {
        
        return expression >= term;
    }

    @:op(A<=B) static function lteTerm(first :Term, second :Term) : Constraint
    {
        
        return Expression.fromTerm(first) <= second;
    }

    @:op(A<=B) static function lteVariable(term :Term, variable :Variable) : Constraint
    {
        
        return Expression.fromTerm(term) <= variable;
    }

    @:op(A<=B) static function lteValue(term :Term, constant :Value) : Constraint
    {
        
        return Expression.fromTerm(term) <= constant;
    }

    @:op(A>=B) static function gteExpression(term :Term, expression :Expression) : Constraint
    {
        
        return expression <= term;
    }

    @:op(A>=B) static function gteTerm(first :Term, second :Term) : Constraint
    {
        
        return Expression.fromTerm(first) >= second;
    }

    @:op(A>=B) static function gteVariable(term :Term, variable :Variable) : Constraint
    {
        
        return Expression.fromTerm(term) >= variable;
    }

    @:op(A>=B) static function gteValue(term :Term, constant :Value) : Constraint
    {
        
        return Expression.fromTerm(term) >= constant;
    }
}

//*********************************************************************************************************

@:forward
@:notNull
abstract Variable(jasper._Variable_) to jasper._Variable_
{
    public inline function new(name :String) : Void
    {
        this = new jasper._Variable_(name);
    }

    @:op(A*B) static function nultiplyValue(variable :Variable, coefficient :Value) : Term
    {
        
        return new Term( variable, coefficient );
    }

    @:op(A/B) static function divideValue(variable :Variable, denominator :Value) : Term
    {
        
        return variable * ( 1.0 / denominator );
    }

    @:op(-A) static function negateVariable(variable :Variable) : Term
    {
        
        return variable * -1.0;
    }

    @:op(A+B) static function addExpression(variable :Variable, expression :Expression) : Expression
    {
        
        return expression + variable;
    }

    @:op(A+B) static function addTerm(variable :Variable, term :Term) : Expression
    {
        
        return term + variable;
    }

    @:op(A+B) static function addVariable(first :Variable, second :Variable) : Expression
    {
        
        return new Term(first) + second;
    }

    @:op(A+B) static function addValue(variable :Variable, constant :Value) : Expression
    {
        
        return new Term(variable) + constant;
    }

    @:op(A-B) static function subtractExpression(variable :Variable, expression :Expression) : Expression
    {
        
        return variable + -expression;
    }

    @:op(A-B) static function subtractTerm(variable :Variable, term :Term) : Expression
    {
        
        return variable + -term;
    }

    @:op(A-B) static function subtractVariable(first :Variable, second :Variable) : Expression
    {
        
        return first + -second;
    }

    @:op(A-B) static function subtractValue(variable :Variable, constant :Value) : Expression
    {
        
        return variable + -constant;
    }

    @:op(A==B) static function equalsExpression(variable :Variable, expression :Expression) : Constraint
    {
        
        return expression == variable;
    }

    @:op(A==B) static function equalsTerm(variable :Variable, term :Term) : Constraint
    {
        
        return term == variable;
    }

    @:op(A==B) static function equalsVariable(first :Variable, second :Variable) : Constraint
    {
        
        return new Term(first) == second;
    }

    @:op(A==B) static function equalsValue(variable :Variable, constant :Value) : Constraint
    {
        
        return new Term(variable) == constant;
    }

    @:op(A<=B) static function lteExpression(variable :Variable, expression :Expression) : Constraint
    {
        
        return expression >= variable;
    }

    @:op(A<=B) static function lteTerm(variable :Variable, term :Term) : Constraint
    {
        
        return term >= variable;
    }

    @:op(A<=B) static function lteVariable(first :Variable, second :Variable) : Constraint
    {
        
        return new Term(first) <= second;
    }

    @:op(A<=B) static function lteValue(variable :Variable, constant :Value) : Constraint
    {
        
        return new Term(variable) <= constant;
    }

    @:op(A>=B) static function gteExpression(variable :Variable, expression :Expression) : Constraint
    {
        
        return expression <= variable;
    }

    @:op(A>=B) static function gteTerm(variable :Variable, term :Term) : Constraint
    {
        
        return term <= variable;
    }

    @:op(A>=B) static function gteVariable(first :Variable, second :Variable) : Constraint
    {
        
        return new Term(first) >= second;
    }

    @:op(A>=B) static function gteValue(variable :Variable, constant :Value) : Constraint
    {
        
        return new Term(variable) >= constant;
    }
}

//================================================================================================





// // Constraint strength modifier

// inline
// Constraint operator|( const Constraint& constraint, double strength )
// {
// 	return Constraint( constraint, strength );
// }


// inline
// Constraint operator|( double strength, const Constraint& constraint )
// {
// 	return constraint | strength;
// }