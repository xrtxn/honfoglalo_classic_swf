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
		
		[Embed(source="/_assets/assets.swf", symbol="symbol78")]
		public dynamic class char2_38 extends MovieClip {
				public var INFO:TextField;
				
				public var __id0_:CharacterComponent;
				
				public var __id1_:CharacterComponent;
				
				public var __setPropDict:Dictionary;
				
				public var __lastFrameProp:int = -1;
				
				public function char2_38() {
						this.__setPropDict = new Dictionary(true);
						super();
						addFrameScript(3,this.frame4);
						addEventListener(Event.FRAME_CONSTRUCTED,this.__setProp_handler,false,0,true);
				}
				
				internal function __setProp___id0__char2_Layer3_0(curFrame:int) : * {
						if(this.__id0_ != null && curFrame >= 1 && curFrame <= 3 && (this.__setPropDict[this.__id0_] == undefined || !(int(this.__setPropDict[this.__id0_]) >= 1 && int(this.__setPropDict[this.__id0_]) <= 3))) {
								this.__setPropDict[this.__id0_] = curFrame;
								try {
										this.__id0_["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.__id0_.character = "INNKEEPER";
								this.__id0_.enabled = true;
								this.__id0_.frame = 4;
								this.__id0_.shade = true;
								this.__id0_.shadow = true;
								this.__id0_.visible = true;
								try {
										this.__id0_["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp___id1__char2_Layer1_3() : * {
						if(this.__setPropDict[this.__id1_] == undefined || int(this.__setPropDict[this.__id1_]) != 4) {
								this.__setPropDict[this.__id1_] = 4;
								try {
										this.__id1_["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.__id1_.character = "HEADSMAN";
								this.__id1_.enabled = true;
								this.__id1_.frame = 1;
								this.__id1_.shade = true;
								this.__id1_.shadow = true;
								this.__id1_.visible = true;
								try {
										this.__id1_["componentInspectorSetting"] = false;
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
						this.__setProp___id0__char2_Layer3_0(curFrame);
				}
				
				internal function frame4() : * {
						this.__setProp___id1__char2_Layer1_3();
				}
		}
}

