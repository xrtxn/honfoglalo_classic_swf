package uibase {
		import flash.display.MovieClip;
		
		public class List extends MovieClip {
				public var LINE1:mailitem2;
				
				public var LINE2:mailitem2;
				
				public var LINE3:mailitem2;
				
				public var LINE4:mailitem2;
				
				public var LINE5:mailitem2;
				
				public var LINE6:mailitem2;
				
				public var scrollrect:MovieClip;
				
				public var scrollbar:ScrollBarMov;
				
				public var prefix:*;
				
				public var columns:int;
				
				public var itemheight:int;
				
				public var pagesize:Number;
				
				public var first:int = 0;
				
				public var pos:Number = 0;
				
				public var items:Array = null;
				
				public var pool:Array;
				
				public var mc:MovieClip = null;
				
				public var click_func:Function = null;
				
				public var draw_func:Function = null;
				
				public var no_events:Boolean = false;
				
				public function List() {
						this.pool = [];
						super();
				}
				
				public function Set(prefix:*, list:Array, itemheight:int, columns:int = 1, clickfunc:Function = null, drawfunc:Function = null, scrollrect:MovieClip = null, scrollbar:ScrollBarMov = null) : * {
				}
				
				public function SetScrollBar(scrollbar:ScrollBarMov) : void {
				}
				
				public function GetVisibleItem(id:*) : * {
				}
				
				public function Hover(id:*) : * {
				}
				
				public function SetItems(list:*, reset:* = true) : * {
				}
				
				public function Draw(refresh:* = true) : * {
				}
				
				public function UnSet() : * {
				}
		}
}

