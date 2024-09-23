package syscode {
		import flash.display.MovieClip;
		
		public class Sys {
				public static var tag_state:Object;
				
				public static var tag_cmd:Object;
				
				public static var tag_mydata:Object;
				
				public static var tag_levelchange:Object;
				
				public static var tag_activeseproom:Object;
				
				public static var tag_waitstate:Object;
				
				public static var tag_shutdown:Object;
				
				public static var tag_question:Object;
				
				public static var tag_tipquestion:Object;
				
				public static var tag_brokenseries:Object;
				
				public static var tag_division:Object;
				
				public static var tag_wrongq:Object;
				
				public static var tag_reward:Object;
				
				public static var wasstatetag:Boolean;
				
				public static var gsqc:SqControl;
				
				public static var castle_badges:Array;
				
				public static var syscodeversion:String = "abstract";
				
				public static var mydata:Object = null;
				
				public static var screen:String = "";
				
				public static var playersonline:int = 0;
				
				public static var activemodule:String = "";
				
				public static var activetutorial:String = "";
				
				public static var tutorialphase:String = "";
				
				public static var villageautplaytutorial:Boolean = false;
				
				public static var villageautplaytutorialmission:Boolean = false;
				
				public static var myclanproperties:Object = null;
				
				public static var questioncats:Array = [];
				
				public static var gameparams:* = {};
				
				public static var lastenergy:int = -1;
				
				public static var disableenergy:Boolean = false;
				
				public static var videoad_available:Boolean = false;
				
				public static var rlresetremaining:Number = 0;
				
				public static var rlresettimeref:Number = 0;
				
				public function Sys() {
						super();
				}
				
				public static function Init() : * {
				}
				
				public static function CheckFeature(astr:String) : Boolean {
						return false;
				}
				
				public static function ProcessCommandTag() : * {
				}
				
				public static function FunnelVersion() : String {
						return null;
				}
				
				public static function GetGiftShareToken(clear:Boolean = true) : Object {
						return null;
				}
				
				public static function ToggleSound(sndmask:int) : * {
				}
				
				public static function FormatGetParamsStoc(obj:Object, addrnd:Boolean = false) : String {
						return null;
				}
				
				public static function OnMissClick(e:Object) : void {
				}
				
				public static function TutorialCheck(notSysActionName:String = "") : Boolean {
						return false;
				}
				
				public static function TutorialMissionCheck() : Boolean {
						return false;
				}
				
				public static function CheckWeeklyChallenge() : void {
				}
				
				public static function SetupFullScreenButton(fsb:MovieClip) : void {
				}
				
				public static function ExitFullscreen(fsb:MovieClip) : void {
				}
				
				public static function CheckFriendInvites() : void {
				}
		}
}

