package syscode.platform
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;

	public class Desktop extends MovieClip
	{
		private var facebook_sso_callback:Function = null;

		private var fb_task_progress:Boolean = false;

		public function Desktop()
		{
			super();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, this.OnKeyDown, false, 0, true);
			stage.addEventListener(Event.ACTIVATE, this.OnActivate, false, 0, true);
			stage.addEventListener(Event.DEACTIVATE, this.OnDeactivate, false, 0, true);
			stage.addEventListener("EXITAPPLICATION", this.OnExitApplication);
			trace("Browser.Browser");
		}

		public function CheckBillingSupport():void
		{
			trace("CheckBillingSupport - Not applicable for browser");
		}

		public function QueryBillingItems(param1:Boolean, param2:Function):void
		{
			trace("QueryBillingItems - Not applicable for browser");
		}

		public function MakePlayPurchase(param1:String, param2:String, param3:Function):void
		{
			trace("MakePlayPurchase - Not applicable for browser");
		}

		public function QueryPlayInventory(param1:Function):void
		{
			trace("QueryPlayInventory - Not applicable for browser");
		}

		public function ConsumeInventoryItem(param1:String):void
		{
			trace("ConsumeInventoryItem - Not applicable for browser");
		}

		public function CheckAdMobSupport(param1:String, param2:String):Boolean
		{
			trace("CheckAdMobSupport - Not applicable for browser");
			return false;
		}

		public function LoadInterstitial(param1:Function, param2:Boolean):Boolean
		{
			trace("LoadInterstitial - Not applicable for browser");
			return false;
		}

		public function ShowInterstitial(param1:Function, param2:String = ""):void
		{
			trace("ShowInterstitial - Not applicable for browser");
			if (param1 != null)
			{
				param1();
			}
		}

		public function OnExitApplication(param1:Event):void
		{
			ExternalInterface.call("closeWindow");
		}

		public function FacebookLogin(appID:String, callback:Function):void
		{
			trace("FacebookLogin, appID:", appID);
			if (ExternalInterface.available)
			{
				this.facebook_sso_callback = callback;
				this.fb_task_progress = true;
				ExternalInterface.addCallback("onFacebookLoginSuccess", this.onFacebookLoginSuccess);
				ExternalInterface.addCallback("onFacebookLoginFailure", this.onFacebookLoginFailure);
				ExternalInterface.call("initFacebookLogin", appID);
			}
			else if (callback != null)
			{
				callback(null);
			}
		}

		private function onFacebookLoginSuccess(accessToken:String):void
		{
			trace("FacebookLoginSuccess, accessToken:", accessToken);
			this.fb_task_progress = false;
			if (this.facebook_sso_callback != null)
			{
				this.facebook_sso_callback({
							"accessToken": accessToken,
							"uid": "0"
						});
			}
		}

		private function onFacebookLoginFailure():void
		{
			trace("FacebookLoginFailure");
			this.fb_task_progress = false;
			if (this.facebook_sso_callback != null)
			{
				this.facebook_sso_callback(null);
			}
		}

		public function FacebookLogout(appURL:String, callback:Function):void
		{
			trace("FacebookLogout, appURL:", appURL);
			if (ExternalInterface.available)
			{
				ExternalInterface.call("logoutFacebook");
				if (callback != null)
				{
					callback();
				}
			}
		}

		public function FacebookInvite(message:String, title:String, data:String, callback:Function):void
		{
			trace("FacebookInvite, message:", message, "title:", title);
			this.facebook_sso_callback = callback;
			this.fb_task_progress = true;
			if (ExternalInterface.available)
			{
				ExternalInterface.call("showFacebookInvite", message, title, data);
			}
		}

		public function LoadPersistentData(key:String):Object
		{
			if (ExternalInterface.available)
			{
				var data:String = ExternalInterface.call("getPersistentData", key);
				if (data && data.length > 0)
				{
					var byteArray:ByteArray = new ByteArray();
					byteArray.writeUTFBytes(data);
					return byteArray.readObject();
				}
			}
			return null;
		}

		public function SavePersistentData(key:String, value:Object):Boolean
		{
			if (ExternalInterface.available)
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.writeObject(value);
				var data:String = byteArray.readUTFBytes(byteArray.length);
				ExternalInterface.call("setPersistentData", key, data);
				return true;
			}
			return false;
		}

		private function OnKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.BACK:
					event.preventDefault();
					event.stopImmediatePropagation();
					stage.dispatchEvent(new Event("BACKBUTTONPRESSED"));
					break;
				case Keyboard.MENU:
					event.preventDefault();
					event.stopImmediatePropagation();
					stage.dispatchEvent(new Event("MENUBUTTONPRESSED"));
					break;
				case Keyboard.SEARCH:
					event.preventDefault();
					event.stopImmediatePropagation();
					stage.dispatchEvent(new Event("SEARCHBUTTONPRESSED"));
			}
		}

		private function OnActivate(event:Event):void
		{
			if (this.fb_task_progress)
			{
				return;
			}
			stage.dispatchEvent(new Event("ACTIVATE"));
		}

		private function OnDeactivate(event:Event):void
		{
			if (this.fb_task_progress)
			{
				return;
			}
			stage.dispatchEvent(new Event("DEACTIVATE"));
		}

		public function CreateStageText(stage:*, x:*, y:*, width:*, height:*, multiline:Boolean):*
		{
			trace("CreateStageText - Not applicable for browser");
			return null;
		}
	}
}
