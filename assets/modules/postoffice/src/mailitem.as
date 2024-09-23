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
		import syscode.AvatarMov;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol34")]
		public dynamic class mailitem extends MovieClip {
				public var AVATAR:AvatarMov;
				
				public var BG:MovieClip;
				
				public var BTNDELETE:MovieClip;
				
				public var BTNMORE:ButtonComponent;
				
				public var HILITE:MovieClip;
				
				public var NAME:TextField;
				
				public var NAME_CONTAINER:MovieClip;
				
				public var TITLE:TextField;
				
				public var __setPropDict:Dictionary;
				
				public function mailitem() {
						this.__setPropDict = new Dictionary(true);
						super();
						addFrameScript(2,this.frame3);
				}
				
				internal function __setProp_BTNMORE_mailitem_Layer6_2() : * {
						if(this.__setPropDict[this.BTNMORE] == undefined || int(this.__setPropDict[this.BTNMORE]) != 3) {
								this.__setPropDict[this.BTNMORE] = 3;
								try {
										this.BTNMORE["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNMORE.enabled = true;
								this.BTNMORE.fontsize = "MEDIUM";
								this.BTNMORE.icon = "";
								this.BTNMORE.skin = "NORMAL";
								this.BTNMORE.testcaption = "Load More";
								this.BTNMORE.visible = true;
								this.BTNMORE.wordwrap = false;
								try {
										this.BTNMORE["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function frame3() : * {
						this.__setProp_BTNMORE_mailitem_Layer6_2();
				}
		}
}

