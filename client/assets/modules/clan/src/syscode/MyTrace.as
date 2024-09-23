package syscode {
		public class MyTrace {
				public static var hilights:* = ["!","FriendlyGame","error","OpenWindow"];
				
				public static var hides:* = ["global error logger ready","WARNING: For content targeting Flash Player version 14 or higher"];
				
				public static var tracelog:Array = [];
				
				public function MyTrace() {
						super();
				}
				
				public static function myTrace(arguments:*) : void {
				}
		}
}

