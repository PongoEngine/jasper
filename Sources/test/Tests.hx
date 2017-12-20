package test;

import jasper.Solver;
import jasper.Variable;
import jasper.Value;
import jasper.Strength;
import jasper.Expression;
import jasper.Constraint;

using jasper.Value.ValueHelper;

class Tests 
{

    private static inline var EPSILON = 1.0e-8;

    public static function simpleNew() : Void 
    {
        var solver = new Solver();
        var x = new Variable("x");

        solver.addConstraint((2 + x) == 20);
        solver.updateVariables();

        Assert.lessThanDelta(x.getValue(), 18, EPSILON, "simpleNew() PASSED");
    }

    public static function simple0() : Void 
    {
        var solver = new Solver();
        var x = new Variable("x");
        var y = new Variable("y");

        solver.addConstraint(x == 20);
        solver.addConstraint(x + 2 == y + 10);
        solver.updateVariables();

        Assert.lessThanDelta(x.getValue(), 20, EPSILON, "simple0() PASSED 1/2");
        Assert.lessThanDelta(y.getValue(), 12, EPSILON, "simple0() PASSED 2/2");
    }

    public static function simple1() : Void
    {
        var solver = new Solver();
        var x = new Variable("x");
        var y = new Variable("y");
        solver.addConstraint(x == y);
        solver.updateVariables();

        Assert.lessThanDelta(x.getValue(), y.getValue(), EPSILON, "simple1() PASSED");
    }

    public static function casso1() : Void
    {
        var x = new Variable("x");
        var y = new Variable("y");
        var solver = new Solver();

        solver.addConstraint(x <= y);
        solver.addConstraint((y == (x + 3.0)));
        solver.addConstraint((x == 10.0).setStrength(Strength.WEAK));
        solver.addConstraint((y == 10.0).setStrength(Strength.WEAK));

        solver.updateVariables();

        if (Math.abs(x.getValue() - 10.0) < EPSILON) {
            Assert.lessThanDelta(10, x.getValue(), EPSILON, "casso1() PASSED 1/2");
            Assert.lessThanDelta(13, y.getValue(), EPSILON, "casso1() PASSED 2/2");
        } else {
            Assert.lessThanDelta(7, x.getValue(), EPSILON, "casso1() PASSED 1/2");
            Assert.lessThanDelta(10, y.getValue(), EPSILON, "casso1() PASSED 2/2");
        }
    }

    public static function addDelete1() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();

        solver.addConstraint((x <= 100).setStrength(Strength.WEAK));

        solver.updateVariables();
        Assert.lessThanDelta(100, x.getValue(), EPSILON);

        var c10 :Constraint = (x <= 10.0);
        var c20 :Constraint = (x <= 20.0);

        solver.addConstraint(c10);
        solver.addConstraint(c20);

        solver.updateVariables();

        Assert.lessThanDelta(10, x.getValue(), EPSILON);

        solver.removeConstraint(c10);

        solver.updateVariables();

        Assert.lessThanDelta(20, x.getValue(), EPSILON);

        solver.removeConstraint(c20);
        solver.updateVariables();

        Assert.lessThanDelta(100, x.getValue(), EPSILON);

        var c10again :Constraint = (x <= 10.0);

        solver.addConstraint(c10again);
        solver.addConstraint(c10);
        solver.updateVariables();

        Assert.lessThanDelta(10, x.getValue(), EPSILON);

        solver.removeConstraint(c10);
        solver.updateVariables();
        Assert.lessThanDelta(10, x.getValue(), EPSILON);

