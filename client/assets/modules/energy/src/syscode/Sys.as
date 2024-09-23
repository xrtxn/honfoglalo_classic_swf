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
				
				public static var codeclan:Boolean = false;
				
				public function Sys() {
						super();
				}
				
				private static function trace(... arguments) : * {
				}
				
				public static function Init() : * {
				}
				
				public static function Reset() : void {
				}
				
				public static function OnUpdateFrame(e:*) : void {
				}
				
				public static function OnStageResize(e:*) : void {
				}
				
				public static function ClearPerMessageTags() : * {
				}
				
				public static function ProcessXMLTags(xml:XML, fromcmd:Boolean) : * {
				}
				
				public static function ProcessDataXML(xml:XML) : void {
				}
				
				public static function ActivateModule(aname:String, xml:XML) : void {
				}
				
				public static function CallProcessorFunction(afuncname:String, aparams:Array) : * {
				}
				
				public static function HandleCommandResult(ec:int) : void {
				}
				
				public static function ProcessCMDAnswer(xml:XML) : void {
				}
				
				public static function SqFinished() : * {
				}
				
				public static function ProcessCommandTag() : * {
				}
				
				public static function tagproc_STATE(tag:*) : * {
				}
				
				public static function ExplodeSoldiers(str:*) : * {
				}
				
				public static function tagproc_MYDATA(tag:*) : * {
				}
				
				public static function tagproc_QCATS(tag:*) : * {
				}
				
				public static function tagproc_GAMEPARAMS(tag:*) : * {
				}
				
				public static function tagproc_NOTIFICATIONS(tag:*) : * {
				}
				
				public static function tagproc_FEATURES(tag:*) : * {
				}
				
				public static function tagproc_BROKENSERIES(_tag:Object) : void {
				}
				
				public static function CheckFeature(astr:String) : Boolean {
						return false;
				}
				
				public static function CommunicationStopped(amsg:String) : void {
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
				
				public static function GetGiftShareToken(clear:Boolean = true) : Object {
						return null;
				}
				
				public static function ToggleSound(sndmask:int) : * {
				}
				
				public static function FormatGetParamsStoc(obj:Object, addrnd:Boolean = false) : String {
						return "";
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
				
				public static function ShowWeeklyChallenge(_jsq:Object) : void {
				}
				
				public static function SetupFullScreenButton(fsb:MovieClip) : void {
				}
				
				public static function ExitFullscreen(fsb:MovieClip) : void {
				}
				
				public static function CollectNotifications() : void {
				}
				
				public static function CheckTutorialNotification() : void {
				}
				
				public static function CheckTutorialMissionNotification() : void {
				}
				
				public static function CheckMyClanProperties() : void {
				}
				
				public static function OnMyClanPropertiesResult(_jsq:Object) : void {
				}
				
				public static function CheckMail() : void {
				}
				
				public static function CheckMailResult(jsq:Object, draw:Boolean, first:int, scroll:int = 0) : * {
				}
				
				public static function CheckMiniQuiz() : void {
				}
				
				public static function OnCheckMiniQuizResult(_jsq:Object) : void {
				}
				
				public static function CheckFriendInvites() : void {
				}
				
				public static function CheckAdvent() : void {
				}
				
				public static function OnAdventResult(_jsq:Object) : void {
				}
				
				public static function StartVideoAds() : void {
				}
				
				public static function QueryVideoAds() : void {
				}
				
				public static function RemoveVideoadsListeners() : void {
				}
				
				public static function ExternalSkin(category:String, mc:DisplayObject, id:int) : * {
				}
				
				public static function SwapImage(mc:DisplayObject, url:String) : * {
				}
		}
}

