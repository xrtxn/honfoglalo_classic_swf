package uibase.components
{
	import fl.core.UIComponent;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import syscode.Modules;
	import syscode.Util;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol1278")]
	public dynamic class ThemeLoader extends UIComponent
	{
		public static var livepreview:Boolean = false;

		public var mc:MovieClip = null;

		public var origbounds:Rectangle = null;

		private var $swf:String = "uibase";

		private var $gfx:String = "???";

		private var $theme:String = "???";

		public function ThemeLoader()
		{
			super();
		}

		override protected function configUI():void
		{
			trace("configUI");
			super.configUI();
			this.swf = "uibase";
			this.gfx = "gfx.invalidgfx";
			this.theme = "";
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

		public function GetMCById():*
		{
			if (Boolean(this.mc) && Boolean(this.mc.parent))
			{
				this.mc.parent.removeChild(this.mc);
			}
			this.mc = null;
			var sclass:Object = null;
			if (this.$gfx != "" && this.$swf != "")
			{
				try
				{
					sclass = Modules.GetClass(this.$swf, this.$gfx);
				}
				catch (e:Error)
				{
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
				this.mc = new sclass();
				Util.StopAllChildrenMov(this.mc);
				this.origbounds = this.mc.getBounds(this.mc);
			}
			if (this.mc && parent && !parent.contains(this.mc))
			{
				addChild(this.mc);
				this.draw();
			}
		}

		public function set gfx(_gfx:String):void
		{
			this.$gfx = _gfx;
			this.GetMCById();
		}

		public function set swf(_swf:String):void
		{
			this.$swf = _swf;
			this.GetMCById();
		}

		public function set theme(_theme:String):void
		{
			this.$theme = _theme;
			this.GetMCById();
		}

		public function get swf():String
		{
			return this.$swf;
		}

		public function get gfx():String
		{
			return this.$gfx;
		}

		public function get theme():String
		{
			return this.$theme;
		}
	}
}
