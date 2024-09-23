package {
		import flash.display.MovieClip;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol595")]
		public dynamic class BummAnim extends MovieClip {
				public function BummAnim() {
						super();
						addFrameScript(17,this.frame18);
				}
				
				internal function frame18() : * {
						stop();
						parent.removeChild(this);
				}
		}
}

