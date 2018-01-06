/*
 * Copyright (c) 2013-2017, Nucleic Development Team.
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Distributed under the terms of the Modified BSD License.
 *  
 * The full license is in the file COPYING.txt, distributed with this software.
*/

package jasper;

import jasper.Errors.DuplicateConstraint;
import jasper.Errors.UnsatisfiableConstraint;
import jasper.Errors.UnknownConstraint;
import jasper.Errors.DuplicateEditVariable;
import jasper.Errors.BadRequiredStrength;
import jasper.Errors.UnknownEditVariable;
import jasper.Errors.InternalSolverError;
import jasper.ds.SolverMap;

import jasper.Symbol;
import jasper.Constraint;

typedef Tag =
{
	@:optional var marker :Symbol;
	@:optional var other :Symbol;
};

typedef EditInfo =
{
	@:optional var tag :Tag;
	@:optional var constraint :Constraint;
	@:optional var constant :Float;
};

typedef VarMap = SolverMap<Variable, Symbol>;

typedef RowMap = SolverMap<Symbol, Row>;

typedef CnMap = SolverMap<Constraint, Tag>;

typedef EditMap = SolverMap<Variable, EditInfo>;

class SolverImpl
{
    @:allow(jasper.Solver)
    private function new() : Void
    {
        m_cns = new CnMap();
        m_rows = new RowMap();
        m_vars = new VarMap();
        m_edits = new EditMap();
        m_objective = new Row();
        m_artificial = null;
    }

	/**
	 *  Add a constraint to the solver.
	 *  
	 *  Throws
	 *  ------
	 *  DuplicateConstraint
	 *  	The given constraint has already been added to the solver.
	 *  UnsatisfiableConstraint
	 *  	The given constraint is required and cannot be satisfied.
	 *  
	 *  @param constraint - 
	 */
	public function addConstraint( constraint :Constraint )
	{
		throw "addConstraint";
	}

	/**
	 *  Remove a constraint from the solver.
	 *  
	 *  Throws
	 *  ------
	 *  UnknownConstraint
	 *  	The given constraint has not been added to the solver.
	 *  
	 *  @param constraint - 
	 */
	public function removeConstraint( constraint :Constraint )
	{
		throw "removeConstraint";
	}

	/**
	 *  Test whether a constraint has been added to the solver.
	 *  
	 *  @param constraint - 
	 *  @return Bool
	 */
	public function hasConstraint( constraint :Constraint ) : Bool
	{
		throw "hasConstraint";
		return false;
	}

	/**
	 *  Add an edit variable to the solver.
	 *  This method should be called before the `suggestValue` method is
	 *  used to supply a suggested value for the given edit variable.
	 *  
	 *  Throws
	 *  ------
	 *  DuplicateEditVariable
	 *  	The given edit variable has already been added to the solver.
	 *  BadRequiredStrength
	 *  	The given strength is >= required.
	 *  
	 *  @param variable - 
	 *  @param strength - 
	 */
	public function addEditVariable( variable :Variable, strength :Strength )
	{
		throw "addEditVariable";
	}

	/**
	 *  Remove an edit variable from the solver.
	 *  
	 *  Throws
	 *  ------
	 *  UnknownEditVariable
	 *  	The given edit variable has not been added to the solver.
	 *  
	 *  @param variable - 
	 */
	public function removeEditVariable( variable :Variable )
	{
		throw "removeEditVariable";
	}

	/* Test whether an edit variable has been added to the solver.
	*/
	public function hasEditVariable( variable :Variable ) : Bool
	{
		throw "hasEditVariable";
		return false;
	}

	/**
	 *  Suggest a value for the given edit variable.
	 *  This method should be used after an edit variable as been added to
	 *  the solver in order to suggest the value for that variable.
	 *  
	 *  Throws
	 *  ------
	 *  UnknownEditVariable
	 *  	The given edit variable has not been added to the solver.
	 *  
	 *  @param variable - 
	 *  @param value - 
	 */
	public function suggestValue( variable :Variable, value :Float )
	{
		throw "suggestValue";
	}

