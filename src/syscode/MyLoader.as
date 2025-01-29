package syscode
{
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.events.*;
    import flash.media.Sound;
    import flash.media.SoundLoaderContext;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.system.LoaderContext;
    import flash.utils.ByteArray;

    public class MyLoader
    {
        public static function LoadText(url:String, funcCallback:Function, thisCallback:* = null, argsCallback:Array = null, withStatus:Boolean = false):void
        {
            var request:URLRequest;
            var loader:URLLoader = null;
            var status:int = 0;
            var onComplete:Function = null;
            var onStatus:Function = null;
            var onIOError:Function = null;
            var onSecurityError:Function = null;
            onComplete = function(event:Event):void
            {
                var str:String = null;
                try
                {
                    str = URLLoader(event.currentTarget).data;
                }
                catch (err:Error)
                {
                    str = null;
                    ClientTrace(32, "MyLoader.LoadText.onComplete(\"" + url + "\") " + err.toString());
                }
                try
                {
                    if (withStatus)
                    {
                        argsCallback.unshift({
                                    "data": str,
                                    "status": status
                                });
                    }
                    else
                    {
                        argsCallback.unshift(str);
                    }
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(32, "MyLoader.LoadText.onComplete(\"" + url + "\"):\"callback\" " + err.toString() + " st: " + err.getStackTrace());
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
                ClientTrace(32, "MyLoader.LoadText.onIOError(\"" + url + "\"): " + event.toString());
                try
                {
                    if (withStatus)
                    {
                        argsCallback.unshift({
                                    "data": null,
                                    "status": status
                                });
                    }
                    else
                    {
                        argsCallback.unshift(null);
                    }
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(32, "MyLoader.LoadText.onIOError(\"" + url + "\"):\"callback\" " + err.toString());
                }
            };
            onSecurityError = function(event:SecurityErrorEvent):void
            {
                event.stopPropagation();
                event.preventDefault();
                ClientTrace(32, "MyLoader.LoadText.onSecurityError(\"" + url + "\"): " + event.toString());
                loader.close();
                try
                {
                    if (withStatus)
                    {
                        argsCallback.unshift({
                                    "data": null,
                                    "status": status
                                });
                    }
                    else
                    {
                        argsCallback.unshift(null);
                    }
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(32, "MyLoader.LoadText.onSecurityError(\"" + url + "\"):\"callback\" " + err.toString());
                }
            };
            if (funcCallback == null)
            {
                return;
            }
            if (argsCallback == null)
            {
                argsCallback = new Array();
            }
            request = new URLRequest(url);
            loader = new URLLoader();
            status = 0;
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            loader.addEventListener(Event.COMPLETE, onComplete);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            try
            {
                loader.load(request);
            }
            catch (err:Error)
            {
                ClientTrace(32, "MyLoader.LoadText.load(\"" + url + "\") " + err.toString());
                try
                {
                    if (withStatus)
                    {
                        argsCallback.unshift({
                                    "data": null,
                                    "status": status
                                });
                    }
                    else
                    {
                        argsCallback.unshift(null);
                    }
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(32, "MyLoader.LoadText.load(\"" + url + "\"):\"callback\" " + err.toString());
                }
            }
        }

        public static function LoadSound(url:String, funcCallback:Function, thisCallback:* = null, argsCallback:Array = null):void
        {
            var context:SoundLoaderContext;
            var request:URLRequest;
            var sound:Sound = null;
            var onComplete:Function = null;
            var onIOError:Function = null;
            onComplete = function(event:Event):void
            {
                try
                {
                    argsCallback.unshift(sound);
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(33, "MyLoader.LoadText.onComplete(\"" + url + "\"):\"callback\" " + err.toString());
                }
            };
            onIOError = function(event:IOErrorEvent):void
            {
                event.stopPropagation();
                event.preventDefault();
                ClientTrace(33, "MyLoader.LoadSound.onIOError(\"" + url + "\"): " + event.toString());
                try
                {
                    argsCallback.unshift(null);
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(33, "MyLoader.LoadSound.onIOError(\"" + url + "\"):\"callback\" " + err.toString());
                }
            };
            if (funcCallback == null)
            {
                return;
            }
            if (argsCallback == null)
            {
                argsCallback = new Array();
            }
            context = new SoundLoaderContext(1000, true);
            request = new URLRequest(url);
            sound = new Sound();
            sound.addEventListener(Event.COMPLETE, onComplete);
            sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            try
            {
                sound.load(request);
            }
            catch (err:Error)
            {
                ClientTrace(33, "MyLoader.LoadSound.load(\"" + url + "\") " + err.toString());
                try
                {
                    argsCallback.unshift(null);
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(33, "MyLoader.LoadSound.load(\"" + url + "\"):\"callback\" " + err.toString());
                }
            }
        }

        public static function LoadBitmap(url:String, funcCallback:Function, thisCallback:* = null, argsCallback:Array = null):void
        {
            var request:URLRequest;
            var loader:URLLoader = null;
            var status:String = null;
            var onComplete:Function = null;
            var onBitmapComplete:Function = null;
            var onHTTPStatus:Function = null;
            var onIOError:Function = null;
            var onBitmapIOError:Function = null;
            var onSecurityError:Function = null;
            onComplete = function(event:Event):void
            {
                var ldr:Loader = new Loader();
                ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onBitmapComplete);
                ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onBitmapIOError);
                try
                {
                    ldr.loadBytes(URLLoader(event.currentTarget).data as ByteArray);
                }
                catch (err:Error)
                {
                    ldr = null;
                    ClientTrace(31, "MyLoader.LoadBitmap.onComplete(\"" + url + "\"):\"load\" " + err.toString());
                }
                if (ldr == null)
                {
                    try
                    {
                        argsCallback.unshift(null);
                        funcCallback.apply(thisCallback, argsCallback);
                    }
                    catch (err:Error)
                    {
                        ClientTrace(31, "MyLoader.LoadBitmap.onComplete(\"" + url + "\"):\"callback\" " + err.toString());
                    }
                }
            };
            onBitmapComplete = function(event:Event):void
            {
                var bitmap:Bitmap = null;
                try
                {
                    bitmap = new Bitmap(event.currentTarget.content.bitmapData, "auto", true);
                }
                catch (err:Error)
                {
                    bitmap = null;
                    ClientTrace(31, "MyLoader.LoadBitmap.onBitmapComplete(\"" + url + "\"):\"bitmap\" " + err.toString());
                }
                try
                {
                    argsCallback.unshift(bitmap);
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(31, "MyLoader.LoadBitmap.onBitmapComplete(\"" + url + "\"):\"callback\" " + err.toString());
                }
            };
            onHTTPStatus = function(event:HTTPStatusEvent):void
            {
                if (status.length > 0)
                {
                    status += ",";
                }
                status += String(event.status);
            };
            onIOError = function(event:IOErrorEvent):void
            {
                event.stopPropagation();
                event.preventDefault();
                ClientTrace(31, "MyLoader.LoadBitmap.onIOError(\"" + url + "\"," + status + "): " + event.toString());
                try
                {
                    argsCallback.unshift(null);
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(31, "MyLoader.LoadBitmap.onIOError(\"" + url + "\"):\"callback\" " + err.toString());
                }
            };
            onBitmapIOError = function(event:IOErrorEvent):void
            {
                event.stopPropagation();
                event.preventDefault();
                ClientTrace(31, "MyLoader.LoadBitmap.onBitmapIOError(\"" + url + "\"," + status + "): " + event.toString());
                try
                {
                    argsCallback.unshift(null);
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(31, "MyLoader.LoadBitmap.onIOError(\"" + url + "\"):\"callback\" " + err.toString());
                }
            };
            onSecurityError = function(event:SecurityErrorEvent):void
            {
                event.stopPropagation();
                event.preventDefault();
                ClientTrace(31, "MyLoader.LoadBitmap.onSecurityError(\"" + url + "\"," + status + "): " + event.toString());
                loader.close();
                try
                {
                    argsCallback.unshift(null);
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(31, "MyLoader.LoadBitmap.onSecurityError(\"" + url + "\"):\"callback\" " + err.toString());
                }
            };
            if (funcCallback == null)
            {
                return;
            }
            if (argsCallback == null)
            {
                argsCallback = new Array();
            }
            request = new URLRequest(url);
            loader = new URLLoader();
            status = "";
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener(Event.COMPLETE, onComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
            try
            {
                loader.load(request);
            }
            catch (err:Error)
            {
                ClientTrace(31, "MyLoader.LoadBitmap.load(\"" + url + "\") " + err.toString());
                try
                {
                    argsCallback.unshift(null);
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(31, "MyLoader.LoadBitmap.load(\"" + url + "\"):\"callback\" " + err.toString());
                }
            }
        }

        public static function LoadSWF(url:String, funcCallback:Function, thisCallback:* = null, argsCallback:Array = null):void
        {
            var ref:String;
            var request:URLRequest;
            var loader:URLLoader = null;
            var status:String = null;
            var onComplete:Function = null;
            var onSWFComplete:Function = null;
            var onHTTPStatus:Function = null;
            var onIOError:Function = null;
            var onSWFIOError:Function = null;
            var onSecurityError:Function = null;
            onComplete = function(event:Event):void
            {
                var loaderContext:LoaderContext;
                var ldr:Loader = new Loader();
                ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFComplete);
                ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onSWFIOError);
                loaderContext = new LoaderContext();
                loaderContext.allowCodeImport = true;
                try
                {
                    ldr.loadBytes(URLLoader(event.currentTarget).data as ByteArray, loaderContext);
                }
                catch (err:Error)
                {
                    ldr = null;
                    ClientTrace(31, "MyLoader.LoadSWF.onComplete(\"" + url + "\"):\"load\" " + err.toString());
                }
                if (ldr == null)
                {
                    try
                    {
                        argsCallback.unshift(null);
                        funcCallback.apply(thisCallback, argsCallback);
                    }
                    catch (err:Error)
                    {
                        ClientTrace(31, "MyLoader.LoadSWF.onComplete(\"" + url + "\"):\"callback\" " + err.toString());
                    }
                }
            };
            onSWFComplete = function(event:Event):void
            {
                var swf:MovieClip = null;
                try
                {
                    swf = event.currentTarget.content as MovieClip;
                }
                catch (err:Error)
                {
                    swf = null;
                    ClientTrace(31, "MyLoader.LoadSWF.onSWFComplete(\"" + url + "\"):\"swf\" " + err.toString());
                }
                argsCallback.unshift(swf);
                funcCallback.apply(thisCallback, argsCallback);
            };
            onHTTPStatus = function(event:HTTPStatusEvent):void
            {
                if (status.length > 0)
                {
                    status += ",";
                }
                status += String(event.status);
            };
            onIOError = function(event:IOErrorEvent):void
            {
                event.stopPropagation();
                event.preventDefault();
                ClientTrace(31, "MyLoader.LoadSWF.onIOError(\"" + url + "\"," + status + "): " + event.toString());
                try
                {
                    argsCallback.unshift(null);
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(31, "MyLoader.LoadSWF.onIOError(\"" + url + "\"):\"callback\" " + err.toString());
                }
            };
            onSWFIOError = function(event:IOErrorEvent):void
            {
                event.stopPropagation();
                event.preventDefault();
                ClientTrace(31, "MyLoader.LoadSWF.onSWFIOError(\"" + url + "\"," + status + "): " + event.toString());
                try
                {
                    argsCallback.unshift(null);
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(31, "MyLoader.LoadSWF.onIOError(\"" + url + "\"):\"callback\" " + err.toString());
                }
            };
            onSecurityError = function(event:SecurityErrorEvent):void
            {
                event.stopPropagation();
                event.preventDefault();
                ClientTrace(31, "MyLoader.LoadSWF.onSecurityError(\"" + url + "\"," + status + "): " + event.toString());
                loader.close();
                try
                {
                    argsCallback.unshift(null);
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(31, "MyLoader.LoadSWF.onSecurityError(\"" + url + "\"):\"callback\" " + err.toString());
                }
            };
            if (funcCallback == null)
            {
                return;
            }
            if (argsCallback == null)
            {
                argsCallback = new Array();
            }
            ref = Config.GetFileReference(url);
            request = new URLRequest(ref);
            loader = new URLLoader();
            status = "";
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener(Event.COMPLETE, onComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
            try
            {
                loader.load(request);
            }
            catch (err:Error)
            {
                ClientTrace(31, "MyLoader.LoadSWF.load(\"" + url + "\") " + err.toString());
                try
                {
                    argsCallback.unshift(null);
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(31, "MyLoader.LoadSWF.load(\"" + url + "\"):\"callback\" " + err.toString());
                }
            }
        }

        public static function ClientTrace(acode:int, astr:String):*
        {
            trace("MyLoader trace: " + acode + ": " + astr);
        }

        public static function PostData(data:String, url:String, funcCallback:Function, thisCallback:* = null, argsCallback:Array = null, withStatus:Boolean = false):void
        {
            var request:URLRequest;
            var loader:URLLoader = null;
            var status:int = 0;
            var onComplete:Function = null;
            var onStatus:Function = null;
            var onIOError:Function = null;
            var onSecurityError:Function = null;
            onComplete = function(event:Event):void
            {
                var str:String = null;
                try
                {
                    str = URLLoader(event.currentTarget).data;
                }
                catch (err:Error)
                {
                    str = null;
                    ClientTrace(32, "MyLoader.PostData.onComplete(\"" + url + "\") " + err.toString());
                }
                try
                {
                    if (withStatus)
                    {
                        argsCallback.unshift({
                                    "data": str,
                                    "status": status
                                });
                    }
                    else
                    {
                        argsCallback.unshift(str);
                    }
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(32, "MyLoader.PostData.onComplete(\"" + url + "\"):\"callback\" " + err.toString() + " st: " + err.getStackTrace());
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
                ClientTrace(32, "MyLoader.PostData.onIOError(\"" + url + "\"): " + event.toString());
                try
                {
                    if (withStatus)
                    {
                        argsCallback.unshift({
                                    "data": null,
                                    "status": status
                                });
                    }
                    else
                    {
                        argsCallback.unshift(null);
                    }
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(32, "MyLoader.PostData.onIOError(\"" + url + "\"):\"callback\" " + err.toString());
                }
            };
            onSecurityError = function(event:SecurityErrorEvent):void
            {
                event.stopPropagation();
                event.preventDefault();
                ClientTrace(32, "MyLoader.PostData.onSecurityError(\"" + url + "\"): " + event.toString());
                loader.close();
                try
                {
                    if (withStatus)
                    {
                        argsCallback.unshift({
                                    "data": null,
                                    "status": status
                                });
                    }
                    else
                    {
                        argsCallback.unshift(null);
                    }
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(32, "MyLoader.PostData.onSecurityError(\"" + url + "\"):\"callback\" " + err.toString());
                }
            };
            if (funcCallback == null)
            {
                return;
            }
            if (argsCallback == null)
            {
                argsCallback = new Array();
            }
            request = new URLRequest(url);
            loader = new URLLoader();
            status = 0;
            request.contentType = "text/plain";
            request.method = URLRequestMethod.POST;
            request.data = String(data);
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            loader.addEventListener(Event.COMPLETE, onComplete);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            try
            {
                loader.load(request);
            }
            catch (err:Error)
            {
                ClientTrace(32, "MyLoader.PostData.load(\"" + url + "\") " + err.toString());
                try
                {
                    if (withStatus)
                    {
                        argsCallback.unshift({
                                    "data": null,
                                    "status": status
                                });
                    }
                    else
                    {
                        argsCallback.unshift(null);
                    }
                    funcCallback.apply(thisCallback, argsCallback);
                }
                catch (err:Error)
                {
                    ClientTrace(32, "MyLoader.PostData.load(\"" + url + "\"):\"callback\" " + err.toString());
                }
            }
        }

        public function MyLoader()
        {
            super();
        }
    }
}
