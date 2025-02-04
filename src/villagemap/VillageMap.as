package villagemap
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;

	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;

	import uibase.Building;

	import villagemap.gfx.BuildingLabel;
	import villagemap.gfx.BuildingPercentbarCircle;
	import villagemap.gfx.GridElementSpriteGray;
	import villagemap.gfx.Inventory;
	import villagemap.gfx.InventoryTraceWin;
	import villagemap.gfx.Notification;
	import villagemap.gfx.SelectRing;
	import syscode.WinMgr;
	import syscode.Imitation;
	import syscode.Modules;
	import syscode.Sys;
	import syscode.Util;
	import syscode.Comm;
	import syscode.JsQuery;
	import syscode.UIBase;
	import syscode.Config;
	import syscode.Platform;
	import syscode.Lang;
	import villagemap.gfx.VillageMapHeader;
	import syscode.AvatarMov;
	import syscode.AvatarBodyMov;
	import syscode.AvatarAnimMov;
	import uibase.LegoIconset;
	import uibase.gfx.LegoIconset;
	import flash.utils.getQualifiedClassName;
	import syscode.AvatarFactory;
	import villagemap.compat.VillageAvatarAnimMov;

	[Embed(source="/modules/villagemap_assets.swf", symbol="symbol160")]
	public class VillageMap extends MovieClip
	{
		public static var mc:VillageMap = null;

		private static var loadingfinished:Boolean = false;

		private static var xmltoprocess:XML = null;

		public static var AutoStartVideoAd:Boolean = false;

		private static var badgesCastle:Array = new Array();

		public var GRIDEDITBTNMC:MovieClip;

		public var HEADER:VillageMapHeader;

		public var MAP:MovieClip;

		private var lifeupdatetimer:Timer = null;

		public var appScale:Number = 1;

		private var oldMydata:Object = null;

		private var mapWidth:Number = 2048;

		private var mapHeight:Number = 1024;

		private var tiled_background:MovieClip = null;

		private var solid_background:MovieClip = null;

		public var redrawVillage:Boolean = false;

		private var mapClickCheck:Boolean = false;

		private var items:Array;

		private var gridArray:Array;

		private var gridmc:MovieClip;

		private var gridItemWidth:Number;

		private var gridItemHeight:Number;

		private var firstGridModeSwitch:Boolean = true;

		private var gridEditMode:Boolean = false;

		private var itemsParent:MovieClip;

		private var draggedItem:MovieClip;

		private var selectRing:MovieClip;

		private var centerItem:MovieClip;

		private var stuff:Stuff;

		private var buildingsData:Array;

		private var needStartTriviadorFx:Boolean = false;

		private var imitationCloneDefinitions:Object;

		private var inventory:MovieClip;

		private var inventoryItems:Array;

		private var evenY:Object;

		private var oddY:Object;

		public function VillageMap()
		{
			this.items = new Array();
			this.imitationCloneDefinitions = new Object();
			this.evenY = {
					"g1x1": [ {
							"x": 0,
							"y": 0
						}],
					"g2x2": [ {
							"x": -1,
							"y": -1
						}, {
							"x": 0,
							"y": -2
						}, {
							"x": 0,
							"y": -1
						}],
					"g3x3": [ {
							"x": -1,
							"y": -2
						}, {
							"x": -1,
							"y": -3
						}, {
							"x": 0,
							"y": -4
						}, {
							"x": 0,
							"y": -3
						}, {
							"x": 1,
							"y": -2
						}],
					"g4x4": [ {
							"x": -2,
							"y": -3
						}, {
							"x": -1,
							"y": -4
						}, {
							"x": -1,
							"y": -5
						}, {
							"x": 0,
							"y": -6
						}, {
							"x": 0,
							"y": -5
						}, {
							"x": 1,
							"y": -4
						}, {
							"x": 1,
							"y": -3
						}],
					"g5x5": [ {
							"x": -2,
							"y": -4
						}, {
							"x": -2,
							"y": -5
						}, {
							"x": -1,
							"y": -6
						}, {
							"x": -1,
							"y": -7
						}, {
							"x": 0,
							"y": -8
						}, {
							"x": 0,
							"y": -7
						}, {
							"x": 1,
							"y": -6
						}, {
							"x": 1,
							"y": -5
						}, {
							"x": 2,
							"y": -4
						}],
					"g6x6": [ {
							"x": -3,
							"y": -5
						}, {
							"x": -2,
							"y": -6
						}, {
							"x": -2,
							"y": -7
						}, {
							"x": -1,
							"y": -8
						}, {
							"x": -1,
							"y": -9
						}, {
							"x": 0,
							"y": -10
						}, {
							"x": 0,
							"y": -9
						}, {
							"x": 1,
							"y": -8
						}, {
							"x": 1,
							"y": -7
						}, {
							"x": 2,
							"y": -6
						}, {
							"x": 2,
							"y": -5
						}],
					"g7x7": [ {
							"x": -3,
							"y": -6
						}, {
							"x": -3,
							"y": -7
						}, {
							"x": -2,
							"y": -8
						}, {
							"x": -2,
							"y": -9
						}, {
							"x": -1,
							"y": -10
						}, {
							"x": -1,
							"y": -11
						}, {
							"x": 0,
							"y": -12
						}, {
							"x": 0,
							"y": -11
						}, {
							"x": 1,
							"y": -10
						}, {
							"x": 1,
							"y": -9
						}, {
							"x": 2,
							"y": -8
						}, {
							"x": 2,
							"y": -7
						}, {
							"x": 3,
							"y": -6
						}]
				};
			this.oddY = {
					"g1x1": [ {
							"x": 0,
							"y": 0
						}],
					"g2x2": [ {
							"x": 0,
							"y": -1
						}, {
							"x": 0,
							"y": -2
						}, {
							"x": 1,
							"y": -1
						}],
					"g3x3": [ {
							"x": -1,
							"y": -2
						}, {
							"x": 0,
							"y": -3
						}, {
							"x": 0,
							"y": -4
						}, {
							"x": 1,
							"y": -3
						}, {
							"x": 1,
							"y": -2
						}],
					"g4x4": [ {
							"x": -1,
							"y": -3
						}, {
							"x": -1,
							"y": -4
						}, {
							"x": 0,
							"y": -5
						}, {
							"x": 0,
							"y": -6
						}, {
							"x": -1,
							"y": -5
						}, {
							"x": 1,
							"y": -4
						}, {
							"x": 2,
							"y": -3
						}],
					"g5x5": [ {
							"x": -2,
							"y": -4
						}, {
							"x": -1,
							"y": -5
						}, {
							"x": -1,
							"y": -6
						}, {
							"x": 0,
							"y": -7
						}, {
							"x": 0,
							"y": -8
						}, {
							"x": 1,
							"y": -7
						}, {
							"x": 1,
							"y": -6
						}, {
							"x": 2,
							"y": -5
						}, {
							"x": 2,
							"y": -4
						}],
					"g6x6": [ {
							"x": -2,
							"y": -5
						}, {
							"x": -2,
							"y": -6
						}, {
							"x": -1,
							"y": -7
						}, {
							"x": -1,
							"y": -8
						}, {
							"x": 0,
							"y": -9
						}, {
							"x": 0,
							"y": -10
						}, {
							"x": 1,
							"y": -9
						}, {
							"x": 1,
							"y": -8
						}, {
							"x": 2,
							"y": -7
						}, {
							"x": 2,
							"y": -6
						}, {
							"x": 3,
							"y": -5
						}],
					"g7x7": [ {
							"x": -3,
							"y": -6
						}, {
							"x": -2,
							"y": -7
						}, {
							"x": -2,
							"y": -8
						}, {
							"x": -1,
							"y": -9
						}, {
							"x": -1,
							"y": -10
						}, {
							"x": 0,
							"y": -11
						}, {
							"x": 0,
							"y": -12
						}, {
							"x": 1,
							"y": -11
						}, {
							"x": 1,
							"y": -10
						}, {
							"x": 2,
							"y": -9
						}, {
							"x": 2,
							"y": -8
						}, {
							"x": 3,
							"y": -7
						}, {
							"x": 3,
							"y": -6
						}]
				};
			super();
		}

		public static function ShowModule():void
		{
			if (!loadingfinished)
			{
				LoadAssets();
				return;
			}
			Show();
		}

		public static function Show():void
		{
			WinMgr.ShowBaseHandler(VillageMap);
			Imitation.UpdateAll();
			Modules.HideModuleWait();
			if (Sys.codegame)
			{
				if (Boolean(Sys.mydata.name) && Sys.mydata.name != "")
				{
					AfterAvatarWin();
				}
				else
				{
					WinMgr.OpenWindow("settings.AvatarWin", {"callback": AfterAvatarWin});
				}
			}
			Sys.codegame = false;
		}

		public static function AfterAvatarWin(command:String = "NOTHING"):void
		{
			Comm.SendCommand("CHANGEWAITHALL", "WH=\"GAME\"", function():*
				{
					WinMgr.OpenWindow("friendlygame.FriendlyGame", {"page": 3});
				});
		}

		public static function WaitForStartWindowMov():void
		{
			var StartWindowMov:* = Modules.GetClass("triviador", "triviador.StartWindowMov");
			var friendlygamemc:* = Modules.GetClass("friendlygame", "friendlygame.FriendlyGame");
			if (StartWindowMov && Boolean(StartWindowMov.mc))
			{
				WinMgr.ReplaceWindow(StartWindowMov.mc, "friendlygame.FriendlyGame", {"page": 3});
			}
			else
			{
				TweenMax.delayedCall(0.5, WaitForStartWindowMov);
			}
		}

		public static function HideModule():*
		{
			var i:int = 0;
			var mov:MovieClip = null;
			if (mc.lifeupdatetimer != null)
			{
				mc.lifeupdatetimer.reset();
				Util.RemoveEventListener(mc.lifeupdatetimer, TimerEvent.TIMER, mc.HeaderUpdateNextLifeTime);
				mc.lifeupdatetimer = null;
			}
			Imitation.RemoveGlobalListener("MYDATACHANGE", mc.OnMyDataChange);
			Imitation.RemoveStageEventListener("WINDOWCHANGE", mc.OnWindowChange);
			Util.RemoveEventListener(Imitation.stage, Event.RESIZE, mc.StageOnResize);
			Imitation.RemoveStageEventListener("ACTIVATE", mc.OnActivate);
			Imitation.RemoveStageEventListener("DEACTIVATE", mc.OnDeactivate);
			Util.RemoveEventListener(mc.MAP, Event.ENTER_FRAME, mc.MapOnMouseMove);
			Util.RemoveEventListener(mc.MAP, Event.ENTER_FRAME, mc.MapFrictionMove);
			i = 0;
			while (i < mc.items.length)
			{
				Imitation.RemoveEvents(mc.items[i]);
				mc.itemsParent.removeChild(mc.items[i]);
				i++;
			}
			while (mc.MAP.numChildren > 0)
			{
				mov = MovieClip(mc.MAP.getChildAt(0));
				Imitation.RemoveEvents(mov);
				mc.MAP.removeChild(mov);
			}

			var avataranim:VillageAvatarAnimMov = VillageAvatarAnimMov(mc.HEADER.USERPROFILE.AVATAR);
			avataranim.Clear();
			Imitation.RemoveEvents(mc.HEADER.BTNPLUSGOLD);
			Imitation.RemoveEvents(mc.HEADER.BTNPLUSENERGY);
			Imitation.RemoveEvents(mc.HEADER.BTNSETTINGS);
			Imitation.RemoveEvents(mc.HEADER.GOLDTRANSPARENT);
			Imitation.RemoveEvents(mc.HEADER.ENERGYTRANSPARENT);
			Imitation.RemoveEvents(mc.HEADER.BG);
			Imitation.RemoveEvents(mc.HEADER.USERPROFILE.FLAG);
			Imitation.RemoveEvents(mc.HEADER.USERTRANSPARENT);
			Imitation.RemoveEvents(mc.MAP);
			Imitation.RemoveEvents(mc.HEADER);
			Imitation.DeleteEventGroup(mc);
			mc.items = [];
			WinMgr.HideBaseHandler(VillageMap);
		}

		public static function LoadAssets():void
		{
			var Building:Object = Modules.GetClass("uibase", "uibase.Building");
			Building.LoadGFX(OnAssetsLoaded);
		}

		public static function OnAssetsLoaded(e:* = null):void
		{
			BadgesLoad("list");
		}

		public static function BadgesLoad(aaction:*):*
		{
			trace("VillageMap.BadgesLoad - client_castle.php");
			JsQuery.Load(BadgesOnLoaded, [], "client_castle.php?stoc=" + Config.stoc + "&cmd=" + aaction);
		}

		public static function BadgesOnLoaded(jsq:*):*
		{
			trace("BadgesOnLoaded jsq: " + jsq);
			if (jsq.error == 0)
			{
				badgesCastle = jsq.data["castlebadges"];
				Sys.castle_badges = badgesCastle;
				Sys.all_badges = jsq.data;
				loadingfinished = true;
				Show();
			}
		}

		public static function ProcessDataXML(xml:XML):void
		{
			if (!loadingfinished)
			{
				xmltoprocess = xml;
				return;
			}
			if (!Comm.listening)
			{
				Comm.Listen(true);
			}
		}

		private function OnActivate(event:Object):void
		{
		}

		private function OnDeactivate(event:Object):void
		{
		}

		public function StageOnResize(e:Event):void
		{
			this.HeaderDraw();
			this.MapSetBuildingToCenter(this.centerItem);
			Util.ShowChildrenOnScreen(this.tiled_background);
			if (this.selectRing != null)
			{
				this.ResizeSelectRing();
			}
			if (this.inventory)
			{
				this.InventoryResize();
			}
			WinMgr.UpdateBackground();
		}

		public function Prepare(aparams:Object):*
		{
			var t:Number = getTimer();
			this.stuff = new Stuff();
			this.buildingsData = this.stuff.buildingsData;
			this.inventoryItems = this.stuff.inventoryItems;
			this.evenY.g2x2 = [].concat(this.evenY.g1x1, this.evenY.g2x2);
			this.evenY.g3x3 = [].concat(this.evenY.g2x2, this.evenY.g3x3);
			this.evenY.g4x4 = [].concat(this.evenY.g3x3, this.evenY.g4x4);
			this.evenY.g5x5 = [].concat(this.evenY.g4x4, this.evenY.g5x5);
			this.evenY.g6x6 = [].concat(this.evenY.g5x5, this.evenY.g6x6);
			this.evenY.g7x7 = [].concat(this.evenY.g6x6, this.evenY.g7x7);
			this.oddY.g2x2 = [].concat(this.oddY.g1x1, this.oddY.g2x2);
			this.oddY.g3x3 = [].concat(this.oddY.g2x2, this.oddY.g3x3);
			this.oddY.g4x4 = [].concat(this.oddY.g3x3, this.oddY.g4x4);
			this.oddY.g5x5 = [].concat(this.oddY.g4x4, this.oddY.g5x5);
			this.oddY.g6x6 = [].concat(this.oddY.g5x5, this.oddY.g6x6);
			this.oddY.g7x7 = [].concat(this.oddY.g6x6, this.oddY.g7x7);
			Util.AddEventListener(Imitation.stage, Event.RESIZE, this.StageOnResize);
			Imitation.AddStageEventListener("ACTIVATE", this.OnActivate);
			Imitation.AddStageEventListener("DEACTIVATE", this.OnDeactivate);
			Imitation.AddGlobalListener("MYDATACHANGE", this.OnMyDataChange);
			Imitation.AddStageEventListener("WINDOWCHANGE", this.OnWindowChange);
			UIBase.HideWaitAnim();
			if (xmltoprocess)
			{
				ProcessDataXML(xmltoprocess);
				xmltoprocess = null;
			}
			this.MAP.BG.STATICBG = Util.SwapSkin(this.MAP.BG.STATICBG, "skin_village", "VillageBg");
			this.HEADER.BG = Util.SwapSkin(this.HEADER.BG, "skin_village", "HeaderBg");
			this.HEADER.BOX.HBBG1 = Util.SwapSkin(this.HEADER.BOX.HBBG1, "skin_village", "HeaderBoxBackground");
			this.HEADER.BOX.HBBG2 = Util.SwapSkin(this.HEADER.BOX.HBBG2, "skin_village", "HeaderBoxBackground");
			this.HEADER.BOX.HBBG3 = Util.SwapSkin(this.HEADER.BOX.HBBG3, "skin_village", "HeaderBoxBackground");
			this.HEADER.USERPROFILE.FLAG = Util.SwapSkin(this.HEADER.USERPROFILE.FLAG, "skin_village", "HeaderFlag");
			this.HEADER.BOX.BACK = Util.SwapSkin(this.HEADER.BOX.BACK, "skin_village", "EnergyBarBack");
			this.HEADER.ENERGY.BAR = Util.SwapSkin(this.HEADER.ENERGY.BAR, "skin_village", "EnergyBar");
			this.HEADER.USERPROFILE.XPBARBACK = Util.SwapSkin(this.HEADER.USERPROFILE.XPBARBACK, "skin_village", "XPBarBack");
			this.HEADER.USERPROFILE.BAR = Util.SwapSkin(this.HEADER.USERPROFILE.BAR, "skin_village", "XpBar");
			Util.SwapTextcolor(this.HEADER.USERPROFILE.USERNAMELABEL, "headerFontcolor1", "skin_village");
			Util.SwapTextcolor(this.HEADER.ENERGY.LABEL, "headerFontcolor1", "skin_village");
			Util.SwapTextcolor(this.HEADER.ENERGY.TIME, "headerEnergyTimer", "skin_village");
			Util.SwapTextcolor(this.HEADER.GOLD, "headerFontcolor1", "skin_village");
			Util.SwapTextcolor(this.HEADER.USERPROFILE.NEXTLVLFIELD, "headerFontcolorLvls", "skin_village");
			Util.SwapTextcolor(this.HEADER.USERPROFILE.LVLFIELD, "headerFontcolorLvls", "skin_village");
			Util.SwapTextcolor(this.HEADER.USERPROFILE.XPPOINTS, "headerXpPoints", "skin_village");
			this.MAP.BG.STATICBG.gotoAndStop(Config.season + 1);
			this.itemsParent = this.MAP.BG.STATICBG;
			this.CalculateAppScale();
			trace("-----VILLAGE-Prepare-REDRAW------");
			this.HeaderInit();
			this.HeaderDraw();
			this.MapInit();
			this.MapDraw();
			this.TiledBackgroundInit();
			TweenMax.delayedCall(2, this.CheckAutoplayTutorials);
			if (VillageMap.AutoStartVideoAd)
			{
				Platform.silentactivate = true;
				Imitation.DispatchStageEvent("VIDEOAD_START_VIDEO");
				VillageMap.AutoStartVideoAd = false;
			}
			this.oldMydata = this.CloneObject(Sys.mydata);
			if (Util.NumberVal(Sys.mydata.xplevel == 0) && !Sys.codegame && Config.mobile)
			{
				this.BuildingButtonClick({"target": MovieClip(this.MAP.getChildByName("HIT_START_TRIVIADOR"))});
			}
		}

		public function OnWindowChange(e:Object):void
		{
		}

		public function OnMyDataChange(e:Event = null):void
		{
			trace("Village.OnMyDataChange");
			this.HeaderDraw();
			this.MapDraw();
			if (this.redrawVillage)
			{
				this.redrawVillage = false;
				this.TiledBackgroundInit();
			}
			this.CheckAutoplayTutorials();
			this.oldMydata = this.CloneObject(Sys.mydata);
		}

		public function OnChangeWaithallResult(res:int, xml:XML):void
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
			}
		}

		public function CalculateAppScale():void
		{
			var guiSize:Rectangle = new Rectangle(0, 0, 800, 480);
			var deviceSize:Rectangle = new Rectangle(0, 0, Math.max(Imitation.stage.stageWidth, Imitation.stage.stageHeight), Math.min(Imitation.stage.stageWidth, Imitation.stage.stageHeight));
			var appSize:Rectangle = guiSize.clone();
			var appLeftOffset:Number = 0;
			if (deviceSize.width / deviceSize.height > guiSize.width / guiSize.height)
			{
				this.appScale = deviceSize.height / guiSize.height;
				appSize.width = deviceSize.width / this.appScale;
				appLeftOffset = Math.round((appSize.width - guiSize.width) / 2);
			}
			else
			{
				this.appScale = deviceSize.width / guiSize.width;
				appSize.height = deviceSize.height / this.appScale;
				appLeftOffset = 0;
			}
			if (!Config.mobile)
			{
				this.appScale = 1;
			}
		}

		private function HeaderUpdateNextLifeTime(event:TimerEvent = null):void
		{
			var elapsed:int = Math.round((getTimer() - Sys.mydata.time) / 1000);
			var nextlifesecs:int = Util.NumberVal(Sys.mydata.energynextupdate) - elapsed;
			if (nextlifesecs > 0)
			{
				this.HEADER.ENERGY.TIME.text = Util.FormatRemaining(nextlifesecs);
			}
			else
			{
				this.HEADER.ENERGY.TIME.text = "";
			}
		}

		private function HeaderInit():void
		{
			trace("HeaderInit");

			// this.HEADER.BTNPLUSGOLD.AddEventClick(this.HeaderButtonClick);
			// this.HEADER.BTNPLUSENERGY.AddEventClick(this.HeaderButtonClick);
			// this.HEADER.BTNSETTINGS.AddEventClick(this.HeaderButtonClick);
			Imitation.AddEventClick(this.HEADER.BTNPLUSGOLD, this.HeaderButtonClick);
			Imitation.AddEventClick(this.HEADER.BTNPLUSENERGY, this.HeaderButtonClick);
			Imitation.AddEventClick(this.HEADER.BTNSETTINGS, this.HeaderButtonClick);
			trace("ok1");
			Imitation.AddEventClick(this.HEADER.GOLDTRANSPARENT, this.HeaderButtonClick);
			Imitation.AddEventClick(this.HEADER.ENERGYTRANSPARENT, this.HeaderButtonClick);
			Imitation.AddEventClick(this.HEADER.BG, null);
			Imitation.AddEventClick(this.HEADER.USERPROFILE.FLAG, this.HeaderButtonClick);
			Imitation.AddEventClick(this.HEADER.USERTRANSPARENT, this.HeaderButtonClick);
			trace("ok2");
			this.HEADER.ENERGY.TIME.text = "";
			if (this.lifeupdatetimer == null)
			{
				this.lifeupdatetimer = new Timer(1000, 0);
				Util.AddEventListener(this.lifeupdatetimer, TimerEvent.TIMER, this.HeaderUpdateNextLifeTime);
				this.lifeupdatetimer.start();
			}
			trace("ok3");
			// this.GRIDEDITBTNMC.GRIDEDITBUTTON.AddEventClick(this.SwitchGridMode, {});
			Imitation.AddEventClick(this.GRIDEDITBTNMC.GRIDEDITBUTTON, this.SwitchGridMode);
		}

		public function HeaderDraw():void
		{
			trace("HeaderDraw");
			var scale:Number = NaN;
			var sp:Number = NaN;
			this.HEADER.scaleX = this.appScale;
			this.HEADER.scaleY = this.appScale;
			this.HEADER.BG.BASE.width = Imitation.stage.stageWidth / this.appScale;
			this.HEADER.BTNSETTINGS.x = Imitation.stage.stageWidth / this.appScale - 60;
			Util.SetText(this.HEADER.USERPROFILE.USERNAMELABEL, Sys.mydata.name);
			this.HEADER.USERPROFILE.LVLFIELD.text = Sys.mydata.xplevel;
			this.HEADER.USERPROFILE.NEXTLVLFIELD.text = Sys.mydata.xplevel + 1;
			this.HEADER.USERPROFILE.XPPOINTS.text = Util.FormatNumber(Util.NumberVal(Sys.mydata.xppoints) - Util.NumberVal(Sys.mydata.xpactmin)) + " / " + Util.FormatNumber(Util.NumberVal(Sys.mydata.xptonextlevel) - Util.NumberVal(Sys.mydata.xpactmin)) + " " + Lang.Get("xp");
			var avataranim:VillageAvatarAnimMov = VillageAvatarAnimMov(mc.HEADER.USERPROFILE.AVATAR);
			avataranim.Clear();
			avataranim.ShowUID(Sys.mydata.id);
			if (Sys.mydata.xppoints !== undefined)
			{
				scale = (Sys.mydata.xppoints - Sys.mydata.xpactmin) / (Sys.mydata.xptonextlevel - Sys.mydata.xpactmin);
				sp = scale;
				if (sp > 1)
				{
					sp = 1;
				}
				if (sp < 0)
				{
					sp = 0;
				}
				if (sp != this.HEADER.USERPROFILE.BAR.scaleX)
				{
					TweenMax.fromTo(this.HEADER.USERPROFILE.BAR, 1, {"scaleX": 0}, {
								"scaleX": sp,
								"ease": Bounce.easeOut,
								"delay": 2
							});
				}
			}
			else
			{
				this.HEADER.USERPROFILE.BAR.scaleX = 0.01;
			}
			this.HEADER.ENERGY.LABEL.text = Sys.mydata.energy + "/" + Sys.mydata.energymax;
			scale = Math.min(Sys.mydata.energy, Sys.mydata.energymax) / Sys.mydata.energymax * 100;
			sp = scale / 100;
			if (sp > 1)
			{
				sp = 1;
			}
			if (sp != this.HEADER.ENERGY.BAR.scaleX)
			{
				TweenMax.fromTo(this.HEADER.ENERGY.BAR, 1, {"scaleX": 0}, {
							"scaleX": sp,
							"ease": Bounce.easeOut,
							"delay": 1
						});
			}
			this.HEADER.GOLD.text = Util.FormatNumber(Util.NumberVal(Sys.mydata.gold));
			Imitation.FreeBitmapAll(this.HEADER);
			Imitation.UpdateAll(this.HEADER);
			this.GRIDEDITBTNMC.scaleX = this.GRIDEDITBTNMC.scaleY = this.appScale;
			this.GRIDEDITBTNMC.x = Imitation.stage.stageWidth - (this.GRIDEDITBTNMC.width + 5);
			this.GRIDEDITBTNMC.y = Imitation.stage.stageHeight - (this.GRIDEDITBTNMC.height + 5);
			if (Config.serveraddress.lastIndexOf("v11") > -1)
			{
				this.GRIDEDITBTNMC.visible = true;
			}
			else
			{
				this.GRIDEDITBTNMC.visible = false;
			}
			Imitation.UpdateAll(this.GRIDEDITBTNMC);
		}

		public function HeaderInitLayout(full:Boolean = true):void
		{
			this.HeaderDraw();
		}

		private function HeaderButtonClick(e:Object):void
		{
			if (e.target.name == "BTNPLUSENERGY" || e.target.name == "ENERGYTRANSPARENT")
			{
				WinMgr.OpenWindow("energy.Energy", {"page": "BUY"});
			}
			if (e.target.name == "BTNPLUSGOLD" || e.target.name == "GOLDTRANSPARENT")
			{
				WinMgr.OpenWindow("bank.Bank", {"funnelid": "VillageMap"});
			}
			if (e.target.name == "BTNSETTINGS")
			{
				WinMgr.OpenWindow("profile2.Profile2", {"page": 4});
			}
			if (e.target.name == "FLAG" || e.target.name == "USERTRANSPARENT")
			{
				WinMgr.OpenWindow("profile2.Profile2");
			}
		}

		private function SwitchGridMode(e:Object):void
		{
			if (this.gridEditMode)
			{
				this.gridEditMode = false;
				this.GRIDEDITBTNMC.GRIDEDITBUTTON.icon = "EDIT";
				this.HEADER.mouseEnabled = true;
				this.HEADER.visible = true;
				this.InventoryHide();
				TweenMax.delayedCall(0.2, this.SwapItemsTo, [this.MAP.BG.STATICBG]);
				TweenMax.delayedCall(0.4, this.WritePositions);
			}
			else
			{
				this.gridEditMode = true;
				this.GRIDEDITBTNMC.GRIDEDITBUTTON.icon = "NONEDIT";
				this.HEADER.mouseEnabled = false;
				this.InventoryShow();
				this.HEADER.visible = false;
				TweenMax.delayedCall(0.1, this.SwapItemsTo, [this.MAP]);
				if (this.firstGridModeSwitch)
				{
				}
			}
			UIBase.ShowWaitAnim();
		}

		private function TiledBackgroundInit():void
		{
			this.solid_background = this.MAP.BG.STATICBG;
			if (this.MAP.BG.contains(this.solid_background))
			{
				this.MAP.BG.removeChild(this.solid_background);
			}
			if (this.tiled_background != null && Boolean(this.MAP.BG.contains(this.tiled_background)))
			{
				this.MAP.BG.removeChild(this.tiled_background);
			}
			this.tiled_background = Util.TileImage(this.solid_background, 256, 256);
			this.MAP.BG.addChildAt(this.tiled_background, 0);
			var i:int = 0;
			while (i < this.tiled_background.numChildren)
			{
				Imitation.SetBitmapScale(this.tiled_background.getChildAt(i), -1);
				i++;
			}
			Imitation.CollectChildrenAll(this.tiled_background);
			Imitation.UpdateAll(this.tiled_background);
			Util.ShowChildrenOnScreen(this.tiled_background);
		}

		private function MapInit():void
		{
			var labels:MovieClip;
			var i:int;
			var buildinginstance:* = undefined;
			var buildinglabel:MovieClip = null;
			var bd:* = undefined;
			var hitArea:MovieClip = null;
			var hclass:Class = null;
			var buildingGrid:MovieClip = null;
			Imitation.AddEventMouseDown(this.MAP, this.MapOnMouseDown);
			Imitation.AddEventMouseUp(this.MAP, this.MapOnMouseUp);
			Util.AddEventListener(this.MAP, Event.ENTER_FRAME, this.MapOnMouseMove);
			this.GridCreate();
			this.MAP.scaleX = this.appScale;
			this.MAP.scaleY = this.appScale;
			labels = new MovieClip();
			labels.name = "LABELS";
			this.itemsParent.addChild(labels);
			trace("this.buildingsData.length: " + this.buildingsData.length);
			i = 0;
			while (i < this.buildingsData.length)
			{
				buildinginstance = new Building(this.buildingsData[i].building);
				buildinginstance.SetLevel(1);
				buildinglabel = new BuildingLabel();
				buildinglabel.name = "LABEL";
				if (this.buildingsData[i].label != "")
				{
					Util.SetText(buildinglabel.FIELD, Lang.Get(this.buildingsData[i].label));
				}
				labels.addChild(buildinglabel);
				this.itemsParent.addChild(buildinginstance);
				buildinginstance.data = this.buildingsData[i];
				buildinginstance.name = this.buildingsData[i].booster;
				buildinginstance.data.labelmc = buildinglabel;
				buildinginstance.alpha = 1;
				this.items.push(buildinginstance);
				this.GridSetItemPositionByIndex(buildinginstance, this.buildingsData[i].x, this.buildingsData[i].y);
				buildinglabel.x = buildinginstance.x;
				buildinglabel.y = buildinginstance.y;
				if (this.buildingsData[i].building == "Castle")
				{
					buildinglabel.y -= 20;
				}
				if (this.buildingsData[i].building == "Stonehenge")
				{
					buildinglabel.y += 10;
				}
				hclass = getDefinitionByName("villagemap.gfx." + "Grid" + buildinginstance.data.size + "mc_hit") as Class;
				if (this.buildingsData[i].type == "win" || this.buildingsData[i].type == "forge")
				{
					Imitation.AddEventClick(buildinginstance, function():*
						{
						});
					hitArea = new hclass();
					hitArea.alpha = 0;
					hitArea.name = "HIT_" + this.buildingsData[i].booster;
					this.MAP.addChild(hitArea);
					hitArea.x = buildinginstance.x;
					hitArea.y = buildinginstance.y;
					Imitation.AddEventMouseDown(hitArea, this.MapOnMouseDown);
					Imitation.AddEventMouseUp(hitArea, this.MapOnMouseUp);
					Imitation.AddEventClick(hitArea, function():*
						{
						});
				}
				buildingGrid = new hclass();
				buildinginstance.addChildAt(buildingGrid, 0);
				buildingGrid.name = "MYGRID";
				buildingGrid.visible = false;
				i++;
			}
			this.itemsParent.setChildIndex(labels, this.itemsParent.numChildren - 1);
			this.MapSetBuildingToCenter(MovieClip(this.itemsParent.getChildByName("START_TRIVIADOR")));
		}

		public function MapSetBuildingToCenter(_mc:MovieClip):void
		{
			this.centerItem = _mc;
			this.MAP.x = Math.round(Imitation.stage.stageWidth / 2 - _mc.x * this.appScale);
			this.MAP.y = Math.round(Imitation.stage.stageHeight / 2 - (_mc.y * this.appScale - _mc.height / 2));
			this.MapCheckPos();
		}

		public function MapOnMouseDown(e:Object):void
		{
			var invitem:MovieClip = null;
			this.MAP.drag = true;
			this.MAP.movetx = 0;
			this.MAP.movety = 0;
			this.MAP.touchX = e.stageX;
			this.MAP.touchY = e.stageY;
			this.mapClickCheck = false;
			this.draggedItem = null;
			if (e.target == this.MAP)
			{
				Sys.OnMissClick(e);
			}
			if (e.target.name.indexOf("INVENTORY_") > -1)
			{
				invitem = this.InventoryItemMouseDown(e);
			}
			if (this.gridEditMode && e.target is Building)
			{
				this.MAP.drag = false;
				if (invitem)
				{
					this.draggedItem = invitem;
				}
				else
				{
					this.draggedItem = e.target;
				}
			}
		}

		public function MapOnMouseMove(e:Event):void
		{
			var mp:Point = null;
			if (this.MAP.drag)
			{
				mp = Imitation.GetMousePos(Imitation.stage);
				this.MAP.movetx = mp.x - this.MAP.touchX;
				this.MAP.movety = mp.y - this.MAP.touchY;
				this.MAP.touchX = mp.x;
				this.MAP.touchY = mp.y;
				this.MAP.x += this.MAP.movetx;
				this.MAP.y += this.MAP.movety;
				this.MapCheckPos();
				if (Math.abs(this.MAP.movetx) > 5 || Math.abs(this.MAP.movety) > 5)
				{
					this.mapClickCheck = true;
				}
			}
			if (this.gridEditMode && Boolean(this.draggedItem))
			{
				mp = Imitation.GetMousePos(Imitation.stage);
				this.MAP.movetx = mp.x - this.MAP.touchX;
				this.MAP.movety = mp.y - this.MAP.touchY;
				if (Math.abs(this.MAP.movetx) < 5 && Math.abs(this.MAP.movety) < 5)
				{
					return;
				}
				this.MAP.touchX = mp.x;
				this.MAP.touchY = mp.y;
				this.GridEitDrag();
				this.GridZOrder();
			}
		}

		public function MapOnMouseUp(e:Object):void
		{
			var mp:Point = null;
			if (this.MAP.drag)
			{
				this.MAP.drag = false;
				Util.RemoveEventListener(this.MAP, Event.ENTER_FRAME, this.MapFrictionMove);
				Util.AddEventListener(this.MAP, Event.ENTER_FRAME, this.MapFrictionMove);
			}
			if (this.gridEditMode && Boolean(this.draggedItem))
			{
				mp = Imitation.GetMousePos(Imitation.stage);
				if (mp.y < this.inventory.BG.height)
				{
					this.InventoryRemoveFromMap();
				}
				this.draggedItem = null;
			}
			if (!this.mapClickCheck && !this.gridEditMode)
			{
				this.BuildingButtonClick(e);
			}
		}

		private function MapFrictionMove(e:Event):void
		{
			this.MAP.movetx *= 0.95;
			this.MAP.movety *= 0.95;
			this.MAP.x += this.MAP.movetx;
			this.MAP.y += this.MAP.movety;
			this.MapCheckPos();
			if (Math.abs(this.MAP.movetx) < 1 && Math.abs(this.MAP.movety) < 1)
			{
				this.MAP.removeEventListener(Event.ENTER_FRAME, this.MapFrictionMove);
			}
		}

		private function MapCheckPos():void
		{
			var stageRect:Rectangle = null;
			var i:int = 0;
			var m:DisplayObject = null;
			var rect:Rectangle = null;
			if (this.MAP.x > 0)
			{
				this.MAP.x = 0;
			}
			if (this.MAP.y > 0)
			{
				this.MAP.y = 0;
			}
			if (this.MAP.x < Imitation.stage.stageWidth - this.mapWidth * this.MAP.scaleX)
			{
				this.MAP.x = Imitation.stage.stageWidth - this.mapWidth * this.MAP.scaleX;
			}
			if (this.MAP.y < Imitation.stage.stageHeight - this.mapHeight * this.MAP.scaleY)
			{
				this.MAP.y = Imitation.stage.stageHeight - this.mapHeight * this.MAP.scaleY;
			}
			if (this.gridEditMode)
			{
				stageRect = new Rectangle(0, 0, Imitation.stage.stageWidth, Imitation.stage.stageHeight);
				i = 0;
				while (i < this.items.length)
				{
					m = this.items[i];
					rect = m.getRect(Imitation.stage);
					m.visible = stageRect.intersects(rect);
					i++;
				}
			}
			Util.ShowChildrenOnScreen(this.tiled_background);
		}

		private function MapDraw():void
		{
			var i:int = 0;
			while (i < this.items.length)
			{
				if (MovieClip(this.items[i]).data.type == "win" || MovieClip(this.items[i]).data.type == "forge")
				{
					this.DrawBuilding(MovieClip(this.items[i]));
				}
				i++;
			}
			this.CheckNeedAnimForStartTriviador();
			this.DrawFarms();
			this.DrawEnvironments();
			this.DrawBadgeStatues();
			this.GridZOrder();
		}

		private function CheckNeedAnimForStartTriviador():void
		{
			var sfxo:Object = null;
			var sfxmc:MovieClip = null;
			var c:DisplayObject = null;
			var need:Boolean = true;
			var fx:MovieClip = MovieClip(this.MAP.getChildByName("START_TRIVIADOR_FX"));
			var st:MovieClip = MovieClip(this.MAP.getChildByName("HIT_START_TRIVIADOR"));
			var i:int = 0;
			while (i < this.MAP.numChildren)
			{
				c = this.MAP.getChildAt(i);
				if (c.name.indexOf("_NOTIFICATION") > -1)
				{
					need = false;
				}
				i++;
			}
			if (need)
			{
				if (fx == null)
				{
					sfxo = Modules.GetClass("uibase", "uibase.ShineEffect");
					sfxmc = new sfxo();
					sfxmc.x = st.x;
					sfxmc.y = st.y;
					sfxmc.name = "START_TRIVIADOR_FX";
					this.MAP.addChild(sfxmc);
				}
			}
			else if (Boolean(fx) && this.MAP.contains(fx))
			{
				this.MAP.removeChild(fx);
				fx = null;
			}
		}

		private function DrawBuilding(_mci:MovieClip):void
		{
			var remainingTime:Number;
			var locked:Boolean;
			var percentbar:*;
			var notification:*;
			var hitArea:MovieClip;
			var myforge:Object = null;
			var duration:int = 0;
			var elapsed:int = 0;
			var remaining:int = 0;
			var p:Number = NaN;
			var pp:* = undefined;
			_mci.SetLevel(0);
			remainingTime = 0;
			locked = true;
			if (Boolean(_mci.data.hasOwnProperty("uls")) || _mci.data.uls != null)
			{
				if (Sys.mydata.uls[_mci.data.uls] == 1)
				{
					_mci.SetLevel(this.GetBuildingsData(_mci.data.booster).level);
					locked = false;
				}
				remainingTime = Number(this.GetBuildingsData(_mci.name).remainingtime);
				if (remainingTime > 0)
				{
					myforge = this.GetBuildingsData(_mci.name);
					duration = myforge.prodtime * 60 * 60;
					elapsed = Math.round((getTimer() - Sys.mydata.time) / 1000);
					remaining = myforge.remainingtime - elapsed;
					p = 1 - remaining / duration;
				}
			}
			if (_mci.name == "CASTLE")
			{
				_mci.SetLevel(Sys.mydata.castlelevel);
				_mci.mouseEnabled = true;
				duration = 1 * 24 * 60 * 60;
				elapsed = Math.round((getTimer() - Sys.mydata.time) / 1000);
				remaining = Sys.mydata.taxremaining - elapsed;
				p = 1 - remaining / duration;
				remainingTime = remaining;
				if (Sys.mydata.taxremaining <= 0)
				{
					remainingTime = 0;
				}
				locked = false;
				if (Sys.mydata.xplevel <= 1)
				{
					locked = true;
				}
			}
			percentbar = this.MAP.getChildByName(_mci.data.booster + "_PB");
			if (locked)
			{
				remainingTime = 0;
			}
			if (remainingTime == 0 && percentbar)
			{
				this.MAP.removeChild(percentbar);
			}
			if (p > 1)
			{
				p = 1;
			}
			if (p < 0)
			{
				p = 0;
			}
			if (!percentbar && remainingTime > 0)
			{
				percentbar = new BuildingPercentbarCircle();
				percentbar.name = _mci.data.booster + "_PB";
				percentbar.cacheAsBitmap = true;
				this.MAP.addChild(percentbar);
			}
			if (percentbar)
			{
				percentbar.x = _mci.x + 35;
				percentbar.y = _mci.y - 35;
				pp = Math.round(p * 100);
				if (isNaN(pp) || pp == null)
				{
					pp = 1;
				}
				if (pp < 1)
				{
					pp = 1;
				}
				if (pp > 100)
				{
					pp = 100;
				}
				if (percentbar.MASK)
				{
					percentbar.MASK.gotoAndStop(pp);
				}
				if (_mci.name == "CASTLE")
				{
					percentbar.y = _mci.y - 40;
				}
			}
			if (_mci.name == "CAMP" && Sys.videoad_available)
			{
				remainingTime = 0;
				locked = false;
			}
			if (_mci.name == "CLAN" && Sys.myclanproperties && Sys.myclanproperties.invites > 0)
			{
				remainingTime = 0;
				locked = false;
			}
			notification = this.MAP.getChildByName(_mci.data.booster + "_NOTIFICATION");
			if (locked)
			{
				remainingTime = 1000;
			}
			if (remainingTime == 0)
			{
				if (!notification)
				{
					notification = new Notification();
					notification.name = _mci.data.booster + "_NOTIFICATION";
					notification.gotoAndStop(_mci.name);
					this.MAP.addChild(notification);
					notification.cacheAsBitmap = true;
					Imitation.AddEventClick(notification, function():*
						{
							BuildingButtonClick({"target": _mci});
						});
				}
				TweenMax.killTweensOf(notification);
				notification.x = _mci.x;
				notification.y = _mci.y - 50;
				if (_mci.name == "CASTLE")
				{
					notification.y = _mci.y - 100;
				}
				TweenMax.to(notification, 1, {
							"y": notification.y - 3,
							"onComplete": null,
							"repeat": -1,
							"ease": Elastic.easeOut,
							"delay": Math.random() * 5,
							"yoyo": true
						});
			}
			else if (notification)
			{
				if (this.MAP.contains(notification))
				{
					this.MAP.removeChild(notification);
				}
				TweenMax.killTweensOf(notification);
				Imitation.RemoveEvents(notification);
				notification = null;
			}
			if (_mci.data.type == "win" && _mci.name != "CASTLE")
			{
				_mci.SetLevel(1);
			}
			if (_mci.name == "ATHENEUM" && Sys.mydata.xplevel < 10)
			{
				_mci.SetLevel(0);
			}
			if (_mci.name == "BANK")
			{
				if ((Sys.mydata.flags & Config.UF_ELDORADO) == Config.UF_ELDORADO)
				{
					_mci.SetLevel(10);
				}
				else
				{
					_mci.SetLevel(1);
				}
			}
			if (_mci.name == "START_TRIVIADOR")
			{
				Lang.Set(_mci.BUILDINGGRAPH.ROPE.FIELD, _mci.data.label);
			}
			hitArea = MovieClip(this.MAP.getChildByName("HIT_" + _mci.data.booster));
			if (this.gridEditMode)
			{
				if (hitArea)
				{
					hitArea.visible = false;
				}
				if (notification)
				{
					notification.visible = false;
				}
				if (percentbar)
				{
					percentbar.visible = false;
				}
				if (_mci.getChildByName("MYGRID"))
				{
					_mci.getChildByName("MYGRID").visible = true;
				}
				if (_mci.getChildByName("LABEL"))
				{
					_mci.getChildByName("LABEL").visible = false;
				}
				Imitation.AddEventMouseDown(_mci, this.MapOnMouseDown);
				Imitation.AddEventMouseUp(_mci, this.MapOnMouseUp);
				Imitation.AddEventClick(_mci, function():*
					{
					});
			}
			else
			{
				if (hitArea)
				{
					hitArea.visible = true;
					hitArea.x = _mci.x;
					hitArea.y = _mci.y;
					if (_mci.name == "CAMP" && !Sys.videoad_available)
					{
						Imitation.RemoveEvents(hitArea);
					}
					if (_mci.name == "CAMP" && Sys.videoad_available)
					{
						Imitation.AddEventClick(_mci, function():*
							{
							});
					}
				}
				if (notification)
				{
					notification.visible = true;
				}
				if (percentbar)
				{
					percentbar.visible = true;
				}
				if (_mci.getChildByName("MYGRID"))
				{
					_mci.getChildByName("MYGRID").visible = false;
				}
				if (_mci.getChildByName("LABEL"))
				{
					_mci.getChildByName("LABEL").visible = true;
				}
				Imitation.RemoveEvents(_mci);
			}
			if (_mci.level == 0)
			{
				_mci.data.labelmc.visible = false;
			}
			if (_mci.data.label == "startgame")
			{
				_mci.data.labelmc.visible = false;
			}
		}

		private function DrawFarms():void
		{
			var counter:int;
			var i:int;
			var farm:MovieClip = null;
			var f:int = 0;
			while (f < this.items.length)
			{
				if (this.items[f].name.indexOf("FARMER") > -1)
				{
					this.items[f].SetLevel(0);
					this.items[f].BUILDINGGRAPH.gotoAndStop(1);
					if (f % 3 == 0)
					{
						this.items[f].BUILDINGGRAPH.gotoAndStop(3);
					}
					if (f % 2 == 0)
					{
						this.items[f].BUILDINGGRAPH.gotoAndStop(2);
					}
					if (this.gridEditMode)
					{
						Imitation.AddEventMouseDown(this.items[f], this.MapOnMouseDown);
						Imitation.AddEventMouseUp(this.items[f], this.MapOnMouseUp);
						Imitation.AddEventClick(this.items[f], function():*
							{
							});
						if (this.items[f].getChildByName("MYGRID"))
						{
							this.items[f].getChildByName("MYGRID").visible = true;
						}
					}
					else
					{
						Imitation.RemoveEvents(this.items[f]);
						if (this.items[f].getChildByName("MYGRID"))
						{
							this.items[f].getChildByName("MYGRID").visible = false;
						}
					}
				}
				f++;
			}
			counter = 1;
			i = 1;
			while (i <= Sys.mydata.xplevel)
			{
				if (i <= 200)
				{
					if (counter > 40)
					{
						counter = 1;
					}
					farm = MovieClip(this.itemsParent.getChildByName("FARMER" + counter));
					if (farm)
					{
						farm.SetLevel(farm.level + 1);
					}
					counter++;
					Imitation.FreeBitmapAll(farm);
				}
				i++;
			}
		}

		public function GetLastFarmState():int
		{
			if (Sys.mydata.xplevel <= 40)
			{
				return 1;
			}
			return 0;
		}

		private function DrawEnvironments():void
		{
			var f:int = 0;
			while (f < this.items.length)
			{
				if (this.items[f].data.type == "environment")
				{
					try
					{
						this.items[f].SetLevel(1);
					}
					catch (e:Error)
					{
					}
					if (this.gridEditMode)
					{
						Imitation.AddEventMouseDown(this.items[f], this.MapOnMouseDown);
						Imitation.AddEventMouseUp(this.items[f], this.MapOnMouseUp);
						Imitation.AddEventClick(this.items[f], function():*
							{
							});
					}
					else
					{
						Imitation.RemoveEvents(this.items[f]);
					}
				}
				Imitation.FreeBitmapAll(this.items[f]);
				f++;
			}
		}

		private function DrawBadgeStatues():void
		{
			var f:int;
			var s:MovieClip = null;
			if (Sys.castle_badges != null)
			{
				badgesCastle = Sys.castle_badges;
			}
			f = 0;
			while (f <= 5)
			{
				s = MovieClip(this.itemsParent.getChildByName("STATUEBADGE_" + f));
				s.SetLevel(0);
				if (badgesCastle[f] != null && badgesCastle[f] != undefined && badgesCastle[f] != "")
				{
					s.SetLevel(1);
					s.BUILDINGGRAPH.gotoAndStop(badgesCastle[f].type);
					s.BUILDINGGRAPH.LEVEL.gotoAndStop(badgesCastle[f].level);
				}
				if (this.gridEditMode)
				{
					Imitation.AddEventMouseDown(s, this.MapOnMouseDown);
					Imitation.AddEventMouseUp(s, this.MapOnMouseUp);
					Imitation.AddEventClick(s, function():*
						{
						});
				}
				else
				{
					Imitation.RemoveEvents(s);
				}
				Imitation.FreeBitmapAll(s);
				f++;
			}
		}

		private function BuildingButtonClick(e:Object):void
		{
			var request:* = undefined;
			var notification:* = undefined;
			var exist:Boolean = false;
			var notifs:Object = null;
			var t:String = String(e.target.name.split("HIT_").join(""));
			if (t == "MAP")
			{
				return;
			}
			if (t == "START_KNIGHTGAME")
			{
				WinMgr.OpenWindow("knightgame.Knightgame");
			}
			if (t == "START_TRIVIADOR")
			{
				Comm.SendCommand("CHANGEWAITHALL", "WH=\"GAME\"", this.OnChangeWaithallResult, this);
			}
			if (t == "RANKLIST")
			{
				WinMgr.OpenWindow("ranklist.Ranklist");
			}
			if (t == "POSTOFFICE")
			{
				WinMgr.OpenWindow("profile2.Profile2", {"page": 2});
			}
			if (t == "CASTLE")
			{
				if (Sys.mydata.xplevel > 1)
				{
					WinMgr.OpenWindow("castle.Castle");
				}
			}
			if (t == "LOBBY")
			{
				WinMgr.OpenWindow("lobby.Lobby");
			}
			if (t == "CLAN" && Boolean(Sys.myclanproperties))
			{
				WinMgr.OpenWindow("clan.Clan");
			}
			if (t == "ATHENEUM" && Sys.mydata.xplevel >= 10)
			{
				WinMgr.OpenWindow("library.Library");
			}
			if (t == "BANK")
			{
				WinMgr.OpenWindow("bank.Bank", {"funnelid": "VillageMap"});
			}
			if (t == "FACEBOOKFP")
			{
				if (Config.loginsystem == "FACE" && Util.StringVal(Config.flashvars.fb_access_token) != "" && Util.StringVal(Config.flashvars.permissions).indexOf("user_friends") >= 0)
				{
					WinMgr.OpenWindow("invite.Invite");
				}
				else
				{
					request = new URLRequest(Config["facebook_fp_url_" + Config.siteid]);
					navigateToURL(request, "_blank");
				}
			}
			if (t == "CAMP")
			{
				notification = this.MAP.getChildByName("CAMP_NOTIFICATION");
				if (notification)
				{
					if (this.MAP.contains(notification))
					{
						this.MAP.removeChild(notification);
					}
					TweenMax.killTweensOf(notification);
					notification = null;
				}
				exist = false;
				notifs = Modules.GetClass("uibase", "uibase.Notifications");
				if (Boolean(notifs) && Boolean(notifs.mc))
				{
					exist = true;
				}
				if (exist)
				{
					notifs.Remove({"name": "videoad"});
				}
				if (Sys.videoad_available)
				{
					WinMgr.OpenWindow("reward.Reward", {"type": 1});
				}
			}
			var f:MovieClip = MovieClip(this.itemsParent.getChildByName(t));
			if (f && f.data && Boolean(f.data.hasOwnProperty("uls")) || f.data.uls != null)
			{
				if (Sys.mydata.uls[f.data.uls] != 1)
				{
					return;
				}
			}
			var wf_selhalf:* = (Sys.mydata.windowflags & Config.WF_SELHALF) == Config.WF_SELHALF;
			var wf_selansw:* = (Sys.mydata.windowflags & Config.WF_SELANSW) == Config.WF_SELANSW;
			var wf_tipaver:* = (Sys.mydata.windowflags & Config.WF_TIPAVER) == Config.WF_TIPAVER;
			var wf_tiprang:* = (Sys.mydata.windowflags & Config.WF_TIPRANG) == Config.WF_TIPRANG;
			var wf_airborne:* = (Sys.mydata.windowflags & Config.WF_AIRBORNE) == Config.WF_AIRBORNE;
			var wf_subject:* = (Sys.mydata.windowflags & Config.WF_SUBJECT) == Config.WF_SUBJECT;
			var wf_fortress:* = (Sys.mydata.windowflags & Config.WF_FORTRESS) == Config.WF_FORTRESS;
			var index:int = Util.NumberVal(Config.helpindexes[t]);
			if (index < 1 || index > 12)
			{
				index = 1;
			}
			if (t == "SELHALF" && !wf_selhalf)
			{
				Sys.TutorialCheck("UL:SELHALF");
				return;
			}
			if (t == "SELANSW" && !wf_selansw)
			{
				Sys.TutorialCheck("UL:SELANSW");
				return;
			}
			if (t == "TIPAVER" && !wf_tipaver)
			{
				Sys.TutorialCheck("UL:TIPAVER");
				return;
			}
			if (t == "TIPRANG" && !wf_tiprang)
			{
				Sys.TutorialCheck("UL:TIPRANG");
				return;
			}
			if (t == "AIRBORNE" && !wf_airborne)
			{
				Sys.TutorialCheck("UL:AIRBORNE");
				return;
			}
			if (t == "SUBJECT" && !wf_subject)
			{
				Sys.TutorialCheck("UL:SUBJECT");
				return;
			}
			if (t == "FORTRESS" && !wf_fortress)
			{
				Sys.TutorialCheck("UL:FORTRESS");
				return;
			}
			if (f && f.data && Boolean(f.data.type) && f.data.type == "forge")
			{
				WinMgr.OpenWindow("forge.Forge", {
							"funnelid": "Village",
							"boosterid": index,
							"onclosecallback": this.OnMyDataChange
						});
			}
		}

		private function SwapItemsTo(_targetmc:MovieClip):void
		{
			this.itemsParent = _targetmc;
			var i:int = 0;
			while (i < this.items.length)
			{
				this.itemsParent.addChild(MovieClip(this.items[i]));
				i++;
			}
			this.MapDraw();
			this.TiledBackgroundInit();
			UIBase.HideWaitAnim();
		}

		private function GridZOrder():void
		{
			var yOffset:Number = 0;
			var xOffset:Number = 0;
			var zIndexedItems:Array = new Array();
			var i:int = 0;
			while (i < this.items.length)
			{
				if (this.items[i].data.size == "1x1")
				{
					yOffset = 0;
					xOffset = 1;
				}
				if (this.items[i].data.size == "2x2")
				{
					yOffset = 1;
					xOffset = 1;
				}
				if (this.items[i].data.size == "3x3")
				{
					yOffset = 1;
					xOffset = 3;
				}
				if (this.items[i].data.size == "4x4")
				{
					yOffset = 2;
					xOffset = 4;
				}
				if (this.items[i].data.size == "5x5")
				{
					yOffset = 2;
					xOffset = 4;
				}
				if (this.items[i].data.size == "6x6")
				{
					yOffset = 3;
					xOffset = 4;
				}
				if (this.items[i].data.size == "7x7")
				{
					yOffset = 4;
					xOffset = 4;
				}
				zIndexedItems.push({
							"mc": this.items[i],
							"x": this.items[i].data.x - xOffset,
							"y": this.items[i].data.y - yOffset
						});
				i++;
			}
			zIndexedItems.sortOn(["y", "x"], [Array.NUMERIC, Array.NUMERIC]);
			var j:* = 0;
			while (j < zIndexedItems.length)
			{
				this.itemsParent.setChildIndex(zIndexedItems[j].mc, j + 1);
				j++;
			}
			Imitation.CollectChildrenAll(this.MAP);
		}

		private function GetBuildingsData(str:String):Object
		{
			if (Sys.mydata == null)
			{
				return null;
			}
			var i:uint = 0;
			while (i < Sys.mydata.helpforges.length)
			{
				if (Sys.mydata.helpforges[i] != null && Sys.mydata.helpforges[i].name == str)
				{
					return Sys.mydata.helpforges[i];
				}
				i++;
			}
			var o:Object = new Object();
			o.level = 1;
			return o;
		}

		public function GridCreate():void
		{
			var gexx:Number = NaN;
			var geyy:Number = NaN;
			var j:int = 0;
			this.gridmc = new MovieClip();
			this.MAP.addChild(this.gridmc);
			this.gridArray = new Array();
			var ge:* = new GridElementSpriteGray();
			var gew:Number = Number(ge.width);
			var geh:Number = Number(ge.height);
			this.gridItemWidth = gew;
			this.gridItemHeight = geh;
			var gw:int = int(this.mapWidth / gew);
			var gh:int = int(this.mapHeight / geh) * 2;
			var i:int = 0;
			while (i < gh)
			{
				j = 0;
				while (j < gw)
				{
					if (i % 2 == 0)
					{
						gexx = gew / 2 + gew * j;
						geyy = geh + geh / 2 * i;
					}
					else
					{
						gexx = gew + gew * j;
						geyy = geh + geh / 2 * i;
					}
					this.gridArray.push({
								"xindex": j,
								"yindex": i,
								"x": gexx,
								"y": geyy
							});
					j++;
				}
				i++;
			}
		}

		private function GridSearchByPixel(_x:Number, _y:Number):Object
		{
			var closer:Object = null;
			var t:Number = NaN;
			var tavolsag:Number = 1000000000;
			var i:int = 0;
			while (i < this.gridArray.length)
			{
				t = this.Pit(this.gridArray[i].x, this.gridArray[i].y, _x, _y);
				if (t < tavolsag)
				{
					tavolsag = t;
					closer = this.gridArray[i];
				}
				i++;
			}
			return closer;
		}

		private function GridSearchByIndex(_x:int, _y:int):Object
		{
			var back:Object = null;
			var i:int = 0;
			while (i < this.gridArray.length)
			{
				if (this.gridArray[i].xindex == _x && this.gridArray[i].yindex == _y)
				{
					back = this.gridArray[i];
					break;
				}
				i++;
			}
			return back;
		}

		private function GridEitDrag():*
		{
			var t:Number = NaN;
			if (!this.draggedItem)
			{
				return null;
			}
			var mp:Point = Imitation.GetMousePos(this.MAP);
			var sortedCloserItems:Array = new Array();
			var i:int = 0;
			while (i < this.gridArray.length)
			{
				t = this.Pit(this.gridArray[i].x, this.gridArray[i].y, mp.x, mp.y);
				sortedCloserItems.push({
							"t": t,
							"gai": this.gridArray[i]
						});
				i++;
			}
			sortedCloserItems.sortOn("t", Array.NUMERIC);
			var ind:int = 0;
			while (!this.GridSetItemPositionByIndex(this.draggedItem, sortedCloserItems[ind].gai.xindex, sortedCloserItems[ind].gai.yindex) && ind < sortedCloserItems.length)
			{
				ind++;
			}
		}

		private function GridSetItemPositionByIndex(_mc:MovieClip, _x:int, _y:int):Boolean
		{
			var busyObj:Object = null;
			var i:int = 0;
			var gp:Object = null;
			var b:int = 0;
			var p:int = 0;
			var gridItem:Object = this.GridSearchByIndex(_x, _y);
			if (_y % 2 == 0)
			{
				busyObj = this.evenY;
			}
			else
			{
				busyObj = this.oddY;
			}
			var key:String = "g" + _mc.data.size;
			var busyArrayDefinition:Array = busyObj[key];
			var possibleBusyItems:Array = new Array();
			while (i < busyArrayDefinition.length)
			{
				gp = this.GridSearchByIndex(_x + busyArrayDefinition[i].x, _y + busyArrayDefinition[i].y);
				if (gp == null)
				{
					return false;
				}
				possibleBusyItems.push(gp);
				i++;
			}
			i = 0;
			while (i < this.items.length)
			{
				if (this.draggedItem)
				{
					if (this.items[i] != this.draggedItem)
					{
						if (this.items[i].data.busyItems)
						{
							b = 0;
							while (b < this.items[i].data.busyItems.length)
							{
								p = 0;
								while (p < possibleBusyItems.length)
								{
									if (possibleBusyItems[p].xindex == this.items[i].data.busyItems[b].xindex && possibleBusyItems[p].yindex == this.items[i].data.busyItems[b].yindex)
									{
										return false;
									}
									p++;
								}
								b++;
							}
						}
					}
				}
				i++;
			}
			_mc.x = gridItem.x;
			_mc.y = gridItem.y;
			_mc.data.x = _x;
			_mc.data.y = _y;
			_mc.data.busyItems = possibleBusyItems;
			return true;
		}

		private function WritePositions():Object
		{
			var itw:MovieClip = null;
			var positions:Object = new Object();
			var clipboardText:String = "";
			var i:int = 0;
			while (i < this.items.length)
			{
				positions[this.items[i].name] = {
						"x": this.items[i].data.x,
						"y": this.items[i].data.y
					};
				clipboardText += "buildingsData.push({building: \"" + this.items[i].data.building + "\", booster: \"" + this.items[i].name + "\", label: \"" + this.items[i].data.label + "\", x:\"" + this.items[i].data.x + "\", y:\"" + this.items[i].data.y + "\", uls: " + this.items[i].data.uls + ", size:\"" + this.items[i].data.size + "\", type:\"" + this.items[i].data.type + "\"});\n";
				i++;
			}
			itw = new InventoryTraceWin();
			itw.FIELD.width = Imitation.stage.stageWidth;
			itw.FIELD.height = Imitation.stage.stageHeight - itw.BTN.height;
			itw.BTN.x = Imitation.stage.stageWidth / 2 - itw.BTN.width / 2;
			itw.BTN.y = Imitation.stage.stageHeight - itw.BTN.height;
			addChild(itw);
			itw.FIELD.text = clipboardText;
			itw.BTN.AddEventClick(function():*
				{
					removeChild(itw);
					itw = null;
				});
			return positions;
		}

		private function Pit(x0:*, y0:*, x1:*, y1:*):Number
		{
			return Math.sqrt(Math.pow(x1 - x0, 2) + Math.pow(y1 - y0, 2));
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

		public function ShowSelectRing(aitemname:String, acallback:Function = null):void
		{
			var OnSelectRingClick:Function;
			var f:Fireworks = null;
			var i:int = 0;
			while (i < this.items.length)
			{
				if (this.items[i].name == aitemname)
				{
					this.MapSetBuildingToCenter(this.items[i]);
					this.selectRing = new SelectRing();
					this.MAP.addChild(this.selectRing);
					this.selectRing.alpha = 0.6;
					this.ResizeSelectRing();
					Imitation.AddEventClick(this.selectRing, function():*
						{
						});
					if (acallback != null)
					{
						OnSelectRingClick = function(e:* = null):void
						{
							HideSelectRing();
							HEADER.mouseEnabled = true;
							if (e.params.item.BUILDINGGRAPH != null)
							{
								if (e.params.item.BUILDINGGRAPH.fireworks != null)
								{
									e.params.item.BUILDINGGRAPH.fireworks.destroyMe();
									e.params.item.BUILDINGGRAPH.fireworks = null;
								}
							}
							acallback();
						};
						Imitation.AddEventClick(this.selectRing.BG.HOLEBUTTON, OnSelectRingClick, {"item": this.items[i]});
					}
					f = new Fireworks(this.items[i], 10000000);
					this.MAP.addChild(f);
					this.items[i].BUILDINGGRAPH.fireworks = f;
					this.HEADER.mouseEnabled = false;
					this.GRIDEDITBTNMC.GRIDEDITBUTTON.visible = false;
					break;
				}
				i++;
			}
		}

		public function ResizeSelectRing():void
		{
			this.selectRing.x = this.centerItem.x;
			this.selectRing.y = this.centerItem.y - this.centerItem.height / 2;
			Imitation.FreeBitmapAll(this.selectRing);
			Imitation.UpdateAll(this.selectRing);
		}

		public function HideSelectRing():void
		{
			if (this.selectRing)
			{
				if (this.MAP.contains(this.selectRing))
				{
					this.MAP.removeChild(this.selectRing);
				}
				this.selectRing = null;
			}
			this.GRIDEDITBTNMC.GRIDEDITBUTTON.visible = true;
		}

		private function CheckAutoplayTutorials():void
		{
			Sys.villageautplaytutorial = true;
			if (VillageMap.AutoStartVideoAd)
			{
				return;
			}
			var notifs:Object = Modules.GetClass("uibase", "uibase.Notifications");
			if (Sys.villageautplaytutorial)
			{
				if (Boolean(notifs) && Boolean(notifs.mc))
				{
					notifs.Remove({"name": "tutorial"});
				}
				Sys.TutorialCheck();
				Sys.villageautplaytutorial = false;
			}
			else if (Sys.villageautplaytutorialmission)
			{
				if (Boolean(notifs) && Boolean(notifs.mc))
				{
					notifs.Remove({"name": "tutorialmission"});
				}
				Sys.TutorialMissionCheck();
				Sys.villageautplaytutorialmission = false;
			}
		}

		private function InventoryShow():void
		{
			var itemsHolder:MovieClip;
			var i:int;
			var buildinginstance:* = undefined;
			var lastItem:* = undefined;
			this.InventoryHide();
			this.inventory = new Inventory();
			this.addChild(this.inventory);
			itemsHolder = MovieClip(this.inventory.MASKHOLDER.ITEMSHOLDER);
			i = 0;
			while (i < this.inventoryItems.length)
			{
				buildinginstance = new Building(this.inventoryItems[i].building);
				buildinginstance.SetLevel(1);
				buildinginstance.data = this.inventoryItems[i];
				buildinginstance.name = "INVENTORY_" + this.inventoryItems[i].booster;
				buildinginstance.height = this.inventory.BG.height - 24;
				buildinginstance.y = this.inventory.BG.height - 12;
				buildinginstance.scaleX = buildinginstance.scaleY;
				if (i > 0)
				{
					lastItem = itemsHolder.getChildByName("INVENTORY_" + this.inventoryItems[i - 1].booster);
					buildinginstance.x = lastItem.x + lastItem.width / 2 + buildinginstance.width / 2 + 10;
				}
				else
				{
					buildinginstance.x = buildinginstance.width / 2;
				}
				itemsHolder.addChild(buildinginstance);
				Imitation.AddEventMouseDown(buildinginstance, this.MapOnMouseDown);
				Imitation.AddEventMouseUp(buildinginstance, this.MapOnMouseUp);
				Imitation.AddEventClick(buildinginstance, function():*
					{
					});
				i++;
			}
			this.inventory.PAGELEFT.AddEventClick(this.InventoryPageButtonClick);
			this.inventory.PAGERIGHT.AddEventClick(this.InventoryPageButtonClick);
			this.InventoryResize();
		}

		private function InventoryHide():void
		{
			if (this.inventory != null)
			{
				if (this.contains(this.inventory))
				{
					this.removeChild(this.inventory);
				}
				Imitation.RemoveEvents(this.inventory.BG);
				this.inventory = null;
			}
		}

		private function InventoryResize():void
		{
			this.inventory.scaleX = this.appScale;
			this.inventory.scaleY = this.appScale;
			this.inventory.BG.BASE.width = Imitation.stage.stageWidth / this.appScale;
			var itemsHolder:MovieClip = MovieClip(this.inventory.MASKHOLDER.ITEMSHOLDER);
			this.inventory.PAGELEFT.x = 30;
			this.inventory.PAGERIGHT.x = this.inventory.BG.BASE.width - this.inventory.PAGERIGHT.width - 30;
			this.inventory.MASKHOLDER.MASK.x = this.inventory.PAGELEFT.x + this.inventory.PAGELEFT.width + 10;
			this.inventory.MASKHOLDER.MASK.width = this.inventory.PAGERIGHT.x - this.inventory.PAGELEFT.x - this.inventory.PAGELEFT.width - 20;
			this.inventory.MASKHOLDER.ITEMSHOLDER.x = this.inventory.MASKHOLDER.MASK.x;
			Imitation.FreeBitmapAll(this.inventory);
		}

		private function InventoryItemMouseDown(e:Object):MovieClip
		{
			var buildinginstance:* = new Building(e.target.data.building);
			buildinginstance.SetLevel(1);
			buildinginstance.data = this.CloneObject(e.target.data);
			buildinginstance.name = buildinginstance.data.booster + "_" + this.items.length;
			this.itemsParent.addChild(buildinginstance);
			this.items.push(buildinginstance);
			var hclass:Class = getDefinitionByName("Grid" + e.target.data.size + "mc") as Class;
			var buildingGrid:MovieClip = new hclass();
			buildinginstance.addChildAt(buildingGrid, 0);
			buildingGrid.name = "MYGRID";
			buildingGrid.visible = true;
			buildinginstance.x = e.stageX;
			buildinginstance.y = e.stageY;
			this.DrawEnvironments();
			return MovieClip(buildinginstance);
		}

		private function InventoryPageButtonClick(e:Object):void
		{
			var o:Number = NaN;
			if (e.target.name == "PAGELEFT")
			{
				o = -50;
			}
			if (e.target.name == "PAGERIGHT")
			{
				o = 50;
			}
			this.inventory.MASKHOLDER.ITEMSHOLDER.x += o;
			Imitation.FreeBitmapAll(this.inventory.MASKHOLDER);
		}

		private function InventoryRemoveFromMap():void
		{
			var i:int = 0;
			var c:DisplayObject = null;
			if (this.draggedItem.data.type != "environment")
			{
				return;
			}
			i = 0;
			while (i < this.MAP.numChildren)
			{
				c = this.MAP.getChildByName("HIT_" + this.draggedItem.name);
				if (Boolean(c) && this.MAP.contains(c))
				{
					this.MAP.removeChild(c);
				}
				c = null;
				i++;
			}
			i = 0;
			while (i < this.items.length)
			{
				if (this.items[i] == this.draggedItem)
				{
					this.itemsParent.removeChild(this.items[i]);
					Imitation.RemoveEvents(this.items[i]);
					this.items.splice(i, 1);
				}
				i++;
			}
		}

		public function PauseAllSounds():void
		{
		}

		public function ResumeAllSounds():void
		{
		}

		private function CloneObject(obj:Object):Object
		{
			var temp:ByteArray = new ByteArray();
			temp.writeObject(obj);
			temp.position = 0;
			return temp.readObject();
		}

		private function CreateBitmapClone(_target:MovieClip):MovieClip
		{
			var clonemc:MovieClip = new MovieClip();
			var pic:Object = Util.GetShot(_target);
			var bmp:Bitmap = new Bitmap(pic.b, "auto", true);
			clonemc.addChild(bmp);
			return clonemc;
		}
	}
}
