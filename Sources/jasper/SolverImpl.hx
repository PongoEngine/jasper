/*
 * Copyright (c) 2013-2017, Nucleic Development Team.
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Distributed under the terms of the Modified BSD License.
 *  
 *  The full license is in the file COPYING.txt, distributed with this software.
*/

package jasper;

import jasper.Errors.DuplicateConstraint;
import jasper.Errors.UnsatisfiableConstraint;
import jasper.Errors.UnknownConstraint;
import jasper.Errors.DuplicateEditVariable;
import jasper.Errors.BadRequiredStrength;
import jasper.Errors.UnknownEditVariable;
import jasper.Errors.InternalSolverError;

import jasper.Symbol;
import jasper.Expression;
import jasper.Symbolics.Variable;
import jasper.Symbolics.Term;

using Lambda;

class SolverImpl
{
    private var m_cns :Map<Constraint, Tag>;
    private var m_rows :Map<Symbol, Row>;
    private var m_vars :Map<Variable, Symbol>;
    private var m_edits :Map<Variable, EditInfo>;
    private var m_infeasible_rows :List<Symbol>;
    private var m_objective :Row;
    private var m_artificial :Row;
	private var m_id_tick :Id = new Id(0);

    @:allow(jasper.Solver)
    private function new() : Void
    {
        m_cns = new Map();
        m_rows = new Map();
        m_vars = new Map();
        m_edits = new Map();
        m_objective = new Row();
        m_artificial = null;
    }

	/**
	 *  Add a constraint to the solver.
     *  
     *  Throws
     *  DuplicateConstraint: The given constraint has already been added to the solver.
     *  UnsatisfiableConstraint: The given constraint is required and cannot be satisfied.
     *  
	 *  @param constraint - 
	 */
	public function addConstraint(constraint :Constraint) : Void
	{

		if(m_cns.exists(constraint)) {
			throw new DuplicateConstraint( constraint );
		}

		// Creating a row causes symbols to reserved for the variables
		// in the constraint. If this method exits with an exception,
		// then its possible those variables will linger in the var map.
		// Since its likely that those variables will be used in other
		// constraints and since exceptional conditions are uncommon,
		// i'm not too worried about aggressive cleanup of the var map.
		var tag = new Tag();
		var rowptr :Row = createRow( constraint, tag );
		var subject :Symbol = chooseSubject( rowptr, tag );

		// If chooseSubject could find a valid entering symbol, one
		// last option is available if the entire row is composed of
		// dummy variables. If the constant of the row is zero, then
		// this represents redundant constraints and the new dummy
		// marker can enter the basis. If the constant is non-zero,
		// then it represents an unsatisfiable constraint.
		if( subject.m_type == INVALID && allDummies( rowptr ) )
		{
			if( !Util.nearZero( rowptr.m_constant ) )
				throw new UnsatisfiableConstraint( constraint );
			else
				subject = tag.marker;
		}

		// If an entering symbol still isn't found, then the row must
		// be added using an artificial variable. If that fails, then
		// the row represents an unsatisfiable constraint.
		if( subject.m_type == INVALID )
		{
			if( !addWithArtificialVariable( rowptr ) )
				throw new UnsatisfiableConstraint( constraint );
		}
		else
		{
			rowptr.solveFor( subject );
			substitute( subject, rowptr );
			m_rows[ subject ] = rowptr;
		}

		m_cns[ constraint ] = tag;

		// Optimizing after each constraint is added performs less
		// aggregate work due to a smaller average system size. It
		// also ensures the solver remains in a consistent state.
		optimize( m_objective );
	}

