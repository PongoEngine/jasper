/*
 * Copyright (c) 2017 Jeremy Meltingtallow
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

// FILE: EDU.Washington.grad.gjb.cassowary
// package EDU.Washington.grad.gjb.cassowary;

package jasper;

import jasper.ClLinearExpression;
import jasper.error.ExCLInternalError;

class CL
{
    public static function Plus(e1, e2) : ClLinearExpression
    {
        // if (!(e1 instanceof ClLinearExpression)) {
        //     e1 = new ClLinearExpression(e1);
        // }
        // if (!(e2 instanceof ClLinearExpression)) {
        //     e2 = new ClLinearExpression(e2);
        // }
        // return e1.plus(e2);
        return null;
    }   

    public static function Minus(e1, e2) : ClLinearExpression
    {
        // if (!(e1 instanceof ClLinearExpression)) {
        //     e1 = new ClLinearExpression(e1);
        // }
        // if (!(e2 instanceof ClLinearExpression)) {
        //     e2 = new ClLinearExpression(e2);
        // }
        // return e1.minus(e2);
        return null;
    }

    public static function Times(e1,e2) : ClLinearExpression
    {
        // if (e1 instanceof ClLinearExpression && e2 instanceof ClLinearExpression) {
        //     return e1.times(e2);
        // } 
        // else if (e1 instanceof ClLinearExpression && e2 instanceof ClVariable) {
        //     return e1.times(new ClLinearExpression(e2));
        // }
        // else if (e1 instanceof ClVariable && e2 instanceof ClLinearExpression) {
        //     return (new ClLinearExpression(e1)).times(e2);
        // } 
        // else if (e1 instanceof ClLinearExpression && typeof(e2) == 'number') {
        //     return e1.times(new ClLinearExpression(e2));
        // } 
        // else if (typeof(e1) == 'number' && e2 instanceof ClLinearExpression) {
        //     return (new ClLinearExpression(e1)).times(e2);
        // } 
        // else if (typeof(e1) == 'number' && e2 instanceof ClVariable) {
        //     return (new ClLinearExpression(e2, e1));
        // } 
        // else if (e1 instanceof ClVariable && typeof(e2) == 'number') {
        //     return (new ClLinearExpression(e1, e2));
        // } 
        // else if (e1 instanceof ClVariable && e2 instanceof ClLinearExpression) {
        //     return (new ClLinearExpression(e2, n));
        // }
        return null;
    }

    public static function Divide(e1 :ClLinearExpression, e2 :ClLinearExpression) : ClLinearExpression
    {
        return e1.divide(e2);
    }

    public static function Assert(f :Bool, description :String) : Void
    {
        if (!f) {
            throw new ExCLInternalError("Assertion failed:" + description);
        }
    }

    public static function approx(a :Float, b :Float) :Bool
    {
        var epsilon = 1.0e-8;

        if (a == 0.0) {
            return (Math.abs(b) < epsilon);
        } 
        else if (b == 0.0) {
            return (Math.abs(a) < epsilon);
        } 
        else {
            return (Math.abs(a - b) < Math.abs(a) * epsilon);
        }
    }

    public static inline var GEQ :Int = 1;
    public static inline var LEQ :Int = 2; 
}







