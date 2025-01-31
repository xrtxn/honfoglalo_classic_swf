package uibase
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol1266")]
	public class ConnectWait extends MovieClip
	{
		public static var mc:ConnectWait = null;

		public static var mini:Boolean = false;

		public var ANIM:MovieClip;

		public var CAPTION:TextField;

		public var SHADER:MovieClip;

		public function ConnectWait()
		{
			super();
		}

		public static function Show():void
		{
			if (mc)
			{
				return;
			}
			mc = new ConnectWait();
			Imitation.AddButtonStop(mc);
			mc.DoShow();
			Aligner.SetAutoAlignFunc(mc, mc.OnAlign);
			Imitation.rootmc.addChild(mc);
			mc.ANIM.stop();
		}

		public static function Hide():void
		{
			if (!mc)
			{
				return;
			}
			Imitation.DeleteEventGroup(mc);
			Aligner.UnSetAutoAlign(mc);
			TweenMax.killTweensOf(mc.ANIM);
			if (Boolean(mc.parent) && mc.parent.contains(mc))
			{
				mc.parent.removeChild(mc);
			}
			mc = null;
		}

		public function DoShow():void
		{
			Lang.Set(this.CAPTION, "connecting_wait");
			mini = true;
			this.OnAlign();
			Imitation.AddEventClick(this.SHADER, this.OnClick);
			if (!TweenMax.isTweening(this.ANIM))
			{
				TweenMax.fromTo(this.ANIM, this.ANIM.totalFrames / 30, {"frame": 1}, {
							"frame": this.ANIM.totalFrames,
							"ease": Linear.easeNone,
							"repeat": -1
						});
			}
		}

		public function OnClick(e:*):*
		{
			mini = false;
			this.OnAlign();
			Imitation.RemoveEvents(this.SHADER);
		}

		public function OnAlign():void
		{
			if (!Imitation.stage)
			{
				return;
			}
			this.SHADER.width = Imitation.stage.stageWidth;
			this.SHADER.height = Imitation.stage.stageHeight;
			this.SHADER.left = 0;
			this.SHADER.top = 0;
			this.CAPTION.x = this.SHADER.width / 2 - this.CAPTION.width / 2;
			this.CAPTION.y = this.SHADER.height / 2 - this.CAPTION.height / 2;
			if (mini)
			{
				this.ANIM.x = this.SHADER.width - 100;
				this.ANIM.y = 50;
				this.ANIM.scaleX = 0.33;
				this.ANIM.scaleY = 0.33;
				this.ANIM.INSHADER.visible = true;
				this.CAPTION.visible = false;
				this.SHADER.alpha = 0;
			}
			else
			{
				this.ANIM.x = this.SHADER.width / 2;
				this.ANIM.y = this.CAPTION.y + 100;
				this.ANIM.scaleX = 0.75;
				this.ANIM.scaleY = 0.75;
				this.ANIM.INSHADER.visible = false;
				this.CAPTION.visible = true;
				this.SHADER.alpha = 1;
			}
			Imitation.CollectChildrenAll(this);
			Imitation.FreeBitmapAll(this.ANIM);
			Imitation.UpdateAll(this.ANIM);
		}
	}
}
