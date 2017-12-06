// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

package jasper;

import jasper.variable.Variable;
import jasper.variable.AbstractVariableArgs;

//Looks complete but not tested

class Point
{
    public var x (default, null) :Variable;
    public var y (default, null) :Variable;

    /**
     *  [Description]
     *  @param xVar - 
     *  @param yVar - 
     */
    public function new(xVar :Variable, yVar :Variable) : Void
    {
        this.x = xVar;
        this.y = yVar;
    }

    /**
     *  [Description]
     *  @param xVar - 
     */
    public function setX(xVar :Variable) : Void
    {
        this.x = xVar;
    }

    /**
     *  [Description]
     *  @param yVar - 
     */
    public function setY(yVar :Variable) : Void
    {
        this.y = yVar;
    }

    /**
     *  [Description]
     *  @param val - 
     */
    public function setXValue(val :Int) : Void
    {
        this.x.value = INT(val);
    }

    /**
     *  [Description]
     *  @param val - 
     */
    public function setYValue(val :Int) : Void
    {
        this.y.value = INT(val);
    }

    /**
     *  [Description]
     *  @param x - 
     *  @param y - 
     *  @param suffix - 
     *  @return Point
     */
    public static function fromVals(x :Int, y :Int, ?suffix :String) : Point
    {
        var xArgs :AbstractVariableArgs = {value :INT(x)};
        var yArgs :AbstractVariableArgs = {value :INT(y)};
        if(suffix != null) {
            xArgs.name = "x" + suffix;
            yArgs.name = "y" + suffix;
        }

        return new Point(new Variable(xArgs), new Variable(yArgs));
    }
}