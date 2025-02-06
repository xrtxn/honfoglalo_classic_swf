package villagemap.gfx
{
	import flash.display.*;
	import flash.text.*;

	import uibase.components.UIBaseButtonComponent;

	[Embed(source="/modules/villagemap_assets.swf", symbol="symbol90")]
	public dynamic class InventoryTraceWin extends MovieClip
	{
		public var BTN:UIBaseButtonComponent;

		public var FIELD:TextField;

		public function InventoryTraceWin()
		{
			super();
			this.__setProp_BTN_inventorytracewin_Layer1_0();
		}

		internal function __setProp_BTN_inventorytracewin_Layer1_0():*
		{
			try
			{
				this.BTN["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.BTN.enabled = true;
			this.BTN.fontsize = "BIG";
			this.BTN.icon = "X";
			this.BTN.skin = "NORMAL";
			this.BTN.testcaption = "Test";
			this.BTN.visible = true;
			this.BTN.wordwrap = false;
			try
			{
				this.BTN["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}
	}
}
