/*
 * Copyright (c) 2017 Jeremy Meltingtallow
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

// FILE: EDU.Washington.grad.gjb.cassowary
// package EDU.Washington.grad.gjb.cassowary;

package jasper;

import jasper.Stringable;

class ClStrength implements Stringable
{
    private var _name :String;
    private var _symbolicWeight :ClSymbolicWeight;

    public function new(name :String, symbolicWeight /*:ClSymbolicWeight*/:Dynamic, ?w2 :Float, ?w3 :Float) : Void
    {
        this._name = name;
        if (Std.is(symbolicWeight, ClSymbolicWeight)) {
            this._symbolicWeight = symbolicWeight;
        }
        else {
            this._symbolicWeight = new ClSymbolicWeight(symbolicWeight, w2, w3);
        }
    }

    public function isRequired() : Bool
    {
        return (this == ClStrength.required);
    }

    public function toString() : String
    {
        return this._name + (!this.isRequired()? (":" + this.symbolicWeight()) : "");
    }

    public function symbolicWeight() : ClSymbolicWeight
    {
        return this._symbolicWeight;
    }

    public function name() : String
    {
        return this._name;
    }

    public function set_name(name :String) : Void 
    {
        this._name = name;
    }

    public function set_symbolicWeight(symbolicWeight :ClSymbolicWeight) : Void
    {
        this._symbolicWeight = symbolicWeight;
    }

    public static var required = new ClStrength("<Required>", new ClSymbolicWeight(1000, 1000, 1000));
    public static var strong = new ClStrength("strong", new ClSymbolicWeight(1, 0, 0));
    public static var medium = new ClStrength("medium", new ClSymbolicWeight(0, 1, 0));
    public static var weak = new ClStrength("weak", new ClSymbolicWeight(0, 0, 1));
}