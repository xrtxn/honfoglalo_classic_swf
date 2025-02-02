package uibase
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol1124")]
	public class List extends MovieClip
	{
		public var ITEM1:MovieClip;

		public var ITEM2:MovieClip;

		public var ITEM3:MovieClip;

		public var scrollrect:MovieClip;

		public var scrollbar:ScrollBarMov;

		public var prefix:*;

		public var columns:int;

		public var itemheight:int;

		public var pagesize:Number;

		public var first:int = 0;

		public var pos:Number = 0;

		public var items:Array = null;

		public var pool:Array;

		public var mc:MovieClip = null;

		public var click_func:Function = null;

		public var draw_func:Function = null;

		public var no_events:Boolean = false;

		public function List()
		{
			this.pool = [];
			super();
		}

		public function Set(prefix:*, list:Array, itemheight:int, columns:int = 1, clickfunc:Function = null, drawfunc:Function = null, scrollrect:MovieClip = null, scrollbar:ScrollBarMov = null):*
		{
			var s:* = undefined;
			var c:* = undefined;
			Util.StopAllChildrenMov(this);
			this.scrollrect = scrollrect;
			this.prefix = prefix;
			this.click_func = clickfunc;
			this.columns = columns;
			this.itemheight = itemheight;
			this.items = list;
			this.draw_func = drawfunc;
			this.mc = this;
			if (scrollbar)
			{
				this.pagesize = scrollbar.height / itemheight;
			}
			else if (scrollrect)
			{
				this.pagesize = scrollrect.height / itemheight;
			}
			var num:* = Math.ceil(this.pagesize + 1) * columns;
			for (var i:* = 1; i <= num; i++)
			{
				this.pool[i] = -1;
				s = this.mc[prefix + i];
				if (!s)
				{
					c = this.mc.getChildAt(0);
					// this threw an error
					// s = new c.constructor();
					s = new c();
					s.x = this.mc[prefix + ((i - 1) % columns + 1)].x;
					this.mc[prefix + i] = s;
					this.mc.addChild(s);
					Util.StopAllChildrenMov(s);
				}
			}
			if (scrollrect)
			{
				Imitation.CollectChildrenAll();
				Imitation.SetMaskedMov(scrollrect, this.mc);
				Imitation.AddEventMask(scrollrect, this.mc);
			}
			if (scrollbar)
			{
				this.SetScrollBar(scrollbar);
			}
			this.Draw();
		}

		public function SetScrollBar(scrollbar:ScrollBarMov):void
		{
			this.scrollbar = scrollbar;
			scrollbar.Set(Math.ceil(this.items.length / this.columns), this.pagesize, 0);
			scrollbar.visible = this.items.length / this.columns > this.pagesize;
			scrollbar.SetScrollRect(this.scrollrect);
			scrollbar.OnScroll = this.onScroll;
		}

		public function GetVisibleItem(id:*):*
		{
			var o:* = undefined;
			var num:* = Math.ceil(this.pagesize + 1) * this.columns;
			for (var i:* = 1; i <= num; i++)
			{
				o = this.mc[this.prefix + i];
				if (o.id == id && o.y + o.height < this.scrollbar.height)
				{
					return o;
				}
			}
		}

		public function Hover(id:*):*
		{
			var o:* = undefined;
			var num:* = Math.ceil(this.pagesize + 1) * this.columns;
			for (var i:* = 1; i <= num; i++)
			{
				o = this.mc[this.prefix + i];
				o.hover = o.id == id;
			}
			this.Draw();
		}

		public function SetItems(list:*, reset:* = true):*
		{
			this.items = list;
			if (reset && Boolean(this.scrollbar))
			{
				this.scrollbar.visible = this.items.length / this.columns > this.pagesize;
				this.scrollbar.Set(Math.ceil(this.items.length / this.columns), this.pagesize, 0);
			}
			if (reset)
			{
				this.pos = 0;
				this.first = 0;
			}
			this.Draw();
		}

		public function Draw(refresh:* = true):*
		{
			var i:int = 0;
			var id:int = 0;
			var fish:int = 0;
			var s:* = undefined;
			var num:* = Math.ceil(this.pagesize + 1) * this.columns;
			if (!this.scrollbar || !this.scrollbar.visible)
			{
				this.pos = 0;
				this.first = 0;
			}
			var pos2:* = this.first - this.pos;
			if (refresh)
			{
				for (i = 1; i <= num; this.pool[i] = -1, i++)
				{
				}
			}
			var newpool:* = [];
			for (fish = 1; fish <= num; newpool[fish] = -1, fish++)
			{
			}
			for (i = 1; i <= num; i++)
			{
				id = i + this.first * this.columns - 1;
				fish = int(this.pool.indexOf(id, 1));
				if (fish >= 0)
				{
					newpool[fish] = id;
				}
			}
			for (i = 1; i <= num; i++)
			{
				id = i + this.first * this.columns - 1;
				fish = int(newpool.indexOf(id, 1));
				if (fish >= 0)
				{
					s = this.mc[this.prefix + fish];
				}
				else
				{
					fish = int(newpool.indexOf(-1, 1));
					newpool[fish] = id;
					s = this.mc[this.prefix + fish];
					s.gotoAndStop(1);
					s.mouseChildren = false;
					s.id = i + this.first * this.columns - 1;
					if (this.draw_func != null)
					{
						this.draw_func(s, s.id);
					}
					if (!this.no_events)
					{
						Imitation.AddEventClick(s, this.onClick);
						Imitation.AddEventMouseOver(s, this.onOver);
						Imitation.AddEventMouseOut(s, this.onOut);
					}
				}
				s.buttonMode = this.click_func != null;
				s.useHandCursor = s.buttonMode;
				s.y = (pos2 + int((i - 1) / this.columns)) * this.itemheight;
			}
			this.pool = newpool;
		}

		public function UnSet():*
		{
			Imitation.RemoveEventMask(this.scrollrect);
		}

		private function onScroll(pos:*):*
		{
			this.pos = pos;
			this.first = Math.floor(pos);
			TweenMax.delayedCall(0, this.Draw, [false]);
		}

		private function onClick(e:*):void
		{
			var s:MovieClip = MovieClip(e.target);
			if (s)
			{
				if (this.scrollbar && this.scrollbar.visible && (Math.abs(this.scrollbar.mouseDownX - this.scrollbar.mouseLastX) > 5 || Math.abs(this.scrollbar.mouseDownY - this.scrollbar.mouseLastY) > 5))
				{
					return;
				}
				if (this.click_func != null)
				{
					this.click_func(s, s.id);
				}
			}
		}

		private function onOver(e:*):void
		{
			var s:MovieClip = MovieClip(e.target);
			if (s)
			{
				s.gotoAndStop(2);
				s.hover = true;
				if (this.draw_func != null)
				{
					this.draw_func(s, s.id);
				}
			}
		}

		private function onOut(e:*):void
		{
			var s:MovieClip = MovieClip(e.target);
			if (s)
			{
				s.gotoAndStop(1);
				s.hover = null;
				if (this.draw_func != null)
				{
					this.draw_func(s, s.id);
				}
			}
		}
	}
}
