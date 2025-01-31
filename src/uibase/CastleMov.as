package uibase
{
	import flash.display.*;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol1450")]
	public class CastleMov extends MovieClip
	{
		public var PLACEHOLDER:MovieClip;

		public var level:int = 1;

		public var color:int = 1;

		public var towers:int = 3;

		public var mc:MovieClip;

		public function CastleMov()
		{
			super();
			removeChild(this.PLACEHOLDER);
		}

		public function Setup(alevel:int, acolor:int, atowers:int):*
		{
			var c:Class = null;
			var fm:* = undefined;
			var activecastlelevels:Array = [0, 1, 2, 3, 4, 6, 7, 10, 13, 14];
			alevel = int(activecastlelevels[alevel]);
			var changed:Boolean = alevel != this.level || acolor != this.color || atowers != this.towers;
			if (!this.mc)
			{
				changed = false;
				c = Modules.GetClass("castles", "Castles");
				if (!c)
				{
					trace("Castles not loaded!");
					return;
				}
				this.mc = new c();
				this.mc.scaleX = 1;
				this.mc.scaleY = this.mc.scaleX;
				addChild(this.mc);
			}
			Util.StopAllChildrenMov(this.mc);
			this.level = alevel;
			if (this.level < 0)
			{
				this.level = 0;
			}
			if (this.level > 14 && this.level != 20)
			{
				this.level = 14;
			}
			this.color = acolor;
			if (this.color < 1)
			{
				this.color = 1;
			}
			if (this.color > 3)
			{
				this.color = 3;
			}
			this.towers = atowers;
			if (this.towers < 0)
			{
				this.towers = 0;
			}
			if (this.towers > 3)
			{
				this.towers = 3;
			}
			var frame:* = this.level;
			if (this.level == 0)
			{
				frame = 15;
			}
			if (this.mc.currentFrame != frame)
			{
				this.mc.gotoAndStop(frame);
				this.mc.CASTLE.gotoAndStop(4 - this.towers);
			}
			else if (this.mc.CASTLE.currentFrame != 4 - this.towers)
			{
				this.mc.CASTLE.gotoAndStop(4 - this.towers);
			}
			for (var n:* = 1; n <= 3; n++)
			{
				fm = this.mc.CASTLE["FLAG" + n];
				if (fm)
				{
					fm.gotoAndStop(this.color);
				}
			}
			var g:MovieClip = MovieClip(this.parent.getChildByName("GROUND"));
			if (g)
			{
				g.gotoAndStop(this.level);
				g.visible = true;
			}
			this.mc.cacheAsBitmap = true;
			if (changed)
			{
				Imitation.FreeBitmapAll(this.mc);
			}
			Imitation.SetBitmapScale(this.mc, 1.5);
		}
	}
}
