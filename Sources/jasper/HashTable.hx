// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

package jasper;

import jasper.Hashable;

class HashTable<K:Hashable, V> implements Hashable
{

    public var hashCode (default, null):Int;

    public function new(?ht :HashTable<K,V>) : Void
    {
        _store = new Map<Int,V>();

        if(ht != null) {
            for(key in _store.keys()) {
                _store.set(key, _store.get(key));
            }
        }
    }

    public function get(key :K) : V
    {
        return _store.get(key.hashCode);
    }

    public function clone() : HashTable<K,V>
    {
        return new HashTable(this);
    }

    private var _store :Map<Int,V>;
}