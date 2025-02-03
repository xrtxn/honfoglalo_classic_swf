package triviador
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import fl.transitions.easing.*;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import syscode.*;

	public class Game
	{
		public static var lpnum:int;

		public static var nextplayer:int;

		public static var availableareas:Array;

		public static var availableareasmask:int;

		public static var warorder:String;

		public static var tag_players:Object;

		public static var tag_answerresult:Object;

		public static var tag_tipresult:Object;

		public static var tag_tipinfo:Object;

		public static var tag_gameover:Object;

		public static var tag_levelchange:Object;

		public static var tag_activeseproom:Object;

		private static var chat:MovieClip;

		public static var skiptipwindows:Boolean = false;

		public static var skipmcwindows:Boolean = false;

		public static var soldier_jump_height:Number = 30;

		public static var prevgamescreen:String = "";

		public static var commandprocessed:Boolean = false;

		public static var boxscale:Number = 1;

		public static var state:int = 0;

		public static var gameround:int = 0;

		public static var phase:int = 0;

		public static var prevgamephase:int = 0;

		public static var players:Array = [null, {}, {}, {}];

		public static var gameid:Number = 0;

		public static var room:Number = 0;

		public static var rules:int = 0;

		public static var sub_rules:int = 0;

		public static var playercount:int = 3;

		public static var isminitournament:Boolean = false;

		public static var iam:int = 0;

		public static var myopp1:int = 0;

		public static var myopp2:int = 0;

		public static var areanum:int = 20;

		public static var areas:Array = [];

		public static var warrounds:int = 4;

		public static var offender:int = 0;

		public static var defender:int = 0;

		public static var attackedarea:int = 0;

		public static var warobserver:Boolean = false;

		public static var showcastleattack:Boolean = false;

		public static var usedhelps:int = 0;

		public static var prevusedhelps:int = 0;

		public static var waitsequenceend:Boolean = true;

		public static var baseattackcontinue:Boolean = false;

		public static var tower_building:int = 0;

		public static var mylastguess:int = -1;

		public static var mylastanswer:int = 0;

		public static var questionmarkable:Boolean = false;

		public static var questionverified:Boolean = false;

		public static var reconnect:Boolean = false;

		public static var offender_areas:Array = [];

		public static var deffender_areas:Array = [];

		public static var spectator_areas:Array = [];

		public static var clocktimeout:int = 15;

		public static var my_areas:Array = [];

		public static var after_fortress:Boolean = false;

		public static var roomtype:String = "?";

		public static var autoselected:Boolean = false;

		public static var last_wait_area:int = 0;

		private static var oppselectstep:int = 0;

		public function Game()
		{
			super();
		}

		public static function Init():*
		{
			Reset();
		}

		public static function Reset():*
		{
			var n:int = 0;
			var p:* = undefined;
			tag_players = null;
			tag_answerresult = null;
			tag_tipinfo = null;
			tag_tipresult = null;
			tag_gameover = null;
			tag_levelchange = null;
			for (n = 1; n <= 3; n++)
			{
				p = Game.players[n];
				p.name = "";
				p.points = 0;
				p.base = 0;
				p.basestate = 0;
				p.selection = 0;
				p.chatstate = 0;
				p.id = -1;
				p.xppoints = 0;
				p.xplevel = 0;
				p.gamecount = 0;
				p.gamecountsr = 0;
				p.countryid = "";
				p.castlelevel = 1;
				p.soldier = 1;
			}
			for (n = 1; n <= Game.areanum; n++)
			{
				areas[n] = {
						"number": n,
						"owner": 0,
						"base": false,
						"towers": 0,
						"value": 0
					};
			}
			mylastguess = -1;
			usedhelps = 0;
			prevusedhelps = 0;
			after_fortress = false;
		}

		public static function ClearPerMessageTags():*
		{
			tag_answerresult = null;
			tag_tipinfo = null;
			Waithall.MinitournamentWin.ClearPerMessageTags();
		}

		public static function ProcessXMLTags(xml:XML, fromcmd:Boolean):*
		{
			var taglist:XMLList;
			var tagcount:int;
			var cyccount:int;
			var FG:Object;
			var GameOver:*;
			var GameOverChat:*;
			var node:XML = null;
			var nname:String = null;
			var tag:Object = null;
			var title:String = null;
			var type:int = 0;
			if (xml == null)
			{
				return;
			}
			taglist = xml.children();
			if (taglist == null)
			{
				return;
			}
			tagcount = int(taglist.length);
			cyccount = 0;
			FG = Modules.GetClass("friendlygame", "friendlygame.FriendlyGame");
			if (FG)
			{
				FG.ClearRooms();
				if (Sys.tag_activeseproom)
				{
					FG.AddRoom(Sys.tag_activeseproom);
				}
			}
			GameOver = Modules.GetClass("gameover", "gameover.GameOver");
			GameOverChat = Modules.GetClass("gameover", "gameover.GameOverChat");
			for each (node in taglist)
			{
				cyccount++;
				if (cyccount > 500)
				{
					throw new Error("main loop cycle counter reached threshold: " + cyccount + ", tagcount was:" + tagcount);
				}
				nname = node.name();
				tag = Util.XMLTagToObject(node);
				if ("STATE" == nname)
				{
					Game.ClearPerMessageTags();
					Game.tagproc_STATE(tag);
					if (Sys.screen == "WAIT")
					{
						Waithall.ResetRooms();
					}
				}
				else if ("GAMEROOM" == nname)
				{
					Waithall.AddFixRoomTag(tag);
					title = Util.StringVal(tag.TITLE);
					type = Util.NumberVal(tag.TYPE);
					if (title.substr(0, 4) == "MINI" || type == 10)
					{
						Waithall.MinitournamentWin.tagproc_GAMEROOM(tag);
					}
				}
				else if ("WAITSTATE" == nname)
				{
					Waithall.activefixroom = Util.NumberVal(tag.ROOMSEL);
					Waithall.activeseproom = Util.NumberVal(tag.SEPROOMSEL);
					Waithall.waitstatetag = tag;
				}
				else if ("SMALLUL" == nname)
				{
					Waithall.tagproc_SMALLUL(tag);
				}
				else if ("RECONNECT" == nname)
				{
					Game.tagproc_RECONNECT(tag);
				}
				else if ("PLAYERS" == nname)
				{
					Game.tag_players = tag;
					Game.tagproc_PLAYERS(tag);
				}
				else if ("ANSWERRESULT" == nname)
				{
					Game.tag_answerresult = tag;
				}
				else if ("TIPINFO" == nname)
				{
					Game.tag_tipinfo = tag;
					if (GuessQuestionMov.mc.visible)
					{
						GuessQuestionMov.mc.AnswerArrived();
					}
				}
				else if ("TIPRESULT" == nname)
				{
					Game.tag_tipresult = tag;
				}
				else if ("QUESTION" == nname)
				{
					Game.questionmarkable = Util.StringVal(tag.ALLOWMARK) == "1";
					Game.questionverified = Util.StringVal(tag.NONMARKABLE) == "1";
				}
				else if ("TIPQUESTION" == nname)
				{
					Game.questionmarkable = Util.StringVal(tag.ALLOWMARK) == "1";
					Game.questionverified = Util.StringVal(tag.NONMARKABLE) == "1";
				}
				else if ("MESSAGE" == nname)
				{
					IngameChat.tagproc_MESSAGE(tag);
					if (GameOverChat)
					{
						GameOverChat.tagproc_MESSAGE(tag);
					}
				}
				else if ("GAMEOVER" == nname)
				{
					Game.tag_gameover = tag;
					if (Sys.screen == "LEFTGAME")
					{
						if (!(GameOver && Boolean(GameOver.mc)))
						{
							Game.sqadd_GameOverWin(false);
						}
					}
				}
				else if ("LEVELCHANGE" == nname)
				{
					Game.tag_levelchange = tag;
				}
				else if ("MINITOUR" == nname)
				{
					Waithall.MinitournamentWin.tagproc_MINITOUR(tag);
					if (GameOver)
					{
						GameOver.tagproc_MINITOUR(tag);
					}
				}
				else if ("MTGAME" == nname)
				{
					Waithall.MinitournamentWin.tagproc_MTGAME(tag);
				}
				else if ("SUBSTITUTE" != nname)
				{
					if ("MARKRESULT" != nname)
					{
						if ("SEPROOM" == nname)
						{
							Modules.LoadModule("friendlygame", function():*
								{
									trace("FriendlyGame.FriendlyGame");
									if (Util.StringVal(tag.P2).split(",")[0] != Sys.mydata.id && Util.StringVal(tag.P3).split(",")[0] != Sys.mydata.id)
									{
										Modules.GetClass("friendlygame", "friendlygame.FriendlyGame").AddRoom(tag);
									}
								}, null);
						}
					}
				}
			}
			Imitation.DispatchGlobalEvent("GAMETAGSPROCESSED");
			if (IngameChat.mc)
			{
				IngameChat.mc.SendBufferedMessages();
			}
			Standings.UpdateChatButtons();
		}

		public static function ProcessDataXML(xml:XML):void
		{
			var waitforsq:* = undefined;
			if (prevgamescreen != Sys.screen)
			{
				ScreenChanged();
				prevgamescreen = Sys.screen;
			}
			var ready:Boolean = true;
			Game.ProcessXMLTags(xml, false);
			var handled:Boolean = false;
			if (Sys.screen == "WAIT" || Sys.screen == "MINITOUR" || Sys.screen == "TOURNAMENT")
			{
				Waithall.DrawScreen();
				handled = true;
			}
			else
			{
				Waithall.Hide();
			}
			if (Sys.screen == "LEFTGAME")
			{
				handled = true;
			}
			if (Sys.screen.substr(0, 3) == "MAP")
			{
				handled = true;
				Game.DrawScreen();
				waitforsq = Sys.gsqc.running && Game.waitsequenceend;
				if (Sys.wasstatetag)
				{
					Game.HandleState();
					waitforsq = Sys.gsqc.running && Game.waitsequenceend;
					if (!waitforsq)
					{
						Sys.ProcessCommandTag();
						waitforsq = Sys.gsqc.running && Game.waitsequenceend;
					}
				}
				if (waitforsq)
				{
					ready = false;
				}
			}
			if (!handled)
			{
				trace("unhandled triviador screen: " + Sys.screen);
			}
			if (!Comm.listening)
			{
				Comm.Listen(ready);
			}
		}

		public static function ProcessCommandTag(cmd:String, tag:Object):void
		{
			if (commandprocessed)
			{
				return;
			}
			trace("Triviador: Processing server cmd: " + cmd);
			if ("SELECT" == cmd)
			{
				commandprocessed = true;
				Game.clocktimeout = Util.NumberVal(tag.TO, 10);
				Map.StartAreaSelection();
				return;
			}
			if ("ANSWER" == cmd)
			{
				commandprocessed = true;
				Game.clocktimeout = Util.NumberVal(tag.TO, 15);
				if (skipmcwindows)
				{
					Comm.SendCommand("ANSWER", "ANSWER=\"" + String(Math.floor(1 + Math.random() * 4)) + "\"");
					return;
				}
				IngameChat.Hide();
				MCQuestionMov.mc.StartInput();
				Standings.UpdateChatButtons();
				return;
			}
			if ("TIP" == cmd)
			{
				commandprocessed = true;
				Game.clocktimeout = Util.NumberVal(tag.TO, 15);
				if (skiptipwindows)
				{
					Comm.SendCommand("TIP", "TIP=\"" + String(Math.floor(Math.random() * 1000)) + "\"");
					return;
				}
				IngameChat.Hide();
				GuessQuestionMov.mc.StartInput();
				Standings.UpdateChatButtons();
				return;
			}
			trace("Triviador: Unhandled server command: " + cmd);
		}

		public static function ScreenChanged():*
		{
			trace("ScreenChanged");
			if (Sys.screen.substr(0, 3) == "MAP")
			{
				Waithall.Hide();
				Standings.SetVisible(true);
			}
			else
			{
				Game.Reset();
				Map.Update();
				Standings.SetVisible(false);
			}
		}

		public static function UpdateGameScreen():*
		{
			WaitingGameMov.Hide();
			Map.Update();
			Standings.Update();
			PhaseDisplay.Update();
			Main.mc.ATTACKANIM.visible = false;
			Main.mc.FASOLDIER1.visible = false;
			Main.mc.FASOLDIER2.visible = false;
			Main.mc.FASOLDIER3.visible = false;
			Main.mc.GAMEOVER.visible = false;
			Main.mc.SELECTRING.visible = false;
			Main.mc.QSHADER.visible = false;
		}

		public static function HandleState():*
		{
			trace("Game.HandleState(" + Game.state + "-" + Game.gameround + "-" + Game.phase + " (lpnum: " + Game.lpnum + " = p" + Game.nextplayer + ")");
			Game.commandprocessed = false;
			if (Game.reconnect)
			{
				Handle_RECONNECT();
				Game.reconnect = false;
			}
			if (Game.state == 11)
			{
				HandleState_PREPAREGAME();
			}
			else if (Game.state == 1)
			{
				HandleState_SELECTBASE();
			}
			else if (Game.state == 2)
			{
				HandleState_SPREADING();
			}
			else if (Game.state == 3)
			{
				HandleState_FREEAREAS();
			}
			else if (Game.state == 4)
			{
				HandleState_WAR();
				if (Game.rules == 0 && Game.gameround >= 4 || Game.rules == 1 && Game.gameround >= 6)
				{
					Platform.LoadInterstitial(null, false);
				}
			}
			else if (Game.state == 5)
			{
				HandleState_WAROVER();
				Platform.LoadInterstitial(null, false);
			}
			else if (Game.state == 15)
			{
				HandleState_GAMEOVER();
				Platform.LoadInterstitial(null, false);
			}
			else if (Game.state == 16)
			{
				HandleState_AFTERGAME();
			}
			else
			{
				trace("Game.HandleState: unhandled state: " + Game.state);
			}
			var lastround:Boolean = Game.state == 4 && Game.phase == 21 && Game.lpnum == 3;
			Main.mc.BTNLEAVEGAME.visible = !lastround && (Game.state == 4 || Game.state == 5) && Game.players[Game.iam].points == 0 && Game.CheckActivePlayers() == 2;
			if (!Sys.gsqc.running && Sys.gsqc.anims.length > 0)
			{
				Sys.gsqc.Start(String(Game.state) + "-" + String(Game.gameround) + "-" + String(Game.phase));
			}
		}

		public static function Handle_RECONNECT():void
		{
			trace("Handle_RECONNECT(" + Game.state + "-" + Game.gameround + "-" + Game.phase + " (lpnum: " + Game.lpnum + " = p" + Game.nextplayer + ")");
			Util.ExternalCall("client_StartGame");
			IngameChat.Init();
			Standings.UpdateChatButtons();
			UpdateGameScreen();
			GuessQuestionMov.mc.Hide();
			MCQuestionMov.mc.Hide();
			Sys.gsqc.Clear();
			StopAttackAnim(true);
			Map.StopAreaSelection();
			PhaseDisplay.Init(Main.mc.PHASEDISPLAY, Main.mc.TURNTABLE, Main.mc.TURNSHADER);
			if (Game.state != 1)
			{
				if (Game.state == 2)
				{
					trace("NOT IMPLEMENTED: RECONNECT to state=2 !!!");
				}
				else if (Game.state == 3)
				{
					if (Game.phase == 2 || Game.phase == 3)
					{
						GuessQuestionMov.mc.Show();
					}
				}
				else if (Game.state == 4)
				{
					if (Game.phase == 5 || Game.phase == 6)
					{
						MCQuestionMov.mc.Show();
					}
					else if (Game.phase == 11 || Game.phase == 12)
					{
						GuessQuestionMov.mc.Show();
					}
					else if (Game.phase == 15)
					{
						if (Sys.tag_tipquestion)
						{
							GuessQuestionMov.mc.Show();
						}
						else if (Sys.tag_question)
						{
							MCQuestionMov.mc.Show();
						}
						else
						{
							Sys.tag_question = {
									"Q": "",
									"OP1": "",
									"OP2": "",
									"OP3": "",
									"OP4": ""
								};
							MCQuestionMov.mc.Show();
						}
					}
				}
				else if (Game.state == 5)
				{
					if (Game.phase == 2 || Game.phase == 3)
					{
						GuessQuestionMov.mc.Show();
					}
				}
			}
			PhaseDisplay.Update();
		}

		public static function HandleState_PREPAREGAME():void
		{
			var ao:* = undefined;
			var i:int = 0;
			WinMgr.RemoveWindow("gameover.GameOver");
			if (!WaitingGameMov.mc || !WaitingGameMov.mc.opened)
			{
				WaitingGameMov.afteropencallback = function():*
				{
					Game.HandleState_PREPAREGAME();
					Sys.gsqc.AnimFinished("WAITINGGAME_OPENWAIT");
				};
				ao = Sys.gsqc.AddObj("WAITINGGAME_OPENWAIT");
				ao.Start = function():*
				{
					if (!WaitingGameMov.mc && !WinMgr.WindowOpened(WaitingGameMov))
					{
						if (StartWindowMov.mc)
						{
							WinMgr.ReplaceWindow(StartWindowMov.mc, WaitingGameMov);
						}
						else if (Waithall.MinitournamentWin.mc)
						{
							WinMgr.ReplaceWindow(Waithall.MinitournamentWin.mc, WaitingGameMov);
						}
						else if (WinMgr.WindowOpened("friendlygame.FriendlyGame"))
						{
							if (WinMgr.WindowOpened("profile.Profile"))
							{
								WinMgr.CloseWindow(Modules.GetClass("profile", "profile.Profile").mc);
							}
							WinMgr.ReplaceWindow(Modules.GetClass("friendlygame", "friendlygame.FriendlyGame").mc, WaitingGameMov);
						}
						else
						{
							WinMgr.OpenWindow(WaitingGameMov);
						}
					}
				};
				return;
			}
			IngameChat.Init();
			Standings.UpdateChatButtons();
			PhaseDisplay.Init(Main.mc.PHASEDISPLAY, Main.mc.TURNTABLE, Main.mc.TURNSHADER);
			WinMgr.UpdateBackground();
			WaitingGameMov.mc.sqadd_PrepareForGame();
			Sys.gsqc.AddCallBack2(function():*
				{
					var bmov:MovieClip = null;
					var wmov:MovieClip = null;
					Standings.Update();
					Standings.current_player = Game.nextplayer;
					Standings.defender_player = Game.defender;
					Standings.UpdateBoxOrder();
					Standings.HiliteCurrentPlayer();
					if (WaitingGameMov.mc)
					{
						for (i = 1; i <= 3; ++i)
						{
							bmov = Standings.mc["BOX" + i];
							wmov = null;
							if (i != Game.iam)
							{
								if (i != Game.myopp1)
								{
									if (i == Game.myopp2)
									{
									}
								}
							}
							bmov.x = 0;
							bmov.y = 0;
						}
					}
				});
			Sys.gsqc.AddDelay(0.5);
			for (i = 1; i <= 3; i++)
			{
				Sys.gsqc.PlayEffect("territory_select");
				Sys.gsqc.AddTweenMaxTo(Standings.mc["BOX" + i], 0.6, {
							"x": Standings.currentx[i],
							"y": Standings.currenty[i],
							"ease": Cubic.easeInOut
						});
			}
			Sys.gsqc.Start();
		}

		public static function HandleState_SELECTBASE():void
		{
			var anim:AreaMarkerMov = null;
			var c:MovieClip = null;
			PhaseDisplay.Update();
			switch (Game.phase)
			{
				case 0:
					Util.ExternalCall("client_StartGame");
					Game.UpdateGameScreen();
					PhaseDisplay.sqadd_ShowTurn();
					break;
				case 1:
					Standings.current_player = Game.nextplayer;
					Standings.defender_player = 0;
					Standings.sqadd_HiliteCurrentPlayer();
					Map.ShowAvailableAreas(true);
					if (Game.nextplayer != Game.iam)
					{
						Game.StartWaitForOpponentAreaSelection();
					}
					else
					{
						anim = Main.mc.ATTACKANIM;
						c = PhaseDisplay.GetCastle(Game.iam);
						anim.Disc(Game.iam, 1000);
						Util.MoveTo(anim, c);
						anim.visible = false;
						c.visible = true;
					}
					break;
				case 2:
					break;
				case 3:
					Game.sqadd_ShieldMisson(Game.players[Game.lpnum].base, true);
					if (Game.rules == 0)
					{
						if (Game.nextplayer == Game.iam)
						{
							c = PhaseDisplay.GetCastle(Game.iam);
							c.visible = false;
						}
						Game.sqadd_SelectArea(Game.lpnum, Game.players[Game.lpnum].base);
						Standings.current_player = 0;
						Standings.defender_player = 0;
						Standings.sqadd_HiliteCurrentPlayer();
					}
					Map.sqadd_MapChanges();
					Standings.sqadd_ScoreChange(1, Game.players[1].points);
					Standings.sqadd_ScoreChange(2, Game.players[2].points);
					Standings.sqadd_ScoreChange(3, Game.players[3].points);
			}
		}

		public static function HandleState_SPREADING():void
		{
			var anim:AreaMarkerMov = null;
			var c:MovieClip = null;
			switch (Game.phase)
			{
				case 0:
					Game.UpdateGameScreen();
					PhaseDisplay.sqadd_ShowTurn();
					if (Game.gameround == 1)
					{
						PhaseDisplay.sqadd_RoundsAppear();
					}
					break;
				case 1:
					PhaseDisplay.sqadd_UpdateSign();
					Standings.current_player = Game.nextplayer;
					Standings.defender_player = 0;
					Standings.sqadd_HiliteCurrentPlayer();
					Sys.gsqc.AddCallBack2(Map.ShowAvailableAreas, [true]);
					if (Game.nextplayer != Game.iam)
					{
						Sys.gsqc.AddCallBack2(Game.StartWaitForOpponentAreaSelection);
					}
					else
					{
						anim = Main.mc.ATTACKANIM;
						c = Map.areamarkers[Game.players[Game.iam].base];
						anim.Disc(Game.iam, 200);
						Util.MoveTo(anim, c);
						anim.visible = false;
					}
					break;
				case 2:
					PhaseDisplay.Update();
					if (Game.nextplayer != Game.iam)
					{
						Sys.gsqc.AddCallBack2(StartWaitForOpponentAreaSelection);
					}
					break;
				case 3:
					PhaseDisplay.Update();
					Game.sqadd_SelectArea(Game.nextplayer, Game.players[Game.nextplayer].selection);
					Sys.gsqc.AddCallBack2(Game.StopAttackAnim, [true]);
					Sys.gsqc.AddDelay(0.5);
					break;
				case 4:
					Standings.current_player = 0;
					Standings.defender_player = 0;
					Standings.sqadd_HiliteCurrentPlayer();
					MCQuestionMov.mc.sqadd_ShowQuestion();
					break;
				case 5:
					break;
				case 6:
					MCQuestionMov.mc.sqadd_Evaluation();
					break;
				case 7:
					Util.ExternalCall("client_RotateBanner");
					PhaseDisplay.Update();
					Map.Combine(false);
					if (MCQuestionMov.mc.visible)
					{
						MCQuestionMov.mc.sqadd_HideQuestion();
					}
					Game.sqadd_SpreadingAnim();
					Sys.gsqc.AddCallBack2(Map.MoveAreaMarkersDefPos);
					Map.sqadd_MapChanges();
					Standings.sqadd_RestorePlayers();
					Standings.sqadd_ScoreChange(1, Game.players[1].points);
					Standings.sqadd_ScoreChange(2, Game.players[2].points);
					Standings.sqadd_ScoreChange(3, Game.players[3].points);
					if (Game.lpnum == 3)
					{
						Standings.sqadd_ReorderBoxes();
					}
					if (Map.GetFreeAreaNumber() <= 3 && Game.gameround < Game.warrounds)
					{
						Sys.gsqc.AddDelay(0.3);
						PhaseDisplay.sqadd_SpreadingRoundsDisappear();
						Sys.gsqc.AddDelay(0.7);
					}
			}
		}

		public static function HandleState_FREEAREAS():void
		{
			switch (Game.phase)
			{
				case 0:
					Game.nextplayer = 0;
					UpdateGameScreen();
					PhaseDisplay.sqadd_FreeAreaAppear();
					PhaseDisplay.sqadd_ShowTurn();
					Standings.current_player = 0;
					Standings.defender_player = 0;
					Standings.sqadd_HiliteCurrentPlayer();
					break;
				case 1:
					if (skiptipwindows)
					{
						break;
					}
					GuessQuestionMov.mc.sqadd_ShowQuestion();
					break;
				case 3:
					if (skiptipwindows)
					{
						break;
					}
					Util.ExternalCall("client_RotateBanner");
					GuessQuestionMov.mc.sqadd_Evaluate();
					GuessQuestionMov.mc.sqadd_HideQuestion();
					PhaseDisplay.sqadd_FreeAreasResult();
					autoselected = true;
					break;
				case 4:
					autoselected = false;
					Map.Combine(false);
					Standings.current_player = Game.nextplayer;
					Standings.defender_player = 0;
					Standings.sqadd_HiliteCurrentPlayer();
					if (Game.rules == 1)
					{
						PhaseDisplay.sqadd_UpdateFreeAreasPointer();
					}
					PrepareFASoldiers();
					if (Game.nextplayer != Game.iam)
					{
						Sys.gsqc.AddCallBack2(StartWaitForOpponentAreaSelection);
					}
					break;
				case 6:
					Map.Combine(false);
					PrepareFASoldiers();
					StopAttackAnim();
					Map.StopAreaSelection();
					Map.StopAnim();
					if (autoselected)
					{
						Standings.current_player = Game.nextplayer;
						Standings.defender_player = 0;
						Standings.sqadd_HiliteCurrentPlayer();
						if (Game.rules == 1)
						{
							PhaseDisplay.sqadd_UpdateFreeAreasPointer();
						}
					}
					Game.sqadd_AttackAnimOccupy();
					Map.sqadd_MapChanges();
					if (String(Standings.CalculateBoxOrder()) != String(Standings.CalculateBoxOrder([null, Game.players[1].points, Game.players[2].points, Game.players[3].points])))
					{
						Standings.sqadd_RestorePlayers();
					}
					Standings.sqadd_ScoreChange(1, Game.players[1].points);
					Standings.sqadd_ScoreChange(2, Game.players[2].points);
					Standings.sqadd_ScoreChange(3, Game.players[3].points);
					if (Game.lpnum == 3)
					{
						Standings.sqadd_ReorderBoxes();
					}
					PhaseDisplay.sqadd_FreeAreasFinish();
			}
		}

		public static function HandleState_WAR():void
		{
			var pnum:int = 0;
			var area:int = 0;
			switch (Game.phase)
			{
				case 0:
					Util.ExternalCall("client_RotateBanner");
					UpdateGameScreen();
					PhaseDisplay.sqadd_ShowTurn();
					if (Game.gameround == 1)
					{
						PhaseDisplay.sqadd_RoundsAppear();
					}
					break;
				case 1:
					if (!after_fortress)
					{
						PhaseDisplay.sqadd_UpdateWarPointer();
					}
					Standings.current_player = Game.nextplayer;
					Standings.defender_player = 0;
					Standings.sqadd_HiliteCurrentPlayer();
					if (Game.nextplayer != Game.iam)
					{
						Sys.gsqc.AddCallBack2(StartWaitForOpponentAreaSelection);
					}
					after_fortress = false;
					break;
				case 2:
					break;
				case 3:
					StopAttackAnim();
					Map.StopAreaSelection();
					for (pnum = 1; Game.players[pnum].selection == 0; )
					{
						pnum++;
					}
					area = int(Game.players[pnum].selection);
					sqadd_Attack(pnum, area);
					break;
				case 4:
					Standings.current_player = Game.nextplayer;
					Standings.defender_player = Game.defender;
					Standings.sqadd_HiliteCurrentPlayer();
					if (Game.offender != Game.iam && Game.defender != Game.iam)
					{
						Util.ExternalCall("client_RotateBanner");
					}
					MCQuestionMov.mc.sqadd_ShowQuestion();
					break;
				case 6:
					MCQuestionMov.mc.sqadd_Evaluation();
					break;
				case 10:
					GuessQuestionMov.mc.sqadd_ShowQuestion();
					break;
				case 12:
					GuessQuestionMov.mc.sqadd_Evaluate();
					break;
				case 15:
					sqadd_TowerDestroy();
					break;
				case 17:
					sqadd_TowerBuild();
					break;
				case 19:
					sqadd_FortressBuild();
					after_fortress = true;
					break;
				case 21:
					if (MCQuestionMov.mc.visible)
					{
						MCQuestionMov.mc.sqadd_HideQuestion();
					}
					if (GuessQuestionMov.mc.visible)
					{
						GuessQuestionMov.mc.sqadd_HideQuestion();
					}
					Sys.gsqc.AddCallBack2(Map.Combine, [false]);
					if (Game.areas[Game.attackedarea].owner == Game.offender)
					{
						sqadd_AttackAnimWin();
					}
					else
					{
						sqadd_AttackAnimLose();
					}
					Map.sqadd_MapChanges();
					Standings.sqadd_RestorePlayers();
					Standings.sqadd_ScoreChange(Game.defender, Game.players[Game.defender].points);
					Standings.sqadd_ScoreChange(Game.offender, Game.players[Game.offender].points);
					Standings.sqadd_ReorderBoxes();
			}
			PhaseDisplay.Order();
		}

		public static function HandleState_WAROVER():void
		{
			var winner:int = 0;
			var second:int = 0;
			switch (Game.phase)
			{
				case 0:
					UpdateGameScreen();
					PhaseDisplay.sqadd_ShowTurn();
					Standings.current_player = 0;
					Standings.defender_player = 0;
					Standings.sqadd_HiliteCurrentPlayer();
					break;
				case 1:
					GuessQuestionMov.mc.sqadd_ShowQuestion();
					break;
				case 2:
					break;
				case 3:
					GuessQuestionMov.mc.sqadd_Evaluate();
					GuessQuestionMov.mc.sqadd_HideQuestion();
					Sys.gsqc.AddCallBack2(Map.Combine, [false]);
					winner = Util.NumberVal(Game.tag_tipresult.WINNER);
					second = Util.NumberVal(Game.tag_tipresult.SECOND);
					Standings.sqadd_ScoreChange(winner, Game.players[winner].points);
					if (second > 0)
					{
						Standings.sqadd_ScoreChange(second, Game.players[second].points);
					}
					Standings.sqadd_RestorePlayers();
					Standings.sqadd_ReorderBoxes();
			}
			PhaseDisplay.Order();
		}

		public static function HandleState_GAMEOVER():void
		{
			switch (Game.phase)
			{
				case 0:
					Util.ExternalCall("client_GameOver");
					UpdateGameScreen();
					PhaseDisplay.sqadd_ShowTurn();
					Standings.current_player = 0;
					Standings.defender_player = 0;
					Standings.sqadd_HiliteCurrentPlayer();
					MCQuestionMov.Dispose();
					GuessQuestionMov.Dispose();
					sqadd_GameOverWin(true);
					break;
				case 1:
			}
		}

		public static function HandleState_AFTERGAME():void
		{
			MCQuestionMov.Dispose();
			GuessQuestionMov.Dispose();
		}

		public static function PrepareFASoldiers():void
		{
			var p:Point = null;
			var fas:AreaMarkerMov = null;
			var am:AreaMarkerMov = null;
			for (var i:int = 1; i <= 3; i++)
			{
				p = PhaseDisplay.SoldierPos(i);
				fas = Main.mc["FASOLDIER" + i];
				fas.visible = i > Game.lpnum;
				if (Game.rules == 1 && Game.state == 3)
				{
					if (i > Math.min(3, Map.areanum - Game.gameround * 3))
					{
						fas.visible = false;
					}
				}
				am = fas;
				if (Game.lpnum == i)
				{
					am = Main.mc.ATTACKANIM;
					if (am.visible)
					{
						trace("PrepareFASoldiers:", i, " / exit");
						continue;
					}
					am.Setup(Game.nextplayer, 200, 0);
					am.visible = true;
				}
				else if (am.visible && Game.rules == 0)
				{
					am.visible = false;
				}
				else if (am.visible)
				{
					if (i == 2)
					{
						am.Setup(Game.nextplayer, 200, 0);
					}
				}
				am.CVALUE.visible = false;
				am.x = p.x;
				am.y = p.y;
				am.alpha = 1;
				am.scaleX = 1;
				am.scaleY = 1;
				Imitation.UpdateAll(am);
				am.scaleX = PhaseDisplay.mc.scaleX;
				am.scaleY = am.scaleX;
			}
		}

		public static function WaitForOpponentAreaSelectionStep():void
		{
			var avail:Array = null;
			var area:int = 0;
			var anim:AreaMarkerMov = Main.mc.ATTACKANIM;
			++oppselectstep;
			if (oppselectstep % 2 == 1)
			{
				avail = Game.DecodeAvailable(Game.availableareasmask);
				avail = Util.ShuffleArray(avail);
				if (avail.length < 2)
				{
					return;
				}
				area = int(avail[0]);
				if (area == last_wait_area)
				{
					area = int(avail[1]);
				}
				last_wait_area = area;
			}
			TweenMax.to(anim, 0.4, {
						"delay": 0.4,
						"onComplete": WaitForOpponentAreaSelectionStep
					});
		}

		public static function StartWaitForOpponentAreaSelection():void
		{
			var c:MovieClip = null;
			if (Map.mapcombine)
			{
				Imitation.Combine(Map.submc, false);
			}
			Map.ShowAvailableAreas(true);
			if (Boolean(Map.bg_anim) && !TweenMax.isTweening(Map.bg_anim))
			{
				Map.MapAnim(Map.bg_anim.alpha == 0);
				TweenMax.to(Map.bg_anim, 0.3, {
							"alpha": 1,
							"delay": 1
						});
			}
			var anim:AreaMarkerMov = Main.mc.ATTACKANIM;
			var pnum:int = Game.nextplayer;
			trace("StartWaitForOpponentAreaSelection:", pnum);
			Util.StopAllChildrenMov(anim.DISC);
			if (Game.rules == 0 && Game.state == 1)
			{
				anim.Disc(pnum, 1000);
				c = PhaseDisplay.GetCastle(pnum);
				Util.MoveTo(anim, c);
			}
			else if (Game.rules == 0 && Game.state == 2)
			{
				anim.Disc(pnum, 200);
				c = Map.areamarkers[Game.players[pnum].base];
				Util.MoveTo(anim, c);
			}
			else
			{
				anim.Setup(pnum, Game.state == 4 ? 400 : 200);
				anim.CVALUE.visible = false;
			}
			anim.visible = true;
			anim.alpha = 1;
			anim.rotation = 0;
			last_wait_area = 0;
			Map.ShowWays(false, true);
			Map.ShowMapShields();
			PhaseDisplay.InitInfo();
			Map.AlignClock();
			ShowClock();
			Map.PrepareSelectRing();
			WaitForOpponentAreaSelectionStep();
			if (Map.mapcombine)
			{
				Imitation.CollectChildrenAll(Map.submc);
				Imitation.UpdateAll(Map.submc);
				Imitation.Combine(Map.submc, true);
			}
			Sounds.StopMusic("drum_roll_loop");
			Sounds.PlayMusic("drum_roll_loop");
		}

		public static function ShowClock():*
		{
			var clockmc:MovieClip = Main.mc.MAPCLOCK;
			var t1:int = getTimer();
			clockmc.visible = true;
			clockmc.gotoAndStop(2);
			Main.mc.MAPCLOCK.BG2 = Util.SwapSkin(Main.mc.MAPCLOCK.BG2, "skin_triviador", "TimerAreaBg");
			Util.SwapTextcolor(Main.mc.MAPCLOCK.NAME, "timerAreaCaptionColor", "skin_triviador");
			clockmc.NAME.scaleX = 1;
			Lang.Set(clockmc.NAME, "xy_turns", Game.players[Game.nextplayer].name);
			clockmc.AVATAR.ShowUID(Game.players[Game.nextplayer].id);
			Imitation.GotoFrame(clockmc.AFRAME, Game.nextplayer);
			var availablewidth:Number = 350;
			var tw:Number = clockmc.NAME.textWidth + 8;
			if (tw > availablewidth)
			{
				clockmc.CAPTION.NAME = tw;
				clockmc.NAME.scaleX = availablewidth / tw;
			}
			Imitation.UpdateAll(clockmc);
			clockmc.visible = false;
			var targetscale:Number = clockmc.scaleX;
			TweenMax.killTweensOf(clockmc);
			TweenMax.fromTo(clockmc, 0.5, {
						"visible": true,
						"alpha": 0,
						"scaleX": 0,
						"scaleY": 0
					}, {
						"alpha": 1,
						"scaleX": targetscale,
						"scaleY": targetscale,
						// not sure if right
						"ease": com.greensock.easing.Bounce.easeOut
					});
			TweenMax.to(clockmc, 0.75, {
						"y": clockmc.y + 15,
						"ease": Regular.easeInOut,
						"repeat": -1,
						"yoyo": true
					});
			TweenMax.fromTo(clockmc.WAIT, 1, {"frame": 1}, {
						"frame": clockmc.WAIT.totalFrames,
						"ease": Linear.easeNone,
						"repeat": -1
					});
		}

		public static function StopAttackAnim(hide:Boolean = false):void
		{
			var anim:AreaMarkerMov = Main.mc.ATTACKANIM;
			TweenMax.killTweensOf(anim);
			TweenMax.killChildTweensOf(anim);
			if (hide)
			{
				anim.visible = false;
			}
			if (Map.mapcombine)
			{
				Imitation.Combine(Map.submc, false);
			}
			Map.HideAllWays(true);
			if (Map.mapcombine)
			{
				Imitation.Combine(Map.submc, true);
			}
			Map.HideMapShields();
			Sounds.StopMusic("drum_roll_loop");
			Sounds.StopMusic("IdleLoop");
		}

		public static function sqadd_ShieldMisson(area:int, base:Boolean = false):void
		{
			var s:* = undefined;
			var ao:Object = null;
			if (!Map.shieldsmc)
			{
				return;
			}
			s = Map.shieldsmc["S" + area];
			if (base)
			{
				if (s && Boolean(s.sm2))
				{
					s.sm2.visible = false;
				}
				return;
			}
			if (Game.rules == 1 && Game.state < 4 && Game.roomtype == "C" && Game.room <= 32)
			{
				ao = Sys.gsqc.AddTweenObj("sqadd_ShieldMisson");
				ao.Start = function():*
				{
					var ox:Number = NaN;
					var oy:Number = NaN;
					if (s && Boolean(s.sm) && (Sys.mydata.shieldmission & 1 << area - 1) == 0)
					{
						s.visible = true;
						s.sm.visible = true;
						s.cacheAsBitmap = false;
						Imitation.FreeBitmapAll(s);
						Imitation.CollectChildrenAll(Map.shieldsmc);
						Imitation.UpdateAll(s);
						ox = Number(s.x);
						oy = Number(s.y);
						if (Game.iam == Game.nextplayer && !base)
						{
							s.sm.visible = false;
							s.sm2.visible = true;
							s.sm2.gotoAndStop(1);
							this.AddTweenMaxFromTo(s.sm2, 1, {
										"y": oy,
										"alpha": 1
									}, {
										"y": oy - 100,
										"alpha": 0,
										"onComplete": function():*
										{
											s.visible = false;
											s.sm2.visible = false;
										}
									});
							this.AddTweenMaxFromTo(s, 1, {
										"y": oy,
										"alpha": 1
									}, {
										"y": oy - 50,
										"alpha": 0
									});
						}
						else
						{
							TweenMax.killTweensOf(s.sm);
							s.sm.ANIM.gotoAndStop(2);
							s.sm2.visible = false;
							this.AddTweenMaxFromTo(s.sm, 1, {
										"rotation": 0,
										"y": oy,
										"scaleX": 1,
										"scaleY": 1,
										"alpha": 1
									}, {
										"rotation": -180,
										"y": oy + 50,
										"scaleX": 0.5,
										"scaleY": 0.5,
										"alpha": 0,
										"onComplete": function():*
										{
											s.visible = false;
											s.sm.visible = false;
										}
									});
							this.AddTweenMaxFromTo(s, 1, {
										"rotation": 0,
										"y": oy,
										"scaleX": 1,
										"scaleY": 1,
										"alpha": 1
									}, {
										"rotation": -180,
										"y": oy + 50,
										"scaleX": 0.5,
										"scaleY": 0.5,
										"alpha": 0
									});
						}
					}
					else
					{
						this.Next();
					}
				};
			}
		}

		public static function sqadd_SelectArea(pnum:int, area:int):void
		{
			var ao:Object;
			var anim:AreaMarkerMov = null;
			var c:MovieClip = null;
			var mypoints:* = undefined;
			anim = Main.mc.ATTACKANIM;
			Game.StopAttackAnim(true);
			Map.HideSelectRing();
			if (Game.state == 2 && Game.prevgamephase != 1)
			{
				c = Map.areamarkers[Game.players[Game.nextplayer].base];
				anim.Disc(Game.nextplayer, 200);
				Util.MoveTo(anim, c);
			}
			anim.visible = true;
			ao = Sys.gsqc.AddTweenObj("sqadd_SelectArea.MOVE");
			ao.Start = function():*
			{
				var pt:Object = Util.LocalToGlobal(Map.areamarkers[area]);
				var scale:Number = Map.areamarkers[area].scaleY;
				this.AddTweenMax(anim, 0.75, {
							"x": pt.x,
							"ease": None.easeIn
						});
				this.AddTweenMax(anim, 0.375, {
							"ease": Regular.easeOut,
							"y": Math.min(pt.y, anim.y) - soldier_jump_height * Map.markerscale,
							"scaleX": scale,
							"scaleY": scale,
							"alpha": 0.7
						});
				this.AddTweenMax(anim, 0.375, {
							"ease": Regular.easeIn,
							"y": pt.y,
							"alpha": 1,
							"delay": 0.375
						});
				anim.SHADOW.visible = true;
				anim.SHADOW.alpha = 0;
				anim.SHADOW.y = 0;
				this.AddTweenMax(anim.SHADOW, 0.375, {
							"ease": Regular.easeOut,
							"y": ((pt.y + anim.y) / 2 - Math.min(pt.y, anim.y) + soldier_jump_height) / scale,
							"alpha": 0.2,
							"scaleX": 0.9,
							"scaleY": 0.9
						});
				this.AddTweenMax(anim.SHADOW, 0.375, {
							"ease": Regular.easeIn,
							"y": 0,
							"alpha": 0.5,
							"scaleX": 1,
							"scaleY": 1,
							"delay": 0.375
						});
			};
			Map.ShowAvailableAreas(false);
			if (Game.state == 1)
			{
				Sys.gsqc.AddFadeIn(anim, 0.2, false);
				Sys.gsqc.AddDelay(0.05);
			}
			else if (Game.state == 2)
			{
				Sys.gsqc.AddCallBack2(function():*
					{
						var w:MovieClip = Map.areamarkers[area];
						w.Disc(Game.nextplayer, 200);
						w.SHADOW.visible = true;
						w.SHADOW.y = 0;
						w.SHADOW.alpha = 0.3;
						w.visible = true;
						anim.visible = false;
					});
			}
			else if (Game.state == 4 && Game.gameround == Game.warrounds)
			{
				mypoints = Game.players[Game.iam].points;
				if (Game.players[Game.myopp1].points > mypoints || Game.players[Game.myopp2].points > mypoints)
				{
					Sounds.PlayVoice("voice_last_chance_to_win");
				}
				else
				{
					Sounds.PlayVoice("voice_go_for_the_win");
				}
			}
		}

		public static function sqadd_Attack(pnum:int, area:int):void
		{
			var anim:AreaMarkerMov = null;
			var ao:Object = null;
			anim = Main.mc.ATTACKANIM;
			anim.CVALUE.visible = false;
			StopAttackAnim(false);
			ao = Sys.gsqc.AddObj("sqadd_Attack.SETUP");
			ao.Start = function():*
			{
				var pt:Object = {
						"x": 0,
						"y": 0
					};
				anim.Setup(pnum, 400);
				anim.FORTRESS.visible = false;
				anim.FORTRESSBACK.visible = false;
				anim.scaleX = Map.markerscale;
				anim.scaleY = Map.markerscale;
				if (!anim.visible)
				{
					anim.x = pt.x;
					anim.y = pt.y;
				}
				anim.alpha = 1;
				anim.visible = true;
				this.Next();
			};
			Sys.gsqc.PlayEffect("swords_drawn");
			ao = Sys.gsqc.AddTweenObj("sqadd_Attack.MOVE");
			ao.Start = function():*
			{
				var pointY:*;
				var avail:Array = Game.DecodeAvailable(Game.availableareasmask);
				var airborne:* = avail.indexOf(area) < 0;
				var speed:* = !!airborne ? 2.5 : 1;
				var pt:Object = Util.LocalToGlobal(Map.areamarkers[area]);
				this.AddTweenMax(anim, 0.75 * speed, {
							"x": pt.x - 40 * Map.markerscale,
							"ease": None.easeIn
						});
				pointY = pt.y;
				this.AddTweenMax(anim, 0.375 * speed, {
							"ease": Regular.easeOut,
							"y": Math.min(pointY, anim.y) - soldier_jump_height * (!!airborne ? 3 : 1) * Map.markerscale,
							"alpha": 0.7,
							"scaleX": Map.markerscale * 1.1,
							"scaleY": Map.markerscale * 1.1
						});
				this.AddTweenMax(anim, 0.375 * speed, {
							"ease": Regular.easeIn,
							"y": pointY,
							"alpha": 1,
							"delay": 0.375 * speed,
							"scaleX": Map.markerscale,
							"scaleY": Map.markerscale
						});
				if (airborne)
				{
					anim.PlayMagicWingsAnim();
				}
				anim.SHADOW.visible = true;
				this.AddTweenMax(anim.SHADOW, 0.375 * speed, {
							"ease": Regular.easeOut,
							"y": ((pointY + anim.y) / 2 - Math.min(pointY, anim.y) + soldier_jump_height * (!!airborne ? 3 : 1) * Map.markerscale) / Map.markerscale / 1.1,
							"alpha": 0.2,
							"scaleX": Map.markerscale * 0.4,
							"scaleY": Map.markerscale * 0.4
						});
				this.AddTweenMax(anim.SHADOW, 0.375 * speed, {
							"ease": Regular.easeIn,
							"y": 15,
							"alpha": 0.5,
							"scaleX": Map.markerscale / 2,
							"scaleY": Map.markerscale / 2,
							"delay": 0.375 * speed
						});
				TweenMax.delayedCall(0.75 * speed, function():*
					{
						anim.CVALUE.visible = true;
						ao.Next();
					});
				TweenMax.to(anim, 0.15, {
							"x": pt.x - 25 * Map.markerscale,
							"delay": 1 * speed
						});
				TweenMax.to(anim, 0.15, {
							"x": pt.x - 40 * Map.markerscale,
							"delay": 1.2 * speed
						});
			};
			ao = Sys.gsqc.AddObj("sqadd_Attack.CLICK");
			ao.Start = function():*
			{
				anim.HideMagicWingsAnim();
				this.Next();
			};
		}

		public static function sqadd_SpreadingAnim():void
		{
			var area:int = 0;
			var w:AreaMarkerMov = null;
			area = 0;
			w = null;
			var ao:* = Sys.gsqc.AddTweenObj("SPREADINGANIM.HIDEFLAG");
			ao.Start = function():*
			{
				var b:Boolean = false;
				for (var i:int = 1; i <= 3; i++)
				{
					if (Util.NumberVal(Game.players[i].points) == Standings.GetScore(i))
					{
						area = Game.players[i].selection;
						w = Map.areamarkers[area];
						this.AddTweenMaxTo(w, 0.75, {
									"alpha": 0,
									"y": w.y - 20
								});
						this.AddTweenMaxTo(w.SHADOW, 0.75, {
									"alpha": 0,
									"y": 20
								});
						b = true;
					}
				}
				if (!b)
				{
					this.Next();
				}
			};
		}

		public static function sqadd_AttackAnimOccupy():*
		{
			var anim:AreaMarkerMov = null;
			var pnum:int = 0;
			var area:int = 0;
			var targetmarker:AreaMarkerMov = null;
			var ao:* = undefined;
			anim = Main.mc.ATTACKANIM;
			StopAttackAnim(false);
			for (pnum = 1; Game.players[pnum].selection == 0; )
			{
				pnum++;
			}
			area = int(Game.players[pnum].selection);
			targetmarker = Map.areamarkers[area];
			Game.sqadd_ShieldMisson(area);
			ao = Sys.gsqc.AddTweenObj("sqadd_AttackAnimOccupy.2");
			ao.Start = function():*
			{
				anim.Setup(pnum, 200);
				anim.FORTRESS.visible = false;
				anim.FORTRESSBACK.visible = false;
				anim.CVALUE.visible = false;
				anim.visible = true;
				anim.alpha = 1;
				var pt:* = Util.LocalToGlobal(targetmarker);
				this.AddTweenMax(anim, 0.5, {
							"delay": 0,
							"x": pt.x,
							"y": pt.y,
							"scaleX": targetmarker.scaleX,
							"scaleY": targetmarker.scaleY
						});
			};
			Sys.gsqc.AddDelay(0.1);
			Sys.gsqc.PlayEffect("territory_select");
			ao = Sys.gsqc.AddObj("sqadd_AttackAnimWin.3");
			ao.Start = function():*
			{
				anim.alpha = 1;
				anim.visible = false;
				targetmarker.Setup(pnum, Game.areas[area].value);
				targetmarker.visible = true;
				this.Next();
			};
		}

		public static function sqadd_AttackAnimWin():*
		{
			var i:int = 0;
			var ao:* = undefined;
			var anim:AreaMarkerMov = Main.mc.ATTACKANIM;
			var cb:Boolean = Game.rules == 0 && Game.offender == Game.defender;
			var offender:int = cb ? 4 : Game.offender;
			ao = Sys.gsqc.AddTweenObj("sqadd_AttackAnimWin.2");
			ao.off = anim;
			ao.mov = Map.areamarkers[Game.attackedarea];
			ao.Start = function():*
			{
				var pt:* = Util.LocalToGlobal(this.mov);
				this.AddTweenMax(this.off, 0.5, {
							"delay": 0.25,
							"x": pt.x,
							"y": pt.y
						});
			};
			Sys.gsqc.AddDelay(0.1);
			ao = Sys.gsqc.AddObj("sqadd_AttackAnimWin.3");
			ao.off = anim;
			ao.mov = Map.areamarkers[Game.attackedarea];
			ao.Start = function():*
			{
				if (Game.defender == Game.iam)
				{
					Sounds.PlayVoice("voice_defeat_laughter");
				}
				else if (Game.offender == Game.iam)
				{
					if (Game.players[Game.defender].points == 0)
					{
						if (Game.defender == 1)
						{
							Sounds.PlayVoice("voice_you_have_conquered_the_red_empire");
						}
						if (Game.defender == 2)
						{
							Sounds.PlayVoice("voice_you_have_conquered_the_green_empire");
						}
						if (Game.defender == 3)
						{
							Sounds.PlayVoice("voice_you_have_conquered_the_blue_empire");
						}
					}
					else
					{
						Sounds.PlayVoice("voice_yess");
					}
				}
				this.off.alpha = 1;
				this.off.visible = false;
				this.mov.Setup(Game.offender, Game.areas[Game.attackedarea].value, Game.areas[Game.attackedarea].towers);
				this.mov.visible = true;
				this.Next();
			};
		}

		public static function sqadd_AttackAnimLose():*
		{
			var anim:AreaMarkerMov = null;
			var ao:* = undefined;
			anim = Main.mc.ATTACKANIM;
			ao = Sys.gsqc.AddTweenObj("sqadd_AttackAnimLose.2");
			ao.Start = function():*
			{
				this.AddTweenMaxTo(anim, 0.75, {
							"alpha": 0,
							"x": anim.x - 300,
							"y": anim.y - 100,
							"rotation": -45,
							"ease": Regular.easeOut
						});
				this.AddTweenMaxTo(anim.SHADOW, 0.75, {
							"alpha": 0,
							"y": 150,
							"ease": Regular.easeOut
						});
			};
			ao = Sys.gsqc.AddObj("sqadd_AttackAnimLose.3");
			ao.Start = function():*
			{
				anim.alpha = 1;
				anim.rotation = 0;
				anim.visible = false;
				this.Next();
			};
		}

		public static function sqadd_FortressBuild():*
		{
			var anum:int = int(Game.players[Game.nextplayer].selection);
			var am:AreaMarkerMov = Map.areamarkers[anum];
			am.cacheAsBitmap = false;
			am.FORTRESS.visible = true;
			am.FORTRESSBACK.visible = true;
			Imitation.CollectChildrenAll(am);
			Imitation.FreeBitmapAll(am);
			Imitation.UpdateAll(am);
			am.FORTRESS.visible = false;
			am.FORTRESSBACK.visible = false;
			Sys.gsqc.AddDelay(0.01);
			Sys.gsqc.AddTweenMaxFromTo(am.FORTRESS, 6 / 60, {
						"visible": true,
						"frame": 1
					}, {
						"frame": 6,
						"ease": Linear.easeNone
					});
			Sys.gsqc.AddTweenMaxFromTo(am.FORTRESSBACK, 6 / 60, {
						"visible": true,
						"frame": 7
					}, {
						"frame": 12,
						"ease": Linear.easeNone
					});
			Sys.gsqc.AddTweenMaxFromTo(am.FORTRESS, 6 / 60, {
						"visible": true,
						"frame": 13
					}, {
						"frame": 17,
						"ease": Linear.easeNone
					});
			Sys.gsqc.AddTweenMaxFromTo(am.FORTRESSBACK, 42 / 60, {
						"visible": true,
						"frame": 18
					}, {
						"frame": 60,
						"ease": Linear.easeNone
					});
		}

		public static function sqadd_GameOverWin(_isgsqc:Boolean):void
		{
			var p:Object = null;
			var OpenGameOver:Function = null;
			OpenGameOver = function():void
			{
				if (PhaseDisplay.mc)
				{
					PhaseDisplay.mc.visible = false;
				}
				WinMgr.OpenWindow("gameover.GameOver", {"prop": p});
				IngameChat.Hide();
			};
			p = {
					"type": "GAME",
					"players": Game.players,
					"areanum": Game.areanum,
					"areas": Game.areas,
					"iam": Game.iam,
					"myopp1": Game.myopp1,
					"myopp2": Game.myopp2,
					"tag": Game.tag_gameover,
					"save": Sys.tag_brokenseries != null,
					"minitournamentwin": Waithall.MinitournamentWin
				};
			p.tag.RULES = Game.rules;
			if (PhaseDisplay.mc)
			{
				Sys.gsqc.AddFadeIn(PhaseDisplay.mc, 0.2, false);
			}
			if (_isgsqc)
			{
				Sys.gsqc.AddCallBack2(OpenGameOver);
			}
			else
			{
				OpenGameOver();
			}
		}

		public static function sqadd_TowerDestroy():*
		{
			var w:MovieClip = null;
			var a:* = undefined;
			var ao:* = undefined;
			w = MCQuestionMov.mc;
			if (!w.visible)
			{
				w = GuessQuestionMov.mc;
			}
			if (!w.visible)
			{
				return;
			}
			a = Game.areas[Game.attackedarea];
			Map.areamarkers[Game.attackedarea].Setup(a.owner, a.value, a.towers);
			w.gotoAndStop(3);
			Util.StopAllChildrenMov(w);
			w.EXPLOSION.gotoAndStop(1);
			w.EXPLOSION.visible = true;
			Imitation.UpdateAll(w.EXPLOSION);
			w.EXPLOSION.visible = false;
			Sys.gsqc.AddDelay(0.01);
			ao = Sys.gsqc.AddTweenObj("explosion");
			ao.Start = function():*
			{
				var tpos:Array;
				var ax:Number = NaN;
				var ay:Number = NaN;
				w.ShowTowers();
				tpos = [0, -60, 60, 0];
				ax = Number(w.BIG_AREAMARKER.x);
				ay = Number(w.BIG_AREAMARKER.y);
				w.EXPLOSION.x = ax + (!!tpos[3 - a.towers] ? tpos[3 - a.towers] : 0);
				w.BIG_AREAMARKER.DUST.x = (w.EXPLOSION.x - ax) / w.BIG_AREAMARKER.scaleX;
				this.AddTweenMaxFromTo(w.EXPLOSION, 1, {
							"frameLabel": "BEGIN",
							"visible": true
						}, {
							"frameLabel": "END",
							"visible": false,
							"ease": Linear.easeNone,
							"onUpdate": function():*
							{
								var s:* = Math.cos(w.EXPLOSION.currentFrame / w.EXPLOSION.totalFrames * Math.PI / 2);
								w.BIG_AREAMARKER.x = ax + (Math.random() * 10 - 5) * s;
								w.BIG_AREAMARKER.y = ay + (Math.random() * 10 - 5) * s;
							},
							"onComplete": function():*
							{
								w.BIG_AREAMARKER.x = ax;
								w.BIG_AREAMARKER.y = ay;
							}
						});
				Sounds.PlayEffect("explosion");
				TweenMax.delayedCall(0.3, function():*
					{
						w.BIG_AREAMARKER.Setup(a.owner, a.value, a.towers);
						w.BIG_AREAMARKER.cacheAsBitmap = false;
						w.BIG_AREAMARKER.CVALUE.visible = false;
						w.BIG_AREAMARKER.FORTRESS.visible = a.fortress;
						Imitation.CollectChildrenAll(w.BIG_AREAMARKER);
						Imitation.UpdateAll(w.BIG_AREAMARKER);
					});
			};
		}

		public static function sqadd_TowerBuild():void
		{
			var w:MovieClip = null;
			var a:* = undefined;
			var ao:* = undefined;
			var ReBuild:Function = null;
			ReBuild = function():void
			{
				w.BIG_AREAMARKER.Setup(a.owner, a.value, a.towers);
				w.BIG_AREAMARKER.CVALUE.visible = false;
				w.BIG_AREAMARKER.FORTRESS.visible = a.fortress;
				Imitation.UpdateAll(w.BIG_AREAMARKER);
			};
			w = MCQuestionMov.mc;
			if (!w.visible)
			{
				w = GuessQuestionMov.mc;
			}
			if (!w.visible)
			{
				return;
			}
			a = Game.areas[Game.attackedarea];
			Map.areamarkers[Game.attackedarea].Setup(a.owner, a.value, a.towers);
			w.EXPLOSION.gotoAndStop(25);
			w.EXPLOSION.visible = true;
			Imitation.UpdateAll(w.EXPLOSION);
			w.EXPLOSION.visible = false;
			Sys.gsqc.AddDelay(0.01);
			ao = Sys.gsqc.AddTweenObj("re-explosion");
			ao.Start = function():*
			{
				var tpos:Array;
				var ax:Number = NaN;
				var ay:Number = NaN;
				w.ShowTowers();
				tpos = [0, -60, 60, 0];
				ax = Number(w.BIG_AREAMARKER.x);
				ay = Number(w.BIG_AREAMARKER.y);
				w.EXPLOSION.x = ax + (!!tpos[4 - a.towers] ? tpos[4 - a.towers] : 0);
				w.BIG_AREAMARKER.DUST.x = (w.EXPLOSION.x - ax) / w.BIG_AREAMARKER.scaleX;
				this.AddTweenMaxFromTo(w.EXPLOSION, 1, {
							"frameLabel": "END",
							"visible": true
						}, {
							"frameLabel": "BEGIN",
							"visible": false,
							"ease": Linear.easeNone,
							"onUpdate": function():*
							{
								var s:* = Math.cos(w.EXPLOSION.currentFrame / w.EXPLOSION.totalFrames * Math.PI / 2);
								w.BIG_AREAMARKER.x = ax - (Math.random() * 10 - 5) * s * 5;
								w.BIG_AREAMARKER.y = ay - (Math.random() * 10 - 5) * s * 5;
							},
							"onComplete": function():*
							{
								w.BIG_AREAMARKER.x = ax;
								w.BIG_AREAMARKER.y = ay;
							}
						});
				Sounds.PlayEffect("explosion_reverse");
			};
			Sys.gsqc.AddCallBack2(ReBuild);
			Sys.gsqc.AddDelay(0.3);
		}

		public static function KeepBufferedMessages():Boolean
		{
			trace("KeepBufferedMessages:" + Game.state + "/" + Game.phase);
			return Game.state == 3 && (Game.phase == 1 || Game.phase == 2) || Game.state == 4 && (Game.phase == 4 || Game.phase == 5 || Game.phase == 10 || Game.phase == 11);
		}

		public static function tagproc_RECONNECT(tag:*):*
		{
			Game.reconnect = true;
		}

		public static function tagproc_STATE(tag:*):*
		{
			var n:* = undefined;
			var arr:* = undefined;
			var sm:Array = null;
			var connected:* = undefined;
			var p:* = undefined;
			var b:* = undefined;
			var a:* = undefined;
			var ac:uint = 0;
			Game.roomtype = Util.StringVal(tag.RT);
			Game.prevgamephase = Game.phase;
			arr = String(tag.ST).split(",");
			Game.state = Util.NumberVal(arr[0]);
			Game.gameround = Util.NumberVal(arr[1]);
			Game.phase = Util.NumberVal(arr[2]);
			arr = String(tag.CP).split(",");
			Game.lpnum = Util.NumberVal(arr[0]);
			Game.nextplayer = Util.NumberVal(arr[1]);
			arr = String(tag.PTS).split(",");
			Game.players[1].points = Util.NumberVal(arr[0]);
			Game.players[2].points = Util.NumberVal(arr[1]);
			Game.players[3].points = Util.NumberVal(arr[2]);
			arr = String(tag.CHS).split(",");
			Game.players[1].chatstate = Util.NumberVal(arr[0]);
			Game.players[2].chatstate = Util.NumberVal(arr[1]);
			Game.players[3].chatstate = Util.NumberVal(arr[2]);
			if (Sys.screen.indexOf("MAP_") > -1)
			{
				DBG.Trace("tag.SMSR", tag.SMSR);
				sm = Util.StringVal(tag.SMSR).split(",");
				if (sm[0] !== "")
				{
					Sys.mydata.shieldmission = Util.HexToInt(Util.StringVal(sm[0]));
					Sys.mydata.shieldmission_rt = Util.HexToInt(Util.StringVal(sm[1]));
				}
				else
				{
					Sys.mydata.shieldmission = 256 * 256 * 256 - 1;
				}
			}
			for (n = 1; n <= 3; n++)
			{
				connected = String(tag.HC).indexOf(String(n)) > -1;
				Game.players[n].connected = connected;
			}
			for (n = 1; n <= 3; n++)
			{
				p = Game.players[n];
				p.selection = parseInt("0x0" + Util.StringVal(tag.SEL).substr((n - 1) * 2, 2));
				b = parseInt("0x0" + Util.StringVal(tag.B).substr((n - 1) * 2, 2));
				p.base = b & 0x1F;
				p.basestate = b >> 6 & 3;
				if (p.base > 0)
				{
					Game.areas[p.base].towers = 3 - p.basestate;
				}
			}
			Game.areanum = Math.floor(Util.StringVal(tag.A).length / 2);
			for (n = 1; n <= Game.areanum; n++)
			{
				a = Game.areas[n];
				if (a === undefined)
				{
					a = {};
					areas[n] = a;
				}
				a.number = n;
				ac = parseInt("0x" + String(tag.A).substr((n - 1) * 2, 2));
				a.owner = ac & 3;
				a.fortress = (ac & 0x80) != 0;
				a.base = false;
				a.valuecode = ac >> 4 & 7;
				if (a.valuecode == 1)
				{
					a.value = 1000;
					a.base = Game.players[a.owner].base == n;
				}
				else if (a.valuecode == 2)
				{
					a.value = 400;
				}
				else if (a.valuecode == 3)
				{
					a.value = 300;
				}
				else if (a.valuecode == 4)
				{
					a.value = 200;
				}
				else
				{
					a.value = 0;
				}
			}
			if (tag.WO !== undefined)
			{
				Game.warorder = tag.WO;
				Game.warrounds = Math.floor(Game.warorder.length / 3);
			}
			else
			{
				Game.warorder = Config.longrulesorder;
				Game.warrounds = 6;
			}
			if (tag.AA !== undefined)
			{
				Game.availableareasmask = parseInt("0x" + Util.StringVal(tag.AA));
				Game.availableareas = Game.DecodeAvailable(Game.availableareasmask);
			}
			Game.offender = 0;
			Game.defender = 0;
			Game.attackedarea = 0;
			Game.warobserver = false;
			Game.showcastleattack = false;
			Game.usedhelps = Util.NumberVal(tag.UH);
			if (Game.state == 4)
			{
				Game.offender = Game.nextplayer;
				if (1 <= Game.offender && Game.offender <= 3)
				{
					Game.attackedarea = Game.players[Game.offender].selection;
					if (Game.attackedarea > 0)
					{
						if (Game.phase == 21)
						{
							arr = String(tag.CP).split(",");
							Game.defender = Util.NumberVal(arr[2]);
							if (Game.defender < 1 || Game.defender > 3)
							{
								Game.defender = 1;
								if (Game.defender == Game.offender)
								{
									Game.defender = 2;
								}
								if (Game.defender == Game.offender)
								{
									Game.defender = 3;
								}
							}
						}
						else
						{
							Game.defender = Game.areas[Game.attackedarea].owner;
						}
						Game.showcastleattack = Boolean(Game.areas[Game.attackedarea].base) || Boolean(Game.areas[Game.attackedarea].fortress);
					}
				}
				if (Game.offender != Game.iam && Game.defender != Game.iam)
				{
					Game.warobserver = true;
				}
			}
			if (Game.state == 15)
			{
			}
		}

		public static function tagproc_PLAYERS(tag:*):*
		{
			var arr:* = undefined;
			var i:* = undefined;
			var p:* = undefined;
			arr = Util.StringVal(tag.RULES).split(",");
			Game.rules = Util.NumberVal(arr[0]);
			Game.sub_rules = Util.NumberVal(arr[1]);
			Game.gameid = Util.NumberVal(tag.GAMEID);
			Game.room = Util.NumberVal(tag.ROOM);
			if (Game.rules == 2)
			{
				Game.playercount = 2;
			}
			else
			{
				Game.playercount = 3;
			}
			Game.isminitournament = tag.MINITOUR == "1";
			arr = String(tag.YOU).split(",");
			Game.iam = Util.NumberVal(arr[0]);
			Game.myopp1 = Util.NumberVal(arr[1]);
			Game.myopp2 = Util.NumberVal(arr[2]);
			for (i = 1; i <= 3; i++)
			{
				p = Game.players[i];
				p.name = Util.StringVal(tag["P" + i]);
				arr = String(tag["PD" + i]).split(",");
				if (i == Game.iam)
				{
					p.id = Sys.mydata.id;
					p.xppoints = Sys.mydata.xppoints;
					p.xplevel = Sys.mydata.xplevel;
					p.gamecount = Sys.mydata.gamecount;
					p.gamecountsr = Sys.mydata.gamecountstr;
					p.countryid = Sys.mydata.countryid;
					p.castlelevel = Sys.mydata.castlelevel;
					p.customavatar = Sys.mydata.customavatar;
					p.soldier = Sys.mydata.soldier;
					p.actleague = Sys.mydata.league;
					p.extavatar = Sys.mydata.extavatar;
					p.usecustomavatar = Sys.mydata.usecustomavatar;
				}
				else
				{
					p.id = Util.NumberVal(arr[0]);
					p.xppoints = Util.NumberVal(arr[1]);
					p.xplevel = Util.NumberVal(arr[2]);
					p.gamecount = Util.NumberVal(arr[3]);
					p.gamecountsr = Util.NumberVal(arr[4]);
					p.countryid = Util.StringVal(arr[5]);
					p.castlelevel = Util.NumberVal(arr[6]);
					p.customavatar = Util.StringVal(arr[7]);
					p.soldier = Util.NumberVal(arr[8], 1);
					p.actleague = Util.NumberVal(arr[9], 1);
					p.extavatar = Util.StringVal(tag["AVATAR" + i]);
					p.usecustomavatar = p.customavatar != "";
				}
				if (Sys.mydata.xplevel < 3 && p.id == Sys.mydata.id)
				{
					p.castlelevel = 0;
				}
				if (p.id != Sys.mydata.id && p.id > 0 && p.name != "" && Boolean(p.usecustomavatar))
				{
					Extdata.SetUserData(p.id, p.name, !!p.usecustomavatar ? p.customavatar : p.extavatar);
				}
			}
			var bnum:int = 0;
			for (i = 1; i <= 3; i++)
			{
				if (i != Game.iam)
				{
					bnum++;
					p = Game.players[i];
					if (p.id < 0)
					{
						p.name = GetBotFakeName(Game.gameid + bnum);
						p.id = -100 - (1 + (Game.gameid + bnum) % 8);
					}
				}
			}
			trace("tagproc_PLAYERS: IAM=" + Game.iam);
		}

		public static function GetBotFakeName(anum:Number):String
		{
			return Lang.get ("bot_fake_name_" + (1 + anum % 8));
		}

		public static function AlignItems():*
		{
			var stagewidth:Number = Aligner.stagewidth;
			var stageheight:Number = Aligner.stageheight;
			var wboxscale:Number = Aligner.basescale * 0.81;
			if (stagewidth < 800 * Aligner.basescale * 0.81)
			{
				wboxscale = stagewidth / 800 * 0.81;
			}
			var hboxscale:Number = Aligner.basescale;
			if (stageheight < 480 * Aligner.basescale)
			{
				hboxscale = stageheight / 480;
			}
			boxscale = wboxscale < hboxscale ? wboxscale : hboxscale;
			if (boxscale < 0.5)
			{
				boxscale = 0.5;
			}
			var lg:Object = Main.mc.BTNLEAVEGAME;
			lg.x = stagewidth - (lg.width + 10);
			lg.y = stageheight - (lg.height + 10);
			Map.AlignMap();
			if (Boolean(MCQuestionMov.mc) && MCQuestionMov.mc.visible)
			{
				MCQuestionMov.mc.AlignFunc();
			}
			if (Boolean(GuessQuestionMov.mc) && GuessQuestionMov.mc.visible)
			{
				GuessQuestionMov.mc.AlignFunc();
			}
			Standings.UpdateLayout();
			Standings.HiliteCurrentPlayer();
			Standings.UpdateChatButtons();
			UpdateFullscreenButton();
			Imitation.FreeBitmapAll();
		}

		public static function UpdateFullscreenButton():void
		{
			var bfs:MovieClip = Main.mc.BTNFULLSCREEN;
			Sys.SetupFullScreenButton(bfs);
			if (bfs.visible)
			{
				bfs.x = 5;
				bfs.y = Aligner.stageheight - 55;
			}
		}

		public static function DrawScreen():*
		{
		}

		public static function DecodeSpreadingorder(wo:String, round:int, lpnum:int):int
		{
			return int(parseInt(wo.charAt((round - 1) * 3 + (lpnum - 1))));
		}

		public static function DecodeWarorder(wo:String, round:int, lpnum:int):int
		{
			var pi:* = (round - 1) * 3 + (lpnum - 1);
			var pc:* = wo.charAt(pi);
			return Util.NumberVal(pc);
		}

		public static function DecodeAvailable(available:int):Array
		{
			var res:Array = [];
			for (var i:* = 1; i <= 30; i++)
			{
				if ((available & 1 << i - 1) != 0)
				{
					res.push(i);
				}
			}
			return res;
		}

		public static function CheckActivePlayers():uint
		{
			var result:uint = 0;
			var player:Object = null;
			for (var i:int = 1; i < Game.players.length; i++)
			{
				player = Game.players[i];
				if (Boolean(player) && Util.NumberVal(player.points) > 0)
				{
					result++;
				}
			}
			return result;
		}

		public static function SetupBoosterButton(btn:MovieClip, atype:String, aprice:int):void
		{
			var cnt:int = 0;
			btn.atype = atype;
			if (aprice > 0)
			{
				Imitation.GotoFrame(btn, "FORGOLD", false);
				btn.LABEL.text = aprice;
				Util.SwapTextcolor(btn.LABEL, "mcqWinHelpButtonCaptionColorForGold", "skin_triviador");
				btn.BASE.BG = Util.SwapSkin(btn.BASE.BG, "skin_triviador", "MCQHelpButtonActiveBg");
			}
			else if (aprice == 0)
			{
				Imitation.GotoFrame(btn, "INSTOCK", false);
				cnt = int(Sys.mydata.freehelps[Config.helpindexes[atype]]);
				btn.LABEL.text = cnt;
				Util.SwapTextcolor(btn.LABEL, "mcqWinHelpButtonCaptionColorInStock", "skin_triviador");
				btn.BASE.BG = Util.SwapSkin(btn.BASE.BG, "skin_triviador", "MCQHelpButtonActiveBg");
			}
			else if (aprice == -2)
			{
				Imitation.GotoFrame(btn, "USED", false);
				Lang.Set(btn.LABEL, "applied");
				Util.SwapTextcolor(btn.LABEL, "mcqWinHelpButtonCaptionColorUsed", "skin_triviador");
				btn.BASE.BG = Util.SwapSkin(btn.BASE.BG, "skin_triviador", "MCQHelpButtonInactiveBg");
			}
			else if (aprice == -5)
			{
				Imitation.GotoFrame(btn, "LOCKED", false);
				btn.BASE.BG = Util.SwapSkin(btn.BASE.BG, "skin_triviador", "MCQHelpButtonInactiveBg");
			}
			else
			{
				Imitation.GotoFrame(btn, "NOGOLD", false);
				btn.LABEL.text = "2000";
				Util.SwapTextcolor(btn.LABEL, "mcqWinHelpButtonCaptionColorNoGold", "skin_triviador");
				btn.BASE.BG = Util.SwapSkin(btn.BASE.BG, "skin_triviador", "MCQHelpButtonInactiveBg");
			}
			Imitation.GotoFrame(btn.BASE.ICON, atype, false);
		}

		public function ClearRooms():void
		{
		}
	}
}
