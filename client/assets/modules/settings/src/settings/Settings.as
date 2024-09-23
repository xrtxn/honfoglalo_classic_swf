package settings {
		import com.greensock.TweenMax;
		import components.ButtonComponent;
		import components.CharacterComponent;
		import components.CommonGfx;
		import fl.transitions.easing.Regular;
		import flash.display.*;
		import flash.events.*;
		import flash.text.*;
		import flash.utils.*;
		import syscode.*;
		import uibase.CountryFlagMov;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol195")]
		public class Settings extends MovieClip {
				public static var mc:Settings = null;
				
				public static var selected_soldier:int = 1;
				
				public var AVATAR:AvatarMov;
				
				public var BTNAVATAR:MovieClip;
				
				public var BTNCHANGECOUNTRY:ButtonComponent;
				
				public var BTNCHANGEEMAIL:ButtonComponent;
				
				public var BTNCHANGEPASS:ButtonComponent;
				
				public var BTNCLOSE:ButtonComponent;
				
				public var BTNCUSTOMIZE:ButtonComponent;
				
				public var BTNDELETEME:ButtonComponent;
				
				public var BUY:MovieClip;
				
				public var CB_AUTOBOT:CheckBox;
				
				public var CB_AUTOLOGIN:CheckBox;
				
				public var CB_EFFECTS:CheckBox;
				
				public var CB_FRIENDLY:CheckBox;
				
				public var CB_MUSIC:CheckBox;
				
				public var CB_QPRGAME:CheckBox;
				
				public var COUNTRYFLAG:CountryFlagMov;
				
				public var COUNTRYID:TextField;
				
				public var COUNTRYNAME:TextField;
				
				public var C_AUDIO:TextField;
				
				public var C_AUTOBOT:TextField;
				
				public var C_AUTOLOGIN:TextField;
				
				public var C_AVATAR:TextField;
				
				public var C_AVATAR2:TextField;
				
				public var C_COUNTRY:TextField;
				
				public var C_DELETEME:TextField;
				
				public var C_EFFECTS:TextField;
				
				public var C_EMAIL:TextField;
				
				public var C_EMAILCH:TextField;
				
				public var C_FRIENDLY:TextField;
				
				public var C_MUSIC:TextField;
				
				public var C_NEWPASS:TextField;
				
				public var C_OLDPASS:TextField;
				
				public var C_OPTIONS:TextField;
				
				public var C_PASS:TextField;
				
				public var C_PASS2:TextField;
				
				public var C_PASSCH:TextField;
				
				public var C_QPRGAME:TextField;
				
				public var C_RPASS:TextField;
				
				public var C_SOLDIERS:TextField;
				
				public var C_SOLDIERS2:TextField;
				
				public var EMAIL:TextField;
				
				public var IMPRESSUM_FIELD:TextField;
				
				public var LOCK:CommonGfx;
				
				public var NEWPASS:TextField;
				
				public var NEXTBTN:SimpleButton;
				
				public var OLDPASS:TextField;
				
				public var PASS:TextField;
				
				public var PASS2:TextField;
				
				public var PREVBTN:SimpleButton;
				
				public var RPASS:TextField;
				
				public var SBG:MovieClip;
				
				public var SOLDIER:MovieClip;
				
				public var SOLDIER1:MovieClip;
				
				public var SOLDIER2:MovieClip;
				
				public var SOLDIER3:MovieClip;
				
				public var TABS:FriendsTabClass;
				
				public var THXLOGO:MovieClip;
				
				public var __id1_:CharacterComponent;
				
				public var __setPropDict:Dictionary;
				
				public var __lastFrameProp:int = -1;
				
				private var soldiers:Object;
				
				public var initialized:Boolean = false;
				
				public var waitanim:Object = null;
				
				private var soldier_timer:Timer;
				
				private var reftime:Number = 0;
				
				private var remsec:Number = 0;
				
				public var currentpage:int = 1;
				
				public function Settings() {
						this.__setPropDict = new Dictionary(true);
						this.soldiers = {};
						this.soldier_timer = new Timer(1000,0);
						super();
						addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3);
						addEventListener(Event.FRAME_CONSTRUCTED,this.__setProp_handler,false,0,true);
				}
				
				public static function ObjectTrace(_obj:Object, sPrefix:String = "") : void {
						var i:* = undefined;
						if(sPrefix == "") {
								sPrefix = "-->";
						} else {
								sPrefix += " -->";
						}
						for(i in _obj) {
								trace(sPrefix,i + ":" + _obj[i]," ");
								if(typeof _obj[i] == "object") {
										ObjectTrace(_obj[i],sPrefix);
								}
						}
				}
				
				public static function ShowResult(jsq:*, title:*, success_str:*) : * {
						if(!mc) {
								return;
						}
						var MessageWin:* = Modules.GetClass("uibase","uibase.MessageWin");
						if(!jsq.error) {
								mc.HideWin();
								MessageWin.Show(Lang.get(title),Lang.get(success_str),mc.RestoreWin,2);
						} else {
								mc.HideWin();
								MessageWin.Show(Lang.get("error"),jsq.errormsg,mc.RestoreWin);
						}
				}
				
				public function Prepare(aparams:Object) : void {
						if(this.waitanim) {
								this.waitanim.HideWaitAnim();
						}
						aparams.waitfordata = true;
						gotoAndStop(1);
						Util.StopAllChildrenMov(this);
						this.BTNCLOSE.AddEventClick(this.OnCloseClicked);
						this.BTNCLOSE.SetCaption("X");
						selected_soldier = Sys.mydata.soldier;
						Util.AddEventListener(Imitation.rootmc,"MYDATACHANGE",this.OnMyDataChange);
						this.TABS.Set(["customize","game_settings","personal_settings","impressum_title"],this.SetActivePage);
						if(Config.loginsystem != "MAIL") {
								this.TABS.TTAB3.visible = false;
								this.TABS.TTAB4.x = this.TABS.TTAB3.x;
						}
						Util.AddEventListener(this.soldier_timer,TimerEvent.TIMER,this.OnTimer);
						this.soldier_timer.start();
				}
				
				public function AfterClose() : void {
						Util.RemoveEventListener(this.soldier_timer,TimerEvent.TIMER,this.OnTimer);
						if(selected_soldier > 0 && selected_soldier != Sys.mydata.soldier) {
								if(Boolean(this.soldiers[selected_soldier]) && Boolean(this.soldiers[selected_soldier].have)) {
										Comm.SendCommand("SETDATA","SOLDIER=\"" + selected_soldier + "\"");
								}
						}
						Util.RemoveEventListener(Imitation.rootmc,"MYDATACHANGE",this.OnMyDataChange);
				}
				
				public function OnCloseClicked(arg:Object) : void {
						WinMgr.CloseWindow(this);
				}
				
				public function SetActivePage(apagenum:int) : void {
						this.currentpage = apagenum;
						this.gotoAndStop(this.currentpage);
						if(this.currentpage == 1) {
								this.ShowCustomSettings();
						} else if(this.currentpage == 2) {
								this.ShowGameSettings();
						} else if(this.currentpage == 3) {
								this.ShowPersonalSettings();
						} else if(this.currentpage == 4) {
								this.ShowImpressum();
						}
				}
				
				public function OnMyDataChange(e:*) : * {
						if(mc) {
								mc.SetActivePage(this.currentpage);
						}
				}
				
				public function UpdateSoldier(s:MovieClip, color:int) : * {
						var c:Class = null;
						var skin:int = selected_soldier;
						s.gotoAndStop(color);
						if(s.SKIN.contains(s.SKIN.PLACEHOLDER)) {
								s.SKIN.removeChild(s.SKIN.PLACEHOLDER);
						}
						if(!s.SKIN.mc) {
								c = Modules.GetClass("soldiers","Soldiers");
								if(!c) {
										trace("Soldiers not loaded!");
										return;
								}
								s.SKIN.mc = new c();
								s.SKIN.mc.scaleX = 0.39;
								s.SKIN.mc.scaleY = s.SKIN.mc.scaleX;
								s.SKIN.addChild(s.SKIN.mc);
						}
						s.SKIN.skincount = s.SKIN.mc.totalFrames;
						if(skin < 1 || skin > s.SKIN.skincount) {
								skin = 1;
						}
						if(!this.soldiers[skin]) {
								s.visible = false;
								return;
						}
						s.visible = true;
						s.SKIN.mc.gotoAndStop(skin);
						s.SKIN.mc.COLOR.gotoAndStop(color);
						s.SKIN.mc.cacheAsBitmap = true;
						Imitation.FreeBitmapAll(s);
						Imitation.Update(s);
						if(s != this.SOLDIER) {
								return;
						}
						this.BUY.BTNBUY.SetLang("buy");
						this.BUY.BTNBUY.AddEventClick(this.OnBuyClick);
						var price:Number = Number(this.soldiers[skin].cost);
						s.alpha = this.SBG.alpha = !!this.soldiers[skin].have ? 1 : 0.5;
						this.BUY.COST.PRICE.text = Util.FormatNumber(price);
						this.BUY.visible = !this.soldiers[skin].have;
						var available:* = this.soldiers[skin].type == 0;
						this.LOCK.visible = !available;
						this.BUY.BTNBUY.SetEnabled(available);
						if(this.soldiers[skin].remaining > 0) {
								this.BUY.DATE.visible = true;
								if(available) {
										Lang.Set(this.BUY.DATE.C_REMAINING,"available_until+:");
								} else {
										Lang.Set(this.BUY.DATE.C_REMAINING,"available_in+:");
								}
								this.remsec = Util.NumberVal(this.soldiers[skin].remaining);
								Util.SetText(this.BUY.DATE.REMAINING,Util.FormatRemaining(this.remsec - Math.round((new Date().time - this.reftime) / 1000)));
								Imitation.GotoFrame(this.SBG,!!available ? 3 : 4);
						} else {
								this.remsec = 0;
								this.BUY.DATE.visible = false;
								Imitation.GotoFrame(this.SBG,!this.soldiers[skin].have && price > 0 ? 2 : 1);
						}
				}
				
				public function OnTimer(e:TimerEvent = null) : void {
						var rem:String = null;
						var now:Number = NaN;
						var dif:int = 0;
						if(!mc) {
								return;
						}
						if(this.remsec == 0) {
								return;
						}
						if(currentFrame == 1) {
								rem = "";
								if(this.reftime > 0 && this.remsec > 0) {
										now = new Date().time;
										dif = Math.round((now - this.reftime) / 1000);
										if(dif <= this.remsec) {
												rem = Util.FormatRemaining(this.remsec - dif);
										} else if(this.soldiers[selected_soldier].type != 2) {
												this.ShowCustomSettings();
												return;
										}
								}
								if(this.BUY.DATE.REMAINING.text != rem) {
										Util.SetText(this.BUY.DATE.REMAINING,rem);
								}
						}
				}
				
				public function OnBuyClick(e:* = null) : void {
						Comm.SendCommand("BUYITEM","ITEMTYPE=\"SOLDIER\" ITEMINDEX=\"" + selected_soldier + "\"",this.HandleBuyResult);
				}
				
				public function HandleBuyResult(res:int, xml:XML = null) : void {
						if(res == 0) {
								return;
						}
						if(res == 77) {
								WinMgr.OpenWindow("bank.Bank",{"funnelid":"Soldier"});
								return;
						}
				}
				
				public function UpdateSoldiers(anim:* = false) : * {
						var d:*;
						var i:*;
						var s:* = undefined;
						this.UpdateSoldier(this.SOLDIER,1);
						d = 0;
						for(i = 1; i <= 3; i++) {
								s = this["SOLDIER" + i];
								if(anim) {
										TweenMax.delayedCall(d,function(s:*, i:*):* {
												UpdateSoldier(s,i);
										},[s,i]);
								} else {
										this.UpdateSoldier(s,i);
								}
								d += 0.15;
						}
				}
				
				public function ShowGameSettings() : * {
						var desc:String = null;
						this.BTNCHANGECOUNTRY.SetLang("do_change");
						Util.RTLSwap("SETTINGS1",this.COUNTRYNAME,this.COUNTRYID);
						Util.RTLSwap("SETTINGS2",this.C_QPRGAME,this.CB_QPRGAME);
						Util.RTLSwap("SETTINGS3",this.C_AUTOBOT,this.CB_AUTOBOT);
						Util.RTLSwap("SETTINGS4",this.C_EFFECTS,this.CB_EFFECTS);
						Util.RTLSwap("SETTINGS5",this.C_MUSIC,this.CB_MUSIC);
						Util.RTLSwap("SETTINGS6",this.C_FRIENDLY,this.CB_FRIENDLY);
						Util.RTLSwap("SETTINGS7",this.C_AUTOLOGIN,this.CB_AUTOLOGIN);
						this.BTNCHANGECOUNTRY.AddEventClick(this.OnChangeCountryClick);
						Imitation.AddEventClick(this.CB_QPRGAME,this.OnQPRGameClick);
						Imitation.AddEventClick(this.CB_AUTOBOT,this.OnAutobotClick);
						Imitation.AddEventClick(this.CB_FRIENDLY,this.OnFriendlyClick);
						Imitation.AddEventClick(this.CB_EFFECTS,this.OnEffectsClick);
						Imitation.AddEventClick(this.CB_MUSIC,this.OnMusicClick);
						Imitation.AddEventClick(this.CB_AUTOLOGIN,this.OnAutologinClick);
						if(Config.siteid == "us") {
								Util.SetText(this.C_COUNTRY,Lang.Get("your_state") + ":");
						} else {
								Util.SetText(this.C_COUNTRY,Lang.Get("your_country") + ":");
						}
						Lang.Set(this.C_AUDIO,"audio_options+:");
						Lang.Set(this.C_OPTIONS,"game_options+:");
						this.COUNTRYID.text = Sys.mydata.country;
						this.COUNTRYID.visible = false;
						var cid:String = Sys.mydata.country;
						if(cid == "a1" || cid == "a2" || cid == "ap" || cid == "eu" || cid == "--") {
								cid = "--";
						}
						this.COUNTRYFLAG.Set(cid);
						if(cid == "--") {
								Lang.Set(this.COUNTRYNAME,"unknown");
						} else {
								Util.SetText(this.COUNTRYNAME,Extdata.CountryName(Sys.mydata.country));
								desc = Util.StringVal(Extdata.CountryDescription(Sys.mydata.country));
								if(desc.length > 0) {
								}
						}
						Lang.Set(this.C_EFFECTS,"sound_effects");
						Lang.Set(this.C_MUSIC,"music");
						Lang.Set(this.C_QPRGAME,"qprgame_title");
						Lang.Set(this.C_AUTOBOT,"autobot_title");
						Lang.Set(this.C_FRIENDLY,"allow_friendly_game_invite");
						Lang.Set(this.C_AUTOLOGIN,"autologin_title");
						this.C_AUTOBOT.visible = false;
						this.CB_AUTOBOT.visible = false;
						this.UpdateCheckBoxes();
				}
				
				public function OnCustomClick(e:* = null) : * {
						WinMgr.OpenWindow("settings.AvatarWin",{
								"strdef":Sys.mydata.customavatar,
								"previewmc":null,
								"callback":null
						});
				}
				
				public function ShowCustomSettings() : * {
						var ap:Object = null;
						Lang.Set(this.C_SOLDIERS,"your_soldiers");
						Lang.Set(this.C_SOLDIERS2,"your_soldiers_description");
						trace("GETSTOREITEMS:");
						Comm.SendCommand("GETSTOREITEMS ","",this.OnStoreItemsCallback);
						this.UpdateSoldiers();
						if(this.C_AVATAR) {
								Lang.Set(this.C_AVATAR,"avatar+:");
						}
						if(this.C_AVATAR2) {
								Lang.Set(this.C_AVATAR2,"avatar_description");
						}
						if(Sys.mydata.customavatar == "") {
								ap = AvatarFactory.CreateProperties("");
								AvatarFactory.RandomizeProperties(ap,Sys.mydata.sex == 2 ? 2 : 1);
								Sys.mydata.customavatar = AvatarFactory.FormatProperties(ap);
						}
						Modules.GetClass("system","system.AvatarMov");
						this.AVATAR.Clear();
						this.AVATAR.ShowUID(Sys.mydata.id);
						Imitation.AddEventClick(this.BTNAVATAR,this.OnCustomClick);
						this.BTNCUSTOMIZE.AddEventClick(this.OnCustomClick);
						this.BTNCUSTOMIZE.SetLang("customize");
						if(Config.loginsystem == "NKLA" || Sys.mydata.extavatar == "") {
								Sys.mydata.usecustomavatar = true;
						}
						if(selected_soldier == 0) {
								this.NEXTBTN.visible = false;
								this.PREVBTN.visible = false;
								this.C_SOLDIERS2.visible = false;
						}
						Imitation.AddEventClick(this.NEXTBTN,this.OnPrevNextClick);
						Imitation.AddEventClick(this.PREVBTN,this.OnPrevNextClick);
				}
				
				private function OnStoreItemsCallback(res:int, xml:XML) : void {
						var i:int = 0;
						var s:Array = null;
						var n:int = 0;
						var have:* = false;
						trace("OnStoreItemsCallback");
						var data:Object = Util.XMLTagToObject(xml);
						DBG.Trace("data",data);
						var ss:Array = Util.StringVal(data.STORE.SOLDIERS.P.VALUE).split(";");
						this.soldiers = {};
						this.reftime = new Date().time;
						for(i = 0; i < Sys.mydata.soldiers.length; i++) {
								if(Sys.mydata.soldiers[i] != 0) {
										this.soldiers[i] = {
												"cost":1,
												"type":0,
												"remaining":0,
												"have":true
										};
								}
						}
						for(i = 0; i < ss.length; i++) {
								s = ss[i].split(",");
								n = Util.NumberVal(s[0]);
								have = Sys.mydata.soldiers[n] != 0;
								this.soldiers[n] = {
										"cost":Util.NumberVal(s[1]),
										"type":Util.NumberVal(s[2]),
										"remaining":Util.NumberVal(s[3]),
										"have":have
								};
						}
						this.UpdateSoldiers(false);
						if(!this.initialized) {
								this.initialized = true;
								WinMgr.WindowDataArrived(mc);
						}
				}
				
				public function OnPrevNextClick(e:*) : * {
						var s:* = undefined;
						var y1:* = undefined;
						do {
								if(e.target == this.NEXTBTN) {
										if(selected_soldier < this.SOLDIER.SKIN.skincount) {
												++selected_soldier;
										} else {
												selected_soldier = 1;
										}
								} else if(selected_soldier > 1) {
										--selected_soldier;
								} else {
										selected_soldier = this.SOLDIER.SKIN.skincount;
								}
						}
						while(!this.soldiers[selected_soldier] || this.soldiers[selected_soldier].type == 2);
						
						this.UpdateSoldiers(true);
						var d:* = 0;
						for(var i:* = 1; i <= 3; i++) {
								s = this["SOLDIER" + i];
								y1 = s.y;
								if(!TweenMax.isTweening(s)) {
										TweenMax.to(s,0.1,{
												"y":s.y - 20,
												"ease":Regular.easeOut,
												"delay":d
										});
										TweenMax.to(s,0.1,{
												"y":y1,
												"ease":Regular.easeIn,
												"delay":d + 0.1
										});
								}
								d += 0.15;
						}
				}
				
				public function OnChangeCountryClick(e:*) : * {
						WinMgr.OpenWindow(SelectCountryWin);
				}
				
				public function UpdateCheckBoxes() : * {
						var ea:Boolean = false;
						var data:Object = null;
						this.CB_QPRGAME.CHECK.visible = (Sys.mydata.flags & Config.UF_NOQPRGAME) == 0;
						this.CB_AUTOBOT.CHECK.visible = (Sys.mydata.flags & Config.UF_NOAUTOBOTS) == 0;
						this.CB_FRIENDLY.CHECK.visible = (Sys.mydata.flags & Config.UF_NOFRIENDLY) == 0;
						this.CB_EFFECTS.CHECK.visible = (Sys.mydata.sndvol & 0xFF) != 0;
						this.CB_MUSIC.CHECK.visible = (Sys.mydata.sndvol & 0x0F00) != 0;
						trace("UpdateCheckBoxes");
						if(Config.android || Config.ios) {
								this.C_AUTOLOGIN.visible = true;
								this.CB_AUTOLOGIN.visible = true;
								ea = true;
								data = Platform.LoadPersistentData("login");
								ObjectTrace(data);
								if(data.enable_autologin != null) {
										ea = Boolean(data.enable_autologin);
								}
								this.CB_AUTOLOGIN.CHECK.visible = ea;
						} else {
								this.C_AUTOLOGIN.visible = false;
								this.CB_AUTOLOGIN.visible = false;
						}
				}
				
				public function OnQPRGameClick(e:*) : * {
						Sys.mydata.flags ^= Config.UF_NOQPRGAME;
						this.UpdateCheckBoxes();
						Comm.SendCommand("SETDATA","FLAGS=\"" + Sys.mydata.flags + "\" SNDVOL=\"" + Sys.mydata.sndvol + "\"");
				}
				
				public function OnAutobotClick(e:*) : * {
						Sys.mydata.flags ^= Config.UF_NOAUTOBOTS;
						this.UpdateCheckBoxes();
						Comm.SendCommand("SETDATA","FLAGS=\"" + Sys.mydata.flags + "\" SNDVOL=\"" + Sys.mydata.sndvol + "\"");
				}
				
				public function OnAutologinClick(e:*) : * {
						this.CB_AUTOLOGIN.CHECK.visible = !this.CB_AUTOLOGIN.CHECK.visible;
						var data:Object = Platform.LoadPersistentData("login");
						data.enable_autologin = this.CB_AUTOLOGIN.CHECK.visible;
						Platform.SavePersistentData("login",data);
						this.UpdateCheckBoxes();
				}
				
				public function OnFriendlyClick(e:*) : * {
						Sys.mydata.flags ^= Config.UF_NOFRIENDLY;
						this.UpdateCheckBoxes();
						Comm.SendCommand("SETDATA","FLAGS=\"" + Sys.mydata.flags + "\" SNDVOL=\"" + Sys.mydata.sndvol + "\"");
				}
				
				public function OnEffectsClick(e:*) : * {
						Sys.ToggleSound(255);
						this.UpdateCheckBoxes();
				}
				
				public function OnMusicClick(e:*) : * {
						Sys.ToggleSound(3840);
						this.UpdateCheckBoxes();
				}
				
				public function ShowPersonalSettings() : * {
						Lang.Set(this.C_PASSCH,"change_pass_title");
						Lang.Set(this.C_OLDPASS,"old_pass+:");
						Lang.Set(this.C_NEWPASS,"new_pass+:");
						Lang.Set(this.C_RPASS,"repeat_pass+:");
						this.OLDPASS.displayAsPassword = true;
						this.NEWPASS.displayAsPassword = true;
						this.RPASS.displayAsPassword = true;
						this.OLDPASS.text = this.NEWPASS.text = this.RPASS.text = "";
						this.BTNCHANGEPASS.AddEventClick(this.OnChangePassClick);
						this.BTNCHANGEPASS.SetLang("do_change");
						Lang.Set(this.C_EMAILCH,"change_email_title");
						Lang.Set(this.C_PASS,"password+:");
						Lang.Set(this.C_EMAIL,"email+:");
						this.PASS.displayAsPassword = true;
						this.PASS.text = "";
						this.BTNCHANGEEMAIL.AddEventClick(this.OnChangeEmailClick);
						this.BTNCHANGEEMAIL.SetLang("do_change");
						Lang.Set(this.C_DELETEME,"delete_me_title");
						Lang.Set(this.C_PASS2,"password+:");
						this.BTNDELETEME.AddEventClick(this.OnDeleteMeClick);
						this.BTNDELETEME.SetLang("delete");
						this.PASS2.displayAsPassword = true;
						this.PASS2.text = "";
				}
				
				public function ShowImpressum() : * {
						var v:String = String(Version.value).substr(0,2) + "." + String(Version.value).substr(2,2) + "." + String(Version.value).substr(4);
						var l:String = Lang.get("impressum_in_settings");
						var s:String = l + "\n\nV" + v;
						Util.SetText(this.IMPRESSUM_FIELD,s);
				}
				
				public function HideWin(e:* = null) : * {
						Imitation.EnableInput(mc,false);
						mc.visible = false;
				}
				
				public function RestoreWin(e:* = null) : * {
						mc.visible = true;
						Imitation.EnableInput(mc,true);
				}
				
				public function OnChangePassClick(e:*) : * {
						var MessageWin:* = Modules.GetClass("uibase","uibase.MessageWin");
						if(this.NEWPASS.text != "" && this.RPASS.text == "") {
								this.HideWin();
								MessageWin.Show(Lang.get("error"),Lang.get("emsg_repeat_pass"),this.RestoreWin);
								return;
						}
						if(this.NEWPASS.text != "" && this.NEWPASS.text != this.RPASS.text) {
								this.HideWin();
								MessageWin.Show(Lang.get("error"),Lang.get("emsg_pass_not_same"),this.RestoreWin);
								return;
						}
						JsQuery.Load(ShowResult,["change_pass_title","pass_changed"],"stal_data.php?" + Sys.FormatGetParamsStoc(null),{
								"cmd":"changepass",
								"oldpass":this.OLDPASS.text,
								"newpass":this.NEWPASS.text
						});
						this.ShowPersonalSettings();
				}
				
				public function OnChangeEmailClick(e:*) : * {
						JsQuery.Load(ShowResult,["change_email_title","email_changed"],"stal_data.php?" + Sys.FormatGetParamsStoc(null),{
								"cmd":"changemail",
								"email":this.EMAIL.text,
								"pass":this.PASS.text
						});
						this.ShowPersonalSettings();
				}
				
				public function OnDeleteMeClick(e:*) : * {
						var MessageWin:* = Modules.GetClass("uibase","uibase.MessageWin");
						this.HideWin();
						MessageWin.AskYesNo(Lang.get("delete_me_title"),Lang.get("ask_delete_me"),Lang.get("yes"),Lang.get("no"),function(a:*):* {
								RestoreWin();
								if(a == 1) {
										JsQuery.Load(ShowResult,["delete_me_title","me_deleted"],"stal_data.php?" + Sys.FormatGetParamsStoc(null),{
												"cmd":"deleteme",
												"pass":PASS2.text
										});
								}
								ShowPersonalSettings();
						});
				}
				
				internal function __setProp_BTNCLOSE_SettingsWindow_close_0(curFrame:int) : * {
						if(this.BTNCLOSE != null && curFrame >= 1 && curFrame <= 4 && (this.__setPropDict[this.BTNCLOSE] == undefined || !(int(this.__setPropDict[this.BTNCLOSE]) >= 1 && int(this.__setPropDict[this.BTNCLOSE]) <= 4))) {
								this.__setPropDict[this.BTNCLOSE] = curFrame;
								try {
										this.BTNCLOSE["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNCLOSE.enabled = true;
								this.BTNCLOSE.fontsize = "BIG";
								this.BTNCLOSE.icon = "X";
								this.BTNCLOSE.skin = "CANCEL";
								this.BTNCLOSE.testcaption = "X";
								this.BTNCLOSE.visible = true;
								this.BTNCLOSE.wordwrap = false;
								try {
										this.BTNCLOSE["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_LOCK_SettingsWindow_Layer9_0() : * {
						if(this.__setPropDict[this.LOCK] == undefined || int(this.__setPropDict[this.LOCK]) != 1) {
								this.__setPropDict[this.LOCK] = 1;
								try {
										this.LOCK["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.LOCK.enabled = true;
								this.LOCK.gfx = "lock";
								this.LOCK.visible = true;
								try {
										this.LOCK["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTNCUSTOMIZE_SettingsWindow_Layer7_0() : * {
						if(this.__setPropDict[this.BTNCUSTOMIZE] == undefined || int(this.__setPropDict[this.BTNCUSTOMIZE]) != 1) {
								this.__setPropDict[this.BTNCUSTOMIZE] = 1;
								try {
										this.BTNCUSTOMIZE["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNCUSTOMIZE.enabled = true;
								this.BTNCUSTOMIZE.fontsize = "SMALL";
								this.BTNCUSTOMIZE.icon = "";
								this.BTNCUSTOMIZE.skin = "NORMAL";
								this.BTNCUSTOMIZE.testcaption = "Customize";
								this.BTNCUSTOMIZE.visible = true;
								this.BTNCUSTOMIZE.wordwrap = false;
								try {
										this.BTNCUSTOMIZE["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp___id1__SettingsWindow_soldier_0() : * {
						if(this.__setPropDict[this.__id1_] == undefined || int(this.__setPropDict[this.__id1_]) != 1) {
								this.__setPropDict[this.__id1_] = 1;
								try {
										this.__id1_["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.__id1_.character = "PROFESSOR";
								this.__id1_.enabled = true;
								this.__id1_.frame = 3;
								this.__id1_.shade = true;
								this.__id1_.shadow = true;
								this.__id1_.visible = true;
								try {
										this.__id1_["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTNCHANGECOUNTRY_SettingsWindow_content_1() : * {
						if(this.__setPropDict[this.BTNCHANGECOUNTRY] == undefined || int(this.__setPropDict[this.BTNCHANGECOUNTRY]) != 2) {
								this.__setPropDict[this.BTNCHANGECOUNTRY] = 2;
								try {
										this.BTNCHANGECOUNTRY["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNCHANGECOUNTRY.enabled = true;
								this.BTNCHANGECOUNTRY.fontsize = "SMALL";
								this.BTNCHANGECOUNTRY.icon = "";
								this.BTNCHANGECOUNTRY.skin = "NORMAL";
								this.BTNCHANGECOUNTRY.testcaption = "Change";
								this.BTNCHANGECOUNTRY.visible = true;
								this.BTNCHANGECOUNTRY.wordwrap = false;
								try {
										this.BTNCHANGECOUNTRY["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTNCHANGEPASS_SettingsWindow_content_2() : * {
						if(this.__setPropDict[this.BTNCHANGEPASS] == undefined || int(this.__setPropDict[this.BTNCHANGEPASS]) != 3) {
								this.__setPropDict[this.BTNCHANGEPASS] = 3;
								try {
										this.BTNCHANGEPASS["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNCHANGEPASS.enabled = true;
								this.BTNCHANGEPASS.fontsize = "SMALL";
								this.BTNCHANGEPASS.icon = "";
								this.BTNCHANGEPASS.skin = "NORMAL";
								this.BTNCHANGEPASS.testcaption = "Change";
								this.BTNCHANGEPASS.visible = true;
								this.BTNCHANGEPASS.wordwrap = false;
								try {
										this.BTNCHANGEPASS["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTNCHANGEEMAIL_SettingsWindow_content_2() : * {
						if(this.__setPropDict[this.BTNCHANGEEMAIL] == undefined || int(this.__setPropDict[this.BTNCHANGEEMAIL]) != 3) {
								this.__setPropDict[this.BTNCHANGEEMAIL] = 3;
								try {
										this.BTNCHANGEEMAIL["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNCHANGEEMAIL.enabled = true;
								this.BTNCHANGEEMAIL.fontsize = "SMALL";
								this.BTNCHANGEEMAIL.icon = "";
								this.BTNCHANGEEMAIL.skin = "NORMAL";
								this.BTNCHANGEEMAIL.testcaption = "Change";
								this.BTNCHANGEEMAIL.visible = true;
								this.BTNCHANGEEMAIL.wordwrap = false;
								try {
										this.BTNCHANGEEMAIL["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTNDELETEME_SettingsWindow_content_2() : * {
						if(this.__setPropDict[this.BTNDELETEME] == undefined || int(this.__setPropDict[this.BTNDELETEME]) != 3) {
								this.__setPropDict[this.BTNDELETEME] = 3;
								try {
										this.BTNDELETEME["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNDELETEME.enabled = true;
								this.BTNDELETEME.fontsize = "SMALL";
								this.BTNDELETEME.icon = "";
								this.BTNDELETEME.skin = "CANCEL";
								this.BTNDELETEME.testcaption = "Delete";
								this.BTNDELETEME.visible = true;
								this.BTNDELETEME.wordwrap = false;
								try {
										this.BTNDELETEME["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_handler(e:Object) : * {
						var curFrame:int = currentFrame;
						if(this.__lastFrameProp == curFrame) {
								return;
						}
						this.__lastFrameProp = curFrame;
						this.__setProp_BTNCLOSE_SettingsWindow_close_0(curFrame);
				}
				
				internal function frame1() : * {
						this.__setProp___id1__SettingsWindow_soldier_0();
						this.__setProp_BTNCUSTOMIZE_SettingsWindow_Layer7_0();
						this.__setProp_LOCK_SettingsWindow_Layer9_0();
				}
				
				internal function frame2() : * {
						this.__setProp_BTNCHANGECOUNTRY_SettingsWindow_content_1();
				}
				
				internal function frame3() : * {
						this.__setProp_BTNDELETEME_SettingsWindow_content_2();
						this.__setProp_BTNCHANGEEMAIL_SettingsWindow_content_2();
						this.__setProp_BTNCHANGEPASS_SettingsWindow_content_2();
				}
		}
}

