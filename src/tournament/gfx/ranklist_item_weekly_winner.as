package tournament.gfx
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import syscode.AvatarAnimMov;
	import uibase.CountryFlagMov;

	[Embed(source="/modules/tournament_assets.swf", symbol="symbol69")]
	public dynamic class ranklist_item_weekly_winner extends MovieClip
	{
		public var AVATAR:AvatarAnimMov;

		public var BG:MovieClip;

		public var CFLAG:CountryFlagMov;

		public var CNAME:TextField;

		public var COUNT:TextField;

		public var FLAG:MovieClip;

		public var FRAME:MovieClip;

		public var NAME:MovieClip;

		public var XP:MovieClip;

		public function ranklist_item_weekly_winner()
		{
			super();
		}
	}
}
