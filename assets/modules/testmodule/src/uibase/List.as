package uibase {
		import flash.display.MovieClip;
		
		public class List extends MovieClip {
				public var ITEM1:Item1_class;
				
				public var ITEM10:Item1_class;
				
				public var ITEM11:Item1_class;
				
				public var ITEM12:Item1_class;
				
				public var ITEM13:Item1_class;
				
				public var ITEM14:Item1_class;
				
				public var ITEM15:Item1_class;
				
				public var ITEM16:Item1_class;
				
				public var ITEM17:Item1_class;
				
				public var ITEM18:Item1_class;
				
				public var ITEM2:Item1_class;
				
				public var ITEM3:Item1_class;
				
				public var ITEM4:Item1_class;
				
				public var ITEM5:Item1_class;
				
				public var ITEM6:Item1_class;
				
				public var ITEM7:Item1_class;
				
				public var ITEM8:Item1_class;
				
				public var ITEM9:Item1_class;
				
				public var S1:Item2_class;
				
				public var S2:Item2_class;
				
				public var prefix:*;
				
				public var click_func:MovieClip;
				
				public var columns:int;
				
				public var itemheight:int;
				
				internal var first:int = 0;
				
				internal var pos:Number = 0;
				
				internal var mc:MovieClip;
				
				internal var draw_func:Function = null;
				
				public function List() {
						super();
				}
				
				public function Set(prefix:*, list:Array, itemheight:int, columns:int = 1, clickfunc:Function = null, drawfunc:Function = null, scrollrect:MovieClip = null, scrollbar:ScrollBarMov = null) : * {
				}
				
				public function Draw(refresh:* = true) : * {
				}
		}
}

