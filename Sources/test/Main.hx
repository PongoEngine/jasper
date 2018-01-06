package test;

import test.Tests;

class Main
{
    public static function main() : Void
    {
        Tests.simpleNew();
        Tests.simple0();
        Tests.simple1();
        Tests.casso1();
        // Tests.inconsistent1();
        // Tests.inconsistent2();
        // Tests.inconsistent3();
        Tests.lessThanEqualTo_ConstantVariableTest();
        // Tests.lessThanEqualToUnsatisfiable_ConstantVariableTest();
        Tests.greaterThanEqualTo_ConstantVariableTest();
        // Tests.greaterThanEqualToUnsatisfiable_ConstantVariableTest();
        Tests.lessThanEqualTo_ExpressionVariableTest();
        // Tests.lessThanEqualToUnsatisfiable_ExpressionVariableTest();
        Tests.greaterThanEqualTo_ExpressionVariableTest();
        // Tests.greaterThanEqualToUnsatisfiable_ExpressionVariableTest();
    }
}