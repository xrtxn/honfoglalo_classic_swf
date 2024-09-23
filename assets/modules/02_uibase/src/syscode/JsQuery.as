package syscode {
		public class JsQuery {
				public static var jstrace:Boolean = true;
				
				public static var baseuri:String = "";
				
				public function JsQuery() {
						super();
				}
				
				public static function Load(callbackfunc:Function, callbackargs:Array, url:String, postdata:* = null) : void {
						trace("fake load called: " + url);
				}
				
				public static function Dummy(jsq:*) : void {
				}
		}
}

