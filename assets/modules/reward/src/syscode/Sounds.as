package syscode {
		import flash.media.Sound;
		
		public class Sounds {
				public static var sounds:Object = {};
				
				public static var baseurl:String = "sounds/";
				
				public static var langid:String = "en/";
				
				public static var loadqueue:Array = [];
				
				public static var loadcallback:Function = null;
				
				public static var loading:Boolean = false;
				
				public static var buffered:Boolean = true;
				
				public static var newname:String = "";
				
				public static var newsound:Sound = null;
				
				public static var newurl:String = "";
				
				public static var voiceid:String = "";
				
				public static var volume_master:Number = 1;
				
				public static var volume_effect:Number = 0.75;
				
				public static var volume_voice:Number = 0.75;
				
				public static var volume_music:Number = 0.75;
				
				public static var playlist:Array = [];
				
				public static var increment:int = 0;
				
				public function Sounds() {
						super();
				}
				
				public static function Init() : void {
				}
				
				public static function LoadSounds(param1:String, param2:Function = null) : void {
				}
				
				public static function SetSound(param1:String, param2:String, param3:String) : Object {
						return null;
				}
				
				public static function InternalLoadSounds() : void {
				}
				
				public static function InternalPlaySound(param1:String, param2:String, param3:Number, param4:int, param5:Function = null) : int {
						return 0;
				}
				
				public static function InternalStopSound(param1:String, param2:String) : void {
				}
				
				public static function PlayEffect(param1:String, param2:Number = 0, param3:Function = null) : int {
						return 0;
				}
				
				public static function StopEffect(param1:String) : void {
				}
				
				public static function PlayVoice(param1:String, param2:Number = 0, param3:Function = null) : int {
						return 0;
				}
				
				public static function StopVoice(param1:String) : void {
				}
				
				public static function PlayMusic(param1:String, param2:Number = 0, param3:int = 999999, param4:Function = null) : int {
						return 0;
				}
				
				public static function StopMusic(param1:String) : void {
				}
				
				public static function StopAll(param1:String) : void {
				}
				
				public static function SetVolume(param1:Number, param2:Number, param3:Number) : void {
				}
				
				public static function IsPlaying(param1:String) : Boolean {
						return false;
				}
		}
}

