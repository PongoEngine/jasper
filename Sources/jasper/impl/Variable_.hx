/*
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package jasper.impl;

/**
 * Created by alex on 30/01/15.
 */
class Variable_
{
    /**
     *  [Description]
     *  @param name - 
     */
    public function new(name :String) : Void
    {
        _name = name;
    }
    
    /**
     *  [Description]
     *  @return Float
     */
    public function getValue() : Float
    {
        return _value;
    }

    /**
     *  [Description]
     *  @param value - 
     */
    public function setValue(value :Float) : Void
    {
        _value = value;
    }

    /**
     *  [Description]
     *  @return String
     */
    public function getName() : String
    {
        return _name;
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() : String
    {
        return "name: " + _name + " value: " + _value;
    }

    private var _name :String;
    private var _value :Float = 0.0;
}
