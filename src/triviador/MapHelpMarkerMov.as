package triviador
{
	import flash.display.MovieClip;
	import syscode.Util;

	[Embed(source="/modules/triviador_assets.swf", symbol="symbol1318")]
	public class MapHelpMarkerMov extends MovieClip
	{
		public var helptype:String = "";

		public var helpprice:int = -1;

		public var active:Boolean = true;

		public function MapHelpMarkerMov()
		{
			super();
			Util.StopAllChildrenMov(this);
		}

		public function Show(atype:String, aprice:int):*
		{
			this.helptype = atype;
			this.helpprice = aprice;
			this.gotoAndStop(this.helptype);
			this.active = true;
			this.visible = false;
		}

		public function Hide():*
		{
			this.active = false;
			this.visible = false;
		}
	}
}
