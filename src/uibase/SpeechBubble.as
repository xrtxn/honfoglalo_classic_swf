package uibase
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol1442")]
	public class SpeechBubble extends MovieClip
	{
		public var BG:MovieClip;

		public var BL:MovieClip;

		public var BLINE:MovieClip;

		public var BR:MovieClip;

		public var FIELD:TextField;

		public var LLINE:MovieClip;

		public var PIPE:MovieClip;

		public var RLINE:MovieClip;

		public var TL:MovieClip;

		public var TLINE:MovieClip;

		public var TR:MovieClip;

		public var ttimer:Timer;

		public var textArray:Array;

		private var pipeDir:String;

		private var finishWait:Number;

		private var callBack:Function;

		private var time:Number;

		public var actText:String;

		public var multiSpell:Number = 8;

		public function SpeechBubble()
		{
			super();
			alpha = 0;
		}

		public function SetMe(_text:String = "", _x:Number = 20, _y:Number = 10, _pipe:String = "left", _width:Number = 300, _time:Number = 300, _finishWait:Number = 3000, _callBack:Function = null, _format:TextFormat = null):void
		{
			this.finishWait = _finishWait;
			this.callBack = _callBack;
			this.actText = _text;
			var rex:RegExp = /[\r\n]/;
			this.actText = _text.replace(rex, "");
			this.actText = this.actText.replace("$1", Sys.mydata.name);
			this.textArray = this.actText.split(" ");
			this.time = _time;
			x = Math.round(_x);
			y = Math.round(_y);
			this.pipeDir = _pipe;
			this.FIELD.width = _width;
			this.FIELD.autoSize = "left";
			this.FIELD.multiline = true;
			this.FIELD.wordWrap = true;
			if (!Config.rtl)
			{
				this.FIELD.text = this.actText;
				this.ResizeMe();
				this.FIELD.text = "";
				this.ttimer = new Timer(_time, this.textArray.length);
				Util.AddEventListener(this.ttimer, TimerEvent.TIMER, this.WriteText);
				Util.AddEventListener(this.ttimer, TimerEvent.TIMER_COMPLETE, this.ReadyText);
				this.ttimer.start();
			}
			else
			{
				alpha = 1;
				Util.SetText(this.FIELD, this.actText);
				this.ResizeMe();
				this.ttimer = new Timer(100, 1);
				Util.AddEventListener(this.ttimer, TimerEvent.TIMER_COMPLETE, this.ReadyText);
				this.ttimer.start();
			}
			Imitation.FreeBitmapAll(this);
			Imitation.UpdateAll(this);
			if (this.callBack != null)
			{
				this.callBack("BUBBLE_START");
			}
		}

		private function WriteText(e:TimerEvent):void
		{
			alpha = 1;
			if (this.FIELD.text != "")
			{
				this.FIELD.appendText(" ");
			}
			this.FIELD.appendText(this.textArray[this.ttimer.currentCount - 1]);
			this.ResizeMe();
		}

		private function ReadyText(e:TimerEvent):void
		{
			trace("ReadyText");
			this.ResizeMe();
			this.ttimer = new Timer(this.finishWait, 1);
			Util.AddEventListener(this.ttimer, TimerEvent.TIMER, this.Finish);
			this.ttimer.start();
			if (this.callBack != null)
			{
				this.callBack("BUBBLE_WRITE_END");
			}
		}

		private function Finish(e:TimerEvent):void
		{
			if (this.callBack != null)
			{
				this.callBack("BUBBLE_WAIT_FINISHED");
			}
		}

		private function ResizeMe():void
		{
			this.BG.width = Math.round(this.FIELD.width);
			this.BG.height = Math.round(this.FIELD.height);
			this.TR.x = this.BG.width - 1;
			this.BL.y = this.BG.height - 1;
			this.BR.x = this.BG.width - 1;
			this.BR.y = this.BG.height - 1;
			this.TLINE.width = this.BG.width;
			this.BLINE.width = this.BG.width;
			this.BLINE.y = this.BG.height - 1;
			this.LLINE.height = this.BG.height;
			this.RLINE.x = this.BG.width - 1;
			this.RLINE.height = this.BG.height;
			if (this.pipeDir == "left")
			{
				this.PIPE.rotation = 0;
				this.PIPE.x = Math.round(this.LLINE.x);
				this.PIPE.y = Math.round(this.BG.height / 2);
			}
			if (this.pipeDir == "right")
			{
				this.PIPE.rotation = 180;
				this.PIPE.x = Math.round(this.RLINE.x + this.RLINE.width);
				this.PIPE.y = Math.round(this.BG.height / 2);
			}
			if (this.pipeDir == "bottom")
			{
				this.PIPE.rotation = -90;
				this.PIPE.x = Math.round(this.BG.width / 2);
				this.PIPE.y = Math.round(this.BLINE.y + this.BLINE.height);
			}
			if (this.pipeDir == "top")
			{
				this.PIPE.rotation = 90;
				this.PIPE.x = Math.round(this.BG.width / 2);
				this.PIPE.y = Math.round(this.TLINE.y);
			}
			if (this.pipeDir == "bottomleft")
			{
				this.PIPE.rotation = -90;
				this.PIPE.x = Math.round(this.BG.width / 4);
				this.PIPE.y = Math.round(this.BLINE.y + this.BLINE.height);
			}
			if (this.pipeDir == "bottomright")
			{
				this.PIPE.rotation = -90;
				this.PIPE.x = Math.round(this.BG.width / 2) + Math.round(this.BG.width / 4);
				this.PIPE.y = Math.round(this.BLINE.y + this.BLINE.height);
			}
		}

		public function StopMe():void
		{
			this.ttimer.stop();
			Util.RemoveEventListener(this.ttimer, TimerEvent.TIMER, this.WriteText);
			Util.RemoveEventListener(this.ttimer, TimerEvent.TIMER_COMPLETE, this.ReadyText);
			this.HideComplete();
		}

		public function HideMe():void
		{
			TweenMax.to(this, 0.5, {
						"alpha": 0,
						"scaleX": 0,
						"scaleY": 0,
						"onComplete": this.HideComplete
					});
		}

		public function HideComplete():void
		{
			if (this.parent != null && this.parent.contains(this))
			{
				this.parent.removeChild(this);
			}
		}
	}
}
