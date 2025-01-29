package syscode
{
    import flash.events.*;
    import flash.utils.Timer;
    import flash.utils.getTimer;

    public class Semu
    {
        public static const CONNECTWAIT:Number = 0.1;
        public static var connid:String;
        public static var enabled:Boolean = false;

        public static var cmdtimeout:int = 150000;

        public static var fastbots:Boolean = true;

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

        public static var players:Array = [null, null, null, null];

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
        public static var bottimers:Array = [];
        public static var mtrooms:Array = [];
        public static var mtrooms_lastsendtime:int = 0;
        public static var current_mtroom:Object = null;
        public static var mt_player_names:Array = ["John", "Rita", "Carl", "Anita", "George", "Gina", "Thomas", "Isabel", "Leo", "Ludmilla", "Peter", "Sarah", "Robert", "Rebecca", "Henry", "Halle", "Bernard", "Beatrice", "Otto", "Amelie", "Teresa", "Joseph", "Kate", "Walter", "Deborah", "Steward jr.", "Nora"];
        public static var mt_round_gamecounts:Array = [0, 9, 3, 1];
        public static var minitour:Object = {"state": 0};
        public static var mtstartstate:int = 1;
        public static var mtstartround:int = 1;
        public static var mtrapidgames:Boolean = true;
        public static var semu_chat:* = {
                "active": false,
                "messages": [],
                "mids": [0, 0],
                "users": [[], []]
            };
        internal static var connecttimer:Timer;
        internal static var answertimer:Timer = null;

        public static function MinitournamentStart():*
        {
            var n:* = undefined;
            var p:* = undefined;
            mtstartstate = Util.NumberVal(Config.semuparams.STARTSTATE, 1);
            mtstartround = Util.NumberVal(Config.semuparams.MTSTARTROUND, 1);
            minitour = {};
            minitour.state = 1;
            minitour.starttime = getTimer();
            minitour.remaining = 5000;
            minitour.currentround = 0;
            minitour.maxrounds = 3;
            minitour.currentlyplaying = 0;
            minitour.iamout = 0;
            minitour.lastupdate = getTimer();
            minitour.players = [];
            n = 0;
            while (n < 27)
            {
                p = {
                        "id": 1000 + n,
                        "name": mt_player_names[n]
                    };
                minitour.players.push(p);
                n++;
            }
            var me:* = {
                    "id": mydata.id,
                    "name": mydata.name
                };
            n = Math.floor(Math.random() * 27);
            minitour.players[n] = me;
            minitour.roundgames = [[], [], []];
            if (mtstartround > 1)
            {
                MinitourSetRound(mtstartround - 1);
            }
        }

        public static function MinitourSetRound(around:*):*
        {
            var mtrapidgames_save:* = mtrapidgames;
            mtrapidgames = true;
            while (minitour.currentround < around)
            {
                StartMinitournamentRound();
                do
                {
                    UpdateMTGames();
                    UpdateCurrentlyPlaying();
                }
                while (minitour.currentlyplaying > 0);

            }
            minitour.state = 1;
            minitour.reamaining = 3000;
            mtrapidgames = mtrapidgames_save;
        }

        public static function StartMinitournamentRound():*
        {
            var n:* = undefined;
            var pn:* = undefined;
            var parr:Array = null;
            var aparr:* = undefined;
            var x:* = undefined;
            var pr:* = undefined;
            var g:* = undefined;
            ++minitour.currentround;
            var gamecount:* = mt_round_gamecounts[minitour.currentround];
            if (minitour.currentround == 1)
            {
                aparr = minitour.players.slice();
                n = 0;
                while (n < gamecount)
                {
                    parr = [];
                    pn = 0;
                    while (pn < 3)
                    {
                        x = Math.floor(Math.random() * aparr.length);
                        parr.push(aparr[x]);
                        aparr.splice(x, 1);
                        pn++;
                    }
                    minitour.roundgames[0].push(CreateMinitournamentGame(parr[0], parr[1], parr[2]));
                    n++;
                }
            }
            else
            {
                pr = minitour.currentround - 1;
                minitour.roundgames[pr] = [];
                parr = [];
                n = 0;
                while (n < mt_round_gamecounts[pr])
                {
                    g = minitour.roundgames[pr - 1][n];
                    pn = 1;
                    while (pn <= 3)
                    {
                        if (g.players[pn].placing == 1)
                        {
                            parr.push(g.players[pn].data);
                            if (parr.length == 3)
                            {
                                minitour.roundgames[pr].push(CreateMinitournamentGame(parr[0], parr[1], parr[2]));
                                parr = [];
                            }
                        }
                        pn++;
                    }
                    n++;
                }
            }
        }

        public static function UpdateMinitournamentState():*
        {
            var elapsed:* = getTimer() - minitour.lastupdate;
            minitour.lastupdate = getTimer();
            if (minitour.state == 1)
            {
                minitour.remaining -= elapsed;
                if (minitour.remaining <= 0)
                {
                    StartMinitournamentRound();
                    minitour.state = 2;
                }
            }
            else if (minitour.state == 2)
            {
                UpdateMTGames();
                UpdateCurrentlyPlaying();
                trace("currently playing: " + minitour.currentlyplaying);
                if (minitour.currentlyplaying <= 0)
                {
                    if (minitour.currentround < 3)
                    {
                        minitour.state = 1;
                        minitour.remaining = 7000;
                    }
                    else
                    {
                        minitour.state = 3;
                    }
                }
            }
            else if (minitour.state != 3)
            {
                trace("Unhandled minitournament state: " + minitour.state);
            }
            trace("Minitournament state: " + minitour.state + ", remaining: " + minitour.remaining);
        }

        public static function UpdateCurrentlyPlaying():*
        {
            var g:* = undefined;
            minitour.currentlyplaying = 0;
            var n:* = 0;
            while (n < mt_round_gamecounts[minitour.currentround])
            {
                g = minitour.roundgames[minitour.currentround - 1][n];
                if (g.state != 16)
                {
                    minitour.currentlyplaying += 3;
                }
                n++;
            }
        }

        public static function UpdateMTGames():*
        {
            var n:* = undefined;
            var g:* = undefined;
            n = 0;
            while (n < mt_round_gamecounts[minitour.currentround])
            {
                g = minitour.roundgames[minitour.currentround - 1][n];
                UpdateMTGameState(g);
                n++;
            }
        }

        public static function UpdateMTGameState(g:*):*
        {
            var second:* = undefined;
            var sumpoints:* = undefined;
            var third:* = undefined;
            var t:* = getTimer();
            if (g.nextchangetime > t)
            {
                return;
            }
            if (mtrapidgames)
            {
                g.nextchangetime = t + 1;
            }
            else
            {
                g.nextchangetime = t + 1000 + Math.floor(2000 * Math.random());
            }
            if (g.state == 11)
            {
                g.state = 1;
                g.phase = 0;
                g.gameround = 1;
                g.players[1].points = 1000;
                g.players[2].points = 1000;
                g.players[3].points = 1000;
            }
            else if (g.state == 1)
            {
                g.state = 3;
                g.phase = 0;
                g.gameround = 1;
                g.linplayer = 0;
                g.curplayer = 0;
                g.defender = 0;
            }
            else if (g.state == 3)
            {
                if (g.phase <= 1)
                {
                    g.linplayer = 0;
                    g.curplayer = 0;
                    g.defender = 0;
                    g.baseattack = false;
                    g.phase = 3;
                }
                else if (g.phase == 3)
                {
                    g.curplayer = 1 + Math.floor(Math.random() * 3);
                    g.phase = 6;
                }
                else if (g.phase == 6)
                {
                    g.players[g.curplayer].points += 200;
                    g.phase = 7;
                }
                else if (g.phase == 7)
                {
                    g.players[g.curplayer].points += 200;
                    g.phase = 8;
                }
                else if (g.phase == 8)
                {
                    second = GetRandomOpponent(g.curplayer);
                    g.players[second].points += 200;
                    g.curplayer = second;
                    g.phase = 9;
                }
                else if (g.phase == 9)
                {
                    sumpoints = g.players[1].points + g.players[2].points + g.players[3].points;
                    if (sumpoints < 5600)
                    {
                        ++g.gameround;
                        g.phase = 0;
                        g.curplayer = 0;
                    }
                    else
                    {
                        g.state = 4;
                        g.gameround = 1;
                        g.linplayer = 1;
                        g.curplayer = 1;
                        g.phase = 0;
                        g.defender = 0;
                    }
                }
                else
                {
                    trace("UpdateMTGameState unhandled phase: " + g.state + "/" + g.phase);
                }
            }
            else if (g.state == 4)
            {
                if (g.phase <= 1)
                {
                    g.defender = 0;
                    g.baseattack = false;
                    g.phase = 3;
                }
                else if (g.phase == 3)
                {
                    g.defender = GetRandomOpponent(g.curplayer);
                    g.baseattack = Math.random() < 0.4;
                    if (g.players[g.defender].points < 1200)
                    {
                        g.baseattack = true;
                    }
                    g.phase = 6;
                }
                else if (g.phase == 6)
                {
                    if (Math.random() < 0.5)
                    {
                        if (!g.baseattack)
                        {
                            g.players[g.curplayer].points += 400;
                            g.players[g.defender].points -= 200;
                            g.phase = 21;
                        }
                        else
                        {
                            ++g.players[g.defender].basestate;
                            if (g.players[g.defender].basestate > 2)
                            {
                                g.players[g.curplayer].points += g.players[g.defender].points;
                                g.players[g.defender].points = 0;
                                third = 6 - g.curplayer - g.defender;
                                if (g.players[third].points == 0)
                                {
                                    g.state = 15;
                                    g.phase = 0;
                                    g.gameround = 1;
                                    g.curplayer = 1;
                                }
                                else
                                {
                                    g.phase = 21;
                                }
                            }
                            else
                            {
                                g.phase = 6;
                            }
                        }
                    }
                    else
                    {
                        if (Math.random() < 0.7)
                        {
                            g.players[g.defender].points += 100;
                        }
                        g.phase = 21;
                    }
                }
                else if (g.phase == 21)
                {
                    g.defender = 0;
                    g.baseattack = 0;
                    g.phase = 0;
                    ++g.linplayer;
                    while (g.linplayer <= 3 && g.players[g.linplayer].points == 0)
                    {
                        ++g.linplayer;
                    }
                    if (g.linplayer > 3)
                    {
                        g.linplayer = 1;
                        ++g.gameround;
                        if (g.players[g.linplayer].points == 0)
                        {
                            ++g.linplayer;
                        }
                        if (g.gameround > 4)
                        {
                            g.state = 15;
                            g.gameround = 0;
                            g.phase = 0;
                        }
                        else
                        {
                            g.curplayer = g.linplayer;
                        }
                    }
                    else
                    {
                        g.curplayer = g.linplayer;
                    }
                }
                else
                {
                    trace("UpdateMTGameState unhandled phase: " + g.state + "/" + g.phase);
                }
            }
            else if (g.state == 15)
            {
                CalculateMTGamePlacings(g);
                g.state = 16;
            }
            else if (g.state != 16)
            {
                trace("Semu.UpdateMTGameState: unhandled state:" + g.state);
            }
        }

        public static function CreateMinitournamentGame(p1:*, p2:*, p3:*):*
        {
            var g:* = {
                    "state": 11,
                    "gameround": 0,
                    "linplayer": 0,
                    "curplayer": 0,
                    "defender": 0,
                    "phase": 0,
                    "baseattack": false,
                    "players": [0, {
                            "data": p1,
                            "points": 0,
                            "basestate": 0,
                            "placing": 0
                        }, {
                            "data": p2,
                            "points": 0,
                            "basestate": 0,
                            "placing": 0
                        }, {
                            "data": p3,
                            "points": 0,
                            "basestate": 0,
                            "placing": 0
                        }],
                    "nextchangetime": 0
                };
            if (mtstartstate == 3)
            {
                g.players[1].points = 1000;
                g.players[2].points = 1000;
                g.players[3].points = 1000;
                g.state = 3;
                g.phase = 0;
                g.gameround = 1;
                g.curplayer = 1;
                g.linplayer = 1;
            }
            else if (mtstartstate == 4)
            {
                g.players[1].points = 2200;
                g.players[2].points = 2200;
                g.players[3].points = 2200;
                g.state = 4;
                g.phase = 0;
                g.gameround = 1;
                g.curplayer = 1;
                g.linplayer = 1;
            }
            return g;
        }

        public static function CalculateMTGamePlacings(g:*):*
        {
            var n:* = undefined;
            var p:* = undefined;
            var maxpoints:* = undefined;
            var pnum:* = undefined;
            var i:* = undefined;
            if (g.players[1].points == g.players[2].points && g.players[1].points == g.players[3].points)
            {
                g.players[1].points += 20;
                g.players[2].points += 10;
            }
            else if (g.players[1].points == g.players[2].points || g.players[1].points == g.players[3].points)
            {
                g.players[1].points += 10;
            }
            else if (g.players[2].points == g.players[3].points)
            {
                g.players[2].points += 10;
            }
            g.players[1].placing = 0;
            g.players[2].placing = 0;
            g.players[3].placing = 0;
            p = 1;
            while (p <= 3)
            {
                maxpoints = -999999;
                pnum = 0;
                n = 1;
                while (n <= 3)
                {
                    if (g.players[n].points > maxpoints && g.players[n].placing == 0)
                    {
                        pnum = n;
                        maxpoints = g.players[n].points;
                    }
                    n++;
                }
                if (pnum == 0)
                {
                    trace("pnum is 0!!!");
                    i = 1;
                    while (i <= 3)
                    {
                        trace("  p" + i + " points=" + g.players[i].points);
                        i++;
                    }
                }
                else
                {
                    g.players[pnum].placing = p;
                }
                p++;
            }
        }

        public static function GetRandomOpponent(pnum:*):*
        {
            var opp:* = pnum + 1 + Math.floor(Math.random() * 2);
            if (opp > 3)
            {
                opp -= 3;
            }
            if (opp == pnum)
            {
                opp++;
            }
            return opp;
        }

        public static function TraceGameState(g:*):*
        {
            var pl:* = undefined;
            var n:* = undefined;
            trace("State: " + g.state + "/" + g.phase + ", gameround: " + g.gameround + ", cp: " + g.curplayer + "/" + g.linplayer + ", def.: " + g.defender + (!!g.baseattack ? " base!" : ""));
            trace("  " + g.players[1].data.name + ": " + g.players[1].points + " (" + g.players[1].basestate + "), " + g.players[2].data.name + ": " + g.players[2].points + " (" + g.players[2].basestate + "), " + g.players[3].data.name + ": " + g.players[3].points + " (" + g.players[3].basestate + ")");
            if (g.state >= 15)
            {
                pl = "";
                n = 1;
                while (n <= 3)
                {
                    pl += g.players[n].placing;
                    n++;
                }
                trace("  placings: " + pl);
            }
        }

        public static function AddMinitournamentRooms():*
        {
            var n:* = undefined;
            var rd:* = undefined;
            var elapsed:* = getTimer() - mtrooms_lastsendtime;
            for (n in mtrooms)
            {
                rd = mtrooms[n];
                rd.remaining -= elapsed;
                if (rd.remaining < 0)
                {
                    rd.open = !rd.open;
                    rd.remaining = 5000 + Math.random() * 5000;
                }
                answer += "<GAMEROOM ID=\"" + rd.id + "\" TITLE=\"" + rd.title + "\" MAP=\"WD\" TYPE=\"10\" GOLDS=\"" + rd.golds + "\" PLAYERS=\"" + rd.players + "\"" + " CLOSED=\"" + (!!rd.open ? "0" : "2") + "\" REMAINING=\"" + rd.remaining + "\" />\r\n";
                if (!rd.open && Semu.roomsel == rd.id)
                {
                    Semu.roomsel = 0;
                }
            }
            mtrooms_lastsendtime = getTimer();
        }

        public static function AddMinitournamentGameTags():*
        {
            var n:* = undefined;
            var g:* = undefined;
            var iam:* = undefined;
            var pn:* = undefined;
            var r:* = 1;
            while (r <= 3)
            {
                n = 1;
                while (n <= minitour.roundgames[r - 1].length)
                {
                    g = minitour.roundgames[r - 1][n - 1];
                    answer += "<MTGAME R=\"" + r + "\"";
                    answer += " S=\"" + g.state + "," + g.gameround + "," + g.linplayer + "," + g.curplayer + "," + g.defender + "," + (!!g.baseattack ? 1 : 0) + "\"";
                    iam = 0;
                    answer += " P=\"";
                    pn = 1;
                    while (pn <= 3)
                    {
                        if (g.players[pn].data.id == Semu.mydata.id)
                        {
                            iam = pn;
                        }
                        answer += (pn > 1 ? "|" : "") + g.players[pn].data.name + "," + g.players[pn].points + "," + g.players[pn].basestate;
                        pn++;
                    }
                    answer += "\"";
                    if (iam != 0)
                    {
                        answer += " IAM=\"" + iam + "\"";
                    }
                    answer += " />\r\n";
                    n++;
                }
                r++;
            }
        }

        public static function SendMinitournamentAnswer():*
        {
            UpdateMinitournamentState();
            answer = AnswerHeader(0);
            answer += "<STATE SCR=\"" + Semu.screen + "\" />";
            answer += "<MINITOUR NAME=\"" + current_mtroom.title + "\"";
            answer += " GPARAMS=\"1,15,4\"";
            answer += " ENTRYGOLDS=\"" + current_mtroom.golds + "\"";
            answer += " MAXROUNDS=\"3\"";
            answer += " CURRENTROUND=\"" + minitour.currentround + "\"";
            answer += " PLAYING=\"" + minitour.currentlyplaying + "\"";
            answer += " IAMOUT=\"" + minitour.iamout + "\"";
            answer += " STATE=\"" + minitour.state + "\"";
            if (minitour.state == 1)
            {
                answer += " REMAINING=\"" + minitour.remaining + "\"";
            }
            answer += " />\r\n";
            AddMinitournamentGameTags();
            AddGeneralTags();
            if (Semu.instantanswer)
            {
                SendAnswerDelayed(0.05);
            }
            else
            {
                SendAnswerDelayed(2);
            }
            instantanswer = false;
        }

        public static function ProcessChatCommand(xml:*, cmd:*, tag:*):*
        {
            var room:* = undefined;
            var id:* = undefined;
            var mid:* = undefined;
            if ("CHATADDUSER" == cmd)
            {
                Semu.AnswerCommand(xml, 0);
                if (tag.CHATID == 0)
                {
                    semu_chat.users.push([tag.UID, Sys.mydata.id]);
                    room = semu_chat.users.length - 1;
                    semu_chat.mids[room] = 0;
                    semu_chat.messages[room] = [ {
                                "uid": 6543230000000030,
                                "name": "user30",
                                "msg": "bla, bla, bla..."
                            }];
                }
                else
                {
                    room = tag.CHATID;
                    semu_chat.users[room].push(tag.UID);
                }
                Semu.instantanswer = true;
                SendChatAnswer(GetChatRooms());
                return true;
            }
            if ("CHATREMOVEUSER" == cmd)
            {
                Semu.AnswerCommand(xml, 0);
                room = tag.CHATID;
                id = semu_chat.users[room].indexOf(tag.UID);
                if (id >= 0)
                {
                    semu_chat.users[room].splice(id, 1);
                }
                Semu.instantanswer = true;
                SendChatAnswer(GetChatRooms());
                return true;
            }
            if ("CHATMSG" == cmd)
            {
                Semu.AnswerCommand(xml, 0);
                room = !!tag.PCH ? tag.PCH : 1;
                semu_chat.messages[room].push({
                            "uid": Sys.mydata.id,
                            "name": Sys.mydata.name,
                            "msg": tag.MSG
                        });
                mid = ++semu_chat.mids[room];
                Semu.instantanswer = true;
                SendChatAnswer(" <CHATMSG" + (room > 1 ? " PCH=\"" + room + "\"" : "") + " MID=\"" + mid + "\" MT=\"1371483998\" UID=\"" + Sys.mydata.id + "\" NAME=\"" + Sys.mydata.name + "\" MSG=\"" + tag.MSG + "\"/>");
                semu_chat.q = tag.MSG;
                return true;
            }
            if ("CHATCLOSE" == cmd)
            {
                Semu.AnswerCommand(xml, 0);
                room = tag.ID;
                semu_chat.users[room] = null;
                semu_chat.messages[room] = null;
                semu_chat.mids[room] = null;
                Semu.instantanswer = true;
                SendChatAnswer(GetChatRooms());
                return true;
            }
            return false;
        }

        public static function AddChatTags():*
        {
            var m:* = undefined;
            var mid:* = undefined;
            var i:* = undefined;
            if (!semu_chat.active)
            {
                semu_chat.active = true;
                semu_chat.users[1] = [6543230000000002, 6543230000000003, 6543230000000004, 6543230000000005, 6543230000000006, 6543230000000029, 6543230000000030];
                semu_chat.messages[1] = [ {
                            "uid": -1,
                            "name": "system",
                            "msg": "1|user30"
                        }, {
                            "uid": 6543230000000029,
                            "name": "user29",
                            "msg": "... cincognak az egerek"
                        }];
                semu_chat.users[1].push(Sys.mydata.id);
                answer += "<CHATROOM MSTATE=\"" + semu_chat.mids[1] + "\" UIDS=\"" + semu_chat.users[1].join(",") + "\" />";
                m = semu_chat.messages[1];
                mid = 0;
                mid = semu_chat.mids[1];
                while (mid < semu_chat.messages[1].length)
                {
                    answer += "<CHATMSG MID=\"" + mid + "\" MT=\"1371483998\" UID=\"" + m[mid].uid + "\" NAME=\"" + m[mid].name + "\" MSG=\"" + m[mid].msg + "\"/>";
                    mid++;
                }
                semu_chat.mids[1] = mid;
            }
            else
            {
                answer += GetChatRooms();
                i = 2;
                while (i < semu_chat.users.length)
                {
                    if (semu_chat.users[i] !== null)
                    {
                        mid = 0;
                        mid = semu_chat.mids[i];
                        while (mid < semu_chat.messages[i].length)
                        {
                            m = semu_chat.messages[i][mid];
                            answer += "<CHATMSG PCH=\"" + i + "\" MID=\"" + mid + "\" MT=\"1371483998\" UID=\"" + m.uid + "\" NAME=\"" + m.name + "\" MSG=\"" + m.msg + "\"/>";
                            mid++;
                        }
                        if (semu_chat.mids[i] != mid)
                        {
                            Semu.instantanswer = true;
                        }
                        semu_chat.mids[i] = mid;
                    }
                    i++;
                }
            }
        }

        public static function ResetChat():*
        {
            semu_chat.active = false;
            var id:* = semu_chat.users[1].indexOf(Sys.mydata.id);
            if (id >= 0)
            {
                semu_chat.users[1].splice(id, 1);
            }
        }

        public static function GetChatRooms():*
        {
            var answer:* = "";
            var i:* = 2;
            while (i < semu_chat.users.length)
            {
                if (semu_chat.users[i] !== null)
                {
                    answer += "<PCHATROOM ID=\"" + i + "\" MSTATE=\"" + semu_chat.mids[i] + "\" UIDS=\"" + semu_chat.users[i].join(",") + "\" />";
                }
                i++;
            }
            return answer;
        }

        public static function SendChatAnswer(ans:* = ""):*
        {
            answer = Semu.AnswerHeader(0);
            answer += "<STATE SCR=\"" + Semu.screen + "\" />";
            answer += ans;
            trace(answer);
            Semu.AddGeneralTags();
            if (Semu.instantanswer)
            {
                Semu.SendAnswerDelayed(0.05);
            }
            else
            {
                Semu.SendAnswerDelayed(2);
            }
            Semu.instantanswer = false;
        }

        public static function Init():*
        {
            mydata = null;
            mtrooms = [ {
                        "id": 9,
                        "title": "1k",
                        "golds": 1000,
                        "playercount": 0,
                        "open": false,
                        "remaining": 4000
                    }, {
                        "id": 10,
                        "title": "2k",
                        "golds": 2000,
                        "playercount": 0,
                        "open": false,
                        "remaining": 6000
                    }, {
                        "id": 11,
                        "title": "5k",
                        "golds": 5000,
                        "playercount": 0,
                        "open": false,
                        "remaining": 7000
                    }, {
                        "id": 12,
                        "title": "10k",
                        "golds": 10000,
                        "playercount": 0,
                        "open": false,
                        "remaining": 10000
                    }];
            SetMap("WD", 20, [null, undefined, ",2,3,11,", ",1,3,6,", ",1,2,4,", ",3,5,", ",4,7,", ",2,7,9,10,", ",5,6,8,9,", ",7,9,", ",6,7,8,10,12,13,", ",6,9,11,12,", ",1,10,12,", ",9,10,11,13,14,", ",9,12,14,", ",12,13,15,", ",14,"]);
        }

        public static function InitConfig():*
        {
            var arr:* = undefined;
            if (Config.semumissions.MISSIONS !== undefined)
            {
                arr = Util.StringVal(Config.semumissions.MISSIONS).split(",");
                Semu.activemissions = parseInt(arr[0]);
                Semu.shownmissions = parseInt(arr[1]);
                Semu.completedmissions = parseInt(arr[2]);
            }
        }

        public static function ProcessMessage(axmlstr:String, id:String):*
        {
            var nodelist:*;
            var htagname:String;
            var xml:XML = null;
            trace("Semu.ProcessMessage", axmlstr);
            try
            {
                xml = new XML("<?xml version=\"1.0\" encoding=\"utf-8\"?><ROOT>" + axmlstr + "</ROOT>");
            }
            catch (e:Error)
            {
                trace("Semu XML format error: " + e.errorID + ": " + e.message);
                return;
            }
            nodelist = xml.children();
            htagname = String(nodelist[0].name());
            if (nodelist.length() < 2)
            {
                trace("Semu: Error in message format!");
                SendAnswer("<ERROR RESULT=\"1\" />", id);
            }
            else if (htagname == "L")
            {
                ProcessListen(xml);
            }
            else if (htagname == "C")
            {
                ProcessCommand(xml);
            }
            else
            {
                trace("Semu: Error: L or C tag is missing!");
                SendAnswer("<ERROR RESULT=\"1\" />", id);
            }
        }

        public static function ProcessCommand(xml:XML):*
        {
            var n:* = undefined;
            var rd:* = undefined;
            var helpidx:int = 0;
            var sex:* = undefined;
            var sndvol:int = 0;
            var flags:int = 0;
            var cid:String = null;
            var soldier:* = undefined;
            var sm:Array = null;
            var customavatar:String = null;
            var usecustomavatar:int = 0;
            var mycategory:int = 0;
            var asave:* = undefined;
            var req:Object = null;
            var dat:Array = null;
            var res:* = null;
            var i:int = 0;
            var uid:String = null;
            var name:String = null;
            var obj:Object = null;
            var custom:int = 0;
            var nodelist:* = xml.children();
            var cmd:* = nodelist[1].name();
            var tag:* = Util.XMLTagToObject(nodelist[1]);
            trace("SEMU ProcessCommand " + cmd);
            if (ProcessChatCommand(xml, cmd, tag))
            {
                return;
            }
            if ("LOGIN" == cmd)
            {
                ProcessCmdLogin(xml);
                AnswerCommand(xml, 0);
            }
            else if ("STARTROBOT" == cmd)
            {
                StartGame();
                HandleGamePhase();
                AnswerCommand(xml, 0);
            }
            else if ("READY" == cmd)
            {
                Semu.isready = true;
                HandleGamePhase();
                AnswerCommand(xml, 0);
            }
            else if ("SELECT" == cmd)
            {
                ProcessCmdSelect(Semu.mydata.playernum, tag.AREA);
                AnswerCommand(xml, 0);
            }
            else if ("SELECTMH" == cmd)
            {
                ProcessCmdSelectMH(tag);
                AnswerCommand(xml, 0);
            }
            else if ("TIP" == cmd)
            {
                ProcessCmdTip(Semu.mydata.playernum, tag.TIP);
                AnswerCommand(xml, 0);
            }
            else if ("ANSWER" == cmd)
            {
                ProcessCmdAnswer(Semu.mydata.playernum, tag.ANSWER);
                AnswerCommand(xml, 0);
            }
            else if ("ENTERROOM" == cmd)
            {
                Semu.roomsel = Util.NumberVal(tag.ROOM, 0);
                if (Semu.screen == "LOBBY")
                {
                    current_mtroom = null;
                    for (n in mtrooms)
                    {
                        rd = mtrooms[n];
                        if (rd.id == Semu.roomsel)
                        {
                            current_mtroom = rd;
                            break;
                        }
                    }
                }
                AddSmallUserListTag();
                SendWaitHallAnswerNow();
                AnswerCommand(xml, 0);
            }
            else if ("EXITROOM" == cmd)
            {
                Semu.roomsel = 0;
                SendWaitHallAnswerNow();
                AnswerCommand(xml, 0);
            }
            else if ("CLOSEGAME" == cmd)
            {
                Semu.roomsel = 0;
                Semu.screen = "WAIT";
                SendWaitHallAnswerNow();
                AnswerCommand(xml, 0);
            }
            else if ("HELP" == cmd)
            {
                AnswerCommand(xml, 0, ProcessCmdHelp(Semu.mydata.playernum, tag.HELP));
            }
            else if ("COLLECTHELP" == cmd)
            {
                helpidx = Config.helpindexes[tag.HELP] - 1;
                ++Semu.mydata.freehelps[helpidx];
                Semu.sendmydata = true;
                AnswerCommand(xml, 0);
            }
            else if ("COLLECTTAX" == cmd)
            {
                Semu.mydata.golds = Semu.mydata.golds + 4500;
                Semu.sendmydata = true;
                AnswerCommand(xml, 0);
            }
            else if ("UPGRADEFORGE" == cmd)
            {
                Semu.sendmydata = true;
                AnswerCommand(xml, 0);
            }
            else if ("MESSAGE" == cmd)
            {
                Semu.tag_messages = "<MESSAGE FROM=\"" + Semu.mydata.playernum + "\" MSG=\"" + tag.TEXT + "\" />";
                AnswerCommand(xml, 0);
                AnswerAllPlayers();
            }
            else if ("MISSION" == cmd)
            {
                AnswerCommand(xml, 0, ProcessCmdMission(tag.ID, tag.CMD));
            }
            else if ("SETDATA" == cmd)
            {
                sex = Util.NumberVal(tag.SEX, 0);
                if (sex > 0)
                {
                    Semu.mydata.sex = sex;
                }
                sndvol = Util.NumberVal(tag.SNDVOL, -1);
                if (sndvol >= 0)
                {
                    Semu.mydata.sndvol = sndvol;
                }
                flags = Util.NumberVal(tag.FLAGS, -1);
                if (flags >= 0)
                {
                    Semu.mydata.flags = flags;
                }
                cid = Util.StringVal(tag.COUNTRY, "");
                if (cid != "")
                {
                    Semu.mydata.country = cid;
                }
                soldier = Util.NumberVal(tag.SOLDIER, 1);
                Semu.mydata.soldier = soldier;
                sm = Util.StringVal(tag.SMSR).split(",");
                Semu.mydata.shieldmission = Util.HexToInt(Util.StringVal(sm[0]));
                Semu.mydata.shieldmission_rt = Util.HexToInt(Util.StringVal(sm[1]));
                customavatar = Util.StringVal(tag.CUSTOMAVATAR, "");
                if (customavatar != "")
                {
                    Semu.mydata.customavatar = customavatar;
                }
                usecustomavatar = Util.NumberVal(tag.USECUSTOMAVATAR, -1);
                if (usecustomavatar >= 0)
                {
                    Semu.mydata.usecustomavatar = usecustomavatar;
                }
                mycategory = Util.NumberVal(tag.MYCATEGORY, 0);
                if (mycategory > 0)
                {
                    Semu.mydata.mycategory = mycategory;
                }
                asave = answer;
                answer = "";
                AddTag_MYDATA();
                AnswerCommand(xml, 0, answer);
                answer = asave;
            }
            else if ("CHANGEWAITHALL" == cmd)
            {
                AnswerCommand(xml, 0);
                if (Semu.screen == "LOBBY")
                {
                    ResetChat();
                }
                Semu.screen = Util.StringVal(tag.WH);
                if (Semu.screen == "GAME")
                {
                    Semu.screen = "WAIT";
                }
                Semu.roomsel = 0;
                SendWaitHallAnswerNow();
            }
            else if ("SEMUSTARTMINITOUR" == cmd)
            {
                AnswerCommand(xml, 0);
                Semu.screen = "MINITOUR";
                MinitournamentStart();
                SendMinitournamentAnswer();
            }
            else if ("GETEXTDATA" == cmd)
            {
                req = Util.XMLTagToObject(xml);
                dat = req.GETEXTDATA.IDLIST.split(",");
                res = "<EXTDATA>";
                i = 0;
                while (i < dat.length)
                {
                    uid = Util.StringVal(dat[i]);
                    for (name in Config.semuplayers)
                    {
                        obj = Config.semuplayers[name];
                        if (uid == Util.StringVal(obj.ID))
                        {
                            res += "<USER";
                            res += " ID=\"" + Util.StrXmlSafe(uid) + "\"";
                            res += " NAME=\"" + Util.StrXmlSafe(Util.StringVal(name)) + "\"";
                            custom = Util.NumberVal(obj.USECUSTOM);
                            res += " USECUSTOM=\"" + custom + "\"";
                            if (custom > 1 || uid == Util.StringVal(Sys.mydata.id))
                            {
                                res += " CUSTOM=\"" + Util.StrXmlSafe(Util.StringVal(obj.CUSTOM)) + "\"";
                            }
                            if (custom <= 0 || uid == Util.StringVal(Sys.mydata.id))
                            {
                                res += " IMGURL=\"" + Util.StrXmlSafe(Util.StringVal(obj.IMGURL)) + "\"";
                            }
                            res += " />";
                        }
                    }
                    i++;
                }
                res += "</EXTDATA>";
                AnswerCommand(xml, 0, res);
            }
            else
            {
                trace("Semu: unknown command: " + cmd);
                AnswerCommand(xml, 0);
            }
        }

        public static function AnswerCommand(axml:XML, aresult:int, adatatag:String = ""):*
        {
            var htag:* = Util.XMLTagToObject(axml.children()[0]);
            var s:* = "<C CID=\"" + Semu.connid + "\" MN=\"" + htag.MN + "\" R=\"" + aresult + "\" />" + adatatag;
            SendAnswer(s, "C");
        }

        public static function ProcessListen(xml:XML):*
        {
            var htag:* = Util.XMLTagToObject(xml.children()[0]);
            Semu.lmsgnum = Util.NumberVal(htag.MN, 0);
            var tag:* = Util.XMLTagToObject(xml.children()[1]);
            Semu.isready = tag.READY == "1";
            if (Semu.screen == "VILLAGE" || Semu.screen == "WAIT" || Semu.screen == "LOBBY")
            {
                SendWaitHallAnswer();
            }
            else if (Semu.screen == "MINITOUR")
            {
                SendMinitournamentAnswer();
            }
            else if (Semu.screen.substr(0, 3) == "MAP")
            {
                if (Semu.isready)
                {
                    HandleGamePhase();
                }
            }
            else
            {
                trace("Semu: ProcessListen unhandled screen: " + Semu.screen);
            }
        }

        public static function HandleGamePhase():*
        {
            var p:SemuPlayer = null;
            var poff:SemuPlayer = null;
            var pdef:SemuPlayer = null;
            var a:Object = null;
            var n:int = 0;
            var c:int = 0;
            var fac:int = 0;
            var selcount:int = 0;
            var i:int = 0;
            var ogood:* = undefined;
            var dgood:* = undefined;
            var lgr:* = undefined;
            var playermask:* = 0;
            var m:* = undefined;
            if (Semu.state == 11)
            {
                AnswerAllPlayers();
                SetState(1, 0, 0);
                return;
            }
            if (Semu.state == 1)
            {
                switch (Semu.phase)
                {
                    case 0:
                        AnswerAllPlayers();
                        Semu.lpnum = 1;
                        SetPhase(game_rule == 1 ? 3 : 1);
                        break;
                    case 1:
                        Semu.nextplayer = Semu.lpnum;
                        Semu.availableareas = GetAvailableAreas(Semu.nextplayer);
                        SetPlayerCmd(Semu.nextplayer, "SELECT", "AVAILABLE=\"" + Util.IntToHex(Semu.availableareas, 6) + "\"");
                        AnswerAllPlayers();
                        SetPhase(Semu.game_rule == 1 ? 3 : 3);
                        break;
                    case 3:
                        Semu.nextplayer = Semu.lpnum;
                        p = Semu.players[Semu.nextplayer];
                        if (game_rule == 1)
                        {
                            Semu.availableareas = Semu.GetAvailableAreas(Semu.nextplayer);
                            p.selection = RandomSelectArea(Semu.availableareas);
                        }
                        if (p.selection > 0)
                        {
                            p.base = p.selection;
                            a = Semu.areas[p.selection];
                            a.base = true;
                            a.owner = Semu.nextplayer;
                            a.value = 1000;
                            p.points += a.value;
                            AnswerAllPlayers();
                            ++Semu.lpnum;
                            if (Semu.lpnum > 3)
                            {
                                SetState(Semu.game_rule == 1 ? 3 : 2, 1, 0);
                            }
                            else if (game_rule == 0)
                            {
                                SetPhase(1);
                            }
                        }
                }
                return;
            }
            if (Semu.state == 2)
            {
                switch (Semu.phase)
                {
                    case 0:
                        Semu.lpnum = 0;
                        Semu.nextplayer = 0;
                        ResetSelections();
                        AnswerAllPlayers();
                        SetPhase(1);
                        break;
                    case 1:
                        CalculateNextPlayer();
                        Semu.availableareas = GetAvailableAreas(Semu.nextplayer);
                        if (Util.CountBits(Semu.availableareas) == 1)
                        {
                            Semu.players[Semu.nextplayer].selection = RandomSelectArea(Semu.availableareas);
                            JumpPhase(3);
                            break;
                        }
                        SetPlayerSelectCmd(Semu.nextplayer);
                        AnswerAllPlayers();
                        SetPhase(3);
                        break;
                    case 3:
                        if (Semu.players[Semu.nextplayer].selection > 0)
                        {
                            AnswerAllPlayers();
                            selcount = 0;
                            i = 1;
                            while (i <= 3)
                            {
                                if (Semu.players[i].selection > 0)
                                {
                                    selcount++;
                                }
                                i++;
                            }
                            if (selcount >= 3)
                            {
                                SetPhase(4);
                                break;
                            }
                            SetPhase(1);
                        }
                        break;
                    case 4:
                        SelectMCQuestion();
                        PrepareAnswers();
                        i = 1;
                        while (i <= 3)
                        {
                            SetPlayerCmd(i, "ANSWER", "");
                            i++;
                        }
                        AnswerAllPlayers();
                        SetPhase(5);
                        break;
                    case 5:
                        c = 0;
                        i = 1;
                        while (i <= 3)
                        {
                            if (Semu.players[i].answer >= 0)
                            {
                                c++;
                            }
                            i++;
                        }
                        if (c >= Math.min(3, FreeAreaCount()))
                        {
                            JumpPhase(6);
                        }
                        break;
                    case 6:
                        Semu.tag_results = FormatAnswerResultTag(true);
                        AnswerAllPlayers();
                        SetPhase(7);
                        break;
                    case 7:
                        Semu.tag_results = "";
                        i = 1;
                        while (i <= 3)
                        {
                            p = Semu.players[i];
                            if (p.selection > 0 && p.answer == Semu.mc_question_goodanswer)
                            {
                                OccupyArea(p.selection, i);
                            }
                            i++;
                        }
                        AnswerAllPlayers();
                        fac = FreeAreaCount();
                        if (fac < 1)
                        {
                            SetState(4, 1, 0);
                        }
                        else if (fac < 3 || Semu.gameround == 6)
                        {
                            SetState(3, 1, 0);
                        }
                        else
                        {
                            SetState(2, Semu.gameround + 1, 0);
                        }
                }
                return;
            }
            if (Semu.state == 3)
            {
                switch (Semu.phase)
                {
                    case 0:
                        Semu.lpnum = 0;
                        Semu.nextplayer = 0;
                        ResetSelections();
                        Semu.answercount = 0;
                        Semu.tag_results = "";
                        AnswerAllPlayers();
                        SetPhase(1);
                        break;
                    case 1:
                        SelectGuessQuestion();
                        PrepareAnswers();
                        n = 1;
                        while (n <= 3)
                        {
                            SetPlayerCmd(n, "TIP", "PLAYERS=\"3\"");
                            n++;
                        }
                        AnswerAllPlayers();
                        SetPhase(2);
                        break;
                    case 2:
                        if (Semu.answercount >= 3)
                        {
                            JumpPhase(3);
                        }
                        break;
                    case 3:
                        Semu.tag_results = FormatTipInfoTag(true) + FormatTipResultTag();
                        Semu.nextplayer = Semu.tipwinorder[0];
                        Semu.lpnum = 1;
                        freeareas_win_order += Semu.tipwinorder[0];
                        if (Semu.game_rule == 1)
                        {
                            freeareas_win_order += Semu.tipwinorder[0];
                            freeareas_win_order += Semu.tipwinorder[1];
                        }
                        AnswerAllPlayers();
                        SetPhase(4);
                        break;
                    case 4:
                        Semu.tag_results = "";
                        ResetSelections();
                        Semu.availableareas = GetAvailableAreas(Semu.nextplayer);
                        if (Util.CountBits(Semu.availableareas) == 1)
                        {
                            Semu.players[Semu.nextplayer].selection = RandomSelectArea(Semu.availableareas);
                            JumpPhase(5);
                            return;
                        }
                        SetPlayerSelectCmd(Semu.nextplayer);
                        AnswerAllPlayers();
                        SetPhase(5);
                        break;
                    case 5:
                        p = Semu.players[Semu.nextplayer];
                        if (p.selection > 0)
                        {
                            OccupyArea(p.selection, Semu.nextplayer);
                            JumpPhase(6);
                        }
                        break;
                    case 6:
                        AnswerAllPlayers();
                        if (Semu.game_rule == 0)
                        {
                            if (FreeAreaCount() <= 0)
                            {
                                SetState(4, 1, 0);
                            }
                            else
                            {
                                ++Semu.gameround;
                                SetPhase(0);
                            }
                            return;
                        }
                        ++Semu.lpnum;
                        if (FreeAreaCount() <= 0)
                        {
                            SetState(4, 1, 0);
                            break;
                        }
                        if (Semu.lpnum > 3)
                        {
                            ++Semu.gameround;
                            SetPhase(0);
                            break;
                        }
                        if (Semu.lpnum == 3)
                        {
                            Semu.nextplayer = Semu.tipwinorder[1];
                        }
                        else
                        {
                            Semu.nextplayer = Semu.tipwinorder[0];
                        }
                        SetPhase(4);
                        break;
                }
                return;
            }
            if (Semu.state == 4)
            {
                switch (Semu.phase)
                {
                    case 0:
                        Semu.lpnum = 0;
                        CalculateNextPlayer();
                        ResetSelections();
                        Semu.answercount = 0;
                        Semu.tag_results = "";
                        AnswerAllPlayers();
                        SetPhase(1);
                        break;
                    case 1:
                        ResetSelections();
                        SetPlayerSelectCmd(Semu.nextplayer);
                        AnswerAllPlayers();
                        SetPhase(2);
                        break;
                    case 2:
                        p = Semu.players[Semu.nextplayer];
                        if (p.selection > 0)
                        {
                            Semu.offender = Semu.nextplayer;
                            Semu.defender = Semu.areas[p.selection].owner;
                            Semu.baseattack = Semu.areas[p.selection].base;
                            JumpPhase(3);
                        }
                        break;
                    case 3:
                        AnswerAllPlayers();
                        SetPhase(4);
                        break;
                    case 4:
                        SelectMCQuestion();
                        PrepareAnswers();
                        SetPlayerCmd(Semu.offender, "ANSWER", "OPPONENT=\"" + Semu.defender + "\"");
                        SetPlayerCmd(Semu.defender, "ANSWER", "OPPONENT=\"" + Semu.offender + "\"");
                        AnswerAllPlayers();
                        SetPhase(5);
                        break;
                    case 5:
                        if (Semu.players[Semu.offender].answer >= 0 && Semu.players[Semu.defender].answer >= 0)
                        {
                            JumpPhase(6);
                        }
                        break;
                    case 6:
                        Semu.tag_results = FormatAnswerResultTag(true);
                        AnswerAllPlayers();
                        poff = Semu.players[Semu.offender];
                        pdef = Semu.players[Semu.defender];
                        ogood = poff.answer == Semu.mc_question_goodanswer;
                        dgood = pdef.answer == Semu.mc_question_goodanswer;
                        SetPhase(21);
                        if (!ogood)
                        {
                            if (dgood)
                            {
                                pdef.points += 100;
                            }
                            break;
                        }
                        if (Semu.offender == Semu.defender)
                        {
                            Semu.players[Semu.offender].basestate = Math.max(0, Semu.players[Semu.offender].basestate - 1);
                            SetPhase(17);
                            break;
                        }
                        if (ogood && !dgood)
                        {
                            if (Semu.areas[poff.selection].fortress)
                            {
                                Semu.areas[poff.selection].fortress = false;
                                SetPhase(15);
                                break;
                            }
                            if (Semu.baseattack)
                            {
                                ++pdef.basestate;
                                SetPhase(15);
                                break;
                            }
                            OccupyArea(poff.selection, Semu.offender);
                            break;
                        }
                        SetPhase(10);
                        break;
                    case 10:
                        Semu.tag_results = "";
                        SelectGuessQuestion();
                        PrepareAnswers();
                        SetPlayerCmd(Semu.offender, "TIP", "");
                        SetPlayerCmd(Semu.defender, "TIP", "");
                        AnswerAllPlayers();
                        SetPhase(11);
                        break;
                    case 11:
                        if (Semu.answercount >= 2)
                        {
                            JumpPhase(12);
                        }
                        break;
                    case 12:
                        Semu.tag_results = FormatTipInfoTag(true) + FormatTipResultTag();
                        AnswerAllPlayers();
                        poff = Semu.players[Semu.offender];
                        pdef = Semu.players[Semu.defender];
                        SetPhase(21);
                        if (Semu.tipwinorder[0] == Semu.offender)
                        {
                            if (Semu.areas[poff.selection].fortress)
                            {
                                Semu.areas[poff.selection].fortress = false;
                                SetPhase(15);
                                break;
                            }
                            if (Semu.baseattack)
                            {
                                ++pdef.basestate;
                                SetPhase(15);
                                break;
                            }
                            OccupyArea(poff.selection, Semu.offender);
                            break;
                        }
                        pdef.points += 100;
                        break;
                    case 15:
                        Semu.tag_results = "";
                        AnswerAllPlayers();
                        if (Semu.players[Semu.defender].basestate > 2)
                        {
                            Semu.DefeatPlayer(Semu.offender, Semu.defender);
                            SetPhase(21);
                            break;
                        }
                        SetPhase(4);
                        break;
                    case 17:
                        Semu.tag_results = "";
                        AnswerAllPlayers();
                        if (Semu.players[Semu.offender].basestate > 0)
                        {
                            SetPhase(4);
                            break;
                        }
                        SetPhase(21);
                        break;
                    case 19:
                        Semu.tag_results = "";
                        AnswerAllPlayers();
                        SetPhase(1);
                        break;
                    case 21:
                        Semu.tag_results = "";
                        AnswerAllPlayers();
                        lgr = Semu.gameround;
                        CalculateNextPlayer();
                        if (ActivePlayerCount() < 2 || Semu.gameround > (Semu.game_rule == 0 ? 6 : 4))
                        {
                            if (EqualPoints() > 0)
                            {
                                SetState(5, 0, 0);
                            }
                            else
                            {
                                SetState(15, 0, 0);
                            }
                        }
                        else if (Semu.gameround != lgr)
                        {
                            SetPhase(0);
                        }
                        else
                        {
                            SetPhase(1);
                        }
                }
                return;
            }
            if (Semu.state == 5)
            {
                switch (Semu.phase)
                {
                    case 0:
                        Semu.lpnum = 0;
                        Semu.nextplayer = 0;
                        ResetSelections();
                        Semu.answercount = 0;
                        Semu.tag_results = "";
                        AnswerAllPlayers();
                        SetPhase(1);
                        break;
                    case 1:
                        SelectGuessQuestion();
                        PrepareAnswers();
                        playermask = 0;
                        n = 1;
                        while (n <= 3)
                        {
                            m = 1;
                            while (m <= 3)
                            {
                                if (n != m && Semu.players[n].points > 0 && Semu.players[n].points == Semu.players[m].points)
                                {
                                    playermask |= 1 << n - 1;
                                    playermask |= 1 << m - 1;
                                }
                                m++;
                            }
                            n++;
                        }
                        n = 1;
                        while (n <= 3)
                        {
                            if ((playermask & 1 << n - 1) != 0)
                            {
                                SetPlayerCmd(n, "TIP", "");
                            }
                            n++;
                        }
                        AnswerAllPlayers();
                        SetPhase(2);
                        break;
                    case 2:
                        if (Semu.answercount >= EqualPoints())
                        {
                            JumpPhase(3);
                        }
                        break;
                    case 3:
                        Semu.tag_results = FormatTipInfoTag(true) + FormatTipResultTag();
                        if (Semu.EqualPoints() > 2)
                        {
                            Semu.players[Semu.tipwinorder[0]].points = Semu.players[Semu.tipwinorder[0]].points + 20;
                            Semu.players[Semu.tipwinorder[1]].points = Semu.players[Semu.tipwinorder[1]].points + 10;
                        }
                        else
                        {
                            Semu.players[Semu.tipwinorder[0]].points = Semu.players[Semu.tipwinorder[0]].points + 10;
                        }
                        AnswerAllPlayers();
                        SetState(15, 0, 0);
                }
                return;
            }
            if (Semu.state == 15)
            {
                if (Semu.phase == 0)
                {
                    HandleGameOver();
                    AnswerAllPlayers();
                    SetState(16, 0, 0);
                }
                return;
            }
            if (Semu.state == 16)
            {
                switch (Semu.phase)
                {
                    case 0:
                        AnswerAllPlayers();
                        SetPhase(1);
                        break;
                    case 1:
                }
                return;
            }
            trace("Semu.HandleGamePhase: unhandled state: " + Semu.state);
        }

        public static function SetState(astate:*, around:*, aphase:*):*
        {
            Semu.state = astate;
            Semu.gameround = around;
            Semu.phase = aphase;
        }

        public static function SetPhase(aphase:*):*
        {
            Semu.phase = aphase;
        }

        public static function JumpPhase(aphase:*):*
        {
            Semu.phase = aphase;
            HandleGamePhase();
        }

        public static function StartGame():*
        {
            var n:* = undefined;
            var i:* = undefined;
            var p:SemuPlayer = null;
            var a:* = undefined;
            Semu.screen = "MAP_" + map_id;
            Semu.send_tag_players = true;
            Semu.tag_results = "";
            Semu.freeareas_win_order = "";
            var tmp:Array = Util.StringVal(Config.semuparams.RULES).split(",");
            Semu.game_rule = Util.NumberVal(tmp[0], 1);
            var parr:* = [Semu.mydata, new SemuPlayer(Config.semuparams.OPP1), new SemuPlayer(Config.semuparams.OPP2)];
            if (Config.semuparams.RANDOMORDER == "1")
            {
                n = 1;
                while (parr.length > 0)
                {
                    i = Math.floor(Math.random() * parr.length);
                    Semu.players[n] = parr[i];
                    parr.splice(i, 1);
                    n++;
                }
            }
            else
            {
                n = 1;
                while (n <= 3)
                {
                    Semu.players[n] = parr[n - 1];
                    n++;
                }
            }
            Semu.players[1].soldier = Sys.mydata.soldier;
            n = 1;
            while (n <= 3)
            {
                p = Semu.players[n];
                p.InitGame(n);
                n++;
            }
            n = 1;
            while (n <= map_areanum)
            {
                a = {};
                a.number = n;
                a.value = 0;
                a.owner = 0;
                a.base = false;
                a.fortress = false;
                Semu.areas[n] = a;
                n++;
            }
            InitStartState();
        }

        public static function InitStartState():*
        {
            var n:* = undefined;
            var p:* = undefined;
            var pnum:* = undefined;
            var startround:* = undefined;
            if (Semu.game_rule == 0)
            {
                Semu.warorder = Semu.rotation;
            }
            else
            {
                Semu.warorder = Semu.warorderstart;
            }
            n = 1;
            while (n <= 3)
            {
                p = Semu.players[n];
                p.basestate = 3 - p.starttowers;
                n++;
            }
            var startstate:* = Util.NumberVal(Config.semuparams.STARTSTATE, 11);
            if (startstate < 1)
            {
                startstate = 11;
            }
            if (startstate != 11)
            {
                if (startstate == 1)
                {
                    SetState(1, 0, 0);
                    return;
                }
                Semu.state = 1;
                SetArea(RandomSelectArea(GetAvailableAreas(1)), 1, 1000);
                SetArea(RandomSelectArea(GetAvailableAreas(2)), 2, 1000);
                SetArea(RandomSelectArea(GetAvailableAreas(3)), 3, 1000);
                if (startstate == 2)
                {
                    SetState(2, 1, 0);
                    return;
                }
                if (startstate == 3)
                {
                    SetState(3, 1, 0);
                    return;
                }
                if (startstate > 3)
                {
                    Semu.state = 3;
                    while (FreeAreaCount() > 0)
                    {
                        pnum = Math.floor(Math.random() * 3) + 1;
                        SetArea(RandomSelectArea(GetAvailableAreas(pnum)), pnum, 200);
                    }
                }
                if (startstate == 4)
                {
                    Semu.players[1].basestate = 2;
                    startround = Util.NumberVal(Config.semuparams.STARTROUND, 1);
                    SetState(4, startround, 0);
                    return;
                }
                if (startstate == 5)
                {
                    Semu.players[1].points = 2400;
                    Semu.players[2].points = 2400;
                    Semu.players[3].points = 2400;
                    SetState(5, 0, 0);
                }
                if (startstate == 15)
                {
                    if (EqualPoints() > 0)
                    {
                        Semu.players[1].points = Semu.players[1].points + 20;
                        Semu.players[2].points = Semu.players[2].points + 10;
                    }
                    SetState(15, 0, 0);
                    return;
                }
            }
            SetState(startstate, 1, 0);
        }

        public static function AnswerAllPlayers():*
        {
            var pnum:* = Semu.mydata.playernum;
            var p:SemuPlayer = Semu.players[pnum];
            answer = AnswerHeader(0);
            AddTag_STATE();
            if (Semu.send_tag_players)
            {
                AddTag_PLAYERS(pnum);
                Semu.send_tag_players = false;
            }
            answer += p.tag_cmd;
            if (Semu.send_tag_question)
            {
                answer += Semu.tag_question;
                Semu.send_tag_question = false;
            }
            answer += Semu.tag_results;
            AddGeneralTags();
            SendAnswerDelayed(0.01);
        }

        public static function AnswerHalfResult():*
        {
            var pnum:* = Semu.mydata.playernum;
            var p:SemuPlayer = Semu.players[pnum];
            answer = AnswerHeader(0);
            answer += Semu.tag_results;
            SendAnswerDelayed(0.01);
        }

        public static function SendWaitHallAnswerNow():*
        {
            if (answertimer != null)
            {
                answertimer.stop();
            }
            Semu.instantanswer = true;
            SendWaitHallAnswer();
        }

        public static function SendWaitHallAnswer():*
        {
            answer = AnswerHeader(0);
            answer += "<STATE SCR=\"" + Semu.screen + "\" />";
            if (Semu.screen == "WAIT")
            {
                AddTag_GAMEROOM();
                AddTag_WAITSTATE();
                AddTag_WRONGQ();
            }
            else if (Semu.screen == "MTROOMS")
            {
                AddMinitournamentRooms();
                AddTag_WAITSTATE();
            }
            else if (Semu.screen == "LOBBY")
            {
                AddChatTags();
                AddTag_WAITSTATE();
            }
            AddGeneralTags();
            if (Semu.instantanswer)
            {
                SendAnswerDelayed(0.05);
            }
            else
            {
                SendAnswerDelayed(2);
            }
            instantanswer = false;
        }

        public static function AnswerHeader(aresult:int):String
        {
            return "<L CID=\"" + Semu.connid + "\" MN=\"" + Semu.lmsgnum + "\" R=\"" + aresult + "\" />";
        }

        public static function AddGeneralTags():*
        {
            if (Semu.sendmydata)
            {
                AddTag_MYDATA();
                Semu.sendmydata = false;
            }
            if (Semu.sendfeatures)
            {
                AddTag_QCATS();
                AddTag_FEATURES();
                AddTag_GAMEPARAMS();
                Semu.sendfeatures = false;
            }
            answer += Semu.tag_messages;
            Semu.tag_messages = "";
        }

        public static function AddSmallUserListTag():void
        {
            var p:* = undefined;
            var s:* = "<SMALLUL UL=\"";
            var sep:String = "";
            for each (p in Config.semuplayers)
            {
                s += sep + p.ID + "^" + p.NAME;
                sep = "|";
            }
            s += "\" />";
            Semu.tag_messages = Semu.tag_messages + s;
        }

        public static function FormatTipInfoTag(addvalues:Boolean):String
        {
            var n:* = undefined;
            var pnum:* = undefined;
            var p:SemuPlayer = null;
            var s:* = "<TIPINFO";
            s += " TIMEORDER=\"" + Semu.tiporder.join("") + "\"";
            n = 0;
            while (n < Semu.tiporder.length)
            {
                pnum = Semu.tiporder[n];
                p = Semu.players[pnum];
                s += " T" + pnum + "=\"" + (p.tiptime - Semu.tipstarttime) / 1000 + "\"";
                if (addvalues)
                {
                    s += " V" + pnum + "=\"" + p.tipanswer + "\"";
                    s += " A" + pnum + "=\"" + p.tipaccuracy + "\"";
                }
                n++;
            }
            return s + " />";
        }

        public static function FormatTipResultTag():String
        {
            var s:* = "<TIPRESULT";
            s += " WINNER=\"" + Semu.tipwinorder[0] + "\"";
            s += " SECOND=\"" + Semu.tipwinorder[1] + "\"";
            s += " GOOD=\"" + Semu.guess_question.a + "\"";
            return s + " />";
        }

        public static function FormatAnswerResultTag(showgood:Boolean):String
        {
            var p:SemuPlayer = null;
            var s:* = "<ANSWERRESULT";
            var n:* = 1;
            while (n <= 3)
            {
                p = Semu.players[n];
                if (p.answer >= 0)
                {
                    s += " PLAYER" + n + "=\"" + p.answer + "\"";
                }
                n++;
            }
            if (showgood)
            {
                s += " GOOD=\"" + Semu.mc_question_goodanswer + "\"";
            }
            return s + " />";
        }

        public static function AddTag_STATE():*
        {
            var n:* = undefined;
            var p:SemuPlayer = null;
            var a:* = undefined;
            var ac:* = undefined;
            var vc:* = undefined;
            var p1:SemuPlayer = Semu.players[1];
            var p2:SemuPlayer = Semu.players[2];
            var p3:SemuPlayer = Semu.players[3];
            var s:* = "<STATE";
            s += " SCR=\"" + Semu.screen + "\"";
            s += " ST=\"" + Semu.state + "," + Semu.gameround + "," + Semu.phase + "\"";
            s += " CP=\"" + Semu.lpnum + "," + Semu.nextplayer + (Semu.state == 4 ? "," + Semu.defender : "") + "\"";
            s += " HC=\"123\"";
            s += " CHS=\"0,0,0\"";
            if (Semu.state == 4)
            {
                s += " WO=\"" + Semu.warorder + "\"";
            }
            s += " PTS=\"" + p1.points + "," + p2.points + "," + p3.points + "\"";
            s += " SEL=\"" + Util.IntToHex(p1.selection, 2) + Util.IntToHex(p2.selection, 2) + Util.IntToHex(p3.selection, 2) + "\"";
            s += " B=\"";
            n = 1;
            while (n <= 3)
            {
                p = Semu.players[n];
                s += Util.IntToHex(p.base + (p.basestate << 6), 2);
                n++;
            }
            s += "\"";
            s += " A=\"";
            n = 1;
            while (n <= map_areanum)
            {
                a = Semu.areas[n];
                ac = a.owner;
                vc = 0;
                if (a.value < 200)
                {
                    vc = 0;
                }
                else if (a.value <= 200)
                {
                    vc = 4;
                }
                else if (a.value <= 300)
                {
                    vc = 3;
                }
                else if (a.value <= 400)
                {
                    vc = 2;
                }
                else if (a.value == 1000)
                {
                    vc = 1;
                }
                ac += vc << 4;
                if (a.fortress)
                {
                    ac |= 128;
                }
                s += Util.IntToHex(ac, 2);
                n++;
            }
            s += "\"";
            s += " AA=\"" + Util.IntToHex(Semu.availableareas, 6) + "\"";
            s += " UH=\"" + Semu.mydata.usedhelps + "\"";
            if (Semu.state == 3)
            {
                s += " FAO=\"" + freeareas_win_order + "\"";
            }
            if (Sys.mydata.shieldmission)
            {
                s += " SMSR=\"" + Sys.mydata.shieldmission.toString(16) + ",0\"";
            }
            s += " />";
            answer += s;
        }

        public static function AddTag_PLAYERS(pnum:int):*
        {
            var n:* = undefined;
            var p:SemuPlayer = null;
            var s:* = "<PLAYERS";
            n = 1;
            while (n <= 3)
            {
                p = Semu.players[n];
                s += " P" + n + "=\"" + p.name + "\"";
                n++;
            }
            n = 1;
            while (n <= 3)
            {
                p = Semu.players[n];
                s += " PD" + n + "=\"" + p.id + "," + p.xppoints + "," + p.xplevel + ",1" + ",0" + "," + Util.ShuffleArray(["hu", "ar", "mx"])[0] + "," + p.castlelevel + "," + p.customavatar + "," + p.soldier + "\"";
                n++;
            }
            if (pnum == 2)
            {
                s += " YOU=\"2,1,3\"";
            }
            else if (pnum == 3)
            {
                s += " YOU=\"3,1,2\"";
            }
            else
            {
                s += " YOU=\"1,2,3\"";
            }
            s += " GAMEID=\"1\"";
            s += " ROOM=\"1\"";
            s += " RULES=\"" + Semu.game_rule + ",0\"";
            if (Config.semuparams.TESTMODE == "MTGAME")
            {
                s += " MINITOUR=\"1\"";
            }
            s += " />";
            answer += s;
        }

        public static function CurrentPlace(pnum:int):int
        {
            var p2:SemuPlayer = null;
            var result:* = 1;
            var p:SemuPlayer = Semu.players[pnum];
            var n:* = 1;
            while (n <= 3)
            {
                p2 = Semu.players[n];
                if (p2 != p && (p2.points > p.points || p.deadtime > 0 && p2.deadtime > 0 && p2.deadtime > p.deadtime))
                {
                    result++;
                }
                n++;
            }
            if (result > 3)
            {
                result = 3;
            }
            return result;
        }

        public static function HandleGameOver():void
        {
            var n:* = undefined;
            var cwinbonus:* = undefined;
            var cwinbonus2:* = undefined;
            var opplevel:* = undefined;
            var cwincount:* = undefined;
            var cwincount2:* = undefined;
            var pnum:* = Semu.mydata.playernum;
            var s:* = "<GAMEOVER";
            var order:* = ["", 1, 2, 3];
            var psum:* = 0;
            n = 1;
            while (n <= 3)
            {
                psum += Semu.players[n].points;
                order[CurrentPlace(n)] = n;
                n++;
            }
            s += " PLACINGS=\"" + order.join("") + "\"";
            var pointpercent:* = Semu.mydata.points / psum;
            s += " ROOMID=\"1\"";
            var basepts:* = 100;
            var ppbonus:* = 0;
            var oppbonus:* = 0;
            cwinbonus = 0;
            cwinbonus2 = 0;
            if (mydata.xplevel >= 10)
            {
                basepts = 100 * (4 - CurrentPlace(pnum));
                ppbonus = Math.round(basepts * pointpercent);
                opplevel = (Semu.players[2].xplevel + Semu.players[3].xplevel) / 2;
                oppbonus = Math.round(opplevel / 100 * basepts);
                cwincount = 2;
                cwincount2 = 5;
                cwinbonus = cwincount * 100;
                if (cwinbonus > 1000)
                {
                    cwinbonus = 1000;
                }
                cwinbonus2 = cwincount2 * 50;
                if (cwinbonus2 > 500)
                {
                    cwinbonus2 = 500;
                }
            }
            var xpchange:* = basepts + ppbonus + oppbonus + cwinbonus + cwinbonus2;
            var oldxppoints:* = mydata.xppoints;
            var oldxplevel:* = mydata.xplevel;
            mydata.xppoints += xpchange;
            mydata.xplevel = CalculateXPLevel(mydata.xppoints);
            var levelchange:* = mydata.xplevel != oldxplevel;
            s += " XP=\"" + oldxppoints + "," + xpchange + "," + mydata.xplevel + "," + (!!levelchange ? "1" : "0") + "\"";
            s += " XPPL=\"" + CurrentPlace(pnum) + "," + basepts + "\"";
            s += " XPPP=\"" + Math.round(pointpercent * 100) + "," + ppbonus + "\"";
            s += " XPOPP=\"" + Math.round(opplevel) + "," + oppbonus + "\"";
            s += " XPCW=\"" + cwincount + "," + cwinbonus + "\"";
            s += " XPCW2=\"" + cwincount2 + "," + cwinbonus2 + "\"";
            s += " ANSWERS=\"6,4\"";
            s += " TIPS=\"5,2\"";
            s += " VEPTIPS=\"4,200\"";
            s += " GOLDS=\"" + mydata.golds + "\"";
            s += " RL=\"7894," + (7894 + xpchange) + ",3149\"";
            if (Config.semuparams.TESTMODE == "MTGAME")
            {
                s += " MINITOUR=\"1\"";
                s += " MTROUND=\"" + minitour.currentround + "\"";
                s += " MTSTATE=\"" + minitour.state + "\"";
                s += " MTREMAINING=\"" + minitour.remaining + "\"";
                s += " MTPLAYING=\"" + minitour.currentlyplaying + "\"";
                if (minitour.currentround == 3 || CurrentPlace(pnum) > 1)
                {
                    s += " MTFINISHED=\"1\"";
                }
            }
            s += " />";
            s += Semu.FormatTag_DIVISION();
            if (levelchange)
            {
                s += FormatTag_LEVELCHANGE();
            }
            Semu.sendmydata = true;
            Semu.tag_results = s;
        }

        public static function FormatTag_DIVISION():String
        {
            var s:* = "<DIVISION USERID=\"" + Sys.mydata.id + "\" TOTALXP=\"2201\" GAMECOUNT=\"4\" LEAGUE=\"7\" DIVISION=\"5\" CLOSETIME=\"1418860800\" UPCOUNT=\"10\" DOWNCOUNT=\"0\">";
            s += "<MEMBER USERID=\"" + Sys.mydata.id + "\" TOTALXP=\"2201\" GAMECOUNT=\"4\" COUNTRY=\"--\"/>";
            s += "<MEMBER USERID=\"100000712460617\" TOTALXP=\"816\" GAMECOUNT=\"3\" COUNTRY=\"sc\"/>";
            s += "<MEMBER USERID=\"1115113337\" TOTALXP=\"709\" GAMECOUNT=\"2\" COUNTRY=\"--\"/>";
            s += "<MEMBER USERID=\"100000681330785\" TOTALXP=\"478\" GAMECOUNT=\"2\" COUNTRY=\"--\"/>";
            s += "<MEMBER USERID=\"100003815212032\" TOTALXP=\"476\" GAMECOUNT=\"2\" COUNTRY=\"in\"/>";
            s += "<MEMBER USERID=\"100003005631435\" TOTALXP=\"475\" GAMECOUNT=\"2\" COUNTRY=\"ak\"/>";
            s += "<MEMBER USERID=\"100000849591663\" TOTALXP=\"473\" GAMECOUNT=\"2\" COUNTRY=\"--\"/>";
            s += "<MEMBER USERID=\"100001048354089\" TOTALXP=\"457\" GAMECOUNT=\"2\" COUNTRY=\"--\"/>";
            s += "<MEMBER USERID=\"100000467678010\" TOTALXP=\"409\" GAMECOUNT=\"3\" COUNTRY=\"wv\"/>";
            s += "<MEMBER USERID=\"100000582034112\" TOTALXP=\"350\" GAMECOUNT=\"1\" COUNTRY=\"--\"/>";
            s += "<MEMBER USERID=\"100003049708245\" TOTALXP=\"347\" GAMECOUNT=\"1\" COUNTRY=\"--\"/>";
            s += "<MEMBER USERID=\"100000021832432\" TOTALXP=\"343\" GAMECOUNT=\"1\" COUNTRY=\"tx\"/>";
            s += "<MEMBER USERID=\"100003124131072\" TOTALXP=\"340\" GAMECOUNT=\"1\" COUNTRY=\"tn\"/>";
            s += "<MEMBER USERID=\"1755000119\" TOTALXP=\"339\" GAMECOUNT=\"1\" COUNTRY=\"fl\"/>";
            s += "<MEMBER USERID=\"44407108\" TOTALXP=\"338\" GAMECOUNT=\"1\" COUNTRY=\"tx\"/>";
            s += "<MEMBER USERID=\"100002951353496\" TOTALXP=\"337\" GAMECOUNT=\"1\" COUNTRY=\"ks\"/>";
            s += "<MEMBER USERID=\"100000085106314\" TOTALXP=\"333\" GAMECOUNT=\"1\" COUNTRY=\"--\"/>";
            return s + "</DIVISION>";
        }

        public static function FormatTag_LEVELCHANGE():*
        {
            var s:String = "";
            switch (mydata.xplevel)
            {
                case 1:
                    s = "TXTID=\"FIRSTGAME\"";
                    break;
                case 2:
                    s = "TXTID=\"HELP_SELHALF\"";
                    break;
                case 3:
                    s = "TXTID=\"HELP_TIPRANG\"";
                    break;
                case 4:
                    s = "TXTID=\"HELP_AIRBORNE\"";
                    break;
                case 5:
                    s = "TXTID=\"UPGRADE_SELHALF\"";
                    break;
                case 6:
                    s = "TXTID=\"HELP_SELANSW\"";
                    break;
                case 7:
                    s = "TXTID=\"HELP_SUBJECT\"";
                    break;
                case 8:
                    s = "TXTID=\"HELP_FORTRESS\"";
                    break;
                case 9:
                    s = "TXTID=\"HELP_TIPAVER\"";
                    break;
                case 10:
                    s = "TXTID=\"CREATESEPROOM\"";
                    break;
                case 11:
                    s = "TXTID=\"NOLOSS_SERIES\"";
                    break;
                case 12:
                    s = "TXTID=\"BADGES\"";
                    break;
                case 13:
                    s = "TXTID=\"WIN_SERIES\"";
                    break;
                case 14:
                    s = "TXTID=\"TRYCHAT\"";
                    break;
                case 15:
                    s = "TXTID=\"NOLOSS_SERIES2\"";
                    break;
                case 16:
                    s = "TXTID=\"DOUBLEGOLDBUY\"";
                    break;
                case 17:
                    s = "TXTID=\"WIN_SERIES2\"";
                    break;
                case 19:
                    s = "TXTID=\"WIN_SERIES3\"";
                    break;
                case 20:
                    s = "TXTID=\"LOBBY\"";
                    break;
                default:
                    s = "TXTID=\"GENERAL\" GOLDS=\"2000\"";
            }
            return "<LEVELCHANGE " + s + " />";
        }

        public static function AddTag_WAITSTATE():*
        {
            var s:* = "<WAITSTATE";
            s += " ROOMSEL=\"" + Semu.roomsel + "\"";
            s += " />";
            answer += s;
        }

        public static function AddTag_MYDATA():*
        {
            var s:* = "";
            s += "<GAMEPARAMS ";
            s += " BADGEBONUSES=\"3,4,5,6,7,8,9|2,3,4,5,6,7,8|1,2,3,4,5,6,7|1,2,3,4,5,6,7|1,2,3,4,5,6,7|1,2,3,4,5,6,7|4,5,6,7,8,9,10|1,0,0,0,0,0,0\"";
            s += " NRG=\"15,3\"";
            s += " HFUG=\"1,1,24,0|1,1,24,20000|1,1,24,20000|1,1,24,20000|1,1,24,20000|1,1,24,20000|1,1,24,20000\"";
            s += " MP=\"1,1000,10,9000,100,70000|1,1000,10,9000,100,70000|1,1000,10,9000,100,70000|1,1000,10,9000,100,70000|1,1000,10,9000,100,70000|1,1000,10,9000,100,70000|1,1000,10,9000,100,70000|1,20000,2,40000,3,60000|1,50000,2,100000,3,150000|1,100000,2,200000,3,300000|1,200000,2,400000,3,600000|1,500000,2,1000000,3,1500000\" HP=\"2000,2000,2000,2000,2000,2000,2000,20000,50000,100000,200000,500000\"";
            s += " />";
            s += "<MYDATA ";
            s += " NAME=\"" + Semu.mydata.name + "\"";
            s += " ID=\"" + Semu.mydata.id + "\"";
            s += " COUNTRY=\"" + Semu.mydata.country + "\"";
            s += " XPPACK=\"" + Semu.mydata.xppoints + ", " + Semu.mydata.xplevel + ", " + Semu.mydata.xpactmin + ", " + Semu.mydata.nextlevelxp + "\"";
            s += " SEX=\"" + Semu.mydata.sex + "\"";
            s += " GAMECOUNT=\"" + Semu.mydata.gamecount + "\"";
            s += " GAMECOUNTSR=\"0\"";
            s += " GOLDS=\"" + Semu.mydata.golds + "\"";
            s += " CASTLELEVEL=\"" + Semu.mydata.castlelevel + "\"";
            s += " SNDVOL=\"" + Semu.mydata.sndvol + "\"";
            s += " FLAGS=\"" + Semu.mydata.flags + "\"";
            s += " MTCUPS=\"1,22,33\"";
            s += " CWINS=\"1,2,0,1,2,3,0\"";
            s += " ENERGYPACK=\"100,75,0,300,1,0\"";
            s += " LEVELFLAGS=\"" + Semu.levelflags + "\"";
            s += " MISSIONS=\"" + Semu.activemissions + "," + Semu.shownmissions + "," + Semu.completedmissions + "\"";
            s += " FH=\"" + Semu.mydata.freehelps.join(",") + "\"";
            s += " HP=\"" + Semu.mydata.helpprices.join(",") + "\"";
            s += " SOLDIER=\"" + Semu.mydata.soldier + "\"";
            s += " SMSR=\"" + Semu.mydata.shieldmission.toString(16) + ",0\"";
            s += " CUSTOMAVATAR=\"" + Semu.mydata.customavatar + "\"";
            s += " USECUSTOMAVATAR=\"" + Semu.mydata.usecustomavatar + "\"";
            s += " EXTAVATAR=\"" + Util.StrXmlSafe(Semu.mydata.extavatar) + "\"";
            s += " MYCATEGORY=\"" + Semu.mydata.mycategory + "\"";
            s += " HFS=\"1,1,24,32500|0,1,168,86400|0,1,168,30|0,1,168,120000|0,1,168,320000|0,1,168,40000|0,2,168,5\"";
            s += " TAXDATA=\"4500,10,3000,600,500\"";
            s += " LASTPLACES=\"3211230000\"";
            s += " />";
            answer += s;
        }

        public static function AddTag_QCATS():*
        {
            var s:* = "<QCATS ";
            s += " CATEGORIES=\"1^Art|2^Everydays|3^Geography|4^History|5^Literature|6^Science: Mat-Phy.|7^Science: Bio-Chem|8^Sport|9^Entertainment|10^Lifestyle\"";
            s += " />";
            answer += s;
        }

        public static function AddTag_FEATURES():*
        {
            var s:* = "<FEATURES ";
            s += " ENABLED=\"" + Util.StringVal(Config.semufeatures.ENABLED) + "\"";
            s += " />";
            answer += s;
        }

        public static function AddTag_GAMEPARAMS():*
        {
            answer += "<GAMEPARAMS BADGEBONUSES=\"3,4,5,6,7,8,9|2,3,4,5,6,7,8|1,2,3,4,5,6,7|1,2,3,4,5,6,7|1,2,3,4,5,6,7|1,2,3,4,5,6,7|4,5,6,7,8,9,10|1,0,0,0,0,0,0\" NRG=\"15,3\" HFUG=\"1,1,24,0|1,1,24,20000|1,1,24,20000|1,1,24,20000|1,1,24,20000|1,1,24,20000|1,1,24,20000\" MP=\"1,1000,10,9000,100,70000|1,1000,10,9000,100,70000|1,1000,10,9000,100,70000|1,1000,10,9000,100,70000|1,1000,10,9000,100,70000|1,1000,10,9000,100,70000|1,1000,10,9000,100,70000|1,20000,2,40000,3,60000|1,50000,2,100000,3,150000|1,100000,2,200000,3,300000|1,200000,2,400000,3,600000|1,500000,2,1000000,3,1500000\" HP=\"2000,2000,2000,2000,2000,2000,2000,20000,50000,100000,200000,500000\"/>";
        }

        public static function AddTag_GAMEROOM():*
        {
            var s:* = "<GAMEROOM ID=\"1\"";
            s += " TITLE=\"DEFAULT\"";
            s += " MAP=\"WD\"";
            s += " TYPE=\"2\"";
            s += " PLAYERS=\"0\"";
            s += " INGAME=\"0\"";
            s += " />";
            s += "<GAMEROOM ID=\"2\"";
            s += " TITLE=\"LONG\"";
            s += " MAP=\"WD\"";
            s += " TYPE=\"2\"";
            s += " PLAYERS=\"0\"";
            s += " INGAME=\"0\"";
            s += " />";
            answer += s;
        }

        public static function AddTag_WRONGQ():*
        {
        }

        public static function CalculateXPLevel(xppoints:int):int
        {
            var result:int = 0;
            var nextlevelxp:int = 0;
            if (xppoints <= 1000)
            {
                result = int(xppoints / 100);
                if (result < 10)
                {
                    nextlevelxp = (result + 1) * 100;
                }
                else
                {
                    nextlevelxp = 1100;
                }
                return result;
            }
            result = 11;
            nextlevelxp = 3500;
            var ldiff:int = 2500;
            var linc:int = 500;
            while (xppoints >= nextlevelxp)
            {
                result++;
                if (result == 18)
                {
                    ldiff = 7000;
                    linc = 1000;
                }
                else if (result == 101)
                {
                    linc = 2000;
                    ldiff = 200000;
                }
                else if (result == 201)
                {
                    linc = 4000;
                    ldiff = 800000;
                }
                ldiff += linc;
                nextlevelxp += ldiff;
            }
            return result;
        }

        public static function IsNeighbour(anum:int, astr:String):Boolean
        {
            var s:* = "," + anum + ",";
            return astr.indexOf(s) >= 0;
        }

        public static function GetAvailableAreas(pnum:int):int
        {
            var n:* = undefined;
            var e:* = undefined;
            var a:* = undefined;
            var bm:* = undefined;
            var pneigh:* = ",";
            var oppneigh:* = ",";
            var result:* = 0;
            n = 1;
            while (n <= map_areanum)
            {
                a = Semu.areas[n];
                if (a.owner == pnum)
                {
                    pneigh += map_neighbours[n] + ",";
                }
                else if (a.owner != pnum && a.owner != 0)
                {
                    oppneigh += map_neighbours[n] + ",";
                }
                n++;
            }
            n = 1;
            while (n <= map_areanum)
            {
                bm = 1 << n - 1;
                a = Semu.areas[n];
                if (Semu.state == 1)
                {
                    e = a.owner == 0 && !Semu.IsNeighbour(n, oppneigh);
                }
                else if (Semu.state == 2 || Semu.state == 3)
                {
                    e = a.owner == 0 && Semu.IsNeighbour(n, pneigh) && n != Semu.players[1].selection && n != Semu.players[2].selection && n != Semu.players[3].selection;
                }
                else if (Semu.game_rule == 0)
                {
                    e = a.owner != pnum && Semu.IsNeighbour(n, pneigh) || a.base && Semu.players[pnum].basestate > 0;
                }
                else
                {
                    e = a.owner != pnum;
                    if (Semu.gameround < 4)
                    {
                        e &&= Semu.IsNeighbour(n, pneigh);
                    }
                }
                if (e)
                {
                    result |= bm;
                }
                n++;
            }
            if (result == 0)
            {
                n = 1;
                while (n <= map_areanum)
                {
                    bm = 1 << n - 1;
                    a = Semu.areas[n];
                    if (Semu.state == 2 || Semu.state == 3)
                    {
                        e = a.owner == 0 && n != Semu.players[1].selection && n != Semu.players[2].selection && n != Semu.players[3].selection;
                    }
                    else
                    {
                        e = a.owner != pnum && !a.base;
                    }
                    if (e)
                    {
                        result |= bm;
                    }
                    n++;
                }
            }
            return result;
        }

        public static function RandomSelectArea(avail:int):int
        {
            var n:* = undefined;
            var anum:* = 0;
            n = 1;
            while (n <= map_areanum)
            {
                if (avail & 1 << n - 1)
                {
                    anum++;
                }
                n++;
            }
            if (anum < 1)
            {
                return 0;
            }
            var sel:* = Math.floor(Math.random() * anum) + 1;
            anum = 0;
            n = 1;
            while (n <= map_areanum)
            {
                if (avail & 1 << n - 1)
                {
                    anum++;
                }
                if (anum == sel)
                {
                    return n;
                }
                n++;
            }
            return 0;
        }

        public static function SetMap(id:String, areanum:int, neighbours:Array):*
        {
            map_id = id;
            map_areanum = areanum;
            map_neighbours = neighbours;
        }

        public static function SetArea(area:int, pnum:int, value:int):*
        {
            var p:SemuPlayer = null;
            var a:* = Semu.areas[area];
            a.owner = pnum;
            a.value = value;
            if (a.value == 1000)
            {
                a.base = true;
            }
            if (a.owner > 0)
            {
                p = Semu.players[pnum];
                p.points += a.value;
                if (a.value == 1000)
                {
                    p.base = area;
                }
            }
        }

        public static function SelectGuessQuestion():*
        {
            var questions:* = [ {
                        "q": "How many visible and oversized teeth does Spongebob have?",
                        "a": 2
                    }, {
                        "q": "For how many minutes does Andy Warhol think it will be possible in the future to be famous?",
                        "a": 15
                    }, {
                        "q": "In which year did the hydrofoil begin its regular tours between Budapest and Vienna?",
                        "a": 1962
                    }, {
                        "q": "How many members of the Simpson family has got in the cartoon version?",
                        "a": 5
                    }, {
                        "q": "How many feet deep are people buried according to the English saying?",
                        "a": 6
                    }, {
                        "q": "How many cabins made of glass are there in London Eye?",
                        "a": 32
                    }, {
                        "q": "How many meters high is the ferris-wheel of London, the London Eye?",
                        "a": 135
                    }, {
                        "q": "In which year was the world's first crosswalk painted on a road in Geneva?",
                        "a": 1949
                    }, {
                        "q": "How old do you have to be in Germany to be able to drink beer legally?",
                        "a": 16
                    }, {
                        "q": "When was the first roller coaster opened in Paris?",
                        "a": 1817
                    }, {
                        "q": "How tall is London's newest symbol, the Gherkin?",
                        "a": 180
                    }, {
                        "q": "What year was Tetra Brik packing introduce?",
                        "a": 1963
                    }, {
                        "q": "In which year was Microsoft founded?",
                        "a": 1975
                    }, {
                        "q": "In which year did Internet Explorer 1.0 appear?",
                        "a": 1995
                    }, {
                        "q": "In which year was Yahoo! founded?",
                        "a": 1994
                    }, {
                        "q": "In which year was the fisrt WiW (Who is who?) invitation sent?",
                        "a": 2002
                    }, {
                        "q": "In which year did the American professor Scott Fahlman invent the following smileys used on [ :-) and :-( ]",
                        "a": 1982
                    }, {
                        "q": "In which year did Paul Allen and Bill Gates found Microsoft?",
                        "a": 1975
                    }, {
                        "q": "In which year did Steve Jobs and Steve Wozniak found the Apple Computer Company?",
                        "a": 1976
                    }, {
                        "q": "In which year did the website youtube.com started to operate?",
                        "a": 2005
                    }, {
                        "q": "In which year was Nokia's first mass produced mobile phone number 1011 put on the market?",
                        "a": 1992
                    }, {
                        "q": "In which year did Gordon E. Moore and Robert Noyce found the computer company Intel?",
                        "a": 1968
                    }, {
                        "q": "In which year was so-called Starcraft, a real strategy computer game available in stores?",
                        "a": 1998
                    }, {
                        "q": "How many stairs lead up to the top of Tower of Pisa?",
                        "a": 294
                    }, {
                        "q": "How many cabins made of glass are there in London Eye?",
                        "a": 32
                    }, {
                        "q": "How many feet deep are people buried according to the English saying?",
                        "a": 6
                    }, {
                        "q": "How many meters high is the ferris-wheel of London, the London Eye?",
                        "a": 135
                    }, {
                        "q": "In which year was the RKO Radio Pictures Incorporation founded?",
                        "a": 1928
                    }, {
                        "q": "How many horses are harnessed in a troika?",
                        "a": 3
                    }, {
                        "q": "What age is school attendance compulsory In Belgium until?",
                        "a": 18
                    }, {
                        "q": "What age is school attendance compulsory In France until?",
                        "a": 16
                    }, {
                        "q": "What year did the London Zoo opened?",
                        "a": 1828
                    }, {
                        "q": "What year was the biggest diamond, the Cullinan found?",
                        "a": 1905
                    }, {
                        "q": "How tall is London Eye?",
                        "a": 135
                    }, {
                        "q": "Which year was the oldest zoo in the world, which is in Schonbrunn, opened?",
                        "a": 1752
                    }, {
                        "q": "How many stairs lead up to the top of Tower of Pisa?",
                        "a": 294
                    }];
            if (Config.rtl)
            {
                questions = [ {
                            "q": "الرئيس جون كوينسي آدامز هو الرئيس الامريكي رقم  ؟ 123",
                            "a": 6
                        }];
            }
            var rnd:* = Math.round(Math.random() * (questions.length - 1));
            Semu.guess_question = questions[rnd];
            Semu.tag_question = "<TIPQUESTION QUESTION=\"" + Semu.guess_question.q + "\" ALLOWMARK=\"1\" THEME=\"" + Util.Random(1, 10) + "\"";
            var help:* = " HELP=\"{";
            if (Semu.players[Semu.mydata.playernum].help_used_average)
            {
                help += "AVERAGE:-2,";
            }
            else if (Semu.players[Semu.mydata.playernum].golds < 2000)
            {
                help += "AVERAGE:-3,";
            }
            else
            {
                help += "AVERAGE:2000,";
            }
            if (Semu.players[Semu.mydata.playernum].help_used_range)
            {
                help += "RANGE:-2";
            }
            else if (Semu.players[Semu.mydata.playernum].golds < 2000)
            {
                help += "RANGE:-3";
            }
            else
            {
                help += "RANGE:2000";
            }
            help += "}\"";
            Semu.tag_question = Semu.tag_question + (help + " />");
            Semu.send_tag_question = true;
        }

        public static function SelectMCQuestion():*
        {
            var questions:* = [ {
                        "q": "Which nation's typical dish is baguette?",
                        "a1": "French",
                        "a2": "German",
                        "a3": "Hungarian",
                        "a4": "Romanian"
                    }, {
                        "q": "Which nation's typical dish is goulash?",
                        "a1": "Hungarian",
                        "a2": "British",
                        "a3": "Scottish",
                        "a4": "Italian"
                    }, {
                        "q": "Which nation's typical dish is paella?",
                        "a1": "Spanish",
                        "a2": "Danish",
                        "a3": "Swedish",
                        "a4": "Greek"
                    }, {
                        "q": "Which nation's typical dish is pizza?",
                        "a1": "Italian",
                        "a2": "English",
                        "a3": "French",
                        "a4": "Turkish"
                    }, {
                        "q": "Where does Pilsner beer originate from?",
                        "a1": "the Czech Republic",
                        "a2": "Germany",
                        "a3": "Belgium",
                        "a4": "Austria"
                    }, {
                        "q": "Which is not a Portugal newspaper?",
                        "a1": "La Vanguardia",
                        "a2": "Diario de Noticias",
                        "a3": "Correio de Manha",
                        "a4": "Jornal de Noticias"
                    }, {
                        "q": "Which currency was in use in Austria before they changed to euro? Austrian...",
                        "a1": "schilling",
                        "a2": "franc",
                        "a3": "penny",
                        "a4": "escudo"
                    }, {
                        "q": "Which currency was in use in France before they changed to euro? French...",
                        "a1": "franc",
                        "a2": "schilling",
                        "a3": "penny",
                        "a4": "escudo"
                    }, {
                        "q": "Which currency was in use in Ireland before they changed to euro? Irish...",
                        "a1": "pound",
                        "a2": "escudo",
                        "a3": "lira",
                        "a4": "marka"
                    }, {
                        "q": "Which currency was in use in Germany before before they changed to euro? German...",
                        "a1": "mark",
                        "a2": "franc",
                        "a3": "pound",
                        "a4": "escudo"
                    }, {
                        "q": "What was the official currency in Italy before the Euro?",
                        "a1": "lira",
                        "a2": "mark",
                        "a3": "franc",
                        "a4": "pound"
                    }, {
                        "q": "Which currency was in use in Spain before they changed to euro? Spanish-",
                        "a1": "peseta",
                        "a2": "escudo",
                        "a3": "lira",
                        "a4": "franc"
                    }, {
                        "q": "What is the official currency in Bulgaria?",
                        "a1": "leva",
                        "a2": "euro",
                        "a3": "koruna",
                        "a4": "dinar"
                    }, {
                        "q": "What was the sub-unit of the French franc?",
                        "a1": "centime",
                        "a2": "heller",
                        "a3": "cent",
                        "a4": "centavo"
                    }, {
                        "q": "Which country has Euro as the official currency?",
                        "a1": "Finland",
                        "a2": "Sweden",
                        "a3": "Denmark",
                        "a4": "Norway"
                    }, {
                        "q": "Which is the national dish of Bulgaria?",
                        "a1": "sopszka salata",
                        "a2": "sztrapacska",
                        "a3": "knedli",
                        "a4": "soska"
                    }, {
                        "q": "What is ayran, popular in Turkey?",
                        "a1": "a yoghurt drink",
                        "a2": "a folk dance",
                        "a3": "a one-course dish made of lamb",
                        "a4": "an anise-flavoured spirit"
                    }];
            if (Config.rtl)
            {
                questions = [ {
                            "q": "ماهو الشي الذي لك ويستخدمه الناس اكثر منك?",
                            "a1": "اسمك",
                            "a2": "اخوك",
                            "a3": "محمولك",
                            "a4": "ملابسك"
                        }];
            }
            var rnd:* = Math.round(Math.random() * (questions.length - 1));
            Semu.mc_question = questions[rnd];
            Semu.tag_question = "<QUESTION QUESTION=\"" + Semu.mc_question.q + "\" ALLOWMARK=\"1\" THEME=\"" + Util.Random(1, 10) + "\"";
            Semu.send_tag_question = true;
            var order:* = [ {
                        "a": Semu.mc_question.a1,
                        "g": true,
                        "r": 51
                    }, {
                        "a": Semu.mc_question.a2,
                        "g": false,
                        "r": 27
                    }, {
                        "a": Semu.mc_question.a3,
                        "g": false,
                        "r": 13
                    }, {
                        "a": Semu.mc_question.a4,
                        "g": false,
                        "r": 9
                    }];
            order = Util.ShuffleArray(order);
            var dc:* = [];
            var di:* = Util.Random(0, 2);
            Semu.mc_doublechance = "";
            Semu.mc_answeratios = "";
            var i:* = 0;
            while (i < order.length)
            {
                Semu.tag_question = Semu.tag_question + (" OP" + (i + 1) + "=\"" + order[i].a + "\"");
                Semu.mc_answeratios = Semu.mc_answeratios + ((Semu.mc_answeratios != "" ? "," : "") + String(order[i].r));
                if (order[i].g)
                {
                    Semu.mc_question_goodanswer = i + 1;
                }
                else
                {
                    dc.push(i + 1);
                }
                i++;
            }
            var x:* = 0;
            while (x <= 2)
            {
                if (x != di)
                {
                    Semu.mc_doublechance = Semu.mc_doublechance + ((Semu.mc_doublechance != "" ? "," : "") + dc[x]);
                }
                x++;
            }
            var help:* = " HELP=\"{";
            if (Semu.players[Semu.mydata.playernum].help_used_half)
            {
                help += "HALF:-2,";
            }
            else if (Semu.players[Semu.mydata.playernum].golds < 2000)
            {
                help += "HALF:-3,";
            }
            else
            {
                help += "HALF:2000,";
            }
            if (Semu.players[Semu.mydata.playernum].help_used_answers)
            {
                help += "ANSWERS:-2";
            }
            else if (Semu.players[Semu.mydata.playernum].golds < 2000)
            {
                help += "ANSWERS:-3";
            }
            else
            {
                help += "ANSWERS:2000";
            }
            help += "}\"";
            if (Util.Random(3, 1) == 1)
            {
                Semu.tag_question = Semu.tag_question + " ICON_URL = \"client/assets/icons/pokeball.png\" COLOR_CODE = \"F3C5C3\"";
            }
            Semu.tag_question = Semu.tag_question + (help + " />");
        }

        public static function PrepareAnswers():*
        {
            var p:SemuPlayer = null;
            Semu.answercount = 0;
            Semu.tipstarttime = getTimer();
            Semu.tiporder = [];
            Semu.tipwinorder = [];
            var n:* = 1;
            while (n <= 3)
            {
                p = Semu.players[n];
                p.tipanswer = -1;
                p.tipaccuracy = -1;
                p.tiptime = 0;
                p.answer = -1;
                n++;
            }
        }

        public static function ResetSelections():*
        {
            var p:SemuPlayer = null;
            var n:* = 1;
            while (n <= 3)
            {
                p = Semu.players[n];
                p.selection = 0;
                n++;
            }
            Semu.answercount = 0;
            Semu.availableareas = 0;
        }

        public static function FreeAreaCount():int
        {
            var result:* = 0;
            var n:* = 1;
            while (n <= map_areanum)
            {
                if (Semu.areas[n].owner == 0)
                {
                    result++;
                }
                n++;
            }
            return result;
        }

        public static function CalculateLastRoundAttackOrder():*
        {
            var wo:* = [1, 2, 3];
            var mysortfunc:* = function(a:*, b:*):*
            {
                if (Semu.players[a].points > Semu.players[b].points)
                {
                    return -1;
                }
                if (Semu.players[a].points < Semu.players[b].points)
                {
                    return 1;
                }
                return 0;
            };
            wo.sort(mysortfunc);
            Semu.warorder = Semu.warorder.substr(0, 9) + wo.join("");
        }

        public static function RotationPlayer(around:int, alpnum:int):int
        {
            if (Semu.state == 2)
            {
                return Util.NumberVal(rotation.charAt((around - 1) * 3 + (alpnum - 1)));
            }
            if (around == 4 && Semu.warorder.charAt(9) == "4")
            {
                CalculateLastRoundAttackOrder();
            }
            return Util.NumberVal(Semu.warorder.charAt((around - 1) * 3 + alpnum - 1));
        }

        public static function CalculateNextPlayer():*
        {
            if (Semu.state == 2)
            {
                while (Semu.gameround <= 6)
                {
                    ++Semu.lpnum;
                    if (Semu.lpnum > 3)
                    {
                        ++Semu.gameround;
                        Semu.lpnum = 1;
                    }
                    Semu.nextplayer = RotationPlayer(Semu.gameround, Semu.lpnum);
                    if (Semu.nextplayer > 0 && !Semu.players[Semu.nextplayer].passive)
                    {
                        return;
                    }
                }
                return;
            }
            while (Semu.gameround <= (Semu.game_rule == 0 ? 6 : 4))
            {
                ++Semu.lpnum;
                if (Semu.lpnum > 3)
                {
                    ++Semu.gameround;
                    Semu.lpnum = 1;
                }
                Semu.nextplayer = RotationPlayer(Semu.gameround, Semu.lpnum);
                if (Semu.nextplayer > 0 && !Semu.players[Semu.nextplayer].passive)
                {
                    return;
                }
            }
        }

        public static function ActivePlayerCount():*
        {
            var result:* = 0;
            var n:* = 1;
            while (n <= 3)
            {
                if (!Semu.players[n].passive)
                {
                    result++;
                }
                n++;
            }
            return result;
        }

        public static function EqualPoints():int
        {
            var result:int = 0;
            var p1:SemuPlayer = Semu.players[1];
            var p2:SemuPlayer = Semu.players[2];
            var p3:SemuPlayer = Semu.players[3];
            if (p1.points > 0 && p1.points == p2.points)
            {
                result++;
            }
            if (p2.points > 0 && p1.points == p3.points)
            {
                result++;
            }
            if (p3.points > 0 && p2.points == p3.points)
            {
                result++;
            }
            if (result == 1)
            {
                result = 2;
            }
            return result;
        }

        public static function OccupyArea(aareanum:*, pnum:*):*
        {
            var a:* = Semu.areas[aareanum];
            var oldowner:* = a.owner;
            var p:SemuPlayer = Semu.players[pnum];
            var pold:SemuPlayer = Semu.players[oldowner];
            if (oldowner != pnum)
            {
                if (oldowner != 0)
                {
                    pold.points -= a.value;
                }
                a.owner = pnum;
                if (Semu.state == 4)
                {
                    if (a.value < 1000)
                    {
                        a.value = 400;
                    }
                }
                else
                {
                    a.value = 200;
                }
                p.points += a.value;
            }
            else
            {
                p.points += 100;
            }
        }

        public static function DefeatPlayer(aoffender:*, adefender:*):*
        {
            var a:* = undefined;
            var poff:SemuPlayer = Semu.players[aoffender];
            var pdef:SemuPlayer = Semu.players[adefender];
            var n:* = 1;
            while (n <= map_areanum)
            {
                a = Semu.areas[n];
                if (a.owner == adefender)
                {
                    a.owner = aoffender;
                    a.base = false;
                }
                n++;
            }
            poff.points += pdef.points;
            pdef.points = 0;
            pdef.passive = true;
            pdef.deadtime = getTimer();
        }

        public static function SetPlayerCmd(pnum:int, acmd:String, aparams:String):*
        {
            var p:SemuPlayer = Semu.players[pnum];
            p.cmd = acmd;
            p.tag_cmd = "<CMD CMD=\"" + acmd + "\" " + aparams + " TO=\"" + Semu.cmdtimeout + "\" />";
            p.commandstarted = false;
        }

        public static function StartRobotActions():*
        {
            var p:SemuPlayer = null;
            var delay:* = undefined;
            if ("MAP" != Sys.screen.substr(0, 3))
            {
                return;
            }
            var pnum:int = 1;
            while (pnum <= 3)
            {
                if (pnum != Semu.mydata.playernum)
                {
                    p = Semu.players[pnum];
                    if (p.cmd != "" && !p.commandstarted)
                    {
                        p.commandstarted = true;
                        delay = 3 + Math.random() * 5;
                        if (fastbots)
                        {
                            delay = 0.05;
                        }
                        else if (pausebots)
                        {
                            delay = 100000;
                        }
                        p.PrepareRobotAction(delay);
                    }
                }
                pnum++;
            }
        }

        public static function SetPlayerSelectCmd(pnum:int):*
        {
            Semu.availableareas = GetAvailableAreas(pnum);
            SetPlayerCmd(pnum, "SELECT", "AVAILABLE=\"" + Util.IntToHex(Semu.availableareas, 6) + "\"" + " MAPHELPS=\"{AIRBORNE:1000,SUBJECT:1000,FORTRESS:900}\"");
        }

        public static function ProcessCmdSelectMH(tag:*):*
        {
            var p:SemuPlayer = Semu.mydata;
            var area:* = Util.NumberVal(tag.AREA);
            if (area == 0)
            {
                ProcessCmdSelect(p.playernum, area);
                return;
            }
            p.ClearCommand();
            p.selection = area;
            ++Semu.answercount;
            if (tag.TYPE == "3")
            {
                Semu.areas[area].fortress = true;
                Semu.phase = 19;
                Semu.mydata.usedhelps = Semu.mydata.usedhelps | 0x40;
            }
            else if (tag.TYPE == "1")
            {
                Semu.mydata.usedhelps = Semu.mydata.usedhelps | 0x10;
            }
            else if (tag.TYPE == "2")
            {
                Semu.mydata.usedhelps = Semu.mydata.usedhelps | 0x20;
            }
            if (Semu.isready)
            {
                HandleGamePhase();
            }
        }

        public static function ProcessCmdSelect(pnum:int, area:int):*
        {
            var p:SemuPlayer = Semu.players[pnum];
            p.ClearCommand();
            if (area == 0)
            {
                area = RandomSelectArea(Semu.availableareas);
            }
            p.selection = area;
            ++Semu.answercount;
            if (Semu.isready)
            {
                HandleGamePhase();
            }
        }

        public static function ProcessCmdTip(pnum:int, avalue:int):*
        {
            var correct:* = undefined;
            var diff:Number = NaN;
            var n:* = undefined;
            var p1:SemuPlayer = null;
            var p2:SemuPlayer = null;
            var x:* = undefined;
            var y:* = undefined;
            var p:SemuPlayer = Semu.players[pnum];
            p.ClearCommand();
            if (p.tipanswer < 0)
            {
                correct = Semu.guess_question.a;
                p.tipanswer = avalue;
                p.tiptime = getTimer();
                diff = Math.abs(correct - avalue);
                if (diff > 500)
                {
                    p.tipaccuracy = 1;
                }
                else
                {
                    p.tipaccuracy = 100 - 100 * (diff / 500);
                }
                Semu.tiporder.push(pnum);
                Semu.answercount = Semu.tiporder.length;
                Semu.tipwinorder.unshift(pnum);
                n = 0;
                while (n < Semu.tipwinorder.length - 1)
                {
                    p1 = Semu.players[Semu.tipwinorder[n]];
                    p2 = Semu.players[Semu.tipwinorder[n + 1]];
                    if (Math.abs(p1.tipanswer - correct) > Math.abs(p2.tipanswer - correct) || Math.abs(p1.tipanswer - correct) == Math.abs(p2.tipanswer - correct) && p1.tiptime > p2.tiptime)
                    {
                        x = Semu.tipwinorder[n];
                        y = Semu.tipwinorder[n + 1];
                        Semu.tipwinorder[n] = y;
                        Semu.tipwinorder[n + 1] = x;
                    }
                    n++;
                }
            }
            Semu.tag_results = FormatTipInfoTag(false);
            AnswerHalfResult();
            if (Semu.isready)
            {
                HandleGamePhase();
            }
        }

        public static function ProcessCmdAnswer(pnum:int, avalue:int):*
        {
            var p:SemuPlayer = Semu.players[pnum];
            p.ClearCommand();
            p.answer = avalue;
            ++Semu.answercount;
            if (Semu.isready)
            {
                HandleGamePhase();
            }
        }

        public static function ProcessCmdLogin(xml:*):*
        {
            Semu.mydata = new SemuPlayer(Config.semuparams.IAM);
            Semu.sendmydata = true;
            Semu.sendfeatures = true;
            ++Semu.connidnum;
            Semu.connid = "0001" + Util.PaddingLeft(String(Semu.connidnum), "0", 8);
            Semu.instantanswer = true;
            var testmode:* = Util.StringVal(Config.semuparams.TESTMODE);
            if (testmode == "MINITOURNAMENT")
            {
                trace("!!!! minitournament test  !!!!");
                Semu.current_mtroom = mtrooms[1];
                Semu.screen = "MINITOUR";
                MinitournamentStart();
            }
            else if (testmode == "MTGAME")
            {
                MinitournamentStart();
                StartMinitournamentRound();
                StartGame();
            }
            else if (testmode == "GAME" || Config.semuparams.SKIPWAITHALL == "1")
            {
                StartGame();
            }
            else
            {
                Semu.screen = "VILLAGE";
            }
        }

        public static function ProcessCmdHelp(pnum:int, help:String):String
        {
            var res:* = "<HELP ";
            if (help == "AVERAGE")
            {
                res += "HELP=\"AVERAGE\" RESULT=\"" + Semu.guess_question.a + "\"";
                Semu.players[Semu.mydata.playernum].help_used_average = true;
                Semu.players[Semu.mydata.playernum].golds = Semu.players[Semu.mydata.playernum].golds - 1000;
                Semu.mydata.usedhelps = Semu.mydata.usedhelps | 4;
            }
            else if (help == "RANGE")
            {
                res += "HELP=\"RANGE\" RESULT=\"" + (Semu.guess_question.a - 1) + "," + Semu.guess_question.a + "," + (Semu.guess_question.a + 1) + "," + (Semu.guess_question.a + 2) + "," + (Semu.guess_question.a + 3) + "\"";
                Semu.players[Semu.mydata.playernum].help_used_range = true;
                Semu.players[Semu.mydata.playernum].golds = Semu.players[Semu.mydata.playernum].golds - 1000;
                Semu.mydata.usedhelps = Semu.mydata.usedhelps | 8;
            }
            else if (help == "HALF")
            {
                res += "HELP=\"HALF\" RESULT=\"" + Semu.mc_doublechance + "\"";
                Semu.players[Semu.mydata.playernum].help_used_half = true;
                Semu.players[Semu.mydata.playernum].golds = Semu.players[Semu.mydata.playernum].golds - 1000;
                Semu.mydata.usedhelps = Semu.mydata.usedhelps | 1;
            }
            else
            {
                if (help != "ANSWERS")
                {
                    return "HELP=\"NONE\" RESULT=\"0\"";
                }
                res += "HELP=\"ANSWERS\" RESULT=\"" + Semu.mc_answeratios + "\"";
                Semu.players[Semu.mydata.playernum].help_used_answers = true;
                Semu.players[Semu.mydata.playernum].golds = Semu.players[Semu.mydata.playernum].golds - 1000;
                Semu.mydata.usedhelps = Semu.mydata.usedhelps | 2;
            }
            res += " />";
            Semu.sendmydata = true;
            return res;
        }

        public static function ProcessCmdMission(mid:int, cmd:String):String
        {
            var panswer:* = undefined;
            trace("Semu.ProcessCmdMission(" + mid + "," + cmd + ")");
            var mf:* = 1 << mid - 1;
            var smd:* = false;
            if (cmd == "SHOWN")
            {
                Semu.shownmissions = Semu.shownmissions | mf;
                smd = true;
            }
            else if (cmd == "CLOSE")
            {
                Semu.mydata.golds = Semu.mydata.golds + 10000;
                smd = true;
                Semu.activemissions = Semu.activemissions & ~mf;
            }
            var res:* = "<MISSION ID=\"" + mid + "\" TXTID=\"" + Config.missionnames[mid] + "\"";
            res += " GOLDS=\"10000\"";
            res += " />";
            if (smd)
            {
                panswer = answer;
                answer = "";
                AddTag_MYDATA();
                res += answer;
                answer = panswer;
            }
            return res;
        }

        public static function RobotAction(pnum:int):*
        {
            var rtip:int = 0;
            var ans:* = undefined;
            var p:SemuPlayer = Semu.players[pnum];
            if ("SELECT" == p.cmd)
            {
                ProcessCmdSelect(pnum, RandomSelectArea(Semu.availableareas));
            }
            else if ("TIP" == p.cmd)
            {
                rtip = 100;
                rtip = Math.floor(Math.random() * 1000);
                ProcessCmdTip(pnum, rtip);
            }
            else if ("ANSWER" == p.cmd)
            {
                ans = 0;
                if (Math.random() * 100 < 60)
                {
                    ans = Semu.mc_question_goodanswer;
                }
                else
                {
                    ans = 1;
                    if (ans == Semu.mc_question_goodanswer)
                    {
                        ans = 4;
                    }
                }
                ProcessCmdAnswer(pnum, ans);
            }
        }

        public static function SendAnswerDelayed(adelay:Number):*
        {
            if (answertimer != null)
            {
                answertimer.stop();
                answertimer = null;
            }
            answertimer = new Timer(adelay * 1000, 1);
            answertimer.addEventListener(TimerEvent.TIMER, OnSendAnswer);
            answertimer.start();
        }

        public static function SendAnswer(ans:String, type:String):void
        {
            var xml:XML = null;
            try
            {
                xml = new XML("<?xml version=\"1.0\" encoding=\"utf-8\"?><ROOT>" + ans + "</ROOT>");
            }
            catch (e:Error)
            {
                trace("Semu error in answer xml: " + e.errorID + ": " + e.message);
                trace("Semu answer: \"" + ans + "\"");
            }
            Comm.XMLReceived(xml, type, "SEMU");
        }

        public static function Connect():*
        {
            connecttimer = new Timer(CONNECTWAIT * 1000, 1);
            connecttimer.addEventListener(TimerEvent.TIMER, OnConnect);
            connecttimer.start();
        }

        public function Semu()
        {
            super();
        }

        public static function OnSendAnswer(e:TimerEvent):*
        {
            Semu.isready = false;
            SendAnswer(answer, "?");
            StartRobotActions();
        }

        public static function OnConnect(e:TimerEvent):*
        {
            InitConfig();
            Comm.OnConnect(e);
        }
    }
}
