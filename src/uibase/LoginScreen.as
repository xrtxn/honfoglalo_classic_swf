package uibase
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol745")]
	public class LoginScreen extends MovieClip
	{
		public static var mc:LoginScreen = null;

		public static var guiddata:Object = null;

		public static var logindata:Object = null;

		public static var isautologin:Boolean = true;

		public static var autologintype:String = "";

		public static var isdatawaiting:Boolean = true;

		public var FRAME:MovieClip;

		public var GAMELOGO:MovieClip;

		public var PANEL_CONN_ERROR:MovieClip;

		public var PANEL_FB:MovieClip;

		public var PANEL_INPUT:MovieClip;

		public var PANEL_LOGIN_ERROR:MovieClip;

		private var pagename:String = "";

		private var inputenabled:Boolean = true;

		private var checkPrivacy:Boolean = false;

		private var checkTos:Boolean = false;

		public function LoginScreen()
		{
			super();
		}

		private static function OnGuidResult(_jsq:Object):void
		{
			trace("OnGuidResult");
			var data:Object = null;
			trace("OnGuidResult", LoginScreen.mc);
			if (!LoginScreen.mc)
			{
				return;
			}
			if (_jsq.error)
			{
				LoginScreen.ShowMessageWin(Lang.Get("login"), _jsq.errormsg, LoginScreen.mc.SetInputsEnable);
				return;
			}
			if (_jsq.data.pass !== undefined)
			{
				data = LoginScreen.guiddata = {
						"guid": Util.StringVal(_jsq.data.guid),
						"pass": Util.StringVal(_jsq.data.pass)
					};
				Platform.SavePersistentData("guid", data);
				LoginScreen.mc.OnGuestLogin();
			}
			else
			{
				LoginScreen.OnLoginResult(_jsq);
			}
		}

		private static function OnReminderResult(_jsq:Object, key:String):void
		{
			var message:String;
			var param:String = null;
			if (!LoginScreen.mc)
			{
				return;
			}
			message = Util.StringVal(_jsq.errormsg);
			param = "PANEL_LOGIN_ERROR";
			if (Util.NumberVal(_jsq.error) == 3)
			{
				message = key == "pass" ? Lang.Get("password_reset_link_sent") : Lang.Get("password_reset_link_sent");
				param = "PANEL_INPUT";
			}
			LoginScreen.ShowMessageWin(Lang.Get("reminder"), message, function():*
				{
					LoginScreen.mc.Draw(param);
				});
		}

		private static function OnLoginResult(_jsq:Object):void
		{
			trace("OnLoginResult");
			var title:String = null;
			var image_url:String = null;
			var button_url:String = null;
			var button_text:String = null;
			var close_button:Boolean = false;
			var close_countdown:Number = NaN;
			var mw:Object = null;
			var serveraddress:String = null;
			var httpport:int = 0;
			var xsocketaddress:String = null;
			var xsocketport:int = 0;
			var advert:String = null;
			var publisher_id:String = null;
			var ad_unit_id:String = null;
			trace("OnLoginResult", LoginScreen.mc);
			if (!LoginScreen.mc)
			{
				return;
			}
			if (Boolean(_jsq.error) && _jsq.error > 0)
			{
				DBG.Trace("OnLoginResult _jsq", _jsq);
				if (_jsq.error < 600)
				{
					LoginScreen.ShowMessageWin(Lang.Get("login"), _jsq.errormsg, LoginScreen.mc.Draw);
				}
				else if (LoginScreen.isautologin)
				{
					LoginScreen.mc.Draw("PANEL_CONN_ERROR");
				}
				else
				{
					LoginScreen.ShowMessageWin(Lang.Get("login"), Lang.Get("server_connect_error") + "\n#" + _jsq.error, LoginScreen.mc.Draw);
				}
				return;
			}
			var d:Object = _jsq.data;
			var msgdata:Object = {};
			var data:Object = {
					"email": Config.loginemail,
					"password": Config.loginpassword,
					"autologin": Config.loginsystem
				};
			DBG.Trace("OnLoginResult", d);
			Platform.SavePersistentData("login", data);
			if (Boolean(d.warning) && Boolean(d.warning.message))
			{
				msgdata = d.warning;
				msgdata.type = 2;
			}
			if (Boolean(d.error) && Boolean(d.error.message))
			{
				msgdata = d.error;
				msgdata.type = 1;
			}
			var message:String = Util.StringVal(msgdata.message);
			if (message != "")
			{
				title = Util.StringVal(msgdata.title);
				image_url = Util.StringVal(msgdata.image_url);
				button_url = Util.StringVal(msgdata.button_url);
				button_text = Util.StringVal(msgdata.button_text);
				close_button = !!Util.NumberVal(msgdata.close_button) ? true : false;
				close_countdown = Util.NumberVal(msgdata.close_countdown);
				mw = Modules.GetClass("uibase", "uibase.LoginMessageWin");
				TweenMax.delayedCall(1, mw.Show, [title, message, image_url, button_text, button_url, close_button, null, [], msgdata.type, close_countdown]);
			}
			Config.loginuserid = d.userid;
			Config.loginusername = d.username;
			Config.userfirstname = d.username;
			Config.userlastname = Util.StringVal(d.userlastname);
			Config.useremail = Util.StringVal(d.useremail);
			Config.loginguid = d.guid;
			Config.loginsign = d.sign;
			Config.logintime = d.time;
			Config.stoc = d.stoc;
			Config.currency = Util.StringVal(d.currency);
			Config.loginextid = Util.StringVal(d.extid);
			if (typeof d.server == "object" && d.server is Object)
			{
				serveraddress = Util.StringVal(d.server.serveraddress);
				httpport = Util.NumberVal(d.server.httpport);
				xsocketaddress = Util.StringVal(d.server.xsocketaddress);
				xsocketport = Util.NumberVal(d.server.xsocketport);
				if (serveraddress.length > 0)
				{
					Config.serveraddress = serveraddress;
				}
				if (httpport > 0)
				{
					Config.httpport = httpport;
				}
				if (xsocketaddress.length > 0)
				{
					Config.xsocketaddress = xsocketaddress;
				}
				else
				{
					Config.xsocketaddress = Config.serveraddress;
				}
				if (xsocketport > 0)
				{
					Config.xsocketport = xsocketport;
				}
			}
			if (typeof d.sysconf == "object" && d.sysconf is Object)
			{
				Config.ProcessClientSysConfig(d.sysconf);
			}
			if (typeof d.advert == "object" && d.advert is Object)
			{
				advert = Util.StringVal(d.advert.advert);
				if (advert == "AdMob")
				{
					publisher_id = Util.StringVal(d.advert.publisher_id);
					ad_unit_id = Util.StringVal(d.advert.ad_unit_id);
					if (publisher_id.length > 0 && ad_unit_id.length > 0)
					{
						Platform.InitInterstitial(publisher_id, ad_unit_id);
					}
				}
			}
			Friends.LoadExternalFriendsAPP(d);
			Comm.Connect();
		}

		private static function ProcessPersistentData():void
		{
			var p:Object = Platform.LoadPersistentData("login");
			LoginScreen.logindata = p;
			if (p)
			{
				if (p.hasOwnProperty("enable_autologin"))
				{
					LoginScreen.isautologin = p.enable_autologin;
				}
				LoginScreen.autologintype = Util.StringVal(p["autologin"]);
				Config.loginemail = Util.StringVal(p["email"]);
				Config.loginpassword = Util.StringVal(p["password"]);
			}
			LoginScreen.guiddata = Platform.LoadPersistentData("guid");
		}

		private static function OnCheckConnection(e:Object = null):void
		{
			JsQuery.Load(LoginScreen.OnPingResult, [], "mobil.php", {"cmd": "ping"});
		}

		private static function OnPingResult(_jsq:Object):void
		{
			if (!LoginScreen.mc)
			{
				return;
			}
			DBG.Trace("OnPingResult _jsq:" + _jsq);
			if (_jsq.error && Util.NumberVal(_jsq.error) >= 600 && Boolean(LoginScreen.isautologin))
			{
				LoginScreen.mc.Draw("PANEL_CONN_ERROR");
			}
			else if (Boolean(_jsq.error) && Util.NumberVal(_jsq.error) > 0)
			{
				LoginScreen.ShowMessageWin(Lang.Get("login"), Lang.Get("server_connect_error") + "\n#" + _jsq.error, LoginScreen.mc.Draw);
			}
			else if (Util.StringVal(_jsq.errormsg) == "pong")
			{
				LoginScreen.mc.Draw("PANEL_INPUT");
			}
		}

		private static function GetSystem():String
		{
			if (Config.android)
			{
				return "ANDR";
			}
			if (Config.ios)
			{
				return "IOS";
			}
			return "PC";
		}

		private static function ShowMessageWin(title:String, message:String, callback:Function = null, countdown:int = 0):void
		{
			if (LoginScreen.mc)
			{
				LoginScreen.mc.CheckChecks();
			}
			var mw:Object = Modules.GetClass("uibase", "uibase.MessageWin");
			mw.Show(title, message, callback, 1, countdown);
		}

		public static function Hide():void
		{
			WinMgr.HideBaseHandler(LoginScreen);
		}

		public function Prepare(_params:Object):void
		{
			trace("LoginScreen.Prepare");
			this.pagename = "";
			this.inputenabled = true;
			guiddata = null;
			logindata = null;
			isautologin = true;
			autologintype = "";
			isdatawaiting = true;
			Sys.codegame = false;
			Util.StopAllChildrenMov(this);
			_params.waitfordata = true;
			trace("prepare desktop?: " + Config.desktop);
			this.PANEL_INPUT.gotoAndStop(Config.desktop ? "DESKTOP" : "MOBILE");
			this.PANEL_INPUT.visible = false;
			this.PANEL_CONN_ERROR.visible = false;
			this.PANEL_LOGIN_ERROR.visible = false;
			this.PANEL_FB.visible = false;
			this.visible = false;
			this.PrepareGameLogo(Config.siteid);
			LoginScreen.ProcessPersistentData();
			if (this.PANEL_INPUT.CODE_INP)
			{
				this.PANEL_INPUT.CODE_INP.FIELD.restrict = "0-9";
			}
			if (Boolean(LoginScreen.isautologin) && LoginScreen.autologintype == "MAIL")
			{
				Util.SetText(this.PANEL_INPUT.INPUT_LOGINEMAIL.FIELD, Config.loginemail);
				Util.SetText(this.PANEL_INPUT.INPUT_LOGINPASSWORD.FIELD, Config.loginpassword);
				this.OnEmailLogin(null);
			}
			else if (Boolean(LoginScreen.isautologin) && LoginScreen.autologintype == "FACE")
			{
				this.OnFacebookLogin(null);
			}
			else
			{
				LoginScreen.OnCheckConnection();
			}
		}

		public function PrepareGameLogo(siteid:String):void
		{
			if (Boolean(siteid) && "|ar|bg|br|de|es|pl|ro|ru|si|tr|us|xa|xs|cz|hu|".indexOf(siteid) >= 0)
			{
				this.GAMELOGO.gotoAndStop(siteid);
			}
			else
			{
				this.GAMELOGO.gotoAndStop("xe");
			}
			Imitation.FreeBitmapAll(this.GAMELOGO);
		}

		public function AfterClose():void
		{
			this.SetInputsEnable(false);
			Imitation.RemoveEvents(this.PANEL_INPUT.TERM);
			if (!Config.desktop)
			{
				Imitation.RemoveEvents(this.PANEL_INPUT.BTN_FACEBOOK);
				Imitation.RemoveEvents(this.PANEL_LOGIN_ERROR.BTN_FACEBOOK);
			}
			Imitation.RemoveEvents(this.PANEL_INPUT.TXT_PROBLEM);
			Aligner.UnSetAutoAlign(this);
		}

		public function SetInputsEnable(_enable:Boolean = true):void
		{
			var w:MovieClip = null;
			if (this.pagename == "PANEL_INPUT")
			{
				w = this.PANEL_INPUT;
				if (!Config.desktop)
				{
					w.BTN_GUEST.SetEnabled(!_enable ? _enable : Util.StringVal(Config.loginpassword) == "");
					w.BTN_CODE.SetEnabled(_enable);
					w.BTN_FACEBOOK.alpha = _enable ? 1 : 0.5;
				}
				w.BTN_LOGIN.SetEnabled(_enable);
				Imitation.EnableInput(w.INPUT_LOGINEMAIL.FIELD, _enable);
				Imitation.EnableInput(w.INPUT_LOGINPASSWORD.FIELD, _enable);
			}
			else if (this.pagename == "PANEL_LOGIN_ERROR")
			{
				w = this.PANEL_LOGIN_ERROR;
				w.BTN_PASS.SetEnabled(_enable);
				w.BTN_INFOS.SetEnabled(_enable);
				Imitation.EnableInput(w.INPUT_PASS.FIELD, _enable);
				Imitation.EnableInput(w.INPUT_INFOS.FIELD, _enable);
				if (!Config.desktop)
				{
					w.BTN_FACEBOOK.alpha = _enable ? 1 : 0.5;
				}
			}
			else if (this.pagename == "PANEL_CONN_ERROR")
			{
				w = this.PANEL_CONN_ERROR;
				w.BTN_EXIT.SetEnabled(_enable);
				w.BTN_RETRY.SetEnabled(_enable);
			}
			this.inputenabled = _enable;
			this.CheckChecks();
		}

		public function Draw(_currentpagename:String = "PANEL_INPUT"):void
		{
			this.visible = true;
			this.SetInputsEnable(false);
			this.pagename = _currentpagename;
			this.PANEL_INPUT.visible = false;
			this.PANEL_CONN_ERROR.visible = false;
			this.PANEL_LOGIN_ERROR.visible = false;
			this.PANEL_FB.visible = false;
			if (_currentpagename == "PANEL_CONN_ERROR")
			{
				this.DrawConnError();
			}
			else if (_currentpagename == "PANEL_LOGIN_ERROR")
			{
				this.DrawLoginError();
			}
			else if (_currentpagename == "PANEL_FB")
			{
				this.DrawPanelFB();
			}
			else
			{
				this.DrawInput();
			}
			Aligner.SetAutoAlign(this);
			if (LoginScreen.isdatawaiting)
			{
				WinMgr.WindowDataArrived(this);
			}
			LoginScreen.isdatawaiting = false;
		}

		private function DrawConnError():void
		{
			var w:MovieClip = this.PANEL_CONN_ERROR;
			Util.SetText(w.TXT_CONN_SHORT.FIELD, Lang.Get("conn_desc_short"));
			Util.SetText(w.TXT_CONN_LONG.FIELD, Lang.Get("conn_desc_long"));
			w.BTN_RETRY.SetLang("retry");
			w.BTN_RETRY.AddEventClick(function(e:Object):*
				{
					SetInputsEnable(false);
					LoginScreen.OnCheckConnection();
				});
			w.BTN_EXIT.SetIcon("X");
			w.BTN_EXIT.AddEventClick(function(e:Object):*
				{
					Draw("PANEL_INPUT");
				});
			this.SetInputsEnable(true);
			w.visible = true;
		}

		private function DrawLoginError():void
		{
			var w:MovieClip = this.PANEL_LOGIN_ERROR;
			Util.SetText(w.TXT_PASS.FIELD, Lang.Get("send_me_password"));
			Util.SetText(w.TXT_INFOS.FIELD, Lang.Get("send_me_info"));
			if (Config.desktop)
			{
				w.BTN_FACEBOOK.visible = false;
				w.TXT_FB.FIELD.visible = false;
			}
			else
			{
				Util.SetText(w.TXT_FB.FIELD, Lang.Get("fb_login_desc"));
				Imitation.AddEventClick(w.BTN_FACEBOOK, this.OnFacebookLogin);
			}
			Util.SetText(w.TXT_PROBLEM.FIELD, Lang.Get("problem_with_login_long"));
			w.BTN_PASS.SetLang("send");
			w.BTN_PASS.AddEventClick(this.OnPasswordReminder, {"key": "pass"});
			w.BTN_INFOS.SetLang("send");
			w.BTN_INFOS.AddEventClick(this.OnPasswordReminder, {"key": "infos"});
			w.BTN_EXIT.SetIcon("X");
			w.BTN_EXIT.AddEventClick(function(e:Object):*
				{
					Draw("PANEL_INPUT");
				});
			this.SetInputsEnable(true);
			w.visible = true;
		}

		private function DrawInput():void
		{
			var w:MovieClip = this.PANEL_INPUT;
			w.NPC.Set("KING");
			if (!Config.desktop)
			{
				Util.SetText(w.TXT_GUEST.FIELD, Lang.Get("login_win_new_player"));
				if (w.TXT_GUEST.FIELD.numLines == 1)
				{
					w.TXT_GUEST.FIELD.y = 65;
				}
				if (w.TXT_GUEST.FIELD.numLines == 2)
				{
					w.TXT_GUEST.FIELD.y = 47;
				}
				if (w.TXT_GUEST.FIELD.numLines == 3)
				{
					w.TXT_GUEST.FIELD.y = 28;
				}
				if (w.TXT_GUEST.FIELD.numLines >= 4)
				{
					w.TXT_GUEST.FIELD.y = 0;
				}
			}
			Util.SetText(w.TXT_REGISTER.FIELD, Lang.Get("login_win_welcome_txt"));
			Util.SetText(w.TXT_LOGIN.FIELD, Lang.Get("login"));
			Util.SetText(w.TXT_PROBLEM.FIELD, Lang.Get("problem_with_login"));
			if (!Config.desktop)
			{
				w.BTN_GUEST.SetIcon("PLAY");
				w.BTN_GUEST.AddEventClick(this.OnGuestLogin);
				w.BTN_GUEST.SetEnabled(Util.StringVal(Config.loginpassword) == "");
				Util.SetText(w.TXT_CODE.FIELD, Lang.Get("friendly_game_code_login"));
				w.BTN_CODE.SetIcon("PLAY");
				w.BTN_CODE.AddEventClick(this.OnCodeLogin);
			}
			w.BTN_LOGIN.SetIcon("PLAY");
			w.BTN_LOGIN.AddEventClick(this.OnEmailLogin);
			w.INPUT_LOGINEMAIL.visible = true;
			w.INPUT_LOGINPASSWORD.visible = true;
			w.INPUT_LOGINEMAIL.FIELD.text = "";
			w.INPUT_LOGINPASSWORD.FIELD.text = "";
			w.INPUT_LOGINPASSWORD.FIELD.displayAsPassword = true;
			w.INPUT_LOGINEMAIL.visible = true;
			w.INPUT_LOGINPASSWORD.visible = true;
			Util.SetText(w.INPUT_LOGINEMAIL.FIELD, Config.loginemail);
			Util.SetText(w.INPUT_LOGINPASSWORD.FIELD, Config.loginpassword);
			if (!Config.desktop)
			{
				Util.SetText(this.PANEL_INPUT.TXT_TERMS.FIELD, Lang.Get("reg_accept_privacy_2"));
				Imitation.AddEventClick(this.PANEL_INPUT.TXT_TERMS, function(e:Object):void
					{
						if (Config.siteid == "hu")
						{
							navigateToURL(new URLRequest("https://thxgames.zendesk.com/hc/hu/articles/209388109-Adatkezel%C3%A9si-Szab%C3%A1lyzat-HEK"), "_blank");
						}
						else if (Config.siteid == "cz")
						{
							navigateToURL(new URLRequest("https://thxgames.zendesk.com/hc/cs/articles/209388109-Z%C3%A1sady-ochrany-osobn%C3%ADch-%C3%BAdaj%C5%AF-ToS"), "_blank");
						}
						else
						{
							navigateToURL(new URLRequest("https://thxgames.zendesk.com/hc/en-us/articles/209388109"), "_blank");
						}
					});
				Util.SetText(this.PANEL_INPUT.TXT_TOS.FIELD, Lang.Get("reg_accept_tos_2"));
				Imitation.AddEventClick(this.PANEL_INPUT.TXT_TOS, function(e:Object):void
					{
						if (Config.siteid == "hu")
						{
							navigateToURL(new URLRequest("https://thxgames.zendesk.com/hc/hu/articles/209385509-Honfoglal%C3%B3-Etikai-K%C3%B3dex-HEK-"), "_blank");
						}
						else if (Config.siteid == "cz")
						{
							navigateToURL(new URLRequest("https://thxgames.zendesk.com/hc/cs/articles/210102485-Smluvn%C3%AD-podm%C3%ADnky"), "_blank");
						}
						else
						{
							navigateToURL(new URLRequest("https://thxgames.zendesk.com/hc/en-us/articles/210102485"), "_blank");
						}
					});
				trace(this.checkPrivacy, this.checkTos);
				this.PANEL_INPUT.CHECK_1.CHECK.visible = false;
				this.PANEL_INPUT.CHECK_2.CHECK.visible = false;
				Imitation.AddEventClick(this.PANEL_INPUT.CHECK_1, this.OnChecks);
				Imitation.AddEventClick(this.PANEL_INPUT.CHECK_2, this.OnChecks);
				if (!Config.desktop)
				{
					Imitation.AddEventClick(w.BTN_FACEBOOK, this.OnFacebookLogin);
				}
			}
			Imitation.AddEventClick(w.TXT_PROBLEM, function(e:Object):*
				{
					Draw("PANEL_LOGIN_ERROR");
				});
			this.SetInputsEnable(true);
			w.visible = true;
		}

		private function OnChecks(e:Object):void
		{
			e.target.CHECK.visible = !e.target.CHECK.visible;
			this.CheckChecks();
		}

		public function CheckChecks():void
		{
			if (Config.desktop)
			{
				return;
			}
			this.checkPrivacy = this.PANEL_INPUT.CHECK_1.CHECK.visible;
			this.checkTos = this.PANEL_INPUT.CHECK_2.CHECK.visible;
			if (this.checkPrivacy && this.checkTos)
			{
				this.PANEL_INPUT.BTN_GUEST.SetEnabled(true);
			}
			else
			{
				this.PANEL_INPUT.BTN_GUEST.SetEnabled(false);
			}
		}

		private function OnPasswordReminder(e:Object):void
		{
			var data:Object = null;
			var w:MovieClip = this.PANEL_LOGIN_ERROR;
			var logtxt:String = e.params.key == "pass" ? String(w.INPUT_PASS.FIELD.text) : String(w.INPUT_INFOS.FIELD.text);
			if (logtxt.length > 0)
			{
				this.SetInputsEnable(false);
				data = {
						"cmd": "reminder2",
						"loginname": logtxt
					};
				JsQuery.Load(LoginScreen.OnReminderResult, [e.params.key], "mobil.php", data);
			}
		}

		public function OnCodeLogin(e:Object = null):void
		{
			trace("OnCodeLogin");
			var data:Object = null;
			this.SetInputsEnable(false);
			Config.loginsystem = "GUID";
			var p:Object = LoginScreen.guiddata;
			if (!p)
			{
				data = {"cmd": "register_guid"};
			}
			else
			{
				data = {
						"cmd": "login_guid",
						"guid": Util.StringVal(p.guid),
						"password": Util.StringVal(p.pass)
					};
			}
			Sys.codegamecode = String(this.PANEL_INPUT.CODE_INP.FIELD.text);
			Sys.codegame = true;
			Sys.codereg = true;
			JsQuery.Load(LoginScreen.OnGuidResult, [], "mobil.php", data);
		}

		public function OnGuestLogin(e:Object = null):void
		{
			trace("OnGuestLogin");
			var data:Object = null;
			this.SetInputsEnable(false);
			Config.loginsystem = "GUID";
			var p:Object = LoginScreen.guiddata;
			if (!p)
			{
				data = {"cmd": "register_guid"};
			}
			else
			{
				data = {
						"cmd": "login_guid",
						"guid": Util.StringVal(p.guid),
						"password": Util.StringVal(p.pass)
					};
			}
			JsQuery.Load(LoginScreen.OnGuidResult, [], "mobil.php", data);
		}

		private function OnFacebookLogin(e:Object = null):void
		{
			var currentDate:Date;
			var fbDate:Date;
			var OnFacebookLoginResult:Function;
			trace("OnFacebookLogin");
			if (Config.desktop)
			{
				return;
			}
			currentDate = new Date();
			fbDate = new Date(2019, 4 - 1, 18);
			trace(currentDate.getTime(), fbDate.getTime());
			if (currentDate.getTime() > fbDate.getTime())
			{
				this.Draw("PANEL_FB");
				return;
			}
			OnFacebookLoginResult = function(_session:Object):void
			{
				var data:Object = null;
				trace("OnFacebookLoginResult", _session);
				if (_session)
				{
					if (!Semu.enabled)
					{
						Config.flashvars.fb_access_token = Util.StringVal(_session.accessToken);
					}
					data = {
							"cmd": "fblogin",
							"extid": _session.uid,
							"access_token": _session.accessToken,
							"clientver": Version.value,
							"system": LoginScreen.GetSystem()
						};
					JsQuery.Load(LoginScreen.OnLoginResult, [], "mobil.php", data);
				}
				else
				{
					LoginScreen.mc.Draw("PANEL_INPUT");
				}
			};
			if (this.inputenabled)
			{
				this.SetInputsEnable(false);
				Config.loginsystem = "FACE";
				Platform.FacebookLogin(OnFacebookLoginResult);
			}
		}

		private function DrawPanelFB():*
		{
			this.PANEL_FB.visible = true;
			var p:MovieClip = this.PANEL_FB;
			p.BTN_LOGIN.AddEventClick(this.PanelFB_Back);
			p.BTN_LOGIN.SetLang("login");
			p.BTN_REG.AddEventClick(this.PanelFB_Reg);
			p.BTN_REG.SetLang("fb_convert_greenbutton");
			p.TITLE.htmlText = Lang.Get("fblogin_title");
			p.TEXT_MAIL.htmlText = Lang.Get("fblogin_text_mail");
			p.TEXT_REG.htmlText = Lang.Get("fblogin_text_reg");
		}

		private function PanelFB_Reg(e:*):*
		{
			navigateToURL(new URLRequest(Lang.Get("fblogin_link")), "_blank");
		}

		private function PanelFB_Back(e:*):*
		{
			this.Draw("PANEL_INPUT");
		}

		private function OnEmailLogin(e:Object):void
		{
			trace("OnEmailLogin");
			this.SetInputsEnable(false);
			var w:MovieClip = this.PANEL_INPUT;
			if (this.PANEL_FB.visible)
			{
				w = this.PANEL_FB;
			}
			Config.loginsystem = "MAIL";
			Config.loginemail = w.INPUT_LOGINEMAIL.FIELD.text;
			Config.loginpassword = w.INPUT_LOGINPASSWORD.FIELD.text;
			var data:Object = {
					"cmd": "login",
					"loginname": Config.loginemail,
					"password": Config.loginpassword,
					"clientver": Version.value,
					"system": LoginScreen.GetSystem()
				};
			DBG.Trace("mobil.php", data);
			JsQuery.Load(LoginScreen.OnLoginResult, [], "mobil.php", data);
		}
	}
}
