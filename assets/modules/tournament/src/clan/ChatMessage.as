package clan {
		import flash.display.MovieClip;
		import syscode.AvatarMov;
		import uibase.lego_button_2x1_ok;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol369")]
		public dynamic class ChatMessage extends MovieClip {
				public var AVATAR:AvatarMov;
				
				public var BG:MovieClip;
				
				public var DAY:MovieClip;
				
				public var MANAGE:lego_button_2x1_ok;
				
				public var SYSBG:MovieClip;
				
				public var SYSTEXT:MovieClip;
				
				public var TEXT:MovieClip;
				
				public function ChatMessage() {
						super();
						addFrameScript(0,this.frame1);
				}
				
				internal function frame1() : * {
						stop();
				}
		}
}

