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

//Looks complete but not tested

class SymbolicWeight 
{
    public var value :Int;

    /**
     *  [Description]
     *  @param w1 - 
     *  @param w2 - 
     *  @param w3 - 
     */
    public function new(w1 :Int, w2 :Int, w3 :Int) : Void
    {
        this.value = 0;
        init(w1,w2,w3);
    }

    /**
     *  [Description]
     *  @param w1 - 
     *  @param w2 - 
     *  @param w3 - 
     */
    private inline function init(w1 :Int, w2 :Int, w3 :Int) : Void
    {
        var factor = 1;

        this.value += w1 * factor;
        factor *= MULTIPLIER;
        this.value += w2 * factor;
        factor *= MULTIPLIER;
        this.value += w3 * factor;
        factor *= MULTIPLIER;
    }

    private static inline var MULTIPLIER = 1000;
}