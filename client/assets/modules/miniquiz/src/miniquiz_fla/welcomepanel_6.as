package miniquiz_fla {
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
		
		[Embed(source="/_assets/assets.swf", symbol="symbol164")]
		public dynamic class welcomepanel_6 extends MovieClip {
				public var BTN_NEVER:ButtonComponent;
				
				public var BTN_PLAY:ButtonComponent;
				
				public var BTN_SKIP:ButtonComponent;
				
				public var TXT_QUESTION:TextField;
				
				public function welcomepanel_6() {
						super();
						this.__setProp_BTN_PLAY_welcomepanel_buttons_0();
						this.__setProp_BTN_SKIP_welcomepanel_buttons_0();
						this.__setProp_BTN_NEVER_welcomepanel_buttons_0();
				}
				
				internal function __setProp_BTN_PLAY_welcomepanel_buttons_0() : * {
						try {
								this.BTN_PLAY["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN_PLAY.enabled = true;
						this.BTN_PLAY.fontsize = "MEDIUM";
						this.BTN_PLAY.icon = "";
						this.BTN_PLAY.skin = "OK";
						this.BTN_PLAY.testcaption = "Play";
						this.BTN_PLAY.visible = true;
						this.BTN_PLAY.wordwrap = false;
						try {
								this.BTN_PLAY["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_BTN_SKIP_welcomepanel_buttons_0() : * {
						try {
								this.BTN_SKIP["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN_SKIP.enabled = true;
						this.BTN_SKIP.fontsize = "SMALL";
						this.BTN_SKIP.icon = "";
						this.BTN_SKIP.skin = "NORMAL";
						this.BTN_SKIP.testcaption = "Skip Today";
						this.BTN_SKIP.visible = true;
						this.BTN_SKIP.wordwrap = false;
						try {
								this.BTN_SKIP["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_BTN_NEVER_welcomepanel_buttons_0() : * {
						try {
								this.BTN_NEVER["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN_NEVER.enabled = true;
						this.BTN_NEVER.fontsize = "SMALL";
						this.BTN_NEVER.icon = "";
						this.BTN_NEVER.skin = "NORMAL";
						this.BTN_NEVER.testcaption = "Never want it";
						this.BTN_NEVER.visible = true;
						this.BTN_NEVER.wordwrap = false;
						try {
								this.BTN_NEVER["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

