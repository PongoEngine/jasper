/*
 * Copyright (c) 2013-2017, Nucleic Development Team.
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Distributed under the terms of the Modified BSD License.
 *  
 *  The full license is in the file COPYING.txt, distributed with this software.
*/

package jasper;

import jasper.Symbolics.Expression;
import jasper.Symbolics.Variable;
import jasper.Symbolics.Term;

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