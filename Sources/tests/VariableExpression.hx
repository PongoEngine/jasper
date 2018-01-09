//https://github.com/alexbirkett/kiwi-java/blob/master/src/test/java/no/birkett/kiwi/Tests.java

package tests;

import jasper.*;

import haxe.unit.TestCase;

class VariableExpression extends TestCase
{
	public function testLessThanEqualTo() : Void
	{
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint(x <= new Expression([], 100));
        solver.updateVariables();
        assertTrue(x.m_value <= 100);
        solver.addConstraint(x == 90);
        solver.updateVariables();
        assertEquals(x.m_value, 90);
    }

    public function testGreaterThanEqualTo() : Void
    {
        var x = new Variable("x");
        var solver = new Solver();
        solver.addConstraint(x >= new Expression([], 100));
        solver.updateVariables();
        assertTrue(x.m_value >= 100);
        solver.addConstraint(x == 110);
        solver.updateVariables();
        assertEquals(x.m_value, 110);
    }
}