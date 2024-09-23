package syscode {
		import flash.display.MovieClip;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol165")]
		public dynamic class CheckBox extends MovieClip {
				public var CHECK:MovieClip;
				
				public function CheckBox() {
						super();
						addFrameScript(0,this.frame1);
				}
				
				internal function frame1() : * {
						stop();
				}
		}
}

