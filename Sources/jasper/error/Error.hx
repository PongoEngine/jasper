// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

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