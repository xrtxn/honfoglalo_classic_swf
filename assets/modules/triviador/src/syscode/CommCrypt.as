package syscode {
		import flash.display.Bitmap;
		import flash.text.TextField;
		import flash.utils.ByteArray;
		
		public class CommCrypt {
				public static var SharedKeyTmp:ByteArray = null;
				
				public static var ChaChaCipher:Object = null;
				
				public static var Encrypted:Boolean = false;
				
				public function CommCrypt() {
						super();
				}
				
				public static function BinaryEncrypt(str:String, defkey:Boolean = false) : ByteArray {
						return null;
				}
				
				public static function BinaryDecrypt(bytes:ByteArray, defkey:Boolean = false) : String {
						return "";
				}
				
				public static function Encrypt(asrc:String) : String {
						return "";
				}
				
				public static function Decrypt(asrc:String) : String {
						return "";
				}
				
				public static function GenerateSharedKey() : Array {
						return null;
				}
				
				public static function StartEncryption() : * {
				}
				
				public static function GetQuestionPic(data:String, color:uint) : Bitmap {
						return null;
				}
				
				public static function SetQuestionText(tf:TextField, qt:String) : void {
				}
				
				public static function Reset() : * {
				}
		}
}

