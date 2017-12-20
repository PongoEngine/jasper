package test;

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
}