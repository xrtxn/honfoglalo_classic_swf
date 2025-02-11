package gameover
{
	import flash.display.MovieClip;
	import uibase.gfx.UIIconset;

	[Embed(source="/modules/gameover_assets.swf", symbol="symbol425")]
	public dynamic class TabItem extends MovieClip
	{
		public var FIELDMC:MovieClip;

		// likely custom class
		public var ICONSET:UIIconset;

		public var NOTIFY:MovieClip;

		public var VALUEMC:MovieClip;

		public function TabItem()
		{
			super();
			addFrameScript(0, this.frame1, 9, this.frame10);
		}

		internal function frame1():*
		{
			stop();
		}

		internal function frame10():*
		{
			stop();
		}
	}
}
