package {
		import flash.display.MovieClip;
		import flash.text.TextField;
		import syscode.AvatarMov;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol68")]
		public dynamic class InviteUserSelect extends MovieClip {
				public var AVATAR:AvatarMov;
				
				public var CHECKBOX:MovieClip;
				
				public var NAME:TextField;
				
				public var SELECTED:MovieClip;
				
				public var STAMP:MovieClip;
				
				public function InviteUserSelect() {
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