        solver.removeConstraint(c10again);
        solver.updateVariables();
        Assert.lessThanDelta(100, x.getValue(), EPSILON);
    }

    public static function addDelete2() : Void
    {
        var x = new Variable("x");
        var y = new Variable("y");
        var solver = new Solver();

        solver.addConstraint((x == 100).setStrength(Strength.WEAK));
        solver.addConstraint((y == 120).setStrength(Strength.STRONG));

        var c10 :Constraint = (x <= 10.0);
        var c20 :Constraint = (x <= 20.0);

        solver.addConstraint(c10);
        solver.addConstraint(c20);
        solver.updateVariables();

        Assert.lessThanDelta(10, x.getValue(), EPSILON);
        Assert.lessThanDelta(120, y.getValue(), EPSILON);

        solver.removeConstraint(c10);
        solver.updateVariables();

        Assert.lessThanDelta(20, x.getValue(), EPSILON);
        Assert.lessThanDelta(120, y.getValue(), EPSILON);

        var cxy :Constraint = ((x * 2.0) == y);
        solver.addConstraint(cxy);
        solver.updateVariables();

        Assert.lessThanDelta(20, x.getValue(), EPSILON);
        Assert.lessThanDelta(40, y.getValue(), EPSILON);

        solver.removeConstraint(c20);
        solver.updateVariables();

        Assert.lessThanDelta(60, x.getValue(), EPSILON);
        Assert.lessThanDelta(120, y.getValue(), EPSILON);

        solver.removeConstraint(cxy);
        solver.updateVariables();

        Assert.lessThanDelta(100, x.getValue(), EPSILON);
        Assert.lessThanDelta(120, y.getValue(), EPSILON);
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
        solver.addConstraint((100.toValue() <= x));
        solver.updateVariables();
        Assert.isTrue(100 <= x.getValue());
        solver.addConstraint((x == 110));
        solver.updateVariables();
        Assert.lessThanDelta(x.getValue(), 110, EPSILON);
    }

    public static function lessThanEqualToUnsatisfiable_ConstantVariableTest() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((100.toValue() <= x));
        solver.updateVariables();
        Assert.isTrue(x.getValue() <= 100);
        solver.addConstraint((x == 10));
        solver.updateVariables();
    }

    public static function greaterThanEqualTo_ConstantVariableTest() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((100.toValue() >= x));
        solver.updateVariables();
        Assert.isTrue(100 >= x.getValue());
        solver.addConstraint((x == 90));
        solver.updateVariables();
        Assert.lessThanDelta(x.getValue(), 90, EPSILON);
    }

    public static function greaterThanEqualToUnsatisfiable_ConstantVariableTest() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((100.toValue() >= x));
        solver.updateVariables();
        Assert.isTrue(100 >= x.getValue());
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
        Assert.isTrue(100 <= x.getValue());
        solver.addConstraint((x == 110));
        solver.updateVariables();
        Assert.lessThanDelta(x.getValue(), 110, EPSILON);
    }

    public static function lessThanEqualToUnsatisfiable_ExpressionVariableTest() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((Expression.fromConstant(100) <= x));
        solver.updateVariables();
        Assert.isTrue(x.getValue() <= 100);
        solver.addConstraint((x == 10));
        solver.updateVariables();
    }

    public static function greaterThanEqualTo_ExpressionVariableTest() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((Expression.fromConstant(100) >= x));
        solver.updateVariables();
        Assert.isTrue(100 >= x.getValue());
        solver.addConstraint((x == 90));
        solver.updateVariables();
        Assert.lessThanDelta(x.getValue(), 90, EPSILON);
    }

    public static function greaterThanEqualToUnsatisfiable_ExpressionVariableTest() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((Expression.fromConstant(100) >= x));
        solver.updateVariables();
        Assert.isTrue(100 >= x.getValue());
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
        Assert.isTrue(x.getValue() <= 100);
        solver.addConstraint((x == 90));
        solver.updateVariables();
        Assert.lessThanDelta(x.getValue(), 90, EPSILON);
    }

    public static function lessThanEqualToUnsatisfiable_VariableConstantTest() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((x <= 100));
        solver.updateVariables();
        Assert.isTrue(x.getValue() <= 100);
        solver.addConstraint((x == 110));
        solver.updateVariables();
    }

    public static function greaterThanEqualTo_VariableConstantTest() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((x >= 100));
        solver.updateVariables();
        Assert.isTrue(x.getValue() >= 100);
        solver.addConstraint((x == 110));
        solver.updateVariables();
        Assert.lessThanDelta(x.getValue(), 110, EPSILON);
    }

    public static function greaterThanEqualToUnsatisfiable_VariableConstantTest() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((x >= 100));
        solver.updateVariables();
        Assert.isTrue(x.getValue() >= 100);
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
        Assert.isTrue(x.getValue() <= 100);
        solver.addConstraint((x == 90));
        solver.updateVariables();
        Assert.lessThanDelta(x.getValue(), 90, EPSILON);
    }

    public static function lessThanEqualToUnsatisfiable_VariableExpression() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((x <= Expression.fromConstant(100)));
        solver.updateVariables();
        Assert.isTrue(x.getValue() <= 100);
        solver.addConstraint((x == 110));
        solver.updateVariables();
    }

    public static function greaterThanEqualTo_VariableExpression() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((x >= Expression.fromConstant(100)));
        solver.updateVariables();
        Assert.isTrue(x.getValue() >= 100);
        solver.addConstraint((x == 110));
        solver.updateVariables();
        Assert.lessThanDelta(x.getValue(), 110, EPSILON);
    }

    public static function greaterThanEqualToUnsatisfiable_VariableExpression() : Void 
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint((x >= 100));
        solver.updateVariables();
        Assert.isTrue(x.getValue() >= 100);
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
        Assert.isTrue(x.getValue() <= 100);
        solver.addConstraint((x == 90));
        solver.updateVariables();
        Assert.lessThanDelta(x.getValue(), 90, EPSILON);
    }

    public static function lessThanEqualToUnsatisfiable_VariableVariableTest() : Void 
    {
        var solver = new Solver();

        var x = new Variable("x");
        var y = new Variable("y");

        solver.addConstraint((y == 100));
        solver.addConstraint((x <= y));

        solver.updateVariables();
        Assert.isTrue(x.getValue() <= 100);
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
        Assert.isTrue(x.getValue() >= 100);
        solver.addConstraint((x == 110));
        solver.updateVariables();
        Assert.lessThanDelta(x.getValue(), 110, EPSILON);
    }

    public static function greaterThanEqualToUnsatisfiable_VariableVariableTest() : Void 
    {
        var solver = new Solver();

        var x = new Variable("x");
        var y = new Variable("y");

        solver.addConstraint((y == 100));

        solver.addConstraint((x >= y));
        solver.updateVariables();
        Assert.isTrue(x.getValue() >= 100);
        solver.addConstraint((x == 90));
        solver.updateVariables();
    }
}