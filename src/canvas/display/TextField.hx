package canvas.display;

import stb.Image;
import canvas.graphics.Font;
import canvas.graphics.Color;
import canvas.graphics.Shader;

import canvas.math.Vector2;
import canvas.math.Vector4;

import canvas.servers.RenderingServer;
import canvas.utils.Assets;

enum abstract TextFieldAlignment(Int) from Int to Int {
	final LEFT = 0;
	final MIDDLE = 1;
	final RIGHT = 2;
}

/**
 * A simple canvas object capable of rendering text.
 */
@:access(canvas.graphics.Font)
class TextField extends Canvas {
    /**
     * A file path to the font that this textfield is using.
     * 
     * ---
     * 
     * This can be a path from within the app's directory:
     * ```haxe
     * textField.font = "assets/myFont.ttf";
     * ```
     * 
     * Or something from outside the app's directory:
     * ```haxe
     * textField.font = "C:/Windows/Fonts/consola.ttf"
     * ```
     */
    public var font(default, set):String;

    /**
     * The size of the current font in pixels.
     */
    public var size(default, set):Int;

    /**
     * The text contents that this textfield will render. 
     */
    public var text(default, set):String;

    /**
     * The current alignment of this textfield.
     */
    public var alignment:TextFieldAlignment;

    /**
     * The color tint applied to this textfield
     * whenever it renders.
     * 
     * If set to something like `RED`, the textfield
     * will have a red tint to it.
     * 
     * Same goes for any color chosen.
     * Default color is `Color.WHITE`.
     */
    public var tint(default, set):Color = new Color().copyFrom(Color.WHITE);

    /**
     * Controls whether or not the text will be
     * smoothened when rendered.
     */
    public var smoothing:Bool;

    /**
     * Makes a new `TextField` instance.
     * 
     * @param  font       A file path to the font that this textfield will use.
     * @param  size       The size of the font in pixels.
     * @param  text       The text contents that this textfield will render. 
     * @param  alignment  The alignment of this textfield.
     * @param  smoothing  Controls whether or not the text will be smoothened when rendered.
     */
    public function new(font:String, size:Int, text:String, ?alignment:TextFieldAlignment = LEFT, ?smoothing:Bool = true) {
        super();
        this.font = font;
        this.size = size;
        this.text = text;
        this.alignment = alignment;
        this.smoothing = smoothing;
    }

    /**
     * Draws this textfield and it's children.
     */
    override function draw() {
        @:privateAccess
        if(_fontData != null) {
            if(_queueSize)
                _updateSize();

            final shader:Shader = this.shader ?? RenderingServer.backend.defaultShader;
            shader.useProgram();

            final scaledSize = size * _textQuality;

            var curX:Float = (_textWidth - _lineWidths[0]) * (alignment * 0.5) * _textQuality;
            var lineNum:Int = 0;

            for(i in 0...text.length) {
                if (text.charAt(i) == '\n') {
                    lineNum++;
                    curX = (_textWidth - _lineWidths[lineNum]) * (alignment * 0.5) * _textQuality;
                    continue;
                }
                final letter = _fontData._getLetter(text.charCodeAt(i), scaledSize);
                final letterWidth = Math.abs(letter.bitmapData.size.x * scale.x * _qualityFract);
			    final letterHeight = Math.abs(letter.bitmapData.size.y * scale.y * _qualityFract);

                RenderingServer.backend.setTextureFilter(letter.bitmapData._data, (smoothing) ? LINEAR : NEAREST);
                RenderingServer.backend.quadRenderer.texture = letter.bitmapData._data;

                RenderingServer.backend.quadRenderer.drawTexture(
                    _pos.set(
                        x + ((curX + letter.bearingX) * _qualityFract), 
                        y + (((size * lineNum + size) - (letter.bearingY * _qualityFract)))
                    ),
                    _size.set(letterWidth, letterHeight), tint, _clipRectUVCoords, Vector2.ZERO, 0
                );
                curX += letter.advance >> 6;
            }
        }
        super.draw();
    }

    // --------------- //
	// [ Private API ] //
	// --------------- //

    private var _pos:Vector2 = new Vector2(0.0, 0.0);
	private var _size:Vector2 = new Vector2(0.0, 0.0);
	private var _clipRectUVCoords:Vector4 = new Vector4(0.0, 0.0, 1.0, 1.0);

    private var _fontData:Font;
    private var _queueSize:Bool = true;

    private var _textQuality:Int = 2;
    private var _qualityFract:Float = 1 / 2;

    private var _lineWidths:Array<Float> = [];
	private var _textWidth:Float;
	private var _textHeight:Float;

    private function _updateSize():Void {
        _queueSize = false;
        _lineWidths.resize(0);
        _textHeight = size;
        var firstLetter:Bool = true;
        var curWidth:Float = 0.0;

        for(i in 0...text.length) {
            if(text.charAt(i) == '\n') {
                _lineWidths.push(curWidth);
                _textHeight += size;
                curWidth = 0.0;
                firstLetter = true;
                continue;
            }
            final letter = _fontData._getLetter(text.charCodeAt(i), size);
            curWidth += letter.advance >> 6;
            _textWidth = Math.max(curWidth, _textWidth);
        }
        _lineWidths.push(curWidth);
    }

    @:noCompletion
    private function set_font(newFont:String):String {
        _fontData = Assets.getFont(newFont);
        _queueSize = _queueSize || (font != newFont);
        return font = newFont;
    }

    @:noCompletion
    private function set_size(newSize:Int):Int {
        _queueSize = _queueSize || (size != newSize);
        return size = newSize;
    }

    @:noCompletion
    private function set_text(newText:String):String {
        _queueSize = _queueSize || (text != newText);
        return text = newText;
    }

    @:noCompletion
    private function set_tint(newTint:Color):Color {
        tint.copyFrom(newTint);
        newTint = null;
        return tint;
    }
}