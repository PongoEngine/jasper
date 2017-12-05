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

import haxe.ds.Either;
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
     *  @param w2 - 
     *  @param w3 - 
     */
    public function new(name :String, symbolicWeight :Either<SymbolicWeight, Int>, w2 :Int, w3 :Int) : Void
    {
        this.name = name;
        this.symbolicWeight = switch symbolicWeight {
            case Left(s): s;
            case Right(w1): new SymbolicWeight(w1, w2, w3);
        }
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

    public static var REQUIRED = new Strength("<Required>", Right(1000), 1000, 1000);
    public static var STRONG = new Strength("strong", Right(1), 0, 0);
    public static var MEDIUM = new Strength("medium", Right(0), 1, 0);
    public static var WEAK = new Strength("weak", Right(0), 0, 1);

}


// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011, Alex Russell (slightlyoff@chromium.org)

// FILE: EDU.Washington.grad.gjb.cassowary
// package EDU.Washington.grad.gjb.cassowary;

// (function(c) {

// c.Strength = c.inherit({
//   initialize: function(name /*String*/, symbolicWeight, w2, w3) {
//     this.name = name;
//     if (symbolicWeight instanceof c.SymbolicWeight) {
//       this.symbolicWeight = symbolicWeight;
//     } else {
//       this.symbolicWeight = new c.SymbolicWeight(symbolicWeight, w2, w3);
//     }
//   },

//   get required() {
//     return (this === c.Strength.required);
//   },

//   toString: function() {
//     return this.name + (!this.required ? (":" + this.symbolicWeight) : "");
//   },
// });

// /* public static final */
// c.Strength.required = new c.Strength("<Required>", 1000, 1000, 1000);
// /* public static final  */
// c.Strength.strong = new c.Strength("strong", 1, 0, 0);
// /* public static final  */
// c.Strength.medium = new c.Strength("medium", 0, 1, 0);
// /* public static final  */
// c.Strength.weak = new c.Strength("weak", 0, 0, 1);

// })(this["c"]||((typeof module != "undefined") ? module.parent.exports.c : {}));