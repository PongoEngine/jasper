package test;

import jasper.Solver;
import jasper.Strength;
import jasper.Value;
import jasper.Variable;
import jasper.Expression;

class Tests 
{

    private static inline var EPSILON = 1.0e-8;

    public static function simpleNew() : Void 
    {
        var solver = new Solver();
        var x = new Variable("x");

        solver.addConstraint(x + 2 == 20);
        solver.updateVariables();

        Assert.lessThanDelta(x.m_value, 18, EPSILON, "simpleNew() PASSED");
    }

    public static function simple0() : Void 
    {
        var solver = new Solver();
        var x = new Variable("x");
        var y = new Variable("y");

        solver.addConstraint(x == 20);
        solver.addConstraint(x + 2 == y + 10);
        solver.updateVariables();

        Assert.lessThanDelta(x.m_value, 20, EPSILON, "simple0() PASSED 1/2");
        Assert.lessThanDelta(y.m_value, 12, EPSILON, "simple0() PASSED 2/2");
    }

    public static function simple1() : Void
    {
        var solver = new Solver();
        var x = new Variable("x");
        var y = new Variable("y");
        solver.addConstraint(x == y);
        solver.updateVariables();

        Assert.lessThanDelta(x.m_value, y.m_value, EPSILON, "simple1() PASSED");
    }

    public static function casso1() : Void
    {
        var x = new Variable("x");
        var y = new Variable("y");
        var solver = new Solver();

        solver.addConstraint(x <= y);
        solver.addConstraint((y == (x + 3.0)));
        solver.addConstraint((x == 10.0) | Strength.WEAK);
        solver.addConstraint((y == 10.0) | Strength.WEAK);

        solver.updateVariables();

        trace(x,y);

        if (Math.abs(x.m_value - 10.0) < EPSILON) {
            Assert.lessThanDelta(10, x.m_value, EPSILON, "casso1() PASSED 1/2");
            Assert.lessThanDelta(13, y.m_value, EPSILON, "casso1() PASSED 2/2");
        } else {
            Assert.lessThanDelta(7, x.m_value, EPSILON, "casso1() PASSED 1/2");
            Assert.lessThanDelta(10, y.m_value, EPSILON, "casso1() PASSED 2/2");
        }
    }

    public static function inconsistent1() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();

        solver.addConstraint((x == 10.0));
        solver.addConstraint((x == 5.0));

