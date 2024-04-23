package canvas.ui;

import sdl.SDL;
import sdl.Types.SDLRawEvent;
import sdl.Types.SDLEvent;
import sdl.Types.SDLMouseButton;
import sdl.Types.SDLWindowEventID;

import canvas.app.Application;
import canvas.app.Event;

import canvas.graphics.Shader;

import canvas.math.Vector2i;
import canvas.math.Rectanglei;
import canvas.math.Matrix4x4;

import canvas.servers.DisplayServer;
import canvas.servers.DisplayServer.IWindowData;

import canvas.servers.RenderingServer;
import canvas.servers.rendering.OpenGLBackend.OpenGLQuadRenderer;

@:access(canvas.app.Application)
@:access(canvas.graphics.Shader)
class Window extends Canvas {
	/**
	 * The X and Y coordinates of this window
	 * on the screen.
	 */
	public var position:Vector2i;

	/**
	 * The width and height of this window
	 * in pixels.
	 */
	public var size:Vector2i;

	/**
	 * The initial width and height of this window
	 * in pixels.
	 */
	public var initialSize(default, null):Vector2i;

	/**
	 * The signal that gets emitted when the window updates.
	 */
	public var onUpdate:Event<Float->Void> = new Event<Float->Void>();

	/**
	 * The signal that gets emitted when the window is closed.
	 */
	public var onClose:Event<Void->Void> = new Event<Void->Void>();

	/**
	 * The signal that gets emitted when the window is minimized.
	 */
	public var onMinimize:Event<Void->Void> = new Event<Void->Void>();

	/**
	 * The signal that gets emitted when the window is maximized.
	 */
	public var onMaximize:Event<Void->Void> = new Event<Void->Void>();

	/**
	 * The signal that gets emitted when the window is restored.
	 */
	public var onRestore:Event<Void->Void> = new Event<Void->Void>();

	/**
	 * The signal that gets emitted when the window is refocused.
	 */
	public var onFocusGain:Event<Void->Void> = new Event<Void->Void>();

	/**
	 * The signal that gets emitted when the window is unfocused.
	 */
	public var onFocusLost:Event<Void->Void> = new Event<Void->Void>();

	/**
	 * The signal that gets emitted when the window is resized.
	 * 
	 * Parameters are:
	 * - New Window Width
	 * - New Window Height
	 */
	public var onResize:Event<Int->Int->Void> = new Event<Int->Int->Void>();

	/**
	 * The signal that gets emitted when the window receives a key press.
	 * 
	 * Parameters are:
	 * - Key Code
	 * - Key Modifier
	 */
	public var onKeyPress:Event<KeyCode->KeyMod->Void> = new Event<KeyCode->KeyMod->Void>();

	/**
	 * The signal that gets emitted when the window receives a key release.
	 * 
	 * Parameters are:
	 * - Key Code
	 * - Key Modifier
	 */
	public var onKeyRelease:Event<KeyCode->KeyMod->Void> = new Event<KeyCode->KeyMod->Void>();

	/**
	 * The signal that gets emitted when the window receives a mouse click.
	 * 
	 * Parameters are:
	 * - Mouse Button
	 */
	public var onMouseClick:Event<SDLMouseButton->Void> = new Event<SDLMouseButton->Void>();

	/**
	 * The signal that gets emitted when the window receives a mouse release.
	 * 
	 * Parameters are:
	 * - Mouse Button
	 */
	public var onMouseRelease:Event<SDLMouseButton->Void> = new Event<SDLMouseButton->Void>();

	/**
	 * The signal that gets emitted when the window receives a mouse movement.
	 * 
	 * Parameters are:
	 * - Mouse Button
	 * - Mouse X
	 * - Mouse Y
	 * - Mouse X (Relative)
	 * - Mouse Y (Relative)
	 */
	public var onMouseMove:Event<SDLMouseButton->Int->Int->Int->Int->Void> = new Event<SDLMouseButton->Int->Int->Int->Int->Void>();

	/**
	 * The signal that gets emitted when the window receives an
	 * event that isn't handled by Canvas2D automatically.
	 */
	public var onMiscEvent:Event<SDLWindowEventID->SDLRawEvent->Void> = new Event<SDLWindowEventID->SDLRawEvent->Void>();

