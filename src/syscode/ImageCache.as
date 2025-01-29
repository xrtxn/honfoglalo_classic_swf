package syscode
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class ImageCache
    {
        private static var imageobj:Object = {};

        public static function LoadImage(callbackFunc:Function, callbackThis:*, callbackArgs:Array, imageUrl:String):void
        {
            var url:String;
            var onImageLoaded:Function = null;
            var bitmap:Bitmap = null;
            onImageLoaded = function(bitmap:Bitmap):void
            {
                ImageCache.imageobj[imageUrl] = bitmap;
                if (bitmap != null)
                {
                    ImageCache.LoadImage(callbackFunc, callbackThis, callbackArgs, imageUrl);
                }
            };
            if (imageUrl == null || imageUrl.length == 0)
            {
                return;
            }
            if (ImageCache.imageobj[imageUrl] !== undefined && ImageCache.imageobj[imageUrl] != null)
            {
                bitmap = new Bitmap(ImageCache.imageobj[imageUrl].bitmapData, "auto", true);
                callbackArgs.unshift(bitmap);
                callbackFunc.apply(callbackThis, callbackArgs);
                return;
            }
            url = imageUrl;
            if (url.indexOf("//") == 0)
            {
                url = Config.protocol + ":" + url;
            }
            MyLoader.LoadBitmap(url, onImageLoaded);
        }

        public static function AddImagePack(zipUrl:String, prefix:String):void
        {
            var loader:URLLoader = null;
            var onComplete:Function = null;
            var onIOError:Function = null;
            onComplete = function(event:Event):void
            {
                var zip:ByteArray = URLLoader(event.currentTarget).data as ByteArray;
                ImageCache.AddImageZip(zip, prefix);
                Util.RemoveEventListener(loader, Event.COMPLETE, onComplete);
                Util.RemoveEventListener(loader, IOErrorEvent.IO_ERROR, onIOError);
            };
            onIOError = function(event:IOErrorEvent):void
            {
                trace("ImageCache.AddImagePack ERROR:", event.toString());
                Util.RemoveEventListener(loader, Event.COMPLETE, onComplete);
                Util.RemoveEventListener(loader, IOErrorEvent.IO_ERROR, onIOError);
            };
            var request:URLRequest = new URLRequest(zipUrl);
            loader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            Util.AddEventListener(loader, Event.COMPLETE, onComplete);
            Util.AddEventListener(loader, IOErrorEvent.IO_ERROR, onIOError);
            loader.load(request);
        }

        private static function ReadZipHeader(zip:ByteArray):Object
        {
            if (zip.bytesAvailable < 30)
            {
                return null;
            }
            var lhs:uint = zip.readUnsignedInt();
            if (lhs != 67324752)
            {
                return null;
            }
            zip.position += 2;
            var gen:uint = zip.readUnsignedShort();
            var cmp:uint = zip.readUnsignedShort();
            if (cmp != 0 && cmp != 8)
            {
                return null;
            }
            zip.position += 8;
            var csize:uint = zip.readUnsignedInt();
            var usize:uint = zip.readUnsignedInt();
            var nlen:uint = zip.readUnsignedShort();
            var xlen:uint = zip.readUnsignedShort();
            var name:String = zip.readUTFBytes(nlen);
            zip.position += xlen;
            return {
                    "compression_method": cmp,
                    "general_flag": gen,
                    "compressed_size": csize,
                    "uncompressed_size": usize,
                    "name": name
                };
        }

        private static function AddImage(bytes:ByteArray, imageUrl:String):void
        {
            var ldr:Loader = null;
            var onBitmapComplete:Function = null;
            onBitmapComplete = function(event:Event):void
            {
                var bitmap:Bitmap = new Bitmap(event.currentTarget.content.bitmapData, "auto", true);
                ImageCache.imageobj[imageUrl] = bitmap;
                Util.RemoveEventListener(ldr.contentLoaderInfo, Event.COMPLETE, onBitmapComplete);
            };
            ldr = new Loader();
            Util.AddEventListener(ldr.contentLoaderInfo, Event.COMPLETE, onBitmapComplete);
            ldr.loadBytes(bytes);
        }

        private static function AddImageZip(zip:ByteArray, prefix:String):void
        {
            var file:ByteArray = null;
            zip.endian = Endian.LITTLE_ENDIAN;
            zip.position = 0;
            var header:Object = ReadZipHeader(zip);
            while (header)
            {
                file = new ByteArray();
                zip.readBytes(file, 0, header.compressed_size);
                if (header.compression_method == 8)
                {
                    file.inflate();
                }
                AddImage(file, prefix + header.name);
                if (header.general_flag & 4)
                {
                    zip.position += 12;
                }
                header = ReadZipHeader(zip);
            }
        }

        public function ImageCache()
        {
            super();
        }
    }
}
