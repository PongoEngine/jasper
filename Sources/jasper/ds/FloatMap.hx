package jasper.ds;

@:forward(remove, exists, keys, iterator)
abstract FloatMap<K:{}>(Map<K, Float>)
{
	public inline function new() : Void
	{
		this = new Map<K, Float>();
	}

	public inline function iterateKeyVal(fn : K -> Float -> Void) : Void
	{
		for(key in this.keys()) {
			var val = this.get(key);
			fn(key, val);
		}
	}

	public function empty() : Bool
	{
		return Lambda.array(this).length == 0;
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