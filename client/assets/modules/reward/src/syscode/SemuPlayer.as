package syscode {
		import flash.events.TimerEvent;
		import flash.utils.Timer;
		
		public class SemuPlayer {
				public var id:String = "-1";
				
				public var name:String = "";
				
				public var customavatar:String = "";
				
				public var usecustomavatar:int = 0;
				
				public var extavatar:String = "";
				
				public var mycategory:int = 0;
				
				public var country:String = "us";
				
				public var xppoints:int = 14000;
				
				public var xplevel:int = 15;
				
				public var xpactmin:int = 14000;
				
				public var golds:int = 3000;
				
				public var freehelps:Array;
				
				public var nextlevelxp:int = 18500;
				
				public var castlelevel:int = 1;
				
				public var gamecount:int = 0;
				
				public var sex:int = 0;
				
				public var sndvol:int = -1;
				
				public var flags:int = 32768;
				
				public var soldier:int = 1;
				
				public var helpprices:Array;
				
				public var starttowers:int = 3;
				
				public var helpforges:Array;
				
				public var playernum:int;
				
				public var points:int;
				
				public var base:int;
				
				public var basestate:int;
				
				public var selection:int;
				
				public var answer:int;
				
				public var tipanswer:int;
				
				public var tiptime:int;
				
				public var tipaccuracy:int;
				
				public var passive:Boolean;
				
				public var deadtime:int;
				
				public var cmd:String = "";
				
				public var tag_cmd:String = "";
				
				public var robotcommandtimer:Timer = null;
				
				public var commandstarted:Boolean = false;
				
				public var help_used_average:Boolean;
				
				public var help_used_range:Boolean;
				
				public var help_used_half:Boolean;
				
				public var help_used_answers:Boolean;
				
				public var usedhelps:int = 0;
				
				public var usecustom:int = 0;
				
				public var custom:String = "";
				
				public var imgurl:String = "";
				
				public function SemuPlayer(param1:String) {
						this.freehelps = [5,3,7,6,0,0,0,0,0,0,0,0];
						this.helpprices = [1000,1000,900,1000,800,1000,900,1000,2000,5000,10000,20000];
						this.helpforges = [];
						super();
				}
				
				public function ClearCommand() : * {
				}
				
				public function InitGame(param1:int) : * {
				}
				
				public function OnRobotAction(param1:TimerEvent) : * {
				}
				
				public function PrepareRobotAction(param1:Number) : * {
				}
		}
}

