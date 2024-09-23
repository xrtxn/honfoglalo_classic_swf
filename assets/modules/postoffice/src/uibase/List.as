package uibase {
		import flash.display.MovieClip;
		
		public class List extends MovieClip {
				public var ITEM1:UserSelect;
				
				public var ITEM10:UserSelect;
				
				public var ITEM2:UserSelect;
				
				public var ITEM3:UserSelect;
				
				public var ITEM4:UserSelect;
				
				public var ITEM5:UserSelect;
				
				public var ITEM6:UserSelect;
				
				public var ITEM7:UserSelect;
				
				public var ITEM8:UserSelect;
				
				public var ITEM9:UserSelect;
				
				public var LINE1:mailitem;
				
				public var LINE2:mailitem;
				
				public var LINE3:mailitem;
				
				public var LINE4:mailitem;
				
				public var LINE5:mailitem;
				
				public var LINE6:mailitem;
				
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

