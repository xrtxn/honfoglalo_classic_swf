package uibase {
		import flash.display.MovieClip;
		import ranklist.Ranklist_item_country_line_4x1;
		import ranklist.Ranklist_item_league_line_4x1;
		import ranklist.Ranklist_item_personal_line_4x1;
		
		public class List extends MovieClip {
				public var CLINE1:Ranklist_item_country_line_4x1;
				
				public var CLINE2:Ranklist_item_country_line_4x1;
				
				public var CLINE3:Ranklist_item_country_line_4x1;
				
				public var CLINE4:Ranklist_item_country_line_4x1;
				
				public var CLINE5:Ranklist_item_country_line_4x1;
				
				public var CLINE6:Ranklist_item_country_line_4x1;
				
				public var CLINE7:Ranklist_item_country_line_4x1;
				
				public var DLINE1:Ranklist_item_league_line_4x1;
				
				public var DLINE2:Ranklist_item_league_line_4x1;
				
				public var DLINE3:Ranklist_item_league_line_4x1;
				
				public var DLINE4:Ranklist_item_league_line_4x1;
				
				public var DLINE5:Ranklist_item_league_line_4x1;
				
				public var DLINE6:Ranklist_item_league_line_4x1;
				
				public var DLINE7:Ranklist_item_league_line_4x1;
				
				public var FLINE1:Ranklist_item_personal_line_4x1;
				
				public var FLINE2:Ranklist_item_personal_line_4x1;
				
				public var FLINE3:Ranklist_item_personal_line_4x1;
				
				public var FLINE4:Ranklist_item_personal_line_4x1;
				
				public var FLINE5:Ranklist_item_personal_line_4x1;
				
				public var FLINE6:Ranklist_item_personal_line_4x1;
				
				public var FLINE7:Ranklist_item_personal_line_4x1;
				
				public var PLINE1:Ranklist_item_personal_line_4x1;
				
				public var PLINE2:Ranklist_item_personal_line_4x1;
				
				public var PLINE3:Ranklist_item_personal_line_4x1;
				
				public var PLINE4:Ranklist_item_personal_line_4x1;
				
				public var PLINE5:Ranklist_item_personal_line_4x1;
				
				public var PLINE6:Ranklist_item_personal_line_4x1;
				
				public var PLINE7:Ranklist_item_personal_line_4x1;
				
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

