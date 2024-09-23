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
		import syscode.AvatarMov;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol87")]
		public dynamic class NameSelectionContainer2_162 extends MovieClip {
				public var BTNCUSTOMIZE:ButtonComponent;
				
				public var BTN_NEXT:ButtonComponent;
				
				public var C_AVATAR:TextField;
				
				public var INTAVATAR:AvatarMov;
				
				public function NameSelectionContainer2_162() {
						super();
						this.__setProp_BTNCUSTOMIZE_NameSelectionContainer2_buttons_0();
						this.__setProp_BTN_NEXT_NameSelectionContainer2_buttons_0();
				}
				
				internal function __setProp_BTNCUSTOMIZE_NameSelectionContainer2_buttons_0() : * {
						try {
								this.BTNCUSTOMIZE["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTNCUSTOMIZE.enabled = true;
						this.BTNCUSTOMIZE.fontsize = "SMALL";
						this.BTNCUSTOMIZE.icon = "";
						this.BTNCUSTOMIZE.skin = "NORMAL";
						this.BTNCUSTOMIZE.testcaption = "Customize";
						this.BTNCUSTOMIZE.visible = true;
						this.BTNCUSTOMIZE.wordwrap = false;
						try {
								this.BTNCUSTOMIZE["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_BTN_NEXT_NameSelectionContainer2_buttons_0() : * {
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

