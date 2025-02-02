package tournament.gfx
{
	import flash.display.MovieClip;
	import uibase.CountryFlagMov;

	[Embed(source="/modules/tournament_assets.swf", symbol="symbol95")]
	public dynamic class Ranklist_item_country_line_4x1 extends MovieClip
	{
		public var COUNTRYNAME:MovieClip;

		public var FLAG:CountryFlagMov;

		public var HILITE:MovieClip;

		public var POSITION:MovieClip;

		public var XPCHANGE:MovieClip;

		public function Ranklist_item_country_line_4x1()
		{
			super();
			addFrameScript(0, this.frame1);
		}

		internal function frame1():*
		{
			stop();
		}
	}
}
