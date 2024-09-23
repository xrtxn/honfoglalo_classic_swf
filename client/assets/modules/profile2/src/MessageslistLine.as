package {
		import flash.display.MovieClip;
		import syscode.AvatarMov;
		import uibase.lego_button_1x1_cancel;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol372")]
		public dynamic class MessageslistLine extends MovieClip {
				public var AVATAR:AvatarMov;
				
				public var BTN_DELETE:lego_button_1x1_cancel;
				
				public var CNAME:MovieClip;
				
				public var CTITLE:MovieClip;
				
				public var POSTBOXICON:LegoIconset;
				
				public function MessageslistLine() {
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

