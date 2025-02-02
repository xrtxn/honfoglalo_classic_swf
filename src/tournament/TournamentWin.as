package tournament
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import syscode.*;
	import uibase.ScrollBarMov7;
	import uibase.gfx.lego_button_1x1_cancel;
	import uibase.gfx.lego_button_1x1_cancel_header;
	import uibase.gfx.lego_button_1x1_normal_header;
	import uibase.gfx.lego_button_1x1_ok;
	// check if good import
	import uibase.gfx.LegoCharacters;
	import uibase.gfx.HeaderTabs;

	[Embed(source="/modules/tournament_assets.swf", symbol="symbol636")]
	public class TournamentWin extends MovieClip
	{
		public static var mc:TournamentWin;

		public static var Waithall:Object = null;

		public static var PhaseDisplay:Object = null;

		public static var iamout:Boolean = false;

		public static var chatbuf:LegoChatMessageBuffer = new LegoChatMessageBuffer();

		public static const CHAT_PCH:String = "-4";

		private static var firstprocessed:Boolean = false;

		private static var chatshown:Boolean = false;

		public var BEFOREJOIN:MovieClip;

		public var BGS1:MovieClip;

		public var BGS10:MovieClip;

		public var BGS11:MovieClip;

		public var BGS2:MovieClip;

		public var BGS3:MovieClip;

		public var BGS4:MovieClip;

		public var BGS5:MovieClip;

		public var BGS6:MovieClip;

		public var BGS7:MovieClip;

		public var BGS8:MovieClip;

		public var BGS9:MovieClip;

		public var BOOSTERS:MovieClip;

		public var BTNCLOSE:lego_button_1x1_cancel_header;

		public var BTNHELP:lego_button_1x1_normal_header;

		public var BTNJOIN:lego_button_1x1_ok;

		public var BTNLEAVE:lego_button_1x1_cancel;

		public var BTN_CHAT_SEND:lego_button_1x1_normal_header;

		public var BUBBLE:MovieClip;

		public var CHAT_AVATAR:AvatarMov;

		public var CHESTS:MovieClip;

		public var DESC:MovieClip;

		public var GOLD:MovieClip;

		public var GOLDCHECK:MovieClip;

		public var ID1:MovieClip;

		public var ID2:MovieClip;

		public var ID3:MovieClip;

		public var INPUT_CHAT:MovieClip;

		public var JOINBG:MovieClip;

		public var JOINTXT:MovieClip;

		public var LEAVEBG:MovieClip;

		public var LEAVETXT:MovieClip;

		public var MASK:MovieClip;

		public var MAXPLAYERS:MovieClip;

		public var MESSAGES:MovieClip;

		public var MINPLAYERS:MovieClip;

		public var MINXPLEVEL:MovieClip;

		public var NPC:LegoCharacters;

		public var PENALTY:MovieClip;

		public var PIPE:MovieClip;

		public var PLAYERSBAR:MovieClip;

		public var PLAYERSCHECK:MovieClip;

		public var RANKINGS0:MovieClip;

		public var RANKINGS1:MovieClip;

		public var RANKINGS2:MovieClip;

		public var RANKINGS3:MovieClip;

		public var RUNNINGGAMES:MovieClip;

		public var S1:MovieClip;

		public var S2:MovieClip;

		public var S3:MovieClip;

		public var S4:MovieClip;

		public var S5:MovieClip;

		public var S6:MovieClip;

		public var SB_CHAT:ScrollBarMov7;

		public var TABS:HeaderTabs;

		public var TIME:MovieClip;

		public var TIMEWAIT:MovieClip;

		public var TITLE:MovieClip;

		public var TOURNAMENT_RULE_1:MovieClip;

		public var TOURNAMENT_RULE_2:MovieClip;

		public var TOURNAMENT_RULE_3:MovieClip;

		public var TOURNAMENT_RULE_4:MovieClip;

		public var XPCHECK:MovieClip;

		public var currenttype:int = 1;

		public var opening:Boolean = false;

		public var tournament_tag:Object = null;

		public var tournamenttimer:Timer;

		public var tournamentreftime:Number = 0;

		public var tournamentremsec:int = 0;

		public var tournamentremmov:TextField = null;

		public var active:Boolean = false;

		private var tend:Boolean = false;

		public function TournamentWin()
		{
			this.tournamenttimer = new Timer(1000, 0);
			super();
		}

		public static function Init(awaithall:Class, aphasedisplay:*):void
		{
			Waithall = awaithall;
			PhaseDisplay = aphasedisplay;
		}

		public static function ExternalSkin():*
		{
			Config.external_skin_path = Util.StringVal(mc.tournament_tag.SKIN_PATH);
			Config.external_skin["tournament"] = Util.StringVal(mc.tournament_tag.SKIN_IMAGES).split("|");
			Sys.ExternalSkin("tournament", mc.ID1, 1);
			Sys.ExternalSkin("tournament", mc.ID2, 2, false);
			Sys.ExternalSkin("tournament", mc.ID3, 3, false);
			Sys.ExternalSkin("tournament", mc.NPC, 4);
			Sys.LoadSkin("tournament");
		}

		public static function Show():void
		{
			if (mc)
			{
				mc.INPUT_CHAT.FIELD.text = "";
			}
		}

		public static function Hide():void
		{
			Imitation.RemoveGlobalListener("TAGSPROCESSED", TournamentWin.OnTagsProcessed);
			if (mc)
			{
				WinMgr.CloseWindow(mc);
			}
		}

		private static function OnTagsProcessed(e:*):void
		{
			trace("TournamentWin.OnTagsProcessed");
			if (TournamentWin.firstprocessed && mc && mc.currenttype == 2)
			{
				if (!TournamentWin.chatshown)
				{
					chatbuf.top = chatbuf.fullheight - mc.MASK.height + 20;
					TournamentWin.chatshown = true;
				}
				mc.MESSAGES.ITEMS.visible = true;
				mc.DrawChatMessages(false);
				mc.UpdateChatScrollBar();
				mc.UpdateChatPos();
			}
			TournamentWin.firstprocessed = true;
		}

		public static function DrawScreen():void
		{
			if (!mc)
			{
				if (iamout && WinMgr.WindowOpened("gameover.GameOver"))
				{
					return;
				}
				WinMgr.OpenWindow("tournament.TournamentWin");
			}
			else
			{
				mc.DoDrawScreen();
			}
		}

		public static function OnExitTournamentResult(res:int, xml:XML):void
		{
			if (res > 0)
			{
				if (res == 73)
				{
					UIBase.ShowMessage("ERROR", "CODE:" + res);
				}
				else if (res == 74)
				{
					UIBase.ShowMessage("ERROR", "CODE:" + res);
				}
				else if (res == 75)
				{
					UIBase.ShowMessage("ERROR", "CODE:" + res);
				}
				else if (res == 76)
				{
					UIBase.ShowMessage("ERROR", "CODE:" + res);
				}
				else if (res == 77)
				{
					UIBase.ShowMessage("ERROR", "CODE:" + res);
				}
				else
				{
					UIBase.ShowMessage("ERROR", "CODE:" + res);
				}
			}
			else
			{
				trace(res);
			}
		}

		public static function GetChatMessageDate(_tag:Object):String
		{
			if (!_tag)
			{
				return "";
			}
			var time:String = "";
			var d:Date = new Date();
			d.setTime(1000 * Util.NumberVal(_tag.TS));
			if (Config.siteid == "hu")
			{
				time = String(d.fullYear).substr(2, 4) + ". " + (d.month + 1) + ". " + d.date;
			}
			else if (Config.siteid == "us")
			{
				time = d.month + 1 + "/" + d.date + "/" + String(d.fullYear).substr(2, 4);
			}
			else
			{
				time = d.date + "/" + (d.month + 1) + "/" + String(d.fullYear).substr(2, 4);
			}
			return time;
		}

		public function AfterOpen():void
		{
			this.DrawTabs();
			this.opening = false;
		}

		public function AfterClose():void
		{
			if (this.tournamenttimer)
			{
				Util.RemoveEventListener(this.tournamenttimer, TimerEvent.TIMER, this.OnTournamentTimer);
				if (this.tournamenttimer.running)
				{
					this.tournamenttimer.stop();
				}
				this.tournamenttimer = null;
			}
		}

		public function Prepare(aprops:Object):void
		{
			chatbuf.num = 9;
			chatbuf.clanchat = false;
			Imitation.AddGlobalListener("TAGSPROCESSED", TournamentWin.OnTagsProcessed);
			this.tagproc_TOURNAMENT(Sys.tag_tournament[0]);
			this.BTNCLOSE.SetIcon("X");
			this.BTNCLOSE.AddEventClick(this.OnCloseClick);
			this.BTNHELP.SetIcon("HELP");
			this.BTNHELP.AddEventClick(this.OnHelpClick);
			this.BTNLEAVE.SetIcon("LEAVE");
			this.BTNLEAVE.AddEventClick(this.OnExitClick);
			this.LEAVETXT.FIELD.text = Lang.Get("i_give_up");
			this.TABS.visible = false;
			this.opening = true;
			gotoAndStop("CLEAR");
			aprops.waitfordata = true;
			TweenMax.delayedCall(1.5, WinMgr.WindowDataArrived, [mc]);
			if (this.tournament_tag.JOINED == "0")
			{
				this.TABS.Set(["tournament_state_1", "tournament_state_2"], ["PERGAMEN", "SANDGLASS"], this.SetActiveType, 1);
			}
			if (this.tournament_tag.OPEN == "1" && this.tournament_tag.JOINED == "1")
			{
				this.TABS.Set(["tournament_state_1", "tournament_state_2"], ["PERGAMEN", "SANDGLASS"], this.SetActiveType, 2);
			}
		}

		public function DoDrawScreen():void
		{
			if (this.opening)
			{
				return;
			}
		}

		public function OnCloseClick(e:*):*
		{
			if (this.tournament_tag.JOINED == "1")
			{
				Comm.SendCommand("CHANGEWAITHALL", "WH=\"GAME\"");
			}
			else
			{
				Hide();
			}
		}

		public function OnHelpClick(e:*):void
		{
			WinMgr.OpenWindow("help.Help", {
						"tab": 1,
						"subtab": 6
					});
		}

		public function DrawTabs():void
		{
			this.TABS.visible = true;
			if (this.tournament_tag.OPEN == "0")
			{
				this.TABS.UnlockTab(this.TABS["TTAB1"]);
				this.TABS.LockTab(this.TABS["TTAB2"]);
			}
			else if (this.tournament_tag.OPEN == "1" && this.tournament_tag.JOINED == "0")
			{
				this.TABS.UnlockTab(this.TABS["TTAB1"]);
				this.TABS.LockTab(this.TABS["TTAB2"]);
			}
			else if (this.tournament_tag.OPEN == "1" && this.tournament_tag.JOINED == "1")
			{
				this.TABS.UnlockTab(this.TABS["TTAB1"]);
				this.TABS.UnlockTab(this.TABS["TTAB2"]);
			}
			Imitation.FreeBitmapAll(this.TABS);
			Imitation.CollectChildrenAll(this.TABS);
			Imitation.UpdateAll(this.TABS);
		}

		public function SetActiveType(anum:*):void
		{
			var lasttype:Number = this.currenttype;
			this.currenttype = anum;
			if (this.currenttype == 1)
			{
				this.DrawPromo();
			}
			else if (this.currenttype == 2)
			{
				this.DrawWait();
				if (this.currenttype != lasttype)
				{
					this.DrawChat();
				}
			}
			else if (this.currenttype == 3)
			{
				this.DrawTournamentOver();
			}
			Imitation.CollectChildrenAll(this);
			Imitation.FreeBitmapAll(this);
		}

		public function DrawPromo():void
		{
			trace("- DrawPromo");
			this.active = false;
			if (currentLabel != "PROMO")
			{
				gotoAndStop("CLEAR");
				gotoAndStop("PROMO");
				ExternalSkin();
			}
			this.BTNJOIN.SetIcon("PIPE");
			this.BTNJOIN.AddEventClick(this.OnJoin);
			this.JOINTXT.FIELD.text = Lang.Get("join");
			if (this.tournament_tag.OPEN == "0")
			{
				this.LEAVEBG.visible = false;
				this.BTNLEAVE.visible = false;
				this.LEAVETXT.visible = false;
				this.JOINBG.visible = false;
				this.BTNJOIN.visible = false;
				this.JOINTXT.visible = false;
				this.BEFOREJOIN.visible = true;
				Util.SetText(this.BEFOREJOIN.FIELD, Lang.Get("tournament_before_join"));
			}
			if (this.tournament_tag.OPEN == "1" && this.tournament_tag.JOINED == "0")
			{
				this.LEAVEBG.visible = false;
				this.BTNLEAVE.visible = false;
				this.LEAVETXT.visible = false;
				this.JOINBG.visible = true;
				this.BTNJOIN.visible = true;
				this.JOINTXT.visible = true;
				this.BEFOREJOIN.visible = false;
			}
			if (this.tournament_tag.OPEN == "1" && this.tournament_tag.JOINED == "1")
			{
				this.JOINBG.visible = false;
				this.BTNJOIN.visible = false;
				this.JOINTXT.visible = false;
				this.LEAVEBG.visible = true;
				this.BTNLEAVE.visible = true;
				this.LEAVETXT.visible = true;
				this.BEFOREJOIN.visible = false;
			}
			DBG.Trace("x", Config.external_skin["tournament"]);
			if (!Config.external_skin["tournament"] || !Config.external_skin["tournament"][4] || Config.external_skin["tournament"][4] == "")
			{
				if (this.tournament_tag.CHARACTER)
				{
					this.NPC.Set(this.tournament_tag.CHARACTER, "DEFAULT");
				}
				else
				{
					this.NPC.Set("MESSENGER", "DEFAULT");
				}
			}
			this.GOLD.FIELD.text = this.tournament_tag.GOLD;
			Util.SetText(this.MINXPLEVEL.FIELD, Lang.Get("min_lvl") + ": " + this.tournament_tag.MINXPLEVEL);
			if (int(this.tournament_tag.BOOSTERS))
			{
				Util.SetText(this.BOOSTERS.FIELD, Lang.Get("tournament_booster_usage_1"));
			}
			else
			{
				Util.SetText(this.BOOSTERS.FIELD, Lang.Get("tournament_booster_usage_2"));
			}
			this.MAXPLAYERS.FIELD.text = this.tournament_tag.MAXPLAYERS;
			this.MINPLAYERS.FIELD.text = this.tournament_tag.MINPLAYERS;
			var p:Number = int(this.tournament_tag.PLAYERS) / int(this.tournament_tag.MAXPLAYERS);
			if (p < 0)
			{
				p = 0;
			}
			else if (p > 1)
			{
				p = 1;
			}
			this.PLAYERSBAR.FIELD.FIELD.text = this.tournament_tag.PLAYERS;
			this.PLAYERSBAR.STRIP.scaleX = p;
			this.tournamentreftime = new Date().time;
			this.tournamentremsec = Util.NumberVal(this.tournament_tag.REMAINING);
			this.tournamentremmov = this.TIME.FIELD;
			this.tournamentremmov.text = Util.FormatRemaining(this.tournamentremsec, false);
			Util.RemoveEventListener(this.tournamenttimer, TimerEvent.TIMER, this.OnTournamentTimer);
			Util.AddEventListener(this.tournamenttimer, TimerEvent.TIMER, this.OnTournamentTimer);
			this.tournamenttimer.start();
			Util.SetText(this.TITLE.FIELD, this.tournament_tag.TITLE);
			Util.SetText(this.DESC.FIELD, this.tournament_tag.DESCRIPTION);
			Util.SetText(this.TOURNAMENT_RULE_1.FIELD, Lang.Get("tournament_rule_1"));
			Util.SetText(this.TOURNAMENT_RULE_2.FIELD, Lang.Get("tournament_rule_2"));
			Util.SetText(this.TOURNAMENT_RULE_3.FIELD, Lang.Get("tournament_rule_3"));
			Util.SetText(this.TOURNAMENT_RULE_4.FIELD, Lang.Get("tournament_rule_4"));
			var readyForFight:Boolean = true;
			if (Sys.mydata.gold < Number(Sys.tag_tournament[0].GOLD))
			{
				readyForFight = false;
				this.GOLDCHECK.gotoAndStop(2);
			}
			else
			{
				this.GOLDCHECK.gotoAndStop(1);
			}
			if (Sys.mydata.xplevel < Number(Sys.tag_tournament[0].MINXPLEVEL))
			{
				readyForFight = false;
				this.XPCHECK.gotoAndStop(2);
			}
			else
			{
				this.XPCHECK.gotoAndStop(1);
			}
			if (Number(Sys.tag_tournament[0].PLAYERS) >= Number(Sys.tag_tournament[0].MAXPLAYERS))
			{
				readyForFight = false;
				this.PLAYERSCHECK.gotoAndStop(2);
			}
			else
			{
				this.PLAYERSCHECK.gotoAndStop(1);
			}
			if (readyForFight)
			{
				this.BTNJOIN.SetEnabled(true);
			}
			else
			{
				this.BTNJOIN.SetEnabled(false);
			}
		}

		public function DrawWait():void
		{
			if (currentLabel != "WAIT")
			{
				gotoAndStop("CLEAR");
				gotoAndStop("WAIT");
				Sys.ClearSkin("tournament");
				Imitation.CollectChildrenAll(this);
			}
			this.RUNNINGGAMES.FIELD.text = int(this.tournament_tag.RUNNINGGAMES) * 3;
			var rankingsa:Array = this.tournament_tag.RANKINGS.split(",");
			this.RANKINGS0.FIELD.text = rankingsa[0];
			this.RANKINGS1.FIELD.text = rankingsa[1];
			this.RANKINGS2.FIELD.text = rankingsa[2];
			this.RANKINGS3.FIELD.text = rankingsa[3];
			var placingsa:Array = this.tournament_tag.PLACINGS.split(",");
			for (var i:int = 1; i <= 6; i++)
			{
				placingsa[i - 1] = int(placingsa[i - 1]);
				if (placingsa[i - 1] == 0)
				{
					placingsa[i - 1] = 4;
				}
				this["S" + i].gotoAndStop(placingsa[i - 1]);
				if (placingsa[i - 1] == 4)
				{
					this["S" + i].TXT.FIELD.text = i;
				}
			}
			if (this.tournament_tag.LEVEL && Util.NumberVal(this.tournament_tag.LEVEL) != 0 && Util.NumberVal(this.tournament_tag.LEVEL) <= 7)
			{
				this.CHESTS.gotoAndStop("L" + Util.NumberVal(this.tournament_tag.LEVEL));
				this.PIPE.visible = true;
			}
			else
			{
				this.CHESTS.gotoAndStop(15);
				this.PIPE.visible = false;
			}
			if (this.tournament_tag.PENALTY)
			{
				this.PENALTY.gotoAndStop(this.tournament_tag.PENALTY);
				if (Util.NumberVal(this.tournament_tag.PENALTY) == 0)
				{
					this.PENALTY.gotoAndStop(4);
				}
			}
			else
			{
				this.PENALTY.gotoAndStop(4);
			}
			this.tournamentreftime = new Date().time;
			this.tournamentremsec = Util.NumberVal(this.tournament_tag.REMAINING);
			this.tournamentremmov = this.TIMEWAIT.FIELD;
			this.tournamentremmov.text = Util.FormatRemaining(this.tournamentremsec, false);
			Util.RemoveEventListener(this.tournamenttimer, TimerEvent.TIMER, this.OnTournamentTimer);
			Util.AddEventListener(this.tournamenttimer, TimerEvent.TIMER, this.OnTournamentTimer);
			if (this.tournamenttimer.running)
			{
				this.tournamenttimer.stop();
			}
			this.tournamenttimer.start();
			if (this.tournament_tag.PENALTY && this.tournament_tag.PENALTY >= 3 || this.tournament_tag.CLOSED && Util.NumberVal(this.tournament_tag.CLOSED) > 0 || this.tournament_tag.STEP && Util.NumberVal(this.tournament_tag.STEP) >= 6)
			{
				this.tournamenttimer.stop();
				Util.SetText(this.TIMEWAIT.FIELD, Lang.Get("tournament_end_txt"));
				this.LEAVETXT.FIELD.text = Lang.Get("exit");
				this.tend = true;
			}
			this.active = true;
			this.Activate();
		}

		public function DrawTournamentOver():void
		{
			if (currentLabel != "TOURNAMENT_OVER")
			{
				gotoAndStop("CLEAR");
				gotoAndStop("TOURNAMENT_OVER");
				Sys.ClearSkin("tournament");
				Imitation.CollectChildrenAll(this);
			}
			this.active = false;
		}

		public function tagproc_TOURNAMENT(tag:Object):void
		{
			this.tournament_tag = tag;
			Util.FormatTrace(tag);
			if (!this.opening)
			{
				this.SetActiveType(this.currenttype);
			}
		}

		public function OnTournamentTimer(e:TimerEvent):void
		{
			var now:Number = NaN;
			var dif:int = 0;
			var s:* = undefined;
			if (this.tournamentreftime > 0 && this.tournamentremsec > 0 && this.tournamentremmov != null)
			{
				now = new Date().time;
				dif = Math.round((now - this.tournamentreftime) / 1000);
				s = this.tournamentremsec - dif;
				this.tournamentremmov.text = Util.FormatRemaining(s, false);
				if (s < 1)
				{
					this.tournamenttimer.stop();
					this.tournamentremmov.text = " ";
					if (this.tournament_tag.JOINED == "0")
					{
						Hide();
					}
				}
			}
		}

		public function OnJoin(e:*):*
		{
			var s:String = "";
			Comm.SendCommand("ENTERTOURNAMENT", "ID=\"" + this.tournament_tag.ID + "\"" + s, this.OnEnterTournamentResult);
			Hide();
		}

		public function OnEnterTournamentResult(res:int, xml:XML):void
		{
			if (res > 0)
			{
				if (res == 73)
				{
					UIBase.ShowMessage("ERROR", "CODE:" + res);
				}
				else if (res == 74)
				{
					UIBase.ShowMessage("ERROR", "CODE:" + res);
				}
				else if (res == 75)
				{
					UIBase.ShowMessage("ERROR", "CODE:" + res);
				}
				else if (res == 76)
				{
					UIBase.ShowMessage("ERROR", "CODE:" + res);
				}
				else if (res == 77)
				{
					UIBase.ShowMessage("ERROR", "CODE:" + res);
				}
				else
				{
					UIBase.ShowMessage("ERROR", "CODE:" + res);
				}
			}
		}

		public function OnExitClick(e:*):*
		{
			var _params:Object = null;
			var msg:String = null;
			if (!this.tend)
			{
				_params = {};
				msg = Lang.Get("tournament_exit_msg");
				Modules.GetClass("uibase", "uibase.MessageWin").AskYesNo("", msg, Lang.Get("yes"), Lang.Get("no"), this.OnExitClick2, [_params]);
			}
			else
			{
				this.OnExitClick2(1, {});
			}
		}

		public function OnExitClick2(_result:int, _params:Object):*
		{
			if (_result == 1)
			{
				Sys.tag_tournament = new Array();
				Comm.SendCommand("EXITTOURNAMENT", "WH=\"GAME\"", OnExitTournamentResult);
				Hide();
			}
		}

		public function DrawChat():void
		{
			if (!this.active)
			{
				return;
			}
			var w:MovieClip = this.MESSAGES.ITEMS;
			Imitation.FreeBitmapAll(w);
			Imitation.FreeBitmapAll(this.MASK);
			this.MESSAGES.condenseWhite = true;
			this.MESSAGES.ITEMS.PROTOTYPE.visible = false;
			this.MASK.visible = false;
			this.SB_CHAT.visible = false;
			this.CHAT_AVATAR.internal_flipped = true;
			this.CHAT_AVATAR.ShowUID(Sys.mydata.id);
			this.INPUT_CHAT.FIELD.restrict = Config.GetChatRestrictChars();
			Util.RTLEditSetup(this.INPUT_CHAT.FIELD);
			this.DrawChatMessages(true);
			this.UpdateChatScrollBar();
			this.UpdateChatPos();
			TweenMax.delayedCall(1, this.HideChatCover);
		}

		public function DrawChatMessages(_refresh:Boolean = false):void
		{
			if (this.active && Boolean(TournamentWin.mc))
			{
				chatbuf.DrawMessages(this, _refresh);
			}
		}

		private function OnMessageSend(e:Object = null):void
		{
			var msg:String = Util.CleanupChatMessage(Util.GetRTLEditText(this.INPUT_CHAT.FIELD));
			if (msg.length >= 2)
			{
				Comm.SendCommand("CHATMSG", "MSG=\"" + msg + "\"" + " PCH=\"" + TournamentWin.CHAT_PCH + "\"");
				Util.SetRTLEditText(this.INPUT_CHAT.FIELD, "");
			}
		}

		private function OnInputKeyUp(e:TextEvent):void
		{
			if (e.text.charCodeAt() == 10 && this.active)
			{
				e.preventDefault();
				this.OnMessageSend();
			}
		}

		public function OnHandleMouseWheel(e:MouseEvent):void
		{
		}

		private function OnChatScrolling(_pos:Number):void
		{
			chatbuf.top = _pos;
			this.DrawChatMessages();
		}

		public function UpdateChatPos():void
		{
			var cb:LegoChatMessageBuffer = chatbuf;
			if (cb.top > chatbuf.fullheight - this.MASK.height - cb.default_line_height * 4)
			{
				cb.top = cb.fullheight - this.MASK.height + 20;
				this.SB_CHAT.Set(chatbuf.fullheight + 20, this.MASK.height, cb.top);
			}
		}

		private function Activate():void
		{
			if (!Sys.tag_tournament)
			{
				return;
			}
			var activechat:Boolean = true;
			this.BTN_CHAT_SEND.AddEventClick(this.OnMessageSend);
			this.BTN_CHAT_SEND.SetIcon("PLAY");
			this.BTN_CHAT_SEND.SetEnabled(activechat);
			this.SB_CHAT.dragging = true;
			if (activechat)
			{
				this.INPUT_CHAT.FIELD.type = TextFieldType.INPUT;
			}
			else
			{
				this.INPUT_CHAT.FIELD.type = TextFieldType.DYNAMIC;
				Util.SetText(this.INPUT_CHAT.FIELD, Lang.Get("chat_is_enabled_at_level"));
			}
			Imitation.AddStageEventListener(TextEvent.TEXT_INPUT, this.OnInputKeyUp);
			Imitation.AddStageEventListener(MouseEvent.MOUSE_WHEEL, this.OnHandleMouseWheel);
			Imitation.EnableInput(this, activechat);
		}

		private function InActivate():void
		{
			Imitation.EnableInput(this, false);
			Imitation.DeleteEventGroup(this);
		}

		private function HideChatCover():void
		{
		}

		public function UpdateChatScrollBar():void
		{
			if (!this.SB_CHAT.visible)
			{
				this.SB_CHAT.visible = chatbuf.fullheight > this.MASK.height;
				if (this.SB_CHAT.visible)
				{
					this.MASK.visible = true;
					this.SB_CHAT.Set(chatbuf.fullheight + 20, this.MASK.height, chatbuf.fullheight - this.MASK.height + 20);
					this.SB_CHAT.buttonstep = 22.1;
					this.SB_CHAT.OnScroll = this.OnChatScrolling;
					Imitation.CollectChildrenAll(TournamentWin.mc);
					Imitation.SetMaskedMov(this.MASK, this.MESSAGES, false);
					Imitation.AddEventMask(this.MASK, this.MESSAGES);
					this.SB_CHAT.SetScrollRect(this.MASK);
					this.SB_CHAT.isaligned = false;
				}
			}
			if (!this.SB_CHAT.dragging)
			{
				this.SB_CHAT.Set(chatbuf.fullheight + 20, this.MASK.height, this.SB_CHAT.firstpos);
			}
			Imitation.FreeBitmapAll(this.SB_CHAT);
			Imitation.UpdateAll(this.SB_CHAT);
		}

		public function tagproc_CHATMSG(_tag:Object):void
		{
			var cb:LegoChatMessageBuffer = null;
			var msg:Object = null;
			Util.FormatTrace(_tag);
			if (Boolean(mc) && Util.StringVal(_tag.PCH) == CHAT_PCH)
			{
				cb = chatbuf;
				if (this.active)
				{
					msg = cb.AddChatMessage(_tag, this.MESSAGES.ITEMS.PROTOTYPE);
					this.UpdateChatScrollBar();
					this.UpdateChatPos();
				}
			}
		}

		public function ObjectTrace(_obj:Object, sPrefix:String = ""):void
		{
			var i:* = undefined;
			if (sPrefix == "")
			{
				sPrefix = "-->";
			}
			else
			{
				sPrefix += " -->";
			}
			for (i in _obj)
			{
				trace(sPrefix, i + ":" + _obj[i], " ");
				if (typeof _obj[i] == "object")
				{
					this.ObjectTrace(_obj[i], sPrefix);
				}
			}
		}
	}
}
