package tournament.gfx
{
	import flash.display.MovieClip;
	import syscode.LegoAvatarMov;
	import uibase.CountryFlagMov;

	[Embed(source="/modules/tournament_assets.swf", symbol="symbol91")]
	public dynamic class Ranklist_item_personal_line_4x1 extends MovieClip
	{
		public var AVATAR:LegoAvatarMov;

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
