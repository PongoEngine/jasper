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

package jasper;

/**
 * Created by alex on 30/01/15.
 */
class Row 
{
    public var constant :Float;
    public var cells = new Map<Symbol, Float>();

    private function new(constant :Float) : Void
    {
        this.constant = constant;
    }

    public static inline function empty() : Row
    {
        return new Row(0);
    }

    public static inline function fromConstant(constant :Float) : Row
    {
        return new Row(constant);
    }

    public static inline function fromRow(row :Row) : Row
    {
        throw "not implmented yet fromRow";
        var row = new Row(0);
        return row;
    }

    public function add(value :Float) : Float
    {
        return this.constant += value;
    }

    public function insertSymbol(symbol :Symbol, coefficient :Float) : Void
    {
        if(cells.exists(symbol)) {
            var val :Float = cells.get(symbol);
            if(Util.nearZero(val + coefficient)) {
                cells.remove(symbol);
            }
            else {
                cells.set(symbol, coefficient);
            }
        }
        else {
            cells.set(symbol, coefficient);
        }
    }

    public function insertRow(other :Row, coefficient :Float) : Void
    {
        this.constant += other.constant * coefficient;

        for(key in other.cells.keys()) {
            var coeff = other.cells.get(key) * coefficient;
            insertSymbol(key, coeff);
        }
    }

    public function remove(symbol :Symbol) : Void
    {
        cells.remove(symbol);
        // not sure what this does, can the symbol be added more than once?
        /*CellMap::iterator it = m_cells.find( symbol );
        if( it != m_cells.end() )
            m_cells.erase( it );*/
    }

    public function reverseSign() : Void
    {
        this.constant = -this.constant;

        var newCells = new Map<Symbol, Float>();
        for(s in cells.keys()){
            var value = - cells.get(s);
            newCells.set(s, value);
        }
        this.cells = newCells;
    }

    public function solveFor(symbol :Symbol) : Void
    {
        var coeff = -1.0 / cells.get(symbol);
        cells.remove(symbol);
        this.constant *= coeff;

        var newCells = new Map<Symbol, Float>();
        for(s in cells.keys()){
            var value = cells.get(s) * coeff;
            newCells.set(s, value);
        }
        this.cells = newCells;
    }

    public function solveForSymbols(lhs :Symbol, rhs :Symbol) : Void
    {
        insertSymbol(lhs, -1.0);
        solveFor(rhs);
    }

    public function coefficientFor(symbol :Symbol) : Float
    {
        if (this.cells.exists(symbol)) {
            return this.cells.get(symbol);
        } else {
            return 0.0;
        }
    }

    public function substitute(symbol :Symbol, row :Row) : Void
    {
        if (cells.exists(symbol)) {
            var coefficient = cells.get(symbol);
            cells.remove(symbol);
            insertRow(row, coefficient);
        }
    }
}
