package syscode {
		import flash.events.TimerEvent;
		
		public class Semu {
				public static var connid:String;
				
				public static var enabled:Boolean = false;
				
				public static var cmdtimeout:int = 150000;
				
				public static var fastbots:Boolean = false;
				
				public static var pausebots:Boolean = false;
				
				public static var connidnum:int = 1;
				
				public static var lmsgnum:int = 0;
				
				public static var isready:Boolean = false;
				
				public static var answer:String = "";
				
				public static var instantanswer:Boolean = true;
				
				public static var sendmydata:Boolean = true;
				
				public static var sendfeatures:Boolean = true;
				
				public static var send_tag_players:Boolean = true;
				
				public static var send_tag_question:Boolean = true;
				
				public static var map_id:String = "";
				
				public static var map_areanum:int = 15;
				
				public static var map_neighbours:Array = [];
				
				public static var screen:String = "";
				
				public static var state:int = 0;
				
				public static var gameround:int = 0;
				
				public static var phase:int = 0;
				
				public static var lpnum:int = 0;
				
				public static var nextplayer:int = 0;
				
				public static var offender:int = 0;
				
				public static var defender:int = 0;
				
				public static var baseattack:Boolean = false;
				
				public static var availableareas:int = 0;
				
				public static var tipstarttime:int = 0;
				
				public static var answercount:int = 0;
				
				public static var tiporder:Array = [];
				
				public static var tipwinorder:Array = [];
				
				public static var tag_results:String = "";
				
				public static var tag_question:String = "";
				
				public static var tag_messages:String = "";
				
				public static var game_rule:int = 1;
				
				public static var warorder:String = "123231312444";
				
				public static var warorderstart:String = "123231312444";
				
				public static var rotation:String = "123231312132213321";
				
				public static var freeareas_win_order:String = "";
				
				public static var mydata:SemuPlayer = null;
				
				public static var players:Array = [null,null,null,null];
				
				public static var areas:Array = [];
				
				public static var mc_question:Object = null;
				
				public static var mc_question_goodanswer:int = -1;
				
				public static var mc_doublechance:String = "";
				
				public static var mc_answeratios:String = "";
				
				public static var guess_question:Object = null;
				
				public static var roomsel:int = 0;
				
				public static var levelflags:int = 0;
				
				public static var activemissions:int = 255;
				
				public static var shownmissions:int = 255;
				
				public static var completedmissions:int = 0;
				
				public static var firststart:Boolean = false;
				
				public static const CONNECTWAIT:Number = 0.1;
				
				public static var bottimers:Array = [];
				
				public function Semu() {
						super();
				}
				
				public static function Init() : * {
				}
				
				public static function InitConfig() : * {
				}
				
				public static function ProcessMessage(axmlstr:String, id:String) : * {
				}
				
				public static function ProcessCommand(xml:XML) : * {
				}
				
				public static function AnswerCommand(axml:XML, aresult:int, adatatag:String = "") : * {
				}
				
				public static function ProcessListen(xml:XML) : * {
				}
				
				public static function HandleGamePhase() : * {
				}
				
				public static function SetState(astate:*, around:*, aphase:*) : * {
				}
				
				public static function SetPhase(aphase:*) : * {
				}
				
				public static function JumpPhase(aphase:*) : * {
				}
				
				public static function StartGame() : * {
				}
				
				public static function InitStartState() : * {
				}
				
				public static function AnswerAllPlayers() : * {
				}
				
				public static function AnswerHalfResult() : * {
				}
				
				public static function SendWaitHallAnswerNow() : * {
				}
				
				public static function SendWaitHallAnswer() : * {
				}
				
				public static function AnswerHeader(aresult:int) : String {
						return "";
				}
				
				public static function AddGeneralTags() : * {
				}
				
				public static function AddSmallUserListTag() : void {
				}
				
				public static function FormatTipInfoTag(addvalues:Boolean) : String {
						return "";
				}
				
				public static function FormatTipResultTag() : String {
						return "";
				}
				
				public static function FormatAnswerResultTag(showgood:Boolean) : String {
						return "";
				}
				
				public static function AddTag_STATE() : * {
				}
				
				public static function AddTag_PLAYERS(pnum:int) : * {
				}
				
				public static function CurrentPlace(pnum:int) : int {
						return 0;
				}
				
				public static function HandleGameOver() : void {
				}
				
				public static function FormatTag_DIVISION() : String {
						return "";
				}
				
				public static function FormatTag_LEVELCHANGE() : * {
				}
				
				public static function AddTag_WAITSTATE() : * {
				}
				
				public static function AddTag_MYDATA() : * {
				}
				
				public static function AddTag_QCATS() : * {
				}
				
				public static function AddTag_FEATURES() : * {
				}
				
				public static function AddTag_GAMEPARAMS() : * {
				}
				
				public static function AddTag_GAMEROOM() : * {
				}
				
				public static function AddTag_WRONGQ() : * {
				}
				
				public static function CalculateXPLevel(xppoints:int) : int {
						return 0;
				}
				
				public static function IsNeighbour(anum:int, astr:String) : Boolean {
						return false;
				}
				
				public static function GetAvailableAreas(pnum:int) : int {
						return 0;
				}
				
				public static function RandomSelectArea(avail:int) : int {
						return 0;
				}
				
				public static function SetMap(id:String, areanum:int, neighbours:Array) : * {
				}
				
				public static function SetArea(area:int, pnum:int, value:int) : * {
				}
				
				public static function SelectGuessQuestion() : * {
				}
				
				public static function SelectMCQuestion() : * {
				}
				
				public static function PrepareAnswers() : * {
				}
				
				public static function ResetSelections() : * {
				}
				
				public static function FreeAreaCount() : int {
						return 0;
				}
				
				public static function CalculateLastRoundAttackOrder() : * {
				}
				
				public static function RotationPlayer(around:int, alpnum:int) : int {
						return 0;
				}
				
				public static function CalculateNextPlayer() : * {
				}
				
				public static function ActivePlayerCount() : * {
				}
				
				public static function EqualPoints() : int {
						return 0;
				}
				
				public static function OccupyArea(aareanum:*, pnum:*) : * {
				}
				
				public static function DefeatPlayer(aoffender:*, adefender:*) : * {
				}
				
				public static function SetPlayerCmd(pnum:int, acmd:String, aparams:String) : * {
				}
				
				public static function StartRobotActions() : * {
				}
				
				public static function SetPlayerSelectCmd(pnum:int) : * {
				}
				
				public static function ProcessCmdSelectMH(tag:*) : * {
				}
				
				public static function ProcessCmdSelect(pnum:int, area:int) : * {
				}
				
				public static function ProcessCmdTip(pnum:int, avalue:int) : * {
				}
				
				public static function ProcessCmdAnswer(pnum:int, avalue:int) : * {
				}
				
				public static function ProcessCmdLogin(xml:*) : * {
				}
				
				public static function ProcessCmdHelp(pnum:int, help:String) : String {
						return "";
				}
				
				public static function ProcessCmdMission(mid:int, cmd:String) : String {
						return "";
				}
				
				public static function RobotAction(pnum:int) : * {
				}
				
				public static function SendAnswerDelayed(adelay:Number) : * {
				}
				
				public static function OnSendAnswer(e:TimerEvent) : * {
				}
				
				public static function SendAnswer(ans:String, type:String) : void {
				}
				
				public static function Connect() : * {
				}
				
				public static function OnConnect(e:TimerEvent) : * {
				}
		}
}

