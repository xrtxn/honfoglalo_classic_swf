package syscode
{
    import flash.events.*;
    import flash.utils.Timer;

    public class SemuPlayer
    {
        public function SemuPlayer(aname:String)
        {
            var n:int = 0;
            var attrnameoc:String = null;
            var value:* = undefined;
            var attrname:* = undefined;
            var arr:Array = null;
            this.freehelps = [5, 3, 7, 6, 0, 0, 0, 0, 0, 0, 0, 0];
            this.helpprices = [1000, 1000, 900, 1000, 800, 1000, 900, 1000, 2000, 5000, 10000, 20000];
            this.helpforges = [];
            super();
            this.name = aname;
            var tag:Object = Config.semuplayers[this.name];
            if (tag)
            {
                for (attrnameoc in tag)
                {
                    value = tag[attrnameoc];
                    attrname = attrnameoc.toLocaleLowerCase();
                    if (attrname == "freehelps")
                    {
                        arr = Util.StringVal(value).split(",");
                        for (n = 0; n < arr.length; n++)
                        {
                            this.freehelps[n] = Util.NumberVal(arr[n]);
                        }
                    }
                    else
                    {
                        this[attrname] = value;
                    }
                }
            }
            this.usecustomavatar = this.usecustom;
            this.customavatar = this.custom;
            this.extavatar = this.imgurl;
            this.xplevel = Semu.CalculateXPLevel(this.xppoints);
        }
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
        public var sndvol:int = 0;
        public var flags:int = 32768;
        public var soldier:int = 1;
        public var shieldmission:int = 0;
        public var shieldmission_rt:int = 0;
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

        public function ClearCommand():*
        {
            this.cmd = "";
            this.tag_cmd = "";
        }

        public function InitGame(apnum:int):*
        {
            this.playernum = apnum;
            this.points = 0;
            this.base = 0;
            this.selection = 0;
            this.basestate = 0;
            this.passive = false;
            this.cmd = "";
            this.tag_cmd = "";
            this.deadtime = 0;
            this.help_used_average = false;
            this.help_used_range = false;
            this.help_used_half = false;
            this.help_used_answers = false;
            this.usedhelps = 0;
            this.soldier = apnum == 1 ? int(Sys.mydata.soldier) : int(Math.random() * 8) + 2;
        }

        public function PrepareRobotAction(adelay:Number):*
        {
            this.robotcommandtimer = new Timer(adelay * 1000, 1);
            this.robotcommandtimer.addEventListener(TimerEvent.TIMER, this.OnRobotAction);
            this.robotcommandtimer.start();
        }

        public function OnRobotAction(e:TimerEvent):*
        {
            Semu.RobotAction(this.playernum);
        }
    }
}
