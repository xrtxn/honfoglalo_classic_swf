package uibase
{
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import syscode.*;

	public class LegoButton extends MovieClip
	{
		public static var validhandlers:Array = ["click", "mousemove", "mousedown", "mouseup", "mouseover", "mouseout"];

		public var CAPTION:TextField;

		public var ICON:MovieClip;

		public var btnenabled:Boolean = true;

		private var eventhandlers:Object;

		public var icon:MovieClip;

		public var caption:TextField;

		private var ox:Number;

		private var oy:Number;

		private var ow:Number;

		private var oh:Number;

		public function LegoButton()
		{
			this.eventhandlers = {};
			super();
			this.ox = x;
			this.oy = y;
			this.ow = width;
			this.oh = height;
			this.icon = MovieClip(getChildByName("ICON"));
			this.caption = TextField(getChildByName("CAPTION"));
			gotoAndStop(1);
			if (this.icon)
			{
				this.icon.gotoAndStop(1);
			}
			if (this.icon)
			{
				this.icon.visible = false;
			}
			if (this.caption)
			{
				this.caption.visible = false;
			}
			Imitation.AddEventMouseOver(this, this.OnRollOver);
			Imitation.AddEventMouseOut(this, this.OnRollOut);
			Imitation.AddEventMouseDown(this, this.OnMouseDown);
			Imitation.AddEventMouseUp(this, this.OnMouseUp);
			Imitation.AddEventClick(this, this.OnMouseClick);
		}

		public function AddEventClick(_func:Function, _params:Object = null):void
		{
			this.SetHandler("click", _func, _params);
		}

		private function OnMouseClick(e:*):void
		{
			if (!this.btnenabled)
			{
				return;
			}
			this.HandleEvent("click", e);
		}

		private function OnMouseDown(e:*):void
		{
			if (!this.btnenabled)
			{
				return;
			}
			gotoAndStop("OVER");
			width = this.ow - 2;
			height = this.oh - 2;
			x += 1;
			y += 1;
			filters = [new DropShadowFilter(2, 45, 0, 0.8, 2, 2, 1, 1, true)];
			Imitation.SetBitmapScale(this, 1.5);
			Imitation.FreeBitmapAll(this);
			Sounds.PlayEffect("Click", 0.04);
		}

		private function OnMouseUp(e:*):void
		{
			if (!this.btnenabled)
			{
				return;
			}
			gotoAndStop("DEFAULT");
			filters = null;
			width = this.ow;
			height = this.oh;
			x = this.ox;
			y = this.oy;
			Imitation.SetBitmapScale(this, 1);
			Imitation.FreeBitmapAll(this);
		}

		private function OnRollOver(e:*):void
		{
			if (!this.btnenabled)
			{
				return;
			}
			gotoAndStop("OVER");
			Imitation.FreeBitmapAll(this);
		}

		private function OnRollOut(e:*):void
		{
			if (!this.btnenabled)
			{
				return;
			}
			gotoAndStop("DEFAULT");
			filters = null;
			width = this.ow;
			height = this.oh;
			x = this.ox;
			y = this.oy;
			Imitation.FreeBitmapAll(this);
		}

		private function HandleEvent(_type:String, evobj:Object):Boolean
		{
			var h:Object = this.eventhandlers[_type];
			if (!h)
			{
				return false;
			}
			evobj.params = h.params;
			if (h.func)
			{
				h.func.apply(null, [evobj]);
				return true;
			}
			return false;
		}

		public function SetHandler(atype:String, afunc:Function, aparams:Object = null):*
		{
			var pn:String = null;
			var htype:String = atype.toLocaleLowerCase();
			if (validhandlers.indexOf(htype) < 0)
			{
				throw new Error("Invalid button event type: " + htype);
			}
			var h:Object = {
					"func": afunc,
					"params": {}
				};
			if (aparams)
			{
				for (pn in aparams)
				{
					h.params[pn] = aparams[pn];
				}
			}
			this.eventhandlers[atype] = h;
			if (afunc == null)
			{
				delete this.eventhandlers[atype];
			}
		}

		public function SetLang(_id:String):void
		{
			this.SetCaption(Lang.Get(_id));
		}

		public function SetLangAndClick(_id:String, _func:Function, _params:Object = null):void
		{
			this.SetCaption(Lang.Get(_id));
			this.AddEventClick(_func, _params);
		}

		public function SetEnabled(_enabled:Boolean):void
		{
			var change:* = this.btnenabled != _enabled;
			this.btnenabled = _enabled;
			mouseEnabled = _enabled;
			if (this.btnenabled)
			{
				gotoAndStop("DEFAULT");
			}
			else
			{
				gotoAndStop("DISABLED");
			}
			if (change)
			{
				Imitation.FreeBitmapAll(this);
			}
		}

		public function SetIcon(_icon:String = ""):void
		{
			if (!this.icon)
			{
				return;
			}
			if (_icon == "")
			{
				return;
			}
			this.icon.visible = true;
			if (this.caption)
			{
				this.caption.visible = false;
			}
			if (this.MovieClipHasLabel(this.icon, _icon))
			{
				this.icon.gotoAndStop(_icon);
			}
			else
			{
				this.icon.gotoAndStop("NO_ICON");
			}
			Imitation.FreeBitmapAll(this);
		}

		public function SetCaption(_str:String = ""):void
		{
			if (!this.caption)
			{
				return;
			}
			if (_str == "")
			{
				return;
			}
			if (this.icon)
			{
				this.icon.visible = false;
			}
			this.caption.visible = true;
			Util.SetText(this.caption, _str);
			Imitation.FreeBitmapAll(this);
		}

		private function MovieClipHasLabel(movieClip:MovieClip, labelName:String):Boolean
		{
			var label:FrameLabel = null;
			var labels:Array = movieClip.currentLabels;
			var a:Boolean = false;
			for (var i:uint = 0; i < labels.length; i++)
			{
				label = labels[i];
				if (label.name == labelName)
				{
					a = true;
					break;
				}
			}
			return a;
		}
	}
}
