/**
 * Copyright 2012 Alex Russell <slightlyoff@google.com>.
 *
 * Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
 *
 * This is an API compatible re-implementation of the subset of jshashtable
 * which Cassowary actually uses.
 *
 * Features removed:
 *
 *     - multiple values per key
 *     - error tollerent hashing of any variety
 *     - overly careful (or lazy) size counting, etc.
 *     - Crockford's "class" pattern. We use the system from c.js.
 *     - any attempt at back-compat with broken runtimes.
 *
 * APIs removed, mostly for lack of use in Cassowary:
 *
 *     - support for custom hashing and equality functions as keys to ctor
 *     - isEmpty() -> check for !ht.size()
 *     - putAll()
 *     - entries()
 *     - containsKey()
 *     - containsValue()
 *     - keys()
 *     - values()
 *
 * Additions:
 *
 *     - new "scope" parameter to each() and escapingEach()
 */

(function(c) {
"use strict";

if (c._functionalMap) {

  c.HashTable = c.inherit({

    initialize: function(ht) {
      this.hashCode = c._inc();
      if (ht instanceof c.HashTable) {
        this._store = new Map(ht._store);
      } else {
        this._store = new Map();
      }
    },

    clone: function() {
      return new c.HashTable(this);
    },

    get: function(key) {
      var r = this._store.get(key.hashCode);
      if (r === undefined) {
        return null;
      }
      return r[1];
    },

    clear: function() {
      this._store.clear();
    },

    get size() {
      return this._store.size;
    },

    set: function(key, value) {
      // if (!key.hashCode) debugger;
      return this._store.set(key.hashCode, [key, value]);
    },

    has: function(key) {
      return this._store.has(key.hashCode);
    },

    delete: function(key) {
      return this._store.delete(key.hashCode);
    },

    each: function(callback, scope) {
      this._store.forEach(function(v, k) {
        return callback.call(scope||null, v[0], v[1]);
      }, scope);
    },

    escapingEach: function(callback, scope) {
      if (!this._store.size) { return; }

      var context;
      var keys = [];
      var rec;
      var vi = this._store.values();
      var rec = vi.next();

      while(!rec.done) {
        context = callback.call(scope||null, rec.value[0], rec.value[1]);

        if (context) {
          if (context.retval !== undefined) {
            return context;
          }
          if (context.brk) {
            break;
          }
        }
        rec = vi.next();
      }
    },

    equals: function(other) {
      if (other === this) {
        return true;
      }

      if (!(other instanceof c.HashTable) || other._size !== this._size) {
        return false;
      }

      for(var x in this._store.keys()) {
        if (other._store.get(x) == undefined) {
          return false;
        }
      }
      return true;
    },

  });

} else {
  // For escapingEach
  var defaultContext = {};
  var copyOwn = function(src, dest) {
    Object.keys(src).forEach(function(x) {
      dest[x] = src[x];
    });
  };


  c.HashTable = c.inherit({

    initialize: function() {
      this.size = 0;
      this._store = {};
      this._deleted = 0;
    },

    set: function(key, value) {
      var hash = key.hashCode;

      if (typeof this._store[hash] == "undefined") {
        // FIXME(slightlyoff): if size gooes above the V8 property limit,
        // compact or go to a tree.
        this.size++;
      }
      this._store[hash] = [ key, value ];
    },

    get: function(key) {
      if(!this.size) { return null; }

      key = key.hashCode;

      var v = this._store[key];
      if (typeof v != "undefined") {
        return v[1];
      }
      return null;
    },

    clear: function() {
      this.size = 0;
      this._store = {};
    },

    _compact: function() {
      // console.time("HashTable::_compact()");
      var ns = {};
      copyOwn(this._store, ns);
      this._store = ns;
      // console.timeEnd("HashTable::_compact()");
    },

    _compactThreshold: 100,
    _perhapsCompact: function() {
      // If we have more properties than V8's fast property lookup limit, don't
      // bother
      if (this._size > 30) return;
      if (this._deleted > this._compactThreshold) {
        this._compact();
        this._deleted = 0;
      }
    },

    delete: function(key) {
      key = key.hashCode;
      if (!this._store.hasOwnProperty(key)) {
        return;
      }
      this._deleted++;

      // FIXME(slightlyoff):
      //    I hate this because it causes these objects to go megamorphic = (
      //    Sadly, Cassowary is hugely sensitive to iteration order changes, and
      //    "delete" preserves order when Object.keys() is called later.
      delete this._store[key];

      if (this.size > 0) {
        this.size--;
      }
    },

    each: function(callback, scope) {
      if (!this.size) { return; }

      this._perhapsCompact();

      var store = this._store;
      for (var x in this._store) {
        if (this._store.hasOwnProperty(x)) {
          callback.call(scope||null, store[x][0], store[x][1]);
        }
      }
    },

    escapingEach: function(callback, scope) {
      if (!this.size) { return; }

      this._perhapsCompact();

      var that = this;
      var store = this._store;
      var context = defaultContext;
      var kl = Object.keys(store);
      for (var x = 0; x < kl.length; x++) {
        (function(v) {
          if (that._store.hasOwnProperty(v)) {
            context = callback.call(scope||null, store[v][0], store[v][1]);
          }
        })(kl[x]);

        if (context) {
          if (context.retval !== undefined) {
            return context;
          }
          if (context.brk) {
            break;
          }
        }
      }
    },

    clone: function() {
      var n = new c.HashTable();
      if (this.size) {
        n.size = this.size;
        copyOwn(this._store, n._store);
      }
      return n;
    },

    equals: function(other) {
      if (other === this) {
        return true;
      }

      if (!(other instanceof c.HashTable) || other._size !== this._size) {
        return false;
      }

      var codes = Object.keys(this._store);
      for (var i = 0; i < codes.length; i++) {
        var code = codes[i];
        if (this._store[code][0] !== other._store[code][0]) {
          return false;
        }
      }

      return true;
    },

    toString: function(h) {
      var answer = "";
      this.each(function(k, v) { answer += k + " => " + v + "\n"; });
      return answer;
    },

    toJSON: function() {
      /*
      var d = {};
      this.each(function(key, value) {
        d[key.toString()] = (value.toJSON) ? value.toJSON : value.toString();
      });
      */
      return {
        _t: "c.HashTable",
        /*
        store: d
        */
      };
    },

    fromJSON: function(o) {
      var r = new c.HashTable();
      /*
      if (o.data) {
        r.size = o.data.length;
        r._store = o.data;
      }
      */
      return r;
    },
  });
}

})(this["c"]||module.parent.exports||{});