        solver.updateVariables();
    }

    public static function inconsistent2() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();

        solver.addConstraint((x >= 10.0));
        solver.addConstraint((x <= 5.0));
        solver.updateVariables();
    }

    public static function inconsistent3() : Void
    {

        var w = new Variable("w");
        var x = new Variable("x");
        var y = new Variable("y");
        var z = new Variable("z");
        var solver = new Solver();

        solver.addConstraint((w >= 10.0));
        solver.addConstraint((x >= w));
        solver.addConstraint((y >= x));
        solver.addConstraint((z >= y));
        solver.addConstraint((z >= 8.0));
        solver.addConstraint((z <= 4.0));
        solver.updateVariables();
    }


    //ConstantVariableTest.hx

    public static function lessThanEqualTo_ConstantVariableTest() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((cast(100, Value) <= x));
        solver.updateVariables();
        Assert.isTrue(100 <= x.m_value);
        solver.addConstraint((x == 110));
        solver.updateVariables();
        Assert.lessThanDelta(x.m_value, 110, EPSILON);
    }

    public static function lessThanEqualToUnsatisfiable_ConstantVariableTest() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((cast(100, Value) <= x));
        solver.updateVariables();
        Assert.isTrue(x.m_value <= 100);
        solver.addConstraint((x == 10));
        solver.updateVariables();
    }

    public static function greaterThanEqualTo_ConstantVariableTest() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((cast(100, Value) >= x));
        solver.updateVariables();
        Assert.isTrue(100 >= x.m_value);
        solver.addConstraint((x == 90));
        solver.updateVariables();
        Assert.lessThanDelta(x.m_value, 90, EPSILON);
    }

    public static function greaterThanEqualToUnsatisfiable_ConstantVariableTest() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((cast(100, Value) >= x));
        solver.updateVariables();
        Assert.isTrue(100 >= x.m_value);
        solver.addConstraint((x == 110));
        solver.updateVariables();
    }

    // ExpressionVariableTest.hx

    public static function lessThanEqualTo_ExpressionVariableTest() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((Expression.fromConstant(100) <= x));
        solver.updateVariables();
        Assert.isTrue(100 <= x.m_value);
        solver.addConstraint((x == 110));
        solver.updateVariables();
        Assert.lessThanDelta(x.m_value, 110, EPSILON);
    }

    public static function lessThanEqualToUnsatisfiable_ExpressionVariableTest() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((Expression.fromConstant(100) <= x));
        solver.updateVariables();
        Assert.isTrue(x.m_value <= 100);
        solver.addConstraint((x == 10));
        solver.updateVariables();
    }

    public static function greaterThanEqualTo_ExpressionVariableTest() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((Expression.fromConstant(100) >= x));
        solver.updateVariables();
        Assert.isTrue(100 >= x.m_value);
        solver.addConstraint((x == 90));
        solver.updateVariables();
        Assert.lessThanDelta(x.m_value, 90, EPSILON);
    }

    public static function greaterThanEqualToUnsatisfiable_ExpressionVariableTest() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((Expression.fromConstant(100) >= x));
        solver.updateVariables();
        Assert.isTrue(100 >= x.m_value);
        solver.addConstraint((x == 110));
        solver.updateVariables();
    }

    // VariableConstantTest.hx

    public static function lessThanEqualTo_VariableConstantTest() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((x <= 100));
        solver.updateVariables();
        Assert.isTrue(x.m_value <= 100);
        solver.addConstraint((x == 90));
        solver.updateVariables();
        Assert.lessThanDelta(x.m_value, 90, EPSILON);
    }

    public static function lessThanEqualToUnsatisfiable_VariableConstantTest() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((x <= 100));
        solver.updateVariables();
        Assert.isTrue(x.m_value <= 100);
        solver.addConstraint((x == 110));
        solver.updateVariables();
    }

    public static function greaterThanEqualTo_VariableConstantTest() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((x >= 100));
        solver.updateVariables();
        Assert.isTrue(x.m_value >= 100);
        solver.addConstraint((x == 110));
        solver.updateVariables();
        Assert.lessThanDelta(x.m_value, 110, EPSILON);
    }

    public static function greaterThanEqualToUnsatisfiable_VariableConstantTest() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((x >= 100));
        solver.updateVariables();
        Assert.isTrue(x.m_value >= 100);
        solver.addConstraint((x == 90));
        solver.updateVariables();
    }

    // VariableExpression.hx

    public static function lessThanEqualTo_VariableExpression() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((x <= Expression.fromConstant(100)));
        solver.updateVariables();
        Assert.isTrue(x.m_value <= 100);
        solver.addConstraint((x == 90));
        solver.updateVariables();
        Assert.lessThanDelta(x.m_value, 90, EPSILON);
    }

    public static function lessThanEqualToUnsatisfiable_VariableExpression() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((x <= Expression.fromConstant(100)));
        solver.updateVariables();
        Assert.isTrue(x.m_value <= 100);
        solver.addConstraint((x == 110));
        solver.updateVariables();
    }

    public static function greaterThanEqualTo_VariableExpression() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((x >= Expression.fromConstant(100)));
        solver.updateVariables();
        Assert.isTrue(x.m_value >= 100);
        solver.addConstraint((x == 110));
        solver.updateVariables();
        Assert.lessThanDelta(x.m_value, 110, EPSILON);
    }

    public static function greaterThanEqualToUnsatisfiable_VariableExpression() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((x >= 100));
        solver.updateVariables();
        Assert.isTrue(x.m_value >= 100);
        solver.addConstraint((x == 90));
        solver.updateVariables();
    }

    // VariableVariableTest.hx

    public static function lessThanEqualTo_VariableVariableTest() : Void 
    {
        var solver = new Solver();

        var x = new Variable("x");
        var y = new Variable("y");

        solver.addConstraint((y == 100));
        solver.addConstraint((x <= y));

        solver.updateVariables();
        Assert.isTrue(x.m_value <= 100);
        solver.addConstraint((x == 90));
        solver.updateVariables();
        Assert.lessThanDelta(x.m_value, 90, EPSILON);
    }

    public static function lessThanEqualToUnsatisfiable_VariableVariableTest() : Void 
    {
        var solver = new Solver();

        var x = new Variable("x");
        var y = new Variable("y");

        solver.addConstraint((y == 100));
        solver.addConstraint((x <= y));

        solver.updateVariables();
        Assert.isTrue(x.m_value <= 100);
        solver.addConstraint((x == 110));
        solver.updateVariables();
    }

    public static function greaterThanEqualTo_VariableVariableTest() : Void 
    {
        var solver = new Solver();

        var x = new Variable("x");
        var y = new Variable("y");

        solver.addConstraint((y == 100));
        solver.addConstraint((x >= y));

        solver.updateVariables();
        Assert.isTrue(x.m_value >= 100);
        solver.addConstraint((x == 110));
        solver.updateVariables();
        Assert.lessThanDelta(x.m_value, 110, EPSILON);
    }

    public static function greaterThanEqualToUnsatisfiable_VariableVariableTest() : Void 
    {
        var solver = new Solver();

        var x = new Variable("x");
        var y = new Variable("y");

        solver.addConstraint((y == 100));

        solver.addConstraint((x >= y));
        solver.updateVariables();
        Assert.isTrue(x.m_value >= 100);
        solver.addConstraint((x == 90));
        solver.updateVariables();
    }
}