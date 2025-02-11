package triviador.compat
{
	import flash.display.*;

	[Embed(source="/modules/triviador_assets.swf", symbol="symbol453")]
	public dynamic class phasebubblechar_420 extends MovieClip
	{
		public var CHAR:TriviadorCharacterComponent;

		public function phasebubblechar_420()
		{
			super();
			this.__setProp_CHAR_phasebubblechar_Layer1_0();
		}

		internal function __setProp_CHAR_phasebubblechar_Layer1_0():*
		{
			try
			{
				this.CHAR["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.CHAR.character = "CEREMONY_MASTER";
			this.CHAR.enabled = true;
			this.CHAR.frame = 3;
			this.CHAR.shade = true;
			this.CHAR.shadow = true;
			this.CHAR.visible = true;
			try
			{
				this.CHAR["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}
	}
}
