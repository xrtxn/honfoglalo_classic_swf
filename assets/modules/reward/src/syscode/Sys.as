package syscode {
		import flash.display.DisplayObject;
		import flash.display.MovieClip;
		
		public class Sys {
				public static var gsqc:SqControl;
				
				public static var wasstatetag:Boolean;
				
				public static var tag_state:Object;
				
				public static var tag_cmd:Object;
				
				public static var tag_mydata:Object;
				
				public static var tag_activeseproom:Object;
				
				public static var tag_tournament:Object;
				
				public static var tag_levelchange:Object;
				
				public static var tag_waitstate:Object;
				
				public static var tag_question:Object;
				
				public static var tag_tipquestion:Object;
				
				public static var tag_shutdown:Object;
				
				public static var tag_giftshare:Object;
				
				public static var tag_qcats:Object;
				
				public static var tag_wrongq:Object;
				
				public static var tag_brokenseries:Object;
				
				public static var tag_division:Object;
				
				public static var tag_reward:Object;
				
				public static var castle_badges:Array;
				
				public static var all_badges:Object;
				
				public static var syscodeversion:String = "abstract";
				
				public static var activemodule:String = "";
				
				public static var mydata:Object = null;
				
				public static var screen:String = "";
				
				public static var prevscreen:String = "";
				
				public static var playersonline:int = 0;
				
				public static var activetutorial:String = "";
				
				public static var tutorialphase:String = "";
				
				public static var villageautplaytutorial:Boolean = false;
				
				public static var villageautplaytutorialmission:Boolean = false;
				
				public static var myclanproperties:Object = null;
				
				public static var questioncats:Array = [];
				
				public static var features_enabled:String = "";
				
				public static var feature_longrule:Boolean = false;
				
				public static var feature_minitournament:Boolean = false;
				
				public static var wasshown_weeklychallenge:Boolean = false;
				
				public static var gameparams:* = {};
				
				public static var lastenergy:int = -1;
				
				public static var disableenergy:Boolean = false;
				
				public static var firstdatafunc:Function = null;
				
				public static var frames:int = 0;
				
				public static var connection_lost_visible:Boolean = false;
				
				public static var browser_videoad_autoplay:Boolean = false;
				
				public static var videoad_available:Boolean = false;
				
				public static var rlresetremaining:Number = 0;
				
				public static var rlresettimeref:Number = 0;
				
				public static var notifcollecttime:Number = 0;
				
				public static var codereg:Boolean = false;
				
				public static var codegame:Boolean = false;
				
				public static var codegamecode:String = "";
				
				public static var codeclan:Boolean = false;
				
				public function Sys() {
						super();
				}
				
				private static function trace(... rest) : * {
				}
				
				public static function Init() : * {
				}
				
				public static function Reset() : void {
				}
				
				public static function OnUpdateFrame(param1:*) : void {
				}
				
				public static function OnStageResize(param1:*) : void {
				}
				
				public static function ClearPerMessageTags() : * {
				}
				
				public static function ProcessXMLTags(param1:XML, param2:Boolean) : * {
				}
				
				public static function ProcessDataXML(param1:XML) : void {
				}
				
				public static function ActivateModule(param1:String, param2:XML) : void {
				}
				
				public static function CallProcessorFunction(param1:String, param2:Array) : * {
				}
				
				public static function HandleCommandResult(param1:int) : void {
				}
				
				public static function ProcessCMDAnswer(param1:XML) : void {
				}
				
				public static function SqFinished() : * {
				}
				
				public static function ProcessCommandTag() : * {
				}
				
				public static function tagproc_STATE(param1:*) : * {
				}
				
				public static function ExplodeSoldiers(param1:*) : * {
				}
				
				public static function tagproc_MYDATA(param1:*) : * {
				}
				
				public static function tagproc_QCATS(param1:*) : * {
				}
				
				public static function tagproc_GAMEPARAMS(param1:*) : * {
				}
				
				public static function tagproc_NOTIFICATIONS(param1:*) : * {
				}
				
				public static function tagproc_FEATURES(param1:*) : * {
				}
				
				public static function tagproc_BROKENSERIES(param1:Object) : void {
				}
				
				public static function CheckFeature(param1:String) : Boolean {
						return false;
				}
				
				public static function CommunicationStopped(param1:String) : void {
				}
				
				public static function HideConnectWait() : * {
				}
				
				public static function ShowConnectWait() : * {
				}
				
				public static function ShowLoginScreen() : * {
				}
				
				public static function LoadPolicyFiles() : * {
				}
				
				public static function FunnelVersion() : String {
						return "";
				}
				
				public static function GetGiftShareToken(param1:Boolean = true) : Object {
						return null;
				}
				
				public static function ToggleSound(param1:int) : * {
				}
				
				public static function FormatGetParamsStoc(param1:Object, param2:Boolean = false) : String {
						return "";
				}
				
				public static function OnMissClick(param1:Object) : void {
				}
				
				public static function TutorialCheck(param1:String = "") : Boolean {
						return false;
				}
				
				public static function TutorialMissionCheck() : Boolean {
						return false;
				}
				
				public static function CheckWeeklyChallenge() : void {
				}
				
				public static function ShowWeeklyChallenge(param1:Object) : void {
				}
				
				public static function SetupFullScreenButton(param1:MovieClip) : void {
				}
				
				public static function ExitFullscreen(param1:MovieClip) : void {
				}
				
				public static function CollectNotifications() : void {
				}
				
				public static function CheckTutorialNotification() : void {
				}
				
				public static function CheckTutorialMissionNotification() : void {
				}
				
				public static function CheckMyClanProperties() : void {
				}
				
				public static function OnMyClanPropertiesResult(param1:Object) : void {
				}
				
				public static function CheckMail() : void {
				}
				
				public static function CheckMailResult(param1:Object, param2:Boolean, param3:int, param4:int = 0) : * {
				}
				
				public static function CheckMiniQuiz() : void {
				}
				
				public static function OnCheckMiniQuizResult(param1:Object) : void {
				}
				
				public static function CheckFriendInvites() : void {
				}
				
				public static function CheckAdvent() : void {
				}
				
				public static function OnAdventResult(param1:Object) : void {
				}
				
				public static function StartVideoAds() : void {
				}
				
				public static function QueryVideoAds() : void {
				}
				
				public static function RemoveVideoadsListeners() : void {
				}
				
				public static function ExternalSkin(param1:String, param2:DisplayObject, param3:int) : * {
				}
				
				public static function SwapImage(param1:DisplayObject, param2:String) : * {
				}
		}
}

