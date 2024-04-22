package canvas._backend.macros;

import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
#if macro
import haxe.macro.*;
import haxe.macro.Expr;
#end
#if (macro || !eval)
import canvas.app.Application;
import canvas.tools.Project;
#end

#if macro
using haxe.macro.PositionTools;
#end

@:keep
class ApplicationMacro {
	public static macro function build():Array<Field> {
        final fields = Context.getBuildFields();

        // Get project config file
        final pos = Context.currentPos();
		final posInfo = pos.getInfos();

		final sourcePath:String = Path.normalize(Sys.getCwd());
		final cfgPath:String = Path.normalize(Path.join([sourcePath, "config.xml"]));

		if (!FileSystem.exists(cfgPath))
			Context.fatalError('Couldn\'t find a valid "config.xml" file!', pos);

		final cfg:ProjectConfig = Project.parse(Xml.parse(File.getContent(cfgPath)));
        
        // The actual macro
        var mainExpr = macro {
            final app:Application = Type.createInstance(Type.resolveClass($v{cfg.meta.get("main")}), []);
            app.startEventLoop();
        };

        var func:Function = {
            ret: TPath({name: "Void", params: [], pack: []}),
            params: [],
            expr: mainExpr,
            args: []
        };

        var mainField:Field = {
            name: "main",
            access: [AStatic],
            kind: FFun(func),
            pos: Context.currentPos(),
            doc: null,
            meta: []
        };
        fields.push(mainField);
        
        return fields;
    }
}