// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

package jasper.constraint;

//Looks complete but not tested

import jasper.Expression;

class Constraint extends AbstractConstraint
{
    /**
     *  [Description]
     *  @param cle - 
     *  @param strength - 
     *  @param weight - 
     */
    public function new(cle :Expression, strength :Strength, weight :Float) : Void
    {
        super(strength, weight);
        this.expression = cle;
    }
}