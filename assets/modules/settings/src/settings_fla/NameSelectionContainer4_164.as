package settings_fla {
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
		
		[Embed(source="/_assets/assets.swf", symbol="symbol108")]
		public dynamic class NameSelectionContainer4_164 extends MovieClip {
				public var BTNLATER:ButtonComponent;
				
				public var BTN_NEXT:ButtonComponent;
				
				public var CONTAINER_FRIENDS:MovieClip;
				
				public var PLACE_FRIENDS:MovieClip;
				
				public function NameSelectionContainer4_164() {
						super();
						this.__setProp_BTNLATER_NameSelectionContainer4_buttons_0();
						this.__setProp_BTN_NEXT_NameSelectionContainer4_buttons_0();
				}
				
				internal function __setProp_BTNLATER_NameSelectionContainer4_buttons_0() : * {
						try {
								this.BTNLATER["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTNLATER.enabled = true;
						this.BTNLATER.fontsize = "BIG";
						this.BTNLATER.icon = "";
						this.BTNLATER.skin = "NORMAL";
						this.BTNLATER.testcaption = "Later";
						this.BTNLATER.visible = true;
						this.BTNLATER.wordwrap = false;
						try {
								this.BTNLATER["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_BTN_NEXT_NameSelectionContainer4_buttons_0() : * {
						try {
								this.BTN_NEXT["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN_NEXT.enabled = true;
						this.BTN_NEXT.fontsize = "BIG";
						this.BTN_NEXT.icon = "";
						this.BTN_NEXT.skin = "OK";
						this.BTN_NEXT.testcaption = "Next";
						this.BTN_NEXT.visible = true;
						this.BTN_NEXT.wordwrap = false;
						try {
								this.BTN_NEXT["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

