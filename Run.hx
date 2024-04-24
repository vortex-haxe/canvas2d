package;

import haxe.io.Path;
import haxe.io.Bytes;

import sys.io.File;
import sys.FileSystem;

import canvas._backend.Logs;
import canvas._backend.macros.ProjectMacro;
import canvas._backend.native.NativeAPI;

import canvas.tools.Project;
import canvas.tools.FileUtil;

using StringTools;

typedef Command = {
	var name:String;
	var description:String;
	var method:Void->Void;
}

@:access(canvas._backend.Logs)
class Run {
	static final cmds:Array<Command> = [
		{
			name: "help",
			description: "Lists every available command.",
			method: () -> {
				Sys.print("\r\n--========##[ Command List ]##========--\r\n\r\n");
				for (cmd in cmds)
					Sys.print('${cmd.name} - ${cmd.description}\r\n');
				Sys.print("\r\n--========####################========--\r\n\r\n");
			}
		},
		{
			name: "create",
			description: "Create a fresh Canvas2D project.",
			method: () -> {
				final emptyZipFile:String = Path.normalize(Path.join([ProjectMacro.getConfigDir(), "projects", "empty.zip"]));
				final args:Array<String> = Sys.args() ?? [];
				final curDir:String = Path.normalize(args[args.length - 1]);
				Sys.print('Please input the name of the new project. (Will be created in ${curDir})\r\n');
				try {
					final result:String = Sys.stdin().readLine().toString();
					final newDir:String = Path.normalize(Path.join([curDir, result]));
					if (FileSystem.exists(newDir)) {
						Sys.print('Project at ${newDir} already exists! Please delete it before continuing.');
						return;
					} else {
						Sys.print('Creating project at ${newDir}...\r\n');
						FileSystem.createDirectory(newDir);
						FileUtil.unzipFile(emptyZipFile, newDir);
					}
					Sys.print('Project at ${newDir} has been created!');
				} catch (e) {}
			}
		},
		{
			name: "build",
			description: "Build a Canvas2D project.",
			method: buildProj.bind(false)
		},
		{
			name: "test",
			description: "Build and run a Canvas2D project.",
			method: buildProj.bind(true)
		},
		{
			name: "run",
			description: "Run a Canvas2D project.",
			method: runProj
		}
	];

