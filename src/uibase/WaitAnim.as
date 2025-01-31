package uibase
{
	import com.greensock.TweenMax;
	import flash.display.*;
	import flash.events.*;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol10")]
	public class WaitAnim extends MovieClip
	{
		public static var globalinstance:WaitAnim = null;

		public static var rotationspeed:Number = 0.5;

		public var ANIM:MovieClip;

		public var SHADER:MovieClip;

		public function WaitAnim()
		{
			super();
			this.visible = false;
			Aligner.SetAutoAlignFunc(this, this.OnAlign);
		}

		public static function NewInstance():WaitAnim
		{
			return new WaitAnim();
		}

		public static function ShowWaitAnim(shader:Boolean = true):void
		{
			if (WaitAnim.globalinstance == null)
			{
				WaitAnim.globalinstance = WaitAnim.NewInstance();
			}
			if (WaitAnim.globalinstance != null)
			{
				WaitAnim.globalinstance.Show();
			}
		}

		public static function HideWaitAnim():void
		{
			if (WaitAnim.globalinstance != null)
			{
				WaitAnim.globalinstance.Hide();
			}
		}

		public function Show(shader:Boolean = true):void
		{
			var idx:int = 0;
			var m:MovieClip = null;
			if (Imitation.rootmc != null)
			{
				if (this.parent == null)
				{
					Imitation.rootmc.addChild(this);
				}
				else
				{
					idx = Imitation.rootmc.getChildIndex(this);
					if (idx < Imitation.rootmc.numChildren - 1)
					{
						Imitation.rootmc.setChildIndex(this, Imitation.rootmc.numChildren - 1);
					}
				}
			}
			Imitation.AddButtonStop(this);
			Util.AddEventListener(this, Event.ENTER_FRAME, this.OnEnterFrame);
			this.ANIM.alpha = 0;
			this.ANIM.n = 0;
			TweenMax.fromTo(this.ANIM, 1, {"alpha": 0}, {"alpha": 1});
			TweenMax.fromTo(this.ANIM, int.MAX_VALUE / 60, {"n": 0}, {"n": int.MAX_VALUE});
			this.SHADER.visible = shader;
			this.visible = true;
			for (var i:* = 1; i <= this.ANIM.numChildren; i++)
			{
				m = this.ANIM["D" + i] as MovieClip;
				Imitation.SetBitmapScale(m, 1 / m.scaleX * 2);
			}
		}

		public function Hide():void
		{
			if (this.parent != null)
			{
				this.parent.removeChild(this);
			}
			Imitation.RemoveEvents(this);
			Util.RemoveEventListener(this, Event.ENTER_FRAME, this.OnEnterFrame);
			TweenMax.killTweensOf(this.ANIM);
			this.visible = false;
		}

		private function OnEnterFrame(e:Event):void
		{
			var m:MovieClip = null;
			var a:Number = NaN;
			var s:Number = NaN;
			var n:Number = Number(this.ANIM.n);
			this.ANIM.rotation = n * rotationspeed;
			for (var i:* = 1; i <= this.ANIM.numChildren; i++)
			{
				m = this.ANIM["D" + i] as MovieClip;
				a = 1;
				s = Math.sin(i / this.ANIM.numChildren * Math.PI * 2 + n / 20) / 3 + 0.8;
				m.alpha = a * Math.min(n / 60, 1);
				m.scaleX = m.scaleY = s;
			}
		}

		private function OnAlign():void
		{
			this.x = 0;
			this.y = 0;
			this.SHADER.x = 0;
			this.SHADER.y = 0;
			if (Imitation.stage)
			{
				this.SHADER.width = Imitation.stage.stageWidth;
				this.SHADER.height = Imitation.stage.stageHeight;
			}
			this.ANIM.x = this.SHADER.width / 2;
			this.ANIM.y = this.SHADER.height / 2;
		}
	}
}
