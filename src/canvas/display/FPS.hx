package canvas.display;

import canvas.graphics.Color;

/**
 * The FPS class provides an easy-to-use monitor to display
 * the current framerate of a Canvas2D project.
 */
class FPS extends TextField {
    public function new(font:String, x:Float, y:Float, ?color:Color = null) {
        super(font, 12, "");
        this.x = x;
        this.y = y;
        this.tint = color ?? Color.WHITE;
    }

    override function update(delta:Float) {
        _timer += delta;
        _fps++;
        if(_timer >= 1.0) {
            text = 'FPS: ${_fps}';
            _fps = 0;
            _timer = 0;
        }
        super.update(delta);
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //

    private var _timer:Float = 1.0;
    private var _fps:Int = 0;
}