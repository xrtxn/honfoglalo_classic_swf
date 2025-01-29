package syscode
{
    import flash.events.*;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.utils.getTimer;

    public class Comm
    {
        public static var lastcmd:String;

        public static var lastcmdobj:Object;

        public static var cmdqueue:Array;

        public static var commlog:int = 3;

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
        public static var xrt_bypass_encryption:Boolean = true;
        private static var cchannel:CommChannel = null;
        private static var lchannel:CommChannel = null;
        private static var hchannel:CommChannel = null;
        private static var xs_game:BinarySocket = null;
        private static var xs_heartbeat:BinarySocket = null;

        public static function Init():*
        {
            clientcc = 1 + Math.floor(Math.random() * 1000000000);
            xs_game = new BinarySocket("G");
            xs_heartbeat = new BinarySocket("H");
            cchannel = new CommChannel("C", xs_game);
            lchannel = new CommChannel("L", xs_game);
            hchannel = new CommChannel("H", xs_heartbeat);
            hchannel.ignoreready = true;
            Comm.connchecktimer = new Timer(1000, 1);
            Comm.connchecktimer.addEventListener(TimerEvent.TIMER, OnConnCheckTimer);
            Comm.connbreaktimer = new Timer(8000, 1);
            Comm.connbreaktimer.addEventListener(TimerEvent.TIMER, OnConnBreakTimer);
            Comm.heartbeattimer = new Timer(1000, 0);
            Comm.heartbeattimer.addEventListener(TimerEvent.TIMER, OnHeartBeatTimer);
            Comm.heartbeattimer.start();
            Reset();
        }

        public static function StartConnCheckAnim(nodelay:Boolean = false):void
        {
            if (Sys.connection_lost_visible)
            {
                return;
            }
            if (nodelay)
            {
                OnConnCheckTimer(null);
                return;
            }
            if (Modules.GetClass("uibase", "uibase.ConnectWait").mc == null)
            {
                if (!Comm.connchecktimer.running)
                {
                    Comm.connchecktimer.start();
                }
            }
        }

        public static function StopConnCheckAnim():void
        {
            Comm.connchecktimer.reset();
            Comm.connbreaktimer.reset();
            Sys.HideConnectWait();
        }

        public static function ProcessHeartBeatAnswer(xml:XML):void
        {
            var cs:int = 0;
            var nodelist:* = xml.children();
            var htag:Object = Util.XMLTagToObject(nodelist[0]);
            var res:int = Util.NumberVal(htag.R);
            if (res != 0)
            {
                if (res == 3)
                {
                    Comm.StopCommunication("ProcessHeartBeatAnswer", "AutoReconnect from testing signal, connid:" + Comm.connid + ", connstate:" + Comm.connstate);
                    Comm.ReConnect(Sys.screen);
                }
                return;
            }
            var ctime:int = getTimer();
            var okay:Boolean = true;
            Comm.last_hb_recv = ctime;
            if (Comm.ModuleLoadingPhase)
            {
                Comm.StopConnCheckAnim();
                return;
            }
            if (Comm.connstate >= 4 && Comm.listening)
            {
                cs = Util.NumberVal(htag.S);
                if ((cs & 1) == 0)
                {
                    if (Comm.lchannel.msgtime > 0 && ctime - Comm.lchannel.msgtime > 1500)
                    {
                        Comm.StartConnCheckAnim();
                        if (Comm.xs_game.connstate > 4)
                        {
                            Comm.xs_game.connstate = 4;
                        }
                        Comm.lchannel.TransmitRequest();
                        okay = false;
                    }
                }
            }
            if (okay)
            {
                Comm.StopConnCheckAnim();
            }
        }

        public static function Reset():void
        {
            Comm.connstate = 0;
            Comm.connid = "";
            Comm.listening = false;
            Comm.iamready = false;
            Comm.cmdqueue = [];
            Comm.lastcmd = "";
            Comm.lastcmdobj = null;
            Comm.last_hb_recv = 0;
            Comm.xs_game.Close();
            Comm.xs_heartbeat.Close();
            Comm.lchannel.Reset();
            Comm.cchannel.Reset();
            Comm.hchannel.Reset();
            Comm.StopConnCheckAnim();
        }

        public static function Connect(screen:String = ""):void
        {
            trace("Comm.Connect ", Config.serveraddress, Config.httpport, Config.xsocketaddress, Config.protocol);
            Sys.firstdatafunc = SysInit.AfterConnect;
            Comm.serveraddress = Config.serveraddress;
            Comm.httpport = Config.httpport;
            Comm.xsocketaddress = Config.xsocketaddress;
            Comm.xsocketport = Config.xsocketport;
            Comm.protocol = Config.protocol;
            Comm.httpuri = Comm.protocol + "://" + Comm.serveraddress;
            if (Comm.httpport > 0 && Comm.httpport != 80)
            {
                Comm.httpuri = Comm.httpuri + (":" + Comm.httpport);
            }
            Comm.httpuri = Comm.httpuri + "/game";
            Comm.Login(screen);
        }

        public static function ReConnect(screen:String = ""):void
        {
            Comm.reconnect = true;
            Comm.preconnid = Comm.connid;
            Comm.Login(screen);
        }

        public static function Listen(isready:Boolean):void
        {
            if (Comm.listening)
            {
                return;
            }
            lchannel.SendRequest("<LISTEN READY=\"" + (isready ? "1" : "0") + "\" />");
            Comm.listening = true;
            Comm.iamready = isready;
        }

        public static function ProcessListenAnswer(xml:XML):void
        {
            var stopcomm:Boolean = false;
            Comm.StopConnCheckAnim();
            var nodelist:* = xml.children();
            var htag:Object = Util.XMLTagToObject(nodelist[0]);
            var res:* = Util.NumberVal(htag.R);
            Comm.listening = false;
            Comm.iamready = false;
            if (res == 0)
            {
                Comm.connstate = 5;
                Sys.ProcessDataXML(xml);
            }
            else
            {
                stopcomm = true;
                switch (res)
                {
                    case 9:
                    case 22:
                        stopcomm = false;
                }
                if (stopcomm)
                {
                    Comm.StopCommunication("ListenResultError", "AutoReconnect, res:" + res + ", connstate:" + Comm.connstate);
                    Comm.ReConnect();
                }
            }
        }

        public static function Ready():*
        {
            if (Comm.connstate >= 4)
            {
                if (Comm.iamready)
                {
                    return;
                }
                if (Comm.listening)
                {
                    Comm.iamready = true;
                    Comm.SendCommand("READY", "");
                }
                else
                {
                    Comm.Listen(true);
                }
            }
        }

        public static function Login(screen:String = ""):void
        {
            trace("Comm.Login screen: " + screen);
            Comm.connstate = 3;
            var extraparams:* = "";
            CommCrypt.Reset();
            Comm.loginpsid = Util.NumberVal(Config.flashvars.psid);
            var shk:Array = CommCrypt.GenerateSharedKey();
            extraparams += " KV=\"" + shk[0] + "\"";
            extraparams += " KD=\"" + shk[1] + "\"";
            extraparams += " LOGINSYSTEM=\"" + Config.loginsystem + "\"";
            extraparams += " CLIENTTYPE=\"" + Config.clienttype + "\"";
            extraparams += " CLIENTVER=\"" + Version.value + "\"";
            extraparams += " PAGEMODE=\"" + Config.pagemode + "\"";
            extraparams += " EXTID=\"" + Util.StrXmlSafe(Config.loginextid) + "\"";
            extraparams += " TIME=\"" + Config.logintime + "\"";
            extraparams += " GUID=\"" + Config.loginguid + "\"";
            extraparams += " SIGN=\"" + Config.loginsign + "\"";
            extraparams += " PSID=\"" + Comm.loginpsid + "\"";
            extraparams += " CC=\"" + Comm.clientcc + "\"";
            extraparams += " WH=\"" + Util.StrXmlSafe(screen) + "\"";
            Comm.loginparams = "UID=\"" + Config.loginuserid + "\" NAME=\"" + Util.StrXmlSafe(Config.loginusername) + "\" " + extraparams;
            Comm.SendCommand("LOGIN", Comm.loginparams);
            Comm.StartConnCheckAnim(!Comm.reconnect);
        }

        public static function SendCommand(cmd:*, params:*, aonresult:Function = null, aobj:* = null, aargs:* = null):*
        {
            if (Comm.connstate < 2)
            {
                DBG.Trace("Comm.SendCommand \"" + cmd + "\", not connected, state:" + Comm.connstate + " at " + Util.FormatTimeStamp(true, true));
                return;
            }
            Comm.cmdqueue.push({
                        "command": cmd,
                        "parameters": params,
                        "onresult": aonresult,
                        "obj": aobj,
                        "args": aargs
                    });
            Comm.HandleCommandQueue();
        }

        public static function ProcessCommandAnswer(xml:XML):void
        {
            trace("ProcessCommandAnswer(xml:XML): " + xml);
            Comm.StopConnCheckAnim();
            var nodelist:* = xml.children();
            var htag:Object = Util.XMLTagToObject(nodelist[0]);
            var res:* = Util.NumberVal(htag.R);
            var lastcmdobj:Object = Comm.lastcmdobj;
            Comm.lastcmdobj = null;
            if (res == 0 && Comm.lastcmd == "LOGIN")
            {
                trace("login thingy");
                if (Comm.loginpsid > 0 && !Comm.reconnect)
                {
                    if (Util.NumberVal(Config.flashvars.prostat, 1) == 1)
                    {
                        Util.ExtraRequest("prostat.php?op=client_login&psid=" + Comm.loginpsid);
                    }
                }
                Comm.connid = htag.CID;
                Comm.reconnect = false;
                Comm.connstate = 4;
                Comm.Listen(true);
            }
            else if (Comm.connstate >= 4 && res == 12)
            {
                trace("already logged in error for already established connection?");
            }
            else
            {
                Sys.ProcessCMDAnswer(xml);
            }
            trace("--- lastcmdobj: " + lastcmdobj.args);
            if (lastcmdobj != null && lastcmdobj.onresult != null)
            {
                if (lastcmdobj.args)
                {
                    lastcmdobj.onresult.apply(lastcmdobj.obj, [res, xml, lastcmdobj.args]);
                }
                else
                {
                    lastcmdobj.onresult.apply(lastcmdobj.obj, [res, xml]);
                }
            }
            trace("ProcessCommandQueue");
            Comm.HandleCommandQueue();
        }

        public static function HandleCommandQueue():*
        {
            trace("Comm.cmdqueue.length: " + Comm.cmdqueue.length);
            if (!cchannel.ready)
            {
                return;
            }
            if (Comm.cmdqueue.length < 1)
            {
                return;
            }
            var cobj:* = Comm.cmdqueue.shift();
            Comm.lastcmdobj = cobj;
            trace("<" + cobj.command + " " + cobj.parameters + " />");
            Comm.lastcmd = cobj.command;
            cchannel.SendRequest("<" + cobj.command + " " + cobj.parameters + " />", "");
        }

        public static function StopCommunication(reason:String, info:String = ""):void
        {
            DBG.Trace("Stopping communication...");
            DBG.SendCustomLog(reason, info, "LOGOUT");
            Comm.StopConnCheckAnim();
            Comm.Reset();
        }

        public static function ClientTrace(tcode:int, tmsg:String):*
        {
            if (Semu.enabled || !Config.inbrowser || xrt_bypass_encryption)
            {
                trace("ClientTrace(" + tcode + ", \"" + tmsg + "\");");
                return;
            }
        }

        public static function OnConnect(e:*):*
        {
            trace("OnConnect for Semu... NOT IMPLEMENTED.");
        }

        public static function DataReceived(adata:ByteArray, atype:String, flags:uint, prot:String):void
        {
            var xml:XML;
            var dec:String = null;
            dec = "";
            if (!xrt_bypass_encryption)
            {
                if ((flags & 1) == 1)
                {
                    CommCrypt.StartEncryption();
                    dec = CommCrypt.BinaryDecrypt(adata);
                }
                else
                {
                    dec = CommCrypt.BinaryDecrypt(adata, true);
                }
            }
            else
            {
                dec = String(adata);
            }
            last_received_message = dec;
            xml = null;
            try
            {
                xml = new XML("<?xml version=\"1.0\" encoding=\"utf-8\"?><ROOT>" + dec + "</ROOT>");
            }
            catch (e:Error)
            {
                trace("XML format error: " + e.errorID + ": " + e.message + "\n" + dec);
                return;
            }
            Comm.XMLReceived(xml, atype, prot);
        }

        public static function XMLReceived(xml:XML, type:String, prot:String):void
        {
            trace("XMLReceived xml:" + xml);
            if (Comm.commlog >= 1)
            {
                DBG.Trace("ReceiveXML(" + type + "/" + prot + ") at " + Util.FormatTimeStamp(true, true) + ":", xml.toString().replace(/[\r\n]+/g, "\n"));
            }
            var nodelist:* = xml.children();
            var htagname:String = String(nodelist[0].name());
            trace("htagname: " + htagname);
            var htag:Object = Util.XMLTagToObject(nodelist[0]);
            if (htagname == "ERROR")
            {
                Comm.StopCommunication("XMLERROR");
                Sys.CommunicationStopped(Lang.Get("server_connect_error"));
                return;
            }
            var ec:int = 0;
            if (htag == null)
            {
                trace("htag == null");
                ec = 1;
            }
            else if (htag.R === undefined)
            {
                ec = 2;
            }
            else if (htag.MN === undefined)
            {
                ec = 6;
            }
            if (ec != 0)
            {
                trace("Error in received XML. Error code: " + ec);
                return;
            }
            var cid:String = Util.StringVal(htag.CID);
            trace("cid should match " + Comm.connid);
            trace("type: " + type);
            if (Comm.connid != "" && cid != "" && htag.CID != Comm.connid)
            {
                trace("Connection id mismatch! message ignored.");
                return;
            }
            if (Semu.enabled || xrt_bypass_encryption)
            {
                type = htagname;
            }
            if (htagname == "H" && type == "H" && (Comm.connstate >= 4 && cid == Comm.connid))
            {
                hchannel.XMLReceived(xml);
            }
            else if (htagname == "L" && (type == "L" || type == "G") && (Comm.connstate >= 4 && cid == Comm.connid))
            {
                lchannel.XMLReceived(xml);
            }
            else if (htagname == "C" && (type == "C" || type == "G") && (Comm.connstate >= 4 && cid == Comm.connid || Comm.connstate == 3 && Comm.connid == ""))
            {
                cchannel.XMLReceived(xml);
            }
            else if (Comm.commlog >= 1)
            {
                DBG.Trace("ReceiveXML(" + type + "/" + prot + ") HTAGNAME error, htagname:" + htagname + ", connstate:" + Comm.connstate + ", cid:" + cid + ", connid:" + Comm.connid);
            }
        }

        public function Comm()
        {
            super();
        }

        public static function OnConnBreakTimer(e:TimerEvent):void
        {
            Comm.StopCommunication("OnConnBreakTimer");
            Sys.CommunicationStopped(Lang.Get("server_connect_error"));
        }

        public static function OnConnCheckTimer(e:TimerEvent):void
        {
            if (Sys.connection_lost_visible)
            {
                return;
            }
            Comm.connchecktimer.reset();
            Comm.connbreaktimer.start();
            Sys.ShowConnectWait();
        }

        public static function OnHeartBeatTimer(e:TimerEvent):void
        {
            var mlp:String = null;
            if (Semu.enabled || xrt_bypass_encryption)
            {
                return;
            }
            var ctime:int = getTimer();
            if (Comm.connstate >= 3)
            {
                if (Comm.cchannel.msgtime > 0 && ctime - Comm.cchannel.msgtime > 1000 && !Comm.cchannel.ready)
                {
                    Comm.StartConnCheckAnim();
                    if (Comm.connstate >= 5)
                    {
                        if (Comm.xs_game.connstate > 4)
                        {
                            Comm.xs_game.connstate = 4;
                        }
                        Comm.cchannel.TransmitRequest();
                    }
                }
            }
            if (Comm.connstate >= 4)
            {
                if (!Comm.ModuleLoadingPhase && Comm.last_hb_recv > 0 && Comm.last_hb_recv < ctime - 1500)
                {
                    Comm.StartConnCheckAnim();
                    if (Comm.xs_heartbeat.connstate > 4)
                    {
                        Comm.xs_heartbeat.connstate = 4;
                    }
                }
                if (Comm.last_hb_recv <= 0)
                {
                    Comm.last_hb_recv = ctime;
                }
                mlp = !!Comm.ModuleLoadingPhase ? "MLP=\"1\"" : "";
                Comm.hchannel.SendRequest("", mlp);
                if (!Comm.listening)
                {
                }
            }
        }
    }
}
