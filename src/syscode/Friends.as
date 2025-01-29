package syscode
{
    import com.adobe.serialization.json.ADOBEJSON;
    import com.greensock.TweenMax;

    import flash.utils.getTimer;

    public class Friends
    {
        public static var soctoken:String = "";

        public static var external:Array = [];

        public static var intern:Array = [];

        public static var all:Array = [];

        public static var invitable:Array = [];

        public static var internalFriendCount:int = 0;

        public static function LoadExternalFriendsAPP(loginData:Object):void
        {
            var i:int = 0;
            var f:Object = null;
            Friends.soctoken = "";
            Friends.external = [];
            if (Boolean(loginData) && Boolean(loginData.social_friends))
            {
                Friends.soctoken = Util.StringVal(loginData.social_friends);
            }
            if (Boolean(loginData) && Boolean(loginData.granted_friends))
            {
                i = 0;
                while (i < loginData.granted_friends.length)
                {
                    f = loginData.granted_friends[i];
                    Friends.AddExternal(f);
                    i++;
                }
            }
            Friends.BuildAll();
        }

        public static function LoadExternalFriendsWEB():void
        {
            var i:int = 0;
            var f:Object = null;
            Friends.soctoken = "";
            Friends.external = [];
            if (Boolean(Config.flashvars) && Boolean(Config.flashvars.social_friends))
            {
                Friends.soctoken = Util.StringVal(Config.flashvars.social_friends);
            }
            var ext:Array = Util.ExternalCall("GetGrantedFriendlist");
            if (ext)
            {
                i = 0;
                while (i < ext.length)
                {
                    f = ext[i];
                    Friends.AddExternal(f);
                    i++;
                }
            }
            Friends.BuildAll();
        }

        public static function LoadInvitableFriends(_callback:Function = null):void
        {
            var url:String = null;
            var acc:String = Util.StringVal(Config.flashvars.fb_access_token);
            if (acc.length > 0)
            {
                url = "https://graph.facebook.com/me/invitable_friends?" + Util.FormatGetParams({
                            "access_token": acc,
                            "limit": 1000
                        }, false);
                MyLoader.LoadText(url, Friends.AddInvitable, null, [_callback], true);
            }
            else if (_callback != null)
            {
                _callback();
            }
        }

        public static function Cancel(userid:String, callbackFunc:Function):void
        {
            var callback:Function = null;
            callback = function(jsq:Object):void
            {
                if (Boolean(jsq) && jsq.error == 0)
                {
                    LoadInternalFriends(callbackFunc);
                }
                else if (callbackFunc != null)
                {
                    callbackFunc();
                }
            };
            FriendCommand("cancel_friendship", userid, callback);
        }

        public static function LoadInternalFriends(callbackFunc:Function):void
        {
            var callback:Function = null;
            callback = function(jsq:Object, callbackFunc:Function):void
            {
                if (jsq.error == 602)
                {
                    Friends.LoadInternalFriends(callbackFunc);
                }
                else if (jsq.error == 600 || jsq.error == 900)
                {
                    TweenMax.delayedCall(3, Friends.LoadInternalFriends, [callbackFunc]);
                }
                else
                {
                    Friends.AddInternal(jsq, callbackFunc);
                }
            };
            var now:int = getTimer();
            Friends.FriendCommand("list", "0", callback, [callbackFunc]);
        }

        public static function GetUser(partnerid:String):Object
        {
            var x:int = 0;
            while (x < Friends.all.length)
            {
                if (Friends.all[x].id == partnerid)
                {
                    return Friends.all[x];
                }
                x++;
            }
            return null;
        }

        public static function AddFriendShip(partnerid:String, callback:Function = null):*
        {
            var mw:Object = null;
            if (Friends.internalFriendCount >= 500)
            {
                mw = Modules.GetClass("uibase", "uibase.MessageWin");
                mw.Show(Lang.get ("friends"), Lang.get ("warn_friendlist_full"));
                return;
            }
            Friends.FriendCommand("add", partnerid, function(jsq:*, id:*):*
                {
                    Friends.AddInternal(jsq, callback);
                }, [partnerid]);
        }

        public static function CancelFriendShip(partnerid:String, callback:Function = null):*
        {
            Friends.FriendCommand("cancel_friendship", partnerid, function(jsq:*, id:*):*
                {
                    Friends.AddInternal(jsq, callback);
                }, [partnerid]);
        }

        public static function DenyFriendShip(partnerid:String, callback:Function = null):*
        {
            Friends.FriendCommand("deny", partnerid, function(jsq:*, id:*):*
                {
                    Friends.AddInternal(jsq, callback);
                }, [partnerid]);
        }

        public static function BlockUser(partnerid:String, callback:Function = null):*
        {
            Friends.FriendCommand("block", partnerid, function(jsq:*, id:*):*
                {
                    Friends.AddInternal(jsq, callback);
                }, [partnerid]);
        }

        public static function CancelBlock(partnerid:String, callback:Function = null):*
        {
            Friends.FriendCommand("cancel_block", partnerid, function(jsq:*, id:*):*
                {
                    Friends.AddInternal(jsq, callback);
                }, [partnerid]);
        }

        private static function AddInvitable(_response:Object, _callback:Function = null):void
        {
            var res:Object = null;
            var fid2:String = null;
            var i:int = 0;
            var f:Object = null;
            var fobj:Object = null;
            if (Boolean(_response) && _response.status == 200)
            {
                res = ADOBEJSON.decode(_response.data);
                if (Boolean(res) && Boolean(res.data))
                {
                    Friends.invitable = [];
                    fid2 = "";
                    i = 0;
                    while (i < res.data.length)
                    {
                        f = res.data[i];
                        if (f.id != fid2)
                        {
                            fobj = {};
                            fobj.invite_token = f.id;
                            fobj.name = f.name;
                            fobj.avatar = f.picture.data.url;
                            fobj.invitable = 1;
                            Friends.invitable.push(fobj);
                        }
                        fid2 = String(f.id);
                        i++;
                    }
                }
            }
            if (_callback != null)
            {
                _callback();
            }
        }

        private static function FriendCommand(cmd:String, partner:String = "0", callback:Function = null, callbackparams:Array = null):void
        {
            JsQuery.Load(callback, callbackparams, "client_friends.php?" + Sys.FormatGetParamsStoc(null), {
                        "cmd": cmd,
                        "partnerid": partner
                    });
        }

        private static function AddInternal(jsq:Object, callbackFunc:Function):void
        {
            var mw:Object = null;
            var f:Object = null;
            var u:Object = null;
            if (jsq.error)
            {
                mw = Modules.GetClass("uibase", "uibase.MessageWin");
                if (!Semu.enabled && !Comm.xrt_bypass_encryption)
                {
                    trace("not bypassing");
                    mw.Show(Lang.get ("error"), "Error loading friends: " + jsq.error + "\n" + jsq.errormsg);
                }
                return;
            }
            Friends.intern = [];
            Friends.internalFriendCount = 0;
            var i:int = 0;
            while (i < jsq.data.allitems.length)
            {
                f = jsq.data.allitems[i];
                u = {};
                u.id = Util.NumberVal(f.id);
                u.ii = u.id;
                u.name = Util.StringVal(f.name);
                u.avatar = Util.StringVal(f.int_avatar);
                if (u.avatar == "")
                {
                    u.avatar = Util.StringVal(f.ext_avatar);
                }
                u.flag = Util.NumberVal(f.flag);
                f.external = false;
                f.intern = true;
                u.actleague = Util.NumberVal(f.actleague);
                u.xplevel = Util.NumberVal(f.xplevel);
                Friends.intern.push(u);
                if (Util.StrTrim(u.name) != "" && u.avatar != "")
                {
                    Extdata.SetUserData(u.id, u.name, u.avatar);
                }
                if (u.flag == 0 || u.flag == 1)
                {
                    ++Friends.internalFriendCount;
                }
                i++;
            }
            BuildAll();
            if (callbackFunc != null)
            {
                callbackFunc();
            }
        }

        private static function AddExternal(f:Object):void
        {
            if (f)
            {
                f.id = Util.StringVal(f.ii);
                f.name = Util.StringVal(f["in"]);
                if (f.name == "")
                {
                    f.name = Util.StringVal(f.xn);
                }
                f.avatar = Util.StringVal(f.ip);
                if (f.avatar == "")
                {
                    f.avatar = Util.StringVal(f.xp);
                }
                f.flag = 1;
                f.external = true;
                f.intern = false;
                f.actleague = Util.NumberVal(f.actleague);
                f.xplevel = Util.NumberVal(f.xplevel);
                Friends.external.push(f);
                Extdata.SetUserData(f.id, f.name, f.avatar);
            }
        }

        private static function BuildAll():void
        {
            var i:int = 0;
            var b:Boolean = false;
            Friends.all = [];
            i = 0;
            while (i < Friends.intern.length)
            {
                Friends.all.push(Friends.intern[i]);
                i++;
            }
            var x:int = 0;
            while (x < Friends.external.length)
            {
                b = false;
                i = 0;
                if (i < Friends.intern.length)
                {
                    if (Friends.intern[i].id == Friends.external[x].id)
                    {
                        b = true;
                    }
                }
                if (!b)
                {
                    Friends.all.push(Friends.external[x]);
                }
                x++;
            }
            Imitation.DispatchGlobalEvent("FRIENDLISTCHANGE");
        }

        public function Friends()
        {
            super();
        }
    }
}
