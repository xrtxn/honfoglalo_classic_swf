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
		
		[Embed(source="/_assets/assets.swf", symbol="symbol104")]
		public dynamic class NameSelectionContainer3_163 extends MovieClip {
				public var BTN_COUNTRY_DEF:ButtonComponent;
				
				public var BTN_NEXT:ButtonComponent;
				
				public var CSB:ScrollBarMov;
				
				public var C_SEARCH:TextField;
				
				public var EDSEARCH:TextField;
				
				public var ITEMS:CountryItems;
				
				public var SCROLLRECT:MovieClip;
				
				public function NameSelectionContainer3_163() {
						super();
						this.__setProp_BTN_NEXT_NameSelectionContainer3_buttons_0();
						this.__setProp_BTN_COUNTRY_DEF_NameSelectionContainer3_buttons_0();
				}
				
				internal function __setProp_BTN_NEXT_NameSelectionContainer3_buttons_0() : * {
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
				
				internal function __setProp_BTN_COUNTRY_DEF_NameSelectionContainer3_buttons_0() : * {
						try {
								this.BTN_COUNTRY_DEF["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN_COUNTRY_DEF.enabled = true;
						this.BTN_COUNTRY_DEF.fontsize = "BIG";
						this.BTN_COUNTRY_DEF.icon = "";
						this.BTN_COUNTRY_DEF.skin = "NORMAL";
						this.BTN_COUNTRY_DEF.testcaption = "I\'m fighting for...";
						this.BTN_COUNTRY_DEF.visible = true;
						this.BTN_COUNTRY_DEF.wordwrap = false;
						try {
								this.BTN_COUNTRY_DEF["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

