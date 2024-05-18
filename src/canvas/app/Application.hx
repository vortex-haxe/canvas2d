package canvas.app;

#if !macro
import cpp.vm.Gc;
import cpp.UInt64;
import cpp.RawPointer;

import canvas._backend.macros.ProjectMacro;
import canvas._backend.bindings.Freetype;
import canvas._backend.native.NativeAPI;

import canvas.ui.Window;

import canvas.graphics.Font;
import canvas.graphics.BitmapData;

import canvas.servers.DisplayServer;
import canvas.servers.RenderingServer;
import canvas.servers.AudioServer;

import canvas.math.Vector2i;
import canvas.tools.Project;

import sdl.SDL;
import sdl.Types.SDLWindowPos;

/**
 * The very base of your games!
 */
@:access(canvas.ui.Window)
@:access(canvas.graphics.Font)
@:access(canvas.graphics.BitmapData)
@:autoBuild(canvas._backend.macros.ApplicationMacro.build())
class Application extends Canvas {
	/**
	 * The current application instance.
	 */
	public static var current:Application;

	/**
	 * The metadata of the project config.
	 */
	public var meta:Map<String, String>;

	/**
	 * The main window of this application.
	 */
	public var window:Window;

	/**
	 * All of the windows attached to this application.
	 */
	public var windows:Array<Window> = [];

	/**
	 * Makes a new `Application` instance.
	 */
	public function new() {
		super();
		if(current == null)
			current = this;
		
		_conf = Project.parse(Xml.parse(ProjectMacro.getConfig()));
		meta = _conf.meta;

		NativeAPI.init();
		Logs.init();

		DisplayServer.init();

		window = new Window(
			meta.get("title") ?? "Canvas2D App", 
			new Vector2i(SDLWindowPos.CENTERED, SDLWindowPos.CENTERED),
			new Vector2i(
				Std.parseInt(_conf.window.get("width")),
				Std.parseInt(_conf.window.get("height"))
			),
			(_conf.window.get("vsync") ?? "false").toLowerCase() == "true"
		);
		window.frameRate = Std.parseInt(_conf.window.get("fps")) ?? 0;

		AudioServer.init();
		RenderingServer.init();
		Freetype.init(RawPointer.addressOf(Font._library));
	}

	public function startEventLoop() {
		Window._ev = SDL.makeEvent();
		
		var curTime:UInt64 = SDL.getPerformanceCounter();
		var oldTime:UInt64 = 0;

		while(windows.length != 0) {
			oldTime = curTime;
			curTime = SDL.getPerformanceCounter();
			
			if(windows.length != 0)
				windows[0].children = children;

			final _dt:Float = untyped __cpp__("(double)({0} - {1}) / (double){2}", curTime, oldTime, SDL.getPerformanceFrequency());
			_deltaTime += _dt;
			
			final fpsFract:Float = (!window.vsync && window.frameRate > 0) ? (1 / window.frameRate) : 0;
			if(fpsFract == 0 || _deltaTime >= fpsFract) {
				for(i in 0...windows.length) {
					final window:Window = windows[i];
					if(window != null) {
						RenderingServer.backend.clear(window);
	
						if(BitmapData._currentRenderBitmap != null) {
							RenderingServer.backend.useFrameBuffer(BitmapData._currentRenderBitmap._frameBuffer);
							window.changeViewportSize(BitmapData._currentRenderBitmap.size.x, BitmapData._currentRenderBitmap.size.y);
						}
						window.update(_deltaTime);
						window.draw();
						
						RenderingServer.backend.useFrameBuffer(null);
	
						if(BitmapData._currentRenderBitmap != null)
							window.changeViewportSize(window.size.x, window.size.y);
						
						RenderingServer.backend.present(window);
					}
				}
	
				// Force gc to clean up unused memory whenever it can
				// Hacky workaround for OpenGLBackend leaking memory when clearing the display
				// I don't know the cause but this seems to fix it
				// I'll see if it causes issues later on
				Gc.run(true);
				Gc.run(false);
				Gc.compact();

				_deltaTime %= fpsFract;
			}
		}
		
		window.dispose();
		DisplayServer.dispose();
		
		AudioServer.dispose();
		RenderingServer.dispose();

		Freetype.done(Font._library);
	}

	/**
     * Updates this application.
     * Override this function to update your own stuff aswell!
     * 
     * Remember to call `super.update(delta)` to ensure
     * that the children of this canvas update aswell!
     * 
     * @param  delta  The time since the last frame in seconds.
     */
	override function update(delta:Float):Void {}

	/**
     * Draws this application.
     * Override this function to draw your own stuff aswell!
     * 
     * Remember to call `super.draw()` to ensure
     * that the children of this canvas update aswell!
     */
	override function draw():Void {}

	// --------------- //
	// [ Private API ] //
	// --------------- //

	private static var _deltaTime:Float;

	private var _conf:ProjectConfig;
}
#else
class Application {
	public function new() {}
}
#end