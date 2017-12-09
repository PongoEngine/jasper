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
    public var solver :SimplexSolver = null;
    public var isConstant (get, null) : Bool;

    /**
     *  [Description]
     *  @param cvar - 
     *  @param value - 
     *  @param constant - 
     */
    public function new(?cvar :AbstractVariable, ?value :Value, constant :Constant) : Void
    {
        this.constant = constant;
        this.terms = new HashTable();
        this.externalVariables = new HashSet();

        if(cvar != null) {
            this.setVariable(cvar, value);
        }
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
            return this.clone().addExpression(expr, new Constant(1));
        } 
        else if (vari != null) {
            return this.clone().addVariable(vari, new Constant(1));
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
            return this.clone().addExpression(expr, new Constant(-1));
        } 
        else if (vari != null) {
            return this.clone().addVariable(vari, new Constant(-1));
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

    public function addExpression(expr :Expression, n :Constant, ?subject :AbstractVariable) : Expression
    {
        this.constant += (n * expr.constant);
        expr.terms.each(function(clv, coeff) {
            this.addVariable(clv, coeff * n, subject);
            this._updateIfExternal(clv);
        });
        return this;
    }

    //determine setVariable first
    public function addVariable(v :AbstractVariable, cd :Constant, ?subject :AbstractVariable) : Expression
    {
        return this;
    }

    /**
     *  [Description]
     *  @param v - 
     */
    private function _updateIfExternal(v :AbstractVariable) : Void
    {
        if (v.isExternal) {
            this.externalVariables.add(v);
            if (this.solver != null) {
                // this.solver._noteUpdatedExternal(v);
            }
        }
    }

    public function setVariable(variable :AbstractVariable, value :Value) : Expression
    {
        this.terms.set(variable, value.toConstant());
        this._updateIfExternal(variable);
        return this;
    }

    //type more then come back
    public function anyPivotableVariable() : Dynamic
    {
        return null;
    }

    //type more then come back
    public function substituteOut(outvar :AbstractVariable, expr :Expression, subject :AbstractVariable) : Void
    {
    }

    /**
     *  [Description]
     *  @param old_subject - 
     *  @param new_subject - 
     */
    public function changeSubject (old_subject :AbstractVariable, new_subject :AbstractVariable) : Void
    {
        this.setVariable(old_subject, this.newSubject(new_subject).toValue());
    }

    /**
     *  [Description]
     *  @param subject - 
     *  @return Constant
     */
    public function newSubject (subject :AbstractVariable) : Constant
    {
        var reciprocal :Constant = new Constant(1) / this.terms.get(subject);
        this.terms.delete(subject);
        this.multiplyMe(-reciprocal);
        return reciprocal;
    }

    /**
     *  [Description]
     *  @param clv - 
     *  @return Constant
     */
    public function coefficientFor (clv :AbstractVariable) : Constant
    {
        var constant = this.terms.get(clv);
        return (constant == null)
            ? new Constant(0)
            : constant;
    }

    /**
     *  [Description]
     *  @return Bool
     */
    private function get_isConstant() : Bool
    {
        return this.terms.size == 0;
    }

    public function toString() : String
    {
        return "";
    }

    /**
     *  [Description]
     *  @param other - 
     *  @return Bool
     */
    public function equals(other :Expression) : Bool
    {
        if (other == this) {
            return true;
        }

        return other.constant == this.constant &&
            other.terms.equals(this.terms);
    }

    /**
     *  [Description]
     *  @param e1 - 
     *  @param e2 - 
     *  @return Expression
     */
    public function Plus(e1 :Expression, e2 :Expression) : Expression
    {
        return e1.plus(e2);
    }

    /**
     *  [Description]
     *  @param e1 - 
     *  @param e2 - 
     *  @return Expression
     */
    public function Minus(e1 :Expression, e2 :Expression) : Expression
    {
        return e1.minus(e2);
    }

    /**
     *  [Description]
     *  @param e1 - 
     *  @param e2 - 
     *  @return Expression
     */
    public function Times(e1 :Expression, e2 :Expression) : Expression
    {
        return e1.times(e2);
    }

    /**
     *  [Description]
     *  @param e1 - 
     *  @param e2 - 
     *  @return Expression
     */
    public function Divide(e1 :Expression, e2 :Expression) : Expression
    {
        return e1.divide(e2);
    }

    /**
     *  [Description]
     *  @param solver - 
     *  @return Expression
     */
    public static function empty(?solver :SimplexSolver) : Expression
    {
        var e = new Expression(new Value(1), new Constant(0));
        e.solver = solver;
        return e;
    }

    /**
     *  [Description]
     *  @param constant - 
     *  @param solver - 
     *  @return Expression
     */
    public static function fromConstant(constant :Constant, ?solver :SimplexSolver) : Expression
    {
        var e = new Expression(constant);
        e.solver = solver;
        return e;
    }

    /**
     *  [Description]
     *  @param value - 
     *  @param solver - 
     *  @return Expression
     */
    public static function fromValue(value :Value, ?solver :SimplexSolver) : Expression
    {
        var e = new Expression(value.abs(), new Constant(0));
        e.solver = solver;
        return e;
    }

    /**
     *  [Description]
     *  @param variable - 
     *  @param solver - 
     *  @return Expression
     */
    public static function fromVariable(variable :AbstractVariable, ?solver :SimplexSolver) : Expression
    {
        var e = new Expression(variable, new Value(1), new Constant(0));
        e.solver = solver;
        return e;
    }

}
