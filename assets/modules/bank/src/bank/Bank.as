package bank {
		import com.greensock.TweenMax;
		import components.CharacterComponent;
		import flash.display.*;
		import flash.net.*;
		import flash.text.*;
		import flash.utils.Dictionary;
		import syscode.*;
		import uibase.lego_button_1x1_cancel_header;
		import uibase.lego_button_1x1_normal_header;
		import uibase.lego_button_1x1_ok;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol530")]
		public class Bank extends MovieClip {
				public static var mc:Bank = null;
				
				public var BG:MovieClip;
				
				public var BG_ELDORADO:MovieClip;
				
				public var BOUNDS:MovieClip;
				
				public var BTN:lego_button_1x1_ok;
				
				public var BTNCLOSE:lego_button_1x1_cancel_header;
				
				public var BTNHELP:lego_button_1x1_normal_header;
				
				public var ERROR:MovieClip;
				
				public var FANIM:MovieClip;
				
				public var HANIM:MovieClip;
				
				public var INPUT:MovieClip;
				
				public var OFFER0:MovieClip;
				
				public var OFFER1:MovieClip;
				
				public var OFFER2:MovieClip;
				
				public var OFFER3:MovieClip;
				
				public var OFFER4:MovieClip;
				
				public var OFFER5:MovieClip;
				
				public var PICS:MovieClip;
				
				public var SMSPANEL:MovieClip;
				
				public var TABS:HeaderTabs;
				
				public var TXT:MovieClip;
				
				public var VOXPAY:SimpleButton;
				
				public var __id0_:CharacterComponent;
				
				public var __setPropDict:Dictionary;
				
				public var funnelid:String;
				
				public var loaded:Boolean = false;
				
				public var first_show:Boolean = true;
				
				public var prepared:Boolean = false;
				
				public var normal_items:Array = null;
				
				public var mobile_items:Array = null;
				
				public var sms_items:Array = null;
				
				public var normal_shown:Boolean = true;
				
				public var pay_success:* = false;
				
				private var getvideoad:Boolean = false;
				
				public var currenttype:int = 1;
				
				public function Bank() {
						this.__setPropDict = new Dictionary(true);
						super();
						addFrameScript(1,this.frame2);
				}
				
				public static function ProcessFaceOffers(jsq:Object) : void {
						if(!mc) {
								return;
						}
						DBG.Trace("ProcessFaceOffers",jsq);
						mc.normal_items = null;
						mc.mobile_items = null;
						mc.sms_items = null;
						mc.loaded = true;
						if(jsq.error == 0) {
								if(jsq.data.offers is Array && jsq.data.offers.length > 0) {
										mc.normal_items = jsq.data.offers;
								}
								if(jsq.data.mobile is Array && jsq.data.mobile.length > 0) {
										mc.mobile_items = jsq.data.mobile;
								}
								if(jsq.data.sms is Array && jsq.data.sms.length > 0) {
										mc.sms_items = jsq.data.sms;
								}
						}
						if(mc.first_show) {
								trace("mc.normal_items: " + mc.normal_items);
								trace("mc.mobile_items: " + mc.mobile_items);
								trace("mc.sms_items: " + mc.sms_items);
								if(mc.normal_items != null) {
										mc.DrawItems(mc.normal_items,true);
								} else {
										if(mc.mobile_items == null) {
												WinMgr.WindowDataArrived(mc);
												WinMgr.CloseWindow(mc);
												return;
										}
										mc.DrawItems(mc.mobile_items,false);
								}
								if(mc.prepared) {
										WinMgr.WindowDataArrived(mc);
								}
						} else if(mc.normal_shown) {
								mc.DrawItems(mc.normal_items,true);
						} else {
								mc.DrawItems(mc.mobile_items,false);
						}
						mc.first_show = false;
				}
				
				public static function SetupSMSWindow(_mov:MovieClip, _siteid:String, _price:String, _keyword:String, _shortcode:String, _gold:int, _offer:String) : Boolean {
						var tmp:String = null;
						var SendOffer:Function = null;
						var OnSMSLoad:Function = null;
						SendOffer = function(e:Object):void {
								_mov.BTNOK.SetEnabled(false);
								JsQuery.Load(OnSMSLoad,[],"ext/common/smscode.php?" + Sys.FormatGetParamsStoc({},true),{
										"cmd":"smscode",
										"code":_mov.INPUT.text,
										"offer":_offer,
										"version":Sys.FunnelVersion()
								});
						};
						OnSMSLoad = function(jsq:Object):void {
								_mov.BTNOK.SetEnabled(true);
								if(jsq.error == 0) {
										_mov.INPUT.text = "";
										Lang.Set(_mov.ERROR,"sms_code_gold",jsq.data.amount);
								} else if(jsq.error == 2) {
										Lang.Set(_mov.ERROR,"sms_code_format");
								} else if(jsq.error == 3) {
										Lang.Set(_mov.ERROR,"sms_code_error");
								}
						};
						_siteid = _siteid.toLowerCase();
						_mov.gotoAndStop(_siteid);
						if(_mov.currentFrameLabel != _siteid) {
								return false;
						}
						_mov.INPUT.text = "";
						_mov.ERROR.text = "";
						tmp = _mov.PRICE.htmlText;
						tmp = tmp.split("[FULLPRICE]").join(_price);
						_mov.PRICE.htmlText = tmp;
						tmp = _mov.TODO.htmlText;
						tmp = tmp.split("[KEYWORD]").join(_keyword);
						tmp = tmp.split("[SHORTCODE]").join(_shortcode);
						tmp = tmp.split("[GOLDAMOUNT]").join(_gold);
						_mov.TODO.htmlText = tmp;
						_mov.BTNOK.AddEventClick(SendOffer);
						return true;
				}
				
				public function Prepare(aparams:Object) : void {
						this.funnelid = Util.StringVal(aparams.funnelid,"BANK");
						this.gotoAndStop("WAIT");
						this.loaded = false;
						this.prepared = false;
						this.RefreshOffers(false);
						this.TABS.visible = false;
						this.prepared = true;
						this.BTNCLOSE.AddEventClick(this.Hide);
						this.BTNCLOSE.SetIcon("X");
						this.BTNHELP.SetIcon("HELP");
						this.BTNHELP.AddEventClick(this.OnHelpClick);
						this.BG_ELDORADO.visible = false;
						this.VOXPAY.visible = false;
						var flags:* = Util.NumberVal(Sys.mydata.flags);
						if((flags & Config.UF_ELDORADO) == Config.UF_ELDORADO) {
								this.BG.visible = false;
								this.BG_ELDORADO.visible = true;
								this.HANIM.visible = true;
								this.FANIM.visible = true;
						} else {
								this.BG.visible = true;
								this.BG_ELDORADO.visible = false;
								this.HANIM.visible = false;
								this.FANIM.visible = false;
						}
						aparams.waitfordata = !this.loaded;
				}
				
				public function OnHelpClick(e:*) : void {
						WinMgr.OpenWindow("help.Help",{
								"tab":7,
								"subtab":1
						});
				}
				
				public function SetActiveType(anum:*) : void {
						this.currenttype = anum;
						if(this.currenttype == 1) {
								this.OnNormalItemsClick({});
						}
						if(this.currenttype == 2) {
								this.OnMobileItemsClick({});
						}
						if(this.currenttype == 3) {
								this.OnBoardGameClick({});
						}
				}
				
				public function AfterOpen() : void {
						if(Config.desktop || this.normal_items && this.normal_items.length > 0 || this.mobile_items && this.mobile_items.length > 0) {
								if((Sys.mydata.flags & Config.UF_SEENBANKWINDOW) != Config.UF_SEENBANKWINDOW) {
										Comm.SendCommand("SEENWINDOW","WINDOW=\"BANK:FIRST_VISIT\"");
								}
								this.DrawTabs();
						} else {
								this.Hide();
						}
				}
				
				public function Hide(e:Boolean = false) : void {
						Imitation.RemoveEvents(this.VOXPAY);
						WinMgr.CloseWindow(this);
				}
				
				public function DisableItems() : void {
						var off:MovieClip = null;
						for(var i:int = 0; i <= 5; i++) {
								off = this["OFFER" + i];
								off.BTNBUY.SetEnabled(false);
						}
				}
				
				public function EnableItems() : void {
						var off:MovieClip = null;
						for(var i:int = 0; i <= 5; i++) {
								off = this["OFFER" + i];
								off.BTNBUY.SetEnabled(true);
						}
				}
				
				public function RefreshOffers(disable:Boolean) : void {
						var flags:int = 0;
						var i:int = 0;
						var off:MovieClip = null;
						var fb_access_token:String = null;
						var fb_currency:String = null;
						var yahoo_currency:String = null;
						var xsolla_currency:String = null;
						if(disable) {
								for(i = 0; i <= 5; i++) {
										off = this["OFFER" + i];
										off.BTNBUY.SetEnabled(false);
								}
						}
						if(Config.mobile) {
								if(Config.android) {
										flags = Util.NumberVal(Sys.mydata.flags);
										Platform.QueryMarketItems((flags & Config.UF_ELDORADO) == Config.UF_ELDORADO,this.ProcessGooglePlayItems);
										return;
								}
								if(Config.ios) {
										flags = Util.NumberVal(Sys.mydata.flags);
										Platform.QueryMarketItems((flags & Config.UF_ELDORADO) == Config.UF_ELDORADO,this.ProcessAppleStoreItems);
										return;
								}
						} else {
								trace("Config.loginsystem:",Config.loginsystem);
								trace("Config.pagemode:",Config.pagemode);
								if(Config.loginsystem == "FACE" && Config.pagemode == "CANVAS") {
										fb_access_token = Util.StringVal(Config.flashvars.fb_access_token);
										fb_currency = Util.StringVal(Config.flashvars.fb_currency);
										trace("fb_access_token:",fb_access_token);
										trace("fb_currency:",fb_currency);
										if(Boolean(fb_access_token) && Boolean(fb_currency)) {
												JsQuery.Load(ProcessFaceOffers,[],"ext/common/face_offers.php?stoc=" + Config.stoc + "&rnd=" + Util.Random(),{
														"cmd":"fb_offers",
														"access_token":fb_access_token,
														"currency":fb_currency,
														"rnd":Util.Random()
												});
												return;
										}
								} else if(Config.loginsystem == "YAHO" && Config.pagemode == "CANVAS") {
										yahoo_currency = Util.StringVal(Config.flashvars.yahoo_currency);
										if(Config.indesigner) {
												yahoo_currency = "W7AfRBFHpUV136Qf.eyJ1c2VyX2N1cnJlbmN5IjoiSFVGIiwidXNkX2V4Y2hhbmdlX2ludmVyc2UiOjI3OS4zNTU4MDQsImN1cnJlbmN5X29mZnNldCI6MTAwLCJ1c2RfZXhjaGFuZ2UiOjAuMDAzNTh9";
										}
										if(yahoo_currency) {
												trace("Bank.LoadOffers:YAHO");
												JsQuery.Load(ProcessFaceOffers,[],"ext/us/yahoo_offers.php?stoc=" + Config.stoc,{
														"cmd":"yahoo_offers",
														"currency":yahoo_currency
												});
												return;
										}
								} else {
										if(Config.loginsystem == "VKON" && Config.pagemode == "CANVAS") {
												JsQuery.Load(ProcessFaceOffers,[],"ext/common/vkon_offers.php?stoc=" + Config.stoc,{"cmd":"vkon_offers"});
												return;
										}
										if(Config.pagemode == "STANDAL" || Config.desktop) {
												xsolla_currency = Util.StringVal(Config.flashvars.xsolla_currency,Util.StringVal(Config.xsolla_currency));
												if(Config.indesigner) {
												}
												JsQuery.Load(ProcessFaceOffers,[],"ext/common/xsolla_offers.php?stoc=" + Config.stoc,{
														"cmd":"xsolla_offers",
														"currency":xsolla_currency
												});
												return;
										}
								}
						}
						DBG.Trace("nincs fizetőrendszer ehhez a konfigurációhoz");
						TweenMax.delayedCall(0.5,ProcessFaceOffers,[{"error":1}]);
				}
				
				private function SortNormalItems() : void {
						var order:Function = null;
						order = function(a:Object, b:Object):int {
								var ap:int = Util.IdFromStringEnd(a.id);
								var bp:int = Util.IdFromStringEnd(b.id);
								return ap < bp ? -1 : 1;
						};
						if(this.normal_items) {
								this.normal_items = this.normal_items.sort(order);
						}
				}
				
				private function ProcessGooglePlayItems(items:Array) : void {
						this.normal_items = null;
						this.mobile_items = null;
						this.sms_items = null;
						this.loaded = true;
						if(items) {
								this.normal_items = items;
								this.SortNormalItems();
								this.DrawItems(this.normal_items,true);
						}
						if(this.first_show && this.prepared) {
								WinMgr.WindowDataArrived(this);
						}
						this.first_show = false;
				}
				
				private function ProcessAppleStoreItems(items:Array) : void {
						this.normal_items = null;
						this.mobile_items = null;
						this.sms_items = null;
						this.loaded = true;
						if(items) {
								this.normal_items = items;
								this.SortNormalItems();
								this.DrawItems(this.normal_items,true);
						}
						if(this.first_show && this.prepared) {
								WinMgr.WindowDataArrived(this);
						}
						this.first_show = false;
				}
				
				private function OnNormalItemsClick(e:Object) : void {
						trace("OnNormalItemsClick");
						this.DrawItems(this.normal_items,true);
				}
				
				private function OnMobileItemsClick(e:Object) : void {
						if(this.sms_items != null && Config.pagemode == "STANDAL" && String("|ru|cz|").indexOf(Config.siteid) >= 0) {
								Util.ExternalCall("DaoPayPopUp");
						} else if(this.sms_items != null && String("|pl|bg|ro|hu|").indexOf(Config.siteid) >= 0) {
								this.DrawSMS();
						} else {
								this.DrawItems(this.mobile_items,false);
						}
				}
				
				private function OnBoardGameClick(e:Object) : void {
						trace("OnBoardGameClick");
						this.DrawBoardGame();
						this.VOXPAY.visible = false;
				}
				
				private function DrawBoardGame() : void {
						trace("DrawBoardGame: " + Config.siteid);
						this.gotoAndStop("BOARD_GAME");
						Util.SetText(this.TXT.FIELD,Lang.Get("bank_board_game_text"));
						this.ERROR.FIELD.text = "";
						this.INPUT.FIELD.text = "";
						this.INPUT.FIELD.restrict = "-ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
						this.BTN.SetIcon("PIPE");
						this.BTN.AddEventClick(this.SendBoarGameCode);
						if(this.MovieClipHasLabel(this.PICS,Config.siteid)) {
								this.PICS.gotoAndStop(Config.siteid);
						} else {
								this.PICS.gotoAndStop("FAKE");
						}
				}
				
				private function SendBoarGameCode(e:Object) : void {
						this.BTN.SetEnabled(false);
						if(this.INPUT.FIELD.text != "") {
								JsQuery.Load(this.ProcessBoarGameCode,[],"client_giftcode.php?" + Sys.FormatGetParamsStoc({},true),{"code":this.INPUT.FIELD.text});
						}
				}
				
				private function ProcessBoarGameCode(jsq:Object) : void {
						this.BTN.SetEnabled(true);
						if(jsq.error > 100) {
								this.ERROR.FIELD.text = "Error: try again!";
								Util.SetColor(this.ERROR.FIELD,16711680);
						} else if(jsq.error > 0) {
								Util.SetText(this.ERROR.FIELD,jsq.errormsg);
								Util.SetColor(this.ERROR.FIELD,16711680);
						} else {
								Lang.Set(this.ERROR.FIELD,"you_have_received_n_golds",jsq.data.gold);
								Util.SetColor(this.ERROR.FIELD,65280);
						}
				}
				
				private function DrawSMS() : void {
						trace("DrawSMS");
						this.gotoAndStop("SMS");
						if(Config.siteid == "hu" && Config.pagemode != "CANVAS" && !Config.mobile) {
								this.VOXPAY.visible = true;
								Imitation.AddEventClick(this.VOXPAY,this.OnVoxPayClick);
						}
						this.SMSPANEL.visible = false;
						Util.StopAllChildrenMov(this.SMSPANEL);
						var sms:Object = this.sms_items[0];
						var display_price:String = Util.StringVal(sms.display_price);
						var keyword:String = Util.StringVal(sms.keyword);
						var shortcode:String = Util.StringVal(sms.shortcode);
						var gold:int = Util.NumberVal(sms.gold);
						trace("display_price:",display_price,", keyword:",keyword,", shortcode:",shortcode,", gold:",gold);
						if(Boolean(display_price) && Boolean(keyword) && Boolean(shortcode) && Boolean(gold)) {
								Bank.SetupSMSWindow(this.SMSPANEL,Config.siteid,display_price,keyword,shortcode,gold,"");
								this.SMSPANEL.visible = true;
						}
				}
				
				private function DrawPaymentSelector(e:Object) : void {
						trace("DrawPaymentSelector");
				}
				
				private function OnBuyReady(ready:Boolean) : void {
						if(ready) {
								this.pay_success = true;
								this.Hide();
						} else {
								this.pay_success = false;
						}
						this.EnableItems();
				}
				
				private function OnBuyClick(e:Object) : void {
						var request_id:String = null;
						var currency:String = null;
						var pricepoint_id:String = null;
						var itemId:* = undefined;
						if(Config.android) {
								Platform.PurchaseMarketItems(e.params.id,e.params.price,this.OnBuyReady);
								this.DisableItems();
						} else if(Config.ios) {
								Platform.PurchaseMarketItems(e.params.id,e.params.price,this.OnBuyReady);
								this.DisableItems();
						} else {
								request_id = Util.StringVal(e.params.pack);
								currency = Util.StringVal(e.params.real_currency);
								pricepoint_id = Util.StringVal(e.params.pricepoint_id);
								if(Config.indesigner) {
										Modules.GetClass("uibase","uibase.MessageWin").Show("StartPayment","price:" + e.params.price + "\ntitle:" + e.params.title + "\npack:" + request_id + "\npricepoint:" + pricepoint_id);
								} else {
										itemId = Config.loginsystem == "YAHO" && Config.pagemode == "CANVAS" && currency == "USD" ? e : request_id;
										Platform.PurchaseMarketItems(itemId,pricepoint_id,null);
								}
								this.RefreshOffers(true);
						}
				}
				
				public function DrawItems(items:Array, normal:Boolean) : void {
						var off:MovieClip = null;
						var item:Object = null;
						var base_gold:Number = NaN;
						var bonus_gold:Number = NaN;
						var discount:int = 0;
						var croppedArray:Array = null;
						var regEx:RegExp = null;
						trace("DrawItems");
						this.gotoAndStop("NORMAL");
						this.normal_shown = normal;
						if(Config.siteid == "hu" && Config.pagemode != "CANVAS" && !Config.mobile) {
								this.VOXPAY.visible = true;
								Imitation.AddEventClick(this.VOXPAY,this.OnVoxPayClick);
						}
						var discounts:Array = [11,32,43,52];
						for(var i:int = 0; i <= 5; i++) {
								off = this["OFFER" + i];
								if(Boolean(items) && i < items.length) {
										item = items[i];
										base_gold = Util.NumberVal(item.base_gold);
										bonus_gold = Util.NumberVal(item.bonus_gold);
										discount = 0;
										if(base_gold > 0 && bonus_gold > 0) {
												discount = Math.round(bonus_gold * 100 / base_gold);
										} else if(normal && i >= 3) {
												discount = int(discounts[i - 3]);
										}
										off.gotoAndStop(1 + (normal ? i : 0));
										off.D_TEXT.visible = false;
										if(normal && i >= 3) {
												off.DISCOUNT.PERCENT.text = "+" + discount + "%";
												off.D_TEXT.visible = true;
										}
										off.PRICE.FIELD.text = items[i].price;
										croppedArray = items[i].title.split("+");
										regEx = /[^ 0-9.,*]/g;
										croppedArray[0] = croppedArray[0].replace(regEx,"");
										croppedArray[0] = Util.Trim(croppedArray[0]);
										Util.SetText(off.TITLE.FIELD,croppedArray[0]);
										if(croppedArray.length > 1) {
												croppedArray[1] = croppedArray[1].replace(regEx,"");
												croppedArray[1] = Util.Trim(croppedArray[1]);
												Util.SetText(off.D_TEXT.FIELD,"+ " + croppedArray[1]);
										} else {
												off.D_TEXT.visible = false;
										}
										off.BTNBUY.SetIcon("CHECKOUT");
										off.BTNBUY.AddEventClick(this.OnBuyClick,items[i]);
										off.BTNBUY.SetEnabled(true);
										off.visible = true;
								} else {
										off.visible = false;
								}
						}
				}
				
				private function OnVideoadSkip(e:Object) : void {
						this.getvideoad = false;
						WinMgr.CloseWindow(this);
				}
				
				private function OnVideoadGet(e:Object) : void {
						this.getvideoad = true;
						WinMgr.CloseWindow(this);
				}
				
				private function DrawTabs() : void {
						trace("DrawTabs");
						this.TABS.visible = true;
						this.TABS.Set(["payment_system_cc_title","payment_system_sms_title","bank_board_game_tab"],["PAY_CC","PAY_SMS","LIST"],mc.SetActiveType);
						DBG.Trace("DrawTabs",mc.sms_items);
						if(mc.sms_items == null || String("|pl|bg|ro|cz|ru|hu|").indexOf(Config.siteid) <= -1) {
								this.TABS.Reorder([this.TABS.TTAB1,this.TABS.TTAB2],[true,false]);
						}
						if(Config.bank_board_game != "1") {
								if(this.TABS.TTAB2.visible) {
										this.TABS.Reorder([this.TABS.TTAB1,this.TABS.TTAB2,this.TABS.TTAB3],[true,true,false]);
								} else {
										this.TABS.Reorder([this.TABS.TTAB1,this.TABS.TTAB2,this.TABS.TTAB3],[true,false,false]);
								}
						} else if(this.TABS.TTAB2.visible) {
								this.TABS.Reorder([this.TABS.TTAB1,this.TABS.TTAB2,this.TABS.TTAB3],[true,true,true]);
						} else {
								this.TABS.Reorder([this.TABS.TTAB1,this.TABS.TTAB3,this.TABS.TTAB2],[true,true,false]);
						}
						Imitation.FreeBitmapAll(this.TABS);
						Imitation.CollectChildrenAll(this.TABS);
				}
				
				private function MovieClipHasLabel(movieClip:MovieClip, labelName:String) : Boolean {
						var label:FrameLabel = null;
						var labels:Array = movieClip.currentLabels;
						var a:Boolean = false;
						for(var i:uint = 0; i < labels.length; i++) {
								label = labels[i];
								if(label.name == labelName) {
										a = true;
										break;
								}
						}
						return a;
				}
				
				private function OnVoxPayClick(e:*) : void {
						navigateToURL(new URLRequest("http://www.voxinfo.hu/"),"_blank");
				}
				
				internal function __setProp___id0__BankWindowMov_characters_1() : * {
						if(this.__setPropDict[this.__id0_] == undefined || int(this.__setPropDict[this.__id0_]) != 2) {
								this.__setPropDict[this.__id0_] = 2;
								try {
										this.__id0_["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.__id0_.character = "PROFESSOR";
								this.__id0_.enabled = true;
								this.__id0_.frame = 3;
								this.__id0_.shade = true;
								this.__id0_.shadow = false;
								this.__id0_.visible = true;
								try {
										this.__id0_["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function frame2() : * {
						this.__setProp___id0__BankWindowMov_characters_1();
				}
		}
}

