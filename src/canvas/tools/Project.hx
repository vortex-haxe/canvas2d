package canvas.tools;

import haxe.xml.Access;
import canvas._backend.macros.DefinesMacro;

using StringTools;

typedef XmlHaxelib = {
    var name:String;
    var version:String;
}

typedef XmlHaxedef = {
    var name:String;
    var value:String;
}

typedef XmlHaxeflag = {
    var name:String;
    var value:String;
}

typedef ProjectConfig = {
    var xml:Access;
    var meta:Map<String, String>;
    var window:Map<String, String>;
    var haxelibs:Array<XmlHaxelib>;
    var haxedefs:Array<XmlHaxedef>;
    var haxeflags:Array<XmlHaxeflag>;
    var defined:Map<String, String>;
}

class Project {
    /**
     * Parses project config XML data into a simple
     * structure containing the XML and some other pieces
     * of data retrieved from the XML.
     * 
     * @param  xml  The XML data to parse.
     */
    public static function parse(xml:Xml):ProjectConfig {
        final conf:ProjectConfig = {
            xml: cast (xml.nodeType == Element ? xml : xml.firstElement()),
            meta: [],
            window: [],
            haxelibs: [],
            haxedefs: [],
            haxeflags: [],
            defined: [
                "windows" => (Sys.systemName() == "Windows") ? "1" : "0",
                "linux"   => (Sys.systemName() == "Linux")   ? "1" : "0",
                "bsd"     => (Sys.systemName() == "BSD")     ? "1" : "0",
                "mac"     => (Sys.systemName() == "Mac")     ? "1" : "0",
                "macos"   => (Sys.systemName() == "Mac")     ? "1" : "0"
            ]
        };

        final desktopSystems:Array<String> = [conf.defined.get("windows"), conf.defined.get("linux"), conf.defined.get("mac")];
        conf.defined.set("desktop", (desktopSystems.contains("1") || desktopSystems.contains("true")) ? "true" : "false");

        function resolveStringIf(defines:Map<String, String>, condition:String, checkParenthCount:Bool):Bool {
            if (checkParenthCount && condition.contains("(")) {
                var leftCount:Int = 0;
                var rightCount:Int = 0;
                var countIndex:Int = -1;
                while ((countIndex = condition.indexOf("(", countIndex)) >= 0)
                    leftCount++;

                countIndex = -1;
                while ((countIndex = condition.indexOf(")", countIndex)) >= 0) // please tell me theres a better way of counting these strings
                    rightCount++;

                if (leftCount != rightCount)
                    throw 'Unable to parse condition "${condition}": Unmatched parenthesis count. $leftCount "(" | $rightCount ")")';
            }

            if (condition.contains("||")) {
                var toReturn:Bool = false;
                for (split in condition.split("||"))
                    toReturn = toReturn || resolveStringIf(defines, split.trim(), false);
                return toReturn;
            }
            if (condition.contains("&&")) {
                for (split in condition.split("&&")) {
                    if (!resolveStringIf(defines, split.trim(), false))
                        return false;
                }
                return true;
            }
            return (defines[condition] == null || defines[condition] == "0" || defines[condition] == "false");
        }

        function parseElementsInXml(data:Access) {
            for(element in data.elements) {
                var canRun:Bool = true;

                final defines:Map<String, String> = DefinesMacro.getDefines();
                if(element.has.resolve("if"))
                    canRun = resolveStringIf(defines, element.att.resolve("if"), true);
                
                if(element.has.resolve("unless"))
                    canRun = canRun && !resolveStringIf(defines, element.att.resolve("unless"), true);

                if (!canRun)
                    continue;
    
                switch(element.name.toLowerCase()) {
                    case "section":
                        parseElementsInXml(element); // recursion 🤯 

                    case "app":
                        for(attName in element.x.attributes()) {
                            final value:String = element.att.resolve(attName);
                            conf.meta.set(attName, value);
                        }

                    case "window":
                        for(attName in element.x.attributes()) {
                            final value:String = element.att.resolve(attName);
                            conf.window.set(attName, value);
                        }
    
                    case "set", "define":
                        conf.defined.set(element.att.name, element.has.value ? element.att.value : "1");

                    case "haxelib":
                        conf.haxelibs.push({
                            name: element.att.name,
                            version: element.has.version ? element.att.version : null
                        });
                        
                    case "haxedef":
                        conf.haxedefs.push({
                            name: element.att.name,
                            value: element.has.value ? element.att.value : "1"
                        });

                    case "haxeflag":
                        conf.haxeflags.push({
                            name: element.att.name,
                            value: element.has.value ? element.att.value : "1"
                        });
                }
            }
        }
        parseElementsInXml(cast conf.xml);

        return conf;
    }
}