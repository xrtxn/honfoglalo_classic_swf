package tutorial {
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import flash.events.*;
		import flash.utils.*;
		import syscode.*;
		import uibase.Building;
		import uibase.lego_button_1x1_ok;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol435")]
		public class Castle extends MovieClip {
				public static var mc:Castle = null;
				
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
				
				public function Castle() {
						this.texts = new Array();
						super();
				}
				
				public static function StartMe() : void {
						WinMgr.OpenWindow(Castle,{});
				}
				
				public static function OnAssetsLoaded(e:* = null) : void {
						trace("Tutorial.Castle.OnAssetsLoaded");
						mc.buildinginstance = new Building(mc.buildingname);
						mc.buildinginstance.SetLevel(1);
						mc.buildinginstance.BG.visible = false;
						mc.addChild(mc.buildinginstance);
						mc.buildinginstance.height = 200;
						mc.buildinginstance.scaleX = mc.buildinginstance.scaleY;
						mc.buildinginstance.x = 586;
						mc.buildinginstance.y = 310;
				}
				
				public function Prepare(aparams:Object) : * {
						trace("Tutorial.Castle.Prepare");
						this.texts[0] = [Lang.Get("tut_castle_s00"),Lang.Get("tut_castle_s01")];
						this.buildingname = "Castle";
						this.iconname = "GOLD2";
						this.NPC.Set("MESSENGER","DEFAULT");
						this.npcframes = new Array("DEFAULT","WARN","DEFAULT","HAPPY","WARN");
						gotoAndStop(1);
						this.BTN_NEXT.AddEventClick(this.OnNextClicked);
						this.BTN_NEXT.SetIcon("PLAY");
						this.BTN_PREV.AddEventClick(this.OnPrevClicked);
						this.BTN_PREV.SetIcon("LEFT");
						this.AVATAR.ShowUID(Sys.mydata.id);
						this.ICON.Set(this.iconname);
						var Building:Object = Modules.GetClass("uibase","uibase.Building");
						Building.LoadGFX(OnAssetsLoaded);
						this.DrawPage();
				}
				
				public function AfterOpen() : void {
						trace("Tutorial.Castle.AfterOpen");
				}
				
				public function DrawPage() : void {
						trace("Tutorial.Castle.DrawPage");
						if(this.index > this.texts.length - 1) {
								WinMgr.CloseWindow(this);
								return;
						}
						if(this.index <= 0) {
								this.index = 0;
								this.BTN_PREV.SetEnabled(false);
						} else {
								this.BTN_PREV.SetEnabled(true);
						}
						if(this.index >= 0 && this.index <= 4) {
								mc.buildinginstance.SetLevel(this.index + 1);
						}
						this.NPC.Set("MESSENGER",this.npcframes[this.index]);
						Util.SetText(this.NPCTEXT.FIELD,this.texts[this.index][0].replace("$1",Sys.mydata.name));
						Util.SetText(this.AVATARTEXT.FIELD,this.texts[this.index][1].replace("$1",Sys.mydata.name));
						if(this.NPCTEXT.FIELD.numLines >= 4) {
								this.NPCTEXT.FIELD.y = 9;
						}
						if(this.NPCTEXT.FIELD.numLines == 3) {
								this.NPCTEXT.FIELD.y = 18;
						}
						if(this.NPCTEXT.FIELD.numLines == 2) {
								this.NPCTEXT.FIELD.y = 29;
						}
						if(this.NPCTEXT.FIELD.numLines == 1) {
								this.NPCTEXT.FIELD.y = 39;
						}
						if(this.AVATARTEXT.FIELD.numLines >= 3) {
								this.AVATARTEXT.FIELD.y = 0;
						}
						if(this.AVATARTEXT.FIELD.numLines == 2) {
								this.AVATARTEXT.FIELD.y = 10;
						}
						if(this.AVATARTEXT.FIELD.numLines == 1) {
								this.AVATARTEXT.FIELD.y = 20;
						}
				}
				
				public function OnNextClicked(arg:Object) : void {
						++this.index;
						this.DrawPage();
				}
				
				public function OnPrevClicked(arg:Object) : void {
						--this.index;
						this.DrawPage();
				}
				
				public function AfterClose() : void {
						WinMgr.OpenWindow("castle.Castle");
						Tutorial.TutorialFinished();
				}
		}
}
