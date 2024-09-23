package syscode {
		import flash.display.MovieClip;
		
		public class Aligner {
				public static var stagewidth:Number;
				
				public static var stageheight:Number;
				
				public static var margins:Object = {
						"left":0,
						"top":0,
						"right":0,
						"bottom":0
				};
				
				public static var basescale:Number = 0;
				
				public function Aligner() {
						super();
				}
				
				public static function CenterWindow(awin:MovieClip, tostage:Boolean = false) : void {
				}
				
				public static function SetAutoAlign(amc:MovieClip, atostage:Boolean = false) : void {
				}
				
				public static function SetAutoAlignFunc(amc:MovieClip, afunction:Function) : void {
				}
				
				public static function UnSetAutoAlign(amc:MovieClip) : void {
				}
		}
}

