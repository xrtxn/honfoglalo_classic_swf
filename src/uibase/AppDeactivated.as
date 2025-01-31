package uibase
{
	import components.ButtonComponent;
	import components.CharacterComponent;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol1248")]
	public class AppDeactivated extends MovieClip
	{
		public static var mc:AppDeactivated = null;

		public var BORDER:MovieClip;

		public var BTNCLOSE:ButtonComponent;

		public var MESSAGE:TextField;

		public var __id0_:CharacterComponent;

		public var params:Object;

		public var callbackfunc:Function = null;

		public var callbackparams:Array;

		public var yesnoresult:int = 0;

		public function AppDeactivated()
		{
			this.params = {};
			this.callbackparams = [];
			super();
			this.__setProp___id0__AppDeactivated_Layer5_0();
			this.__setProp_BTNCLOSE_AppDeactivated_Layer4_0();
		}

		public static function Show(amsg:String, acallbackfunc:Function = null):void
		{
			var par:Object = {};
			par.msg = amsg;
			par.callbackfunc = acallbackfunc;
			par.callbackparams = null;
			WinMgr.OpenWindow(AppDeactivated, par);
		}

		public function Prepare(aparams:Object):void
		{
			this.params = aparams;
			trace("Preparing message window \"" + this.params.msg + "\"");
			Util.SetText(this.MESSAGE, this.params.msg);
			if (this.params.callbackfunc)
			{
				this.callbackfunc = this.params.callbackfunc;
				if (this.params.callbackparams)
				{
					this.callbackparams = this.params.callbackparams;
				}
				else
				{
					this.callbackparams = [];
				}
			}
			this.BTNCLOSE.SetLang("okay");
			this.BTNCLOSE.AddEventClick(this.OnClose);
		}

		public function AfterClose():void
		{
			if (this.callbackfunc != null)
			{
				this.callbackfunc.apply(null, this.callbackparams);
			}
		}

		private function OnClose(e:*):*
		{
			WinMgr.CloseWindow(this);
		}

		internal function __setProp___id0__AppDeactivated_Layer5_0():*
		{
			try
			{
				this.__id0_["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.__id0_.character = "KING";
			this.__id0_.enabled = true;
			this.__id0_.frame = 1;
			this.__id0_.shade = false;
			this.__id0_.shadow = false;
			this.__id0_.visible = true;
			try
			{
				this.__id0_["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}

		internal function __setProp_BTNCLOSE_AppDeactivated_Layer4_0():*
		{
			try
			{
				this.BTNCLOSE["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.BTNCLOSE.enabled = true;
			this.BTNCLOSE.fontsize = "BIG";
			this.BTNCLOSE.icon = "";
			this.BTNCLOSE.skin = "OK";
			this.BTNCLOSE.testcaption = "OK";
			this.BTNCLOSE.visible = true;
			this.BTNCLOSE.wordwrap = false;
			try
			{
				this.BTNCLOSE["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}
	}
}
