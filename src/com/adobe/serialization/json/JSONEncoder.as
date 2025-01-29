package com.adobe.serialization.json
{
    import flash.utils.describeType;

    public class JSONEncoder
    {
        public function JSONEncoder(value:*)
        {
            super();
            jsonString = convertToString(value);
        }
        private var jsonString:String;

        public function getString():String
        {
            return jsonString;
        }

        private function convertToString(value:*):String
        {
            if (value is String)
            {
                return escapeString(value as String);
            }
            if (value is Number)
            {
                return !!isFinite(value as Number) ? value.toString() : "null";
            }
            if (value is Boolean)
            {
                return !!value ? "true" : "false";
            }
            if (value is Array)
            {
                return arrayToString(value as Array);
            }
            if (value is Object && value != null)
            {
                return objectToString(value);
            }
            return "null";
        }

        private function escapeString(str:String):String
        {
            var s:String = "";
            var len:Number = str.length;
            var i:int = 0;
            while (i < len)
            {
                var ch:String = str.charAt(i);
                switch (ch)
                {
                    case "\"":
                        s += "\\\"";
                        break;
                    case "\\":
                        s += "\\\\";
                        break;
                    case "\b":
                        s += "\\b";
                        break;
                    case "\f":
                        s += "\\f";
                        break;
                    case "\n":
                        s += "\\n";
                        break;
                    case "\r":
                        s += "\\r";
                        break;
                    case "\t":
                        s += "\\t";
                        break;
                    default:
                        if (ch < " ")
                        {
                            var hexCode:String = ch.charCodeAt(0).toString(16);
                            var zeroPad:String = hexCode.length == 2 ? "00" : "000";
                            s += "\\u" + zeroPad + hexCode;
                        }
                        else
                        {
                            s += ch;
                        }
                        break;
                }
                i++;
            }
            return "\"" + s + "\"";
        }

        private function arrayToString(a:Array):String
        {
            var s:String = "";
            var length:int = int(a.length);
            var i:int = 0;
            while (i < length)
            {
                if (s.length > 0)
                {
                    s += ",";
                }
                s += convertToString(a[i]);
                i++;
            }
            return "[" + s + "]";
        }

        private function objectToString(o:Object):String
        {
            var value:Object;
            var key:String;
            var v:XML;
            var s:String = "";
            var classInfo:XML = describeType(o);
            if (classInfo.@name.toString() == "Object")
            {
                for (key in o)
                {
                    value = o[key];
                    if (!(value is Function))
                    {
                        if (s.length > 0)
                        {
                            s += ",";
                        }
                        s += escapeString(key) + ":" + convertToString(value);
                    }
                }
            }
            else
            {
                for each (v in classInfo.. * .(name() == "variable" || name() == "accessor" && attribute("access").charAt(0) == "r"))
                {
                    if (!(v.metadata && v.metadata.(@name == "Transient").length() > 0))
                    {
                        if (s.length > 0)
                        {
                            s += ",";
                        }
                        s += escapeString(v.@name.toString()) + ":" + convertToString(o[v.@name]);
                    }
                }
            }
            return "{" + s + "}";
        }
    }
}
