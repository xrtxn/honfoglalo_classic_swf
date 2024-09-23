package clan {
		import flash.display.MovieClip;
		import flash.text.TextField;
		import syscode.AvatarMov;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol24")]
		public dynamic class Visitorline extends MovieClip {
				public var AVATAR:AvatarMov;
				
				public var BG_ACTIVE:MovieClip;
				
				public var BG_INACTIVE:MovieClip;
				
				public var TXT_ACTIVE:TextField;
				
				public var TXT_INACTIVE:TextField;
				
				public var TXT_NAME:TextField;
				
				public function Visitorline() {
						super();
				}
		}
}

