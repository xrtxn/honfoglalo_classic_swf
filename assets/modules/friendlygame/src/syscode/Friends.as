package syscode {
		public class Friends {
				public static var soctoken:String = "";
				
				public static var external:Array = [];
				
				public static var §internal§:Array = [];
				
				public static var all:Array = [];
				
				public static var invitable:Array = [];
				
				public static var internalFriendCount:int = 0;
				
				public function Friends() {
						super();
				}
				
				public static function LoadExternalFriendsAPP(loginData:Object) : void {
				}
				
				public static function LoadExternalFriendsWEB() : void {
				}
				
				public static function LoadInvitableFriends(_callback:Function = null) : void {
				}
				
				public static function Cancel(userid:String, callbackFunc:Function) : void {
				}
				
				public static function LoadInternalFriends(callbackFunc:Function) : void {
				}
				
				public static function GetUser(partnerid:String) : Object {
						return null;
				}
				
				public static function AddFriendShip(partnerid:String, callback:Function = null) : * {
				}
				
				public static function CancelFriendShip(partnerid:String, callback:Function = null) : * {
				}
				
				public static function DenyFriendShip(partnerid:String, callback:Function = null) : * {
				}
				
				public static function BlockUser(partnerid:String, callback:Function = null) : * {
				}
				
				public static function CancelBlock(partnerid:String, callback:Function = null) : * {
				}
		}
}

