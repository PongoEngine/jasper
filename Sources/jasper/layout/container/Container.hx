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

package jasper.layout.container;

import jasper.Solver;
import jasper.layout.Rectangle;

class Container<T>
{
    public var parent (default, null) :Container<T> = null;
    public var firstChild (default, null) :Container<T> = null;
    public var next (default, null) :Container<T> = null;
    public var rectangle (default, null):Rectangle;
    public var solver (default, null):Solver;
    public var data :T;

    public function new(data :T, solver :Solver) : Void
    {
        this.rectangle = new Rectangle();
        this.data = data;
        this.solver = solver;
    }

    private function addConstraints() : Void
    {
    }

    public function addChild(container :Container<T>) : Container<T>
    {
        if (container.parent != null) {
            container.parent.removeChild(container);
        }
        container.parent = this;

        // Append it to the child list
        var tail = null, p = firstChild;
        while (p != null) {
            tail = p;
            p = p.next;
        }
        if (tail != null) {
            tail.next = container;
            addConstraints();
        } else {
            firstChild = container;
            addConstraints();
        }

        return this;
    }

    public function alter(fn :Container<T> -> Void) : Container<T>
    {
        fn(this);
        return this;
    }

    public function removeChild(container :Container<T>) : Void
    {
        var prev :Container<T> = null, p = firstChild;
        while (p != null) {
            var next = p.next;
            if (p == container) {
                // Splice out the entity
                if (prev == null) {
                    firstChild = next;
                } else {
                    prev.next = next;
                }
                p.parent = null;
                p.next = null;
                addConstraints();
                return;
            }
            prev = p;
            p = next;
        }
    }
}