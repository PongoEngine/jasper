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

import jasper.Symbolics.Expression;
import jasper.Symbolics.Variable;
import jasper.Symbolics.Term;

/**
 * Created by alex on 30/01/15.
 */
class Constraint 
{
    public var expression :Expression;
    public var strength :Strength;
    public var operator :RelationalOperator;

    /**
     *  [Description]
     *  @param expr - 
     *  @param op - 
     *  @param strength - 
     */
    public function new(expr :Expression, op :RelationalOperator, strength :Strength) : Void
    {
        this.expression = reduce(expr);
        this.operator = op;
        this.strength = Strength.clip(strength);
    }

    /**
     *  [Description]
     *  @param expr - 
     *  @param op - 
     *  @return Constraint
     */
    public static inline function fromExpression(expr :Expression, op :RelationalOperator) : Constraint
    {
        return new Constraint(expr, op, Strength.REQUIRED);
    }

    /**
     *  [Description]
     *  @param other - 
     *  @param strength - 
     *  @return Constraint
     */
    public static inline function fromConstraint(other :Constraint, strength :Strength) : Constraint
    {
        return new Constraint(other.expression, other.operator, strength);
    }

    /**
     *  [Description]
     *  @param expr - 
     *  @return Expression
     */
    private static inline function reduce(expr :Expression) :Expression
    {
        var vars = new Map<Variable, Float>();
        for(term in expr.m_terms){
            var value = vars.get(term.variable);
            if(value == null){
                value = 0.0;
            }
            value += term.coefficient;
            vars.set(term.variable, value);
        }

        var reducedTerms = new List<Term>();
        for(variable in vars.keys()){
            reducedTerms.add(new Term(variable, vars.get(variable)));
        }

        return new Expression(reducedTerms, expr.m_constant);
    }

    /**
     *  [Description]
     *  @param strength - 
     *  @return Constraint
     */
    public function setStrength(strength : Strength) : Constraint
    {
        this.strength = strength;
        return this;
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() : String
    {
        return "expression: (" + expression + ") strength: " + strength + " operator: " + operator;
    }
}

enum RelationalOperator
{
    OP_LE;
    OP_GE;
    OP_EQ;
}