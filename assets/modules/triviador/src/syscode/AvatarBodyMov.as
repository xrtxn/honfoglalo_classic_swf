package syscode {
		import flash.display.MovieClip;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol256")]
		public class AvatarBodyMov extends MovieClip {
				public var body:MovieClip;
				
				public var head:MovieClip;
				
				public var uid:String;
				
				public var HEAD:MovieClip;
				
				public function AvatarBodyMov() {
						super();
				}
				
				public static function Init(callback:*) : * {
				}
				
				public function Clear() : void {
				}
				
				public function ShowUID(userid:String, readyCallback:Function = null) : void {
				}
				
				public function ShowInternal(uid:String, def:String, readyCallback:Function = null) : void {
				}
		}
}

