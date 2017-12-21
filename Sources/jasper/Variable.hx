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

class Variable_
{
    public var name (default, null):String;
    public var value :Float;

    /**
     *  [Description]
     *  @param name - 
     */
    public function new(name :String) : Void
    {
        this.name = name;
        this.value = 0.0;
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() : String
    {
        return "name: " + name + " value: " + value;
    }
}


/**
 * Created by alex on 30/01/15.
 */
@:forward
@:notNull
abstract Variable(Variable_) to Variable_
{
    /**
     *  [Description]
     *  @param name - 
     */
    public inline function new(name :String) : Void
    {
        this = new Variable_(name);
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @param coefficient - 
     *  @return Term
     */
    @:op(A * B) @:commutative public static function multiply(variable :Variable, coefficient :Value) : Term
    {
        return new Term(variable, coefficient);
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @param denominator - 
     *  @return Term
     */
    @:op(A / B) public static function divide(variable :Variable, denominator :Value) : Term
    {
        return variable * (new Value(1.0) / denominator);
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @return Term
     */
    @:op(-A) public static function negate(variable :Variable) : Term
    {
        return variable * new Value(-1.0);
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Expression
     */
    @:op(A + B) public static function addVariable(first :Variable, second :Variable) : Expression
    {
        return Term.fromVariable(first) + second;
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @param constant - 
     *  @return Expression
     */
    @:op(A + B) @:commutative public static function addConstant(variable :Variable, constant :Value) : Expression
    {
        return Term.fromVariable(variable) + constant;
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @param expression - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractExpression(variable :Variable, expression :Expression) : Expression
    {
        return variable + (-expression);
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @param term - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractTerm(variable :Variable, term :Term) : Expression
    {
        return variable + (-term);
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractVariable(first :Variable, second :Variable) : Expression
    {
        return first + (-second);
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @param constant - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractConstant(variable :Variable, constant :Value) : Expression
    {
        return variable + (-constant);
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Constraint
     */
    @:op(A == B) public static function equalsVariable(first :Variable, second :Variable) : Constraint
    {
        return Term.fromVariable(first) == second;
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @param constant - 
     *  @return Constraint
     */
    @:op(A == B) @:commutative public static function equalsConstant(variable :Variable, constant :Value) : Constraint
    {
        return Term.fromVariable(variable) == constant;
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @param expression - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToExpression(variable :Variable, expression :Expression) : Constraint
    {
        return Term.fromVariable(variable) <= expression;
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @param term - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToTerm(variable :Variable, term :Term) : Constraint
    {
        return Term.fromVariable(variable) <= term;
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToVariable(first :Variable, second :Variable) : Constraint
    {
        return Term.fromVariable(first) <= second;
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @param constant - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToConstant(variable :Variable, constant :Value) : Constraint
    {
        return Term.fromVariable(variable) <= constant;
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @param expression - 
     *  @return Constraint
     */
    @:op(A >= B) public static function greaterThanOrEqualToExpression(variable :Variable, expression :Expression) : Constraint
    {
        return Term.fromVariable(variable) >= expression;
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @param term - 
     *  @return Constraint
     */
    @:op(A >= B) public static function greaterThanOrEqualToTerm(variable :Variable, term :Term) : Constraint
    {
        return term >= variable;
    }

    /**
     *  [Description]
     *  @param first - 
     *  @param second - 
     *  @return Constraint
     */
    @:op(A >= B) public static function greaterThanOrEqualToVariable(first :Variable, second :Variable) : Constraint
    {
        return Term.fromVariable(first) >= second;
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @param constant - 
     *  @return Constraint
     */
    @:op(A >= B) public static function greaterThanOrEqualToConstant(variable :Variable, constant :Value) : Constraint
    {
        return Term.fromVariable(variable) >= constant;
    }
}