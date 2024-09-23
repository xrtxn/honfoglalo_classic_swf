package profile_fla {
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
		
		[Embed(source="/_assets/assets.swf", symbol="symbol122")]
		public dynamic class UserButtons_44 extends MovieClip {
				public var BTNACCEPT:ButtonComponent;
				
				public var BTNBLOCK:ButtonComponent;
				
				public var BTNCANCELB:ButtonComponent;
				
				public var BTNCANCELP:ButtonComponent;
				
				public var BTNDENY:ButtonComponent;
				
				public var BTNINVITE:ButtonComponent;
				
				public var INFO:TextField;
				
				public var __setPropDict:Dictionary;
				
				public var __lastFrameProp:int = -1;
				
				public function UserButtons_44() {
						this.__setPropDict = new Dictionary(true);
						super();
						addEventListener(Event.FRAME_CONSTRUCTED,this.__setProp_handler,false,0,true);
				}
				
				internal function __setProp_BTNINVITE_UserButtons_Layer6_0(curFrame:int) : * {
						if(this.BTNINVITE != null && curFrame >= 1 && curFrame <= 9 && (this.__setPropDict[this.BTNINVITE] == undefined || !(int(this.__setPropDict[this.BTNINVITE]) >= 1 && int(this.__setPropDict[this.BTNINVITE]) <= 9))) {
								this.__setPropDict[this.BTNINVITE] = curFrame;
								try {
										this.BTNINVITE["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNINVITE.enabled = true;
								this.BTNINVITE.fontsize = "MEDIUM";
								this.BTNINVITE.icon = "";
								this.BTNINVITE.skin = "OK";
								this.BTNINVITE.testcaption = "Invite";
								this.BTNINVITE.visible = true;
								this.BTNINVITE.wordwrap = false;
								try {
										this.BTNINVITE["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTNBLOCK_UserButtons_Layer6_0(curFrame:int) : * {
						if(this.BTNBLOCK != null && curFrame >= 1 && curFrame <= 9 && (this.__setPropDict[this.BTNBLOCK] == undefined || !(int(this.__setPropDict[this.BTNBLOCK]) >= 1 && int(this.__setPropDict[this.BTNBLOCK]) <= 9))) {
								this.__setPropDict[this.BTNBLOCK] = curFrame;
								try {
										this.BTNBLOCK["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNBLOCK.enabled = true;
								this.BTNBLOCK.fontsize = "MEDIUM";
								this.BTNBLOCK.icon = "";
								this.BTNBLOCK.skin = "CANCEL";
								this.BTNBLOCK.testcaption = "Block";
								this.BTNBLOCK.visible = true;
								this.BTNBLOCK.wordwrap = false;
								try {
										this.BTNBLOCK["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTNACCEPT_UserButtons_Layer9_9(curFrame:int) : * {
						if(this.BTNACCEPT != null && curFrame >= 10 && curFrame <= 18 && (this.__setPropDict[this.BTNACCEPT] == undefined || !(int(this.__setPropDict[this.BTNACCEPT]) >= 10 && int(this.__setPropDict[this.BTNACCEPT]) <= 18))) {
								this.__setPropDict[this.BTNACCEPT] = curFrame;
								try {
										this.BTNACCEPT["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNACCEPT.enabled = true;
								this.BTNACCEPT.fontsize = "MEDIUM";
								this.BTNACCEPT.icon = "";
								this.BTNACCEPT.skin = "OK";
								this.BTNACCEPT.testcaption = "Accept";
								this.BTNACCEPT.visible = true;
								this.BTNACCEPT.wordwrap = false;
								try {
										this.BTNACCEPT["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTNBLOCK_UserButtons_Layer9_9(curFrame:int) : * {
						if(this.BTNBLOCK != null && curFrame >= 10 && curFrame <= 18 && (this.__setPropDict[this.BTNBLOCK] == undefined || !(int(this.__setPropDict[this.BTNBLOCK]) >= 10 && int(this.__setPropDict[this.BTNBLOCK]) <= 18))) {
								this.__setPropDict[this.BTNBLOCK] = curFrame;
								try {
										this.BTNBLOCK["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNBLOCK.enabled = true;
								this.BTNBLOCK.fontsize = "MEDIUM";
								this.BTNBLOCK.icon = "";
								this.BTNBLOCK.skin = "CANCEL";
								this.BTNBLOCK.testcaption = "Block";
								this.BTNBLOCK.visible = true;
								this.BTNBLOCK.wordwrap = false;
								try {
										this.BTNBLOCK["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTNDENY_UserButtons_Layer9_9(curFrame:int) : * {
						if(this.BTNDENY != null && curFrame >= 10 && curFrame <= 18 && (this.__setPropDict[this.BTNDENY] == undefined || !(int(this.__setPropDict[this.BTNDENY]) >= 10 && int(this.__setPropDict[this.BTNDENY]) <= 18))) {
								this.__setPropDict[this.BTNDENY] = curFrame;
								try {
										this.BTNDENY["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNDENY.enabled = true;
								this.BTNDENY.fontsize = "MEDIUM";
								this.BTNDENY.icon = "";
								this.BTNDENY.skin = "NORMAL";
								this.BTNDENY.testcaption = "Deny";
								this.BTNDENY.visible = true;
								this.BTNDENY.wordwrap = false;
								try {
										this.BTNDENY["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTNCANCELP_UserButtons_Layer7_25(curFrame:int) : * {
						if(this.BTNCANCELP != null && curFrame >= 26 && curFrame <= 33 && (this.__setPropDict[this.BTNCANCELP] == undefined || !(int(this.__setPropDict[this.BTNCANCELP]) >= 26 && int(this.__setPropDict[this.BTNCANCELP]) <= 33))) {
								this.__setPropDict[this.BTNCANCELP] = curFrame;
								try {
										this.BTNCANCELP["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNCANCELP.enabled = true;
								this.BTNCANCELP.fontsize = "MEDIUM";
								this.BTNCANCELP.icon = "";
								this.BTNCANCELP.skin = "NORMAL";
								this.BTNCANCELP.testcaption = "Cancel Invitation";
								this.BTNCANCELP.visible = true;
								this.BTNCANCELP.wordwrap = false;
								try {
										this.BTNCANCELP["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTNCANCELB_UserButtons_Layer7copy_33(curFrame:int) : * {
						if(this.BTNCANCELB != null && curFrame >= 34 && curFrame <= 44 && (this.__setPropDict[this.BTNCANCELB] == undefined || !(int(this.__setPropDict[this.BTNCANCELB]) >= 34 && int(this.__setPropDict[this.BTNCANCELB]) <= 44))) {
								this.__setPropDict[this.BTNCANCELB] = curFrame;
								try {
										this.BTNCANCELB["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNCANCELB.enabled = true;
								this.BTNCANCELB.fontsize = "MEDIUM";
								this.BTNCANCELB.icon = "";
								this.BTNCANCELB.skin = "NORMAL";
								this.BTNCANCELB.testcaption = "Cancel Block";
								this.BTNCANCELB.visible = true;
								this.BTNCANCELB.wordwrap = false;
								try {
										this.BTNCANCELB["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_handler(e:Object) : * {
						var curFrame:int = currentFrame;
						if(this.__lastFrameProp == curFrame) {
								return;
						}
						this.__lastFrameProp = curFrame;
						this.__setProp_BTNINVITE_UserButtons_Layer6_0(curFrame);
						this.__setProp_BTNBLOCK_UserButtons_Layer6_0(curFrame);
						this.__setProp_BTNACCEPT_UserButtons_Layer9_9(curFrame);
						this.__setProp_BTNBLOCK_UserButtons_Layer9_9(curFrame);
						this.__setProp_BTNDENY_UserButtons_Layer9_9(curFrame);
						this.__setProp_BTNCANCELP_UserButtons_Layer7_25(curFrame);
						this.__setProp_BTNCANCELB_UserButtons_Layer7copy_33(curFrame);
				}
		}
}

