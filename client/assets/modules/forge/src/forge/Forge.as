package forge {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import flash.display.*;
		import flash.events.*;
		import flash.text.*;
		import flash.utils.Timer;
		import flash.utils.getTimer;
		import syscode.*;
		import uibase.lego_button_1x1_cancel_header;
		import uibase.lego_button_1x1_normal_header;
		import uibase.lego_button_1x1_ok;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol645")]
		public class Forge extends MovieClip {
				public static var mc:Forge = null;
				
				public static var closeaftercollect:Boolean = false;
				
				public static var collectonly:Boolean = false;
				
				public static var upgradeonly:Boolean = false;
				
				public static var showcontinue:Boolean = false;
				
				public static var loading:Boolean = false;
				
				internal static var prevhelpcnt:int = 0;
				
				public static var animateReward:* = false;
				
				public static var mode:* = "NORMAL";
				
				public static var lastlevel:* = 1;
				
				public var ARROW:MovieClip;
				
				public var BOOSTER:MovieClip;
				
				public var BOUGHTBOOSTERS:MovieClip;
				
				public var BTNBUY1:lego_button_1x1_ok;
				
				public var BTNBUY2:lego_button_1x1_ok;
				
				public var BTNBUY3:lego_button_1x1_ok;
				
				public var BTNHELP:lego_button_1x1_normal_header;
				
				public var BTNX:lego_button_1x1_cancel_header;
				
				public var CARDINFO:MovieClip;
				
				public var CHAR:MovieClip;
				
				public var COLLHIGHLIGHT:MovieClip;
				
				public var CURRENTPANEL:MovieClip;
				
				public var ICON2:LegoIconset;
				
				public var ICON3:LegoIconset;
				
				public var INSTOCK:MovieClip;
				
				public var KINGBUBBLE:MovieClip;
				
				public var KINGINFO:MovieClip;
				
				public var LINE1:MovieClip;
				
				public var LINE2:MovieClip;
				
				public var LINE3:MovieClip;
				
				public var STOCK:MovieClip;
				
				public var TABS:HeaderTabs;
				
				public var TUTUPGRARR2:MovieClip;
				
				public var UGHIGHLIGHT:MovieClip;
				
				public var UPGRADEPANEL:MovieClip;
				
				public var WARGOLDS:MovieClip;
				
				public var WARPIECES:MovieClip;
				
				public var WARPRICE:MovieClip;
				
				public var XFIELD:MovieClip;
				
				private var sqc:SqControl;
				
				private var mov:DisplayObject;
				
				public var params:Object;
				
				public var waitanim:Object = null;
				
				public var currentpage:int = 1;
				
				public var guided:Boolean = false;
				
				public var tutorialUpgradeReady:Boolean = false;
				
				public var type:* = "forge";
				
				internal var updatetimer:Timer = null;
				
				public function Forge() {
						super();
				}
				
				public function Prepare(aparams:Object) : void {
						this.params = aparams;
						if(this.params.boosterid >= 8) {
								this.type = "serial";
						} else {
								this.type = "forge";
						}
						this.currentpage = this.type == "serial" ? int(this.params.boosterid - 7) : int(this.params.boosterid);
						this.gotoAndStop("WAITING");
						Forge.animateReward = false;
						this.CARDINFO.visible = false;
						this.DoShow("");
						this.CARDINFO.CLOSE.SetIcon("X");
						Imitation.AddEventClick(this.CARDINFO.CLOSE,function():* {
								CARDINFO.visible = false;
						});
						Imitation.AddEventClick(this.CARDINFO,function():* {
								CARDINFO.visible = false;
						});
				}
				
				public function OnHelpClick(e:*) : void {
						WinMgr.OpenWindow("help.Help",{
								"tab":2,
								"subtab":1
						});
				}
				
				public function DoShow(funnelid:String) : void {
						this.gotoAndStop("NORMAL");
						Util.StopAllChildrenMov(this);
						this.BTNX.AddEventClick(this.HideWithAnim);
						mode = "NORMAL";
						this.DrawTabs();
						this.DrawPage();
				}
				
				public function AfterClose() : void {
						closeaftercollect = false;
						collectonly = false;
						upgradeonly = false;
						showcontinue = false;
						if(this.params.onclosecallback) {
								this.params.onclosecallback();
						}
				}
				
				public function AfterOpen() : void {
						Imitation.FreeBitmapAll(this.TABS["TTAB" + this.currentpage]);
						Imitation.UpdateAll(this.TABS["TTAB" + this.currentpage]);
				}
				
				private function ResetUpdateTimer() : void {
						if(Forge.mc && this.updatetimer && this.updatetimer.hasEventListener(TimerEvent.TIMER)) {
								Util.RemoveEventListener(this.updatetimer,TimerEvent.TIMER,this.UpdateRemainingTime);
								this.updatetimer = null;
						}
				}
				
				public function HideWithAnim(e:* = null) : * {
						this.ResetUpdateTimer();
						if(this.mov) {
								this.mov.visible = false;
						}
						WinMgr.CloseWindow(this);
				}
				
				public function GetOffers(boostername:String) : Array {
						var datas:* = Sys.gameparams.marketdata[Config.helpindexes[boostername] - 1];
						var offers:* = [];
						for(var n:* = 0; n < 3; n++) {
								offers[n] = {
										"amount":Util.NumberVal(datas[n * 2]),
										"price":Util.NumberVal(datas[n * 2 + 1])
								};
						}
						return offers;
				}
				
				public function DrawTabs() : * {
						var i:int = 0;
						var enabled:* = false;
						var tab:MovieClip = null;
						var myforge:Object = null;
						var duration:int = 0;
						var elapsed:int = 0;
						var remaining:int = 0;
						var booster_ids:Array = null;
						var help_ids:Array = null;
						var offset:int = this.type == "serial" ? 7 : 0;
						var num:int = this.type == "serial" ? 5 : 7;
						if(this.TABS.titles.length <= 0) {
								booster_ids = new Array();
								help_ids = new Array();
								for(i = offset; i < offset + num; i++) {
										booster_ids.push(Config.helpfieldname[i]);
										help_ids.push("helpname_" + Config.helpfieldname[i].toLowerCase());
								}
								if(this.type == "serial") {
										booster_ids.push("NO_ICON");
										booster_ids.push("NO_ICON");
										help_ids.push("helpname_SERIAL6_FAKE");
										help_ids.push("helpname_SERIAL7_FAKE");
								}
								this.TABS.Set(help_ids,booster_ids,this.OnLegoTabClick,this.currentpage);
								if(this.type == "serial") {
										this.TABS.Reorder([this.TABS.TTAB1,this.TABS.TTAB2,this.TABS.TTAB3,this.TABS.TTAB4,this.TABS.TTAB5,this.TABS.TTAB6,this.TABS.TTAB7],[true,true,false,false,false,false,false]);
								}
						}
						for(i = 1; i <= num; i++) {
								tab = this.TABS["TTAB" + i];
								enabled = Config.helpullevels[i + offset - 1] <= Sys.mydata.xplevel;
								myforge = Sys.mydata.helpforges[i + offset];
								duration = myforge.prodtime * 60 * 60;
								elapsed = Math.round((getTimer() - Sys.mydata.time) / 1000);
								remaining = myforge.remainingtime - elapsed;
								this.TABS.Notify(tab,false);
								if(enabled) {
										this.TABS.UnlockTab(tab);
										if(remaining <= 0) {
												this.TABS.Notify(tab,true,String("+" + myforge.prodcount));
										}
								} else {
										this.TABS.LockTab(tab);
								}
								this.TABS.SetValue(tab,String(Sys.mydata.freehelps[i + offset]));
						}
						Imitation.FreeBitmapAll(this.TABS);
						Imitation.UpdateAll(this.TABS);
				}
				
				public function OnTabClick(e:*) : * {
						var tab:* = e.target.parent;
						var num:int = Util.IdFromStringEnd(tab.name);
						mode = "NORMAL";
						this.SetActivePage(num);
				}
				
				public function OnLegoTabClick(_pagenumber:Number) : * {
						mode = "NORMAL";
						this.SetActivePage(_pagenumber);
				}
				
				public function SetActivePage(apagenum:int) : * {
						this.currentpage = apagenum;
						this.DrawTabs();
						this.DrawPage();
				}
				
				public function DrawPage() : void {
						this.DrawForgePage();
						this.DrawUpgradePage();
				}
				
				public function DrawForgePage() : void {
						var line:MovieClip = null;
						var btn:* = undefined;
						var offer:Object = null;
						if(!mc) {
								return;
						}
						var offset:int = this.type == "serial" ? 7 : 0;
						TweenMax.killChildTweensOf(mc,true);
						if(this.sqc) {
								this.sqc.Clear();
						}
						if(Boolean(this.mov) && Boolean(this.mov.parent)) {
								this.mov.parent.removeChild(this.mov);
								this.mov = null;
						}
						this.gotoAndStop("NORMAL");
						this.BTNX.AddEventClick(this.HideWithAnim);
						this.BTNX.SetIcon("X");
						this.BTNHELP.SetIcon("HELP");
						this.BTNHELP.AddEventClick(this.OnHelpClick);
						var titletf:TextFormat = new TextFormat();
						var boostername:String = Config.helpfieldname[this.currentpage - 1 + offset];
						var helpmaker:String = Config.helpmakers[this.currentpage - 1 + offset];
						var myforge:Object = Sys.mydata.helpforges[this.currentpage + offset];
						var duration:int = myforge.prodtime * 60 * 60;
						var elapsed:* = (getTimer() - Sys.mydata.time) / 1000;
						var remaining:int = myforge.remainingtime - elapsed;
						var p:Number = 1 - remaining / duration;
						if(p > 1) {
								p = 1;
						}
						prevhelpcnt = Sys.mydata.freehelps[this.currentpage + offset];
						this.UGHIGHLIGHT.stop();
						this.UGHIGHLIGHT.visible = false;
						this.COLLHIGHLIGHT.stop();
						this.COLLHIGHLIGHT.visible = false;
						this.BOUGHTBOOSTERS.ICONSET.gotoAndStop(boostername);
						this.BOUGHTBOOSTERS.visible = false;
						Lang.Set(this.CHAR.INFO.FIELD,"marketwork_" + helpmaker,Sys.mydata.name);
						Lang.Set(this.WARPRICE.FIELD,"warprice+:");
						Lang.Set(this.INSTOCK.FIELD,"in_stock+:");
						this.XFIELD.FIELD.text = "X";
						var pordtimetxt:String = Config.rtl ? myforge.prodtime + " / " + myforge.prodcount : myforge.prodcount + " / " + myforge.prodtime;
						this.STOCK.FIELD.text = Sys.mydata.freehelps[this.currentpage + offset];
						this.CHAR.NPC.Set(boostername,"DEFAULT");
						var offers:Array = this.GetOffers(boostername);
						this.WARGOLDS.FIELD.text = Util.FormatNumber(Sys.gameparams.helpprices[this.currentpage + offset]);
						this.WARPIECES.FIELD.text = "1";
						this.ICON2.Set(boostername);
						this.ICON3.Set(boostername);
						Imitation.FreeBitmapAll(this.ICON2);
						Imitation.FreeBitmapAll(this.ICON3);
						for(var n:int = 1; n <= 3; n++) {
								line = this["LINE" + n];
								btn = this["BTNBUY" + n];
								offer = offers[n - 1];
								if(offer) {
										line.ICONSET.Set(boostername);
										line.PIECES.FIELD.text = offer.amount;
										line.GOLDS.FIELD.text = Util.FormatNumber(offer.price);
										line.XFIELD.FIELD.text = "X";
										Imitation.FreeBitmapAll(line);
										Imitation.UpdateAll(line);
										offer.id = n;
										btn.AddEventClick(this.OnBuyClick,{
												"name":boostername,
												"offer":offer
										});
										btn.SetIcon("CHECKOUT");
										line.visible = true;
										btn.visible = true;
								} else {
										line.visible = false;
										btn.visible = false;
								}
						}
						this.BOOSTER.PRODCNT.FIELD.text = "×" + myforge.prodcount;
						if(remaining <= 0) {
								this.BOOSTER.gotoAndStop(1);
								this.BOOSTER.gotoAndStop(2);
								this.BOOSTER.ANIM.ICONSET.Set(boostername);
								this.BOOSTER.ANIM.stop();
								TweenMax.fromTo(this.BOOSTER.ANIM,90 / 60,{"frame":1},{
										"frame":90,
										"ease":Linear.easeNone,
										"repeat":-1
								});
								this.BOOSTER.BTNCOLLECT.AddEventClick(this.OnCollectClick);
								this.BOOSTER.BTNCOLLECT.visible = true;
								this.BOOSTER.BTNCOLLECT.SetLang("collect");
								Lang.Set(mc.CHAR.INFO.FIELD,"marketinfo_" + helpmaker,Sys.mydata.name);
						} else {
								this.BOOSTER.gotoAndStop(1);
								this.BOOSTER.ICONSET.Set(boostername);
								TweenMax.killChildTweensOf(this.BOOSTER);
								this.UpdateRemainingTime();
						}
						if(upgradeonly) {
								Lang.Set(this.CHAR.INFO.FIELD,"level_upgrade_selhalf",Sys.mydata.name);
								this.UGHIGHLIGHT.visible = true;
								TweenMax.fromTo(this.UGHIGHLIGHT,40 / 60,{"frame":1},{
										"frame":40,
										"ease":Linear.easeNone,
										"repeat":-1
								});
								if(this.BOOSTER.BTNCOLLECT) {
										this.BOOSTER.BTNCOLLECT.visible = false;
								}
								this.HideBuyButtons();
						} else if(collectonly) {
								this.HideHighlightArrows();
								this.COLLHIGHLIGHT.visible = true;
								TweenMax.fromTo(this.COLLHIGHLIGHT,40 / 60,{"frame":1},{
										"frame":40,
										"ease":Linear.easeNone,
										"repeat":-1
								});
								this.HideBuyButtons();
						}
						if(this.COLLHIGHLIGHT.visible || this.UGHIGHLIGHT.visible) {
								this.BTNX.visible = false;
						} else if(showcontinue) {
								this.BTNX.visible = false;
						} else {
								this.BTNX.visible = true;
								this.BTNX.SetIcon("X");
						}
						if(this.CHAR.INFO.FIELD.numLines >= 4) {
								this.CHAR.INFO.FIELD.y = 9;
						}
						if(this.CHAR.INFO.FIELD.numLines == 3) {
								this.CHAR.INFO.FIELD.y = 18;
						}
						if(this.CHAR.INFO.FIELD.numLines == 2) {
								this.CHAR.INFO.FIELD.y = 28;
						}
						if(this.CHAR.INFO.FIELD.numLines == 1) {
								this.CHAR.INFO.FIELD.y = 38;
						}
						Imitation.Update(this.CHAR);
				}
				
				private function OnInfoBtnClick(e:Object) : void {
						this.CARDINFO.visible = true;
						var forgenum:int = this.currentpage + (this.type == "serial" ? 7 : 0);
						var myforge:Object = Sys.mydata.helpforges[forgenum];
						Lang.Set(mc.CARDINFO.TITLE.FIELD,"helpname_" + myforge.name.toLowerCase());
						Lang.Set(mc.CARDINFO.TEXT.FIELD,"tut_" + myforge.name.toLowerCase() + "_s04");
				}
				
				public function DrawUpgradePage() : void {
						var w:* = undefined;
						if(!mc) {
								return;
						}
						var forgenum:int = this.currentpage + (this.type == "serial" ? 7 : 0);
						this.TUTUPGRARR2.visible = false;
						this.TUTUPGRARR2.gotoAndStop(1);
						var myforge:Object = Sys.mydata.helpforges[forgenum];
						var helpmaker:String = Config.helpmakers[forgenum - 1];
						var pordtimetxt:String = Config.rtl ? myforge.prodtime + " / " + myforge.prodcount : myforge.prodcount + " / " + myforge.prodtime;
						if(myforge.nextlevel > 0 && myforge.upgradeprice == 0) {
								Lang.Set(mc.CHAR.INFO.FIELD,"upgradeinfo_blacksmith_free",Sys.mydata.name);
						}
						this.UPGRADEPANEL.visible = true;
						this.UPGRADEPANEL.gotoAndStop(1);
						lastlevel = myforge.level;
						var freeupgrade:Boolean = false;
						if(myforge.nextlevel > myforge.level) {
								gotoAndStop("UPGRADE");
								if(!TweenMax.isTweening(this.UPGRADEPANEL)) {
										this.UPGRADEPANEL.gotoAndStop(1);
								}
								w = this.UPGRADEPANEL.PANEL;
								w.HOUSE.SetupForge(forgenum,myforge.nextlevel);
								w.BTNUPGRADE.SetLang("upgrade_it");
								Lang.Set(w.LEVEL.FIELD,"level_n",myforge.nextlevel);
								Util.SetText(w.PRODUCTION.FIELD,myforge.nextlevelpc + " / " + myforge.nextlevelpt + " " + Lang.Get("a_hour"));
								if(myforge.upgradeprice == 0) {
										Lang.Set(w.UPGRADEPRICE.FIELD,"free");
										w.GOLDICON.visible = false;
										this.guided = Forge.upgradeonly;
										freeupgrade = true;
								} else {
										w.UPGRADEPRICE.FIELD.text = Util.FormatNumber(myforge.upgradeprice);
										w.GOLDICON.visible = true;
								}
								w.BTNUPGRADE.visible = true;
								w.BTNUPGRADE.SetHandler("click",this.OnUpgradeNow);
								if(Sys.mydata.xplevel < 5) {
										w.BTNUPGRADE.visible = false;
										w.UPGRADEPRICE.visible = false;
										w.GOLDICON.visible = false;
								} else {
										w.BTNUPGRADE.visible = true;
										w.UPGRADEPRICE.visible = true;
										w.GOLDICON.visible = true;
								}
								if(Sys.mydata.action == "GIFT:SELHALF_UP") {
										if(!this.tutorialUpgradeReady) {
												this.TUTUPGRARR2.visible = true;
												TweenMax.fromTo(this.TUTUPGRARR2,40 / 60,{"frame":1},{
														"frame":40,
														"ease":Linear.easeNone,
														"repeat":-1
												});
										}
								}
						} else {
								gotoAndStop("KING");
								this.UPGRADEPANEL.visible = false;
								Lang.Set(mc.CHAR.INFO.FIELD,"marketinfo_" + helpmaker,Sys.mydata.name);
								Lang.Set(this.KINGINFO.FIELD,"king_upgrades_ready",Lang.Get("char_" + helpmaker));
						}
						this.BTNX.visible = !this.guided;
						if(!this.BTNX.visible) {
								if(!freeupgrade) {
										if(myforge.upgradeprice > 0) {
												w.BTNUPGRADE.BUTTON.SetEnabled(false);
												w.BTNUPGRADE.alpha = 0.2;
												Lang.Set(mc.CHAR.INFO.FIELD,"upgradeinfo_blacksmith_first",Sys.mydata.name);
										}
								}
						}
						w = this.CURRENTPANEL;
						mc.ARROW.visible = myforge.nextlevel > myforge.level;
						w.HOUSE.SetupForge(forgenum,myforge.level);
						Lang.Set(w.CURRENTLEVEL.FIELD,"current_level");
						Lang.Set(w.LEVEL.FIELD,"level_n",myforge.level);
						Util.SetText(w.PRODUCTION.FIELD,myforge.prodcount + " / " + myforge.prodtime + " " + Lang.Get("a_hour"));
						this.DrawTabs();
				}
				
				public function OnBackClick(e:Object) : void {
						mode = "NORMAL";
						this.DrawPage();
				}
				
				public function OnUpgradeNow(e:* = null) : void {
						var forgenum:int = this.currentpage + (this.type == "serial" ? 7 : 0);
						this.UPGRADEPANEL.PANEL.BTNUPGRADE.visible = false;
						this.TUTUPGRARR2.visible = false;
						this.TUTUPGRARR2.gotoAndStop(1);
						this.tutorialUpgradeReady = true;
						Comm.SendCommand("UPGRADEFORGE","HELP=\"" + Config.helpfieldname[forgenum - 1] + "\"",this.OnUpgradeResult,this);
				}
				
				public function OnShareClick(self:Forge, token:String, shareid:String, amount:String) : void {
						var gift:MovieClip = self.getChildByName("GIFTSHARE") as MovieClip;
						if(gift != null) {
								gift.BTNSHARE.BUTTON.SetEnabled(false);
						}
						self.DoShow("forgeupgrade");
						var params:Object = {
								"cid":2,
								"uttag":Util.NewPostId(Sys.mydata.id),
								"gift":token
						};
						if(Config.indesigner) {
								return;
						}
						Util.ExternalCall("FBPostFeed","?" + Util.FormatGetParams(params),Config.baseurl + "/client/assets/share/" + shareid + ".png",Lang.Get("giftshare_" + shareid + "_link",amount),Lang.Get("giftshare_" + shareid + "_caption",amount,Config.loginusername),"upgrade_" + shareid,0,Sys.FunnelVersion());
				}
				
				public function UpgradeAnimComplete() : void {
						this.DrawPage();
				}
				
				public function HideBuyButtons() : * {
						var btn:* = undefined;
						for(var n:int = 1; n <= 3; n++) {
								btn = this["BTNBUY" + n];
								if(btn) {
										btn.visible = false;
								}
						}
				}
				
				public function HideHighlightArrows() : * {
						this.UGHIGHLIGHT.stop();
						this.UGHIGHLIGHT.visible = false;
						this.COLLHIGHLIGHT.stop();
						this.COLLHIGHLIGHT.visible = false;
						collectonly = false;
						upgradeonly = false;
				}
				
				public function UpdateRemainingTime(event:TimerEvent = null) : void {
						var d2:String = null;
						var forgenum:int = this.currentpage + (this.type == "serial" ? 7 : 0);
						if(!this.BOOSTER) {
								return;
						}
						var myforge:Object = Sys.mydata.helpforges[forgenum];
						var duration:int = myforge.prodtime * 60 * 60;
						var elapsed:int = Math.round((getTimer() - Sys.mydata.time) / 1000);
						var remaining:int = myforge.remainingtime - elapsed;
						var p:Number = 1 - remaining / duration;
						if(p > 1) {
								p = 1;
						}
						if(remaining <= 0) {
								if(this.updatetimer != null) {
										this.updatetimer.stop();
										this.updatetimer = null;
								}
								this.DrawPage();
								return;
						}
						var perint:int = int(p * 100 + 0.001);
						var perstring:* = int(p * 100 + 0.001) + "%";
						this.BOOSTER.PERCENTBAR.STRIP.scaleX = perint / 100;
						Lang.Set(this.BOOSTER.PERCENTBAR.FIELD.FIELD,"remaining_time");
						var d:String = Util.FormatRemaining(remaining,true,false);
						if(d.indexOf(" ") > -1) {
								d2 = d.substr(0,d.indexOf(" "));
						} else {
								d2 = "0";
						}
						this.BOOSTER.REMAINING_TIME.DAILYRESETDAY.FIELD.text = d2;
						this.BOOSTER.REMAINING_TIME.DAILYTIME.FIELD.text = Util.FormatRemaining(remaining,false,true);
						if(this.updatetimer == null) {
								this.updatetimer = new Timer(1000,0);
								Util.AddEventListener(this.updatetimer,TimerEvent.TIMER,this.UpdateRemainingTime);
								this.updatetimer.start();
						}
				}
				
				public function OnCollectClick(e:*) : * {
						var forgenum:int = this.currentpage + (this.type == "serial" ? 7 : 0);
						this.HideHighlightArrows();
						this.BOOSTER.BTNCOLLECT.visible = false;
						Comm.SendCommand("COLLECTHELP","HELP=\"" + Config.helpfieldname[forgenum - 1] + "\"",this.OnCollectResult,this);
				}
				
				public function OnBuyClick(e:*) : void {
						var ecode:int = 0;
						var emsg:String = null;
						var name:String = e.params.name;
						var offer:Object = e.params.offer;
						var forgenum:int = this.currentpage + (this.type == "serial" ? 7 : 0);
						if(Forge.animateReward) {
								return;
						}
						Forge.animateReward = true;
						this.SetEnabledBuyBtns(!Forge.animateReward);
						this.SetEnabledTabs(!Forge.animateReward);
						if(Semu.enabled) {
								ecode = 0;
								emsg = "";
								if(Semu.mydata.golds >= offer.price) {
										Semu.mydata.freehelps[forgenum - 1] += offer.amount;
										Semu.sendmydata = true;
										if(Comm.listening) {
												Semu.SendAnswerDelayed(0.1);
										}
								} else {
										ecode = 10;
										emsg = "Insufficient golds.";
								}
								this.HandleBuyResult(0);
						} else {
								Comm.SendCommand("BUYHELP","HELP=\"" + name + "\" INDEX=\"" + offer.id + "\" PRICE=\"" + offer.price + "\" AMOUNT=\"" + offer.amount + "\"",this.HandleBuyResult,this);
						}
				}
				
				public function OnUpgradeClick(e:*) : void {
						mode = "UPGRADE";
						gotoAndStop("UPGRADE");
						Util.StopAllChildrenMov(this);
						this.DrawTabs();
						this.DrawPage();
				}
				
				public function HandleBuyResult(res:int, xml:XML = null) : void {
						if(res == 0) {
								this.AnimateBooster();
								return;
						}
						if(res == 77) {
								WinMgr.OpenWindow("bank.Bank",{"funnelid":"Forge"});
								Forge.animateReward = false;
								this.SetEnabledBuyBtns(!Forge.animateReward);
								this.SetEnabledTabs(!Forge.animateReward);
								return;
						}
				}
				
				public function AnimateBooster() : * {
						var forgenum:int;
						var Anim:Object;
						var newhelpcnt:int;
						var cnt:int = 0;
						if(this.currentFrameLabel != "NORMAL") {
						}
						forgenum = this.currentpage + (this.type == "serial" ? 7 : 0);
						Anim = Modules.GetClass("uibase","uibase.Anim");
						newhelpcnt = int(Sys.mydata.freehelps[forgenum]);
						if(newhelpcnt != prevhelpcnt) {
								if(this.BOOSTER.currentFrame == 2 && !this.BOOSTER.BTNCOLLECT.visible) {
										this.mov = Anim.RaiseItemOff(null,this.BOOSTER.ANIM.ICONSET);
								} else {
										cnt = newhelpcnt - prevhelpcnt;
										this.BOUGHTBOOSTERS.CNT.FIELD.text = "x" + cnt;
										this.BOUGHTBOOSTERS.visible = true;
										this.mov = Anim.RaiseItemOff(null,this.BOUGHTBOOSTERS);
										this.BOUGHTBOOSTERS.visible = false;
								}
								this.mov.visible = true;
								Imitation.CollectChildrenAll(this);
								Imitation.UpdateAll();
								this.sqc = new SqControl("booster-collect");
								this.sqc.AddDelay(0.001);
								Anim.AnimateRewardTo(this.sqc,this.mov,this.STOCK.FIELD,prevhelpcnt,newhelpcnt);
								this.sqc.AddCallBack2(function():* {
										DrawTabs();
										DrawPage();
										Forge.animateReward = false;
										SetEnabledBuyBtns(!Forge.animateReward);
										SetEnabledTabs(!Forge.animateReward);
								});
								this.sqc.Start();
								prevhelpcnt = newhelpcnt;
						} else {
								this.DrawTabs();
								this.DrawPage();
								Forge.animateReward = false;
								this.SetEnabledBuyBtns(!Forge.animateReward);
								this.SetEnabledTabs(!Forge.animateReward);
						}
				}
				
				public function OnUpgradeResult(res:int, xml:XML) : void {
						var VillageMap:* = undefined;
						if(res == 0) {
								VillageMap = Modules.GetClass("villagemap","villagemap.VillageMap");
								if(VillageMap && Boolean(VillageMap.mc)) {
										VillageMap.mc.redrawVillage = true;
								}
								mc.ARROW.visible = false;
								this.UPGRADEPANEL.gotoAndPlay(1);
								TweenMax.delayedCall(2,this.UpgradeAnimComplete);
						} else if(res == 77) {
								WinMgr.OpenWindow("bank.Bank",{"funnelid":"Forge"});
								this.DrawPage();
						}
				}
				
				public function OnCollectResult(res:int, xml:XML) : void {
						if(res != 0) {
								return;
						}
						this.AnimateBooster();
				}
				
				public function SetEnabledBuyBtns(aenabled:Boolean) : void {
						var btn:* = undefined;
						for(var n:int = 1; n <= 3; n++) {
								btn = this["BTNBUY" + n];
								if(btn) {
										btn.enabled = aenabled;
								}
						}
				}
				
				public function SetEnabledTabs(_enabled:Boolean) : void {
						if(!_enabled) {
								Imitation.AddEventClick(this.TABS,function():* {
										trace("blokker");
								});
						} else {
								Imitation.RemoveEvents(this.TABS);
						}
				}
		}
}

