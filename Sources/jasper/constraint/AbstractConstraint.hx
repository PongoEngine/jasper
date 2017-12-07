// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

package jasper.constraint;

//Looks complete but not tested

import jasper.C;
import jasper.Strength;
import jasper.Expression;
import jasper.variable.Variable;
import jasper.Hashable;

class AbstractConstraint implements Hashable
{
    public var hashCode (default, null):Int;
    public var strength :Strength;
    public var weight :Float;

    public var isEdit :Bool = false;
    public var isInequality :Bool = false;
    public var isStay :Bool = false;

    public var expression : Expression;
    public var variable : Variable;
    public var required (get, null) : Bool;

    /**
     *  [Description]
     *  @param strength - 
     *  @param weight - 
     */
    public function new(?strength :Strength, ?weight :Null<Float>) : Void
    {
        this.hashCode = C._inc();
        this.strength = (strength == null)
            ? Strength.REQUIRED
            : strength;
        this.weight = (weight == null)
            ? 1
            : weight;
    }

    /**
     *  [Description]
     *  @return Bool
     */
    private function get_required() : Bool
    {
        return this.strength == Strength.REQUIRED;
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() : String 
    {
        // this is abstract -- it intentionally leaves the parens unbalanced for
        // the subclasses to complete (e.g., with ' = 0', etc.
        return this.strength + " {" + this.weight + "} (" + this.expression +")";
    }
}