// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

package jasper;

import jasper.SymbolicWeight;

//Looks complete but not tested

class Strength 
{
    public var name :String;
    public var symbolicWeight :SymbolicWeight;
    public var required (get, null) : Bool;

    /**
     *  [Description]
     *  @param name - 
     *  @param symbolicWeight - 
     */
    public function new(name :String, symbolicWeight :SymbolicWeight) : Void
    {
        this.name = name;
        this.symbolicWeight = symbolicWeight;
    }

    /**
     *  [Description]
     *  @param name - 
     *  @param w1 - 
     *  @param w2 - 
     *  @param w3 - 
     *  @return Strength
     */
    public static inline function fromWeights(name :String, w1 :Int, w2 :Int, w3 :Int) : Strength
    {
        return new Strength(name, new SymbolicWeight(w1, w2, w3));
    }
    
    /**
     *  [Description]
     *  @return Bool
     */
    private function get_required() : Bool
    {
        return (this == Strength.REQUIRED);
    }

    /**
     *  [Description]
     *  @return String
     */
    public function toString() :String
    {
        return this.name + (!this.required ? (":" + this.symbolicWeight) : "");
    }

    public static var REQUIRED = Strength.fromWeights("<Required>", 1000, 1000, 1000);
    public static var STRONG = Strength.fromWeights("strong", 1, 0, 0);
    public static var MEDIUM = Strength.fromWeights("medium", 0, 1, 0);
    public static var WEAK = Strength.fromWeights("weak", 0, 0, 1);
}