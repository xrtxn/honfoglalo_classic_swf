package villagemap.gfx
{
	import flash.display.*;

	import uibase.components.UIButtonComponent;

	[Embed(source="/modules/villagemap_assets.swf", symbol="symbol159")]
	public dynamic class grideditmc_31 extends MovieClip
	{
		public var GRIDEDITBUTTON:UIButtonComponent;

		public function grideditmc_31()
		{
			super();
			this.__setProp_GRIDEDITBUTTON_grideditmc_Layer1_0();
		}

		internal function __setProp_GRIDEDITBUTTON_grideditmc_Layer1_0():*
		{
			try
			{
				this.GRIDEDITBUTTON["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.GRIDEDITBUTTON.enabled = true;
			this.GRIDEDITBUTTON.fontsize = "BIG";
			this.GRIDEDITBUTTON.icon = "EDIT";
			this.GRIDEDITBUTTON.skin = "NORMAL";
			this.GRIDEDITBUTTON.testcaption = "S";
			this.GRIDEDITBUTTON.visible = true;
			this.GRIDEDITBUTTON.wordwrap = false;
			try
			{
				this.GRIDEDITBUTTON["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}
	}
}
