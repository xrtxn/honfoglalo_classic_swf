package syscode
{
    import com.adobe.serialization.json.ADOBEJSON;

    import flash.text.*;

    public class Lang
    {
        public static var data:Object = {};

        public static var todo:Array = [];

        public static var init:Boolean = false;

        public static function Get(alangid:String, apar1:* = undefined, apar2:* = undefined, apar3:* = undefined, apar4:* = undefined):String
        {
            var lidarr:Array = null;
            var langid:String = null;
            var toadd:String = "";
            var s:String = "";
            var firstchar:String = alangid.substr(0, 1);
            if (firstchar != "@" && firstchar != "^")
            {
                lidarr = alangid.split("+");
                langid = String(lidarr[0]);
                if (lidarr.length > 1)
                {
                    toadd = String(lidarr[1]);
                }
                s = String(Lang.data[langid]);
                if (s == null || s.length < 1)
                {
                    return "(\"" + langid + "\")";
                }
            }
            else
            {
                s = alangid;
                if (firstchar == "^")
                {
                    s = s.substr(1);
                }
            }
            if (apar1 !== undefined)
            {
                s = String(Lang.ReplaceStr(s, "$1", apar1));
            }
            if (apar2 !== undefined)
            {
                s = String(Lang.ReplaceStr(s, "$2", apar2));
            }
            if (apar3 !== undefined)
            {
                s = String(Lang.ReplaceStr(s, "$3", apar3));
            }
            if (apar4 !== undefined)
            {
                s = String(Lang.ReplaceStr(s, "$4", apar4));
            }
            return s + toadd;
        }

        public static function get (langid:String, apar1:* = undefined, apar2:* = undefined, apar3:* = undefined, apar4:* = undefined):String
        {
            return Lang.Get(langid, apar1, apar2, apar3, apar4);
        }

        public static function Set(tf:TextField, langid:String, apar1:* = undefined, apar2:* = undefined, apar3:* = undefined, apar4:* = undefined):void
        {
            Lang.SetLang(tf, langid, apar1, apar2, apar3, apar4);
        }

        public static function SetLang(tf:TextField, langid:String, apar1:* = undefined, apar2:* = undefined, apar3:* = undefined, apar4:* = undefined):void
        {
            var str:String = null;
            if (!Config.releaseversion)
            {
                if (Lang.init)
                {
                    str = String(Lang.Get(langid, apar1, apar2, apar3, apar4));
                    Util.SetText(tf, str);
                }
                else
                {
                    tf.text = "";
                    todo.push({
                                "tf": tf,
                                "langid": langid,
                                "apar1": apar1,
                                "apar2": apar2,
                                "apar3": apar3,
                                "apar4": apar4
                            });
                }
                return;
            }
            try
            {
                if (Lang.init)
                {
                    str = String(Lang.Get(langid, apar1, apar2, apar3, apar4));
                    Util.SetText(tf, str);
                }
                else
                {
                    tf.text = "";
                    todo.push({
                                "tf": tf,
                                "langid": langid,
                                "apar1": apar1,
                                "apar2": apar2,
                                "apar3": apar3,
                                "apar4": apar4
                            });
                }
            }
            catch (err:Error)
            {
                DBG.Trace("Lang.SetLang", err);
            }
        }

        public static function ProcessTodoList():void
        {
            var tmp:Object = null;
            var str:String = null;
            while (Lang.todo.length > 0)
            {
                tmp = Lang.todo.pop();
                str = String(Lang.Get(tmp.langid, tmp.apar1, tmp.apar2, tmp.apar3, tmp.apar4));
                try
                {
                    Util.SetText(tmp.tf, str);
                }
                catch (err:Error)
                {
                    trace("Lang.ProcessTodoList ERROR:" + err.toString());
                }
            }
        }

        public static function LoadLangData(aurl:String, aoncompletefunc:Function):*
        {
            var LangDataLoaded:Function = null;
            LangDataLoaded = function(data:String):*
            {
                try
                {
                    Lang.init = true;
                    Lang.data = ADOBEJSON.decode(data);
                    Lang.ProcessTodoList();
                    if (aoncompletefunc != null)
                    {
                        aoncompletefunc(true);
                    }
                }
                catch (err:Error)
                {
                    trace("Lang.LoadLangData ERROR:" + err.toString() + ", st:" + err.getStackTrace());
                    if (aoncompletefunc != null)
                    {
                        aoncompletefunc(false);
                    }
                }
            };
            DBG.Trace("Lang.LoadLangData:" + aurl);
            MyLoader.LoadText(aurl, LangDataLoaded);
        }

        public static function ReplaceStr(astr:String, afrom:String, ato:String):String
        {
            return astr.split(afrom).join(ato);
        }

        public static function fn_sysmsg(code:int):String
        {
            if (code == 0)
            {
                return "";
            }
            if (Lang.data["gs_error_" + code] !== undefined)
            {
                return Lang.Get("gs_error_" + code);
            }
            return Lang.Get("gs_error_unknown");
        }

        public function Lang()
        {
            super();
        }
    }
}
