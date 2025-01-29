package syscode
{
    import com.adobe.serialization.json.ADOBEJSON;

    import flash.events.*;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.Timer;

    public class JsQuery
    {
        public static var jstrace:Boolean = false;

        public static var baseuri:String = "";

        public static function Load(callbackfunc:Function, callbackargs:Array, url:String, postdata:* = null):void
        {
            var request:URLRequest;
            var status:int;
            var loader:URLLoader;
            var timer:Timer;
            var onTimer:Function;
            var onComplete:Function;
            var onStatus:Function;
            var onIOError:Function;
            var onSecurityError:Function;
            var ReturnData:Function;
            var ReturnError:Function;
            var DecompressSqlData:Function;
            var RemoveEvents:Function;
            trace("Url: " + url);
            loader = null;
            timer = null;
            onTimer = null;
            onComplete = null;
            onStatus = null;
            onIOError = null;
            onSecurityError = null;
            onTimer = function(event:TimerEvent):void
            {
                timer.reset();
                loader.close();
                ReturnError(602, "JsQuery.AsyncQuery: timeout reached.");
            };
            onComplete = function(event:Event):void
            {
                var parsed:*;
                var str:String = null;
                str = null;
                var robj:Object = null;
                try
                {
                    trace("event: " + event);
                    trace("URLLoader(event.currentTarget).data" + URLLoader(event.currentTarget).data);
                    str = URLLoader(event.currentTarget).data;
                    parsed = ADOBEJSON.decode(str);
                    robj = parsed;
                    robj.plain = str;
                }
                catch (err:Error)
                {
                    ReturnError(700, "JsQuery.AsyncQuery: JSON error: " + str + "real err:" + err);
                    return;
                }
                DecompressSqlData(robj);
                callbackargs.unshift(robj);
                ReturnData();
            };
            ReturnData = function():void
            {
                timer.reset();
                if (jstrace)
                {
                    DBG.Trace("JsQuery.Load/ReturnData: " + baseuri + url + " at " + Util.FormatTimeStamp(true, true), callbackargs);
                }
                callbackfunc.apply(null, callbackargs);
                RemoveEvents();
            };
            ReturnError = function(aerror:int, amsg:String):*
            {
                var result:* = {
                        "error": aerror,
                        "errormsg": amsg
                    };
                callbackargs.unshift(result);
                ReturnData();
            };
            DecompressSqlData = function(obj:*):*
            {
                var di:* = undefined;
                var d:* = undefined;
                var fi:* = undefined;
                if (obj.fieldnames !== undefined && typeof obj.data == "object" && obj.data is Array && obj.data.length > 0)
                {
                    for (di in obj.data)
                    {
                        d = {};
                        for (fi in obj.fieldnames)
                        {
                            d[obj.fieldnames[fi]] = obj.data[di][fi];
                        }
                        obj.data[di] = d;
                    }
                }
            };
            onStatus = function(event:HTTPStatusEvent):void
            {
                status = event.status;
            };
            onIOError = function(event:IOErrorEvent):void
            {
                event.stopPropagation();
                event.preventDefault();
                trace("IOError: " + url);
                ReturnError(600, "JsQuery.AsyncQuery: IO error");
            };
            onSecurityError = function(event:SecurityErrorEvent):void
            {
                event.stopPropagation();
                event.preventDefault();
                ReturnError(900, "JsQuery.AsyncQuery: Security Error");
            };
            RemoveEvents = function():*
            {
                Util.RemoveEventListener(loader, Event.COMPLETE, onComplete);
                Util.RemoveEventListener(loader, HTTPStatusEvent.HTTP_STATUS, onStatus);
                Util.RemoveEventListener(loader, IOErrorEvent.IO_ERROR, onIOError);
                Util.RemoveEventListener(loader, SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
                Util.RemoveEventListener(timer, TimerEvent.TIMER_COMPLETE, onTimer);
            };
            if (jstrace)
            {
                DBG.Trace("JsQuery.Load: " + baseuri + url + " at " + Util.FormatTimeStamp(true, true), postdata);
            }
            if (callbackfunc == null)
            {
                return;
            }
            if (callbackargs == null)
            {
                callbackargs = new Array();
            }
            request = new URLRequest(baseuri + url);
            loader = new URLLoader();
            status = 0;
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            Util.AddEventListener(loader, Event.COMPLETE, onComplete);
            Util.AddEventListener(loader, HTTPStatusEvent.HTTP_STATUS, onStatus);
            Util.AddEventListener(loader, IOErrorEvent.IO_ERROR, onIOError);
            Util.AddEventListener(loader, SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            if (postdata != null)
            {
                request.method = "POST";
                request.contentType = "application/json";
                request.data = ADOBEJSON.encode(postdata);
            }
            try
            {
                loader.load(request);
            }
            catch (err:Error)
            {
                RemoveEvents();
                ReturnError(601, "JsQuery.AsyncQuery: load exception.");
                return;
            }
            timer = new Timer(10000, 1);
            Util.AddEventListener(timer, TimerEvent.TIMER_COMPLETE, onTimer);
            timer.start();
        }

        public static function Dummy(jsq:*):void
        {
        }

        public function JsQuery()
        {
            super();
        }
    }
}
