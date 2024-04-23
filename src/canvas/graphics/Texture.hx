package canvas.graphics;

import cpp.Star;
import cpp.UInt8;
import cpp.Pointer;
import cpp.RawPointer;
import cpp.Helpers;

import stb.Image;

import canvas.servers.RenderingServer;
import canvas.servers.RenderingServer.ITextureData;

import canvas.math.Vector2i;

enum abstract TextureType(Int) from Int to Int {
    final NORMAL = 0;
    final RENDER;
}

/**
 * A simple texture class including basic data such as
 * width, height, pixels, etc.
 */
class Texture {
    /**
     * The file path to the image that this texture used.
     * 
     * Blank if this texture wasn't loaded from a file.
     */
    public var filePath:String = "";

    /**
     * The width and height of the texture in pixels.
     */
    public var size(default, null):Vector2i = Vector2i.ZERO;

    /**
     * The amount of channels in this texture.
     */
    public var numChannels(default, null):Int = 0;

    /**
     * The current type of this texture.
     * 
     * - `NORMAL` - This texture is used for sprites and such.
     * - `RENDER` - The window will render onto this texture when set as active, useful for camera systems, post-processing, or any GFX!
     */
    public var type(default, null):TextureType = NORMAL;

    /**
     * Makes a new `Texture`.
     * 
     * @param  width   The width of the new texture in pixels.
     * @param  height  The height of the new texture in pixels.
     * @param  color   The color of each pixel in this texture. (Useless if width or height are set to `0`)
     */
    public function new(width:Int = 0, height:Int = 0, color:Color = null, ?type:TextureType = NORMAL) {
        this.type = type;

        if(width == 0 || height == 0)
            return;

        if(color == null)
            color = Color.TRANSPARENT;

        switch(type) {
            case RENDER:
                _frameBuffer = RenderingServer.backend.createFrameBuffer();

                final _tex = RenderingServer.backend.createTexture(width, height, null, 3);
                RenderingServer.backend.setupFrameBuffer(_frameBuffer, _tex);

            default:
                size.set(width, height);
                numChannels = 4;

                var pixels:RawPointer<UInt8> = Helpers.malloc(4 * height * width, UInt8);

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
                _data = RenderingServer.backend.createTexture(width, height, pixels, 4, false, REPEAT, NEAREST);
                Helpers.free(pixels);
        }
    }

    /**
     * Returns a texture from a given file path.
     * 
     * @param  filePath  The path to the image to load.
     */
    public static function fromFile(filePath:String):Texture {
        final tex = new Texture();
        tex.filePath = filePath;
        
        var pixels:Star<UInt8> = Image.load(filePath, Pointer.addressOf(tex.size.x), Pointer.addressOf(tex.size.y), Pointer.addressOf(tex.numChannels), 0);
        
        if (pixels != 0)
            tex._data = RenderingServer.backend.createTexture(tex.size.x, tex.size.y, cast pixels, tex.numChannels);
        else
            Logs.trace('Image at ${filePath} failed to load: ${Image.failureReason()}', ERROR);
        
        Image.freeImage(pixels);
        return tex;
    }

    /**
     * Disposes of this texture and removes it's
     * properties from memory.
     */
    public function dispose():Void {
        size = null;
        RenderingServer.backend.disposeTexture(_data);

        if(type == RENDER) {
            RenderingServer.backend.useFrameBuffer(null);
            RenderingServer.backend.disposeFrameBuffer(_frameBuffer);
        }
    }

    /**
     * Sets this texture as the currently
     * active render texture if it's type is `RENDER_TEXTURE`.
     */
    public function activate():Void {
        if(type != RENDER) {
            Logs.trace('You cannot activate a texture of type "NORMAL".', WARNING);
            return;
        }
        _currentRenderTex = this;
    }

    /**
     * Sets this texture as the currently
     * active render texture if it's type is `RENDER_TEXTURE`.
     */
    public function deactivate():Void {
        if(type != RENDER) {
            Logs.trace('You cannot deactivate a texture of type "NORMAL".', WARNING);
            return;
        }
        if(type == RENDER && _currentRenderTex != this) {
            Logs.trace('You cannot deactivate a render texture that is not current.', WARNING);
            return;
        }
        _currentRenderTex = null;
    }

    // [ Private API ] //

    private static var _currentRenderTex:Texture;

    private var _data:ITextureData = null;
    private var _frameBuffer:IFrameBufferData = null;
}