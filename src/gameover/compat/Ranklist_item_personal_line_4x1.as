package gameover.compat
{
	import flash.display.MovieClip;
	import uibase.CountryFlagMov;

	[Embed(source="/modules/gameover_assets.swf", symbol="symbol354")]
	public dynamic class Ranklist_item_personal_line_4x1 extends MovieClip
	{
		public var AVATAR:AvatarMov;

		public var C_POSITION:MovieClip;

		public var FLAG:CountryFlagMov;

		public var HILITE:MovieClip;

		public var HIT:MovieClip;

		public var NAMEE:MovieClip;

		public var POSITION:MovieClip;

		public var XPCHANGE:MovieClip;

		public function Ranklist_item_personal_line_4x1()
		{
			super();
			addFrameScript(0, this.frame1, 1, this.frame2);
		}

		internal function frame1():*
		{
			stop();
		}

		internal function frame2():*
		{
			stop();
		}
	}
}
