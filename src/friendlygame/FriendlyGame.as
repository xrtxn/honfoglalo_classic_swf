package friendlygame
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import syscode.*;
	import uibase.ScrollBarMov7;
	import uibase.ScrollBarMov8;
	import uibase.ScrollBarMov9;
	import uibase.gfx.lego_button_1x1_cancel_header;
	import uibase.gfx.lego_button_3x1_ok;
	import uibase.gfx.lego_button_3x1_cancel;
	import uibase.gfx.lego_button_2x1_ok;
	import uibase.gfx.lego_button_3x1_normal;
	import uibase.gfx.lego_button_1x1_normal_header;
	import uibase.components.BaseCharacterComponent;
	import fl.controls.CheckBox;
	import uibase.gfx.HeaderTabs;
	import friendlygame.gfx.Friends1c;
	import friendlygame.gfx.friendlygamelist;

	[Embed(source="/modules/friendlygame_assets.swf", symbol="symbol453")]
	public class FriendlyGame extends MovieClip
	{
		private static var prevstates:Array;

		public static var mc:FriendlyGame = null;

		public static var msgs:String = "";

		private static var iswaiting:Boolean = false;

		private static var code_shared:Boolean = false;

		public static var village_notif:Object = null;

		public static var timer:MyTimer = new MyTimer();

		public static var rooms:Array = [];

		public static var current_room:int = -1;

		public static var room_code:String = "0000";

		public static var code_sent:Boolean = false;

		public static var lobby_share_msg:String = "";

		private static var cost:Number = 0;

		public var ADD1:MovieClip;

		public var ADD2:MovieClip;

		public var ADD3:MovieClip;

		public var BACK:MovieClip;

		public var BTNCLOSE:lego_button_1x1_cancel_header;

		public var BTNCREATE:lego_button_3x1_ok;

		public var BTNEXIT:lego_button_3x1_cancel;

		public var BTNJOIN:lego_button_2x1_ok;

		public var BTNNO:lego_button_3x1_cancel;

		public var BTNSTART:lego_button_3x1_ok;

		public var BTNSTARTBOT:lego_button_3x1_normal;

		public var BTNYES:lego_button_3x1_ok;

		public var BTN_CHAT_SEND:lego_button_1x1_normal_header;

		public var BTN_JOIN:lego_button_2x1_ok;

		public var BTN_SHARE_CLAN:lego_button_3x1_normal;

		public var BUBBLE:MovieClip;

		// todo might be different type
		public var CBALL:CheckBox;

		public var CHAR:BaseCharacterComponent;

		public var CHAT_AVATAR:AvatarMov;

		public var CODE:TextField;

		public var DOWN1:MovieClip;

		public var DOWN2:MovieClip;

		public var DOWN3:MovieClip;

		public var DOWN4:MovieClip;

		public var GAMETYPE1:MovieClip;

		public var GAMETYPE2:MovieClip;

		public var INFO:MovieClip;

		public var INPUT:TextField;

		public var ITEMS:Friends1c;

		public var MASK:MovieClip;

		public var MESSAGES:MovieClip;

		public var NUM1:MovieClip;

		public var NUM2:MovieClip;

		public var NUM3:MovieClip;

		public var NUM4:MovieClip;

		public var OPP1:MovieClip;

		public var OPP2:MovieClip;

		public var ROOMS:friendlygamelist;

		public var ROOMS_MASK:MovieClip;

		public var ROOMS_SB:ScrollBarMov9;

		public var SB:ScrollBarMov8;

		public var SCROLLBAR:ScrollBarMov7;

		public var SCROLLRECT:MovieClip;

		public var SEARCH:MovieClip;

		public var STAMP:MovieClip;

		public var SUBJECT1:MovieClip;

		public var SUBJECT10:MovieClip;

		public var SUBJECT2:MovieClip;

		public var SUBJECT3:MovieClip;

		public var SUBJECT4:MovieClip;

		public var SUBJECT5:MovieClip;

		public var SUBJECT6:MovieClip;

		public var SUBJECT7:MovieClip;

		public var SUBJECT8:MovieClip;

		public var SUBJECT9:MovieClip;

		public var TABS:HeaderTabs;

		public var TXTALL:MovieClip;

		public var TXT_LONG:MovieClip;

		public var TXT_NORMAL:MovieClip;

		public var TXT_NOROOM:MovieClip;

		public var UP1:MovieClip;

		public var UP2:MovieClip;

		public var UP3:MovieClip;

		public var UP4:MovieClip;

		public var WRONG_CODE:MovieClip;

		public var __setPropDict:Dictionary;

		private var friends:Array;

		private var notfriends:Array;

		public var opened:Boolean = false;

		public var openedlength:int = 0;

		public var listItems:Array;

		public var selected:Array;

		public var user_selected:Array;

		public var user_invited:Array;

		public var first_show:Boolean = true;

		public var subjects:String = "";

		public var user_gametype:int = 2;

		public var invitableFriendList:Array;

		public var onlineplayers:Object;

		private var user_code:Object;

		private var user_robot:Object;

		private var user_anybody:Object;

		private var room_selected:String = "-1";

		public var chatbuf:LegoChatMessageBuffer;

		public var properties:Object = null;

		public var sex:int = 1;

		private var params:Object;

		internal var my:Number = 0;

		internal var keypressing:int = 0;

		public function FriendlyGame()
		{
			this.__setPropDict = new Dictionary(true);
			this.listItems = [];
			this.selected = [];
			this.user_selected = [];
			this.user_invited = [];
			this.invitableFriendList = [];
			this.onlineplayers = {};
			this.chatbuf = new LegoChatMessageBuffer();
			super();
			addFrameScript(4, this.frame5);
		}

		public static function trace(...arguments):*
		{
			MyTrace.myTrace(arguments);
		}

		public static function DrawScreen():*
		{
		}

		public static function ClearRooms():*
		{
			while (rooms.length > 0)
			{
				rooms.pop();
			}
		}

		public static function AddRoom(tag:*):*
		{
			if (!mc)
			{
				return;
			}
			var p1:* = tag.P1.split(",");
			var p2:* = tag.P2.split(",");
			var p3:* = tag.P3.split(",");
			var f:Object = Friends.GetUser(tag.id);
			if (!f || f.flag < 3 && p1[0] != Sys.mydata.id && p2[0] != Sys.mydata.id && p3[0] != Sys.mydata.id)
			{
				rooms.push({"data": tag});
			}
		}

		public static function ShowNotification():*
		{
			var VillageMap:*;
			var StartWindowMov:*;
			var notifs:Object;
			var pname:* = undefined;
			var notifObj:Object = null;
			if (mc)
			{
				mc.TABS.Notify(mc.TABS.TTAB2, true);
			}
			VillageMap = Modules.GetClass("villagemap", "villagemap.VillageMap");
			StartWindowMov = Modules.GetClass("triviador", "triviador.StartWindowMov");
			notifs = Modules.GetClass("uibase", "uibase.Notifications");
			if (Boolean(notifs) && Boolean(notifs.mc))
			{
				pname = Util.StringVal(Sys.tag_activeseproom["PN1"]);
				notifObj = new Object();
				notifObj = {
						"name": "friendlygameinvite",
						"icon": "MESSENGER",
						"icontype": "character",
						"smallicon": "FRIENDLY_GAME",
						"smallicon_color": "0xFF0000",
						"smallicon_blink": true,
						"text": Lang.get ("friendlygame_notification", pname),
						"callback": function():*
						{
							WinMgr.OpenWindow("friendlygame.FriendlyGame");
						}
					};
				notifs.Add(notifObj);
			}
			if (StartWindowMov && Boolean(StartWindowMov.mc))
			{
				StartWindowMov.mc.ShowNotification();
			}
		}

		public static function HideNotification():*
		{
			if (mc)
			{
				mc.TABS.Notify(mc.TABS.TTAB2, false);
			}
			var VillageMap:* = Modules.GetClass("villagemap", "villagemap.VillageMap");
			var StartWindowMov:* = Modules.GetClass("triviador", "triviador.StartWindowMov");
			var notifs:Object = Modules.GetClass("uibase", "uibase.Notifications");
			if (Boolean(notifs) && Boolean(notifs.mc))
			{
				notifs.Remove({"name": "friendlygameinvite"});
			}
			if (StartWindowMov && Boolean(StartWindowMov.mc))
			{
				StartWindowMov.mc.HideNotification();
			}
		}

		public static function CheckSeproomWaiting(update:* = false):Boolean
		{
			var tag:Object = Sys.tag_activeseproom;
			if (tag && tag.UNCONFIRMED !== undefined && mc && mc.TABS.current == 3)
			{
				ShowNotification();
			}
			if (Boolean(mc) && mc.TABS.current > 1)
			{
				return false;
			}
			if (!tag || Sys.tag_shutdown != null)
			{
				if (mc && mc.currentFrame == 4 && Sys.screen == "VILLAGE")
				{
					mc.Hide();
					HideNotification();
					return false;
				}
				if (Sys.tag_shutdown != null && Boolean(tag))
				{
					Comm.SendCommand("EXITROOM", "");
				}
				if (Boolean(mc) && mc.currentFrame > 1)
				{
					msgs = "";
					mc.ShowCreate();
				}
				HideNotification();
				return false;
			}
			if (Boolean(tag) && tag.UNCONFIRMED !== undefined)
			{
				if (Boolean(mc) && mc.currentFrame == 1)
				{
					if (!update)
					{
						ShowWaiting();
					}
				}
				ShowNotification();
				return true;
			}
			if (mc && mc.currentFrame > 1 && (!Sys.codereg || !update))
			{
				ShowWaiting();
			}
			return true;
		}

		public static function ShowWaiting():*
		{
			var btn:* = undefined;
			var b:Boolean = false;
			var pname:* = null;
			var ws:* = undefined;
			var extid:String = null;
			var line:* = undefined;
			var ext:String = null;
			var url:* = null;
			if (!mc)
			{
				return;
			}
			var w:MovieClip = mc;
			var tag:Object = Sys.tag_activeseproom;
			mc.BTNCLOSE.visible = true;
			if (mc.BTN_SHARE_CLAN)
			{
				mc.BTN_SHARE_CLAN.visible = false;
			}
			if (mc.BTNEXIT)
			{
				mc.BTNEXIT.SetLang("exit");
			}
			if (!tag)
			{
				return;
			}
			mc.TABS.visible = false;
			var ncname:String = "";
			var wuname:String = "";
			var freeslots:Number = 0;
			var myroom:Boolean = false;
			var ownername:String = "";
			var sarr:Array = null;
			var qcats:String = Util.StringVal(tag.QCATS);
			if (qcats != "")
			{
				sarr = qcats.split(",");
			}
			for (var i:* = 1; i <= 10; i++)
			{
				btn = w["SUBJECT" + i];
				if (btn)
				{
					if (Sys.questioncats[i - 1])
					{
						b = sarr == null || sarr.indexOf(Util.StringVal(Sys.questioncats[i - 1].id)) > -1;
						btn.gotoAndStop(b ? 4 : 3);
						if (btn.ICON)
						{
							btn.ICON.gotoAndStop("THEME" + Sys.questioncats[i - 1].id);
						}
						btn.visible = true;
						Imitation.FreeBitmapAll(btn);
					}
					else
					{
						btn.gotoAndStop(3);
						btn.visible = false;
					}
					Imitation.RemoveEvents(btn);
					btn.id = i;
				}
			}
			if (Boolean(w.GAMETYPE1) && Boolean(w.GAMETYPE2))
			{
				w.GAMETYPE1.gotoAndStop(tag.RULES == "1" ? 3 : 4);
				w.GAMETYPE1.type = 2;
				w.DrawGameType(1);
				w.GAMETYPE2.gotoAndStop(tag.RULES == "1" ? 4 : 3);
				w.GAMETYPE2.type = 1;
				w.DrawGameType(2);
				Imitation.RemoveEvents(w.GAMETYPE1);
				Imitation.RemoveEvents(w.GAMETYPE2);
			}
			var pd:Array = Util.StringVal(tag["P1"]).split(",");
			var uid:* = Util.StringVal(pd[0]);
			var readynum:* = 0;
			if (uid == Sys.mydata.id)
			{
				myroom = true;
			}
			if (!myroom)
			{
				FriendlyGame.mc.selected = [];
			}
			var n2:int = 0;
			cost = 6;
			for (var n:int = 1; n <= 3; n++)
			{
				n2++;
				pd = Util.StringVal(tag["P" + n2]).split(",");
				pname = Romanization.ToLatin(Util.StringVal(tag["PN" + n2]));
				uid = Util.StringVal(pd[0]);
				ws = pd[1];
				extid = Util.StringVal(tag["EXTID" + n2]);
				if (myroom)
				{
					if (mc.selected[0] && mc.selected[0].id == uid && Boolean(mc.selected[0].invite_token))
					{
						cost -= 3;
					}
					if (mc.selected[1] && mc.selected[1].id == uid && Boolean(mc.selected[1].invite_token))
					{
						cost -= 3;
					}
				}
				if (n > 1)
				{
					line = w["OPP" + (n - 1)];
					line.gotoAndStop(3);
					line.CODE.visible = false;
					if (extid.indexOf("FBID.") == 0)
					{
						ext = extid.substr(5);
						url = "https://graph.facebook.com/" + ext + "/picture";
						line.AVATAR.ShowExternal(ext, url);
					}
					else
					{
						line.AVATAR.ShowUID(uid);
						if (uid == -2)
						{
							line.CODE.visible = true;
						}
					}
					line.BTNREMOVE.visible = false;
					if (pname == "" && uid == "0")
					{
						pname = "(" + Lang.get ("anybody") + ")";
					}
					else if (pname == "" && uid == "-1")
					{
						pname = "(" + Lang.get ("robot") + ")";
					}
					else if (pname == "" && uid == "-2")
					{
						if (Boolean(tag.CODE) && myroom)
						{
							pname = "(" + Lang.get ("code+:") + tag.CODE + ")";
						}
						else
						{
							pname = "(" + Lang.get ("code") + ")";
						}
					}
					Util.SetText(line.NAME.FIELD, pname);
					if (uid == 0 && ws == 0)
					{
						freeslots++;
					}
					line.READY.visible = uid == -1 || ws == 1;
					if (uid == -1 || ws == 1)
					{
						readynum++;
					}
					line.UNCONFIRMED.visible = ws == 4;
					if (ws == 4 && ncname == "")
					{
						ncname = pname;
					}
					line.WAITANIM.visible = (uid >= 0 || uid == -2) && ws != 1 && ws != 4;
					if (line.WAITANIM.visible)
					{
						line.WAITANIM.play();
					}
					else
					{
						line.WAITANIM.stop();
					}
					Lang.Set(line.INGAME.FIELD, "in_game");
					line.INGAME.visible = ws == 3;
					if (uid > 0 && Boolean(line.WAITANIM.visible))
					{
						wuname = pname;
					}
				}
				if (prevstates[n - 1] != 1 && uid > 0 && ws == 1)
				{
					if (n == 1)
					{
						mc.SysMsg(Lang.get ("sb_created_room", pname));
					}
					else
					{
						mc.SysMsg(Lang.get ("sb_joined", pname));
					}
				}
				prevstates[n - 1] = ws;
			}
			if (tag.STARTDELAY !== undefined && freeslots == 0 && tag["P2"] != "-2,0" && tag["P3"] != "-2,0")
			{
				if (myroom)
				{
					mc.gotoAndStop("STARTING");
					mc.BTNSTART.SetEnabled(true);
					mc.BTNSTARTBOT.SetEnabled(false);
					mc.BTNSTART.AddEventClick(OnStart);
					mc.BTNSTART.SetLang("startgame");
					mc.BTNSTARTBOT.SetLang("startgame_with_ai");
					Lang.Set(mc.INFO.FIELD, "friendly_game_ready");
					mc.STAMP.visible = true;
					mc.STAMP.gotoAndStop(cost == 0 ? 2 : 1);
					if (mc.STAMP.NUM)
					{
						Util.SetText(mc.STAMP.NUM, "-" + cost);
					}
				}
				else
				{
					mc.gotoAndStop("NORMAL");
					Lang.Set(mc.INFO.FIELD, "friendly_game_waiting_start", ownername);
				}
				mc.BTNEXIT.AddEventClick(OnFriendlyExit);
				mc.BTNEXIT.SetLang("exit");
			}
			else if (tag.UNCONFIRMED !== undefined)
			{
				mc.gotoAndStop("CONFIRM");
				Lang.Set(mc.INFO.FIELD, "friendly_confirm_question");
				mc.BTNYES.SetLang("yes");
				mc.BTNYES.AddEventClick(OnFriendlyConfirm);
				mc.BTNNO.SetLang("no");
				mc.BTNNO.AddEventClick(OnFriendlyNo);
				mc.BTNCLOSE.visible = false;
				if (mc.BTN_SHARE_CLAN)
				{
					mc.BTN_SHARE_CLAN.visible = false;
				}
			}
			else
			{
				if (myroom)
				{
					mc.gotoAndStop("STARTING");
					mc.BTNSTART.SetEnabled(false);
					mc.BTNSTARTBOT.SetEnabled(readynum == 1 && (mc.selected[0].id == 0 || mc.selected[1].id == 0));
					mc.BTNSTART.SetLang("startgame");
					mc.BTNSTARTBOT.AddEventClick(OnStart);
					mc.BTNSTARTBOT.SetLang("startgame_with_ai");
					mc.STAMP.visible = false;
				}
				else
				{
					mc.gotoAndStop("NORMAL");
				}
				mc.BTNEXIT.AddEventClick(OnFriendlyExit);
				mc.BTNEXIT.SetLang("exit");
				if (mc.BTN_SHARE_CLAN)
				{
					mc.BTN_SHARE_CLAN.visible = false;
				}
				if (tag.CODE && myroom && (tag["P2"] == "-2,0" || tag["P3"] == "-2,0"))
				{
					room_code = tag.CODE;
					Lang.Set(mc.INFO.FIELD, "friendly_game_code", tag.CODE);
					mc.BTN_SHARE_CLAN.SetLangAndClick("share_with_clan", OnShareClan);
					if (!code_shared && Sys.myclanproperties && Boolean(Sys.myclanproperties.id))
					{
						mc.BTN_SHARE_CLAN.visible = true;
					}
				}
				else if (ncname != "")
				{
					Lang.Set(mc.INFO.FIELD, "sb_not_confirmed_friendly", ncname);
				}
				else if (wuname != "")
				{
					Lang.Set(mc.INFO.FIELD, "friendly_game_waiting_sb", wuname);
				}
				else
				{
					Lang.Set(mc.INFO.FIELD, "friendly_game_waiting_any");
				}
			}
			mc.StartWaitingChat();
		}

		private static function OnShareClan(e:* = null):void
		{
			var msg:String = Lang.get ("share_clan_code", room_code);
			Comm.SendCommand("CHATMSG", "MSG=\"" + msg + "\"" + " PCH=\"-3\"");
			Comm.SendCommand("CHATMSG", "MSG=\"" + msg + "\"" + " PCH=\"-2\"");
			mc.BTN_SHARE_CLAN.visible = false;
			code_shared = true;
		}

		public static function OnFriendlyExit(e:*):*
		{
			if (mc.BTNSTART)
			{
				mc.BTNSTART.SetEnabled(false);
			}
			mc.BTNEXIT.SetEnabled(false);
			Comm.SendCommand("EXITROOM", "");
		}

		public static function OnFriendlyNo(e:*):*
		{
			mc.BTNYES.SetEnabled(false);
			mc.BTNNO.SetEnabled(false);
			Comm.SendCommand("EXITROOM", "");
			if (Sys.screen == "VILLAGEMAP")
			{
				mc.Hide();
			}
		}

		public static function OnStart(e:*):*
		{
			mc.BTNSTART.SetEnabled(false);
			mc.BTNSTARTBOT.SetEnabled(false);
			mc.BTNEXIT.SetEnabled(false);
			Comm.SendCommand("STARTSEPROOM", "");
		}

		public static function OnFriendlyConfirm(e:*):*
		{
			mc.BTNYES.SetEnabled(false);
			mc.BTNNO.SetEnabled(false);
			Comm.SendCommand("CHANGEWAITHALL", "WH=\"GAME\"", OnChangeWaithallResult);
		}

		public static function OnChangeWaithallResult(res:int, xml:XML):void
		{
			if (res > 0)
			{
				if (res == 88)
				{
					UIBase.ShowMessage("ERROR:" + res, "NAMELESS_USER");
				}
				else
				{
					UIBase.ShowMessage("ERROR", "CODE:" + res);
				}
				return;
			}
			Comm.SendCommand("CONFIRMSEPROOM", "");
		}

		public static function OnFriendlyNever(e:*):*
		{
			UIBase.AskYesNo("", Lang.Get("ask_friendlygame_never"), Lang.Get("yes"), Lang.Get("cancel"), function(answer:*):*
				{
					if (answer != 1)
					{
						return;
					}
					Sys.mydata.flags |= Config.UF_NOFRIENDLY;
					Comm.SendCommand("SETDATA", "FLAGS=\"" + Sys.mydata.flags + "\" SNDVOL=\"" + Sys.mydata.sndvol + "\"");
					Comm.SendCommand("EXITROOM", "");
				});
		}

		public static function tagproc_CHATMSG(tag:Object):void
		{
			if (!mc || mc.currentFrame == 1 || mc.TABS.current > 1)
			{
				return;
			}
			var cb:LegoChatMessageBuffer = mc.chatbuf;
			if (tag.PCH != -2)
			{
				return;
			}
			if (tag.UID == -1)
			{
				return;
			}
			var fullheight:Number = cb.fullheight;
			tag.TS = null;
			var msg:Object = cb.AddChatMessage(tag, mc.MESSAGES.ITEMS.PROTOTYPE);
			if (cb.top > fullheight - mc.MASK.height - cb.default_line_height * 2)
			{
				cb.top = cb.fullheight - mc.MASK.height;
			}
		}

		public static function OnTagsProcessed(e:*):*
		{
			if (!mc || mc.currentFrame == 1)
			{
				return;
			}
			if (code_sent)
			{
				code_sent = false;
				mc.TABS.SetActiveTab(mc.TABS.TTAB1);
				mc.gotoAndStop("NORMAL");
				Util.StopAllChildrenMov(mc);
				Imitation.FreeBitmapAll(mc);
				ShowWaiting();
				mc.StartWaitingChat();
			}
			if (mc.TABS.current > 1)
			{
				return;
			}
			mc.DrawChatMessages();
			mc.UpdateScrollBar();
		}

		public static function OnGameTagsProcessed(e:*):*
		{
			var i:Number = NaN;
			var btn:* = undefined;
			if (Boolean(mc) && mc.TABS.current == 2)
			{
				mc.ROOMS.Draw();
				mc.CHAR.visible = rooms.length == 0;
				mc.TXT_NOROOM.visible = mc.CHAR.visible;
				for (i = 0; i < rooms.length; i++)
				{
					if (Boolean(rooms[i]) && Boolean(rooms[i].data) && rooms[i].data.ID == mc.room_selected)
					{
						return;
					}
				}
				mc.room_selected = "-1";
				for (i = 1; i <= 10; i++)
				{
					btn = mc["SUBJECT" + i];
					if (Sys.questioncats[i - 1])
					{
						btn.gotoAndStop(3);
					}
				}
				mc.BTN_JOIN.visible = false;
			}
		}

		public function Prepare(aparams:Object):void
		{
			var f:* = undefined;
			trace("Friendlygame.prepare");
			this.params = aparams;
			Util.StopAllChildrenMov(mc);
			mc.BTNCLOSE.AddEventClick(this.OnCloseClick);
			mc.BTNCLOSE.SetIcon("X");
			this.user_code = {
					"name": Lang.get ("code"),
					"id": -2
				};
			this.user_robot = {
					"name": Lang.get ("robot"),
					"id": -1
				};
			this.user_anybody = {
					"name": Lang.get ("anybody"),
					"id": 0
				};
			aparams.waitfordata = true;
			this.friends = [];
			for (var i:int = 0; i < Friends.all.length; i++)
			{
				f = Friends.all[i];
				if (f.flag == 1)
				{
					this.friends.push(f);
				}
			}
			msgs = "";
			this.chatbuf.num = 9;
			mc.TABS.Set(["create", "list", "code"], ["PLUS", "LIST", "KEY"], this.ShowPage);
			if (aparams.page)
			{
				if (aparams.page == 2)
				{
					mc.TABS.SetActiveTab(mc.TABS.TTAB2);
				}
				if (aparams.page == 3)
				{
					mc.TABS.SetActiveTab(mc.TABS.TTAB3);
				}
			}
			aparams.CanClose = mc.CanClose;
		}

		public function CanClose(e:* = null):Boolean
		{
			if (!mc)
			{
				return true;
			}
			return mc.BTNCLOSE.visible;
		}

		public function ShowPage(pagenum:*):*
		{
			var i:int = 0;
			trace("FriendlyGame.ShowPage", pagenum);
			this.HideMobileCode();
			if (mc.currentFrame > 1 && pagenum == 2 && Sys.tag_activeseproom && Sys.tag_activeseproom.UNCONFIRMED !== "1")
			{
				Comm.SendCommand("EXITROOM", "");
				HideNotification();
			}
			if (Sys.codereg || Sys.codeclan)
			{
				Sys.codeclan = false;
				prevstates = [0, 0, 0];
				mc.gotoAndStop("NORMAL");
				ShowWaiting();
				this.StartWaitingChat();
				for (i = 1; i <= 10; i++)
				{
					if (this["SUBJECT" + i])
					{
						this["SUBJECT" + i].visible = false;
					}
				}
				mc.INFO.FIELD.text = "";
				Util.StopAllChildrenMov(mc);
				Imitation.FreeBitmapAll(mc);
				this.Loaded();
			}
			else if (pagenum == 1)
			{
				this.ShowCreate();
			}
			else if (pagenum == 2)
			{
				this.ShowRooms();
			}
			else if (pagenum >= 3)
			{
				this.ShowCode();
			}
			if (Sys.codegamecode != "")
			{
				this.ShowCode();
			}
		}

		private function ShowCode():void
		{
			var n:int;
			var num:MovieClip = null;
			var up:MovieClip = null;
			var down:MovieClip = null;
			trace("friendlygame.ShowCode");
			gotoAndStop("CODE");
			mc.TABS.current = 3;
			this.WRONG_CODE.visible = false;
			this.CODE.visible = false;
			Lang.Set(this.INFO.FIELD, "friendlygame_code_info");
			Lang.Set(this.WRONG_CODE.FIELD, "friendlygame_code_wrong");
			if (mc.params.error == "CODE")
			{
				this.WRONG_CODE.visible = true;
				mc.params.error = null;
			}
			Imitation.CollectChildrenAll(mc);
			for (n = 1; n <= 4; n++)
			{
				num = mc["NUM" + n];
				up = mc["UP" + n];
				down = mc["DOWN" + n];
				Imitation.SetMaskedMov(num.MASK, num.NUMBERS);
				num.s = 0;
				num.v = 0;
				num.NUM.visible = true;
				num.NUM.alpha = 0;
				num.NUM.text = "0";
				up.gotoAndStop(1);
				down.gotoAndStop(1);
				Imitation.AddEventClick(num, function():*
					{
					});
				Imitation.AddEventMouseDown(num, this.NumMouseDown);
				Imitation.AddStageEventListener(MouseEvent.MOUSE_UP, this.NumMouseUp);
				Imitation.AddEventMouseDown(up, this.UDMouseDown);
				Imitation.AddEventMouseDown(down, this.UDMouseDown);
				this.DrawNumber(num);
			}
			mc.BTNJOIN.SetLangAndClick("join", this.SendCode);
			Util.AddEventListener(mc, Event.ENTER_FRAME, this.OnNumbersFrame);
			this.Loaded();
			if (Sys.codegamecode != "")
			{
				trace("frindlygame.showcode: " + Sys.codegamecode);
				mc.CODE.text = String(Sys.codegamecode);
				this.SendCode();
			}
		}

		private function HideMobileCode():void
		{
			if (Boolean(mc) || !mc.NUM1)
			{
				return;
			}
			for (var n:int = 1; n <= 4; n++)
			{
				Imitation.RemoveEvents(mc["NUM" + n]);
				Imitation.RemoveEvents(mc["UP" + n]);
				Imitation.RemoveEvents(mc["DOWN" + n]);
			}
			Imitation.RemoveStageEventListener(MouseEvent.MOUSE_UP, this.NumMouseUp);
			Util.RemoveEventListener(mc, Event.ENTER_FRAME, this.OnNumbersFrame);
		}

		private function NumMouseDown(e:*):void
		{
			e.target.down = true;
			this.my = Imitation.stage.mouseY;
			e.target.NUM.visible = false;
		}

		private function NumMouseUp(e:*):void
		{
			if (!mc || !mc.NUM1)
			{
				return;
			}
			for (var n:int = 1; n <= 4; n++)
			{
				mc["NUM" + n].down = false;
				mc["UP" + n].down = false;
				mc["DOWN" + n].down = false;
			}
		}

		private function UDMouseDown(e:*):void
		{
			e.target.down = true;
			this.keypressing = 0;
		}

		private function OnNumbersFrame(e:Event):void
		{
			var num:MovieClip = null;
			var up:MovieClip = null;
			var down:MovieClip = null;
			if (!mc || !mc.NUM1)
			{
				return;
			}
			var code:* = "";
			for (var n:int = 1; n <= 4; n++)
			{
				num = mc["NUM" + n];
				up = mc["UP" + n];
				down = mc["DOWN" + n];
				--this.keypressing;
				if (up.down)
				{
					if (this.keypressing < 0)
					{
						num.v = 0.15;
						this.DrawNumber(num);
						this.keypressing = 100;
					}
				}
				else if (down.down)
				{
					if (this.keypressing < 0)
					{
						num.v = -0.15;
						this.DrawNumber(num);
						this.keypressing = 100;
					}
				}
				if (num.down)
				{
					num.v = (Imitation.stage.mouseY - this.my) / 50;
					num.s += num.v;
					this.my = Imitation.stage.mouseY;
					this.DrawNumber(num);
				}
				else
				{
					num.s += num.v;
					num.v *= 0.96;
					if (Math.abs(num.v) <= 0.1)
					{
						num.v = 0;
						num.s = (num.s * 2 + Math.round(num.s)) / 3;
						if (Math.abs(num.s - Math.round(num.s)) < 0.01)
						{
							num.s = Math.round(num.s);
							if (!num.NUM.visible)
							{
								num.NUM.text = -num.s - Math.floor(-num.s / 10) * 10;
								num.NUM.visible = true;
								TweenMax.fromTo(num.NUM, 0.5, {"alpha": 0}, {"alpha": 1});
								TweenMax.fromTo(num.NUM, 0.5, {"alpha": 1}, {
											"alpha": 0.5,
											"delay": 0.5
										});
							}
						}
						else
						{
							num.NUM.visible = false;
						}
					}
					else
					{
						num.NUM.visible = false;
					}
					this.DrawNumber(num);
				}
				code += "" + num.NUM.text;
			}
			mc.CODE.text = code;
		}

		public function DrawNumber(num:MovieClip):*
		{
			var a:Number = NaN;
			var m:MovieClip = null;
			var p:Number = NaN;
			var p2:Number = NaN;
			var s:* = num.s + 4.5;
			for (var i:Number = 0; i < 10; i++)
			{
				a = i + s - Math.floor((i + s) / 10) * 10;
				m = num.NUMBERS["N" + i];
				p = Math.sin(-Math.cos(a / 10 * Math.PI) * Math.PI / 2 * 1.2);
				p2 = Math.sin(-Math.cos((a + 1) / 10 * Math.PI) * Math.PI / 2 * 1.2);
				m.y = 118 + 123 * p;
				m.height = 123 * (p2 - p) + 1;
			}
		}

		private function SendCode(e:* = null):void
		{
			if (Sys.codegamecode != "")
			{
				mc.CODE.text = String(Sys.codegamecode);
			}
			trace("frindlygame.SendCode: " + mc.CODE.text);
			Comm.SendCommand("ENTERSEPROOM", "CODE=\"" + mc.CODE.text + "\"", function(res:int, xml:XML):*
				{
					if (res > 0)
					{
						WRONG_CODE.visible = true;
						mc.BTNJOIN.SetEnabled(true);
					}
					else
					{
						HideMobileCode();
						code_sent = true;
					}
				});
			Sys.codegamecode = "";
		}

		private function ShowRooms():*
		{
			var btn:* = undefined;
			gotoAndStop("ROOMS");
			this.ROOMS.Set("ROOM", rooms, 40, 1, this.ClickRoom, this.DrawRoom, this.ROOMS_MASK, this.ROOMS_SB);
			for (var i:int = 1; i <= 10; i++)
			{
				btn = this["SUBJECT" + i];
				if (Sys.questioncats[i - 1])
				{
					btn.gotoAndStop(3);
					btn.visible = true;
					Imitation.RemoveEvents(btn);
				}
				else
				{
					btn.gotoAndStop(1);
					btn.ICON.stop();
					btn.visible = false;
				}
			}
			this.BTN_JOIN.visible = false;
			this.CHAR.visible = rooms.length == 0;
			this.TXT_NOROOM.visible = this.CHAR.visible;
			Lang.Set(this.TXT_NOROOM.FIELD, "friendlygame_no_room");
		}

		private function ClickRoom(lm:MovieClip, idx:int):void
		{
			var btn:* = undefined;
			var b:Boolean = false;
			var tag:Object = rooms[idx].data;
			var sarr:Array = null;
			if (tag.subjects != "")
			{
				sarr = !!tag.QCATS ? tag.QCATS.split(",") : null;
			}
			for (var i:int = 1; i <= 10; i++)
			{
				btn = this["SUBJECT" + i];
				if (Sys.questioncats[i - 1])
				{
					b = sarr == null || sarr.indexOf(Util.StringVal(Sys.questioncats[i - 1].id)) > -1;
					btn.gotoAndStop(b ? 4 : 3);
					if (btn.ICON)
					{
						btn.ICON.gotoAndStop("THEME" + Sys.questioncats[i - 1].id);
					}
					btn.visible = true;
					Imitation.FreeBitmapAll(btn);
				}
				else
				{
					btn.gotoAndStop(1);
					btn.ICON.stop();
					btn.visible = false;
				}
			}
			this.room_selected = tag.ID;
			this.ROOMS.Draw();
			this.BTN_JOIN.visible = true;
			if (Util.StringVal(tag.P2).split(",")[0] == Sys.mydata.id || Util.StringVal(tag.P3).split(",")[0] == Sys.mydata.id)
			{
				this.BTN_JOIN.SetLangAndClick("accept", this.OnAcceptRoom, {"id": tag.ID});
			}
			else
			{
				this.BTN_JOIN.SetLangAndClick("join", this.OnJoinRoom, {"id": tag.ID});
			}
		}

		private function OnJoinRoom(e:*):void
		{
			trace("ENTERSEPROOM: OnJoinRoom");
			ClearRooms();
			Comm.SendCommand("ENTERSEPROOM", "ROOM=\"" + e.params.id + "\"", function():*
				{
					mc.TABS.SetActiveTab(mc.TABS.TTAB1);
					mc.gotoAndStop("NORMAL");
					Util.StopAllChildrenMov(mc);
					Imitation.FreeBitmapAll(mc);
					ShowWaiting();
				});
		}

		private function OnAcceptRoom(e:*):void
		{
			ClearRooms();
			mc.TABS.SetActiveTab(mc.TABS.TTAB1);
			Comm.SendCommand("CHANGEWAITHALL", "WH=\"GAME\"", OnChangeWaithallResult);
		}

		public function DrawRoom(lm:MovieClip, idx:int):*
		{
			var tag:Object = null;
			var hasfreeplace:* = undefined;
			var pn:* = undefined;
			var pmov:* = undefined;
			var pname:* = undefined;
			var pd:* = undefined;
			var uid:* = undefined;
			var ws:* = undefined;
			Util.StopAllChildrenMov(lm);
			if (rooms[idx] !== undefined && Boolean(rooms[idx].data))
			{
				tag = rooms[idx].data;
				hasfreeplace = false;
				if (Util.StringVal(tag.P2).split(",")[0] == Sys.mydata.id || Util.StringVal(tag.P3).split(",")[0] == Sys.mydata.id)
				{
					lm.gotoAndStop(3);
				}
				lm.SELECTED.alpha = tag.ID == this.room_selected ? 1 : 0;
				for (pn = 1; pn <= 3; pn++)
				{
					pmov = lm["PLAYER" + pn];
					pname = Util.StringVal(tag["PN" + pn]);
					pd = Util.StringVal(tag["P" + pn]).split(",");
					uid = pd[0];
					ws = pd[1];
					if (ws == 0 && uid == 0)
					{
						pmov.AVATAR.ShowUID(0);
						Lang.Set(pmov.NAME.FIELD, "free_join");
						pmov.CODE.visible = false;
					}
					else
					{
						pmov.AVATAR.ShowUID(uid);
						if (uid == -2)
						{
							Util.SetText(pmov.NAME.FIELD, "(" + Lang.get ("code") + ")");
							pmov.CODE.visible = true;
						}
						else if (uid < 0)
						{
							Util.SetText(pmov.NAME.FIELD, "(" + Lang.get ("robot") + ")");
							pmov.CODE.visible = false;
						}
						else
						{
							Util.SetText(pmov.NAME.FIELD, pname);
							pmov.CODE.visible = false;
						}
					}
				}
				lm.ICON.gotoAndStop("TRIVIADOR" + (tag.RULES == "1" ? 2 : 1));
				lm.visible = true;
			}
			else
			{
				lm.visible = false;
			}
		}

		public function ShowCreate():*
		{
			var i:* = undefined;
			var btn:* = undefined;
			var b:Boolean = false;
			gotoAndStop(1);
			mc.BTNCLOSE.visible = true;
			mc.TABS.visible = true;
			iswaiting = false;
			this.selected = this.user_selected.slice();
			prevstates = [0, 0, 0];
			this.ITEMS.Set("ITEM", this.listItems, 40, 1, this.ClickItem, this.DrawItem, this.SCROLLRECT, this.SB);
			this.SEARCH.EDSEARCH.FIELD.text = "";
			this.SEARCH.alpha = 0;
			this.opened = false;
			this.SEARCH.EDSEARCH.visible = false;
			Util.AddEventListener(this.SEARCH.EDSEARCH.FIELD, Event.CHANGE, this.FilterItems);
			Util.RTLEditSetup(this.SEARCH.EDSEARCH.FIELD);
			this.FilterItems();
			this.BTNCREATE.AddEventClick(this.OnCreateClick);
			Imitation.AddEventClick(this.OPP1.BTNREMOVE, this.OnRemoveClick);
			Imitation.AddEventClick(this.OPP2.BTNREMOVE, this.OnRemoveClick);
			this.ShowSelected();
			var sarr:Array = null;
			if (this.subjects != "")
			{
				sarr = this.subjects.split(",");
			}
			for (i = 1; i <= 10; i++)
			{
				btn = this["SUBJECT" + i];
				if (Sys.questioncats[i - 1])
				{
					b = sarr == null || sarr.indexOf(Util.StringVal(Sys.questioncats[i - 1].id)) > -1;
					btn.gotoAndStop(b ? 2 : 1);
					btn.ICON.gotoAndStop("THEME" + Sys.questioncats[i - 1].id);
					btn.visible = true;
					Imitation.FreeBitmapAll(btn);
				}
				else
				{
					btn.gotoAndStop(1);
					btn.ICON.stop();
					btn.visible = false;
				}
				btn.id = i;
				Imitation.AddEventClick(btn, this.OnSubjectClick);
			}
			Imitation.AddEventClick(this.CBALL, this.OnSelectAll);
			Lang.SetLang(this.TXTALL.FIELD, "select_all");
			this.GAMETYPE1.gotoAndStop(this.user_gametype == 2 ? 2 : 1);
			this.GAMETYPE1.type = 2;
			this.DrawGameType(1);
			Imitation.AddEventClick(this.GAMETYPE1, this.OnGameTypeClick);
			Lang.Set(this.TXT_NORMAL.FIELD, "game_rule_2");
			this.GAMETYPE2.gotoAndStop(this.user_gametype == 1 ? 2 : 1);
			this.GAMETYPE2.type = 1;
			this.DrawGameType(2);
			Imitation.AddEventClick(this.GAMETYPE2, this.OnGameTypeClick);
			Lang.Set(this.TXT_LONG.FIELD, "game_rule_1");
			this.DrawAddButtons();
			if (CheckSeproomWaiting(false))
			{
				this.Loaded();
			}
			else
			{
				if (this.first_show)
				{
					this.invitableFriendList = [];
					this.OpenGraphInvitableFriends(this.Loaded);
				}
				this.BTNCREATE.SetLang("create_game");
				if (Boolean(this.selected[0]) && Boolean(this.selected[1]))
				{
					this.BTNCREATE.SetEnabled(true);
				}
				else
				{
					this.BTNCREATE.SetEnabled(false);
				}
			}
		}

		private function OnSelectAll(e:*):void
		{
			var lm:* = undefined;
			var btn:MovieClip = null;
			var all:Boolean = true;
			for (var n:int = 1; n <= 10; n++)
			{
				lm = this["SUBJECT" + n];
				if (lm.currentFrame == 1 && Boolean(Sys.questioncats[n - 1]))
				{
					all = false;
					break;
				}
			}
			for (var i:int = 1; i <= 10; i++)
			{
				btn = this["SUBJECT" + i];
				if (Sys.questioncats[i - 1])
				{
					btn.gotoAndStop(all ? 1 : 2);
					btn.ICON.gotoAndStop("THEME" + Sys.questioncats[i - 1].id);
					btn.visible = true;
					Imitation.FreeBitmapAll(btn);
				}
				else
				{
					btn.gotoAndStop(1);
					btn.ICON.stop();
					btn.visible = false;
				}
			}
			this.SetSubjects();
		}

		private function DrawAddButtons():void
		{
			var b:* = this.selected[0] && this.selected[1];
			Lang.Set(this.ADD1.TITLE.FIELD, "code");
			this.ADD1.AVATAR.visible = false;
			Imitation.AddEventClick(this.ADD1.BTN, this.OnAdd);
			this.ADD1.BTN.SetIcon("PLUS");
			this.ADD1.STAMP.gotoAndStop(2);
			this.ADD1.DISABLED.visible = b;
			Lang.Set(this.ADD2.TITLE.FIELD, "robot");
			this.ADD2.CODE.visible = false;
			this.ADD2.AVATAR.ShowUID(-1);
			Imitation.AddEventClick(this.ADD2.BTN, this.OnAdd);
			this.ADD2.BTN.SetIcon("PLUS");
			this.ADD2.STAMP.gotoAndStop(1);
			this.ADD2.DISABLED.visible = b;
			Lang.Set(this.ADD3.TITLE.FIELD, "anybody");
			this.ADD3.CODE.visible = false;
			this.ADD3.AVATAR.Clear();
			Imitation.AddEventClick(this.ADD3.BTN, this.OnAdd);
			this.ADD3.BTN.SetIcon("PLUS");
			this.ADD3.STAMP.gotoAndStop(1);
			this.ADD3.DISABLED.visible = b;
		}

		private function OnAdd(e:* = null):void
		{
			var adds:* = [null, this.user_code, this.user_robot, this.user_anybody];
			var id:Number = Util.IdFromStringEnd(e.target.parent.name);
			this.SelectUser(adds[id]);
		}

		private function OnRefreshClick(e:*):void
		{
			this.GetExtData();
		}

		public function OnExtdataResult(res:int, xml:XML):*
		{
			var ru:Object = null;
			this.onlineplayers = {};
			var data:Object = null;
			var ri:int = 0;
			if (res == 0)
			{
				data = Util.XMLTagToObject(xml);
				var whusers:* = data.EXTDATA.USER;
				if (!whusers)
				{
					this.FilterItems();
					return;
				}
				if (!(whusers is Array))
				{
					whusers = [whusers];
				}
				for (ri = 0; ri < whusers.length; ri++)
				{
					ru = whusers[ri];
					Extdata.SetUserData(ru.ID, ru.NAME, !!Util.NumberVal(ru.USECUSTOM) ? ru.CUSTOM : ru.IMGURL);
					if (Util.NumberVal(ru.ONLINE) == 1)
					{
						this.onlineplayers[ru.ID] = true;
					}
				}
				this.FilterItems();
				return;
			}
		}

		internal function OnSubjectClick(e:*):*
		{
			var btn:* = e.target;
			btn.gotoAndStop(btn.currentFrame > 1 ? 1 : 2);
			btn.ICON.gotoAndStop("THEME" + btn.id);
			Imitation.FreeBitmapAll(btn);
			this.SetSubjects();
		}

		internal function OnGameTypeClick(e:*):*
		{
			var i:* = undefined;
			var btn:* = undefined;
			this.user_gametype = e.target == this.GAMETYPE1 ? 2 : 1;
			for (i = 1; i <= 2; i++)
			{
				btn = this["GAMETYPE" + i];
				btn.gotoAndStop(this["GAMETYPE" + i] == e.target ? 2 : 1);
				this.DrawGameType(i);
				Imitation.FreeBitmapAll(btn);
			}
		}

		internal function DrawGameType(id:*):*
		{
			var btn:* = this["GAMETYPE" + id];
			if (btn.ICON)
			{
				btn.ICON.gotoAndStop("TRIVIADOR" + id);
			}
		}

		private function ClickItem(item:MovieClip, idx:int):void
		{
			this.SelectUser(this.listItems[idx]);
		}

		internal function SelectUser(u:Object):*
		{
			if (u.id != 0 && u.id != -1 && u.id != -2)
			{
				if (this.user_selected.length > 0 && this.user_selected[0] && this.user_selected[0] == u)
				{
					return;
				}
				if (this.user_selected.length > 1 && this.user_selected[1] && this.user_selected[1] == u)
				{
					return;
				}
			}
			if (this.user_selected[0] == null)
			{
				this.user_selected[0] = u;
			}
			else
			{
				if (this.user_selected[1] != null)
				{
					return;
				}
				this.user_selected[1] = u;
			}
			this.selected = this.user_selected.slice();
			this.ITEMS.Draw();
			this.DrawAddButtons();
			this.ShowSelected();
		}

		public function ShowSelected():*
		{
			cost = 0;
			if (this.selected[0])
			{
				this.OPP1.gotoAndStop(2);
				this.OPP1.CODE.visible = false;
				Util.SetText(this.OPP1.NAME.FIELD, this.selected[0].name);
				if (this.selected[0].invite_token)
				{
					this.OPP1.AVATAR.ShowExternal(this.selected[0].invite_token, this.selected[0].avatar);
					this.OPP1.STAMP.gotoAndStop(1);
				}
				else if (this.selected[0].id == -2)
				{
					this.OPP1.CODE.visible = true;
					this.OPP1.STAMP.gotoAndStop(1);
				}
				else
				{
					this.OPP1.AVATAR.ShowUID(this.selected[0].id);
					cost += 3;
					this.OPP1.STAMP.gotoAndStop(2);
				}
				this.OPP1.BTNREMOVE.visible = currentFrame == 1;
				this.OPP1.BTNREMOVE.SetIcon("X");
			}
			else
			{
				this.OPP1.gotoAndStop(1);
				this.OPP1.CODE.visible = false;
				Util.SetText(this.OPP1.NAME.FIELD, "");
				this.OPP1.AVATAR.Clear();
				this.OPP1.BTNREMOVE.visible = false;
				Lang.Set(this.OPP1.ADDUSER.FIELD, "add_user");
			}
			if (this.selected[1])
			{
				this.OPP2.gotoAndStop(2);
				this.OPP2.CODE.visible = false;
				Util.SetText(this.OPP2.NAME.FIELD, this.selected[1].name);
				if (this.selected[1].invite_token)
				{
					this.OPP2.AVATAR.ShowExternal(this.selected[1].invite_token, this.selected[1].avatar);
					this.OPP2.STAMP.gotoAndStop(1);
				}
				else if (this.selected[1].id == -2)
				{
					this.OPP2.CODE.visible = true;
					this.OPP2.STAMP.gotoAndStop(1);
				}
				else
				{
					this.OPP2.AVATAR.ShowUID(this.selected[1].id);
					cost += 3;
					this.OPP2.STAMP.gotoAndStop(2);
				}
				this.OPP2.BTNREMOVE.visible = currentFrame == 1;
				this.OPP2.BTNREMOVE.SetIcon("X");
			}
			else
			{
				this.OPP2.gotoAndStop(1);
				this.OPP2.CODE.visible = false;
				Util.SetText(this.OPP2.NAME.FIELD, "");
				this.OPP2.AVATAR.Clear();
				this.OPP2.BTNREMOVE.visible = false;
				Lang.Set(this.OPP2.ADDUSER.FIELD, "add_user");
			}
			if (currentFrame == 1)
			{
				if (Boolean(this.selected[0]) && Boolean(this.selected[1]))
				{
					this.BTNCREATE.SetEnabled(true);
				}
				else
				{
					this.BTNCREATE.SetEnabled(false);
				}
				Imitation.FreeBitmapAll(this.BTNCREATE);
				this.STAMP.gotoAndStop(cost == 0 ? 2 : 1);
				if (this.STAMP.NUM)
				{
					Util.SetText(this.STAMP.NUM, "-" + cost);
				}
			}
		}

		public function OnRemoveClick(e:*):*
		{
			var n:* = Util.IdFromStringEnd(e.target.parent.name) - 1;
			this.user_selected[n] = null;
			this.selected = this.user_selected.slice();
			this.ITEMS.Draw();
			this.DrawAddButtons();
			this.ShowSelected();
		}

		public function DrawItem(item:MovieClip, idx:int):*
		{
			var a:* = undefined;
			var b:* = undefined;
			var username:* = undefined;
			if (!mc)
			{
				return;
			}
			if (this.listItems[idx])
			{
				a = this.listItems[idx].id > 0 || this.listItems[idx].invite_token;
				if (a)
				{
					item.gotoAndStop(!!this.listItems[idx].invite_token ? 1 : 2);
				}
				else
				{
					item.gotoAndStop(3);
				}
				b = a && this.selected.indexOf(this.listItems[idx]) >= 0 || this.selected[0] && this.selected[1];
				item.SELECTED.visible = b;
				username = Romanization.ToLatin(this.listItems[idx].name);
				if (item.AVATAR)
				{
					if (this.listItems[idx].invite_token)
					{
						item.AVATAR.ShowExternal(this.listItems[idx].invite_token, this.listItems[idx].avatar);
					}
					else
					{
						item.AVATAR.ShowUID(this.listItems[idx].id);
					}
					item.AVATAR.DisableClick();
				}
				if (item.STAMP)
				{
					item.STAMP.visible = true;
					if (this.onlineplayers[this.listItems[idx].id])
					{
						item.STAMP.gotoAndStop(4);
					}
					else
					{
						item.STAMP.gotoAndStop(this.listItems[idx].id > 0 ? 3 : 2);
					}
					Imitation.FreeBitmapAll(item.STAMP);
					Imitation.CollectChildrenAll(item.STAMP);
					Imitation.UpdateAll(item.STAMP);
				}
				item.visible = true;
				Util.SetText(item.NAME.FIELD, username);
			}
			else
			{
				item.gotoAndStop(2);
				item.visible = false;
			}
		}

		public function GetOnlineCount():int
		{
			var c:int = 0;
			for (var i:* = 0; i < this.friends.length; i++)
			{
				if (this.onlineplayers[this.friends[i].id])
				{
					c++;
				}
			}
			return c;
		}

		public function FilterItems(e:* = null):void
		{
			var i:int = 0;
			if (currentFrame > 1)
			{
				return;
			}
			this.listItems = [];
			var fstr:String = Util.UpperCase(Util.GetRTLEditText(this.SEARCH.EDSEARCH.FIELD));
			for (i = 0; i < this.friends.length; i++)
			{
				if (Boolean(this.onlineplayers[this.friends[i].id]) && Util.UpperCase(this.friends[i].name).indexOf(fstr) >= 0)
				{
					this.listItems.push(this.friends[i]);
					++this.openedlength;
				}
			}
			for (i = 0; i < Math.min(fstr == "" ? 50 : 5000, this.invitableFriendList.length); i++)
			{
				if (Util.UpperCase(this.invitableFriendList[i].name).indexOf(fstr) >= 0)
				{
					this.listItems.push(this.invitableFriendList[i]);
				}
			}
			for (i = 0; i < this.friends.length; i++)
			{
				if (!this.onlineplayers[this.friends[i].id] && Util.UpperCase(this.friends[i].name).indexOf(fstr) >= 0)
				{
					this.listItems.push(this.friends[i]);
					++this.openedlength;
				}
			}
			this.SEARCH.EDSEARCH.visible = this.invitableFriendList.length > 0 || this.opened && this.friends.length > 0;
			this.SEARCH.alpha = !!this.SEARCH.EDSEARCH.visible ? 1 : 0;
			this.ITEMS.SetItems(this.listItems);
		}

		public function AfterOpen():void
		{
			this.Loaded();
			Imitation.AddGlobalListener("TAGSPROCESSED", OnTagsProcessed);
			Imitation.AddGlobalListener("GAMETAGSPROCESSED", OnGameTagsProcessed);
		}

		public function GetExtData():void
		{
			if (currentFrame > 1)
			{
				return;
			}
			var fls:Array = [];
			for (var i:* = 0; i < this.friends.length; fls.push(this.friends[i].id), i++)
			{
			}
			Comm.SendCommand("GETEXTDATA", "IDLIST=\"" + fls.join(",") + "\"", this.OnExtdataResult, null);
		}

		public function ShowFriends():void
		{
			this.FilterItems();
		}

		public function Loaded():*
		{
			if (this.first_show)
			{
				TweenMax.delayedCall(0, WinMgr.WindowDataArrived, [this]);
			}
			else
			{
				this.GetExtData();
				if (Sys.codereg)
				{
					CheckSeproomWaiting();
				}
				Sys.codereg = false;
				Imitation.FreeBitmapAll(this.TABS);
				Imitation.CollectChildrenAll(this.TABS);
				Imitation.UpdateAll(this.TABS);
			}
			this.first_show = false;
		}

		public function Hide():void
		{
			this.HideMobileCode();
			if (Boolean(this.SEARCH) && Boolean(this.SEARCH.EDSEARCH.FIELD))
			{
				Util.RemoveEventListener(this.SEARCH.EDSEARCH.FIELD, Event.CHANGE, this.FilterItems);
			}
			WinMgr.CloseWindow(this);
		}

		public function AfterClose():void
		{
			Imitation.RemoveStageEventListener(MouseEvent.MOUSE_UP, this.NumMouseUp);
			Imitation.RemoveStageEventListener(TextEvent.TEXT_INPUT, this.InputKeyUp);
			Imitation.RemoveStageEventListener("mouseWheel", this.HandleMouseWheel);
			Imitation.RemoveGlobalListener("GAMETAGSPROCESSED", OnGameTagsProcessed);
			if (this.SB)
			{
				this.SB.Remove();
			}
			if (this.SCROLLBAR)
			{
				this.SCROLLBAR.Remove();
			}
			if (this.ROOMS_SB)
			{
				this.ROOMS_SB.Remove();
			}
		}

		public function OnCloseClick(e:* = null):void
		{
			if (mc && WinMgr.WindowOpened("friendlygame.FriendlyGame") && mc.currentFrame > 1 && this.TABS.current == 1)
			{
				Comm.SendCommand("EXITROOM", "");
				HideNotification();
			}
			this.Hide();
		}

		public function SetSubjects():*
		{
			var lm:* = undefined;
			this.subjects = "";
			for (var n:* = 1; n <= Sys.questioncats.length; n++)
			{
				lm = this["SUBJECT" + n];
				if (lm.currentFrame == 2)
				{
					this.subjects += (this.subjects != "" ? "," : "") + Sys.questioncats[n - 1].id;
				}
			}
		}

		public function FriendlyGameCallback(data:Object):void
		{
			var f:Object = null;
			var i:int = 0;
			var n:int = 0;
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("FriendlyGameCallback", null);
			}
			if (FriendlyGame.mc.selected.length <= 0 || FriendlyGame.mc.user_invited.length != data.to.length)
			{
				this.Hide();
				return;
			}
			var tosend:String = "";
			var toidx:int = 0;
			for (i = 0; i < FriendlyGame.mc.selected.length; i++)
			{
				f = FriendlyGame.mc.selected[i];
				if (f.external && f.hasOwnProperty("xi") && typeof f.xi == "string" && f.xi.length > 0)
				{
					for (n = 0; n < data.to.length; n++)
					{
						if (f.xi == data.to[n])
						{
							data.to.splice(n, 1);
							break;
						}
					}
				}
			}
			for (i = 0; i < data.to.length; i++)
			{
				toidx++;
				tosend += " OPP" + toidx + "=\"0\"";
				tosend += " EXT" + toidx + "=\"FBID." + data.to[i] + "\"";
				tosend += " NAME" + toidx + "=\"" + Util.StrXmlSafe(FriendlyGame.mc.user_invited[i].name) + "\"";
			}
			for (i = 0; i < FriendlyGame.mc.selected.length; i++)
			{
				f = FriendlyGame.mc.selected[i];
				if (!(Boolean(f.hasOwnProperty("invite_token")) && typeof f.invite_token == "string" && f.invite_token.length > 0))
				{
					toidx++;
					tosend += " OPP" + toidx + "=\"" + f.id + "\"";
					tosend += " EXT" + toidx + "=\"\"";
					tosend += " NAME" + toidx + "=\"" + Util.StrXmlSafe(f.name) + "\"";
				}
			}
			if (1 <= toidx && toidx <= 2)
			{
				tosend += " RULES=\"" + this.user_gametype + "\" QCATS=\"" + this.subjects + "\"";
				Comm.SendCommand("ADDSEPROOM", tosend, this.OnAddSeproomResult, this);
			}
			else
			{
				this.Hide();
			}
			FriendlyGame.mc.selected = [];
			FriendlyGame.mc.user_invited = [];
		}

		public function OnCreateClick(e:*):void
		{
			var f:Object = null;
			var msg:String = null;
			var invites:Array = [];
			var invcnt:int = 0;
			this.BTNCREATE.SetLang("create_game");
			Comm.SendCommand("EXITROOM", "");
			code_shared = false;
			for (var i:int = 0; i < FriendlyGame.mc.selected.length; i++)
			{
				f = FriendlyGame.mc.selected[i];
				if (Boolean(f.hasOwnProperty("invite_token")) && typeof f.invite_token == "string" && f.invite_token.length > 0)
				{
					FriendlyGame.mc.user_invited.push(f);
					invites.push(f.invite_token);
					invcnt++;
				}
				else if (f.external && f.hasOwnProperty("xi") && typeof f.xi == "string" && f.xi.length > 0)
				{
					FriendlyGame.mc.user_invited.push(f);
					invites.push(f.xi);
				}
			}
			if (!this.selected[0])
			{
				this.selected[0] = {
						"id": -1,
						"name": "(" + Lang.get ("robot") + ")",
						"granted": true
					};
			}
			if (!this.selected[1])
			{
				this.selected[1] = {
						"id": -1,
						"name": "(" + Lang.get ("robot") + ")",
						"granted": true
					};
			}
			if (invcnt > 0 && Config.mobile)
			{
				Platform.FacebookInvite(invites.join(), Lang.Get("invite_new_user"), Lang.Get("select_friends_play_with"), FriendlyGame.mc.FriendlyGameCallback);
			}
			else if (invcnt > 0 && ExternalInterface.available)
			{
				ExternalInterface.addCallback("FriendlyGameCallback", null);
				ExternalInterface.addCallback("FriendlyGameCallback", this.FriendlyGameCallback);
				Util.ExternalCall("InviteFriends", invites, "FRIENDLYGAME", Sys.FunnelVersion(), "FriendlyGameCallback");
			}
			else
			{
				msg = Lang.get ("created_a_friendly_game", Sys.mydata.name);
				if (lobby_share_msg == msg)
				{
					msg = "";
				}
				else
				{
					lobby_share_msg = msg;
				}
				Comm.SendCommand("ADDSEPROOM", "OPP1=\"" + this.selected[0].id + "\" OPP2=\"" + this.selected[1].id + "\"" + " NAME1=\"" + Util.StrXmlSafe(this.selected[0].name) + "\" NAME2=\"" + Util.StrXmlSafe(this.selected[1].name) + "\"" + " RULES=\"" + this.user_gametype + "\"" + " QCATS=\"" + this.subjects + "\"" + " CHATMSG=\"" + msg + "\"", this.OnAddSeproomResult, this);
				if (invites.length > 0)
				{
					Util.ExternalCall("InviteFriends", invites, "FRIENDLYGAME", Sys.FunnelVersion(), "");
				}
			}
		}

		public function OnAddSeproomResult(ecode:int, xml:*):*
		{
			var unum:int = 0;
			var s:String = null;
			if (ecode != 0)
			{
				if (ecode == 87)
				{
					WinMgr.OpenWindow("energy.Energy", {
								"funnelid": "Game",
								"page": "WARNING"
							});
					this.ShowCreate();
					return;
				}
				if (ecode == 79)
				{
					WinMgr.OpenWindow("energy.Energy", {
								"funnelid": "Game",
								"page": "BUY"
							});
					this.ShowCreate();
					return;
				}
				unum = ecode - 67;
				s = "* error creating separate room!";
				if (unum >= 1 && unum <= 2)
				{
					s = Lang.get ("sb_not_available_for_friendly", this.selected[unum - 1].name);
				}
				UIBase.ShowMessage(Lang.get ("error"), s);
				this.ShowCreate();
				return;
			}
			gotoAndStop("NORMAL");
			if (mc.BTN_SHARE_CLAN)
			{
				mc.BTN_SHARE_CLAN.visible = false;
			}
			Util.StopAllChildrenMov(mc);
			Lang.Set(mc.INFO.FIELD, "waiting_for_players");
			mc.BTNEXIT.AddEventClick(OnFriendlyExit);
			mc.BTNEXIT.SetLang("exit");
			this.ShowSelected();
			this.StartWaitingChat();
		}

		private function OnNotifyClick(e:*):void
		{
			ShowWaiting();
		}

		public function SysMsg(msg:String):void
		{
			if (currentFrame == 1 || currentFrame > 4)
			{
				return;
			}
			this.chatbuf.AddChatMessage({
						"TS": 0,
						"UID": -1,
						"NAME": "",
						"MSG": msg
					}, this.MESSAGES.ITEMS.PROTOTYPE);
			this.DrawChatMessages();
			this.chatbuf.top = this.chatbuf.fullheight - mc.MASK.height + this.chatbuf.default_line_height;
			this.UpdateScrollBar();
		}

		private function StartWaitingChat():*
		{
			var m:MovieClip = null;
			var two_bots:Boolean = false;
			if (!iswaiting)
			{
				Imitation.CollectChildren(mc);
				mc.DrawChatMessages();
				m = mc.MESSAGES.ITEMS;
				mc.BTN_CHAT_SEND.SetIcon("PLAY");
				mc.BTN_CHAT_SEND.AddEventClick(mc.OnSendClick);
				mc.CHAT_AVATAR.ShowUID(Sys.mydata.id);
				Imitation.AddStageEventListener(TextEvent.TEXT_INPUT, mc.InputKeyUp);
				mc.MESSAGES.condenseWhite = true;
				mc.MESSAGES.ITEMS.PROTOTYPE.visible = false;
				mc.SCROLLBAR.OnScroll = mc.OnScrollBarScroll;
				mc.INPUT.restrict = Config.GetChatRestrictChars();
				Util.RTLEditSetup(mc.INPUT);
				mc.SCROLLBAR.Set(mc.chatbuf.fullheight, mc.MASK.height, mc.chatbuf.fullheight - mc.MASK.height);
				mc.SCROLLBAR.SetScrollRect(mc.MASK);
				mc.SCROLLBAR.isaligned = false;
				mc.SCROLLBAR.visible = mc.chatbuf.fullheight > mc.MASK.height;
				Imitation.SetMaskedMov(mc.MASK, mc.MESSAGES, false);
				Imitation.AddStageEventListener("mouseWheel", mc.HandleMouseWheel);
				this.chatbuf.Clear();
				this.DrawChatMessages(true);
				two_bots = this.selected[0] !== undefined && this.selected[1] !== undefined && Util.NumberVal(this.selected[0].id) == -1 && Util.NumberVal(this.selected[1].id) == -1;
				if (two_bots)
				{
					mc.INPUT.visible = false;
					mc.BUBBLE.alpha = 0.5;
					mc.BTN_CHAT_SEND.SetEnabled(false);
				}
				else
				{
					mc.INPUT.visible = true;
					mc.BUBBLE.alpha = 1;
					mc.BTN_CHAT_SEND.SetEnabled(true);
				}
				iswaiting = true;
			}
		}

		public function OpenGraphInvitableFriends(callbackfunc:Function = null):void
		{
			var acc:String;
			var LoadedInvitableFriends:Function = null;
			LoadedInvitableFriends = function():void
			{
				FriendlyGame.mc.invitableFriendList = Friends.invitable;
				if (Boolean(FriendlyGame.mc) && callbackfunc != null)
				{
					callbackfunc();
				}
			};
			this.invitableFriendList = [];
			acc = Util.StringVal(Config.flashvars.fb_access_token);
			if (Config.loginsystem != "FACE" && acc.length <= 0)
			{
				if (Boolean(FriendlyGame.mc) && callbackfunc != null)
				{
					callbackfunc();
				}
				return;
			}
			Friends.LoadInvitableFriends(LoadedInvitableFriends);
		}

		public function DrawChatMessages(refresh:* = false):*
		{
			if (!mc || !mc.MESSAGES)
			{
				return;
			}
			this.chatbuf.DrawMessages(this, refresh);
		}

		public function InputKeyUp(e:TextEvent):void
		{
			if (e.text.charCodeAt() == 10)
			{
				e.preventDefault();
				this.OnSendClick();
			}
		}

		public function OnSendClick(e:* = null):*
		{
			var msg:* = Util.GetRTLEditText(this.INPUT);
			msg = Util.CleanupChatMessage(msg);
			if (msg.length < 2)
			{
				return;
			}
			if (timer.running)
			{
				return;
			}
			Comm.SendCommand("CHATMSG", "MSG=\"" + msg + "\"" + " PCH=\"-2\"");
			Util.SetRTLEditText(this.INPUT, "");
		}

		public function FloodBlockReady():*
		{
			this.BTN_CHAT_SEND.SetEnabled(true);
		}

		public function UpdateScrollBar():*
		{
			if (!mc || mc.TABS.current > 1)
			{
				return;
			}
			this.SCROLLBAR.visible = this.chatbuf.fullheight > this.MASK.height;
			if (!this.SCROLLBAR.dragging)
			{
				this.SCROLLBAR.Set(this.chatbuf.fullheight, this.MASK.height, this.chatbuf.top);
			}
		}

		public function OnScrollBarScroll(afirst:*):*
		{
			this.chatbuf.top = afirst;
			TweenMax.delayedCall(0, this.DrawChatMessages);
		}

		public function OnMessagesScroll(e:*):*
		{
			this.UpdateScrollBar();
		}

		public function HandleMouseWheel(e:MouseEvent):*
		{
			var cb:LegoChatMessageBuffer = this.chatbuf;
			if (!cb)
			{
				return;
			}
			cb.top -= e.delta * cb.default_line_height;
			cb.top = Math.min(this.chatbuf.fullheight - this.MASK.height, cb.top);
			cb.top = Math.max(0, cb.top);
			TweenMax.delayedCall(0, this.DrawChatMessages);
			this.UpdateScrollBar();
		}

		internal function __setProp_CHAR_FriendlyGameMov_Layer27_4():*
		{
			if (this.__setPropDict[this.CHAR] == undefined || int(this.__setPropDict[this.CHAR]) != 5)
			{
				this.__setPropDict[this.CHAR] = 5;
				try
				{
					this.CHAR["componentInspectorSetting"] = true;
				}
				catch (e:Error)
				{
				}
				this.CHAR.character = "CLAN_GIRL";
				this.CHAR.enabled = true;
				this.CHAR.frame = 1;
				this.CHAR.shade = true;
				this.CHAR.shadow = true;
				this.CHAR.visible = true;
				try
				{
					this.CHAR["componentInspectorSetting"] = false;
				}
				catch (e:Error)
				{
				}
			}
		}

		internal function frame5():*
		{
			this.__setProp_CHAR_FriendlyGameMov_Layer27_4();
		}
	}
}
