package profile2 {
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol577")]
		public class FriendsPage extends MovieClip {
				public var BUBBLE:MovieClip;
				
				public var CB_1:RadioButton;
				
				public var CB_2:RadioButton;
				
				public var CB_3:RadioButton;
				
				public var EDSEARCH:MovieClip;
				
				public var FRIEND_LIST:MovieClip;
				
				public var INFO:MovieClip;
				
				public var NPC:LegoCharacters;
				
				public var state:String = "friends";
				
				private var filteredFriends:Array;
				
				public function FriendsPage() {
						var i:int = 0;
						var cb:MovieClip = null;
						super();
						for(i = 1; i <= 3; i++) {
								cb = this["CB_" + i];
								cb.CHECK.visible = false;
								Imitation.AddEventClick(cb,this.OnCheckboxClick,{"index":i});
						}
						Util.AddEventListener(this.EDSEARCH.FIELD,"change",this.FilterChanged);
				}
				
				public function Start(_data:Object = null) : void {
						this.Draw(_data);
				}
				
				public function Draw(_obj:Object) : void {
						this.SetState(this.state);
				}
				
				public function SetState(_state:String = "friends") : void {
						this.state = _state;
						this.SetNPC();
						this.SetRadioButtons();
						if(this.state == "friends") {
								this.FilterFriends(1);
						}
						if(this.state == "invited") {
								this.FilterFriends(2);
						}
						if(this.state == "blocked") {
								this.FilterFriends(3);
						}
				}
				
				public function SetNPC() : void {
						if(this.state == "friends") {
								Util.SetText(this.INFO.FIELD,Lang.Get("postoffice_friends_empty"));
								this.NPC.Set("INNKEEPER","DEFAULT");
						} else if(this.state == "invited") {
								Util.SetText(this.INFO.FIELD,Lang.Get("postoffice_invitations_empty"));
								this.NPC.Set("CEREMONY_MASTER","DEFAULT");
						} else if(this.state == "blocked") {
								Util.SetText(this.INFO.FIELD,Lang.Get("postoffice_blocked_empty"));
								this.NPC.Set("HEADSMAN","DEFAULT");
						}
						if(this.INFO.FIELD.numLines == 1) {
								this.INFO.FIELD.y = 29;
						}
						if(this.INFO.FIELD.numLines == 2) {
								this.INFO.FIELD.y = 21;
						}
						if(this.INFO.FIELD.numLines == 3) {
								this.INFO.FIELD.y = 15;
						}
						if(this.INFO.FIELD.numLines == 4) {
								this.INFO.FIELD.y = 8;
						}
						if(this.INFO.FIELD.numLines >= 5) {
								this.INFO.FIELD.y = 0;
						}
				}
				
				public function SetRadioButtons() : void {
						var i:int = 0;
						var cb:MovieClip = null;
						for(i = 1; i <= 3; i++) {
								cb = this["CB_" + i];
								cb.CHECK.visible = false;
						}
						if(this.state == "friends") {
								this.CB_1.CHECK.visible = true;
						} else if(this.state == "invited") {
								this.CB_2.CHECK.visible = true;
						} else if(this.state == "blocked") {
								this.CB_3.CHECK.visible = true;
						}
				}
				
				public function OnCheckboxClick(e:Object) : void {
						if(e.params.index == 1) {
								this.SetState("friends");
						}
						if(e.params.index == 2) {
								this.SetState("invited");
						}
						if(e.params.index == 3) {
								this.SetState("blocked");
						}
				}
				
				private function FilterChanged(e:Object) : void {
						var name:String = Util.GetRTLEditText(this.EDSEARCH.FIELD);
						if(this.state == "friends") {
								this.FilterFriends(1,name);
						}
						if(this.state == "invited") {
								this.FilterFriends(2,name);
						}
						if(this.state == "blocked") {
								this.FilterFriends(3,name);
						}
				}
				
				public function FilterFriends(_flag:int = 1, _name:String = "") : void {
						var i:int = 0;
						var friend:Object = null;
						this.filteredFriends = new Array();
						for(i = 0; i < Friends.all.length; i++) {
								friend = Friends.all[i];
								trace(friend.name,friend.flag);
								if(_flag == 1 && friend.flag == 0) {
										trace("ismerősnek jelöltem");
										this.filteredFriends.push(friend);
								}
								if(friend.flag == _flag) {
										if(_name != "") {
												if(friend.name.toLowerCase().indexOf(_name.toLowerCase()) > -1) {
														this.filteredFriends.push(friend);
												}
										} else {
												this.filteredFriends.push(friend);
										}
								}
						}
						this.filteredFriends.sort(function(a:*, b:*):* {
								return a.name.localeCompare(b.name);
						});
						this.FRIEND_LIST.FLINES.Set("FLINE",this.filteredFriends,37,1,this.OnFriendListClick,this.DrawFriendLine,this.FRIEND_LIST.MASK_LINES,this.FRIEND_LIST.SB);
						this.FRIEND_LIST.SB.ScrollTo(0,0);
						this.FRIEND_LIST.SB.dragging = true;
				}
				
				public function OnFriendListClick(_item:MovieClip, _id:int) : void {
				}
				
				public function DrawFriendLine(_item:MovieClip, _id:int) : void {
						if(this.filteredFriends[_id]) {
								_item.visible = true;
								_item.AVATAR.ShowUID(this.filteredFriends[_id].id);
								_item.FBICON.visible = false;
								Util.SetText(_item.CNAME.FIELD,this.filteredFriends[_id].name);
								if(this.state == "friends") {
										_item.BTN_OK.visible = false;
										_item.BTN_OK.SetIcon("PIPE_WHITE");
										_item.BTN_NO.visible = true;
										_item.BTN_NO.SetIcon("X");
										if(this.filteredFriends[_id].flag == 0) {
												_item.gotoAndStop(2);
										}
										_item.BTN_NO.AddEventClick(function():* {
												Modules.GetClass("uibase","uibase.MessageWin").AskYesNo(Lang.Get("cancel_friendship"),Lang.Get("ask_cancel_friendship"),Lang.Get("yes"),Lang.Get("cancel"),function(result:*):* {
														if(result == 1) {
																Friends.CancelFriendShip(filteredFriends[_id].id,MovieClip(parent).OnFriendsChanged);
														}
												});
										});
										if(this.filteredFriends[_id].external) {
												_item.BTN_NO.SetEnabled(false);
												_item.FBICON.visible = true;
										}
								}
								if(this.state == "invited") {
										_item.BTN_OK.visible = true;
										_item.BTN_OK.SetIcon("PIPE_WHITE");
										_item.BTN_OK.AddEventClick(function():* {
												Friends.AddFriendShip(filteredFriends[_id].id,MovieClip(parent).OnFriendsChanged);
										});
										_item.BTN_NO.visible = false;
										_item.BTN_NO.SetIcon("X");
								}
								if(this.state == "blocked") {
										_item.BTN_OK.visible = true;
										_item.BTN_OK.SetIcon("LOCK_OUT_WHITE");
										_item.BTN_OK.AddEventClick(function():* {
												Friends.CancelBlock(filteredFriends[_id].id,MovieClip(parent).OnFriendsChanged);
										});
										_item.BTN_NO.visible = false;
										_item.BTN_NO.SetIcon("X");
								}
								Imitation.AddEventClick(_item.BG,function():* {
										WinMgr.RemoveWindow("profile2.Profile2");
										WinMgr.OpenWindow("profile2.Profile2",{"user_id":filteredFriends[_id].id});
								});
						} else {
								_item.visible = false;
						}
				}
				
				public function Destroy() : void {
						var i:int = 0;
						var cb:MovieClip = null;
						trace("FriendsPage.Destroy");
						Util.RemoveEventListener(this.EDSEARCH.FIELD,"change",this.FilterChanged);
						for(i = 1; i <= 3; i++) {
								cb = this["CB_" + i];
								Imitation.RemoveEvents(cb);
						}
				}
		}
}

