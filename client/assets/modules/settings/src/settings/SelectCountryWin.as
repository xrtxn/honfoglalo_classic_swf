package settings {
		import components.ButtonComponent;
		import flash.display.*;
		import flash.events.*;
		import flash.text.*;
		import syscode.*;
		import uibase.CountryFlagMov;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol34")]
		public class SelectCountryWin extends MovieClip {
				public static var mc:SelectCountryWin = null;
				
				public var BTNCANCEL:ButtonComponent;
				
				public var BTNOK:ButtonComponent;
				
				public var BTNPGDN:MovieClip;
				
				public var BTNPGUP:MovieClip;
				
				public var C_SEARCH:TextField;
				
				public var C_SELECTION:TextField;
				
				public var EDSEARCH:TextField;
				
				public var LIST:MovieClip;
				
				public var PAGENUM:TextField;
				
				public var SFLAG:CountryFlagMov;
				
				public var SID:TextField;
				
				public var SNAME:TextField;
				
				public var TITLE:TextField;
				
				public var items:Array;
				
				public var firstitem:* = 1;
				
				public var itemsperpage:* = 16;
				
				public var selected:* = null;
				
				public var waitanim:Object = null;
				
				public var params:Object;
				
				public function SelectCountryWin() {
						this.items = [];
						this.params = {};
						super();
						this.__setProp_BTNOK_SelectCountryWindow_search_0();
						this.__setProp_BTNCANCEL_SelectCountryWindow_search_0();
				}
				
				public function Prepare(aparams:Object) : void {
						var line:* = undefined;
						this.params = aparams;
						Util.StopAllChildrenMov(this);
						this.EDSEARCH.text = "";
						this.BTNCANCEL.AddEventClick(this.OnCancelClick);
						this.BTNCANCEL.SetLang("cancel");
						if(this.params.callback != undefined || this.params.callback != null) {
								this.BTNCANCEL.SetEnabled(false);
						}
						this.BTNOK.AddEventClick(this.OnOKClick);
						this.BTNOK.SetLang("ok");
						this.BTNPGUP.BUTTON.AddEventClick(this.OnPgUpClick);
						this.BTNPGUP.BUTTON.SetCaption("");
						this.BTNPGDN.BUTTON.AddEventClick(this.OnPgDnClick);
						this.BTNPGDN.BUTTON.SetCaption("");
						Util.AddEventListener(this.EDSEARCH,"change",this.OnSearchKey);
						for(var n:* = 1; n <= this.itemsperpage; n++) {
								line = this.LIST["LINE" + n];
								Util.RTLSwap("COUNTRYLINE" + n,line.NAME,line.ID);
								if(n <= this.itemsperpage / 2) {
										Util.RTLSwap("COUNTRYLAYOUT" + n,this.LIST["LINE" + n],this.LIST["LINE" + (n + this.itemsperpage / 2)]);
								}
						}
						Util.RTLSwap("COUNTRYSEARCH",this.C_SEARCH,this.EDSEARCH);
						Util.RTLEditSetup(this.EDSEARCH);
						Lang.Set(this.TITLE,"select_your_country");
						Util.SetText(this.C_SEARCH,Lang.Get("name_search") + ":");
						Util.SetText(this.C_SELECTION,Lang.Get("current_selection") + ":");
						this.selected = {
								"id":Sys.mydata.country,
								"name":Extdata.CountryName(Sys.mydata.country)
						};
						this.FilterList();
						this.DrawList();
						this.DrawSelected();
						this.waitanim = Modules.GetClass("uibase","uibase.WaitAnim");
						this.waitanim.HideWaitAnim();
						Imitation.stage.focus = this.EDSEARCH;
				}
				
				public function Hide() : * {
						if(this.EDSEARCH) {
								Util.RemoveEventListener(this.EDSEARCH,"change",this.OnSearchKey);
						}
						WinMgr.CloseWindow(this);
				}
				
				public function DrawList() : * {
						var n:* = undefined;
						var line:* = undefined;
						var f:* = undefined;
						var w:* = this;
						for(n = 1; n <= this.itemsperpage; n++) {
								line = w.LIST["LINE" + n];
								f = this.items[this.firstitem + n - 2];
								if(f !== undefined) {
										Util.SetText(line.NAME,f.name);
										line.ID.text = f.id;
										line.ID.visible = false;
										Imitation.AddEventClick(line.BTN,this.OnFriendClick);
										Imitation.AddEventMouseOver(line.BTN,this.OnLineMouseOver);
										Imitation.AddEventMouseOut(line.BTN,this.OnLineMouseOut);
										line.HILITE.visible = false;
										if(f.desc !== undefined && f.desc != null && Util.StringVal(f.desc).length > 0) {
										}
										line.visible = true;
								} else {
										line.visible = false;
								}
						}
						var maxpages:* = Math.ceil(this.items.length / this.itemsperpage);
						var curpage:* = 1 + Math.floor((this.firstitem - 1) / this.itemsperpage);
						w.BTNPGUP.visible = curpage > 1;
						w.BTNPGDN.visible = curpage < maxpages;
						Lang.Set(w.PAGENUM,"page_n_of_m",curpage,maxpages);
						w.LIST.visible = true;
						Imitation.Update(w);
				}
				
				public function FilterList() : * {
						var w:*;
						var fstr:String;
						var cid:String = null;
						var c:Object = null;
						var cname:String = null;
						var cdesc:String = null;
						this.firstitem = 1;
						this.items = [];
						w = this;
						fstr = Util.UpperCase(Util.GetRTLEditText(w.EDSEARCH));
						for(cid in Extdata.countries) {
								c = Extdata.countries[cid];
								cname = c.name;
								cdesc = c.description;
								if(Util.UpperCase(cname).indexOf(fstr) >= 0) {
										if(cid != "a1" && cid != "a2" && (Config.siteid.charAt(0) == "x" && cid != "ap" || Config.siteid.charAt(0) != "x") && cid != "eu" && cid != "--") {
												this.items.push({
														"id":cid,
														"name":cname,
														"desc":cdesc
												});
										}
								}
						}
						this.items.sort(function(a:*, b:*):* {
								return a.name.localeCompare(b.name);
						});
				}
				
				public function DrawSelected() : * {
						if(this.selected != null) {
								Util.SetText(this.SNAME,this.selected.name);
								this.SID.text = this.selected.id;
								this.SFLAG.Set(this.selected.id);
						} else {
								this.SNAME.text = "";
								this.SID.text = "";
								this.SFLAG.Clear();
						}
						this.SID.visible = false;
				}
				
				public function OnFriendClick(e:*) : * {
						var n:* = Util.IdFromStringEnd(e.target.parent.name);
						this.selected = this.items[n + this.firstitem - 2];
						this.DrawSelected();
				}
				
				public function OnLineMouseOver(e:*) : * {
						e.target.parent.HILITE.visible = true;
				}
				
				public function OnLineMouseOut(e:*) : * {
						e.target.parent.HILITE.visible = false;
				}
				
				public function OnPgUpClick(e:*) : * {
						this.firstitem -= this.itemsperpage;
						if(this.firstitem < 1) {
								this.firstitem = 1;
						}
						this.DrawList();
				}
				
				public function OnSearchKey(e:*) : * {
						this.FilterList();
						this.DrawList();
				}
				
				public function OnPgDnClick(e:*) : * {
						this.firstitem += this.itemsperpage;
						this.DrawList();
				}
				
				public function OnCancelClick(e:*) : * {
						this.Hide();
				}
				
				public function OnOKClick(e:*) : * {
						if(this.selected == null || this.selected.id == "") {
								return;
						}
						trace("selected.id: " + this.selected.id);
						Comm.SendCommand("SETDATA","COUNTRY=\"" + this.selected.id + "\" SNDVOL=\"" + Sys.mydata.sndvol + "\"");
						trace("Setting country done.");
						if(this.params.callback) {
								trace("calling country callback:");
								this.params.callback("SET_COUNTRY_READY");
						}
						this.Hide();
				}
				
				internal function __setProp_BTNOK_SelectCountryWindow_search_0() : * {
						try {
								this.BTNOK["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTNOK.enabled = true;
						this.BTNOK.fontsize = "BIG";
						this.BTNOK.icon = "";
						this.BTNOK.skin = "OK";
						this.BTNOK.testcaption = "OK";
						this.BTNOK.visible = true;
						this.BTNOK.wordwrap = false;
						try {
								this.BTNOK["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_BTNCANCEL_SelectCountryWindow_search_0() : * {
						try {
								this.BTNCANCEL["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTNCANCEL.enabled = true;
						this.BTNCANCEL.fontsize = "BIG";
						this.BTNCANCEL.icon = "";
						this.BTNCANCEL.skin = "CANCEL";
						this.BTNCANCEL.testcaption = "Cancel";
						this.BTNCANCEL.visible = true;
						this.BTNCANCEL.wordwrap = false;
						try {
								this.BTNCANCEL["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

