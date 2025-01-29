package syscode
{
    import com.adobe.serialization.json.ADOBEJSON;
    import com.greensock.TweenMax;
    import com.xvisage.utils.StringUtils;

    import fl.motion.Color;

    import flash.display.*;
    import flash.events.*;
    import flash.external.ExternalInterface;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.*;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.system.Capabilities;
    import flash.text.*;
    import flash.utils.Dictionary;
    import flash.utils.escapeMultiByte;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;

    public class Util
    {
        public static var thousand_separator:String = " ";

        public static var decimal_separator:String = ".";
        public static var textformat:TextFormat = null;
        public static var traceFilter:Array = [];
        public static var traceOutput:TextField = null;
        public static var debug_listeners:Boolean = false;
        public static var dic:Dictionary = new Dictionary(true);
        public static var aliasfunc:Dictionary = new Dictionary(true);
        public static var dispatch_count:int = 0;
        public static var trace_event_listeners:Boolean = false;
        internal static var rtlswaps:Object = {};
        internal static var rtledits:Object = {};
        private static var stringutils:StringUtils = null;

        public static function StopAllChildrenMov(amc:MovieClip):void
        {
            var cidx:* = undefined;
            var child:* = undefined;
            if (amc)
            {
                amc.stop();
                cidx = 0;
                while (cidx < amc.numChildren)
                {
                    child = amc.getChildAt(cidx);
                    if (child is MovieClip)
                    {
                        StopAllChildrenMov(child);
                    }
                    cidx++;
                }
            }
        }

        public static function StartAllChildrenMov(amc:MovieClip):void
        {
            var cidx:* = undefined;
            var child:* = undefined;
            if (amc)
            {
                amc.play();
                cidx = 0;
                while (cidx < amc.numChildren)
                {
                    child = amc.getChildAt(cidx);
                    if (child is MovieClip)
                    {
                        StartAllChildrenMov(child);
                    }
                    cidx++;
                }
            }
        }

        public static function RemoveChildren(doc:DisplayObjectContainer):void
        {
            if (doc)
            {
                while (doc.numChildren > 0)
                {
                    doc.removeChildAt(0);
                }
            }
        }

        public static function CountAllChildrenMov(amc:MovieClip, filter:Function = null):int
        {
            var child:* = undefined;
            var c:int = 0;
            var cidx:* = 0;
            while (cidx < amc.numChildren)
            {
                child = amc.getChildAt(cidx);
                if (child)
                {
                    if (filter != null)
                    {
                        if (filter(child))
                        {
                            c++;
                        }
                    }
                    else
                    {
                        c++;
                    }
                    if (child is MovieClip)
                    {
                        c += CountAllChildrenMov(child, filter);
                    }
                }
                cidx++;
            }
            return c;
        }

        public static function LocalToGlobal(ado:DisplayObject):Object
        {
            var coord:Point = new Point(0, 0);
            var global:* = ado.localToGlobal(coord);
            return {
                    "x": global.x,
                    "y": global.y,
                    "w": ado.width,
                    "h": ado.height
                };
        }

        public static function LocalToGlobalBounded(ado:DisplayObject):Object
        {
            var b:Rectangle = ado.getBounds(ado);
            var m:Matrix = ado.transform.matrix;
            var p:Object = Util.LocalToGlobal(ado);
            var r:Object = new Object();
            r.x = p.x + b.x * m.a;
            r.y = p.y + b.y * m.d;
            r.w = p.w;
            r.h = p.h;
            return r;
        }

        public static function MoveTo(src_do:DisplayObject, dst_do:DisplayObject):void
        {
            var pt:* = LocalToGlobal(dst_do);
            src_do.x = pt.x;
            src_do.y = pt.y;
        }

        public static function MoveToLocal(src_do:DisplayObject, dst_do:DisplayObject):void
        {
            var pt:* = LocalToGlobal(dst_do);
            pt = src_do.parent.globalToLocal(new Point(pt.x, pt.y));
            src_do.x = pt.x;
            src_do.y = pt.y;
        }

        public static function MoveToAndScale(src_do:DisplayObject, dst_do:DisplayObject):void
        {
            var pt:* = LocalToGlobal(dst_do);
            src_do.x = pt.x;
            src_do.y = pt.y;
            src_do.width = pt.w;
            src_do.height = pt.h;
        }

        public static function SetColor(amc:DisplayObject, acolor:uint):void
        {
            Imitation.SetColor(amc, acolor);
        }

        public static function SetTint(amc:DisplayObject, acolor:uint, amult:Number):void
        {
            var c:Color = new Color();
            c.tintColor = acolor;
            c.tintMultiplier = amult;
            amc.transform.colorTransform = c;
        }

        public static function GetSaturationFilter(amount:Number):ColorMatrixFilter
        {
            var interpolateArrays:Function = function(ary1:Array, ary2:Array, t:Number):Array
            {
                var result:Array = ary1.length >= ary2.length ? ary1.slice() : ary2.slice();
                var i:uint = result.length;
                while (i--)
                {
                    result[i] = ary1[i] + (ary2[i] - ary1[i]) * t;
                }
                return result;
            };
            var colorFilter:* = new ColorMatrixFilter();
            var colmatrix:Array = new Array();
            colmatrix = colmatrix.concat(interpolateArrays([0.3, 0.59, 0.11, 0, 0], [1, 0, 0, 0, 0], amount));
            colmatrix = colmatrix.concat(interpolateArrays([0.3, 0.59, 0.11, 0, 0], [0, 1, 0, 0, 0], amount));
            colmatrix = colmatrix.concat(interpolateArrays([0.3, 0.59, 0.11, 0, 0], [0, 0, 1, 0, 0], amount));
            colmatrix = colmatrix.concat([0, 0, 0, 1, 0]);
            colorFilter.matrix = colmatrix;
            return colorFilter;
        }

        public static function FormatTimeStamp(utc:Boolean = false, subsecond:Boolean = false):String
        {
            var d:Date = new Date();
            var r:* = "";
            if (utc)
            {
                r += Util.StringVal(d.fullYearUTC);
                r += "-";
                r += Util.PaddingLeft(Util.StringVal(d.monthUTC + 1), "0", 2);
                r += "-";
                r += Util.PaddingLeft(Util.StringVal(d.dateUTC), "0", 2);
                r += " ";
                r += Util.PaddingLeft(Util.StringVal(d.hoursUTC), "0", 2);
                r += ":";
                r += Util.PaddingLeft(Util.StringVal(d.minutesUTC), "0", 2);
                r += ":";
                r += Util.PaddingLeft(Util.StringVal(d.secondsUTC), "0", 2);
                if (subsecond)
                {
                    r += ".";
                    r += Util.PaddingLeft(Util.StringVal(d.millisecondsUTC), "0", 3);
                }
            }
            else
            {
                r += Util.StringVal(d.fullYear);
                r += "-";
                r += Util.PaddingLeft(Util.StringVal(d.month + 1), "0", 2);
                r += "-";
                r += Util.PaddingLeft(Util.StringVal(d.date), "0", 2);
                r += " ";
                r += Util.PaddingLeft(Util.StringVal(d.hours), "0", 2);
                r += ":";
                r += Util.PaddingLeft(Util.StringVal(d.minutes), "0", 2);
                r += ":";
                r += Util.PaddingLeft(Util.StringVal(d.seconds), "0", 2);
                if (subsecond)
                {
                    r += ".";
                    r += Util.PaddingLeft(Util.StringVal(d.milliseconds), "0", 3);
                }
            }
            return r;
        }

        public static function FormatDateTime(year:int, month:int, day:int, hour:int, minute:int, second:int):String
        {
            return "" + Util.StringVal(year) + "-" + PaddingLeft(Util.StringVal(month), "0", 2) + "-" + PaddingLeft(Util.StringVal(day), "0", 2) + "T" + PaddingLeft(Util.StringVal(hour), "0", 2) + ":" + PaddingLeft(Util.StringVal(minute), "0", 2) + ":" + PaddingLeft(Util.StringVal(second), "0", 2);
        }

        public static function FormatNumber(number:Number, decimals:int = 0, usethousandsep:Boolean = true):String
        {
            var t:String = null;
            var s:String = "";
            s = number.toFixed(decimals);
            if (s == "0.")
            {
                return "0";
            }
            s = s.split(",").join(Util.decimal_separator);
            s = s.split(".").join(Util.decimal_separator);
            if (usethousandsep)
            {
                do
                {
                    t = s;
                    s = s.replace(/(\d+)(\d\d\d)/g, "$1" + Util.thousand_separator + "$2");
                }
                while (s != t);

            }
            return s;
        }

        public static function IntToHex(d:uint, cnt:uint):String
        {
            var x:int = 0;
            var hextab:Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"];
            var res:String = "";
            var tmp:uint = d;
            while (cnt > 0)
            {
                x = tmp % 16;
                res = hextab[x] + res;
                tmp = Math.floor(tmp / 16);
                cnt--;
            }
            return res;
        }

        public static function HexToInt(h:String):uint
        {
            return parseInt("0x" + h);
        }

        public static function StringVal(str:*, defval:* = ""):*
        {
            if (str !== undefined && str != null)
            {
                return String(str);
            }
            if (typeof defval == "string")
            {
                return defval;
            }
            return "";
        }

        public static function NumberVal(num:*, defval:* = 0):*
        {
            var tmp:* = Number(num);
            if (!isNaN(tmp))
            {
                return tmp;
            }
            if (typeof defval == "number")
            {
                return Number(defval);
            }
            return 0;
        }

        public static function CountBits(num:uint):int
        {
            var result:int = 0;
            var i:* = 0;
            while (i <= 31)
            {
                if ((num & 1 << i) != 0)
                {
                    result++;
                }
                i++;
            }
            return result;
        }

        public static function PaddingLeft(str:String, pad:String, len:int):String
        {
            var tmp:String = str;
            while (tmp.length < len)
            {
                tmp = pad + tmp;
            }
            return tmp;
        }

        public static function PaddingRight(str:String, pad:String, len:int):String
        {
            var tmp:String = str;
            while (tmp.length < len)
            {
                tmp += pad;
            }
            return tmp;
        }

        public static function FormatRemaining(asecs:Number, separatedays:Boolean = true, separatedate:Boolean = false):String
        {
            var s:* = NumberVal(asecs);
            if (s < 0)
            {
                s = 0;
            }
            var days:* = Math.floor(s / (24 * 60 * 60));
            s %= 24 * 60 * 60;
            var hours:* = Math.floor(s / (60 * 60));
            s %= 60 * 60;
            var mins:* = Math.floor(s / 60);
            s %= 60;
            var secs:* = s;
            var res:* = "";
            if (days > 0)
            {
                res += days + " " + Lang.Get("days");
                if (separatedays)
                {
                    return res;
                }
                res += " ";
            }
            if (separatedate)
            {
                res = "";
            }
            if (hours > 0)
            {
                res += PaddingLeft(hours, "0", 2) + ":";
            }
            return res + (PaddingLeft(mins, "0", 2) + ":" + PaddingLeft(secs, "0", 2));
        }

        public static function FormatRemaining2(asecs:Number):String
        {
            var s:* = NumberVal(asecs);
            if (s < 0)
            {
                s = 0;
            }
            var mins:* = Math.floor(s / 60);
            s %= 60;
            var secs:* = s;
            return "" + (PaddingLeft(mins, "0", 2) + ":" + PaddingLeft(secs, "0", 2));
        }

        public static function XMLTagToObject(axml:XML):Object
        {
            var a:* = undefined;
            var c:* = undefined;
            var aname:String = null;
            var avalue:String = null;
            var cname:String = null;
            var cvalue:Object = null;
            if (axml == null)
            {
                return null;
            }
            var tag:Object = {};
            for each (a in axml.attributes())
            {
                aname = String(Util.StringVal(a.name()));
                avalue = String(Util.StringVal(a.valueOf()));
                tag[aname] = avalue;
            }
            for each (c in axml.children())
            {
                cname = String(Util.StringVal(c.name()));
                cvalue = Util.XMLTagToObject(c);
                if (typeof tag[cname] == "object")
                {
                    if (tag[cname] is Array)
                    {
                        tag[cname].push(cvalue);
                    }
                    else
                    {
                        tag[cname] = [tag[cname], cvalue];
                    }
                }
                else
                {
                    tag[cname] = cvalue;
                }
            }
            return tag;
        }

        public static function ShuffleArray(arr:Array):Array
        {
            return arr.sort(function(a:*, b:*):*
                {
                    return Math.floor(Math.random() * 3) - 1;
                });
        }

        public static function ParseJsVar(text:String):Object
        {
            var at:int = 0;
            var ch:String = null;
            var error_occured:Boolean = false;
            var error:Function = function(m:*):*
            {
                trace("ParseJsObjectError: " + m);
                error_occured = true;
            };
            var next:Function = function():*
            {
                ch = text.charAt(at);
                at += 1;
                return ch;
            };
            var white:Function = function():*
            {
                while (!error_occured && ch != null)
                {
                    if (ch > " ")
                    {
                        break;
                    }
                    next();
                }
            };
            var str:Function = function():*
            {
                var i:* = undefined;
                var t:* = undefined;
                var u:* = undefined;
                var s:* = "";
                var outer:* = false;
                if (ch == "\"")
                {
                    while (!error_occured && next() != null)
                    {
                        if (ch == "\"")
                        {
                            next();
                            return s;
                        }
                        if (ch != "\\")
                        {
                            s += ch;
                            continue;
                        }
                        next();
                        switch (ch)
                        {
                            case "b":
                                s += "\b";
                                break;
                            case "f":
                                s += "\f";
                                break;
                            case "n":
                                s += "\n";
                                break;
                            case "r":
                                s += "\r";
                                break;
                            case "t":
                                s += "\t";
                                break;
                            case "u":
                                u = 0;
                                i = 0;
                                while (i < 4)
                                {
                                    t = parseInt(next(), 16);
                                    if (!isFinite(t))
                                    {
                                        outer = true;
                                        break;
                                    }
                                    u = u * 16 + t;
                                    i += 1;
                                }
                                if (outer)
                                {
                                    outer = false;
                                }
                                else
                                {
                                    s += String.fromCharCode(u);
                                }
                                break;
                            default:
                                s += ch;
                                break;
                        }
                    }
                }
                error("Bad string");
            };
            var identifier:Function = function():*
            {
                var s:* = "";
                while (ch != null && "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890_".indexOf(ch) >= 0)
                {
                    s += ch;
                    next();
                }
                return s;
            };
            var arr:Function = function():*
            {
                var a:* = [];
                if (ch == "[")
                {
                    next();
                    white();
                    if (ch == "]")
                    {
                        next();
                        return a;
                    }
                    while (!error_occured && ch != null)
                    {
                        a.push(value());
                        white();
                        if (ch == "]")
                        {
                            next();
                            return a;
                        }
                        if (ch != ",")
                        {
                            break;
                        }
                        next();
                        white();
                    }
                }
                error("Bad array");
            };
            var obj:Function = function():*
            {
                var k:* = undefined;
                var o:* = {};
                if (ch == "{")
                {
                    next();
                    white();
                    if (ch == "}")
                    {
                        next();
                        return o;
                    }
                    while (!error_occured && ch != null)
                    {
                        k = identifier();
                        white();
                        if (ch != ":")
                        {
                            break;
                        }
                        next();
                        o[k] = value();
                        white();
                        if (ch == "}")
                        {
                            next();
                            return o;
                        }
                        if (ch != ",")
                        {
                            break;
                        }
                        next();
                        white();
                    }
                }
                error("Bad object");
            };
            var num:Function = function():*
            {
                var v:* = undefined;
                var n:* = "";
                if (ch == "-")
                {
                    n = "-";
                    next();
                }
                while (!error_occured && ch >= "0" && ch <= "9")
                {
                    n += ch;
                    next();
                }
                if (ch == ".")
                {
                    n += ".";
                    next();
                    while (!error_occured && ch >= "0" && ch <= "9")
                    {
                        n += ch;
                        next();
                    }
                }
                if (ch == "e" || ch == "E")
                {
                    n += ch;
                    next();
                    if (ch == "-" || ch == "+")
                    {
                        n += ch;
                        next();
                    }
                    while (!error_occured && ch >= "0" && ch <= "9")
                    {
                        n += ch;
                        next();
                    }
                }
                v = Number(n);
                if (!isFinite(v))
                {
                    error("Bad number");
                }
                return v;
            };
            var word:Function = function():*
            {
                switch (ch)
                {
                    case "t":
                        if (next() == "r" && next() == "u" && next() == "e")
                        {
                            next();
                            return true;
                        }
                        break;
                    case "f":
                        if (next() == "a" && next() == "l" && next() == "s" && next() == "e")
                        {
                            next();
                            return false;
                        }
                        break;
                    case "n":
                        if (next() == "u" && next() == "l" && next() == "l")
                        {
                            next();
                            return null;
                        }
                        break;
                }
                error("Syntax error");
            };
            var value:Function = function():*
            {
                white();
                switch (ch)
                {
                    case "{":
                        return obj();
                    case "[":
                        return arr();
                    case "\"":
                        return str();
                    case "-":
                        return num();
                    default:
                        return ch >= "0" && ch <= "9" ? num() : word();
                }
            };
            at = 0;
            ch = " ";
            error_occured = false;
            text = String(Util.StringVal(text, "{}"));
            var r:* = value();
            if (!error_occured)
            {
                return r;
            }
            return null;
        }

        public static function Random(max:int = 999999999, min:int = 0):int
        {
            return Math.floor(Math.random() * (max - min + 1)) + min;
        }

        public static function IdFromStringEnd(s:String):int
        {
            return Util.NumberVal(s.replace(/.*?([0-9]+)$/, "$1"));
        }

        public static function CleanupChatMessage(amsg:String):String
        {
            return Util.StrTrim(Util.StrXmlSafe(Util.StringVal(amsg)));
        }

        public static function MovName(amov:DisplayObject):String
        {
            var s:String = amov.name;
            if (s != null && s.indexOf("instance") === 0)
            {
                s = getQualifiedClassName(amov);
                if (s != null)
                {
                    s = s.substr(s.indexOf("::") + 2);
                }
            }
            return s;
        }

        public static function FindTweenedObject(doc:DisplayObjectContainer, tween:TweenMax):DisplayObject
        {
            var child:DisplayObject = null;
            var tweens:* = undefined;
            var t:* = undefined;
            var o:* = undefined;
            var o2:* = null;
            var cidx:int = 0;
            while (cidx < doc.numChildren)
            {
                child = doc.getChildAt(cidx);
                if (child)
                {
                    if (TweenMax.isTweening(child))
                    {
                        tweens = TweenMax.getTweensOf(child);
                        for each (t in tweens)
                        {
                            if (t == tween)
                            {
                                return child;
                            }
                        }
                    }
                    if (child is DisplayObjectContainer)
                    {
                        o = FindTweenedObject(child as DisplayObjectContainer, tween);
                        if (o)
                        {
                            o2 = o;
                        }
                    }
                }
                cidx++;
            }
            return o2;
        }

        public static function MovPathName(amov:DisplayObject):String
        {
            var s:String = String(Util.MovName(amov));
            var p:* = amov.parent;
            while (p != null && p !== undefined)
            {
                if (p == p.root)
                {
                    s = "." + s;
                    break;
                }
                s = Util.MovName(p) + "." + s;
                p = p.parent;
            }
            return s;
        }

        public static function ObjByPath(path:String, obj:*):Object
        {
            var n:* = path.indexOf(".");
            var p:* = path.substr(0, n);
            if (n == -1)
            {
                return obj[path];
            }
            return ObjByPath(path.substr(n + 1), obj[p]);
        }

        public static function ExtraRequest(url:String):*
        {
            var req:URLRequest = new URLRequest(url);
            var ldr:URLLoader = new URLLoader();
            ldr.addEventListener(Event.COMPLETE, function(e:*):*
                {
                });
            ldr.addEventListener(IOErrorEvent.IO_ERROR, function(e:*):*
                {
                    e.preventDefault();
                });
            ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:*):*
                {
                    e.preventDefault();
                });
            ldr.load(req);
            return ldr;
        }

        public static function GetShot(dobj:DisplayObject):Object
        {
            var bounds:Rectangle = dobj.getBounds(dobj);
            var matrix:Matrix = dobj.transform.matrix;
            var bitmap:BitmapData = new BitmapData(Math.round(bounds.width * matrix.a), Math.round(bounds.height * matrix.d), true, 0);
            bitmap.draw(dobj, new Matrix(matrix.a, matrix.b, matrix.c, matrix.d, -bounds.x * matrix.a, -bounds.y * matrix.d), null, null, null, true);
            var pt:Object = Util.LocalToGlobal(dobj);
            var result:Object = new Object();
            result.scaleX = matrix.a;
            result.scaleY = matrix.d;
            result.x = pt.x + bounds.x * matrix.a;
            result.y = pt.y + bounds.y * matrix.d;
            result.w = pt.w;
            result.h = pt.h;
            result.b = bitmap;
            return result;
        }

        public static function BreakUp(width:int, height:int, space:int, dobj:DisplayObject):Array
        {
            var y:int = 0;
            var dst:BitmapData = null;
            var cx:int = 0;
            var cy:int = 0;
            var px:uint = 0;
            var res:Array = new Array();
            var obj:Object = Util.GetShot(dobj);
            var x:int = 0;
            while (x < obj.w)
            {
                y = 0;
                while (y < obj.h)
                {
                    dst = new BitmapData(width, height, true, 0);
                    cx = 0;
                    while (cx < width)
                    {
                        cy = 0;
                        while (cy < height)
                        {
                            px = uint(obj.b.getPixel32(x + cx, y + cy));
                            dst.setPixel32(cx, cy, px);
                            cy++;
                        }
                        cx++;
                    }
                    res.push({
                                "x": x,
                                "y": y,
                                "w": width,
                                "h": height,
                                "dx": obj.x,
                                "dy": obj.y,
                                "b": dst
                            });
                    y += height + space;
                }
                x += width + space;
            }
            return res;
        }

        public static function StrTrim(s:String):String
        {
            return s.replace(/^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2");
        }

        public static function StrXmlSafe(s:String):String
        {
            trace("StrXmlSafe s: " + s);
            if (s == null)
            {
                s = "";
            }
            trace(s.charCodeAt(0));
            var c:String = null;
            var res:* = "";
            var i:int = 0;
            while (i < s.length)
            {
                if (s.charCodeAt(i) >= 32)
                {
                    c = s.charAt(i);
                    if (c == "\"")
                    {
                        res += "&quot;";
                    }
                    else if (c == "'")
                    {
                        res += "&apos;";
                    }
                    else if (c == "&")
                    {
                        res += "&amp;";
                    }
                    else if (c == "<")
                    {
                        res += "&lt;";
                    }
                    else if (c == ">")
                    {
                        res += "&gt;";
                    }
                    else
                    {
                        res += c;
                    }
                }
                i++;
            }
            return res;
        }

        public static function OnCheckBoxClicked(e:*):*
        {
            e.currentTarget.CHECK.visible = !e.currentTarget.CHECK.visible;
        }

        public static function CopyFilters(obj:DisplayObject):Array
        {
            var res:Array = new Array();
            var i:int = 0;
            while (i < obj.filters.length)
            {
                res.push(obj.filters[i].clone());
                i++;
            }
            return res;
        }

        public static function UpperCase(str:String):String
        {
            var val:Number = NaN;
            var res:String = "";
            var i:* = 0;
            while (i < str.length)
            {
                val = Number(str.charCodeAt(i));
                if (val == 73 || val == 105 || val == 304 || val == 305)
                {
                    res += String.fromCharCode(105);
                }
                else
                {
                    res += String.fromCharCode(val).toUpperCase();
                }
                i++;
            }
            return res;
        }

        public static function NewPostId(userid:String):String
        {
            var u:String = Number(userid).toString(16);
            var d:String = Math.round(new Date().getTime() / 1000).toString(16);
            u = u.split("").reverse().join("").substring(0, 8);
            d = d.split("").reverse().join("").substring(0, 8);
            var k:* = u + d;
            while (k.length < 16)
            {
                k += "F";
            }
            return k;
        }

        public static function InitArabicUtils():*
        {
            var Fontclass:Class = null;
            var f:Font = null;
            if (Util.stringutils == null)
            {
                Util.stringutils = new StringUtils();
                Util.stringutils.wrapFactor = 0.98;
                Util.stringutils.hindiNumeralsOnly = false;
                Util.stringutils.americanFormat = false;
                Fontclass = Modules.GetClass("fonts", "aarabicafontbold");
                f = null;
                if (Fontclass)
                {
                    f = new Fontclass();
                }
                Util.textformat = new TextFormat();
                if (f)
                {
                    Util.textformat.font = f.fontName;
                }
                Util.textformat.bold = true;
                Util.textformat.rightMargin = 4;
            }
        }

        public static function LoadArabicText(tf:TextField, str:String, keeplayout:Boolean = false):void
        {
            var fmt:* = undefined;
            InitArabicUtils();
            Util.textformat.size = Math.round(Util.NumberVal(tf.defaultTextFormat.size) * 1);
            Util.textformat.color = tf.defaultTextFormat.color;
            var oldleading:* = Number(tf.defaultTextFormat.leading);
            Util.textformat.leading = oldleading;
            Util.textformat.align = tf.defaultTextFormat.align;
            if (!keeplayout)
            {
                if (tf.defaultTextFormat.align == "left")
                {
                    Util.textformat.align = "right";
                }
                else if (tf.defaultTextFormat.align == "right")
                {
                    Util.textformat.align = "left";
                }
            }
            var to:Object = tf as Object;
            if (!to.hasOwnProperty("origY"))
            {
            }
            tf.htmlText = Util.stringutils.parseArabic(str, tf, Util.textformat);
            if (oldleading != tf.defaultTextFormat.leading)
            {
                fmt = new TextFormat();
                fmt.leading = oldleading;
                tf.defaultTextFormat = fmt;
            }
        }

        public static function SetText(tf:TextField, str:String, keeplayout:Boolean = false):void
        {
            if (Config.rtl)
            {
                Util.LoadArabicText(tf, str, keeplayout);
            }
            else
            {
                tf.text = str;
            }
        }

        public static function FormatArabicText(str:String, tf:TextField):*
        {
            InitArabicUtils();
            Util.textformat.size = tf.defaultTextFormat.size;
            Util.textformat.color = tf.defaultTextFormat.color;
            Util.textformat.leading = tf.defaultTextFormat.leading;
            Util.textformat.align = tf.defaultTextFormat.align;
            return Util.stringutils.parseArabic(str, tf, Util.textformat);
        }

        public static function RTLSwap(id:String, obj1:DisplayObject, obj2:DisplayObject, keeplayout:Boolean = false):*
        {
            var o1shift:* = undefined;
            var o2shift:* = undefined;
            var fmt:* = undefined;
            var gap:* = undefined;
            var tf:TextField = null;
            if (!Config.rtl)
            {
                return;
            }
            if (obj1 == null || obj2 == null)
            {
                return;
            }
            var o1b:* = obj1.getBounds(obj1.parent);
            var o2b:* = obj2.getBounds(obj1.parent);
            var so:* = rtlswaps[id];
            if (so === undefined || so.origx1 == obj1.x)
            {
                so = {
                        "origx1": obj1.x,
                        "origx2": obj2.x
                    };
                rtlswaps[id] = so;
                o1shift = obj1.x - o1b.x;
                o2shift = obj2.x - o2b.x;
                if (o2b.x > o1b.x)
                {
                    gap = o2b.x - (o1b.x + o1b.width);
                    obj2.x = o1b.x + o2shift;
                    obj1.x = o1b.x + o2b.width + gap + o1shift;
                    if (!keeplayout && obj2 is TextField)
                    {
                        tf = TextField(obj2);
                        if (tf.defaultTextFormat.align == "left")
                        {
                            fmt = new TextFormat();
                            fmt.align = "right";
                            tf.defaultTextFormat = fmt;
                        }
                        else if (tf.defaultTextFormat.align == "right")
                        {
                            fmt = new TextFormat();
                            fmt.align = "left";
                            tf.defaultTextFormat = fmt;
                        }
                    }
                }
                else
                {
                    gap = o1b.x - (o2b.x + o2b.width);
                    obj1.x = o2b.x + o1shift;
                    obj2.x = o2b.x + o1b.width + gap + o2shift;
                }
            }
        }

        public static function RTLEditSetup(tf:TextField):void
        {
            Imitation.RTLEditSetup(tf);
        }

        public static function GetRTLEditText(tf:TextField):String
        {
            if (!Config.rtl)
            {
                return tf.text;
            }
            return Imitation.GetRTLEditText(tf);
        }

        public static function UpdateRTLEdit(eo:*):*
        {
            var fmt:* = undefined;
            var tf:* = eo.tfobj;
            LoadArabicText(tf, eo.realtext, true);
            if (tf.defaultTextFormat.align != "right")
            {
                fmt = new TextFormat();
                fmt.align = "right";
                tf.defaultTextFormat = fmt;
            }
            var nl:* = tf.numLines - 1;
            var pos:* = 0;
            if (Boolean(tf.multiline) && nl > 0)
            {
                while (nl > 0 && tf.getLineLength(nl) < 1)
                {
                    nl--;
                }
                pos = tf.getLineOffset(nl);
            }
            tf.setSelection(pos, pos);
        }

        public static function SetRTLEditText(tf:TextField, value:String):*
        {
            Imitation.SetRTLEditText(tf, value);
        }

        public static function OnRTLEditChange(e:*):*
        {
            var tf:TextField = e.currentTarget;
            var id:* = Util.MovPathName(tf);
            var eo:* = rtledits[id];
            if (eo === undefined)
            {
                return;
            }
            UpdateRTLEdit(eo);
        }

        public static function OnRTLEditTextInput(e:*):*
        {
            var tf:TextField = e.currentTarget;
            var id:* = Util.MovPathName(tf);
            var eo:* = rtledits[id];
            if (eo === undefined)
            {
                return;
            }
            if (tf.maxChars > 0 && eo.realtext.length >= tf.maxChars)
            {
                return;
            }
            eo.realtext += e.text;
            UpdateRTLEdit(eo);
        }

        public static function OnRTLEditKeyDown(e:*):*
        {
            var tf:TextField = e.currentTarget;
            var id:* = Util.MovPathName(tf);
            var eo:* = rtledits[id];
            if (eo === undefined)
            {
                return;
            }
            if (e.keyCode == 8)
            {
                eo.realtext = eo.realtext.substr(0, eo.realtext.length - 1);
                UpdateRTLEdit(eo);
            }
        }

        public static function OnRTLEditKeyUp(e:*):*
        {
            var tf:TextField = e.currentTarget;
            tf.setSelection(0, 0);
        }

        public static function OnRTLEditClick(e:*):*
        {
            var tf:TextField = e.currentTarget;
            tf.setSelection(0, 0);
        }

        public static function FormatGetParams(obj:Object, addrnd:Boolean = false):String
        {
            var name:String = null;
            var value:String = null;
            if (obj == null)
            {
                obj = new Object();
            }
            if (addrnd)
            {
                obj.rnd = Util.Random();
            }
            var params:Array = new Array();
            for (name in obj)
            {
                value = String(Util.StringVal(obj[name]));
                params.push(escapeMultiByte(name) + "=" + escapeMultiByte(value));
            }
            if (params.length > 0)
            {
                return params.join("&");
            }
            return "";
        }

        public static function GetFrameNum(aobj:MovieClip, frame:Object):uint
        {
            var fname:String = null;
            var labels:Array = null;
            var i:uint = 0;
            var label:FrameLabel = null;
            var frameno:uint = 0;
            if (typeof frame == "number")
            {
                frameno = Number(frame);
            }
            else
            {
                if (typeof frame != "string")
                {
                    return 0;
                }
                fname = String(frame);
                labels = aobj.currentLabels;
                i = 0;
                while (i < labels.length)
                {
                    label = labels[i];
                    if (label.name == fname)
                    {
                        frameno = Number(label.frame);
                        break;
                    }
                    i++;
                }
            }
            return frameno;
        }

        public static function ExternalCall(funcName:String, ...aargs):*
        {
            var args:Array = null;
            var res:* = null;
            if (!Config.inbrowser)
            {
                trace("ExternalCall: ", funcName, ADOBEJSON.stringify(aargs.concat()));
            }
            else if (ExternalInterface.available)
            {
                args = aargs.concat();
                args.unshift(funcName);
                res = ExternalInterface.call.apply(null, args);
            }
            else
            {
                DBG.Trace("ExternalCall unavailable");
            }
            return res;
        }

        public static function FormatTrace(obj:*, prefix:String = "", postfix:String = ""):String
        {
            var idx:int = 0;
            var name:String = null;
            var type:* = typeof obj;
            var res:String = "";
            if (type == "object")
            {
                if (obj is Array)
                {
                    res += (prefix.length > 0 ? "\n" : "") + prefix + "[\n";
                    idx = 0;
                    while (idx < obj.length)
                    {
                        res += prefix + "  " + FormatTrace(obj[idx], prefix + "  ", ",");
                        idx++;
                    }
                    res += prefix + "]" + postfix;
                }
                else
                {
                    res += (prefix.length > 0 ? "\n" : "") + prefix + "{\n";
                    for (name in obj)
                    {
                        res += prefix + "  " + name + ":" + FormatTrace(obj[name], prefix + "  ", ",");
                    }
                    res += prefix + "}" + postfix;
                }
            }
            else if (type == "string")
            {
                res += "\"" + obj + "\"" + postfix;
            }
            else if (type == "number")
            {
                res += String(obj) + postfix;
            }
            else if (type == "boolean")
            {
                res += (!!obj ? "true" : "false") + postfix;
            }
            return res + "\n";
        }

        public static function CalcDelay(afromtime:int):Number
        {
            return (getTimer() - afromtime) / 1000;
        }

        public static function Sleep(ms:int):void
        {
            var init:int = getTimer();
            while (getTimer() - init < ms)
            {
            }
        }

        public static function Trim(s:String):String
        {
            return s.replace(/^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2");
        }

        public static function Trace(...rest):void
        {
            var traceText:String = rest.join(" ") + " ";
            var filter:String;

            // Check if there is a trace filter
            if (traceFilter.length)
            {
                for each (filter in traceFilter)
                {
                    // Compare the start of the message with the filter
                    if (String(rest[0]).substr(0, filter.length) == filter)
                    {
                        if (traceOutput != null)
                        {
                            traceOutput.appendText("\r" + traceText);
                        }
                        trace(traceText);
                        break;
                    }
                }
            }
            else
            {
                // No filter, output directly
                if (traceOutput != null)
                {
                    traceOutput.appendText("\r" + traceText);
                }
                trace(traceText);
            }
        }

        public static function RenderText(textfield:TextField):Bitmap
        {
            var bm:Bitmap = new Bitmap(null, "auto", true);
            bm.bitmapData = new BitmapData(textfield.width + 20, textfield.height, true, 0);
            bm.bitmapData.draw(textfield);
            bm.x = textfield.x - 10;
            bm.y = textfield.y;
            return bm;
        }

        public static function SwapTextToBitmap(textfield:TextField):void
        {
            if (textfield.visible)
            {
                textfield.parent.addChild(Util.RenderText(textfield));
            }
            textfield.visible = false;
        }

        public static function GetPlayerVersion():Number
        {
            var versionNumber:String = Capabilities.version;
            var versionArray:Array = versionNumber.split(",");
            var platformAndVersion:Array = versionArray[0].split(" ");
            var majorVersion:int = int(parseInt(platformAndVersion[1]));
            var minorVersion:int = int(parseInt(versionArray[1]));
            return Number(majorVersion + "." + minorVersion);
        }

        public static function AutoAlignText(amov:MovieClip, txt:String):void
        {
            var height:Number = amov.height;
            var format:TextFormat = amov.CAPTION.defaultTextFormat;
            var size:Number = 12;
            while (size < 50)
            {
                format.size = size + 2;
                amov.CAPTION.defaultTextFormat = format;
                Util.SetText(amov.CAPTION, txt);
                if (amov.CAPTION.textHeight > height)
                {
                    break;
                }
                size += 2;
            }
            format.size = size;
            amov.CAPTION.defaultTextFormat = format;
            Util.SetText(amov.CAPTION, txt);
            amov.CAPTION.y = (height - amov.CAPTION.textHeight) / 2;
        }

        public static function RemoveInvisibleChars(astr:String):String
        {
            return astr.replace(/–/g, "-");
        }

        public static function DrawRectangleWithoutLine(_color:uint, _alpha:Number, _x:Number, _y:Number, _width:Number, _height:Number):Shape
        {
            var shape:Shape = new Shape();
            shape.graphics.lineStyle();
            shape.graphics.beginFill(_color, _alpha);
            shape.graphics.drawRect(_x, _y, _width, _height);
            shape.graphics.endFill();
            return shape;
        }

        public static function FormatLocalDate(adate:*):*
        {
            var d:* = undefined;
            var num:* = NumberVal(adate);
            if (adate is Date)
            {
                d = adate;
            }
            else
            {
                if (num <= 946681200)
                {
                    return "";
                }
                d = new Date();
                if (num > 2051218800)
                {
                    d.setTime(num);
                }
                else
                {
                    d.setTime(num * 1000);
                }
            }
            var s:* = Lang.get ("date_format");
            s = s.replace("yyyy", d.getFullYear());
            s = s.replace("mm", PaddingLeft(d.getMonth() + 1, "0", 2));
            return s.replace("dd", PaddingLeft(d.getDate(), "0", 2));
        }

        public static function FormatDate(_date:String):String
        {
            if (!_date)
            {
                return "";
            }
            var s:String = "";
            var arr:Array = _date.split("-");
            if (Config.siteid == "hu")
            {
                s = String(arr[0]).substr(2, 4) + ". " + arr[1] + ". " + arr[2];
            }
            else if (Config.siteid == "us")
            {
                s = arr[1] + "/" + arr[2] + "/" + String(arr[0]).substr(2, 4);
            }
            else
            {
                s = arr[2] + "/" + arr[1] + "/" + String(arr[0]).substr(2, 4);
            }
            return s;
        }

        public static function DegreesToRadians(_degrees:Number):Number
        {
            return _degrees * Math.PI / 180;
        }

        public static function RadiansToDegrees(_radians:Number):Number
        {
            return _radians * 180 / Math.PI;
        }

        public static function RoundDecimalPlace(_n:Number, _decimals:int):Number
        {
            var pow:int = Math.pow(10, _decimals);
            return Math.round(_n * pow) / pow;
        }

        public static function TileImage(imageArea:DisplayObject, tileX:int = 512, tileY:int = 512):MovieClip
        {
            var n:int = 0;
            var tempData:BitmapData = null;
            var tempRect:* = undefined;
            var k:int = 0;
            var bitmap:Bitmap = null;
            var tile:MovieClip = new MovieClip();
            var mainImage:BitmapData = new BitmapData(imageArea.width, imageArea.height, false);
            var bitmapArray:Array = new Array();
            var tilesH:int = Math.ceil(mainImage.width / tileX);
            var tilesV:int = Math.ceil(mainImage.height / tileY);
            mainImage.draw(imageArea);
            var i:int = 0;
            while (i < tilesH)
            {
                bitmapArray[i] = new Array();
                n = 0;
                while (n < tilesV)
                {
                    tempData = new BitmapData(tileX + 2, tileY + 2, false);
                    tempRect = new Rectangle(tileX * i, tileY * n, tileX + 2, tileY + 2);
                    tempData.copyPixels(mainImage, tempRect, new Point(0, 0));
                    bitmapArray[i][n] = tempData;
                    n++;
                }
                i++;
            }
            var j:int = 0;
            while (j < bitmapArray.length)
            {
                k = 0;
                while (k < bitmapArray[j].length)
                {
                    bitmap = new Bitmap(bitmapArray[j][k]);
                    tile.addChild(bitmap);
                    bitmap.x = j * tileX;
                    bitmap.y = k * tileY;
                    k++;
                }
                j++;
            }
            return tile;
        }

        public static function ShowChildrenOnScreen(obj:MovieClip):void
        {
            var o:Object = null;
            var m:DisplayObject = null;
            var rect:Rectangle = null;
            if (!obj)
            {
                return;
            }
            var stageRect:Rectangle = new Rectangle(0, 0, Imitation.stage.stageWidth, Imitation.stage.stageHeight);
            var stageRectForEnv:Rectangle = new Rectangle(-100, -100, Imitation.stage.stageWidth + 200, Imitation.stage.stageHeight + 200);
            var i:int = 0;
            while (i < obj.numChildren)
            {
                m = obj.getChildAt(i);
                if (m.name.indexOf("environment_") > -1)
                {
                    m.visible = false;
                    o = Util.LocalToGlobal(m);
                    if (stageRectForEnv.contains(o.x, o.y))
                    {
                        m.visible = true;
                    }
                }
                else
                {
                    rect = m.getRect(Imitation.stage);
                    m.visible = stageRect.intersects(rect);
                }
                i++;
            }
        }

        public static function SendProstatData(_cmd:String):void
        {
            var prostatid:Number = Number(Util.NumberVal(Config.flashvars.prostatid));
            if (prostatid > 0)
            {
                trace("Sending prostat");
                Util.ExtraRequest("prostat_v11.php?cmd=" + _cmd + "&psid=" + prostatid);
            }
        }

        public static function SwapSkin(_src:*, _targetSwf:String, _targetClass:String):*
        {
            var sclass:* = undefined;
            var smc:* = undefined;
            if (Config.skin == "none")
            {
                return _src;
            }
            if (_src.hasOwnProperty("skinReady"))
            {
                return _src;
            }
            try
            {
                sclass = Modules.GetClass(_targetSwf, _targetClass);
            }
            catch (e:Error)
            {
                return _src;
            }
            smc = new sclass();
            smc.x = _src.x;
            smc.y = _src.y;
            smc.width = _src.width;
            smc.height = _src.height;
            if (_src.hasOwnProperty("rotation"))
            {
                smc.rotation = _src.rotation;
            }
            smc.name = _src.name;
            smc.cacheAsBitmap = _src.cacheAsBitmap;
            smc.skinReady = true;
            _src.parent.addChildAt(smc, _src.parent.getChildIndex(_src));
            _src.parent.removeChild(_src);
            _src = null;
            return MovieClip(smc);
        }

        public static function SwapTextcolor(_tf:TextField, _color:String, _targetSwf:String):void
        {
            if (Config.skin == "none")
            {
                return;
            }
            var c:* = Modules.GetModuleMC(_targetSwf)[_color];
            _tf.textColor = c;
        }

        public static function CountEventListeners():int
        {
            var o:* = undefined;
            var s:* = undefined;
            var f:* = undefined;
            var o2:* = undefined;
            var c:int = 0;
            for (o in dic)
            {
                for (s in dic[o])
                {
                    for (f in dic[o][s])
                    {
                        if (trace_event_listeners)
                        {
                            o2 = o;
                            if (o is TweenMax)
                            {
                                o2 = FindTweenedObject(Imitation.rootmc, o);
                            }
                            trace(o, o2 is DisplayObject ? Util.MovPathName(o2 as DisplayObject) : "", s, dic[o][s][f]);
                        }
                        c++;
                        dic[o][s][f] = 0;
                    }
                }
            }
            trace_event_listeners = false;
            return c;
        }

        public static function AddEventListener(o:Object, s:String, f:Function, c:Boolean = false, p:int = 0, w:Boolean = false):void
        {
            var weakref:Dictionary = null;
            if (debug_listeners)
            {
                if (!dic[o])
                {
                    dic[o] = {};
                }
                if (!dic[o][s])
                {
                    dic[o][s] = new Dictionary(true);
                }
                weakref = new Dictionary(true);
                weakref[f] = true;
                if (!aliasfunc[f])
                {
                    aliasfunc[f] = function(e:*):*
                    {
                        var wf:* = undefined;
                        var dip:* = undefined;
                        for (wf in weakref)
                        {
                            dip = Modules.GetClass("uibase", "uibase.DebugInfo");
                            if (dip && Boolean(dip.mc) && Boolean(dip.mc.visible))
                            {
                            }
                            ++dispatch_count;
                            ++dic[o][s][wf];
                        }
                    };
                }
                dic[o][s][f] = 0;
                o.addEventListener(s, aliasfunc[f], c, p, w);
            }
            o.addEventListener(s, f, c, p, w);
        }

        public static function RemoveEventListener(o:Object, s:String, f:Function, c:Boolean = false):void
        {
            if (debug_listeners)
            {
                if (Boolean(dic[o]) && Boolean(dic[o][s]))
                {
                    delete dic[o][s][f];
                }
                if (aliasfunc[f])
                {
                    o.removeEventListener(s, aliasfunc[f], c);
                }
            }
            o.removeEventListener(s, f, c);
        }

        public static function VerticalSliceImage(owner:MovieClip, obj:*, positions:Array, shadow:int = 2):Array
        {
            var tempData:BitmapData = null;
            var tempRect:* = undefined;
            var bitmap:Bitmap = null;
            var mainImage:BitmapData = new BitmapData(obj.width + shadow, obj.height + shadow, true, 0);
            var bitmapArray:Array = new Array();
            var bounds:* = obj.getBounds(obj);
            mainImage.draw(obj, new Matrix(1, 0, 0, 1, int(-bounds.left), -bounds.top));
            var py:int = 0;
            positions.push(obj.height);
            var i:int = 0;
            while (i < positions.length)
            {
                tempData = new BitmapData(obj.width, positions[i] - py + (i == positions.length - 1 ? shadow : 0), true, 0);
                tempRect = new Rectangle(0, py, obj.width, positions[i] - py + (i == positions.length - 1 ? shadow : 0));
                tempData.copyPixels(mainImage, tempRect, new Point(0, 0));
                bitmap = new Bitmap(tempData);
                bitmapArray[i] = bitmap;
                owner.addChild(bitmap);
                bitmap.x = int(bounds.left) - 1;
                bitmap.y = bounds.top + py - 1;
                py = int(positions[i]);
                i++;
            }
            obj.visible = false;
            return bitmapArray;
        }

        public function Util()
        {
            super();
        }
    }
}
