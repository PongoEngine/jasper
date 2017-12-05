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

package jasper.variable;

import jasper.C;
import jasper.variable.AbstractVariableArgs;
import jasper.variable.AbstractValue;

//Looks complete but not tested

class AbstractVariable
{
    public var hashCode :Int;

    public var isDummy :Bool = false;
    public var isExternal: Bool = false;
    public var isPivotable: Bool = false;
    public var isRestricted: Bool = false;

    public var _prefix : String = "";
    public var name : String = "";
    public var value : AbstractValue = INT(0);

    /**
     *  [Description]
     *  @param args - 
     *  @param varNamePrefix - 
     */
    public function new(?args :AbstractVariableArgs, ?varNamePrefix : String) : Void
    {
        this.hashCode = C._inc();

        this.name = (varNamePrefix == null)
            ? this.hashCode + ""
            : varNamePrefix + this.hashCode;

        if(args != null) {
            if(args.name != null) this.name = args.name;
            if(args.value != null) this.value = args.value;
            if(args.prefix != null) this._prefix = args.prefix;
        }
    }

    /**
     *  [Description]
     *  @return AbstractValue
     */
    public function valueOf() : AbstractValue
    {
        return this.value; 
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() : String
    {
        return this._prefix + "[" + this.name + ":" + this.value + "]";
    };
}