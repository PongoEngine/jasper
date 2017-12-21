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


/**
 * Created by alex on 30/01/15.
 */
@:forward
@:forwardStatics
@:notNull
abstract Term(Term_) to Term_
{
    /**
     *  [Description]
     *  @param variable - 
     *  @param coefficient - 
     */
    public function new(variable :Variable, coefficient :Float) : Void
    {
        this = new Term_(variable, coefficient);
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param coefficient - 
     *  @return Term
     */
    @:op(A * B) public static function multiply(term :Term, coefficient :Value) : Term
    {
        return new Term(term.variable, term.coefficient * coefficient.toFloat());
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param denominator - 
     *  @return Term
     */
    @:op(A / B) public static function divide(term :Term, denominator :Value) : Term
    {
        return term * (new Value(1.0)/ denominator);
    }

    /**
     *  [Description]
     *  @param term - 
     *  @return Term
     */
    @:op(-A)public static function negate(term :Term) : Term
    {
        return term * new Value(-1.0);
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Expression
     */
    @:op(A + B) public static function addTerm(first :Term, second :Term) : Expression
    {
        var terms = new List<Term>();
        terms.add(first);
        terms.add(second);
        return Expression.fromTerms(terms);
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param variable - 
     *  @return Expression
     */
    @:op(A + B) @:commutative public static function addVariable(term :Term, variable :Variable) : Expression
    {
        return term + Term.fromVariable(variable);
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param constant - 
     *  @return Expression
     */
    @:op(A + B) @:commutative public static function addConstant(term :Term, constant :Value) : Expression
    {
        return Expression.fromTermAndConstant(term, constant);
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param expression - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractExpression(term :Term, expression :Expression) : Expression
    {
        return (-expression) + term;
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractTerm(first :Term, second :Term) : Expression
    {
        return first + (-second);
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param variable - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractVariable(term :Term, variable :Variable) : Expression
    {
        return term + (-variable);
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param constant - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractConstant(term :Term, constant :Value) : Expression
    {
        return term + (-constant);
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Constraint
     */
    @:op(A == B) public static function equalsTerm(first :Term, second :Term) : Constraint
    {
        return Expression.fromTerm(first) == second;
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param variable - 
     *  @return Constraint
     */
    @:op(A == B) @:commutative public static function equalsVariable(term :Term, variable :Variable) : Constraint
    {
        return Expression.fromTerm(term) == variable;
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param constant - 
     *  @return Constraint
     */
    @:op(A == B) @:commutative public static function equalsConstant(term :Term, constant :Value) : Constraint
    {
        return Expression.fromTerm(term) == constant;
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param expression - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToExpression(term :Term, expression :Expression) : Constraint
    {
        return Expression.fromTerm(term) <= expression;
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToTerm(first :Term, second :Term) : Constraint
    {
        return Expression.fromTerm(first) <= second;
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param variable - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToVariable(term :Term, variable :Variable) : Constraint
    {
        return Expression.fromTerm(term) <= variable;
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param constant - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToConstant(term :Term, constant :Value) : Constraint
    {
        return Expression.fromTerm(term) <= constant;
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param expression - 
     *  @return Constraint
     */
    @:op(A >= B) public static function greaterThanOrEqualToExpression(term :Term, expression :Expression) : Constraint
    {
        return Expression.fromTerm(term) >= expression;
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Constraint
     */
    @:op(A >= B) public static function greaterThanOrEqualToTerm(first :Term, second :Term) : Constraint
    {
        return Expression.fromTerm(first) >= second;
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param variable - 
     *  @return Constraint
     */
    @:op(A >= B) public static function greaterThanOrEqualToVariable(term :Term, variable :Variable) : Constraint
    {
        return Expression.fromTerm(term) >= variable;
    }

    /**
     *  [Description]
     *  @param term - 
     *  @param constant - 
     *  @return Constraint
     */
    @:op(A >= B) public static function greaterThanOrEqualToConstant(term :Term, constant :Value) : Constraint
    {
        return Expression.fromTerm(term) >= constant;
    }
}