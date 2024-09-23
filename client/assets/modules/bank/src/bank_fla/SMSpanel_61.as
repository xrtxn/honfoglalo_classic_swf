package bank_fla {
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
		
		[Embed(source="/_assets/assets.swf", symbol="symbol511")]
		public dynamic class SMSpanel_61 extends MovieClip {
				public var BTNOK:ButtonComponent;
				
				public var ERROR:TextField;
				
				public var INFO:TextField;
				
				public var INPUT:TextField;
				
				public var PRICE:TextField;
				
				public var SEARCH:MovieClip;
				
				public var TODO:TextField;
				
				public function SMSpanel_61() {
						super();
						this.__setProp_BTNOK_SMSpanel_buttons_0();
				}
				
				internal function __setProp_BTNOK_SMSpanel_buttons_0() : * {
						try {
								this.BTNOK["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTNOK.enabled = true;
						this.BTNOK.fontsize = "BIG";
						this.BTNOK.icon = "ENTER";
						this.BTNOK.skin = "OK";
						this.BTNOK.testcaption = "ENTER";
						this.BTNOK.visible = true;
						this.BTNOK.wordwrap = false;
						try {
								this.BTNOK["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

