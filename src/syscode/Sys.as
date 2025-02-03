package syscode
{
    import com.greensock.TweenMax;

    import fl.motion.easing.Linear;

    import flash.display.*;
    import flash.events.*;
    import flash.geom.Rectangle;
    import flash.media.SoundMixer;
    import flash.system.Security;
    import flash.text.*;
    import flash.utils.*;

    public class Sys
    {
        public static var gsqc:SqControl;

        public static var wasstatetag:Boolean;

        public static var tag_state:Object;

        public static var tag_cmd:Object;

        public static var tag_mydata:Object;

        public static var tag_activeseproom:Object;

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

        public static var syscodeversion:String = "real";

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

        public static var tag_tournament:Array = new Array();

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

        public static var videoads_ready:Boolean = false;

        public static var AutoStartAdaptiveUrl:String = "";

        private static var skinsloading:Object = {};

        private static var skinscache:Object = {};

        private static var skinsrefnum:int = 0;

        public static function Init():*
        {
            var f:* = undefined;
            Reset();
            Comm.Init();
            Semu.Init();
            Sys.gsqc = new SqControl("GSQC");
            Sys.gsqc.OnFinished = function():*
            {
                Sys.SqFinished();
            };
            Imitation.gsqc = Sys.gsqc;
            f = TweenMax;
            f = Util;
            f = Lang;
            f = Help;
            f = Imitation;
            f = DBG;
            f = Extdata;
            f = AvatarFactory;
            f = AvatarMov;
            f = AvatarBodyMov;
            f = AvatarAnimMov;
            f = WinMgr;
            f = Romanization;
            f = ChatMessageBuffer;
            f = LegoChatMessageBuffer;
            f = BrowserVideoad;
        }

        public static function Reset():void
        {
            tag_state = null;
            tag_cmd = null;
            tag_mydata = null;
            tag_qcats = null;
            tag_shutdown = null;
            tag_question = null;
            tag_tipquestion = null;
            tag_brokenseries = null;
            tag_division = null;
            tag_reward = null;
            mydata = {"id": -1};
            screen = "";
            prevscreen = "";
            activetutorial = "";
            tutorialphase = "";
            wasstatetag = false;
        }

        public static function OnUpdateFrame(e:*):void
        {
            ++frames;
            Imitation.UpdateFrame();
        }

        public static function OnStageResize(e:*):void
        {
            Imitation.StageResized(Imitation.stage.stageWidth, Imitation.stage.stageHeight);
            WinMgr.ReAlign();
            Modules.AlignWaitMc();
            Aligner.StageResized(Imitation.stage.stageWidth, Imitation.stage.stageHeight);
        }

        public static function ClearPerMessageTags():*
        {
            tag_cmd = null;
            tag_shutdown = null;
            tag_wrongq = null;
            tag_activeseproom = null;
            tag_waitstate = null;
        }

        public static function ProcessXMLTags(xml:XML, fromcmd:Boolean):*
        {
            var taglist:XMLList;
            var tagcount:int;
            var cyccount:int;
            var Lobby:Object;
            var TournamentWin:Object;
            var tournamentCollection:Array;
            var ttt:Object;
            var node:XML = null;
            var nname:String = null;
            var tag:Object = null;
            var first:Boolean = false;
            var notifs:Object = null;
            var exist:Boolean = false;
            var notifObj:Object = null;
            var tttext:String = null;
            var notificon:String = null;
            var tournament_joined:int = 0;
            var t:int = 0;
            trace("Processing xml tags");
            trace("Sys.screen: " + Sys.screen);
            if (xml == null)
            {
                return;
            }
            Sys.wasstatetag = false;
            taglist = xml.children();
            if (taglist == null)
            {
                return;
            }
            tagcount = int(taglist.length);
            cyccount = 0;
            Lobby = null;
            TournamentWin = null;
            tournamentCollection = new Array();
            if ((Sys.screen == "VILLAGE" || Sys.screen == "LOBBY") && WinMgr.WindowOpened("lobby.Lobby"))
            {
                Lobby = Modules.GetClass("lobby", "lobby.Lobby");
            }
            ttt = Modules.GetClass("tournament", "tournament.TournamentWin");
            if (ttt.mc)
            {
                TournamentWin = ttt.mc;
            }
            for each (node in taglist)
            {
                cyccount++;
                if (cyccount > 500)
                {
                    throw new Error("main loop cycle counter reached threshold: " + cyccount + ", tagcount was:" + tagcount);
                }
                nname = String(node.name());
                tag = Util.XMLTagToObject(node);
                if ("STATE" == nname)
                {
                    Sys.wasstatetag = true;
                    tag_state = tag;
                    Sys.ClearPerMessageTags();
                    Sys.tagproc_STATE(tag);
                }
                else if ("MYDATA" == nname)
                {
                    first = Sys.tag_mydata == null;
                    Sys.tag_mydata = tag;
                    Sys.tagproc_MYDATA(tag);
                    notifs = Modules.GetClass("uibase", "uibase.Notifications");
                    if (first)
                    {
                        if (Boolean(notifs) && typeof notifs.Init == "function")
                        {
                            notifs.Init();
                        }
                    }
                    if (Boolean(notifs) && Boolean(notifs.mc))
                    {
                        CollectNotifications();
                    }
                }
                else if ("LEVELCHANGE" == nname)
                {
                    Sys.tag_levelchange = tag;
                }
                else if ("QCATS" == nname)
                {
                    tag_qcats = tag;
                    Sys.tagproc_QCATS(tag);
                }
                else if ("FEATURES" == nname)
                {
                    Sys.tagproc_FEATURES(tag);
                }
                else if ("GAMEPARAMS" == nname)
                {
                    Sys.tagproc_GAMEPARAMS(tag);
                }
                else if ("ACTIVESEPROOM" == nname)
                {
                    Sys.tag_activeseproom = tag;
                }
                else if ("TOURNAMENT" == nname)
                {
                    tournamentCollection.push(tag);
                }
                else if ("WAITSTATE" == nname)
                {
                    Sys.tag_waitstate = tag;
                }
                else if ("CMD" == nname)
                {
                    Sys.tag_cmd = tag;
                }
                else if ("QUESTION" == nname)
                {
                    Sys.tag_question = tag;
                }
                else if ("TIPQUESTION" == nname)
                {
                    Sys.tag_tipquestion = tag;
                }
                else if ("SHUTDOWN" == nname)
                {
                    Sys.tag_shutdown = tag;
                }
                else if ("NOTIFICATIONS" == nname)
                {
                    Sys.tagproc_NOTIFICATIONS(tag);
                }
                else if ("DIVISION" == nname)
                {
                    Sys.tag_division = tag;
                }
                else if ("BROKENSERIES" == nname)
                {
                    Sys.tag_brokenseries = tag;
                    Sys.tagproc_BROKENSERIES(tag);
                }
                else if ("WRONGQ" == nname)
                {
                    Sys.tag_wrongq = tag;
                }
                else if ("CHATMSG" == nname)
                {
                    if (Lobby)
                    {
                        Lobby.tagproc_CHATMSG(tag);
                    }
                    else if (WinMgr.WindowOpened("friendlygame.FriendlyGame"))
                    {
                        Modules.GetClass("friendlygame", "friendlygame.FriendlyGame").tagproc_CHATMSG(tag);
                    }
                    else if (WinMgr.WindowOpened("clan.Clan"))
                    {
                        Modules.GetClass("clan", "clan.Clan").tagproc_CHATMSG(tag);
                    }
                    else if (TournamentWin)
                    {
                        TournamentWin.tagproc_CHATMSG(tag);
                    }
                }
                else if ("HIDEMSG" == nname)
                {
                    if (Lobby)
                    {
                        Lobby.tagproc_HIDEMSG(tag);
                    }
                }
                else if ("MCUL" == nname)
                {
                    if (Lobby)
                    {
                        Lobby.tagproc_MCUL(tag);
                    }
                }
                else if ("PCHATS" == nname)
                {
                    if (Lobby)
                    {
                        Lobby.tagproc_PCHATS(tag);
                    }
                }
                else if ("PCHUSERS" == nname)
                {
                    if (Lobby)
                    {
                        Lobby.tagproc_PCHUSERS(tag);
                    }
                }
                else if ("REWARD" == nname)
                {
                    Sys.tag_reward = tag;
                    if ("MAP" != Sys.screen.substr(0, 3) && "MINITOUR" != Sys.screen && Util.StringVal(Sys.tag_reward.TYPE) == "VIDEOAD")
                    {
                        TweenMax.delayedCall(1, WinMgr.OpenWindow, ["reward.Reward", {
                                        "fadeIn": "zoom_out",
                                        "type": 2,
                                        "ready": true
                                    }]);
                    }
                    else if ("MAP" != Sys.screen.substr(0, 3) && "MINITOUR" != Sys.screen && Util.StringVal(Sys.tag_reward.TYPE) == "TRIALPAY")
                    {
                        TweenMax.delayedCall(1, WinMgr.OpenWindow, ["reward.Reward", {
                                        "fadeIn": "zoom_out",
                                        "type": 3,
                                        "ready": true
                                    }]);
                    }
                    else if (Util.StringVal(Sys.tag_reward.TYPE) != "VIDEOAD")
                    {
                        exist = false;
                        notifs = Modules.GetClass("uibase", "uibase.Notifications");
                        if (Boolean(notifs) && Boolean(notifs.mc))
                        {
                            exist = true;
                        }
                        if (exist)
                        {
                            notifObj = new Object();
                            tttext = "";
                            if (Util.StringVal(Sys.tag_reward.TYPE) == "TOURNAMENT")
                            {
                                tttext = Lang.Get("tournament_reward_notification");
                            }
                            else if (Util.StringVal(Sys.tag_reward.NOTIFICATION).indexOf("lang:") > -1)
                            {
                                tttext = Lang.Get(Util.StringVal(Sys.tag_reward.NOTIFICATION).replace("lang:", ""));
                            }
                            else
                            {
                                tttext = Util.StringVal(Sys.tag_reward.NOTIFICATION);
                            }
                            notificon = "GETREWARD";
                            if (Util.StringVal(Sys.tag_reward.CHARACTER) != "")
                            {
                                notificon = Util.StringVal(Sys.tag_reward.CHARACTER);
                            }
                            notifObj = {
                                    "name": "reward",
                                    "priority": 100,
                                    "icon": notificon,
                                    "icontype": "icon",
                                    "smallicon": "GETREWARD",
                                    "smallicon_color": "0xFF0000",
                                    "smallicon_blink": true,
                                    "text": tttext,
                                    "callback": function():*
                                    {
                                        WinMgr.OpenWindow("reward.Reward", {"type": 3});
                                    }
                                };
                            notifs.Add(notifObj);
                        }
                    }
                }
            }
            if (tournamentCollection.length > 0)
            {
                tournament_joined = -1;
                t = 0;
                while (t < tournamentCollection.length)
                {
                    if (tournamentCollection[t].JOINED == "1")
                    {
                        tournament_joined = t;
                        break;
                    }
                    t++;
                }
                if (tournament_joined == -1)
                {
                    Sys.tag_tournament[0] = tournamentCollection[0];
                }
                else
                {
                    Sys.tag_tournament[0] = tournamentCollection[tournament_joined];
                }
                if (Boolean(TournamentWin) && Sys.tag_tournament.length > 0)
                {
                    TournamentWin.tagproc_TOURNAMENT(Sys.tag_tournament[0]);
                }
            }
            Imitation.DispatchGlobalEvent("TAGSPROCESSED");
        }

        public static function ProcessDataXML(xml:XML):void
        {
            Sys.ProcessXMLTags(xml, false);
            if (firstdatafunc != null)
            {
                firstdatafunc();
                firstdatafunc = null;
            }
            var mname:String = "villagemap";
            if ("TOURNAMENT" == Sys.screen || "WAIT" == Sys.screen || "MAP" == Sys.screen.substr(0, 3) || "MINITOUR" == Sys.screen || "LEFTGAME" == Sys.screen)
            {
                mname = "triviador";
            }
            else if ("VILLAGE" == Sys.screen || "LOBBY" == Sys.screen)
            {
                mname = "villagemap";
            }
            else
            {
                mname = "villagemap";
            }
            var devmode:int = Util.NumberVal(Config.sysconf["DEVMODE"]);
            if (mname == "villagemap" || "WAIT" == Sys.screen)
            {
                if (Sys.CheckFeature("SEPROOMS"))
                {
                    Modules.GetClass("friendlygame", "friendlygame.FriendlyGame").CheckSeproomWaiting(true);
                }
            }
            if (activemodule != mname)
            {
                ActivateModule(mname, xml);
            }
            else
            {
                CallProcessorFunction("ProcessDataXML", [xml]);
            }
        }

        public static function ActivateModule(aname:String, xml:XML):void
        {
            var t1:Number = NaN;
            var ActiveModuleLoaded:Function = null;
            var ShowActiveModule:Function = null;
            var ActiveModuleProgress:Function = null;
            ActiveModuleLoaded = function():void
            {
                var delay:Number = NaN;
                Modules.ShowModuleWait(aname, -1);
                Imitation.UpdateFrame();
                activemodule = aname;
                var t2:Number = new Date().time;
                var tt:Number = t2 - t1;
                if (!Config.mobile && tt < 500)
                {
                    delay = 0.5 - tt / 1000;
                    TweenMax.delayedCall(delay, ShowActiveModule);
                }
                else
                {
                    ShowActiveModule();
                }
            };
            ShowActiveModule = function():void
            {
                CallProcessorFunction("ShowModule", []);
                CallProcessorFunction("ProcessDataXML", [xml]);
            };
            ActiveModuleProgress = function(e:*):void
            {
                Modules.ShowModuleWait(aname, e.target.progress);
            };
            if (activemodule != "" && activemodule != aname)
            {
                CallProcessorFunction("HideModule", []);
                activemodule = "";
            }
            t1 = new Date().time;
            Modules.ShowModuleWait(aname, 0);
            Modules.LoadModule(aname, ActiveModuleLoaded, ActiveModuleProgress);
        }

        public static function CallProcessorFunction(afuncname:String, aparams:Array):*
        {
            var pc:Object = Modules.GetProcessorClass(activemodule);
            if (pc)
            {
                if (typeof pc[afuncname] == "function")
                {
                    return pc[afuncname].apply(null, aparams);
                }
                Comm.StopCommunication("ProcessorFunctionMissing", activemodule + ":" + afuncname);
            }
            else
            {
                Comm.StopCommunication("ProcessorClassMissing", activemodule + ":" + afuncname);
            }
            return false;
        }

        public static function HandleCommandResult(ec:int):void
        {
            switch (ec)
            {
                case 0:
                    return;
                case 3:
                case 11:
                case 12:
                    Comm.StopCommunication("CommandResultError", String(ec));
                    Sys.CommunicationStopped(Lang.get ("gs_error_" + ec));
            }
        }

        public static function ProcessCMDAnswer(xml:XML):void
        {
            trace("ProcessCMDAnswer");
            var nodelist:* = xml.children();
            var htag:Object = Util.XMLTagToObject(nodelist[0]);
            Sys.HandleCommandResult(Util.NumberVal(htag.R));
            Sys.ProcessXMLTags(xml, true);
        }

        public static function SqFinished():*
        {
            Comm.Ready();
            Sys.ProcessCommandTag();
        }

        public static function ProcessCommandTag():*
        {
            if (Sys.tag_cmd == null)
            {
                return;
            }
            var servercmd:String = Util.StringVal(Sys.tag_cmd.CMD);
            if (servercmd == "")
            {
                return;
            }
            CallProcessorFunction("ProcessCommandTag", [servercmd, Sys.tag_cmd]);
        }

        public static function tagproc_STATE(tag:*):*
        {
            screen = Util.StringVal(tag.SCR);
            playersonline = Util.NumberVal(tag.PO);
        }

        public static function ExplodeSoldiers(str:*):*
        {
            var b:* = undefined;
            var v:* = undefined;
            var t:Array = [];
            var i:* = 0;
            while (i < str.length)
            {
                b = str.substr(i, 1);
                v = parseInt("0x" + b);
                t.push(!!(v & 8) ? 1 : 0);
                t.push(!!(v & 4) ? 1 : 0);
                t.push(!!(v & 2) ? 1 : 0);
                t.push(!!(v & 1) ? 1 : 0);
                i++;
            }
            t.push(0);
            t.reverse();
            return t;
        }

        public static function tagproc_MYDATA(tag:*):*
        {
            var n:* = undefined;
            var arr:Array = null;
            var hfs:Array = null;
            var hfug:Array = null;
            var forge:Object = null;
            var v:int = 0;
            mydata.id = Util.NumberVal(tag.ID);
            mydata.name = Util.StringVal(tag.NAME);
            mydata.country = Util.StringVal(tag.COUNTRY);
            mydata.sex = Util.NumberVal(tag.SEX);
            mydata.birthday = Util.StringVal(tag.BIRTHDAY);
            mydata.gamecount = Util.NumberVal(tag.GAMECOUNT);
            mydata.gamecountsr = Util.NumberVal(tag.GAMECOUNTSR);
            mydata.flags = Util.NumberVal(tag.FLAGS);
            mydata.windowflags = Util.NumberVal(tag.WINDOWFLAGS);
            arr = Util.StringVal(tag.CASTLELEVEL).split(",");
            mydata.castlelevel = Util.NumberVal(arr[0]);
            mydata.castlenextlevel = Util.NumberVal(arr[1]);
            arr = Util.StringVal(tag.XPPACK).split(",");
            mydata.xppoints = Util.NumberVal(arr[0]);
            mydata.xplevel = Util.NumberVal(arr[1]);
            mydata.xpactmin = Util.NumberVal(arr[2]);
            mydata.xptonextlevel = Util.NumberVal(arr[3]);
            mydata.league = Util.NumberVal(tag.ACTLEAGUE);
            arr = Util.StringVal(tag.VEP).split(",");
            mydata.vep = Util.NumberVal(arr[0]);
            mydata.mcq = Util.NumberVal(arr[1]);
            mydata.guess = Util.NumberVal(arr[2]);
            mydata.firstlogin = Util.NumberVal(tag.FIRSTLOGIN);
            mydata.lastgame = Util.NumberVal(tag.LASTGAME);
            mydata.places = [];
            arr = Util.StringVal(tag.PLACES).split(",");
            n = 1;
            while (n <= 3)
            {
                mydata.places[n] = arr[n - 1];
                n++;
            }
            arr = Util.StringVal(tag.VICTORY).split(",");
            mydata.gloriousvictory = Util.NumberVal(arr[0]);
            mydata.fullmapvictory = Util.NumberVal(arr[1]);
            mydata.usqaccepted = Util.NumberVal(tag.USQACCEPTED);
            mydata.uls = Util.StringVal(tag.ULS).split(",");
            mydata.action = Util.StringVal(tag.ACTION);
            mydata.tutorialmission = Util.StringVal(tag.TUTORIALMISSION);
            mydata.gold = Util.NumberVal(tag.GOLD);
            arr = Util.StringVal(tag.ENERGYPACK).split(",");
            mydata.energy = Util.NumberVal(arr[0]);
            mydata.energymax = Util.NumberVal(arr[1]);
            mydata.energynextupdate = Util.NumberVal(arr[2]);
            mydata.energyrefillsecs = Util.NumberVal(arr[3]);
            mydata.energyrefillunits = Util.NumberVal(arr[4]);
            mydata.energyfreetimeremain = Util.NumberVal(arr[5]);
            mydata.mtcups = Util.StringVal(tag.MTCUPS).split(",");
            mydata.soldier = Util.NumberVal(tag.SOLDIER, 0);
            mydata.customavatar = Util.StringVal(tag.CUSTOMAVATAR);
            mydata.usecustomavatar = mydata.customavatar != "" && Util.NumberVal(tag.USECUSTOMAVATAR) != 0;
            mydata.extavatar = Util.StringVal(tag.EXTAVATAR);
            Extdata.SetUserData(mydata.id, mydata.name, !!mydata.usecustomavatar ? String(mydata.customavatar) : String(mydata.extavatar));
            mydata.mycategory = Util.NumberVal(tag.MYCATEGORY, 0);
            var taxarr:Array = Util.StringVal(tag.TAXDATA).split(",");
            mydata.taxtotal = Util.NumberVal(taxarr[0]);
            mydata.taxremaining = Util.NumberVal(taxarr[1]);
            mydata.taxbasic = Util.NumberVal(taxarr[2]);
            mydata.taxfamilies = Util.NumberVal(taxarr[3]);
            mydata.taxcastle = Util.NumberVal(taxarr[4]);
            mydata.badgebonus = Util.NumberVal(taxarr[5]);
            mydata.badgepercent = Util.NumberVal(taxarr[6]);
            var chatban:int = Util.NumberVal(mydata.chatban);
            mydata.chatban = (Sys.mydata.flags & Config.UF_CHATBANNED) != 0;
            mydata.time = getTimer();
            arr = Util.StringVal(tag.LIVES).split(",");
            mydata.maxlives = Util.NumberVal(arr[0]);
            mydata.bonuslives = Util.NumberVal(arr[1]);
            mydata.freehelps = Util.StringVal(tag.FH).split(",");
            mydata.freehelps.unshift(0);
            mydata.helpforges = [null];
            var hfsarr:Array = Util.StringVal(tag.HFS).split("|");
            var hfugarr:Array = Sys.gameparams.forgeupgrades;
            for (n in hfsarr)
            {
                hfs = Util.StringVal(hfsarr[n]).split(",");
                hfug = Util.StringVal(hfugarr[n]).split(",");
                forge = {};
                forge.id = Util.NumberVal(n) + 1;
                forge.name = Config.helpfieldname[n];
                forge.level = Util.NumberVal(hfs[0]) + 1;
                forge.prodcount = Util.NumberVal(hfs[1]);
                forge.prodtime = Util.NumberVal(hfs[2]);
                forge.remainingtime = Util.NumberVal(hfs[3]);
                forge.nextlevel = Util.NumberVal(hfug[0]) + 1;
                if (forge.nextlevel < 2)
                {
                    forge.nextlevel = 0;
                }
                forge.nextlevelpc = Util.NumberVal(hfug[1]);
                forge.nextlevelpt = Util.NumberVal(hfug[2]);
                forge.upgradeprice = Util.NumberVal(hfug[3]);
                mydata.helpforges.push(forge);
            }
            mydata.lastgametimes = Util.StringVal(tag.LT).split(",");
            if (Util.NumberVal(mydata.lastgametimes[0]) == 0)
            {
                mydata.lastgametimes = [];
            }
            mydata.fh_life_expire = Util.NumberVal(tag.FH_LIFE_EXPIRE);
            arr = Util.StringVal(tag.MISSIONS).split(",");
            mydata.activemissions = Util.NumberVal(arr[0]);
            mydata.shownmissions = Util.NumberVal(arr[1]);
            mydata.completedmissions = Util.NumberVal(arr[2]);
            arr = Util.StringVal(tag.CWINS).split(",");
            mydata.curcwins = Util.NumberVal(arr[0]);
            mydata.curcwins2 = Util.NumberVal(arr[1]);
            mydata.prevcwins = Util.NumberVal(arr[2]);
            mydata.prevcwins2 = Util.NumberVal(arr[3]);
            mydata.maxcwins = Util.NumberVal(arr[4]);
            mydata.maxcwins2 = Util.NumberVal(arr[5]);
            mydata.shlevel = Util.NumberVal(arr[6]);
            mydata.soldiers = ExplodeSoldiers(Util.StringVal(tag.SOLDIERS, "0"));
            arr = Util.StringVal(tag.WEEKLY).split(",");
            mydata.xpt = Util.NumberVal(arr[0]);
            mydata.twd = Util.NumberVal(arr[2]);
            mydata.xpm = Util.NumberVal(arr[3]);
            mydata.cw1 = mydata.curcwins;
            mydata.cw2 = mydata.curcwins2;
            mydata.lastplaces = [];
            var serdata:String = Util.StringVal(tag.LASTPLACES);
            n = 0;
            while (n < serdata.length)
            {
                v = int(Util.HexToInt(serdata.substr(n, 1)));
                if (!v)
                {
                    break;
                }
                mydata.lastplaces.push(v);
                n++;
            }
            var sm:Array = Util.StringVal(tag.SMSR).split(",");
            if (sm[0] !== "")
            {
                mydata.shieldmission = Util.HexToInt(Util.StringVal(sm[0]));
                mydata.shieldmission_rt = Util.HexToInt(Util.StringVal(sm[1]));
            }
            else
            {
                mydata.shieldmission = 256 * 256 * 256 - 1;
            }
            var sndvol:int = Util.NumberVal(tag.SNDVOL, 4095);
            if (sndvol < 0)
            {
                sndvol = 4095;
            }
            mydata.sndvol = sndvol;
            var s_mus:int = Math.floor(sndvol / 256);
            sndvol %= 256;
            var s_voi:int = Math.floor(sndvol / 16);
            var s_eff:int = sndvol % 16;
            Sounds.SetVolume(s_eff / 15, s_voi / 15, s_mus / 15);
            Imitation.DispatchGlobalEvent("MYDATACHANGE");
        }

        public static function tagproc_QCATS(tag:*):*
        {
            var n:* = undefined;
            var qcdata:* = undefined;
            var qc:* = undefined;
            Sys.questioncats = [];
            var qca:* = tag.CATEGORIES.split("|");
            n = 0;
            while (n < qca.length)
            {
                qcdata = qca[n].split("^");
                qc = {
                        "id": Util.NumberVal(qcdata[0]),
                        "name": Util.StringVal(qcdata[1])
                    };
                Sys.questioncats[n] = qc;
                n++;
            }
        }

        public static function tagproc_GAMEPARAMS(tag:*):*
        {
            var n:* = undefined;
            var badgenames:* = undefined;
            var badgebonus:Array = null;
            var i:int = 0;
            var arr:Array = Util.StringVal(tag.NRG).split(",");
            gameparams.energycost = Util.NumberVal(arr[0]);
            gameparams.separatecost = Util.NumberVal(arr[1]);
            lastenergy = -1;
            arr = Util.StringVal(tag.MP).split("|");
            gameparams.marketdata = {};
            for (n in arr)
            {
                gameparams.marketdata[n] = Util.StringVal(arr[n]).split(",");
            }
            gameparams.helpprices = Util.StringVal(tag.HP).split(",");
            gameparams.helpprices.unshift(0);
            gameparams.forgeupgrades = Util.StringVal(tag.HFUG).split("|");
            gameparams.badgebonuses = {};
            badgenames = ["CW1", "CW2", "XPT", "XPM", "RLP", "TWD", "USQ", "EXT"];
            badgebonus = Util.StringVal(tag.BADGEBONUSES).split("|");
            i = 0;
            while (i < badgebonus.length)
            {
                arr = badgebonus[i].split(",");
                for (n in arr)
                {
                    arr[n] = Util.NumberVal(arr[n]);
                }
                gameparams.badgebonuses[badgenames[i]] = arr;
                i++;
            }
            var VillageMap:* = Modules.GetClass("villagemap", "villagemap.VillageMap");
            if (VillageMap && Boolean(VillageMap.mc))
            {
                VillageMap.mc.HeaderInitLayout();
            }
        }

        public static function tagproc_NOTIFICATIONS(tag:*):*
        {
            var nl:String = null;
            var VillageMap:* = undefined;
            var exist:Boolean = false;
            var notifs:Object = null;
            var notifObj:Object = null;
            var data:Array = Util.StringVal(tag.DATA).split(",");
            var i:int = 0;
            while (i < data.length)
            {
                nl = Util.StringVal(data[i]);
                if (nl.substr(0, 11) == "SPONSORPAY:")
                {
                    VillageMap = Modules.GetClass("villagemap", "villagemap.VillageMap");
                    if (VillageMap && Boolean(VillageMap.mc))
                    {
                        VillageMap.mc.SeenVideoAdStart(nl.substr(11));
                    }
                }
                else if (nl == "DELETED")
                {
                    Util.ExternalCall("LogOut");
                }
                else if (nl == "FRIENDSUPDATE")
                {
                    Friends.LoadInternalFriends(function():*
                        {
                            Imitation.DispatchGlobalEvent("FRIENDSCHANGED");
                        });
                }
                else if (nl == "MESSAGESUPDATE")
                {
                    exist = false;
                    notifs = Modules.GetClass("uibase", "uibase.Notifications");
                    if (Boolean(notifs) && Boolean(notifs.mc))
                    {
                        exist = true;
                    }
                    if (!exist)
                    {
                        return;
                    }
                    notifObj = new Object();
                    notifObj = {
                            "name": "unreadedmail",
                            "icon": "MESSENGER",
                            "icontype": "character",
                            "smallicon": "UNREADED_MAIL",
                            "smallicon_color": "0xFF0000",
                            "smallicon_blink": true,
                            "text": Lang.get ("unreaded_mail_notification"),
                            "callback": function():*
                            {
                                WinMgr.OpenWindow("postoffice.PostOffice", {
                                            "type": "MAILS",
                                            "page": 1
                                        });
                            }
                        };
                    notifs.Add(notifObj);
                }
                else if (nl == "DELETEME")
                {
                    Util.ExternalCall("LogOut");
                }
                i++;
            }
        }

        public static function tagproc_FEATURES(tag:*):*
        {
            features_enabled = Util.StringVal(tag.ENABLED);
            feature_longrule = Sys.CheckFeature("LONGRULE");
            feature_minitournament = Sys.CheckFeature("MINITOUR");
        }

        public static function tagproc_BROKENSERIES(_tag:Object):void
        {
            var p:Object = null;
            if (Sys.screen == "VILLAGE")
            {
                p = {
                        "type": "VILLAGE",
                        "areanum": Math.floor(Util.StringVal(_tag.A).length / 2),
                        "iam": Util.NumberVal(_tag.IAM),
                        "myopp1": Util.NumberVal(_tag.OPP1),
                        "myopp2": Util.NumberVal(_tag.OPP2),
                        "tag": _tag,
                        "save": true
                    };
                WinMgr.OpenWindow("gameover.GameOver", {"prop": p});
            }
        }

        public static function CheckFeature(astr:String):Boolean
        {
            var s:* = "," + features_enabled + ",";
            return s.indexOf("," + astr + ",") >= 0;
        }

        public static function CommunicationStopped(amsg:String):void
        {
            var mw:Object;
            var lastscreen:String = null;
            var callback:Function = null;
            callback = function():void
            {
                Sys.connection_lost_visible = false;
                Comm.ReConnect(lastscreen);
            };
            if (Sys.connection_lost_visible)
            {
                return;
            }
            Sys.connection_lost_visible = true;
            lastscreen = String(Sys.screen);
            Sys.screen = "";
            Sys.gsqc.Clear();
            SoundMixer.stopAll();
            Imitation.UnFreezeAllEvents();
            mw = Modules.GetClass("uibase", "uibase.ConnectionLost");
            mw.Show(amsg, callback);
        }

        public static function HideConnectWait():*
        {
            var cw:Object = Modules.GetClass("uibase", "uibase.ConnectWait");
            if (cw)
            {
                cw.Hide();
            }
        }

        public static function ShowConnectWait():*
        {
            var cw:Object = Modules.GetClass("uibase", "uibase.ConnectWait");
            if (cw)
            {
                cw.Show();
            }
        }

        public static function ShowLoginScreen():*
        {
            WinMgr.ShowBaseHandler("uibase.LoginScreen");
        }

        public static function LoadPolicyFiles():*
        {
            if (Config.inbrowser)
            {
                Security.allowDomain("*");
                Security.allowInsecureDomain("*");
            }
            if (Config.protocol == "https")
            {
                Security.loadPolicyFile("https://graph.facebook.com/crossdomain.xml");
            }
            else
            {
                Security.loadPolicyFile("http://graph.facebook.com/crossdomain.xml");
            }
        }

        public static function FunnelVersion():String
        {
            return String(Version.value) + "/" + Config.abtest;
        }

        public static function GetGiftShareToken(clear:Boolean = true):Object
        {
            var tmp:Object = Sys.tag_giftshare;
            if (clear)
            {
                Sys.tag_giftshare = null;
            }
            return tmp;
        }

        public static function ToggleSound(sndmask:int):*
        {
            Sys.mydata.sndvol = Sys.mydata.sndvol & ~sndmask | (!!(Sys.mydata.sndvol & sndmask) ? 0 : sndmask);
            Comm.SendCommand("SETDATA", "SNDVOL=\"" + Sys.mydata.sndvol + "\"");
        }

        public static function FormatGetParamsStoc(obj:Object, addrnd:Boolean = false):String
        {
            if (obj == null)
            {
                obj = new Object();
            }
            obj.stoc = Config.stoc;
            return Util.FormatGetParams(obj, addrnd);
        }

        public static function OnMissClick(e:Object):void
        {
            // TODO: keep original code?
            var WaveAnim:Object = Modules.GetClass("uibase", "uibase.WaveAnim");
            var a:MovieClip = new WaveAnim();
            e.target.addChildAt(a, 1);
            a.x = e.localX;
            a.y = e.localY;
            TweenMax.fromTo(a, 0.5, {"frame": 1}, {
                        "frame": 30,
                        "ease": Linear,
                        "remove": true
                    });
        }

        public static function TutorialCheck(notSysActionName:String = ""):Boolean
        {
            var Tutorial:Object = Modules.GetClass("tutorial", "tutorial.Tutorial");
            if (Tutorial == null)
            {
                return false;
            }
            if (!Tutorial)
            {
                return false;
            }
            if (notSysActionName != "")
            {
                return Tutorial.TutorialCheck(notSysActionName);
            }
            return Tutorial.TutorialCheck();
        }

        public static function TutorialMissionCheck():Boolean
        {
            var Tutorial:Object = Modules.GetClass("tutorial", "tutorial.Tutorial");
            if (!Tutorial)
            {
                return false;
            }
            return Tutorial.TutorialMissionCheck();
        }

        public static function CheckWeeklyChallenge():void
        {
            if (Sys.mydata.xplevel < 11)
            {
                Sys.wasshown_weeklychallenge = true;
                return;
            }
            if (!Sys.wasshown_weeklychallenge)
            {
                JsQuery.Load(ShowWeeklyChallenge, [], "client_weekly.php?" + Sys.FormatGetParamsStoc({}, true), {"cmd": "auto"});
                Sys.wasshown_weeklychallenge = true;
            }
        }

        public static function ShowWeeklyChallenge(_jsq:Object):void
        {
            var exist:Boolean;
            var notifs:Object;
            var notifObj:Object;
            if (_jsq && _jsq.data && Boolean(_jsq.data.closetime))
            {
                rlresetremaining = Util.NumberVal(_jsq.data.closetime);
                rlresettimeref = getTimer();
            }
            if (_jsq.error > 0)
            {
                return;
            }
            if (Boolean(_jsq.data) && Boolean(_jsq.data.users) && _jsq.data.users.length < 5)
            {
                return;
            }
            exist = false;
            notifs = Modules.GetClass("uibase", "uibase.Notifications");
            if (Boolean(notifs) && Boolean(notifs.mc))
            {
                exist = true;
            }
            if (!exist)
            {
                return;
            }
            notifObj = new Object();
            notifObj = {
                    "name": "weeklychallenge",
                    "icon": "MESSENGER",
                    "icontype": "character",
                    "smallicon": "WEEKLY_CHALLENGE",
                    "smallicon_color": "0x00FF00",
                    "smallicon_blink": false,
                    "text": Lang.get ("weekly_notification"),
                    "callback": function():*
                    {
                        WinMgr.OpenWindow("ranklist.Ranklist", {
                                    "data": _jsq.data,
                                    "type": "auto",
                                    "activepage": 4
                                });
                    }
                };
            notifs.Add(notifObj);
        }

        public static function SetupFullScreenButton(fsb:MovieClip):void
        {
            Imitation.RemoveEvents(fsb);
            if (Config.mobile)
            {
                fsb.gotoAndStop(1);
                fsb.visible = false;
            }
            else
            {
                if (Imitation.stage.displayState == "fullScreenInteractive")
                {
                    fsb.gotoAndStop(2);
                }
                else
                {
                    fsb.gotoAndStop(1);
                }
                Imitation.AddEventClick(fsb, Sys.ToggleFullscreen, {"button": fsb});
                fsb.visible = true;
            }
        }

        public static function ExitFullscreen(fsb:MovieClip):void
        {
            var p:Object = null;
            if (Config.mobile)
            {
                return;
            }
            if (Imitation.stage.displayState != null)
            {
                if (Imitation.stage.displayState == "fullScreenInteractive")
                {
                    p = {"button": fsb};
                    ToggleFullscreen({"params": p});
                }
            }
        }

        public static function CollectNotifications():void
        {
            CheckTutorialNotification();
            CheckTutorialMissionNotification();
            CheckFriendInvites();
            if (!videoads_ready)
            {
                QueryVideoAds();
            }
            var needphpcollect:Boolean = false;
            var currenttime:Number = Number(getTimer() / 1000);
            var elapsed:Number = currenttime - notifcollecttime;
            if (notifcollecttime == 0)
            {
                needphpcollect = true;
            }
            else if (elapsed > Config.notifrecollectlimit)
            {
                needphpcollect = true;
                notifcollecttime = getTimer() / 1000;
            }
            if (needphpcollect)
            {
                notifcollecttime = getTimer() / 1000;
                CheckMyClanProperties();
                CheckMail();
                CheckMiniQuiz();
                CheckAdvent();
                CheckWeeklyChallenge();
            }
        }

        public static function CheckTutorialNotification():void
        {
            var ntext:String = null;
            var nicon:String = null;
            var notifObj:Object = null;
            var acc:String = null;
        }

        public static function CheckTutorialMissionNotification():void
        {
            var ntext:String = null;
            var nicon:String = null;
            var spl:Array = null;
            var id_status:String = null;
            var ida:Array = null;
            var id:String = null;
            var status:String = null;
            var boo_num:Array = null;
            var booster:String = null;
            var booster_number:int = 0;
            var bg:int = 0;
            var notifObj:Object = null;
            var exist:Boolean = false;
            var notifs:Object = Modules.GetClass("uibase", "uibase.Notifications");
            if (Boolean(notifs) && Boolean(notifs.mc))
            {
                exist = true;
            }
            if (!exist)
            {
                return;
            }
            if (Sys.mydata.tutorialmission != undefined && Sys.mydata.tutorialmission != "")
            {
                nicon = "MESSENGER";
                spl = Sys.mydata.tutorialmission.split(";");
                id_status = String(spl[0].split("TUTORIALMISSION:").join(""));
                ida = id_status.split(",");
                id = String(ida[0]);
                status = String(ida[1]);
                boo_num = spl[1].split("=");
                booster = String(boo_num[0]);
                booster_number = int(boo_num[1]);
                ntext = Lang.get ("tutm_notif_" + status + ":GENERIC");
                if (id == "SELHALF")
                {
                    nicon = "SELHALF";
                }
                if (id == "TIPRANG")
                {
                    nicon = "TIPRANG";
                }
                if (id == "AIRBORNE")
                {
                    nicon = "AIRBORNE";
                }
                if (id == "SELANSW")
                {
                    nicon = "SELANSW";
                }
                if (id == "SUBJECT")
                {
                    nicon = "SUBJECT";
                }
                if (id == "FORTRESS")
                {
                    nicon = "FORTRESS";
                }
                if (id == "TIPAVER")
                {
                    nicon = "TIPAVER";
                }
                bg = 1;
                if (status == "END")
                {
                    bg = 2;
                }
                if (status == "RUNNING")
                {
                    return;
                }
                notifObj = new Object();
                notifObj = {
                        "name": "tutorialmission",
                        "priority": 50,
                        "icon": nicon,
                        "icontype": "icon",
                        "smallicon": "TUTORIAL_MISSION",
                        "smallicon_color": "0x00FF00",
                        "smallicon_blink": false,
                        "text": ntext,
                        "bg": bg,
                        "callback": function():*
                        {
                            Sys.TutorialMissionCheck();
                        }
                    };
                notifs.Add(notifObj);
                TweenMax.killTweensOf(notifs.SetState);
                notifs.SetState("IN");
            }
        }

        public static function CheckMyClanProperties():void
        {
            JsQuery.Load(OnMyClanPropertiesResult, [], Config.CLAN_PHP + Sys.FormatGetParamsStoc({}, true), {"cmd": "menubutton"});
        }

        public static function OnMyClanPropertiesResult(_jsq:Object):void
        {
            var exist:Boolean = false;
            var notifs:Object = null;
            var notifObj:Object = null;
            if (Util.NumberVal(_jsq.error) == 0)
            {
                Sys.myclanproperties = _jsq.data;
                exist = false;
                notifs = Modules.GetClass("uibase", "uibase.Notifications");
                if (Boolean(notifs) && Boolean(notifs.mc))
                {
                    exist = true;
                }
                if (!exist)
                {
                    return;
                }
                if (_jsq.data.invites > 0)
                {
                    notifObj = new Object();
                    notifObj = {
                            "name": "claninvites",
                            "icon": "CLAN_INVITE",
                            "icontype": "icon",
                            "smallicon": "CLAN_INVITE",
                            "smallicon_color": "0xFF0000",
                            "smallicon_blink": false,
                            "text": Lang.get ("village_clan_invite_notification"),
                            "callback": function():*
                            {
                                WinMgr.OpenWindow("clan.Clan");
                            }
                        };
                    notifs.Add(notifObj);
                }
            }
        }

        public static function CheckMail():void
        {
            JsQuery.Load(CheckMailResult, [true, 0, 0], "client_messages.php?" + Sys.FormatGetParamsStoc({
                            "cmd": "list",
                            "first": 0,
                            "postbox": "to"
                        }, true));
        }

        public static function CheckMailResult(jsq:Object, draw:Boolean, first:int, scroll:int = 0):*
        {
            var n:String = null;
            var exist:Boolean = false;
            var notifs:Object = null;
            var notifObj:Object = null;
            var num:int = 0;
            var unreaded:int = 0;
            for (n in jsq.data)
            {
                num++;
                if (jsq.data[n].flag == 0)
                {
                    unreaded++;
                }
            }
            exist = false;
            notifs = Modules.GetClass("uibase", "uibase.Notifications");
            if (Boolean(notifs) && Boolean(notifs.mc))
            {
                exist = true;
            }
            if (!exist)
            {
                return;
            }
            if (unreaded > 0)
            {
                notifObj = new Object();
                notifObj = {
                        "name": "unreadedmail",
                        "icon": "MESSENGER",
                        "icontype": "character",
                        "smallicon": "UNREADED_MAIL",
                        "smallicon_color": "0xFF0000",
                        "smallicon_blink": true,
                        "text": Lang.get ("unreaded_mail_notification"),
                        "callback": function():*
                        {
                            WinMgr.OpenWindow("profile2.Profile2", {"page": 2});
                        }
                    };
                notifs.Add(notifObj);
            }
        }

        public static function CheckMiniQuiz():void
        {
            var xplevel:int = Util.NumberVal(Sys.mydata.xplevel);
            if (xplevel >= 11)
            {
                JsQuery.Load(OnCheckMiniQuizResult, [], Config.MINIQUIZ_PHP + Sys.FormatGetParamsStoc({}, true), {"cmd": "qprgame"});
            }
        }

        public static function OnCheckMiniQuizResult(_jsq:Object):void
        {
            var exist:Boolean = false;
            var notifs:Object = null;
            var notifObj:Object = null;
            if (Util.NumberVal(_jsq.error) == 0)
            {
                exist = false;
                notifs = Modules.GetClass("uibase", "uibase.Notifications");
                if (Boolean(notifs) && Boolean(notifs.mc))
                {
                    exist = true;
                }
                if (!exist)
                {
                    return;
                }
                if (_jsq.data.status == 1)
                {
                    notifObj = new Object();
                    notifObj = {
                            "name": "miniquiz",
                            "icon": "LIBRARIAN",
                            "icontype": "character",
                            "smallicon": "MINIQUIZ",
                            "smallicon_color": "0xFF0000",
                            "smallicon_blink": false,
                            "text": Lang.get ("village_miniquiz_notification"),
                            "callback": function():*
                            {
                                WinMgr.OpenWindow("miniquiz.MiniQuiz");
                            }
                        };
                    notifs.Add(notifObj);
                }
            }
        }

        public static function CheckFriendInvites():void
        {
            var finvites:int;
            var i:int;
            var f:Object = null;
            var blockeduser:Boolean = false;
            var j:int = 0;
            var f2:Object = null;
            var notifObj:Object = null;
            var exist:Boolean = false;
            var notifs:Object = Modules.GetClass("uibase", "uibase.Notifications");
            if (Boolean(notifs) && Boolean(notifs.mc))
            {
                exist = true;
            }
            if (!exist)
            {
                return;
            }
            finvites = 0;
            i = 0;
            while (i < Friends.all.length)
            {
                f = Friends.all[i];
                if (f.flag == 2)
                {
                    blockeduser = false;
                    j = 0;
                    while (j < Friends.all.length)
                    {
                        f2 = Friends.all[j];
                        if (f.id == f2.id)
                        {
                            if (f2.flag == 3)
                            {
                                blockeduser = true;
                                break;
                            }
                        }
                        j++;
                    }
                    if (!blockeduser)
                    {
                        finvites++;
                    }
                }
                i++;
            }
            if (finvites > 0)
            {
                notifObj = new Object();
                notifObj = {
                        "name": "friendinvite",
                        "icon": "MESSENGER",
                        "icontype": "character",
                        "smallicon": "FRIEND_INVITE",
                        "smallicon_color": "0xFF0000",
                        "smallicon_blink": false,
                        "text": Lang.get ("village_friend_inv_notification"),
                        "callback": function():*
                        {
                            WinMgr.OpenWindow("profile2.Profile2", {"page": 3});
                        }
                    };
                notifs.Add(notifObj);
            }
        }

        public static function CheckAdvent():void
        {
            var advent:int = Util.NumberVal(Config.sysconf["ADVENT"]);
            if (advent > 0)
            {
                JsQuery.Load(OnAdventResult, [], Config.ADVENT_PHP + Sys.FormatGetParamsStoc({}, true), {
                            "cmd": "get",
                            "advent": advent
                        });
            }
        }

        public static function OnAdventResult(_jsq:Object):void
        {
            var notifObj:Object = null;
            var exist:Boolean = false;
            var notifs:Object = Modules.GetClass("uibase", "uibase.Notifications");
            if (Boolean(notifs) && Boolean(notifs.mc))
            {
                exist = true;
            }
            if (!exist)
            {
                return;
            }
            if (Util.NumberVal(_jsq.error) == 0 && Util.NumberVal(_jsq.data.notification) == 1)
            {
                notifObj = new Object();
                notifObj = {
                        "name": "advent",
                        "icon": "GETREWARD",
                        "icontype": "icon",
                        "smallicon": "ADVENT",
                        "smallicon_color": "0xFF0000",
                        "smallicon_blink": true,
                        "text": Lang.get (Util.NumberVal(_jsq.data.notification) == 1 ? "advent_calendar_notification" : "check_calendar_notification"),
                        "callback": function():*
                        {
                            WinMgr.OpenWindow("adventcalendar.AdventCalendar", {
                                        "state": "GIFT",
                                        "advent": Util.NumberVal(_jsq.data.advent)
                                    });
                        }
                    };
                notifs.Add(notifObj);
            }
        }

        public static function StartVideoAds():void
        {
            var village:Object = Modules.GetClass("villagemap", "villagemap.VillageMap");
            if (village != null && village.mc != null)
            {
                village.mc.PauseAllSounds();
                village.clientVisible = false;
            }
            Imitation.AddStageEventListener("VIDEOAD_VIDEO_FINISHED", OnVideoAdsFinished);
            Imitation.AddStageEventListener("VIDEOAD_VIDEO_ABORTED", OnVideoAdsAborted);
            Platform.silentactivate = true;
        }

        public static function QueryVideoAds():void
        {
            var xplevel:int = Util.NumberVal(Sys.mydata.xplevel);
            if (xplevel >= 11)
            {
                Imitation.AddStageEventListener("VIDEOAD_VIDEO_AVAILABLE", OnVideoAdsAvailable);
                Imitation.AddStageEventListener("VIDEOAD_VIDEO_UNAVAILABLE", OnVideoAdsUnavailable);
                Imitation.DispatchStageEvent(null, new CustomEvent("VIDEOAD_QUERY_VIDEO", {"userid": Sys.mydata.id}));
            }
            else
            {
                Imitation.DispatchStageEvent("VIDEOAD_VIDEO_UNAVAILABLE");
            }
        }

        public static function RemoveVideoadsListeners():void
        {
            Imitation.RemoveStageEventListener("VIDEOAD_VIDEO_AVAILABLE", OnVideoAdsAvailable);
            Imitation.RemoveStageEventListener("VIDEOAD_VIDEO_UNAVAILABLE", OnVideoAdsUnavailable);
            Imitation.RemoveStageEventListener("VIDEOAD_VIDEO_FINISHED", OnVideoAdsFinished);
            Imitation.RemoveStageEventListener("VIDEOAD_VIDEO_ABORTED", OnVideoAdsAborted);
        }

        public static function SwapBitmap(_src:*, _target:Bitmap):MovieClip
        {
            if (!_target)
            {
                return null;
            }
            if (!_src)
            {
                return null;
            }
            if (!_src.parent)
            {
                return null;
            }
            var bounds:Rectangle = _src.getBounds(_src.parent);
            var smc:MovieClip = new MovieClip();
            smc.addChild(_target);
            _target.x = bounds.left + (bounds.width - _target.width) / 2;
            _target.y = bounds.top + (bounds.height - _target.height) / 2;
            _target.cacheAsBitmap = _src.cacheAsBitmap;
            _src.parent.addChildAt(smc, !!_src.parent ? _src.parent.getChildIndex(_src) : 0);
            _src.parent.removeChild(_src);
            _src.visible = false;
            _src = null;
            Imitation.SetBitmapScale(smc, -1);
            Imitation.FreeBitmapAll(smc.parent);
            Imitation.CollectChildrenAll(smc.parent);
            Imitation.UpdateAll(smc.parent);
            return smc;
        }

        public static function ExternalSkin(category:String, mc:DisplayObject, id:int, hide_placeholder:Boolean = true):*
        {
            if (!mc)
            {
                return;
            }
            if (!mc.parent)
            {
                return;
            }
            var m:* = Config.external_skin[category.toLowerCase()];
            if (m && Boolean(m[id - 1]) && m[id - 1] != "")
            {
                if (hide_placeholder)
                {
                    mc.visible = false;
                }
                if (skinsloading[category] === undefined)
                {
                    skinsloading[category] = {};
                }
                if (skinscache[category] === undefined)
                {
                    skinscache[category] = {};
                }
                skinsloading[category][id] = mc;
            }
        }

        public static function ClearSkin(category:String):*
        {
            var m:* = undefined;
            for each (m in skinscache[category])
            {
                if (m && Boolean(m.parent) && Boolean(m.parent.contains(m)))
                {
                    m.parent.removeChild(m);
                }
            }
        }

        public static function LoadSkin(category:String):*
        {
            var _closure:Function;
            var m:* = undefined;
            var id:* = undefined;
            var mc:* = undefined;
            var bitmap:* = undefined;
            var bounds:Rectangle = null;
            var amc:MovieClip = null;
            var s:Shape = null;
            var t:TextField = null;
            var tf:* = undefined;
            m = Config.external_skin[category.toLowerCase()];
            for (id in skinsloading[category])
            {
                mc = skinsloading[category][id];
                if (mc)
                {
                    if (mc.parent)
                    {
                        if (skinscache[category][id] === null || skinscache[category][id] is Bitmap)
                        {
                            mc.visible = false;
                            bitmap = skinscache[category][id];
                            if (bitmap && bitmap.width > 0)
                            {
                                mc = SwapBitmap(mc, bitmap);
                            }
                            else
                            {
                                mc.visible = true;
                            }
                        }
                        else
                        {
                            _closure = function(id:int, mc:*):*
                            {
                                skinsloading[category][id] = null;
                                MyLoader.LoadBitmap("https:" + Config.external_skin_path + "/" + m[id - 1], function(bitmap:Bitmap):*
                                    {
                                        if (!mc)
                                        {
                                            return;
                                        }
                                        if (!mc.parent)
                                        {
                                            return;
                                        }
                                        mc.visible = false;
                                        skinscache[category][id] = bitmap;
                                        if (Boolean(bitmap) && bitmap.width > 0)
                                        {
                                            SwapBitmap(mc, bitmap);
                                        }
                                        else
                                        {
                                            mc.visible = true;
                                        }
                                    });
                            };
                            _closure(id, mc);
                        }
                        if (Config.show_slots)
                        {
                            bounds = mc.getBounds(mc.parent);
                            amc = new MovieClip();
                            s = new Shape();
                            amc.x = bounds.left + bounds.width / 2;
                            amc.y = bounds.top + bounds.height / 2;
                            s.graphics.beginFill(16776960, 1);
                            s.graphics.lineStyle(2, 238, 1);
                            s.graphics.drawCircle(0, 0, 10);
                            s.graphics.endFill();
                            amc.cacheAsBitmap = true;
                            s.width = 20;
                            s.height = 20;
                            t = new TextField();
                            tf = new TextFormat("arial", 15, 0, "bold", null, null, null, null, "center");
                            t.defaultTextFormat = tf;
                            t.autoSize = "center";
                            t.x = -2.5;
                            t.y = -10.5;
                            t.text = id.toString();
                            amc.addChild(s);
                            amc.addChild(t);
                            mc.parent.addChild(amc);
                            Imitation.CollectChildrenAll(mc.parent);
                        }
                    }
                }
            }
        }

        public static function SwapImage(mc:DisplayObject, url:String):*
        {
            mc.visible = false;
            MyLoader.LoadBitmap(url, function(bitmap:*):*
                {
                    mc.parent[mc.name] = SwapBitmap(mc, bitmap);
                });
        }

        private static function ToggleFullscreen(e:Object):void
        {
            var fsb:MovieClip = null;
            if (Config.mobile)
            {
                return;
            }
            if (Imitation.stage.displayState != null)
            {
                if (Imitation.stage.displayState == "normal")
                {
                    Imitation.stage.displayState = "fullScreenInteractive";
                }
                else
                {
                    Imitation.stage.displayState = "normal";
                }
                fsb = e.params.button;
                if (fsb)
                {
                    SetupFullScreenButton(fsb);
                }
            }
        }

        public function Sys()
        {
            super();
        }

        private static function OnVideoAdsFinished(e:Event):void
        {
            Platform.silentactivate = false;
            var village:Object = Modules.GetClass("villagemap", "villagemap.VillageMap");
            if (village != null && village.mc != null)
            {
                village.mc.ResumeAllSounds();
                village.clientVisible = true;
            }
            var exist:Boolean = false;
            var notifs:Object = Modules.GetClass("uibase", "uibase.Notifications");
            if (Boolean(notifs) && Boolean(notifs.mc))
            {
                exist = true;
            }
            if (!exist)
            {
                return;
            }
            notifs.Remove({"name": "videoad"});
            videoad_available = false;
            videoads_ready = false;
        }

        private static function OnVideoAdsAborted(e:Event):void
        {
            Platform.silentactivate = false;
            var village:Object = Modules.GetClass("villagemap", "villagemap.VillageMap");
            if (village != null && village.mc != null)
            {
                village.mc.ResumeAllSounds();
                village.clientVisible = true;
            }
            var reward:Object = Modules.GetClass("reward", "reward.Reward");
            if (reward != null && reward.mc != null)
            {
                reward.mc.Hide();
            }
        }

        private static function OnVideoAdsUnavailable(e:Event):void
        {
            videoads_ready = false;
            var exist:Boolean = false;
            var notifs:Object = Modules.GetClass("uibase", "uibase.Notifications");
            if (Boolean(notifs) && Boolean(notifs.mc))
            {
                exist = true;
            }
            if (!exist)
            {
                return;
            }
            notifs.Remove({"name": "videoad"});
            videoad_available = false;
            var VillageMap:* = Modules.GetClass("villagemap", "villagemap.VillageMap");
            if (VillageMap && Boolean(VillageMap.mc))
            {
                VillageMap.mc.redrawVillage = false;
                VillageMap.mc.OnMyDataChange();
            }
        }

        private static function OnVideoAdsAvailable(e:Event):void
        {
            var notifObj:Object;
            var VillageMap:*;
            videoads_ready = true;
            var exist:Boolean = false;
            var notifs:Object = Modules.GetClass("uibase", "uibase.Notifications");
            if (Boolean(notifs) && Boolean(notifs.mc))
            {
                exist = true;
            }
            if (!exist)
            {
                return;
            }
            notifObj = new Object();
            notifObj = {
                    "name": "videoad",
                    "icon": "VIDEOAD",
                    "icontype": "icon",
                    "smallicon_color": "0x00FF00",
                    "smallicon_blink": true,
                    "text": Lang.get ("village_video_ad_notification"),
                    "callback": function():*
                    {
                        var vm:* = Modules.GetClass("villagemap", "villagemap.VillageMap");
                        if (vm && Boolean(vm.mc))
                        {
                            Sys.videoad_available = false;
                            vm.mc.redrawVillage = false;
                            vm.mc.OnMyDataChange();
                        }
                        WinMgr.OpenWindow("reward.Reward", {"type": 1});
                    }
                };
            notifs.Add(notifObj);
            videoad_available = true;
            VillageMap = Modules.GetClass("villagemap", "villagemap.VillageMap");
            if (VillageMap && Boolean(VillageMap.mc))
            {
                VillageMap.mc.redrawVillage = false;
                VillageMap.mc.OnMyDataChange();
            }
        }
    }
}
