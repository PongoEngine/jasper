// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

package jasper;

import jasper.HashTable;
import jasper.HashSet;
import jasper.SimplexSolver;
import jasper.variable.AbstractVariable;
import jasper.error.NonExpression;
import jasper.error.InternalError;
import jasper.error.Error;
import jasper.C;
import jasper.data.Constant;
import jasper.data.Value;

class Expression
{
    public var constant :Constant;
    public var terms :HashTable<AbstractVariable, Constant>;
    public var externalVariables :HashSet<AbstractVariable>;
    public var solver :SimplexSolver;
    public var isConstant (get, null) : Bool;

    public function new(cvar :AbstractVariable, value :Value, constant :Constant) : Void
    {
    }

    public function initializeFromHash(constant :Constant, terms :HashTable<AbstractVariable, Constant>) : Expression
    {
        return null;
    }

    public function multiplyMe(x :Constant) : Expression
    {
        return null;
    }

    public function clone() : Expression
    {
        return null;
    }

    public function times(?x :Null<Constant>, ?expr :Expression) : Expression
    {
        return null;
    }

    public function plus(?expr :Expression, ?vari :AbstractVariable)  : Expression
    {
        return null;
    }

    public function minus(?expr :Expression, ?vari :AbstractVariable) : Expression
    {
        return null;
    }

    public function divide(?x :Constant, ?expr :Expression) : Expression
    {
        return null;
    }

    public function addExpression(?expr :Expression, ?vari :AbstractVariable, ?n :Constant, ?subject :AbstractVariable) : Expression
    {
        return null;
    }

    public function addVariable(v :AbstractVariable, ?cd :Constant, ?subject) : Expression
    {
        return null;
    }

    private function _updateIfExternal(v :AbstractVariable) : Void
    {
    }

    public function setVariable(v :AbstractVariable, c :Constant) : Expression
    {
        return null;
    }

    public function anyPivotableVariable() : Dynamic
    {
        return null;
    }

    public function substituteOut(outvar  /*c.AbstractVariable*/, expr /*c.Expression*/, subject /*c.AbstractVariable*/) : Void
    {
    }

    public function changeSubject (old_subject /*c.AbstractVariable*/, new_subject /*c.AbstractVariable*/) : Void
    {
    }

    public function newSubject (subject /*c.AbstractVariable*/) 
    {
    }

    public function coefficientFor (clv /*c.AbstractVariable*/) 
    {
    }

    private function get_isConstant() : Bool
    {
        return false;
    }

    public function toString() : String
    {
        return "";
    }

    public function equals(other) : Bool
    {
        return false;
    }

    public function Plus(e1 :Expression, e2 :Expression) : Expression
    {
        return e1.plus(e2);
    }

    public function Minus(e1 :Expression, e2 :Expression) : Expression
    {
        return e1.minus(e2);
    }

    public function Times(e1 :Expression, e2 :Expression) : Expression
    {
        return e1.times(e2);
    }

    public function Divide(e1 :Expression, e2 :Expression) : Expression
    {
        return e1.divide(e2);
    }


    public static function empty(?solver :SimplexSolver) : Expression
    {
        return null;
    }

    public static function fromConstant(constant :Float, ?solver :SimplexSolver) : Expression
    {
        return null;
    }

    public static function fromValue(value :Value, ?solver :SimplexSolver) : Expression
    {
        return null;
    }

    public static function fromVariable(cvar :AbstractVariable, ?solver :SimplexSolver) : Expression
    {
        return null;
    }

}
