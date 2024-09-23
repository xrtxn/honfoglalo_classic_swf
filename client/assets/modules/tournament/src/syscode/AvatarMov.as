package syscode {
		import flash.display.DisplayObject;
		import flash.display.MovieClip;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol39")]
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
				
				public static function GetGlobalScale(obj:MovieClip) : Number {
						return 0;
				}
				
				public function Clear() : void {
				}
				
				public function ShowUID(userid:String, readyCallback:Function = null, readyParams:Array = null, anim_id:int = 0) : void {
				}
				
				public function DisableClick() : void {
				}
				
				public function ShowInternalBitmap(uid:String, def:String, readyCallback:Function = null, readyParams:Array = null) : void {
				}
				
				public function ShowInternalShape(uid:String, def:String, readyCallback:Function = null, readyParams:Array = null, anim_id:* = 0) : void {
				}
				
				public function ShowExternal(uid:String, url:String, readyCallback:Function = null, readyParams:Array = null) : void {
				}
				
				public function ShowDoll() : void {
				}
		}
}

