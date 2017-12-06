// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

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