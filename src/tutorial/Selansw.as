package tutorial
{
	import flash.display.MovieClip;

	import uibase.Building;
	import uibase.gfx.lego_button_1x1_ok;
		import syscode.WinMgr;
	import syscode.Lang;
	import syscode.Sys;
	import syscode.Modules;
	import syscode.Util;
	import syscode.AvatarMov;
	import uibase.gfx.LegoIconset;
	import uibase.gfx.LegoCharacters;
	import syscode.Config;

	[Embed(source="/modules/tutorial_assets.swf", symbol="symbol428")]
	public class Selansw extends MovieClip
	{
		public static var mc:Selansw = null;

		public var AVATAR:AvatarMov;

		public var AVATARTEXT:MovieClip;

		public var BOOSTERBG:MovieClip;

		public var BTN_NEXT:lego_button_1x1_ok;

		public var BTN_PREV:lego_button_1x1_ok;

		public var ICON:LegoIconset;

		public var NPC:LegoCharacters;

		public var NPCTEXT:MovieClip;

		public var texts:Array;

		public var index:int = 0;

		public var buildinginstance:*;

		public var buildingname:String;

		public var iconname:String;

		public var npcframes:Array;

		public function Selansw()
		{
			this.texts = new Array();
			super();
		}

		public static function StartMe():void
		{
			WinMgr.OpenWindow(Selansw, {});
		}

		public static function OnAssetsLoaded(e:* = null):void
		{
			mc.buildinginstance = new Building(mc.buildingname);
			mc.buildinginstance.SetLevel(1);
			mc.buildinginstance.BG.visible = false;
			mc.addChild(mc.buildinginstance);
			mc.buildinginstance.height = 200;
			mc.buildinginstance.scaleX = mc.buildinginstance.scaleY;
			mc.buildinginstance.x = 586;
			mc.buildinginstance.y = 300;
		}

		public static function OnForgeWinClosed():void
		{
			var VillageMap:* = Modules.GetClass("villagemap", "villagemap.VillageMap");
			if (VillageMap && Boolean(VillageMap.mc))
			{
				VillageMap.mc.redrawVillage = true;
			}
			Tutorial.TutorialFinished();
		}

		public function Prepare(aparams:Object):*
		{
			this.texts[0] = [Lang.Get("tut_2_selansw_s00"), Lang.Get("tut_2_selansw_s01")];
			this.texts[1] = [Lang.Get("tut_2_selansw_s02"), Lang.Get("tut_2_selansw_s03")];
			this.texts[2] = [Lang.Get("tut_2_selansw_s04"), Lang.Get("tut_2_selansw_s05")];
			this.texts[3] = [Lang.Get("tut_2_selansw_s06"), Lang.Get("tut_2_selansw_s07")];
			this.texts[4] = [Lang.Get("tut_2_selansw_s08"), Lang.Get("tut_2_selansw_s09")];
			this.buildingname = "Inn";
			this.iconname = "SELANSW";
			this.NPC.Set("INNKEEPER", "DEFAULT");
			this.npcframes = new Array("DEFAULT", "WARN", "DEFAULT", "HAPPY", "WARN");
			gotoAndStop(1);
			this.BTN_NEXT.AddEventClick(this.OnNextClicked);
			this.BTN_NEXT.SetIcon("PLAY");
			this.BTN_PREV.AddEventClick(this.OnPrevClicked);
			this.BTN_PREV.SetIcon("LEFT");
			this.AVATAR.ShowUID(Sys.mydata.id);
			this.ICON.Set(this.iconname);
			var Building:Object = Modules.GetClass("uibase", "uibase.Building");
			Building.LoadGFX(OnAssetsLoaded);
			this.DrawPage();
		}

		public function AfterOpen():void
		{
		}

		public function DrawPage():void
		{
			if (this.index > this.texts.length - 1)
			{
				WinMgr.CloseWindow(this);
				return;
			}
			if (this.index <= 0)
			{
				this.index = 0;
				this.BTN_PREV.SetEnabled(false);
			}
			else
			{
				this.BTN_PREV.SetEnabled(true);
			}
			if (this.index >= 0 && this.index <= 4)
			{
				mc.buildinginstance.SetLevel(this.index + 1);
			}
			this.NPC.Set("INNKEEPER", this.npcframes[this.index]);
			this.BOOSTERBG.visible = this.index > 0 ? true : false;
			Util.SetText(this.NPCTEXT.FIELD, this.texts[this.index][0].replace("$1", Sys.mydata.name));
			Util.SetText(this.AVATARTEXT.FIELD, this.texts[this.index][1].replace("$1", Sys.mydata.name));
			if (this.NPCTEXT.FIELD.numLines >= 4)
			{
				this.NPCTEXT.FIELD.y = 9;
			}
			if (this.NPCTEXT.FIELD.numLines == 3)
			{
				this.NPCTEXT.FIELD.y = 18;
			}
			if (this.NPCTEXT.FIELD.numLines == 2)
			{
				this.NPCTEXT.FIELD.y = 29;
			}
			if (this.NPCTEXT.FIELD.numLines == 1)
			{
				this.NPCTEXT.FIELD.y = 39;
			}
			if (this.AVATARTEXT.FIELD.numLines >= 3)
			{
				this.AVATARTEXT.FIELD.y = 0;
			}
			if (this.AVATARTEXT.FIELD.numLines == 2)
			{
				this.AVATARTEXT.FIELD.y = 10;
			}
			if (this.AVATARTEXT.FIELD.numLines == 1)
			{
				this.AVATARTEXT.FIELD.y = 20;
			}
		}

		public function OnNextClicked(arg:Object):void
		{
			++this.index;
			this.DrawPage();
		}

		public function OnPrevClicked(arg:Object):void
		{
			--this.index;
			this.DrawPage();
		}

		public function AfterClose():void
		{
			var forgename:String = Tutorial.currentaction.split(":")[1];
			var forgeid:int = int(Config.helpindexes[forgename]);
			WinMgr.OpenWindow("forge.Forge", {
						"boosterid": forgeid,
						"onclosecallback": OnForgeWinClosed
					});
		}
	}
}
