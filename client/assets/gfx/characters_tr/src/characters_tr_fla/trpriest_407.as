package characters_tr_fla {
		import flash.display.MovieClip;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol799")]
		public dynamic class trpriest_407 extends MovieClip {
				public var HAN:MovieClip;
				
				public var HEA:MovieClip;
				
				public var LEG:MovieClip;
				
				public function trpriest_407() {
						super();
						addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4,349,this.frame350);
				}
				
				internal function frame1() : * {
						this.HAN.gotoAndStop("1");
				}
				
				internal function frame2() : * {
						this.HAN.gotoAndStop("2");
				}
				
				internal function frame3() : * {
						this.HAN.gotoAndStop("3");
				}
				
				internal function frame4() : * {
						this.HAN.gotoAndStop("4");
				}
				
				internal function frame350() : * {
						gotoAndPlay("DEFAULT");
				}
		}
}

