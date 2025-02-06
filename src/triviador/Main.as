package triviador
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import syscode.*;
	import uibase.components.UIBaseButtonComponent;
	import triviador.compat.TriviadorButtonComponent;

	[Embed(source="/modules/triviador_assets.swf", symbol="symbol1182")]
	public class Main extends MovieClip
	{
		public static var mc:Main = null;

		internal static var initialized:Boolean = false;

		internal static var loadingfinished:Boolean = false;

		internal static var xmltoprocess:XML = null;

		public var ATTACKANIM:AreaMarkerMov;

		public var BTNFULLSCREEN:MovieClip;

		public var BTNLEAVEGAME:TriviadorButtonComponent;

		public var FASOLDIER1:AreaMarkerMov;

		public var FASOLDIER2:AreaMarkerMov;

		public var FASOLDIER3:AreaMarkerMov;

		public var GAMEOVER:MovieClip;

		public var GQWIN:GuessQuestionMov;

		public var MAP:MovieClip;

		public var MAPCLOCK:MovieClip;

		public var MCQWIN:MCQuestionMov;

		public var MHSUBJECTS:MovieClip;

		public var PHASEDISPLAY:MovieClip;

		public var QSHADER:MovieClip;

		public var SELECTRING:MovieClip;

		public var STANDINGS:MovieClip;

		public var TURNSHADER:MovieClip;

		public var TURNTABLE:MovieClip;

		public function Main()
		{
			super();
			this.__setProp_BTNLEAVEGAME_TriviadorMain_leavegame_0();
		}

		public static function ShowModule():*
		{
			if (!initialized)
			{
				Game.Init();
				Map.Init();
				Waithall.Init();
				initialized = true;
			}
			WinMgr.ShowBaseHandler(Main);
			Modules.GetClass("uibase", "uibase.DebugInfo").Init();
			Sounds.LoadSounds("triviador", OnSoundsLoaded);
			Map.SelectMap(Config.settings.DEFAULTMAP);
			Util.StopAllChildrenMov(Main.mc);
			LoadFinished();
		}

		public static function OnSoundsLoaded(e:* = null):void
		{
			trace("Triviador sounds are loaded.");
		}

		public static function AfterClose():void
		{
			Util.StopAllChildrenMov(Main.mc);
		}

		public static function HideModule():*
		{
			Waithall.Hide();
			WaitingGameMov.Hide();
			Map.Clear();
			WinMgr.HideBaseHandler(Main);
		}

		public static function ProcessDataXML(xml:XML):void
		{
			if (!loadingfinished)
			{
				xmltoprocess = xml;
				return;
			}
			Game.ProcessDataXML(xml);
		}

		public static function ProcessCommandTag(cmd:String, tag:Object):void
		{
			Game.ProcessCommandTag(cmd, tag);
		}

		internal static function LoadFinished():*
		{
			Aligner.SetAutoAlignFunc(mc, Game.AlignItems);
			loadingfinished = true;
			if (xmltoprocess)
			{
				ProcessDataXML(xmltoprocess);
				xmltoprocess = null;
			}
			Imitation.UpdateAll();
			Modules.HideModuleWait();
		}

		public function Prepare(aparams:Object):*
		{
			Util.StopAllChildrenMov(this);
			this.MAP.PLACEHOLDER.visible = false;
			this.MAP.addChild(Map.mc);
			this.MAPCLOCK.visible = false;
			this.SELECTRING.visible = false;
			this.MHSUBJECTS.visible = false;
			this.ATTACKANIM.visible = false;
			this.FASOLDIER1.visible = false;
			this.FASOLDIER2.visible = false;
			this.FASOLDIER3.visible = false;
			this.BTNLEAVEGAME.visible = false;
			this.BTNLEAVEGAME.SetLangAndClick("leave_the_game", this.OnCloseGameClick);
			this.STANDINGS.STATUS.visible = false;
			this.STANDINGS.BOX1.BASE = Util.SwapSkin(this.STANDINGS.BOX1.BASE, "skin_triviador", "StandingBase");
			this.STANDINGS.BOX2.BASE = Util.SwapSkin(this.STANDINGS.BOX2.BASE, "skin_triviador", "StandingBase");
			this.STANDINGS.BOX3.BASE = Util.SwapSkin(this.STANDINGS.BOX3.BASE, "skin_triviador", "StandingBase");
			this.STANDINGS.BOX1.SCOREANIM = Util.SwapSkin(this.STANDINGS.BOX1.SCOREANIM, "skin_triviador", "ScoreChangeAnim");
			this.STANDINGS.BOX2.SCOREANIM = Util.SwapSkin(this.STANDINGS.BOX2.SCOREANIM, "skin_triviador", "ScoreChangeAnim");
			this.STANDINGS.BOX3.SCOREANIM = Util.SwapSkin(this.STANDINGS.BOX3.SCOREANIM, "skin_triviador", "ScoreChangeAnim");
			Standings.Init(this.STANDINGS);
			this.TURNTABLE.BG = Util.SwapSkin(this.TURNTABLE.BG, "skin_triviador", "TurnDisplayBackground");
			Util.SwapTextcolor(this.TURNTABLE.CAPTION, "TurnDisplayCaptionColor", "skin_triviador");
			PhaseDisplay.Init(this.PHASEDISPLAY, this.TURNTABLE, this.TURNSHADER);
			this.PHASEDISPLAY.BG = Util.SwapSkin(this.PHASEDISPLAY.BG, "skin_triviador", "PhaseStateBg");
			this.PHASEDISPLAY.ICON = Util.SwapSkin(this.PHASEDISPLAY.ICON, "skin_triviador", "PhaseDispIcon");
			Util.SwapTextcolor(this.PHASEDISPLAY.LONGFREEAREA.ROUND, "phasedisplayLabelColor", "skin_triviador");
			Aligner.SetAutoAlign(this.GAMEOVER, false);
			this.GAMEOVER.BTNCLOSEGAME.SetLangAndClick("back_to_lobby", this.OnCloseGameClick);
			this.GAMEOVER.visible = false;
			this.QSHADER.visible = false;
			Game.UpdateFullscreenButton();
		}

		public function OnCloseGameClick(e:Object):void
		{
			Sys.gsqc.Clear();
			if (GuessQuestionMov.mc)
			{
				GuessQuestionMov.mc.Hide();
				TweenMax.killChildTweensOf(GuessQuestionMov.mc);
				GuessQuestionMov.Dispose();
			}
			if (MCQuestionMov.mc)
			{
				MCQuestionMov.mc.Hide();
				TweenMax.killChildTweensOf(MCQuestionMov.mc);
				MCQuestionMov.Dispose();
			}
			Sounds.StopMusic("passive_player");
			var clockmc:MovieClip = Main.mc.MAPCLOCK;
			TweenMax.killTweensOf(clockmc.STRIP);
			TweenMax.killTweensOf(clockmc);
			Map.StopAreaSelection();
			Game.StopAttackAnim(true);
			Game.Reset();
			Comm.SendCommand("CLOSEGAME", "");
			TweenMax.killTweensOf(this.BTNLEAVEGAME);
			this.BTNLEAVEGAME.visible = false;
			this.GAMEOVER.visible = false;
		}

		internal function __setProp_BTNLEAVEGAME_TriviadorMain_leavegame_0():*
		{
			try
			{
				this.BTNLEAVEGAME["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.BTNLEAVEGAME.enabled = true;
			this.BTNLEAVEGAME.fontsize = "BIG";
			this.BTNLEAVEGAME.icon = "";
			this.BTNLEAVEGAME.skin = "OK";
			this.BTNLEAVEGAME.testcaption = "A játék elhagyása";
			this.BTNLEAVEGAME.visible = true;
			this.BTNLEAVEGAME.wordwrap = false;
			try
			{
				this.BTNLEAVEGAME["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}
	}
}
