package postoffice {
		import com.greensock.TweenMax;
		import components.ButtonComponent;
		import flash.display.MovieClip;
		import flash.text.TextField;
		import syscode.*;
		import uibase.ScrollBarMov;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol82")]
		public class PostOffice extends MovieClip {
				public static var hasmorelines:Boolean;
				
				public static var mc:PostOffice = null;
				
				private static var windowopened:Boolean = false;
				
				public static var current_type:String = "FRIENDS";
				
				public static var current_page:int = 1;
				
				public static var tab_titles:* = ["your_friends","invitations","blocked_users","inbox","outbox"];
				
				public static var newmessages:int = 0;
				
				public static var incount:int = 0;
				
				public static var outcount:int = 0;
				
				public static var maxin:int = 500;
				
				public static var maxout:int = 500;
				
				public static var pagecaptions:Array = ["","inbox","outbox","write_letter"];
				
				public static var allmessages:Array = [];
				
				public static var messages:Array = [];
				
				public static var loading:Boolean = false;
				
				public static var firstload:Boolean = true;
				
				public static var firstitem:int = 0;
				
				public static var message:Object = null;
				
				public static var prior_msg_id:String = "0";
				
				public static var linelimit:int = 50;
				
				public var BACK:MovieClip;
				
				public var BTNCLOSE:ButtonComponent;
				
				public var BTNINVITE:ButtonComponent;
				
				public var CHAR:MovieClip;
				
				public var CONTENT:MovieClip;
				
				public var EDSEARCH:TextField;
				
				public var MASK:MovieClip;
				
				public var MESSAGES:maillist;
				
				public var SB:ScrollBarMov;
				
				public var T1:MovieClip;
				
				public var T2:MovieClip;
				
				public var T3:MovieClip;
				
				public var T4:MovieClip;
				
				public var T5:MovieClip;
				
				public var mylist:Array;
				
				public var isempty:Boolean = false;
				
				public var selcnt:int = 0;
				
				public var currentfilter:int = 0;
				
				private var itemh:int = 30;
				
				public function PostOffice() {
						this.mylist = [];
						super();
						this.__setProp_BTNINVITE_FriendsWindowMov_content_0();
						this.__setProp_BTNCLOSE_FriendsWindowMov_Layer5_0();
				}
				
				public static function UpdateList(fromindex:int = 0, scroll:* = 0) : * {
						if(current_type != "MAILS") {
								return;
						}
						if(loading) {
								return;
						}
						if(fromindex == 0) {
								messages = [];
								allmessages = [];
								hasmorelines = false;
								firstitem = 0;
						}
						loading = true;
						JsQuery.Load(ProcessMessages,[true,fromindex,scroll],"client_messages.php?" + Sys.FormatGetParamsStoc({
								"cmd":"list",
								"first":fromindex,
								"postbox":(current_page == 1 ? "to" : "from"),
								"lines":linelimit + 1
						},true));
				}
				
				public static function ProcessMessages(jsq:Object, draw:Boolean, first:int, scroll:int = 0) : * {
						var n:String = null;
						DBG.Trace("!!!!JSQ",jsq);
						loading = false;
						if(jsq == null || Boolean(jsq.error)) {
								return;
						}
						allmessages = allmessages.slice(0,first);
						hasmorelines = false;
						var lcnt:int = 0;
						for(n in jsq.data) {
								lcnt++;
								if(lcnt > linelimit) {
										hasmorelines = true;
										break;
								}
								allmessages.push(jsq.data[n]);
						}
						FilterMails(Util.GetRTLEditText(mc.EDSEARCH));
						mc.SB.ScrollTo(scroll);
				}
				
				public static function FilterMails(filter:String) : * {
						var uname:* = undefined;
						var a:String = null;
						var b:String = null;
						messages = [];
						var f:String = filter.toLowerCase();
						for(var i:int = 0; i < allmessages.length; i++) {
								uname = allmessages[i].toid == Sys.mydata.id ? allmessages[i].fromname : allmessages[i].toname;
								a = uname.toLowerCase().replace(/&lt;/gi,"<").replace(/&gt;/gi,">");
								b = allmessages[i].title.toLowerCase().replace(/&lt;/gi,"<").replace(/&gt;/gi,">");
								if(a.indexOf(filter) > -1 || b.indexOf(filter) > -1) {
										messages.push(allmessages[i]);
								}
						}
						if(hasmorelines) {
								messages.push({
										"name":"",
										"time":"",
										"id":-1
								});
						}
						mc.MASK.visible = true;
						mc.MESSAGES.visible = true;
						mc.MESSAGES.Set("LINE",messages,mc.itemh,1,mc.LineClick,mc.DrawMessageListItem,mc.MASK,mc.SB);
				}
				
				public static function UpdateItem(mid:String, flag:int = 0) : * {
						if(current_type != "MAILS") {
								return;
						}
						if(loading) {
								return;
						}
						var draw:* = flag == 2;
						firstitem = 0;
						messages = [];
						mc.MESSAGES.visible = false;
						loading = true;
						JsQuery.Load(ProcessMessages,[draw,firstitem],"client_messages.php?" + Sys.FormatGetParamsStoc({
								"cmd":"set",
								"msgid":mid,
								"postbox":(current_page == 1 ? "to" : "from"),
								"flag":flag
						},true));
				}
				
				public static function OpenMessage(mid:String) : * {
						var uid:* = undefined;
						var message:Object = null;
						for(var i:int = 0; i < messages.length; i++) {
								if(messages[i].id == mid) {
										message = messages[i];
										break;
								}
						}
						if(message) {
								if(message.flag == 0 && current_page == 1) {
										--newmessages;
								}
								if(message.flag != 1) {
										UpdateItem(mid,1);
								}
								if(mc.SB.visible && Boolean(Modules.GetClass("uibase","uibase.ScrollBarMov").global_dragging)) {
										return;
								}
								uid = message.toid == Sys.mydata.id ? message.fromid : message.toid;
								WinMgr.OpenWindow("profile.Profile",{
										"user_id":uid,
										"fadeIn":"left",
										"fadeOut":"left",
										"page":"MAILS",
										"message":message
								});
						}
				}
				
				public function Prepare(aparams:Object) : void {
						current_type = Util.StringVal(aparams.type,"FRIENDS");
						current_page = Util.NumberVal(aparams.page,1);
						Util.StopAllChildrenMov(this);
						this.CHAR.visible = false;
						this.CONTENT.visible = false;
						mc.BTNINVITE.SetLangAndClick("invite",this.SendInvite);
						mc.BTNINVITE.visible = Config.loginsystem == "FACE";
						mc.BTNCLOSE.AddEventClick(this.Hide);
						mc.BTNCLOSE.SetCaption("X");
						this.itemh = mc.CONTENT.FRIENDS.LIST.ITEM3.y - mc.CONTENT.FRIENDS.LIST.ITEM1.y;
						for(var i:int = 1; i <= 5; i++) {
								Lang.Set(mc["T" + i].CAPTION,tab_titles[i - 1]);
						}
						Imitation.AddGlobalListener("FRIENDSCHANGED",this.OnFriendsChanged);
				}
				
				public function AfterOpen() : void {
						windowopened = true;
						this.SetActivePage(current_type,current_page);
				}
				
				public function Hide(e:* = null) : void {
						if(this.EDSEARCH) {
								Util.RemoveEventListener(this.EDSEARCH,"change",this.MailsFilterChanged);
						}
						if(Boolean(this.CONTENT) && Boolean(this.CONTENT.EDSEARCH)) {
								Util.RemoveEventListener(this.CONTENT.EDSEARCH,"change",this.FilterChanged);
						}
						Imitation.RemoveGlobalListener("FRIENDSCHANGED",this.OnFriendsChanged);
						WinMgr.CloseWindow(this);
				}
				
				private function SortFilteredItems() : void {
						var order:Function = null;
						order = function(a:Object, b:Object):int {
								var cmp:int = int(a.sort.localeCompare(b.sort));
								if(cmp != 0) {
										return cmp;
								}
								return a.id < b.id ? -1 : 1;
						};
						if(this.mylist) {
								this.mylist = this.mylist.sort(order);
						}
				}
				
				private function FilterFriends(flag:int, name:String, auto:Boolean = true) : void {
						var f:Object = null;
						var fok:* = false;
						var nok:* = false;
						var j:int = 0;
						var n:String = name == null ? "" : name.toLocaleLowerCase();
						this.mylist = [];
						this.isempty = true;
						for(var i:int = 0; i < Friends.all.length; i++) {
								f = Friends.all[i];
								if(f["sort"] == undefined) {
										f.sort = f.name.toLocaleLowerCase();
								}
								fok = true;
								nok = true;
								if(flag > 0) {
										fok = f.flag == flag;
								} else {
										fok = f.flag == 0 || f.flag == 1;
								}
								if(flag == 2) {
										for(j = 0; j < Friends.all.length; j++) {
												if(f.id == Friends.all[j].id && Friends.all[j].flag == 3) {
														fok = false;
														break;
												}
										}
								}
								if(fok) {
										this.isempty = false;
								}
								if(name != null && name.length > 0) {
										nok = f.sort.indexOf(n) >= 0;
								}
								if(fok && nok) {
										f.checked = false;
										this.mylist.push(f);
								}
						}
						this.SortFilteredItems();
						this.selcnt = 0;
						if(auto) {
								this.CONTENT.FRIENDS.LIST.SetItems(this.mylist);
						}
						this.CONTENT.SEARCH2.visible = this.CONTENT.EDSEARCH.visible = !this.isempty;
				}
				
				private function FilterChanged(e:Object) : void {
						var name:String = Util.GetRTLEditText(this.CONTENT.EDSEARCH);
						this.FilterFriends(this.currentfilter,name);
				}
				
				private function ClickListItem(item:UserSelect, idx:int) : void {
						var f:Object = null;
						if(Modules.GetClass("uibase","uibase.ScrollBarMov").global_dragging) {
								return;
						}
						WinMgr.OpenWindow("profile.Profile",{
								"user_id":this.mylist[idx].id,
								"fadeIn":"left",
								"fadeOut":"left"
						});
				}
				
				private function DrawListItem(item:UserSelect, idx:int) : void {
						var f:Object = null;
						if(!item) {
								return;
						}
						if(idx >= 0 && idx < this.mylist.length) {
								f = this.mylist[idx];
								item.gotoAndStop(f.flag == 0 ? 2 : 1);
								item.AVATAR.ShowUID(f.id);
								Util.SetText(item.NAME,f.name);
								item.HILITE.visible = f.checked;
								item.EXTERNALICON.visible = f.external;
								item.visible = true;
						} else {
								item.visible = false;
						}
				}
				
				private function SendMessageClicked(e:Object) : void {
				}
				
				public function OnFriendsChanged(e:* = null) : void {
						if(current_type != "FRIENDS") {
								return;
						}
						trace("OnFriendsChanged");
						this.DrawFriendsPage(current_page);
				}
				
				private function SendInvite(e:*) : void {
						trace("SendInvite:",Config.loginsystem);
						WinMgr.OpenWindow("invite.Invite",{"funnelid":"FRIENDS"});
				}
				
				public function DrawTabs() : * {
						var tab:MovieClip = null;
						var active:* = undefined;
						var framename:* = undefined;
						for(var n:int = 1; n <= 5; n++) {
								tab = this["T" + n];
								tab.visible = true;
								active = n == current_page + (current_type == "MAILS" ? 3 : 0);
								framename = !!active ? "ACTIVE" : "INACTIVE";
								tab.gotoAndStop(framename);
								Imitation.AddEventClick(tab,this.OnTabClick);
								tab.useHandCursor = !active;
						}
				}
				
				public function OnTabClick(e:* = null) : * {
						var tab:* = e.target;
						var num:int = Util.IdFromStringEnd(tab.name);
						if(num <= 3) {
								this.SetActivePage("FRIENDS",num);
						} else {
								this.SetActivePage("MAILS",num - 3);
						}
				}
				
				public function SetActivePage(atype:*, apage:*) : * {
						current_page = apage;
						current_type = atype;
						if(current_type == "FRIENDS") {
								this.DrawFriendsPage(apage);
						} else if(current_type == "MAILS") {
								this.DrawMailsPage(apage);
						}
						this.DrawTabs();
				}
				
				private function DrawFriendsPage(apage:* = 1) : void {
						var filters:* = [0,2,3];
						var infos:* = ["postoffice_friends","postoffice_invitations","postoffice_blocked"];
						trace("DrawFriendsPage");
						mc.gotoAndStop("FRIENDS");
						Util.StopAllChildrenMov(mc);
						var w:MovieClip = this.CONTENT;
						mc.BTNCLOSE.AddEventClick(this.Hide);
						mc.BTNCLOSE.SetCaption("X");
						var h:int = w.FRIENDS.LIST.ITEM3.y - w.FRIENDS.LIST.ITEM1.y;
						this.CONTENT.EDSEARCH.text = "";
						Util.AddEventListener(this.CONTENT.EDSEARCH,"change",this.FilterChanged);
						Util.RTLEditSetup(this.CONTENT.EDSEARCH);
						this.CONTENT.visible = true;
						this.currentfilter = filters[apage - 1];
						if(windowopened) {
								this.FilterFriends(this.currentfilter,"",false);
						}
						mc.CHAR.visible = this.isempty;
						mc.CHAR.gotoAndStop(apage + 1);
						Lang.Set(mc.CHAR.INFO,infos[apage - 1] + "_empty");
						w.CHAR.visible = !this.isempty;
						if(Config.loginsystem == "FACE" && !Config.mobile && apage < 3) {
								w.CHAR.gotoAndStop(1);
						} else {
								w.CHAR.gotoAndStop(apage + 1);
						}
						Lang.Set(w.CHAR.INFO,infos[apage - 1] + "_more");
						w.FRIENDS.LIST.Set("ITEM",this.mylist,this.itemh,2,this.ClickListItem,this.DrawListItem,w.FRIENDS.MASK,w.FRIENDS.SB);
				}
				
				private function DrawMailsPage(apage:* = 1) : void {
						mc.gotoAndStop("MAILS");
						Util.StopAllChildrenMov(mc);
						this.Clear();
						mc.MASK.visible = false;
						UpdateList();
						this.DrawTabs();
						this.EDSEARCH.text = "";
						Util.AddEventListener(this.EDSEARCH,"change",this.MailsFilterChanged);
						TweenMax.delayedCall(0,Util.RTLEditSetup,[this.EDSEARCH]);
				}
				
				private function MailsFilterChanged(e:Object) : void {
						FilterMails(Util.GetRTLEditText(this.EDSEARCH));
						mc.MESSAGES.Draw();
				}
				
				public function DrawMessageListItem(mov:MovieClip, id:int) : * {
						var uid:* = undefined;
						var uname:* = undefined;
						if(!mov) {
								return;
						}
						var msg:* = messages[id];
						if(msg) {
								mov.visible = true;
								if(msg.id == -1) {
										mov.gotoAndStop(3);
										Imitation.GotoFrame(mov.BG,4);
										mov.BTNMORE.SetEnabled(true);
										mov.BTNMORE.SetLangAndClick("show_older_msg",this.LoadMoreClick);
										Imitation.RemoveEvents(mov);
								} else {
										if(mov.HILITE) {
												mov.HILITE.visible = false;
										}
										uid = msg.toid == Sys.mydata.id ? msg.fromid : msg.toid;
										uname = msg.toid == Sys.mydata.id ? msg.fromname : msg.toname;
										if(parseInt(msg.fromid) == 0) {
												Imitation.GotoFrame(mov.BG,3);
										} else {
												Imitation.GotoFrame(mov.BG,parseInt(msg.flag) == 1 ? 1 : 2);
										}
										mov.AVATAR.ShowUID(uid);
										Util.SetText(mov.TITLE,msg.title);
										Util.SetText(mov.NAME,Util.StringVal(uname));
										Imitation.AddEventClick(mov.BTNDELETE,this.DeleteItemClick);
										Imitation.AddEventMouseOver(mov.BTNDELETE,this.OnBtnDeletOver);
										Imitation.AddEventMouseOut(mov.BTNDELETE,this.OnBtnDeletOut);
								}
						} else {
								Imitation.RemoveEvents(mov);
								mov.visible = false;
								mov.stop();
								mov.BG.stop();
						}
				}
				
				public function Clear() : * {
						var mov:* = undefined;
						for(var i:int = 1; i <= 6; i++) {
								mov = this.MESSAGES["LINE" + i];
								mov.visible = false;
								mov.stop();
						}
						this.SB.visible = false;
				}
				
				private function OnBtnDeletOver(e:*) : void {
						Imitation.GotoFrame(e.target,2);
				}
				
				private function OnBtnDeletOut(e:*) : void {
						Imitation.GotoFrame(e.target,1);
				}
				
				public function DeleteItemClick(e:*) : * {
						var mid:* = undefined;
						var MessageWin:* = Modules.GetClass("uibase","uibase.MessageWin");
						mid = messages[e.target.parent.id].id;
						MessageWin.AskYesNo(Lang.get("delete"),Lang.get("ask_delete_msg"),Lang.get("yes"),Lang.get("no"),function(a:*):* {
								if(a == 1) {
										UpdateItem(mid,2);
								}
						});
				}
				
				public function LineClick(item:*, idx:*) : * {
						OpenMessage(messages[idx].id);
				}
				
				public function LoadMoreClick(e:*) : * {
						e.target.SetEnabled(false);
						UpdateList(allmessages.length,mc.SB.firstpos);
				}
				
				internal function __setProp_BTNINVITE_FriendsWindowMov_content_0() : * {
						try {
								this.BTNINVITE["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTNINVITE.enabled = true;
						this.BTNINVITE.fontsize = "BIG";
						this.BTNINVITE.icon = "";
						this.BTNINVITE.skin = "OK";
						this.BTNINVITE.testcaption = "Ask Friends";
						this.BTNINVITE.visible = true;
						this.BTNINVITE.wordwrap = false;
						try {
								this.BTNINVITE["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_BTNCLOSE_FriendsWindowMov_Layer5_0() : * {
						try {
								this.BTNCLOSE["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTNCLOSE.enabled = true;
						this.BTNCLOSE.fontsize = "BIG";
						this.BTNCLOSE.icon = "X";
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
		}
}

