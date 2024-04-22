package canvas._backend.macros;

// Thanks Ne_Eo for this macro code
// I'm not good at macros so you are helping a lot 🙏

import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

import haxe.xml.Access as XmlAccess;

#if macro
import haxe.macro.*;
import haxe.macro.Expr;
#end
#if (macro || !eval)
import canvas.tools.Project;
import canvas.tools.FileUtil;
#end

#if macro
using haxe.macro.PositionTools;
#end
using StringTools;

@:keep
class ProjectMacro {
	public static macro function build():Array<Field> {
		#if (macro || !eval)
		final pos = Context.currentPos();
		final posInfo = pos.getInfos();

		var sourcePath:String = Path.directory(posInfo.file);
		if (!Path.isAbsolute(sourcePath))
			sourcePath = Path.join([Sys.getCwd(), sourcePath]);

		sourcePath = Path.normalize(sourcePath);

		final xmlPath:String = Path.normalize(Path.join([sourcePath, "config.xml"]));
		if (!FileSystem.exists(xmlPath))
			Context.fatalError('Couldn\'t find a valid "config.xml" file!', pos);

		final cfg:ProjectConfig = Project.parse(cast Xml.parse(File.getContent(xmlPath)));
		final platform:String = Sys.systemName().toLowerCase();

		// Copy specified asset folders to export folder
		for (node in cfg.xml.nodes.assets) {
			final dirToCopy:String = Path.normalize(Path.join([sourcePath, node.att.path]));
			final destDir:String = Path.normalize(Path.join([sourcePath, cfg.defined.get("BUILD_DIR") ?? "export", platform, "bin", node.att.path]));
			FileUtil.copyDirectory(dirToCopy, destDir);
		}
		return Context.getBuildFields();
		#else
		return null;
		#end
	}

	public static macro function getConfigDir():Expr {
		return macro $v{Path.normalize(Sys.getCwd())};
	}

	public static macro function getConfig():Expr {
		final cwd:String = Path.normalize(Sys.getCwd());
		final xmlPath:String = Path.normalize(Path.join([cwd, "config.xml"]));

		if (!FileSystem.exists(xmlPath))
			Context.fatalError('Couldn\'t find a valid "config.xml" file! ' + xmlPath, Context.currentPos());

		final content:String = File.getContent(xmlPath).replace("\r\n", "\n");
		return macro $v{content};
	}
}
