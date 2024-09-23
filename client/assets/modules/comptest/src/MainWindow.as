package {
		import components.ButtonComponent;
		import components.CharacterComponent;
		import flash.display.MovieClip;
		import flash.text.TextField;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol9")]
		public class MainWindow extends MovieClip {
				public static var mc:MainWindow;
				
				public var BTN1:ButtonComponent;
				
				public var BTN2:ButtonComponent;
				
				public var BTN3:ButtonComponent;
				
				public var TITLE:TextField;
				
				public var __id1_:CharacterComponent;
				
				public function MainWindow() {
						super();
						this.__setProp___id1__MainWindow_character_0();
						this.__setProp_BTN1_MainWindow_button_0();
						this.__setProp_BTN2_MainWindow_button_0();
						this.__setProp_BTN3_MainWindow_button_0();
				}
				
				public static function Show() : * {
						mc = new MainWindow();
						Imitation.AddEventGroup(mc);
						mc.DoShow();
						Aligner.SetAutoAlign(mc);
						Imitation.rootmc.addChild(mc);
				}
				
				public function DoShow() : * {
						this.TITLE.text = "qqcs";
						this.BTN1.SetLang("ok");
						this.BTN2.SetCaption("valami caption");
						this.BTN3.SetCaption("continue");
						this.BTN1.AddEventClick(this.OnClick,{"value":1});
						this.BTN2.AddEventClick(this.OnClick,{"value":2});
						this.BTN3.AddEventClick(this.OnClick,{"value":3});
				}
				
				public function OnClick(e:*) : * {
						trace("OnClick: value=" + e.params.value);
						UIBase.ShowMessage("Message","Button clicked. Value=" + e.params.value);
				}
				
				internal function __setProp___id1__MainWindow_character_0() : * {
						try {
								this.__id1_["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.__id1_.character = "PET_MERCHANT";
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
				
				internal function __setProp_BTN1_MainWindow_button_0() : * {
						try {
								this.BTN1["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN1.enabled = true;
						this.BTN1.fontsize = "MEDIUM";
						this.BTN1.icon = "";
						this.BTN1.skin = "CANCEL";
						this.BTN1.testcaption = "Test";
						this.BTN1.visible = true;
						this.BTN1.wordwrap = false;
						try {
								this.BTN1["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_BTN2_MainWindow_button_0() : * {
						try {
								this.BTN2["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN2.enabled = true;
						this.BTN2.fontsize = "BIG";
						this.BTN2.icon = "";
						this.BTN2.skin = "OK";
						this.BTN2.testcaption = "Test caption";
						this.BTN2.visible = true;
						this.BTN2.wordwrap = false;
						try {
								this.BTN2["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_BTN3_MainWindow_button_0() : * {
						try {
								this.BTN3["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN3.enabled = true;
						this.BTN3.fontsize = "SMALL";
						this.BTN3.icon = "";
						this.BTN3.skin = "NORMAL";
						this.BTN3.testcaption = "Test caption";
						this.BTN3.visible = true;
						this.BTN3.wordwrap = false;
						try {
								this.BTN3["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

