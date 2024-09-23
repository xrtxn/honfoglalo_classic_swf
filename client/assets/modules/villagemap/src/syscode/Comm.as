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
				
				public static function OnConnBreakTimer(e:TimerEvent) : void {
				}
				
				public static function OnConnCheckTimer(e:TimerEvent) : void {
				}
				
				public static function StartConnCheckAnim(nodelay:Boolean = false) : void {
				}
				
				public static function StopConnCheckAnim() : void {
				}
				
				public static function OnHeartBeatTimer(e:TimerEvent) : void {
				}
				
				public static function ProcessHeartBeatAnswer(xml:XML) : void {
				}
				
				public static function Reset() : void {
				}
				
				public static function Connect(screen:String = "") : void {
				}
				
				public static function ReConnect(screen:String = "") : void {
				}
				
				public static function Listen(isready:Boolean) : void {
				}
				
				public static function ProcessListenAnswer(xml:XML) : void {
				}
				
				public static function Ready() : * {
				}
				
				public static function Login(screen:String = "") : void {
				}
				
				public static function SendCommand(cmd:*, params:*, aonresult:Function = null, aobj:* = null, aargs:* = null) : * {
				}
				
				public static function ProcessCommandAnswer(xml:XML) : void {
				}
				
				public static function HandleCommandQueue() : * {
				}
				
				public static function StopCommunication(reason:String, info:String = "") : void {
				}
				
				public static function ClientTrace(tcode:int, tmsg:String) : * {
				}
				
				public static function OnConnect(e:*) : * {
				}
				
				public static function DataReceived(adata:ByteArray, atype:String, flags:uint, prot:String) : void {
				}
				
				public static function XMLReceived(xml:XML, type:String, prot:String) : void {
				}
		}
}

