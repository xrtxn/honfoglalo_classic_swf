package settings {
		import com.greensock.TweenMax;
		import flash.display.*;
		import flash.events.*;
		import flash.geom.Rectangle;
		import flash.text.*;
		import syscode.*;
		import uibase.lego_button_1x1_cancel_header;
		import uibase.lego_button_1x1_ok;
		import uibase.lego_button_triangle_normal_left;
		import uibase.lego_button_triangle_normal_right;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol744")]
		public class AvatarWin extends MovieClip {
				private static var original_properties:Object;
				
				public static var last_triedname:String;
				
				public static var mc:AvatarWin = null;
				
				public static var oy:Number = 0;
				
				public static const INACTIV_BUTTON_ALPHA:Number = 0.5;
				
				public static var propnames:Array = ["HEAD","NOSE","HAIR","EAR","MOUTH","EYE","FACIAL","BACK"];
				
				public static var coloredprops:Array = ["BACK","HEAD","HAIR","EYE","FACIAL"];
				
				public static var issuggestionsloading:Boolean = false;
				
				public static var namesug:Array = [];
				
				public static var namesug_timeout:Number = 30;
				
				public var AVATAR:AvatarMov;
				
				public var AVATAR_EDITOR_BUTTON:MovieClip;
				
				public var BACK:MovieClip;
				
				public var BTNAVATAR:MovieClip;
				
				public var BTNCLOSE:lego_button_1x1_cancel_header;
				
				public var C1:MovieClip;
				
				public var C10:MovieClip;
				
				public var C11:MovieClip;
				
				public var C12:MovieClip;
				
				public var C13:MovieClip;
				
				public var C14:MovieClip;
				
				public var C15:MovieClip;
				
				public var C2:MovieClip;
				
				public var C3:MovieClip;
				
				public var C4:MovieClip;
				
				public var C5:MovieClip;
				
				public var C6:MovieClip;
				
				public var C7:MovieClip;
				
				public var C8:MovieClip;
				
				public var C9:MovieClip;
				
				public var CB_CUSTOM:CheckBox;
				
				public var CHAR:MovieClip;
				
				public var CHECK_3:CheckBox;
				
				public var CONFIRM_BTN:lego_button_1x1_ok;
				
				public var C_NAME:MovieClip;
				
				public var C_REG_1:MovieClip;
				
				public var C_REG_2:MovieClip;
				
				public var C_REG_3:MovieClip;
				
				public var EDITOR_BG:MovieClip;
				
				public var FBAVATAR:AvatarMov;
				
				public var FBAVATARFRAME:MovieClip;
				
				public var FEMALE_BTN:lego_button_triangle_normal_left;
				
				public var INPUT_REGEMAIL:MovieClip;
				
				public var ITEMS:SelectableItemsList;
				
				public var MALE_BTN:lego_button_triangle_normal_right;
				
				public var NAME_BG:MovieClip;
				
				public var NAME_DESC:MovieClip;
				
				public var NAME_ICON:MovieClip;
				
				public var PASS:MovieClip;
				
				public var RECOMMENDED1:MovieClip;
				
				public var RECOMMENDED2:MovieClip;
				
				public var RECOMMENDED3:MovieClip;
				
				public var SNAME:MovieClip;
				
				public var TAB1:MovieClip;
				
				public var TAB2:MovieClip;
				
				public var TAB3:MovieClip;
				
				public var TAB4:MovieClip;
				
				public var TAB5:MovieClip;
				
				public var TAB6:MovieClip;
				
				public var TAB7:MovieClip;
				
				public var TAB8:MovieClip;
				
				public var TXT_NEWSLETTER:MovieClip;
				
				public var WRONG_NAME:MovieClip;
				
				public var params:Object;
				
				public var sex:int = 1;
				
				public var my:Number = 0;
				
				public var previewmc:MovieClip = null;
				
				public var properties:Object = null;
				
				public var avatarmc:MovieClip = null;
				
				public var avatarmembers:Object;
				
				public var current_prop:String = "HEAD";
				
				public var guiddata:Object;
				
				public function AvatarWin() {
						this.params = {};
						this.avatarmembers = {};
						super();
				}
				
				public static function DrawScreen() : * {
				}
				
				private static function OnNameSug(jsq:Object, self:AvatarWin) : void {
						var tn:String = null;
						var s:* = undefined;
						var ss:* = undefined;
						var i:int = 0;
						var obj:MovieClip = null;
						DBG.Trace("OnNameSug",jsq);
						AvatarWin.issuggestionsloading = false;
						if(!mc) {
								return;
						}
						AvatarWin.namesug = [];
						for each(s in jsq.data) {
								AvatarWin.namesug.push(s);
						}
						if(AvatarWin.namesug.length == 1) {
								tn = "free";
						} else {
								tn = "busy";
						}
						if(jsq.tried_name != undefined) {
								tn = jsq.tried_name;
						}
						if(tn == "free") {
								mc.NAME_ICON.visible = true;
								Imitation.GotoFrame(mc.NAME_ICON,1);
								mc.CONFIRM_BTN.SetEnabled(true);
								return;
						}
						if(tn == "busy") {
								mc.NAME_ICON.visible = true;
								Imitation.GotoFrame(mc.NAME_ICON,2);
								mc.CONFIRM_BTN.SetEnabled(false);
						}
						if(jsq.error == 0) {
								AvatarWin.namesug = [];
								for each(ss in jsq.data) {
										AvatarWin.namesug.push(ss);
								}
								for(i = 0; i < AvatarWin.namesug.length; i++) {
										if(i < 3) {
												obj = mc["RECOMMENDED" + (i + 1)];
												obj.FIELD.FIELD.text = AvatarWin.namesug[i];
												obj.visible = true;
										}
								}
						}
						Util.SetText(mc.NAME_DESC.FIELD,Lang.get("avatarwin_txt_7"));
						if(mc.NAME_DESC.FIELD.numLines == 1) {
								mc.NAME_DESC.FIELD.text = "\n\n" + mc.NAME_DESC.FIELD.text;
						}
						if(mc.NAME_DESC.FIELD.numLines == 2) {
								mc.NAME_DESC.FIELD.text = "\n" + mc.NAME_DESC.FIELD.text;
						}
						if(jsq.timeout != undefined) {
								namesug_timeout = Number(jsq.timeout);
						}
						TweenMax.killTweensOf(mc.HideRecommendedLines);
						TweenMax.delayedCall(namesug_timeout,mc.HideRecommendedLines);
				}
				
				public function Prepare(aparams:Object) : * {
						this.params = aparams;
						trace("params.strdef: " + this.params.strdef);
						this.DoShow(this.params.strdef,this.params.previewmc);
						trace("Config.loginemail: " + Config.loginemail);
						trace("Config.loginpassword: " + Config.loginpassword);
						this.guiddata = Platform.LoadPersistentData("guid");
				}
				
				public function AfterOpen() : void {
						this.HideFBAvatar();
				}
				
				public function CanClose() : Boolean {
						return this.BTNCLOSE.visible;
				}
				
				public function Hide(e:* = null) : * {
						if(!mc) {
								return;
						}
						if(mc.params.callback) {
								mc.params.callback("SET_NAME_READY");
						}
						if(mc.SNAME) {
								Util.RemoveEventListener(mc.SNAME.FIELD,Event.CHANGE,this.OnSNameChange);
						}
						if(this.avatarmc) {
								TweenMax.killTweensOf(this.avatarmc);
								TweenMax.killChildTweensOf(this.avatarmc);
								if(Boolean(mc.AVATAR) && mc.AVATAR.contains(this.avatarmc)) {
										mc.AVATAR.removeChild(this.avatarmc);
								}
								this.avatarmc = null;
								this.params = {};
								this.avatarmembers = {};
						}
						if(mc.FBAVATAR) {
								mc.FBAVATAR.Clear();
						}
						WinMgr.CloseWindow(this);
						mc = null;
				}
				
				public function DoShow(astrdef:String, apreviewmc:MovieClip) : * {
						var i:int = 0;
						this.previewmc = apreviewmc;
						Imitation.ChangeParent(this,Imitation.rootmc);
						Imitation.CollectChildrenAll();
						Imitation.AddButtonStop(this);
						Util.StopAllChildrenMov(this);
						Aligner.SetAutoAlignFunc(this,null);
						mc.BTNCLOSE.AddEventClick(this.Hide);
						mc.BTNCLOSE.SetIcon("X");
						this.properties = AvatarFactory.CreateProperties(!!astrdef ? astrdef : "");
						original_properties = AvatarFactory.CloneProperties(this.properties);
						this.CONFIRM_BTN.SetIcon("PLAY");
						this.CONFIRM_BTN.AddEventClick(this.ConfirmClick);
						this.MALE_BTN.SetIcon("MALE");
						this.FEMALE_BTN.SetIcon("FEMALE");
						Imitation.AddEventClick(this.FEMALE_BTN,this.SetSex);
						Imitation.AddEventClick(this.MALE_BTN,this.SetSex);
						for(i = 1; i <= 8; i++) {
								if(i == 7) {
										Imitation.GotoFrame(mc.TAB7.ICON,this.properties.sex == 1 ? "AVATAR_PROP7_1" : "AVATAR_PROP7_2");
								} else {
										Imitation.GotoFrame(mc["TAB" + i].ICON,"AVATAR_PROP" + i);
								}
						}
						for(i = 1; i <= 8; i++) {
								mc["TAB" + i].prop = propnames[i - 1];
								Imitation.AddEventClick(mc["TAB" + i],this.OnTabClick);
								Imitation.AddEventMouseOver(mc["TAB" + i],this.OnTabOver);
								Imitation.AddEventMouseOut(mc["TAB" + i],this.OnTabOut);
						}
						this.SetCurrentProp("HEAD");
						if(Sys.mydata.extavatar != "" && Boolean(mc.FBAVATAR)) {
								mc.FBAVATAR.ShowExternal(Sys.mydata.id,Sys.mydata.extavatar);
								mc.CB_CUSTOM.CHECK.visible = false;
								this.CB_CUSTOM.gotoAndStop("FACEBOOK");
								Imitation.AddEventClick(mc.CB_CUSTOM,this.OnCBCustomClick);
						}
						this.CB_CUSTOM.visible = false;
						this.CHAR.NPC.Set("MESSENGER","DEFAULT");
						Util.SetText(this.CHAR.INFO.FIELD,Lang.Get("avatarwin_txt_1"));
						if(this.CHAR.INFO.FIELD.numLines >= 4) {
								this.CHAR.INFO.FIELD.y = 9;
						}
						if(this.CHAR.INFO.FIELD.numLines == 3) {
								this.CHAR.INFO.FIELD.y = 18;
						}
						if(this.CHAR.INFO.FIELD.numLines == 2) {
								this.CHAR.INFO.FIELD.y = 28;
						}
						if(this.CHAR.INFO.FIELD.numLines == 1) {
								this.CHAR.INFO.FIELD.y = 38;
						}
						Imitation.Update(this.CHAR);
						this.AVATAR_EDITOR_BUTTON.ICON.Set("EDIT");
						Imitation.AddEventClick(this.AVATAR_EDITOR_BUTTON,function():* {
								if(!ITEMS.visible) {
										ShowAvatarEditor();
								} else {
										HideAvatarEditor();
								}
						});
						if(Sys.mydata.name == "") {
								this.ShowNameReg();
						} else {
								this.ShowAvatarReg();
						}
						this.HideAvatarEditor();
						AvatarWin.oy = mc.y;
				}
				
				public function OnCBCustomClick(e:* = null) : void {
						mc.CB_CUSTOM.CHECK.visible = !mc.CB_CUSTOM.CHECK.visible;
						if(mc.CB_CUSTOM.CHECK.visible) {
								this.ShowChoosedAvatar("FB");
						} else {
								this.ShowChoosedAvatar("DEFAULT");
						}
				}
				
				private function OnTabOver(e:*) : void {
				}
				
				private function OnTabOut(e:*) : void {
				}
				
				public function OnTabClick(e:*) : void {
						this.ShowChoosedAvatar("DEFAULT");
						this.SetCurrentProp(e.target.prop);
				}
				
				public function SetCurrentProp(p:String) : * {
						var t:MovieClip = null;
						var a:int = 0;
						var e:* = false;
						this.current_prop = p;
						for(var i:int = 1; i <= 8; i++) {
								t = mc["TAB" + i];
								a = mc.getChildIndex(t);
								e = this.current_prop == propnames[i - 1];
								Imitation.GotoFrame(t,e ? 1 : 2);
						}
						Imitation.CollectChildrenAll(mc);
						this.DrawAvatar();
				}
				
				public function DrawAvatar() : * {
						var i:int = 0;
						var item:MovieClip = null;
						var m:MovieClip = null;
						var c:MovieClip = null;
						var color:int = 0;
						mc.CB_CUSTOM.CHECK.visible = true;
						this.OnCBCustomClick();
						if(!this.avatarmc) {
								this.avatarmc = AvatarFactory.CreateAvatarMov(this.properties);
								this.avatarmembers.properties = this.properties;
								this.avatarmembers.mc = this.avatarmc;
								this.AVATAR.addChild(this.avatarmc);
								this.avatarmc.scaleX = 1 / 250 * 70;
								this.avatarmc.scaleY = 1 / 250 * 70;
								this.avatarmc.x = 35;
								this.avatarmc.y = 70;
								Imitation.CollectChildren(this.AVATAR);
						}
						AvatarFactory.UpdateProperties(this.avatarmc,this.properties,this.avatarmembers);
						AvatarFactory.StartAnim(this.avatarmembers);
						var propcolors:Object = {
								"BACK":AvatarFactory.back_colors,
								"HEAD":AvatarFactory.head_colors,
								"HAIR":AvatarFactory.hair_colors,
								"EYE":AvatarFactory.eye_colors,
								"FACIAL":(this.properties.sex == 2 ? AvatarFactory.female_hairdecor_colors : AvatarFactory.male_facial_colors)
						};
						Imitation.GotoFrame(mc.TAB7.ICON,this.properties.sex == 1 ? "AVATAR_PROP7_1" : "AVATAR_PROP7_2");
						Imitation.Update(mc.TAB7);
						var symbols:Array = AvatarFactory.NewSymbols(this.current_prop,this.properties.sex);
						for(i = 1; i <= 8; i++) {
								item = this.ITEMS["B" + i];
								if(item) {
										if(item.SYMBOL) {
												item.removeChild(item.SYMBOL);
										}
										m = symbols[i - 1];
										if(m) {
												if(this.current_prop == "HEAD") {
														item.value = i;
												} else {
														item.value = AvatarFactory.GetSymbolIndex(this.properties.sex,this.properties.head,m);
												}
												item.buttonMode = true;
												Imitation.AddEventClick(item,this.SetProperty);
												item.gotoAndStop(this.properties[this.current_prop.toLowerCase()] == item.value ? 2 : 1);
												if(this.ITEMS.visible) {
														item.visible = true;
												}
												item.addChildAt(m,1);
												item.SYMBOL = m;
												m.gotoAndStop(1);
												m.scaleY /= 5;
												m.scaleX /= 5;
												m.x /= 5;
												m.y = m.y / 5 - 2;
												if(m.BASE) {
														Util.SetColor(m.BASE,coloredprops.indexOf(this.current_prop) > -1 ? uint(propcolors[this.current_prop][this.properties[this.current_prop.toLowerCase() + "color"] - 1]) : uint(propcolors["HEAD"][this.properties["headcolor"] - 1]));
												}
										} else {
												item.visible = false;
												item.SYMBOL = null;
										}
								}
						}
						for(i = 1; i <= 15; i++) {
								c = mc["C" + i];
								if(c) {
										c.value = i;
										c.buttonMode = true;
										c.gotoAndStop(this.properties[this.current_prop.toLowerCase() + "color"] == i ? 2 : 1);
										Imitation.AddEventClick(c,this.SetColor);
										if(Boolean(propcolors[this.current_prop]) && i - 1 < propcolors[this.current_prop].length) {
												c.visible = true;
												color = int(propcolors[this.current_prop][i - 1]);
												Util.SetColor(c.COLOR,color);
												Imitation.Update(c.COLOR);
										} else {
												c.visible = false;
										}
										if(!this.ITEMS.visible) {
												c.visible = false;
										}
								}
						}
						var bgcolor:int = int(AvatarFactory.back_colors[this.properties["backcolor"] - 1]);
						Imitation.Update(this.AVATAR);
				}
				
				private function OnAvatarClick(e:*) : void {
						this.ShowChoosedAvatar("DEFAULT");
						var anim:int = Util.Random(3,1);
						AvatarFactory.UpdateProperties(this.avatarmc,this.properties,this.avatarmembers,anim);
						AvatarFactory.StartAnim(this.avatarmembers,anim);
				}
				
				private function Animate(prop:String) : void {
						var mb:MovieClip = null;
						var m:MovieClip = null;
						if(prop == "head") {
								m = this.avatarmc.HEAD;
								TweenMax.to(m,0.15,{
										"scaleX":1.1,
										"scaleY":0.95
								});
								TweenMax.to(m,0.15,{
										"scaleX":1,
										"scaleY":1,
										"delay":0.15
								});
						} else {
								if(this.avatarmembers[prop]) {
										m = this.avatarmembers[prop][this.properties[prop] - 1];
								}
								if(!m) {
										return;
								}
								this.AnimateMember(m,prop);
								if("hair" == prop) {
										mb = this.avatarmembers["hairb"][this.properties.hair - 1];
										if(mb) {
												this.AnimateMember(mb,"hair");
										}
								}
						}
				}
				
				private function AnimateMember(m:MovieClip, prop:String) : * {
						var sx:*;
						var sy:*;
						var x1:*;
						var y1:*;
						var scx:*;
						var scy:*;
						var b:Rectangle;
						var cx:*;
						var cy:*;
						var MemberAnimComplete:Function = null;
						MemberAnimComplete = function():* {
								avatarmc.gotoAndStop(properties.sex + 1);
								DrawAvatar();
						};
						if(TweenMax.isTweening(m)) {
								return;
						}
						sx = m.scaleX;
						sy = m.scaleY;
						x1 = m.x;
						y1 = m.y;
						scx = prop == "hair" ? 1.1 : 1.33;
						scy = prop == "hair" ? 0.9 : 0.75;
						b = m.getBounds(m);
						cx = (b.left + b.right) / 2 * (1 - scx);
						cy = (b.top + b.bottom) / 2 * (1 - scy) + (prop == "hair" ? -10 : 0);
						TweenMax.to(m,0.15,{
								"x":x1 + cx,
								"y":y1 + cy,
								"scaleX":sx * scx,
								"scaleY":sy * scy
						});
						TweenMax.to(m,0.15,{
								"x":x1,
								"y":y1,
								"scaleX":sx,
								"scaleY":sy,
								"delay":0.15,
								"onComplete":MemberAnimComplete
						});
				}
				
				public function SetSex(e:*) : * {
						this.RandomClick();
						var btnname:* = e.target.name.split("_")[0];
						AvatarFactory.ChangeSex(this.properties,btnname == "FEMALE" ? 2 : 1);
						this.DrawAvatar();
						this.Animate("head");
						mc.CB_CUSTOM.CHECK.visible = true;
						this.OnCBCustomClick();
				}
				
				private function OnBGColorClick(e:*) : void {
						TweenMax.to(e.target,0.15,{
								"scaleX":0.9,
								"scaleY":0.9
						});
						TweenMax.to(e.target,0.15,{
								"scaleX":1,
								"scaleY":1,
								"delay":0.15
						});
						var value:int = int(this.properties["backcolor"]);
						value++;
						if(value >= AvatarFactory.back_colors.length) {
								value = 1;
						}
						this.properties["backcolor"] = value;
						this.DrawAvatar();
				}
				
				public function SetColor(e:*) : * {
						TweenMax.to(e.target,0.15,{
								"scaleX":0.9,
								"scaleY":0.9
						});
						TweenMax.to(e.target,0.15,{
								"scaleX":1,
								"scaleY":1,
								"delay":0.15
						});
						var prop:* = this.current_prop.toLowerCase() + "color";
						var value:int = int(e.target.value);
						this.properties[prop] = value;
						this.DrawAvatar();
						this.Animate(this.current_prop.toLowerCase());
				}
				
				public function SetProperty(e:*) : * {
						var value:int = int(e.target.value);
						TweenMax.to(e.target,0.15,{
								"scaleX":0.9,
								"scaleY":0.9
						});
						TweenMax.to(e.target,0.15,{
								"scaleX":1,
								"scaleY":1,
								"delay":0.15
						});
						AvatarFactory.SetProperty(this.properties,this.current_prop.toLocaleLowerCase(),value);
						this.DrawAvatar();
						this.Animate(this.current_prop.toLocaleLowerCase());
				}
				
				public function ResetClick(e:*) : * {
						this.properties = AvatarFactory.CloneProperties(original_properties);
						this.DrawAvatar();
						this.Animate("head");
				}
				
				public function RandomClick(e:Object = null) : * {
						AvatarFactory.RandomizeProperties(this.properties,this.properties.sex);
						this.DrawAvatar();
						this.Animate("head");
				}
				
				public function ConfirmClick(e:*) : * {
						var avatarid:String = null;
						var usecustom:Boolean = false;
						trace("AvatarWin.ConfirmClick");
						if(Sys.mydata.name == "") {
								this.OnSendNameAndAvatar(e);
						} else {
								trace("only avatar save");
								avatarid = AvatarFactory.FormatProperties(this.properties);
								usecustom = Sys.mydata.extavatar != "" ? !this.CB_CUSTOM.CHECK.visible : true;
								Comm.SendCommand("SETDATA","CUSTOMAVATAR=\"" + avatarid + "\" USECUSTOMAVATAR=\"" + (usecustom ? "1" : "0") + "\"");
								if(Config.loginemail != "") {
										this.Hide();
										return;
								}
								this.ShowEmailRegistration();
						}
				}
				
				private function ShowNameReg() : void {
						trace("ShowNameReg");
						this.BTNCLOSE.visible = false;
						Util.SetText(mc.C_NAME.FIELD,Lang.Get("avatarwin_txt_2"));
						Util.AddEventListener(mc.SNAME.FIELD,Event.CHANGE,this.OnSNameChange);
						mc.SNAME.FIELD.maxChars = 12;
						this.WRONG_NAME.visible = false;
						this.NAME_DESC.visible = true;
						this.C_NAME.visible = true;
						this.NAME_ICON.visible = false;
						this.FEMALE_BTN.visible = true;
						this.MALE_BTN.visible = true;
						this.AVATAR_EDITOR_BUTTON.visible = true;
						this.BTNAVATAR.visible = true;
						this.AVATAR.visible = true;
						this.CONFIRM_BTN.SetEnabled(true);
						Util.SetText(this.NAME_DESC.FIELD,Lang.get("emsg_login_name_format").replace(/<br>/g,""));
						this.HideRecommendedLines();
						Imitation.AddEventClick(this.RECOMMENDED1,this.OnSuggClick);
						Imitation.AddEventClick(this.RECOMMENDED2,this.OnSuggClick);
						Imitation.AddEventClick(this.RECOMMENDED3,this.OnSuggClick);
						Imitation.CollectChildrenAll(mc);
						Imitation.FreeBitmapAll(mc);
				}
				
				private function ShowAvatarReg() : void {
						trace("ShowAvatarReg");
						this.BTNCLOSE.visible = true;
						Util.SetText(mc.C_NAME.FIELD,Lang.Get("avatarwin_txt_8"));
						this.WRONG_NAME.visible = false;
						this.NAME_DESC.visible = false;
						this.C_NAME.visible = true;
						this.NAME_ICON.visible = true;
						Imitation.GotoFrame(this.NAME_ICON,1);
						this.FEMALE_BTN.visible = true;
						this.MALE_BTN.visible = true;
						this.AVATAR_EDITOR_BUTTON.visible = true;
						this.BTNAVATAR.visible = true;
						this.AVATAR.visible = true;
						this.CONFIRM_BTN.SetEnabled(true);
						this.SNAME.FIELD.text = Sys.mydata.name;
						this.SNAME.FIELD.type = TextFieldType.DYNAMIC;
						this.HideRecommendedLines();
						Imitation.RemoveEvents(this.RECOMMENDED1);
						Imitation.RemoveEvents(this.RECOMMENDED2);
						Imitation.RemoveEvents(this.RECOMMENDED3);
						Imitation.CollectChildrenAll(mc);
						Imitation.FreeBitmapAll(mc);
				}
				
				private function ShowEmailRegistration() : void {
						trace("ShowEmailRegistration");
						gotoAndStop("REG");
						this.HideAvatarEditor();
						this.HideFBAvatar();
						this.BTNCLOSE.visible = true;
						this.CHAR.visible = true;
						Util.SetText(this.CHAR.INFO.FIELD,Lang.Get("avatarwin_txt_4"));
						if(this.CHAR.INFO.FIELD.numLines >= 4) {
								this.CHAR.INFO.FIELD.y = 9;
						}
						if(this.CHAR.INFO.FIELD.numLines == 3) {
								this.CHAR.INFO.FIELD.y = 18;
						}
						if(this.CHAR.INFO.FIELD.numLines == 2) {
								this.CHAR.INFO.FIELD.y = 28;
						}
						if(this.CHAR.INFO.FIELD.numLines == 1) {
								this.CHAR.INFO.FIELD.y = 38;
						}
						Util.SetText(this.C_REG_1.FIELD,Lang.Get("avatarwin_txt_3"));
						if(this.C_REG_1.FIELD.numLines >= 5) {
								this.C_REG_1.FIELD.y = 4;
						}
						if(this.C_REG_1.FIELD.numLines == 4) {
								this.C_REG_1.FIELD.y = 13;
						}
						if(this.C_REG_1.FIELD.numLines == 3) {
								this.C_REG_1.FIELD.y = 23;
						}
						if(this.C_REG_1.FIELD.numLines == 2) {
								this.C_REG_1.FIELD.y = 31;
						}
						if(this.C_REG_1.FIELD.numLines == 1) {
								this.C_REG_1.FIELD.y = 40;
						}
						Util.SetText(this.C_REG_2.FIELD,Lang.Get("avatarwin_txt_5"));
						Util.SetText(this.C_REG_3.FIELD,Lang.Get("avatarwin_txt_6"));
						Util.SetText(this.PASS.FIELD,"");
						this.CONFIRM_BTN.SetEnabled(true);
						this.CONFIRM_BTN.AddEventClick(this.OnRegistration);
						this.PASS.visible = false;
						Imitation.CollectChildrenAll(mc);
						Imitation.FreeBitmapAll(mc);
						Util.SetText(this.TXT_NEWSLETTER.FIELD,Lang.Get("reg_subscribe_newsletter"));
						this.CHECK_3.CHECK.visible = false;
						this.CHECK_3.gotoAndStop(1);
						Imitation.AddEventClick(this.CHECK_3,this.OnChecks);
				}
				
				private function OnChecks(e:Object) : void {
						e.target.CHECK.visible = !e.target.CHECK.visible;
				}
				
				private function OnSNameChange(e:Event) : void {
						this.NAME_ICON.visible = false;
						if(mc.SNAME.FIELD.text.length >= 4) {
								mc.CONFIRM_BTN.SetEnabled(false);
								TweenMax.killTweensOf(this.LoadSuggestions);
								TweenMax.delayedCall(0.5,this.LoadSuggestions,[mc.SNAME.FIELD.text]);
						} else {
								Util.SetText(this.NAME_DESC.FIELD,Lang.get("emsg_login_name_format").replace(/<br>/g,""));
								mc.CONFIRM_BTN.SetEnabled(false);
								this.HideRecommendedLines();
								this.NAME_ICON.visible = true;
								Imitation.GotoFrame(this.NAME_ICON,2);
						}
						this.WRONG_NAME.visible = false;
						this.NAME_DESC.visible = true;
				}
				
				private function OnSendNameAndAvatar(e:*) : * {
						trace("OnSendNameAndAvatar");
						this.CONFIRM_BTN.SetEnabled(false);
						var suggested:Boolean = false;
						for(var i:int = 0; i < AvatarWin.namesug.length; i++) {
								if(this.SNAME.FIELD.text == AvatarWin.namesug[i]) {
										suggested = true;
										break;
								}
						}
						JsQuery.Load(this.SendAvatarAndCode,[],"stal_data.php?" + Sys.FormatGetParamsStoc({},true),{
								"cmd":"uname_set",
								"uname":this.SNAME.FIELD.text,
								"suggested":suggested
						});
				}
				
				private function SendAvatarAndCode(jsq:*) : * {
						var avatarid:String;
						var usecustom:Boolean;
						trace("SendAvatarAndCode");
						this.NAME_ICON.visible = true;
						DBG.Trace("jsq",jsq);
						if(Boolean(jsq.error) || jsq.data.result != "OK") {
								this.WRONG_NAME.visible = true;
								this.NAME_DESC.visible = false;
								if(jsq.data.result == "CHAR") {
										Lang.Set(this.WRONG_NAME.FIELD,"nameselection_error_char");
								} else if(jsq.data.result == "DENY") {
										Lang.Set(this.WRONG_NAME.FIELD,"nameselection_error_deny");
								} else {
										Lang.Set(this.WRONG_NAME.FIELD,"name_wrong");
								}
								Imitation.GotoFrame(this.NAME_ICON,2);
								return;
						}
						this.WRONG_NAME.visible = false;
						this.NAME_DESC.visible = false;
						Imitation.GotoFrame(this.NAME_ICON,1);
						avatarid = AvatarFactory.FormatProperties(this.properties);
						usecustom = Sys.mydata.extavatar != "" ? !this.CB_CUSTOM.CHECK.visible : true;
						Comm.SendCommand("SETDATA","CUSTOMAVATAR=\"" + avatarid + "\" USECUSTOMAVATAR=\"" + (usecustom ? "1" : "0") + "\"",function():* {
								trace("Comm.SendCommand(\'SETDATA\' result");
								if(Config.loginemail == "") {
										ShowEmailRegistration();
										return;
								}
								Hide();
						});
				}
				
				private function OnRegistration(e:Object) : void {
						var data:Object = null;
						this.CONFIRM_BTN.SetEnabled(false);
						this.BTNCLOSE.visible = false;
						var email:String = this.INPUT_REGEMAIL.FIELD.text;
						if(email == "") {
								this.Hide();
								return;
						}
						var password:String = this.PASS.FIELD.text;
						var newsletter:int = 0;
						if(this.CHECK_3.CHECK.visible) {
								newsletter = 1;
						}
						trace("newsletter: " + newsletter);
						if(this.guiddata) {
								data = {
										"cmd":"upgrade_guid",
										"email":email,
										"guid":Util.StringVal(this.guiddata.guid),
										"password":Util.StringVal(this.guiddata.pass)
								};
						} else {
								data = {
										"cmd":"register2",
										"email":email,
										"newletter":newsletter,
										"clientver":Version.value
								};
						}
						JsQuery.Load(this.OnRegistrationResult,[],"mobil.php",data);
				}
				
				private function OnRegistrationResult(_jsq:Object) : void {
						var mw:Object = null;
						this.BTNCLOSE.visible = true;
						if(_jsq.error) {
								mw = Modules.GetClass("uibase","uibase.MessageWin");
								mw.Show(Lang.Get("registration"),_jsq.errormsg,function():* {
										CONFIRM_BTN.SetEnabled(true);
								});
								return;
						}
						this.PASS.visible = false;
						this.PASS.FIELD.selectable = true;
						this.C_REG_1.FIELD.text = Lang.Get("password_create_link_sent",this.PASS.FIELD.text);
						if(this.C_REG_1.FIELD.numLines >= 5) {
								this.C_REG_1.FIELD.y = 4;
						}
						if(this.C_REG_1.FIELD.numLines == 4) {
								this.C_REG_1.FIELD.y = 13;
						}
						if(this.C_REG_1.FIELD.numLines == 3) {
								this.C_REG_1.FIELD.y = 23;
						}
						if(this.C_REG_1.FIELD.numLines == 2) {
								this.C_REG_1.FIELD.y = 31;
						}
						if(this.C_REG_1.FIELD.numLines == 1) {
								this.C_REG_1.FIELD.y = 40;
						}
						this.C_REG_2.visible = false;
						this.C_REG_3.visible = false;
						Config.loginemail = this.INPUT_REGEMAIL.FIELD.text;
						this.CONFIRM_BTN.SetEnabled(true);
						this.CONFIRM_BTN.AddEventClick(this.Hide);
						Imitation.FreeBitmapAll(this);
				}
				
				private function OnGameTagsProcessed(e:Event) : void {
						Imitation.RemoveGlobalListener("GAMETAGSPROCESSED",this.OnGameTagsProcessed);
						this.Hide();
				}
				
				public function HideAvatarEditor(e:Object = null) : void {
						var i:int = 0;
						for(i = 1; i <= 8; i++) {
								mc["TAB" + i].visible = false;
						}
						this.ITEMS.visible = false;
						for(i = 1; i <= 15; i++) {
								mc["C" + i].alpha = 0;
						}
						this.HideFBAvatar();
						if(Sys.mydata.extavatar != "" && this.CB_CUSTOM.CHECK.visible) {
								this.ShowFBAvatar();
						} else if(Sys.mydata.extavatar != "" && !this.CB_CUSTOM.CHECK.visible) {
								this.HideFBAvatar();
						}
						this.CB_CUSTOM.visible = false;
						this.EDITOR_BG.visible = false;
						this.CHAR.visible = true;
				}
				
				public function ShowAvatarEditor(e:Object = null) : void {
						var i:int = 0;
						for(i = 1; i <= 8; i++) {
								mc["TAB" + i].visible = true;
						}
						this.ITEMS.visible = true;
						for(i = 1; i <= 15; i++) {
								mc["C" + i].alpha = 1;
						}
						if(Sys.mydata.extavatar != "" && this.CB_CUSTOM.CHECK.visible) {
								this.ShowFBAvatar();
						} else if(Sys.mydata.extavatar != "" && !this.CB_CUSTOM.CHECK.visible) {
								this.HideFBAvatar();
						}
						if(Sys.mydata.extavatar != "") {
								this.CB_CUSTOM.visible = true;
						} else {
								this.CB_CUSTOM.visible = false;
						}
						this.EDITOR_BG.visible = true;
						this.CHAR.visible = false;
				}
				
				public function HideFBAvatar() : void {
						this.FBAVATARFRAME.visible = false;
						this.FBAVATAR.visible = false;
				}
				
				public function ShowFBAvatar() : void {
						this.FBAVATARFRAME.visible = true;
						this.FBAVATAR.visible = true;
				}
				
				public function ShowChoosedAvatar(_type:String = "DEFAULT") : void {
						var i:int = 0;
						if(_type == "FB") {
								this.ShowFBAvatar();
								this.FEMALE_BTN.alpha = 0.3;
								this.MALE_BTN.alpha = 0.3;
								this.BTNAVATAR.visible = false;
								this.AVATAR.visible = false;
								for(i = 1; i <= 8; i++) {
										mc["TAB" + i].alpha = 0.3;
								}
								this.ITEMS.alpha = 0.3;
								for(i = 1; i <= 15; i++) {
										mc["C" + i].alpha = 0.3;
								}
						} else {
								this.HideFBAvatar();
								this.FEMALE_BTN.alpha = 1;
								this.MALE_BTN.alpha = 1;
								this.BTNAVATAR.visible = true;
								this.AVATAR.visible = true;
								for(i = 1; i <= 8; i++) {
										mc["TAB" + i].alpha = 1;
								}
								this.ITEMS.alpha = 1;
								for(i = 1; i <= 15; i++) {
										mc["C" + i].alpha = 1;
								}
						}
				}
				
				private function LoadSuggestions(triedname:String = "") : void {
						if(AvatarWin.issuggestionsloading) {
								return;
						}
						if(triedname == "") {
								return;
						}
						last_triedname = triedname;
						this.HideRecommendedLines();
						AvatarWin.issuggestionsloading = true;
						AvatarWin.namesug = [];
						var arr:Array = [];
						arr.push(triedname);
						if(Config.loginusername != "") {
								arr.push(Config.loginusername);
						}
						if(Config.userlastname != "") {
								arr.push(Config.userlastname);
						}
						if(Config.useremail != "") {
								arr.push(Config.useremail);
						}
						arr.push(Version.value);
						var sex:* = this.properties.sex;
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
						if(triedname != "") {
								obj.tried_name = triedname;
						}
						obj.version = Version.value;
						DBG.Trace("",arr);
						DBG.Trace("",obj);
						if(arr.length > 0) {
								JsQuery.Load(OnNameSug,[this],"client_namesugg.php?" + Sys.FormatGetParamsStoc({},true),{
										"data":arr.join(","),
										"sex":sex,
										"newsugg":obj
								});
						} else {
								AvatarWin.issuggestionsloading = false;
								AvatarWin.namesug = [];
						}
				}
				
				private function HideRecommendedLines() : void {
						trace("HideRecommendedLines");
						if(!mc) {
								return;
						}
						if(this.RECOMMENDED1) {
								this.RECOMMENDED1.visible = false;
						}
						if(this.RECOMMENDED2) {
								this.RECOMMENDED2.visible = false;
						}
						if(this.RECOMMENDED3) {
								this.RECOMMENDED3.visible = false;
						}
				}
				
				private function OnSuggClick(e:Object) : void {
						trace("OnSuggClick");
						mc.SNAME.FIELD.text = e.target.FIELD.FIELD.text;
						this.WRONG_NAME.visible = false;
						this.NAME_DESC.visible = true;
						mc.NAME_ICON.visible = false;
						this.CONFIRM_BTN.SetEnabled(true);
				}
		}
}

