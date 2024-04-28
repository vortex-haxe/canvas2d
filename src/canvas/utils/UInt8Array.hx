package canvas.utils;

import haxe.ds.Vector;
import haxe.io.BytesData;

#if cpp
import cpp.Pointer;
import cpp.RawPointer;
import cpp.UInt8;
#end

/**
 * An array that stores UInt8 values.
 */
@:forward
abstract UInt8Array(BytesData) from BytesData to BytesData {
    public function new(length:Int):Void {
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
