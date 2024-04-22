package canvas._backend;

import haxe.Log;
import haxe.PosInfos;

import canvas._backend.native.NativeAPI;
import canvas._backend.native.NativeAPI.ConsoleColor;

class Logs {
	public static var nativeTrace = Log.trace;

	public static function init() {
		Log.trace = function(v:Dynamic, ?infos:Null<PosInfos>) {
			var data = [
				logText('${infos.fileName}:${infos.lineNumber}: ', CYAN),
				logText(Std.string(v))
			];

			if (infos.customParams != null) {
				for (i in infos.customParams) {
					data.push(
						logText("," + Std.string(i))
					);
				}
			}
			__showInConsole(prepareColoredTrace(data, TRACE));
		};
	}

	public static function traceColored(text:Array<LogText>, level:Level = INFO) {
		__showInConsole(prepareColoredTrace(text, level));
	}

	public static function trace(text:String, level:Level = INFO, color:ConsoleColor = LIGHTGRAY) {
		traceColored([{
			text: text,
			color: color
		}], level);
	}

	// --------------- //
	// [ Private API ] //
	// --------------- //

	private static var __showing:Bool = false;

	private static function prepareColoredTrace(text:Array<LogText>, level:Level = INFO) {
		var superCoolText = [
			logText('[ '),
			switch(level) {
				case WARNING:	logText('WARN', DARKYELLOW);
				case ERROR:		logText('ERROR', DARKRED);
				case TRACE:		logText('TRACE', GRAY);
				case VERBOSE:	logText('VERBOSE', DARKMAGENTA);
				default:		logText('INFO', CYAN);
			},
			logText(' ] ')
		];
		for(k=>e in superCoolText)
			text.insert(k, e);
		return text;
	}

	private static function logText(text:String, color:ConsoleColor = LIGHTGRAY):LogText {
		return {
			text: text,
			color: color
		};
	}

	private static function __showInConsole(text:Array<LogText>) {
		#if sys
		while(__showing)
			Sys.sleep(0.05);
		
		__showing = true;
		for(t in text) {
			NativeAPI.setConsoleColors(t.color);
			Sys.print(t.text);
			// windows 8 will not cooperate correctly if i don't sleep twice
			Sys.sleep(0.001);
			NativeAPI.setConsoleColors();
			Sys.sleep(0.001);
		}
		NativeAPI.setConsoleColors();
		Sys.print("\r\n");
		__showing = false;
		#else
		@:privateAccess
		nativeTrace([for(t in text) t.text].join(""));
		#end
	}
}

enum abstract Level(Int) {
	var INFO = 0;
	var WARNING = 1;
	var ERROR = 2;
	var TRACE = 3;
	var VERBOSE = 4;
}
typedef LogText = {
	var text:String;
	var color:ConsoleColor;
}