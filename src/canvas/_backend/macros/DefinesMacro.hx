package canvas._backend.macros;

import haxe.macro.Context;

@:keep
class DefinesMacro {
    public static function getDefines():Map<String, String> {
        #if macro
        return Context.getDefines();
        #else
        return [];
        #end
    }
}