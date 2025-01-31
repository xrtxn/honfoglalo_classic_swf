package uibase.components
{
	import fl.core.UIComponent;
	import flash.display.MovieClip;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol398")]
	public class WindowFrame extends UIComponent
	{
		public static var livepreview:Boolean = false;

		public var BG:MovieClip = null;

		public function WindowFrame()
		{
			super();
		}

		override protected function configUI():void
		{
			super.configUI();
			this.BG = new WindowFrameGraphics();
			addChildAt(this.BG, 0);
		}
	}
}
