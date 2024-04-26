package canvas.utils;

/**
 * A integer value that represents a boolean.
 * 
 * - `0` being off
 * - `1` being on
 * 
 * You can also use regular boolean values such as `true`
 * and `false` in functions that utilize int booleans.
 */
abstract IntBool(Bool) from Bool to Bool {
    @:from
    public static inline function fromInt(int:Int):IntBool {
        #if cpp
        return untyped __cpp__("{0}", int);
        #else
        return int != 0;
        #end
    }

    @:to
    public static inline function toInt(bool:Bool):Int {
        #if cpp
        return untyped __cpp__("{0}", bool);
        #else
        return (bool) ? 1 : 0;
        #end
    }
}