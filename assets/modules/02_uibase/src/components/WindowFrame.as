package components {
		import fl.core.UIComponent;
		import flash.display.MovieClip;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol398")]
		public class WindowFrame extends UIComponent {
				public static var livepreview:Boolean = false;
				
				public var BG:MovieClip = null;
				
				public function WindowFrame() {
						super();
				}
				
				override protected function configUI() : void {
						super.configUI();
						this.BG = new WindowFrameGraphics();
						addChildAt(this.BG,0);
				}
		}
}

