package canvas.servers;

import canvas.servers.display.SDLGLBackend;
import canvas.math.Vector2i;

interface IWindowData {
    public var window:Any;
	public var context:Any;
}

class DisplayBackend {
    public function new() {}

	/**
	 * Initializes this display backend.
	 */
	public function init():Void {}

    /**
     * Creates a new window.
	 * 
	 * @param  title     The title of the new window.
	 * @param  position  The position of the new window.
	 * @param  size      The size of the new window.
     */
    public function createWindow(title:String, position:Vector2i, size:Vector2i):IWindowData {
        return null;
    }

    /**
     * Sets the rendering context of the given window
	 * to the current context in use.
     */
    public function useWindowContext(window:IWindowData):Void {}

	/**
	 * Presents/renders whatever is on-screen currently
	 * to the given window.
	 */
	public function present(window:IWindowData):Void {}

    /**
	 * Sets the position of any given window to the values
	 * within a given `Vector2i`.
	 */
	public function setWindowPosition(window:IWindowData, position:Vector2i):Void {}

    /**
	 * Sets the size of any given window to the values
	 * within a given `Vector2i`.
	 */
	public function setWindowSize(window:IWindowData, size:Vector2i):Void {}

    /**
	 * Disposes of any given window data and
	 * removes it's properties from memory.
	 */
	public function disposeWindow(window:IWindowData):Void {}

	/**
	 * Disposes of this display backend and removes it's
	 * objects from memory.
	 */
	public function dispose():Void {}
}

class DisplayServer {
    /**
     * The currently selected backend for the window.
     */
    public static var backend:DisplayBackend = new SDLGLBackend();

	/**
	 * Initializes this display server.
	 */
	public static function init():Void {
        backend.init();
    }

	/**
	 * Disposes of this display server and removes it's
	 * objects from memory.
	 */
	public static function dispose():Void {
        backend.dispose();
        backend = null;
    }
}
