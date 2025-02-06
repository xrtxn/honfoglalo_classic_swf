package uibase
{
	import flash.display.*;
	import syscode.*;

	public class SoldierMov extends MovieClip
	{
		public var PLACEHOLDER:MovieClip;

		public var skin:int = 1;

		public var color:int = 0;

		public var mc:MovieClip = null;

		public var COLOR:MovieClip;

		public var skincount:int = 1;

		public function SoldierMov()
		{
			super();
			removeChild(this.PLACEHOLDER);
		}

		public function Setup(askin:int, acolor:int):*
		{
			var c:Class = null;
			var changed:Boolean = askin != this.skin || acolor != this.color;
			this.skin = askin;
			this.color = acolor;
			if (!this.mc)
			{
				changed = false;
				c = Modules.GetClass("soldiers", "Soldiers");
				if (!c)
				{
					trace("Soldiers not loaded!");
					return;
				}
				this.mc = new c();
				this.mc.scaleX = 0.39;
				this.mc.scaleY = this.mc.scaleX;
				addChild(this.mc);
			}
			this.skincount = this.mc.totalFrames;
			if (this.skin < 1 || this.skin > this.skincount)
			{
				this.skin = 1;
			}
			this.mc.gotoAndStop(this.skin);
			this.mc.COLOR.gotoAndStop(this.color);
			this.mc.cacheAsBitmap = true;
			if (changed)
			{
				Imitation.FreeBitmapAll(this.mc);
			}
			Imitation.SetBitmapScale(this.mc, 1.5);
		}
	}
}
