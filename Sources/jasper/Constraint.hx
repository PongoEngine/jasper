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

using Lambda;

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
        test.Assert.notTested("Constraint.hx", "reduce", false);
        var vars = new Map<Variable, Float>();

        for(term in expr.m_terms) {
            if(!vars.exists(term.variable))
                vars.set(term.variable, 0);
            vars[term.variable] += term.coefficient;
        }

        var terms = new List<Term>();
        for(key in vars.keys()) {
            terms.add(new Term(key, vars.get(key)));
        }

        return new Expression(terms, expr.m_constant);
    }

    /**
     *  [Description]
     *  @param strength - 
     *  @return Constraint
     */
    public function setStrength(strength : Strength) : Constraint
    {
        test.Assert.notTested("Constraint.hx", "setStrength");
        
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