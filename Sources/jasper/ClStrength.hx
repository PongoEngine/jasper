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

class ClStrength
{
    public var name :String;
    public var symbolicWeight :ClSymbolicWeight;

    /**
     *  [Description]
     *  @param name - 
     *  @param symbolicWeight - 
     */
    public function new(name :String, symbolicWeight :ClSymbolicWeight) : Void
    {
        this.name = name;
        this.symbolicWeight = symbolicWeight;
    }

    /**
     *  [Description]
     *  @return Bool
     */
    public function isRequired() : Bool
    {
        return (this == ClStrength.REQUIRED);
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() : String
    {
        return this.name + (!this.isRequired()
            ? (":" + this.symbolicWeight) 
            : "");
    }

    /**
     *  [Description]
     *  @param name - 
     *  @param w1 - 
     *  @param w2 - 
     *  @param w3 - 
     *  @return ClStrength
     */
    public static function fromWeights(name :String, w1 :Float, w2 :Float, w3 :Float) : ClStrength
    {
        var symbolicWeight :ClSymbolicWeight = new ClSymbolicWeight(w1, w2, w3);
        return new ClStrength(name, symbolicWeight);
    }


    public static var REQUIRED = new ClStrength("<Required>", new ClSymbolicWeight(1000, 1000, 1000));
    public static var STRONG = new ClStrength("strong", new ClSymbolicWeight(1, 0, 0));
    public static var MEDIUM = new ClStrength("medium", new ClSymbolicWeight(0, 1, 0));
    public static var WEAK = new ClStrength("weak", new ClSymbolicWeight(0, 0, 1));
}












