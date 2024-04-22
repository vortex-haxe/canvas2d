package canvas.display;

import canvas.graphics.Color;
import canvas.graphics.Shader;
import canvas.graphics.Texture;

import canvas.math.Vector2;
import canvas.math.Vector4;

import canvas.servers.RenderingServer;

/**
 * A simple canvas object capable of rendering a texture.
 */
class Sprite extends Canvas {
    /**
     * The currently rendering texture.
     */
    public var texture:Texture;

    /**
     * The shader applied to the sprite
     * whenever it renders.
     */
    public var shader:Shader;

    /**
     * The color tint applied to this sprite
     * whenever it renders.
     * 
     * If set to something like `RED`, the sprite
     * will have a red tint to it.
     * 
     * Same goes for any color chosen.
     */
    public var tint(default, set):Color = Color.WHITE;

    /**
     * Makes a new `Sprite` instance.
     * 
     * @param  texture  The texture to make this sprite render. 
     */
    public function new(?texture:Texture) {
        super();
        this.texture = texture;
    }

    /**
     * Draws this sprite.
     * Override this function to draw your own stuff aswell!
     * 
     * Remember to call `super.draw()` to ensure
     * that the children of this canvas update aswell!
     */
    override function draw() {
        if(texture != null) {
            final shader:Shader = this.shader ?? RenderingServer.backend.defaultShader;
            @:privateAccess {
                shader.useProgram();
                RenderingServer.backend.quadRenderer.texture = texture.textureData;
            }
            RenderingServer.backend.quadRenderer.drawTexture(_pos.set(x, y), _size.set(texture.size.x * scale.x, texture.size.y * scale.y), tint, _clipRectUVCoords, Vector2.ZERO, 0);
        }
        super.draw();
    }

    // --------------- //
	// [ Private API ] //
	// --------------- //

	private var _pos:Vector2 = new Vector2(0.0, 0.0);
	private var _size:Vector2 = new Vector2(0.0, 0.0);
	private var _clipRectUVCoords:Vector4 = new Vector4(0.0, 0.0, 1.0, 1.0);

    @:noCompletion
    private function set_tint(newTint:Color):Color {
        tint.copyFrom(newTint);
        newTint = null;
        return tint;
    }
}