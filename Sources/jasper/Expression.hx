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

class Expression
{
    public var constant :Float;
    public var terms :HashTable<AbstractVariable, Float>;
    public var externalVariables :HashSet<AbstractVariable>;
    public var solver :SimplexSolver;
    public var isConstant (get, null) : Bool;

    //needs helper functions
    public function new(cvar :AbstractVariable, value :Float, constant :Float) : Void
    {
        this.constant = constant;
        this.terms = new HashTable();
        this.externalVariables = new HashSet();
        this.solver = null;
    }

    /**
     *  [Description]
     *  @param constant - 
     *  @param terms - 
     *  @return Expression
     */
    public function initializeFromHash(constant :Float, terms :HashTable<AbstractVariable, Float>) : Expression
    {
        this.constant = constant;
        this.terms = terms.clone();
        return this;
    }

    public function multiplyMe(x :Float) : Expression
    {
        this.constant *= x;
        var t = this.terms;
        t.each(function(clv, coeff) { t.set(clv, coeff * x); });
        return this;
    }

    public function clone() : Expression
    {
        var e = Expression.empty();
        e.initializeFromHash(this.constant, this.terms);
        e.solver = this.solver;
        return e;
    }

    public function times(?x :Null<Float>, ?expr :Expression) : Expression
    {
        if (x != null) {
            return (this.clone()).multiplyMe(x);
        } 
        else {
            if (this.isConstant) {
                return expr.times(this.constant);
            } 
            else if (expr.isConstant) {
                return this.times(expr.constant);
            } 
            else {
                throw new NonExpression();
            }
        }
    }

    public function plus(?expr :Expression, ?vari :AbstractVariable)  : Expression
    {
        if (expr != null) {
            return this.clone().addExpression(expr, 1);
        } else if (vari != null) {
            return this.clone().addVariable(vari, 1);
        }
        throw new Error("plus", "plus");
    }

    public function minus(?expr :Expression, ?vari :AbstractVariable) : Expression
    {
        if (expr != null) {
            return this.clone().addExpression(expr, -1);
        } else if (vari != null) {
            return this.clone().addVariable(vari, -1);
        }
        throw new Error("minus", "minus");
    }

    public function divide(?x :Float, ?expr :Expression) : Expression
    {
        if (x != null) {
            if (C.approx(x, 0)) {
                throw new NonExpression();
            }
            return this.times(1 / x);
        } else if (expr != null) {
            if (!expr.isConstant) {
                throw new NonExpression();
            }
            return this.times(1 / expr.constant);
        }
        throw new Error("divide", "divide");
    }

    public function addExpression(?expr :Expression, ?vari :AbstractVariable, ?n :Float, ?subject :AbstractVariable) : Expression
    {
        if (vari != null) {
            expr = Expression.fromVariable(vari);
        }
        n = (n == null) ? 1 : n;

        this.constant += (n * expr.constant);
        expr.terms.each(function(clv, coeff) {
            this.addVariable(clv, coeff * n, subject);
            this._updateIfExternal(clv);
        });
        return this;
    }

    public function addVariable(v :AbstractVariable, ?cd :Float, ?subject) : Expression
    {
        cd = (cd == null) ? 1 : cd;
        var coeff = this.terms.get(v);

        if (coeff != null) {
            var newCoefficient = coeff + cd;
            if (newCoefficient == 0 || C.approx(newCoefficient, 0)) {
                if (this.solver != null) {
                    // this.solver.noteRemovedVariable(v, subject);
                }
                this.terms.delete(v);
            } 
            else {
                this.setVariable(v, newCoefficient);
            }
        } 
        else {
            if (!C.approx(cd, 0)) {
                this.setVariable(v, cd);
                if (this.solver != null) {
                    // this.solver.noteAddedVariable(v, subject);
                }
            }   
        }

        return this;
    }

    private function _updateIfExternal(v :AbstractVariable) : Void
    {
        if (v.isExternal) {
           this.externalVariables.add(v);
            if (this.solver != null) {
                // this.solver._noteUpdatedExternal(v);
            }
        }
    }

    public function setVariable(v :AbstractVariable, c :Float) : Expression
    {
        this.terms.set(v, c);
        this._updateIfExternal(v);
        return this;
    }

