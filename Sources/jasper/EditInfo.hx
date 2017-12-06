// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

package jasper;

//Looks complete but not tested

import jasper.constraint.Constraint;
import jasper.variable.SlackVariable;

class EditInfo
{
    public var constraint :Constraint;
    public var editPlus :SlackVariable;
    public var editMinus :SlackVariable;
    public var prevEditConstant :Float;
    public var index :Int;

    /**
     *  [Description]
     *  @param cn - 
     *  @param eplus - 
     *  @param eminus - 
     *  @param prevEditConstant - 
     *  @param i - 
     */
    public function new(cn :Constraint, eplus :SlackVariable, eminus :SlackVariable, prevEditConstant :Float, i :Int) : Void
    {
        this.constraint = cn;
        this.editPlus = eplus;
        this.editMinus = eminus;
        this.prevEditConstant = prevEditConstant;
        this.index = i;
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() : String
    {
        return "<cn=" + this.constraint +
            ", ep=" + this.editPlus +
            ", em=" + this.editMinus +
            ", pec=" + this.prevEditConstant +
            ", index=" + this.index + ">";
    }
}