	/* Remove a constraint from the solver.
	Throws
	------
	UnknownConstraint
		The given constraint has not been added to the solver.
	*/
	public function removeConstraint(constraint :Constraint) : Void
	{
		
        if(!m_cns.exists(constraint)) {
            throw new UnknownConstraint( constraint );
        }

        var tag :Tag = m_cns.get(constraint);
        m_cns.remove(constraint);

		// Remove the error effects from the objective function
		// *before* pivoting, or substitutions into the objective
		// will lead to incorrect solver results.
		removeConstraintEffects( constraint, tag );

		// If the marker is basic, simply drop the row. Otherwise,
		// pivot the marker into the basis and then drop the row.
		if(m_rows.exists(tag.marker))
		{
            m_rows.remove(tag.marker);
		}
		else
		{
			var row_it = getMarkerLeavingRow( tag.marker );
			if( row_it == null )
				throw new InternalSolverError( "failed to find leaving row" );
			var leaving :Symbol = ( row_it.symbol );
			var rowptr :Row = ( row_it.row );
			m_rows.remove( leaving );
			rowptr.solveForSymbols( leaving, tag.marker );
			substitute( tag.marker, rowptr );
		}

		// Optimizing after each constraint is removed ensures that the
		// solver remains consistent. It makes the solver api easier to
		// use at a small tradeoff for speed.
		optimize( m_objective );
	}

	/* Test whether a constraint has been added to the solver.
	*/
	public function hasConstraint(constraint :Constraint) : Bool
	{
		
        return m_cns.exists(constraint);
	}

	/* Add an edit variable to the solver.
	This method should be called before the `suggestValue` method is
	used to supply a suggested value for the given edit variable.
	Throws
	------
	DuplicateEditVariable
		The given edit variable has already been added to the solver.
	BadRequiredStrength
		The given strength is >= required.
	*/
	public function addEditVariable(variable :Variable, strength :Strength) : Void
	{

        if(m_edits.exists(variable)) {
            throw new DuplicateEditVariable( variable );
        }

		strength = Strength.clip( strength );
		if( strength == Strength.REQUIRED )
			throw new BadRequiredStrength();

        //JM not sure if this is correct        
		var cn = new Constraint ( Expression.fromTerm( new Term(variable) ), OP_EQ, strength );
		addConstraint( cn );
        var info = new EditInfo(cn, m_cns[cn], 0.0);
		m_edits[ variable ] = info;
	}

	/* Remove an edit variable from the solver.
	Throws
	------
	UnknownEditVariable
		The given edit variable has not been added to the solver.
	*/
	public function removeEditVariable(variable :Variable) : Void
	{
		
        if(!m_edits.exists(variable))
            throw new UnknownEditVariable( variable );
		removeConstraint( m_edits.get(variable).constraint );
		m_edits.remove(variable);
	}

	/* Test whether an edit variable has been added to the solver.
	*/
	public function hasEditVariable(variable :Variable) : Bool
	{
		
        return m_edits.exists(variable);
	}

	/* Suggest a value for the given edit variable.
	This method should be used after an edit variable as been added to
	the solver in order to suggest the value for that variable.
	Throws
	------
	UnknownEditVariable
		The given edit variable has not been added to the solver.
	*/
	public function suggestValue(variable :Variable, value :Float) : Void
	{
		
        if(!m_edits.exists(variable)) {
            throw new UnknownEditVariable( variable );
        }

		// DualOptimizeGuard guard( *this );
		var info :EditInfo = m_edits.get(variable);
		var delta :Float = value - info.constant;
		info.constant = value;

		// Check first if the positive error variable is basic.
		// RowMap::iterator row_it = m_rows.find( info.tag.marker );
        if(m_rows.exists(info.tag.marker)) {
			if( m_rows.get(info.tag.marker).add( -delta ) < 0.0 )
				m_infeasible_rows.add(info.tag.marker);
			return;
        }

		// Check next if the negative error variable is basic.
        if(m_rows.exists(info.tag.other))
		{
			if( m_rows.get(info.tag.other).add( delta ) < 0.0 )
				m_infeasible_rows.add(info.tag.other);
			return;
		}

		// Otherwise update each row where the error variables exist.
		for(key in m_rows.keys())
		{
			var coeff = m_rows.get(key).coefficientFor( info.tag.marker );
			if( coeff != 0.0 &&
				m_rows.get(key).add( delta * coeff ) < 0.0 &&
				key.m_type != EXTERNAL )
				m_infeasible_rows.add( key );
		}
	}

