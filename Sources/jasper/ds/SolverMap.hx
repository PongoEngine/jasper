package jasper.ds;

@:forward(exists, remove, iterator)
abstract SolverMap<K:{},V>(Map<K,V>)
{
	public inline function new() : Void
	{
		this = new Map<K,V>();
	}

	public inline function keyVal(key :K, fn : K -> V -> Void) : Void
	{
		if(this.exists(key)) {
			var val = this.get(key);
			fn(key, val);
		}
	}

	public inline function iterateKeyVal(fn : K -> V -> Void) : Void
	{
		for(key in this.keys()) {
			var val = this.get(key);
			fn(key, val);
		}
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