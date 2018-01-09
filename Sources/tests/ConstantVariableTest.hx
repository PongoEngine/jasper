//https://github.com/alexbirkett/kiwi-java/blob/master/src/test/java/no/birkett/kiwi/Tests.java

package tests;

import jasper.*;

import haxe.unit.TestCase;

class ConstantVariableTest extends TestCase
{
    public function testLessThanEqualTo() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint(cast(100, Value) <= x);
        solver.updateVariables();
        assertTrue(100.0 <= x.m_value);
        solver.addConstraint(x == 110);
        solver.updateVariables();
        assertEquals(x.m_value, 110);
    }

    public function testGreaterThanEqualTo() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint(cast(100, Value) >= x);
        solver.updateVariables();
        assertTrue(100.0 >= x.m_value);
        solver.addConstraint(x == 90);
        solver.updateVariables();
        assertEquals(x.m_value, 90);
    }
}