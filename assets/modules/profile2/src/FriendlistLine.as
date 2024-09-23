package {
		import flash.display.MovieClip;
		import syscode.AvatarMov;
		import uibase.lego_button_1x1_cancel;
		import uibase.lego_button_1x1_ok;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol409")]
		public dynamic class FriendlistLine extends MovieClip {
				public var AVATAR:AvatarMov;
				
				public var BG:MovieClip;
				
				public var BTN_NO:lego_button_1x1_cancel;
				
				public var BTN_OK:lego_button_1x1_ok;
				
				public var CNAME:MovieClip;
				
				public var FBICON:MovieClip;
				
				public function FriendlistLine() {
						super();
						addFrameScript(0,this.frame1,1,this.frame2);
				}
				
				internal function frame1() : * {
						stop();
				}
				
				internal function frame2() : * {
						stop();
				}
		}
}

