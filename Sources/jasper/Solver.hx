/*
 * MIT License
 *
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

package jasper;

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
        this.suggestValue( variable, value );
    }

    /**
     *  Update the values of the external solver variables.
     */
    public inline function updateVariables() : Void
    {
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
        this.reset();
    }

    /**
     *  Dump a representation of the solver internals to stdout.
     */
    public function dump() : Void
    {
        throw "dump";
    }
}