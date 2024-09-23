package testmodule {
		import components.ButtonComponent;
		import flash.display.MovieClip;
		import syscode.*;
		import uibase.ScrollBarMov;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol31")]
		public class TestModule extends MovieClip {
				public static var mc:TestModule = null;
				
				public var BTNCLOSE:ButtonComponent;
				
				public var BTNINVITE:ButtonComponent;
				
				public var ITEMS1:Items1;
				
				public var ITEMS2:Items2;
				
				public var SB1:ScrollBarMov;
				
				public var SB2:ScrollBarMov;
				
				public var SCROLLRECT1:MovieClip;
				
				public var SCROLLRECT2:MovieClip;
				
				private var data1:*;
				
				private var data2:*;
				
				public function TestModule() {
						super();
						this.__setProp_BTNCLOSE_TestModuleMov_frame_0();
						this.__setProp_BTNINVITE_TestModuleMov_Layer5_0();
				}
				
				public static function Show(funnelid:String = "???") : void {
						if(mc == null) {
								mc = new TestModule();
						}
						mc.DoShow(funnelid);
				}
				
				public static function Hide() : void {
						if(mc != null) {
								mc.DoHide();
								mc = null;
						}
				}
				
				public function OnCloseClicked(arg:Object) : void {
						TestModule.Hide();
				}
				
				public function DoShow(funnelid:String) : void {
						var i:*;
						Imitation.rootmc.addChild(this);
						Imitation.AddButtonStop(this);
						Aligner.SetAutoAlignFunc(this,null);
						this.BTNCLOSE.AddEventClick(this.OnCloseClicked);
						this.BTNCLOSE.SetCaption("X");
						Imitation.CollectChildrenAll();
						Modules.GetClass("uibase","uibase.List");
						this.data1 = [];
						this.data2 = [];
						for(i = 1; i < 1000; i++) {
								this.data1.push({"label":i + "..."});
								this.data2.push({"label":i + "..."});
						}
						this.ITEMS1.Set("ITEM",this.data1,this.ITEMS1.ITEM1.height + 1,2,this.OnClick1,this.Draw1,this.SCROLLRECT1,this.SB1);
						this.ITEMS2.Set("S",this.data2,this.ITEMS2.S1.height + 4,1,this.OnClick2,this.Draw2,this.SCROLLRECT2,this.SB2);
						this.BTNINVITE.AddEventClick(function():* {
								Hide();
								WinMgr.OpenWindow("invite.Invite",{"funnelid":"???"});
						});
				}
				
				public function OnClick1(item:MovieClip, id:int) : * {
						trace("clicked: ",1,id);
				}
				
				public function OnClick2(item:MovieClip, id:int) : * {
						trace("clicked: ",2,id);
				}
				
				public function Draw1(item:MovieClip, id:int) : * {
						item.cacheAsBitmap = true;
						Util.SetText(item.TEXT,!!this.data1[id] ? this.data1[id].label : "");
						Imitation.Update(item);
				}
				
				public function Draw2(item:MovieClip, id:int) : * {
						item.cacheAsBitmap = true;
						Util.SetText(item.TEXT,!!this.data1[id] ? this.data2[id].label : "");
						Imitation.Update(item);
				}
				
				public function DoHide() : void {
						Aligner.UnSetAutoAlign(this);
						Imitation.rootmc.removeChild(this);
						Imitation.DeleteEventGroup(this);
						Imitation.RemoveMask(this.SCROLLRECT1);
						Imitation.RemoveMask(this.SCROLLRECT2);
				}
				
				internal function __setProp_BTNCLOSE_TestModuleMov_frame_0() : * {
						try {
								this.BTNCLOSE["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTNCLOSE.enabled = true;
						this.BTNCLOSE.fontsize = "BIG";
						this.BTNCLOSE.icon = "";
						this.BTNCLOSE.skin = "CANCEL";
						this.BTNCLOSE.testcaption = "X";
						this.BTNCLOSE.visible = true;
						this.BTNCLOSE.wordwrap = false;
						try {
								this.BTNCLOSE["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_BTNINVITE_TestModuleMov_Layer5_0() : * {
						try {
								this.BTNINVITE["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTNINVITE.enabled = true;
						this.BTNINVITE.fontsize = "MEDIUM";
						this.BTNINVITE.icon = "";
						this.BTNINVITE.skin = "NORMAL";
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
}

