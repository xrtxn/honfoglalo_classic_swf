package uibase
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import fl.motion.easing.*;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import syscode.*;

	public class LegoUniqueButton extends MovieClip
	{
		public static const DISLIKE_FRAME:uint = 1;

		public static const LIKE_FRAME:uint = 2;

		public static const TELESCOPE_FRAME:uint = 3;

		public var LABEL:TextField;

		private var clickfunction:Function = null;

		private var clickparams:Object = null;

		public var BG:MovieClip;

		public var ICON:MovieClip;

		public function LegoUniqueButton()
		{
			super();
			Util.StopAllChildrenMov(this);
		}

		public function Set(_keyframe:uint, _clickfunction:Function, _clickparams:Object = null):void
		{
			this.gotoAndStop(_keyframe);
			this.clickfunction = _clickfunction;
			this.clickparams = _clickparams;
		}

		public function SetCaption(_label:String):void
		{
			if (this.LABEL)
			{
				this.LABEL.text = _label;
			}
		}

		public function Activate():void
		{
			Imitation.AddEventClick(this, this.OnClick);
		}

		public function InActivate():void
		{
			Imitation.RemoveEvents(this);
		}

		public function Init():void
		{
			this.visible = true;
			this.alpha = 1;
			this.scaleX = this.scaleY = 1;
			this.Activate();
		}

		public function Hide():void
		{
			TweenMax.killTweensOf(this);
			this.InActivate();
			this.visible = false;
		}

		public function FadeOut():void
		{
			var self:MovieClip = null;
			self = this;
			TweenMax.to(this, 0.5, {
						"alpha": 0,
						"onComplete": function():*
						{
							self.Hide();
						}
					});
		}

		private function OnClick(e:Object):void
		{
			var self:MovieClip = null;
			self = this;
			TweenMax.to(this, 0.18, {
						"scaleX": 0.8,
						"scaleY": 0.8,
						"repeat": 2,
						"yoyo": true,
						"ease": fl.motion.easing.Linear.easeNone,
						"onComplete": function():*
						{
							self.Hide();
						}
					});
			if (this.clickfunction != null)
			{
				if (this.clickparams)
				{
					e.params = this.clickparams;
				}
				this.clickfunction(e);
			}
			this.InActivate();
		}
	}
}
