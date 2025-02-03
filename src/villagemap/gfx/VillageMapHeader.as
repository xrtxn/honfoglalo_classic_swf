package villagemap.gfx
{
	import flash.display.*;
	import flash.text.*;

	import components.ButtonComponent;

	[Embed(source="/modules/villagemap_assets.swf", symbol="symbol158")]
	public dynamic class VillageMapHeader extends MovieClip
	{
		public var BG:MovieClip;

		public var BOX:MovieClip;

		// these are supposed to be ButtonComponent-s
		public var BTNPLUSENERGY:MovieClip;

		public var BTNPLUSGOLD:MovieClip;

		public var BTNSETTINGS:MovieClip;

		public var ENERGY:MovieClip;

		public var ENERGYTRANSPARENT:MovieClip;

		public var GOLD:TextField;

		public var GOLDTRANSPARENT:MovieClip;

		public var USERPROFILE:MovieClip;

		public var USERTRANSPARENT:MovieClip;

		public function VillageMapHeader()
		{
			super();
			this.__setProp_BTNPLUSGOLD_header_buttons_0();
			this.__setProp_BTNPLUSENERGY_header_buttons_0();
			this.__setProp_BTNSETTINGS_header_buttons_0();
		}

		internal function __setProp_BTNPLUSGOLD_header_buttons_0():*
		{
			try
			{
				this.BTNPLUSGOLD["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			// var btn:ButtonComponent = ButtonComponent(this.BTNPLUSGOLD);
			this.BTNPLUSGOLD.enabled = true;
			this.BTNPLUSGOLD.fontsize = "BIG";
			this.BTNPLUSGOLD.icon = "PLUS";
			this.BTNPLUSGOLD.skin = "OK";
			this.BTNPLUSGOLD.testcaption = "+";
			this.BTNPLUSGOLD.visible = true;
			this.BTNPLUSGOLD.wordwrap = false;
			try
			{
				this.BTNPLUSGOLD["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}

		internal function __setProp_BTNPLUSENERGY_header_buttons_0():*
		{
			try
			{
				this.BTNPLUSENERGY["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.BTNPLUSENERGY.enabled = true;
			this.BTNPLUSENERGY.fontsize = "BIG";
			this.BTNPLUSENERGY.icon = "PLUS";
			this.BTNPLUSENERGY.skin = "OK";
			this.BTNPLUSENERGY.testcaption = "+";
			this.BTNPLUSENERGY.visible = true;
			this.BTNPLUSENERGY.wordwrap = false;
			try
			{
				this.BTNPLUSENERGY["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}

		internal function __setProp_BTNSETTINGS_header_buttons_0():*
		{
			try
			{
				this.BTNSETTINGS["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.BTNSETTINGS.enabled = true;
			this.BTNSETTINGS.fontsize = "BIG";
			this.BTNSETTINGS.icon = "SETTINGS";
			this.BTNSETTINGS.skin = "NORMAL";
			this.BTNSETTINGS.testcaption = "S";
			this.BTNSETTINGS.visible = true;
			this.BTNSETTINGS.wordwrap = false;
			try
			{
				this.BTNSETTINGS["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}
	}
}
