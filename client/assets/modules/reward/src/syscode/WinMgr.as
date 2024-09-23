package syscode {
		import flash.display.MovieClip;
		
		public class WinMgr {
				public static const shaderalpha:Number = 0.7;
				
				public static const shadercolor:Number = 0;
				
				public static var initialized:Boolean = false;
				
				public static var basemc:MovieClip = null;
				
				public static var overlaymc:MovieClip = null;
				
				public static var currentwindow:WinObj = null;
				
				public static var closingwindow:WinObj = null;
				
				public static var loadingwindow:WinObj = null;
				
				public static var basehandler:WinObj = null;
				
				public static var loadwait:MovieClip = null;
				
				public static var shaderanim:Boolean = false;
				
				public function WinMgr() {
						super();
				}
				
				private static function trace(... rest) : * {
				}
				
				public static function Init() : * {
				}
				
				public static function ShowBaseHandler(param1:Object, param2:Object = null) : void {
				}
				
				public static function HideBaseHandler(param1:Object) : void {
				}
				
				public static function OpenWindow(param1:Object, param2:Object = null) : void {
				}
				
				public static function CloseWindow(param1:MovieClip) : void {
				}
				
				public static function RemoveWindow(param1:Object) : void {
				}
				
				public static function ReplaceWindow(param1:MovieClip, param2:Object, param3:Object = null) : void {
				}
				
				public static function WindowOpened(param1:Object) : Boolean {
						return false;
				}
				
				public static function UpdateBackground(param1:Boolean = false) : void {
				}
				
				public static function ReAlign() : void {
				}
				
				public static function ShowLoadWait() : void {
				}
				
				public static function OnLoadWaitFrame(param1:*) : void {
				}
				
				public static function HideLoadWait() : void {
				}
				
				public static function SetWaitProgress(param1:Number) : void {
				}
				
				public static function WindowDataArrived(param1:MovieClip) : void {
				}
		}
}

