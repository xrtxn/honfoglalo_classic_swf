package {
		import flash.display.MovieClip;
		import flash.text.TextField;
		import uibase.CountryFlagMov;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol100")]
		public dynamic class NameSelectionCountryLine extends MovieClip {
				public var BTN:MovieClip;
				
				public var COUNTRYNAME:TextField;
				
				public var FLAG:CountryFlagMov;
				
				public var HILITE:MovieClip;
				
				public var XPCHANGE:TextField;
				
				public function NameSelectionCountryLine() {
						super();
				}
		}
}

