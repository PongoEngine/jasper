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

import jasper.exception.NonlinearExpressionException;

class Expression_
{

    public var terms :List<Term>;
    public var constant :Float;

    /**
     *  [Description]
     *  @param terms - 
     *  @param constant - 
     */
    public function new(terms :List<Term>, constant :Float) : Void
    {
        this.terms = terms;
        this.constant = constant;
    }

    /**
     *  [Description]
     *  @return Expression
     */
    public static inline function empty() : Expression
    {
        return fromConstant(0);
    }

    /**
     *  [Description]
     *  @param constant - 
     *  @return Expression
     */
    public static inline function fromConstant(constant :Float) : Expression
    {
        return new Expression(new List<Term>(), constant);
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param constant - 
     *  @return Expression
     */
    public static inline function fromTermAndConstant(term :Term, constant :Float) : Expression
    {
        var terms = new List<Term>();
        terms.add(term);
        return new Expression(terms, constant);
    }

    /**
     *  [Description]
     *  @param term - 
     *  @return Expression
     */
    public static inline function fromTerm(term :Term) : Expression
    {
        return fromTermAndConstant(term, 0.0);
    }

    /**
     *  [Description]
     *  @param terms - 
     *  @return Expression
     */
    public static inline function fromTerms(terms :List<Term>) : Expression
    {
        return new Expression(terms, 0.0);
    }

    /**
     *  [Description]
     *  @return Float
     */
    public function getValue() : Float
    {
        var result = constant;

        for (term in terms) {
            result += term.getValue();
        }
        return result;
    }

    /**
     *  [Description]
     *  @return Bool
     */
    public function isConstant() : Bool
    {
        return terms.length == 0;
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() : String
    {
        var sb = "isConstant: " + isConstant() + " constant: " + constant;
        if (!isConstant()) {
            sb += " terms: [";
            for (term in terms) {
                sb += "(";
                sb += term;
                sb += ")";
            }
            sb += "] ";
        }
        return sb;
    }
}

/**
 * Created by alex on 30/01/15.
 */
@:forward
@:forwardStatics
@:notNull
abstract Expression(Expression_) to Expression_
{
    /**
     *  [Description]
     *  @param terms - 
     *  @param constant - 
     */
    public inline function new(terms :List<Term>, constant :Float) : Void
    {
        this = new Expression_(terms, constant);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param coefficient - 
     *  @return Expression
     */
    @:op(A * B) @:commutative public static function multiplyCoefficient(expression :Expression, coefficient :Value) : Expression
    {
        var terms = new List<Term>();

        for (term in expression.terms) {
            terms.add(term * coefficient);
        }

        return new Expression(terms, expression.constant * coefficient.toFloat());
    }

    /**
     *  [Description]
     *  @param expression1 - 
     *  @param expression2 - 
     *  @return Expression
     */
    @:op(A * B) public static function multiplyExpression(expression1 :Expression, expression2 :Expression) : Expression 
    {
        if (expression1.isConstant()) {
            return (new Value(expression1.constant) * expression2);
        } else if (expression2.isConstant()) {
            return (new Value(expression2.constant) * expression1);
        } else {
            throw new NonlinearExpressionException();
        }
    }
    
    /**
     *  [Description]
     *  @param expression - 
     *  @param denominator - 
     *  @return Expression
     */
    @:op(A / B) public static function divideDeniminator(expression :Expression, denominator :Value) : Expression
    {
    	return expression * (new Value(1.0) / denominator);
    }

    /**
     *  [Description]
     *  @param expression1 - 
     *  @param expression2 - 
     *  @return Expression
     */
    @:op(A / B) public static function divideExpression(expression1 :Expression, expression2 :Expression) : Expression
    {
        if (expression2.isConstant()) {
            return expression1 / new Value(expression2.constant);
        } else {
            throw new NonlinearExpressionException();
        }
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @return Expression
     */
    @:op(-A) public static function negate(expression :Expression) : Expression
    {
    	return expression * new Value(-1.0);
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Expression
     */
    @:op(A + B) public static function addExpression(first :Expression, second :Expression) : Expression
    {
        //TODO do we need to copy term objects?
        var terms = new List<Term>();

        for(t in first.terms) {
        	terms.add(t);
        }

        for(t in second.terms) {
        	terms.add(t);
        }

        return new Expression(terms, first.constant + second.constant);
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Expression
     */
    @:op(A + B) @:commutative public static function addTerm(first :Expression, second :Term) : Expression
    {
        //TODO do we need to copy term objects?
        var terms = new List<Term>();

        for(t in first.terms) {
        	terms.add(t);
        }
        terms.add(second);

        return new Expression(terms, first.constant);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param variable - 
     *  @return Expression
     */
    @:op(A + B) @:commutative public static function addVariable(expression :Expression, variable :Variable) : Expression
    {
    	return expression + Term.fromVariable(variable);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param constant - 
     *  @return Expression
     */
    @:op(A + B) @:commutative public static function addConstant(expression :Expression, constant :Value) : Expression
    {
        return new Expression(expression.terms, expression.constant + constant);
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractExpression(first :Expression, second :Expression) : Expression
    {
    	return first + (-second);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param term - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractTerm(expression :Expression, term :Term) : Expression
    {
    	return expression + (-term);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param variable - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractVariable(expression :Expression, variable :Variable) : Expression
    {
    	return expression + (-variable);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param constant - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractConstant(expression :Expression, constant :Value) : Expression
    {
    	return expression + (-constant);
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Constraint
     */
    @:op(A == B) public static function equalsExpression(first :Expression, second :Expression) : Constraint
    {
        return Constraint.fromExpression(first - second, RelationalOperator.OP_EQ);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param term - 
     *  @return Constraint
     */
    @:op(A == B) @:commutative public static function equalsTerm(expression :Expression, term :Term) : Constraint
    {
    	return expression == Expression.fromTerm(term);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param variable - 
     *  @return Constraint
     */
    @:op(A == B) @:commutative public static function equalsVariable(expression :Expression, variable :Variable) : Constraint
    {
    	return expression == Term.fromVariable(variable);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param constant - 
     *  @return Constraint
     */
    @:op(A == B) @:commutative public static function equalsConstant(expression :Expression, constant :Value) : Constraint
    {
    	return expression == Expression.fromConstant(constant);
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToExpression(first :Expression, second :Expression) : Constraint
    {
        return Constraint.fromExpression(first - second, RelationalOperator.OP_LE);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param term - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToTerm(expression :Expression, term :Term) : Constraint
    {
    	return expression <= Expression.fromTerm(term);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param variable - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToVariable(expression :Expression, variable :Variable) : Constraint
    {
    	return expression <= Term.fromVariable(variable);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param constant - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToConstant(expression :Expression, constant :Value) : Constraint
    {
    	return expression <= Expression.fromConstant(constant);
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Constraint
     */
    @:op(A >= B) public static function greaterThanOrEqualToExpression(first :Expression, second :Expression) : Constraint
    {
        return Constraint.fromExpression(first - second, RelationalOperator.OP_GE);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param term - 
     *  @return Constraint
     */
    @:op(A >= B) public static function greaterThanOrEqualToTerm(expression :Expression, term :Term) : Constraint
    {
    	return expression >= Expression.fromTerm(term);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param variable - 
     *  @return Constraint
     */
    @:op(A >= B) public static function greaterThanOrEqualToVariable(expression :Expression, variable :Variable) : Constraint
    {
    	return expression >= Term.fromVariable(variable);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param constant - 
     *  @return Constraint
     */
    @:op(A >= B) public static function greaterThanOrEqualToConstant(expression :Expression, constant :Value) : Constraint
    {
    	return expression >= Expression.fromConstant(constant);
    }
}