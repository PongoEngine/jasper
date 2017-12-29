/*
 * Copyright (c) 2013-2017, Nucleic Development Team.
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Distributed under the terms of the Modified BSD License.
 *  
 * The full license is in the file COPYING.txt, distributed with this software.
*/

package jasper;

class Symbol
{
    public var m_type (default, null):SymbolType;
    public var m_id (default, null):Id;
    
    public function new(type :SymbolType = SYM_INVALID, id :Id = ID_0) : Void
    {
        m_type = type;
        m_id = id;
    }

    private static inline var ID_0 = new Id(0);
    private static inline var SYM_INVALID = INVALID;
}

@:enum
@:notNull
abstract SymbolType(Int)
{
    var INVALID = 0;
    var EXTERNAL = 1;
    var SLACK = 2;
    var ERROR = 3;
    var DUMMY = 4;
}

@:notNull
abstract Id(Int)
{
    public inline function new(id :Int) : Void
    {
        this = id;
    }

    @:op(A++) static function increment(A:Id) :Id;
}