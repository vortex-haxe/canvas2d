package canvas.graphics;

using StringTools;

/**
 * A simple class that holds RGB values for a color.
 * There are many preset colors available if you need them.
 * 
 * The preset colors have been taken from Godot Engine.
 * @see https://github.com/godotengine/godot/blob/master/core/math/color.cpp
 */
@:forward
abstract Color(BaseColor) from BaseColor to BaseColor {
	public static final ALICE_BLUE:Color = 0xFFF0F8FF;
	public static final ANTIQUE_WHITE:Color = 0xFFFAEBD7;
	public static final AQUA:Color = 0xFF00FFFF;
	public static final AQUAMARINE:Color = 0xFF7FFFD4;
	public static final AZURE:Color = 0xFFF0FFFF;
	public static final BEIGE:Color = 0xFFF5F5DC;
	public static final BISQUE:Color = 0xFFFFE4C4;
	public static final BLACK:Color = 0xFF000000;
	public static final BLANCHED_ALMOND:Color = 0xFFFFEBCD;
	public static final BLUE:Color = 0xFF0000FF;
	public static final BLUE_VIOLET:Color = 0xFF8A2BE2;
	public static final BROWN:Color = 0xFFA52A2A;
	public static final BURLYWOOD:Color = 0xFFDEB887;
	public static final CADET_BLUE:Color = 0xFF5F9EA0;
	public static final CHARTREUSE:Color = 0xFF7FFF00;
	public static final CHOCOLATE:Color = 0xFFD2691E;
	public static final CORAL:Color = 0xFFFF7F50;
	public static final CORNFLOWER_BLUE:Color = 0xFF6495ED;
	public static final CORNSILK:Color = 0xFFFFF8DC;
	public static final CRIMSON:Color = 0xFFDC143C;
	public static final CYAN:Color = 0xFF00FFFF;
	public static final DARK_BLUE:Color = 0xFF00008B;
	public static final DARK_CYAN:Color = 0xFF008B8B;
	public static final DARK_GOLDENROD:Color = 0xFFB8860B;
	public static final DARK_GRAY:Color = 0xFFA9A9A9;
	public static final DARK_GREEN:Color = 0xFF006400;
	public static final DARK_KHAKI:Color = 0xFFBDB76B;
	public static final DARK_MAGENTA:Color = 0xFF8B008B;
	public static final DARK_OLIVE_GREEN:Color = 0xFF556B2F;
	public static final DARK_ORANGE:Color = 0xFFFF8C00;
	public static final DARK_ORCHID:Color = 0xFF9932CC;
	public static final DARK_RED:Color = 0xFF8B0000;
	public static final DARK_SALMON:Color = 0xFFE9967A;
	public static final DARK_SEA_GREEN:Color = 0xFF8FBC8F;
	public static final DARK_SLATE_BLUE:Color = 0xFF483D8B;
	public static final DARK_SLATE_GRAY:Color = 0xFF2F4F4F;
	public static final DARK_TURQUOISE:Color = 0xFF00CED1;
	public static final DARK_VIOLET:Color = 0xFF9400D3;
	public static final DEEP_PINK:Color = 0xFFFF1493;
	public static final DEEP_SKY_BLUE:Color = 0xFF00BFFF;
	public static final DIM_GRAY:Color = 0xFF696969;
	public static final DODGER_BLUE:Color = 0xFF1E90FF;
	public static final FIREBRICK:Color = 0xFFB22222;
	public static final FLORAL_WHITE:Color = 0xFFFFFAF0;
	public static final FOREST_GREEN:Color = 0xFF228B22;
	public static final FUCHSIA:Color = 0xFFFF00FF;
	public static final GAINSBORO:Color = 0xFFDCDCDC;
	public static final GHOST_WHITE:Color = 0xFFF8F8FF;
	public static final GOLD:Color = 0xFFFFD700;
	public static final GOLDENROD:Color = 0xFFDAA520;
	public static final GRAY:Color = 0xFFBEBEBE;
	public static final GREEN:Color = 0xFF00FF00;
	public static final GREEN_YELLOW:Color = 0xFFADFF2F;
	public static final HONEYDEW:Color = 0xFFF0FFF0;
	public static final HOT_PINK:Color = 0xFFFF69B4;
	public static final INDIAN_RED:Color = 0xFFCD5C5C;
	public static final INDIGO:Color = 0xFF4B0082;
	public static final IVORY:Color = 0xFFFFFFF0;
	public static final KHAKI:Color = 0xFFF0E68C;
	public static final LAVENDER:Color = 0xFFE6E6FA;
	public static final LAVENDER_BLUSH:Color = 0xFFFFF0F5;
	public static final LAWN_GREEN:Color = 0xFF7CFC00;
	public static final LEMON_CHIFFON:Color = 0xFFFFFACD;
	public static final LIGHT_BLUE:Color = 0xFFADD8E6;
	public static final LIGHT_CORAL:Color = 0xFFF08080;
	public static final LIGHT_CYAN:Color = 0xFFE0FFFF;
	public static final LIGHT_GOLDENROD:Color = 0xFFFAFAD2;
	public static final LIGHT_GRAY:Color = 0xFFD3D3D3;
	public static final LIGHT_GREEN:Color = 0xFF90EE90;
	public static final LIGHT_PINK:Color = 0xFFFFB6C1;
	public static final LIGHT_SALMON:Color = 0xFFFFA07A;
	public static final LIGHT_SEA_GREEN:Color = 0xFF20B2AA;
	public static final LIGHT_SKY_BLUE:Color = 0xFF87CEFA;
	public static final LIGHT_SLATE_GRAY:Color = 0xFF778899;
	public static final LIGHT_STEEL_BLUE:Color = 0xFFB0C4DE;
	public static final LIGHT_YELLOW:Color = 0xFFFFFFE0;
	public static final LIME:Color = 0xFF00FF00;
	public static final LIME_GREEN:Color = 0xFF32CD32;
	public static final LINEN:Color = 0xFFFAF0E6;
	public static final MAGENTA:Color = 0xFFFF00FF;
	public static final MAROON:Color = 0xFFB03060;
	public static final MEDIUM_AQUAMARINE:Color = 0xFF66CDAA;
	public static final MEDIUM_BLUE:Color = 0xFF0000CD;
	public static final MEDIUM_ORCHID:Color = 0xFFBA55D3;
	public static final MEDIUM_PURPLE:Color = 0xFF9370DB;
	public static final MEDIUM_SEA_GREEN:Color = 0xFF3CB371;
	public static final MEDIUM_SLATE_BLUE:Color = 0xFF7B68EE;
	public static final MEDIUM_SPRING_GREEN:Color = 0xFF00FA9A;
	public static final MEDIUM_TURQUOISE:Color = 0xFF48D1CC;
	public static final MEDIUM_VIOLET_RED:Color = 0xFFC71585;
	public static final MIDNIGHT_BLUE:Color = 0xFF191970;
	public static final MINT_CREAM:Color = 0xFFF5FFFA;
	public static final MISTY_ROSE:Color = 0xFFFFE4E1;
	public static final MOCCASIN:Color = 0xFFFFE4B5;
	public static final NAVAJO_WHITE:Color = 0xFFFFDEAD;
	public static final NAVY_BLUE:Color = 0xFF000080;
	public static final OLD_LACE:Color = 0xFFFDF5E6;
	public static final OLIVE:Color = 0xFF808000;
	public static final OLIVE_DRAB:Color = 0xFF6B8E23;
	public static final ORANGE:Color = 0xFFFFA500;
	public static final ORANGE_RED:Color = 0xFFFF4500;
	public static final ORCHID:Color = 0xFFDA70D6;
	public static final PALE_GOLDENROD:Color = 0xFFEEE8AA;
	public static final PALE_GREEN:Color = 0xFF98FB98;
	public static final PALE_TURQUOISE:Color = 0xFFAFEEEE;
	public static final PALE_VIOLET_RED:Color = 0xFFDB7093;
	public static final PAPAYA_WHIP:Color = 0xFFFFEFD5;
	public static final PEACH_PUFF:Color = 0xFFFFDAB9;
	public static final PERU:Color = 0xFFCD853F;
	public static final PINK:Color = 0xFFFFC0CB;
	public static final PLUM:Color = 0xFFDDA0DD;
	public static final POWDER_BLUE:Color = 0xFFB0E0E6;
	public static final PURPLE:Color = 0xFFA020F0;
	public static final REBECCA_PURPLE:Color = 0xFF663399;
	public static final RED:Color = 0xFFFF0000;
	public static final ROSY_BROWN:Color = 0xFFBC8F8F;
	public static final ROYAL_BLUE:Color = 0xFF4169E1;
	public static final SADDLE_BROWN:Color = 0xFF8B4513;
	public static final SALMON:Color = 0xFFFA8072;
	public static final SANDY_BROWN:Color = 0xFFF4A460;
	public static final SEA_GREEN:Color = 0xFF2E8B57;
	public static final SEASHELL:Color = 0xFFFFF5EE;
	public static final SIENNA:Color = 0xFFA0522D;
	public static final SILVER:Color = 0xFFC0C0C0;
	public static final SKY_BLUE:Color = 0xFF87CEEB;
	public static final SLATE_BLUE:Color = 0xFF6A5ACD;
	public static final SLATE_GRAY:Color = 0xFF708090;
	public static final SNOW:Color = 0xFFFFFAFA;
	public static final SPRING_GREEN:Color = 0xFF00FF7F;
	public static final STEEL_BLUE:Color = 0xFF4682B4;
	public static final TAN:Color = 0xFFD2B48C;
	public static final TEAL:Color = 0xFF008080;
	public static final THISTLE:Color = 0xFFD8BFD8;
	public static final TOMATO:Color = 0xFFFF6347;
	public static final TRANSPARENT:Color = 0x00000000;
	public static final TURQUOISE:Color = 0xFF40E0D0;
	public static final VIOLET:Color = 0xFFEE82EE;
	public static final WEB_GRAY:Color = 0xFF808080;
	public static final WEB_GREEN:Color = 0xFF008000;
	public static final WEB_MAROON:Color = 0xFF800000;
	public static final WEB_PURPLE:Color = 0xFF800080;
	public static final WHEAT:Color = 0xFFF5DEB3;
	public static final WHITE:Color = 0xFFFFFFFF;
	public static final WHITE_SMOKE:Color = 0xFFF5F5F5;
	public static final YELLOW:Color = 0xFFFFFF00;
	public static final YELLOW_GREEN:Color = 0xFF9ACD32;

	/**
	 * Returns a new `Color`.
	 */
	public function new(r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 1) {
		this = new BaseColor(r, g, b, a);
	}

	// --------------- //
	// [ Private API ] //
	// --------------- //

	@:from
	private static inline function _fromInt(color:Int):Color {
		@:privateAccess
		return BaseColor._parseInt(color);
	}
	
	@:from
	private static inline function _fromString(color:String):Color {
		@:privateAccess
		return BaseColor._parseInt(Std.parseInt("0x"+color.replace("#", "").replace("0x", "")));
	}
}

