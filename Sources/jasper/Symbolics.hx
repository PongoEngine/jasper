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
abstract Expression(jasper._Expression_)
{
    public inline function new(terms :List<Term>, constant :Float) : Void
    {
        this = new jasper._Expression_(terms, constant);
    }

    @:op(A*B) static function multiplyValue(expression :Expression, coefficient :Value) : Expression
    {
        // std::vector<Term> terms;
        // terms.reserve( expression.terms().size() );
        // typedef std::vector<Term>::const_iterator iter_t;
        // iter_t begin = expression.terms().begin();
        // iter_t end = expression.terms().end();
        // for( iter_t it = begin; it != end; ++it )
        //     terms.push_back( ( *it ) * coefficient );
        // return Expression( terms, expression.constant() * coefficient );

        var terms = new List<Term>();

        for (term in expression.terms) {
            terms.add(term * coefficient);
        }

        return new Expression(terms, expression.constant * coefficient);
    }

    @:op(A/B) static function divideValue(expression :Expression, denominator :Value) : Expression
    {
        return expression * ( 1.0 / denominator );
    }

    @:op(-A) static function negateExpression(expression :Expression) : Expression
    {
        return expression * -1.0;
    }

    @:op(A+B) static function addExpression(first :Expression, second :Expression) : Expression
    {
        // std::vector<Term> terms;
        // terms.reserve( first.terms().size() + second.terms().size() );
        // terms.insert( terms.begin(), first.terms().begin(), first.terms().end() );
        // terms.insert( terms.end(), second.terms().begin(), second.terms().end() );
        // return Expression( terms, first.constant() + second.constant() );

        var terms = new List<Term>();

        for(t in first.terms) terms.add(t);
        for(t in second.terms) terms.add(t);

        return new Expression(terms, first.constant + second.constant);
    }

    @:op(A+B) static function addTerm(first :Expression, second :Term) : Expression
    {
        // std::vector<Term> terms;
        // terms.reserve( first.terms().size() + 1 );
        // terms.insert( terms.begin(), first.terms().begin(), first.terms().end() );
        // terms.push_back( second );
        // return Expression( terms, first.constant() );

        var terms = new List<Term>();
        for(t in first.terms) terms.add(t);
        terms.add(second);
        return new Expression(terms, first.constant);
    }

    @:op(A+B) static function addVariable(expression :Expression, variable :Variable) : Expression
    {
        return expression + Term.fromVariable(variable);
    }

    @:op(A+B) static function addValue(expression :Expression, constant :Value) : Expression
    {
        return new Expression( expression.terms, expression.constant + constant );
    }

    @:op(A-B) static function subtractExpression(first :Expression, second :Expression) : Expression
    {
        return first + -second;
    }

    @:op(A-B) static function subtractTerm(expression :Expression, term :Term) : Expression
    {
        return expression + -term;
    }

    @:op(A-B) static function subtractVariable(expression :Expression, variable :Variable) : Expression
    {
        return expression + -variable;
    }

    @:op(A-B) static function subtractValue(expression :Expression, constant :Value) : Expression
    {
        return expression + -constant;
    }

    @:op(A==B) static function equalsExpression(first :Expression, second :Expression) : Constraint
    {
        return Constraint.fromExpression( first - second, OP_EQ );
    }

    @:op(A==B) static function equalsTerm(expression :Expression, term :Term) : Constraint
    {
        return expression == Expression.fromTerm(term);
    }

    @:op(A==B) static function equalsVariable(expression :Expression, variable :Variable) : Constraint
    {
        return expression == Term.fromVariable(variable);
    }

    @:op(A==B) static function equalsValue(expression :Expression, constant :Value) : Constraint
    {
        return expression == Expression.fromConstant(constant);
    }

    @:op(A<=B) static function lteExpression(first :Expression, second :Expression) : Constraint
    {
        return Constraint.fromExpression( first - second, OP_LE );
    }

    @:op(A<=B) static function lteTerm(expression :Expression, term :Term) : Constraint
    {
        return expression <= Expression.fromTerm(term);
    }

    @:op(A<=B) static function lteVariable(expression :Expression, variable :Variable) : Constraint
    {
        return expression <= Term.fromVariable(variable);
    }

    @:op(A<=B) static function lteValue(expression :Expression, constant :Value) : Constraint
    {
        return expression <= Expression.fromConstant(constant);
    }

    @:op(A>=B) static function gteExpression(first :Expression, second :Expression) : Constraint
    {
        return Constraint.fromExpression( first - second, OP_GE );
    }

    @:op(A>=B) static function gteTerm(expression :Expression, term :Term) : Constraint
    {
        return expression >= Expression.fromTerm(term);
    }

    @:op(A>=B) static function gteVariable(expression :Expression, variable :Variable) : Constraint
    {
        return expression >= Term.fromVariable(variable);
    }

    @:op(A>=B) static function gteValue(expression :Expression, constant :Value) : Constraint
    {
        return expression >= Expression.fromConstant(constant);
    }
}

//*********************************************************************************************************


@:forward
@:forwardStatics
@:notNull
abstract Term(jasper._Term_)
{
    public inline function new(variable :Variable, coefficient :Float) : Void
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
        // std::vector<Term> terms;
        // terms.reserve( 2 );
        // terms.push_back( first );
        // terms.push_back( second );
        // return Expression( terms );

        var terms = new List<Term>();
        terms.add(first);
        terms.add(second);

        return Expression.fromTerms(terms);
    }

    @:op(A+B) static function addVariable(term :Term, variable :Variable) : Expression
    {
        return term + Term.fromVariable( variable );
    }

    @:op(A+B) static function addValue(term :Term, constant :Value) : Expression
    {
        return Expression.fromTermAndConstant( term, constant );
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
        return Term.fromVariable(first) + second;
    }

    @:op(A+B) static function addValue(variable :Variable, constant :Value) : Expression
    {
        return Term.fromVariable(variable) + constant;
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
        return Term.fromVariable(first) == second;
    }

    @:op(A==B) static function equalsValue(variable :Variable, constant :Value) : Constraint
    {
        return Term.fromVariable(variable) == constant;
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
        return Term.fromVariable(first) <= second;
    }

    @:op(A<=B) static function lteValue(variable :Variable, constant :Value) : Constraint
    {
        return Term.fromVariable(variable) <= constant;
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
        return Term.fromVariable(first) >= second;
    }

    @:op(A>=B) static function gteValue(variable :Variable, constant :Value) : Constraint
    {
        return Term.fromVariable(variable) >= constant;
    }
}

//================================================================================================
//================================================================================================
//================================================================================================
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