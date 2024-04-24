package canvas;

import canvas.graphics.Texture;
import canvas.math.Vector2;
import canvas.servers.RenderingServer;

/**
 * An updatable and drawable canvas that can
 * contain other canvases within it.
 * 
 * This class is designed to have similar functionality
 * to OpenFL's Sprite class.
 */
@:access(canvas.graphics.Texture)
class Canvas {
    /**
     * The children of this canvas.
     */
    public var children(default, null):Array<Canvas> = [];

    /**
     * The parent of this canvas.
     */
    public var parent(default, null):Canvas = null;

    /**
     * The X coordinate of this object starting
     * from the top-left corner of the window.
     */
    public var x:Float = 0;

    /**
     * The Y coordinate of this object starting
     * from the top-left corner of the window.
     */
    public var y:Float = 0;

    /**
     * The X and Y scale multiplier of this object.
     * `1` being the default value.
     */
    @:isVar
    public var scale(default, set):Vector2 = new Vector2().copyFrom(Vector2.ONE);

    /**
     * The layer index of this canvas according to it's parent.
     */
    public var layer(get, never):Int;

    /**
     * Makes a new `Canvas` instance.
     */
    public function new() {}

    /**
     * Adds a child canvas to this canvas.
     */
    public function addChild(canvas:Canvas):Void {
        if(children.contains(canvas)) {
            Logs.trace("Child canvas was already added to it's parent!", ERROR);
            return;
        }
        canvas.parent = this;
        children.push(canvas);
    }

    /**
     * Adds a child canvas at a specified layer to this canvas.
     */
    public function insertChild(layer:Int, canvas:Canvas):Void {
        if(children.contains(canvas)) {
            Logs.trace("Child canvas was already added to it's parent!", ERROR);
            return;
        }
        canvas.parent = this;
        children.insert(layer, canvas);
    }

    /**
     * Removes a child canvas from this canvas.
     */
    public function removeChild(canvas:Canvas):Void {
        if(!children.contains(canvas)) {
            Logs.trace("Child canvas doesn't have a parent!", ERROR);
            return;
        }
        canvas.parent = null;
        children.remove(canvas);
    }

    /**
     * Puts this canvas into a new parent canvas.
     */
    public function reparent(newParent:Canvas):Void {
        parent.removeChild(this);
        newParent.addChild(this);
    }

    /**
     * Updates this canvas object and it's children.
     * Override this function to update your own stuff aswell!
     * 
     * Remember to call `super.update(delta)` to ensure
     * that the children of this canvas update aswell!
     * 
     * @param  delta  The time since the last frame in seconds.
     */
    public function update(delta:Float):Void {
        for(i in 0...children.length) {
            final child:Canvas = children[i];
            if(child != null)
                child.update(delta);
        }
    }

    /**
     * Draws this canvas object and it's children.
     * Override this function to draw your own stuff aswell!
     * 
     * Remember to call `super.draw()` to ensure
     * that the children of this canvas update aswell!
     */
    public function draw():Void {
        for(i in 0...children.length) {
            final child:Canvas = children[i];
            if(child != null)
                child.draw();
        }
    }

    /**
     * Disposes of this canvas object and
     * all of it's properties.
     */
    public function dispose():Void {
        parent = null;
        @:bypassAccessor scale = null;
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //

    @:noCompletion
    private function get_layer():Int {
        if(parent != null)
            return parent.children.indexOf(this);

        return 0;
    }

    @:noCompletion
    private function set_scale(newScale:Vector2):Vector2 {
        scale.copyFrom(newScale);
        newScale = null;
        return scale;
    }
}