private class BaseColor {
	/**
	 * The red channel of this color. Ranges from `0.0` - `1.0`.
	 */
	public var r:Float = 0;

	/**
	 * The green channel of this color. Ranges from `0.0` - `1.0`.
	 */
	public var g:Float = 0;

	/**
	 * The blue channel of this color. Ranges from `0.0` - `1.0`.
	 */
	public var b:Float = 0;

	/**
	 * The alpha channel of this color. Ranges from `0.0` - `1.0`.
	 */
	public var a:Float = 1;

	/**
	 * Returns a new `Color`.
	 */
	public function new(r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 1) {
		set(r, g, b, a);
	}

	/**
	 * Sets the RGBA components of this color to any
	 * values specified.
	 * 
	 * @param r  The new value for the red component.
	 * @param g  The new value for the green component.
	 * @param b  The new value for the blue component.
	 * @param a  The new value for the alpha component.
	 */
	public function set(r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 1) {
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
		return this;
	}

	/**
	 * Copies the RGBA values from another color
	 * into this one.
	 * 
	 * @param color  The color to copy from.
	 */
	public function copyFrom(color:Color) {
		r = color.r;
		g = color.g;
		b = color.b;
		a = color.a;
		return this;
	}

	public function toString():String {
		return '[ Color | R: ${r}, G: ${g}, B: ${b}, A: ${a} ]';
	}

	// ##==-------------------------------------------------==## //
	// ##==----- Don't modify these parts below unless -----==## //
	// ##==-- you are here to fix a bug or add a feature. --==## //
	// ##==-------------------------------------------------==## //

	@:noCompletion
	private static inline function _parseInt(integer:Int) {
		final newColor:Color = new Color();
		newColor.r = ((integer >> 16) & 0xff) / 255;
		newColor.g = ((integer >> 8) & 0xff) / 255;
		newColor.b = ((integer) & 0xff) / 255;
		newColor.a = ((integer >> 24) & 0xff) / 255;
		return newColor;
	}
}
