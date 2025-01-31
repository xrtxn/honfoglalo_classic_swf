package uibase
{
	import adobe.utils.*;
	import components.ButtonComponent;
	import flash.accessibility.*;
	import flash.desktop.*;
	import flash.display.*;
	import flash.errors.*;
	import flash.events.*;
	import flash.external.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.globalization.*;
	import flash.media.*;
	import flash.net.*;
	import flash.net.drm.*;
	import flash.printing.*;
	import flash.profiler.*;
	import flash.sampler.*;
	import flash.sensors.*;
	import flash.system.*;
	import flash.text.*;
	import flash.text.engine.*;
	import flash.text.ime.*;
	import flash.ui.*;
	import flash.utils.*;
	import flash.xml.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol80")]
	public dynamic class StatInfo extends MovieClip
	{
		public var LEFT:ButtonComponent;

		public var NUM:TextField;

		public var RESET:ButtonComponent;

		public var RIGHT:ButtonComponent;

		public var TEXT:TextField;

		public function StatInfo()
		{
			super();
			this.__setProp_RIGHT_StatInfo_Layer1_0();
			this.__setProp_LEFT_StatInfo_Layer1_0();
			this.__setProp_RESET_StatInfo_Layer1_0();
		}

		internal function __setProp_RIGHT_StatInfo_Layer1_0():*
		{
			try
			{
				this.RIGHT["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.RIGHT.enabled = true;
			this.RIGHT.fontsize = "BIG";
			this.RIGHT.icon = "RIGHT";
			this.RIGHT.skin = "NORMAL";
			this.RIGHT.testcaption = "";
			this.RIGHT.visible = true;
			this.RIGHT.wordwrap = false;
			try
			{
				this.RIGHT["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}

		internal function __setProp_LEFT_StatInfo_Layer1_0():*
		{
			try
			{
				this.LEFT["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.LEFT.enabled = true;
			this.LEFT.fontsize = "BIG";
			this.LEFT.icon = "LEFT";
			this.LEFT.skin = "NORMAL";
			this.LEFT.testcaption = "";
			this.LEFT.visible = true;
			this.LEFT.wordwrap = false;
			try
			{
				this.LEFT["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}

		internal function __setProp_RESET_StatInfo_Layer1_0():*
		{
			try
			{
				this.RESET["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.RESET.enabled = true;
			this.RESET.fontsize = "BIG";
			this.RESET.icon = "X";
			this.RESET.skin = "NORMAL";
			this.RESET.testcaption = "";
			this.RESET.visible = true;
			this.RESET.wordwrap = false;
			try
			{
				this.RESET["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}
	}
}
