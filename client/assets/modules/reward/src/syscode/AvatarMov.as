package syscode {
		import flash.display.DisplayObject;
		import flash.display.MovieClip;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol491")]
		public class AvatarMov extends MovieClip {
				public var DOLL:MovieClip;
				
				public var avatar:DisplayObject;
				
				public var uid:String;
				
				public var PIC:MovieClip;
				
				public var anim:Boolean = false;
				
				public var members:Object;
				
				public var isinternal:Boolean = true;
				
				public var internal_flipped:Boolean = false;
				
				public var mt:Boolean = false;
				
				public var BACK:MovieClip;
				
				public var HEAD:MovieClip;
				
				public var anim_id:int = 0;
				
				public function AvatarMov() {
						this.members = {};
						super();
				}
				
				public static function GetGlobalScale(param1:MovieClip) : Number {
						return 0;
				}
				
				public function Clear() : void {
				}
				
				public function ShowUID(param1:String, param2:Function = null, param3:Array = null, param4:int = 0) : void {
				}
				
				public function DisableClick() : void {
				}
				
				public function ShowInternalBitmap(param1:String, param2:String, param3:Function = null, param4:Array = null) : void {
				}
				
				public function ShowInternalShape(param1:String, param2:String, param3:Function = null, param4:Array = null, param5:* = 0) : void {
				}
				
				public function ShowExternal(param1:String, param2:String, param3:Function = null, param4:Array = null) : void {
				}
				
				public function ShowDoll() : void {
				}
		}
}

