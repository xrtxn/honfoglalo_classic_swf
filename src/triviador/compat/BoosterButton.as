package triviador.compat
{
	import adobe.utils.*;
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
	import uibase.components.UICommonGfx;

	[Embed(source="/modules/triviador_assets.swf", symbol="symbol962")]
	public dynamic class BoosterButton extends MovieClip
	{
		public var BASE:MovieClip;

		public var LABEL:TextField;

		public var __id0_:UICommonGfx;

		public var __setPropDict:Dictionary;

		public function BoosterButton()
		{
			this.__setPropDict = new Dictionary(true);
			super();
			addFrameScript(4, this.frame5);
		}

		internal function __setProp___id0__helpbutton_label_4():*
		{
			if (this.__setPropDict[this.__id0_] == undefined || int(this.__setPropDict[this.__id0_]) != 5)
			{
				this.__setPropDict[this.__id0_] = 5;
				try
				{
					this.__id0_["componentInspectorSetting"] = true;
				}
				catch (e:Error)
				{
				}
				this.__id0_.enabled = true;
				this.__id0_.gfx = "lock";
				this.__id0_.visible = true;
				try
				{
					this.__id0_["componentInspectorSetting"] = false;
				}
				catch (e:Error)
				{
				}
			}
		}

		internal function frame5():*
		{
			this.__setProp___id0__helpbutton_label_4();
		}
	}
}
