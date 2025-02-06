package triviador
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	import syscode.*;
	import triviador.compat.lego_button_1x1_normal_header;
	import triviador.compat.lego_button_1x1_cancel_header;
	import triviador.compat.TriviadorShutdownWait;
	import triviador.gfx.TriviadorLegoIconset;

	[Embed(source="/modules/triviador_assets.swf", symbol="symbol1300")]
	public class StartWindowMov extends MovieClip
	{
		public static var mc:StartWindowMov = null;

		public static var backtothevillage:Boolean = false;

		public static var friendlist_sent_to_gs:Boolean = false;

		public static var xrt_bypass_encryption:Boolean = true;

		public var BTNCLOSE:lego_button_1x1_cancel_header;

		public var BTNHELP:lego_button_1x1_normal_header;

		public var BTNSETTINGS:lego_button_1x1_normal_header;

		public var ENERGY_DATA:MovieClip;

		public var FRAME:MovieClip;

		public var INVENTORY:MovieClip;

		public var LASTPLACES:MovieClip;

		public var LEGO_DAILY_RESET_ONE:MovieClip;

		public var NPCS:MovieClip;

		public var SHUTDOWN:TriviadorShutdownWait;

		public var STARTMENU:MovieClip;

		public var USERDATA:MovieClip;

		private var friendly_icon:MovieClip = null;

		public var lifeupdatetimer:Timer = null;

		public var touchX:Number = 0;

		public var dragmovetx:Number = 0;

		public var dragTouched:Boolean = false;

		public var waitanim:Object = null;

		public var minitimer:Timer;

		public var minireftime:Number = 0;

		public var miniremsec:int = 0;

		public var miniremmov:TextField = null;

		public var tournamenttimer:Timer;

		public var tournamentreftime:Number = 0;

		public var tournamentremsec:int = 0;

		public var tournamentremmov:TextField = null;

		public var notifs:*;

		public var notifIcon:*;

		public var tournament_alert_win:MovieClip;

		private var tournament_disabled_others:Boolean = false;

		private var tournament_nostart_time:Number = 600;

		public var rlresetremaining:int = 0;

		public var rlresettimeref:int = 0;

		public var rlresettimer:Timer = null;

		public function StartWindowMov()
		{
			this.minitimer = new Timer(1000, 0);
			this.tournamenttimer = new Timer(100, 0);
			super();
		}

		public static function DrawScreen():void
		{
			if (!mc)
			{
				if (backtothevillage)
				{
					return;
				}
				WinMgr.OpenWindow(StartWindowMov);
			}
			else
			{
				mc.DoDrawScreen();
			}
		}

		public static function Show():void
		{
			if (!mc)
			{
				WinMgr.OpenWindow(StartWindowMov);
			}
		}

		public static function Hide():void
		{
			backtothevillage = false;
			if (mc)
			{
				if (mc.notifs != null)
				{
					mc.notifs.Reset();
					mc.notifs.RemoveVideoadsListeners();
				}
				WinMgr.CloseWindow(mc);
			}
		}

		public static function HideModule():*
		{
			if (mc)
			{
				if (mc.notifs != null)
				{
					mc.notifs.Reset();
					mc.notifs.RemoveVideoadsListeners();
				}
			}
		}

		public function AfterClose():void
		{
			Util.RemoveEventListener(Imitation.rootmc, "MYDATACHANGE", this.OnMyDataChange);
			if (backtothevillage)
			{
				Comm.SendCommand("CHANGEWAITHALL", "WH=\"VILLAGE\"");
			}
			if (this.minitimer)
			{
				Util.RemoveEventListener(this.minitimer, TimerEvent.TIMER, this.OnMiniTimer);
				if (this.minitimer.running)
				{
					this.minitimer.stop();
				}
				this.minitimer = null;
			}
			if (this.tournamenttimer)
			{
				Util.RemoveEventListener(this.tournamenttimer, TimerEvent.TIMER, this.OnTournamentTimer);
				if (this.tournamenttimer.running)
				{
					this.tournamenttimer.stop();
				}
				this.tournamenttimer = null;
			}
			if (this.lifeupdatetimer)
			{
				Util.RemoveEventListener(this.lifeupdatetimer, TimerEvent.TIMER, this.UpdateNextLifeTime);
				if (this.lifeupdatetimer.running)
				{
					this.lifeupdatetimer.stop();
				}
				this.lifeupdatetimer = null;
			}
			this.WeeklyTimerDestroy();
		}

		public function CanClose():Boolean
		{
			backtothevillage = true;
			return true;
		}

		public function AfterOpen():void
		{
			Util.AddEventListener(Imitation.rootmc, "MYDATACHANGE", this.OnMyDataChange);
			Util.AddEventListener(this.minitimer, TimerEvent.TIMER, this.OnMiniTimer);
			Util.AddEventListener(this.tournamenttimer, TimerEvent.TIMER, this.OnTournamentTimer);
			this.minitimer.start();
			this.tournamenttimer.start();
		}

		public function Prepare(aparams:Object):void
		{
			var l:MovieClip = null;
			var i:int = 0;
			while (i < 10)
			{
				l = this.LASTPLACES["S" + i];
				l.ox = l.x;
				i++;
			}
			Util.StopAllChildrenMov(this);
			this.WeeklyTimerStop();
			backtothevillage = false;
			this.UpdateShutdownWait();
			this.BTNCLOSE.SetIcon("X");
			this.BTNCLOSE.AddEventClick(this.OnVillageClick);
			this.BTNHELP.SetIcon("HELP");
			this.BTNHELP.AddEventClick(this.OnHelpClick);
			this.BTNSETTINGS.SetIcon("SETTINGS");
			this.BTNSETTINGS.AddEventClick(this.OnSettingsClick);
			this.BTNSETTINGS.SetEnabled(Sys.mydata.xplevel > 0);
			if (Sys.mydata.xplevel > 0)
			{
				Imitation.AddEventClick(this.ENERGY_DATA.ENERGYBG, this.OnPlusEnergyClick);
			}
			Imitation.AddEventClick(this.USERDATA.UNAMEBG, this.OnProfileClick);
			this.rlresetremaining = Util.NumberVal(Sys.rlresetremaining);
			this.rlresettimeref = getTimer();
			this.DrawStartMenu();
			this.DrawMyData();
			Imitation.FreeBitmapAll(this);
			Imitation.UpdateAll(this);
		}

		public function OnHelpClick(e:*):void
		{
			WinMgr.OpenWindow("help.Help", {
						"tab": 1,
						"subtab": 1
					});
		}

		public function DoDrawScreen():*
		{
			var tag:Object = null;
			var title:String = null;
			var type:int = 0;
			var foundmini:Boolean = false;
			var i:int = 0;
			while (i < Waithall.fixgamerooms.length)
			{
				tag = Waithall.fixgamerooms[i];
				if (tag)
				{
					title = Util.StringVal(tag.TITLE);
					type = Util.NumberVal(tag.TYPE);
					if (title.substr(0, 4) == "MINI" || type == 10)
					{
						this.minireftime = new Date().time;
						this.miniremsec = Util.NumberVal(tag.REMAINING);
						foundmini = true;
						break;
					}
				}
				i++;
			}
			if (foundmini != (this.miniremmov != null))
			{
				if (!foundmini)
				{
					this.miniremmov = null;
				}
			}
			this.DrawStartMenu();
		}

		public function DrawMyData():*
		{
			var GameOver:Object = Modules.GetClass("gameover", "gameover.GameOver");
			var xpchange:* = 0;
			if (GameOver)
			{
				xpchange = GameOver.lastxpchange;
				GameOver.lastxpchange = 0;
			}
			this.DrawBoosters();
			this.USERDATA.LVL1C.FIELD.text = Lang.Get("lvl");
			this.USERDATA.LVL2C.FIELD.text = Lang.Get("lvl");
			this.USERDATA.LVLFIELD.FIELD.text = Sys.mydata.xplevel;
			this.USERDATA.NEXTLVLFIELD.FIELD.text = Sys.mydata.xplevel + 1;
			this.USERDATA.USERNAME.FIELD.text = Util.FormatNumber(Util.NumberVal(Sys.mydata.xppoints) - Util.NumberVal(Sys.mydata.xpactmin)) + " / " + Util.FormatNumber(Util.NumberVal(Sys.mydata.xptonextlevel) - Util.NumberVal(Sys.mydata.xpactmin)) + " " + Lang.Get("xp");
			var scale:Number = (Sys.mydata.xppoints - Sys.mydata.xpactmin) / (Sys.mydata.xptonextlevel - Sys.mydata.xpactmin);
			scale = Math.max(0, Math.min(1, scale));
			var scale2:Number = xpchange / (Sys.mydata.xptonextlevel - Sys.mydata.xpactmin);
			if (scale2 > scale)
			{
				scale2 = 0;
			}
			this.USERDATA.XPBAR.STRIP.scaleX = scale - scale2;
			this.DrawEnergy();
			this.DrawLastPlaces();
		}

		public function OnMyDataChange(e:*):*
		{
			if (!mc)
			{
				return;
			}
			this.DrawMyData();
			Imitation.FreeBitmapAll(this);
			Imitation.UpdateAll(this);
		}

		public function DrawStartMenu():void
		{
			var firstgameroomid:* = undefined;
			var room:Object = null;
			var title:String = null;
			var type:int = 0;
			var id:int = 0;
			var b:MovieClip = null;
			if (Sys.CheckFeature("SEPROOMS"))
			{
				Waithall.AddFixRoomTag({
							"TYPE": 11,
							"TITLE": "FRIENDLY"
						});
			}
			this.NPCS.visible = false;
			this.STARTMENU.y = -96;
			var rooms:Array = [];
			var i:int = 0;
			while (i < Waithall.fixgamerooms.length)
			{
				room = Waithall.fixgamerooms[i];
				title = Util.StringVal(room.TITLE);
				type = Util.NumberVal(room.TYPE);
				id = Util.NumberVal(room.ID);
				trace("title: " + title);
				trace("type: " + type);
				trace("id: " + id);
				trace("------------------");
				if (Sys.mydata.xplevel < 10)
				{
					if (type == 11)
					{
						rooms.push(Waithall.fixgamerooms[i]);
					}
					if (type == 2 && title == "DEFAULT")
					{
						rooms.push(Waithall.fixgamerooms[i]);
					}
					this.LASTPLACES.visible = false;
					this.WeeklyTimerStop();
					this.USERDATA.visible = false;
					this.ENERGY_DATA.visible = false;
					this.NPCS.visible = true;
					this.NPCS.NPC.Set("VETERAN");
					Util.SetText(this.NPCS.TXT1.FIELD, Lang.Get("start_win_npc1"));
					Util.SetText(this.NPCS.TXT2.FIELD, Lang.Get("start_win_npc2"));
					if (this.NPCS.TXT1.FIELD.numLines >= 3)
					{
						this.NPCS.TXT1.FIELD.y = 9;
					}
					if (this.NPCS.TXT1.FIELD.numLines == 2)
					{
						this.NPCS.TXT1.FIELD.y = 18;
					}
					if (this.NPCS.TXT1.FIELD.numLines == 1)
					{
						this.NPCS.TXT1.FIELD.y = 27;
					}
					if (this.NPCS.TXT2.FIELD.numLines >= 3)
					{
						this.NPCS.TXT2.FIELD.y = 9;
					}
					if (this.NPCS.TXT2.FIELD.numLines == 2)
					{
						this.NPCS.TXT2.FIELD.y = 18;
					}
					if (this.NPCS.TXT2.FIELD.numLines == 1)
					{
						this.NPCS.TXT2.FIELD.y = 27;
					}
					this.STARTMENU.y = -77;
				}
				else
				{
					this.WeeklyTimerStart();
					this.LASTPLACES.visible = true;
					this.USERDATA.visible = true;
					this.ENERGY_DATA.visible = true;
					rooms.push(Waithall.fixgamerooms[i]);
				}
				i++;
			}
			rooms = rooms.sort(this.SortRooms);
			if (Sys.tag_tournament.length > 0 && Util.NumberVal(Sys.tag_tournament[0].REMAINING) > 1)
			{
				if (Sys.mydata.xplevel > 10)
				{
					rooms.unshift({
								"TITLE": Sys.tag_tournament[0].TITLE,
								"TYPE": 12,
								"ID": Sys.tag_tournament[0].ID,
								"REMAINING": Sys.tag_tournament[0].REMAINING,
								"CLOSED": 0,
								"GOLD": Sys.tag_tournament[0].GOLD,
								"BOOSTERS": Sys.tag_tournament[0].BOOSTERS,
								"GAMES": Sys.tag_tournament[0].GAMES,
								"PLAYERS": Sys.tag_tournament[0].PLAYERS,
								"MAXPLAYERS": Sys.tag_tournament[0].MAXPLAYERS
							});
				}
			}
			if (Sys.tag_tournament.length > 0)
			{
				if (Util.NumberVal(Sys.tag_tournament[0].REMAINING) < this.tournament_nostart_time && Sys.tag_tournament[0].JOINED == "1")
				{
					this.tournament_disabled_others = true;
				}
			}
			var n:int = 1;
			while (n <= 6)
			{
				b = this.STARTMENU["BTN" + n];
				if (n <= rooms.length)
				{
					b.visible = true;
					this.SetupRoom(b, rooms[n - 1]);
					if (b.firstgameroomid)
					{
						firstgameroomid = b.firstgameroomid;
					}
				}
				else
				{
					b.visible = false;
				}
				n++;
			}
			var startmenupos:Array = [0, -59, -122, -185, -248, -310, -374];
			this.STARTMENU.x = startmenupos[rooms.length];
			if (Util.NumberVal(Sys.mydata.xplevel == 0) && !Sys.codegame && Config.mobile)
			{
				trace("firstgameroomid: " + firstgameroomid);
				this.EnterRoom(firstgameroomid);
			}
		}

		private function SetupRoom(m:MovieClip, room:Object):void
		{
			var enabled:* = false;
			var title:String = Util.StringVal(room.TITLE);
			var type:int = Util.NumberVal(room.TYPE);
			var id:int = Util.NumberVal(room.ID);
			Util.FormatTrace(room);
			if (Sys.mydata.xplevel < 10)
			{
				m.WOOD.visible = true;
			}
			else
			{
				m.WOOD.visible = false;
			}
			if (type == 2)
			{
				enabled = false;
				m.STAMP.gotoAndStop(1);
				m.STAMP.visible = true;
				m.STAMP.NUM.FIELD.text = "-15";
				m.REMAINING.visible = false;
				if (title == "JUNIOR")
				{
					enabled = Sys.mydata.xplevel > 0;
					m.ICON.gotoAndStop("JUNIOR");
					m.BG.gotoAndStop("BLUE");
					Lang.Set(m.CAPTION.FIELD, "game_junior");
				}
				else if (id == 2)
				{
					enabled = Sys.mydata.xplevel > 0;
					m.ICON.gotoAndStop("LONG");
					m.BG.gotoAndStop("GREEN");
					Lang.Set(m.CAPTION.FIELD, "game_rule_1");
				}
				else
				{
					enabled = true;
					m.ICON.gotoAndStop("NORMAL");
					m.BG.gotoAndStop("RED");
					m.firstgameroomid = id;
					Lang.Set(m.CAPTION.FIELD, "game_rule_2");
				}
				m.ICON.LOCKED.cacheAsBitmap = true;
				m.ICON.LOCKED.visible = !enabled;
				m.ICON.LOCKGR.visible = !enabled;
				if (enabled && !this.tournament_disabled_others)
				{
					Imitation.AddEventClick(m.BG, this.OnStartGame, {"roomid": id});
					Imitation.AddEventClick(m.ICON, this.OnStartGame, {"roomid": id});
				}
				else
				{
					Imitation.RemoveEvents(m.BG);
					Imitation.RemoveEvents(m.ICON);
				}
			}
			else if (type == 10)
			{
				this.SetupMinitournamentRoom(m, room);
			}
			else if (type == 11)
			{
				this.SetupSeparateRoom(m, room);
			}
			else if (type == 12)
			{
				this.SetupTournamentRoom(m, room);
			}
			if (m.CAPTION.FIELD.numLines <= 1)
			{
				m.CAPTION.FIELD.text = "\n" + m.CAPTION.FIELD.text;
			}
		}

		private function SetupMinitournamentRoom(m:MovieClip, room:Object):void
		{
			m.ICON.gotoAndStop("MINITOURNAMENT");
			m.BG.gotoAndStop("ORANGE");
			m.STAMP.gotoAndStop(1);
			m.STAMP.visible = true;
			m.STAMP.NUM.FIELD.text = "-30";
			Lang.Set(m.CAPTION.FIELD, "minitournament");
			if (Util.NumberVal(room.CLOSED) == 1)
			{
				m.ICON.LOCKED.visible = true;
				m.ICON.LOCKGR.visible = true;
				m.REMAINING.visible = false;
				Imitation.RemoveEvents(m);
			}
			else
			{
				m.ICON.LOCKED.visible = false;
				m.ICON.LOCKGR.visible = false;
				if (!this.tournament_disabled_others)
				{
					Imitation.AddEventClick(m.BG, this.OnStartGame, {"roomid": Util.NumberVal(room.ID)});
					Imitation.AddEventClick(m.ICON, this.OnStartGame, {"roomid": Util.NumberVal(room.ID)});
				}
				else
				{
					Imitation.RemoveEvents(m.BG);
					Imitation.RemoveEvents(m.ICON);
				}
				m.REMAINING.visible = true;
				this.minireftime = new Date().time;
				this.miniremsec = Util.NumberVal(room.REMAINING);
				this.miniremmov = m.REMAINING.FIELD;
				this.miniremmov.text = Util.FormatRemaining(this.miniremsec);
			}
		}

		private function SetupSeparateRoom(m:MovieClip, room:Object):void
		{
			m.ICON.gotoAndStop("FRIENDLY");
			m.BG.gotoAndStop("BROWN");
			m.ICON.LOCKED.visible = false;
			m.ICON.LOCKGR.visible = false;
			m.ICON.NOTIFY.visible = false;
			this.friendly_icon = m.ICON;
			m.STAMP.gotoAndStop(1);
			m.STAMP.visible = false;
			m.REMAINING.visible = false;
			if (!this.tournament_disabled_others)
			{
				Imitation.AddEventClick(m.BG, this.OnFriendlyGame);
				Imitation.AddEventClick(m.ICON, this.OnFriendlyGame);
			}
			else
			{
				Imitation.RemoveEvents(m.BG);
				Imitation.RemoveEvents(m.ICON);
			}
			Lang.Set(m.CAPTION.FIELD, "friendly_game");
		}

		private function SetupTournamentRoom(m:MovieClip, room:Object):void
		{
			m.ICON.gotoAndStop("TOURNAMENT");
			m.BG.gotoAndStop("BLUE");
			m.STAMP.gotoAndStop(1);
			m.STAMP.visible = false;
			m.STAMP.NUM.FIELD.text = "-30";
			m.CAPTION.FIELD.text = room.TITLE;
			if (Util.NumberVal(room.CLOSED) == 1)
			{
				m.ICON.LOCKED.visible = true;
				m.ICON.LOCKGR.visible = true;
				m.REMAINING.visible = false;
				Imitation.RemoveEvents(m.BG);
				Imitation.RemoveEvents(m.ICON);
			}
			else
			{
				m.ICON.LOCKED.visible = false;
				m.ICON.LOCKGR.visible = false;
				m.ICON.visible = true;
				Imitation.AddEventClick(m.BG, this.OnStartTournament, {"roomid": Util.NumberVal(room.ID)});
				Imitation.AddEventClick(m.ICON, this.OnStartTournament, {"roomid": Util.NumberVal(room.ID)});
				m.REMAINING.visible = true;
				this.tournamentreftime = new Date().time;
				this.tournamentremsec = Util.NumberVal(room.REMAINING);
				this.tournamentremmov = m.REMAINING.FIELD;
				this.tournamentremmov.text = Util.FormatRemaining(this.tournamentremsec, false);
			}
		}

		private function SortRooms(a:Object, b:Object):int
		{
			var av:int = Util.NumberVal(a.TYPE);
			var bv:int = Util.NumberVal(b.TYPE);
			if (av == bv)
			{
				av = Util.NumberVal(a.ID);
				bv = Util.NumberVal(b.ID);
				return av < bv ? -1 : 1;
			}
			return av < bv ? -1 : 1;
		}

		public function DrawBoosters():void
		{
			var enabled:Boolean = false;
			var i:int = 0;
			var acthelpname:String = null;
			var myforge2:Object = null;
			var duration2:int = 0;
			var elapsed2:int = 0;
			var remaining2:int = 0;
			i = 1;
			while (i <= 12)
			{
				enabled = false;
				acthelpname = String(Config.helpfieldname[i - 1]);
				this.INVENTORY["BOOSTER" + i].ICONSET.Set(acthelpname);
				if (i == 1 && Sys.mydata.uls[9] == 1)
				{
					enabled = true;
				}
				if (i == 2 && Sys.mydata.uls[10] == 1)
				{
					enabled = true;
				}
				if (i == 3 && Sys.mydata.uls[11] == 1)
				{
					enabled = true;
				}
				if (i == 4 && Sys.mydata.uls[12] == 1)
				{
					enabled = true;
				}
				if (i == 5 && Sys.mydata.uls[13] == 1)
				{
					enabled = true;
				}
				if (i == 6 && Sys.mydata.uls[14] == 1)
				{
					enabled = true;
				}
				if (i == 7 && Sys.mydata.uls[15] == 1)
				{
					enabled = true;
				}
				if (i == 8 && Sys.mydata.uls[16] == 1)
				{
					enabled = true;
				}
				if (i == 9 && Sys.mydata.uls[17] == 1)
				{
					enabled = true;
				}
				if (i == 10 && Sys.mydata.uls[18] == 1)
				{
					enabled = true;
				}
				if (i == 11 && Sys.mydata.uls[19] == 1)
				{
					enabled = true;
				}
				if (i == 12 && Sys.mydata.uls[20] == 1)
				{
					enabled = true;
				}
				if (!enabled)
				{
					this.INVENTORY["BOOSTER" + i].ICONSET.Set("LOCK");
				}
				if (enabled && (i <= 7 || i == 8 || i == 9))
				{
					Imitation.AddEventClick(this.INVENTORY["BOOSTER" + i], this.OnBoosterClick, {"boosterid": i});
				}
				this.INVENTORY["BOOSTER" + i].VALUEMC.VALUE.FIELD.text = Sys.mydata.freehelps[i];
				if (i <= 7 || i == 8 || i == 9)
				{
					myforge2 = Sys.mydata.helpforges[i];
					if (Semu.enabled)
					{
						myforge2 = {
								"prodtime": 1,
								"remainingtime": 0,
								"prodcount": 1
							};
					}
					duration2 = myforge2.prodtime * 60 * 60;
					elapsed2 = Math.round((getTimer() - Sys.mydata.time) / 1000);
					remaining2 = myforge2.remainingtime - elapsed2;
					this.INVENTORY["BOOSTER" + i].NOTIFY.visible = enabled && remaining2 <= 0;
					this.INVENTORY["BOOSTER" + i].NOTIFY.NOTIFYANIM.FIELD.text = "+" + myforge2.prodcount;
				}
				else
				{
					this.INVENTORY["BOOSTER" + i].NOTIFY.visible = false;
				}
				this.INVENTORY.GOLD.FIELD.text = Util.FormatNumber(Sys.mydata.gold);
				if (Sys.mydata.xplevel > 0)
				{
					Imitation.AddEventClick(this.INVENTORY.GOLDCLICK, this.OnPlusGoldClick);
				}
				i++;
			}
		}

		public function OnBoosterClick(e:*):void
		{
			WinMgr.OpenWindow("forge.Forge", {
						"funnelid": "",
						"boosterid": e.params.boosterid
					});
		}

		public function DrawLastPlaces():void
		{
			var won:Number = NaN;
			var noloss:Number = NaN;
			var currplaces:Array = null;
			var wonstart:Boolean = false;
			var nolossstart:Boolean = false;
			var wonstartmc:MovieClip = null;
			var nolossstartmc:MovieClip = null;
			var k:int = 0;
			var i:uint = 0;
			var m:MovieClip = null;
			var p:* = 0;
			var l:MovieClip = null;
			if (Sys.mydata.gamecount >= 11)
			{
			}
			Lang.Set(this.LASTPLACES.WON.FIELD, "serial_win");
			Lang.Set(this.LASTPLACES.NOLOSS.FIELD, "serial_noloss");
			if (Sys.mydata.lastplaces.length > 0)
			{
				won = Util.NumberVal(Sys.mydata.curcwins);
				noloss = Util.NumberVal(Sys.mydata.curcwins2);
				currplaces = Sys.mydata.lastplaces;
				if (currplaces.length < 10)
				{
					k = 10 - currplaces.length;
					i = 0;
					while (i < k)
					{
						currplaces.unshift(0);
						i++;
					}
				}
				currplaces.length = 10;
				wonstart = true;
				nolossstart = true;
				i = 0;
				while (i < 10)
				{
					m = this.LASTPLACES["S" + i];
					m.WON.visible = false;
					m.NOLOSS.visible = false;
					m.STARTWONMC.visible = false;
					m.STARTNOLOSSMC.visible = false;
					m.NUM.FIELD.text = 10 - i;
					if (currplaces[i] == null)
					{
						currplaces[i] = 0;
					}
					p = parseInt(currplaces[i]) & 3;
					if (p > 0)
					{
						m.COIN.visible = true;
						Imitation.GotoFrame(m, "PLACE" + p);
						if (wonstart && p == 1)
						{
							m.WON.visible = true;
							if (wonstartmc == null)
							{
								wonstartmc = m;
								m.WON.visible = false;
								m.STARTWONMC.visible = true;
							}
						}
						if (nolossstart && (p == 1 || p == 2))
						{
							m.NOLOSS.visible = true;
							if (nolossstartmc == null)
							{
								nolossstartmc = m;
								m.NOLOSS.visible = false;
								m.STARTNOLOSSMC.visible = true;
							}
						}
						if (p == 2)
						{
							wonstart = false;
						}
						if (p == 3)
						{
							wonstart = false;
							nolossstart = false;
						}
					}
					else
					{
						m.COIN.visible = false;
					}
					i++;
				}
			}
			else
			{
				i = 0;
				while (i < 10)
				{
					l = this.LASTPLACES["S" + i];
					l.NUM.FIELD.text = 10 - i;
					l.COIN.visible = false;
					l.STARTWONMC.visible = false;
					l.STARTNOLOSSMC.visible = false;
					l.WON.visible = false;
					l.NOLOSS.visible = false;
					i++;
				}
			}
			Imitation.FreeBitmapAll(this.LASTPLACES);
			Imitation.UpdateAll(this.LASTPLACES);
		}

		public function UpdateShutdownWait():void
		{
			if (Boolean(this.STARTMENU) && Boolean(this.SHUTDOWN))
			{
				this.STARTMENU.visible = Sys.tag_shutdown == null;
				this.SHUTDOWN.visible = !this.STARTMENU.visible;
				if (Sys.tag_shutdown != null)
				{
					this.SHUTDOWN.Draw();
				}
			}
		}

		public function DrawEnergy():void
		{
			var r:Number = Sys.mydata.energy / Sys.mydata.energymax;
			if (r > 1)
			{
				r = 1;
			}
			this.ENERGY_DATA.ENERGY.BAR.STRIP.scaleX = r;
			this.ENERGY_DATA.ENERGY.PERCENT.FIELD.text = Sys.mydata.energy + " / " + Sys.mydata.energymax;
			if (this.lifeupdatetimer == null)
			{
				this.lifeupdatetimer = new Timer(1000, 0);
				Util.AddEventListener(this.lifeupdatetimer, TimerEvent.TIMER, this.UpdateNextLifeTime);
				this.lifeupdatetimer.start();
			}
			this.UpdateNextLifeTime();
		}

		public function UpdateNextLifeTime(event:TimerEvent = null):void
		{
			var elapsed:int = Math.round((getTimer() - Sys.mydata.time) / 1000);
			var nextlifesecs:int = Util.NumberVal(Sys.mydata.energynextupdate) - elapsed;
			var energytime:String = "";
			if (nextlifesecs > 0)
			{
				energytime = Util.FormatRemaining(nextlifesecs);
			}
			if (energytime == "")
			{
				energytime = "00:00";
			}
			this.ENERGY_DATA.ENERGY.TIME.FIELD.text = energytime;
			if (energytime != this.ENERGY_DATA.ENERGY.TIME.FIELD.text)
			{
				Imitation.Update(this.ENERGY_DATA.ENERGY);
			}
			this.UpdateShutdownWait();
		}

		public function OnStartGame(e:Object):void
		{
			this.EnterRoom(e.params.roomid);
		}

		public function OnStartTournament(e:Object):void
		{
			if (Sys.tag_tournament[0].JOINED == "1")
			{
				Comm.SendCommand("CHANGEWAITHALL", "WH=\"TOURNAMENT\"");
			}
			else
			{
				WinMgr.OpenWindow("tournament.TournamentWin");
			}
		}

		public function OnFriendlyGame(e:Object):void
		{
			if (Sys.mydata.name == "")
			{
				WinMgr.ReplaceWindow(this, "settings.AvatarWin");
			}
			else
			{
				WinMgr.ReplaceWindow(this, "friendlygame.FriendlyGame");
			}
		}

		public function EnterRoom(roomid:int = 0):void
		{
			var i:int = 0;
			var s:String = "";
			var f:Array = [];
			WinMgr.ShowLoadWait();
			if (!StartWindowMov.friendlist_sent_to_gs)
			{
				i = 0;
				while (i < Friends.all.length)
				{
					if (Friends.all[i].flag == 1)
					{
						f.push(Friends.all[i].id);
					}
					i++;
				}
				s += " FRIENDS=\"" + Util.StrXmlSafe(f.join(",")) + "\"";
			}
			Comm.SendCommand("ENTERROOM", "ROOM=\"" + roomid + "\"" + s, this.OnEnterRoomResult);
		}

		public function OnEnterRoomResult(res:int, xml:XML):void
		{
			var x:Object = null;
			var r:int = 0;
			var t:String = null;
			if (res > 0)
			{
				if (res == 23)
				{
					x = Util.XMLTagToObject(xml);
					r = Util.NumberVal(x.SUSPENDED.REASON);
					t = Util.FormatRemaining(Util.NumberVal(x.SUSPENDED.EXPIRE));
					UIBase.ShowMessage(Lang.Get("suspended_title"), Lang.Get("suspended_reason_" + r, t));
				}
				else if (res == 87)
				{
					WinMgr.OpenWindow("energy.Energy", {
								"funnelid": "Game",
								"page": "WARNING"
							});
				}
				else if (res == 79)
				{
					WinMgr.OpenWindow("energy.Energy", {
								"funnelid": "Game",
								"page": "BUY"
							});
				}
				else if (res == 88)
				{
					WinMgr.OpenWindow("settings.AvatarWin");
				}
				else
				{
					UIBase.ShowMessage("ERROR", "CODE:" + res);
				}
			}
			else
			{
				StartWindowMov.friendlist_sent_to_gs = true;
			}
		}

		public function OnSettingsClick(e:*):*
		{
			WinMgr.OpenWindow("profile2.Profile2", {"page": 4});
		}

		public function OnPlusGoldClick(e:*):*
		{
			WinMgr.OpenWindow("bank.Bank");
		}

		public function OnPlusEnergyClick(e:*):*
		{
			WinMgr.OpenWindow("energy.Energy", {"page": "BUY"});
		}

		public function OnProfileClick(e:*):*
		{
			WinMgr.OpenWindow("profile2.Profile2");
		}

		public function OnVillageClick(e:*):*
		{
			backtothevillage = true;
			WinMgr.CloseWindow(this);
		}

		public function OnStartBotsClick(e:*):*
		{
			Comm.SendCommand("STARTROBOT", "");
		}

		public function OnCancelClick(e:*):*
		{
			Comm.SendCommand("EXITROOM", "");
		}

		public function OnMiniTimer(e:TimerEvent):void
		{
			var now:Number = NaN;
			var dif:int = 0;
			if (this.minireftime > 0 && this.miniremsec > 0 && this.miniremmov != null)
			{
				now = new Date().time;
				dif = Math.round((now - this.minireftime) / 1000);
				if (dif <= this.miniremsec)
				{
					this.miniremmov.text = Util.FormatRemaining(this.miniremsec - dif);
				}
				else
				{
					this.miniremmov.text = " ";
				}
			}
		}

		public function OnTournamentTimer(e:TimerEvent):void
		{
			var now:Number = NaN;
			var dif:int = 0;
			var s:* = undefined;
			var n:int = 0;
			var tmc:MovieClip = null;
			var b:MovieClip = null;
			if (this.tournamentreftime > 0 && this.tournamentremsec > 0 && this.tournamentremmov != null)
			{
				now = new Date().time;
				dif = Math.round((now - this.tournamentreftime) / 1000);
				s = this.tournamentremsec - dif;
				this.tournamentremmov.text = Util.FormatRemaining(s, false);
				n = 1;
				while (n <= 6)
				{
					b = this.STARTMENU["BTN" + n];
					if (b.ICON.currentLabel == "TOURNAMENT")
					{
						tmc = b;
					}
					n++;
				}
				if (s <= 5)
				{
					if (Boolean(tmc) && Boolean(tmc.BTN))
					{
						tmc.BTN.SetEnabled(false);
					}
				}
				else if (Boolean(tmc) && Boolean(tmc.BTN))
				{
					tmc.BTN.SetEnabled(true);
				}
				if (s <= 0)
				{
					this.tournamentremmov.text = " ";
					if (tmc)
					{
						tmc.visible = false;
					}
					Sys.tag_tournament = new Array();
				}
			}
		}

		public function ShowNotification():*
		{
			if (!this.friendly_icon)
			{
				return;
			}
			if (this.friendly_icon.NOTIFY.visible)
			{
				return;
			}
			this.friendly_icon.NOTIFY.visible = true;
			var tag:Object = Sys.tag_activeseproom;
			var ln:int = 1;
			var n:int = 1;
			while (n <= 3)
			{
				n++;
			}
			TweenMax.fromTo(this.friendly_icon, 0.5, {
						"scaleX": 1,
						"scaleY": 1
					}, {
						"scaleX": 1.1,
						"scaleY": 1.1,
						"repeat": -1,
						"yoyo": true
					});
		}

		public function HideNotification():*
		{
			if (!this.friendly_icon)
			{
				return;
			}
			this.friendly_icon.NOTIFY.visible = false;
			TweenMax.killTweensOf(this.friendly_icon);
		}

		public function UpdateRLResetTime(e:TimerEvent = null):void
		{
			var elapsed:int = 0;
			var remaining:int = 0;
			var days:* = undefined;
			var hours:* = undefined;
			var mins:String = null;
			var sec:String = null;
			if (this.rlresettimer == null)
			{
				this.rlresettimer = new Timer(1000, 0);
				Util.AddEventListener(this.rlresettimer, TimerEvent.TIMER, this.UpdateRLResetTime);
				this.rlresettimer.start();
			}
			if (this.rlresettimer.currentCount >= 0)
			{
				elapsed = Math.round((getTimer() - this.rlresettimeref) / 1000);
				remaining = this.rlresetremaining - elapsed;
				days = Math.floor(remaining / (24 * 60 * 60));
				remaining %= 24 * 60 * 60;
				hours = Math.floor(remaining / (60 * 60));
				remaining %= 60 * 60;
				mins = String(Math.floor(remaining / 60));
				if (mins.length == 1)
				{
					mins = "0" + mins;
				}
				remaining %= 60;
				sec = String(Math.floor(remaining));
				if (sec.length == 1)
				{
					sec = "0" + sec;
				}
				Util.SetText(this.LEGO_DAILY_RESET_ONE.DAILYTIME.FIELD, hours + ":" + mins + ":" + sec);
				Util.SetText(this.LEGO_DAILY_RESET_ONE.DAILYRESETDAY.FIELD, days);
			}
		}

		public function WeeklyTimerStart():void
		{
			var league:int = Util.NumberVal(Sys.mydata.league);
			if (league != 0)
			{
				this.LEGO_DAILY_RESET_ONE.CROWN.Set("CROWN" + league);
				this.LEGO_DAILY_RESET_ONE.visible = true;
				this.UpdateRLResetTime();
			}
			else
			{
				this.WeeklyTimerStop();
			}
		}

		public function WeeklyTimerStop():void
		{
			if (this.rlresettimer != null)
			{
				this.rlresettimer.stop();
			}
			this.LEGO_DAILY_RESET_ONE.visible = false;
		}

		public function WeeklyTimerDestroy():void
		{
			if (Boolean(this.rlresettimer) && this.rlresettimer.hasEventListener(TimerEvent.TIMER))
			{
				Util.RemoveEventListener(this.rlresettimer, TimerEvent.TIMER, this.UpdateRLResetTime);
				this.rlresettimer.stop();
				this.rlresettimer = null;
			}
		}
	}
}
