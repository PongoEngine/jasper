package jasper.ds;

import jasper.ds.SolverMap._JasperMap_;

@:forward(remove, exists, keys)
abstract FloatMap<K:{}>(_JasperMap_<K, Float>)
{
	public inline function new() : Void
	{
		this = new _JasperMap_<K, Float>();
	}

	public inline function keyValIterator() : Iterator<{k:K,v:Float}>
	{
		return this.keyValIterator();
	}

	public function empty() : Bool
	{
		return this.empty();
	}

    @:arrayAccess
    public inline function get(key:K) : Float
    {
        return this.exists(key) ? this.get(key) : 0;
    }

    @:arrayAccess
    public inline function arrayWrite(k:K, v:Float) : Float
    {
        this.set(k, v);
        return v;
    }
}