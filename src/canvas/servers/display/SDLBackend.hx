package canvas.servers.display;

import sdl.SDL;
import sdl.Types;

import sdl.SDL;
import sdl.Types.SDLEvent;
import sdl.Types.SDLWindowInitFlags;
import sdl.Types.SDLWindow;

import canvas.app.Application;
import canvas.servers.DisplayServer.DisplayBackend;
import canvas.servers.DisplayServer.IWindowData;
import canvas.math.Vector2i;
import canvas.utils.IntBool;

// this was going to be a typedef but you can't do that cuz weird hxcpp stuff :(
class SDLWindowData implements IWindowData {
	public var window:Any;
	public var context:Any;

	public function new(nativeWindow:SDLWindow, sdlRenderer:SDLRenderer) {
		this.window = nativeWindow;
		this.context = sdlRenderer;
	}
}

@:access(canvas.app.Application)
class SDLBackend extends DisplayBackend {
    /**
	 * Initializes this display backend.
	 */
	override function init():Void {
        if (SDL.init(VIDEO | EVENTS) < 0) {
			Logs.trace(SDL.getError(), ERROR);
			return;
		}
    }

    /**
     * Creates a window and context with SDL.
     */
    override function createWindow(title:String, position:Vector2i, size:Vector2i, vsync:IntBool):IWindowData {
		var wFlags:SDLWindowInitFlags = SHOWN;

		final resizable:String = (Application.current._conf.window.get("resizable") ?? "0").toLowerCase();
		if (resizable == "1" || resizable == "true")
			wFlags |= RESIZABLE;
		
		final borderless:String = (Application.current._conf.window.get("borderless") ?? "0").toLowerCase();
		if (borderless == "1" || borderless == "true")
			wFlags |= BORDERLESS;

		var nativeWindow:SDLWindow = SDL.createWindow(title, position.x, position.y, size.x, size.y, wFlags);
		var sdlRenderer:SDLRenderer = SDL.createRenderer(nativeWindow, -1, ACCELERATED);

		if (sdlRenderer == null) {
			// Fallback to software renderer
			Logs.trace("SDL_CreateRenderer couldn't find accelerated graphics, Falling back to software rendering.", WARNING);
			sdlRenderer = SDL.createRenderer(nativeWindow, -1, SOFTWARE);
		}
		if(vsync && sdlRenderer != null)
			SDL.renderSetVSync(sdlRenderer, vsync);

		return new SDLWindowData(nativeWindow, sdlRenderer);
	}

	/**
     * Sets the rendering context of the given window
	 * to the current context in use.
     */
	override function useWindowContext(window:IWindowData):Void {}

	/**
	 * Presents/renders whatever is on-screen currently.
	 */
	override function present(window:IWindowData):Void {
		SDL.renderPresent(window.context);
	}

	/**
	 * Sets the position of any given window to the values
	 * within a given `Vector2i`.
	 */
	override function setWindowPosition(window:IWindowData, position:Vector2i):Void {
		SDL.setWindowPosition(window.window, position.x, position.y);
	}

	/**
	 * Sets the size of any given window to the values
	 * within a given `Vector2i`.
	 */
	override function setWindowSize(window:IWindowData, size:Vector2i):Void {
		SDL.setWindowSize(window.window, size.x, size.y);
	}

	/**
	 * Toggles V-Sync on the given window.
	 */
	override function toggleVSync(window:IWindowData, enabled:IntBool):Void {
		SDL.renderSetVSync(window.context, enabled);
	}

	/**
	 * Disposes of any given window data and
	 * removes it's properties from memory.
	 */
	override function disposeWindow(window:IWindowData):Void {
		SDL.destroyRenderer(window.context);
		SDL.destroyWindow(window.window);
	}

	/**
	 * Disposes of this display backend and removes it's
	 * objects from memory.
	 */
	override function dispose():Void {
		SDL.quit();
	}
}