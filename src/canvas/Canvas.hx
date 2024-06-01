package canvas;

import canvas.app.Event;
import canvas.graphics.Shader;
import canvas.math.Vector2;
import canvas.utils.AssetCache.IDisposable;

/**
 * An updatable and drawable canvas that can
 * contain other canvases within it.
 * 
 * This class is designed to have similar functionality
 * to OpenFL's Sprite class.
 */
class Canvas implements IDisposable {
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
     * The opacity of this canvas object along with
     * it's children from a `0` to `1` range.
     * 
     * NOTE: Invisible canvas objects will still update!
     */
    public var alpha:Float = 1;

    /**
     * Controls whether or not this canvas object
     * and it's children can draw onto the screen.
     * 
     * NOTE: Invisible canvas objects will still update!
     */
    public var visible:Bool = true;

    /**
     * The shader applied to the sprite
     * whenever it renders.
     */
    public var shader:Shader;

    /**
     * The event that gets dispatched when this
     * child canvas gets added to it's parent.
     */
    public var addedToParent:Event<Canvas->Void> = new Event<Canvas->Void>();

    /**
     * The event that gets dispatched when this
     * child canvas gets removed from it's parent.
     */
    public var removedFromParent:Event<Void->Void> = new Event<Void->Void>();

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
        canvas.addedToParent.dispatch(this);
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
        canvas.addedToParent.dispatch(this);
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
        canvas.removedFromParent.dispatch();
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
        if(alpha == 0 || !visible)
            return;

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
        for(i in 0...children.length) {
            final child:Canvas = children[i];
            if(child != null)
                child.dispose();
        }
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