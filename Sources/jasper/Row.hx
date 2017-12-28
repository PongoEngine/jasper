/*
 * Copyright (c) 2013-2017, Nucleic Development Team.
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Distributed under the terms of the Modified BSD License.
 *  
 *  The full license is in the file COPYING.txt, distributed with this software.
*/

package jasper;

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

    public static inline function fromRow(other :Row) : Row
    {
        test.Assert.notTested("Row.hx", "fromRow");
        
        var row = new Row(other.constant);
        // row.cells = other.cells;
        for(otherKey in other.cells.keys()) {
            row.cells.set(otherKey, other.cells.get(otherKey));
        }
        return row;
    }

    public function add(value :Float) : Float
    {
        test.Assert.notTested("Row.hx", "add");
        
        return this.constant += value;
    }

    public function insertSymbol(symbol :Symbol, coefficient :Float) : Void
    {
        test.Assert.notTested("Row.hx", "insertSymbol");
        
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
        test.Assert.notTested("Row.hx", "insertRow");
        
        this.constant += other.constant * coefficient;

        for(key in other.cells.keys()) {
            var coeff = other.cells.get(key) * coefficient;
            insertSymbol(key, coeff);
        }
    }

    public function remove(symbol :Symbol) : Void
    {
        test.Assert.notTested("Row.hx", "remove");
        
        if(cells.exists(symbol)) {
            cells.remove(symbol);
        }
    }

    public function reverseSign() : Void
    {
        test.Assert.notTested("Row.hx", "reverseSign");
        
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
        test.Assert.notTested("Row.hx", "solveFor");
        
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
        test.Assert.notTested("Row.hx", "solveForSymbols");
        
        insertSymbol(lhs, -1.0);
        solveFor(rhs);
    }

    public function coefficientFor(symbol :Symbol) : Float
    {
        test.Assert.notTested("Row.hx", "coefficientFor");
        
        if (this.cells.exists(symbol)) {
            return this.cells.get(symbol);
        } else {
            return 0.0;
        }
    }

    public function substitute(symbol :Symbol, row :Row) : Void
    {
        test.Assert.notTested("Row.hx", "substitute");
        
        if (cells.exists(symbol)) {
            var coefficient = cells.get(symbol);
            cells.remove(symbol);
            insertRow(row, coefficient);
        }
    }
}
