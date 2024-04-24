package canvas.servers;

import cpp.RawPointer;
import cpp.UInt8;
import cpp.Star;
import cpp.ConstCharStar;

import canvas.math.*;

import canvas.graphics.Shader;
import canvas.graphics.Color;

import canvas.app.Application;
import canvas.ui.Window;

import canvas.math.Rectanglei;
import canvas.servers.rendering.*;

typedef QuadFrame = {
	var name:String;
	var position:Vector2;
	var offset:Vector2;
	var size:Vector2;
	var marginSize:Vector2;
	var angle:Float;
}

enum TextureWrapping {
	REPEAT;
	MIRRORED_REPEAT;
	CLAMP_EDGE;
	CLAMP_BORDER;
}

// maybe add linear mipmap and nearest mipmap and whatever if we need it later
// :3

enum TextureFilter {
	LINEAR;
	NEAREST;
}

interface ITextureData {
	public var texture:Any;

	public var size:Vector2i;
	public var channels:Int;
	public var mipmaps:Bool;
	public var wrapping:TextureWrapping;
	public var filter:TextureFilter;
}

interface IShaderData {
	public var shader:Any;
}

interface IQuadRenderer {
	public var texture:ITextureData;
	public var shader:IShaderData;
	public var projection:Matrix4x4;

	public function drawColor(position:Vector2, size:Vector2, color:Color):Void;
	public function drawTexture(position:Vector2, size:Vector2, modulate:Color, sourceRect:Vector4, origin:Vector2, angle:Float):Void;
	public function drawFrame(position:Vector2, frame:QuadFrame, size:Vector2, scale:Vector2, modulate:Color, sourceRect:Vector4, origin:Vector2, angle:Float):Void;

	public function dispose():Void;
}

interface IFrameBufferData {
	public var buffer:Any;
}

class RenderingBackend {
	public var quadRenderer:IQuadRenderer;
	public var defaultShader:Shader;

	public function new() {}

	/**
	 * Initializes this rendering backend.
	 */
	public function init():Void {}

	/**
	 * Sets the values of the current viewport rectangle.
	 */
	public function setViewportRect(rect:Rectanglei):Void {}

	/**
	 * Clears whatever is on-screen currently.
	 */
	public function clear(window:Window):Void {}

	/**
	 * Presents/renders whatever is on-screen currently.
	 */
	public function present(window:Window):Void {}

	/**
	 * TODO: Implement this!
	 */
	public function createFrameBuffer():IFrameBufferData {
		return null;
	}

	/**
	 * TODO: Implement this!
	 */
	public function setupFrameBuffer(frameBuffer:IFrameBufferData, texture:ITextureData):Void {}

	/**
	 * TODO: Implement this!
	 */
	public function disposeFrameBuffer(frameBuffer:IFrameBufferData):Void {}

	/**
	 * TODO: Implement this!
	 */
	public function useFrameBuffer(frameBuffer:IFrameBufferData):Void {}

	/**
	 * TODO: Implement this!
	 */
	public function createTexture(width:Int, height:Int, data:RawPointer<UInt8>, format:Null<Int> = null, channels:Int = 4, mipmaps:Bool = true, wrapping:TextureWrapping = REPEAT, filter:TextureFilter = LINEAR):ITextureData {
		return null;
	}

	/**
	 * TODO: Implement this!
	 */
	public function setTextureFilter(texture:ITextureData, filter:TextureFilter = LINEAR):Void {}

	/**
	 * TODO: Implement this!
	 */
	public function disposeTexture(texture:ITextureData):Void {}

	/**
	 * TODO: Implement this!
	 */
	public function createShader(fragmentSource:ConstCharStar, vertexSource:ConstCharStar):IShaderData {
		return null;
	}

	/**
	 * TODO: Implement this!
	 */
	public function useShader(shader:IShaderData):Void {}

	/**
	 * TODO: Implement this!
	 */
	public function disposeShader(shader:IShaderData):Void {}

	/**
	 * TODO: Implement this!
	 */
	public function setUniformInt(shader:IShaderData, name:ConstCharStar, value:Int):Void {}

	/**
	 * TODO: Implement this!
	 */
	public function setUniformFloat(shader:IShaderData, name:ConstCharStar, value:Float):Void {}

	/**
	 * TODO: Implement this!
	 */
	public function setUniformVec2(shader:IShaderData, name:ConstCharStar, value:Vector2):Void {}

	/**
	 * TODO: Implement this!
	 */
	public function setUniformVec3(shader:IShaderData, name:ConstCharStar, value:Vector3):Void {}

	/**
	 * TODO: Implement this!
	 */
	public function setUniformVec4(shader:IShaderData, name:ConstCharStar, value:Vector4):Void {}

	/**
	 * TODO: Implement this!
	 */
	public function setUniformColor(shader:IShaderData, name:ConstCharStar, value:Color):Void {}

	/**
	 * TODO: Implement this!
	 */
	public function setUniformMat4x4(shader:IShaderData, name:ConstCharStar, value:Matrix4x4):Void {}

	/**
	 * Disposes of this rendering backend and removes it's
	 * properties from memory.
	 */
	public function dispose():Void {}
}

@:access(canvas.app.Application)
class RenderingServer {
	/**
	 * The current rendering backend for every window.
	 * 
	 * Changing it after Vortex has already initialized
	 * could break/crash it!
	 * 
	 * Change it before `super()` is called in your Main class.
	 * 
	 * - `OPENGL` - The standard backend, supports shaders and works on basically any GPU.
	 * - `VULKAN` - The modern backend, supports shaders and runs better, but doesn't work on older GPUs.
	 * - `SDL` - The limited backend, doesn't support shaders but works on basically any GPU. 
	 */
	public static var backend:RenderingBackend = new OpenGLBackend();

	/**
	 * The default color displayed on an empty window.
	 * 
	 * This is defined in your `config.xml` file.
	 */
	public static var clearColor:Color;

	/**
	 * Initializes the rendering server.
	 */
	public static function init():Void {
		// Initialize basic stuff
		clearColor = Application.current._conf.window.get("background") ?? "#000000";
		
		// Initialize the actual backend
		backend.init();
	}

	/**
	 * Disposes of this rendering server and removes it's
	 * properties from memory.
	 */
	public static function dispose():Void {
		backend.dispose();
		backend = null;
		clearColor = null;
	}
}