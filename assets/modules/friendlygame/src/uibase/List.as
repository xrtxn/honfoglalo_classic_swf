package uibase {
		import flash.display.MovieClip;
		import friendlygame.FriendlyGameItem;
		
		public class List extends MovieClip {
				public var ITEM1:UserAddClass;
				
				public var ITEM2:UserAddClass;
				
				public var ITEM3:UserAddClass;
				
				public var ITEM4:UserAddClass;
				
				public var ITEM5:UserAddClass;
				
				public var ITEM6:UserAddClass;
				
				public var ITEM7:UserAddClass;
				
				public var ROOM1:FriendlyGameItem;
				
				public var ROOM2:FriendlyGameItem;
				
				public var ROOM3:FriendlyGameItem;
				
				public var ROOM4:FriendlyGameItem;
				
				public var ROOM5:FriendlyGameItem;
				
				public var ROOM6:FriendlyGameItem;
				
				public var ROOM7:FriendlyGameItem;
				
				public var ROOM8:FriendlyGameItem;
				
				public var ROOM9:FriendlyGameItem;
				
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

