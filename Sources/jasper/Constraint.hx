/*
 * Copyright (c) 2013-2017, Nucleic Development Team.
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Distributed under the terms of the Modified BSD License.
 *  
 * The full license is in the file COPYING.txt, distributed with this software.
*/

package jasper;

class _Constraint_ 
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
    private static function reduce(expr :Expression) :Expression
    {
        var vars = new Map<Variable, Float>();

        for(term in expr.m_terms) {
            if(!vars.exists(term.m_variable))
                vars.set(term.m_variable, 0);
            vars[term.m_variable] += term.m_coefficient;
        }

        var terms = new Array<Term>();
        for(key in vars.keys()) {
            terms.push(new Term(key, vars.get(key)));
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

@:forward
@:forwardStatics
@:notNull
abstract Constraint(_Constraint_) to _Constraint_ from _Constraint_
{
    public function new(expr :Expression, op :RelationalOperator, strength :Strength = Strength.REQUIRED) : Void
    {
        this = new _Constraint_(expr, op, strength);
    }
}