package syscode {
		public class Extdata {
				public static var countries:Object = {};
				
				public function Extdata() {
						super();
				}
				
				public static function AddUser(uid:String) : Object {
						return null;
				}
				
				public static function SetUserData(uid:String, name:String, avatar:String) : Object {
						return null;
				}
				
				public static function GetUserData(uid:String, schedule:Boolean = true) : Object {
						return null;
				}
				
				public static function UserName(uid:String) : String {
						return "";
				}
				
				public static function SetCountryData(cid:String, name:String, description:String, flag:String) : Object {
						return null;
				}
				
				public static function GetCountryData(cid:String) : Object {
						return null;
				}
				
				public static function CountryName(cid:String) : String {
						return "";
				}
				
				public static function CountryDescription(cid:String) : String {
						return "";
				}
				
				public static function LoadCountries(onCompleteFunc:Function) : void {
				}
				
				public static function GetSheduledData(onCompleteFunc:Function) : void {
				}
		}
}

