package gameover
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import syscode.*;
	import uibase.gfx.lego_button_3x1_ok;
	import uibase.gfx.lego_button_3x1_normal;
	import uibase.gfx.LegoCharacters;
	import uibase.gfx.HeaderTabs;

	[Embed(source="/modules/gameover_assets.swf", symbol="symbol827")]
	public class GameOver extends MovieClip
	{
		public static var mc:GameOver = null;

		public static var prop:Object = null;

		public static var issaving:Boolean = false;

		public static var serialframeid:String = "1";

		public static var gametype:String = "NORMAL";

		public static var prevpage:int = 0;

		public static var currentpage:int = 1;

		public static var data:Object = {};

		public static var save:Object = {};

		public static var lost:Object = {};

		public static var lastxpchange:int = 0;

		public static var clanprop:Object = {};

		public static var autoplay:Boolean = true;

		public static var isturning:Boolean = false;

		public static var firstshowing:Boolean = false;

		public static var istutorialplaying:Boolean = false;

		private static var minitournament_tag:* = null;

		private static var tournament_tag:* = null;

		private static var mt_currentlyplaying:Number = 0;

		private static var mt_remaining:Number = 0;

		public static var mt_round:int = 0;

		public var BOUNDS:MovieClip;

		public var BTNGET:lego_button_3x1_ok;

		public var BTNOK:lego_button_3x1_ok;

		public var BTNSKIP:lego_button_3x1_normal;

		public var BUBBLE:MovieClip;

		public var BUBBLELESSTEN:MovieClip;

		public var BUTTONPANEL:MovieClip;

		public var DIVISIONLIST:MovieClip;

		public var INFO:MovieClip;

		public var INFO2:MovieClip;

		public var INFOBG:MovieClip;

		public var INFOBG2:MovieClip;

		public var INFOLESSTEN:MovieClip;

		public var LEAGUE:MovieClip;

		public var MTOURSTATE:MovieClip;

		public var MT_TITLE:MovieClip;

		public var NPC:LegoCharacters;

		public var PAGE:MovieClip;

		public var PIRATE_BUBBLE:MovieClip;

		public var PIRATE_TXT:MovieClip;

		public var SERIAL:LegoCharacters;

		public var TABS:HeaderTabs;

		public var TROPHIES:MovieClip;

		public var XPCHANGE_NEW:MovieClip;

		public var XPCHANGE_OLD:MovieClip;

		private var tabs:Array;

		private var tutorialindex:* = 0;

		private var tutorialtexts:Array;

		private var mtupdatetimer:Timer;

		private var _frame:String;

		private var IngameChat:Object = null;

		private var videoad_available:Boolean = false;

		private var videoad_play:Boolean = false;

		private var tabs_ready:Boolean = false;

		private var div_members:Array;

		public var tournament_close_timer:Timer = null;

		private var tournament_counter:int = 15;

		private var chat_visible:Boolean = false;

		private var lessten_tips:Array;

		public function GameOver()
		{
			this.tabs = [1, 2, 3, 4, 5, 6, 9, 10];
			this.tutorialtexts = [Lang.Get("tut_gameover_s00"), Lang.Get("tut_gameover_s01"), Lang.Get("tut_gameover_s02"), Lang.Get("tut_gameover_s03"), Lang.Get("tut_gameover_s04"), Lang.Get("tut_gameover_s05"), Lang.Get("tut_gameover_s06")];
			this.mtupdatetimer = new Timer(1000, 0);
			this.div_members = new Array();
			this.lessten_tips = ["waiting_game_tip_10", "waiting_game_tip_13", "waiting_game_tip_11", "waiting_game_tip_14", "waiting_game_tip_6", "waiting_game_tip_12", "waiting_game_tip_0", "waiting_game_tip_4", "waiting_game_tip_5", "waiting_game_tip_15"];
			super();
		}

		public static function tagproc_MINITOUR(tag:Object):void
		{
			minitournament_tag = tag;
			mt_currentlyplaying = Util.NumberVal(tag.PLAYING);
			mt_remaining = Util.NumberVal(tag.REMAINING);
			if (mc)
			{
				mc.UpdateMinitournamentState();
			}
		}

		public static function LoadMyClanProperties():void
		{
			var socials:String = Util.StringVal(Config.flashvars.social_friends);
			JsQuery.Load(GameOver.SetMyClanProperties, [], Config.CLAN_PHP + Sys.FormatGetParamsStoc({}, true), {
						"cmd": "alliance",
						"social_friends": socials
					});
		}

		public static function SetMyClanProperties(_jsq:Object):void
		{
			if (_jsq.error)
			{
				GameOver.clanprop = {};
				return;
			}
			GameOver.clanprop = _jsq.data;
		}

		public static function CheckGamePost():Boolean
		{
			var tag:* = GameOver.prop.tag;
			if (!tag)
			{
				return false;
			}
			if (Util.NumberVal(Config.flashvars.postenabled) !== 1)
			{
				return false;
			}
			if (Config.siteid == "pl" || Config.siteid == "ru")
			{
				return false;
			}
			if (Config.loginsystem != "FACE" && Config.loginsystem != "MAIL")
			{
				return false;
			}
			if (Util.NumberVal(tag.ROOMID) >= 32)
			{
				return false;
			}
			if (Util.NumberVal(tag.MINITOUR) != 0 || Util.NumberVal(tag.TOURNAMENT) != 0)
			{
				return false;
			}
			return true;
		}

		public static function GetBotFakeName(_num:int):String
		{
			return Lang.get ("bot_fake_name_" + (1 + _num % 8));
		}

		public static function GetDefaultGameOverData():Object
		{
			return {
					"gameid": 0,
					"exitstate": 0,
					"mapid": "",
					"areas": [],
					"iam": 0,
					"opp1": 0,
					"opp2": 0,
					"placings": [],
					"place": 0,
					"basexp": 0,
					"pointpercent": 0,
					"opplevel": 0,
					"xpcw": 0,
					"xpcw2": 0,
					"allylevel": 0,
					"xppoints": 0,
					"curcwins": 0,
					"curcwins2": 0,
					"answercount": 0,
					"goodanswers": 0,
					"tipcount": 0,
					"tipwins": 0,
					"tipvepcount": 0,
					"tipveptotal": 0,
					"opp1place": 0,
					"opp1userid": "",
					"opp1name": "",
					"opp1xplevel": 0,
					"opp1ppp": 0,
					"opp2place": 0,
					"opp2userid": "",
					"opp2name": "",
					"opp2xplevel": 0,
					"opp2ppp": 0,
					"mt_prize_xp": 0
				};
		}

		private static function GetGameOverDataFromVillage():Object
		{
			var areas:String = null;
			var i:int = 0;
			var ac:uint = 0;
			var a:Object = null;
			var d:Object = GameOver.GetDefaultGameOverData();
			var p:Object = GameOver.prop;
			var tag:Object = p.tag;
			var arr:Array = [];
			if (tag)
			{
				p.players = [ {}];
				d.place = Util.NumberVal(tag.PLACE);
				d.basexp = 100 * (4 - d.place);
				d.points = Util.NumberVal(tag.POINTS);
				d.pointpercent = Util.NumberVal(tag.PPP);
				d.pppxp = Math.round(d.pointpercent * d.basexp);
				d.opplevel = Util.NumberVal(tag.OPPLEVEL);
				d.opplevelxp = Math.round(d.basexp * d.opplevel / 100);
				arr = Util.StringVal(tag.XPCW).split(",");
				d.curcwins = Util.NumberVal(arr[0]);
				d.xpcw = Util.NumberVal(arr[1]);
				arr = Util.StringVal(tag.XPCW2).split(",");
				d.curcwins2 = Util.NumberVal(arr[0]);
				d.xpcw2 = Util.NumberVal(arr[1]);
				d.xpchange = d.basexp + d.pppxp + d.opplevelxp + d.xpcw + d.xpcw2;
				d.allylevel = Util.NumberVal(tag.ALLYLEVEL);
				d.allyxp = Math.round(d.xpchange * d.allylevel / 100);
				d.xpchange += d.allyxp;
				d.xp = Util.NumberVal(tag.XPPOINTS);
				d.mt_prize_xp = Util.NumberVal(tag.PRIZEXP);
				d.lastplaces = Sys.mydata.lastplaces.slice();
				d.iam = Util.NumberVal(tag.IAM);
				d.opp1 = Util.NumberVal(tag.OPP1);
				d.opp2 = Util.NumberVal(tag.OPP2);
				d.opp1userid = Util.NumberVal(tag.OPP1USERID) == 0 ? -1 : Util.NumberVal(tag.OPP1USERID);
				d.opp1place = Util.NumberVal(tag.OPP1PLACE);
				d.opp1basexp = !!d.opp1place ? (4 - d.opp1place) * 100 : 0;
				d.opp1name = Util.StringVal(tag.OPP1NAME);
				d.opp1xplevel = Util.NumberVal(tag.OPP1XPLEVEL);
				d.opp1points = Util.NumberVal(tag.OPP1POINTS);
				d.opp1ppp = Util.NumberVal(tag.OPP1PPP);
				d.opp1pppxp = Math.round(d.opp1basexp * d.opp1ppp);
				if (d.opp1userid < 0)
				{
					d.opp1name = GameOver.GetBotFakeName(Util.NumberVal(tag.GAMEID) + 1);
					d.opp1userid = -100 - (1 + (Util.NumberVal(tag.GAMEID) + 1) % 8);
				}
				d.opp2userid = Util.NumberVal(tag.OPP2USERID) == 0 ? -1 : Util.NumberVal(tag.OPP2USERID);
				d.opp2place = Util.NumberVal(tag.OPP2PLACE);
				d.opp2basexp = !!d.opp2place ? (4 - d.opp2place) * 100 : 0;
				d.opp2name = Util.StringVal(tag.OPP2NAME);
				d.opp2xplevel = Util.NumberVal(tag.OPP2XPLEVEL);
				d.opp2points = Util.NumberVal(tag.OPP2POINTS);
				d.opp2ppp = Util.NumberVal(tag.OPP2PPP);
				d.opp2pppxp = Math.round(d.opp2basexp * d.opp2ppp);
				if (d.opp2userid < 0)
				{
					d.opp2name = GameOver.GetBotFakeName(Util.NumberVal(tag.GAMEID) + 2);
					d.opp2userid = -100 - (1 + (Util.NumberVal(tag.GAMEID) + 2) % 8);
				}
				d.placings = [0, 1, 2, 3];
				d.placings[d.place] = d.iam;
				d.placings[d.opp1place] = d.opp1;
				d.placings[d.opp2place] = d.opp2;
				d.state = Util.NumberVal(tag.STATE);
				d.mapid = Util.NumberVal(tag.MAPID);
				areas = Util.StringVal(tag.A);
				d.areanum = Math.floor(areas.length / 2);
				d.areas = [null];
				d.bases = [0, 0, 0];
				for (i = 1; i <= d.areanum; i++)
				{
					ac = parseInt("0x" + areas.substr((i - 1) * 2, 2));
					a = {};
					a.number = i;
					a.owner = ac & 3;
					a.fortress = (ac & 0x80) > 0;
					a.base = false;
					a.valuecode = ac >> 4 & 7;
					switch (a.valuecode)
					{
						case 1:
							a.value = 1000;
							d.bases[a.owner] = i;
							a.base = true;
							break;
						case 2:
							a.value = 400;
							break;
						case 3:
							a.value = 300;
							break;
						case 4:
							a.value = 200;
							break;
						default:
							a.value = 0;
							break;
					}
					d.areas.push(a);
				}
				d.answercount = Util.NumberVal(tag.ANSWERCOUNT);
				d.goodanswers = Util.NumberVal(tag.GOODANSWERS);
				d.tipcount = Util.NumberVal(tag.TIPCOUNT);
				d.tipwins = Util.NumberVal(tag.TIPWINS);
				d.tipvepcount = Util.NumberVal(tag.TIPVEPCOUNT);
				d.tipveptotal = Util.NumberVal(tag.TIPVEPTOTAL);
			}
			return d;
		}

		private static function GetGameOverDataFromGame():Object
		{
			var arr:* = undefined;
			var arr2:* = undefined;
			var opp1:* = undefined;
			var opp2:* = undefined;
			var sum:Number = NaN;
			var answers:* = undefined;
			var tips:* = undefined;
			var veptips:* = undefined;
			var d:Object = GameOver.GetDefaultGameOverData();
			var p:Object = GameOver.prop;
			var tag:Object = p.tag;
			if (tag)
			{
				arr = Util.StringVal(tag.XPPL).split(",");
				d.place = Util.NumberVal(arr[0]);
				d.basexp = Util.NumberVal(arr[1]);
				arr = Util.StringVal(tag.XPPP).split(",");
				d.points = p.players[p.iam].points;
				d.pppxp = Util.NumberVal(arr[1]);
				arr = Util.StringVal(tag.XPOPP).split(",");
				d.opplevel = Util.NumberVal(arr[0]);
				d.opplevelxp = Util.NumberVal(arr[1]);
				arr = Util.StringVal(tag.XPCW).split(",");
				arr2 = Util.StringVal(tag.XPCW2).split(",");
				d.xpcw = Util.NumberVal(arr[1]);
				d.xpcw2 = Util.NumberVal(arr2[1]);
				if (tag.ALLY)
				{
					arr = Util.StringVal(tag.ALLY).split(",");
				}
				else
				{
					arr = [0, 0, 0];
				}
				d.allylevel = Util.NumberVal(arr[1]);
				d.allyxp = Util.NumberVal(arr[2]);
				arr = Util.StringVal(tag.XP).split(",");
				d.xp = arr[1];
				d.mt_prize_xp = Util.NumberVal(tag.PRIZEXP);
				d.lastplaces = Sys.mydata.lastplaces.slice();
				d.curcwins = Sys.mydata.curcwins;
				d.curcwins2 = Sys.mydata.curcwins2;
				d.iam = p.iam;
				d.opp1 = p.myopp1;
				d.opp2 = p.myopp2;
				opp1 = p.players[d.opp1];
				opp2 = p.players[d.opp2];
				d.placings = [0, Number(tag.PLACINGS.charAt(0)), Number(tag.PLACINGS.charAt(1)), Number(tag.PLACINGS.charAt(2))];
				sum = Util.NumberVal(p.players[1].points) + Util.NumberVal(p.players[2].points) + Util.NumberVal(p.players[3].points);
				d.opp1userid = opp1.id;
				d.opp1place = d.placings.indexOf(d.opp1);
				d.opp1basexp = (4 - d.opp1place) * 100;
				d.opp1name = opp1.name;
				d.opp1xplevel = opp1.xplevel;
				d.opp1points = opp1.points;
				d.opp1ppp = Util.NumberVal(opp1.points) / sum;
				d.opp1pppxp = Math.round(d.opp1basexp * p.players[d.opp1].points / sum);
				d.opp2userid = opp2.id;
				d.opp2place = d.placings.indexOf(d.opp2);
				d.opp2basexp = (4 - d.opp2place) * 100;
				d.opp2name = opp2.name;
				d.opp2xplevel = opp2.xplevel;
				d.opp2points = opp2.points;
				d.opp2ppp = Util.NumberVal(opp2.points) / sum;
				d.opp2pppxp = Math.round(d.opp2basexp * p.players[d.opp2].points / sum);
				d.pointpercent = 1 - (d.opp1ppp + d.opp2ppp);
				d.bases = {};
				d.bases[d.iam] = p.players[d.iam].base;
				d.bases[d.opp1] = p.players[d.opp1].base;
				d.bases[d.opp2] = p.players[d.opp2].base;
				d.areas = p.areas;
				answers = tag.ANSWERS.split(",");
				tips = tag.TIPS.split(",");
				veptips = tag.VEPTIPS.split(",");
				d.answercount = Util.NumberVal(answers[0]);
				d.goodanswers = Util.NumberVal(answers[1]);
				d.tipcount = Util.NumberVal(tips[0]);
				d.tipwins = Util.NumberVal(tips[1]);
				d.tipvepcount = Util.NumberVal(veptips[0]);
				d.tipveptotal = Util.NumberVal(veptips[1]);
			}
			return d;
		}

		public static function GetGameOverData():Object
		{
			var p:Object = GameOver.prop;
			if (p.type == "VILLAGE")
			{
				return GameOver.GetGameOverDataFromVillage();
			}
			return GameOver.GetGameOverDataFromGame();
		}

		public static function GetLastGameOverData():Object
		{
			var a:Object = null;
			var k:* = undefined;
			var d:Object = GameOver.GetGameOverData();
			var p:Object = GameOver.prop;
			var calc:Array = Util.StringVal(Sys.tag_brokenseries.CALC).split(",");
			d.place = 1;
			d.basexp = Util.NumberVal(calc[1]);
			d.pointpercent = 1;
			d.pppxp = Util.NumberVal(calc[2]);
			d.lastplaces[0] = 9;
			d.curcwins = Sys.mydata.prevcwins + 1;
			d.curcwins2 = Sys.mydata.prevcwins2 + 1;
			d.placings = [0, d.iam, d.opp1, d.opp2];
			d.opp1name = "X";
			d.opp2name = "X";
			d.opp1basexp = 0;
			d.opp2basexp = 0;
			d.opp1ppp = 0;
			d.opp1pppxp = 0;
			d.opp1points = 0;
			d.opp2ppp = 0;
			d.opp2pppxp = 0;
			d.opp2points = 0;
			d.opp1xplevel = Util.NumberVal(calc[3]);
			d.opp2xplevel = Util.NumberVal(calc[3]);
			d.xpcw = Util.NumberVal(calc[4]);
			d.xpcw2 = Util.NumberVal(calc[5]);
			d.opplevelxp = Math.round(Util.NumberVal(d.basexp) * Util.NumberVal(calc[3]) / 100);
			d.allylevel = Util.NumberVal(calc[6]);
			d.allyxp = Util.NumberVal(calc[7]);
			d.xpchange = Util.NumberVal(calc[0]);
			d.xp = d.xpchange;
			d.areas = d.areas.slice();
			for (var i:* = 1; i <= p.areanum; i++)
			{
				a = {};
				for (k in d.areas[i])
				{
					a[k] = d.areas[i][k];
				}
				a.owner = d.iam;
				d.areas[i] = a;
			}
			return d;
		}

		public function Prepare(_params:Object):void
		{
			var two_bots:Boolean = false;
			var competition_chat:* = undefined;
			var friendlygame_chat:* = undefined;
			var MinitournamentWin:Object = null;
			trace("-----------GameOver Prepare-----------------");
			GameOver.prop = _params.prop;
			Util.StopAllChildrenMov(this);
			var p:Object = GameOver.prop;
			GameOver.istutorialplaying = Util.NumberVal(p.tag.TUTORIAL) == 1;
			GameOver.issaving = p.save;
			GameOver.serialframeid = String(Math.min(Util.NumberVal(Sys.mydata.shlevel) + 1, 5));
			this.IngameChat = Modules.GetClass("triviador", "triviador.IngameChat");
			var Game:* = Modules.GetClass("triviador", "triviador.Game");
			if (Game)
			{
				two_bots = Boolean(Game.players[Game.myopp1]) && Game.players[Game.myopp1].id <= -1 && Boolean(Game.players[Game.myopp2]) && Game.players[Game.myopp2].id <= -1;
				competition_chat = Game.roomtype == "C" && Sys.mydata.chatban == 0 && Util.NumberVal(Sys.mydata.uls[3]) == 1;
				friendlygame_chat = Game.roomtype == "F" && (Game.players[Game.iam] && Game.players[Game.iam].chatstate == 0);
				if (!two_bots && (competition_chat || friendlygame_chat))
				{
					this.chat_visible = true;
				}
				else
				{
					this.chat_visible = false;
				}
			}
			else
			{
				this.chat_visible = false;
			}
			if (Sys.screen == "VILLAGE")
			{
				this.chat_visible = false;
			}
			if (this.chat_visible)
			{
				mc.PAGE.CHAT.gotoAndStop(1);
				if (Boolean(this.IngameChat) && Boolean(this.IngameChat.mc))
				{
					mc.PAGE.CHAT.Init(this.IngameChat.mc.chatbuf);
				}
				else
				{
					mc.PAGE.CHAT.Init();
				}
			}
			if (this.IngameChat)
			{
				this.IngameChat.Remove();
			}
			this.tabs = [1, 2, 3, 4, 5, 6, 9, 10];
			GameOver.gametype = "NORMAL";
			GameOver.LoadMyClanProperties();
			if (Util.NumberVal(Sys.mydata.xplevel) <= 10)
			{
			}
			if (Util.NumberVal(p.tag.MINITOUR) != 0)
			{
				GameOver.gametype = "MINITOURNAMENT";
				MinitournamentWin = prop.minitournamentwin;
				if (Util.NumberVal(p.tag.MTFINISHED) != 0 || MinitournamentWin && MinitournamentWin.iamout)
				{
					this.tabs = [];
				}
				else
				{
					this.tabs = [];
				}
			}
			else if (Util.NumberVal(p.tag.ROOMID) >= 32)
			{
				GameOver.gametype = "FRIENDLY";
			}
			else if (Util.NumberVal(p.tag.RULES) == 0)
			{
				GameOver.gametype = "LONG";
			}
			if (Util.NumberVal(p.tag.TOURNAMENT) != 0)
			{
				GameOver.gametype = "TOURNAMENT";
			}
			if (GameOver.issaving)
			{
				this.Draw("BROKEN");
			}
			else if (GameOver.gametype == "MINITOURNAMENT")
			{
				this.Draw("MINITOURNAMENT");
			}
			else if (GameOver.gametype == "TOURNAMENT")
			{
				this.Draw("TOURNAMENT");
			}
			else if (GameOver.gametype == "FRIENDLY")
			{
				this.Draw("FRIENDLY");
			}
			else
			{
				this.Draw("COMPETITION");
			}
			if (GameOver.gametype != "MINITOURNAMENT" && GameOver.gametype != "TOURNAMENT")
			{
				this.PAGE.TITLE.visible = false;
			}
		}

		private function SetDivisionPanel():void
		{
			var o:Object;
			var i:int = 0;
			var league:int = Util.NumberVal(Sys.mydata.league);
			var xplevel:int = Util.NumberVal(Sys.mydata.xplevel);
			trace(league + ". " + Lang.Get("league_name_" + league));
			if (this.LEAGUE)
			{
				Util.SetText(this.LEAGUE.C_ACTLEAGUE.FIELD, league + ". " + Lang.Get("league_name_" + league));
			}
			if (league == 0 || xplevel < 10)
			{
				this.LEAGUE.visible = false;
			}
			else
			{
				this.LEAGUE.visible = true;
				if (this.LEAGUE.CROWN)
				{
					Imitation.GotoFrame(this.LEAGUE.CROWN, 8 - league);
				}
			}
			o = null;
			if (Sys.tag_division.LINE !== undefined)
			{
				for (i = 0; i < Sys.tag_division.LINE.length; i++)
				{
					o = Sys.tag_division.LINE[i];
					this.div_members.push({
								"UID": o.UID,
								"XP": o.XP,
								"xplevel": Util.NumberVal(o.L),
								"actleague": Util.NumberVal(Sys.mydata.league),
								"UP": o.UP,
								"DOWN": o.DOWN
							});
					Extdata.GetUserData(Util.StringVal(o.UID));
				}
			}
			this.DIVISIONLIST.LINES.Set("DLINE_", [], 40, 1, null, this.DrawDivision, this.DIVISIONLIST.MASK, this.DIVISIONLIST.SB);
			Extdata.GetSheduledData(function():*
				{
					if (DIVISIONLIST)
					{
						DIVISIONLIST.LINES.Set("DLINE_", div_members, 40, 1, null, DrawDivision, DIVISIONLIST.MASK, DIVISIONLIST.SB);
					}
					if (DIVISIONLIST)
					{
						DIVISIONLIST.SB.ScrollTo(0, 0);
					}
				});
		}

		private function DrawDivision(lm:*, id:*):void
		{
			trace("Gaameover.DrawDivision");
			Imitation.CollectChildrenAll(lm);
			var p:Object = null;
			var u:Object = null;
			p = this.div_members[id];
			var up:int = Util.NumberVal(Sys.tag_division.UP);
			var down:int = Util.NumberVal(Sys.tag_division.DOWN);
			if (Boolean(p) && lm)
			{
				lm.visible = true;
				u = Extdata.GetUserData(Util.StringVal(p.UID));
				if (u != null)
				{
					if (Boolean(lm.COUNT) && Boolean(lm.COUNT.FIELD))
					{
						Util.SetText(lm.COUNT.FIELD, String(id + 1) + ".");
					}
					if (Boolean(lm.NAME) && Boolean(lm.NAME.FIELD))
					{
						Util.SetText(lm.NAME.FIELD, Romanization.ToLatin(Util.StringVal(u.name)));
					}
					if (Boolean(lm.XP) && Boolean(lm.XP.FIELD))
					{
						Util.SetText(lm.XP.FIELD, Util.StringVal(Util.FormatNumber(p.XP)) + " " + Lang.Get("xp"));
					}
					if (lm.AVATAR)
					{
						lm.AVATAR.ShowUID(u.id, Imitation.Update, [lm.AVATAR]);
					}
					if (lm.UP)
					{
						lm.UP.visible = id + 1 <= up;
					}
					if (lm.DOWN)
					{
						lm.DOWN.visible = id + 1 > this.div_members.length - down;
					}
				}
				else
				{
					if (Boolean(lm.COUNT) && Boolean(lm.COUNT.FIELD))
					{
						lm.COUNT.FIELD.text = "";
					}
					if (Boolean(lm.NAME) && Boolean(lm.NAME.FIELD))
					{
						lm.NAME.FIELD.text = "";
					}
					if (Boolean(lm.XP) && Boolean(lm.XP.FIELD))
					{
						lm.XP.FIELD.text = "";
					}
					if (lm.AVATAR)
					{
						lm.AVATAR.Clear();
					}
					if (lm.UP)
					{
						lm.UP.visible = false;
					}
					if (lm.DOWN)
					{
						lm.DOWN.visible = false;
					}
				}
				Imitation.FreeBitmapAll(lm);
				Imitation.UpdateAll(lm);
			}
			else
			{
				lm.visible = false;
				if (lm.AVATAR)
				{
					lm.AVATAR.ShowUID(-1);
				}
			}
		}

		private function DrawCompetitionFrame():void
		{
			trace("Gaameover.DrawCompetitionFrame");
			this.BUBBLELESSTEN.visible = false;
			this.INFOLESSTEN.visible = false;
			var ppl:uint = uint(Util.StringVal(GameOver.prop.tag.XPPL).split(",")[0]);
			var ppp:uint = uint(Util.StringVal(GameOver.prop.tag.XPPP).split(",")[0]);
			this.BUTTONPANEL.BTNOK.visible = true;
			this.BUTTONPANEL.BTNCELEBRATE.visible = true;
			if (Util.NumberVal(Sys.mydata.xplevel) > 10)
			{
				Util.SetText(this.INFO.FIELD, Lang.Get("total_xp") + "\n+" + Util.StringVal(GameOver.data.xp) + Lang.Get("xp"));
				if (this.INFO.FIELD.numLines == 1)
				{
					this.INFO.FIELD.y = 29;
				}
				if (this.INFO.FIELD.numLines == 2)
				{
					this.INFO.FIELD.y = 23;
				}
				if (this.INFO.FIELD.numLines == 3)
				{
					this.INFO.FIELD.y = 15;
				}
				if (this.INFO.FIELD.numLines == 4)
				{
					this.INFO.FIELD.y = 8;
				}
				if (this.INFO.FIELD.numLines >= 5)
				{
					this.INFO.FIELD.y = 0;
				}
			}
			else
			{
				Util.SetText(this.INFOLESSTEN.FIELD, Lang.Get(this.lessten_tips[Sys.mydata.xplevel - 1]));
				if (this.INFOLESSTEN.FIELD.numLines == 1)
				{
					this.INFOLESSTEN.FIELD.y = 23;
				}
				if (this.INFOLESSTEN.FIELD.numLines == 2)
				{
					this.INFOLESSTEN.FIELD.y = 18;
				}
				if (this.INFOLESSTEN.FIELD.numLines == 3)
				{
					this.INFOLESSTEN.FIELD.y = 13;
				}
				if (this.INFOLESSTEN.FIELD.numLines == 4)
				{
					this.INFOLESSTEN.FIELD.y = 9;
				}
				if (this.INFOLESSTEN.FIELD.numLines >= 5)
				{
					this.INFOLESSTEN.FIELD.y = 0;
				}
			}
			if (GameOver.istutorialplaying)
			{
				this.BUTTONPANEL.BTNCELEBRATE.SetLang("tut_btn_next");
				this.BUTTONPANEL.BTNCELEBRATE.AddEventClick(this.OnNextTab);
				this.BUTTONPANEL.BTNOK.visible = false;
				this.DrawTutorial();
			}
			else if (ppl == 1 && Boolean(GameOver.CheckGamePost()))
			{
				this.BUTTONPANEL.BTNCELEBRATE.SetLang("celebrate");
				this.BUTTONPANEL.BTNCELEBRATE.AddEventClick(this.OnCelebrateClick);
				this.BUTTONPANEL.BTNOK.visible = false;
			}
			else
			{
				this.BUTTONPANEL.BTNOK.SetLang("ok");
				this.BUTTONPANEL.BTNOK.AddEventClick(this.Hide);
				this.BUTTONPANEL.BTNCELEBRATE.visible = false;
			}
			if (this.DIVISIONLIST)
			{
				this.SetDivisionPanel();
			}
			if (Util.NumberVal(Sys.mydata.xplevel < 11))
			{
				this.HideDivisionAndPushToRight();
			}
			if (GameOver.data.place == 1)
			{
				if (ppp >= 100)
				{
					Sounds.PlayVoice("voice_full_map_victory");
				}
				else if (ppp >= 50)
				{
					Sounds.PlayVoice("voice_glorious_victory");
				}
				else
				{
					Sounds.PlayVoice("voice_victory");
				}
			}
			else if (GameOver.data.place == 2)
			{
				Sounds.PlayVoice("voice_you_came_in_second");
			}
			else if (GameOver.data.place == 3)
			{
				if (ppp == 0)
				{
					Sounds.PlayVoice("voice_you_have_been_destroyed");
				}
				else
				{
					Sounds.PlayVoice("voice_you_are_the_last");
				}
			}
			this.NPC.Set("CEREMONY_MASTER", "DEFAULT");
		}

		private function DrawSaveFrame():void
		{
			this.BUBBLELESSTEN.visible = false;
			this.INFOLESSTEN.visible = false;
			trace("Gameover.DrawSaveFrame");
			this.chat_visible = false;
			if (Util.NumberVal(Sys.mydata.xplevel) > 10)
			{
				Util.SetText(this.INFO.FIELD, Lang.Get("total_xp") + "\n+" + Util.StringVal(GameOver.save.xp) + Lang.Get("xp"));
				if (this.INFO.FIELD.numLines == 1)
				{
					this.INFO.FIELD.y = 29;
				}
				if (this.INFO.FIELD.numLines == 2)
				{
					this.INFO.FIELD.y = 23;
				}
				if (this.INFO.FIELD.numLines == 3)
				{
					this.INFO.FIELD.y = 15;
				}
				if (this.INFO.FIELD.numLines == 4)
				{
					this.INFO.FIELD.y = 8;
				}
				if (this.INFO.FIELD.numLines >= 5)
				{
					this.INFO.FIELD.y = 0;
				}
			}
			else
			{
				Util.SetText(this.INFOLESSTEN.FIELD, Lang.Get(this.lessten_tips[Sys.mydata.xplevel - 1]));
				if (this.INFOLESSTEN.FIELD.numLines == 1)
				{
					this.INFOLESSTEN.FIELD.y = 23;
				}
				if (this.INFOLESSTEN.FIELD.numLines == 2)
				{
					this.INFOLESSTEN.FIELD.y = 18;
				}
				if (this.INFOLESSTEN.FIELD.numLines == 3)
				{
					this.INFOLESSTEN.FIELD.y = 13;
				}
				if (this.INFOLESSTEN.FIELD.numLines == 4)
				{
					this.INFOLESSTEN.FIELD.y = 9;
				}
				if (this.INFOLESSTEN.FIELD.numLines >= 5)
				{
					this.INFOLESSTEN.FIELD.y = 0;
				}
			}
			this.SERIAL.Set("SERIES" + GameOver.serialframeid, "DEFAULT");
			this.BUTTONPANEL.BTNOK.SetLang("ok");
			this.BUTTONPANEL.BTNOK.AddEventClick(this.Hide);
			if (this.DIVISIONLIST)
			{
				this.SetDivisionPanel();
			}
			if (Util.NumberVal(Sys.mydata.xplevel < 11))
			{
				this.HideDivisionAndPushToRight();
			}
		}

		private function HideDivisionAndPushToRight():void
		{
			this.DIVISIONLIST.visible = false;
			this.LEAGUE.visible = false;
			this.NPC.x += 70;
			this.PAGE.x += 70;
			this.BUBBLE.visible = false;
			this.INFO.visible = false;
			this.BUBBLELESSTEN.visible = true;
			this.INFOLESSTEN.visible = true;
		}

		private function DrawSerialFrame():void
		{
			var sb:MovieClip = null;
			trace("Gaameover.DrawSerialFrame");
			Util.StopAllChildrenMov(this);
			this.chat_visible = false;
			Imitation.CollectChildren(this);
			var tag:Object = Sys.tag_brokenseries;
			this.BUTTONPANEL.BTNNO.SetCaption(Lang.Get("no"));
			this.BUTTONPANEL.BTNNO.AddEventClick(this.OnKeepClick);
			this.BUTTONPANEL.BTNOK.SetCaption(Lang.Get("yes"));
			this.BUTTONPANEL.BTNOK.AddEventClick(this.OnHelpClick);
			this.SERIAL.Set("SERIES" + GameOver.serialframeid, "DEFAULT");
			this.NPC.Set("CEREMONY_MASTER", "SAD");
			var freesb:* = Util.NumberVal(Sys.mydata.uls[Math.min(Util.NumberVal(Sys.mydata.shlevel) + 1, 5) + 15]) == 1;
			freesb &&= Util.NumberVal(Sys.mydata.freehelps[Math.min(Util.NumberVal(Sys.mydata.shlevel) + 1, 5) + 7]) > 0;
			Imitation.GotoFrame(this.BUTTONPANEL.SELECTOR, freesb ? 2 : 1);
			if (freesb)
			{
				sb = this.BUTTONPANEL.SELECTOR.BOOSTER;
				Imitation.GotoFrame(sb.ICON, "SERIES" + Math.min(Util.NumberVal(Sys.mydata.shlevel) + 1, 5));
				if (String("|tr|xa|").indexOf(Config.siteid) >= 0)
				{
					Imitation.GotoFrame(sb.ICON, "SERIES" + Math.min(Util.NumberVal(Sys.mydata.shlevel) + 1, 5) + "_TR");
				}
				sb.cacheAsBitmap = true;
				Util.SetText(this.BUTTONPANEL.SELECTOR.MINUS.FIELD, "-1");
				Imitation.FreeBitmapAll(sb);
				Imitation.UpdateAll(sb);
			}
			else
			{
				Util.SetText(this.BUTTONPANEL.SELECTOR.PRICE.FIELD, Util.StringVal(Util.FormatNumber(tag.PRICE)));
			}
			if (this.PIRATE_TXT)
			{
				Lang.Set(this.PIRATE_TXT.FIELD, "serial_boosters_small_tip");
				if (this.PIRATE_TXT.FIELD.numLines == 1)
				{
					this.PIRATE_TXT.FIELD.y = 29;
				}
				if (this.PIRATE_TXT.FIELD.numLines == 2)
				{
					this.PIRATE_TXT.FIELD.y = 23;
				}
				if (this.PIRATE_TXT.FIELD.numLines == 3)
				{
					this.PIRATE_TXT.FIELD.y = 15;
				}
				if (this.PIRATE_TXT.FIELD.numLines == 4)
				{
					this.PIRATE_TXT.FIELD.y = 8;
				}
				if (this.PIRATE_TXT.FIELD.numLines >= 5)
				{
					this.PIRATE_TXT.FIELD.y = 0;
				}
			}
			Util.SetText(this.XPCHANGE_OLD.VALUE.FIELD, "+" + Util.StringVal(GameOver.data.xp));
			Util.SetText(this.XPCHANGE_NEW.VALUE.FIELD, "+" + Util.StringVal(GameOver.save.xp));
			Lang.Set(this.XPCHANGE_OLD.XP.FIELD, "xp");
			Lang.Set(this.XPCHANGE_NEW.XP.FIELD, "xp");
		}

		private function DrawBrokenFrame():void
		{
			trace("Gaameover.DrawBrokenFrame");
			Imitation.CollectChildren(this);
			if (this.INFO)
			{
				Util.SetText(this.INFO.FIELD, Lang.Get("total_xp") + "\n+" + Util.StringVal(GameOver.data.xp) + Lang.Get("xp"));
				if (this.INFO.FIELD.numLines == 1)
				{
					this.INFO.FIELD.y = 29;
				}
				if (this.INFO.FIELD.numLines == 2)
				{
					this.INFO.FIELD.y = 23;
				}
				if (this.INFO.FIELD.numLines == 3)
				{
					this.INFO.FIELD.y = 15;
				}
				if (this.INFO.FIELD.numLines == 4)
				{
					this.INFO.FIELD.y = 8;
				}
				if (this.INFO.FIELD.numLines >= 5)
				{
					this.INFO.FIELD.y = 0;
				}
			}
			if (GameOver.istutorialplaying)
			{
				this.BUTTONPANEL.BTNOK.SetLang("tut_btn_next");
				this.BUTTONPANEL.BTNOK.AddEventClick(this.OnNextTab);
				this.DrawTutorial();
			}
			else
			{
				this.BUTTONPANEL.BTNOK.SetLang("ok");
				this.BUTTONPANEL.BTNOK.AddEventClick(function(e:*):void
					{
						Draw("SERIAL");
					});
			}
			trace(GameOver.serialframeid);
			this.SERIAL.Set("SERIES" + GameOver.serialframeid, "DEFAULT");
			this.NPC.Set("CEREMONY_MASTER", "DEFAULT");
			if (this.PIRATE_TXT)
			{
				Lang.Set(this.PIRATE_TXT.FIELD, "i_have_an_offer");
				if (this.PIRATE_TXT.FIELD.numLines == 1)
				{
					this.PIRATE_TXT.FIELD.y = 29;
				}
				if (this.PIRATE_TXT.FIELD.numLines == 2)
				{
					this.PIRATE_TXT.FIELD.y = 23;
				}
				if (this.PIRATE_TXT.FIELD.numLines == 3)
				{
					this.PIRATE_TXT.FIELD.y = 15;
				}
				if (this.PIRATE_TXT.FIELD.numLines == 4)
				{
					this.PIRATE_TXT.FIELD.y = 8;
				}
				if (this.PIRATE_TXT.FIELD.numLines >= 5)
				{
					this.PIRATE_TXT.FIELD.y = 0;
				}
			}
		}

		private function DrawFriendlyFrame():void
		{
			trace("Gaameover.DrawFriendlyFrame");
			this.BTNOK.SetLang("ok");
			this.BTNOK.AddEventClick(this.Hide);
			var tag:Object = GameOver.prop.tag;
			var ppl:int = int(data.placings.indexOf(data.iam));
			if (ppl == 1)
			{
				Lang.Set(this.INFO.FIELD, "friendly_game_info_win");
			}
			else
			{
				Lang.Set(this.INFO.FIELD, "friendly_game_info");
			}
			if (this.INFO.FIELD.numLines == 1)
			{
				this.INFO.FIELD.y = 23;
			}
			if (this.INFO.FIELD.numLines == 2)
			{
				this.INFO.FIELD.y = 18;
			}
			if (this.INFO.FIELD.numLines == 3)
			{
				this.INFO.FIELD.y = 13;
			}
			if (this.INFO.FIELD.numLines == 4)
			{
				this.INFO.FIELD.y = 9;
			}
			if (this.INFO.FIELD.numLines >= 5)
			{
				this.INFO.FIELD.y = 0;
			}
			Lang.Set(this.INFO2.FIELD, "friendly_game_info2");
			if (this.INFO2.FIELD.numLines == 1)
			{
				this.INFO2.FIELD.y = 23;
			}
			if (this.INFO2.FIELD.numLines == 2)
			{
				this.INFO2.FIELD.y = 18;
			}
			if (this.INFO2.FIELD.numLines == 3)
			{
				this.INFO2.FIELD.y = 13;
			}
			if (this.INFO2.FIELD.numLines == 4)
			{
				this.INFO2.FIELD.y = 9;
			}
			if (this.INFO2.FIELD.numLines >= 5)
			{
				this.INFO2.FIELD.y = 0;
			}
			this.NPC.Set("CEREMONY_MASTER", "DEFAULT");
			this.SERIAL.Set("VETERAN", "DEFAULT");
		}

		private function DrawMinitournamentFrame():void
		{
			this.BTNOK.SetLang("ok");
			this.BTNOK.AddEventClick(this.Hide);
			var tag:Object = GameOver.prop.tag;
			minitournament_tag = tag;
			var ppl:int = int(data.placings.indexOf(data.iam));
			mt_round = Util.NumberVal(tag.MTROUND);
			var mtfinished:* = Util.NumberVal(tag.MTFINISHED) != 0;
			Lang.Set(this.MT_TITLE.FIELD, "minitournament");
			Util.SetText(this.PAGE.TITLE.FIELD, "");
			if (mt_round == 2)
			{
				Lang.Set(this.PAGE.TITLE.FIELD, "semi_final");
				if (mtfinished)
				{
					Lang.Set(this.INFO.FIELD, "you_are_off_this_minitournament");
				}
				else
				{
					Lang.Set(this.INFO.FIELD, "minitournament_you_in_final");
				}
			}
			else if (mt_round == 3)
			{
				Lang.Set(this.PAGE.TITLE.FIELD, "final");
				Lang.Set(this.INFO.FIELD, "minitournament_msg_place_" + ppl);
			}
			else
			{
				Lang.Set(this.PAGE.TITLE.FIELD, "qualifying");
				if (mtfinished)
				{
					Lang.Set(this.INFO.FIELD, "you_are_off_this_minitournament");
				}
				else
				{
					Lang.Set(this.INFO.FIELD, "minitournament_you_in_semifinal");
				}
			}
			if (this.INFO.FIELD.numLines == 1)
			{
				this.INFO.FIELD.y = 29;
			}
			if (this.INFO.FIELD.numLines == 2)
			{
				this.INFO.FIELD.y = 23;
			}
			if (this.INFO.FIELD.numLines == 3)
			{
				this.INFO.FIELD.y = 15;
			}
			if (this.INFO.FIELD.numLines == 4)
			{
				this.INFO.FIELD.y = 8;
			}
			if (this.INFO.FIELD.numLines >= 5)
			{
				this.INFO.FIELD.y = 0;
			}
			this.NPC.Set("CEREMONY_MASTER", "DEFAULT");
			this.UpdateMinitournamentState();
			this.ShowMinitournamentTrophies(ppl);
		}

		private function DrawTournamentFrame():void
		{
			this.BTNOK.SetLang("ok");
			this.BTNOK.AddEventClick(this.Hide);
			this.BTNOK.SetCaption(Util.FormatRemaining(this.tournament_counter));
			this.tournament_close_timer = new Timer(1000, 0);
			Util.AddEventListener(this.tournament_close_timer, TimerEvent.TIMER, this.OnTournamentCloseTimer);
			this.tournament_close_timer.start();
			var tag:Object = GameOver.prop.tag;
			tournament_tag = tag;
			if (Boolean(Sys.tag_tournament) && Sys.tag_tournament.length > 0)
			{
				this.INFO.FIELD.text = Sys.tag_tournament[0].TITLE;
			}
			else
			{
				this.INFO.FIELD.text = "";
			}
			Util.SetText(this.PAGE.TITLE.FIELD, "");
			if (this.INFO.FIELD.numLines == 1)
			{
				this.INFO.FIELD.y = 29;
			}
			if (this.INFO.FIELD.numLines == 2)
			{
				this.INFO.FIELD.y = 23;
			}
			if (this.INFO.FIELD.numLines == 3)
			{
				this.INFO.FIELD.y = 15;
			}
			if (this.INFO.FIELD.numLines == 4)
			{
				this.INFO.FIELD.y = 8;
			}
			if (this.INFO.FIELD.numLines >= 5)
			{
				this.INFO.FIELD.y = 0;
			}
			this.NPC.Set("CEREMONY_MASTER", "DEFAULT");
		}

		public function OnTournamentCloseTimer(e:TimerEvent):void
		{
			--this.tournament_counter;
			this.BTNOK.SetCaption(Util.FormatRemaining(this.tournament_counter));
			if (this.tournament_counter <= 0)
			{
				this.Hide();
			}
		}

		public function Draw(_frame:String):void
		{
			this._frame = _frame;
			Util.StopAllChildrenMov(this);
			TweenMax.killTweensOf(this);
			GameOver.firstshowing = true;
			GameOver.autoplay = !GameOver.istutorialplaying;
			Imitation.CollectChildrenAll(this);
			Imitation.GotoFrame(GameOver.mc, _frame);
			Util.StopAllChildrenMov(this.PAGE);
			if (Boolean(GameOver.issaving) && _frame == "BROKEN")
			{
				GameOver.data = GameOver.GetGameOverData();
				GameOver.save = GameOver.GetLastGameOverData();
				this.DrawBrokenFrame();
			}
			else if (_frame == "COMPETITION")
			{
				GameOver.data = GameOver.GetGameOverData();
				lastxpchange = GameOver.data.xp;
				this.DrawCompetitionFrame();
			}
			else if (_frame == "FRIENDLY")
			{
				GameOver.data = GameOver.GetGameOverData();
				this.DrawFriendlyFrame();
			}
			else if (_frame == "MINITOURNAMENT")
			{
				GameOver.data = GameOver.GetGameOverData();
				this.DrawMinitournamentFrame();
			}
			else if (_frame == "TOURNAMENT")
			{
				GameOver.data = GameOver.GetGameOverData();
				this.DrawTournamentFrame();
			}
			else if (_frame == "SERIAL")
			{
				GameOver.save = GameOver.GetLastGameOverData();
				this.DrawSerialFrame();
			}
			else if (_frame == "SAVE")
			{
				lastxpchange = GameOver.save.xp;
				this.DrawSaveFrame();
			}
			this.SetActivePage(this.currentFrame == 4 ? 4 : 1);
			if (GameOver.istutorialplaying)
			{
				this.TABS.Freeze();
			}
		}

		private function DrawTabs():void
		{
			var i:int = 0;
			var v:String = null;
			var tab:* = undefined;
			var enabled:Boolean = false;
			if (this.tabs_ready)
			{
				return;
			}
			this.tabs_ready = true;
			var d:Object = this.currentFrame == 2 || this.currentFrame == 4 ? GameOver.save : GameOver.data;
			var values:Array = [null, Util.NumberVal(Sys.mydata.xplevel) <= 10 ? "100" : Util.StringVal(d.basexp), Util.StringVal(d.pppxp), Util.StringVal(d.opplevelxp), d.xpcw + d.xpcw2, Util.StringVal(d.allyxp)];
			this.TABS.Set(["gameover_tab1", "gameover_tab2", "gameover_tab3", "gameover_tab4", "gameover_tab5", "gameover_tab6", "missions", "chat"], ["GAME_OVER_TAB1", "GAME_OVER_TAB2", "GAME_OVER_TAB3", "GAME_OVER_TAB4", "CLAN", "GAME_OVER_TAB6", "SWORDS", "HELP_CHAT"], this.OnLegoTabClick, GameOver.currentpage);
			for (i = 1; i <= 8; i++)
			{
				v = values[i];
				tab = this.TABS["TTAB" + i];
				enabled = i <= 2 || i == 8 || Util.NumberVal(Sys.mydata.xplevel) >= 11;
				if (this.tabs[i - 1] == 10)
				{
					tab.visible = this.chat_visible;
				}
				if (enabled)
				{
					this.TABS.UnlockTab(tab);
				}
				else
				{
					this.TABS.LockTab(tab);
				}
				if (v != null)
				{
					this.TABS.SetValue(tab, String(v));
				}
			}
			var Game:* = Modules.GetClass("triviador", "triviador.Game");
			var anychat:* = Game && Game.iam && Game.players[Game.iam] && Game.players[Game.iam].chatstate == 0 && (Game.players[Game.myopp1].chatstate == 0 || Game.players[Game.myopp2].chatstate == 0);
			if (GameOver.gametype == "FRIENDLY" && anychat)
			{
				this.TABS.Reorder([this.TABS.TTAB1, this.TABS.TTAB8, this.TABS.TTAB2, this.TABS.TTAB3, this.TABS.TTAB4, this.TABS.TTAB5, this.TABS.TTAB6, this.TABS.TTAB7], [true, this.TABS.TTAB8.visible, false, false, false, false, false, false]);
			}
			else if (GameOver.gametype != "NORMAL" && GameOver.gametype != "LONG" || Util.NumberVal(Sys.mydata.xplevel) < Config.ULL_CHAT)
			{
				this.TABS.Reorder([this.TABS.TTAB1, this.TABS.TTAB2, this.TABS.TTAB3, this.TABS.TTAB4, this.TABS.TTAB5, this.TABS.TTAB6, this.TABS.TTAB7, this.TABS.TTAB8], [false, false, false, false, false, false, false, false]);
			}
			Imitation.FreeBitmapAll(this.TABS);
			Imitation.UpdateAll(this.TABS);
		}

		public function OnLegoTabClick(_pagenumber:Number):*
		{
			trace("OnLegoTabClick: " + _pagenumber);
			this.SetActivePage(_pagenumber);
		}

		public function SetActivePage(_pagenum:int):void
		{
			trace("SetActivePage: " + _pagenum);
			if (!GameOver.mc)
			{
				return;
			}
			GameOver.currentpage = this.tabs[_pagenum - 1];
			this.StepPage();
		}

		private function StepPage():void
		{
			if (!GameOver.mc)
			{
				return;
			}
			trace(GameOver.currentpage);
			var w:MovieClip = this.PAGE;
			Util.StopAllChildrenMov(w);
			for (var i:int = w.numChildren - 1; i >= 0; i--)
			{
				w.getChildAt(i).visible = false;
			}
			w.TITLE.visible = true;
			this.DrawTabs();
			var data:Object = this.currentFrame == 2 || this.currentFrame == 4 ? GameOver.save : GameOver.data;
			if (GameOver.currentpage == 1)
			{
				if (this._frame != "MINITOURNAMENT" || this._frame != "TOURNAMENT" || this._frame != "FRIENDLY")
				{
					this.PAGE.TITLE.visible = false;
				}
				this.DrawPodium(w, true, data);
				return;
			}
			if (GameOver.currentpage == 2)
			{
				Lang.Set(w.TITLE.FIELD, "conquer_bonus");
				this.DrawConquerBonus(w, data);
			}
			else if (GameOver.currentpage == 3)
			{
				Lang.Set(w.TITLE.FIELD, "opponent_bonus");
				this.DrawOpponentBonus(w, data);
			}
			else if (GameOver.currentpage == 4)
			{
				Lang.Set(w.TITLE.FIELD, "serial_bonus");
				this.DrawSerials(w, data);
			}
			else if (GameOver.currentpage == 5)
			{
				Lang.Set(w.TITLE.FIELD, "clan_bonus");
				this.DrawClanBonus(w, data);
			}
			else if (GameOver.currentpage == 6)
			{
				this.DrawQuestions(w, data);
				w.TITLE.visible = false;
			}
			else if (GameOver.currentpage != 7)
			{
				if (GameOver.currentpage == 9)
				{
					w.TITLE.visible = false;
					this.DrawMissions();
				}
				else if (GameOver.currentpage == 10)
				{
					Lang.Set(w.TITLE.FIELD, "chat");
					this.DrawChat(w, data);
				}
			}
			this.PAGE.TITLE.visible = false;
		}

		public function DrawMissions():void
		{
			this.PAGE.MISSION_LIST.visible = true;
			this.PAGE.MISSION_LIST.cacheAsBitmap = false;
			this.PAGE.MISSION_LIST.Start();
			Imitation.CollectChildrenAll(this.PAGE);
			Imitation.FreeBitmapAll(this.PAGE);
		}

		private function DrawPodium(_page:MovieClip, _anim:Boolean, _data:Object):void
		{
			var i:uint = 0;
			var unknown:Boolean = false;
			var a:* = undefined;
			var Game:* = undefined;
			if (!GameOver.mc || GameOver.currentpage != 1)
			{
				return;
			}
			var leftgame:* = Sys.screen == "LEFTGAME";
			var w:MovieClip = _page.PODIUM;
			var tag:Object = GameOver.prop.tag;
			var placings:* = _data.placings;
			var pname:String = "";
			var myplace:Number = 0;
			var issaving:Boolean = this.currentFrame == 2 || this.currentFrame == 4;
			w.visible = true;
			var pnames:Object = {};
			pnames[_data.iam] = Lang.Get("me");
			pnames[_data.opp1] = Romanization.ToLatin(_data.opp1name);
			pnames[_data.opp2] = Romanization.ToLatin(_data.opp2name);
			if (GameOver.gametype == "TOURNAMENT")
			{
				for (i = 1; i <= 3; i++)
				{
					pnames[placings[i]] = tag["NAME" + placings[i]];
				}
				_page.TITLE.visible = false;
			}
			var pids:Object = {};
			pids[_data.iam] = Sys.mydata.id;
			pids[_data.opp1] = _data.opp1userid;
			pids[_data.opp2] = _data.opp2userid;
			var xps:Object = {};
			xps[_data.iam] = _data.basexp;
			xps[_data.opp1] = _data.opp1basexp;
			xps[_data.opp2] = _data.opp2basexp;
			for (i = 1; i <= 3; i++)
			{
				unknown = leftgame && pids[placings[i]] != Sys.mydata.id;
				if (unknown)
				{
					pname = "";
				}
				else
				{
					pname = pnames[placings[i]];
				}
				w["P" + i].gotoAndStop(unknown ? 4 : placings[i]);
				Util.SetText(w["P" + i].NAME.FIELD, pname);
				Util.SetText(w["P" + i].NAME.FIELD, pname);
				Util.SetText(w["P" + i].NAME.FIELD, pname);
				if ((GameOver.gametype == "NORMAL" || GameOver.gametype == "LONG") && Util.NumberVal(Sys.mydata.xplevel) > 10)
				{
					Util.SetText(w["XP" + i].FIELD, xps[placings[i]]);
					Util.SetText(w["C_XP" + i].FIELD, Lang.Get("xp"));
				}
				else
				{
					w["XP" + i].visible = false;
					w["C_XP" + i].visible = false;
					w["XP_BG" + i].visible = false;
				}
				a = w["P" + i].AVATAR;
				if (a)
				{
					Game = Modules.GetClass("triviador", "triviador.Game");
					a.AVATAR.mt = Game && Game.roomtype == "M" || Game.roomtype == "T";
					a.gotoAndStop(unknown ? 4 : placings[i]);
					if (issaving && pids[placings[i]] != Sys.mydata.id)
					{
						a.AVATAR.ShowDoll();
					}
					else if (unknown)
					{
						a.AVATAR.Clear();
						a.AVATAR.gotoAndStop(3);
					}
					else
					{
						a.AVATAR.ShowUID(pids[placings[i]]);
					}
					if (pids[placings[i]] == Sys.mydata.id)
					{
						myplace = i;
					}
				}
			}
			if (this._frame == "FRIENDLY")
			{
				this.INFO.visible = this.INFOBG.visible = true;
				this.INFO2.visible = this.INFOBG2.visible = true;
				if (this.PAGE.TITLE)
				{
					this.PAGE.TITLE.visible = false;
				}
			}
			_page.cacheAsBitmap = false;
			Imitation.CollectChildrenAll(_page);
			Imitation.FreeBitmapAll(_page);
		}

		private function DrawConquerBonus(_page:MovieClip, _data:Object):void
		{
			var u:MovieClip = null;
			var per:Number = NaN;
			var basexp:Number = NaN;
			var pid:Number = NaN;
			var pname:String = null;
			var ppoints:Number = NaN;
			if (!GameOver.mc || GameOver.currentpage != 2)
			{
				return;
			}
			var w:MovieClip = _page.CONQUER;
			var p:Object = GameOver.prop;
			var issaving:Boolean = this.currentFrame == 2 || this.currentFrame == 4;
			var placings:* = _data.placings;
			w.visible = true;
			for (var i:uint = 1; i <= 3; i++)
			{
				u = w["U" + i];
				per = 0;
				basexp = 0;
				pid = 0;
				pname = "";
				ppoints = 0;
				if (_data.iam == i)
				{
					basexp = Util.NumberVal(_data.basexp);
					pid = Util.NumberVal(Sys.mydata.id);
					pname = Romanization.ToLatin(Util.StringVal(Sys.mydata.name));
					ppoints = Util.NumberVal(_data.points);
					u.gotoAndStop(1);
					u.BG.gotoAndStop(Util.NumberVal(p.iam));
					u.BG.alpha = 1;
					per = Util.NumberVal(_data.pointpercent);
					Util.SetText(u.XP.FIELD, _data.pppxp);
				}
				else
				{
					basexp = Util.NumberVal(_data.opp1) == i ? Util.NumberVal(_data.opp1basexp) : Util.NumberVal(_data.opp2basexp);
					pid = Util.NumberVal(_data.opp1) == i ? Util.NumberVal(_data.opp1userid) : Util.NumberVal(_data.opp2userid);
					pname = Romanization.ToLatin(Util.NumberVal(_data.opp1) == i ? _data.opp1name : _data.opp2name);
					ppoints = Util.NumberVal(_data.opp1) == i ? Util.NumberVal(_data.opp1points) : Util.NumberVal(_data.opp2points);
					u.gotoAndStop(2);
					u.BG.gotoAndStop(i);
					u.BG.alpha = 1;
					per = Util.NumberVal(_data.opp1) == i ? Util.NumberVal(_data.opp1ppp) : Util.NumberVal(_data.opp2ppp);
					Util.SetText(u.XP.FIELD, "" + Math.round(Util.NumberVal(_data.opp1) == i ? Util.NumberVal(_data.opp1pppxp) : Util.NumberVal(_data.opp2pppxp)));
				}
				if (issaving && i != _data.iam)
				{
					u.AVATAR.ShowDoll();
					Util.SetText(u.NAME.FIELD, pname);
				}
				else
				{
					u.AVATAR.ShowUID(pid);
					Util.SetText(u.NAME.FIELD, pname);
				}
				Util.SetText(u.BASEXP.FIELD, String(basexp) + Lang.Get("xp"));
				Util.SetText(u.C_XP.FIELD, Lang.Get("xp"));
				Util.SetText(u.POINTS.FIELD, ppoints.toString());
				Util.SetText(u.PER.FIELD, (per * 100).toFixed(1) + "%");
			}
			Imitation.CollectChildrenAll(_page);
			Imitation.FreeBitmapAll(_page);
		}

		private function DrawSerials(_page:MovieClip, _data:Object):void
		{
			var s:MovieClip = null;
			var c:Number = NaN;
			var p:* = false;
			if (!GameOver.mc || GameOver.currentpage != 4)
			{
				return;
			}
			var w:MovieClip = _page.SERIAL;
			var data:* = _data.lastplaces;
			var won:Number = Util.NumberVal(_data.curcwins);
			var noloss:Number = Util.NumberVal(_data.curcwins2);
			var n:int = Math.min(data.length, 10);
			w.visible = true;
			for (var i:uint = 0; i < 10; i++)
			{
				s = w["S" + (i + 1)];
				if (i < n)
				{
					c = data[i] & 3;
					p = (data[i] & 8) == 8;
					s.gotoAndStop(c);
					s.visible = true;
				}
				else
				{
					s.visible = false;
				}
			}
			w.WON.visible = false;
			w.NOLOSS.visible = false;
			if (won)
			{
				w.WON.visible = true;
				w.WON.OBJ.x = w["S" + Math.min(10, won)].x - w.S10.x;
			}
			if (noloss)
			{
				w.NOLOSS.visible = true;
				w.NOLOSS.OBJ.x = w["S" + Math.min(10, noloss)].x - w.S10.x;
			}
			Lang.Set(w.C_ALLWINS.FIELD, "serial_win+:");
			Lang.Set(w.C_ALLNOLOSS.FIELD, "serial_noloss+:");
			w.ALLWINS.FIELD.text = won;
			w.ALLNOLOSS.FIELD.text = noloss;
			Lang.Set(w.SERIALWIN.FIELD, "serial_win_bonus");
			Lang.Set(w.SERIALNOLOSS.FIELD, "serial_noloss_bonus");
			w.BROKEN.visible = GameOver.issaving && this.currentFrame == 3;
			Imitation.GotoFrame(w.BROKEN, noloss > 0 ? 2 : 1);
			Util.SetText(w.NUM1.NUM, Util.StringVal(_data.xpcw));
			Util.SetText(w.NUM2.NUM, Util.StringVal(_data.xpcw2));
			var result:Number = Util.NumberVal(_data.xpcw) + Util.NumberVal(_data.xpcw2);
			Util.SetText(w.RESULT.FIELD, "+" + Util.StringVal(result) + " " + Lang.Get("xp"));
			w.cacheAsBitmap = true;
			Imitation.CollectChildrenAll(_page);
			Imitation.FreeBitmapAll(_page);
		}

		private function DrawOpponentBonus(_page:MovieClip, _data:Object):void
		{
			if (!GameOver.mc || GameOver.currentpage != 3)
			{
				return;
			}
			var w:MovieClip = _page.OPPONENT;
			var p:Object = GameOver.prop;
			var issaving:Boolean = this.currentFrame == 2 || this.currentFrame == 4;
			w.visible = true;
			w.USER1.gotoAndStop(int(p.myopp1));
			w.USER2.gotoAndStop(int(p.myopp2));
			Lang.Set(w.USER1.LEVEL.FIELD, "level_n", _data.opp1xplevel);
			Lang.Set(w.USER2.LEVEL.FIELD, "level_n", _data.opp2xplevel);
			Util.SetText(w.USER1.NAME.FIELD, Romanization.ToLatin(Util.StringVal(_data.opp1name)));
			Util.SetText(w.USER2.NAME.FIELD, Romanization.ToLatin(Util.StringVal(_data.opp2name)));
			if (issaving)
			{
				w.USER1.AVATAR.ShowDoll();
				w.USER2.AVATAR.ShowDoll();
			}
			else
			{
				w.USER1.AVATAR.ShowUID(_data.opp1userid);
				w.USER2.AVATAR.ShowUID(_data.opp2userid);
			}
			var per:Number = Util.NumberVal(_data.opp1xplevel) / 2 + Util.NumberVal(_data.opp2xplevel) / 2;
			var basexp:Number = Util.NumberVal(_data.basexp);
			var result:Number = basexp * per / 100;
			Lang.Set(w.C_BASEXP.FIELD, "base_xp");
			Util.SetText(w.BASEXP.FIELD, String(basexp));
			Lang.Set(w.C_AVG.FIELD, "average_level");
			Util.SetText(w.AVG.FIELD, String(per));
			Util.SetText(w.PER.FIELD, String(per) + " %");
			Util.SetText(w.RESULT.FIELD, "+ " + Math.round(result) + " " + Lang.Get("xp"));
			Imitation.CollectChildrenAll(_page);
			Imitation.FreeBitmapAll(_page);
		}

		private function DrawClanBonus(_page:MovieClip, _data:Object):void
		{
			var allxp:Number = NaN;
			if (!GameOver.mc || GameOver.currentpage != 5)
			{
				return;
			}
			var w:MovieClip = _page.CLAN;
			if (Boolean(GameOver.clanprop) && Boolean(GameOver.clanprop.alliance))
			{
				allxp = 0;
				w.visible = true;
				Util.SetText(w.V1.FIELD, Util.StringVal(_data.basexp));
				allxp += Util.NumberVal(_data.basexp);
				Util.SetText(w.V2.FIELD, Util.StringVal(_data.pppxp));
				allxp += Util.NumberVal(_data.pppxp);
				Util.SetText(w.V3.FIELD, _data.opplevelxp);
				allxp += Util.NumberVal(_data.opplevelxp);
				Util.SetText(w.V4.FIELD, String(_data.xpcw + _data.xpcw2));
				allxp += Util.NumberVal(_data.xpcw);
				allxp += Util.NumberVal(_data.xpcw2);
				Util.SetText(w.ALLXP.FIELD, Util.StringVal(allxp));
				Util.SetText(w.C_XP.FIELD, Lang.Get("xp"));
				Util.SetText(w.C_ACTIVENUM.FIELD, Lang.Get("active_members+:"));
				Util.SetText(w.ACTIVENUM.FIELD, Util.StringVal(GameOver.clanprop.alliance.actives));
				Util.SetText(w.C_CLAN_BONUS.FIELD, Lang.Get("clan_bonus"));
				Util.SetText(w.ALLXP2.FIELD, Util.StringVal(allxp) + Lang.Get("xp"));
				Util.SetText(w.PER.FIELD, _data.allylevel + "%");
				Util.SetText(w.RESULT.FIELD, _data.allyxp);
				Util.SetText(w.RESULT_XP.FIELD, Lang.Get("xp"));
				Util.SetText(w.C_TOTAL_XP.FIELD, Lang.Get("total_xp"));
				Util.SetText(w.RESULT2.FIELD, Util.StringVal(allxp) + Lang.Get("xp"));
				Util.SetText(w.PER2.FIELD, _data.allyxp + Lang.Get("xp"));
				Util.SetText(w.ALL_RESULT.FIELD, Util.StringVal(GameOver.data.xp));
				Util.SetText(w.ALL_RESULT_XP.FIELD, Lang.Get("xp"));
				w.cacheAsBitmap = true;
				Imitation.CollectChildrenAll(_page);
				Imitation.FreeBitmapAll(_page);
			}
			else
			{
				_page.CLAN.visible = false;
				_page.NO_CLAN.visible = true;
				Util.SetText(_page.NO_CLAN.LABEL.FIELD, Lang.Get("gameover_noclan"));
			}
		}

		private function DrawQuestions(_page:MovieClip, _data:Object):void
		{
			var r:Number = NaN;
			var s:String = null;
			if (!GameOver.mc || GameOver.currentpage != 6)
			{
				return;
			}
			var w:MovieClip = _page.QUESTION;
			w.visible = true;
			Util.SetText(w.ANSCNT.CAPTION.FIELD, Lang.Get("your_answer_count"));
			Util.SetText(w.GOODANSCNT.CAPTION.FIELD, Lang.Get("your_good_answer_count"));
			Util.SetText(w.ANSRATIO.CAPTION.FIELD, Lang.Get("your_good_answer_ratio"));
			Util.SetText(w.TIPCNT.CAPTION.FIELD, Lang.Get("your_tip_count"));
			Util.SetText(w.GOODTIPCNT.CAPTION.FIELD, Lang.Get("your_won_tip_count"));
			Util.SetText(w.TIPRATIO.CAPTION.FIELD, Lang.Get("avg_tip_precision"));
			Util.SetText(w.ANSCNT.VALUE.FIELD, _data.answercount);
			Util.SetText(w.GOODANSCNT.VALUE.FIELD, _data.goodanswers);
			if (_data.answercount > 0)
			{
				r = Math.round(10000 * _data.goodanswers / _data.answercount) / 100;
			}
			else
			{
				r = 0;
			}
			Util.SetText(w.ANSRATIO.VALUE.FIELD, r.toFixed(0) + "%");
			Util.SetText(w.TIPCNT.VALUE.FIELD, _data.tipcount);
			Util.SetText(w.GOODTIPCNT.VALUE.FIELD, _data.tipwins);
			if (_data.tipvepcount > 0)
			{
				Util.SetText(w.TIPRATIO.VALUE.FIELD, Math.round(100 * _data.tipveptotal / _data.tipvepcount / 100).toFixed(0) + "%");
			}
			else
			{
				Util.SetText(w.TIPRATIO.VALUE.FIELD, "-");
			}
			w.cacheAsBitmap = true;
			Imitation.CollectChildrenAll(_page);
			Imitation.FreeBitmapAll(_page);
		}

		private function DrawTutorial():void
		{
			Util.SetText(this.INFO.FIELD, this.tutorialtexts[this.tutorialindex]);
			if (this.INFO.FIELD.numLines == 1)
			{
				this.INFO.FIELD.y = 29;
			}
			if (this.INFO.FIELD.numLines == 2)
			{
				this.INFO.FIELD.y = 23;
			}
			if (this.INFO.FIELD.numLines == 3)
			{
				this.INFO.FIELD.y = 15;
			}
			if (this.INFO.FIELD.numLines == 4)
			{
				this.INFO.FIELD.y = 8;
			}
			if (this.INFO.FIELD.numLines >= 5)
			{
				this.INFO.FIELD.y = 0;
			}
			++this.tutorialindex;
			trace("DrawTutorial: " + this.tutorialindex);
			this.TABS.callback = null;
			this.TABS.Freeze();
			if (this.tabs_ready)
			{
				this.TABS.SetActiveTab(MovieClip(this.TABS["TTAB" + this.tutorialindex]));
			}
			if (this.tutorialindex >= this.tutorialtexts.length)
			{
				GameOver.istutorialplaying = false;
				if (this.BUTTONPANEL.BTNCELEBRATE)
				{
					this.BUTTONPANEL.BTNCELEBRATE.SetLang("ok");
					this.BUTTONPANEL.BTNCELEBRATE.AddEventClick(this.Hide);
				}
				if (this.BUTTONPANEL.BTNOK)
				{
					this.BUTTONPANEL.BTNOK.SetLang("ok");
					this.BUTTONPANEL.BTNOK.AddEventClick(function(e:*):void
						{
							Draw("SERIAL");
						});
				}
			}
		}

		private function DrawChat(_page:MovieClip, _data:Object):void
		{
			var w:MovieClip = _page.CHAT;
			w.visible = true;
			_page.cacheAsBitmap = false;
			w.GoBottom();
			if (this._frame == "FRIENDLY")
			{
				this.INFO.visible = this.INFOBG.visible = false;
				this.INFO2.visible = this.INFOBG2.visible = false;
			}
			Imitation.CollectChildrenAll(_page);
			Imitation.FreeBitmapAll(_page);
		}

		private function ShowMinitournamentTrophies(ppl:int):*
		{
			var places:* = undefined;
			var numcups:int = 0;
			var i:int = 0;
			var tag:* = minitournament_tag;
			var mtfinished:* = Util.NumberVal(tag.MTFINISHED) != 0;
			if (mt_round == 3)
			{
				this.TROPHIES.gotoAndStop("WIN");
				this.TROPHIES.CUP.gotoAndStop(ppl);
			}
			else if (mtfinished)
			{
				places = [["10-18", "19-27"], ["4-6", "7-9"]];
				this.TROPHIES.gotoAndStop("OUT");
				Lang.Set(this.TROPHIES.OUTTEXT.FIELD, "try_next_time");
				Lang.Set(this.TROPHIES.C_YOURPLACE.FIELD, "your_place");
				this.TROPHIES.YOURPLACE.FIELD.text = places[mt_round - 1][ppl - 2];
				Imitation.FreeBitmapAll(this.TROPHIES.YOURPLACE);
				Imitation.UpdateAll(this.TROPHIES.YOURPLACE);
			}
			else
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
			Imitation.FreeBitmapAll(this.TROPHIES);
			Imitation.UpdateAll(this.TROPHIES);
		}

		private function UpdateMinitournamentState(e:Object = null):void
		{
			if (!mc)
			{
				return;
			}
			var MinitournamentWin:Object = prop.minitournamentwin;
			if (!MinitournamentWin)
			{
				return;
			}
			var sm:MovieClip = mc.MTOURSTATE;
			sm.visible = true;
			if (MinitournamentWin.state <= 2 && mt_round < 3)
			{
				sm.gotoAndStop("GAMESRUNNING");
				Lang.Set(sm.INFO.FIELD, "minitournament_soon_" + (mt_round + 1));
			}
			else
			{
				sm.gotoAndStop("FINISHED");
				Lang.Set(sm.CAPTION.FIELD, "minitournament_finished");
			}
		}

		public function OnTimer(e:TimerEvent):void
		{
			var rem:String = null;
			var now:Number = NaN;
			var dif:int = 0;
			if (!GameOver.mc)
			{
				return;
			}
			if (gametype != "MINITOURNAMENT")
			{
				return;
			}
			var MinitournamentWin:Object = prop.minitournamentwin;
			var sm:MovieClip = mc.MTOURSTATE;
			if (Boolean(sm) && sm.currentFrameLabel == "REMAINING")
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
				if (sm.REMAINING.text != rem)
				{
					sm.REMAINING.text = rem;
				}
			}
		}

		private function OnHelpClick(e:Object = null):void
		{
			if (this.BUTTONPANEL.BTNNO)
			{
				this.BUTTONPANEL.BTNNO.btnenabled = false;
			}
			var tag:Object = Sys.tag_brokenseries;
			Comm.SendCommand("SERIESHELP", "CMD=\"USE\" GAMEID=\"" + Util.StringVal(tag.GAMEID) + "\"", this.OnHelpResult, this);
		}

		private function OnHelpResult(_res:int, _xml:XML):void
		{
			if (this.BUTTONPANEL.BTNNO)
			{
				this.BUTTONPANEL.BTNNO.btnenabled = true;
			}
			if (this.BUTTONPANEL.BTNOK)
			{
				this.BUTTONPANEL.BTNOK.btnenabled = true;
			}
			if (_res == 77)
			{
				WinMgr.OpenWindow("bank.Bank", {"funnelid": "GameOver"});
			}
			else
			{
				this.Draw("SAVE");
			}
		}

		public function OnKeepClick(e:Object = null):void
		{
			var tag:Object = Sys.tag_brokenseries;
			Comm.SendCommand("SERIESHELP", "GAMEID=\"" + Util.StringVal(tag.GAMEID) + "\"", this.OnKeepResult);
			JsQuery.Load(JsQuery.Dummy, [], "client_castle.php?stoc=" + Config.stoc + "&cmd=closecwins");
		}

		public function OnKeepResult(_res:int = -1, _xml:XML = null):void
		{
			if (GameOver.issaving)
			{
				GameOver.issaving = false;
				this.Draw("COMPETITION");
			}
		}

		private function OnNextTab(e:Object = null):void
		{
			trace("OnNextTab");
			var p:Number = Number(this.tabs[this.tabs.indexOf(GameOver.currentpage) + 1]);
			if (GameOver.istutorialplaying)
			{
				p = this.tutorialindex + 1;
				this.DrawTutorial();
			}
			if (GameOver.currentpage != this.tabs[this.tabs.length - 1])
			{
				this.SetActivePage(p);
			}
			else if (GameOver.issaving)
			{
				this.Draw("BROKEN");
			}
			else
			{
				this.Draw("COMPETITION");
			}
		}

		private function OnCelebrateClick(e:Object = null):void
		{
			this.Hide();
		}

		private function OnVideoAdsAvailable(e:Event):void
		{
			DBG.Trace("GameOver:OnVideoAdsAvailable");
			if (!this.videoad_available)
			{
				this.videoad_available = true;
				Util.ExternalCall("TrackState", "GAMEOVER_RESPONSE", "");
			}
		}

		public function AfterOpen():void
		{
			Imitation.FreeBitmapAll(this.TABS.TTAB1);
			Imitation.UpdateAll(this.TABS.TTAB1);
			Util.AddEventListener(this.mtupdatetimer, TimerEvent.TIMER, this.OnTimer);
			this.mtupdatetimer.start();
			var xplevel:int = Util.NumberVal(Sys.mydata.xplevel);
			this.videoad_available = false;
			if (!Config.ios)
			{
				if (GameOver.prop.type == "GAME" && GameOver.gametype != "TOURNAMENT" && GameOver.gametype != "MINITOURNAMENT" && xplevel >= 10)
				{
					DBG.Trace("GameOver:AfterOpen, VIDEOAD_QUERY_VIDEO");
					Imitation.AddStageEventListener("VIDEOAD_VIDEO_AVAILABLE", this.OnVideoAdsAvailable);
					Imitation.DispatchStageEvent(null, new CustomEvent("VIDEOAD_QUERY_VIDEO", {"userid": Sys.mydata.id}));
					Util.ExternalCall("TrackState", "GAMEOVER_REQUEST", "");
				}
			}
			Imitation.CollectChildrenAll(this.PAGE);
			Imitation.FreeBitmapAll(this.PAGE);
			if (this.DIVISIONLIST)
			{
				Imitation.FreeBitmapAll(this.DIVISIONLIST);
			}
		}

		public function AfterClose():void
		{
			var village:Object = null;
			var xplevel:int = 0;
			Sys.tag_brokenseries = null;
			GameOverChat.Remove();
			var backtowh:String = "";
			if (this.videoad_play)
			{
				this.videoad_play = false;
				village = Modules.GetClass("villagemap", "villagemap.VillageMap");
				if (Config.mobile && village != null && Boolean(village.hasOwnProperty("AutoStartVideoAd")))
				{
					village.AutoStartVideoAd = true;
					backtowh = "WH=\"VILLAGE\"";
				}
				else
				{
					if (village != null && village.mc != null)
					{
						village.mc.PauseAllSounds();
						village.clientVisible = false;
					}
					Platform.silentactivate = true;
					Imitation.DispatchStageEvent("VIDEOAD_START_VIDEO");
				}
			}
			else
			{
				xplevel = Util.NumberVal(Sys.mydata.xplevel);
				if (!Config.mobile && GameOver.prop.type == "GAME" && GameOver.gametype != "MINITOURNAMENT" && GameOver.gametype != "TOURNAMENT" && xplevel >= 10)
				{
					Util.ExternalCall("client_RotatePreroll", "GAMEOVER");
				}
			}
			this.mtupdatetimer.stop();
			Util.RemoveEventListener(this.mtupdatetimer, TimerEvent.TIMER, this.OnTimer);
			if (this.tournament_close_timer)
			{
				Util.RemoveEventListener(this.tournament_close_timer, TimerEvent.TIMER, this.OnTournamentCloseTimer);
				if (this.tournament_close_timer.running)
				{
					this.tournament_close_timer.stop();
				}
				this.tournament_close_timer = null;
			}
			if (GameOver.prop.type == "GAME" && GameOver.gametype != "MINITOURNAMENT" && GameOver.gametype != "TOURNAMENT")
			{
				Comm.SendCommand("CLOSEGAME", backtowh);
				return;
			}
			if (GameOver.prop.type == "GAME")
			{
				Comm.SendCommand("CLOSEGAME", backtowh);
			}
		}

		private function OnVideoAdsStart(e:* = null):void
		{
			trace("GameOver.OnVideoAdsStart");
			this.videoad_play = true;
			this.Hide();
			Util.ExternalCall("TrackState", "GAMEOVER_START", "");
		}

		public function Hide(e:* = null):void
		{
			trace("GameOver.Hide: " + this.videoad_available);
			Imitation.RemoveStageEventListener("VIDEOAD_VIDEO_AVAILABLE", this.OnVideoAdsAvailable);
			this.PAGE.MISSION_LIST.Destroy();
			if (this.videoad_available)
			{
				this.videoad_available = false;
				this.videoad_play = false;
				this.gotoAndStop("VIDEOAD");
				this.TABS.visible = false;
				this.PAGE.visible = false;
				this.NPC.Set("PROFESSOR", "DEFAULT");
				Util.SetText(this.INFO.FIELD, Lang.Get("gameover_videoad_text"));
				if (this.INFO.FIELD.numLines == 1)
				{
					this.INFO.FIELD.y = 40;
				}
				if (this.INFO.FIELD.numLines == 2)
				{
					this.INFO.FIELD.y = 31;
				}
				if (this.INFO.FIELD.numLines == 3)
				{
					this.INFO.FIELD.y = 19;
				}
				if (this.INFO.FIELD.numLines >= 4)
				{
					this.INFO.FIELD.y = 9;
				}
				this.BTNSKIP.SetLangAndClick("bank_cancel_videoad_skip", this.Hide);
				this.BTNGET.SetLangAndClick("bank_cancel_videoad_get", this.OnVideoAdsStart);
				Util.ExternalCall("TrackState", "GAMEOVER_OFFER", "");
			}
			else
			{
				WinMgr.CloseWindow(this);
				Sys.ExitFullscreen(null);
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
