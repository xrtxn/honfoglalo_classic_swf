package syscode
{
    import com.adobe.serialization.json.ADOBEJSON;

    import flash.text.*;

    public class Help
    {
        public static var data:Object = {};

        public static var todo:Array = [];

        public static var init:Boolean = false;

        public static function Get(hid:String):String
        {
            var s:String = String(Help.data[hid]);
            if (s == null || s.length < 1)
            {
                return "{" + hid + "}";
            }
            return s;
        }

        public static function get (hid:String):String
        {
            return Help.Get(hid);
        }

        public static function Set(tf:TextField, hid:String):void
        {
            if (!Config.releaseversion)
            {
                if (Help.init)
                {
                    tf.htmlText = Help.Get(hid);
                }
                else
                {
                    tf.text = "";
                    todo.push({
                                "tf": tf,
                                "hid": hid
                            });
                }
                return;
            }
            try
            {
                if (Help.init)
                {
                    tf.htmlText = Help.Get(hid);
                }
                else
                {
                    tf.text = "";
                    todo.push({
                                "tf": tf,
                                "hid": hid
                            });
                }
            }
            catch (err:Error)
            {
                DBG.Trace("Help.Set", err);
            }
        }

        public static function set (tf:TextField, hid:String):void
        {
            Help.Set(tf, hid);
        }

        public static function ProcessTodoList():void
        {
            var tmp:Object = null;
            while (Help.todo.length > 0)
            {
                tmp = Help.todo.pop();
                try
                {
                    Util.SetText(tmp.tf, Help.Get(tmp.hid));
                }
                catch (err:Error)
                {
                    DBG.Trace("Help.ProcessTodoList", err);
                }
            }
        }

        public static function LoadData(url:String, callback:Function = null):void
        {
            var HelpDataLoaded:Function = null;
            HelpDataLoaded = function(data:String):void
            {
                try
                {
                    Help.init = true;
                    Help.data = ADOBEJSON.decode(data);
                    Help.ProcessTodoList();
                    if (callback != null)
                    {
                        callback(true);
                    }
                }
                catch (err:Error)
                {
                    DBG.Trace("Help.LoadData", err);
                    if (callback != null)
                    {
                        callback(false);
                    }
                }
            };
            MyLoader.LoadText(url, HelpDataLoaded);
        }

        public static function ReplaceStr(astr:String, afrom:String, ato:String):String
        {
            return astr.split(afrom).join(ato);
        }

        public function Help()
        {
            super();
        }
    }
}
