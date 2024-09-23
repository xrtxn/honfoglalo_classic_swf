package clan {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import flash.events.MouseEvent;
		import flash.events.TextEvent;
		import syscode.*;
		import uibase.ScrollBarMov7;
		import uibase.lego_button_1x1_normal_header;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol631")]
		public class MemberList extends MovieClip {
				public static var active:Boolean = false;
				
				public static var currentcmd:String = "";
				
				public static var visiblemembers:Array = [];
				
				public static var highlightfriend:Object = null;
				
				public static var chatbuf:LegoChatMessageBuffer = new LegoChatMessageBuffer();
				
				public static var historylines:Array = [];
				
				public static var history_n:Number = 0;
				
				public static var applicants:Array = [];
				
				public static var applicants_n:Number = 0;
				
				public static var xpfields:* = ["xp","xppoints","xppoints_weekly","xppoints_weekly_prev"];
				
				public var BTN_CHAT_SEND:lego_button_1x1_normal_header;
				
				public var BUBBLE:MovieClip;
				
				public var CHAT_AVATAR:AvatarMov;
				
				public var CONTAINER_LIST:MovieClip;
				
				public var GRAPHICS:background_shape_6x9;
				
				public var INPUT_CHAT:MovieClip;
				
				public var MASK:MovieClip;
				
				public var MESSAGES:MovieClip;
				
				public var SB_CHAT:ScrollBarMov7;
				
				public var TAB_1:MovieClip;
				
				public var TAB_2:MovieClip;
				
				public var TAB_3:MovieClip;
				
				private var currentpos:int = 0;
				
				private var currenttab:Number = 1;
				
				public function MemberList() {
						super();
						history_n = 0;
						historylines = [];
						applicants_n = 0;
						applicants = [];
						chatbuf.num = 9;
						chatbuf.clanchat = true;
				}
				
				public static function trace(... arguments) : * {
						MyTrace.myTrace(arguments);
				}
				
				public static function UpdateHighlightFriend() : void {
						var i:int = 0;
						MemberList.highlightfriend = null;
						var p:Object = Clan.myclanproperties;
						if(!p) {
								return;
						}
						var tag:Object = null;
						var myadminright:Number = Util.NumberVal(p.alliance.adminright);
						var activeinvite:* = myadminright > 0;
						if(activeinvite) {
								for(i = 0; i < p.friends.length; i++) {
										tag = p.friends[i];
										if(Boolean(tag) && Util.NumberVal(tag.invited) == 0) {
												MemberList.highlightfriend = tag;
												break;
										}
								}
						}
				}
				
				public static function GetChatMessageDate(_tag:Object) : String {
						if(!_tag) {
								return "";
						}
						var time:String = "";
						var d:Date = new Date();
						d.setTime(1000 * Util.NumberVal(_tag.TS));
						if(Config.siteid == "hu") {
								time = String(d.fullYear).substr(2,4) + ". " + (d.month + 1) + ". " + d.date;
						} else if(Config.siteid == "us") {
								time = d.month + 1 + "/" + d.date + "/" + String(d.fullYear).substr(2,4);
						} else {
								time = d.date + "/" + (d.month + 1) + "/" + String(d.fullYear).substr(2,4);
						}
						return time;
				}
				
				public function Show() : void {
						trace("Clan.Memberlist.Show");
						Util.StopAllChildrenMov(this);
						this.visible = true;
						MemberList.active = true;
						this.currentpos = 0;
						this.MESSAGES.ITEMS.visible = false;
						this.INPUT_CHAT.FIELD.text = "";
						this.Draw();
				}
				
				public function Draw() : void {
						Imitation.CollectChildrenAll(this);
						this.CONTAINER_LIST.visible = false;
						UpdateHighlightFriend();
						this.InitVisibleMembers();
						this.DrawPlayerPanel();
						this.DrawChat();
						this.Activate();
						this.DrawTabs();
				}
				
				private function InitVisibleMembers() : void {
						var i:int = 0;
						var p:Object = Clan.myclanproperties;
						var tag:Object = null;
						if(!p) {
								return;
						}
						var myadminright:Number = Util.NumberVal(p.alliance.adminright);
						var activeinvite:Boolean = myadminright > 0 && Boolean(MemberList.highlightfriend);
						MemberList.visiblemembers = [];
						if(activeinvite) {
								MemberList.visiblemembers = p.members.slice(0);
								for(i = 0; i < p.friends.length; i++) {
										tag = p.friends[i];
										if(tag && Util.NumberVal(tag.invited) == 0 && Util.NumberVal(tag.id) != Util.NumberVal(MemberList.highlightfriend.id)) {
												if(!tag.userid) {
														tag.userid = tag.id;
												}
												tag.xppoints = -1;
												tag.xppoints_weekly = -1;
												tag.xppoints_weekly_prev = -1;
												MemberList.visiblemembers.push(tag);
										}
								}
						} else {
								MemberList.visiblemembers = p.members.slice(0);
						}
						this.OnLoadExdatas();
				}
				
				private function OnLoadExdatas() : void {
						var id:String = null;
						var u:Object = null;
						trace("! OnLoadExdatas");
						var emptydata:Boolean = false;
						for(var i:int = 0; i < MemberList.visiblemembers.length; i++) {
								id = Util.StringVal(MemberList.visiblemembers[i].id) != "" ? Util.StringVal(MemberList.visiblemembers[i].id) : Util.StringVal(MemberList.visiblemembers[i].userid);
								u = Extdata.GetUserData(id);
								if(u == null) {
										emptydata = true;
								}
						}
						if(emptydata) {
								Extdata.GetSheduledData(this.OnLoadExdatas);
						} else {
								this.DrawList();
						}
				}
				
				private function DrawList() : void {
						var p:Object = Clan.myclanproperties;
						var w:MovieClip = this.GRAPHICS;
						var myadminright:Number = Util.NumberVal(p.alliance.adminright);
						var activeinvite:Boolean = myadminright > 0 && Boolean(MemberList.highlightfriend);
						if(activeinvite) {
								this.DrawHighlightLine();
						}
						w = this.CONTAINER_LIST;
						w.visible = true;
						MemberList.visiblemembers.sortOn(xpfields[this.currenttab],Array.DESCENDING | Array.NUMERIC);
						w.MLINES.Set("MLINE",MemberList.visiblemembers,40,1,null,this.DrawLine,w.MASK_LINES,w.SB);
						w.SB.ScrollTo(0,0);
						w.SB.dragging = true;
				}
				
				private function DrawHighlightLine() : void {
				}
				
				private function DrawLine(_item:MovieClip, _id:int) : void {
						var members:Array = null;
						var tag:Object = null;
						var friendly:* = false;
						if(_item) {
								members = MemberList.visiblemembers;
								tag = members[_id];
								if(tag) {
										friendly = tag.id !== undefined;
										if(friendly) {
												_item.MEMBER.visible = false;
												this.DrawInviteLine(_item.INVITE,tag,_id);
										} else {
												_item.INVITE.visible = false;
												this.DrawMemberLine(_item.MEMBER,tag,_id);
										}
										_item.visible = true;
								} else {
										_item.visible = false;
								}
						}
				}
				
				private function DrawInviteLine(_lm:MovieClip, _tag:Object, _id:int) : void {
						var w:MovieClip = null;
						var u:Object = null;
						if(Boolean(_lm) && Boolean(_tag)) {
								w = this;
								u = Extdata.GetUserData(Util.StringVal(_tag.id));
								_lm.visible = true;
								Lang.Set(_lm.TXT_INIVTE.FIELD,"invite_to_my_clan");
								Util.SetText(_lm.TXT_NAME.FIELD,Romanization.ToLatin(Util.StringVal(_tag.name)));
								_lm.OVER.visible = false;
								if(u) {
										_lm.AVATAR.ShowUID(u.id);
								} else {
										_lm.AVATAR.Clear();
								}
								_lm.AVATAR.DisableClick();
								Imitation.AddEventClick(_lm,function(e:Object):* {
										w.OnLineClick(_lm,_id);
								});
								if(!Config.mobile) {
										Imitation.AddEventMouseOver(_lm,function(e:Object):* {
												if(_lm) {
														_lm.OVER.visible = true;
												}
										});
										Imitation.AddEventMouseOut(_lm,function(e:Object):* {
												if(_lm) {
														_lm.OVER.visible = false;
												}
										});
								}
						}
				}
				
				private function DrawMemberLine(_lm:MovieClip, _tag:Object, _id:int) : void {
						var w:MovieClip = null;
						var u:Object = null;
						if(Boolean(_lm) && Boolean(_tag)) {
								w = this;
								u = Extdata.GetUserData(Util.StringVal(_tag.userid));
								_lm.visible = true;
								Util.SetText(_lm.TXT_NAME.FIELD,Romanization.ToLatin(Util.StringVal(_tag.name)));
								Util.SetText(_lm.TXT_ACTIVE.FIELD,_tag.days + " " + Lang.Get("days"));
								Util.SetText(_lm.TXT_INACTIVE.FIELD,_tag.days + " " + Lang.Get("days"));
								if(_lm.RANK) {
										Util.SetText(_lm.RANK.FIELD,String(_id + 1) + ".");
								}
								Lang.Set(_lm.XP.FIELD,"xp");
								Util.SetText(_lm.TXT_XPPOINTS.FIELD,Util.FormatNumber(_tag[xpfields[this.currenttab]]));
								Imitation.GotoFrame(_lm.ICON,Util.NumberVal(_tag.adminright) + 1);
								_lm.BG_ME.visible = _tag.userid == Util.NumberVal(Sys.mydata.id);
								_lm.TXT_ACTIVE.visible = Util.NumberVal(_tag.inactive) == 0;
								_lm.TXT_INACTIVE.visible = !_lm.TXT_ACTIVE.visible;
								_lm.OVER.visible = false;
								if(Boolean(u) && Clan.winopened) {
										_lm.AVATAR.ShowUID(u.id);
								} else {
										_lm.AVATAR.Clear();
								}
								_lm.AVATAR.DisableClick();
								_lm.ARROW.visible = this.currenttab == 2;
								if(_tag.prev_week_pos == 0) {
										Imitation.GotoFrame(_lm.ARROW,7);
								} else if(_id + 1 == _tag.prev_week_pos) {
										Imitation.GotoFrame(_lm.ARROW,5);
								} else {
										Imitation.GotoFrame(_lm.ARROW,_id + 1 < _tag.prev_week_pos ? 1 : 3);
								}
								Imitation.AddEventClick(_lm,function(e:Object):* {
										w.OnLineClick(_lm,_id);
								});
								if(!Config.mobile) {
										Imitation.AddEventMouseOver(_lm,function(e:Object):* {
												if(_lm) {
														_lm.OVER.visible = true;
												}
										});
										Imitation.AddEventMouseOut(_lm,function(e:Object):* {
												if(_lm) {
														_lm.OVER.visible = false;
												}
										});
								}
						}
				}
				
				public function DrawPlayerPanel() : void {
						var u:Object = null;
						var tag:Object = this.currentpos == -1 ? MemberList.highlightfriend : MemberList.visiblemembers[this.currentpos];
						if(!tag) {
								return;
						}
						var friendly:* = tag.id !== undefined;
						if(tag) {
								u = Extdata.GetUserData(Util.StringVal(friendly ? tag.id : tag.userid));
						}
				}
				
				private function DrawButtons(_tag:Object) : void {
				}
				
				private function OnButtonClick(e:Object) : void {
						Clan.AskMemberRequest(e.params);
				}
				
				public function OnLineClick(_item:MovieClip, _id:int) : void {
						if(Boolean(_item) && !Modules.GetClass("uibase","uibase.ScrollBarMov").global_dragging) {
								this.currentpos = _id;
								this.HighlightLine(_item);
								WinMgr.OpenWindow("profile2.Profile2",{
										"user_id":MemberList.visiblemembers[_id].userid,
										"fadeIn":"left",
										"fadeOut":"left"
								});
						}
				}
				
				private function OnInviteClick(e:Object) : void {
						Clan.OnSendInvite(Util.StringVal(e.params.tag.id));
						MemberList.currentcmd = "INVITE";
				}
				
				private function GetRankText(_rank:Number) : String {
						if(_rank == 2) {
								return Lang.Get("founder");
						}
						if(_rank == 1) {
								return Lang.Get("admin");
						}
						return Lang.Get("member");
				}
				
				private function HighlightLine(_item:MovieClip = null) : void {
						this.HideLinesStroke();
						if(Boolean(_item) && Boolean(_item.LAYER)) {
								_item.LAYER.visible = true;
						}
				}
				
				private function HideLinesStroke() : void {
				}
				
				public function Hide() : void {
						TweenMax.killTweensOf(this);
						Util.StopAllChildrenMov(this);
						if(this.CONTAINER_LIST.SB) {
								this.CONTAINER_LIST.SB.dragging = false;
								this.CONTAINER_LIST.SB.Remove();
						}
						this.InActivate();
						this.visible = false;
						MemberList.active = false;
				}
				
				public function DrawChat() : void {
						trace("DrawChat");
						var w:MovieClip = this.MESSAGES.ITEMS;
						Imitation.FreeBitmapAll(w);
						Imitation.FreeBitmapAll(this.MASK);
						this.MESSAGES.condenseWhite = true;
						this.MESSAGES.ITEMS.PROTOTYPE.visible = false;
						this.MASK.visible = false;
						this.SB_CHAT.visible = false;
						this.CHAT_AVATAR.internal_flipped = true;
						this.CHAT_AVATAR.ShowUID(Sys.mydata.id);
						this.INPUT_CHAT.FIELD.restrict = Config.GetChatRestrictChars();
						Util.RTLEditSetup(this.INPUT_CHAT.FIELD);
						this.DrawChatMessages(true);
						this.UpdateChatScrollBar();
						this.UpdateChatPos();
						TweenMax.delayedCall(1,this.HideChatCover);
				}
				
				public function DrawChatMessages(_refresh:Boolean = false) : void {
						if(active && Boolean(Clan.mc)) {
								chatbuf.DrawMessages(this,_refresh);
						}
				}
				
				private function OnMessageSend(e:Object = null) : void {
						var msg:String = Util.CleanupChatMessage(Util.GetRTLEditText(this.INPUT_CHAT.FIELD));
						if(msg.length >= 2) {
								Comm.SendCommand("CHATMSG","MSG=\"" + msg + "\"" + " PCH=\"" + Clan.CHAT_PCH + "\"");
								Util.SetRTLEditText(this.INPUT_CHAT.FIELD,"");
						}
				}
				
				private function OnInputKeyUp(e:TextEvent) : void {
						if(e.text.charCodeAt() == 10 && active) {
								e.preventDefault();
								this.OnMessageSend();
						}
				}
				
				public function OnHandleMouseWheel(e:MouseEvent) : void {
				}
				
				private function OnChatScrolling(_pos:Number) : void {
						chatbuf.top = _pos;
						this.DrawChatMessages();
				}
				
				public function UpdateChatPos() : void {
						var cb:LegoChatMessageBuffer = chatbuf;
						if(cb.top > chatbuf.fullheight - this.MASK.height - cb.default_line_height * 4) {
								cb.top = cb.fullheight - this.MASK.height + 20;
								this.SB_CHAT.Set(chatbuf.fullheight + 20,this.MASK.height,cb.top);
						}
				}
				
				private function Activate() : void {
						if(!Clan.myclanproperties) {
								return;
						}
						var activechat:* = Clan.myclanproperties.members.length > 1;
						this.BTN_CHAT_SEND.AddEventClick(this.OnMessageSend);
						this.BTN_CHAT_SEND.SetIcon("PLAY");
						this.BTN_CHAT_SEND.SetEnabled(activechat);
						this.SB_CHAT.dragging = true;
						this.INPUT_CHAT.visible = activechat;
						Imitation.AddStageEventListener(TextEvent.TEXT_INPUT,this.OnInputKeyUp);
						Imitation.AddStageEventListener(MouseEvent.MOUSE_WHEEL,this.OnHandleMouseWheel);
						Imitation.EnableInput(this,activechat);
						this.ActivateTabs();
				}
				
				private function InActivate() : void {
						Imitation.EnableInput(this,false);
						Imitation.DeleteEventGroup(this);
				}
				
				private function HideChatCover() : void {
				}
				
				public function UpdateChatScrollBar() : void {
						if(!this.SB_CHAT.visible) {
								this.SB_CHAT.visible = chatbuf.fullheight > this.MASK.height;
								if(this.SB_CHAT.visible) {
										this.MASK.visible = true;
										this.SB_CHAT.Set(chatbuf.fullheight + 20,this.MASK.height,chatbuf.fullheight - this.MASK.height + 20);
										this.SB_CHAT.buttonstep = 22.1;
										this.SB_CHAT.OnScroll = this.OnChatScrolling;
										Imitation.CollectChildrenAll(Clan.mc);
										Imitation.SetMaskedMov(this.MASK,this.MESSAGES,false);
										Imitation.AddEventMask(this.MASK,this.MESSAGES);
										this.SB_CHAT.SetScrollRect(this.MASK);
										this.SB_CHAT.isaligned = false;
								}
						}
						if(!this.SB_CHAT.dragging) {
								this.SB_CHAT.Set(chatbuf.fullheight + 20,this.MASK.height,this.SB_CHAT.firstpos);
						}
						Imitation.FreeBitmapAll(this.SB_CHAT);
						Imitation.UpdateAll(this.SB_CHAT);
				}
				
				private function DrawTabs() : void {
						var tab:MovieClip = null;
						for(var i:int = 1; i <= 3; i++) {
								tab = this["TAB_" + i];
								if(tab) {
										Imitation.GotoFrame(tab,i == this.currenttab ? 1 : 3);
										Imitation.GotoFrame(tab.ICON,i);
										Imitation.FreeBitmapAll(tab);
										Imitation.UpdateAll(tab);
								}
						}
				}
				
				private function ActivateTabs() : void {
						var tab:MovieClip = null;
						for(var i:int = 1; i <= 3; i++) {
								tab = this["TAB_" + i];
								if(tab) {
										Imitation.AddEventClick(tab,this.OnTabClick,{"currenttab":i});
								}
						}
				}
				
				private function OnTabClick(e:Object) : void {
						var params:Array = null;
						if(this.currenttab != Util.NumberVal(e.params.currenttab)) {
								params = [null,"alltime","weekly","prev","alltime"];
								this.currenttab = Util.NumberVal(e.params.currenttab);
								this.Draw();
						}
				}
		}
}

