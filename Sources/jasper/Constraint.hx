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

enum ConstraintParams
{
    None;
    ExprRelop(expr :Expression, op :RelationalOperator);
    ExprRelopStrength(expr :Expression, op :RelationalOperator, strength :Float);
    ConstraintStrength(other :Constraint, strength :Float);
}

/**
 * Created by alex on 30/01/15.
 */
class Constraint {

    private var expression :Expression;
    private var strength :Float;
    private var op :RelationalOperator;

    public function new(params :ConstraintParams) : Void
    {
        switch params {
            case None:
            case ExprRelop(expr, op):
                this.expression = expr;
                this.op = op;
                this.strength = Strength.REQUIRED;
                
            case ExprRelopStrength(expr, op, strength):
                this.expression = expr;
                this.op = op;
                this.strength = strength;

            case ConstraintStrength(other, strength):
                this.expression = other.expression;
                this.op = other.op;
                this.strength = strength;
        }
    }

    private static function reduce(expr :Expression) : Expression
    {
        var vars :Map<Variable, Float> = new Map();
        for(term in expr.getTerms()){
            var value = vars.get(term.variable);
            if(value == null){
                value = 0.0;
            }
            value += term.coefficient;
            vars.set(term.variable, value);
        }

        var reducedTerms = new Array<Term>();
        for(variable in vars.keys()){
            reducedTerms.push(new Term(variable, vars.get(variable)));
        }

        return new Expression(TermsConst(reducedTerms, expr.getConstant()));
    }

    public function setStrength(strength :Float) : Constraint
    {
        this.strength = strength;
        return this;
    }

    public function toString() : String
    {
        return "expression: (" + expression + ") strength: " + strength + " operator: " + op;
    }

}
