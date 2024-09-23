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
		import uibase.ScrollBarMov;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol62")]
		public dynamic class NameSelectionContainer_157 extends MovieClip {
				public var BTN_NEXT:ButtonComponent;
				
				public var C_NAME:TextField;
				
				public var C_SUGG:TextField;
				
				public var C_WARNING:TextField;
				
				public var ERROR:TextField;
				
				public var ITEMS:sugitems;
				
				public var NAME:TextField;
				
				public var SB:ScrollBarMov;
				
				public var SCROLLRECT:MovieClip;
				
				public function NameSelectionContainer_157() {
						super();
						this.__setProp_BTN_NEXT_NameSelectionContainer_buttons_0();
				}
				
				internal function __setProp_BTN_NEXT_NameSelectionContainer_buttons_0() : * {
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

