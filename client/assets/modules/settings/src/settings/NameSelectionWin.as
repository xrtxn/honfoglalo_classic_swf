package settings {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import components.CharacterComponent;
		import flash.display.*;
		import flash.events.*;
		import flash.text.*;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol109")]
		public class NameSelectionWin extends MovieClip {
				public static var mc:NameSelectionWin = null;
				
				public static var namesug:Array = [];
				
				public static var currentpage:uint = 1;
				
				public static var foundfunnelid:String = "IM.IM1REGION";
				
				public static var countryitems:Array = [];
				
				public static var countryfirstitem:* = 1;
				
				public static var countrymaxrows:* = 1;
				
				public static var countryselected:* = null;
				
				public static var countrieslines:Object = {};
				
				public static var issuggestionsloading:Boolean = false;
				
				public static var activesuggestions:Boolean = true;
				
				public var BUBBLE:MovieClip;
				
				public var INFO:TextField;
				
				public var KING:CharacterComponent;
				
				public var PAGE:MovieClip;
				
				public var waitanim:Object = null;
				
				public var params:Object;
				
				internal var triedname:String = "";
				
				public function NameSelectionWin() {
						this.params = {};
						super();
						this.__setProp_KING_NameSelectionWindow_king_0();
				}
				
				private static function OnNameSug(jsq:Object, self:NameSelectionWin) : void {
						var s:* = undefined;
						if(!mc) {
								return;
						}
						if(NameSelectionWin.currentpage != 1) {
								return;
						}
						DBG.Trace("",jsq);
						if(jsq.error == 0) {
								NameSelectionWin.issuggestionsloading = false;
								NameSelectionWin.namesug = [];
								for each(s in jsq.data) {
										NameSelectionWin.namesug.push(s);
								}
								mc.PAGE.ITEMS.SetItems(NameSelectionWin.namesug);
								if(NameSelectionWin.namesug.length > 0 && Util.Trim(mc.PAGE.NAME.text) == "") {
										mc.SelectSuggName(NameSelectionWin.namesug[0]);
								}
								mc.PAGE.SB.visible = NameSelectionWin.namesug.length > 6;
						}
				}
				
				private static function OnQueryLoad(jsq:Object, self:Object) : void {
						if(!mc) {
								return;
						}
						mc.HideWaitAnim();
						trace("jsq.error: " + jsq.error);
						trace("jsq.data.result: " + jsq.data.result);
						if(jsq.error == 0) {
								if(jsq.data.result == "OK") {
										if(mc.params.callback) {
												mc.params.callback("SET_NAME_READY");
												mc.Hide();
												return;
										}
										NameSelectionWin.currentpage = 2;
										Extdata.SetUserData(Sys.mydata.id,jsq.data.uname,!!Sys.mydata.usecustomavatar ? Sys.mydata.customavatar : "");
										mc.DoShow();
										return;
								}
								if(jsq.data.result == "CHAR") {
										if(Boolean(self) && Boolean(self.PAGE)) {
												Lang.Set(self.PAGE.ERROR,"nameselection_error_char");
										}
								} else if(jsq.data.result == "DENY") {
										if(Boolean(self) && Boolean(self.PAGE)) {
												Lang.Set(self.PAGE.ERROR,"nameselection_error_deny");
										}
								} else if(Boolean(self) && Boolean(self.PAGE)) {
										mc.triedname = Util.StrTrim(self.PAGE.NAME.text);
										NameSelectionWin.activesuggestions = true;
										mc.LoadSuggestions();
										Lang.Set(self.PAGE.ERROR,"nameselection_error_used");
								}
						} else {
								UIBase.ShowMessage("uname_set error",jsq.error + "\n\n" + jsq.errormsg);
						}
						mc.PAGE.x = 0;
						mc.PAGE.alpha = 1;
						Imitation.EnableInput(mc.PAGE.NAME,true);
						TweenMax.from(mc.PAGE,0.3,{
								"x":30,
								"ease":Back.easeOut,
								"yoyo":true
						});
				}
				
				public function Prepare(aparams:Object) : void {
						this.params = aparams;
						this.DoShow();
				}
				
				public function Hide() : void {
						if(Boolean(this.PAGE) && Boolean(this.PAGE.NAME)) {
								Util.RemoveEventListener(this.PAGE.NAME,"change",this.OnNameChange);
						}
						WinMgr.CloseWindow(this);
				}
				
				public function AfterClose() : void {
						Util.RemoveEventListener(Imitation.rootmc,"MYDATACHANGE",this.OnMyDataChange);
				}
				
				private function ShowWaitAnim() : void {
						this.waitanim = Modules.GetClass("uibase","uibase.WaitAnim");
						this.waitanim.ShowWaitAnim(false);
				}
				
				private function HideWaitAnim() : void {
						this.waitanim.HideWaitAnim();
				}
				
				public function AfterOpen() : * {
						if(NameSelectionWin.currentpage == 1) {
								this.LoadSuggestions();
						}
				}
				
				private function DoShow() : void {
						var useinternal:Boolean = false;
						var ap:Object = null;
						this.PAGE.x = 0;
						if(!this.params.callback) {
								Util.AddEventListener(Imitation.rootmc,"MYDATACHANGE",mc.OnMyDataChange);
						}
						var tf_xa:TextFormat = new TextFormat();
						tf_xa.align = TextFormatAlign.RIGHT;
						gotoAndStop(currentpage);
						Util.StopAllChildrenMov(this.PAGE);
						TweenMax.from(this.PAGE,0.7,{
								"x":100,
								"alha":0,
								"ease":Back.easeOut
						});
						if(NameSelectionWin.currentpage == 1) {
								this.PAGE.NAME.text = "";
								this.PAGE.ERROR.text = "";
								if(Util.NumberVal(Sys.tag_mydata.NAMECHANGE) == 1) {
										Util.SetColor(this.INFO,10027008);
										this.SetKingSpeech("nameselection_info_reset");
								} else {
										Util.SetColor(this.INFO,5977371);
										this.SetKingSpeech("nameselection_info_first");
								}
								this.PAGE.BTN_NEXT.SetLang("thats_my_name");
								Lang.Set(this.PAGE.C_WARNING,"nameselection_warning");
								Lang.Set(this.PAGE.C_NAME,"display_name+:");
								Lang.Set(this.PAGE.C_SUGG,"suggestions+:");
								Util.RTLEditSetup(this.PAGE.NAME);
								this.PAGE.NAME.restrict = Config.GetNameRestrictChars();
								this.PAGE.NAME.maxChars = 12;
								Util.AddEventListener(this.PAGE.NAME,"change",this.OnNameChange);
								Imitation.stage.focus = this.PAGE.NAME;
								this.PAGE.ITEMS.Set("S",namesug,38,2,this.onSuggClick,this.onSuggDraw,this.PAGE.SCROLLRECT,this.PAGE.SB);
								this.PAGE.BTN_NEXT.AddEventClick(this.OnButtonNameNextClick);
						} else if(NameSelectionWin.currentpage == 2) {
								Util.SetColor(this.INFO,5977371);
								this.SetKingSpeech("is_this_your_face");
								this.PAGE.BTN_NEXT.SetLang("i_love_my_face");
								Lang.Set(this.PAGE.C_AVATAR,"select_your_avatar+:");
								useinternal = Config.loginsystem == "MAIL" || Config.loginsystem == "NKLA";
								if(Sys.mydata.customavatar == "") {
										ap = AvatarFactory.CreateProperties("");
										AvatarFactory.RandomizeProperties(ap,Sys.mydata.sex == 2 ? 2 : 1);
										Sys.mydata.customavatar = AvatarFactory.FormatProperties(ap);
										Sys.mydata.usecustomavatar = useinternal ? 1 : 0;
										Comm.SendCommand("SETDATA","CUSTOMAVATAR=\"" + Sys.mydata.customavatar + "\" USECUSTOMAVATAR=\"" + (!!Sys.mydata.usecustomavatar ? "1" : "0") + "\"");
								}
								this.PAGE.INTAVATAR.ShowInternalBitmap(Sys.mydata.id,Sys.mydata.customavatar);
								this.PAGE.CB_INT.CHECK.visible = Sys.mydata.usecustomavatar;
								Imitation.AddEventClick(this.PAGE.CB_INT,this.OnCbIntClick);
								if(useinternal) {
										this.PAGE.EXTAVATAR.Clear();
										this.PAGE.EXTAVATAR.visible = false;
										this.PAGE.CB_EXT.visible = false;
								} else {
										this.PAGE.EXTAVATAR.ShowUID(Sys.mydata.id);
										this.PAGE.EXTAVATAR.visible = true;
										this.PAGE.CB_EXT.CHECK.visible = !Sys.mydata.usecustomavatar;
										Imitation.AddEventClick(this.PAGE.CB_EXT,this.OnCbExtClick);
										this.PAGE.CB_EXT.visible = true;
								}
								this.PAGE.BTNCUSTOMIZE.AddEventClick(this.OnBtnCustomizeClick);
								this.PAGE.BTNCUSTOMIZE.SetLang("customize");
								this.PAGE.BTN_NEXT.AddEventClick(this.OnButtonAvatarNextClick);
						} else if(NameSelectionWin.currentpage == 3) {
								Util.SetColor(this.INFO,5977371);
								this.SetKingSpeech("which_country");
								this.PAGE.BTN_COUNTRY_DEF.SetLang("im_fighting_for+...");
								this.PAGE.BTN_NEXT.visible = false;
								this.PAGE.BTN_COUNTRY_DEF.visible = true;
								this.PAGE.BTN_NEXT.AddEventClick(this.OnButtonCountryNextClick);
								Util.AddEventListener(this.PAGE.EDSEARCH,Event.CHANGE,this.OnCountrySearchKey);
								Util.RTLEditSetup(this.PAGE.EDSEARCH);
								Util.SetText(this.PAGE.C_SEARCH,Lang.Get("name_search") + ":");
								NameSelectionWin.countryselected = {
										"id":Sys.mydata.country,
										"name":Extdata.CountryName(Sys.mydata.country)
								};
								this.PAGE.C_SEARCH.setTextFormat(tf_xa);
								this.PAGE.ITEMS.Set("CLINE",countryitems,62,1,this.OnCountryClick,this.OnCountryDraw,this.PAGE.SCROLLRECT,this.PAGE.CSB);
								this.FilterList();
						} else if(NameSelectionWin.currentpage == 4) {
								Util.SetColor(this.INFO,5977371);
								this.SetKingSpeech("spreading_the_knowledge");
								this.PAGE.BTN_NEXT.SetLang("i_count_on_them");
								Lang.Set(this.PAGE.BTNLATER.CAPTION,"later_thanks");
								this.PAGE.BTN_NEXT.AddEventClick(this.OnButtonInviteNextClick);
								this.PAGE.BTNLATER.AddEventClick(this.OnButtonInviteNextClick);
						}
						this.INFO.y = this.BUBBLE.y - this.INFO.textHeight / 2;
				}
				
				private function LoadSuggestions() : void {
						if(NameSelectionWin.currentpage > 1 || Boolean(NameSelectionWin.issuggestionsloading) || !NameSelectionWin.activesuggestions) {
								return;
						}
						NameSelectionWin.issuggestionsloading = true;
						NameSelectionWin.activesuggestions = false;
						var arr:Array = [];
						if(this.triedname != "") {
								arr.push(this.triedname);
						}
						if(Config.loginusername != "") {
								arr.push(Config.loginusername);
						}
						if(Config.userlastname != "") {
								arr.push(Config.userlastname);
						}
						if(Config.useremail != "") {
								arr.push(Config.useremail);
						}
						var sex:* = !!Sys.mydata.sex ? Sys.mydata.sex : 0;
						var obj:Object = {};
						obj.sex = sex;
						obj.name = "";
						if(Config.useremail != "") {
								obj.email = Config.useremail;
						}
						if(Config.loginusername != "") {
								obj.name += Config.loginusername;
						}
						if(Config.userlastname != "") {
								obj.name += "," + Config.userlastname;
						}
						if(this.triedname != "") {
								obj.triedname = this.triedname;
						}
						if(arr.length > 0) {
								JsQuery.Load(OnNameSug,[this],"client_namesugg.php?" + Sys.FormatGetParamsStoc({},true),{
										"data":arr.join(","),
										"sex":sex,
										"newsugg":obj
								});
						} else {
								NameSelectionWin.issuggestionsloading = false;
								namesug = [];
								this.PAGE.ITEMS.SetItems(namesug);
								this.PAGE.SB.visible = false;
						}
				}
				
				private function OnNameChange(e:*) : * {
						this.PAGE.ERROR.text = "";
				}
				
				private function SelectSuggName(name:String) : void {
						Imitation.SetRTLEditText(this.PAGE.NAME,name);
						this.PAGE.ERROR.text = "";
				}
				
				private function onSuggClick(item:*, id:*) : * {
						if(namesug[id]) {
								this.SelectSuggName(!!namesug[id] ? namesug[id] : "");
						}
				}
				
				private function onSuggDraw(item:*, id:*) : * {
						item.cacheAsBitmap = true;
						Util.SetText(item.TEXT,!!namesug[id] ? namesug[id] : "");
						Imitation.Update(item);
				}
				
				private function OnCbIntClick(e:*) : void {
						this.PAGE.CB_INT.CHECK.visible = true;
						this.PAGE.CB_EXT.CHECK.visible = false;
						Comm.SendCommand("SETDATA","CUSTOMAVATAR=\"" + Sys.mydata.customavatar + "\" USECUSTOMAVATAR=\"1\"");
				}
				
				private function OnCbExtClick(e:*) : void {
						this.PAGE.CB_INT.CHECK.visible = false;
						this.PAGE.CB_EXT.CHECK.visible = true;
						Comm.SendCommand("SETDATA","CUSTOMAVATAR=\"" + Sys.mydata.customavatar + "\" USECUSTOMAVATAR=\"0\"");
				}
				
				private function OnBtnCustomizeClick(e:*) : void {
						this.OnCbIntClick(e);
						WinMgr.OpenWindow("settings.AvatarWin",{
								"strdef":Sys.mydata.customavatar,
								"previewmc":null
						});
				}
				
				private function OnMyDataChange(e:*) : void {
						if(NameSelectionWin.mc) {
								NameSelectionWin.mc.DoShow();
						}
				}
				
				public function OnButtonNameNextClick(e:*) : void {
						var name:String = null;
						name = Util.Trim(Imitation.GetRTLEditText(this.PAGE.NAME));
						if(4 <= name.length && name.length <= 12) {
								Imitation.EnableInput(this.PAGE.NAME,false);
								TweenMax.to(this.PAGE,0.7,{
										"x":-100,
										"alpha":0,
										"ease":Back.easeOut,
										"onComplete":function():* {
												GetRanklistCountries();
												JsQuery.Load(NameSelectionWin.OnQueryLoad,[mc],"stal_data.php?stoc=" + Config.stoc,{
														"cmd":"uname_set",
														"uname":name
												});
												ShowWaitAnim();
										}
								});
						} else {
								Lang.Set(mc.PAGE.ERROR,"nameselection_error_char");
						}
				}
				
				public function OnButtonAvatarNextClick(e:*) : void {
						this.HideWaitAnim();
						TweenMax.to(this.PAGE,0.7,{
								"x":-100,
								"alpha":0,
								"ease":Back.easeOut,
								"onComplete":function():* {
										NameSelectionWin.currentpage = 3;
										DoShow();
										if(!(NameSelectionWin.countryselected.id != "--" || NameSelectionWin.countryselected.id != "")) {
												OnButtonCountryNextClick(e);
										}
								}
						});
				}
				
				public function OnButtonCountryNextClick(e:*) : void {
						if(NameSelectionWin.countryselected == null || NameSelectionWin.countryselected.id == "" || NameSelectionWin.countryselected.id == "--") {
								return;
						}
						Comm.SendCommand("SETDATA","COUNTRY=\"" + NameSelectionWin.countryselected.id + "\" SNDVOL=\"" + Sys.mydata.sndvol + "\"");
						this.Hide();
				}
				
				public function OnButtonInviteNextClick(e:*) : void {
				}
				
				public function SetKingSpeech(_langid:String, _anim:Boolean = true) : void {
						Lang.Set(this.INFO,_langid);
						if(_anim) {
								TweenMax.fromTo(this.INFO,0.3,{"alpha":0},{"alpha":1});
						}
				}
				
				public function FilterList() : void {
						var cid:String = null;
						var i:int = 0;
						var c:Object = null;
						var country:* = undefined;
						NameSelectionWin.countryfirstitem = 1;
						NameSelectionWin.countryitems = [];
						var w:* = this;
						var fstr:String = Util.UpperCase(Util.GetRTLEditText(w.PAGE.EDSEARCH));
						for(cid in Extdata.countries) {
								c = Extdata.countries[cid];
								if(Util.UpperCase(c.name).indexOf(fstr) >= 0) {
										if(c.cid != "a1" && c.cid != "a2" && (Config.siteid.charAt(0) == "x" && c.cid != "ap" || Config.siteid.charAt(0) != "x") && c.cid != "eu" && c.cid != "--") {
												country = this.GetCountry(c.cid);
												NameSelectionWin.countryitems.push({
														"id":c.cid,
														"name":c.name,
														"desc":c.description,
														"xp":(country != null ? country.XP : -1)
												});
										}
								}
						}
						NameSelectionWin.countryitems.sortOn(["xp"],[Array.DESCENDING | Array.NUMERIC]);
						for(i = 0; i < NameSelectionWin.countryitems.length; i++) {
								if(NameSelectionWin.countryitems[i].xp == -1) {
										NameSelectionWin.countryitems[i].xp = "-";
								}
						}
						NameSelectionWin.countrymaxrows = NameSelectionWin.countryitems.length;
						NameSelectionWin.countryfirstitem = 1;
						if(NameSelectionWin.countryfirstitem + 5 > NameSelectionWin.countrymaxrows) {
								NameSelectionWin.countryfirstitem = NameSelectionWin.countrymaxrows - 5;
						}
						if(NameSelectionWin.countryfirstitem < 1) {
								NameSelectionWin.countryfirstitem = 1;
						}
						if(NameSelectionWin.countryitems.length == 1) {
								NameSelectionWin.countryselected = NameSelectionWin.countryitems[0];
								this.PAGE.BTN_NEXT.visible = true;
								this.PAGE.BTN_COUNTRY_DEF.visible = false;
								this.PAGE.BTN_NEXT.SetCaption(Lang.Get("im_fighting_for") + "\n" + NameSelectionWin.countryselected.name);
						} else {
								NameSelectionWin.countryselected = {
										"id":"--",
										"name":""
								};
								this.PAGE.BTN_NEXT.visible = false;
								this.PAGE.BTN_COUNTRY_DEF.visible = true;
						}
						this.PAGE.ITEMS.SetItems(countryitems);
				}
				
				public function OnCountrySearchKey(e:Event) : void {
						this.FilterList();
				}
				
				public function OnFriendSearchKey(e:Event) : void {
				}
				
				public function GetCountry(_countryId:String) : Object {
						var id:String = null;
						for(id in NameSelectionWin.countrieslines) {
								if(NameSelectionWin.countrieslines[id].C == _countryId) {
										return NameSelectionWin.countrieslines[id];
								}
						}
						return null;
				}
				
				public function OnCountryClick(item:*, id:*) : void {
						NameSelectionWin.countryselected = NameSelectionWin.countryitems[id];
						this.PAGE.BTN_NEXT.visible = true;
						this.PAGE.BTN_COUNTRY_DEF.visible = false;
						this.PAGE.BTN_NEXT.SetCaption(Lang.Get("im_fighting_for") + "\n" + NameSelectionWin.countryselected.name);
						this.PAGE.ITEMS.Draw();
				}
				
				public function OnCountryDraw(item:*, id:*) : void {
						item.cacheAsBitmap = true;
						var tag:* = NameSelectionWin.countryitems[id];
						if(tag !== undefined) {
								Util.SetText(item.COUNTRYNAME,tag.name);
								item.XPCHANGE.text = tag.xp;
								if(item.XPCHANGE.text != "-") {
										item.XPCHANGE.text = Util.FormatNumber(Number(item.XPCHANGE.text));
								}
								if(tag == NameSelectionWin.countryselected) {
										item.gotoAndStop(3);
								}
								item.visible = true;
								Imitation.Update(item);
						} else {
								item.visible = false;
						}
						Imitation.Update(item);
				}
				
				public function GetRanklistCountries() : * {
						if(Comm.connstate < 5) {
								return;
						}
						var uri:* = Comm.httpuri + "/rlquery?type=countries&all=0&from=-1&countryid=" + Sys.mydata.country;
						trace("GetRanklistCountries..." + uri);
						MyLoader.LoadText(uri,this.ProcessRLDataCountries,this);
				}
				
				public function ProcessRLDataCountries(adata:String) : * {
						var xml:*;
						var cl:*;
						var maintag:*;
						var tag:* = undefined;
						var node:* = undefined;
						if(adata == null) {
								return;
						}
						xml = new XML("<?xml version=\"1.0\" encoding=\"utf-8\"?><ROOT>" + adata + "</ROOT>");
						cl = xml.children();
						maintag = Util.XMLTagToObject(cl[0]);
						try {
								NameSelectionWin.countrieslines = {};
								for each(node in cl) {
										tag = Util.XMLTagToObject(node);
										trace(Util.FormatTrace(tag));
										if(node.name() == "LINE") {
												NameSelectionWin.countrieslines[tag.N] = tag;
										}
								}
						}
						catch(e:*) {
								Comm.ClientTrace(111,"ProcessRLDataCountries collect error: " + e.toString());
						}
				}
				
				internal function __setProp_KING_NameSelectionWindow_king_0() : * {
						try {
								this.KING["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.KING.character = "KING";
						this.KING.enabled = true;
						this.KING.frame = 2;
						this.KING.shade = true;
						this.KING.shadow = true;
						this.KING.visible = true;
						try {
								this.KING["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

