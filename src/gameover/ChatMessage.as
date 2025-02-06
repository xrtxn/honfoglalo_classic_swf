package gameover
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import syscode.AvatarMov;

	[Embed(source="/modules/gameover_assets.swf", symbol="symbol599")]
	public dynamic class ChatMessage extends MovieClip
	{
		public var AVATAR:AvatarMov;

		public var DOT:MovieClip;

		public var TEXT:TextField;

		public function ChatMessage()
		{
			super();
		}
	}
}
