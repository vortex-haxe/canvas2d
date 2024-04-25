package canvas.graphics;

import cpp.Pointer;
import stb.Image;

import canvas.servers.RenderingServer;
import canvas.servers.RenderingServer.ITextureData;

import canvas.math.Vector2i;
import canvas.utils.UInt8Array;
import canvas.utils.AssetCache.IDisposable;

enum abstract BitmapType(Int) from Int to Int {
    final NORMAL = 0;
    final RENDER;
}

/**
 * A simple bitmap class including basic data such as
 * width, height, pixels, etc.
 */
class BitmapData implements IDisposable {
    /**
     * The file path to the image that this bitmap used.
     * 
     * Blank if this bitmap wasn't loaded from a file.
     */
    public var filePath:String = "";

    /**
     * The width and height of the bitmap in pixels.
     * 
     * Access the width via `size.x`, and the
     * height via `size.y`.
     */
    public var size(default, null):Vector2i = new Vector2i();

    /**
     * The amount of channels in this bitmap.
     */
    public var numChannels(default, null):Int = 0;

    /**
     * The current type of this bitmap.
     * 
     * - `NORMAL` - This bitmap data is used for bitmaps and such.
     * - `RENDER` - The window will render onto this bitmap data when set as active, useful for camera systems, post-processing, or any GFX!
     */
    public var type(default, null):BitmapType = NORMAL;

    /**
     * Makes a new `BitmapData` instance.
     * 
     * @param  width   The width of the new bitmap in pixels.
     * @param  height  The height of the new bitmap in pixels.
     * @param  color   The color of each pixel in this bitmap. (Useless if width or height are set to `0`)
     */
    public function new(width:Int = 0, height:Int = 0, color:Color = null, ?type:BitmapType = NORMAL) {
        this.type = type;

        if(width == 0 || height == 0)
            return;

        if(color == null)
            color = Color.TRANSPARENT;

        switch(type) {
            case RENDER:
                size.set(width, height);
                numChannels = 4;
                
                _frameBuffer = RenderingServer.backend.createFrameBuffer();

                _data = RenderingServer.backend.createTexture(width, height, null, null, 4);
                RenderingServer.backend.setupFrameBuffer(_frameBuffer, _data);

            default:
                size.set(width, height);
                numChannels = 4;

                var pixels:UInt8Array = new UInt8Array(4 * height * width);
                var r:UInt8 = cast Std.int(color.r * 255);
                var g:UInt8 = cast Std.int(color.g * 255);
                var b:UInt8 = cast Std.int(color.b * 255);
                var a:UInt8 = cast Std.int(color.a * 255);

                for(y in 0...height) {
                    for(x in 0...width) {
                        var offset:Int = y * width * 4 + x * 4;
                        pixels[offset + 0] = r;
                        pixels[offset + 1] = g;
                        pixels[offset + 2] = b;
                        pixels[offset + 3] = a;
                    }
                }
                _data = RenderingServer.backend.createTexture(width, height, pixels, null, 4, false, REPEAT, NEAREST);
        }
    }

    /**
     * Returns a new bitmap from a given file path.
     * 
     * @param  filePath  The path to the image to load.
     */
    public static function fromFile(filePath:String):BitmapData {
        final bmp = new BitmapData();
        bmp.filePath = filePath;
        
        Image.setFlipVerticallyOnLoad(1);
        var pixels:Star<UInt8> = Image.load(filePath, Pointer.addressOf(bmp.size.x), Pointer.addressOf(bmp.size.y), Pointer.addressOf(bmp.numChannels), 0);
        
        if (pixels != 0)
            bmp._data = RenderingServer.backend.createTexture(bmp.size.x, bmp.size.y, cast pixels, null, bmp.numChannels);
        else
            Logs.trace('Image at ${filePath} failed to load: ${Image.failureReason()}', ERROR);
        
        Image.freeImage(pixels);
        return bmp;
    }

    /**
     * Disposes of this bitmap and removes it's
     * properties from memory.
     */
    public function dispose():Void {
        size = null;
        RenderingServer.backend.disposeTexture(_data);

        if(type == RENDER) {
            RenderingServer.backend.useFrameBuffer(null);
            RenderingServer.backend.disposeFrameBuffer(_frameBuffer);
            _currentRenderBitmap = null;
        }
    }

    /**
     * Sets this bitmap as the currently
     * active render bitmap if it's type is `RENDER`.
     */
    public function activate():Void {
        if(type != RENDER) {
            Logs.trace('You cannot activate a bitmap of type "NORMAL".', WARNING);
            return;
        }
        _currentRenderBitmap = this;
    }

    /**
     * Sets this bitmap as the currently
     * active render bitmap if it's type is `RENDER`.
     */
    public function deactivate():Void {
        if(type != RENDER) {
            Logs.trace('You cannot deactivate a bitmap of type "NORMAL".', WARNING);
            return;
        }
        if(type == RENDER && _currentRenderBitmap != this) {
            Logs.trace('You cannot deactivate a render bitmap that is not current.', WARNING);
            return;
        }
        _currentRenderBitmap = null;
    }

    // [ Private API ] //

    private static var _currentRenderBitmap:BitmapData;

    private var _data:ITextureData = null;
    private var _frameBuffer:IFrameBufferData = null;
}