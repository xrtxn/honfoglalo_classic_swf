package skin_village_default_fla {
		import flash.display.MovieClip;
		
		public dynamic class MainTimeline extends MovieClip {
				public var headerFontcolor1:uint;
				
				public var headerFontcolorLvls:uint;
				
				public var headerEnergyTimer:uint;
				
				public var headerXpPoints:uint;
				
				public function MainTimeline() {
						super();
						addFrameScript(0,this.frame1);
				}
				
				internal function frame1() : * {
						this.headerFontcolor1 = 8939568;
						this.headerFontcolorLvls = 16777215;
						this.headerEnergyTimer = 16777215;
						this.headerXpPoints = 7427906;
				}
		}
}

