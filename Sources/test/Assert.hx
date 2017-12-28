package test;

import haxe.macro.Expr;

class Assert
{
    public static function lessThanDelta(a :Float, b :Float, delta :Float, ?successMessage :String) : Void
    {
        if(Math.abs(a-b) > delta) {
            throw "lessThanDelta error";
        }
        else {
            if(successMessage != null) {
                trace(successMessage);
            }
        }
    }

    public static function isTrue(b :Bool, ?successMessage :String) : Void
    {
        if(!b) {
            throw "isTrue error";
        }
        else {
            if(successMessage != null) {
                trace(successMessage);
            }
        }
    }

    public static inline function notTested(className :String, funcName :String, shouldThrow :Bool = true) : Void
    {
        if(shouldThrow)
            throw 'Class: $className, Function: $funcName not tested!';
        else {
            count++;
            trace('ID: $count, Class: $className, Function: $funcName');
        }
    }

    public static inline function notTestedSymbolics(className :String, funcName :String) : Void
    {
        // throw 'Class: $className, Function: $funcName not tested!';
    }

    static var count = -1;
}