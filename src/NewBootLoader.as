package
{
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;

	public class NewBootLoader extends MovieClip
	{
		internal static var sourceurl:String;

		internal static var protocol:String;

		internal static var loader:Loader;

		internal static var context:LoaderContext;

		internal static var request:URLRequest;

		internal static var mc:MovieClip = null;

		internal static var bootparams:Object = false;

		internal static var loaderinfo:LoaderInfo = null;

		internal static var loadermc:Object = null;

		public static var xsolla_currency:String = "";

		public function NewBootLoader()
		{
			super();
		}

		public static function StartBoot(param1:MovieClip, param2:Object):void
		{
			mc = param1;
			bootparams = param2;
			mc.stage.scaleMode = StageScaleMode.NO_SCALE;
			mc.stage.align = StageAlign.TOP_LEFT;
			mc.stage.quality = StageQuality.BEST;
			Log("BootLoader started. Mobile=" + bootparams.mobile);
			loaderinfo = param1.root.loaderInfo;
			StartLoader("../src/loader11.swf");
		}

		private static function StartLoader(param1:String):void
		{
			Log("Loading: " + param1);
			sourceurl = StringVal(loaderinfo.url);
			protocol = StringVal(sourceurl.split(":")[0]);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, OnIOErrorHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnSecurityErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnSecurityErrorHandler);
			var _loc2_:SecurityDomain = null;
			var _loc3_:Boolean = false;
			if (protocol.indexOf("http") >= 0)
			{
				_loc2_ = SecurityDomain.currentDomain;
				_loc3_ = true;
			}
			context = new LoaderContext(_loc3_, ApplicationDomain.currentDomain, _loc2_);
			context.allowCodeImport = true;
			context.parameters = loaderinfo.parameters;
			if (Boolean(loaderinfo) && Boolean(loaderinfo.parameters))
			{
				param1 = StringVal(loaderinfo.parameters.clienturl, param1);
			}
			request = new URLRequest(param1);
			loader.load(request, context);
		}

		private static function OnCompleteHandler(param1:Event):void
		{
			Log("BootLoader: OnCompleteHandler");
			loadermc = param1.currentTarget.content;
			loadermc.Start(mc, bootparams);
			// this possibly creates a race condition
			var syscode1:syscode = new syscode();
			syscode1.Start(mc, loadermc as MovieClip, bootparams);
		}

		private static function OnIOErrorHandler(param1:IOErrorEvent):void
		{
			Log("BootLoader: IO Error Loading the Loader!");
		}

		private static function OnSecurityErrorHandler(param1:SecurityErrorEvent):void
		{
			Log("BootLoader: Security Error Loading the Loader!");
		}

		private static function Log(param1:String):void
		{
			trace(param1);
			if (ExternalInterface.available)
			{
				ExternalInterface.call("console.log", param1);
			}
			var _loc2_:* = mc.getChildByName("BLINFO");
			if (!_loc2_)
			{
				return;
			}
			_loc2_.text = param1;
		}

		private static function StringVal(param1:*, param2:* = ""):String
		{
			if (param1 !== undefined && param1 != null)
			{
				return String(param1);
			}
			if (typeof param2 == "string")
			{
				return param2;
			}
			return "";
		}
	}
}
