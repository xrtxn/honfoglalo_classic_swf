package villagemap.gfx
{
	import flash.display.*;
	import flash.utils.*;

	import uibase.components.UISerialCharComponent;

	[Embed(source="/modules/villagemap_assets.swf", symbol="symbol64")]
	public dynamic class Notification extends MovieClip
	{
		public var BUBBLE:MovieClip;

		public var __id1_:UISerialCharComponent;

		public var __setPropDict:Dictionary;

		public function Notification()
		{
			this.__setPropDict = new Dictionary(true);
			super();
			addFrameScript(8, this.frame9, 9, this.frame10, 10, this.frame11, 11, this.frame12, 12, this.frame13);
		}

		internal function __setProp___id1__notification_serial_8():*
		{
			if (this.__setPropDict[this.__id1_] == undefined || int(this.__setPropDict[this.__id1_]) != 9)
			{
				this.__setPropDict[this.__id1_] = 9;
				try
				{
					this.__id1_["componentInspectorSetting"] = true;
				}
				catch (e:Error)
				{
				}
				this.__id1_.character = "SERIAL1";
				this.__id1_.enabled = true;
				this.__id1_.frame = 1;
				this.__id1_.shade = true;
				this.__id1_.shadow = true;
				this.__id1_.visible = true;
				try
				{
					this.__id1_["componentInspectorSetting"] = false;
				}
				catch (e:Error)
				{
				}
			}
		}

		internal function __setProp___id1__notification_serial_9():*
		{
			if (this.__setPropDict[this.__id1_] == undefined || int(this.__setPropDict[this.__id1_]) != 10)
			{
				this.__setPropDict[this.__id1_] = 10;
				try
				{
					this.__id1_["componentInspectorSetting"] = true;
				}
				catch (e:Error)
				{
				}
				this.__id1_.character = "SERIAL2";
				this.__id1_.enabled = true;
				this.__id1_.frame = 1;
				this.__id1_.shade = true;
				this.__id1_.shadow = true;
				this.__id1_.visible = true;
				try
				{
					this.__id1_["componentInspectorSetting"] = false;
				}
				catch (e:Error)
				{
				}
			}
		}

		internal function __setProp___id1__notification_serial_10():*
		{
			if (this.__setPropDict[this.__id1_] == undefined || int(this.__setPropDict[this.__id1_]) != 11)
			{
				this.__setPropDict[this.__id1_] = 11;
				try
				{
					this.__id1_["componentInspectorSetting"] = true;
				}
				catch (e:Error)
				{
				}
				this.__id1_.character = "SERIAL3";
				this.__id1_.enabled = true;
				this.__id1_.frame = 1;
				this.__id1_.shade = true;
				this.__id1_.shadow = true;
				this.__id1_.visible = true;
				try
				{
					this.__id1_["componentInspectorSetting"] = false;
				}
				catch (e:Error)
				{
				}
			}
		}

		internal function __setProp___id1__notification_serial_11():*
		{
			if (this.__setPropDict[this.__id1_] == undefined || int(this.__setPropDict[this.__id1_]) != 12)
			{
				this.__setPropDict[this.__id1_] = 12;
				try
				{
					this.__id1_["componentInspectorSetting"] = true;
				}
				catch (e:Error)
				{
				}
				this.__id1_.character = "SERIAL4";
				this.__id1_.enabled = true;
				this.__id1_.frame = 1;
				this.__id1_.shade = true;
				this.__id1_.shadow = true;
				this.__id1_.visible = true;
				try
				{
					this.__id1_["componentInspectorSetting"] = false;
				}
				catch (e:Error)
				{
				}
			}
		}

		internal function __setProp___id1__notification_serial_12():*
		{
			if (this.__setPropDict[this.__id1_] == undefined || int(this.__setPropDict[this.__id1_]) != 13)
			{
				this.__setPropDict[this.__id1_] = 13;
				try
				{
					this.__id1_["componentInspectorSetting"] = true;
				}
				catch (e:Error)
				{
				}
				this.__id1_.character = "SERIAL5";
				this.__id1_.enabled = true;
				this.__id1_.frame = 1;
				this.__id1_.shade = true;
				this.__id1_.shadow = true;
				this.__id1_.visible = true;
				try
				{
					this.__id1_["componentInspectorSetting"] = false;
				}
				catch (e:Error)
				{
				}
			}
		}

		internal function frame9():*
		{
			this.__setProp___id1__notification_serial_8();
		}

		internal function frame10():*
		{
			this.__setProp___id1__notification_serial_9();
		}

		internal function frame11():*
		{
			this.__setProp___id1__notification_serial_10();
		}

		internal function frame12():*
		{
			this.__setProp___id1__notification_serial_11();
		}

		internal function frame13():*
		{
			this.__setProp___id1__notification_serial_12();
		}
	}
}
