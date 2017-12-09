// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

package jasper.data;

abstract Value(Float) {
    inline public function new(flt:Float) {
        this = flt;
    }

    public function toConstant() : Constant
    {
        return new Constant(this);
    }

    public function abs() : Value
    {
        return new Value(Math.abs(this));
    }
}