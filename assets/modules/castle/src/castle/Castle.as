package castle {
		import com.adobe.serialization.json.ADOBEJSON;
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import flash.events.*;
		import flash.text.TextFormat;
		import flash.text.TextFormatAlign;
		import flash.utils.Timer;
		import flash.utils.getTimer;
		import syscode.*;
		import uibase.Building;
		import uibase.ScrollBarMov9;
		import uibase.lego_button_1x1_cancel_header;
		import uibase.lego_button_1x1_normal_header;
		import uibase.lego_button_3x1_ok;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol753")]
		public class Castle extends MovieClip {
				public static var mc:Castle = null;
				
				public static var badges:Array = [];
				
				public static var castle_badges:Array = [null,null,null,null,null,null];
				
				public static var badgenames:* = ["CW1","CW2","XPT","XPM","RLP","TWD","USQ","EXT"];
				
				public static var badgelevellimits:* = {
						"CW1":[5,10,20,40,60,80,100],
						"CW2":[5,10,20,40,60,80,100],
						"TWD":[10,20,50,100,200,500,1000],
						"XPT":[5000,10000,20000,50000,100000,200000,500000],
						"RLP":[50,40,30,20,10,5,1],
						"XPM":[500,1000,1500,2000,2500,3000,3500],
						"USQ":[100,50,20,10,3,2,1],
						"EXT":[10,0,0,0,0,0,0]
				};
				
				internal static var prevgold:int = 0;
				
				public var ASSETS:MovieClip;
				
				public var BADGESCORE:MovieClip;
				
				public var BADGE_PER:MovieClip;
				
				public var BASIC:MovieClip;
				
				public var BTNCLOSE:lego_button_1x1_cancel_header;
				
				public var BTNCONTINUE:lego_button_3x1_ok;
				
				public var BTNHELP:lego_button_1x1_normal_header;
				
				public var CARDINFO:MovieClip;
				
				public var CASTLE:Building;
				
				public var COLLECT:MovieClip;
				
				public var DRAGDROP:MovieClip;
				
				public var FRAME:MovieClip;
				
				public var INCOME:MovieClip;
				
				public var ITEMS2:CastleItems2;
				
				public var LEVEL:MovieClip;
				
				public var LEVELSCORE:MovieClip;
				
				public var L_BADGES:MovieClip;
				
				public var L_BASIC:MovieClip;
				
				public var L_EARN_IN:MovieClip;
				
				public var L_LEVELSCORE:MovieClip;
				
				public var L_PEOPLE:MovieClip;
				
				public var MYGOLDS:MovieClip;
				
				public var NEWBADGESINFO:MovieClip;
				
				public var NPC:LegoCharacters;
				
				public var PEOPLE:MovieClip;
				
				public var PMUL:MovieClip;
				
				public var PROGRESS:MovieClip;
				
				public var S1:MovieClip;
				
				public var S2:MovieClip;
				
				public var S3:MovieClip;
				
				public var S4:MovieClip;
				
				public var S5:MovieClip;
				
				public var S6:MovieClip;
				
				public var SB2:ScrollBarMov9;
				
				public var SCROLLRECT2:MovieClip;
				
				public var SLOT1:MovieClip;
				
				public var SLOT2:MovieClip;
				
				public var SLOT3:MovieClip;
				
				public var SLOT4:MovieClip;
				
				public var SLOT5:MovieClip;
				
				public var SLOT6:MovieClip;
				
				public var TAXMOV:MovieClip;
				
				public var TIME:MovieClip;
				
				public var TITLE:MovieClip;
				
				public var VALUE:MovieClip;
				
				public var dragdrop:DragAndDrop = null;
				
				public var badges_loaded:Boolean = false;
				
				public var castle_badges_rendered:Boolean = false;
				
				public var castle_badges_changed:Boolean = false;
				
				private var tutorialCallback:Function = null;
				
				private var currenttype:int = 1;
				
				private var last_tax_value:* = 0;
				
				private var data:Object;
				
				public var firstitem:int = 1;
				
				public var loading:Boolean = false;
				
				private var castle_badges_loading:Boolean;
				
				private var csillamsample:MovieClip = null;
				
				private var arenewbadges:* = false;
				
				private var werenew:*;
				
				private var initialized:Boolean = false;
				
				private var newcount:* = 0;
				
				internal var updatetimer:Timer = null;
				
				public function Castle() {
						this.werenew = {};
						super();
				}
				
				public static function CollectProc(e:* = null) : * {
						if(!mc) {
								return;
						}
						mc.COLLECT.visible = false;
						Comm.SendCommand("COLLECTTAX","");
				}
				
				public static function OnBadgesLoaded(jsq:*) : * {
						trace("-------------------------------OnBadgesLoaded");
						if(!mc) {
								return;
						}
						mc.loading = false;
						DBG.Trace("jsq",jsq);
						trace("jsq.data: " + ADOBEJSON.encode(jsq.data));
						if(jsq.error != 0) {
								WinMgr.WindowDataArrived(mc);
								WinMgr.HideLoadWait();
								mc.Hide();
								return;
						}
						mc.badges_loaded = true;
						mc.data = jsq.data["allbadges"];
						Castle.castle_badges = jsq.data["castlebadges"];
						mc.ProcessBadgeData();
						Util.AddEventListener(mc,Event.ENTER_FRAME,mc.BadgeRenderer);
				}
				
				public static function SetCastleBadges() : * {
						trace("SetCastleBadges");
						JsQuery.Load(OnCastleBadgesSet,[],"client_castle.php?stoc=" + Config.stoc + "&cmd=set",castle_badges);
				}
				
				public static function OnCastleBadgesSet(jsq:*) : * {
						trace("OnCastleBadgesSet");
						if(jsq.error != 0) {
								return;
						}
				}
				
				public function Hide(e:* = null) : void {
						this.CleanUp();
						WinMgr.CloseWindow(this);
				}
				
				public function AfterClose() : void {
						SetCastleBadges();
						Sys.castle_badges = castle_badges;
						Util.RemoveEventListener(Imitation.rootmc,"MYDATACHANGE",this.OnMyDataChange);
						Util.RemoveEventListener(this,Event.ENTER_FRAME,this.BadgeRenderer);
						if(this.SCROLLRECT2) {
								Imitation.SetMaskedMov(this.SCROLLRECT2,null);
						}
						this.dragdrop.Remove();
						if(this.tutorialCallback != null) {
								this.tutorialCallback();
						}
				}
				
				public function Prepare(aparams:Object) : void {
						var i:int = 0;
						var j:int = 0;
						var s:MovieClip = null;
						this.initialized = false;
						aparams.waitfordata = true;
						if(aparams.onclosecallback != null) {
								this.tutorialCallback = aparams.onclosecallback;
						}
						this.BTNCLOSE.AddEventClick(this.Hide);
						this.BTNCLOSE.SetIcon("X");
						this.BTNHELP.SetIcon("HELP");
						this.BTNHELP.AddEventClick(this.OnHelpClick);
						Util.StopAllChildrenMov(this);
						Imitation.CollectChildrenAll();
						Modules.GetClass("uibase","uibase.List");
						Modules.GetClass("uibase","uibase.Building");
						this.CASTLE.CreateMC("Castle");
						this.CASTLE.SetLevel(Sys.mydata.castlelevel);
						this.ASSETS.visible = false;
						this.CARDINFO.visible = false;
						this.SCROLLRECT2.visible = false;
						this.DRAGDROP.visible = false;
						this.DrawTax();
						this.dragdrop = new DragAndDrop(mc.DRAGDROP,this.OnDrop,this.OnCancel);
						this.CheckAllBadges();
						this.SCROLLRECT2.visible = true;
						this.ITEMS2.Set("S",[],this.ITEMS2.S1.height + 4,1,this.OnClickItem,this.DrawItem,this.SCROLLRECT2,this.SB2);
						this.ITEMS2.isaligned = false;
						i = 1;
						while(i <= 6) {
								s = mc["S" + i];
								this.dragdrop.AddTarget(s);
								s.visible = false;
								Imitation.AddEventClick(s,function(e:Object):* {
										var n:*;
										var o:*;
										if(!e.target.visible || dragdrop.dragging || arenewbadges) {
												return;
										}
										n = Util.IdFromStringEnd(e.target.name);
										castle_badges[n - 1] = null;
										dragdrop.mc.id = e.target.id;
										dragdrop.mc.scaleY = 1.5;
										dragdrop.mc.scaleX = 1.5;
										SetStatue(dragdrop.mc,true);
										dragdrop.DragBack(e.target);
										GlowAnim();
										e.target.visible = false;
										o = ITEMS2.GetVisibleItem(e.target.id);
										if(o) {
												ITEMS2.Draw();
										} else {
												ITEMS2.scrollbar.ScrollTo(e.target.id,0.5,function():* {
														ITEMS2.Draw();
												});
										}
										DrawArrows();
								});
								i++;
						}
						this.CARDINFO.CLOSE.SetIcon("X");
				}
				
				public function AfterOpen() : void {
						Util.AddEventListener(Imitation.rootmc,"MYDATACHANGE",this.OnMyDataChange);
						Imitation.AddEventClick(this.CARDINFO,function():* {
								CARDINFO.visible = false;
						});
						Imitation.AddEventClick(this.CARDINFO.CLOSE,function():* {
								CARDINFO.visible = false;
						});
				}
				
				private function BadgeRenderer(e:Event) : void {
						var type:* = undefined;
						var level:* = undefined;
						var m:MovieClip = null;
						var i:* = 0;
						while(i < badges.length) {
								type = badges[i].type;
								level = badges[i].level;
								if(!this.ASSETS["STATUE" + type + "_" + level]) {
										if(level == 1 || badges[i].count > 0) {
												m = new this.ASSETS.STATUE.constructor();
												m.filters = this.ASSETS.STATUE.filters;
												m.scaleX = m.scaleY = 0.8;
												m.gotoAndStop(type);
												m.LEVEL.gotoAndStop(level);
												this.ASSETS["STATUE" + type + "_" + level] = m;
												this.ASSETS.addChild(m);
												m = new this.ASSETS.WATERMARK.constructor();
												m.filters = this.ASSETS.WATERMARK.filters;
												m.scaleX = m.scaleY = 0.8;
												m.gotoAndStop(type);
												m.LEVEL.gotoAndStop(level);
												this.ASSETS["WATERMARK" + type + "_" + level] = m;
												this.ASSETS.addChild(m);
												return;
										}
										this.ASSETS["STATUE" + type + "_" + level] = this.ASSETS.STATUE;
										this.ASSETS["WATERMARK" + type + "_" + level] = this.ASSETS.WATERMARK;
								}
								i++;
						}
						this.castle_badges_rendered = true;
						Util.RemoveEventListener(this,Event.ENTER_FRAME,this.BadgeRenderer);
						this.SyncLoadedBadges();
				}
				
				public function DrawTax() : void {
						var tf_xa:TextFormat = null;
						prevgold = Sys.mydata.gold;
						var elapsed:int = Math.round((getTimer() - Sys.mydata.time) / 1000);
						var remaining:int = Sys.mydata.taxremaining - elapsed;
						if(remaining > 0) {
								if(Config.rtl) {
										this.gotoAndStop("RTL");
								} else {
										this.gotoAndStop("PROGRESS");
								}
						} else if(Config.rtl) {
								this.gotoAndStop("RTLCOLLECT");
						} else {
								this.gotoAndStop("COLLECT");
						}
						Util.SetText(this.TITLE.FIELD,Lang.Get("your_castle+:"),true);
						Util.SetText(this.LEVEL.FIELD,Lang.Get("level_n_2",Sys.mydata.castlelevel),true);
						this.MYGOLDS.VALUE.FIELD.text = Util.FormatNumber(Sys.mydata.gold);
						trace("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
						trace(Lang.Get("basic+:"));
						trace("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
						Util.SetText(this.INCOME.FIELD,Lang.Get("income+:"),true);
						Util.SetText(this.L_BASIC.FIELD,Lang.Get("basic+:"),true);
						Util.SetText(this.L_PEOPLE.FIELD,Lang.Get("people+:"),true);
						Util.SetText(this.L_LEVELSCORE.FIELD,Lang.Get("castle_level_n",Sys.mydata.castlelevel),true);
						Util.SetText(this.L_BADGES.FIELD,Lang.Get("badges+:"),true);
						this.BASIC.FIELD.text = Sys.mydata.taxbasic;
						this.PEOPLE.FIELD.text = Sys.mydata.taxfamilies;
						this.LEVELSCORE.FIELD.text = Sys.mydata.taxcastle;
						this.BADGESCORE.FIELD.text = Sys.mydata.badgebonus;
						this.BADGE_PER.FIELD.text = Sys.mydata.badgepercent + "%";
						if(this.PMUL) {
								Util.SetText(this.PMUL.FIELD,"×" + Sys.mydata.xplevel);
						}
						if(this.VALUE) {
								Util.SetText(this.VALUE.FIELD,Sys.mydata.taxtotal);
						}
						if(Config.rtl) {
								tf_xa = new TextFormat();
								tf_xa.align = TextFormatAlign.RIGHT;
								if(this.VALUE) {
										this.VALUE.FIELD.setTextFormat(tf_xa);
								}
								if(this.VALUE) {
										this.VALUE.FIELD.defaultTextFormat = tf_xa;
								}
								if(this.TIME) {
										this.TIME.FIELD.setTextFormat(tf_xa);
								}
								if(this.TIME) {
										this.TIME.FIELD.defaultTextFormat = tf_xa;
								}
						}
						if(remaining > 0) {
								this.UpdateRemainingTime();
						} else {
								this.TAXMOV.gotoAndStop(Config.rtl ? "rtl" : "ltr");
								this.TAXMOV.VALUE.FIELD.text = Sys.mydata.taxtotal;
								Util.AddEventListener(this.TAXMOV,"enterFrame",this.PulseTax);
								this.COLLECT.BTNCOLLECT.SetLang("collect_tax");
								this.COLLECT.BTNCOLLECT.AddEventClick(this.OnCollectClick);
								if(Util.NumberVal(Sys.mydata.taxtotal) < 0) {
										this.COLLECT.BTNCOLLECT.SetEnabled(false);
								} else {
										this.COLLECT.BTNCOLLECT.SetEnabled(true);
								}
								this.COLLECT.visible = true;
								this.BTNCONTINUE.visible = false;
						}
				}
				
				public function PulseTax(e:*) : * {
						if(!this.TAXMOV) {
								return;
						}
						this.TAXMOV.scaleX = 1 + 0.05 * Math.sin(getTimer() / 200);
						this.TAXMOV.scaleY = this.TAXMOV.scaleX;
				}
				
				public function UpdateRemainingTime(event:TimerEvent = null) : void {
						var t:String = null;
						if(this.arenewbadges) {
								return;
						}
						var duration:* = 1 * 24 * 60 * 60;
						var elapsed:int = Math.round((getTimer() - Sys.mydata.time) / 1000);
						var remaining:int = Sys.mydata.taxremaining - elapsed;
						var p:Number = 1 - remaining / duration;
						if(p > 1) {
								p = 1;
						}
						if(p < 0) {
								p = 0;
						}
						if(remaining <= 0) {
								if(this.updatetimer != null) {
										this.updatetimer.stop();
										this.updatetimer = null;
								}
								this.DrawTax();
						} else {
								Lang.Set(this.L_EARN_IN.FIELD,"earn_in+:");
								t = Util.FormatRemaining(remaining,false);
								if(this.TIME.FIELD.text != t) {
										this.TIME.FIELD.text = t;
								}
								this.PROGRESS.STRIP.scaleX = p;
								this.PROGRESS.FIELD.FIELD.text = int(p * 100) + "%";
								Imitation.CollectChildrenAll(this);
								Imitation.FreeBitmapAll(this.PROGRESS);
								Imitation.UpdateAll(this.PROGRESS);
								if(this.updatetimer == null) {
										this.updatetimer = new Timer(250,0);
										Util.AddEventListener(this.updatetimer,TimerEvent.TIMER,this.UpdateRemainingTime);
										this.updatetimer.start();
								}
						}
				}
				
				public function OnHelpClick(e:*) : void {
						if(this.dragdrop.active) {
								return;
						}
						WinMgr.OpenWindow("help.Help",{
								"tab":3,
								"subtab":1
						});
				}
				
				public function OnCollectClick(e:* = null) : * {
						this.COLLECT.visible = false;
						JsQuery.Load(CollectProc,[],"client_castle.php?stoc=" + Config.stoc + "&cmd=set",castle_badges);
				}
				
				public function OnMyDataChange(e:*) : * {
						var Anim:Object;
						var newgold:int;
						var mov:* = undefined;
						if(currentFrameLabel != "COLLECT" && currentFrameLabel != "RTLCOLLECT") {
								return;
						}
						Anim = Modules.GetClass("uibase","uibase.Anim");
						newgold = int(Sys.mydata.gold);
						if(newgold != prevgold) {
								mov = Anim.RaiseItemOff(null,this.TAXMOV);
								Anim.AnimateRewardTo(null,mov,this.MYGOLDS.VALUE.FIELD,prevgold,newgold);
								TweenMax.delayedCall(1.5,function():* {
										DrawTax();
								});
								return;
						}
						this.DrawTax();
				}
				
				public function DrawBadges() : * {
						this.ITEMS2.SetItems(badges);
				}
				
				public function CountCastleBadges(badge:Object) : * {
						var b:* = undefined;
						var c:int = 0;
						var i:* = 1;
						while(i <= 6) {
								b = castle_badges[i - 1];
								if(b && b.type == badge.type && b.level == badge.level) {
										c++;
								}
								i++;
						}
						return c;
				}
				
				public function CalculateBadgeBonus() : * {
						var b:* = undefined;
						var p:int = 0;
						var i:* = 1;
						while(i <= 6) {
								b = castle_badges[i - 1];
								if(b && Boolean(b.type)) {
										p += Sys.gameparams.badgebonuses[b.type][b.level - 1];
								}
								i++;
						}
						var base:* = Sys.mydata.taxbasic + Sys.mydata.taxfamilies + Sys.mydata.taxcastle;
						return {
								"percent":Math.ceil(p),
								"bonus":Math.ceil(p / 100 * base)
						};
				}
				
				public function CalculateTax() : * {
						var t:int = 0;
						t += Sys.mydata.taxbasic;
						t += Sys.mydata.taxfamilies;
						t += Sys.mydata.taxcastle;
						var a:* = this.CalculateBadgeBonus();
						t += Sys.mydata.badgebonus = a.bonus;
						Sys.mydata.badgepercent = a.percent;
						Sys.mydata.taxtotal = t;
						if(this.BADGESCORE) {
								Util.SetText(this.BADGESCORE.FIELD,Sys.mydata.badgebonus);
						}
						if(this.BADGE_PER) {
								Util.SetText(this.BADGE_PER.FIELD,Sys.mydata.badgepercent + "%");
						}
						if(this.VALUE) {
								Util.SetText(this.VALUE.FIELD,Sys.mydata.taxtotal);
						}
						if(this.TAXMOV) {
								Util.SetText(this.TAXMOV.VALUE.FIELD,Sys.mydata.taxtotal);
						}
				}
				
				public function CountRemainingBadges(badge:Object, current:Boolean = true) : * {
						var c:int = int(badge.count);
						var b:* = this.dragdrop.active && current ? badges[this.dragdrop.mc.id] : null;
						c -= this.CountCastleBadges(badge);
						if(b == badge) {
								c--;
						}
						return c;
				}
				
				private function SetStatue(obj:MovieClip, glow:Boolean = false) : * {
						if(obj.id === null || obj.id === undefined) {
								obj.visible = false;
								return;
						}
						var b:* = badges[obj.id];
						if(glow) {
								obj.GLOW.gotoAndStop("CLEAR");
								obj.GLOW.gotoAndStop(b.type);
						} else if(obj.GLOW) {
								obj.GLOW.gotoAndStop("CLEAR");
						}
						obj.STATUE.gotoAndStop(b.type);
						obj.STATUE.LEVEL.gotoAndStop(b.level);
						obj.visible = true;
						if(obj.BONUS) {
								obj.BONUS.FIELD.text = Sys.gameparams.badgebonuses[b.type][Math.max(0,b.level - 1)] + "%";
						}
						Imitation.CollectChildrenAll(obj);
						Imitation.FreeBitmapAll(obj);
						Imitation.UpdateAll(obj);
				}
				
				private function OnDrop() : void {
						var n:*;
						var b:*;
						var VillageMap:*;
						var t:MovieClip = null;
						t = this.dragdrop.target;
						var id:int = int(this.dragdrop.target.id);
						var type:int = int(this.dragdrop.mc.STATUE.currentFrame);
						var level:int = int(this.dragdrop.mc.STATUE.LEVEL.currentFrame);
						t.id = this.dragdrop.mc.id;
						n = Util.IdFromStringEnd(this.dragdrop.target.name);
						b = badges[this.dragdrop.mc.id];
						castle_badges[n - 1] = {
								"type":b.type,
								"level":b.level
						};
						if(this.dragdrop.target.visible) {
								this.dragdrop.mc.id = id;
								this.dragdrop.mc.scaleY = 1.5;
								this.dragdrop.mc.scaleX = 1.5;
								this.SetStatue(this.dragdrop.mc,true);
								this.dragdrop.mc.visible = false;
								TweenMax.delayedCall(0.1,function():* {
										dragdrop.DragBack(t);
										GlowAnim();
										ITEMS2.Draw();
								},[],true);
						} else {
								TweenMax.delayedCall(0.1,function():* {
										ITEMS2.Draw();
								},[],true);
						}
						this.SetStatue(this.dragdrop.target);
						this.castle_badges_changed = true;
						this.last_tax_value = Sys.mydata.badgebonus;
						this.CalculateTax();
						this.AnimBadgeTax();
						this.DrawArrows();
						VillageMap = Modules.GetClass("villagemap","villagemap.VillageMap");
						if(VillageMap && Boolean(VillageMap.mc)) {
								VillageMap.mc.redrawVillage = true;
						}
				}
				
				internal function AnimBadgeTax() : * {
						if(this.last_tax_value == Sys.mydata.badgebonus) {
								return;
						}
						if(this.BADGESCORE) {
								TweenMax.to(this.BADGESCORE,0.1,{
										"x":this.BADGESCORE.x - 3,
										"repeat":5,
										"yoyo":true
								});
						}
						if(this.VALUE) {
								TweenMax.to(this.VALUE,0.1,{
										"x":this.VALUE.x - 3,
										"repeat":5,
										"yoyo":true
								});
						}
				}
				
				private function OnCancel() : void {
						TweenMax.delayedCall(0,mc.ITEMS2.Draw);
						this.castle_badges_changed = true;
						this.ITEMS2.Draw();
						this.last_tax_value = Sys.mydata.badgebonus;
						this.CalculateTax();
						this.AnimBadgeTax();
						this.DrawArrows();
				}
				
				public function OnClickItem(item:MovieClip, id:int) : * {
						var remaining_badges:* = undefined;
						trace("clicked: ",id);
						if(!this.dragdrop.active && item.CARD.INFO && Boolean(item.CARD.INFO.getRect(Imitation.stage).contains(Imitation.stage.mouseX,Imitation.stage.mouseY))) {
								mc.CARDINFO.visible = !mc.CARDINFO.visible;
								this.DrawItem(item,id);
						} else if(!this.arenewbadges) {
								mc.CARDINFO.visible = false;
								remaining_badges = this.CountRemainingBadges(badges[id]);
								if(remaining_badges == 0) {
										return;
								}
								remaining_badges--;
								if(remaining_badges == 0) {
										item.STATUE.alpha = 0.5;
								}
								this.dragdrop.mc.id = id;
								this.dragdrop.mc.scaleY = 1.5;
								this.dragdrop.mc.scaleX = 1.5;
								this.SetStatue(this.dragdrop.mc,true);
								item.CARD.COUNT.FIELD.text = remaining_badges + " / " + badges[id].count;
								this.dragdrop.Drag(item.STATUE);
								this.GlowAnim();
								this.DrawItem(item,id);
						}
						this.DrawArrows();
				}
				
				private function GlowAnim() : * {
						var a:* = undefined;
						var j:* = 1;
						while(j <= 4) {
								a = this.dragdrop.mc.GLOW["S" + j];
								a.visible = true;
								a.stop();
								TweenMax.fromTo(a,a.totalFrames / 60,{"frame":1},{
										"frame":a.totalFrames,
										"ease":Linear.easeNone,
										"delay":j / 2,
										"repeatDelay":Math.random(),
										"repeat":-1
								});
								j++;
						}
				}
				
				public function DrawItem(item:MovieClip, id:int) : * {
						if(!mc) {
								return;
						}
						if(!item) {
								return;
						}
						if(!this.badges_loaded) {
								return;
						}
						if(!badges[id] || !this.castle_badges_rendered) {
								item.visible = false;
								return;
						}
						var remaining_badges:* = this.CountRemainingBadges(badges[id]);
						item.visible = true;
						Util.StopAllChildrenMov(item);
						this.DrawCardStatue(item,id,remaining_badges);
						this.DrawCardFlash(item,id);
						this.DrawCardFace(item,id);
						this.DrawCardTexts(item,id,remaining_badges);
						this.DrawCardLock(item,id);
						Imitation.UpdateAll(item);
						this.DrawCardInfo(item,id);
				}
				
				private function DrawCardStatue(item:MovieClip, id:int, remaining_badges:int) : void {
						var shapelevel:* = badges[id].level;
						if(badges[id].count == 0) {
								shapelevel = 1;
						}
						var sname:* = badges[id].type + "_" + shapelevel;
						if(item.sname != sname) {
								if(Boolean(item.WATERMARK) && item.contains(item.WATERMARK)) {
										item.removeChild(item.WATERMARK);
								}
								if(Boolean(item.STATUE) && item.contains(item.STATUE)) {
										item.removeChild(item.STATUE);
								}
								item.WATERMARK = Imitation.CreateClone(mc.ASSETS["WATERMARK" + sname],item);
								item.STATUE = Imitation.CreateClone(mc.ASSETS["STATUE" + sname],item);
								item.sname = sname;
						}
						item.STATUE.x = 31;
						item.STATUE.y = 70;
						item.WATERMARK.scaleY = 0.65;
						item.WATERMARK.scaleX = 0.65;
						item.WATERMARK.x = 31;
						item.WATERMARK.y = 70;
						item.STATUE.alpha = remaining_badges > 0 ? 1 : (badges[id].count == 0 ? 0 : 0.2);
				}
				
				private function DrawCardLock(item:MovieClip, id:int) : void {
						if(Sys.mydata.xplevel < 10) {
								item.LOCK.visible = true;
								item.addChild(item.LOCK);
								item.CARD.COUNT.visible = false;
								item.CARD.BONUS.FIELD.text = Lang.get("unlock_level_n",10);
						} else {
								item.LOCK.visible = false;
								item.CARD.COUNT.visible = true;
						}
				}
				
				private function DrawCardFlash(item:MovieClip, id:int) : void {
						if(badges[id].isnew) {
								if(this.arenewbadges) {
										this.CreateFlash(item);
										if(!TweenMax.isTweening(item.STATUE)) {
												item.STATUE.scaleX = item.STATUE.scaleY = 0.65;
										}
								} else {
										item.STATUE.scaleX = item.STATUE.scaleY = 0.65;
										TweenMax.killTweensOf(item.STATUE);
										this.KillFlash(item);
								}
						} else {
								item.STATUE.scaleX = item.STATUE.scaleY = 0.65;
								TweenMax.killTweensOf(item.STATUE);
								this.KillFlash(item);
						}
				}
				
				private function DrawCardFace(item:MovieClip, id:int) : void {
						if(!item.CARD) {
								return;
						}
						if(Boolean(item.CARD.FACE) && Boolean(item.CARD.contains(item.CARD.FACE)) && item.CARD.FACE.parent == item.CARD) {
								item.CARD.removeChild(item.CARD.FACE);
						}
						var face:* = 1;
						if(badges[id].isnew) {
								face = 2;
								this.StatueShake(item.STATUE,true,0);
						}
						if(badges[id].count == 0) {
								face = 3;
						}
						if(!mc.ASSETS["CARDFACE" + face]) {
								return;
						}
						item.CARD.FACE = Imitation.CreateClone(mc.ASSETS["CARDFACE" + face],item.CARD);
						item.CARD.setChildIndex(item.CARD.FACE,0);
						item.CARD.HIGHLIGHT.visible = item.hover || this.dragdrop.active && this.dragdrop.mc && this.dragdrop.mc.id == id;
				}
				
				public function StatueShake(btn:MovieClip, dirtoright:Boolean, index:Number) : void {
						index++;
						if(index < 10) {
								TweenMax.to(btn,0.1,{
										"rotation":(dirtoright ? 5 : -5),
										"ease":Bounce.easeInOut,
										"onComplete":this.StatueShake,
										"onCompleteParams":[btn,!dirtoright,index]
								});
						} else {
								btn.rotation = 0;
						}
				}
				
				private function DrawCardTexts(item:MovieClip, id:int, remaining_badges:int) : void {
						item.CARD.COUNT.FIELD.text = remaining_badges + " / " + badges[id].count;
						item.CARD.BONUS.FIELD.text = Lang.get("n_percent_bonus",Sys.gameparams.badgebonuses[badges[id].type][Math.max(0,badges[id].level - 1)]);
						Lang.Set(item.CARD.RANK.FIELD,"rank_n",badges[id].level);
						Lang.Set(item.CARD.NAME.FIELD,"badge_name_" + badges[id].type.toLowerCase());
				}
				
				private function DrawCardInfo(item:MovieClip, id:int) : void {
						if(item.hover) {
								Lang.Set(mc.CARDINFO.TITLE.FIELD,"badge_name_" + badges[id].type.toLowerCase());
								if(badges[id].count == 0) {
										if(badges[id].type == "RLP") {
												Lang.Set(mc.CARDINFO.TEXT.FIELD,"badge_desc_" + badges[id].type.toLowerCase() + "_" + badges[id].level,badges[id].level,badgelevellimits[badges[id].type][badges[id].level - 1]);
										} else {
												Lang.Set(mc.CARDINFO.TEXT.FIELD,"badge_desc_" + badges[id].type.toLowerCase(),badges[id].level,badgelevellimits[badges[id].type][badges[id].level - 1]);
										}
								} else if(badges[id].type == "RLP") {
										Lang.Set(mc.CARDINFO.TEXT.FIELD,"badge_line_" + badges[id].type.toLowerCase() + "_" + badges[id].level,Util.UpperCase(Lang.get("badge_level_name_" + badges[id].level)),badgelevellimits[badges[id].type][badges[id].level - 1]);
								} else {
										Lang.Set(mc.CARDINFO.TEXT.FIELD,"badge_line_" + badges[id].type.toLowerCase(),Util.UpperCase(Lang.get("badge_level_name_" + badges[id].level)),badgelevellimits[badges[id].type][badges[id].level - 1]);
								}
						}
				}
				
				public function CreateFlash(p:MovieClip) : * {
						var i:Number = NaN;
						var cs:MovieClip = null;
						var fadeInOut:Function = null;
						var d:* = undefined;
						if(!this.csillamsample) {
								this.csillamsample = new Csillam2();
								this.csillamsample.visible = false;
								this.addChild(this.csillamsample);
								Imitation.CollectChildrenAll(this);
						}
						if(!p.css) {
								p.css = [];
								i = 1;
								while(i <= 4) {
										fadeInOut = function(cs:*):* {
												var s:* = 0.8 + Math.random() / 2;
												var d:* = Math.random();
												TweenMax.fromTo(cs,0.5,{
														"alpha":0,
														"scaleX":0,
														"scaleY":0
												},{
														"alpha":1,
														"scaleX":s,
														"scaleY":s,
														"onComplete":function():* {
																TweenMax.to(cs,0.5,{
																		"alpha":0,
																		"scaleX":0,
																		"scaleY":0
																});
														}
												});
												TweenMax.fromTo(cs,1,{"rotation":0},{"rotation":100});
												TweenMax.delayedCall(2 + d,fadeInOut,[cs]);
										};
										cs = Imitation.CreateClone(this.csillamsample,p);
										cs.x = Util.Random(50,-50) + 50;
										cs.y = Util.Random(50,-50) + 50;
										cs.alpha = 0;
										d = Math.random();
										TweenMax.delayedCall(i + d / 5,fadeInOut,[cs]);
										cs.visible = true;
										p.css[i] = cs;
										i++;
								}
						} else {
								i = 1;
								while(i <= 4) {
										p.addChild(p.css[i]);
										i++;
								}
						}
				}
				
				public function KillFlash(p:MovieClip) : * {
						var i:* = undefined;
						if(p.css) {
								i = 1;
								while(i <= 4) {
										TweenMax.killTweensOf(p.css[i]);
										p.removeChild(p.css[i]);
										i++;
								}
								p.css = null;
						}
				}
				
				public function CheckAllBadges() : * {
						if(!this.badges_loaded) {
								this.LoadBadges("list");
						}
				}
				
				public function ProcessBadgeData() : * {
						trace("ProcessBadgeData json this.data: " + this.data);
						var bname:* = undefined;
						var blevel:* = undefined;
						var bcount:int = 0;
						var newlevel:int = 0;
						badges = [];
						var n:* = 0;
						this.arenewbadges = false;
						this.newcount = 0;
						for each(bname in badgenames) {
								trace("this.data.NEWLEVELS[bname]: " + this.data.NEWLEVELS[bname]);
								newlevel = Util.NumberVal(this.data.NEWLEVELS[bname]);
								if(newlevel > 0) {
										this.arenewbadges = true;
										++this.newcount;
								} else {
										newlevel = int(this.werenew[bname]);
								}
								if(newlevel > 0) {
										bcount = this.data[bname][newlevel - 1] + (!!this.arenewbadges ? 1 : 0);
										n++;
										badges.push({
												"type":bname,
												"level":newlevel,
												"count":bcount,
												"isnew":true
										});
								}
						}
						blevel = 7;
						trace("1 done");
						while(blevel >= 1) {
								for each(bname in badgenames) {
										newlevel = Util.NumberVal(this.data.NEWLEVELS[bname]);
										if(newlevel == 0) {
												newlevel = int(this.werenew[bname]);
										}
										if(blevel > 0 && blevel != newlevel) {
												trace("[blevel - 1]: " + blevel - 1);
												trace("this.data[bname]: " + this.data[bname]);
												trace("this.data[bname][blevel - 1]: " + this.data[bname]["6"]);
												bcount = int(this.data[bname][blevel - 1]);
												if(bcount > 0) {
														n++;
														badges.push({
																"type":bname,
																"level":blevel,
																"count":bcount,
																"isnew":false
														});
												}
										}
								}
								blevel--;
						}
						trace("2 done");
						blevel = 1;
						while(blevel <= 7) {
								for each(bname in badgenames) {
										if(blevel > 0) {
												bcount = int(this.data[bname][blevel - 1]);
												if(bcount == 0 && (bname != "EXT" || blevel == 1)) {
														n++;
														badges.push({
																"type":bname,
																"level":blevel,
																"count":bcount,
																"isnew":false
														});
												}
										}
								}
								blevel++;
						}
						trace("3 done");
						if(this.arenewbadges) {
								gotoAndStop("NEWBADGES");
								this.COLLECT.BTNCOLLECT.SetLang(this.newcount > 1 ? "collect_badges" : "collect_badge");
								Lang.Set(this.NEWBADGESINFO.FIELD,this.newcount > 1 ? "have_new_badges" : "have_new_badge");
								if(this.NEWBADGESINFO.FIELD.numLines >= 4) {
										this.NEWBADGESINFO.FIELD.y = -2;
								}
								if(this.NEWBADGESINFO.FIELD.numLines == 3) {
										this.NEWBADGESINFO.FIELD.y = 8;
								}
								if(this.NEWBADGESINFO.FIELD.numLines == 2) {
										this.NEWBADGESINFO.FIELD.y = 16;
								}
								if(this.NEWBADGESINFO.FIELD.numLines == 1) {
										this.NEWBADGESINFO.FIELD.y = 23;
								}
								this.NPC.Set("KING","HAPPY");
								this.COLLECT.BTNCOLLECT.AddEventClick(this.OnCollectBadgesClick);
								TweenMax.fromTo(this.COLLECT,0.8,{
										"scaleX":1,
										"scaleY":1
								},{
										"scaleX":1.05,
										"scaleY":1.2,
										"repeat":-1,
										"yoyo":true
								});
								this.werenew = this.data.NEWLEVELS;
								return;
						}
				}
				
				public function OnCollectBadgesClick(e:*) : void {
						this.DrawTax();
						this.LoadBadges("addnewbadges");
				}
				
				public function DrawCastleBadges() : void {
						var s:MovieClip = null;
						var o:Object = null;
						var j:* = undefined;
						var i:* = 1;
						while(i <= 6) {
								s = mc["S" + i];
								o = castle_badges[i - 1];
								s.visible = Boolean(o) && o.type != 0;
								if(s.visible) {
										for(j in badges) {
												if(badges[j].type == o.type && badges[j].level == o.level) {
														s.id = j;
														break;
												}
										}
										this.SetStatue(s);
								}
								i++;
						}
						this.CalculateTax();
						this.DrawArrows();
				}
				
				public function DrawArrows() : void {
						var s:MovieClip = null;
						var j:* = undefined;
						if(this.arenewbadges) {
								return;
						}
						var i:* = 1;
						while(i <= 6) {
								s = mc["S" + i];
								TweenMax.killTweensOf(mc["SLOT" + i]);
								mc["SLOT" + i].gotoAndStop(1);
								if(!s.visible) {
										for(j in badges) {
												if(this.CountRemainingBadges(badges[j],false) > 0) {
														TweenMax.fromTo(mc["SLOT" + i],0.75,{"frame":1},{
																"frame":30,
																"ease":Linear,
																"repeat":-1
														});
														break;
												}
										}
								}
								i++;
						}
				}
				
				public function SyncLoadedBadges() : * {
						if(this.badges_loaded && this.castle_badges_rendered) {
								this.DrawCastleBadges();
								this.DrawBadges();
								if(this.initialized) {
										WinMgr.HideLoadWait();
								} else {
										WinMgr.WindowDataArrived(this);
								}
								this.initialized = true;
						}
				}
				
				public function LoadBadges(aaction:*) : * {
						if(this.loading) {
								return;
						}
						if(this.initialized) {
								WinMgr.ShowLoadWait();
						}
						this.loading = true;
						JsQuery.Load(OnBadgesLoaded,[],"client_castle.php?stoc=" + Config.stoc + "&cmd=" + aaction);
				}
				
				private function CleanUp() : void {
						this.ResetUpdateTimer();
						if(Boolean(Castle.mc) && Boolean(this.TAXMOV)) {
								Util.RemoveEventListener(this.TAXMOV,"enterFrame",this.PulseTax);
						}
				}
				
				private function ResetUpdateTimer() : void {
						if(Castle.mc && this.updatetimer && this.updatetimer.hasEventListener(TimerEvent.TIMER)) {
								Util.RemoveEventListener(this.updatetimer,TimerEvent.TIMER,this.UpdateRemainingTime);
								this.updatetimer = null;
						}
				}
		}
}

