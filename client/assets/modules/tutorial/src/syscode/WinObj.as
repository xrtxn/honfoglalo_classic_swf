package syscode {
		import flash.display.MovieClip;
		
		public class WinObj {
				public var mc:MovieClip = null;
				
				public var winclass:Object;
				
				public var classname:String;
				
				public var modulename:String;
				
				public var properties:Object;
				
				public var loaded:Boolean = true;
				
				public function WinObj(aclass:Object, aprops:Object) {
						super();
				}
				
				public function BackHandler(event:Object) : void {
				}
				
				public function Dispose() : void {
				}
		}
}

