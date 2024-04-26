package canvas.servers.display;

import glad.Glad;

import sdl.SDL;
import sdl.Types;

import sdl.SDL;
import sdl.Types.SDLEvent;
import sdl.Types.SDLWindowInitFlags;
import sdl.Types.SDLWindow;
import sdl.Types.SDLGlContext;

import canvas.app.Application;
import canvas.servers.DisplayServer.DisplayBackend;
import canvas.servers.DisplayServer.IWindowData;
import canvas.math.Vector2i;
import canvas.utils.IntBool;

// this was going to be a typedef but you can't do that cuz weird hxcpp stuff :(
class SDLGLWindowData implements IWindowData {
	public var window:Any;
	public var context:Any;

	public function new(nativeWindow:SDLWindow, glContext:SDLGlContext) {
		this.window = nativeWindow;
		this.context = glContext;
	}
}

@:access(canvas.app.Application)
class SDLGLBackend extends DisplayBackend {
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
     * Creates a window with SDL and initializes an OpenGL Core 3.3 context with it.
     */
    override function createWindow(title:String, position:Vector2i, size:Vector2i, vsync:IntBool):IWindowData {
		var wFlags:SDLWindowInitFlags = OPENGL;

		final resizable:String = (Application.current._conf.window.get("resizable") ?? "0").toLowerCase();
		if (resizable == "1" || resizable == "true")
			wFlags |= RESIZABLE;
		
		final borderless:String = (Application.current._conf.window.get("borderless") ?? "0").toLowerCase();
		if (borderless == "1" || borderless == "true")
			wFlags |= BORDERLESS;

		var nativeWindow:SDLWindow = SDL.createWindow(title, position.x, position.y, size.x, size.y, wFlags);
		var glContext:SDLGlContext = SDL.glCreateContext(nativeWindow);
		var returnData:SDLGLWindowData = new SDLGLWindowData(nativeWindow, glContext);
		
		SDL.glMakeCurrent(nativeWindow, glContext);
		SDL.glSetSwapInterval(vsync);

		Glad.loadGLLoader(untyped __cpp__("SDL_GL_GetProcAddress"));

		return returnData;
	}

	/**
     * Sets the rendering context of the given window
	 * to the current context in use.
     */
	override function useWindowContext(window:IWindowData):Void {
		SDL.glMakeCurrent(window.window, window.context);
	}

	/**
	 * Presents/renders whatever is on-screen currently.
	 */
	override function present(window:IWindowData):Void {
		SDL.glSwapWindow(window.window);
	}

	/**
	 * TODO: Add this description lol.
	 */
	override function setWindowPosition(window:IWindowData, position:Vector2i):Void {
		SDL.setWindowPosition(window.window, position.x, position.y);
	}

	/**
	 * TODO: Add this description lol.
	 */
	override function setWindowSize(window:IWindowData, size:Vector2i):Void {
		SDL.setWindowSize(window.window, size.x, size.y);
	}

	/**
	 * Toggles V-Sync on the given window.
	 */
	override function toggleVSync(window:IWindowData, enabled:IntBool):Void {
		SDL.glMakeCurrent(window.window, window.context);
		SDL.glSetSwapInterval(enabled);
	}

	/**
	 * TODO: Add this description lol.
	 */
	override function disposeWindow(window:IWindowData):Void {
		SDL.glDeleteContext(window.context);
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