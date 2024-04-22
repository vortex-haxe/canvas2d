package canvas.servers.rendering;

import cpp.UInt8;
import cpp.RawPointer;

import sdl.SDL;
import sdl.Types.SDLRectangle;
import sdl.Types.SDLFRectangle;
import sdl.Types.SDLFPoint;
import sdl.Types.SDLTexture;
import sdl.Types.SDLRenderer;
import sdl.Types.SDLRawRenderer;
import sdl.Types.SDLPixelFormat;
import sdl.Types.SDLSurface;
import sdl.Types.SDLTextureAccess;
import sdl.Types.SDLPixelFormatEnum;

import canvas.app.Application;
import canvas.ui.Window;

import canvas.graphics.Shader;
import canvas.graphics.Color;

import canvas.math.Vector4;
import canvas.math.Vector2;
import canvas.math.Vector2i;
import canvas.math.Rectanglei;
import canvas.math.Matrix4x4;

import canvas.servers.RenderingServer;

class SDLTextureData implements ITextureData {
	public var texture:Any;
	
	public var size:Vector2i;
	public var channels:Int;
	public var mipmaps:Bool;
	public var wrapping:TextureWrapping;
	public var filter:TextureFilter;

	// boilerplate lol!!!!
	public function new(texture:SDLTexture, size:Vector2i, channels:Int, mipmaps:Bool,
			wrapping:TextureWrapping, filter:TextureFilter) {
		this.texture = texture;
		this.size = size;
		this.channels = channels;
		this.mipmaps = mipmaps;
		this.wrapping = wrapping;
		this.filter = filter;
	}
}

class SDLQuadRenderer implements IQuadRenderer {
	public var texture:ITextureData;
	public var shader:IShaderData;
	public var projection:Matrix4x4;

	private var renderer:SDLRenderer;

	private var sourceRectangle:SDLRectangle;
	private var destinationRectangle:SDLFRectangle;
	private var originPoint:SDLFPoint;
	private var vec2:Vector2;

	public function new(renderer:SDLRenderer) {
		this.renderer = renderer;

		sourceRectangle = SDLRectangle.create(0, 0, 0, 0);
		destinationRectangle = SDLFRectangle.create(0.0, 0.0, 0.0, 0.0);
		originPoint = SDLFPoint.create(0.0, 0.0);
		vec2 = new Vector2();
	}

	public function drawColor(position:Vector2, size:Vector2, color:Color):Void {

	}

	public function drawTexture(position:Vector2, size:Vector2, modulate:Color, sourceRect:Vector4, origin:Vector2, angle:Float):Void {
		sourceRectangle.x = Math.floor(sourceRect.x);
		sourceRectangle.y = Math.floor(sourceRect.y);
		sourceRectangle.w = Math.floor(sourceRect.z);
		sourceRectangle.h = Math.floor(sourceRect.w);

		vec2.set((sourceRect.z - sourceRect.x) * size.x, (sourceRect.w - sourceRect.y) * size.y);

		destinationRectangle.x = position.x + (-origin.x * vec2.x);
		destinationRectangle.y = position.y + (-origin.y * vec2.y);
		destinationRectangle.w = size.x;
		destinationRectangle.h = size.y;

		originPoint.x = size.x * origin.x;
		originPoint.y = size.y * origin.y;

		// todo: optimize rotations and shit (not doing rn cuz i wanna get this working lol!!!!)
		SDL.setTextureColorMod(texture.texture, Math.floor(modulate.r * 255), Math.floor(modulate.g * 255), Math.floor(modulate.b * 255));
		SDL.setTextureAlphaMod(texture.texture, Math.floor(modulate.a * 255));

		SDL.renderCopyExF(renderer, texture.texture, sourceRectangle, destinationRectangle, angle * (180 / Math.PI), originPoint);
	}

	public function drawFrame(position:Vector2, frame:QuadFrame, size:Vector2, scale:Vector2, modulate:Color, sourceRect:Vector4, origin:Vector2, angle:Float):Void {
		
	}

	public function dispose():Void {
		// Nothing
	}
}

/**
 * The SDL rendering backend.
 * 
 * TODO: implement me!
 */
@:access(canvas.ui.Window)
class SDLBackend extends RenderingBackend {
	private var sdlRenderer:SDLRenderer;

	/**
	 * Initializes this rendering backend.
	 */
	override function init():Void {
		// Just for the record, shaders literally do nothing in this backend so this is just done to prevent crashing.
		// Lol.
		defaultShader = new Shader("", "");
		
		sdlRenderer = Application.current.window._nativeWindow.context;

		// for fills and shit ig
		SDL.setRenderDrawBlendMode(sdlRenderer, BLEND);

		quadRenderer = new SDLQuadRenderer(sdlRenderer);
	}

	/**
	 * Sets the values of the current viewport rectangle.
	 */
	override function setViewportRect(rect:Rectanglei):Void {
		SDL.renderSetViewport(sdlRenderer, SDLRectangle.create(rect.x, rect.y, rect.width, rect.height));
	}

	/**
	 * Clears whatever is on-screen currently.
	 */
	override function clear(window:Window):Void {
		SDL.renderClear(sdlRenderer);
		quadRenderer.drawColor(Vector2i.ZERO, window.initialSize, RenderingServer.clearColor);
	}

	/**
	 * Presents/renders whatever is on-screen currently.
	 */
	override function present(window:Window):Void {
		DisplayServer.backend.present(window._nativeWindow);
	}

	/**
	 * TODO: Implement this!
	 */
	override function createTexture(width:Int, height:Int, data:RawPointer<UInt8>, channels:Int = 4, mipmaps:Bool = true,
			wrapping:TextureWrapping = REPEAT, filter:TextureFilter = LINEAR):ITextureData {
		// var format:PixelFormatEnum = channels == 4 ? PixelFormatEnum.RGBA32 : PixelFormatEnum.RGB24;
		
		// var texture:Texture = SDL.createTexture(sdlRenderer, untyped __cpp__('SDL_PIXELFORMAT_RGBA32'),
		// 	TextureAccess.STATIC, width, height);
		// SDL.updateTextureRaw(texture, null, data, width * channels);

		var texture:SDLTexture = null;

		// If somebody can explain why this doesn't work
		// I will be extremely happy.

		// This is because this solution and the one above it (commented out)
		// are used by different SDL2 examples and just don't work??
		
		untyped __cpp__("
			{0} = SDL_CreateTexture({1}, {2} == 4 ? SDL_PIXELFORMAT_RGBA32 : SDL_PIXELFORMAT_RGB24,
				SDL_TEXTUREACCESS_STREAMING, {3}, {4});
			
			int pitch;
			void *pixels;
			SDL_LockTexture({0}, NULL, &pixels, &pitch);

			memcpy(pixels, {5}, pitch * {4});

			SDL_UnlockTexture({0});

			pixels = NULL;
			pitch = 0;

			// SDL_UpdateTexture({0}, NULL, (const void*) {5}, {3} * {2});
		", texture, sdlRenderer, channels, width, height, data);

		// var surface:Surface = SDL.createRGBSurfaceWithFormatFromRaw(data, width, height, channels * 8, channels * width, format);
		// var texture:Texture = SDL.createTextureFromSurface(sdlRenderer, surface);
		// SDL.freeSurface(surface);

		var textureData:SDLTextureData = new SDLTextureData(texture, new Vector2i(width, height), channels, mipmaps,
				wrapping, filter);
		return textureData;
	}
}