	/**
	 *  Update the values of the external solver variables.
	 */
	public function updateVariables()
	{
		throw "updateVariables";
	}

	/**
	 *  Reset the solver to the empty starting condition.
	 *  This method resets the internal solver state to the empty starting
	 *  condition, as if no constraints or edit variables have been added.
	 *  This can be faster than deleting the solver and creating a new one
	 *  when the entire system must change, since it can avoid unecessary
	 *  heap (de)allocations.
	 */
	public function reset()
	{
		throw "reset!!";
	}

	private function clearRows()
	{
		throw "clearRows";
	}

	/**
	 *  Get the symbol for the given variable.
	 *  If a symbol does not exist for the variable, one will be created.
	 *  
	 *  @param variable - 
	 *  @return Symbol
	 */
	private function getVarSymbol( variable :Variable ) : Symbol
	{
		throw "getVarSymbol";
		return null;
	}

	/**
	 *  Create a new Row object for the given constraint.
	 *  The terms in the constraint will be converted to cells in the row.
	 *  Any term in the constraint with a coefficient of zero is ignored.
	 *  This method uses the `getVarSymbol` method to get the symbol for
	 *  the variables added to the row. If the symbol for a given cell
	 *  variable is basic, the cell variable will be substituted with the
	 *  basic row.
	 *  
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
	private function createRow( constraint :Constraint, tag :Tag ) : Row
	{
		throw "createRow";
		return null;
	}

	/**
	 *  Choose the subject for solving for the row.
	 *  This method will choose the best subject for using as the solve
	 *  target for the row. An invalid symbol will be returned if there
	 *  is no valid target.
	 *  
	 *  The symbols are chosen according to the following precedence:
	 *  1) The first symbol representing an external variable.
	 *  2) A negative slack or error tag variable.
	 *  If a subject cannot be found, an invalid symbol will be returned.
	 *  
	 *  @param row - 
	 *  @param tag - 
	 *  @return Symbol
	 */
	private function chooseSubject( row :Row, tag :Tag ) : Symbol
	{
		throw "chooseSubject";
		return null;
	}

 	/**
 	 *  Add the row to the tableau using an artificial variable.
	 *  This will return false if the constraint cannot be satisfied.
	 *  
 	 *  @param row - 
 	 *  @return Bool
 	 */
 	private function addWithArtificialVariable( row :Row ) : Bool
 	{
		throw "addWithArtificialVariable";
		return false;
 	}

	/**
	 *  Substitute the parametric symbol with the given row.
	 *  This method will substitute all instances of the parametric symbol
	 *  in the tableau and the objective function with the given row.
	 *  
	 *  @param symbol - 
	 *  @param row - 
	 */
	private function substitute( symbol :Symbol, row :Row )
	{
		throw "substitute";
	}

	/**
	 *  Optimize the system for the given objective function.
	 *  This method performs iterations of Phase 2 of the simplex method
	 *  until the objective function reaches a minimum.
	 *  
	 *  Throws
	 *  ------
	 *  InternalSolverError
	 *  	The value of the objective function is unbounded.
	 *  
	 *  @param objective - 
	 */
	private function optimize( objective :Row )
	{
		throw "optimize";
	}

	/**
	 *  Optimize the system using the dual of the simplex method.
	 *  The current state of the system should be such that the objective
	 *  function is optimal, but not feasible. This method will perform
	 *  an iteration of the dual simplex method to make the solution both
	 *  optimal and feasible.
	 *  
	 *  Throws
	 *  ------
	 *  InternalSolverError
	 *  	The system cannot be dual optimized.
	 */
	private function dualOptimize()
	{
		throw "dualOptimize";
	}

