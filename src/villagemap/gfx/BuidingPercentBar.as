package villagemap.gfx
{
	import flash.display.MovieClip;

	[Embed(source="/modules/villagemap_assets.swf", symbol="symbol42")]
	public dynamic class BuidingPercentBar extends MovieClip
	{
		public var BAR:MovieClip;

		public function BuidingPercentBar()
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
