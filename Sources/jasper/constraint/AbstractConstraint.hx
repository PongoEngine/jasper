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

package jasper.constraint;

//Looks complete but not tested

import jasper.C;
import jasper.Strength;
import jasper.Expression;
import jasper.variable.Variable;

class AbstractConstraint
{
    public var hashCode :Int;
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