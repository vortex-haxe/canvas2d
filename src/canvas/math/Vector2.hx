package canvas.math;

@:forward abstract Vector2(BaseVector2) to BaseVector2 from BaseVector2 {
	public static var ZERO(default, never):Vector2 = new Vector2(0, 0);
	public static var ONE(default, never):Vector2 = new Vector2(0, 0);

	public static var UP(default, never):Vector2 = new Vector2(0, -1);
	public static var DOWN(default, never):Vector2 = new Vector2(0, 1);
	public static var LEFT(default, never):Vector2 = new Vector2(-1, 0);
	public static var RIGHT(default, never):Vector2 = new Vector2(1, 0);

	public static var AXIS_X(default, never):Vector2 = new Vector2(1, 0);
	public static var AXIS_Y(default, never):Vector2 = new Vector2(0, 1);
	
	public inline function new(x:Float = 0, y:Float = 0) {
		this = new BaseVector2(x, y);
	}

	@:noCompletion
	@:op(-A)
	private static inline function invert(a:Vector2) {
		return new Vector2(-a.x, -a.y);
	}

	@:noCompletion
	@:op(A + B)
	private static inline function addOp(a:Vector2, b:Vector2) {
		return new Vector2(a.x + b.x, a.y + b.y);
	}

	@:noCompletion
	@:op(A + B)
	private static inline function addFloatOp(a:Vector2, b:Float) {
		return new Vector2(a.x + b, a.y + b);
	}

	@:noCompletion
	@:op(A += B)
	private static inline function addEqualOp(a:Vector2, b:Vector2) {
		return a.add(b.x, b.y);
	}

	@:noCompletion
	@:op(A += B)
	private static inline function addEqualFloatOp(a:Vector2, b:Float) {
		return a.add(b, b);
	}

	@:noCompletion
	@:op(A - B)
	private static inline function subtractOp(a:Vector2, b:Vector2) {
		return new Vector2(a.x - b.x, a.y - b.y);
	}

	@:noCompletion
	@:op(A - B)
	private static inline function subtractFloatOp(a:Vector2, b:Float) {
		return new Vector2(a.x - b, a.y - b);
	}

	@:noCompletion
	@:op(A -= B)
	private static inline function subtractEqualOp(a:Vector2, b:Vector2) {
		return a.subtract(b.x, b.y);
	}

	@:noCompletion
	@:op(A -= B)
	private static inline function subtractEqualFloatOp(a:Vector2, b:Float) {
		return a.subtract(b, b);
	}

	@:noCompletion
	@:op(A * B)
	private static inline function multiplyOp(a:Vector2, b:Vector2) {
		return new Vector2(a.x * b.x, a.y * b.y);
	}

	@:noCompletion
	@:op(A * B)
	private static inline function multiplyFloatOp(a:Vector2, b:Float) {
		return new Vector2(a.x * b, a.y * b);
	}

	@:noCompletion
	@:op(A *= B)
	private static inline function multiplyEqualOp(a:Vector2, b:Vector2) {
		return a.multiply(b.x, b.y);
	}

	@:noCompletion
	@:op(A *= B)
	private static inline function multiplyEqualFloatOp(a:Vector2, b:Float) {
		return a.multiply(b, b);
	}

	@:noCompletion
	@:op(A / B)
	private static inline function divideOp(a:Vector2, b:Vector2) {
		return new Vector2(a.x / b.x, a.y / b.y);
	}
	
	@:noCompletion
	@:op(A / B)
	private static inline function divideFloatOp(a:Vector2, b:Float) {
		return new Vector2(a.x / b, a.y / b);
	}

	@:noCompletion
	@:op(A /= B)
	private static inline function divideEqualOp(a:Vector2, b:Vector2) {
		return a.divide(b.x, b.y);
	}

	@:noCompletion
	@:op(A /= B)
	private static inline function divideEqualFloatOp(a:Vector2, b:Float) {
		return a.divide(b, b);
	}

	@:from
	private static inline function fromIEquivalent(a:Vector2i) {
		return new Vector2(a.x, a.y);
	}

	@:to
	private static inline function toIEquivalent(a:Vector2) {
		return new Vector2i(Math.floor(a.x), Math.floor(a.y));
	}
}