	static function main() {
		NativeAPI.init();
		
		var isValidCMD:Bool = false;
		final args:Array<String> = Sys.args() ?? [];
		for (cmd in cmds) {
			if (args[0] == cmd.name) {
				isValidCMD = true;
				if (cmd.method != null)
					cmd.method();
				break;
			}
		}
		if (!isValidCMD) {
			final asciiArt:String = "
                                         ________     .___
  ____ _____    _______  _______    _____\\_____  \\  __| _/
_/ ___\\\\__  \\  /    \\  \\/ /\\__  \\  /  ___//  ____/ / __ | 
\\  \\___ / __ \\|   |  \\   /  / __ \\_\\___ \\/       \\/ /_/ | 
 \\___  >____  /___|  /\\_/  (____  /____  >_______ \\____ | 
     \\/     \\/     \\/           \\/     \\/        \\/    \\/ 
            \r\n";
			NativeAPI.setConsoleColors(GREEN);
			Sys.print(asciiArt);

			NativeAPI.setConsoleColors();
			
			Sys.print("Welcome to Canvas2D: The core backend for Vortex, designed to abstract lower level parts of an application/game engine into friendlier classes/functions.\r\n\r\n");
			Sys.print("Type in \"haxelib run canvas2d help\" for a list of every available command!\r\n");
		}
	}

	static function buildProj(?runAfterBuild:Bool = false) {
		final libDir:String = Sys.getCwd();

        final sysArgs:Array<String> = Sys.args();
        final curDir:String = sysArgs[sysArgs.length - 1];

		if (!FileSystem.exists('${curDir}config.xml')) {
			Logs.trace("A config.xml file couldn't be found in the current directory.", ERROR);
			return;
		}
		final args:Array<String> = [];
		final cfg:ProjectConfig = Project.parse(Xml.parse(File.getContent('${curDir}config.xml')));

		var sourceFolder:String = "source";
		if(cfg.xml.hasNode.source)
			sourceFolder = cfg.xml.node.source.att.path;

		if(cfg.xml.hasNode.classpath)
			sourceFolder = cfg.xml.node.classpath.att.path;

        args.push('--class-path');
        args.push(sourceFolder);

        args.push('--library');
        args.push('canvas2d');

		for (lib in cfg.haxelibs) {
			args.push('--library');
			args.push('${lib.name}${(lib.version != null && lib.version.length != 0) ? ":" + lib.version : ""}');
		}

		final is32bit:String = (cfg.defined.get("32") ?? cfg.defined.get("32bits") ?? "0").toLowerCase();
        if (args.contains("-32") || args.contains("-32bits") || is32bit == "1" || is32bit == "true") {
            args.push('--define');
            args.push('HXCPP_M32');
		}

		args.push('--main');
		args.push(cfg.meta.get("main"));

		final buildDir:String = cfg.defined.get("BUILD_DIR") ?? "export";
		final platform:String = Sys.systemName().toLowerCase();
		args.push('--cpp');
		args.push('${buildDir}/${platform}/obj');
		
		final isDebug:String = (cfg.defined.get("debug") ?? "0").toLowerCase();
		if(args.contains("-debug") || isDebug == "1" || isDebug == "true")
			args.push("--debug");

		args.push("--macro");
		args.push("canvas._backend.macros.OSDefineMacro.build()");
		
		Sys.setCwd(curDir);

		final binFolder:String = Path.normalize(Path.join([curDir, buildDir, platform, "bin"]));
		if(!FileSystem.exists(binFolder))
			FileSystem.createDirectory(binFolder);
			
		final compileError:Int = Sys.command('haxe', args);
		if(compileError == 0) {
			Sys.setCwd(Path.normalize(Path.join([curDir, buildDir, platform, "obj"])));
			
			if(Sys.systemName() == "Windows") { // Windows
				final exePath:String = Path.normalize(Path.join([binFolder, '${cfg.meta.get("file")}${((isDebug == "1" || isDebug == "true") ? "-debug" : "")}.exe']));
				File.copy(
					Path.normalize(Path.join([Sys.getCwd(), '${cfg.meta.get("main").substring(cfg.meta.get("main").lastIndexOf(".") + 1)}.exe'])),
					exePath
				);
				for(file in FileSystem.readDirectory(Sys.getCwd())) {
					if(Path.extension(file) == "dll") {
						File.copy(
							Path.normalize(Path.join([Sys.getCwd(), file])),
							Path.normalize(Path.join([binFolder, file]))
						);
					}
				}
				final icon:String = cfg.window.get("icon") ?? "icon.png";
				final projIconDir:String = Path.normalize(Path.join([curDir, icon]));
				final outputIconDir:String = Path.normalize(Path.join([binFolder, "icon.ico"]));
				
				if(FileSystem.exists(projIconDir)) {
					// Generate ico file
					Sys.setCwd(Path.normalize(Path.join([libDir, "helpers", "windows", "magick"])));
					Sys.command("convert.exe", ["-resize", "256x256", projIconDir, outputIconDir]);
					
					// Apply icon to exe file
					Sys.setCwd(Path.normalize(Path.join([libDir, "helpers", "windows"])));
					Sys.command("ReplaceVistaIcon.exe", [exePath, outputIconDir]);
				} else {
					Logs.trace('Icon file "${icon}" doesn\'t exist in the project directory!.', WARNING);
				}
			} else { // Linux/MacOS (Maybe BSD too, I forgot how BSD works)
				File.copy(
					Path.normalize(Path.join([Sys.getCwd(), '${cfg.meta.get("main").substring(cfg.meta.get("main").lastIndexOf(".") + 1)}${((isDebug == "1" || isDebug == "true") ? "-debug" : "")}'])),
					Path.normalize(Path.join([binFolder, '${cfg.meta.get("file")}']))
				);
				Sys.setCwd(binFolder);
				Sys.command('chmod +x "${cfg.meta.get("file")}"');
			}
			if(runAfterBuild)
				runProj();
		}
	}

	static function runProj() {
        final sysArgs:Array<String> = Sys.args();
        final curDir:String = sysArgs[sysArgs.length - 1];

		if (!FileSystem.exists('${curDir}config.xml')) {
			Logs.trace("A config.xml file couldn't be found in the current directory.", ERROR);
			return;
		}
		final cfg:ProjectConfig = Project.parse(Xml.parse(File.getContent('${curDir}config.xml')));
		
		final buildDir:String = cfg.defined.get("BUILD_DIR") ?? "export";
		final platform:String = Sys.systemName().toLowerCase();

		Sys.setCwd(curDir);
		if(Sys.systemName() == "Windows") { // Windows
			final exec:String = Path.normalize(Path.join([curDir, buildDir, platform, "bin"]));
			if(FileSystem.exists(exec)) {
				Sys.setCwd(exec);
				Sys.command('"${cfg.meta.get("file")}.exe"');
			}
		} else { // Linux/MacOS (Maybe BSD too, I forgot how BSD works)
			final exec:String = Path.normalize(Path.join([curDir, buildDir, platform, "bin"]));
			if(FileSystem.exists(exec)) {
				Sys.setCwd(exec);
				Sys.command('"./${cfg.meta.get("file")}"');
			}
		}
	}
}
