package triviador.gfx
{
	import flash.display.*;

	import uibase.components.UIBaseButtonComponent;

	[Embed(source="/modules/triviador_assets.swf", symbol="symbol1172")]
	public dynamic class GameOver_531 extends MovieClip
	{
		public var BTNCLOSEGAME:UIBaseButtonComponent;

		public function GameOver_531()
		{
			super();
			this.__setProp_BTNCLOSEGAME_GameOver_Layer1_0();
		}

		internal function __setProp_BTNCLOSEGAME_GameOver_Layer1_0():*
		{
			try
			{
				this.BTNCLOSEGAME["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.BTNCLOSEGAME.enabled = true;
			this.BTNCLOSEGAME.fontsize = "SMALL";
			this.BTNCLOSEGAME.icon = "";
			this.BTNCLOSEGAME.skin = "NORMAL";
			this.BTNCLOSEGAME.testcaption = "Back to Lobby";
			this.BTNCLOSEGAME.visible = true;
			this.BTNCLOSEGAME.wordwrap = false;
			try
			{
				this.BTNCLOSEGAME["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}
	}
}
