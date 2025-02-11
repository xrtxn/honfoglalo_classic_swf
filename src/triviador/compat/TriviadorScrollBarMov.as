package triviador.compat
{
	import com.greensock.TweenMax;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.*;
	import syscode.*;
	import uibase.LegoScrollBarMov;

	[Embed(source="/modules/triviador_assets.swf", symbol="symbol1306")]
	public dynamic class TriviadorScrollBarMov extends LegoScrollBarMov
	{
		public function TriviadorScrollBarMov()
		{
			super();
			addFrameScript(0, this.frame1);
		}
	}
}
