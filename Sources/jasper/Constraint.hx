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

/**
 * Created by alex on 30/01/15.
 */
class Constraint 
{

    private var _expression :Expression;
    private var _strength :Float;
    private var _op :RelationalOperator;

    public function new(expr :Expression, op :RelationalOperator, strength :Float) : Void
    {
        _expression = reduce(expr);
        _op = op;
        _strength = Strength.clip(strength);
    }

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
    public static inline function fromConstraint(other :Constraint, strength :Float) : Constraint
    {
        return new Constraint(other._expression, other._op, strength);
    }

    /**
     *  [Description]
     *  @param expr - 
     *  @return Expression
     */
    private static inline function reduce(expr :Expression) :Expression
    {
        var vars = new Map<Variable, Float>();
        for(term in expr.getTerms()){
            var value = vars.get(term.getVariable());
            if(value == null){
                value = 0.0;
            }
            value += term.getCoefficient();
            vars.set(term.getVariable(), value);
        }

        var reducedTerms = new List<Term>();
        for(variable in vars.keys()){
            reducedTerms.add(new Term(variable, vars.get(variable)));
        }

        return new Expression(reducedTerms, expr.getConstant());
    }

    /**
     *  [Description]
     *  @return Expression
     */
    public function getExpression() : Expression
    {
        return _expression;
    }

    /**
     *  [Description]
     *  @param expression - 
     */
    public function setExpression(expression :Expression) : Void
    {
        _expression = expression;
    }

    /**
     *  [Description]
     *  @return Float
     */
    public function getStrength() : Float
    {
        return _strength;
    }

    /**
     *  [Description]
     *  @param strength - 
     *  @return Constraint
     */
    public function setStrength(strength : Float) : Constraint
    {
        _strength = strength;
        return this;
    }

    /**
     *  [Description]
     *  @return RelationalOperator
     */
    public function getOp() : RelationalOperator
    {
        return _op;
    }

    /**
     *  [Description]
     *  @param op - 
     */
    public function setOp(op :RelationalOperator) : Void
    {
        _op = op;
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() : String
    {
        return "expression: (" + _expression + ") strength: " + _strength + " operator: " + _op;
    }
}
