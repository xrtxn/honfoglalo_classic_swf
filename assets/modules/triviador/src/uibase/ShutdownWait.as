package uibase {
		import components.CharacterComponent;
		import flash.display.*;
		import flash.text.TextField;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol1299")]
		public class ShutdownWait extends MovieClip {
				public var FOOTER:TextField;
				
				public var HEADER:TextField;
				
				public var PROF:CharacterComponent;
				
				public var REMAINING:TextField;
				
				public function ShutdownWait() {
						super();
				}
				
				public function Draw() : void {
				}
				
				internal function __setProp_PROF_Shutdownwait_prof_0() : * {
						try {
								this.PROF["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.PROF.character = "PROFESSOR";
						this.PROF.enabled = true;
						this.PROF.frame = 3;
						this.PROF.shade = false;
						this.PROF.shadow = true;
						this.PROF.visible = true;
						try {
								this.PROF["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

