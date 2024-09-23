package uibase {
		import flash.display.MovieClip;
		
		public class List extends MovieClip {
				public var B1:MovieClip;
				
				public var B2:MovieClip;
				
				public var B3:MovieClip;
				
				public var B4:MovieClip;
				
				public var B5:MovieClip;
				
				public var B6:MovieClip;
				
				public var B7:MovieClip;
				
				public var B8:MovieClip;
				
				public var CLINE1:NameSelectionCountryLine;
				
				public var CLINE2:NameSelectionCountryLine;
				
				public var CLINE3:NameSelectionCountryLine;
				
				public var CLINE4:NameSelectionCountryLine;
				
				public var CLINE5:NameSelectionCountryLine;
				
				public var S1:NameSuggSel;
				
				public var S2:NameSuggSel;
				
				public var S3:NameSuggSel;
				
				public var S4:NameSuggSel;
				
				public var S5:NameSuggSel;
				
				public var S6:NameSuggSel;
				
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

