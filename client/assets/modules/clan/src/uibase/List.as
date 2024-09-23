package uibase {
		import Clan.Symbol24copy;
		import clan.Listline;
		import clan.MemberlistLine;
		import clan.Visitorline;
		import clan.clanshielditem;
		import flash.display.MovieClip;
		
		public class List extends MovieClip {
				public var FLINE_1:Symbol24copy;
				
				public var FLINE_2:Symbol24copy;
				
				public var FLINE_3:Symbol24copy;
				
				public var FLINE_4:Symbol24copy;
				
				public var LINE1:Visitorline;
				
				public var LINE2:Visitorline;
				
				public var LINE3:Visitorline;
				
				public var LINE4:Visitorline;
				
				public var LINE5:Visitorline;
				
				public var LINE6:Visitorline;
				
				public var LINE_1:Listline;
				
				public var LINE_2:Listline;
				
				public var LINE_3:Listline;
				
				public var LINE_4:Listline;
				
				public var LINE_5:Listline;
				
				public var LINE_6:Listline;
				
				public var MLINE1:MemberlistLine;
				
				public var MLINE2:MemberlistLine;
				
				public var MLINE3:MemberlistLine;
				
				public var MLINE4:MemberlistLine;
				
				public var MLINE5:MemberlistLine;
				
				public var MLINE6:MemberlistLine;
				
				public var MLINE7:MemberlistLine;
				
				public var S1:clanshielditem;
				
				public var S10:clanshielditem;
				
				public var S11:clanshielditem;
				
				public var S12:clanshielditem;
				
				public var S2:clanshielditem;
				
				public var S3:clanshielditem;
				
				public var S4:clanshielditem;
				
				public var S5:clanshielditem;
				
				public var S6:clanshielditem;
				
				public var S7:clanshielditem;
				
				public var S8:clanshielditem;
				
				public var S9:clanshielditem;
				
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

