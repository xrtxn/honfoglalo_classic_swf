package uibase
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import syscode.*;
	import uibase.components.UICharacterComponent;
	import uibase.components.UIButtonComponent;
	import uibase.components.UIWindowFrame;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol401")]
	public class LogoutWindow extends MovieClip
	{
		public static var mc:LogoutWindow = null;

		public var BTNX:UIButtonComponent;

		public var BTN_LOGOUT:UIButtonComponent;

		public var BTN_QUIT:UIButtonComponent;

		public var FRAME:UIWindowFrame;

		public var TXT_LOGOUT:TextField;

		public var TXT_QUIT:TextField;

		public var __id1_:UICharacterComponent;

		public var __id2_:UICharacterComponent;

		private var logout:Boolean = false;

		public function LogoutWindow()
		{
			super();
			this.__setProp___id1__LogoutWindow_characters_0();
			this.__setProp___id2__LogoutWindow_characters_0();
			this.__setProp_BTN_QUIT_LogoutWindow_buttons_0();
			this.__setProp_BTN_LOGOUT_LogoutWindow_buttons_0();
			this.__setProp_BTNX_LogoutWindow_buttons_0();
		}

		public function Prepare(aprops:Object):void
		{
			Util.StopAllChildrenMov(this);
			this.BTNX.SetCaption("X");
			this.BTNX.AddEventClick(this.OnCloseClick);
			Lang.Set(this.TXT_QUIT, "are_you_sure_quit_the_game");
			this.BTN_QUIT.SetLangAndClick("quit", this.OnQuitClick);
			Lang.Set(this.TXT_LOGOUT, "do_you_want_to_logout");
			this.BTN_LOGOUT.SetLangAndClick("logout", this.OnLogoutClick);
			aprops.canclose = false;
			Aligner.SetAutoAlign(this);
		}

		public function AfterClose():void
		{
			Aligner.UnSetAutoAlign(this);
			if (this.logout)
			{
			}
		}

		private function OnCloseClick(jsq:Object):void
		{
			WinMgr.CloseWindow(this);
		}

		private function OnQuitClick(jsq:Object):void
		{
			Platform.ExitApplication();
		}

		private function OnLogoutClick(jsq:Object):void
		{
			Config.loginuserid = "";
			Config.loginusername = "";
			Config.userfirstname = "";
			Config.userlastname = "";
			Config.useremail = "";
			Config.loginguid = "";
			Config.loginsign = "";
			Config.logintime = "";
			Config.stoc = "";
			Config.currency = "";
			this.logout = true;
			var data:Object = Platform.LoadPersistentData("login");
			data.autologin = false;
			Platform.SavePersistentData("login", data);
			WinMgr.CloseWindow(this);
		}

		internal function __setProp___id1__LogoutWindow_characters_0():*
		{
			try
			{
				this.__id1_["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.__id1_.character = "PET_MERCHANT";
			this.__id1_.enabled = true;
			this.__id1_.frame = 2;
			this.__id1_.shade = true;
			this.__id1_.shadow = false;
			this.__id1_.visible = true;
			try
			{
				this.__id1_["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}

		internal function __setProp___id2__LogoutWindow_characters_0():*
		{
			try
			{
				this.__id2_["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.__id2_.character = "GENERAL";
			this.__id2_.enabled = true;
			this.__id2_.frame = 2;
			this.__id2_.shade = true;
			this.__id2_.shadow = false;
			this.__id2_.visible = true;
			try
			{
				this.__id2_["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}

		internal function __setProp_BTN_QUIT_LogoutWindow_buttons_0():*
		{
			try
			{
				this.BTN_QUIT["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.BTN_QUIT.enabled = true;
			this.BTN_QUIT.fontsize = "BIG";
			this.BTN_QUIT.icon = "";
			this.BTN_QUIT.skin = "OK";
			this.BTN_QUIT.testcaption = "Quit";
			this.BTN_QUIT.visible = true;
			this.BTN_QUIT.wordwrap = false;
			try
			{
				this.BTN_QUIT["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}

		internal function __setProp_BTN_LOGOUT_LogoutWindow_buttons_0():*
		{
			try
			{
				this.BTN_LOGOUT["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.BTN_LOGOUT.enabled = true;
			this.BTN_LOGOUT.fontsize = "BIG";
			this.BTN_LOGOUT.icon = "";
			this.BTN_LOGOUT.skin = "NORMAL";
			this.BTN_LOGOUT.testcaption = "Logout";
			this.BTN_LOGOUT.visible = true;
			this.BTN_LOGOUT.wordwrap = false;
			try
			{
				this.BTN_LOGOUT["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}

		internal function __setProp_BTNX_LogoutWindow_buttons_0():*
		{
			try
			{
				this.BTNX["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.BTNX.enabled = true;
			this.BTNX.fontsize = "BIG";
			this.BTNX.icon = "";
			this.BTNX.skin = "CANCEL";
			this.BTNX.testcaption = "X";
			this.BTNX.visible = true;
			this.BTNX.wordwrap = false;
			try
			{
				this.BTNX["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}
	}
}
