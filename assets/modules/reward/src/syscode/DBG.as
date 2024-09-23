package syscode {
		import flash.display.LoaderInfo;
		import flash.utils.Timer;
		
		public class DBG {
				public static var FPSCounter:uint = 0;
				
				public static var FPSTimer:Timer = new Timer(1000,0);
				
				public static var FPSTime:Number = 0;
				
				public static var StageState:String = "";
				
				public static var ClientState:Object = {};
				
				public static var StageFrameRate:int = 0;
				
				public static var LastFrameTime:Number = 0;
				
				public static var LongFrameTimes:Array = [];
				
				public static var LastFrameReportTime:Number = 0;
				
				public function DBG() {
						super();
				}
				
				private static function trace(... rest) : * {
				}
				
				public static function Trace(param1:String, param2:* = null) : void {
				}
				
				public static function AddErrorLogger(param1:LoaderInfo) : void {
				}
				
				public static function SendWarning(param1:String) : void {
				}
				
				public static function SendCustomLog(param1:String, param2:String, param3:String) : void {
				}
		}
}

