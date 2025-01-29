package syscode
{
    import com.adobe.serialization.json.ADOBEJSON;

    import flash.display.*;
    import flash.events.*;
    import flash.external.ExternalInterface;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.system.Capabilities;
    import flash.utils.Timer;

    public class DBG
    {
        public static var FPSCounter:uint = 0;

        public static var FPSTimer:Timer = new Timer(1000, 0);

        public static var FPSTime:Number = 0;

        public static var StageState:String = "";

        public static var ClientState:Object = {};

        public static var StageFrameRate:int = 0;

        public static var LastFrameTime:Number = 0;

        public static var LongFrameTimes:Array = [];

        public static var LastFrameReportTime:Number = 0;

        private static var LastErrorReportTime:Number = 0;

        public static function trace(...rest):*
        {
            MyTrace.myTrace(rest);
        }

        public static function Trace(info:String, obj:* = null):void
        {
            var log:String = Util.FormatTrace(obj);
            trace(info);
            if (obj != null)
            {
                if (typeof obj == "string")
                {
                    trace(obj);
                }
                else
                {
                    trace(log);
                }
            }
            if (Config.inbrowser && ExternalInterface.available && Config.tracetoconsole)
            {
                ExternalInterface.call("console.log", info);
                if (obj != null)
                {
                    if (typeof obj == "string")
                    {
                        ExternalInterface.call("console.log", obj);
                    }
                    else
                    {
                        ExternalInterface.call("console.log", log);
                    }
                }
            }
        }

        public static function AddErrorLogger(loaderinfo:LoaderInfo):void
        {
            if (DBG.GetVersion() >= 11.5)
            {
                trace("global error logger ready");
                loaderinfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, DBG.OnErrorLogger);
            }
            else
            {
                trace("global error logger failed: invalid player version");
            }
        }

        public static function SendWarning(message:String):void
        {
            DBG.SendErrorLog(message, "", "warninglog");
        }

        public static function SendCustomLog(message:String, info:String, command:String):void
        {
            DBG.SendErrorLog(message, info, command);
        }

        private static function StringVal(str:*, defval:String = ""):String
        {
            if (str !== undefined && str != null)
            {
                return String(str);
            }
            return defval;
        }

        private static function NumberVal(num:*, defval:Number = 0):Number
        {
            var tmp:* = Number(num);
            if (!isNaN(tmp))
            {
                return tmp;
            }
            return defval;
        }

        private static function GetVersion():Number
        {
            var ver:String = null;
            var arr:Array = null;
            var tmp:Array = null;
            try
            {
                ver = Capabilities.version;
                arr = ver.split(",");
                tmp = arr[0].split(" ");
                return Number(tmp[1] + "." + arr[1]);
            }
            catch (e:Error)
            {
            }
            return 0;
        }

        private static function CollectClientState():Object
        {
            var arr:Array = null;
            var res:Object = {};
            res.connstate = Comm.connstate;
            res.listen = Comm.listening ? 1 : 0;
            res.ready = Comm.iamready ? 1 : 0;
            res.connid = Comm.connid;
            res.preconnid = Comm.preconnid;
            res.mlp = Comm.ModuleLoadingPhase ? 1 : 0;
            res.mainmodule = Sys.activemodule;
            res.screen = Sys.screen;
            res.prevscreen = Sys.prevscreen;
            res.version = Version.value;
            res.currentwindow = WinMgr.currentwindow == null ? "" : WinMgr.currentwindow.classname;
            res.closingwindow = WinMgr.closingwindow == null ? "" : WinMgr.closingwindow.classname;
            res.loadingwindow = WinMgr.loadingwindow == null ? "" : WinMgr.loadingwindow.classname;
            if (res.screen.substr(0, 3) == "MAP")
            {
                arr = String(Sys.tag_state.ST).split(",");
                res.gamestate = StringVal(arr[0]);
                res.gameround = StringVal(arr[1]);
                res.gamephase = StringVal(arr[2]);
            }
            if (Boolean(Sys.mydata) && Sys.mydata.id > 0)
            {
                res.xplevel = Sys.mydata.xplevel;
            }
            else if (Config.inbrowser && Boolean(Config.flashvars))
            {
                res.xplevel = Util.NumberVal(Config.flashvars.xplevel);
            }
            else
            {
                res.xplevel = 0;
            }
            res.tracelog = MyTrace.tracelog;
            return res;
        }

        private static function SendErrorLog(message:String, stacktrace:String, command:String):void
        {
            var url:String = null;
            var dat:String = null;
            var req:URLRequest = null;
            var ldr:URLLoader = null;
            var now:Number = new Date().time;
            if (LastErrorReportTime <= now - 1000)
            {
                url = Config.extdatauribase + "client_errorlog.php?cmd=errorlog&time=" + now;
                dat = ADOBEJSON.stringify({
                            "cmd": command,
                            "time": now,
                            "userid": Config.loginuserid,
                            "client": Config.clienttype,
                            "message": message,
                            "stacktrace": stacktrace,
                            "version": Version.value,
                            "usegpu": (Imitation.usegpu ? "1" : "0"),
                            "driver": Imitation.driverinfo,
                            "flash": DBG.GetVersion(),
                            "state": DBG.CollectClientState()
                        });
                DBG.Trace("DBG.SendErrorLog", url + "\n" + dat);
                if (Config.indesigner)
                {
                    return;
                }
                req = new URLRequest(url);
                req.contentType = "text/plain";
                req.method = "POST";
                req.data = dat;
                ldr = new URLLoader();
                ldr.addEventListener(IOErrorEvent.IO_ERROR, function(e:*):*
                    {
                        trace("io error sending error report...");
                    });
                ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:*):*
                    {
                        trace("security error sending error report...");
                    });
                ldr.dataFormat = URLLoaderDataFormat.TEXT;
                ldr.load(req);
                LastErrorReportTime = now;
            }
            else
            {
                trace("DBG.SendError: flood blocked");
            }
        }

        public function DBG()
        {
            super();
        }

        private static function OnErrorLogger(event:UncaughtErrorEvent):void
        {
            var err:Error = null;
            var message:String = "";
            var stacktr:String = "";
            if (event.error is Error)
            {
                err = event.error as Error;
                message = err.message;
                stacktr = err.getStackTrace();
            }
            else if (event.error is ErrorEvent)
            {
                message = ErrorEvent(event.error).text;
                stacktr = "ErrorEvent";
            }
            else
            {
                trace("non error event was uncaught");
            }
            if (message.length > 0)
            {
                DBG.SendErrorLog(message, stacktr, "errorlog");
            }
        }
    }
}
