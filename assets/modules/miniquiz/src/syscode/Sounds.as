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
				
				public static function LoadSounds(atag:String, acallback:Function = null) : void {
				}
				
				public static function SetSound(aname:String, aurl:String, atags:String) : Object {
						return null;
				}
				
				public static function InternalLoadSounds() : void {
				}
				
				public static function InternalPlaySound(aname:String, type:String, startTime:Number, loops:int, onReadyCallback:Function = null) : int {
						return 0;
				}
				
				public static function InternalStopSound(aname:String, type:String) : void {
				}
				
				public static function PlayEffect(name:String, startTime:Number = 0, onReadyCallback:Function = null) : int {
						return 0;
				}
				
				public static function StopEffect(name:String) : void {
				}
				
				public static function PlayVoice(name:String, startTime:Number = 0, onReadyCallback:Function = null) : int {
						return 0;
				}
				
				public static function StopVoice(name:String) : void {
				}
				
				public static function PlayMusic(name:String, startTime:Number = 0, loops:int = 999999, onReadyCallback:Function = null) : int {
						return 0;
				}
				
				public static function StopMusic(name:String) : void {
				}
				
				public static function StopAll(name:String) : void {
				}
				
				public static function SetVolume(vol_eff:Number, vol_voi:Number, vol_mus:Number) : void {
				}
				
				public static function IsPlaying(aname:String) : Boolean {
						return false;
				}
		}
}

