package syscode {
		import flash.events.TimerEvent;
		import flash.utils.Timer;
		
		public class MyTimer {
				public var timer:Timer;
				
				public var queue:Array;
				
				public var onReady:Function;
				
				public var running:Boolean;
				
				public function MyTimer() {
						super();
				}
				
				public function Start() : * {
				}
				
				public function Stop() : void {
				}
				
				public function OnTimer(e:TimerEvent) : void {
				}
				
				public function AddFunction(atime:Number, afunc:Function, avars:Array = null) : * {
				}
				
				public function AddMethod(atime:Number, ainst:Object, afunc:Function, avars:Array = null) : * {
				}
		}
}

