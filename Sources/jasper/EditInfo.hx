/*
 * Copyright (c) 2017 Jeremy Meltingtallow
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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