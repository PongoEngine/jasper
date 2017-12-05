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

package jasper.error;

//Looks complete but not tested

class Error
{
    public var message (get, null) : String;
    public var description (get, set) : String;

    public function new(name :String, description :String) : Void
    {
        _name = name;
        _description = description;
    }

    private function get_description() : String
    {
        return "(" + this._name + ") " + this._description;
    }

    private function set_description(desc :String) : String
    {
        return this._description = desc;
    }

    private function get_message() : String
    {
        return this.description;
    }

    public function toString() : String
    {
        return this.description;
    }

    private var _description :String;
    private var _name :String;
}