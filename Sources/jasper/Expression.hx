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

import jasper.impl.Expression_;
import jasper.exception.NonlinearExpressionException;

/**
 * Created by alex on 30/01/15.
 */
@:forward
@:forwardStatics
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
    @:op(A * B) public static function multiplyCoefficient(expression :Expression, coefficient :Value) : Expression
    {

        var terms = new List<Term>();

        for (term in expression.getTerms()) {
            terms.add(term * coefficient);
        }

        return new Expression(terms, expression.getConstant() * coefficient.toFloat());
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
            return (new Value(expression1.getConstant()) * expression2);
        } else if (expression2.isConstant()) {
            return (new Value(expression2.getConstant()) * expression1);
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
            return expression1 / new Value(expression2.getConstant());
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

        for(t in first.getTerms()) {
        	terms.add(t);
        }

        for(t in second.getTerms()) {
        	terms.add(t);
        }

        return new Expression(terms, first.getConstant() + second.getConstant());
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Expression
     */
    @:op(A + B) public static function addTerm(first :Expression, second :Term) : Expression
    {
        //TODO do we need to copy term objects?
        var terms = new List<Term>();

        for(t in first.getTerms()) {
        	terms.add(t);
        }
        terms.add(second);

        return new Expression(terms, first.getConstant());
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param variable - 
     *  @return Expression
     */
    @:op(A + B) public static function addVariable(expression :Expression, variable :Variable) : Expression
    {
    	return expression + Term.fromVariable(variable);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param constant - 
     *  @return Expression
     */
    @:op(A + B) public static function addConstant(expression :Expression, constant :Value) : Expression
    {
        return new Expression(expression.getTerms(), expression.getConstant() + constant);
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
    @:op(A == B) public static function equalsTerm(expression :Expression, term :Term) : Constraint
    {
    	return expression == Expression.fromTerm(term);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param variable - 
     *  @return Constraint
     */
    @:op(A == B) public static function equalsVariable(expression :Expression, variable :Variable) : Constraint
    {
    	return expression == Term.fromVariable(variable);
    }

    /**
     *  [Description]
     *  @param expression - 
     *  @param constant - 
     *  @return Constraint
     */
    @:op(A == B) public static function equalsConstant(expression :Expression, constant :Value) : Constraint
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