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
    public var cells :Map<Symbol, Float>;

    /**
     *  [Description]
     *  @param constant - 
     *  @param cells - 
     */
    public function new(constant :Float, cells :Map<Symbol, Float>) : Void
    {
        this.constant = constant;
        this.cells = cells;
    }

    /**
     *  [Description]
     *  @param other - 
     *  @return Row
     */
    public static inline function fromRow(other :Row) : Row
    {
        var clonedCells = new Map<Symbol, Float>();
        var otherCells = other.cells;

        for(key in otherCells.keys()) {
            clonedCells.set(key, otherCells.get(key));
        }

        return new Row(other.constant, clonedCells);
    }

    /**
     *  [Description]
     *  @param constant - 
     *  @return Row
     */
    public static inline function fromConstant(constant :Float) : Row
    {
        return new Row(constant, new Map<Symbol, Float>());
    }

    /**
     *  [Description]
     *  @return Row
     */
    public static inline function empty() : Row
    {
        return new Row(0, new Map<Symbol, Float>());
    }

    /**
     *  [Description]
     *  @param value - 
     *  @return Float
     */
    public function add(value :Float) : Float
    {
        return constant += value;
    }

    /**
     *  [Description]
     *  @param symbol - 
     *  @param coefficient - 
     */
    public function insertSymbol(symbol :Symbol, coefficient :Float) : Void
    {
        var existingCoefficient = cells.get(symbol);

        if (existingCoefficient != null) {
            coefficient += existingCoefficient;
        }

        if (Util.nearZero(coefficient)) {
            cells.remove(symbol);
        } else {
            cells.set(symbol, coefficient);
        }
    }

    /**
     *  [Description]
     *  @param symbol - 
     */
    public function insertSymbolWithDefault(symbol :Symbol) : Void
    {
        insertSymbol(symbol, 1.0);
    }

    /**
     *  [Description]
     *  @param other - 
     *  @param coefficient - 
     */
    public function insertRow(other :Row, coefficient :Float) : Void
    {
        constant += other.constant * coefficient;

        for(s in other.cells.keys()){
            var coeff = other.cells.get(s) * coefficient;

            var value = cells.get(s);
            if(value == null){
                cells.set(s, 0.0);
            }
            var temp = cells.get(s) + coeff;
            cells.set(s, temp);
            if(Util.nearZero(temp)){
                cells.remove(s);
            }
        }
    }

    /**
     *  [Description]
     *  @param other - 
     */
    public function insertRowWithDefault(other :Row) : Void
    {
        insertRow(other, 1.0);
    }

    /**
     *  [Description]
     *  @param symbol - 
     */
    public function remove(symbol :Symbol) : Void
    {
        cells.remove(symbol);
    }

    /**
     *  [Description]
     */
    public function reverseSign() : Void
    {
        constant = -constant;

        var newCells = new Map<Symbol, Float>();
        for(s in cells.keys()){
            var value = -cells.get(s);
            newCells.set(s, value);
        }
        cells = newCells;
    }

    /**
     *  [Description]
     *  @param symbol - 
     */
    public function solveFor(symbol :Symbol) : Void
    {
        var coeff = (-1.0) / cells.get(symbol);
        cells.remove(symbol);
        constant *= coeff;

        var newCells = new Map<Symbol, Float>();
        for(s in cells.keys()){
            var value = cells.get(s) * coeff;
            newCells.set(s, value);
        }
        cells = newCells;
    }

    /**
     *  [Description]
     *  @param lhs - 
     *  @param rhs - 
     */
    public function solveForSymbols(lhs :Symbol, rhs :Symbol) : Void
    {
        insertSymbol(lhs, -1.0);
        solveFor(rhs);
    }

    /**
     *  [Description]
     *  @param symbol - 
     *  @return Float
     */
    public function coefficientFor(symbol :Symbol) : Float
    {
        if (cells.exists(symbol)) {
            return cells.get(symbol);
        } else {
            return 0.0;
        }
    }

    /**
     *  [Description]
     *  @param symbol - 
     *  @param row - 
     */
    public function substitute(symbol :Symbol, row :Row) : Void
    {
        if (cells.exists(symbol)) {
            var coefficient = cells.get(symbol);
            cells.remove(symbol);
            insertRow(row, coefficient);
        }
    }
}
