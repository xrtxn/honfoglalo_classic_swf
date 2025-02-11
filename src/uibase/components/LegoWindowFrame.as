package uibase.components
{
	import fl.core.UIComponent;
	import flash.display.MovieClip;

	public class LegoWindowFrame extends UIComponent
	{
		public static var livepreview:Boolean = false;

		public var BG:MovieClip = null;

		public function LegoWindowFrame()
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
