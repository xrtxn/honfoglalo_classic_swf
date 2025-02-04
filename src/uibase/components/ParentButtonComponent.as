package uibase.components
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import fl.core.UIComponent;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import syscode.*;

	// DON'T use this class directly!
	// This class was added because of villagemap's ButtonComponent refusing to work with the other embed
	public class ParentButtonComponent extends UIComponent
	{
		public static var livepreview:Boolean = false;

		public static var FONT:Font = null;

		public static var validhandlers:Array = ["click", "mousemove", "mousedown", "mouseup", "mouseover", "mouseout"];

		public var btnenabled:Boolean = true;

		private var $skin:String = "NORMAL";

		private var $fontsize:String = "BIG";

		private var $testcaption:String = "Test";

		private var $icon:String = "";

		private var $wordwrap:Boolean = false;

		public var SHAPE:MovieClip = null;

		public var CAPTION:TextField = null;

		public var ICON:MovieClip = null;

		public var CONTAINER:Sprite = null;

		public var logfunc:Function = null;

		private var eventhandlers:Object;

		private var baseframe:String = "";

		private var needfirstdraw:Boolean = true;

		public function ParentButtonComponent()
		{
			this.eventhandlers = {};
			super();
		}

		override protected function configUI():void
		{
			var fontclass:Class = null;
			super.configUI();
			if (!FONT)
			{
				fontclass = Modules.GetClass("fonts", Config.rtl ? "aarabicafontbold" : "aabasefontbold");
				if (fontclass)
				{
					FONT = new fontclass();
				}
				else
				{
					this.Log("PANIC: fontclass not found!!!!");
				}
			}
			this.KillFocusManager();
			this.CalculateBaseFrame();
			this.CONTAINER = new Sprite();
			this.SHAPE = new ButtonShape();
			this.SHAPE.stop();
			this.CAPTION = new TextField();
			this.CAPTION.text = "no caption";
			this.CONTAINER.addChild(this.SHAPE);
			this.CONTAINER.addChild(this.CAPTION);
			addChild(this.CONTAINER);
			this.Activate();
			TweenMax.delayedCall(0, this.FirstDraw);
		}

		private function FirstDraw():void
		{
			if (this.needfirstdraw)
			{
				this.draw();
			}
		}

		override protected function draw():void
		{
			this.needfirstdraw = false;
			TweenMax.killChildTweensOf(this);
			this.DrawShape();
			this.DrawCaption();
			super.draw();
		}

		public function Log(astr:String):void
		{
			trace("[ButtonComponent] " + astr);
			if (this.logfunc != null)
			{
				this.logfunc(astr);
			}
		}

		public function DrawNow():void
		{
			this.draw();
		}

		public function SetCaption(astr:String):void
		{
			Util.SetText(this.CAPTION, astr);
			this.draw();
		}

		public function SetLang(aid:String, apar1:* = undefined, apar2:* = undefined, apar3:* = undefined, apar4:* = undefined):void
		{
			Lang.SetLang(this.CAPTION, aid, apar1, apar2, apar3, apar4);
			this.draw();
		}

		public function SetLangAndClick(aid:String, afunc:Function, aparams:Object = null):void
		{
			this.SetLang(aid);
			this.AddEventClick(afunc, aparams);
		}

		public function SetEnabled(aenabled:Boolean):void
		{
			this.btnenabled = aenabled;
			this.mouseEnabled = aenabled;
			this.draw();
		}

		private function KillFocusManager():void
		{
			if (focusManager)
			{
				focusManager.deactivate();
			}
		}

		private function DrawCaption():void
		{
			var tf:TextFormat;
			var availablewidth:Number;
			var captioncenter:Number;
			var tw:Number;
			var sheight:*;
			var color:uint = 16777215;
			var fsize:* = 28;
			if (this.$fontsize == "MEDIUM")
			{
				fsize = 24;
			}
			else if (this.$fontsize == "SMALL")
			{
				fsize = 18;
			}
			tf = new TextFormat(FONT.fontName, fsize, null, true, null, null, null, null, "center");
			availablewidth = this.SHAPE.width - 24;
			captioncenter = this.SHAPE.width / 2;
			if (this.$icon != "")
			{
				if (!this.ICON)
				{
					this.ICON = new ButtonIcon();
					this.CONTAINER.addChild(this.ICON);
				}
				try
				{
					this.ICON.gotoAndStop(this.$icon);
				}
				catch (e:Error)
				{
					ICON.gotoAndStop("UNKNOWN");
				}
				this.ICON.x = this.SHAPE.x + 16 + 12;
				this.ICON.y = this.SHAPE.y + this.SHAPE.height / 2 - 2;
				availablewidth -= 32;
				captioncenter += 16;
			}
			else if (this.ICON)
			{
				this.CONTAINER.removeChild(this.ICON);
				this.ICON = null;
			}
			if (Boolean(this.ICON) && availablewidth < 20)
			{
				this.CAPTION.visible = false;
				this.ICON.x = this.SHAPE.x + this.SHAPE.width / 2;
				this.CAPTION.width = 1;
				this.CAPTION.x = this.SHAPE.x;
				this.CAPTION.y = this.SHAPE.y;
				return;
			}
			this.CAPTION.width = availablewidth;
			this.CAPTION.scaleX = 1;
			this.CAPTION.alpha = this.btnenabled ? 1 : 0.7;
			this.CAPTION.textColor = color;
			this.CAPTION.selectable = false;
			this.CAPTION.antiAliasType = AntiAliasType.ADVANCED;
			this.CAPTION.sharpness = 0;
			this.CAPTION.thickness = 0;
			this.CAPTION.wordWrap = this.$wordwrap;
			this.CAPTION.multiline = this.$wordwrap;
			this.CAPTION.embedFonts = true;
			this.CAPTION.filters = [new DropShadowFilter(1, 45, 0, 0.7, 1.5, 1.5)];
			if (livepreview)
			{
				Util.SetText(this.CAPTION, this.testcaption);
			}
			this.CAPTION.setTextFormat(tf);
			this.CAPTION.height = this.CAPTION.textHeight + 6;
			tw = this.CAPTION.textWidth + 8;
			if (tw > availablewidth)
			{
				this.CAPTION.width = tw;
				this.CAPTION.scaleX = availablewidth / tw;
			}
			sheight = this.SHAPE.height - 4;
			this.CAPTION.x = this.SHAPE.x + captioncenter - this.CAPTION.width / 2;
			this.CAPTION.y = this.SHAPE.y + sheight / 2 - this.CAPTION.height / 2;
		}

		private function CalculateBaseFrame():void
		{
			this.baseframe = String(this.$skin).toUpperCase();
			if (width < 60)
			{
				this.baseframe += "_XS";
			}
			else if (width >= 60 && width < 90)
			{
				this.baseframe += "_S";
			}
			else if (width >= 90 && width < 130)
			{
				this.baseframe += "_M";
			}
			else if (width >= 130 && width < 200)
			{
				this.baseframe += "_L";
			}
			else if (width >= 200 && width < 220)
			{
				this.baseframe += "_EUL";
			}
			else if (width >= 220)
			{
				this.baseframe += "_XL";
			}
			if (width >= 90)
			{
				if (height >= 60)
				{
					this.baseframe += "BIG";
				}
			}
		}

		private function DrawShape():void
		{
			this.CalculateBaseFrame();
			this.SHAPE.gotoAndStop(this.baseframe + (this.btnenabled ? "" : "_DISABLED"));
			this.SHAPE.x = -this.SHAPE.width / 2;
			this.SHAPE.y = -this.SHAPE.height / 2;
			this.CONTAINER.x = -this.SHAPE.x;
			this.CONTAINER.y = -this.SHAPE.y;
		}

		public function Activate():void
		{
			if (livepreview)
			{
				return;
			}
			Imitation.AddEventMouseOver(this, this.OnRollOver);
			Imitation.AddEventMouseOut(this, this.OnRollOut);
			Imitation.AddEventMouseDown(this, this.OnMouseDown);
			Imitation.AddEventMouseUp(this, this.OnMouseUp);
			Imitation.AddEventClick(this, this.OnMouseClick);
		}

		public function InActivate():void
		{
			if (livepreview)
			{
				return;
			}
			Imitation.RemoveEvents(this);
		}

		public function ResetPos():void
		{
			this.CONTAINER.scaleX = 1;
			this.CONTAINER.scaleY = 1;
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

		private function HandleEvent(atype:String, evobj:Object):Boolean
		{
			var h:Object = this.eventhandlers[atype];
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

		public function AddEventClick(afunc:Function, aparams:Object = null):void
		{
			this.SetHandler("click", afunc, aparams);
		}

		private function OnRollOver(e:*):void
		{
			TweenMax.killChildTweensOf(this);
			this.ResetPos();
			if (!this.btnenabled)
			{
				return;
			}
			this.SHAPE.gotoAndStop(this.baseframe + "_OVER");
			this.HandleEvent("mouseover", e);
		}

		public function OnRollOut(e:*):void
		{
			TweenMax.killChildTweensOf(this);
			this.ResetPos();
			if (!this.btnenabled)
			{
				return;
			}
			this.SHAPE.gotoAndStop(this.baseframe);
			this.HandleEvent("mouseout", e);
		}

		public function PlaySound(aid:String):void
		{
			var Sounds:* = undefined;
			try
			{
				Sounds = getDefinitionByName("syscode.Sounds");
				Sounds.PlayEffect(aid, 0.04);
			}
			catch (error:Error)
			{
				trace("Sounds error ButtonComponentFace OnMouseDown");
			}
		}

		public function OnMouseDown(e:*):void
		{
			TweenMax.killChildTweensOf(this);
			if (!this.btnenabled)
			{
				return;
			}
			this.HandleEvent("mousedown", e);
			this.SHAPE.gotoAndStop(this.baseframe + "_OVER");
			this.ResetPos();
			var r:Number = 0.866;
			TweenMax.to(this.CONTAINER, 0.2, {
						"scaleX": r,
						"scaleY": r,
						"ease": Linear.easeNone
					});
			this.PlaySound("Click");
		}

		public function OnMouseUp(e:*):void
		{
			TweenMax.killChildTweensOf(this);
			if (!this.btnenabled)
			{
				return;
			}
			this.HandleEvent("mouseup", e);
			this.SHAPE.gotoAndStop(this.baseframe);
			TweenMax.to(this.CONTAINER, 0.2, {
						"scaleX": 1,
						"scaleY": 1,
						"ease": Linear.easeNone
					});
		}

		public function OnMouseClick(e:*):void
		{
			if (!this.btnenabled)
			{
				return;
			}
			this.HandleEvent("click", e);
		}

		public function set testcaption(_txt:String):void
		{
			this.$testcaption = _txt;
			this.DrawCaption();
		}

		public function get testcaption():String
		{
			return this.$testcaption;
		}

		public function set icon(_icon:String):void
		{
			this.$icon = _icon;
			this.DrawCaption();
		}

		public function get icon():String
		{
			return this.$icon;
		}

		public function set skin(_txt:String):void
		{
			this.$skin = _txt;
			this.draw();
		}

		public function get skin():String
		{
			return this.$skin;
		}

		public function set fontsize(_txt:String):void
		{
			this.$fontsize = _txt;
			this.DrawCaption();
		}

		public function get fontsize():String
		{
			return this.$fontsize;
		}

		public function set wordwrap(b:Boolean):void
		{
			this.$wordwrap = b;
			this.DrawCaption();
		}

		public function get wordwrap():Boolean
		{
			return this.$wordwrap;
		}
	}
}
