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
class Row {

    public var constant :Constant;
    public var cells = new Map<Symbol, Float>();

    public function new(params :RowParams) : Void
    {
        switch params {
            case None:
                this.constant = new Constant(0);
            case Const(constant):
                this.constant = constant;
            case Row(other):
                this.cells = other.cells;
                this.constant = other.constant;
        }
    }

    public function add(value :Float) :Float
    {
        this.constant += value
        return this.constant.toFloat();
    }
    
    public function insert(params :InsertParams) : Void
    {
        switch params {
            case Sym(symbol):
                insertSymbolCoef(symbol, 1.0);
            case SymCoef(symbol, coefficient):
                insertSymbolCoef(symbol, coefficient);
            case RowCoef(other, coefficient):
                insertRowCoef(other, coefficient);
            case Row(other):
                insertRowCoef(other, 1.0);
        }
    }

    private function insertRowCoef(other :Row, coefficient :Float) : Void
    {
        this.constant += other.constant * coefficient;

        for(s in other.cells.keys()){
            var coeff = other.cells.get(s) * coefficient;

            var value = this.cells.get(s);
            if(value == null){
                this.cells.set(s, 0.0);
            }
            var temp = this.cells.get(s) + coeff;
            this.cells.set(s, temp);
            if(Util.nearZero(temp)){
                this.cells.remove(s);
            }
        }
    }

    private function insertSymbolCoef(symbol :Symbol, coefficient :Float) : Void
    {
        var existingCoefficient = cells.get(symbol);
        if (existingCoefficient != null) {
            coefficient += existingCoefficient;
        }
        if (Util.nearZero(coefficient)) {
            cells.remove(symbol);
        } 
        else {
            cells.set(symbol, coefficient);
        }
    }

    public function remove(symbol :Symbol) : Void
    {
        cells.remove(symbol);
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

    public function solveFor(params :SolveForParams) : Void
    {
        switch params {
            case Sym(sym):
                solveForSym(sym);
            case SymSym(lhs, rhs):
                insert(SymCoef(lhs, -1.0));
                solveForSym(rhs);
        }
    }

    private function solveForSym(symbol :Symbol) : Void
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
            insert(RowCoef(row, coefficient));
        }
    }

}

enum SolveForParams
{
    Sym(symbol :Symbol);
    SymSym(lhs :Symbol, rhs :Symbol);
}

enum InsertParams
{
    Sym(symbol :Symbol);
    SymCoef(symbol :Symbol, coefficient :Float);
    RowCoef(row :Row, coefficient :Float);
    Row(row :Row);
}

enum RowParams
{
    None;
    Const(const :Constant);
    Row(row :Row);
}