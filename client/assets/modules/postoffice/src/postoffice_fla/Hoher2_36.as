package postoffice_fla {
		import adobe.utils.*;
		import components.CharacterComponent;
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
		
		[Embed(source="/_assets/assets.swf", symbol="symbol72")]
		public dynamic class Hoher2_36 extends MovieClip {
				public var HOHER:CharacterComponent;
				
				public var INFO:TextField;
				
				public var __setPropDict:Dictionary;
				
				public var __lastFrameProp:int = -1;
				
				public function Hoher2_36() {
						this.__setPropDict = new Dictionary(true);
						super();
						addFrameScript(3,this.frame4);
						addEventListener(Event.FRAME_CONSTRUCTED,this.__setProp_handler,false,0,true);
				}
				
				internal function __setProp_HOHER_Hoher2_Layer5_0(curFrame:int) : * {
						if(this.HOHER != null && curFrame >= 1 && curFrame <= 3 && (this.__setPropDict[this.HOHER] == undefined || !(int(this.__setPropDict[this.HOHER]) >= 1 && int(this.__setPropDict[this.HOHER]) <= 3))) {
								this.__setPropDict[this.HOHER] = curFrame;
								try {
										this.HOHER["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.HOHER.character = "INNKEEPER";
								this.HOHER.enabled = true;
								this.HOHER.frame = 1;
								this.HOHER.shade = true;
								this.HOHER.shadow = true;
								this.HOHER.visible = true;
								try {
										this.HOHER["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_HOHER_Hoher2_Layer1_3() : * {
						if(this.__setPropDict[this.HOHER] == undefined || int(this.__setPropDict[this.HOHER]) != 4) {
								this.__setPropDict[this.HOHER] = 4;
								try {
										this.HOHER["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.HOHER.character = "HEADSMAN";
								this.HOHER.enabled = true;
								this.HOHER.frame = 1;
								this.HOHER.shade = true;
								this.HOHER.shadow = true;
								this.HOHER.visible = true;
								try {
										this.HOHER["componentInspectorSetting"] = false;
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
						this.__setProp_HOHER_Hoher2_Layer5_0(curFrame);
				}
				
				internal function frame4() : * {
						this.__setProp_HOHER_Hoher2_Layer1_3();
				}
		}
}

