package invite {
		import flash.display.MovieClip;
		import flash.events.*;
		import flash.net.URLRequest;
		import flash.net.navigateToURL;
		import flash.text.*;
		import syscode.*;
		import uibase.ScrollBarMov;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol94")]
		public class Invite extends MovieClip {
				public static var mc:Invite = null;
				
				public static var invitableFriendList:Array = [];
				
				public static var listItems:Array = [];
				
				public static var selectedFriends:Array = [];
				
				public static var funnelid:String = "";
				
				public static var tutorialCallBack:Function = null;
				
				public var BTNCLOSE:MovieClip;
				
				public var BTNFANPAGE:MovieClip;
				
				public var BTNSEND:MovieClip;
				
				public var CB:CheckBox;
				
				public var C_CB:TextField;
				
				public var EDSEARCH:TextField;
				
				public var ITEMS:Items1;
				
				public var SB:ScrollBarMov;
				
				public var SCROLLRECT:MovieClip;
				
				public var SELECTED:TextField;
				
				public var TITLE:TextField;
				
				public function Invite() {
						super();
				}
				
				private static function OnBtnSendClick(e:*) : void {
						Util.ExternalCall("console.log","BtnSendClick",selectedFriends.length);
						var list:Array = [];
						for(var i:int = 0; i < selectedFriends.length; i++) {
								if(selectedFriends[i]) {
										list.push(selectedFriends[i].invite_token);
										if(list.length >= 50) {
												break;
										}
								}
						}
						if(list.length > 0) {
								mc.BTNSEND.BTN.SetEnabled(false);
								if(Config.mobile) {
										Platform.FacebookInvite(list.join(),Lang.Get("invite_new_user"),Lang.Get("invite_message"),Invite.mc.Hide);
										return;
								}
								Util.ExternalCall("InviteFriends",list);
						}
						Invite.mc.Hide();
				}
				
				public function OnCloseClicked(arg:Object) : void {
						if(this.BTNCLOSE.BUTTON.visible) {
								this.Hide();
						} else {
								Platform.ExitApplication();
						}
				}
				
				public function Prepare(aparams:Object) : void {
						listItems = [];
						invitableFriendList = [];
						selectedFriends = [];
						Platform.AddBackHandler(mc.OnCloseClicked);
						Invite.tutorialCallBack = aparams.callback;
						Invite.funnelid = aparams.funnelid;
						this.BTNCLOSE.BUTTON.AddEventClick(this.OnCloseClicked);
						this.BTNCLOSE.BUTTON.SetCaption("X");
						this.BTNSEND.BTN.SetEnabled(true);
						this.BTNSEND.BTN.AddEventClick(OnBtnSendClick);
						this.DrawSendButton();
						Imitation.AddEventClick(this.BTNFANPAGE,this.OnFanpageClick);
						Lang.Set(this.TITLE,"invite_friends_title");
						this.EDSEARCH.text = "";
						Util.AddEventListener(this.EDSEARCH,Event.CHANGE,this.FilterItems);
						Util.RTLEditSetup(this.EDSEARCH);
						Imitation.AddEventClick(this.CB,this.OnSelectAll);
						this.CB.selected = false;
						this.CB.CHECK.visible = false;
						Lang.Set(this.C_CB,"select_all");
						this.SELECTED.text = "";
						this.ITEMS.Set("ITEM",listItems,80,3,this.ClickItem,this.DrawItem,this.SCROLLRECT,this.SB);
						this.EDSEARCH.visible = false;
						Friends.LoadInvitableFriends(this.DataReady);
						aparams.waitfordata = true;
				}
				
				private function OnFanpageClick(e:* = null) : void {
						var request:* = new URLRequest(Config["facebook_fp_url_" + Config.siteid]);
						navigateToURL(request,"_blank");
				}
				
				public function Hide(e:* = null) : void {
						if(this.EDSEARCH) {
								Util.RemoveEventListener(this.EDSEARCH,Event.CHANGE,this.FilterItems);
						}
						Platform.RemoveBackHandler(mc.OnCloseClicked);
						WinMgr.CloseWindow(this);
				}
				
				public function AfterOpen() : void {
						this.FilterItems();
				}
				
				public function AfterClose() : void {
						if(tutorialCallBack != null) {
								tutorialCallBack("Invite_after_close");
						}
				}
				
				public function DataReady(e:* = null) : void {
						Invite.invitableFriendList = Invite.invitableFriendList.concat(Friends.invitable);
						Invite.selectedFriends = invitableFriendList.slice();
						if(Invite.selectedFriends) {
								this.CB.selected = true;
								this.CB.CHECK.visible = true;
						}
						this.DrawSendButton();
						Lang.Set(this.SELECTED,"n_selected_to_invite",selectedFriends.length);
						WinMgr.WindowDataArrived(this);
				}
				
				public function FilterItems(e:* = null) : void {
						listItems = [];
						var fstr:String = Util.UpperCase(Util.GetRTLEditText(this.EDSEARCH));
						for(var i:int = 0; i < invitableFriendList.length; i++) {
								if(Util.UpperCase(invitableFriendList[i].name).indexOf(fstr) >= 0) {
										listItems.push(invitableFriendList[i]);
								}
						}
						this.EDSEARCH.visible = true;
						this.ITEMS.SetItems(listItems);
				}
				
				private function OnSelectAll(e:*) : void {
						this.EDSEARCH.text = "";
						if(this.CB.selected) {
								selectedFriends = [];
						} else {
								selectedFriends = invitableFriendList.slice();
						}
						this.CB.selected = !this.CB.selected;
						this.CB.CHECK.visible = this.CB.selected;
						Lang.Set(this.SELECTED,"n_selected_to_invite",selectedFriends.length);
						this.FilterItems();
						this.DrawSendButton();
				}
				
				private function ClickItem(item:InviteUserSelect, idx:int) : void {
						var n:int = int(selectedFriends.indexOf(listItems[idx]));
						if(n == -1) {
								selectedFriends.push(listItems[idx]);
						} else {
								selectedFriends.splice(n,1);
						}
						Lang.Set(this.SELECTED,"n_selected_to_invite",selectedFriends.length);
						this.DrawItem(item,idx);
						this.DrawSendButton();
				}
				
				public function DrawItem(item:InviteUserSelect, idx:int) : * {
						var b:* = undefined;
						var username:String = null;
						if(!item) {
								return;
						}
						if(listItems[idx]) {
								b = selectedFriends.indexOf(listItems[idx]) >= 0;
								item.SELECTED.visible = b;
								item.CHECKBOX.CHECK.visible = b;
								username = Romanization.ToLatin(listItems[idx].name);
								item.AVATAR.ShowExternal(listItems[idx].invite_token,listItems[idx].avatar);
								item.STAMP.visible = false;
								item.STAMP.gotoAndStop(1);
								item.visible = true;
								Util.SetText(item.NAME,username);
						} else {
								item.visible = false;
						}
				}
				
				private function DrawSendButton() : void {
						if(Invite.selectedFriends.length > 0) {
								this.BTNSEND.BTN.SetLang("invite");
								this.BTNSEND.BTN.skin = "OK";
						} else {
								this.BTNSEND.BTN.SetLang("later_thanks");
								this.BTNSEND.BTN.skin = "NORMAL";
						}
				}
		}
}

