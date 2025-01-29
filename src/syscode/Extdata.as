package syscode
{
    import com.greensock.TweenMax;

    public class Extdata
    {
        public static var countries:Object = {};
        private static var users:Object = {};
        private static var userstoget:Array = [];
        private static var countriesloaded:Boolean = false;
        private static var callbackFuncArr:Array = [];

        public static function AddUser(uid:String):Object
        {
            var u:Object = {
                    "loaded": 0,
                    "id": uid,
                    "name": "",
                    "avatar": "",
                    "bigavatar": ""
                };
            Extdata.users[uid] = u;
            return u;
        }

        public static function SetUserData(uid:String, name:String, avatar:String):Object
        {
            var u:Object = Extdata.users[uid];
            if (!u)
            {
                u = AddUser(uid);
            }
            u.name = Util.StringVal(name);
            u.avatar = Util.StringVal(avatar);
            u.bigavatar = u.avatar;
            u.loaded = 4;
            if (u.avatar.match(/^\/\/graph\.facebook\.com\/[0-9]+\/picture$/))
            {
                u.bigavatar = u.avatar + "?width=70&height=70";
                u.avatar += "?width=35&height=35";
            }
            return u;
        }

        public static function GetUserData(uid:String, schedule:Boolean = true):Object
        {
            var u:Object = Extdata.users[uid];
            if (!u)
            {
                if (schedule)
                {
                    u = AddUser(uid);
                    Extdata.userstoget.push(u);
                }
                return null;
            }
            if (u.loaded >= 4)
            {
                return u;
            }
            return null;
        }

        public static function UserName(uid:String):String
        {
            if (uid == Sys.mydata.id)
            {
                return Sys.mydata.name;
            }
            var u:Object = Extdata.GetUserData(uid);
            if (u)
            {
                return u.name;
            }
            return "";
        }

        public static function SetCountryData(cid:String, name:String, description:String, flag:String):Object
        {
            var c:Object = Extdata.countries[cid];
            if (!c)
            {
                c = AddCountry(cid);
            }
            c.name = name;
            c.description = description;
            c.flag = flag;
            c.loaded = 4;
            return c;
        }

        public static function GetCountryData(cid:String):Object
        {
            var c:Object = Extdata.countries[cid];
            if (c)
            {
                return c;
            }
            return {
                    "loaded": 4,
                    "id": "--",
                    "name": "",
                    "flag": "",
                    "description": ""
                };
        }

        public static function CountryName(cid:String):String
        {
            var c:Object = Extdata.GetCountryData(cid);
            if (c)
            {
                return c.name;
            }
            return "";
        }

        public static function CountryDescription(cid:String):String
        {
            var c:Object = Extdata.GetCountryData(cid);
            if (c)
            {
                return c.description;
            }
            return "";
        }

        public static function LoadCountries(onCompleteFunc:Function):void
        {
            var callback:Function = null;
            callback = function(jsq:Object):void
            {
                var co:Object = null;
                var flag:* = null;
                var prefix:String = null;
                if (jsq.error == 602)
                {
                    Extdata.LoadCountries(onCompleteFunc);
                    return;
                }
                if (jsq.error == 600 || jsq.error == 900)
                {
                    TweenMax.delayedCall(3, Extdata.LoadCountries, [onCompleteFunc]);
                    return;
                }
                if (jsq.error > 0)
                {
                    return;
                }
                Extdata.countriesloaded = true;
                var data:Array = jsq.data as Array;
                var cnt:int = 0;
                var i:int = 0;
                trace("Config.siteid: " + Config.siteid);
                trace("Config.siteid.length: " + Config.siteid.length);
                while (i < data.length)
                {
                    co = data[i];
                    flag = "";
                    prefix = Config.ios || Config.desktop ? String(Config.bootparams.appbaseurl) : "client/";
                    if (Config.siteid)
                    {
                        if (Config.siteid.substr(0, 1) == "x" || Config.siteid.length != 2)
                        {
                            flag = prefix + "assets/flags/xx/" + co.id + ".gif";
                        }
                        else
                        {
                            flag = prefix + "assets/flags/" + Config.siteid + "/" + co.id + ".gif";
                            trace("flag: " + flag);
                        }
                    }
                    Extdata.SetCountryData(Util.StringVal(co.id), Util.StringVal(co.name), Util.StringVal(co.description), flag);
                    cnt++;
                    i++;
                }
                if (onCompleteFunc != null)
                {
                    onCompleteFunc();
                }
            };
            if (Extdata.countriesloaded)
            {
                if (onCompleteFunc != null)
                {
                    onCompleteFunc();
                }
                return;
            }
            JsQuery.Load(callback, [], "client_countries.php");
        }

        public static function GetSheduledData(onCompleteFunc:Function):void
        {
            var f:int = 0;
            var u:Object = null;
            if (onCompleteFunc != null)
            {
                Extdata.callbackFuncArr.push(onCompleteFunc);
            }
            if (onCompleteFunc == null && Extdata.userstoget.length <= 0)
            {
                f = 0;
                while (f < Extdata.callbackFuncArr.length)
                {
                    if (Extdata.callbackFuncArr[f] != null)
                    {
                        Extdata.callbackFuncArr[f]();
                    }
                    f++;
                }
                Extdata.callbackFuncArr = [];
                return;
            }
            var srvusers:Array = [];
            var phpusers:Array = [];
            var i:int = 0;
            while (i < Extdata.userstoget.length)
            {
                u = Extdata.userstoget[i];
                if (u.loaded == 0)
                {
                    u.loaded = 1;
                    srvusers.push(u.id);
                }
                else if (u.loaded == 2)
                {
                    u.loaded = 3;
                    phpusers.push(u.id);
                }
                i++;
            }
            if (srvusers.length > 0)
            {
                Comm.SendCommand("GETEXTDATA", "IDLIST=\"" + srvusers.join(",") + "\"", OnSrvCommandResult, null);
            }
            if (phpusers.length > 0)
            {
                JsQuery.Load(OnPhpCommandResult, [], "client_extdata.php", phpusers);
            }
        }

        private static function OnSrvCommandResult(res:int, xml:XML):void
        {
            var gu:Object = null;
            var ok:Boolean = false;
            var ru:Object = null;
            var data:Object = null;
            var gi:int = 0;
            var ri:int = 0;
            if (res == 0)
            {
                data = Util.XMLTagToObject(xml);
            }
            while (gi < Extdata.userstoget.length)
            {
                gu = Extdata.userstoget[gi];
                ok = false;
                if (res == 0 && data && Boolean(data.EXTDATA) && Boolean(data.EXTDATA.USER))
                {
                    if (!(data.EXTDATA.USER is Array))
                    {
                        data.EXTDATA.USER = [data.EXTDATA.USER];
                    }
                    ri = 0;
                    while (ri < data.EXTDATA.USER.length)
                    {
                        ru = data.EXTDATA.USER[ri];
                        if (gu.loaded == 1 && ru.ID == gu.id)
                        {
                            ok = true;
                            gu.loaded = 4;
                            Extdata.SetUserData(gu.id, ru.NAME, !!Util.NumberVal(ru.USECUSTOM) ? String(ru.CUSTOM) : String(ru.IMGURL));
                            Extdata.userstoget.splice(gi, 1);
                            break;
                        }
                        ri++;
                    }
                }
                if (!ok)
                {
                    gi++;
                    if (gu.loaded == 1)
                    {
                        gu.loaded = 2;
                    }
                }
            }
            Extdata.GetSheduledData(null);
        }

        private static function OnPhpCommandResult(jsq:Object):void
        {
            var gu:Object = null;
            var ok:Boolean = false;
            var ru:Object = null;
            var data:Object = null;
            var gi:int = 0;
            var ri:int = 0;
            if (jsq.error == 0)
            {
                data = jsq.data;
            }
            while (gi < Extdata.userstoget.length)
            {
                gu = Extdata.userstoget[gi];
                ok = false;
                if (jsq.error == 0 && Boolean(data))
                {
                    ri = 0;
                    while (ri < data.length)
                    {
                        ru = data[ri];
                        if (gu.loaded == 3 && ru.USERID == gu.id)
                        {
                            ok = true;
                            gu.loaded = 4;
                            Extdata.SetUserData(gu.id, ru.NAME, !!Util.NumberVal(ru.USECUSTOM) ? String(ru.CUSTOM) : String(ru.IMGURL));
                            Extdata.userstoget.splice(gi, 1);
                            break;
                        }
                        ri++;
                    }
                }
                if (!ok)
                {
                    if (gu.loaded == 3)
                    {
                        gu.loaded = 5;
                        Extdata.SetUserData(gu.id, "-", "");
                        Extdata.userstoget.splice(gi, 1);
                    }
                    else
                    {
                        gi++;
                    }
                }
            }
            Extdata.GetSheduledData(null);
        }

        private static function AddCountry(cid:String):Object
        {
            var c:Object = {
                    "loaded": 4,
                    "id": cid,
                    "name": "",
                    "flag": "",
                    "description": ""
                };
            Extdata.countries[cid] = c;
            return c;
        }

        public function Extdata()
        {
            super();
        }
    }
}
