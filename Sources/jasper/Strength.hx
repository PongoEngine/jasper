/*
 * Copyright (c) 2017 Jeremy Meltingtallow
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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