// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2015, Alex Russell (slightlyoff@chromium.org)
// Haxe Port (C) 2017, Jeremy Meltingtallow

package jasper;

import jasper.Hashable;
import jasper.C;

class HashSet<T:Hashable> implements Hashable
{
    public var hashCode (default, null) : Int;
    public var size (get, null) : Int;

    public function new(?iter :Iterable<T>) : Void
    {
        this.hashCode = C._inc();
        _store = new Map();

        if(iter != null ) {
            for(val in iter) {
                _store.set(val.hashCode, val);
            }
        }
    }

    public function add(item :T) : Void
    {
        this._store.set(item.hashCode, item);
    }

    public function has(item :T) : Bool
    {   
        return this._store.exists(item.hashCode);
    }

    private function get_size() : Int
    {
        // return this._store.size;
        return 0;
    }

    public function clear() : Void
    {
    //   this._store.clear();
    }

    public function values() : Array<T>
    {
        var values :Array<T> = [];
        for(val in _store.iterator()) {
            values.push(val);
        }
        return values;
    }

    public function first() : T
    {
        var iter = this._store.iterator();
        if(iter.hasNext()) {
            return iter.next();
        }
        return null;
    }

    public function delete(item :T) : Void
    {
        this._store.remove(item.hashCode);
    }

    public function each (callback : T -> Void) : Void
    {
    }

    public function escapingEach(func : T -> Void) : Void
    {
    }

    public function toString() : String
    {
        var answer = this.size + " {";
        var first = true;

        this.each(function(e) {
            if (!first) {
                answer += ", ";
            } else {
                first = false;
            }
            answer += e;
        });

        answer += "}\n";
        return answer;
    }

    private var _store :Map<Int, T>;
}