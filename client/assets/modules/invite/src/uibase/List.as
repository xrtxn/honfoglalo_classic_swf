package uibase {
		import flash.display.MovieClip;
		
		public class List extends MovieClip {
				public var ITEM1:InviteUserSelect;
				
				public var ITEM10:InviteUserSelect;
				
				public var ITEM11:InviteUserSelect;
				
				public var ITEM12:InviteUserSelect;
				
				public var ITEM2:InviteUserSelect;
				
				public var ITEM3:InviteUserSelect;
				
				public var ITEM4:InviteUserSelect;
				
				public var ITEM5:InviteUserSelect;
				
				public var ITEM6:InviteUserSelect;
				
				public var ITEM7:InviteUserSelect;
				
				public var ITEM8:InviteUserSelect;
				
				public var ITEM9:InviteUserSelect;
				
				public var S1:Item2_class;
				
				public var S2:Item2_class;
				
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

