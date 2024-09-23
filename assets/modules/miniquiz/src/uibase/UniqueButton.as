package uibase {
		import flash.display.MovieClip;
		import flash.text.TextField;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol62")]
		public class UniqueButton extends MovieClip {
				public static const DISLIKE_FRAME:uint = 1;
				
				public static const LIKE_FRAME:uint = 2;
				
				public static const TELESCOPE_FRAME:uint = 3;
				
				public var LABEL:TextField;
				
				public var BG:MovieClip;
				
				public var ICON:MovieClip;
				
				public function UniqueButton() {
						super();
				}
				
				public function Set(_keyframe:uint, _clickfunction:Function, _clickparams:Object = null) : void {
				}
				
				public function SetCaption(_label:String) : void {
				}
				
				public function Activate() : void {
				}
				
				public function InActivate() : void {
				}
				
				public function Init() : void {
				}
				
				public function Hide() : void {
				}
				
				public function FadeOut() : void {
				}
		}
}

