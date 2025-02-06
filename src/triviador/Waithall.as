package triviador
{
	import flash.display.*;
	import flash.events.*;
	import syscode.*;

	public class Waithall
	{
		public static var fixgamerooms:Array = [];

		public static var mainroomid:int = 1;

		public static var longruleroomid:int = 0;

		public static var juniorroomid:int = 0;

		public static var minitourroomid:int = 0;

		public static var minitourroomtag:Object = null;

		public static var waitstatetag:Object = null;

		public static var activefixroom:int = 0;

		public static var activeseproom:int = 0;

		public static var smalluserlist:Array = [];

		public static var MinitournamentWin:Object = null;

		public static var TournamentWin:Object = null;

		public static var FriendlyGame:Object = null;

		public static var SeparateRooms:Object = null;

		public static var WrongQuestion:Object = null;

		public static var AvatarWin:Object = null;

		public static var Clan:Object = null;

		public static var Lobby:Object = null;

		public function Waithall()
		{
			super();
		}

		public static function Init():void
		{
			MinitournamentWin = Modules.GetClass("minitournament", "minitournament.MinitournamentWin");
			MinitournamentWin.Init(Waithall, PhaseDisplay);
			TournamentWin = Modules.GetClass("tournament", "tournament.TournamentWin");
			TournamentWin.Init(Waithall, PhaseDisplay);
			FriendlyGame = Modules.GetClass("friendlygame", "friendlygame.FriendlyGame");
			Clan = Modules.GetClass("clan", "clan.Clan");
			Lobby = Modules.GetClass("lobby", "lobby.Lobby");
			WrongQuestion = Modules.GetClass("wrongquestion", "wrongquestion.WrongQuestion");
			AvatarWin = Modules.GetClass("settings", "settings.AvatarWin");
		}

		public static function Hide():void
		{
			StartWindowMov.Hide();
			MinitournamentWin.Hide();
			TournamentWin.Hide();
		}

		public static function ResetRooms():*
		{
			fixgamerooms = [];
			longruleroomid = 0;
			juniorroomid = 0;
			minitourroomid = 0;
			minitourroomtag = null;
		}

		public static function AddFixRoomTag(tag:*):*
		{
			fixgamerooms.push(tag);
			if (Sys.screen != "WAIT")
			{
				return;
			}
			var title:String = Util.StringVal(tag.TITLE);
			var roomid:int = Util.NumberVal(tag.ID);
			var type:int = Util.NumberVal(tag.TYPE);
			if (fixgamerooms.length == 1)
			{
				mainroomid = roomid;
			}
			if (fixgamerooms.length > 1)
			{
				if ("JUNIOR" == title)
				{
					juniorroomid = roomid;
				}
				else if ("LONG" == title)
				{
					longruleroomid = roomid;
				}
				else if (title.substr(0, 4) == "MINI" || type == 10)
				{
					Waithall.minitourroomid = roomid;
					Waithall.minitourroomtag = tag;
				}
				else if (longruleroomid == 0)
				{
					longruleroomid = roomid;
				}
			}
		}

		public static function DrawScreen():*
		{
			var w:* = undefined;
			var whwindows:Array = [StartWindowMov, WaitingGameMov, MinitournamentWin, TournamentWin, FriendlyGame, WrongQuestion, AvatarWin, Clan, Lobby];
			var requiredwin:Object = null;
			if (Sys.screen == "MINITOUR" || minitourroomid > 0 && activefixroom == minitourroomid)
			{
				requiredwin = MinitournamentWin;
			}
			else if (Sys.screen == "TOURNAMENT")
			{
				requiredwin = TournamentWin;
			}
			else if (activefixroom != 0)
			{
				requiredwin = WaitingGameMov;
			}
			else if (Boolean(AvatarWin) && Boolean(AvatarWin.mc))
			{
				requiredwin = AvatarWin;
			}
			else if (Boolean(Clan) && Boolean(Clan.mc))
			{
				requiredwin = Clan;
			}
			else if (Boolean(Lobby) && Boolean(Lobby.mc))
			{
				requiredwin = Lobby;
			}
			else if (Boolean(FriendlyGame) && Boolean(FriendlyGame.mc))
			{
				requiredwin = FriendlyGame;
			}
			else if (Sys.codegamecode != "")
			{
				requiredwin = FriendlyGame;
			}
			else if (Sys.tag_wrongq)
			{
				requiredwin = WrongQuestion;
			}
			else
			{
				requiredwin = StartWindowMov;
			}
			var curwin:Class = null;
			for each (w in whwindows)
			{
				if (w != requiredwin && w && Boolean(w.mc))
				{
					curwin = w;
					break;
				}
			}
			if (curwin)
			{
				WinMgr.ReplaceWindow(curwin.mc, requiredwin);
			}
			else
			{
				requiredwin.DrawScreen();
			}
		}

		public static function tagproc_SMALLUL(tag:Object):void
		{
			var uli:String = null;
			var parr:Array = null;
			var u:Object = null;
			smalluserlist = [];
			var ularr:Array = Util.StringVal(tag.UL).split("|");
			var shcnt:int = 0;
			for each (uli in ularr)
			{
				parr = uli.split("^");
				if (Boolean(parr) && parr.length == 2)
				{
					if (parr[0] != Sys.mydata.id)
					{
						smalluserlist.push({
									"ID": parr[0],
									"NAME": parr[1]
								});
						u = Extdata.GetUserData(parr[0]);
						if (!u)
						{
							u = Extdata.SetUserData(parr[0], parr[1], "");
							u.loaded = 2;
							shcnt++;
						}
					}
				}
			}
			if (shcnt > 0)
			{
				Extdata.GetSheduledData(null);
			}
			trace("Lobby.tagproc_SMALLUL: " + smalluserlist.length + " users");
		}
	}
}
