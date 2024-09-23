package knightgame_fla {
		import flash.display.MovieClip;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol184")]
		public dynamic class leftknightmc_27 extends MovieClip {
				public var DUST1:MovieClip;
				
				public var DUST2:MovieClip;
				
				public var MOUNT:MovieClip;
				
				public function leftknightmc_27() {
						super();
						addFrameScript(0,this.frame1,12,this.frame13,91,this.frame92);
				}
				
				internal function frame1() : * {
						stop();
				}
				
				internal function frame13() : * {
						gotoAndPlay("RUN");
				}
				
				internal function frame92() : * {
						gotoAndPlay("BIRDY");
				}
		}
}