/**
 * A simple class to store 2D X and Y values.
 */
class BaseVector2 {
    /**
     * Static matrix used for intermediate calculations.
     */
	private static var dummy = new BaseVector2(0.0, 0.0);

	/**
	 * The X value of this vector.
	 */
	public var x(default, set):Float;

	/**
	 * The Y value of this vector.
	 */
	public var y(default, set):Float;

	/**
	 * Returns a new `Vector2`.
	 * 
	 * @param x  The X value of this vector.
	 * @param y  The Y value of this vector.
	 */
	public function new(x:Float = 0, y:Float = 0) {
		@:bypassAccessor this.x = x;
		@:bypassAccessor this.y = y;
	}

	/**
	 * Sets the values of this vector.
	 * 
	 * @param x  The X value of this vector.
	 * @param y  The Y value of this vector.
	 */
	public function set(x:Float = 0, y:Float = 0) {
		@:bypassAccessor this.x = x;
		@:bypassAccessor this.y = y;
		if (_onChange != null)
			_onChange(this.x, this.y);
		return this;
	}

	/**
	 * Adds to the values of this vector with given values.
	 * 
	 * @param x  The X value to add.
	 * @param y  The Y value to add.
	 */
	public function add(x:Float = 0, y:Float = 0) {
		@:bypassAccessor this.x += x;
		@:bypassAccessor this.y += y;
		if (_onChange != null)
			_onChange(this.x, this.y);
		return this;
	}

	/**
	 * Subtracts the values of this vector by given values.
	 * 
	 * @param x  The X value to subtract.
	 * @param y  The Y value to subtract.
	 */
	public function subtract(x:Float = 0, y:Float = 0) {
		@:bypassAccessor this.x -= x;
		@:bypassAccessor this.y -= y;
		if (_onChange != null)
			_onChange(this.x, this.y);
		return this;
	}

	/**
	 * Multiplies the values of this vector with given values.
	 * 
	 * @param x  The X value to multiply.
	 * @param y  The Y value to multiply.
	 */
	public function multiply(x:Float = 0, y:Float = 0) {
		@:bypassAccessor this.x *= x;
		@:bypassAccessor this.y *= y;
		if (_onChange != null)
			_onChange(this.x, this.y);
		return this;
	}

	/**
	 * Divides the values of this vector by given values.
	 * 
	 * @param x  The X value to divide.
	 * @param y  The Y value to divide.
	 */
	public function divide(x:Float = 0, y:Float = 0) {
		@:bypassAccessor this.x /= x;
		@:bypassAccessor this.y /= y;
		if (_onChange != null)
			_onChange(this.x, this.y);
		return this;
	}

	/**
	 * Copies the values from another Vector2
	 * onto this one.
	 */
	public function copyFrom(vec:Vector2) {
		x = vec.x;
		y = vec.y;
		return this;
	}

	// ##==-- Privates --==## //
	private var _onChange:(x:Float, y:Float) -> Void;

	@:noCompletion
	private function set_x(value:Float):Float {
		if (_onChange != null)
			_onChange(value, y);
		return x = value;
	}

	@:noCompletion
	private function set_y(value:Float):Float {
		if (_onChange != null)
			_onChange(x, value);
		return y = value;
	}

    public function toString():String {
        return '(${x}, ${y})';
    }

    public function rotated(rads) {
        dummy.x = x * Math.cos(rads) - y * Math.sin(rads); 
        dummy.y = x * Math.sin(rads) + y * Math.cos(rads);
        return copyFrom(dummy);
    }
}
