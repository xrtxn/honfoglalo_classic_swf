package profile2 {
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import flash.events.Event;
		import flash.text.TextField;
		import syscode.*;
		import uibase.lego_button_1x1_cancel_header;
		import uibase.lego_button_1x1_normal_header;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol655")]
		public class Profile2 extends MovieClip {
				private static var opening:Boolean;
				
				public static var mc:Profile2 = null;
				
				public var BOUNDS:MovieClip;
				
				public var BTNCLOSE:lego_button_1x1_cancel_header;
				
				public var BTNHELP:lego_button_1x1_normal_header;
				
				public var FRIENDS_PAGE:FriendsPage;
				
				public var MESSAGES_PAGE:MessagesPage;
				
				public var MISSIONS_PAGE:MovieClip;
				
				public var PROFILE_PAGE:ProfilePage;
				
				public var SCHOOLS_PAGE:SchoolsPage;
				
				public var SETTINGS_PAGE:SettingsPage;
				
				public var TABS:HeaderTabs;
				
				public var USERID:TextField;
				
				public var actPageNumber:Number = 1;
				
				private var params:Object;
				
				private var usersdata:Object = null;
				
				public var uid:String;
				
				public var soldiers:Object;
				
				public var selected_soldier:int = 1;
				
				public var reftime:Number = 0;
				
				public var friendship:Object = null;
				
				public var countryList:Array;
				
				public function Profile2() {
						this.soldiers = {};
						super();
				}
				
				public static function UserDataProc(jsq:*) : * {
						if(!mc) {
								return;
						}
						if(jsq.error != 0) {
								if(opening) {
										WinMgr.WindowDataArrived(mc);
								}
								Hide();
								return;
						}
						mc.usersdata = jsq.data;
						Comm.SendCommand("GETSTOREITEMS ","",mc.OnStoreItemsCallback);
				}
				
				public static function Hide(e:Object = null) : void {
						Imitation.RemoveGlobalListener("MYDATACHANGE",mc.OnMyDataChange);
						Imitation.RemoveGlobalListener("FRIENDSCHANGED",mc.OnFriendsChanged);
						if(mc) {
								mc.Destroy();
						}
						WinMgr.CloseWindow(mc);
				}
				
				public static function OnClanCommandReady(e:* = null) : void {
						var Clan:Object = null;
						WinMgr.HideLoadWait();
						if(mc) {
								mc.LoadUserData();
						}
						if(WinMgr.WindowOpened("clan.Clan")) {
								Clan = Modules.GetClass("clan","clan.Clan");
								Clan.mc.Hide();
						}
				}
				
				public static function OnSendMemberRequest(_result:int, _params:Object) : void {
						if(_result == 1) {
								WinMgr.ShowLoadWait();
								JsQuery.Load(OnMemberRequestResult,[_params],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),_params);
						}
				}
				
				public static function OnMemberRequestResult(_jsq:Object, _params:Object) : void {
						if(Util.NumberVal(_jsq.error) > 0) {
								WinMgr.HideLoadWait();
						} else {
								OnClanCommandReady();
						}
				}
				
				public static function ShowResult(jsq:*, title:*, success_str:*) : * {
						if(!mc) {
								return;
						}
						var MessageWin:* = Modules.GetClass("uibase","uibase.MessageWin");
						if(!jsq.error) {
								mc.SETTINGS_PAGE.HideWin();
								MessageWin.Show(Lang.get(title),Lang.get(success_str),mc.SETTINGS_PAGE.RestoreWin,2);
						} else {
								mc.SETTINGS_PAGE.HideWin();
								MessageWin.Show(Lang.get("error"),jsq.errormsg,mc.SETTINGS_PAGE.RestoreWin);
						}
				}
				
				public function Prepare(aparams:Object) : void {
						this.params = aparams;
						opening = true;
						if(aparams.user_id) {
								this.uid = aparams.user_id;
						} else {
								this.uid = Sys.mydata.id;
						}
						if(aparams.page) {
								this.actPageNumber = aparams.page;
						}
						this.USERID.text = "ID: " + this.uid;
						this.USERID.visible = false;
						this.LoadUserData();
						aparams.waitfordata = true;
						this.selected_soldier = Sys.mydata.soldier;
						Imitation.AddGlobalListener("MYDATACHANGE",this.OnMyDataChange);
						Imitation.AddGlobalListener("FRIENDSCHANGED",this.OnFriendsChanged);
						this.BTNCLOSE.SetIcon("X");
						this.BTNCLOSE.AddEventClick(this.OnCloseClick);
						this.BTNHELP.SetIcon("HELP");
						this.BTNHELP.AddEventClick(this.OnHelpClick);
						this.TABS.visible = false;
						this.HidePages();
						this.GetCountryList();
				}
				
				private function LoadUserData() : void {
						JsQuery.Load(UserDataProc,[],"client_userdata.php?stoc=" + Config.stoc,{"userid":this.uid});
				}
				
				private function OnStoreItemsCallback(res:int, xml:XML) : void {
						var i:int = 0;
						var s:Array = null;
						var n:int = 0;
						var have:* = false;
						this.reftime = new Date().time;
						var data:Object = Util.XMLTagToObject(xml);
						var ss:Array = Util.StringVal(data.STORE.SOLDIERS.P.VALUE).split(";");
						this.soldiers = {};
						for(i = 0; i < Sys.mydata.soldiers.length; i++) {
								if(Sys.mydata.soldiers[i] != 0) {
										this.soldiers[i] = {
												"cost":1,
												"type":0,
												"remaining":0,
												"have":true
										};
								}
						}
						for(i = 0; i < ss.length; i++) {
								s = ss[i].split(",");
								n = Util.NumberVal(s[0]);
								have = Sys.mydata.soldiers[n] != 0;
								this.soldiers[n] = {
										"cost":Util.NumberVal(s[1]),
										"type":Util.NumberVal(s[2]),
										"remaining":Util.NumberVal(s[3]),
										"have":have
								};
						}
						if(opening) {
								WinMgr.WindowDataArrived(mc);
						}
						this.OnFriendsChanged();
						mc.DrawTabs();
				}
				
				private function GetCountryList() : void {
						var cid:String = null;
						var c:Object = null;
						var cname:String = null;
						var cdesc:String = null;
						this.countryList = new Array();
						for(cid in Extdata.countries) {
								c = Extdata.countries[cid];
								cname = c.name;
								cdesc = c.description;
								if(cid != "a1" && cid != "a2" && (Config.siteid.charAt(0) == "x" && cid != "ap" || Config.siteid.charAt(0) != "x") && cid != "eu" && cid != "--") {
										this.countryList.push({
												"id":cid,
												"name":cname,
												"desc":cdesc
										});
								}
						}
						this.countryList.sort(function(a:*, b:*):* {
								return a.name.localeCompare(b.name);
						});
				}
				
				public function Destroy() : void {
						Imitation.RemoveGlobalListener("MYDATACHANGE",mc.OnMyDataChange);
						Imitation.RemoveGlobalListener("FRIENDSCHANGED",mc.OnFriendsChanged);
						mc.MISSIONS_PAGE.MISSION_LIST.Destroy();
						mc.PROFILE_PAGE.Destroy();
						mc.FRIENDS_PAGE.Destroy();
						mc.MESSAGES_PAGE.Destroy();
						mc.SETTINGS_PAGE.Destroy();
						mc.SCHOOLS_PAGE.Destroy();
				}
				
				public function AfterOpen() : void {
						this.USERID.visible = true;
						opening = false;
						Imitation.EnableInput(this.PROFILE_PAGE,this.PROFILE_PAGE.visible);
						Imitation.EnableInput(this.MESSAGES_PAGE,this.MESSAGES_PAGE.visible);
						Imitation.EnableInput(this.MESSAGES_PAGE.NEW_MESSAGE_MC,this.MESSAGES_PAGE.NEW_MESSAGE_MC.visible);
						Imitation.EnableInput(this.MESSAGES_PAGE.BODY,this.MESSAGES_PAGE.BODY.visible);
						Imitation.EnableInput(this.FRIENDS_PAGE,this.FRIENDS_PAGE.visible);
						Imitation.EnableInput(this.SETTINGS_PAGE,this.SETTINGS_PAGE.visible);
						Imitation.EnableInput(this.MISSIONS_PAGE,this.MISSIONS_PAGE.visible);
						Imitation.EnableInput(this.SCHOOLS_PAGE,this.MISSIONS_PAGE.visible);
						Imitation.FreeBitmapAll(this);
						Imitation.UpdateAll(this);
				}
				
				public function AfterClose() : void {
						if(this.selected_soldier > 0 && this.selected_soldier != Sys.mydata.soldier) {
								if(Boolean(this.soldiers[this.selected_soldier]) && Boolean(this.soldiers[this.selected_soldier].have)) {
										Comm.SendCommand("SETDATA","SOLDIER=\"" + this.selected_soldier + "\"");
								}
						}
				}
				
				public function Show() : void {
				}
				
				public function OnMyDataChange(e:Event = null) : void {
						if(this.uid == Sys.mydata.id) {
								this.PROFILE_PAGE.AVATAR.Clear();
								this.PROFILE_PAGE.AVATAR.ShowUID(this.uid);
								this.PROFILE_PAGE.started = false;
								Comm.SendCommand("GETSTOREITEMS ","",this.OnStoreItemsCallback);
						}
				}
				
				public function OnFriendsChanged(e:* = null) : void {
						var a:Object = null;
						var f:Object = null;
						for(var i:int = 0; i < Friends.all.length; i++) {
								a = Friends.all[i];
								if(a.id == this.uid && a.flag != 4) {
										f = a;
										break;
								}
						}
						this.friendship = f;
						this.PROFILE_PAGE.started = false;
						this.DrawTabs();
						if(e == null && WinMgr.WindowOpened("postoffice.PostOffice")) {
								Modules.GetClass("postoffice","postoffice.PostOffice").mc.OnFriendsChanged(null);
						}
				}
				
				public function DrawTabs() : void {
						this.TABS.visible = true;
						if(this.TABS.titles.length <= 0) {
								this.TABS.Set(["profile","messages","friends","settings","missions","schools"],["MEMBER1","PERGAMEN","MEMBERS","SETTINGS","SWORDS","THEME5"],this.OnLegoTabClick,this.actPageNumber);
								if(this.uid != Sys.mydata.id) {
										this.TABS.Reorder([this.TABS.TTAB1,this.TABS.TTAB2,this.TABS.TTAB3,this.TABS.TTAB4,this.TABS.TTAB5,this.TABS.TTAB6],[true,false,false,false,false,false]);
								} else {
										this.TABS.Reorder([this.TABS.TTAB1,this.TABS.TTAB2,this.TABS.TTAB3,this.TABS.TTAB4,this.TABS.TTAB5,this.TABS.TTAB6],[true,true,true,true,true,false]);
								}
						} else {
								this.OnLegoTabClick(this.actPageNumber);
						}
				}
				
				public function OnLegoTabClick(_pagenumber:Number) : * {
						this.actPageNumber = _pagenumber;
						this.HidePages();
						if(_pagenumber == 1) {
								this.DrawProfilePage();
						}
						if(_pagenumber == 2) {
								this.DrawMessagesPage();
						}
						if(_pagenumber == 3) {
								this.DrawFriendsPage();
						}
						if(_pagenumber == 4) {
								this.DrawSettingsPage();
						}
						if(_pagenumber == 5) {
								this.DrawMissionsPage();
						}
						if(_pagenumber == 6) {
								this.DrawSchoolsPage();
						}
				}
				
				public function OnCloseClick(e:*) : * {
						Hide();
				}
				
				public function OnHelpClick(e:*) : void {
						WinMgr.OpenWindow("help.Help",{
								"tab":10,
								"subtab":3
						});
				}
				
				public function HidePages() : void {
						this.PROFILE_PAGE.visible = false;
						this.MESSAGES_PAGE.visible = false;
						this.FRIENDS_PAGE.visible = false;
						this.SETTINGS_PAGE.visible = false;
						this.SETTINGS_PAGE.EraseInputs();
						this.MISSIONS_PAGE.visible = false;
						this.SCHOOLS_PAGE.visible = false;
						this.SetIntputs(false);
				}
				
				public function SetIntputs(_enabled:Boolean = false) : void {
						trace("Profile2.SetIntputs",_enabled);
						Imitation.EnableInput(this.PROFILE_PAGE,false);
						Imitation.EnableInput(this.MESSAGES_PAGE,false);
						Imitation.EnableInput(this.FRIENDS_PAGE,false);
						Imitation.EnableInput(this.SETTINGS_PAGE,false);
						Imitation.EnableInput(this.MISSIONS_PAGE,false);
						Imitation.EnableInput(this.SCHOOLS_PAGE,false);
				}
				
				public function DrawProfilePage(_data:Object = null) : void {
						if(_data == null) {
								_data = this.usersdata;
						}
						Imitation.EnableInput(this.PROFILE_PAGE,true);
						this.PROFILE_PAGE.Start(_data);
						this.PROFILE_PAGE.visible = true;
				}
				
				public function DrawMessagesPage() : void {
						Imitation.EnableInput(this.MESSAGES_PAGE,true);
						this.MESSAGES_PAGE.visible = true;
						this.MESSAGES_PAGE.Start();
				}
				
				public function DrawFriendsPage() : void {
						this.FRIENDS_PAGE.visible = true;
						Imitation.EnableInput(this.FRIENDS_PAGE,true);
						this.FRIENDS_PAGE.Start();
				}
				
				public function DrawSettingsPage(_data:Object = null) : void {
						Imitation.EnableInput(this.SETTINGS_PAGE,true);
						if(_data == null) {
								_data = this.usersdata;
						}
						this.SETTINGS_PAGE.Start(_data);
						this.SETTINGS_PAGE.visible = true;
				}
				
				public function DrawMissionsPage() : void {
						this.MISSIONS_PAGE.visible = true;
						if(!this.MISSIONS_PAGE.MISSION_LIST.started) {
								this.MISSIONS_PAGE.MISSION_LIST.Start();
								this.MISSIONS_PAGE.NPC.Set("VETERAN","DEFAULT");
								Util.SetText(this.MISSIONS_PAGE.LABEL.FIELD,Lang.Get("mission_tip"));
								if(this.MISSIONS_PAGE.LABEL.FIELD.numLines == 1) {
										this.MISSIONS_PAGE.LABEL.FIELD.y = 23;
								}
								if(this.MISSIONS_PAGE.LABEL.FIELD.numLines == 2) {
										this.MISSIONS_PAGE.LABEL.FIELD.y = 18;
								}
								if(this.MISSIONS_PAGE.LABEL.FIELD.numLines == 3) {
										this.MISSIONS_PAGE.LABEL.FIELD.y = 13;
								}
								if(this.MISSIONS_PAGE.LABEL.FIELD.numLines == 4) {
										this.MISSIONS_PAGE.LABEL.FIELD.y = 9;
								}
								if(this.MISSIONS_PAGE.LABEL.FIELD.numLines >= 5) {
										this.MISSIONS_PAGE.LABEL.FIELD.y = 0;
								}
								Imitation.CollectChildrenAll(this);
						}
				}
				
				public function DrawSchoolsPage(_data:Object = null) : void {
						Imitation.EnableInput(this.SCHOOLS_PAGE,true);
						this.SCHOOLS_PAGE.Start();
						this.SCHOOLS_PAGE.visible = true;
				}
		}
}

