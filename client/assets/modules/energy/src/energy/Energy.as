package energy {
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import flash.events.*;
		import flash.text.*;
		import flash.utils.*;
		import syscode.*;
		import uibase.lego_button_1x1_cancel_header;
		import uibase.lego_button_3x1_ok;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol604")]
		public class Energy extends MovieClip {
				public static var mc:Energy = null;
				
				public var BTNCLOSE:lego_button_1x1_cancel_header;
				
				public var BTNOK:lego_button_3x1_ok;
				
				public var COST:MovieClip;
				
				public var ENERGY_DATA:MovieClip;
				
				public var INFO:MovieClip;
				
				public var NPC:LegoCharacters;
				
				public var SUPPLY_REFILL:MovieClip;
				
				public var lifeupdatetimer:Timer = null;
				
				public var page:String = "";
				
				public function Energy() {
						super();
				}
				
				public function Prepare(aparams:Object) : void {
						this.page = aparams.page;
						Util.StopAllChildrenMov(this);
						Util.AddEventListener(Imitation.rootmc,"MYDATACHANGE",mc.OnMyDataChange);
						this.BTNCLOSE.AddEventClick(this.Hide);
						this.BTNCLOSE.SetIcon("X");
						this.NPC.Set("VETERAN");
						this.Draw();
				}
				
				private function Draw() : void {
						Imitation.CollectChildrenAll();
						gotoAndStop(this.page);
						Lang.Set(this.SUPPLY_REFILL.FIELD,"energy_supply_refill");
						this.COST.FIELD.text = "20000";
						if(this.page == "BUY") {
								if(Sys.mydata.energy < Sys.mydata.energymax) {
										Lang.Set(this.INFO.FIELD,"energy_info_refill");
										this.BTNOK.SetCaption(Lang.Get("refill_please"));
										this.BTNOK.AddEventClick(this.OnBtnRefill);
										if(this.lifeupdatetimer == null) {
												this.lifeupdatetimer = new Timer(1000,0);
												Util.AddEventListener(this.lifeupdatetimer,TimerEvent.TIMER,this.UpdateNextLifeTime);
												this.lifeupdatetimer.start();
										}
								} else {
										Lang.Set(this.INFO.FIELD,"energy_info_full");
										this.BTNOK.SetCaption(Lang.Get("refill_please"));
										this.BTNOK.SetEnabled(false);
								}
						} else if(this.page == "WARNING") {
								Lang.Set(this.INFO.FIELD,"energy_info_warning");
								this.BTNOK.SetLang("uh_i_know");
								this.BTNOK.AddEventClick(function():* {
										var VillageMap:*;
										var StartWindowMov:*;
										Sys.mydata.energy = Sys.mydata.energymax;
										VillageMap = Modules.GetClass("villagemap","villagemap.VillageMap");
										if(VillageMap.mc) {
												VillageMap.mc.HeaderInitLayout();
										}
										StartWindowMov = Modules.GetClass("triviador","triviador.StartWindowMov");
										if(StartWindowMov.mc) {
												StartWindowMov.mc.DrawMyData();
										}
										gotoAndStop("FREE");
										Lang.Set(INFO.FIELD,"energy_info_free");
										if(INFO.FIELD.numLines >= 3) {
												INFO.FIELD.y = 9;
										}
										if(INFO.FIELD.numLines == 2) {
												INFO.FIELD.y = 18;
										}
										if(INFO.FIELD.numLines == 1) {
												INFO.FIELD.y = 27;
										}
										BTNOK.SetLang("thank_you");
										BTNOK.AddEventClick(function():* {
												Hide();
										});
								});
						}
						if(this.INFO.FIELD.numLines >= 3) {
								this.INFO.FIELD.y = 9;
						}
						if(this.INFO.FIELD.numLines == 2) {
								this.INFO.FIELD.y = 18;
						}
						if(this.INFO.FIELD.numLines == 1) {
								this.INFO.FIELD.y = 27;
						}
						this.DrawEnergy();
				}
				
				public function DrawEnergy() : void {
						var r:Number = Sys.mydata.energy / Sys.mydata.energymax;
						if(r > 1) {
								r = 1;
						}
						this.ENERGY_DATA.ENERGY.BAR.STRIP.scaleX = r;
						this.ENERGY_DATA.ENERGY.PERCENT.FIELD.text = Sys.mydata.energy + " / " + Sys.mydata.energymax;
						if(this.lifeupdatetimer == null) {
								this.lifeupdatetimer = new Timer(1000,0);
								Util.AddEventListener(this.lifeupdatetimer,TimerEvent.TIMER,this.UpdateNextLifeTime);
								this.lifeupdatetimer.start();
						}
						this.UpdateNextLifeTime();
				}
				
				public function UpdateNextLifeTime(event:TimerEvent = null) : void {
						var elapsed:int = Math.round((getTimer() - Sys.mydata.time) / 1000);
						var nextlifesecs:int = Util.NumberVal(Sys.mydata.energynextupdate) - elapsed;
						var energytime:String = "";
						if(nextlifesecs > 0) {
								energytime = Util.FormatRemaining(nextlifesecs);
						}
						if(energytime == "") {
								energytime = "00:00";
						}
						this.ENERGY_DATA.ENERGY.TIME.FIELD.text = energytime;
						if(energytime != this.ENERGY_DATA.ENERGY.TIME.FIELD.text) {
								Imitation.Update(this.ENERGY_DATA.ENERGY);
						}
				}
				
				public function Hide(e:* = null) : void {
						trace("hide called on Energy window");
						WinMgr.CloseWindow(this);
				}
				
				public function AfterClose() : void {
						Util.RemoveEventListener(Imitation.rootmc,"MYDATACHANGE",this.OnMyDataChange);
						if(this.lifeupdatetimer != null) {
								this.lifeupdatetimer.reset();
								Util.RemoveEventListener(this.lifeupdatetimer,TimerEvent.TIMER,this.UpdateNextLifeTime);
								this.lifeupdatetimer = null;
						}
				}
				
				public function OnBtnRefill(e:*) : * {
						Comm.SendCommand("BUYENERGY","",this.OnRefillCallback);
				}
				
				public function OnRefillCallback(res:int, xml:XML) : * {
						if(res == 77) {
								WinMgr.OpenWindow("bank.Bank",{"funnelid":"Energy"});
						}
				}
				
				public function OnMyDataChange(e:*) : * {
						if(Sys.mydata.energy >= Sys.mydata.energymax) {
								this.Hide();
						} else {
								this.Draw();
						}
				}
		}
}

