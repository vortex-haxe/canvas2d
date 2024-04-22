package canvas.graphics;

import cpp.Star;
import cpp.UInt8;
import cpp.Pointer;

import stb.Image;

import canvas.servers.RenderingServer;
import canvas.servers.RenderingServer.ITextureData;

import canvas.math.Vector2i;

/**
 * A simple texture class including basic data such as
 * width, height, pixels, etc.
 */
class Texture {
	private var textureData:ITextureData = null;

	/**
	 * The file path to the image that this texture used.
	 * 
	 * Blank if this texture wasn't loaded from a file.
	 */
	public var filePath:String = "";

	/**
	 * The width and height of the texture in pixels.
	 */
	public var size:Vector2i = Vector2i.ZERO;

	/**
	 * The amount of channels in this texture.
	 */
	public var numChannels:Int = 0;

	/**
	 * Makes a new `Texture`.
	 */
	public function new() {}

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
            tex.textureData = RenderingServer.backend.createTexture(tex.size.x, tex.size.y, cast pixels, tex.numChannels);
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
		RenderingServer.backend.disposeTexture(textureData);
	}
}