	/* Update the values of the external solver variables.
	*/
	public function updateVariables() : Void
	{
		
		for(varKey in m_vars.keys())
		{
            var v :Variable = varKey;
			if(!m_rows.exists(m_vars.get(varKey)))
				v.value = 0.0;
			else
				v.value = m_rows.get(m_vars.get(varKey)).m_constant;
		}
	}

	/* Reset the solver to the empty starting condition.
	This method resets the internal solver state to the empty starting
	condition, as if no constraints or edit variables have been added.
	This can be faster than deleting the solver and creating a new one
	when the entire system must change, since it can avoid unecessary
	heap (de)allocations.
	*/
	public function reset() : Void
	{
		
        for(key in m_rows.keys()) m_rows.remove(key);
        for(key in m_cns.keys()) m_cns.remove(key);
        for(key in m_vars.keys()) m_vars.remove(key);
        for(key in m_edits.keys()) m_edits.remove(key);
		m_infeasible_rows.clear();
        m_objective = new Row();
        m_artificial = null;
	}

	/* Get the symbol for the given variable.
	If a symbol does not exist for the variable, one will be created.
	*/
	private function getVarSymbol(variable :Variable) : Symbol
	{
		
		if(m_vars.exists( variable ))
			return m_vars.get( variable );
		var symbol = new Symbol(m_id_tick++, EXTERNAL);
		m_vars[ variable ] = symbol;
		return symbol;
	}

	/**
	 *  Create a new Row object for the given constraint.
	 *  
	 *  The terms in the constraint will be converted to cells in the row.
	 *  Any term in the constraint with a coefficient of zero is ignored.
	 *  This method uses the `getVarSymbol` method to get the symbol for
	 *  the variables added to the row. If the symbol for a given cell
	 *  variable is basic, the cell variable will be substituted with the
	 *  basic row.
	 *  The necessary slack and error variables will be added to the row.
	 *  If the constant for the row is negative, the sign for the row
	 *  will be inverted so the constant becomes positive.
	 *  The tag will be updated with the marker and error symbols to use
	 *  for tracking the movement of the constraint in the tableau.
	 *  
	 *  @param constraint - 
	 *  @param tag - 
	 *  @return Row
	 */
	private function createRow(constraint :Constraint, tag :Tag) : Row
	{

		var expr :Expression = constraint.expression;
		var row :Row = new Row(expr.m_constant);

		// // Substitute the current basic variables into the row.
		for(it in expr.m_terms) {
			if( !Util.nearZero( it.coefficient ) )
			{
				var symbol :Symbol = getVarSymbol( it.variable );
				if(m_rows.exists(symbol))
					row.insertRow(m_rows.get(symbol), it.coefficient);
				else
					row.insertSymbol(symbol, it.coefficient);
			}
		}

		// Add the necessary slack, error, and dummy variables.
		switch( constraint.operator )
		{
			case OP_LE:
			case OP_GE:
			{
				var coeff = constraint.operator == OP_LE ? 1.0 : -1.0;
				var slack :Symbol = new Symbol(m_id_tick++, SLACK);
				tag.marker = slack;
				row.insertSymbol( slack, coeff );
				if( constraint.strength < Strength.REQUIRED ) {
					var error = new Symbol (m_id_tick++, ERROR);
					tag.other = error;
					row.insertSymbol( error, -coeff );
					m_objective.insertSymbol( error, constraint.strength );
				}
			}
			case OP_EQ:
			{
				if( constraint.strength < Strength.REQUIRED ) {
					var errplus = new Symbol(m_id_tick++, ERROR);
					var errminus = new Symbol(m_id_tick++, ERROR);
					tag.marker = errplus;
					tag.other = errminus;
					row.insertSymbol( errplus, -1.0 ); // v = eplus - eminus
					row.insertSymbol( errminus, 1.0 ); // v - eplus + eminus = 0
					m_objective.insertSymbol( errplus, constraint.strength );
					m_objective.insertSymbol( errminus, constraint.strength );
				}
				else {
					var dummy = new Symbol(m_id_tick++, DUMMY);
					tag.marker = dummy;
					row.insertSymbol( dummy );
				}
			}
		}

		// Ensure the row as a positive constant.
		if( row.m_constant < 0.0 )
			row.reverseSign();

		return row;
	}

