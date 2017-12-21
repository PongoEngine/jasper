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

@:notNull
abstract Value(Float) to Float from Float
{
    /**
     *  [Description]
     *  @param val - 
     */
    public inline function new(val :Float) : Void
    {
        this = val;
    }

    /**
     *  [Description]
     *  @return Float
     */
    public function toFloat() : Float
    {
        return this;
    }

    @:op(A / B) public static function divide(a :Value, b :Value) : Value;
    @:op(-A) public static function negate(a :Value) : Value;

    /**
     *  [Description]
     *  @param constant - 
     *  @param expression - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractExpression(constant :Value, expression :Expression) : Expression
    {
        return (-expression) + constant;
    }

    /**
     *  [Description]
     *  @param constant - 
     *  @param term - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractTerm(constant :Value, term :Term) : Expression
    {
        return (-term) + constant;
    }

    /**
     *  [Description]
     *  @param constant - 
     *  @param variable - 
     *  @return Expression
     */
    @:op(A - B) public static function subtractVariable(constant :Value, variable :Variable) : Expression
    {
        return (-variable) + constant;
    }

    /**
     *  [Description]
     *  @param constant - 
     *  @param expression - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToExpression(constant :Value, expression :Expression) : Constraint
    {
        return Expression.fromConstant(constant) <= expression;
    }

    /**
     *  [Description]
     *  @param constant - 
     *  @param term - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToTerm(constant :Value, term :Term) : Constraint
    {
        return constant <= Expression.fromTerm(term);
    }

    /**
     *  [Description]
     *  @param constant - 
     *  @param variable - 
     *  @return Constraint
     */
    @:op(A <= B) public static function lessThanOrEqualToVariable(constant :Value, variable :Variable) : Constraint
    {
        return constant <= Term.fromVariable(variable);
    }

    /**
     *  [Description]
     *  @param constant - 
     *  @param term - 
     *  @return Constraint
     */
    @:op(A >= B) public static function greaterThanOrEqualToTerm(constant :Value, term :Term) : Constraint
    {
        return Expression.fromConstant(constant) >= term;
    }

    /**
     *  [Description]
     *  @param constant - 
     *  @param variable - 
     *  @return Constraint
     */
    @:op(A >= B) public static function greaterThanOrEqualToVariable(constant :Value, variable :Variable) : Constraint
    {
        return constant >= Term.fromVariable(variable);
    }

    // public static function modifyStrength(Constraint constraint, double strength) : Constraint
    // {
    //     return new Constraint(constraint, strength);
    // }

    // public static function modifyStrength(double strength, Constraint constraint) : Constraint
    // {
    //     return modifyStrength(strength, constraint);
    // }
}

class ValueHelper
{
    public static inline function toValue(flt :Float) : Value
    {
        return new Value(flt);
    }
}