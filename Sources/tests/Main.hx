//https://github.com/alexbirkett/kiwi-java/blob/master/src/test/java/no/birkett/kiwi/Tests.java

package tests;

import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import jasper.Solver;
import jasper.Variable;
import jasper.Strength;

class Main
{
    public static function main() : Void
    {
        var runner = new TestRunner();
        runner.add(new BaseTest());
        runner.add(new ConstantVariableTest());
        runner.add(new ExpressionVariableTest());
        runner.add(new VariableConstantTest());
        runner.add(new VariableExpression());
        runner.add(new VariableVariableTest());
        runner.run();
    }
}

class BaseTest extends TestCase
{
    public function testSimpleNew() : Void
    {
        var solver = new Solver();
        var x = new Variable("x");

        solver.addConstraint(x + 2 == 20);
        solver.updateVariables();

        assertEquals(x.m_value, 18);
    }

    public function testSimple0() : Void
    {
        var solver = new Solver();
        var x = new Variable("x");
        var y = new Variable("y");

        solver.addConstraint(x == 20);

        solver.addConstraint(x + 2 == y + 10);

        solver.updateVariables();

        assertEquals(y.m_value, 12);
        assertEquals(x.m_value, 20);
    }

    public function testSimple1() : Void
    {
        var x = new Variable("x");
        var y = new Variable("y");
        var solver = new Solver();
        solver.addConstraint(x == y);
        solver.updateVariables();
        assertEquals(x.m_value, y.m_value);
    }

    public function testCasso1() : Void
    {
        var x = new Variable("x");
        var y = new Variable("y");
        var solver = new Solver();

        solver.addConstraint(x <= y);
        solver.addConstraint(y == x + 3.0);
        solver.addConstraint((x == 10.0) | Strength.WEAK);
        solver.addConstraint((y == 10.0) | Strength.WEAK);

        solver.updateVariables();

        assertEquals(10.0, x.m_value);
        assertEquals(13.0, y.m_value);
    }

    public function testAddDelete1() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();

        solver.addConstraint((x <= 100) | Strength.WEAK);

        solver.updateVariables();
        assertEquals(100.0, x.m_value);

        var c10 = x <= 10.0;
        var c20 = x <= 20.0;

        solver.addConstraint(c10);
        solver.addConstraint(c20);

        solver.updateVariables();

        assertEquals(10.0, x.m_value);

        solver.removeConstraint(c10);

        solver.updateVariables();

        assertEquals(20.0, x.m_value);

        solver.removeConstraint(c20);
        solver.updateVariables();

        assertEquals(100.0, x.m_value);

        var c10again = x <= 10.0;

        solver.addConstraint(c10again);
        solver.addConstraint(c10);
        solver.updateVariables();

        assertEquals(10.0, x.m_value);

        solver.removeConstraint(c10);
        solver.updateVariables();
        assertEquals(10.0, x.m_value);

        solver.removeConstraint(c10again);
        solver.updateVariables();
        assertEquals(100.0, x.m_value);
    }

    public function testAddDelete2() : Void
    {
        var x = new Variable("x");
        var y = new Variable("y");
        var solver = new Solver();

        solver.addConstraint((x == 100) | Strength.WEAK);
        solver.addConstraint((y == 120) | Strength.STRONG);

        var c10 = x <= 10.0;
        var c20 = x <= 20.0;

        solver.addConstraint(c10);
        solver.addConstraint(c20);
        solver.updateVariables();

        assertEquals(10.0, x.m_value);
        assertEquals(120.0, y.m_value);

        solver.removeConstraint(c10);
        solver.updateVariables();

        assertEquals(20.0, x.m_value);
        assertEquals(120.0, y.m_value);

        var cxy = (x * 2.0) == y;
        solver.addConstraint(cxy);
        solver.updateVariables();

        assertEquals(20.0, x.m_value);
        assertEquals(40.0, y.m_value);

        solver.removeConstraint(c20);
        solver.updateVariables();

        assertEquals(60.0, x.m_value);
        assertEquals(120.0, y.m_value);

        solver.removeConstraint(cxy);
        solver.updateVariables();

        assertEquals(100.0, x.m_value);
        assertEquals(120.0, y.m_value);
    }
}