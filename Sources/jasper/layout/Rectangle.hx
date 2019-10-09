/*
 * Copyright (c) 2019 Jeremy Meltingtallow
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

package jasper.layout;

import jasper.Expression;
import jasper.Variable;

class Rectangle
{
    public var x :Length;
    public var y :Length;
    public var width :Length;
    public var height :Length;

    public function new() : Void
    {
        this.x = new Length();
        this.y = new Length();
        this.width = new Length();
        this.height = new Length();
    }
}

class Length
{
    public var unit :Unit;
    public var value (default, null):Variable;

    public function new() : Void
    {
        this.unit = AUTO;
        this.value = new Variable();
    }
}

enum Unit
{
    PX(val :Int);
    PERCENT(val :Float);
    CALC(fn :Variable -> Expression);
    AUTO;
}