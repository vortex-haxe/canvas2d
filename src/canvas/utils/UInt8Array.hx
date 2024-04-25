package canvas.utils;

import haxe.ds.Vector;

#if cpp
import cpp.Pointer;
import cpp.RawPointer;
typedef UInt8 = cpp.UInt8;
typedef Star<T> = cpp.Star<T>;
#else
typedef UInt8 = UInt;
typedef Star<T> = T;
#end

/**
 * An array that stores UInt8 values.
 */
@:forward
abstract UInt8Array(Array<UInt8>) from Array<UInt8> to Array<UInt8> {
    public function new(length:Int) {
        this = cast new Vector(length);
    }

    #if cpp
    @:to public inline function toPtr():Pointer<UInt8> {
        return Pointer.ofArray(this);
    }

    @:to public inline function toRawPtr():RawPointer<UInt8> {
        return cast Pointer.ofArray(this);
    }
    #end
}