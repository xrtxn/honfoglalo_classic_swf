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
				
				private static function trace(... arguments) : * {
				}
				
				public static function Init() : * {
				}
				
				public static function ShowBaseHandler(aclass:Object, aprops:Object = null) : void {
				}
				
				public static function HideBaseHandler(aclass:Object) : void {
				}
				
				public static function OpenWindow(aclass:Object, aprops:Object = null) : void {
				}
				
				public static function CloseWindow(amc:MovieClip) : void {
				}
				
				public static function RemoveWindow(aclass:Object) : void {
				}
				
				public static function ReplaceWindow(amc:MovieClip, aclass:Object, aprops:Object = null) : void {
				}
				
				public static function WindowOpened(aclass:Object) : Boolean {
						return false;
				}
				
				public static function UpdateBackground(aforceshader:Boolean = false) : void {
				}
				
				public static function ReAlign() : void {
				}
				
				public static function ShowLoadWait() : void {
				}
				
				public static function OnLoadWaitFrame(e:*) : void {
				}
				
				public static function HideLoadWait() : void {
				}
				
				public static function SetWaitProgress(avalue:Number) : void {
				}
				
				public static function WindowDataArrived(mc:MovieClip) : void {
				}
		}
}

