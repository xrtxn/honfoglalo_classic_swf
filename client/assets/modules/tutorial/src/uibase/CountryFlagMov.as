package uibase {
		import flash.display.Bitmap;
		import flash.display.MovieClip;
		import flash.text.TextField;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol500")]
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
				
				public function Set(aflagid:String) : * {
				}
				
				public function OnFlagLoaded(bitmap:Bitmap, aflagid:String) : * {
				}
				
				public function Clear() : * {
				}
		}
}

