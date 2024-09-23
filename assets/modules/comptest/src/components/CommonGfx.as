package components {
		import fl.core.UIComponent;
		import flash.display.MovieClip;
		import flash.geom.Rectangle;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol11")]
		public class CommonGfx extends UIComponent {
				public static var livepreview:Boolean = false;
				
				public var mc:MovieClip = null;
				
				public var origbounds:Rectangle = null;
				
				private var $gfx:String = "???";
				
				public function CommonGfx() {
						super();
				}
				
				public function DrawNow() : void {
						draw();
				}
				
				public function set gfx(gfxid:String) : void {
						draw();
				}
				
				public function get gfx() : String {
						return this.$gfx;
				}
		}
}

