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

import jasper.Solver;
import jasper.Strength;
import jasper.layout.container.Container;
import jasper.layout.container.ContainerColumn;
import jasper.layout.container.ContainerRow;
import jasper.layout.container.ContainerStack;

class Layout<T>
{
    public var root (default, null) : Container<T>;
    public var solver (default, null) : Solver;

    public function new(solver :Solver, data :T, width :Float, height :Float) : Void
    {
        this.root = new ContainerColumn(data, solver);
        this.solver = solver;

        solver.addConstraint((this.root.rectangle.x.value == 0) | Strength.MEDIUM);
        solver.addConstraint((this.root.rectangle.y.value == 0) | Strength.MEDIUM);
        solver.addConstraint((this.root.rectangle.width.value == width) | Strength.WEAK);
        solver.addConstraint((this.root.rectangle.height.value == height) | Strength.WEAK);
        solver.addEditVariable(this.root.rectangle.width.value, Strength.MEDIUM);
        solver.addEditVariable(this.root.rectangle.height.value, Strength.MEDIUM);
    }

    public inline function createColumn(data :T) : ContainerColumn<T>
    {
        return new ContainerColumn(data, solver);
    }

    public inline function createRow(data :T) : ContainerRow<T>
    {
        return new ContainerRow(data, solver);
    }

    public inline function createStack(data :T) : ContainerStack<T>
    {
        return new ContainerStack(data, solver);
    }

    public function update(width :Float, height :Float) : Void
    {
        solver.suggestValue(this.root.rectangle.width.value, width);
        solver.suggestValue(this.root.rectangle.height.value, height);
        this.solver.updateVariables();
    }
}