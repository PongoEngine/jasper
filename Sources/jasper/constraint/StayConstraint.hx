// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

package jasper.constraint;

//stubbed out to be complete not tested

import jasper.variable.Variable;
import jasper.Strength;
import jasper.Expression;

class StayConstraint extends AbstractConstraint
{
    /**
     *  [Description]
     *  @param cv - 
     *  @param _strength - 
     *  @param weight - 
     */
    public function new(cv :Variable, ?_strength :Strength, ?weight :Null<Float>) : Void
    {
        var strength = (_strength == null)
            ? Strength.STRONG
            : _strength;

        super(strength, weight);
        this.variable = cv;
        // this.expression = new Expression(cv, -1, cv.value);
        this.isStay = true;
    }

    /**
     *  [Description]
     *  @return String
     */
    override public function toString() : String
    {
        return "stay:" + super.toString();
    }   
}