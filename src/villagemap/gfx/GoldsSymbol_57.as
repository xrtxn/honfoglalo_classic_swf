package villagemap.gfx
{
	import flash.display.*;

	import uibase.components.UICommonGfx;

	[Embed(source="/modules/villagemap_assets.swf", symbol="symbol56")]
	public dynamic class GoldsSymbol_57 extends MovieClip
	{
		public var __id2_:UICommonGfx;

		public function GoldsSymbol_57()
		{
			super();
			this.__setProp___id2__GoldsSymbol_Layer2_0();
		}

		internal function __setProp___id2__GoldsSymbol_Layer2_0():*
		{
			try
			{
				this.__id2_["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.__id2_.enabled = true;
			this.__id2_.gfx = "gold";
			this.__id2_.visible = true;
			try
			{
				this.__id2_["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}
	}
}
