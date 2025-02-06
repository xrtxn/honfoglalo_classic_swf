package villagemap.gfx
{
	import flash.display.*;

	import uibase.components.UIBaseButtonComponent;

	[Embed(source="/modules/villagemap_assets.swf", symbol="symbol98")]
	public dynamic class Inventory extends MovieClip
	{
		public var BG:MovieClip;

		public var MASKHOLDER:MovieClip;

		public var PAGELEFT:UIBaseButtonComponent;

		public var PAGERIGHT:UIBaseButtonComponent;

		public function Inventory()
		{
			super();
			this.__setProp_PAGELEFT_inventory_buttons_0();
			this.__setProp_PAGERIGHT_inventory_buttons_0();
		}

		internal function __setProp_PAGELEFT_inventory_buttons_0():*
		{
			try
			{
				this.PAGELEFT["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.PAGELEFT.enabled = true;
			this.PAGELEFT.fontsize = "BIG";
			this.PAGELEFT.icon = "LEFT";
			this.PAGELEFT.skin = "NORMAL";
			this.PAGELEFT.testcaption = "Test";
			this.PAGELEFT.visible = true;
			this.PAGELEFT.wordwrap = false;
			try
			{
				this.PAGELEFT["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}

		internal function __setProp_PAGERIGHT_inventory_buttons_0():*
		{
			try
			{
				this.PAGERIGHT["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.PAGERIGHT.enabled = true;
			this.PAGERIGHT.fontsize = "BIG";
			this.PAGERIGHT.icon = "RIGHT";
			this.PAGERIGHT.skin = "NORMAL";
			this.PAGERIGHT.testcaption = "Test";
			this.PAGERIGHT.visible = true;
			this.PAGERIGHT.wordwrap = false;
			try
			{
				this.PAGERIGHT["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}
	}
}
