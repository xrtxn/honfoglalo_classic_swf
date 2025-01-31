package
{
	import flash.display.MovieClip;
	import uibase.Anim;

	public class uibase extends MovieClip
	{
		public function uibase()
		{
			super();
			trace("uibase constructor");
			var a:* = Anim;
			var i:int = 1;
			trace("uibase.constructor: " + i);
		}

		public function Init():*
		{
			trace("uibase init...");
		}
	}
}
