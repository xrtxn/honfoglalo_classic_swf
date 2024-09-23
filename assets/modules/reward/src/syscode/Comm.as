package syscode {
		import flash.events.TimerEvent;
		import flash.utils.ByteArray;
		import flash.utils.Timer;
		
		public class Comm {
				public static var lastcmd:String;
				
				public static var lastcmdobj:Object;
				
				public static var cmdqueue:Array;
				
				public static var commlog:int = 0;
				
				public static var clientcc:int = 0;
				
				public static var connstate:int = 0;
				
				public static var reconnect:Boolean = false;
				
				public static var preconnid:String = "";
				
				public static var connid:String = "";
				
				public static var listening:Boolean = false;
				
				public static var iamready:Boolean = false;
				
				public static var loginpsid:int = 0;
				
				public static var loginparams:String = "";
				
				public static var protocol:String = "";
				
				public static var serveraddress:String = "";
				
				public static var httpport:int = 80;
				
				public static var xsocketaddress:String = "";
				
				public static var xsocketport:int = 2002;
				
				public static var httpuri:String = "";
				
				public static var connchecktimer:Timer = null;
				
				public static var connbreaktimer:Timer = null;
				
				public static var heartbeattimer:Timer = null;
				
				public static var last_hb_recv:int = 0;
				
				public static var last_received_message:String = "";
				
				public static var ModuleLoadingPhase:Boolean = false;
				
				public function Comm() {
						super();
				}
				
				public static function Init() : * {
				}
				
				public static function OnConnBreakTimer(param1:TimerEvent) : void {
				}
				
				public static function OnConnCheckTimer(param1:TimerEvent) : void {
				}
				
				public static function StartConnCheckAnim(param1:Boolean = false) : void {
				}
				
				public static function StopConnCheckAnim() : void {
				}
				
				public static function OnHeartBeatTimer(param1:TimerEvent) : void {
				}
				
				public static function ProcessHeartBeatAnswer(param1:XML) : void {
				}
				
				public static function Reset() : void {
				}
				
				public static function Connect(param1:String = "") : void {
				}
				
				public static function ReConnect(param1:String = "") : void {
				}
				
				public static function Listen(param1:Boolean) : void {
				}
				
				public static function ProcessListenAnswer(param1:XML) : void {
				}
				
				public static function Ready() : * {
				}
				
				public static function Login(param1:String = "") : void {
				}
				
				public static function SendCommand(param1:*, param2:*, param3:Function = null, param4:* = null, param5:* = null) : * {
				}
				
				public static function ProcessCommandAnswer(param1:XML) : void {
				}
				
				public static function HandleCommandQueue() : * {
				}
				
				public static function StopCommunication(param1:String, param2:String = "") : void {
				}
				
				public static function ClientTrace(param1:int, param2:String) : * {
				}
				
				public static function OnConnect(param1:*) : * {
				}
				
				public static function DataReceived(param1:ByteArray, param2:String, param3:uint, param4:String) : void {
				}
				
				public static function XMLReceived(param1:XML, param2:String, param3:String) : void {
				}
		}
}

