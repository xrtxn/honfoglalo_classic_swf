package
{
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.*;
	import flash.system.*;
	import flash.text.TextField;
	import flash.utils.*;

	public class loader11 extends MovieClip
	{
		public static const PROSTAT_PREFIX:String = "prostat_v11.php?cmd=";

		public var FATALTXT:TextField;

		public var GAMELOGO:MovieClip;

		public var LOADERS:MovieClip;

		public var LOADWAIT:MovieClip;

		public var PARTNERSLOGO:MovieClip;

		public var THXLOGO:MovieClip;

		public var rootmc:MovieClip = null;

		public var syscodemc:Object = null;

		public var bootparams:Object;

		public var loaderlist:Array;

		public var GPUINIT:MovieClip = null;

		public var loadedmodules:int = 0;

		public var cururl:String;

		// public var curpbmov:ModuleLoaderMov = null;

		public var curmodulename:String = "";

		public var onloadcallback:Function = null;

		public var loaderinfo:LoaderInfo = null;

		public var sourceurl:String;

		public var protocol:String;

		public var siteid:String = "??";

		public var loader:Loader;

		public var context:LoaderContext;

		public var request:URLRequest;

		public var prostatid:Number;

		public function loader11()
		{
			var i:int = 0;
			var m:MovieClip = null;
			var lid:String = null;
			this.bootparams = {
					"mobile": false,
					"assestsbaseurl": "client/assets/"
				};
			this.loaderlist = ["syscode", "clientparams", "lang", "fonts", "uibase", "basegfx", "villagemap", "triviador", "gpuinit"];
			super();
			this.Log("Loader11 constructor.");
		}

		public function Start(amc:MovieClip, abootparams:Object):*
		{
			this.rootmc = amc;
			this.bootparams = abootparams;
			this.loaderinfo = this.rootmc.root.loaderInfo;
			this.sourceurl = this.StringVal(this.loaderinfo.url);
			this.protocol = this.StringVal(this.sourceurl.split(":")[0]);
			this.siteid = this.StringVal(this.bootparams.siteid);
			this.prostatid = 0;
			if (this.siteid == "" && this.loaderinfo && Boolean(this.loaderinfo.parameters))
			{
				this.siteid = this.StringVal(this.loaderinfo.parameters.siteid);
				this.prostatid = this.NumberVal(this.loaderinfo.parameters.prostatid);
			}
			this.THXLOGO.visible = this.protocol.indexOf("http") == -1;
			this.PrepareGameLogo(this.siteid);
			this.PreparePartnersLogo(this.siteid);
			this.rootmc.stage.color = 5456434;
			this.rootmc.stage.scaleMode = "noScale";
			this.rootmc.stage.align = "topLeft";
			this.rootmc.stage.quality = "best";
			this.rootmc.stage.addEventListener(Event.RESIZE, this.OnStageResize);
			this.OnStageResize(null);
			this.Log("Starting loader...mobile: " + this.bootparams.mobile);
			this.rootmc.addChild(this);
			this.LOADWAIT.addEventListener(Event.ENTER_FRAME, this.OnEnterFrame);
			var syscode:String = null;
			if (Boolean(this.loaderinfo) && Boolean(this.loaderinfo.parameters))
			{
				syscode = this.StringVal(this.loaderinfo.parameters.syscode);
			}
			if (Boolean(syscode) && syscode.length > 0)
			{
				if (this.prostatid > 0)
				{
					this.ExtraRequest(loader11.PROSTAT_PREFIX + "loader_start&psid=" + this.prostatid);
				}
				this.LoadSWF("syscode", syscode, this.OnSysCodeLoaded);
			}
			else
			{
				this.LoadSWF("syscode", this.bootparams.appbaseurl + "assets/modules/01_syscode.swf", this.OnSysCodeLoaded);
			}
		}

		public function PrepareGameLogo(siteid:String):void
		{
			if (Boolean(siteid) && "|ar|bg|br|de|es|pl|ro|ru|si|tr|us|xa|xs|cz|hu|rs|fr|".indexOf(siteid) >= 0)
			{
				this.GAMELOGO.gotoAndStop(siteid);
			}
			else
			{
				this.GAMELOGO.gotoAndStop("xe");
			}
		}

		public function PreparePartnersLogo(siteid:String):void
		{
			this.PARTNERSLOGO.visible = Boolean(siteid) && "|es|pl|cz|".indexOf(siteid) >= 0;
			if (this.PARTNERSLOGO.visible)
			{
				this.PARTNERSLOGO.gotoAndStop(siteid);
			}
		}

		public function OnStageResize(e:*):*
		{
			var stw:Number = this.rootmc.stage.stageWidth;
			var sth:Number = this.rootmc.stage.stageHeight;
			this.THXLOGO.x = 14 / 800 * stw;
			this.THXLOGO.y = 14 / 480 * sth;
			this.PARTNERSLOGO.x = 779 / 800 * stw;
			this.PARTNERSLOGO.y = 22 / 480 * sth;
			this.GAMELOGO.y = (30 + 320 / 2) / 480 * sth - 320 / 2;
			this.GAMELOGO.x = stw / 2;
			this.FATALTXT.y = 80;
			this.FATALTXT.x = 0;
			this.FATALTXT.width = stw;
			this.LOADWAIT.x = stw / 2;
			this.LOADWAIT.y = sth / 2;
			this.LOADERS.x = stw / 2;
			this.LOADERS.y = sth * 0.8396;
		}

		public function OnEnterFrame(e:*):void
		{
			var pm:MovieClip = this.LOADWAIT.POINTERS;
			pm.SHORT.rotation += 1.5;
			pm.LONG.rotation += 6;
		}

		public function OnSysCodeLoaded(aswf:*):*
		{
			this.Log("loader11: SysCode loaded, passing control...");
			aswf.Start(this.rootmc, this, this.bootparams);
		}

		public function LoadSWF(modulename:String, url:String, callbackfunc:Function):void
		{
			this.Log("Loading module: " + modulename + " - " + url);
			this.cururl = url;
			this.onloadcallback = callbackfunc;
			this.sourceurl = this.StringVal(this.loaderinfo.url);
			this.protocol = this.StringVal(this.sourceurl.split(":")[0]);
			this.loader = new Loader();
			this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.OnCompleteHandler);
			this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.OnProgressHandler);
			this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.OnIOErrorHandler);
			this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.OnSecurityErrorHandler);
			this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.OnSecurityErrorHandler);
			var sd:SecurityDomain = null;
			var check:Boolean = false;
			if (this.protocol.indexOf("http") >= 0)
			{
				sd = SecurityDomain.currentDomain;
				check = true;
			}
			this.context = new LoaderContext(check, ApplicationDomain.currentDomain, sd);
			this.context.parameters = this.loaderinfo.parameters;
			this.request = new URLRequest(url);
			this.loader.load(this.request, this.context);
		}

		public function RemoveLoader():void
		{
			this.LOADWAIT.removeEventListener(Event.ENTER_FRAME, this.OnEnterFrame);
			this.rootmc.stage.removeEventListener(Event.RESIZE, this.OnStageResize);
			this.parent.removeChild(this);
		}

		private function OnCompleteHandler(event:Event):void
		{
			if (this.prostatid > 0)
			{
				this.ExtraRequest(loader11.PROSTAT_PREFIX + this.curmodulename + "&psid=" + this.prostatid);
			}
			this.onloadcallback(event.currentTarget.content);
		}

		private function OnProgressHandler(progress:ProgressEvent):void
		{
		}

		private function OnIOErrorHandler(event:IOErrorEvent):void
		{
			if (this.prostatid > 0)
			{
				this.ExtraRequest(loader11.PROSTAT_PREFIX + "ioerror&psid=" + this.prostatid);
			}
			this.FatalError("IO Error Loading " + this.cururl);
		}

		private function OnSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			if (this.prostatid > 0)
			{
				this.ExtraRequest(loader11.PROSTAT_PREFIX + "secerror&psid=" + this.prostatid);
			}
			this.FatalError("Security Error Loading " + this.cururl);
		}

		public function FatalError(astr:String):void
		{
			this.Log("Loader11 FATAL ERROR: " + astr);
			this.FATALTXT.text = astr;
			this.FATALTXT.visible = true;
		}

		private function Log(astr:String):void
		{
			trace(astr);
			if (ExternalInterface.available)
			{
				ExternalInterface.call("console.log", astr);
			}
		}

		private function ExtraRequest(_url:String):*
		{
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest(_url));
			return loader;
		}

		private function HexaStr(_str:String):String
		{
			var byte:uint = 0;
			var chars:ByteArray = new ByteArray();
			chars.writeUTFBytes("0123456789ABCDEF");
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes(_str);
			data.position = 0;
			var res:ByteArray = new ByteArray();
			while (data.bytesAvailable > 0)
			{
				byte = data.readUnsignedByte();
				res.writeByte(chars[byte >>> 4]);
				res.writeByte(chars[byte & 0x0F]);
			}
			res.position = 0;
			return res.readUTFBytes(res.bytesAvailable);
		}

		private function NumberVal(num:*, defval:* = 0):Number
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

		private function StringVal(str:*, defval:* = ""):String
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
	}
}
