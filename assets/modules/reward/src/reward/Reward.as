package reward {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import flash.display.*;
		import flash.geom.Point;
		import flash.text.*;
		import flash.utils.*;
		import syscode.*;
		import uibase.lego_button_1x1_cancel_header;
		import uibase.lego_button_1x1_ok;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol448")]
		public class Reward extends MovieClip {
				public static const VIDEOAD:uint = 1;
				
				public static const AD_REWARD:uint = 2;
				
				public static const REWARD:uint = 3;
				
				public static var mc:Reward = null;
				
				private static var tag:Object = null;
				
				private static var type:uint = 1;
				
				private static var id:String = null;
				
				private static var message:String = null;
				
				private static var image:String = null;
				
				private static var gold:Number = 0;
				
				private static var boosters:Array = [];
				
				private static var watchedafterclose:Boolean = false;
				
				public var ANIM_GOLD:MovieClip;
				
				public var B1:MovieClip;
				
				public var B10:MovieClip;
				
				public var B11:MovieClip;
				
				public var B12:MovieClip;
				
				public var B2:MovieClip;
				
				public var B3:MovieClip;
				
				public var B4:MovieClip;
				
				public var B5:MovieClip;
				
				public var B6:MovieClip;
				
				public var B7:MovieClip;
				
				public var B8:MovieClip;
				
				public var B9:MovieClip;
				
				public var BTN:MovieClip;
				
				public var BTNCLOSE:lego_button_1x1_cancel_header;
				
				public var BTN_LABEL:MovieClip;
				
				public var BTN_PIPE:lego_button_1x1_ok;
				
				public var CAMERA:MovieClip;
				
				public var CHAT_TXT:MovieClip;
				
				public var CHESTS:MovieClip;
				
				public var GOLD:MovieClip;
				
				public var INVENTORY:MovieClip;
				
				public var LAYER_FLYBOOSTER:MovieClip;
				
				public var LAYER_IMAGE:MovieClip;
				
				public var NPC:LegoCharacters;
				
				public var SAMPLE_FLYBOOSTER:VAdAnim;
				
				private var wparams:Object = null;
				
				private var defaultscale:Number;
				
				private var flyboosterstartpos:Point;
				
				public function Reward() {
						super();
				}
				
				public static function StartVideoAds() : void {
						DBG.Trace("VideoAd:StartVideoAds");
						Platform.silentactivate = true;
						Imitation.DispatchStageEvent("VIDEOAD_START_VIDEO");
				}
				
				public function Prepare(param1:Object) : void {
						Util.StopAllChildrenMov(this);
						this.wparams = param1;
						Reward.watchedafterclose = false;
						Reward.type = Util.NumberVal(param1.type);
						Reward.tag = Sys.tag_reward;
						trace("Reward.type:" + Reward.type);
						this.ObjectTrace(Reward.tag);
						this.NPC.Set("PROFESSOR","DEFAULT");
						if(Reward.tag) {
								Reward.id = Util.StringVal(Sys.tag_reward.ID);
								Reward.image = Util.StringVal(Sys.tag_reward.IMAGE);
								Reward.message = Util.StringVal(Sys.tag_reward.MESSAGE);
								if(Boolean(Reward.tag.CHARACTER) && Reward.tag.CHARACTER != "") {
										this.NPC.Set(Reward.tag.CHARACTER,"DEFAULT");
								}
						}
						this.InitFlyBoosters();
						this.Draw();
						this.DrawBoosters();
						Imitation.FreeBitmapAll(this);
						if(Boolean(Reward.image) && Reward.image != "") {
								param1.waitfordata = true;
								MyLoader.LoadBitmap(Reward.image,this.OnImageLoaded);
						} else {
								WinMgr.WindowDataArrived(Reward.mc);
						}
				}
				
				public function ObjectTrace(param1:Object, param2:String = "") : void {
						var _loc3_:* = undefined;
						if(param2 == "") {
								param2 = "-->";
						} else {
								param2 += " -->";
						}
						for(_loc3_ in param1) {
								trace(param2,_loc3_ + ":" + param1[_loc3_]," ");
								if(typeof param1[_loc3_] == "object") {
										this.ObjectTrace(param1[_loc3_],param2);
								}
						}
				}
				
				private function InitFlyBoosters() : void {
						this.defaultscale = this.scaleX;
						this.flyboosterstartpos = new Point(this.SAMPLE_FLYBOOSTER.x,this.SAMPLE_FLYBOOSTER.y);
						this.SAMPLE_FLYBOOSTER.visible = false;
						this.removeChild(this.SAMPLE_FLYBOOSTER);
						Util.RemoveChildren(this.SAMPLE_FLYBOOSTER);
				}
				
				private function OnImageLoaded(param1:Bitmap) : void {
						if(param1) {
								this.LAYER_IMAGE.addChild(param1);
						}
						this.NPC.visible = false;
						if(Reward.mc) {
								WinMgr.WindowDataArrived(Reward.mc);
						}
				}
				
				public function Draw() : void {
						gotoAndStop(1);
						this.BTNCLOSE.SetEnabled(true);
						this.BTNCLOSE.SetIcon("X");
						this.BTNCLOSE.AddEventClick(this.Hide);
						if(this.ANIM_GOLD) {
								this.ANIM_GOLD.visible = false;
						}
						if(Reward.tag && Reward.tag.CHEST && Util.NumberVal(Reward.tag.CHEST) > 0 && Util.NumberVal(Reward.tag.CHEST) <= 7) {
								this.CHESTS.gotoAndStop("L" + Util.NumberVal(Reward.tag.CHEST));
						} else {
								this.CHESTS.gotoAndStop("L1");
						}
						Imitation.FreeBitmapAll(this.CHESTS);
						if(Reward.type == Reward.VIDEOAD) {
								gotoAndStop(2);
								Util.SetText(this.CHAT_TXT.FIELD,Lang.Get("video_ad_recommend"));
								Util.SetText(this.BTN_LABEL.FIELD,Lang.Get("video_ad_watchvideo"));
								Imitation.AddEventClick(this.BTN,this.OnBtnGetClick);
								this.CAMERA.visible = true;
								this.CHESTS.visible = false;
								this.BTN_PIPE.SetEnabled(true);
								this.BTN_PIPE.SetIcon("PLAY");
								this.BTN_PIPE.AddEventClick(this.OnBtnGetClick);
						} else if(Reward.type == Reward.AD_REWARD) {
								gotoAndStop(1);
								Util.SetText(this.CHAT_TXT.FIELD,Lang.Get("video_ad_ready"));
								Util.SetText(this.BTN_LABEL.FIELD,Lang.Get("reward_click_chest"));
								Imitation.AddEventClick(this.BTN,this.OnCollectReward);
								this.CAMERA.visible = false;
								this.CHESTS.visible = true;
						} else {
								this.CAMERA.visible = false;
								this.CHESTS.visible = true;
								Util.SetText(this.BTN_LABEL.FIELD,Lang.Get("reward_click_chest"));
								Imitation.AddEventClick(this.BTN,this.OnCollectReward);
								if(Util.StringVal(Reward.message).indexOf("lang:") > -1) {
										Reward.message = Reward.message.replace("lang:","");
										Util.SetText(this.CHAT_TXT.FIELD,Lang.Get(Reward.message));
								} else {
										Util.SetText(this.CHAT_TXT.FIELD,Reward.message);
								}
						}
						if(this.CHAT_TXT.FIELD.numLines >= 4) {
								this.CHAT_TXT.FIELD.y = 9;
						}
						if(this.CHAT_TXT.FIELD.numLines == 3) {
								this.CHAT_TXT.FIELD.y = 18;
						}
						if(this.CHAT_TXT.FIELD.numLines == 2) {
								this.CHAT_TXT.FIELD.y = 28;
						}
						if(this.CHAT_TXT.FIELD.numLines == 1) {
								this.CHAT_TXT.FIELD.y = 38;
						}
				}
				
				private function OnCollectReward(param1:Object = null) : void {
						this.CHESTS.nextFrame();
						Imitation.FreeBitmapAll(this.CHESTS);
						Comm.SendCommand("GETREWARD","ID=\"" + Util.NumberVal(Sys.tag_reward.ID) + "\"",this.GetRewardResult,this,Sys.tag_reward);
				}
				
				private function GetRewardResult(param1:int, param2:XML, param3:Object) : void {
						var _loc4_:String = null;
						if(param1 != 0) {
								Sys.tag_reward = null;
								this.Hide();
						} else if(Reward.mc) {
								Reward.gold = Util.NumberVal(Sys.tag_reward.GOLD);
								Reward.boosters = [];
								for(_loc4_ in param3) {
										if(String("|SELHALF|SELANSW|TIPAVER|TIPRANG|AIRBORNE|SUBJECT|FORTRESS|SERIES1|SERIES2|SERIES3|SERIES4|").indexOf(_loc4_) >= 0 && Util.NumberVal(param3[_loc4_]) > 0) {
												Reward.boosters.push({
														"name":_loc4_,
														"value":Util.NumberVal(param3[_loc4_])
												});
										}
								}
								Sys.tag_reward = null;
								this.CheckShareAnim();
						}
				}
				
				private function CheckShareAnim(param1:Object = null) : void {
						if(Reward.mc) {
								if(Reward.boosters.length > 0) {
										this.PlayBoosterAnim();
								} else if(Reward.gold > 0) {
										this.PlayGoldAnim();
								} else {
										TweenMax.delayedCall(2,this.Hide);
								}
						}
				}
				
				private function PlayBoosterAnim() : void {
						var _loc1_:Object = null;
						var _loc2_:int = 0;
						var _loc3_:MovieClip = null;
						var _loc4_:MovieClip = null;
						var _loc5_:Number = NaN;
						var _loc6_:MovieClip = null;
						var _loc7_:uint = 0;
						var _loc8_:MovieClip = null;
						var _loc9_:SqControl = null;
						if(Reward.mc) {
								if(Reward.boosters.length > 0) {
										_loc1_ = Reward.boosters.shift();
										if(Config.helpindexes[_loc1_.name]) {
												_loc2_ = int(Sys.mydata.freehelps[Config.helpindexes[_loc1_.name]]);
												_loc3_ = this.INVENTORY["BOOSTER" + Config.helpindexes[_loc1_.name]];
												_loc4_ = this["B" + Config.helpindexes[_loc1_.name]];
										}
										if(_loc3_) {
												_loc5_ = 0.1;
												_loc6_ = null;
												_loc7_ = 0;
												while(_loc7_ < Util.NumberVal(_loc1_.value)) {
														_loc5_ += 0.2;
														_loc6_ = new LegoIconset();
														_loc6_.scaleX = _loc6_.scaleY = 3;
														this.LAYER_FLYBOOSTER.addChild(_loc6_);
														_loc6_.Set(_loc1_.name);
														_loc6_.tx = this.INVENTORY.x + _loc3_.x + 30;
														_loc6_.ty = this.INVENTORY.y + _loc3_.y;
														_loc6_.x = this.flyboosterstartpos.x;
														_loc6_.y = this.flyboosterstartpos.y;
														_loc6_.visible = false;
														_loc6_.targetgift = _loc4_;
														_loc6_.targetgiftvalue = Util.NumberVal(_loc1_.value);
														TweenMax.fromTo(_loc6_,0.8,{"visible":true},{
																"delay":_loc5_,
																"scaleX":this.defaultscale,
																"scaleY":this.defaultscale,
																"bezier":[{
																		"x":this.flyboosterstartpos.x,
																		"y":this.flyboosterstartpos.y - 100
																},{
																		"x":_loc6_.tx,
																		"y":_loc6_.ty,
																		"scaleX":this.defaultscale * 3,
																		"scaleY":this.defaultscale * 3
																}],
																"onComplete":this.RemoveFlyBooster,
																"onCompleteParams":[_loc6_,_loc7_ == Util.NumberVal(_loc1_.value) - 1],
																"ease":Sine.easeInOut
														});
														_loc7_++;
												}
												_loc8_ = new BummAnim();
												this.addChild(_loc8_);
												_loc8_.gotoAndStop(1);
												_loc8_.x = _loc6_.x + 20;
												_loc8_.y = _loc6_.y + 10;
												_loc8_.visible = false;
												TweenMax.fromTo(_loc8_,1,{
														"frame":1,
														"visible":true
												},{
														"frame":18,
														"delay":0.3
												});
												if(Util.NumberVal(_loc1_.value) > 0) {
														_loc9_ = new SqControl("video_valueroll." + _loc1_.name);
														_loc9_.AddDelay(0.8 + Math.max(0,_loc5_ - 0.8));
														Modules.GetClass("uibase","uibase.Anim").ValueRollUp(_loc9_,_loc3_.VALUEMC.VALUE.FIELD,_loc2_ - Util.NumberVal(_loc1_.value),_loc2_);
														_loc9_.Start("video_valueroll." + _loc1_.name);
												}
										}
								} else {
										this.CheckShareAnim();
								}
						}
				}
				
				public function RemoveFlyBooster(param1:*, param2:Boolean = false) : void {
						var _loc3_:MovieClip = null;
						if(Reward.mc) {
								if(param1.targetgift) {
										if(param1.targetgift.ICONSET.alpha != 1) {
												param1.targetgift.ICONSET.alpha = 1;
												param1.targetgift.LABEL.alpha = 1;
												param1.targetgift.LABEL.FIELD.text = param1.targetgiftvalue;
												_loc3_ = new BummAnim();
												this.addChild(_loc3_);
												_loc3_.gotoAndPlay(1);
												_loc3_.x = param1.targetgift.x + 40;
												_loc3_.y = param1.targetgift.y + 10;
										}
								}
								this.LAYER_FLYBOOSTER.removeChild(param1);
								if(param2) {
										this.PlayBoosterAnim();
								}
						}
				}
				
				private function PlayGoldAnim() : void {
						TweenMax.fromTo(this.ANIM_GOLD,1,{
								"frame":1,
								"visible":true
						},{
								"frame":15,
								"onComplete":this.CompleteGoldAnim
						});
						var _loc1_:Number = Number(Reward.gold);
						var _loc2_:SqControl = new SqControl("advent_valueroll.gold");
						_loc2_.AddDelay(0.6);
						Modules.GetClass("uibase","uibase.Anim").ValueRollUp(_loc2_,this.INVENTORY.GOLD.FIELD,Util.NumberVal(Sys.mydata.gold) - Reward.gold,Util.NumberVal(Sys.mydata.gold));
						_loc2_.Start("reward_valueroll.gold");
				}
				
				private function CompleteGoldAnim() : void {
						var _loc1_:MovieClip = null;
						if(Reward.mc) {
								this.GOLD.ICONSET.alpha = 1;
								this.GOLD.LABEL.alpha = 1;
								this.GOLD.LABEL.FIELD.text = Reward.gold;
								this.ANIM_GOLD.visible = false;
								_loc1_ = new BummAnim();
								this.addChild(_loc1_);
								_loc1_.gotoAndPlay(1);
								_loc1_.x = this.GOLD.x + 40;
								_loc1_.y = this.GOLD.y + 10;
								Reward.gold = 0;
								this.CheckShareAnim();
						}
				}
				
				public function DrawBoosters() : void {
						var _loc1_:Boolean = false;
						var _loc2_:int = 0;
						var _loc3_:String = null;
						var _loc4_:Object = null;
						var _loc5_:int = 0;
						var _loc6_:int = 0;
						var _loc7_:int = 0;
						_loc2_ = 1;
						while(_loc2_ <= 12) {
								_loc1_ = false;
								_loc3_ = Config.helpfieldname[_loc2_ - 1];
								this.INVENTORY["BOOSTER" + _loc2_].ICONSET.Set(_loc3_);
								if(_loc2_ == 1 && Sys.mydata.uls[9] == 1) {
										_loc1_ = true;
								}
								if(_loc2_ == 2 && Sys.mydata.uls[10] == 1) {
										_loc1_ = true;
								}
								if(_loc2_ == 3 && Sys.mydata.uls[11] == 1) {
										_loc1_ = true;
								}
								if(_loc2_ == 4 && Sys.mydata.uls[12] == 1) {
										_loc1_ = true;
								}
								if(_loc2_ == 5 && Sys.mydata.uls[13] == 1) {
										_loc1_ = true;
								}
								if(_loc2_ == 6 && Sys.mydata.uls[14] == 1) {
										_loc1_ = true;
								}
								if(_loc2_ == 7 && Sys.mydata.uls[15] == 1) {
										_loc1_ = true;
								}
								if(_loc2_ == 8 && Sys.mydata.uls[16] == 1) {
										_loc1_ = true;
								}
								if(_loc2_ == 9 && Sys.mydata.uls[17] == 1) {
										_loc1_ = true;
								}
								if(_loc2_ == 10 && Sys.mydata.uls[18] == 1) {
										_loc1_ = true;
								}
								if(_loc2_ == 11 && Sys.mydata.uls[19] == 1) {
										_loc1_ = true;
								}
								if(_loc2_ == 12 && Sys.mydata.uls[20] == 1) {
										_loc1_ = true;
								}
								if(!_loc1_) {
										this.INVENTORY["BOOSTER" + _loc2_].ICONSET.Set("LOCK");
								}
								if(_loc1_ && (_loc2_ <= 7 || _loc2_ == 8 || _loc2_ == 9)) {
										Imitation.AddEventClick(this.INVENTORY["BOOSTER" + _loc2_],this.OnBoosterClick,{"boosterid":_loc2_});
								}
								this.INVENTORY["BOOSTER" + _loc2_].VALUEMC.VALUE.FIELD.text = Sys.mydata.freehelps[_loc2_];
								if(_loc2_ <= 7 || _loc2_ == 8 || _loc2_ == 9) {
										_loc4_ = Sys.mydata.helpforges[_loc2_];
										if(Semu.enabled) {
												_loc4_ = {
														"prodtime":1,
														"remainingtime":0,
														"prodcount":1
												};
										}
										_loc5_ = _loc4_.prodtime * 60 * 60;
										_loc6_ = Math.round((getTimer() - Sys.mydata.time) / 1000);
										_loc7_ = _loc4_.remainingtime - _loc6_;
										this.INVENTORY["BOOSTER" + _loc2_].NOTIFY.visible = _loc1_ && _loc7_ <= 0;
										this.INVENTORY["BOOSTER" + _loc2_].NOTIFY.NOTIFYANIM.FIELD.text = "+" + _loc4_.prodcount;
								} else {
										this.INVENTORY["BOOSTER" + _loc2_].NOTIFY.visible = false;
								}
								this.INVENTORY.GOLD.FIELD.text = Util.FormatNumber(Sys.mydata.gold);
								if(Sys.mydata.xplevel > 0) {
										Imitation.AddEventClick(this.INVENTORY.GOLDCLICK,this.OnPlusGoldClick);
								}
								if(currentFrame == 1) {
										this["B" + _loc2_].ICONSET.Set(_loc3_);
										this["B" + _loc2_].ICONSET.alpha = 0.4;
										this["B" + _loc2_].LABEL.alpha = 0.4;
										this["B" + _loc2_].LABEL.FIELD.text = "???";
								}
								_loc2_++;
						}
						if(currentFrame == 1) {
								this.GOLD.ICONSET.Set("GOLD3");
								this.GOLD.LABEL.FIELD.text = "???";
								this.GOLD.ICONSET.alpha = 0.4;
								this.GOLD.LABEL.alpha = 0.4;
						}
				}
				
				public function OnBoosterClick(param1:*) : void {
						WinMgr.OpenWindow("forge.Forge",{
								"funnelid":"",
								"boosterid":param1.params.boosterid
						});
				}
				
				public function OnPlusGoldClick(param1:*) : * {
						WinMgr.OpenWindow("bank.Bank");
				}
				
				private function OnBtnGetClick(param1:Object) : void {
						this.BTNCLOSE.SetEnabled(false);
						this.wparams.fadeOut = "zoom_in";
						Reward.watchedafterclose = true;
						this.Hide();
				}
				
				public function AfterOpen() : void {
						Imitation.FreeBitmapAll(this);
				}
				
				public function AfterClose() : void {
						if(Reward.watchedafterclose) {
								Reward.StartVideoAds();
						} else if(Reward.type == Reward.VIDEOAD) {
								Sys.QueryVideoAds();
						}
				}
				
				public function Hide(param1:Object = null) : void {
						TweenMax.killTweensOf(this);
						WinMgr.CloseWindow(this);
				}
		}
}

