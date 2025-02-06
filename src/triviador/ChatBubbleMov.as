package triviador
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.Timer;
	import syscode.*;

	[Embed(source="/modules/triviador_assets.swf", symbol="symbol1356")]
	public class ChatBubbleMov extends MovieClip
	{
		public var EMO:MovieClip;

		public var TEXT:TextField;

		internal var outtimer:Timer;

		public function ChatBubbleMov(atext:*, em:*)
		{
			super();
			this.gotoAndStop(1);
			if (em)
			{
				Util.SetText(this.TEXT, "");
				this.EMO.visible = true;
				Imitation.GotoFrame(this.EMO, em);
			}
			else
			{
				Util.SetText(this.TEXT, atext);
				this.EMO.visible = false;
			}
		}

		public function KillMe():*
		{
			if (this.outtimer)
			{
				Util.RemoveEventListener(this.outtimer, TimerEvent.TIMER, this.BubbleOut);
			}
			this.parent.removeChild(this);
		}

		public function BubbleIn():*
		{
			TweenMax.from(this, 0.3, {
						"scaleX": 0,
						"scaleY": 0
					});
			this.outtimer = new Timer(2 * 1000, 1);
			Util.AddEventListener(this.outtimer, TimerEvent.TIMER, this.BubbleOut);
			this.outtimer.start();
		}

		public function BubbleOut(e:*):*
		{
			Imitation.GotoFrame(this, 2);
			var btnchat:* = Standings.mc.STATUS;
			if (!btnchat)
			{
				return;
			}
			TweenMax.to(this, 0.25, {"x": btnchat.x + btnchat.width / 2 - 20});
			TweenMax.to(this, 0.25, {
						"y": btnchat.y + btnchat.height / 2 - 15,
						"scaleX": 0.3,
						"scaleY": 0.3,
						"onComplete": this.KillMe
					});
			var m:* = btnchat.EFFECT;
		}
	}
}
