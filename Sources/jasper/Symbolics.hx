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
        test.Assert.notTestedSymbolics("Sym_Value.hx", "multiplyExpression");

        return expression * coefficient;
    }

    @:op(A*B) static function multiplyTerm(coefficient :Value, term :Term) : Term
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "multiplyTerm");
        
        return term * coefficient;
    }

    @:op(A*B) static function multiplyVariable(coefficient :Value, variable :Variable) : Term
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "multiplyVariable");
        
        return variable * coefficient;
    }

    @:op(A+B) static function addExpression(constant :Value, expression :Expression) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "addExpression");
        
        return expression + constant;
    }

    @:op(A+B) static function addTerm(constant :Value, term :Term) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "addTerm");
        
        return term + constant;
    }

    @:op(A+B) static function addVariable(constant :Value, variable :Variable) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "addVariable");
        
        return variable + constant;
    }

    @:op(A-B) static function subtractExpression(constant :Value, expression :Expression) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "subtractExpression");
        
        return -expression + constant;
    }

    @:op(A-B) static function subtractTerm(constant :Value, term :Term) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "subtractTerm");
        
        return -term + constant;
    }

    @:op(A-B) static function subtractVariable(constant :Value, variable :Variable) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "subtractVariable");
        
        return -variable + constant;
    }

    @:op(A==B) static function equalsExpression(constant :Value, expression :Expression) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "equalsExpression");
        
        return expression == constant;
    }

    @:op(A==B) static function equalsTerm(constant :Value, term :Term) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "equalsTerm");
        
        return term == constant;
    }

    @:op(A==B) static function equalsVariable(constant :Value, variable :Variable) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "equalsVariable");
        
        return variable == constant;
    }

    @:op(A<=B) static function lteExpression(constant :Value, expression :Expression) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "lteExpression");
        
        return expression >= constant;
    }

    @:op(A<=B) static function lteTerm(constant :Value, term :Term) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "lteTerm");
        
        return term >= constant;
    }

    @:op(A<=B) static function lteVariable(constant :Value, variable :Variable) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "lteVariable");
        
        return variable >= constant;
    }

    @:op(A>=B) static function gteExpression(constant :Value, expression :Expression) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "gteExpression");
        
        return expression <= constant;
    }

    @:op(A>=B) static function gteTerm(constant :Value, term :Term) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "gteTerm");
        
        return term <= constant;
    }

    @:op(A>=B) static function gteVariable(constant :Value, variable :Variable) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Value.hx", "gteVariable");
        
        return variable <= constant;
    }
}

//*********************************************************************************************************

