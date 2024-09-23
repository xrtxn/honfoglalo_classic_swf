package skin_general_ui_default_fla {
		import flash.display.MovieClip;
		
		public dynamic class MainTimeline extends MovieClip {
				public var startWinHeaderFontcolor1:uint;
				
				public var startWinHeaderFontcolorLvls:uint;
				
				public function MainTimeline() {
						super();
						addFrameScript(0,this.frame1);
				}
				
				internal function frame1() : * {
						this.startWinHeaderFontcolor1 = 9070897;
						this.startWinHeaderFontcolorLvls = 16777215;
				}
		}
}

