package syscode {
		import flash.display.BitmapData;
		
		public final class BitmapDataPool {
				public static var max_size:int = 50;
				
				public static var pool:Array = [];
				
				public static var types:Object = {};
				
				public static var stat_pop:* = 0;
				
				public static var stat_push:* = 0;
				
				public static var stat_new:* = 0;
				
				public static var enabled:* = false;
				
				public function BitmapDataPool() {
						super();
				}
				
				public static function Alloc(w:int, h:int, transparent:Boolean = true, color:int = 0) : BitmapData {
						return null;
				}
				
				public static function Free(bmd:BitmapData) : void {
				}
		}
}

