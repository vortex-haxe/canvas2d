package canvas.utils;

/**
 * A simple disposable object template.
 */
interface IDisposable {
    public function dispose():Void;
}

/**
 * A simple asset cache, compatible with
 * any type that is an `IDisposable`.
 */
class AssetCache<T:IDisposable> implements IDisposable {
    /**
     * Makes a new `AssetCache` instance.
     */
    public function new() {}

    /**
     * Returns whether or not an item of a
     * given key exists within the cache.
     * 
     * @param  key  The key of the item to check.
     */
    public function exists(key:String):Bool {
        return _cache.get(key) != null;
    }

    /**
     * Retrieves an item from the cache
     * with the given key, and then returns it.
     * 
     * @param  key  The key of the item to retrieve from cache.
     */
    public function get(key:String):T {
        return _cache.get(key);
    }

    /**
     * Adds an item to the cache with
     * a given key and value.
     * 
     * @param  key    The key of the new item.
     * @param  value  The value of the new item.
     */
    public function add(key:String, value:T):Void {
        _cache.set(key, value);
    }

    /**
     * Disposes everything in this cache.
     */
    public function dispose():Void {
        for(item in _cache) {
            if(item != null)
                item.dispose();
        }
        _cache.clear();
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //

    private var _cache:Map<String, T> = [];
}