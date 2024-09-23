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
		
		[Embed(source="/_assets/assets.swf", symbol="symbol158")]
		public dynamic class mailbox extends MovieClip {
				public var BTNCLOSE:ButtonComponent;
				
				public var BTNDELETE:ButtonComponent;
				
				public var MASK:MovieClip;
				
				public var MESSAGE:MovieClip;
				
				public var MSGTITLE:TextField;
				
				public var NAME_CONTAINER:MovieClip;
				
				public var TIMEVALUE:TextField;
				
				public function mailbox() {
						super();
						this.__setProp_BTNDELETE_mailbox_Layer2_0();
						this.__setProp_BTNCLOSE_mailbox_Layer2_0();
				}
				
				internal function __setProp_BTNDELETE_mailbox_Layer2_0() : * {
						try {
								this.BTNDELETE["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTNDELETE.enabled = true;
						this.BTNDELETE.fontsize = "MEDIUM";
						this.BTNDELETE.icon = "";
						this.BTNDELETE.skin = "CANCEL";
						this.BTNDELETE.testcaption = "Delete";
						this.BTNDELETE.visible = true;
						this.BTNDELETE.wordwrap = false;
						try {
								this.BTNDELETE["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_BTNCLOSE_mailbox_Layer2_0() : * {
						try {
								this.BTNCLOSE["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTNCLOSE.enabled = true;
						this.BTNCLOSE.fontsize = "MEDIUM";
						this.BTNCLOSE.icon = "";
						this.BTNCLOSE.skin = "NORMAL";
						this.BTNCLOSE.testcaption = "Close";
						this.BTNCLOSE.visible = true;
						this.BTNCLOSE.wordwrap = false;
						try {
								this.BTNCLOSE["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

