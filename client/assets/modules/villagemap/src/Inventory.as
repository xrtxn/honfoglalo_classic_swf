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
		
		[Embed(source="/_assets/assets.swf", symbol="symbol98")]
		public dynamic class Inventory extends MovieClip {
				public var BG:MovieClip;
				
				public var MASKHOLDER:MovieClip;
				
				public var PAGELEFT:ButtonComponent;
				
				public var PAGERIGHT:ButtonComponent;
				
				public function Inventory() {
						super();
						this.__setProp_PAGELEFT_inventory_buttons_0();
						this.__setProp_PAGERIGHT_inventory_buttons_0();
				}
				
				internal function __setProp_PAGELEFT_inventory_buttons_0() : * {
						try {
								this.PAGELEFT["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.PAGELEFT.enabled = true;
						this.PAGELEFT.fontsize = "BIG";
						this.PAGELEFT.icon = "LEFT";
						this.PAGELEFT.skin = "NORMAL";
						this.PAGELEFT.testcaption = "Test";
						this.PAGELEFT.visible = true;
						this.PAGELEFT.wordwrap = false;
						try {
								this.PAGELEFT["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_PAGERIGHT_inventory_buttons_0() : * {
						try {
								this.PAGERIGHT["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.PAGERIGHT.enabled = true;
						this.PAGERIGHT.fontsize = "BIG";
						this.PAGERIGHT.icon = "RIGHT";
						this.PAGERIGHT.skin = "NORMAL";
						this.PAGERIGHT.testcaption = "Test";
						this.PAGERIGHT.visible = true;
						this.PAGERIGHT.wordwrap = false;
						try {
								this.PAGERIGHT["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

