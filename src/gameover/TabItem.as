package gameover
{
	import flash.display.MovieClip;
	import uibase.gfx.UIIconset;
	import gameover.compat.GameOverIconset;

	[Embed(source="/modules/gameover_assets.swf", symbol="symbol425")]
	public dynamic class TabItem extends MovieClip
	{
		public var FIELDMC:MovieClip;

		public var ICONSET:GameOverIconset;

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
