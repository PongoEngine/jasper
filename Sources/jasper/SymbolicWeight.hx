// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

package jasper;

//Looks complete but not tested

class SymbolicWeight 
{
    public var value :Int;

    /**
     *  [Description]
     *  @param w1 - 
     *  @param w2 - 
     *  @param w3 - 
     */
    public function new(w1 :Int, w2 :Int, w3 :Int) : Void
    {
        this.value = 0;
        init(w1,w2,w3);
    }

    /**
     *  [Description]
     *  @param w1 - 
     *  @param w2 - 
     *  @param w3 - 
     */
    private inline function init(w1 :Int, w2 :Int, w3 :Int) : Void
    {
        var factor = 1;

        this.value += w1 * factor;
        factor *= MULTIPLIER;
        this.value += w2 * factor;
        factor *= MULTIPLIER;
        this.value += w3 * factor;
        factor *= MULTIPLIER;
    }

    private static inline var MULTIPLIER = 1000;
}