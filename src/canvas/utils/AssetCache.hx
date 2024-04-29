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
     * Removes an item of the given key
     * from the cache.
     * 
     * @param  key  A key to the item to remove.
     */
    public function remove(key:String):Void {
        if(_cache.exists(key))
            _cache.remove(key);
    }

    /**
     * Directly removes an item from the cache.
     * 
     * @param  item  The item to remove.
     */
    public function removeItem(item:T):Void {
        for(i in _cache) {
            if(i == item) {
                _cache.remove(item);
                break;
            }
        }
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