package components {
		import fl.core.UIComponent;
		import flash.display.MovieClip;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol8")]
		public class CharacterComponent extends UIComponent {
				public var mc:MovieClip;
				
				private var $character:String = "KING";
				
				private var $frame:Number = 1;
				
				private var $shadow:Boolean = true;
				
				private var $shade:Boolean = true;
				
				public function CharacterComponent() {
						super();
				}
				
				public function DrawNow() : void {
				}
				
				public function DoEmotion(emotion:String = "default") : void {
				}
				
				public function set character(s:String) : void {
						this.$character = s;
						draw();
				}
				
				public function get character() : String {
						return this.$character;
				}
				
				public function set frame(n:Number) : void {
						this.$frame = n;
						draw();
				}
				
				public function get frame() : Number {
						return this.$frame;
				}
				
				public function set shade(b:Boolean) : void {
						this.$shade = b;
						draw();
				}
				
				public function get shade() : Boolean {
						return this.$shade;
				}
				
				public function set shadow(b:Boolean) : void {
						this.$shadow = b;
						draw();
				}
				
				public function get shadow() : Boolean {
						return this.$shadow;
				}
		}
}

