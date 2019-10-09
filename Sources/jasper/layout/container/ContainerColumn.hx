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
import jasper.Strength;
import jasper.Constraint;
import jasper.layout.container.Container;

@:allow(jasper.layout.Layout)
class ContainerColumn<T> extends Container<T>
{
    private function new(data :T, solver :Solver) : Void
    {
        super(data, solver);
        _constraints = [];
    }

    override private function addConstraints() : Void
    {
        while(_constraints.length > 0) {
            solver.removeConstraint(_constraints.pop());
        }

        var last :Container<T> = null;
        var p = this.firstChild;

        while(p != null) {
            switch p.rectangle.x.unit {
                case PX(val): 
                    _constraints.push((p.rectangle.x.value == val) | Strength.MEDIUM);
                case PERCENT(val): 
                    _constraints.push((p.rectangle.x.value == this.rectangle.width.value * val) | Strength.MEDIUM);
                case CALC(fn): 
                    _constraints.push((p.rectangle.x.value == fn(this.rectangle.width.value)) | Strength.MEDIUM);
                case AUTO:
                    _constraints.push((p.rectangle.x.value == 0) | Strength.MEDIUM);
            }

            switch [p.rectangle.y.unit, last == null] {
                case [PX(val), true]:
                    _constraints.push((p.rectangle.y.value == val) | Strength.MEDIUM);
                case [PX(val), false]:
                    _constraints.push((p.rectangle.y.value == (last.rectangle.y.value + last.rectangle.height.value + val)) | Strength.MEDIUM);
                case [PERCENT(val), true]:
                    _constraints.push((p.rectangle.y.value == this.rectangle.height.value * val) | Strength.MEDIUM);
                case [PERCENT(val), false]:
                    _constraints.push((p.rectangle.y.value == (last.rectangle.y.value + last.rectangle.height.value + (this.rectangle.height.value * val))) | Strength.MEDIUM);
                case [CALC(fn), true]:
                    _constraints.push((p.rectangle.y.value == fn(this.rectangle.height.value)) | Strength.MEDIUM);
                case [CALC(fn), false]:
                    _constraints.push((p.rectangle.y.value == (last.rectangle.y.value + last.rectangle.height.value + fn(this.rectangle.height.value))) | Strength.MEDIUM);
                case [AUTO, true]:
                    _constraints.push((p.rectangle.y.value == 0) | Strength.MEDIUM);
                case [AUTO, false]:
                    _constraints.push((p.rectangle.y.value == (last.rectangle.y.value + last.rectangle.height.value)) | Strength.MEDIUM);
            }
            
            switch p.rectangle.width.unit {
                case PX(val): 
                    _constraints.push((p.rectangle.width.value == val) | Strength.MEDIUM);
                case PERCENT(val): 
                    _constraints.push((p.rectangle.width.value == this.rectangle.width.value * val) | Strength.MEDIUM);
                case CALC(fn): 
                    _constraints.push((p.rectangle.width.value == fn(this.rectangle.width.value)) | Strength.MEDIUM);
                case AUTO: 
                    _constraints.push((p.rectangle.width.value == this.rectangle.width.value) | Strength.MEDIUM);
            }

            switch p.rectangle.height.unit {
                case PX(val): 
                    _constraints.push((p.rectangle.height.value == val) | Strength.MEDIUM);
                case PERCENT(val): 
                    _constraints.push((p.rectangle.height.value == this.rectangle.height.value * val) | Strength.MEDIUM);
                case CALC(fn): 
                    _constraints.push((p.rectangle.height.value == fn(this.rectangle.height.value)) | Strength.MEDIUM);
                case AUTO: 
            }

            last = p;
            p = p.next;
        }

        for(c in _constraints) {
            solver.addConstraint(c);
        }
    }

    private var _constraints :Array<Constraint>;
}