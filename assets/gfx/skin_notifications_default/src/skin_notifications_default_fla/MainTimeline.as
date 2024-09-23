package skin_notifications_default_fla {
		import flash.display.MovieClip;
		
		public dynamic class MainTimeline extends MovieClip {
				public var notifFontcolor1:uint;
				
				public function MainTimeline() {
						super();
						addFrameScript(0,this.frame1);
				}
				
				internal function frame1() : * {
						this.notifFontcolor1 = 3342336;
				}
		}
}

