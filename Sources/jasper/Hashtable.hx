/*
 * Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

// FILE: EDU.Washington.grad.gjb.cassowary
// package EDU.Washington.grad.gjb.cassowary;

package jasper;

import jasper.Hashable;
import jasper.Stringable;

class Hashtable<K :Hashable,V> implements Stringable
{
	public function new() : Void
	{
		_map = new Map<K, V>();
	}

	public function get(key :K) : V
	{
		return _map.get(key);
	}

	public function put(key :K, value :V) : Void
	{
		return _map.set(key, value);
	}

	public function remove(key :K) : V
	{
		var val = _map.get(key);
		_map.remove(key);
		return val;
	}

	public function size() : Int
	{
		return 0;
	}

	public function each(fn : K -> V -> Void) : Void
	{
		for(key in _map.keys()) {
			fn(key, _map.get(key));
		}
	}

	public function clone() : Hashtable<K,V>
	{
		var clone = new Hashtable<K,V>();

		for(key in _map.keys()) {
			clone.put(key, _map.get(key));
		}

		return clone;
	}

	public function toString() : String
	{
		var answer = "";

		each( function(k,v) {
			answer += k + " => ";

			if(Std.is(v, Stringable)) {
				answer += cast(v, Stringable).toString();
			}
			else {
				answer += v + "\n";
			}
		});

		return answer;
	}

	private var _map :Map<K, V>;
}