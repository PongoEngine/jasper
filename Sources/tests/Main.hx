package tests;

import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import jasper.Solver;
import jasper.Variable;

class Main
{
    public static function main() : Void
    {
        var runner = new TestRunner();
        runner.add(new BaseTest());
        runner.run();
    }
}

class BaseTest extends TestCase
{
    public function testJasper() : Void
    {
        var solver = new Solver();
        var x = new Variable("x");

        solver.addConstraint(x + 2 == 20);
        solver.updateVariables();

        assertEquals(x.m_value, 18);
    }
}