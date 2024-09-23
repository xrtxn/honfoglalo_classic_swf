package profile2 {
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import syscode.*;
		import uibase.CountryFlagMov;
		import uibase.lego_button_1x1_cancel;
		import uibase.lego_button_1x1_ok;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol614")]
		public class SettingsPage extends MovieClip {
				public var BTN_DELETE_ME:lego_button_1x1_cancel;
				
				public var BTN_SAVE_COUNTRY:lego_button_1x1_ok;
				
				public var BTN_SAVE_EMAIL:lego_button_1x1_ok;
				
				public var BTN_SAVE_PASS:lego_button_1x1_ok;
				
				public var CB_4:CheckBox;
				
				public var CB_AUTOLOGIN:CheckBox;
				
				public var CB_EFFECTS:CheckBox;
				
				public var CB_FRIENDLY:CheckBox;
				
				public var CB_MUSIC:CheckBox;
				
				public var CB_NEWSLETTER:CheckBox;
				
				public var CB_QPRGAME:CheckBox;
				
				public var COUNTRYFLAG:CountryFlagMov;
				
				public var COUNTRYID:MovieClip;
				
				public var COUNTRYLIST:MovieClip;
				
				public var COUNTRYNAME:MovieClip;
				
				public var C_4:MovieClip;
				
				public var C_AUTOLOGIN:MovieClip;
				
				public var C_COUNTRY:MovieClip;
				
				public var C_DELETEME:MovieClip;
				
				public var C_DELETE_ME_PASS:MovieClip;
				
				public var C_EMAIL:MovieClip;
				
				public var C_EMAILCH:MovieClip;
				
				public var C_FRIENDLY:MovieClip;
				
				public var C_NEWPASS:MovieClip;
				
				public var C_NEWSLETTER:MovieClip;
				
				public var C_OLDPASS:MovieClip;
				
				public var C_PASS:MovieClip;
				
				public var C_PASSCH:MovieClip;
				
				public var C_RPASS:MovieClip;
				
				public var C_SAVE_COUNTRY:MovieClip;
				
				public var C_SAVE_EMAIL:MovieClip;
				
				public var C_SAVE_PASS:MovieClip;
				
				public var DELETE_ME_PASS:MovieClip;
				
				public var EMAIL:MovieClip;
				
				public var NEWPASS:MovieClip;
				
				public var OLDPASS:MovieClip;
				
				public var PASS:MovieClip;
				
				public var RPASS:MovieClip;
				
				public var userdata:Object = null;
				
				public function SettingsPage() {
						super();
				}
				
				public function Start(_data:Object = null) : void {
						this.Draw(_data);
				}
				
				public function Draw(_obj:Object = null) : void {
						this.userdata = _obj;
						this.C_4.visible = false;
						this.CB_4.visible = false;
						if(Config.siteid == "us") {
								Util.SetText(this.C_COUNTRY.FIELD,Lang.Get("your_state") + ":");
						} else {
								Util.SetText(this.C_COUNTRY.FIELD,Lang.Get("your_country") + ":");
						}
						Util.SetText(this.C_SAVE_COUNTRY.FIELD,Lang.Get("custom_settings"));
						this.BTN_SAVE_COUNTRY.SetIcon("SETTINGS_WHITE");
						Imitation.AddEventClick(this.BTN_SAVE_COUNTRY,this.OnSaveCountry);
						this.COUNTRYLIST.visible = false;
						this.COUNTRYLIST.MLINES.Set("MLINE",MovieClip(parent).countryList,32,1,this.OnCountryListClick,this.DrawCountryLine,this.COUNTRYLIST.MASK_LINES,this.COUNTRYLIST.SB);
						this.COUNTRYLIST.SB.ScrollTo(0,0);
						this.COUNTRYLIST.SB.dragging = true;
						this.COUNTRYID.text = Sys.mydata.country;
						this.COUNTRYID.visible = false;
						var cid:String = Sys.mydata.country;
						if(cid == "a1" || cid == "a2" || cid == "ap" || cid == "eu" || cid == "--") {
								cid = "--";
						}
						this.COUNTRYFLAG.Set(cid);
						if(cid == "--") {
								Util.SetText(this.COUNTRYNAME.FIELD,Lang.Get("unknown"));
						} else {
								Util.SetText(this.COUNTRYNAME.FIELD,Extdata.CountryName(Sys.mydata.country));
						}
						Util.SetText(this.C_FRIENDLY.FIELD,Lang.Get("allow_friendly_game_invite"));
						Util.SetText(this.C_AUTOLOGIN.FIELD,Lang.Get("autologin_title"));
						Util.SetText(this.C_NEWSLETTER.FIELD,Lang.Get("reg_subscribe_newsletter"));
						Imitation.AddEventClick(this.CB_FRIENDLY,this.OnFriendlyClick);
						Imitation.AddEventClick(this.CB_AUTOLOGIN,this.OnAutologinClick);
						Imitation.AddEventClick(this.CB_QPRGAME,this.OnQPRGameClick);
						Imitation.AddEventClick(this.CB_EFFECTS,this.OnEffectsClick);
						Imitation.AddEventClick(this.CB_MUSIC,this.OnMusicClick);
						Imitation.AddEventClick(this.CB_NEWSLETTER,this.OnNewsletterClick);
						this.UpdateCheckBoxes();
						Util.SetText(this.C_PASSCH.FIELD,Lang.Get("change_pass_title"));
						Util.SetText(this.C_OLDPASS.FIELD,Lang.Get("old_pass+:"));
						Util.SetText(this.C_NEWPASS.FIELD,Lang.Get("new_pass+:"));
						Util.SetText(this.C_RPASS.FIELD,Lang.Get("repeat_pass+:"));
						Util.SetText(this.C_EMAILCH.FIELD,Lang.Get("change_email_title"));
						Util.SetText(this.C_EMAIL.FIELD,Lang.Get("email+:"));
						Util.SetText(this.C_PASS.FIELD,Lang.Get("password+:"));
						Util.SetText(this.C_SAVE_PASS.FIELD,Lang.Get("save"));
						Util.SetText(this.C_SAVE_EMAIL.FIELD,Lang.Get("save"));
						Imitation.AddEventClick(this.BTN_SAVE_PASS,this.OnChangePassClick);
						Imitation.AddEventClick(this.BTN_SAVE_EMAIL,this.OnChangeEmailClick);
						this.BTN_SAVE_PASS.SetIcon("PIPE_WHITE");
						this.BTN_SAVE_EMAIL.SetIcon("PIPE_WHITE");
						Util.SetText(this.C_DELETEME.FIELD,Lang.Get("delete_me_title"));
						Util.SetText(this.C_DELETE_ME_PASS.FIELD,Lang.Get("password"));
						this.BTN_DELETE_ME.SetIcon("PIPE_WHITE");
						Imitation.AddEventClick(this.BTN_DELETE_ME,this.OnDeleteMeClick);
				}
				
				private function OnSaveCountry(e:Object) : void {
						if(this.COUNTRYLIST.visible) {
								this.COUNTRYLIST.visible = false;
						} else {
								this.COUNTRYLIST.visible = true;
						}
				}
				
				public function OnAutologinClick(e:*) : void {
						this.CB_AUTOLOGIN.CHECK.visible = !this.CB_AUTOLOGIN.CHECK.visible;
						var data:Object = Platform.LoadPersistentData("login");
						data.enable_autologin = this.CB_AUTOLOGIN.CHECK.visible;
						Platform.SavePersistentData("login",data);
						this.UpdateCheckBoxes();
				}
				
				public function OnFriendlyClick(e:*) : void {
						Sys.mydata.flags ^= Config.UF_NOFRIENDLY;
						this.UpdateCheckBoxes();
						Comm.SendCommand("SETDATA","FLAGS=\"" + Sys.mydata.flags + "\" SNDVOL=\"" + Sys.mydata.sndvol + "\"");
				}
				
				public function OnQPRGameClick(e:*) : void {
						Sys.mydata.flags ^= Config.UF_NOQPRGAME;
						this.UpdateCheckBoxes();
						Comm.SendCommand("SETDATA","FLAGS=\"" + Sys.mydata.flags + "\" SNDVOL=\"" + Sys.mydata.sndvol + "\"");
				}
				
				public function OnEffectsClick(e:*) : void {
						Sys.ToggleSound(255);
						this.UpdateCheckBoxes();
				}
				
				public function OnMusicClick(e:*) : void {
						Sys.ToggleSound(3840);
						this.UpdateCheckBoxes();
				}
				
				public function OnNewsletterClick(e:*) : void {
						this.CB_NEWSLETTER.CHECK.visible = !this.CB_NEWSLETTER.CHECK.visible;
						if(this.CB_NEWSLETTER.CHECK.visible) {
								this.userdata.newsletter = 1;
						} else {
								this.userdata.newsletter = 0;
						}
						var data:Object = {
								"cmd":"newsletter",
								"newsletter":this.userdata.newsletter,
								"clientver":Version.value
						};
						JsQuery.Load(this.OnNewsletterResult,[],"client_newsletter.php?stoc=" + Config.stoc + "&rand=" + new Date().getTime(),data);
						this.UpdateCheckBoxes();
				}
				
				private function OnNewsletterResult(_jsq:Object) : void {
						trace("OnNewsletterResult");
						this.ObjectTrace(_jsq);
						this.UpdateCheckBoxes();
						if(!_jsq.error) {
						}
				}
				
				public function ObjectTrace(_obj:Object, sPrefix:String = "") : void {
						var i:* = undefined;
						if(sPrefix == "") {
								sPrefix = "-->";
						} else {
								sPrefix += " -->";
						}
						for(i in _obj) {
								trace(sPrefix,i + ":" + _obj[i]," ");
								if(typeof _obj[i] == "object") {
										this.ObjectTrace(_obj[i],sPrefix);
								}
						}
				}
				
				public function OnDeleteMeClick(e:*) : void {
						var MessageWin:* = Modules.GetClass("uibase","uibase.MessageWin");
						this.HideWin();
						MessageWin.AskYesNo(Lang.get("delete_me_title"),Lang.get("ask_delete_me"),Lang.get("yes"),Lang.get("no"),function(a:*):* {
								RestoreWin();
								if(a == 1) {
										JsQuery.Load(Profile2.ShowResult,["delete_me_title","me_deleted"],"stal_data.php?" + Sys.FormatGetParamsStoc(null),{
												"cmd":"deleteme",
												"pass":DELETE_ME_PASS.FIELD.text
										});
								}
								Start();
						});
				}
				
				public function OnChangePassClick(e:*) : void {
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
						JsQuery.Load(Profile2.ShowResult,["change_pass_title","pass_changed"],"stal_data.php?" + Sys.FormatGetParamsStoc(null),{
								"cmd":"changepass",
								"oldpass":this.OLDPASS.FIELD.text,
								"newpass":this.NEWPASS.FIELD.text
						});
						this.Start();
				}
				
				public function OnChangeEmailClick(e:*) : void {
						JsQuery.Load(Profile2.ShowResult,["change_email_title","email_changed"],"stal_data.php?" + Sys.FormatGetParamsStoc(null),{
								"cmd":"changemail",
								"email":this.EMAIL.FIELD.text,
								"pass":this.PASS.FIELD.text
						});
						this.Start();
				}
				
				public function HideWin(e:* = null) : void {
						Profile2.mc.visible = false;
				}
				
				public function RestoreWin(e:* = null) : void {
						Profile2.mc.visible = true;
				}
				
				public function EraseInputs() : void {
						this.OLDPASS.FIELD.text = "";
						this.NEWPASS.FIELD.text = "";
						this.RPASS.FIELD.text = "";
						this.EMAIL.FIELD.text = "";
						this.PASS.FIELD.text = "";
						this.DELETE_ME_PASS.FIELD.text = "";
				}
				
				public function UpdateCheckBoxes() : void {
						var ea:Boolean = false;
						var data:Object = null;
						trace("SettingsPage.UpdateCheckBoxes: " + this.userdata.newsletter);
						this.CB_QPRGAME.CHECK.visible = (Sys.mydata.flags & Config.UF_NOQPRGAME) == 0;
						this.CB_FRIENDLY.CHECK.visible = (Sys.mydata.flags & Config.UF_NOFRIENDLY) == 0;
						this.CB_EFFECTS.CHECK.visible = (Sys.mydata.sndvol & 0xFF) != 0;
						this.CB_MUSIC.CHECK.visible = (Sys.mydata.sndvol & 0x0F00) != 0;
						if(this.userdata.newsletter == 1) {
								this.CB_NEWSLETTER.CHECK.visible = true;
						} else {
								this.CB_NEWSLETTER.CHECK.visible = false;
						}
						if(Config.android || Config.ios) {
								this.C_AUTOLOGIN.visible = true;
								this.CB_AUTOLOGIN.visible = true;
								ea = true;
								data = Platform.LoadPersistentData("login");
								if(data.enable_autologin != null) {
										ea = Boolean(data.enable_autologin);
								}
								this.CB_AUTOLOGIN.CHECK.visible = ea;
						} else {
								this.C_AUTOLOGIN.visible = false;
								this.CB_AUTOLOGIN.visible = false;
						}
				}
				
				public function OnCountryListClick(_item:MovieClip, _id:int) : void {
						this.OnSaveCountry({});
						Comm.SendCommand("SETDATA","COUNTRY=\"" + MovieClip(parent).countryList[_id].id + "\" SNDVOL=\"" + Sys.mydata.sndvol + "\"");
				}
				
				public function DrawCountryLine(_item:MovieClip, _id:int) : void {
						if(_id >= MovieClip(parent).countryList.length) {
								return;
						}
						_item.COUNTRYFLAG.Set(MovieClip(parent).countryList[_id].id);
						Util.SetText(_item.CNAME.FIELD,MovieClip(parent).countryList[_id].name);
				}
				
				public function Destroy() : void {
						trace("SettingsPage.Destroy");
						Imitation.RemoveEvents(this.BTN_SAVE_COUNTRY);
						Imitation.RemoveEvents(this.CB_FRIENDLY);
						Imitation.RemoveEvents(this.CB_AUTOLOGIN);
						Imitation.RemoveEvents(this.CB_QPRGAME);
						Imitation.RemoveEvents(this.CB_EFFECTS);
						Imitation.RemoveEvents(this.CB_MUSIC);
						Imitation.RemoveEvents(this.CB_NEWSLETTER);
						Imitation.RemoveEvents(this.BTN_SAVE_PASS);
						Imitation.RemoveEvents(this.BTN_SAVE_EMAIL);
						Imitation.RemoveEvents(this.BTN_DELETE_ME);
				}
		}
}

