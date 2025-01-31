package uibase
{
	import flash.display.MovieClip;
	import syscode.Config;
	import syscode.Imitation;

	public class LegoIconset extends MovieClip
	{
		public function LegoIconset()
		{
			super();
		}

		public function Set(_name:String):void
		{
			var i:uint = 0;
			if (_name == "" || _name == null)
			{
				return;
			}
			var frameid:String = _name.toUpperCase();
			gotoAndStop(frameid);
			if (String("|tr|xa|").indexOf(Config.siteid) >= 0)
			{
				for (i = 0; i < this.currentLabels.length; i++)
				{
					if (this.currentLabels[i].name == frameid + "_TR")
					{
						gotoAndStop(frameid + "_TR");
						break;
					}
				}
			}
			Imitation.FreeBitmapAll(this);
		}
	}
}
