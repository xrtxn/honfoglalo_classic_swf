package villagemap.gfx
{
	import flash.display.*;

	import villagemap.compat.VillagemapCommonGfx;

	[Embed(source="/modules/villagemap_assets.swf", symbol="symbol131")]
	public dynamic class GoldsSymbol_11 extends MovieClip
	{
		public var __id0_:VillagemapCommonGfx;

		public function GoldsSymbol_11()
		{
			super();
			this.__setProp___id0__GoldsSymbol_Layer2_0();
		}

		internal function __setProp___id0__GoldsSymbol_Layer2_0():*
		{
			try
			{
				this.__id0_["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.__id0_.enabled = true;
			this.__id0_.gfx = "gold";
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
}
