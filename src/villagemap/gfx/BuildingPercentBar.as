package villagemap.gfx
{
	import flash.display.MovieClip;

	[Embed(source="/modules/villagemap_assets.swf", symbol="symbol42")]
	public dynamic class BuildingPercentBar extends MovieClip
	{
		public var BAR:MovieClip;

		public function BuildingPercentBar()
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