	/**
	 *  Choose the subject for solving for the row.
	 *  
	 *  This method will choose the best subject for using as the solve
	 *  target for the row. An invalid symbol will be returned if there
	 *  is no valid target.
	 *  The symbols are chosen according to the following precedence:
	 *  1) The first symbol representing an external variable.
	 *  2) A negative slack or error tag variable.
	 *  If a subject cannot be found, an invalid symbol will be returned.
	 *  @param row - 
	 *  @param tag - 
	 *  @return Symbol
	 */
	private function chooseSubject(row :Row, tag :Tag) : Symbol
	{
		
		for( cellKey in row.m_cells.keys()) {
			if( cellKey.m_type == EXTERNAL)
				return cellKey;
		}
		if( tag.marker.m_type == SLACK || tag.marker.m_type == ERROR ) {
			if( row.coefficientFor( tag.marker ) < 0.0 )
				return tag.marker;
		}
		if( tag.other.m_type == SLACK || tag.other.m_type == ERROR )
		{
			if( row.coefficientFor( tag.other ) < 0.0 )
				return tag.other;
		}
		return new Symbol(new Id(0), INVALID);
	}

 	/* Add the row to the tableau using an artificial variable.
	This will return false if the constraint cannot be satisfied.
 	*/
 	private function addWithArtificialVariable(row :Row) : Bool
 	{
		 
        // Create and add the artificial variable to the tableau
		var art = new Symbol(new Id(0), SLACK);
		m_rows[ art ] = Row.fromRow( row );
		m_artificial = Row.fromRow( row );

		// Optimize the artificial objective. This is successful
		// only if the artificial objective is optimized to zero.
		optimize( m_artificial );
		var success :Bool = Util.nearZero( m_artificial.m_constant );
        m_artificial = null;

		// If the artificial variable is basic, pivot the row so that
		// it becomes basic. If the row is constant, exit early.
		if( m_rows.exists(art) )
		{
			var rowptr :Row = m_rows.get(art);
			m_rows.remove( art );

            var isEmpty = rowptr.m_cells.array().length == 0;
			if( isEmpty )
				return success;
			var entering :Symbol = ( anyPivotableSymbol( rowptr ) );
			if( entering.m_type == INVALID )
				return false;  // unsatisfiable (will this ever happen?)
			rowptr.solveForSymbols( art, entering );
			substitute( entering, rowptr );
			m_rows[ entering ] = rowptr;
		}

		for(row in m_rows)
			row.remove( art );
		m_objective.remove( art );
		return success;
 	}

	/* Substitute the parametric symbol with the given row.
	This method will substitute all instances of the parametric symbol
	in the tableau and the objective function with the given row.
	*/
	private function substitute(symbol :Symbol,row :Row) : Void
	{
		
		for(key in m_rows.keys())
		{
			m_rows.get(key).substitute( symbol, row );
			if( key.m_type != EXTERNAL &&
				m_rows.get(key).m_constant < 0.0 )
				m_infeasible_rows.add(key);
		}
		m_objective.substitute( symbol, row );
		if( m_artificial != null )
			m_artificial.substitute( symbol, row );
	}

