/*
 * Copyright (c) 2013-2017, Nucleic Development Team.
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Distributed under the terms of the Modified BSD License.
 *  
 *  The full license is in the file COPYING.txt, distributed with this software.
*/

package jasper;


class _Variable_
{
    public var name (default, null):String;
    public var value :Float;

    /**
     *  [Description]
     *  @param name - 
     */
    public function new(name :String) : Void
    {
        this.name = name;
        this.value = 0.0;
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() : String
    {
        return "name: " + name + " value: " + value;
    }
}