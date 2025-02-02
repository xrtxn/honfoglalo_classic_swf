package uibase
{
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import syscode.*;
	import uibase.gfx.LegoIconset;

	public class LegoWeeklyTimer extends MovieClip
	{
		public var CROWN:uibase.gfx.LegoIconset;

		public var ENERGYBG:MovieClip;

		public var rlresetremaining:int = 0;

		public var rlresettimeref:int = 0;

		public var rlresettimer:Timer = null;

		public var LABEL1:MovieClip;

		public var LABEL2:MovieClip;

		public var ICON1:MovieClip;

		public var ICON2:MovieClip;

		public var DAILYRESET:MovieClip;

		public var DAILYTIME:MovieClip;

		public var DAILYRESETDAY:MovieClip;

		public function LegoWeeklyTimer()
		{
			super();
			this.visible = false;
		}

		public function UpdateRLResetTime(e:TimerEvent = null):void
		{
			var elapsed:int = 0;
			var remaining:int = 0;
			var days:* = undefined;
			var hours:* = undefined;
			var mins:String = null;
			var sec:String = null;
			var ts:String = null;
			if (this.rlresettimer == null)
			{
				this.rlresettimer = new Timer(1000, 0);
				Util.AddEventListener(this.rlresettimer, TimerEvent.TIMER, this.UpdateRLResetTime);
				this.rlresettimer.start();
			}
			if (this.rlresettimer.currentCount >= 0)
			{
				this.visible = true;
				elapsed = Math.round((getTimer() - this.rlresettimeref) / 1000);
				remaining = this.rlresetremaining - elapsed;
				days = Math.floor(remaining / (24 * 60 * 60));
				remaining %= 24 * 60 * 60;
				hours = Math.floor(remaining / (60 * 60));
				remaining %= 60 * 60;
				mins = String(Math.floor(remaining / 60));
				if (mins.length == 1)
				{
					mins = "0" + mins;
				}
				remaining %= 60;
				sec = String(Math.floor(remaining));
				if (sec.length == 1)
				{
					sec = "0" + sec;
				}
				if (this.name.indexOf("ONE") >= 1)
				{
					Util.SetText(this.DAILYTIME.FIELD, hours + ":" + mins + ":" + sec);
					Util.SetText(this.DAILYRESETDAY.FIELD, days);
				}
				if (this.name.indexOf("BIG") >= 1)
				{
					Util.SetText(this.DAILYRESET.FIELD, Lang.Get("weekly_reset_remaining2"));
					Util.SetText(this.DAILYTIME.FIELD, hours + ":" + mins + ":" + sec);
					Util.SetText(this.DAILYRESETDAY.FIELD, days);
				}
				if (this.name.indexOf("SMALL") >= 1)
				{
					ts = "";
					if (days > 0)
					{
						ts += days + ":" + hours;
						this.LABEL1.FIELD.text = days;
						this.LABEL2.FIELD.text = hours;
						this.ICON1.gotoAndStop("SUN");
						this.ICON2.gotoAndStop("TIME");
					}
					else if (hours > 0)
					{
						ts += hours + ":" + mins;
						this.LABEL1.FIELD.text = hours;
						this.LABEL2.FIELD.text = mins;
						this.ICON1.gotoAndStop("TIME");
						this.ICON2.gotoAndStop("MINUTE");
					}
					else
					{
						ts += mins + ":" + sec;
						this.LABEL1.FIELD.text = mins;
						this.LABEL2.FIELD.text = sec;
						this.ICON1.gotoAndStop("MINUTE");
						this.ICON2.gotoAndStop("SECOND");
					}
				}
			}
		}

		public function Start():void
		{
			this.UpdateRLResetTime();
		}

		public function Destroy():void
		{
			if (Boolean(this.rlresettimer) && this.rlresettimer.hasEventListener(TimerEvent.TIMER))
			{
				Util.RemoveEventListener(this.rlresettimer, TimerEvent.TIMER, this.UpdateRLResetTime);
				this.rlresettimer.stop();
				this.rlresettimer = null;
			}
			if (Boolean(parent) && parent.contains(this))
			{
				parent.removeChild(this);
			}
		}
	}
}