	/**
	 *  Compute the entering variable for a pivot operation.
	 *  This method will return first symbol in the objective function which
	 *  is non-dummy and has a coefficient less than zero. If no symbol meets
	 *  the criteria, it means the objective function is at a minimum, and an
	 *  invalid symbol is returned.
	 *  
	 *  @param objective - 
	 *  @return Symbol
	 */
	private function getEnteringSymbol( objective :Row ) : Symbol
	{
		throw "getEnteringSymbol";
		return null;
	}

	/**
	 *  Compute the entering symbol for the dual optimize operation.
	 *  This method will return the symbol in the row which has a positive
	 *  coefficient and yields the minimum ratio for its respective symbol
	 *  in the objective function. The provided row *must* be infeasible.
	 *  If no symbol is found which meats the criteria, an invalid symbol
	 *  is returned.
	 *  
	 *  @param row - 
	 *  @return Symbol
	 */
	private function getDualEnteringSymbol( row :Row ) : Symbol
	{
		throw "getDualEnteringSymbol";
		return null;
	}

	/**
	 *  Get the first Slack or Error symbol in the row.
	 *  If no such symbol is present, and Invalid symbol will be returned.
	 *  
	 *  @param row - 
	 *  @return Symbol
	 */
	private function anyPivotableSymbol( row :Row ) : Symbol
	{
		throw "anyPivotableSymbol";
		return null;
	}

	/**
	 *  Compute the row which holds the exit symbol for a pivot.
	 *  This method will return an iterator to the row in the row map
	 *  which holds the exit symbol. If no appropriate exit symbol is
	 *  found, the end() iterator will be returned. This indicates that
	 *  the objective function is unbounded.
	 *  
	 *  @param entering - 
	 *  @param cb - 
	 */
	private function getLeavingRow( entering :Symbol) : {k:Symbol,v:Row}
	{
		throw "getLeavingRow";
		return null;
	}

	/**
	 *  Compute the leaving row for a marker variable.
	 *  
	 *  This method will return an iterator to the row in the row map
	 *  which holds the given marker variable. The row will be chosen
	 *  according to the following precedence:
	 *  1) The row with a restricted basic varible and a negative coefficient
	 *     for the marker with the smallest ratio of -constant / coefficient.
	 *  2) The row with a restricted basic variable and the smallest ratio
	 *     of constant / coefficient.
	 *  3) The last unrestricted row which contains the marker.
	 *  If the marker does not exist in any row, the row map end() iterator
	 *  will be returned. This indicates an internal solver error since
	 *  the marker *should* exist somewhere in the tableau.
	 *  
	 *  @param marker - 
	 *  @param cb - 
	 *  @return //symbol,row
	 */
	private function getMarkerLeavingRow( marker :Symbol) : {k:Symbol,v:Row}
	{
		throw "getMarkerLeavingRow";
		return null;
	}

	/**
	 *  Remove the effects of a constraint on the objective function.
	 *  
	 *  @param cn - 
	 *  @param tag - 
	 */
	private function removeConstraintEffects( cn :Constraint, tag :Tag )
	{
		throw "removeConstraintEffects";
	}

	/**
	 *  Remove the effects of an error marker on the objective function.
	 *  
	 *  @param marker - 
	 *  @param strength - 
	 */
	private function removeMarkerEffects( marker :Symbol, strength :Strength )
	{
		throw "removeMarkerEffects";
	}

	/**
	 *  Test whether a row is composed of all dummy variables.
	 *  
	 *  @param row - 
	 *  @return Bool
	 */
	private function allDummies( row :Row ) : Bool
	{
		throw "allDummies";
		return false;
	}

	private var m_cns :CnMap;
	private var m_rows :RowMap;
	private var m_vars :VarMap;
	private var m_edits :EditMap;
	private var m_infeasible_rows :Array<Symbol>;
	private var m_objective :Row;
	private var m_artificial :Row;
}