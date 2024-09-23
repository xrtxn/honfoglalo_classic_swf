package syscode {
		public final class Pool {
				public static var pool:Object = {};
				
				public static var types:Object = {};
				
				public static var stat_pop:* = 0;
				
				public static var stat_push:* = 0;
				
				public static var stat_new:* = 0;
				
				public function Pool() {
						super();
				}
				
				public static function Alloc(aclass:Class) : * {
				}
				
				public static function Free(obj:*, aclass:Class) : void {
				}
				
				public static function Query(key:*) : * {
				}
				
				public static function Remember(obj:*, key:*) : void {
				}
				
				public static function Drop(obj:*, key:* = null) : void {
				}
		}
}

