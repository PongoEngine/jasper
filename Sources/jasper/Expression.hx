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

    /**
     *  [Description]
     *  @param cvar - 
     *  @param value - 
     *  @param constant - 
     */
    public function new(cvar :AbstractVariable, value :Value, constant :Constant) : Void
    {
        this.constant = constant;
        this.terms = new HashTable();
        this.externalVariables = new HashSet();
        this.solver = null;
        this.setVariable(cvar, value);
    }

    /**
     *  [Description]
     *  @param constant - 
     *  @param terms - 
     *  @return Expression
     */
    public function initializeFromHash(constant :Constant, terms :HashTable<AbstractVariable, Constant>) : Expression
    {
        this.constant = constant;
        this.terms = terms.clone();
        return this;
    }

    /**
     *  [Description]
     *  @param x - 
     *  @return Expression
     */
    public function multiplyMe(x :Constant) : Expression
    {
        this.constant *= x;
        var t = this.terms;
        t.each(function(clv :AbstractVariable, coeff :Constant) { 
            t.set(clv, coeff * x);
        });

        return this;
    }

    /**
     *  [Description]
     *  @return Expression
     */
    public function clone() : Expression
    {
        var e = Expression.empty();
        e.initializeFromHash(this.constant, this.terms);
        e.solver = this.solver;
        return e;
    }

    /**
     *  [Description]
     *  @param expr - 
     *  @param vari - 
     *  @return Expression
     */
    public function plus(?expr :Expression, ?vari :AbstractVariable)  : Expression
    {
        if (expr != null) {
            return this.clone().addExpression(expr, 1);
        } 
        else if (vari != null) {
            return this.clone().addVariable(vari, 1);
        }
        else {
            throw new Error("Expression.hx", "plus");
        }
    }

    /**
     *  [Description]
     *  @param expr - 
     *  @param vari - 
     *  @return Expression
     */
    public function minus(?expr :Expression, ?vari :AbstractVariable) : Expression
    {
        if (expr != null) {
            return this.clone().addExpression(expr, -1);
        } 
        else if (vari != null) {
            return this.clone().addVariable(vari, -1);
        }
        else {
            throw new Error("Expression.hx", "minus");
        }
    }

    /**
     *  [Description]
     *  @param x - 
     *  @param expr - 
     *  @return Expression
     */
    public function times(?x :Null<Constant>, ?expr :Expression) : Expression
    {
        if (x != null) {
            return (this.clone()).multiplyMe(x);
        } 
        else {
            if (this.isConstant) {
                return expr.times(this.constant);
            } else if (expr.isConstant) {
                return this.times(expr.constant);
            } else {
                throw new NonExpression();
            }
        }
    }

    /**
     *  [Description]
     *  @param x - 
     *  @param expr - 
     *  @return Expression
     */
    public function divide(?x :Null<Constant>, ?expr :Expression) : Expression
    {
        if (x != null) {
            if (C.approx(x, 0)) {
                throw new NonExpression();
            }
            return this.times(new Constant(1) / x);
        } 
        else if (expr != null) {
            if (!expr.isConstant) {
                throw new NonExpression();
            }
            return this.times(new Constant(1) / expr.constant);
        }
        else {
            throw new Error("Expression.hx", "divide");
        }
    }

    public function addExpression(?expr :Dynamic, ?vari :Dynamic, ?n :Dynamic, ?subject :Dynamic) : Expression
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

    public function setVariable(v :AbstractVariable, c :Value) : Expression
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
