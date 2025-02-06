package minitournament
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import syscode.*;
	import uibase.gfx.lego_button_1x1_cancel_header;
	import uibase.gfx.lego_button_1x1_normal_header;

	[Embed(source="/modules/minitournament_assets.swf", symbol="symbol499")]
	public class MinitournamentWin extends MovieClip
	{
		public static var mc:MinitournamentWin;

		private static var selectedgame:MovieClip = null;

		public static var Waithall:Object = null;

		public static var PhaseDisplay:Object = null;

		public static var state:int = 0;

		public static var currentround:int = 0;

		public static var currentlyplaying:int = 0;

		public static var iamout:Boolean = false;

		public static var remaining:int = 0;

		public static var remainingreftime:int = 0;

		public static var prevstate:int = 0;

		public static var prevround:int = 0;

		public static var games:Array = [null, [], [], []];

		public static var resetgames:Boolean = false;

		public static var gameroom_tag:Object = null;

		public static var minitournament_tag:Object = null;

		public static var tab_langids:Array = [null, "qualifying", "semi_final", "final", "final_results_short"];

		public static var timer:Timer = new Timer(1000, 0);

		public static var reftime:Number = 0;

		public static var remsec:int = 0;

		public static var windowopened:Boolean = false;

		public var BACK:MovieClip;

		public var BOUNDS:MovieClip;

		public var BTNBACK:lego_button_1x1_cancel_header;

		public var BTNHELP:lego_button_1x1_normal_header;

		public var CONTENT:MovieClip;

		public var INTRO:MovieClip;

		public var LOGO:MovieClip;

		public var MTOURSTATE:MovieClip;

		public var TOP3:MovieClip;

		public var TROPHIES:MovieClip;

		public var opening:Boolean = false;

		public function MinitournamentWin()
		{
			super();
		}

		public static function Init(awaithall:Class, aphasedisplay:*):void
		{
			Waithall = awaithall;
			PhaseDisplay = aphasedisplay;
		}

		public static function Hide():void
		{
			if (mc)
			{
				WinMgr.CloseWindow(mc);
			}
		}

		public static function DrawScreen():void
		{
			if (!mc)
			{
				if (iamout && WinMgr.WindowOpened("gameover.GameOver"))
				{
					return;
				}
				WinMgr.OpenWindow(MinitournamentWin);
			}
			else
			{
				mc.DoDrawScreen();
			}
			resetgames = true;
		}

		public static function ClearPerMessageTags():void
		{
			gameroom_tag = null;
			minitournament_tag = null;
		}

		public static function tagproc_GAMEROOM(tag:Object):void
		{
			var mc:MinitournamentWin = null;
			var sm:MovieClip = null;
			MinitournamentWin.gameroom_tag = tag;
			if (MinitournamentWin.gameroom_tag && MinitournamentWin.mc && Sys.screen != "MINITOUR")
			{
				mc = MinitournamentWin.mc;
				MinitournamentWin.reftime = new Date().time;
				MinitournamentWin.remsec = Util.NumberVal(MinitournamentWin.gameroom_tag.REMAINING);
				if (mc.opening)
				{
					return;
				}
				sm = mc.MTOURSTATE;
				sm.gotoAndStop("REMAINING");
				Lang.Set(sm.C_REMAINING.FIELD, "remaining_time_to_start+:");
				mc.OnTimer(null);
			}
		}

		public static function tagproc_MINITOUR(tag:Object):void
		{
			var lastround:* = currentround;
			minitournament_tag = tag;
			state = Util.NumberVal(tag.STATE);
			currentround = Util.NumberVal(tag.CURRENTROUND);
			currentlyplaying = Util.NumberVal(tag.PLAYING);
			iamout = Util.NumberVal(tag.IAMOUT) != 0;
			remaining = Util.NumberVal(tag.REMAINING);
			remainingreftime = getTimer();
			if (lastround != currentround && mc && Boolean(mc.CONTENT))
			{
				selectedgame = null;
			}
		}

		public static function tagproc_MTGAME(tag:Object):void
		{
			var pp:Array = null;
			var po:Object = null;
			var r:int = Util.NumberVal(tag.R);
			if (r < 1 || r > 3)
			{
				return;
			}
			if (resetgames)
			{
				games[1] = [];
				games[2] = [];
				games[3] = [];
				resetgames = false;
			}
			var statearr:Array = Util.StringVal(tag.S).split(",");
			var gs:Object = {
					"tag": tag,
					"index": games[r].length + 1,
					"state": Util.NumberVal(statearr[0]),
					"gameround": Util.NumberVal(statearr[1]),
					"linplayer": Util.NumberVal(statearr[2]),
					"curplayer": Util.NumberVal(statearr[3]),
					"defender": Util.NumberVal(statearr[4]),
					"third": 0,
					"baseattack": Util.NumberVal(statearr[5]),
					"players": [null]
				};
			for (var pn:int = 1; pn <= 3; pn++)
			{
				pp = Util.StringVal(tag["P" + pn + "PTS"]).split(",");
				po = {
						"name": Util.StringVal(tag["P" + pn + "NAME"]),
						"avatar": Util.StringVal(tag["P" + pn + "AVATAR"]),
						"userid": Util.StringVal(tag["P" + pn + "ID"]),
						"place": Util.StringVal(tag["P" + pn + "PLACE"]),
						"points": Util.NumberVal(pp[0]),
						"basestate": Util.NumberVal(pp[1])
					};
				gs.players.push(po);
			}
			games[r].push(gs);
		}

		public static function RoundPlayerX(r:int, p:int, s:int):Number
		{
			var x:Number = NaN;
			if (r < 1)
			{
				x = 1;
			}
			else if (p < 0)
			{
				x = 1 + r * 3;
			}
			else if (p > 3)
			{
				x = 3 + r * 3;
			}
			else
			{
				x = p + r * 3;
			}
			if (s == 4)
			{
				x += 4 * 3;
			}
			if (s > 4)
			{
				return 1;
			}
			trace(r, p, s);
			return x / 8 / 3;
		}

		public function Prepare(aprops:Object):void
		{
			var GameOver:Object;
			var ppl:int;
			var r:int;
			var mxp:int;
			windowopened = false;
			Util.StopAllChildrenMov(this);
			this.BOUNDS.visible = false;
			this.BTNBACK.AddEventClick(this.OnBackClick);
			this.BTNBACK.SetIcon("X");
			this.BTNHELP.SetIcon("HELP");
			this.BTNHELP.AddEventClick(this.OnHelpClick);
			Imitation.AddEventMouseDown(mc.BACK, function(e:*):*
				{
					selectedgame = null;
				});
			mc.BACK.buttonMode = false;
			this.INTRO.visible = false;
			this.INTRO.NPC.Set("GENERAL", "DEFAULT");
			GameOver = Modules.GetClass("gameover", "gameover.GameOver");
			ppl = 0;
			r = 0;
			mxp = 0;
			if (GameOver)
			{
				r = int(GameOver.mt_round);
			}
			if (GameOver)
			{
				mxp = int(GameOver.data.mt_prize_xp);
			}
			if (Boolean(GameOver) && Boolean(GameOver.data))
			{
				ppl = int(GameOver.data.placings.indexOf(GameOver.data.iam));
			}
			mc.ShowMinitournamentTrophies(r, ppl, mxp);
			this.DoDrawScreen();
			this.opening = true;
		}

		public function OnHelpClick(e:*):void
		{
			WinMgr.OpenWindow("help.Help", {
						"tab": 1,
						"subtab": 3
					});
		}

		private function ShowMinitournamentTrophies(r:int, ppl:int, xp:int):*
		{
			var places:* = undefined;
			var p:String = null;
			var numcups:int = 0;
			var i:int = 0;
			this.TROPHIES.visible = true;
			if (r == 3 && state == 3 && ppl > 0)
			{
				this.TROPHIES.gotoAndStop("WIN");
				this.TROPHIES.CUP.gotoAndStop(ppl);
				Util.SetText(this.TROPHIES.XP.FIELD, "+" + xp + " " + Lang.get ("xp"));
				Lang.Set(this.TROPHIES.CAPTION.FIELD, "your_trophies");
			}
			else if (iamout && ppl > 1 && r > 0)
			{
				this.TROPHIES.gotoAndStop("OUT");
				Lang.Set(this.TROPHIES.OUTTEXT.FIELD, "try_next_time");
				Lang.Set(this.TROPHIES.C_YOURPLACE.FIELD, "your_place");
				places = [["10-18", "19-27"], ["4-6", "7-9"]];
				p = !!places[r - 1] ? places[r - 1][ppl - 2] : null;
				if (p)
				{
					this.TROPHIES.YOURPLACE.visible = true;
					if (this.TROPHIES.YOURPLACE.FIELD.text != p)
					{
						this.TROPHIES.YOURPLACE.FIELD.text = p;
						Imitation.FreeBitmapAll(this.TROPHIES.YOURPLACE);
						Imitation.UpdateAll(this.TROPHIES.YOURPLACE);
					}
				}
				else
				{
					this.TROPHIES.YOURPLACE.visible = false;
				}
				Lang.Set(this.TROPHIES.C_XP.FIELD, "you_got");
				Util.SetText(this.TROPHIES.XP.FIELD, "+" + xp + " " + Lang.get ("xp"));
			}
			else if (Sys.mydata.mtcups)
			{
				this.TROPHIES.gotoAndStop("NOTFINISHED");
				numcups = 0;
				for (i = 0; i < 3; i++)
				{
					if (Sys.mydata.mtcups[i] > 0)
					{
						numcups++;
					}
					this.TROPHIES["C" + (i + 1)].FIELD.text = Sys.mydata.mtcups[i];
					this.TROPHIES["ICON" + (i + 1)].gotoAndStop(Sys.mydata.mtcups[i] > 0 ? 1 : 2);
				}
				if (numcups > 0)
				{
					Lang.Set(this.TROPHIES.CAPTION.FIELD, "your_trophies");
				}
				else
				{
					Lang.Set(this.TROPHIES.CAPTION.FIELD, "collect_trophies");
				}
			}
			else
			{
				this.TROPHIES.visible = false;
			}
		}

		public function OnTimer(e:TimerEvent):void
		{
			var sm:MovieClip = null;
			var rem:String = null;
			var now:Number = NaN;
			var dif:int = 0;
			if (mc.opening)
			{
				return;
			}
			if (MinitournamentWin.mc)
			{
				sm = MinitournamentWin.mc.MTOURSTATE;
				if (sm.currentFrameLabel == "REMAINING")
				{
					rem = "";
					if (MinitournamentWin.reftime > 0 && MinitournamentWin.remsec > 0)
					{
						now = new Date().time;
						dif = Math.round((now - MinitournamentWin.reftime) / 1000);
						if (dif <= MinitournamentWin.remsec)
						{
							rem = Util.FormatRemaining(MinitournamentWin.remsec - dif);
						}
					}
					if (sm.REMAINING.FIELD.text != rem)
					{
						sm.REMAINING.FIELD.text = rem;
					}
				}
			}
		}

		public function AfterOpen():void
		{
			this.opening = false;
			windowopened = true;
			this.DrawGames();
			Util.AddEventListener(timer, TimerEvent.TIMER, this.OnTimer);
			timer.start();
		}

		public function AfterClose():void
		{
			timer.stop();
			Util.RemoveEventListener(timer, TimerEvent.TIMER, this.OnTimer);
			state = 0;
			currentround = 0;
			currentlyplaying = 0;
			iamout = false;
			remaining = 0;
			remainingreftime = 0;
			prevstate = 0;
			prevround = 0;
			games = [null, [], [], []];
			resetgames = false;
			gameroom_tag = null;
			minitournament_tag = null;
		}

		public function DoDrawScreen():void
		{
			if (this.opening)
			{
				return;
			}
			var sm:MovieClip = mc.MTOURSTATE;
			Lang.Set(this.LOGO.TITLE.FIELD, "minitournament");
			DBG.Trace("minitournament_tag", minitournament_tag);
			DBG.Trace("minitournament_room", MinitournamentWin.gameroom_tag);
			trace(Sys.screen, iamout);
			if (Boolean(MinitournamentWin.gameroom_tag) && Sys.screen != "MINITOUR")
			{
				sm.gotoAndStop("REMAINING");
				Lang.Set(sm.C_REMAINING.FIELD, "remaining_time_to_start+:");
				MinitournamentWin.reftime = new Date().time;
				MinitournamentWin.remsec = Util.NumberVal(MinitournamentWin.gameroom_tag.REMAINING);
				this.OnTimer(null);
				this.DrawPage();
				this.BTNBACK.SetEnabled(true);
				return;
			}
			if (!minitournament_tag)
			{
				sm.gotoAndStop("REMAINING");
				sm.C_REMAINING.FIELD.text = "";
				sm.REMAINING.FIELD.text = "";
				this.BTNBACK.SetEnabled(true);
				return;
			}
			if (!iamout)
			{
				this.BTNBACK.SetEnabled(false);
			}
			else
			{
				this.BTNBACK.SetEnabled(true);
			}
			if (state == 1)
			{
				sm.gotoAndStop("REMAINING");
				if (currentround <= 1)
				{
					Lang.Set(sm.C_REMAINING.FIELD, "remaining_time_to_start+:");
				}
				else
				{
					Lang.Set(sm.C_REMAINING.FIELD, "remaining_to_next_game+:");
				}
				MinitournamentWin.reftime = new Date().time;
				MinitournamentWin.remsec = Util.NumberVal(remaining);
				this.OnTimer(null);
			}
			else if (state == 2)
			{
				sm.gotoAndStop("GAMESRUNNING");
				if (currentround == 3)
				{
					Lang.Set(this.MTOURSTATE.C_STATE.FIELD, "final");
				}
				else if (currentround == 2)
				{
					Lang.Set(this.MTOURSTATE.C_STATE.FIELD, "semi_final");
				}
				else
				{
					Lang.Set(this.MTOURSTATE.C_STATE.FIELD, "qualifying");
				}
				Lang.Set(sm.C_INGAMEPLAYERS.FIELD, "currently_playing+:");
				sm.INGAMEPLAYERS.FIELD.text = currentlyplaying;
				sm.visible = true;
			}
			else
			{
				this.BTNBACK.SetEnabled(true);
				sm.gotoAndStop("FINISHED");
				Lang.Set(sm.CAPTION.FIELD, "minitournament_finished");
			}
			this.DrawPage();
			prevstate = state;
			prevround = currentround;
		}

		public function DrawPage():void
		{
			var w:Object = this.CONTENT;
			if (selectedgame)
			{
				this.DrawAreas();
			}
			this.DrawGames();
			trace("---------------" + state);
			if (state == 3)
			{
				w.alpha = 1;
				this.INTRO.visible = false;
				w.GAME3_1.visible = false;
				mc.TOP3.visible = true;
				this.DrawTop3();
			}
			else if (state == 0)
			{
				w.alpha = 0.2;
				this.INTRO.visible = true;
				Util.SetText(this.INTRO.SPEECH.FIELD, Lang.get ("minitournament_info2"));
				mc.TOP3.visible = false;
				w.GAME3_1.visible = true;
			}
			else
			{
				w.alpha = 1;
				this.INTRO.visible = false;
				w.GAME3_1.visible = true;
				mc.TOP3.visible = false;
			}
		}

		private function DrawTop3():void
		{
			var a:MovieClip = null;
			var pnum:* = undefined;
			var xps:Array = null;
			this.INTRO.visible = false;
			var w:MovieClip = mc.TOP3;
			var pname:String = "";
			var myplace:Number = 0;
			w.visible = true;
			var gs:Object = games[3][0];
			if (!gs)
			{
				return;
			}
			var points:Array = [];
			for (var n:* = 1; n <= 3; n++)
			{
				points.push({
							"place": gs.players[n].place,
							"basestate": gs.players[n].basestate,
							"player": n
						});
			}
			points = points.sortOn("place", Array.NUMERIC);
			for (n = 1; n <= 3; n++)
			{
				pnum = points[n - 1].player;
				pname = gs.players[pnum].name;
				w["AVATAR" + n].ShowUID(gs.players[pnum].userid);
				Util.SetText(w["NAME" + n].FIELD, pname);
				xps = [8000, 4000, 2000];
				Util.SetText(w["XP" + n].FIELD, xps[n - 1] + " " + Lang.get ("xp"));
				w["BORDER" + n].gotoAndStop(pnum);
			}
		}

		public function DrawGames():void
		{
			var n:int = 0;
			var gmov:MovieClip = null;
			var gs:Object = null;
			var mygame:Boolean = false;
			var pnum:int = 0;
			var pb:MovieClip = null;
			var pname:String = null;
			var pid:* = undefined;
			var rank:int = 0;
			var off:MovieClip = null;
			var def:MovieClip = null;
			for (var r:int = 1; r <= 3; r++)
			{
				for (n = 1; n <= 9; n++)
				{
					gmov = this.CONTENT["GAME" + (r > 1 ? r + "_" : "") + n];
					if (gmov)
					{
						gs = games[r][n - 1];
						if (gs)
						{
							gmov.gotoAndStop(currentround == r ? 1 : 2);
							Util.StopAllChildrenMov(gmov);
							Imitation.CollectChildrenAll(gmov);
							if (gs.state < 15)
							{
							}
							gmov.SWORD.visible = false;
							gmov.SHIELD.visible = false;
							gmov.CANNON.visible = false;
							gmov.TOWER.visible = false;
							gmov.FLAG.visible = false;
							gmov.gs = gs;
							mygame = false;
							TweenMax.to(gmov.PHASE, 2, {"scaleX": RoundPlayerX(gs.gameround, gs.linplayer, gs.state)});
							for (pnum = 1; pnum <= 3; pnum++)
							{
								pb = gmov["SCORE" + pnum];
								pname = gs.state < 15 ? "" : gs.players[pnum].name;
								pid = gs.players[pnum].userid;
								rank = int(gs.players[pnum].place);
								pb.gotoAndStop(pnum);
								Imitation.CollectChildrenAll(gmov);
								if (pid == Sys.mydata.id)
								{
									mygame = true;
								}
								if (!pb.AVATAR.mt)
								{
									pb.AVATAR.mt = true;
									pb.AVATAR.Clear();
								}
								if (windowopened)
								{
									pb.AVATAR.ShowUID(pid);
								}
								pb.AVATAR.DisableClick();
								Util.SetText(pb.SCORE.FIELD, gs.players[pnum].points);
								Imitation.GotoFrame(pb.CASTLE, 1 + gs.players[pnum].basestate);
								if (gs.state == 15)
								{
									pb.RANK.visible = true;
									if (rank == 1 && pid == Sys.mydata.id)
									{
										Imitation.GotoFrame(pb.RANK, 1);
									}
									else
									{
										Imitation.GotoFrame(pb.RANK, rank + 1);
									}
								}
								else
								{
									pb.RANK.stop();
									pb.RANK.visible = false;
								}
								if (gs.curplayer == pnum)
								{
									if (gs.state == 4)
									{
										off = Boolean(gs.baseattack) && gs.defender > 0 ? gmov.CANNON : gmov.SWORD;
										off.visible = true;
										if (off.x != pb.x)
										{
											off.x = pb.x;
											off.alpha = 0;
											TweenMax.to(off, 0.8, {"alpha": 1});
											TweenMax.fromTo(off, 0.3, {"y": pb.y}, {
														"y": pb.y - 8,
														"repeat": 5,
														"yoyo": true
													});
										}
									}
									else
									{
										gmov.FLAG.visible = true;
										if (gmov.FLAG.x != pb.x)
										{
											gmov.FLAG.x = pb.x;
											gmov.FLAG.alpha = 0;
											TweenMax.to(gmov.FLAG, 0.8, {"alpha": 1});
											TweenMax.fromTo(gmov.FLAG, 0.3, {"y": pb.y}, {
														"y": pb.y - 8,
														"repeat": 5,
														"yoyo": true
													});
										}
									}
								}
								if (gs.defender == pnum)
								{
									def = !!gs.baseattack ? gmov.TOWER : gmov.SHIELD;
									def.visible = true;
									if (def.x != pb.x)
									{
										def.x = pb.x;
										def.alpha = 0;
										TweenMax.to(def, 0.8, {"alpha": 1});
										TweenMax.fromTo(def, 0.3, {"y": pb.y}, {
													"y": pb.y - 8,
													"repeat": 5,
													"yoyo": true
												});
									}
								}
							}
							if (mygame)
							{
								Imitation.GotoFrame(gmov.BG, 2);
							}
							else
							{
								Imitation.GotoFrame(gmov.BG, gs.state == 15 ? 3 : 1);
							}
						}
						else
						{
							gmov.gotoAndStop(3);
						}
					}
				}
			}
		}

		private function OnGameClick(e:*):void
		{
			selectedgame = e.target;
			var s:MovieClip = this.CONTENT.SEL;
			var info:MovieClip = s.INFO;
			s.x = e.target.x;
			s.y = e.target.y;
			s.visible = true;
			Lang.Set(info.C_AREAS, "areas");
			Util.SetText(info.C_ROUND, Lang.Get("gameround") + " " + selectedgame.gs.gameround + "/15");
			this.DrawAreas();
		}

		private function DrawAreas():void
		{
			var per:Number = NaN;
			var strip:MovieClip = null;
			var prevstrip:MovieClip = null;
			var c:MovieClip = null;
			var w:MovieClip = this.CONTENT.SEL.INFO;
			var sum:Number = selectedgame.gs.players[1].points + selectedgame.gs.players[2].points + selectedgame.gs.players[3].points;
			for (var i:uint = 1; i <= 3; i++)
			{
				per = selectedgame.gs.players[i].points / sum;
				strip = w.GRAPH["SHAPE_" + i];
				prevstrip = w.GRAPH["SHAPE_" + Number(i - 1)];
				if (strip)
				{
					strip.x = 0;
					strip.scaleX = per;
					strip.gotoAndStop(i);
					if (prevstrip)
					{
						strip.x = prevstrip.x + prevstrip.width + 4;
					}
				}
				c = w["C" + i];
				if (c)
				{
					Util.SetText(c.PER, (per * 100).toFixed(1) + "%");
					if (strip)
					{
						if (c.width > strip.width * w.GRAPH.scaleX)
						{
							c.visible = false;
						}
						else
						{
							c.visible = true;
							c.x = w.GRAPH.x + (strip.x + strip.width / 2 + 4) * w.GRAPH.scaleX;
						}
					}
				}
			}
			Imitation.CollectChildrenAll(w);
			Imitation.FreeBitmapAll(w);
		}

		public function GameStateName(astate:int, around:int):String
		{
			var s:String = "";
			switch (astate)
			{
				case 0:
					s = Lang.get ("game_starting");
					break;
				case 1:
					s = Lang.get ("gameround_1b");
					break;
				case 2:
					s = Lang.get ("gameround_2");
					break;
				case 3:
					s = Lang.get ("gameround_3") + " / " + around;
					break;
				case 4:
					s = Lang.get ("gameround_4") + " / " + around;
					break;
				case 5:
					s = Lang.get ("gameround_5");
					break;
				case 15:
				case 16:
					s = Lang.get ("gameround_15");
			}
			return s;
		}

		public function DrawWaitingForPlayers():void
		{
			this.CONTENT.gotoAndStop("WAITING");
			this.MTOURSTATE.gotoAndStop("WAITPLAYERS");
			Lang.Set(this.MTOURSTATE.CAPTION, "waiting_for_players");
		}

		public function OnBackClick(e:*):void
		{
			if (Sys.screen != "MINITOUR")
			{
				Comm.SendCommand("EXITROOM", "");
			}
			else
			{
				Comm.SendCommand("CHANGEWAITHALL", "WH=\"GAME\"");
			}
		}

		public function OnSemuStartClick(e:*):void
		{
			Comm.SendCommand("SEMUSTARTMINITOUR", "");
		}
	}
}
