package canvas.ui;

import canvas.utils.MacroUtil;

enum abstract KeyCode(Int) from Int to Int {
	public static var fromStringMap(default, null):Map<String, KeyCode> = MacroUtil.buildMap("canvas.ui.KeyCode");
	public static var toStringMap(default, null):Map<KeyCode, String> = MacroUtil.buildMap("canvas.ui.KeyCode", true);

    var UNKNOWN = 0;
    var ENTER = 13;
    var ESCAPE = 27;
    var BACKSPACE = 8;
    var TAB = 9;
    var SPACE = 32;
    var EXCLAIM = 33;
    var QUOTEDBL = 34;
    var HASH = 35;
    var PERCENT = 37;
    var DOLLAR = 36;
    var AMPERSAND = 38;
    var QUOTE = 39;
    var LEFTPAREN = 40;
    var RIGHTPAREN = 41;
    var ASTERISK = 42;
    var PLUS = 43;
    var COMMA = 44;
    var MINUS = 45;
    var PERIOD = 46;
    var SLASH = 47;
    var ZERO = 48;
    var ONE = 49;
    var TWO = 50;
    var THREE = 51;
    var FOUR = 52;
    var FIVE = 53;
    var SIX = 54;
    var SEVEN = 55;
    var EIGHT = 56;
    var NINE = 57;
    var COLON = 58;
    var SEMICOLON = 59;
    var LESS = 60;
    var EQUALS = 61;
    var GREATER = 62;
    var QUESTION = 63;
    var AT = 64;
    var LEFTBRACKET = 91;
    var BACKSLASH = 92;
    var RIGHTBRACKET = 93;
    var CARET = 94;
    var UNDERSCORE = 95;
    var BACKQUOTE = 96;
    var A = 97;
    var B = 98;
    var C = 99;
    var D = 100;
    var E = 101;
    var F = 102;
    var G = 103;
    var H = 104;
    var I = 105;
    var J = 106;
    var K = 107;
    var L = 108;
    var M = 109;
    var N = 110;
    var O = 111;
    var P = 112;
    var Q = 113;
    var R = 114;
    var S = 115;
    var T = 116;
    var U = 117;
    var V = 118;
    var W = 119;
    var X = 120;
    var Y = 121;
    var Z = 122;
    var NONUSHASH = 1073741874;
    var APOSTROPHE = 1073741876;
    var GRAVE = 1073741877;
    var CAPSLOCK = 1073741881;
    var F1 = 1073741882;
    var F2 = 1073741883;
    var F3 = 1073741884;
    var F4 = 1073741885;
    var F5 = 1073741886;
    var F6 = 1073741887;
    var F7 = 1073741888;
    var F8 = 1073741889;
    var F9 = 1073741890;
    var F10 = 1073741891;
    var F11 = 1073741892;
    var F12 = 1073741893;
    var PRINTSCREEN = 1073741894;
    var SCROLLLOCK = 1073741895;
    var PAUSE = 1073741896;
    var INSERT = 1073741897;
    var HOME = 1073741898;
    var PAGEUP = 1073741899;
    var DELETE = 1073741900;
    var END = 1073741901;
    var PAGEDOWN = 1073741902;
    var RIGHT = 1073741903;
    var LEFT = 1073741904;
    var DOWN = 1073741905;
    var UP = 1073741906;
    var NUMLOCKCLEAR = 1073741907;
    var KP_DIVIDE = 1073741908;
    var KP_MULTIPLY = 1073741909;
    var KP_MINUS = 1073741910;
    var KP_PLUS = 1073741911;
    var KP_ENTER = 1073741912;
    var KP_ONE = 1073741913;
    var KP_TWO = 1073741914;
    var KP_THREE = 1073741915;
    var KP_FOUR = 1073741916;
    var KP_FIVE = 1073741917;
    var KP_SIX = 1073741918;
    var KP_SEVEN = 1073741919;
    var KP_EIGHT = 1073741920;
    var KP_NINE = 1073741921;
    var KP_ZERO = 1073741922;
    var KP_PERIOD = 1073741923;
    var NONUSBACKSLASH = 1073741924;
    var APPLICATION = 1073741925;
    var POWER = 1073741926;
    var KP_EQUALS = 1073741927;
    var F13 = 1073741928;
    var F14 = 1073741929;
    var F15 = 1073741930;
    var F16 = 1073741931;
    var F17 = 1073741932;
    var F18 = 1073741933;
    var F19 = 1073741934;
    var F20 = 1073741935;
    var F21 = 1073741936;
    var F22 = 1073741937;
    var F23 = 1073741938;
    var F24 = 1073741939;
    var EXECUTE = 1073741940;
    var HELP = 1073741941;
    var MENU = 1073741942;
    var SELECT = 1073741943;
    var STOP = 1073741944;
    var AGAIN = 1073741945;
    var UNDO = 1073741946;
    var CUT = 1073741947;
    var COPY = 1073741948;
    var PASTE = 1073741949;
    var FIND = 1073741950;
    var MUTE = 1073741951;
    var VOLUMEUP = 1073741952;
    var VOLUMEDOWN = 1073741953;
    var KP_COMMA = 1073741957;
    var KP_EQUALSAS400 = 1073741958;
    var INTERNATIONAL1 = 1073741959;
    var INTERNATIONAL2 = 1073741960;
    var INTERNATIONAL3 = 1073741961;
    var INTERNATIONAL4 = 1073741962;
    var INTERNATIONAL5 = 1073741963;
    var INTERNATIONAL6 = 1073741964;
    var INTERNATIONAL7 = 1073741965;
    var INTERNATIONAL8 = 1073741966;
    var INTERNATIONAL9 = 1073741967;
    var LANG1 = 1073741968;
    var LANG2 = 1073741969;
    var LANG3 = 1073741970;
    var LANG4 = 1073741971;
    var LANG5 = 1073741972;
    var LANG6 = 1073741973;
    var LANG7 = 1073741974;
    var LANG8 = 1073741975;
    var LANG9 = 1073741976;
    var ALTERASE = 1073741977;
    var SYSREQ = 1073741978;
    var CANCEL = 1073741979;
    var CLEAR = 1073741980;
    var PRIOR = 1073741981;
    var ENTER2 = 1073741982;
    var SEPARATOR = 1073741983;
    var OUT = 1073741984;
    var OPER = 1073741985;
    var CLEARAGAIN = 1073741986;
    var CRSEL = 1073741987;
    var EXSEL = 1073741988;
    var KP_00 = 1073742000;
    var KP_000 = 1073742001;
    var THOUSANDSSEPARATOR = 1073742002;
    var DECIMALSEPARATOR = 1073742003;
    var CURRENCYUNIT = 1073742004;
    var CURRENCYSUBUNIT = 1073742005;
    var KP_LEFTPAREN = 1073742006;
    var KP_RIGHTPAREN = 1073742007;
    var KP_LEFTBRACE = 1073742008;
    var KP_RIGHTBRACE = 1073742009;
    var KP_TAB = 1073742010;
    var KP_BACKSPACE = 1073742011;
    var KP_A = 1073742012;
    var KP_B = 1073742013;
    var KP_C = 1073742014;
    var KP_D = 1073742015;
    var KP_E = 1073742016;
    var KP_F = 1073742017;
    var KP_XOR = 1073742018;
    var KP_POWER = 1073742019;
    var KP_PERCENT = 1073742020;
    var KP_LESS = 1073742021;
    var KP_GREATER = 1073742022;
    var KP_AMPERSAND = 1073742023;
    var KP_DBLAMPERSAND = 1073742024;
    var KP_VERTICALBAR = 1073742025;
    var KP_DBLVERTICALBAR = 1073742026;
    var KP_COLON = 1073742027;
    var KP_HASH = 1073742028;
    var KP_SPACE = 1073742029;
    var KP_AT = 1073742030;
    var KP_EXCLAM = 1073742031;
    var KP_MEMSTORE = 1073742032;
    var KP_MEMRECALL = 1073742033;
    var KP_MEMCLEAR = 1073742034;
    var KP_MEMADD = 1073742035;
    var KP_MEMSUBTRACT = 1073742036;
    var KP_MEMMULTIPLY = 1073742037;
    var KP_MEMDIVIDE = 1073742038;
    var KP_PLUSMINUS = 1073742039;
    var KP_CLEAR = 1073742040;
    var KP_CLEARENTRY = 1073742041;
    var KP_BINARY = 1073742042;
    var KP_OCTAL = 1073742043;
    var KP_DECIMAL = 1073742044;
    var KP_HEXADECIMAL = 1073742045;
    var LCTRL = 1073742048;
    var LSHIFT = 1073742049;
    var LALT = 1073742050;
    var LGUI = 1073742051;
    var RCTRL = 1073742052;
    var RSHIFT = 1073742053;
    var RALT = 1073742054;
    var RGUI = 1073742055;
    var MODE = 1073742081;
    var AUDIONEXT = 1073742082;
    var AUDIOPREV = 1073742083;
    var AUDIOSTOP = 1073742084;
    var AUDIOPLAY = 1073742085;
    var AUDIOMUTE = 1073742086;
    var MEDIASELECT = 1073742087;
    var WWW = 1073742088;
    var MAIL = 1073742089;
    var CALCULATOR = 1073742090;
    var COMPUTER = 1073742091;
    var AC_SEARCH = 1073742092;
    var AC_HOME = 1073742093;
    var AC_BACK = 1073742094;
    var AC_FORWARD = 1073742095;
    var AC_STOP = 1073742096;
    var AC_REFRESH = 1073742097;
    var AC_BOOKMARKS = 1073742098;
    var BRIGHTNESSDOWN = 1073742099;
    var BRIGHTNESSUP = 1073742100;
    var DISPLAYSWITCH = 1073742101;
    var KBDILLUMTOGGLE = 1073742102;
    var KBDILLUMDOWN = 1073742103;
    var KBDILLUMUP = 1073742104;
    var EJECT = 1073742105;
    var SLEEP = 1073742106;
    var APP1 = 1073742107;
    var APP2 = 1073742108;
    var AUDIOREWIND = 1073742109;
    var AUDIOFASTFORWARD = 1073742110;
    var SOFTLEFT = 1073742111;
    var SOFTRIGHT = 1073742112;
    var CALL = 1073742113;
    var ENDCALL = 1073742114;

	@:from
	public static inline function fromString(s:String) {
		s = s.toUpperCase();
		return fromStringMap.exists(s) ? fromStringMap.get(s) : UNKNOWN;
	}

	@:to
	public inline function toString():String {
		return toStringMap.get(this);
	}
}