package uibase
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol74")]
	public class TabMov extends MovieClip
	{
		public var TTAB1:MovieClip;

		public var TTAB2:MovieClip;

		public var TTAB3:MovieClip;

		public var current:int = 1;

		public var callback:Function = null;

		public var titles:Array;

		public var active:Boolean = true;

		public function TabMov()
		{
			this.titles = new Array();
			super();
		}

		public function Set(atitles:Array, acallback:Function):void
		{
			this.titles = atitles;
			this.callback = acallback;
			this.SetActiveTab(1);
		}

		public function TabClicked(e:*):void
		{
			if (!this.active)
			{
				return;
			}
			var tab:* = e.target.parent;
			var num:int = int(tab.name.substr(-1, 1));
			this.SetActiveTab(num);
			this.TabOver(e);
		}

		public function SetActiveTab(anum:*):void
		{
			var tab:MovieClip = null;
			var i:* = 1;
			while (tab = this.getChildByName("TTAB" + i) as MovieClip, tab)
			{
				tab.gotoAndStop(i == anum ? "ACTIVE" : "INACTIVE");
				Imitation.AddEventClick(tab.BTN, this.TabClicked);
				Imitation.AddEventMouseOver(tab.BTN, this.TabOver);
				Imitation.AddEventMouseOut(tab.BTN, this.TabOut);
				if (tab.CAPTION)
				{
					Lang.Set(tab.CAPTION, this.titles[i - 1]);
				}
				i++;
			}
			this.current = anum;
			if (this.callback != null)
			{
				this.callback(anum);
			}
		}

		private function TabOver(e:*):void
		{
			if (!this.active)
			{
				return;
			}
			var tab:* = e.target.parent;
			if (tab.currentFrame == 1)
			{
				if (tab.BG)
				{
					TweenMax.to(tab.BG, 0.2, {"scaleY": 1.15});
				}
				if (tab.CAPTION)
				{
					TweenMax.to(tab.CAPTION, 0.2, {"y": -30});
				}
			}
		}

		private function TabOut(e:*):void
		{
			if (!this.active)
			{
				return;
			}
			var tab:* = e.target.parent;
			if (!tab)
			{
				return;
			}
			if (tab.currentFrame == 1)
			{
				if (tab.BG)
				{
					TweenMax.to(tab.BG, 0.2, {"scaleY": 1});
				}
				if (tab.CAPTION)
				{
					TweenMax.to(tab.CAPTION, 0.2, {"y": -24});
				}
			}
		}
	}
}
