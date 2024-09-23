package syscode {
		import flash.display.MovieClip;
		
		public class WinMgr {
				public static var basemc:MovieClip = null;
				
				public static var overlaymc:MovieClip = null;
				
				public function WinMgr() {
						super();
				}
				
				public static function OpenWindow(aclass:Object, aprops:Object = null) : void {
				}
				
				public static function CloseWindow(amc:MovieClip) : void {
				}
				
				public static function WindowDataArrived(mc:MovieClip) : void {
				}
				
				public static function ReplaceWindow(amc:MovieClip, aclass:Object, aprops:Object = null) : void {
				}
				
				public static function WindowOpened(aclass:Object) : Boolean {
						return false;
				}
				
				public static function UpdateBackground(aforce:Boolean = false) : void {
				}
				
				public static function ReAlign() : void {
				}
				
				public static function ShowBaseHandler(aclass:Object, aprops:Object = null) : void {
				}
				
				public static function HideBaseHandler(aclass:Object) : void {
				}
		}
}

