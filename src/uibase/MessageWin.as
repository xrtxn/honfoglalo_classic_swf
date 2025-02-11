package uibase
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.Timer;
	import syscode.*;
	import uibase.gfx.lego_button_2x1_ok;
	import uibase.gfx.lego_button_2x1_cancel;
	import uibase.gfx.lego_button_3x1_normal;
	import uibase.gfx.UIIconset;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol394")]
	public class MessageWin extends MovieClip
	{
		public var BTN1:lego_button_2x1_ok;

		public var BTN2:lego_button_2x1_cancel;

		public var BTNCLOSE:lego_button_3x1_normal;

		public var ICON:uibase.gfx.UIIconset;

		public var MESSAGE:MovieClip;

		public var TITLE:MovieClip;

		public var params:Object;

		public var callbackfunc:Function = null;

		public var callbackparams:Array;

		public var yesnoresult:int = 0;

		public function MessageWin()
		{
			this.params = {};
			this.callbackparams = [];
			super();
		}

		public static function Show(atitle:String, amsg:String, acallbackfunc:Function = null, icon:int = 1, countdown:int = 0):void
		{
			var par:Object = {};
			par.title = atitle;
			par.msg = amsg;
			par.yesno = false;
			par.callbackfunc = acallbackfunc;
			par.callbackparams = null;
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
			WinMgr.OpenWindow(MessageWin, par);
		}

		public static function AskYesNo(atitle:String, amsg:String, abtn1:String, abtn2:String, acallbackfunc:Function, acallbackparams:Array = null):void
		{
			var par:Object = {};
			par.title = atitle;
			par.msg = amsg;
			par.yesno = true;
			par.btn1 = abtn1;
			par.btn2 = abtn2;
			par.callbackfunc = acallbackfunc;
			par.callbackparams = acallbackparams;
			par.countdown = 0;
			WinMgr.OpenWindow(MessageWin, par);
		}

		public function Prepare(aparams:Object):void
		{
			var SetCloseBtn:Function;
			var countdown:int = 0;
			var cd:Timer = null;
			this.params = aparams;
			trace("Preparing message window \"" + this.params.msg + "\"");
			Util.SetText(this.TITLE.FIELD, this.params.title);
			Util.SetText(this.MESSAGE.FIELD, this.params.msg);
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
			if (this.params.yesno)
			{
				this.yesnoresult = 0;
				this.BTN1.SetCaption(this.params.btn1);
				this.BTN2.SetCaption(this.params.btn2);
				this.BTN1.AddEventClick(this.OnYesNoClick);
				this.BTN2.AddEventClick(this.OnYesNoClick);
				this.BTN1.visible = true;
				this.BTN2.visible = true;
				this.BTNCLOSE.visible = false;
				this.ICON.gotoAndStop("TRIANGLE2");
			}
			else
			{
				SetCloseBtn = function(e:* = null):*
				{
					if (BTNCLOSE)
					{
						BTNCLOSE.SetLang("close");
						BTNCLOSE.SetEnabled(true);
						BTNCLOSE.AddEventClick(OnClose);
					}
				};
				this.BTN1.visible = false;
				this.BTN2.visible = false;
				this.BTNCLOSE.visible = true;
				this.ICON.gotoAndStop(this.params.icon);
				countdown = Util.NumberVal(this.params.countdown);
				if (countdown)
				{
					this.BTNCLOSE.SetEnabled(false);
					this.BTNCLOSE.SetCaption("- " + String(countdown) + " -");
					cd = new Timer(1000, countdown + 1);
					Util.AddEventListener(cd, TimerEvent.TIMER, function():*
						{
							trace(countdown);
							if (BTNCLOSE)
							{
								BTNCLOSE.SetCaption("- " + String(countdown) + " -");
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
			WinMgr.CloseWindow(this);
		}
	}
}