	/**
	 * Makes a new `Window`.
	 */
	public function new(title:String, position:Vector2i, size:Vector2i) {
		super();
		@:bypassAccessor this.position = position;
		@:bypassAccessor this.size = size;
		initialSize = new Vector2i().copyFrom(size);
		_nativeWindow = DisplayServer.backend.createWindow(title, position, size);

		@:privateAccess {
			this.position._onChange = (x:Int, y:Int) -> {
				DisplayServer.backend.setWindowPosition(_nativeWindow, new Vector2i(x, y));
			};
			this.size._onChange = (x:Int, y:Int) -> {
				DisplayServer.backend.setWindowSize(_nativeWindow, new Vector2i(x, y));
			};
		}
		Application.current.windows.push(this);
	}
	
	public function changeViewportSize(newWidth:Int, newHeight:Int):Void {
		RenderingServer.backend.setViewportRect(_recti.set(
			0, 0,
			newWidth, newHeight
		));
		if(RenderingServer.backend.quadRenderer is OpenGLQuadRenderer) {
			final quadRenderer:OpenGLQuadRenderer = cast RenderingServer.backend.quadRenderer;
			quadRenderer.projection = Matrix4x4.ortho(0, newWidth, newHeight, 0, -1, 1);

			for(shader in Shader._shaders) {
				shader.useProgram();
				shader.setUniformMat4x4("PROJECTION", quadRenderer.projection);
			}
		}
	}

	/**
     * Updates this window.
     * 
     * @param  delta  The time since the last frame in seconds.
     */
	override function update(delta:Float):Void {
		super.update(delta);
		onUpdate.dispatch(Application._deltaTime);
		if(onUpdate.cancelled)
			return;

		while(SDL.pollEvent(_ev) != 0) {
			switch(_ev.ref.type) {
				case WINDOWEVENT:
					switch(_ev.ref.window.event) {
						case CLOSE:
							onClose.dispatch();
							if(!onClose.cancelled)
								dispose();
						
						case MINIMIZED:
							onMinimize.dispatch();
							
						case MAXIMIZED:
							onMaximize.dispatch();
	
						case RESTORED:
							onRestore.dispatch();
	
						case FOCUS_GAINED:
							onFocusGain.dispatch();
	
						case FOCUS_LOST:
							onFocusLost.dispatch();
	
						case RESIZED:
							final newWidth:Int = _ev.ref.window.data1;
							final newHeight:Int = _ev.ref.window.data2;
							changeViewportSize(newWidth, newHeight);

							@:bypassAccessor size.x = newWidth;
							@:bypassAccessor size.y = newHeight;
							onResize.dispatch(newWidth, newHeight);
	
						default:
					}
	
				case KEYDOWN:
					onKeyPress.dispatch(cast _ev.ref.key.keysym.sym, cast _ev.ref.key.keysym.mod);
	
				case KEYUP:
					onKeyRelease.dispatch(cast _ev.ref.key.keysym.sym, cast _ev.ref.key.keysym.mod);
	
				case MOUSEMOTION:
					onMouseMove.dispatch(_ev.ref.motion.state, _ev.ref.motion.x, _ev.ref.motion.y, _ev.ref.motion.xRel, _ev.ref.motion.yRel);
	
				case MOUSEBUTTONDOWN:
					onMouseClick.dispatch(_ev.ref.button.button);
	
				case MOUSEBUTTONUP:
					onMouseRelease.dispatch(_ev.ref.button.button);
	
				default:
					onMiscEvent.dispatch(_ev.ref.window.event, _ev.ref);
			}
		}
	}
	
	/**
	 * Closes this window immediately.
	 */
	public function close():Void {
		 dispose();
	}

	/**
	 * Disposes of this window and removes it's
	 * properties from memory.
	 */
	override function dispose():Void {
		Application.current.windows.remove(this);
		DisplayServer.backend.disposeWindow(_nativeWindow);
	}

	// ----------- //
	// Private API //
	// ----------- //

	private static var _ev:SDLEvent;
	private static var _recti:Rectanglei = new Rectanglei();

	private var _nativeWindow:IWindowData;
}