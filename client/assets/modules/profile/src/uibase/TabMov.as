package uibase {
		import flash.display.MovieClip;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol18")]
		public class TabMov extends MovieClip {
				public var TTAB1:MovieClip;
				
				public var TTAB2:MovieClip;
				
				public var current:int = 1;
				
				public var callback:Function = null;
				
				public var titles:Array;
				
				public var active:Boolean = true;
				
				public function TabMov() {
						this.titles = new Array();
						super();
				}
				
				public function Set(atitles:Array, acallback:Function) : void {
				}
				
				public function TabClicked(e:*) : void {
				}
				
				public function SetActiveTab(anum:*) : void {
				}
		}
}

