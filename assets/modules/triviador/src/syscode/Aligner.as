package syscode {
		import flash.display.MovieClip;
		
		public class Aligner {
				public static var stagewidth:Number;
				
				public static var stageheight:Number;
				
				public static var margins:Object = {
						"left":25,
						"top":5,
						"right":5,
						"bottom":5
				};
				
				public static var basescale:Number = 1;
				
				public static var autoaligned:Object = {};
				
				public function Aligner() {
						super();
				}
				
				public static function Init(awidth:Number, aheight:Number) : * {
				}
				
				public static function StageResized(awidth:Number, aheight:Number) : * {
				}
				
				public static function CenterWindow(awin:MovieClip, tostage:Boolean = false) : * {
				}
				
				public static function SetAutoAlign(amc:MovieClip, atostage:Boolean = false) : void {
				}
				
				public static function SetAutoAlignFunc(amc:MovieClip, afunction:Function) : void {
				}
				
				public static function AutoAlignWindow(aao:Object) : void {
				}
				
				public static function UnSetAutoAlign(amc:MovieClip) : void {
				}
				
				public static function SetMargins() : void {
				}
				
				public static function DoAutoAlign() : void {
				}
		}
}

