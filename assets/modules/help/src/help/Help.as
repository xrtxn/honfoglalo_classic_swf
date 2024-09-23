package help {
		import com.greensock.*;
		import com.greensock.easing.*;
		import components.CharacterComponent;
		import flash.display.*;
		import flash.events.*;
		import flash.net.URLRequest;
		import flash.net.navigateToURL;
		import flash.text.*;
		import syscode.*;
		import uibase.ScrollBarMov9;
		import uibase.lego_button_1x1_cancel_header;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol362")]
		public class Help extends MovieClip {
				public static var mc:Help = null;
				
				public var BOUNDS:MovieClip;
				
				public var BTNCLOSE:lego_button_1x1_cancel_header;
				
				public var CONTENT:MovieClip;
				
				public var CONTENTBG:MovieClip;
				
				public var MASK:MovieClip;
				
				public var NEXTTO:MovieClip;
				
				public var SB:ScrollBarMov9;
				
				public var SPEECH:MovieClip;
				
				public var SPEECHBG:MovieClip;
				
				public var SUBTABS:MovieClip;
				
				public var TABS:HeaderTabs;
				
				public var __id0_:CharacterComponent;
				
				private var paramtab:int = 1;
				
				private var paramsubtab:int = 1;
				
				private var seenstartpage:Boolean = false;
				
				private var currenttab:int = 1;
				
				private var nexttolink:String = "";
				
				private var oy:Number;
				
				public function Help() {
						super();
						this.__setProp___id0__HelpWindow_content_0();
				}
				
				public static function Show() : void {
						if(!mc) {
						}
				}
				
				public static function Hide(e:* = null) : void {
						if(mc) {
								WinMgr.CloseWindow(mc);
						}
				}
				
				public function Prepare(aprops:Object) : void {
						var i:int;
						trace("HELP.Prepare");
						if(aprops && aprops.tab && Boolean(aprops.subtab)) {
								this.paramtab = aprops.tab;
								this.paramsubtab = aprops.subtab;
						}
						this.SB.visible = false;
						for(i = 1; i <= 15; i++) {
								this.SUBTABS["STAB" + i].AddEventClick(function(e:Object):* {
										OnSubTabClick(e.target.name.substring(4));
								});
								this.SUBTABS["STAB" + i].visible = false;
						}
						Util.SetText(this.NEXTTO.FIELD.FIELD,Lang.Get("c_help_nexttobtn_title"));
						this.NEXTTO.BTN.SetIcon("PLAY");
						this.NEXTTO.BTN.AddEventClick(function(e:Object):* {
								OnNextToClick({});
						});
						this.NEXTTO.visible = false;
						this.BTNCLOSE.AddEventClick(Hide);
						this.BTNCLOSE.SetIcon("X");
						this.TABS.Set(["c_help_tab01","c_help_tab02","c_help_tab03","c_help_tab04","c_help_tab05","c_help_tab06","c_help_tab07","c_help_tab08","c_help_tab09","c_help_tab10"],["HELP_GAMERULES","HELP_BOOSTERS","HELP_CASTLE","HELP_CLAN","HELP_CHAT","HELP_RANKLIST","HELP_GOLD","HELP_LIBRARY","HELP_POST","HELP_INFO"],this.OnLegoTabClick,this.paramtab);
				}
				
				private function OnScrolling(_pos:Number) : void {
						this.SUBTABS.y = this.MASK.y + _pos * -1;
				}
				
				public function AfterOpen() : void {
						Imitation.FreeBitmapAll(this.TABS["TTAB" + this.paramtab]);
						Imitation.UpdateAll(this.TABS["TTAB" + this.paramtab]);
						if(!this.seenstartpage && this.paramsubtab != 1) {
								this.seenstartpage = true;
								this.OnSubTabClick(this.paramsubtab);
						}
				}
				
				public function AfterClose() : void {
				}
				
				public function OnLegoTabClick(_param:Number) : * {
						var sp:String = null;
						var si:String = null;
						trace("OnLegoTabClick: " + _param);
						if(int(_param) < 10) {
								sp = "0" + _param;
						} else {
								sp = "" + _param;
						}
						this.SUBTABS.isaligned = false;
						this.SUBTABS.isfloat = false;
						this.SUBTABS.y = this.MASK.y;
						this.currenttab = _param;
						this.oy = 0;
						for(var i:int = 1; i <= 15; i++) {
								if(i < 10) {
										si = "0" + i;
								} else {
										si = "" + i;
								}
								this.SUBTABS["STAB" + i].visible = true;
								this.SUBTABS["STAB" + i].SetLang("c_help_subtab_" + sp + "_" + si);
								if(Lang.Get("c_help_subtab_" + sp + "_" + si) == "(\"" + "c_help_subtab_" + sp + "_" + si + "\")") {
										this.SUBTABS["STAB" + i].visible = false;
								} else {
										this.oy += 40;
								}
						}
						this.SPEECH.FIELD.styleSheet = new StyleSheet();
						this.SPEECH.FIELD.multiline = true;
						this.SPEECH.FIELD.htmlText = Lang.Get("c_help_speech_" + sp);
						this.OnSubTabClick(1);
						Imitation.SetMaskedMov(this.MASK,this.SUBTABS);
						Imitation.AddEventMask(this.MASK,this.SUBTABS);
						this.SB.Set(this.oy,this.MASK.height,0);
						this.SB.OnScroll = this.OnScrolling;
						this.SB.SetScrollRect(this.MASK);
						this.SB.visible = this.oy > 350;
				}
				
				public function OnSubTabClick(_param:Number) : * {
						var sp:String = null;
						var cts:String = null;
						trace("OnSubTabClick: " + _param);
						for(var i:int = 1; i <= 15; i++) {
								if(i == _param) {
										this.SUBTABS["STAB" + i].SetEnabled(false);
								} else {
										this.SUBTABS["STAB" + i].SetEnabled(true);
								}
						}
						this.CONTENT.visible = true;
						this.NEXTTO.visible = true;
						if(int(_param) < 10) {
								sp = "0" + _param;
						} else {
								sp = "" + _param;
						}
						if(int(this.currenttab) < 10) {
								cts = "0" + this.currenttab;
						} else {
								cts = "" + this.currenttab;
						}
						if(Lang.Get("c_help_content_" + cts + "_" + sp) == "(\"" + "c_help_content_" + cts + "_" + sp + "\")") {
								this.CONTENT.visible = false;
								this.NEXTTO.visible = false;
						}
						this.CONTENT.FIELD.styleSheet = new StyleSheet();
						this.CONTENT.FIELD.multiline = true;
						this.CONTENT.FIELD.htmlText = Lang.Get("c_help_content_" + cts + "_" + sp);
						if(Lang.Get("c_help_nextto_" + cts + "_" + sp) == "(\"" + "c_help_nextto_" + cts + "_" + sp + "\")") {
								this.NEXTTO.visible = false;
						} else {
								this.nexttolink = Lang.Get("c_help_nextto_" + cts + "_" + sp);
						}
				}
				
				private function OnNextToClick(e:Object) : void {
						trace("OnNextToClick: " + this.nexttolink);
						navigateToURL(new URLRequest(this.nexttolink),"_blank");
				}
				
				internal function __setProp___id0__HelpWindow_content_0() : * {
						try {
								this.__id0_["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.__id0_.character = "PROFESSOR";
						this.__id0_.enabled = true;
						this.__id0_.frame = 1;
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
}

