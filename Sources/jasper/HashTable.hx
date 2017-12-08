// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

package jasper;

import jasper.Hashable;

class HashTable<K:Hashable, V> implements Hashable
{
    public var hashCode (default, null) :Int;
    public var size (get, null) :Int;

    /**
     *  [Description]
     *  @param ht - 
     */
    public function new(?ht :HashTable<K,V>) : Void
    {
        _store = new Map<Int,V>();

        if(ht != null) {
            for(key in _store.keys()) {
                _store.set(key, _store.get(key));
            }
        }
    }

    /**
     *  [Description]
     *  @param key - 
     *  @return V
     */
    public function get(key :K) : V
    {
        return _store.get(key.hashCode);
    }

    /**
     *  [Description]
     *  @return HashTable<K,V>
     */
    public function clone() : HashTable<K,V>
    {
        return new HashTable(this);
    }

    /**
     *  [Description]
     */
    public function clear() : Void
    {
        // this._store.clear();
    }

    /**
     *  [Description]
     *  @return Int
     */
    private function get_size() :Int
    {
    //   return this._store.size;
        return 0;
    }

    /**
     *  [Description]
     *  @param key - 
     *  @param value - 
     */
    public function set(key :K, value :V) : Void
    {
        // if (!key.hashCode) debugger;
        return this._store.set(key.hashCode, value);
    }

    /**
     *  [Description]
     *  @param key - 
     *  @return Bool
     */
    public function has(key :K) : Bool
    {
        return this._store.exists(key.hashCode);
    }

    /**
     *  [Description]
     *  @param key - 
     */
    public function delete(key :K) : Void
    {
        this._store.remove(key.hashCode);
    }

    public function each(callback) : Void
    {
    }

    /**
     *  [Description]
     *  @param callback - 
     */
    public function escapingEach(callback)
    {
        return null;
    }

    /**
     *  [Description]
     *  @param other - 
     *  @return Bool
     */
    public function equals(other :HashTable<K,V>) : Bool
    {
        if (other == this) {
            return true;
        }

        if (other.size != this.size) {
            return false;
        }

        for(x in this._store.keys()) {
            if (other._store.get(x) == null) {
                return false;
            }
        }

        return true;
    }

    private var _store :Map<Int,V>;
}