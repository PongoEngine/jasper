// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

package jasper;

//needs expression to be defined
import jasper.Expression;

class C 
{
    public static function plus(e1, e2) : Expression
    {
        e1 = exprFromVarOrValue(e1);
        e2 = exprFromVarOrValue(e2);
        return e1.plus(e2);
    }

    public static function minus(e1, e2) : Expression
    {
        e1 = exprFromVarOrValue(e1);
        e2 = exprFromVarOrValue(e2);
        return e1.minus(e2);
    }

    public static function times(e1, e2) : Expression
    {
        // e1 = exprFromVarOrValue(e1);
        // e2 = exprFromVarOrValue(e2);
        // return e1.times(e2);
        return null;
    }

    public static function divide(e1, e2) : Expression
    {
        e1 = exprFromVarOrValue(e1);
        e2 = exprFromVarOrValue(e2);
        return e1.divide(e2);
    }

    /**
     *  [Description]
     *  @param a - 
     *  @param b - 
     *  @return Bool
     */
    public static function approx(a :jasper.data.Constant, b :Float) : Bool
    {
        var aVal = a.toVal();

        aVal = Math.abs(aVal);
        b = Math.abs(b);
        if (aVal == b) { 
            return true; 
        }

        if (aVal == 0) {
            return (Math.abs(b) < epsilon);
        }

        if (b == 0) {
            return (Math.abs(aVal) < epsilon);
        }

        return (Math.abs(aVal - b) < Math.abs(aVal) * epsilon);
    }

    public static inline var epsilon :Float = 1e-8;

    /**
     *  [Description]
     *  @return Int
     */
    public static function _inc() : Int
    { 
        return _COUNT++; 
    };

    private static function exprFromVarOrValue(v) : Expression
    {
        // if (typeof v == "number" ) {
        //     return c.Expression.fromConstant(v);
        // } else if(v instanceof c.Variable) {
        //     return c.Expression.fromVariable(v);
        // }
        // return v;
        return null;
    }
    private static var _COUNT :Int = 1;
}

@:enum
abstract Constant(Int) {
    var GEQ = 1;
    var LEQ = 2;
}