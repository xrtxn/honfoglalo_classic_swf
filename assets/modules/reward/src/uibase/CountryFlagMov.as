package uibase {
		import flash.display.Bitmap;
		import flash.display.MovieClip;
		import flash.text.TextField;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol514")]
		public class CountryFlagMov extends MovieClip {
				public var IDTEXT:TextField;
				
				public var PLACE:MovieClip;
				
				public var SHADER:MovieClip;
				
				public var currentid:String = "";
				
				public var currentbitmap:Bitmap = null;
				
				public var flagloaded:Boolean = false;
				
				public function CountryFlagMov() {
						super();
				}
				
				public function Set(param1:String) : * {
				}
				
				public function OnFlagLoaded(param1:Bitmap, param2:String) : * {
				}
				
				public function Clear() : * {
				}
		}
}

