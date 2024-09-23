package {
		import adobe.utils.*;
		import components.ButtonComponent;
		import flash.accessibility.*;
		import flash.desktop.*;
		import flash.display.*;
		import flash.errors.*;
		import flash.events.*;
		import flash.external.*;
		import flash.filters.*;
		import flash.geom.*;
		import flash.globalization.*;
		import flash.media.*;
		import flash.net.*;
		import flash.net.drm.*;
		import flash.printing.*;
		import flash.profiler.*;
		import flash.sampler.*;
		import flash.sensors.*;
		import flash.system.*;
		import flash.text.*;
		import flash.text.engine.*;
		import flash.text.ime.*;
		import flash.ui.*;
		import flash.utils.*;
		import flash.xml.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol90")]
		public dynamic class InventoryTraceWin extends MovieClip {
				public var BTN:ButtonComponent;
				
				public var FIELD:TextField;
				
				public function InventoryTraceWin() {
						super();
						this.__setProp_BTN_inventorytracewin_Layer1_0();
				}
				
				internal function __setProp_BTN_inventorytracewin_Layer1_0() : * {
						try {
								this.BTN["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN.enabled = true;
						this.BTN.fontsize = "BIG";
						this.BTN.icon = "X";
						this.BTN.skin = "NORMAL";
						this.BTN.testcaption = "Test";
						this.BTN.visible = true;
						this.BTN.wordwrap = false;
						try {
								this.BTN["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

