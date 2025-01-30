package
{
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;
	import syscode.AvatarFactory;

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
			StartLoader("loader11");
		}

		private static function StartLoader(param1:String):void
		{
			Log("Loading: " + param1);
			// var loader:loader11 = new loader11();
			// loader.Start(mc, bootparams);
			var syscode1: syscode = new syscode();
			trace("syscode1: " + syscode1);
			syscode1.Start(mc, bootparams);
		}

		private static function OnCompleteHandler(param1:Event):void
		{
			Log("BootLoader: OnCompleteHandler");
			loadermc = param1.currentTarget.content;
			loadermc.Start(mc, bootparams);
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
