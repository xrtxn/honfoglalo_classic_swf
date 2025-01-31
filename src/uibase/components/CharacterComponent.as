package uibase.components
{
	import com.greensock.TweenMax;
	import fl.core.UIComponent;
	import flash.display.*;
	import flash.filters.DropShadowFilter;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol86")]
	public class CharacterComponent extends UIComponent
	{
		public var mc:MovieClip;

		private var $character:String = "KING";

		private var $frame:Number = 1;

		private var $shadow:Boolean = true;

		private var $shade:Boolean = true;

		private var char:MovieClip;

		private var head:MovieClip;

		private var leg:MovieClip;

		private var hand:MovieClip;

		private var mouth:MovieClip;

		private var eyebrown:MovieClip;

		private var sanim:MovieClip;

		private var eyemasked:Boolean = false;

		private var needfirstdraw:Boolean = true;

		public function CharacterComponent()
		{
			super();
		}

		override protected function configUI():void
		{
			super.configUI();
			var cclass:Object = Modules.GetClass("characters", "Characters");
			this.mc = new cclass();
			addChild(this.mc);
			Util.StopAllChildrenMov(this.mc);
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
			var subanim:MovieClip = null;
			if (!this.mc)
			{
				return;
			}
			Util.StopAllChildrenMov(this.mc);
			this.needfirstdraw = false;
			var scale:Number = width / 280;
			var sy:Number = height / 370;
			if (sy < scale)
			{
				scale = sy;
			}
			this.mc.scaleX = this.mc.scaleY = scale;
			this.mc.x = width / 2;
			this.mc.y = height / 2;
			this.mc.gotoAndStop(this.$character);
			if (this.mc.OBJ)
			{
				this.mc.OBJ.gotoAndStop(this.$frame);
				subanim = this.mc.OBJ.SUBANIM;
				if (subanim)
				{
					subanim.stop();
				}
				if (this.$shade)
				{
					this.mc.OBJ.filters = [new DropShadowFilter(8 * scale, 45, 3342336, 0.3, 15 * scale, 15 * scale)];
				}
				else
				{
					this.mc.OBJ.filters = [];
				}
			}
			if (this.mc.SHADOW)
			{
				this.mc.SHADOW.visible = this.$shadow;
			}
			super.draw();
		}

		public function DrawNow():void
		{
			this.draw();
		}

		public function DoEmotion(emotion:String = "default"):void
		{
			if (this.MovieClipHasLabel(this.mc.OBJ, "DEFAULT"))
			{
				this.mc.OBJ.gotoAndPlay("DEFAULT");
				Imitation.CollectChildrenAll(this.char);
				this.CheckBodyParts();
				if (this.sanim)
				{
					this.sanim.play();
				}
				switch (emotion)
				{
					case "default":
						this.char.gotoAndPlay("DEFAULT");
						if (this.leg)
						{
							this.leg.gotoAndStop("DEFAULT");
						}
						if (this.eyebrown)
						{
							this.eyebrown.gotoAndPlay("DEFAULT");
						}
						if (this.hand)
						{
							this.hand.gotoAndStop(1);
						}
						break;
					case "speechStart":
						if (this.mouth)
						{
							this.mouth.gotoAndPlay("SPEECH");
						}
						if (this.leg)
						{
							this.leg.gotoAndStop("DEFAULT");
						}
						break;
					case "speechStop":
						if (this.mouth)
						{
							this.mouth.gotoAndStop("DEFAULT");
						}
						break;
					case "wait":
						if (this.leg)
						{
							this.leg.gotoAndPlay("MOVE");
						}
						if (this.eyebrown)
						{
							this.eyebrown.gotoAndPlay("MOVE");
						}
						break;
					case "showHandUp":
						if (this.hand)
						{
							this.hand.gotoAndPlay(2);
						}
						break;
					case "showHandDown":
						if (this.hand)
						{
							this.hand.gotoAndStop(1);
						}
				}
				if (this.head && this.head.EYELIDS && Boolean(this.head.EYEMASK))
				{
					this.head.EYEMASK.visible = false;
					this.head.EYELIDS.visible = false;
				}
				Imitation.CollectChildrenAll(this.char);
				Imitation.FreeBitmapAll(this.char);
				Imitation.UpdateAll(this.char);
				return;
			}
		}

		private function CheckBodyParts():void
		{
			this.char = null;
			this.head = null;
			this.leg = null;
			this.hand = null;
			this.mouth = null;
			this.eyebrown = null;
			this.sanim = null;
			this.char = MovieClip(this.mc.getChildByName("OBJ"));
			if (this.char)
			{
				this.head = MovieClip(this.char.getChildByName("HEA"));
			}
			if (this.char)
			{
				this.leg = MovieClip(this.char.getChildByName("LEG"));
			}
			if (this.char)
			{
				this.hand = MovieClip(this.char.getChildByName("HAN"));
			}
			if (this.head)
			{
				this.eyebrown = MovieClip(this.head.getChildByName("EYEBROW"));
			}
			if (this.head)
			{
				this.mouth = MovieClip(this.head.getChildByName("MOUTH"));
			}
			if (this.char)
			{
				this.sanim = MovieClip(this.char.getChildByName("SUBANIM"));
			}
		}

		public function MovieClipHasLabel(movieClip:MovieClip, labelName:String):Boolean
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

		public function set character(s:String):void
		{
			this.$character = s;
			this.draw();
		}

		public function get character():String
		{
			return this.$character;
		}

		public function set frame(n:Number):void
		{
			this.$frame = n;
			this.draw();
		}

		public function get frame():Number
		{
			return this.$frame;
		}

		public function set shade(b:Boolean):void
		{
			this.$shade = b;
			this.draw();
		}

		public function get shade():Boolean
		{
			return this.$shade;
		}

		public function set shadow(b:Boolean):void
		{
			this.$shadow = b;
			this.draw();
		}

		public function get shadow():Boolean
		{
			return this.$shadow;
		}
	}
}
