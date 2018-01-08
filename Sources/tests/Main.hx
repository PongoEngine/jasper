package tests;

import haxe.unit.TestCase;
import haxe.unit.TestRunner;

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
        assertEquals(1, 1);
    }
}