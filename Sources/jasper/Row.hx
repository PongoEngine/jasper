/*
 * Copyright (c) 2013-2017, Nucleic Development Team.
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Distributed under the terms of the Modified BSD License.
 *  
 * The full license is in the file COPYING.txt, distributed with this software.
*/

package jasper;

class Row 
{
    public var m_constant :Float;
    public var m_cells = new Map<Symbol, Float>();

    public function new(constant :Float = 0) : Void
    {
        this.m_constant = constant;
    }

    public static inline function fromRow(other :Row) : Row
    {
        
        var row = new Row(other.m_constant);
        for(otherKey in other.m_cells.keys()) {
            row.m_cells.set(otherKey, other.m_cells.get(otherKey));
        }
        return row;
    }

    public function add(value :Float) : Float
    {
        
        return this.m_constant += value;
    }

    public function insertSymbol(symbol :Symbol, coefficient :Float = 1.0) : Void
    {

        if(!m_cells.exists(symbol))
            m_cells[symbol] = 0;
        
        if( Util.nearZero( m_cells[ symbol ] += coefficient ) )
			m_cells.remove( symbol );
    }

    public function insertRow(other :Row, coefficient :Float = 1.0) : Void
    {
        
        this.m_constant += other.m_constant * coefficient;

        for(key in other.m_cells.keys()) {
            var coeff = other.m_cells.get(key) * coefficient;
            insertSymbol(key, coeff);
        }
    }

    public function remove(symbol :Symbol) : Void
    {
        
        if(m_cells.exists(symbol)) {
            m_cells.remove(symbol);
        }
    }

    public function reverseSign() : Void
    {
        
		m_constant = -m_constant;
        for(key in m_cells.keys()) {
            m_cells[key] = -m_cells[key];
        }
    }

    public function solveFor(symbol :Symbol) : Void
    {
        
        var coeff = -1.0 / m_cells.get(symbol);
        m_cells.remove(symbol);
        this.m_constant *= coeff;

        var newCells = new Map<Symbol, Float>();
        for(s in m_cells.keys()){
            var value = m_cells.get(s) * coeff;
            newCells.set(s, value);
        }
        this.m_cells = newCells;
    }

    public function solveForSymbols(lhs :Symbol, rhs :Symbol) : Void
    {
        
        insertSymbol(lhs, -1.0);
        solveFor(rhs);
    }

    public function coefficientFor(symbol :Symbol) : Float
    {
        
        if (this.m_cells.exists(symbol)) {
            return this.m_cells.get(symbol);
        } else {
            return 0.0;
        }
    }

    public function substitute(symbol :Symbol, row :Row) : Void
    {
        
        if (m_cells.exists(symbol)) {
            var coefficient = m_cells.get(symbol);
            m_cells.remove(symbol);
            insertRow(row, coefficient);
        }
    }
}
