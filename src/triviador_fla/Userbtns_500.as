package triviador_fla
{
	import flash.display.*;
	import flash.utils.*;

	import uibase.components.ButtonComponent;

	[Embed(source="/modules/triviador_assets.swf", symbol="symbol785")]
	public dynamic class Userbtns_500 extends MovieClip
	{
		public var BTNBLOCK:ButtonComponent;

		public var BTNCANCELB:ButtonComponent;

		public var BTNCANCELF:ButtonComponent;

		public var BTNFRIEND:ButtonComponent;

		public var __setPropDict:Dictionary;

		public function Userbtns_500()
		{
			this.__setPropDict = new Dictionary(true);
			super();
			addFrameScript(0, this.frame1, 1, this.frame2, 2, this.frame3);
		}

		internal function __setProp_BTNBLOCK_Userbtns_Layer1_0():*
		{
			if (this.__setPropDict[this.BTNBLOCK] == undefined || int(this.__setPropDict[this.BTNBLOCK]) != 1)
			{
				this.__setPropDict[this.BTNBLOCK] = 1;
				try
				{
					this.BTNBLOCK["componentInspectorSetting"] = true;
				}
				catch (e:Error)
				{
				}
				this.BTNBLOCK.enabled = true;
				this.BTNBLOCK.fontsize = "BIG";
				this.BTNBLOCK.icon = "";
				this.BTNBLOCK.skin = "NORMAL";
				this.BTNBLOCK.testcaption = "";
				this.BTNBLOCK.visible = true;
				this.BTNBLOCK.wordwrap = false;
				try
				{
					this.BTNBLOCK["componentInspectorSetting"] = false;
				}
				catch (e:Error)
				{
				}
			}
		}

		internal function __setProp_BTNFRIEND_Userbtns_Layer1_0():*
		{
			if (this.__setPropDict[this.BTNFRIEND] == undefined || int(this.__setPropDict[this.BTNFRIEND]) != 1)
			{
				this.__setPropDict[this.BTNFRIEND] = 1;
				try
				{
					this.BTNFRIEND["componentInspectorSetting"] = true;
				}
				catch (e:Error)
				{
				}
				this.BTNFRIEND.enabled = true;
				this.BTNFRIEND.fontsize = "BIG";
				this.BTNFRIEND.icon = "";
				this.BTNFRIEND.skin = "NORMAL";
				this.BTNFRIEND.testcaption = "";
				this.BTNFRIEND.visible = true;
				this.BTNFRIEND.wordwrap = false;
				try
				{
					this.BTNFRIEND["componentInspectorSetting"] = false;
				}
				catch (e:Error)
				{
				}
			}
		}

		internal function __setProp_BTNCANCELF_Userbtns_Layer1_1():*
		{
			if (this.__setPropDict[this.BTNCANCELF] == undefined || int(this.__setPropDict[this.BTNCANCELF]) != 2)
			{
				this.__setPropDict[this.BTNCANCELF] = 2;
				try
				{
					this.BTNCANCELF["componentInspectorSetting"] = true;
				}
				catch (e:Error)
				{
				}
				this.BTNCANCELF.enabled = true;
				this.BTNCANCELF.fontsize = "SMALL";
				this.BTNCANCELF.icon = "";
				this.BTNCANCELF.skin = "NORMAL";
				this.BTNCANCELF.testcaption = "Cancel Friendship";
				this.BTNCANCELF.visible = true;
				this.BTNCANCELF.wordwrap = false;
				try
				{
					this.BTNCANCELF["componentInspectorSetting"] = false;
				}
				catch (e:Error)
				{
				}
			}
		}

		internal function __setProp_BTNCANCELB_Userbtns_Layer1_2():*
		{
			if (this.__setPropDict[this.BTNCANCELB] == undefined || int(this.__setPropDict[this.BTNCANCELB]) != 3)
			{
				this.__setPropDict[this.BTNCANCELB] = 3;
				try
				{
					this.BTNCANCELB["componentInspectorSetting"] = true;
				}
				catch (e:Error)
				{
				}
				this.BTNCANCELB.enabled = true;
				this.BTNCANCELB.fontsize = "SMALL";
				this.BTNCANCELB.icon = "";
				this.BTNCANCELB.skin = "NORMAL";
				this.BTNCANCELB.testcaption = "Cancel Block";
				this.BTNCANCELB.visible = true;
				this.BTNCANCELB.wordwrap = false;
				try
				{
					this.BTNCANCELB["componentInspectorSetting"] = false;
				}
				catch (e:Error)
				{
				}
			}
		}

		internal function frame1():*
		{
			this.__setProp_BTNFRIEND_Userbtns_Layer1_0();
			this.__setProp_BTNBLOCK_Userbtns_Layer1_0();
		}

		internal function frame2():*
		{
			this.__setProp_BTNCANCELF_Userbtns_Layer1_1();
		}

		internal function frame3():*
		{
			this.__setProp_BTNCANCELB_Userbtns_Layer1_2();
		}
	}
}
