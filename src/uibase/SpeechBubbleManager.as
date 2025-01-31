package uibase
{
	import flash.display.MovieClip;
	import flash.events.*;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol1427")]
	public class SpeechBubbleManager extends MovieClip
	{
		private var bubbles:Array;

		private var data:Array;

		public var actIndex:int = 0;

		public var state:String = "pause";

		public var callBack:Function;

		public function SpeechBubbleManager()
		{
			this.bubbles = new Array();
			super();
		}

		public function Init(_data:Array):void
		{
			this.data = _data;
		}

		public function PlayMe():void
		{
			this.StopMe();
			this.state = "play";
			this.NextText();
		}

		public function PauseMe():void
		{
			this.state = "pause";
		}

		public function StopMe():void
		{
			for (var i:int = 0; i < this.bubbles.length; i++)
			{
				if (this.bubbles[i] != null && this.bubbles[i] != undefined)
				{
					this.bubbles[i].StopMe();
				}
			}
		}

		private function NextText(target:* = null):void
		{
			if (target == "BUBBLE_START")
			{
				if (this.callBack != null)
				{
					this.callBack(target);
				}
				return;
			}
			if (target == "BUBBLE_WRITE_END")
			{
				if (this.actIndex < this.data.length)
				{
					if (this.callBack != null)
					{
						this.callBack(target);
					}
					return;
				}
				if (this.callBack != null)
				{
					this.callBack("STORY_END");
					return;
				}
			}
			if (target == "BUBBLE_WAIT_FINISHED")
			{
				if (this.callBack != null)
				{
					this.callBack(target);
				}
			}
			if (this.state == "pause")
			{
				return;
			}
			var yoffset:Number = 0;
			for (var i:int = 0; i < this.bubbles.length; i++)
			{
				if (this.bubbles[i] != null && this.bubbles[i] != undefined)
				{
					if (this.contains(this.bubbles[i]))
					{
						yoffset = this.bubbles[i].y + this.bubbles[i].BG.height + 30;
					}
				}
			}
			this.bubbles[this.actIndex] = new SpeechBubble();
			Imitation.CollectChildrenAll(this);
			trace("actIndex: " + this.actIndex);
			if (yoffset == 0)
			{
				this.bubbles[this.actIndex].SetMe(this.data[this.actIndex].text, this.data[this.actIndex].x, this.data[this.actIndex].y, this.data[this.actIndex].direction, this.data[this.actIndex].width, this.data[this.actIndex].time, this.data[this.actIndex].finish, this.NextText, this.data[this.actIndex].format);
			}
			else
			{
				this.bubbles[this.actIndex].SetMe(this.data[this.actIndex].text, this.data[this.actIndex].x, yoffset, this.data[this.actIndex].direction, this.data[this.actIndex].width, this.data[this.actIndex].time, this.data[this.actIndex].finish, this.NextText, this.data[this.actIndex].format);
			}
			addChild(this.bubbles[this.actIndex]);
			if (this.data[this.actIndex].state == "pause")
			{
				this.PauseMe();
			}
			this.actIndex += 1;
		}
	}
}
