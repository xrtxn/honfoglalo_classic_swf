package uibase
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import syscode.*;
	import uibase.components.UIButtonComponent;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol1276")]
	public class ConnectionLost extends MovieClip
	{
		public var BORDER:MovieClip;

		public var BTNCLOSE:UIButtonComponent;

		public var MESSAGE:TextField;

		public var params:Object;

		public var callbackfunc:Function = null;

		public var callbackparams:Array;

		public var yesnoresult:int = 0;

		public function ConnectionLost()
		{
			this.params = {};
			this.callbackparams = [];
			super();
			this.__setProp_BTNCLOSE_Connectionlost_Layer4_0();
		}

		public static function Show(amsg:String, acallbackfunc:Function = null):void
		{
			var par:Object = {};
			par.msg = amsg;
			par.callbackfunc = acallbackfunc;
			par.callbackparams = null;
			WinMgr.OpenWindow(ConnectionLost, par);
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
			this.BTNCLOSE.SetLang("reconnect");
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

		internal function __setProp_BTNCLOSE_Connectionlost_Layer4_0():*
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
