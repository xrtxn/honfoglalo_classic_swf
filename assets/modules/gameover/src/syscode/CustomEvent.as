package syscode {
		import flash.events.Event;
		
		public class CustomEvent extends Event {
				public var params:Object;
				
				public function CustomEvent(type:String, params:Object, bubbles:Boolean = false, cancelable:Boolean = false) {
						super(type,false,false);
				}
				
				override public function clone() : Event {
						return null;
				}
				
				override public function toString() : String {
						return "";
				}
		}
}