	/* Optimize the system for the given objective function.
	This method performs iterations of Phase 2 of the simplex method
	until the objective function reaches a minimum.
	Throws
	------
	InternalSolverError
		The value of the objective function is unbounded.
	*/
	private function optimize(objective :Row) : Void
	{
		
        while( true )
		{
			var entering :Symbol = ( getEnteringSymbol( objective ) );
			if( entering.m_type == INVALID )
				return;
			var it = getLeavingRow( entering );
			if( it == null )
				throw new InternalSolverError( "The objective is unbounded." );
			// pivot the entering symbol into the basis
			var leaving :Symbol = ( it.symbol );
			var row :Row = it.row;
			m_rows.remove( leaving );
			row.solveForSymbols( leaving, entering );
			substitute( entering, row );
			m_rows[ entering ] = row;
		}
	}

	/* Optimize the system using the dual of the simplex method.
	The current state of the system should be such that the objective
	function is optimal, but not feasible. This method will perform
	an iteration of the dual simplex method to make the solution both
	optimal and feasible.
	Throws
	------
	InternalSolverError
		The system cannot be dual optimized.
	*/
	private function dualOptimize() : Void
	{
		
        while( !m_infeasible_rows.empty() )
		{

			var leaving :Symbol = ( m_infeasible_rows.last() );
			m_infeasible_rows.remove(leaving);
			// RowMap::iterator it = m_rows.find( leaving );
			if( m_rows.exists(leaving) && m_rows.get(leaving).m_constant < 0.0 )
			{
				var entering :Symbol = ( getDualEnteringSymbol(m_rows.get(leaving)) );
				if( entering.m_type == INVALID)
					throw new InternalSolverError( "Dual optimize failed." );
				// pivot the entering symbol into the basis
				var row :Row = m_rows.get(leaving);
				m_rows.remove(leaving);
				row.solveForSymbols( leaving, entering );
				substitute( entering, row );
				m_rows[ entering ] = row;
			}
		}
	}

	/* Compute the entering variable for a pivot operation.
	This method will return first symbol in the objective function which
	is non-dummy and has a coefficient less than zero. If no symbol meets
	the criteria, it means the objective function is at a minimum, and an
	invalid symbol is returned.
	*/
	private function getEnteringSymbol(objective :Row) : Symbol
	{
		
		for(key in objective.m_cells.keys())
		{
			if( key.m_type != DUMMY && objective.m_cells.get(key) < 0.0 )
				return key;
		}
		return new Symbol(new Id(0), INVALID);
	}

	/* Compute the entering symbol for the dual optimize operation.
	This method will return the symbol in the row which has a positive
	coefficient and yields the minimum ratio for its respective symbol
	in the objective function. The provided row *must* be infeasible.
	If no symbol is found which meats the criteria, an invalid symbol
	is returned.
	*/
	private function getDualEnteringSymbol(row :Row) : Symbol
	{
		
		var entering :Symbol = new Symbol(new Id(0), INVALID);
		var ratio = Util.FLOAT_MAX;
		for(key in row.m_cells.keys())
		{
			if( row.m_cells.get(key) > 0.0 && key.m_type != DUMMY )
			{
				var coeff = m_objective.coefficientFor( key );
				var r = coeff / row.m_cells.get(key);
				if( r < ratio )
				{
					ratio = r;
					entering = key;
				}
			}
		}
		return entering;
	}

	/* Get the first Slack or Error symbol in the row.
	If no such symbol is present, and Invalid symbol will be returned.
	*/
	private function anyPivotableSymbol(row :Row) : Symbol
	{
		
		for(key in row.m_cells.keys())
		{
			var sym = key;
			if( sym.m_type == SLACK || sym.m_type == ERROR )
				return sym;
		}
		return new Symbol(new Id(0), INVALID);
	}

