/*
 * Copyright (c) 2013-2017, Nucleic Development Team.
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Distributed under the terms of the Modified BSD License.
 *  
 *  The full license is in the file COPYING.txt, distributed with this software.
*/

package jasper;

import jasper.Symbolics.Variable;

@:notNull
abstract Solver(SolverImpl)
{

    public inline function new() : Void
    {
        this = new SolverImpl();
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
	public inline function addConstraint(constraint :Constraint) : Void
	{
		test.Assert.notTested("Solver.hx", "addConstraint");

		this.addConstraint( constraint );
	}

	/**
	 *  Remove a constraint from the solver.
     *  
     *  Throws
     *  UnknownConstraint: The given constraint has not been added to the solver.
     *  
	 *  @param constraint - 
	 */
	public inline function removeConstraint(constraint :Constraint) : Void
	{
		test.Assert.notTested("Solver.hx", "removeConstraint");
		
		this.removeConstraint( constraint );
	}

	/**
	 *  Test whether a constraint has been added to the solver.
     *  
	 *  @param constraint - 
	 *  @return Bool
	 */
	public inline function hasConstraint(constraint :Constraint) : Bool
	{
		test.Assert.notTested("Solver.hx", "hasConstraint");
		
		return this.hasConstraint( constraint );
	}

	/**
	 *  Add an edit variable to the solver.
     *  
     *  This method should be called before the `suggestValue` method is
     *  used to supply a suggested value for the given edit variable.
     *  
     *  Throws
     *  DuplicateEditVariable: The given edit variable has already been added to the solver.
     *  BadRequiredStrength: The given strength is >= required.
     *  
	 *  @param variable - 
	 *  @param strength - 
	 */
	public inline function addEditVariable(variable :Variable, strength :Strength) : Void
	{
		test.Assert.notTested("Solver.hx", "addEditVariable");
		
		this.addEditVariable( variable, strength );
	}

	/**
	 *  Remove an edit variable from the solver.
     *  
     *  Throws
     *  UnknownEditVariable: The given edit variable has not been added to the solver.
     *  
	 *  @param variable - 
	 */
	public inline function removeEditVariable(variable :Variable) : Void
	{
		test.Assert.notTested("Solver.hx", "removeEditVariable");
		
		this.removeEditVariable( variable );
	}

	/**
	 *  Test whether an edit variable has been added to the solver.
     *  
	 *  @param variable - 
	 *  @return Bool
	 */
	public inline function hasEditVariable(variable :Variable) : Bool
	{
		test.Assert.notTested("Solver.hx", "hasEditVariable");
		
		return this.hasEditVariable( variable );
	}

	/**
	 *  Suggest a value for the given edit variable.
     *  
     *  This method should be used after an edit variable as been added to
     *  the solver in order to suggest the value for that variable. After
     *  all suggestions have been made, the `solve` method can be used to
     *  update the values of all variables.
     *  
     *  Throws
     *  UnknownEditVariable: The given edit variable has not been added to the solver.
     *  
	 *  @param variable - 
	 *  @param value - 
	 */
	public inline function suggestValue(variable :Variable, value :Float) : Void
	{
		test.Assert.notTested("Solver.hx", "suggestValue");
		
		this.suggestValue( variable, value );
	}

	/**
	 *  Update the values of the external solver variables.
	 */
	public inline function updateVariables() : Void
	{
		test.Assert.notTested("Solver.hx", "updateVariables");
		
		this.updateVariables();
	}

	/**
	 *  Reset the solver to the empty starting condition.
     *  
     *  This method resets the internal solver state to the empty starting
     *  condition, as if no constraints or edit variables have been added.
     *  This can be faster than deleting the solver and creating a new one
     *  when the entire system must change, since it can avoid unecessary
     *  heap (de)allocations.
	 */
	public function reset() : Void
	{
		test.Assert.notTested("Solver.hx", "reset");
		
		// m_impl.reset();
	}

	/**
	 *  Dump a representation of the solver internals to stdout.
	 */
	public function dump() : Void
	{
		test.Assert.notTested("Solver.hx", "dump");
		
		// debug::dump( m_impl );
	}
}