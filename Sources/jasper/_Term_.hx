/*
 * Copyright (c) 2013-2017, Nucleic Development Team.
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Distributed under the terms of the Modified BSD License.
 *  
 *  The full license is in the file COPYING.txt, distributed with this software.
*/

package jasper;

import jasper.Symbolics.Variable;
import jasper.Symbolics.Term;

class _Term_
{
    public var variable :Variable;
    public var coefficient :Float;

    /**
     *  [Description]
     *  @param variable - 
     *  @param coefficient - 
     */
    public function new(variable :Variable, coefficient :Float) : Void
    {
        this.variable = variable;
        this.coefficient = coefficient;
    }

    /**
     *  [Description]
     *  @return Float
     */
    public function getValue() : Float
    {
        test.Assert.notTested("_Term_.hx", "getValue");

        return coefficient * variable.value;
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() : String
    {
        return "variable: (" + variable + ") coefficient: "  + coefficient;
    }
}


