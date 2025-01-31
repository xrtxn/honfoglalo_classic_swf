package uibase
{
	import com.greensock.TweenMax;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.*;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol103")]
	public class ScrollBarMov extends MovieClip
	{
		public static var global_dragging:Boolean = false;

		public var BAR:MovieClip;

		public var BTNDOWN:SimpleButton;

		public var BTNUP:SimpleButton;

		public var THUMB:MovieClip;

		public var buttongap:Number = 1;

		public var buttonstep:Number = 1;

		public var isfloat:Boolean = true;

		public var isaligned:Boolean = true;

		public var isvertical:Boolean = false;

		public var fullsize:Number = 0;

		public var buttonsize:Number = 0;

		public var barsize:Number = 0;

		public var scrollsize:Number = 0;

		public var pagesize:Number = 0;

		public var firstpos:Number = 0;

		public var dragging:Boolean = false;

		public var OnScroll:Function = null;

		public var scrollrect:MovieClip = null;

		public var mouseDownX:Number = 0;

		public var mouseDownY:Number = 0;

		public var mouseLastX:Number = 0;

		public var mouseLastY:Number = 0;

		public var mouseDownPos:Number = 0;

		public var velocity:Number = 0;

		internal var thumbsize:Number = 0;

		internal var thumbs:Array;

		public function ScrollBarMov()
		{
			super();
			this.fullsize = this.height;
			if (this.height < this.width)
			{
				this.isvertical = true;
				this.fullsize = this.width;
			}
			this.buttonsize = this.BTNUP.height;
			this.scaleY = 1;
			this.UpdateLayout();
			this.thumbs = Util.VerticalSliceImage(this.THUMB, this.THUMB.BTN, [4, this.THUMB.BTN.height - 4], 5);
			this.Set(1, 1, 0);
		}

		public function Remove():*
		{
			Util.RemoveEventListener(Imitation.stage, "mouseDown", this.OnScrollRectMouseDown);
			Util.RemoveEventListener(this, Event.ENTER_FRAME, this.OnEnterFrame);
			if (this.parent)
			{
				Util.RemoveEventListener(this.parent, Event.REMOVED, this.OnRemoved);
			}
			if (Boolean(this.parent) && this.parent.contains(this))
			{
				this.parent.removeChild(this);
			}
		}

		public function OnRemoved(e:*):*
		{
			if (e.target != this)
			{
				return;
			}
			Util.RemoveEventListener(Imitation.stage, "mouseDown", this.OnScrollRectMouseDown);
			Util.RemoveEventListener(this, Event.ENTER_FRAME, this.OnEnterFrame);
			if (this.parent)
			{
				Util.RemoveEventListener(this.parent, Event.REMOVED, this.OnRemoved);
			}
		}

		public function OnEnterFrame(e:*):*
		{
			if (!this.parent || !this.parent.parent)
			{
				this.Remove();
				return;
			}
			if (this.dragging)
			{
				if (this.scrollrect.width / this.scrollrect.scaleX > this.scrollrect.mouseX)
				{
					this.velocity = this.mouseLastY - Imitation.stage.mouseY;
				}
				this.mouseLastY = Imitation.stage.mouseY;
				this.mouseLastX = Imitation.stage.mouseX;
				if (this.OnScroll != null)
				{
					this.OnScroll(this.firstpos);
				}
				this.UpdateThumb();
			}
			else if (this.velocity)
			{
				this.velocity /= 1.05;
				if (Math.abs(this.velocity) < 0.5)
				{
					if (this.isaligned && this.firstpos - Math.round(this.firstpos) > 0.05)
					{
						this.velocity = -0.5;
					}
					else if (this.isaligned && this.firstpos - Math.round(this.firstpos) < -0.05)
					{
						this.velocity = 0.5;
					}
					else
					{
						this.velocity = 0;
					}
				}
				this.firstpos += this.velocity * this.pagesize / height;
				if (this.firstpos < 0)
				{
					this.firstpos = 0;
				}
				if (this.firstpos > this.scrollsize - this.pagesize)
				{
					this.firstpos = this.scrollsize - this.pagesize;
				}
				if (this.OnScroll != null)
				{
					this.OnScroll(this.firstpos);
				}
				this.UpdateThumb();
			}
		}

		public function UpdateLayout():*
		{
			this.barsize = this.fullsize - 2 * (this.buttonsize + this.buttongap);
			this.BTNDOWN.y = this.fullsize;
			this.BAR.y = this.buttonsize + this.buttongap;
			this.BAR.height = this.barsize;
			Imitation.FreeBitmapAll(this.BAR);
			Imitation.UpdateAll(this.BAR);
		}

		public function Set(ascrollsize:*, apagesize:*, afirstpos:*):*
		{
			TweenMax.killTweensOf(this);
			this.scrollsize = ascrollsize;
			this.pagesize = apagesize;
			this.firstpos = afirstpos;
			this.velocity = 0;
			this.dragging = false;
			global_dragging = false;
			this.mouseLastY = 0;
			this.mouseLastX = 0;
			this.mouseDownPos = 0;
			this.mouseDownY = 0;
			this.mouseDownX = 0;
			if (this.firstpos + this.pagesize > this.scrollsize)
			{
				this.firstpos = this.scrollsize - this.pagesize;
			}
			if (this.firstpos < 0)
			{
				this.firstpos = 0;
			}
			this.UpdateThumb();
			Imitation.AddEventMouseDown(this.THUMB, this.OnThumbMouseDown);
			Imitation.AddEventClick(this.BTNUP, this.OnBtnUp);
			Imitation.AddEventClick(this.BTNDOWN, this.OnBtnDown);
			if (this.parent)
			{
				Util.AddEventListener(this.parent, Event.REMOVED, this.OnRemoved);
			}
		}

		public function SetScrollRect(m:MovieClip):*
		{
			this.scrollrect = m;
			Util.AddEventListener(Imitation.stage, "mouseDown", this.OnScrollRectMouseDown);
			Util.AddEventListener(this, Event.ENTER_FRAME, this.OnEnterFrame);
		}

		public function OnScrollRectMouseDown(e:*):*
		{
			var hit:* = this.scrollrect.getRect(Imitation.stage).contains(Imitation.stage.mouseX, Imitation.stage.mouseY);
			if (!hit || !this.visible)
			{
				return;
			}
			this.mouseDownY = Imitation.stage.mouseY;
			this.mouseDownX = Imitation.stage.mouseX;
			this.mouseLastY = this.mouseDownY;
			this.mouseLastX = this.mouseDownX;
			this.mouseDownPos = this.firstpos;
			Util.AddEventListener(Imitation.stage, "mouseUp", this.OnScrollRectMouseUp);
			Util.AddEventListener(Imitation.stage, "mouseMove", this.OnScrollRectMouseMove);
			this.dragging = true;
		}

		public function OnScrollRectMouseUp(e:*):*
		{
			Util.RemoveEventListener(Imitation.stage, "mouseUp", this.OnScrollRectMouseUp);
			Util.RemoveEventListener(Imitation.stage, "mouseMove", this.OnScrollRectMouseMove);
			this.UpdateThumb();
			this.dragging = false;
			TweenMax.delayedCall(0, function():*
				{
					global_dragging = false;
				});
		}

		public function OnScrollRectMouseMove(e:*):*
		{
			if (!this.parent || !this.parent.parent)
			{
				return;
			}
			var fprl:* = this.scrollsize - this.pagesize;
			var pm:Point = new Point(this.mouseDownX, this.mouseDownY);
			var ps:Point = new Point(Imitation.stage.mouseX, Imitation.stage.mouseY);
			pm = globalToLocal(pm);
			ps = globalToLocal(ps);
			if (Math.abs(pm.x - ps.x) > 5 || Math.abs(pm.y - ps.y) > 5)
			{
				global_dragging = true;
			}
			var p:* = (pm.y - ps.y) * this.pagesize / height / fprl;
			this.firstpos = fprl * p + this.mouseDownPos;
			if (!this.isfloat)
			{
				this.firstpos = Math.round(this.firstpos);
			}
			if (this.firstpos < 0)
			{
				this.firstpos = 0;
			}
			if (this.firstpos > this.scrollsize - this.pagesize)
			{
				this.firstpos = this.scrollsize - this.pagesize;
			}
		}

		public function ScrollTo(pos:Number, delay:Number = 0, oncomplete:Function = null):*
		{
			var update:Function = null;
			var complete:Function = null;
			update = function():*
			{
				if (!isfloat)
				{
					firstpos = Math.round(firstpos);
				}
				if (firstpos < 0)
				{
					firstpos = 0;
				}
				if (firstpos > scrollsize - pagesize)
				{
					firstpos = scrollsize - pagesize;
				}
				if (OnScroll != null)
				{
					OnScroll(firstpos);
				}
				UpdateThumb();
			};
			complete = function():*
			{
				if (oncomplete != null)
				{
					oncomplete();
				}
			};
			if (delay > 0)
			{
				TweenMax.to(this, delay, {
							"firstpos": pos,
							"onUpdate": update,
							"onComplete": complete
						});
			}
			else
			{
				this.firstpos = pos;
				update();
				complete();
			}
		}

		public function UpdateThumb():*
		{
			var hratio:* = 1;
			if (this.scrollsize > 0)
			{
				hratio = this.pagesize / this.scrollsize;
			}
			if (hratio > 1)
			{
				hratio = 1;
			}
			this.thumbsize = Math.max(20, int(this.barsize * hratio));
			if (this.THUMB.height != this.thumbsize)
			{
				this.thumbs[0].y = -this.thumbsize / 2;
				this.thumbs[1].y = 4 - this.thumbsize / 2;
				this.thumbs[1].height = this.thumbsize - 8 + 1;
				this.thumbs[2].y = this.thumbs[0].y + this.thumbsize - 4;
				Imitation.FreeBitmapAll(this.THUMB);
				Imitation.UpdateAll(this.THUMB);
			}
			var p:* = 0;
			if (this.scrollsize - this.pagesize > 0)
			{
				p = this.firstpos / (this.scrollsize - this.pagesize);
			}
			this.THUMB.y = this.BAR.y + this.thumbsize / 2 + p * (this.barsize - this.thumbsize);
		}

		public function OnThumbMouseDown(e:*):*
		{
			var x:* = this.THUMB.x;
			var y:* = this.BAR.y + this.thumbsize / 2;
			var trl:* = this.barsize - this.thumbsize;
			Imitation.StartDrag(this.THUMB, new Rectangle(x, y, 0, trl));
			Util.AddEventListener(Imitation.stage, "mouseUp", this.OnThumbMouseUp);
			Util.AddEventListener(Imitation.stage, "mouseMove", this.OnThumbMove);
			this.dragging = true;
		}

		public function OnThumbMouseUp(e:*):*
		{
			Imitation.StopDrag();
			Util.RemoveEventListener(Imitation.stage, "mouseUp", this.OnThumbMouseUp);
			Util.RemoveEventListener(Imitation.stage, "mouseMove", this.OnThumbMove);
			this.UpdateThumb();
			this.dragging = false;
			TweenMax.delayedCall(0, function():*
				{
					global_dragging = false;
				});
		}

		public function OnThumbMove(e:*):*
		{
			var y:* = this.BAR.y + this.thumbsize / 2;
			var trl:* = this.barsize - this.thumbsize;
			var p:* = (this.THUMB.y - y) / trl;
			var fprl:* = this.scrollsize - this.pagesize;
			this.firstpos = fprl * p;
			if (!this.isfloat)
			{
				this.firstpos = Math.round(this.firstpos);
			}
			if (this.firstpos < 0)
			{
				this.firstpos = 0;
			}
			if (this.OnScroll != null)
			{
				this.OnScroll(this.firstpos);
			}
		}

		public function OnBtnUp(e:*):*
		{
			this.firstpos -= this.buttonstep;
			if (this.firstpos < 0)
			{
				this.firstpos = 0;
			}
			this.UpdateThumb();
			if (this.OnScroll != null)
			{
				this.OnScroll(this.firstpos);
			}
		}

		public function OnBtnDown(e:*):*
		{
			this.firstpos += this.buttonstep;
			if (this.firstpos + this.pagesize > this.scrollsize)
			{
				this.firstpos = this.scrollsize - this.pagesize;
			}
			if (this.firstpos < 0)
			{
				this.firstpos = 0;
			}
			this.UpdateThumb();
			if (this.OnScroll != null)
			{
				this.OnScroll(this.firstpos);
			}
		}
	}
}