	/* Compute the row which holds the exit symbol for a pivot.
	This method will return an iterator to the row in the row map
	which holds the exit symbol. If no appropriate exit symbol is
	found, the end() iterator will be returned. This indicates that
	the objective function is unbounded.
	*/
	private function getLeavingRow(entering :Symbol) :LeavingRow
	{
		
		var ratio = Util.FLOAT_MAX;
        var found :LeavingRow = null;
		for( key in m_rows.keys())
		{
			if( key.m_type != EXTERNAL )
			{
				var temp = m_rows.get(key).coefficientFor( entering );
				if( temp < 0.0 )
				{
					var temp_ratio = -m_rows.get(key).m_constant / temp;
					if( temp_ratio < ratio )
					{
						ratio = temp_ratio;
						found = new LeavingRow(key, m_rows.get(key));
					}
				}
			}
		}
		return found;
	}

	/* Compute the leaving row for a marker variable.
	This method will return an iterator to the row in the row map
	which holds the given marker variable. The row will be chosen
	according to the following precedence:
	1) The row with a restricted basic varible and a negative coefficient
	   for the marker with the smallest ratio of -constant / coefficient.
	2) The row with a restricted basic variable and the smallest ratio
	   of constant / coefficient.
	3) The last unrestricted row which contains the marker.
	If the marker does not exist in any row, the row map end() iterator
	will be returned. This indicates an internal solver error since
	the marker *should* exist somewhere in the tableau.
	*/
	private function getMarkerLeavingRow( marker :Symbol ) :LeavingRow
	{
		
        var dmax = Util.FLOAT_MAX;
		var r1 = dmax;
		var r2 = dmax;
		var first :LeavingRow= null;
		var second :LeavingRow= null;
		var third :LeavingRow= null;
		for(rowKey in m_rows.keys())
		{
			var c = m_rows.get(rowKey).coefficientFor( marker );
			if( c == 0.0 )
				continue;
			if( rowKey.m_type == EXTERNAL )
			{
				third = new LeavingRow(rowKey, m_rows.get(rowKey));
			}
			else if( c < 0.0 )
			{
				var r = -m_rows.get(rowKey).m_constant / c;
				if( r < r1 )
				{
					r1 = r;
					first = new LeavingRow(rowKey, m_rows.get(rowKey));
				}
			}
			else
			{
				var r = m_rows.get(rowKey).m_constant / c;
				if( r < r2 )
				{
					r2 = r;
					second = new LeavingRow(rowKey, m_rows.get(rowKey));
				}
			}
		}
		if( first != null )
			return first;
		if( second != null )
			return second;
		return third;
	}

	/* Remove the effects of a constraint on the objective function.
	*/
	private function removeConstraintEffects(cn :Constraint, tag :Tag) : Void
	{
		
        if( tag.marker.m_type == ERROR )
			removeMarkerEffects( tag.marker, cn.strength );
		if( tag.other.m_type == ERROR )
			removeMarkerEffects( tag.other, cn.strength );
	}

	/* Remove the effects of an error marker on the objective function.
	*/
	private function removeMarkerEffects(marker :Symbol, strength :Strength) : Void
	{
		
		if(m_rows.exists(marker))
			m_objective.insertRow(m_rows.get(marker), -strength );
		else
			m_objective.insertSymbol( marker, -strength );
	}

	/* Test whether a row is composed of all dummy variables.
	*/
	private function allDummies(row :Row) : Bool
	{
		
		for( key in row.m_cells.keys())
		{
			if( key.m_type != DUMMY )
				return false;
		}
		return true;
	}

}

private class Tag 
{
   public var marker :Symbol;
   public var other :Symbol;

   public function new() : Void
   {
      marker = new Symbol(new Id(0), INVALID);
      other = new Symbol(new Id(0), INVALID);
   }
}

private class EditInfo 
{
   public var tag :Tag;
   public var constraint :Constraint;
   public var constant :Float;

   public function new(constraint :Constraint, tag :Tag, constant : Float) : Void
   {
      this.constraint = constraint;
      this.tag = tag;
      this.constant = constant;
   }
}

private class LeavingRow
{
    public var symbol :Symbol;
    public var row :Row;

    public function new(symbol :Symbol, row :Row) : Void
    {
        this.symbol = symbol;
        this.row = row;
    }
}