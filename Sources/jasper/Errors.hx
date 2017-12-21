package jasper;

import jasper.Symbolics.Variable;

class UnsatisfiableConstraint
{
    public function new(constraint :Constraint) : Void
    {
    }
}

class UnknownConstraint
{
    public function new(constraint :Constraint) : Void
    {
    }
}

class DuplicateConstraint
{
    public function new(constraint :Constraint) : Void
    {
    }
}

class UnknownEditVariable
{
    public function new(variable :Variable) : Void
    {
    }
}

class DuplicateEditVariable
{
    public function new(variable :Variable) : Void
    {
    }
}

class BadRequiredStrength
{
    public function new() : Void
    {
    }
}

class InternalSolverError
{
    public function new(message :String) : Void
    {
    }
}