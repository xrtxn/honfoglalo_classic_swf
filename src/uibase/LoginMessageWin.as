package uibase
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.*;
	import flash.utils.Timer;
	import syscode.*;
	import uibase.gfx.lego_button_2x1_ok;
	import uibase.gfx.lego_button_2x1_cancel;
	import uibase.gfx.UIIconset;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol395")]
	public class LoginMessageWin extends MovieClip
	{
		public static var mc:LoginMessageWin = null;

		public var BTN1:lego_button_2x1_ok;

		public var BTN2:lego_button_2x1_cancel;

		public var ICON:uibase.gfx.UIIconset;

		public var MESSAGE:MovieClip;

		public var TITLE:MovieClip;

		private var loader:Loader = null;

		public var params:Object;

		public var callbackfunc:Function = null;

		public var callbackparams:Array;

		public var yesnoresult:int = 0;

		public function LoginMessageWin()
		{
			this.params = {};
			this.callbackparams = [];
			super();
		}

		public static function Show(atitle:String, amsg:String, image_url:String, button_text:String, button_url:String, close_buton:Boolean, acallbackfunc:Function, acallbackparams:Array = null, icon:int = 1, countdown:int = 0):void
		{
			var par:Object = {};
			par.title = atitle;
			par.msg = amsg;
			par.img = Util.StringVal(image_url);
			par.url = button_url;
			par.yesno = true;
			par.btn1 = button_text;
			par.btn2 = Lang.get ("close");
			par.callbackfunc = acallbackfunc;
			par.callbackparams = acallbackparams;
			par.icon = icon;
			if (par.icon == 1)
			{
				par.icon = "TRIANGLE1";
			}
			if (par.icon == 2)
			{
				par.icon = "TRIANGLE2";
			}
			par.countdown = countdown;
			par.close_btn = close_buton;
			WinMgr.OpenWindow("uibase.LoginMessageWin", par);
		}

		public function Prepare(aparams:Object):void
		{
			var countdown:int = 0;
			var SetCloseBtn:Function = null;
			var cd:Timer = null;
			SetCloseBtn = function(e:* = null):*
			{
				if (BTN2)
				{
					BTN2.SetLang("close");
					BTN2.SetEnabled(true);
					BTN2.AddEventClick(OnClose);
				}
			};
			this.params = aparams;
			trace("Preparing message window \"" + this.params.msg + "\"");
			if (this.params.img == "")
			{
				this.params.loading = false;
				gotoAndStop(1);
			}
			else
			{
				this.params.waitfordata = true;
				this.params.loading = true;
				gotoAndStop(2);
			}
			if (this.params.callbackfunc)
			{
				this.callbackfunc = this.params.callbackfunc;
				if (this.params.callbackparams)
				{
					this.callbackparams = this.params.callbackparams;
				}
				else
				{
					this.callbackparams = [];
				}
			}
			this.yesnoresult = 0;
			this.TITLE.FIELD.htmlText = Util.StringVal(this.params.title);
			if (Boolean(this.MESSAGE) && Boolean(this.MESSAGE.FIELD))
			{
				this.MESSAGE.FIELD.htmlText = Util.StringVal(this.params.msg);
			}
			this.BTN1.SetCaption(this.params.btn1);
			this.BTN2.SetCaption(this.params.btn2);
			this.BTN1.AddEventClick(this.OnYesNoClick);
			this.BTN2.AddEventClick(this.OnYesNoClick);
			this.BTN1.visible = this.params.btn1 != "";
			this.BTN2.visible = this.params.close_btn;
			this.ICON.gotoAndStop(this.params.icon);
			countdown = Util.NumberVal(this.params.countdown);
			if (countdown)
			{
				this.BTN2.SetEnabled(false);
				this.BTN2.SetCaption("- " + String(countdown) + " -");
				cd = new Timer(1000, countdown + 1);
				Util.AddEventListener(cd, TimerEvent.TIMER, function():*
					{
						trace(countdown);
						if (BTN2)
						{
							BTN2.SetCaption("- " + String(countdown) + " -");
						}
						--countdown;
					});
				Util.AddEventListener(cd, TimerEvent.TIMER_COMPLETE, SetCloseBtn);
				cd.start();
			}
			else
			{
				SetCloseBtn();
			}
		}

		private function OnLoaderComplete(img:Bitmap):void
		{
		}

		public function AfterClose():void
		{
			if (this.callbackfunc != null)
			{
				this.callbackfunc.apply(null, this.callbackparams);
			}
		}

		public function CanClose():Boolean
		{
			return !this.params.yesno;
		}

		private function OnClose(e:*):*
		{
			WinMgr.CloseWindow(this);
		}

		private function OnYesNoClick(e:*):*
		{
			trace("OnYesNoClick: " + e.target.name);
			this.yesnoresult = Util.IdFromStringEnd(e.target.name);
			this.callbackparams.unshift(this.yesnoresult);
			if (this.yesnoresult == 1)
			{
				if (this.params.url != "")
				{
					navigateToURL(new URLRequest(this.params.url));
				}
			}
			WinMgr.CloseWindow(this);
		}
	}
}
