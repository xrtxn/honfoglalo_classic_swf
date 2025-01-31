package uibase.components
{
	import fl.core.UIComponent;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import syscode.Modules;
	import syscode.Util;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol1280")]
	public class CommonGfx extends UIComponent
	{
		public static var livepreview:Boolean = false;

		public var mc:MovieClip = null;

		public var origbounds:Rectangle = null;

		private var $gfx:String = "???";

		public function CommonGfx()
		{
			super();
		}

		override protected function configUI():void
		{
			super.configUI();
			this.gfx = "";
		}

		public function DrawNow():void
		{
			this.draw();
		}

		override protected function draw():void
		{
			if (!this.mc)
			{
				return;
			}
			var rscale:Number = this.width / this.origbounds.width;
			var ys:Number = this.height / this.origbounds.height;
			if (ys < rscale)
			{
				rscale = ys;
			}
			this.mc.scaleX = rscale;
			this.mc.scaleY = rscale;
			this.mc.x = -this.origbounds.x * rscale;
			this.mc.y = -this.origbounds.y * rscale;
		}

		public function GetMCById(gfxid:String):MovieClip
		{
			var sclass:Class = null;
			if (gfxid != "")
			{
				try
				{
					sclass = Modules.GetClass("uibase", "gfx." + gfxid);
				}
				catch (e:Error)
				{
					trace("CommonGfx error: \"gfx." + gfxid + " not found!");
				}
			}
			if (!sclass)
			{
				try
				{
					sclass = Modules.GetClass("uibase", "gfx.invalidgfx");
				}
				catch (e:Error)
				{
				}
			}
			if (sclass)
			{
				return new sclass();
			}
			return null;
		}

		public function set gfx(gfxid:String):void
		{
			if (Boolean(this.mc) && Boolean(this.mc.parent))
			{
				this.mc.parent.removeChild(this.mc);
			}
			this.mc = null;
			this.mc = this.GetMCById(gfxid);
			Util.StopAllChildrenMov(this.mc);
			this.origbounds = this.mc.getBounds(this.mc);
			if (this.mc)
			{
				addChild(this.mc);
			}
			this.draw();
		}

		public function get gfx():String
		{
			return this.$gfx;
		}
	}
}
