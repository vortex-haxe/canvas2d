package canvas.graphics;

import cpp.Helpers;
import cpp.UInt8;
import cpp.UInt32;
import cpp.RawPointer;

import glad.Glad;

import canvas._backend.bindings.Freetype;
import canvas.graphics.BitmapData;

import canvas.servers.RenderingServer;
import canvas.utils.AssetCache.IDisposable;

@:structInit
private class FontTexture {
    public var bitmapData:BitmapData;
    public var bearingX:Int;
    public var bearingY:Int;
    public var advance:Int;
}

@:access(canvas.graphics.BitmapData)
class Font implements IDisposable {
    /**
     * The file path to the font file that this font used.
     */
    public var filePath:String;
    
    /**
     * Makes a new `Font` instance.
     * 
     * @param  filePath  A file path to the font file to load.
     */
    public function new(filePath:String) {
        this.filePath = filePath;
        Freetype.newFace(_library, filePath, 0, RawPointer.addressOf(_face));
    }

    /**
     * Disposes of this font and removes it's
     * properties from memory.
     */
    public function dispose():Void {
        Freetype.doneFace(_face);
        for(size in _sizes.iterator()) {
            for(tex in size.iterator())
                tex.bitmapData.dispose();
        }
        _sizes.clear();
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //

    private static final _loadFlags:UInt32 = Freetype.LOAD_RENDER;
    private static var _library:FreetypeLib;

    private var _face:FreetypeFace;
    private var _sizes:Map<Int, Map<Int, FontTexture>> = [];

    private function _preloadSize(size:Int):Void {
        for(i in 32...127)
            _getLetter(i, size);
    }

    private function _getLetter(letter:Int, size:Int) {
        if(!_sizes.exists(size))
            _sizes[size] = new Map<Int, FontTexture>();

        if(!_sizes[size].exists(letter)) {
            Freetype.setPixelSizes(_face, 0, size);

            final errCode = Freetype.loadChar(_face, cast letter, _loadFlags);
            if (errCode != 0) {
                Logs.trace('Error occured loading "${String.fromCharCode(letter)}" for ${filePath}: $errCode', ERROR);
                _sizes[size].set(letter, {
                    bitmapData: null,
                    bearingX: 0,
                    bearingY: 0,
                    advance: 6
                });
                return _sizes[size].get(letter);
            }

            var newBmpData = new BitmapData();
            newBmpData.size.set(
                cast _face[0].glyph.bitmap.width,
                cast _face[0].glyph.bitmap.rows
            );

            var width:Int = newBmpData.size.x;
            var height:Int = newBmpData.size.y;

            var buffer:RawPointer<UInt8> = _face[0].glyph.bitmap.buffer;
            var goodBuffer:RawPointer<UInt8> = Helpers.malloc(width * height * 4, UInt8);
            
            for(y in 0...height) {
                for(x in 0...width) {
                    var badOffset:Int = (y * width) + x;
                    var offset:Int = (height - y - 1) * width * 4 + x * 4;
                    goodBuffer[offset + 0] = 255;
                    goodBuffer[offset + 1] = 255;
                    goodBuffer[offset + 2] = 255;
                    goodBuffer[offset + 3] = buffer[badOffset];
                }
            }
            newBmpData._data = RenderingServer.backend.createTexture(cast _face[0].glyph.bitmap.width, cast _face[0].glyph.bitmap.rows, goodBuffer, null, 4, false, CLAMP_EDGE);
            
            _sizes[size].set(letter, {
                bitmapData: newBmpData,
                bearingX: _face[0].glyph.bitmapLeft,
                bearingY: _face[0].glyph.bitmapTop,
                advance: cast _face[0].glyph.advance.x
            });
            Helpers.free(goodBuffer);
        }
        return _sizes[size].get(letter);
    }
}