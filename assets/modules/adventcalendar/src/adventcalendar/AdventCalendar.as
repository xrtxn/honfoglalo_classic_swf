package adventcalendar {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import components.ButtonComponent;
		import flash.display.*;
		import flash.text.*;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol102")]
		public class AdventCalendar extends MovieClip {
				public static var mc:AdventCalendar = null;
				
				public static const NOT_OPENABLE:uint = 0;
				
				public static const OPENABLE:uint = 1;
				
				public static const MISSED:uint = 2;
				
				public static const OPENED:uint = 3;
				
				public static const OPENED_TODAY:uint = 4;
				
				private static var windows:Array = [];
				
				private static var goldgifts:Array = [];
				
				private static var prevfreehelps:Array = [];
				
				private static var gift:String = null;
				
				private static var gold:int = -1;
				
				private static var cons:uint = 0;
				
				private static var state:String = "SHOW";
				
				private static var advent:uint = 0;
				
				public var ANIM_CHEST:MovieClip;
				
				public var ANIM_GOLDSHARE:MovieClip;
				
				public var ANIM_GOLD_0:MovieClip;
				
				public var ANIM_GOLD_1:MovieClip;
				
				public var ANIM_GOLD_2:MovieClip;
				
				public var ANIM_GOLD_3:MovieClip;
				
				public var BACK:MovieClip;
				
				public var BOUNDS:MovieClip;
				
				public var BTN:ButtonComponent;
				
				public var C_1:MovieClip;
				
				public var C_10:MovieClip;
				
				public var C_11:MovieClip;
				
				public var C_12:MovieClip;
				
				public var C_13:MovieClip;
				
				public var C_14:MovieClip;
				
				public var C_15:MovieClip;
				
				public var C_16:MovieClip;
				
				public var C_17:MovieClip;
				
				public var C_18:MovieClip;
				
				public var C_19:MovieClip;
				
				public var C_2:MovieClip;
				
				public var C_20:MovieClip;
				
				public var C_21:MovieClip;
				
				public var C_22:MovieClip;
				
				public var C_23:MovieClip;
				
				public var C_24:MovieClip;
				
				public var C_3:MovieClip;
				
				public var C_4:MovieClip;
				
				public var C_5:MovieClip;
				
				public var C_6:MovieClip;
				
				public var C_7:MovieClip;
				
				public var C_8:MovieClip;
				
				public var C_9:MovieClip;
				
				public var C_ANIM:MovieClip;
				
				public var GAMEBOOSTERS:MovieClip;
				
				public var GIFT:MovieClip;
				
				public var TXT_GOLD_0:TextField;
				
				public var TXT_GOLD_1:TextField;
				
				public var TXT_GOLD_2:TextField;
				
				public var TXT_GOLD_3:TextField;
				
				public var TXT_HAPPY:TextField;
				
				public var TXT_OPEN:TextField;
				
				public var W_1:MovieClip;
				
				public var W_10:MovieClip;
				
				public var W_11:MovieClip;
				
				public var W_12:MovieClip;
				
				public var W_13:MovieClip;
				
				public var W_14:MovieClip;
				
				public var W_15:MovieClip;
				
				public var W_16:MovieClip;
				
				public var W_17:MovieClip;
				
				public var W_18:MovieClip;
				
				public var W_19:MovieClip;
				
				public var W_2:MovieClip;
				
				public var W_20:MovieClip;
				
				public var W_21:MovieClip;
				
				public var W_22:MovieClip;
				
				public var W_23:MovieClip;
				
				public var W_24:MovieClip;
				
				public var W_3:MovieClip;
				
				public var W_4:MovieClip;
				
				public var W_5:MovieClip;
				
				public var W_6:MovieClip;
				
				public var W_7:MovieClip;
				
				public var W_8:MovieClip;
				
				public var W_9:MovieClip;
				
				private var dailywindow:MovieClip = null;
				
				public function AdventCalendar() {
						super();
						this.__setProp_BTN_CalendarWindowMov_buttons_0();
				}
				
				public static function OnSendWindowOpen(e:Object) : void {
						var lm:MovieClip = MovieClip(e.target);
						if(lm) {
								Imitation.RemoveEvents(lm);
						}
						WinMgr.ShowLoadWait();
						JsQuery.Load(AdventCalendar.OnWindowOpenResult,[],Config.ADVENT_PHP + Sys.FormatGetParamsStoc({},true),{
								"cmd":"open",
								"advent":advent
						});
				}
				
				public static function OnWindowOpenResult(_jsq:Object) : void {
						var i:uint = 0;
						WinMgr.HideLoadWait();
						if(Util.NumberVal(_jsq.error) > 0) {
								AdventCalendar.mc.Hide();
						} else {
								AdventCalendar.cons = Util.NumberVal(_jsq.data.cons);
								AdventCalendar.gold = Util.StringVal(_jsq.data.gold);
								AdventCalendar.gift = Util.StringVal(_jsq.data.gift);
								for(i = 0; i < AdventCalendar.windows.length; i++) {
										if(AdventCalendar.windows[i] == AdventCalendar.OPENABLE) {
												AdventCalendar.windows[i] = AdventCalendar.OPENED_TODAY;
										}
								}
								if(AdventCalendar.mc) {
										AdventCalendar.mc.Draw();
								}
								if(AdventCalendar.mc) {
										AdventCalendar.mc.PlayGiftAnim();
								}
						}
				}
				
				public static function OnLoadAdventState() : void {
						WinMgr.ShowLoadWait();
						JsQuery.Load(AdventCalendar.OnAdventStateResult,[],Config.ADVENT_PHP + Sys.FormatGetParamsStoc({},true),{
								"cmd":"show",
								"advent":advent
						});
				}
				
				public static function OnAdventStateResult(_jsq:Object) : void {
						WinMgr.HideLoadWait();
						if(Util.NumberVal(_jsq.error) <= 0) {
								AdventCalendar.prevfreehelps = [];
								AdventCalendar.prevfreehelps = AdventCalendar.prevfreehelps.concat(Sys.mydata.freehelps);
								AdventCalendar.windows = _jsq.data.windows;
								AdventCalendar.goldgifts = _jsq.data.goldgifts;
								AdventCalendar.cons = Util.NumberVal(_jsq.data.cons);
								AdventCalendar.mc.Draw();
								AdventCalendar.mc.DrawCashbars();
								AdventCalendar.mc.DrawBoosters();
								if(AdventCalendar.mc) {
										WinMgr.WindowDataArrived(AdventCalendar.mc);
								}
						}
				}
				
				public function Prepare(aparams:Object) : void {
						Util.StopAllChildrenMov(this);
						aparams.waitfordata = true;
						if(Util.StringVal(aparams.state) != "") {
								AdventCalendar.state = Util.StringVal(aparams.state);
						}
						advent = Util.NumberVal(aparams.advent);
						AdventCalendar.OnLoadAdventState();
				}
				
				public function Draw() : void {
						var lm:MovieClip = null;
						var txt:TextField = null;
						Util.StopAllChildrenMov(this);
						TweenMax.killTweensOf(this);
						if(Config.siteid == "tr" || Config.siteid == "xa") {
								this.BACK.SNOW.visible = false;
								Imitation.FreeBitmapAll(this.BACK);
						}
						this.BTN.SetLangAndClick("okay",this.Hide);
						this.BTN.visible = AdventCalendar.state == "SHOW";
						this.ANIM_GOLDSHARE.visible = false;
						this.GIFT.visible = this.C_ANIM.visible = false;
						this.ANIM_GOLD_0.visible = this.ANIM_GOLD_1.visible = false;
						this.ANIM_GOLD_2.visible = this.ANIM_GOLD_3.visible = false;
						Lang.Set(this.TXT_HAPPY,"happy_holydays");
						Lang.Set(this.TXT_OPEN,"open_gift");
						for(var i:uint = 0; i < AdventCalendar.goldgifts.length; i++) {
								txt = this["TXT_GOLD_" + i];
								if(txt) {
										Util.SetText(txt,Util.StringVal(AdventCalendar.goldgifts[i]));
								}
						}
						for(i = 0; i < AdventCalendar.windows.length; i++) {
								lm = this["W_" + (i + 1)];
								if(lm) {
										Imitation.GotoFrame(lm,Util.NumberVal(AdventCalendar.windows[i]) + 1);
								}
								if(Boolean(lm) && lm.currentFrame - 1 == AdventCalendar.OPENABLE) {
										this.dailywindow = lm;
										TweenMax.fromTo(this.dailywindow.SHAPE,0.4,{"frame":1},{
												"frame":25,
												"repeat":-1
										});
										Imitation.AddEventClick(this.dailywindow,AdventCalendar.OnSendWindowOpen);
								}
						}
				}
				
				public function DrawCashbars() : void {
						var lm:MovieClip = null;
						for(var i:uint = 1; i <= AdventCalendar.cons; i++) {
								lm = this["C_" + i];
								if(lm) {
										Imitation.GotoFrame(lm,2);
										Imitation.FreeBitmapAll(lm);
								}
						}
				}
				
				public function DrawBoosters() : void {
						var enabled:Boolean = false;
						var bm:MovieClip = null;
						for(var i:int = 1; i <= 12; i++) {
								bm = this.GAMEBOOSTERS["BOOSTER" + i];
								enabled = false;
								Imitation.GotoFrame(bm.BASE.ICON,i);
								Imitation.GotoFrame(bm.BASE.LOCK,i);
								if(i == 1 && Sys.mydata.uls[9] == 1) {
										enabled = true;
								}
								if(i == 2 && Sys.mydata.uls[10] == 1) {
										enabled = true;
								}
								if(i == 3 && Sys.mydata.uls[11] == 1) {
										enabled = true;
								}
								if(i == 4 && Sys.mydata.uls[12] == 1) {
										enabled = true;
								}
								if(i == 5 && Sys.mydata.uls[13] == 1) {
										enabled = true;
								}
								if(i == 6 && Sys.mydata.uls[14] == 1) {
										enabled = true;
								}
								if(i == 7 && Sys.mydata.uls[15] == 1) {
										enabled = true;
								}
								if(i == 8 && Sys.mydata.uls[16] == 1) {
										enabled = true;
								}
								if(i == 9 && Sys.mydata.uls[17] == 1) {
										enabled = true;
								}
								if(i == 10 && Sys.mydata.uls[18] == 1) {
										enabled = true;
								}
								if(i == 11 && Sys.mydata.uls[19] == 1) {
										enabled = true;
								}
								if(i == 12 && Sys.mydata.uls[20] == 1) {
										enabled = true;
								}
								bm.BASE.LOCK.visible = !enabled;
								bm.VALUE.text = Sys.mydata.freehelps[i];
								bm.BUYBTNMC.visible = false;
								bm.BUYBTNMC.scaleX = 0.8;
								bm.BUYBTNMC.scaleY = 0.8;
								bm.GLOW.visible = false;
								bm.GLOW.alpha = 0;
								bm.PLUSS.visible = false;
								bm.BUYBTNMC.visible = false;
						}
						Imitation.FreeBitmapAll(this.GAMEBOOSTERS);
				}
				
				public function AfterOpen() : void {
				}
				
				public function AfterClose() : void {
				}
				
				public function Hide(e:Object = null) : void {
						Util.StopAllChildrenMov(this);
						TweenMax.killTweensOf(this);
						WinMgr.CloseWindow(this);
				}
				
				private function RemoveGift() : void {
						this.GIFT.visible = false;
				}
				
				public function PlayGiftAnim() : void {
						var target:MovieClip = null;
						var sq:SqControl = null;
						AdventCalendar.gift = AdventCalendar.gift.toUpperCase();
						var originalscale:* = this.scaleX;
						var n:int = int(AdventCalendar.prevfreehelps[Config.helpindexes[AdventCalendar.gift]]);
						if(Config.helpindexes[AdventCalendar.gift]) {
								target = this.GAMEBOOSTERS["BOOSTER" + Config.helpindexes[AdventCalendar.gift]];
						}
						if(target) {
								this.GIFT.ICON.gotoAndStop(AdventCalendar.gift);
								this.GIFT.scaleX = this.GIFT.scaleY = this.scaleX;
								this.GIFT.cacheAsBitmap = true;
								this.GIFT.tx = this.GAMEBOOSTERS.x + target.x * this.GAMEBOOSTERS.scaleX;
								this.GIFT.ty = this.GAMEBOOSTERS.y + target.y * this.GAMEBOOSTERS.scaleY;
								this.GIFT.x = this.dailywindow.x;
								this.GIFT.y = this.dailywindow.y;
								this.GIFT.visible = false;
								TweenMax.fromTo(this.GIFT,0.8,{"visible":true},{
										"delay":0.2,
										"scaleX":originalscale,
										"scaleY":originalscale,
										"bezier":[{
												"x":this.dailywindow.x,
												"y":this.dailywindow.y - 100
										},{
												"x":this.GIFT.tx,
												"y":this.GIFT.ty,
												"scaleX":originalscale * 3,
												"scaleY":originalscale * 3
										}],
										"onComplete":this.RemoveGift,
										"ease":Sine.easeInOut
								});
								target.GLOW.visible = true;
								TweenMax.to(target.GLOW,1,{
										"alpha":1,
										"delay":0.4
								});
								sq = new SqControl("advent_valueroll." + AdventCalendar.gift);
								sq.AddDelay(0.8);
								Modules.GetClass("uibase","uibase.Anim").ValueRollUp(sq,target.VALUE,n,n + 1);
								sq.Start("advent_valueroll." + AdventCalendar.gift);
						}
						if(AdventCalendar.cons > 0) {
								this.C_ANIM.y = this["C_" + AdventCalendar.cons].y;
						}
						TweenMax.delayedCall(1.7,this.UpdateCurrentCashbar);
						TweenMax.fromTo(this.C_ANIM,0.6,{
								"visible":true,
								"frame":1
						},{
								"frame":9,
								"delay":1.4,
								"onComplete":this.CheckShareGold
						});
				}
				
				private function UpdateCurrentCashbar() : void {
						var lm:MovieClip = null;
						if(AdventCalendar.cons > 0) {
								lm = this["C_" + AdventCalendar.cons];
								if(lm) {
										Imitation.GotoFrame(lm,2);
										Imitation.FreeBitmapAll(lm);
								}
						}
				}
				
				private function CheckShareGold() : void {
						var cbindex:int = 0;
						this.C_ANIM.visible = false;
						if(AdventCalendar.gold == 0) {
								this.FadeInBtn();
						} else {
								cbindex = int(AdventCalendar.goldgifts.indexOf(AdventCalendar.gold));
								if(cbindex > -1) {
										this.PlayJumpGold(this["ANIM_GOLD_" + cbindex]);
								} else {
										this.FadeInBtn();
								}
						}
				}
				
				private function PlayJumpGold(_cb:MovieClip) : void {
						var duration:Number = 0.4 + AdventCalendar.goldgifts.indexOf(AdventCalendar.gold) * 0.1;
						if(_cb) {
								TweenMax.fromTo(_cb,duration,{
										"visible":true,
										"frame":1
								},{
										"frame":15,
										"delay":0.1,
										"onComplete":this.PlayChestAnim
								});
						} else {
								this.FadeInBtn();
						}
				}
				
				private function PlayChestAnim() : void {
						this.ANIM_GOLD_0.visible = this.ANIM_GOLD_1.visible = false;
						this.ANIM_GOLD_2.visible = this.ANIM_GOLD_3.visible = false;
						TweenMax.fromTo(this.ANIM_CHEST,0.5,{
								"frame":1,
								"visible":true
						},{
								"frame":10,
								"delay":0.1,
								"onComplete":this.FadeInBtn
						});
				}
				
				private function FadeInBtn() : void {
						this.GIFT.visible = this.C_ANIM.visible = false;
						this.ANIM_GOLDSHARE.visible = this.ANIM_CHEST.visible = false;
						this.ANIM_GOLD_0.visible = this.ANIM_GOLD_1.visible = false;
						this.ANIM_GOLD_2.visible = this.ANIM_GOLD_3.visible = false;
						TweenMax.fromTo(this.BTN,0.3,{
								"visible":true,
								"alpha":0
						},{
								"alpha":1,
								"delay":0.7
						});
				}
				
				internal function __setProp_BTN_CalendarWindowMov_buttons_0() : * {
						try {
								this.BTN["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN.enabled = true;
						this.BTN.fontsize = "MEDIUM";
						this.BTN.icon = "";
						this.BTN.skin = "OK";
						this.BTN.testcaption = "OK";
						this.BTN.visible = true;
						this.BTN.wordwrap = false;
						try {
								this.BTN["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

