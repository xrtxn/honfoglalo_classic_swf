package triviador.compat
{
	import flash.display.*;
	import flash.text.TextField;
	import syscode.*;

	[Embed(source="/modules/triviador_assets.swf", symbol="symbol1299")]
	public class TriviadorShutdownWait extends MovieClip
	{
		public var FOOTER:TextField;

		public var HEADER:TextField;

		public var PROF:TriviadorCharacterComponent;

		public var REMAINING:TextField;

		public function TriviadorShutdownWait()
		{
			super();
			this.Draw();
			this.__setProp_PROF_Shutdownwait_prof_0();
		}

		public function Draw():void
		{
			var remaining:Number = NaN;
			var tag:Object = Sys.tag_shutdown;
			if (tag)
			{
				remaining = Math.floor(Util.NumberVal(tag.REMAINING) / 1000);
				if (remaining < 2)
				{
					remaining = 0;
				}
				Util.SetText(this.REMAINING, Util.FormatRemaining(remaining));
				Lang.Set(this.HEADER, "maintenance_header");
				Lang.Set(this.FOOTER, "maintenance_footer");
				Imitation.FreeBitmapAll(this);
				Imitation.UpdateAll(this);
			}
		}

		internal function __setProp_PROF_Shutdownwait_prof_0():*
		{
			try
			{
				this.PROF["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.PROF.character = "PROFESSOR";
			this.PROF.enabled = true;
			this.PROF.frame = 3;
			this.PROF.shade = false;
			this.PROF.shadow = true;
			this.PROF.visible = true;
			try
			{
				this.PROF["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}
	}
}
