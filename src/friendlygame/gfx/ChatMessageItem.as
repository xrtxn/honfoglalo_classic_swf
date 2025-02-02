package friendlygame.gfx
{
	import flash.display.MovieClip;
	import syscode.AvatarMov;

	[Embed(source="/modules/friendlygame_assets.swf", symbol="symbol393")]
	public dynamic class ChatMessageItem extends MovieClip
	{
		public var AVATAR:AvatarMov;

		public var AVATARFRAME:MovieClip;

		public var BG:MovieClip;

		public var SYSBG:MovieClip;

		public var SYSTEXT:MovieClip;

		public var TEXT:MovieClip;

		public function ChatMessageItem()
		{
			super();
		}
	}
}
