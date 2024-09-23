package uibase {
		import flash.display.MovieClip;
		
		public class HeaderTabs extends MovieClip {
				public var TTAB1:MovieClip;
				
				public var TTAB2:MovieClip;
				
				public var TTAB3:MovieClip;
				
				public var TTAB4:MovieClip;
				
				public var current:int = 1;
				
				public var callback:Function = null;
				
				public var titles:Array;
				
				public var icons:Array;
				
				public var active:Boolean = true;
				
				public var animating:Boolean = false;
				
				public function HeaderTabs() {
						this.titles = new Array();
						this.icons = new Array();
						super();
				}
				
				public function Set(atitles:Array, aicons:Array, acallback:Function, selected:int = 0) : void {
				}
				
				public function Reorder(newOrder:Array = null, visibilities:Array = null) : void {
				}
				
				public function TabClicked(e:*) : void {
				}
				
				public function SetActiveTab(clickedmc:MovieClip) : void {
				}
				
				public function FreeTabBitmaps() : void {
				}
				
				public function Notify(tab:MovieClip, active:Boolean, text:String = "!") : void {
				}
				
				public function SetValue(tab:MovieClip, value:String) : void {
				}
				
				public function LockTab(tab:MovieClip) : void {
				}
				
				public function UnlockTab(tab:MovieClip) : void {
				}
		}
}

