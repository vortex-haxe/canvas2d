package canvas.display;

import canvas.math.Rectangle;
import canvas.app.Application;

import canvas.graphics.Color;
import canvas.graphics.Shader;
import canvas.graphics.BitmapData;

import canvas.math.Vector2;
import canvas.math.Vector4;

import canvas.servers.RenderingServer;

/**
 * A simple canvas object capable of rendering bitmap data.
 */
class Bitmap extends Canvas {
    public var id:Int = _idEnumerator++;

    /**
     * The currently rendering bitmap data.
     */
    public var bitmapData:BitmapData;

    /**
     * The scroll rectangle bounds of the canvas object.
     * 
     * The canvas object is cropped to the size defined by the rectangle,
     * and it scrolls within the rectangle when you change the x and y
     * properties of the `scrollRect` object.
     */
    public var scrollRect(default, set):Rectangle;

    /**
     * The color tint applied to this sprite
     * whenever it renders.
     * 
     * If set to something like `RED`, the sprite
     * will have a red tint to it.
     * 
     * Same goes for any color chosen.
     * Default color is `Color.WHITE`.
     */
    public var tint(default, set):Color = new Color().copyFrom(Color.WHITE);

    /**
     * Makes a new `Sprite` instance.
     * 
     * @param  bitmapData  The bitmap data to make this sprite render. 
     */
    public function new(?bitmapData:BitmapData) {
        super();
        this.bitmapData = bitmapData;
    }

    /**
     * Draws this sprite.
     * Override this function to draw your own stuff aswell!
     * 
     * Remember to call `super.draw()` to ensure
     * that the children of this canvas update aswell!
     */
    override function draw() {
        @:privateAccess
        if(bitmapData != null && bitmapData._data != null) {
            if(bitmapData.type == RENDER) {
                RenderingServer.backend.useFrameBuffer(null);
                Application.current.window.changeViewportSize(Application.current.window.size.x, Application.current.window.size.y);
            }

            final shader:Shader = this.shader ?? RenderingServer.backend.defaultShader;
            shader.useProgram();

            _scrollRectUV.set(
                scrollRect.x / bitmapData.size.x,
                scrollRect.y / bitmapData.size.y,
                (scrollRect.x + scrollRect.width) / bitmapData.size.x,
                (scrollRect.x + scrollRect.height) / bitmapData.size.y,
            );
            RenderingServer.backend.quadRenderer.texture = bitmapData._data;
            RenderingServer.backend.quadRenderer.drawTexture(_pos.set(x, y), _size.set(bitmapData.size.x * scale.x, bitmapData.size.y * scale.y), tint, _scrollRectUV, Vector2.ZERO, 0);
        
            if(bitmapData.type == RENDER) {
                RenderingServer.backend.useFrameBuffer(bitmapData._frameBuffer);
                Application.current.window.changeViewportSize(bitmapData.size.x, bitmapData.size.y);
            }
        }
        super.draw();
    }

    /**
     * Disposes of this sprite and
     * all of it's properties.
     */
    override function dispose() {
        scrollRect = null;
        bitmapData = null;
        shader = null;
        @:bypassAccessor tint = null;
        super.dispose();
    }

    // --------------- //
	// [ Private API ] //
	// --------------- //

    private static var _idEnumerator:Int = 0;

	private var _pos:Vector2 = new Vector2(0.0, 0.0);
	private var _size:Vector2 = new Vector2(0.0, 0.0);
	private var _scrollRectUV:Vector4 = new Vector4(0.0, 0.0, 1.0, 1.0);

    @:noCompletion
    private function set_scrollRect(newRect:Rectangle):Rectangle {
        if(scrollRect == null)
            scrollRect = new Rectangle();

        scrollRect.copyFrom(newRect);
        newRect = null;
        return scrollRect;
    }

    @:noCompletion
    private function set_tint(newTint:Color):Color {
        tint.copyFrom(newTint);
        newTint = null;
        return tint;
    }
}