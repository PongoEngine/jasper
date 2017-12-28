/*
 * Copyright (c) 2013-2017, Nucleic Development Team.
 * Haxe Port Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Distributed under the terms of the Modified BSD License.
 *  
 *  The full license is in the file COPYING.txt, distributed with this software.
*/

package jasper;

// @:notNull
// abstract Symbol(SymbolType) to Int
class Symbol
{
    public var m_type (default, null):SymbolType;
    public var m_id (default, null):Id;
    
    /**
     *  [Description]
     *  @param type - 
     */
    public inline function new(id :Id, type :SymbolType) : Void
    {
        m_type = type;
        m_id = id;
    }
}

enum SymbolType
{
    INVALID;
    EXTERNAL;
    SLACK;
    ERROR;
    DUMMY;
}

abstract Id(Int)
{
    public inline function new(id :Int) : Void
    {
        this = id;
    }

    @:op(A++) static function increment(A:Id) :Id;
}