@:forward
@:forwardStatics
@:notNull
abstract Expression(jasper._Expression_)
{
    public inline function new(terms :List<Term>, constant :Float) : Void
    {        
        this = new jasper._Expression_(terms, constant);
    }

    @:op(A*B) static function multiplyValue(expression :Expression, coefficient :Value) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "multiplyValue");
        
        var terms = new List<Term>();

        for (term in expression.m_terms) {
            terms.add(term * coefficient);
        }

        return new Expression(terms, expression.m_constant * coefficient);
    }

    @:op(A/B) static function divideValue(expression :Expression, denominator :Value) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "divideValue");
        
        return expression * ( 1.0 / denominator );
    }

    @:op(-A) static function negateExpression(expression :Expression) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "negateExpression");

        return expression * -1.0;
    }

    @:op(A+B) static function addExpression(first :Expression, second :Expression) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "addExpression");
        
        var terms = new List<Term>();

        for(t in first.m_terms) terms.add(t);
        for(t in second.m_terms) terms.add(t);

        return new Expression(terms, first.m_constant + second.m_constant);
    }

    @:op(A+B) static function addTerm(first :Expression, second :Term) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "addTerm");
        
        var terms = new List<Term>();
        for(t in first.m_terms) terms.add(t);
        terms.add(second);
        return new Expression(terms, first.m_constant);
    }

    @:op(A+B) static function addVariable(expression :Expression, variable :Variable) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "addVariable");
        
        return expression + new Term(variable);
    }

    @:op(A+B) static function addValue(expression :Expression, constant :Value) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "addValue");
        
        return new Expression( expression.m_terms, expression.m_constant + constant );
    }

    @:op(A-B) static function subtractExpression(first :Expression, second :Expression) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "subtractExpression");
        
        return first + -second;
    }

    @:op(A-B) static function subtractTerm(expression :Expression, term :Term) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "subtractTerm");
        
        return expression + -term;
    }

    @:op(A-B) static function subtractVariable(expression :Expression, variable :Variable) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "subtractVariable");
        
        return expression + -variable;
    }

    @:op(A-B) static function subtractValue(expression :Expression, constant :Value) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "subtractValue");
        
        return expression + -constant;
    }

    @:op(A==B) static function equalsExpression(first :Expression, second :Expression) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "equalsExpression");
        
        return Constraint.fromExpression( first - second, OP_EQ );
    }

    @:op(A==B) static function equalsTerm(expression :Expression, term :Term) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "equalsTerm");
        
        return expression == Expression.fromTerm(term);
    }

    @:op(A==B) static function equalsVariable(expression :Expression, variable :Variable) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "equalsVariable");
        
        return expression == new Term(variable);
    }

    @:op(A==B) static function equalsValue(expression :Expression, constant :Value) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "equalsValue");
        
        return expression == Expression.fromConstant(constant);
    }

    @:op(A<=B) static function lteExpression(first :Expression, second :Expression) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "lteExpression");
        
        return Constraint.fromExpression( first - second, OP_LE );
    }

    @:op(A<=B) static function lteTerm(expression :Expression, term :Term) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "lteTerm");
        
        return expression <= Expression.fromTerm(term);
    }

    @:op(A<=B) static function lteVariable(expression :Expression, variable :Variable) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "lteVariable");
        
        return expression <= new Term(variable);
    }

    @:op(A<=B) static function lteValue(expression :Expression, constant :Value) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "lteValue");
        
        return expression <= Expression.fromConstant(constant);
    }

    @:op(A>=B) static function gteExpression(first :Expression, second :Expression) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "gteExpression");
        
        return Constraint.fromExpression( first - second, OP_GE );
    }

    @:op(A>=B) static function gteTerm(expression :Expression, term :Term) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "gteTerm");
        
        return expression >= Expression.fromTerm(term);
    }

    @:op(A>=B) static function gteVariable(expression :Expression, variable :Variable) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "gteVariable");
        
        return expression >= new Term(variable);
    }

    @:op(A>=B) static function gteValue(expression :Expression, constant :Value) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Expression.hx", "gteValue");
        
        return expression >= Expression.fromConstant(constant);
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
        test.Assert.notTestedSymbolics("Sym_Term.hx", "multiplyValue");
        
        return new Term( term.variable, term.coefficient * coefficient );
    }

    @:op(A/B) static function divideValue(term :Term, denominator :Value) : Term
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "divideValue");

        return term * ( 1.0 / denominator );
    }

    @:op(-A) static function negateTerm(term :Term) : Term
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "negateTerm");
        
        return term * -1.0;
    }

    @:op(A+B) static function addExpression(term :Term, expression :Expression) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "addExpression");
        
        return expression + term;
    }

    @:op(A+B) static function addTerm(first :Term, second :Term) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "addTerm");
        
        var terms = new List<Term>();
        terms.add(first);
        terms.add(second);

        return Expression.fromTerms(terms);
    }

    @:op(A+B) static function addVariable(term :Term, variable :Variable) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "addVariable");
        
        return term + new Term(variable);
    }

    @:op(A+B) static function addValue(term :Term, constant :Value) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "addValue");
        
        return Expression.fromTermAndConstant( term, constant );
    }

    @:op(A-B) static function subtractExpression(term :Term, expression :Expression) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "subtractExpression");
        
        return -expression + term;
    }

    @:op(A-B) static function subtractTerm(first :Term, second :Term) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "subtractTerm");
        
        return first + -second;
    }

    @:op(A-B) static function subtractVariable(term :Term, variable :Variable) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "subtractVariable");
        
        return term + -variable;
    }

    @:op(A-B) static function subtractValue(term :Term, constant :Value) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "subtractValue");
        
        return term + -constant;
    }

    @:op(A==B) static function equalsExpression(term :Term, expression :Expression) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "equalsExpression");
        
        return expression == term;
    }

    @:op(A==B) static function equalsTerm(first :Term, second :Term) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "equalsTerm");
        
        return Expression.fromTerm(first) == second;
    }

    @:op(A==B) static function equalsVariable(term :Term, variable :Variable) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "equalsVariable");
        
        return Expression.fromTerm(term) == variable;
    }

    @:op(A==B) static function equalsValue(term :Term, constant :Value) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "equalsValue");
        
        return Expression.fromTerm(term) == constant;
    }

    @:op(A<=B) static function lteExpression(term :Term, expression :Expression) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "lteExpression");
        
        return expression >= term;
    }

    @:op(A<=B) static function lteTerm(first :Term, second :Term) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "lteTerm");
        
        return Expression.fromTerm(first) <= second;
    }

    @:op(A<=B) static function lteVariable(term :Term, variable :Variable) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "lteVariable");
        
        return Expression.fromTerm(term) <= variable;
    }

    @:op(A<=B) static function lteValue(term :Term, constant :Value) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "lteValue");
        
        return Expression.fromTerm(term) <= constant;
    }

    @:op(A>=B) static function gteExpression(term :Term, expression :Expression) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "gteExpression");
        
        return expression <= term;
    }

    @:op(A>=B) static function gteTerm(first :Term, second :Term) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "Term");
        
        return Expression.fromTerm(first) >= second;
    }

    @:op(A>=B) static function gteVariable(term :Term, variable :Variable) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "gteVariable");
        
        return Expression.fromTerm(term) >= variable;
    }

    @:op(A>=B) static function gteValue(term :Term, constant :Value) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Term.hx", "gteValue");
        
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
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "nultiplyValue");
        
        return new Term( variable, coefficient );
    }

    @:op(A/B) static function divideValue(variable :Variable, denominator :Value) : Term
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "divideValue");
        
        return variable * ( 1.0 / denominator );
    }

    @:op(-A) static function negateVariable(variable :Variable) : Term
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "negateVariable");
        
        return variable * -1.0;
    }

    @:op(A+B) static function addExpression(variable :Variable, expression :Expression) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "addExpression");
        
        return expression + variable;
    }

    @:op(A+B) static function addTerm(variable :Variable, term :Term) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "addTerm");
        
        return term + variable;
    }

    @:op(A+B) static function addVariable(first :Variable, second :Variable) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "addVariable");
        
        return new Term(first) + second;
    }

    @:op(A+B) static function addValue(variable :Variable, constant :Value) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "addValue");
        
        return new Term(variable) + constant;
    }

    @:op(A-B) static function subtractExpression(variable :Variable, expression :Expression) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "subtractExpression");
        
        return variable + -expression;
    }

    @:op(A-B) static function subtractTerm(variable :Variable, term :Term) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "subtractTerm");
        
        return variable + -term;
    }

    @:op(A-B) static function subtractVariable(first :Variable, second :Variable) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "subtractVariable");
        
        return first + -second;
    }

    @:op(A-B) static function subtractValue(variable :Variable, constant :Value) : Expression
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "subtractValue");
        
        return variable + -constant;
    }

    @:op(A==B) static function equalsExpression(variable :Variable, expression :Expression) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "equalsExpression");
        
        return expression == variable;
    }

    @:op(A==B) static function equalsTerm(variable :Variable, term :Term) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "equalsTerm");
        
        return term == variable;
    }

    @:op(A==B) static function equalsVariable(first :Variable, second :Variable) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "equalsVariable");
        
        return new Term(first) == second;
    }

    @:op(A==B) static function equalsValue(variable :Variable, constant :Value) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "equalsValue");
        
        return new Term(variable) == constant;
    }

    @:op(A<=B) static function lteExpression(variable :Variable, expression :Expression) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "lteExpression");
        
        return expression >= variable;
    }

    @:op(A<=B) static function lteTerm(variable :Variable, term :Term) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "lteTerm");
        
        return term >= variable;
    }

    @:op(A<=B) static function lteVariable(first :Variable, second :Variable) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "lteVariable");
        
        return new Term(first) <= second;
    }

    @:op(A<=B) static function lteValue(variable :Variable, constant :Value) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "lteValue");
        
        return new Term(variable) <= constant;
    }

    @:op(A>=B) static function gteExpression(variable :Variable, expression :Expression) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "gteExpression");
        
        return expression <= variable;
    }

    @:op(A>=B) static function gteTerm(variable :Variable, term :Term) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "gteTerm");
        
        return term <= variable;
    }

    @:op(A>=B) static function gteVariable(first :Variable, second :Variable) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "gteVariable");
        
        return new Term(first) >= second;
    }

    @:op(A>=B) static function gteValue(variable :Variable, constant :Value) : Constraint
    {
        test.Assert.notTestedSymbolics("Sym_Variable.hx", "gteValue");
        
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