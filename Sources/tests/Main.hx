package tests;

import haxe.unit.TestCase;

class Main
{
    public static function main() : Void
    {
        new Test().run();
    }
}

class Test extends TestCase
{
    public function run() : Void
    {
        assertEquals("a", "a");
    }
}