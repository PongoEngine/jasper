package jasper.ds;

import haxe.Constraints.IMap;

@:forward(exists, remove)
abstract SolverMap<K:{},V>(_JasperMap_<K,V>)
{
	public inline function new() : Void
	{
		this = new _JasperMap_<K,V>();
	}

	@:arrayAccess
    public inline function get(key:K) : V
    {
        return this.get(key);
    }

    @:arrayAccess
    public inline function arrayWrite(k:K, v:V) : V
    {
        this.set(k, v);
        return v;
    }
}

class _JasperMap_<K:{},V> implements IMap<K, V>
{
	public function new() : Void
	{
		_keys = [];
		_map = new Map();
	}

	public function empty() : Bool
	{
		return _keys.length == 0;
	}

	public inline function exists(key :K) : Bool
	{
		return _map.exists(key);
	}

	public inline function get(key :K) : V
	{
		return _map.get(key);
	}

	public inline function iterator() : JasperIterator<K,V>
	{
		return new JasperIterator(this);
	}

	public inline function keyValIterator() : KeyValIterator<K,V>
	{
		return new KeyValIterator(this);
	}

	public inline function keys() : Iterator<K>
	{
		return _keys.iterator();
	}

	public inline function remove(key :K) : Bool
	{
		return _map.remove(key) && _keys.remove(key);
	}

	public inline function set(key :K, value :V) : Void
	{
		if (!_map.exists(key)) {
			_keys.push(key);
		}
        _map[key] = value;
	}

	public inline function toString() : String
	{
		return _map.toString();
	}

	private var _map :Map<K, V>;
	@:allow(jasper.ds.JasperIterator)
	@:allow(jasper.ds.KeyValIterator)
    private var _keys :Array<K>;
}

private class JasperIterator<K:{},V> 
{
    public function new(map :_JasperMap_<K,V>) 
	{
        _map = map;
	}

    public function hasNext() : Bool 
	{
        return _index < _map._keys.length;
	}

    public function next() : V
	{
        return _map.get(_map._keys[_index++]);
	}

	private var _map : _JasperMap_<K,V>;
    private var _index : Int = 0;
}

private class KeyValIterator<K:{},V> 
{
    public function new(map :_JasperMap_<K,V>) 
	{
        _map = map;
		_item = {k:null,v:null};
	}

    public function hasNext() : Bool 
	{
        return _index < _map._keys.length;
	}

    public function next() : {k:K,v:V}
	{
		_item.k = _map._keys[_index++];
		_item.v = _map.get(_item.k);
        return _item;
	}

	private var _map : _JasperMap_<K,V>;
    private var _index : Int = 0;
	private var _item :{k:K,v:V};
}