    public function anyPivotableVariable() : Dynamic
    {
        if (this.isConstant) {
            throw new InternalError("anyPivotableVariable called on a constant");
        }

        var rv :Dynamic = this.terms.escapingEach(function(clv :AbstractVariable, c) {
            return clv.isPivotable
                ? { retval: clv }
                : null;
        });

        if (rv != null && rv.retval != null) {
            return rv.retval;
        }

        return null;
    }

    public function substituteOut(outvar  /*c.AbstractVariable*/, expr /*c.Expression*/, subject /*c.AbstractVariable*/) : Void
    {

    // var solver = this.solver;
    // if (!solver) {
    // throw new c.InternalError("Expressions::substituteOut called without a solver");
    // }

    // var setVariable = this.setVariable.bind(this);
    // var terms = this.terms;
    // var multiplier = terms.get(outvar);
    // terms.delete(outvar);
    // this.constant += (multiplier * expr.constant);
    // /*
    // console.log("substituteOut:",
    // "\n\tsolver:", typeof this.solver,
    // "\n\toutvar:", outvar,
    // "\n\texpr:", expr.toString(),
    // "\n\tmultiplier:", multiplier,
    // "\n\tterms:", terms);
    // */
    // expr.terms.each(function(clv, coeff) {
    // var oldCoefficient = terms.get(clv);
    // if (oldCoefficient) {
    // var newCoefficient = oldCoefficient + multiplier * coeff;
    // if (c.approx(newCoefficient, 0)) {
    // solver.noteRemovedVariable(clv, subject);
    // terms.delete(clv);
    // } else {
    // setVariable(clv, newCoefficient);
    // }
    // } else {
    // setVariable(clv, multiplier * coeff);
    // if (solver) {
    // solver.noteAddedVariable(clv, subject);
    // }
    // }
    // });
    }

    public function changeSubject (old_subject /*c.AbstractVariable*/, new_subject /*c.AbstractVariable*/) : Void
    {
        this.setVariable(old_subject, this.newSubject(new_subject));
    }

    public function newSubject (subject /*c.AbstractVariable*/) 
    {
        // var reciprocal = 1 / this.terms.get(subject);
        // this.terms.delete(subject);
        // this.multiplyMe(-reciprocal);
        // return reciprocal;
        return null;
    }

    // Return the coefficient corresponding to variable var, i.e.,
    // the 'ci' corresponding to the 'vi' that var is:
    //     v1*c1 + v2*c2 + .. + vn*cn + c
    public function coefficientFor (clv /*c.AbstractVariable*/) 
    {
        // return this.terms.get(clv) || 0;
        return null;
    }

    private function get_isConstant() : Bool
    {
        // return this.terms.size == 0;
        return false;
    }

    public function toString() : String
    {
        // var bstr = ''; // answer
        // var needsplus = false;
        // if (!c.approx(this.constant, 0) || this.isConstant) {
        // bstr += this.constant;
        // if (this.isConstant) {
        // return bstr;
        // } else {
        // needsplus = true;
        // }
        // }
        // this.terms.each( function(clv, coeff) {
        // if (needsplus) {
        // bstr += " + ";
        // }
        // bstr += coeff + "*" + clv;
        // needsplus = true;
        // });
        // return bstr;
        return null;
    }

    public function equals(other) : Bool
    {
        // if (other === this) {
        // return true;
        // }

        // return other instanceof c.Expression &&
        // other.constant === this.constant &&
        // other.terms.equals(this.terms);
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
        var e = new Expression(null, 1, 0);
        e.solver = solver;
        return e;
    }

    public static function fromConstant(constant :Float, ?solver :SimplexSolver) : Expression
    {
        // var e = new Expression(cons);
        // e.solver = solver;
        // return e;
        return null;
    }

    public static function fromValue(value :Float, ?solver :SimplexSolver) : Expression
    {
        value = Math.abs(value);
        var e = new Expression(null, value, 0);
        e.solver = solver;
        return e;
    }

    public static function fromVariable(cvar :AbstractVariable, ?solver :SimplexSolver) : Expression
    {
        var e = new Expression(cvar, 1, 0);
        e.solver = solver;
        return e;
    }

}
