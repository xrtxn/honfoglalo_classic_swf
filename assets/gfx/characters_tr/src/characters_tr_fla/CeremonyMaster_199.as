package characters_tr_fla {
		import flash.display.MovieClip;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol419")]
		public dynamic class CeremonyMaster_199 extends MovieClip {
				public var HAN:MovieClip;
				
				public var HEA:MovieClip;
				
				public function CeremonyMaster_199() {
						super();
						addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4,358,this.frame359);
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
				
				internal function frame359() : * {
						gotoAndPlay("DEFAULT");
				}
		}
}

