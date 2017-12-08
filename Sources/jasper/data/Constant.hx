// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

package jasper.data;

abstract Constant(Float)
{
    inline public function new(const :Float) {
        this = const;
    }

    public function toVal() : Float
    {
        return this;
    }

    @:op(A + B) static public function add(lhs:Constant, rhs:Constant):Constant;
    @:op(A * B) static public function multiply(lhs:Constant, rhs:Constant):Constant;
    @:op(A / B) static public function divide(lhs:Constant, rhs:Constant):Constant;
    @:op(A == B) static public function equals(lhs:Constant, rhs:Constant):Bool;

    
}