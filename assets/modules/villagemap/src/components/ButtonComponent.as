package components {
		import fl.core.UIComponent;
		import flash.display.MovieClip;
		import flash.display.Sprite;
		import flash.text.TextField;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol89")]
		public class ButtonComponent extends UIComponent {
				public static var livepreview:Boolean = false;
				
				public var logfunc:Function = null;
				
				public var SHAPE:MovieClip = null;
				
				public var CAPTION:TextField = null;
				
				public var CONTAINER:Sprite = null;
				
				public var btnenabled:Boolean = true;
				
				private var $skin:String = "NORMAL";
				
				private var $fontsize:String = "BIG";
				
				private var $testcaption:String = "Test";
				
				private var $icon:String = "";
				
				private var $wordwrap:Boolean = false;
				
				public function ButtonComponent() {
						super();
				}
				
				public function DrawNow() : void {
				}
				
				public function SetCaption(astr:String) : void {
				}
				
				public function SetLang(aid:String, apar1:* = undefined, apar2:* = undefined, apar3:* = undefined, apar4:* = undefined) : void {
				}
				
				public function SetLangAndClick(aid:String, afunc:Function, aparams:Object = null) : void {
				}
				
				public function SetEnabled(aenabled:Boolean) : void {
				}
				
				public function AddEventClick(afunc:Function, aparams:Object = null) : void {
				}
				
				override protected function draw() : void {
				}
				
				private function DrawCaption() : void {
				}
				
				private function DrawShape() : void {
				}
				
				public function Activate() : void {
				}
				
				public function InActivate() : void {
				}
				
				public function set testcaption(_txt:String) : void {
						this.$testcaption = _txt;
						this.DrawCaption();
				}
				
				public function get testcaption() : String {
						return this.$testcaption;
				}
				
				public function set icon(_icon:String) : void {
						this.$icon = _icon;
						this.DrawCaption();
				}
				
				public function get icon() : String {
						return this.$icon;
				}
				
				public function set skin(_txt:String) : void {
						this.$skin = _txt;
						this.draw();
				}
				
				public function get skin() : String {
						return this.$skin;
				}
				
				public function set fontsize(_txt:String) : void {
						this.$fontsize = _txt;
						this.DrawCaption();
				}
				
				public function get fontsize() : String {
						return this.$fontsize;
				}
				
				public function set wordwrap(b:Boolean) : void {
						this.$wordwrap = b;
						this.DrawCaption();
				}
				
				public function get wordwrap() : Boolean {
						return this.$wordwrap;
				}
		}
}

