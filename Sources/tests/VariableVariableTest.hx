//https://github.com/alexbirkett/kiwi-java/blob/master/src/test/java/no/birkett/kiwi/Tests.java

package tests;

import jasper.*;

import haxe.unit.TestCase;

class VariableVariableTest extends TestCase
{
    public function testLessThanEqualTo() : Void
    {
        var solver = new Solver();

        var x = new Variable("x");
        var y = new Variable("y");

        solver.addConstraint(y == 100);
        solver.addConstraint(x <= y);

        solver.updateVariables();
        assertTrue(x.m_value <= 100);
        solver.addConstraint(x == 90);
        solver.updateVariables();
        assertEquals(x.m_value, 90);
    }

    public function testGreaterThanEqualTo() : Void
    {
        var solver = new Solver();

        var x = new Variable("x");
        var y = new Variable("y");

        solver.addConstraint(y == 100);
        solver.addConstraint(x >= y);

        solver.updateVariables();
        assertTrue(x.m_value >= 100);
        solver.addConstraint(x == 110);
        solver.updateVariables();
        assertEquals(x.m_value, 110);
    }
}