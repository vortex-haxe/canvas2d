package canvas.app;

/**
 * Event is a strictly-typed signals and slots implementation, used for
 * core event dispatching.
 * 
 * For example:
 * 
 * ```haxe
 * var event = new Event<Int->Void> ();
 * event.add((value:Int) -> trace(value));
 * event.dispatch(100);
 * 
 * var event = new Event<Void->Void> ();
 * event.add(() -> trace("callback"));
 * event.dispatch();
 * ```
 * 
 * @see https://github.com/openfl/lime/blob/master/src/lime/app/Event.hx
 */
#if !macro
@:genericBuild(canvas._backend.macros.EventMacro.build())
#end
class Event<T> {
    /**
     * Whether the event was cancelled during the previous dispatch
     */
    public var cancelled(default, null):Bool;

    /**
     * Makes a new `Event` instance.
     */
    public function new() {
        #if !macro
        cancelled = false;
        __listeners = new Array();
        __priorities = new Array<Int>();
        __repeat = new Array<Bool>();
        #end
    }

    /**
     * Adds a new event listener
     * 
     * @param  listener  A callback that matches the signature of the event
     * @param  once	     Whether to receive an event dispatch only once, or each time it is fired
     * @param  priority  The priority for this listener, a higher priority will be dispatched sooner
     */
    public function add(listener:T, once:Bool = false, priority:Int = 0):Void {
        #if !macro
        for (i in 0...__priorities.length) {
            if (priority > __priorities[i]) {
                __listeners.insert(i, cast listener);
                __priorities.insert(i, priority);
                __repeat.insert(i, !once);
                return;
            }
        }
        __listeners.push(cast listener);
        __priorities.push(priority);
        __repeat.push(!once);
        #end
    }

    /**
     * Marks the event as cancelled, and stops the current event dispatch
     */
    public function cancel():Void {
        cancelled = true;
    }

    /**
     * Dispatches a new event callback to all listeners. The signature for the
     * `dispatch` method depends upon the type of the `Event`. For example, an
     * `Event` of type `Int->Int->Void` will create a `dispatch` method that
     * takes two `Int` arguments, like `dispatch(1, 2);`
     */
    public var dispatch:Dynamic;

    /**
     * Checks whether a callback is a listener to this event
     * 
     * @param  listener  A callback that matches the signature of the event
     * 
     * @return Whether the callback is a listener
    **/
    public function has(listener:T):Bool {
        #if !macro
        for (l in __listeners) {
            if (Reflect.compareMethods(l, listener))
                return true;
        }
        #end
        return false;
    }

    /**
     * Removes an event listener
     * 
     * @param  listener  A callback that matches the signature of the event
    **/
    public function remove(listener:T):Void {
        #if !macro
        var i = __listeners.length;
        while (--i >= 0) {
            if (Reflect.compareMethods(__listeners[i], listener)) {
                __listeners.splice(i, 1);
                __priorities.splice(i, 1);
                __repeat.splice(i, 1);
            }
        }
        #end
    }

    /**
     * Removes all event listeners
     */
    public function removeAll():Void {
        #if !macro
        var len = __listeners.length;
        __listeners.splice(0, len);
        __priorities.splice(0, len);
        __repeat.splice(0, len);
        #end
    }

    @:dox(hide)
    @:noCompletion
    public var __listeners:Array<T>;

    @:dox(hide)
    @:noCompletion
    public var __repeat:Array<Bool>;

    @:dox(hide)
    @:noCompletion
    private var __priorities:Array<Int>;
}