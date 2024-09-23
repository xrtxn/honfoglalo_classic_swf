package lobby {
		import com.greensock.TweenMax;
		import flash.display.MovieClip;
		import flash.events.Event;
		import flash.events.MouseEvent;
		import flash.events.TextEvent;
		import flash.text.TextField;
		import flash.utils.Timer;
		import flash.utils.getTimer;
		import syscode.*;
		import uibase.ScrollBarMov3;
		import uibase.ScrollBarMov7;
		import uibase.lego_button_1x1_cancel;
		import uibase.lego_button_1x1_cancel_header;
		import uibase.lego_button_1x1_normal_header;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol319")]
		public class Lobby extends MovieClip {
				public static var mc:Lobby = null;
				
				public static var timer:MyTimer = new MyTimer();
				
				public static var activeroom:ChatRoomData = null;
				
				public static var userlist:Object = {};
				
				public static var mainroom:ChatRoomData = null;
				
				public static var clanroom:ChatRoomData = null;
				
				public static var privaterooms:Array = [];
				
				public static var privateroomsbyid:Object = {};
				
				public static var firstprivateroom:int = 1;
				
				public static var follownewroom:Boolean = false;
				
				public static var visbleprivatetabs:int = 6;
				
				public static var listfilter:String = "";
				
				public static var rlresetremaining:int = 0;
				
				public static var rlresettimeref:int = 0;
				
				public static var rlresettimer:Timer = null;
				
				private static var last_friendlygame_share:Number = 0;
				
				private static var friendlygame_share_counter:Number = 0;
				
				private static var friendlygame_share_message_id:Number = -1;
				
				public var AVATAR:AvatarMov;
				
				public var BTNCLOSE:lego_button_1x1_cancel_header;
				
				public var BTNHELP:lego_button_1x1_normal_header;
				
				public var BTNSEND:lego_button_1x1_normal_header;
				
				public var BUBBLE:MovieClip;
				
				public var CSB:ScrollBarMov7;
				
				public var EDSEARCH:TextField;
				
				public var FRAME:MovieClip;
				
				public var INPUT_CHAT:MovieClip;
				
				public var LEAVEBTN:lego_button_1x1_cancel;
				
				public var MASK:MovieClip;
				
				public var MESSAGES:MovieClip;
				
				public var MTAB:MovieClip;
				
				public var NOTYET:MovieClip;
				
				public var ONLINE:ChatUsers1c;
				
				public var ONLINE2:Items2;
				
				public var OSB:ScrollBarMov7;
				
				public var PARTNERS:Items2;
				
				public var PTAB1:MovieClip;
				
				public var PTAB2:MovieClip;
				
				public var PTAB3:MovieClip;
				
				public var PTAB4:MovieClip;
				
				public var PTAB5:MovieClip;
				
				public var PTAB6:MovieClip;
				
				public var SB1:ScrollBarMov3;
				
				public var SB2:ScrollBarMov3;
				
				public var SCROLLBAR:ScrollBarMov7;
				
				public var SCROLLRECT:MovieClip;
				
				public var SCROLLRECT1:MovieClip;
				
				public var SCROLLRECT2:MovieClip;
				
				private var onlines:MovieClip = null;
				
				private var item_height:* = 40;
				
				private var window_opened:Boolean = false;
				
				private var first:Boolean = true;
				
				public function Lobby() {
						super();
				}
				
				public static function DrawScreen() : * {
				}
				
				public static function NewChatRoom(aid:int) : ChatRoomData {
						return new ChatRoomData(aid);
				}
				
				public static function Reset() : * {
						mainroom = NewChatRoom(0);
						privaterooms = [];
						privateroomsbyid = {};
						activeroom = mainroom;
				}
				
				public static function AddChatMessage(cs:ChatRoomData, tag:Object) : * {
						var cb:LegoChatMessageBuffer = null;
						if(!mc) {
								return;
						}
						var fullheight:Number = cs.buffer.fullheight;
						var msg:Object = cs.buffer.AddChatMessage(tag,mc.MESSAGES.ITEMS.PROTOTYPE);
						if(activeroom == cs) {
								cb = cs.buffer;
								cs.showblinker = false;
								if(cb.top > fullheight - mc.MASK.height - cb.default_line_height * 2) {
										cb.top = cb.fullheight - mc.MASK.height;
								}
						} else if(Lobby.mc) {
								cs.showblinker = !mc.first;
						}
				}
				
				public static function HideChatMessage(cs:ChatRoomData, tag:Object) : * {
						if(!mc) {
								return;
						}
						var fullheight:Number = cs.buffer.fullheight;
						cs.buffer.HideChatMessage(tag);
						DrawChatMessages(true);
				}
				
				public static function tagproc_CHATMSG(tag:Object) : void {
						var m:* = undefined;
						var cs:ChatRoomData = null;
						if(tag.PCH) {
								cs = ChatRoomData(privateroomsbyid[tag.PCH]);
								if(!clanroom) {
										clanroom = cs;
								}
						}
						if(cs == null) {
								cs = mainroom;
						}
						if(!cs) {
								return;
						}
						var mid:int = -1;
						var name:String = "";
						var fg:Boolean = false;
						if(tag.MSG.indexOf(Lang.get("created_a_friendly_game","")) > -1) {
								fg = true;
								tag.FG = 1;
								name = tag.MSG.replace(Lang.get("created_a_friendly_game",""),"");
								if(last_friendlygame_share > getTimer()) {
										mid = friendlygame_share_message_id;
										++friendlygame_share_counter;
								} else {
										friendlygame_share_counter = 0;
										last_friendlygame_share = getTimer() + 60 * 2;
								}
						}
						if(mid == -1) {
								AddChatMessage(cs,tag);
								if(fg) {
										friendlygame_share_message_id = cs.buffer.allmsg.length - 1;
								}
						} else {
								m = cs.buffer.allmsg[mid];
								if(m) {
										m.message = Lang.get("created_friendly_games",name,"+" + friendlygame_share_counter);
										m.formattedmsg = m.FormatMessage();
								}
								DrawChatMessages(true);
						}
				}
				
				public static function tagproc_HIDEMSG(tag:Object) : void {
						var cs:ChatRoomData = null;
						if(tag.PCH) {
								cs = ChatRoomData(privateroomsbyid[tag.PCH]);
								if(!clanroom) {
										clanroom = cs;
								}
						}
						if(cs == null) {
								cs = mainroom;
						}
						if(!cs) {
								return;
						}
						HideChatMessage(cs,tag);
				}
				
				public static function OnTagsProcessed(e:*) : * {
						var v:Number;
						if(!mc) {
								return;
						}
						mc.first = false;
						TweenMax.delayedCall(1,function():* {
								DrawChatMessages();
						});
						v = mc.SCROLLBAR.velocity;
						mc.UpdateScrollBar();
						mc.SCROLLBAR.velocity = v;
						mc.DrawTabs();
				}
				
				public static function tagproc_PCHUSERS(tag:*) : * {
						var uid:String = null;
						var f:Object = null;
						var uids:* = tag.UIDS.split(",");
						var pch:* = tag.PCH;
						var room:Object = privateroomsbyid[pch];
						if(room) {
								room.users = [];
								room.uids = uids;
								for each(uid in uids) {
										if(uid != Sys.mydata.id) {
												f = userlist[uid];
												if(f != null) {
														room.users.push(f);
												}
										}
								}
								room.users.sort(function(a:*, b:*):* {
										return a.name.localeCompare(b.name);
								});
								if(mc) {
										mc.DrawTabs();
										mc.RefreshRoom(room);
								}
						}
				}
				
				public static function getfriendvalue(id:*) : * {
						var f:Object = Friends.GetUser(id);
						var n:* = 0;
						if(f) {
								if(f.flag == 2) {
										n = 4;
								} else if(f.descendant) {
										n = 3;
								} else if(f.external) {
										n = 2;
								} else {
										n = 1;
								}
						}
						return n;
				}
				
				public static function tagproc_MCUL(tag:*) : * {
						var fullul:String;
						var ulch:String;
						var uarr:Array = null;
						var ustr:String = null;
						var udarr:Array = null;
						var ud:Object = null;
						var f:* = undefined;
						var chstr:String = null;
						if(!mc) {
								return;
						}
						fullul = Util.StringVal(tag.FULL);
						ulch = Util.StringVal(tag.CH);
						if(fullul != "") {
								userlist = {};
								uarr = fullul.split("|");
								for each(ustr in uarr) {
										udarr = ustr.split("^");
										ud = {
												"id":udarr[0],
												"name":udarr[1],
												"xplevel":udarr[2]
										};
										userlist[ud.id] = ud;
								}
						}
						if(ulch != "") {
								uarr = ulch.split("|");
								for each(ustr in uarr) {
										chstr = ustr.charAt(0);
										ustr = ustr.substr(1);
										udarr = ustr.split("^");
										ud = {
												"id":udarr[0],
												"name":udarr[1],
												"xplevel":udarr[2]
										};
										if(chstr == "-") {
												userlist[ud.id] = undefined;
										} else {
												userlist[ud.id] = ud;
										}
								}
						}
						mainroom.users = [];
						for each(f in userlist) {
								if(f && f.id != Sys.mydata.id) {
										mainroom.users.push(f);
								}
						}
						mainroom.users.sort(function(a:*, b:*):* {
								var av:* = getfriendvalue(a.id);
								var bv:* = getfriendvalue(b.id);
								if(av != bv) {
										return bv - av;
								}
								return a.name.localeCompare(b.name);
						});
						if(mc) {
								mc.RefreshRoom(mainroom);
								if(activeroom.pch == -3) {
										mc.RefreshRoom(activeroom);
								}
						}
				}
				
				public static function tagproc_PCHATS(tag:*) : * {
						var i:int = 0;
						var roomid:int = 0;
						var pch:int = 0;
						var newactiveroom:ChatRoomData = null;
						var room:ChatRoomData = null;
						var mc:* = Lobby.mc;
						if(!mc) {
								return;
						}
						if(!mc.window_opened) {
								return;
						}
						var pids:Array = Util.StringVal(tag.IDS).split(",");
						var pidstr:* = "," + Util.StringVal(tag.IDS) + ",";
						for(i = 0; i < privaterooms.length; i++) {
								pch = int(privaterooms[i].pch);
								if(pidstr.indexOf("," + pch + ",") == -1) {
										newactiveroom = null;
										if(activeroom == privaterooms[i]) {
												if(i + 1 < privaterooms.length) {
														newactiveroom = privaterooms[i + 1];
												} else if(i > 0) {
														newactiveroom = privaterooms[i - 1];
												} else {
														newactiveroom = mainroom;
												}
										}
										privateroomsbyid[pch] = undefined;
										privaterooms.splice(i,1);
										i--;
										if(Lobby.mc) {
												if(newactiveroom != null) {
														SetActiveRoom(newactiveroom);
												} else {
														mc.DrawTabs();
												}
										}
								}
						}
						for each(roomid in pids) {
								if(roomid != 0 && privateroomsbyid[roomid] === undefined) {
										room = NewChatRoom(roomid);
										privaterooms.push(room);
										privateroomsbyid[roomid] = room;
										follownewroom = follownewroom || roomid == -2;
										if(follownewroom) {
												follownewroom = false;
												SetActiveRoom(room);
										} else {
												room.showblinker = false;
												mc.DrawTabs();
										}
								}
						}
				}
				
				private static function OnClanMembersLoaded(jsq:Object, refresh:Boolean) : * {
						var f:* = undefined;
						var m:* = undefined;
						if(!mc) {
								return;
						}
						if(mc.currentFrame != 3) {
								return;
						}
						mc.PARTNERS.visible = true;
						mc.SCROLLRECT1.visible = true;
						mc.PARTNERS.Set("ITEM",[],mc.item_height,1,function():* {
						},mc.DrawPartner,mc.SCROLLRECT1);
						if(refresh) {
								mc.PARTNERS.SetScrollBar(mc.CSB);
						}
						for each(f in Lobby.mainroom.users) {
								for each(m in jsq.data.members) {
										if(m.userid == f.id) {
												mc.PARTNERS.items.push(f);
										}
								}
						}
						mc.PARTNERS.SetItems(mc.PARTNERS.items);
				}
				
				public static function SetActiveRoom(aroom:ChatRoomData) : * {
						activeroom = aroom;
						listfilter = "";
						if(mc) {
								mc.CorrectFirstPrivate();
								mc.DrawActiveRoom(true);
								if(mc.EDSEARCH) {
										mc.EDSEARCH.text = "";
										Util.AddEventListener(mc.EDSEARCH,Event.CHANGE,mc.FilterItems);
										Util.RTLEditSetup(mc.EDSEARCH);
								}
								mc.FilterItems();
						}
				}
				
				public static function OnUserClick(uid:*) : * {
				}
				
				public static function DrawChatMessages(refresh:Boolean = false) : * {
						if(!mc) {
								return;
						}
						if(!activeroom) {
								return;
						}
						activeroom.buffer.DrawMessages(mc,refresh);
						activeroom.buffer.OnUserClick = OnUserClick;
				}
				
				public function Prepare(aparams:Object) : void {
						this.first = true;
						clanroom = null;
						last_friendlygame_share = 0;
						friendlygame_share_counter = 0;
						friendlygame_share_message_id = -1;
						Util.StopAllChildrenMov(mc);
						this.item_height = this.ONLINE.ITEM2.y - this.ONLINE.ITEM1.y;
						Imitation.SetMaskedMov(mc.MASK,mc.MESSAGES,false);
						this.BTNCLOSE.SetIcon("X");
						this.BTNCLOSE.AddEventClick(this.Hide);
						this.BTNHELP.SetIcon("HELP");
						this.BTNHELP.AddEventClick(this.OnHelpClick);
						Imitation.AddStageEventListener(TextEvent.TEXT_INPUT,this.InputKeyUp);
						this.MESSAGES.condenseWhite = true;
						this.MESSAGES.ITEMS.PROTOTYPE.visible = false;
						this.SCROLLBAR.OnScroll = this.OnScrollBarScroll;
						this.INPUT_CHAT.FIELD.restrict = Config.GetChatRestrictChars();
						Util.RTLEditSetup(this.INPUT_CHAT.FIELD);
						Reset();
						this.visible = true;
						activeroom.buffer.num = 10;
						this.SCROLLBAR.Set(activeroom.buffer.fullheight,this.MASK.height,activeroom.buffer.fullheight - this.MASK.height);
						this.SCROLLBAR.SetScrollRect(this.MASK);
						this.SCROLLBAR.isaligned = false;
						this.SCROLLBAR.visible = activeroom.buffer.fullheight > this.MASK.height;
						this.SCROLLBAR.buttonstep = 22;
						Imitation.AddStageEventListener("mouseWheel",this.HandleMouseWheel);
						Imitation.AddGlobalListener("FRIENDLISTCHANGE",this.FilterItems);
						SetActiveRoom(mainroom);
				}
				
				public function OnHelpClick(e:*) : void {
						WinMgr.OpenWindow("help.Help",{
								"tab":5,
								"subtab":2
						});
				}
				
				public function AfterOpen() : void {
						if(Sys.mydata.name == "") {
								this.Hide();
								WinMgr.OpenWindow("settings.AvatarWin");
								return;
						}
						this.window_opened = true;
						Imitation.AddGlobalListener("TAGSPROCESSED",OnTagsProcessed);
						Comm.SendCommand("CHANGEWAITHALL","WH=\"LOBBY\"",function():* {
								first = true;
						});
				}
				
				public function Hide(e:* = null) : void {
						Imitation.RemoveStageEventListener(TextEvent.TEXT_INPUT,this.InputKeyUp);
						Imitation.RemoveStageEventListener("mouseWheel",this.HandleMouseWheel);
						Comm.SendCommand("CHANGEWAITHALL","WH=\"VILLAGE\"");
						WinMgr.CloseWindow(this);
				}
				
				public function DrawPartner(item:MovieClip, idx:int) : * {
						var username:* = undefined;
						var level:String = null;
						if(!mc) {
								return;
						}
						if(!this.PARTNERS) {
								return;
						}
						if(!this.PARTNERS.items) {
								return;
						}
						var listItems:Array = this.PARTNERS.items;
						if(listItems[idx]) {
								item.gotoAndStop(1);
								item.LINE.visible = false;
								item.SELECTED.visible = false;
								item.ADDBTN.visible = false;
								username = Romanization.ToLatin(listItems[idx].name);
								level = Lang.Get("lvl") + ": " + listItems[idx].xplevel;
								if(item.AVATAR) {
										item.AVATAR.ShowUID(listItems[idx].id);
								}
								if(item.STAMP) {
										item.STAMP.visible = false;
										item.STAMP.gotoAndStop(1);
								}
								item.visible = true;
								Util.SetText(item.NAME.FIELD,username);
								Util.SetText(item.XPLEVEL.FIELD,level);
						} else {
								item.gotoAndStop(2);
								item.visible = false;
						}
				}
				
				public function DrawItem(item:MovieClip, idx:int) : * {
						var f:Object = null;
						var username:* = undefined;
						var level:String = null;
						if(!mc) {
								return;
						}
						if(!this.onlines) {
								return;
						}
						item.x = int(item.x);
						item.y = int(item.y);
						var listItems:Array = this.onlines.items;
						if(listItems[idx]) {
								if(Config.mobile) {
										item.gotoAndStop(1);
								}
								f = Friends.GetUser(listItems[idx].id);
								item.LINE.visible = false;
								item.ADDBTN.visible = f && f.flag == 1;
								item.SELECTED.visible = false;
								username = Romanization.ToLatin(listItems[idx].name);
								level = Lang.Get("lvl") + ": " + listItems[idx].xplevel;
								if(item.AVATAR) {
										item.AVATAR.ShowUID(listItems[idx].id);
								}
								if(item.STAMP) {
										item.STAMP.visible = false;
										item.STAMP.gotoAndStop(1);
								}
								item.visible = true;
								Util.SetText(item.NAME.FIELD,username);
								Util.SetText(item.XPLEVEL.FIELD,level);
						} else {
								item.gotoAndStop(1);
								item.visible = false;
						}
				}
				
				public function OnClickItem(item:MovieClip, idx:int) : * {
						if(item.ADDBTN.visible) {
								this.ChatAddUser(this.onlines.items[idx].id,activeroom.pch);
						} else {
								WinMgr.OpenWindow("profile2.Profile2",{
										"user_id":this.onlines.items[idx].id,
										"fadeIn":"left",
										"fadeOut":"left"
								});
						}
				}
				
				public function UpdateRLResetTime() : * {
				}
				
				public function FilterItems(e:* = null) : void {
						var u:* = undefined;
						var f:Object = null;
						if(!this.EDSEARCH) {
								return;
						}
						listfilter = this.EDSEARCH.text;
						this.onlines.items = [];
						if(Boolean(mainroom) && Boolean(mainroom.users)) {
								for each(u in mainroom.users) {
										f = Friends.GetUser(u.id);
										if(!f || f.flag < 3) {
												if(activeroom.pch == 0 || activeroom.uids.indexOf(String(u.id)) == -1) {
														if(listfilter == "" || u.name.toLocaleLowerCase().indexOf(listfilter.toLocaleLowerCase()) > -1) {
																this.onlines.items.push(u);
														}
												}
										}
								}
								this.onlines.SetItems(this.onlines.items,this.onlines.scrollbar.firstpos == 0 || e != null);
						}
				}
				
				public function DrawActiveRoom(refresh:* = false) : * {
						var p:Number = NaN;
						var v:Number = NaN;
						var f:Object = null;
						var n:* = undefined;
						if(!mc) {
								return;
						}
						if(Boolean(Sys.mydata.chatban) && activeroom == mainroom) {
								this.INPUT_CHAT.FIELD.visible = false;
								this.BTNSEND.visible = false;
								this.NOTYET.visible = true;
								Util.SetText(this.NOTYET.FIELD,Lang.Get("chat_is_banned"));
								activeroom.buffer.allow_hide = false;
						} else if(Sys.mydata.xplevel < Config.ULL_COMMONCHAT && activeroom == mainroom) {
								this.INPUT_CHAT.FIELD.visible = false;
								this.BTNSEND.visible = false;
								this.NOTYET.visible = true;
								Util.SetText(this.NOTYET.FIELD,Lang.Get("unlock_chat_3") + "\n" + Lang.Get("unlock_chat_2"));
								activeroom.buffer.allow_hide = false;
						} else {
								this.INPUT_CHAT.FIELD.visible = true;
								this.BTNSEND.visible = true;
								this.NOTYET.visible = false;
								this.BTNSEND.SetCaption("");
								this.BTNSEND.SetIcon("PLAY");
								this.BTNSEND.AddEventClick(this.OnSendClick);
								activeroom.buffer.allow_hide = true;
						}
						if(this.AVATAR) {
								this.AVATAR.internal_flipped = true;
								this.AVATAR.ShowUID(Sys.mydata.id);
						}
						Util.RTLEditSetup(this.INPUT_CHAT.FIELD);
						if(activeroom == mainroom || activeroom.pch == 0) {
								mc.gotoAndStop(1);
								this.ONLINE.Set("ITEM",[],this.item_height,1,this.OnClickItem,this.DrawItem,this.SCROLLRECT);
								if(refresh) {
										this.ONLINE.SetScrollBar(this.OSB);
								}
								this.onlines = this.ONLINE;
								this.FilterItems();
						} else if(activeroom.pch == -3) {
								if(currentFrame != 3) {
										mc.gotoAndStop(3);
										this.PARTNERS.visible = false;
										this.SCROLLRECT1.visible = false;
										this.CSB.visible = false;
								}
								this.onlines = null;
								JsQuery.Load(OnClanMembersLoaded,[refresh],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
										"cmd":"members",
										"allianceid":Util.NumberVal(Sys.myclanproperties.id)
								});
						} else if(activeroom == null) {
								mc.gotoAndStop(2);
								for(n = 1; n <= 16; n++) {
										this.MESSAGES.ITEMS.getChildByName("MESSAGE" + n).visible = false;
								}
						} else {
								mc.gotoAndStop(2);
								this.LEAVEBTN.SetIcon("REDX");
								this.LEAVEBTN.AddEventClick(this.OnTabCloseClick);
								this.PARTNERS.Set("ITEM",[],this.item_height,1,function():* {
								},this.DrawPartner,this.SCROLLRECT1);
								if(refresh) {
										this.PARTNERS.SetScrollBar(this.SB1);
								}
								this.ONLINE2.Set("ITEM",[],this.item_height,1,this.OnClickItem,this.DrawItem,this.SCROLLRECT2);
								if(refresh) {
										this.ONLINE2.SetScrollBar(this.SB2);
								}
								this.onlines = mc.ONLINE2;
								for each(f in mainroom.users) {
										if(activeroom.uids.indexOf(String(f.id)) > -1) {
												this.PARTNERS.items.push(f);
										}
								}
								this.PARTNERS.SetItems(this.PARTNERS.items);
								this.FilterItems();
						}
						if(activeroom != null) {
								activeroom.showblinker = false;
						}
						this.DrawTabs();
						if(this.BTNSEND) {
								this.BTNSEND.SetEnabled(activeroom != null);
						}
						if(refresh) {
								activeroom.buffer.top = activeroom.buffer.fullheight - this.MASK.height;
								this.UpdateScrollBar();
						}
						DrawChatMessages(refresh);
				}
				
				public function RefreshRoom(room:Object) : * {
						if(room == activeroom) {
								mc.DrawActiveRoom(false);
						}
				}
				
				public function InputKeyUp(e:TextEvent) : void {
						if(e.text.charCodeAt() == 10) {
								e.preventDefault();
								this.OnSendClick();
						}
				}
				
				public function ChatAddUser(uid:*, room:* = 0) : * {
						follownewroom = room == 0;
						Comm.SendCommand("CHATADDUSER","UID=\"" + uid + "\" CHATID=\"" + room + "\"");
				}
				
				public function OnSendClick(e:* = null) : * {
						var msg:* = Util.GetRTLEditText(this.INPUT_CHAT.FIELD);
						msg = Util.CleanupChatMessage(msg);
						if(msg.length < 2) {
								return;
						}
						if(timer.running) {
								return;
						}
						if(activeroom == mainroom) {
								if(this.BTNSEND) {
										this.BTNSEND.SetEnabled(false);
								}
								timer.AddMethod(3,this,this.FloodBlockReady);
								timer.Start();
						}
						Comm.SendCommand("CHATMSG","MSG=\"" + msg + "\"" + (activeroom != null && activeroom != mainroom ? " PCH=\"" + activeroom.pch + "\"" : ""));
						Util.SetRTLEditText(this.INPUT_CHAT.FIELD,"");
				}
				
				public function FloodBlockReady() : * {
						if(activeroom != null) {
								if(this.BTNSEND) {
										this.BTNSEND.SetEnabled(true);
								}
						}
				}
				
				public function UpdateScrollBar() : * {
						this.SCROLLBAR.visible = activeroom.buffer.fullheight > this.MASK.height;
						if(!this.SCROLLBAR.dragging) {
								this.SCROLLBAR.Set(activeroom.buffer.fullheight,this.MASK.height,activeroom.buffer.top);
						}
				}
				
				public function OnScrollBarScroll(afirst:*) : * {
						if(!activeroom) {
								return;
						}
						activeroom.buffer.top = afirst;
						TweenMax.delayedCall(0,DrawChatMessages);
				}
				
				public function OnMessagesScroll(e:*) : * {
						this.UpdateScrollBar();
				}
				
				public function HandleMouseWheel(e:MouseEvent) : * {
						if(!activeroom) {
								return;
						}
						var cb:LegoChatMessageBuffer = activeroom.buffer;
						cb.top -= e.delta * cb.default_line_height;
						cb.top = Math.min(activeroom.buffer.fullheight - this.MASK.height,cb.top);
						cb.top = Math.max(0,cb.top);
						DrawChatMessages();
						this.UpdateScrollBar();
				}
				
				public function CorrectFirstPrivate() : * {
						var ri:* = undefined;
						var curprivate:int = 0;
						if(activeroom != null && activeroom != mainroom && activeroom != clanroom) {
								for(ri in privaterooms) {
										if(privaterooms[ri] == activeroom) {
												curprivate = ri + 1;
												break;
										}
								}
						}
						if(curprivate > 0 && (firstprivateroom > curprivate || curprivate > firstprivateroom - 1 + visbleprivatetabs)) {
								firstprivateroom = curprivate;
						}
				}
				
				public function SetupTab(tab:*, room:Object, isprivate:Boolean) : * {
						var title:String = null;
						var u:* = undefined;
						var active:* = activeroom == room;
						tab.VALUEMC.visible = false;
						tab.COUNT.visible = false;
						if(active) {
								tab.gotoAndStop("ACTIVE");
						} else {
								tab.gotoAndStop("INACTIVE");
								if(room.showblinker) {
										tab.COUNT.visible = true;
										tab.COUNT.NOTIFYANIM.FIELD.text = "!";
								}
						}
						if(isprivate) {
								if(room.pch == -2) {
										title = Lang.Get("friendly_game");
										tab.ICON.gotoAndStop("MEMBER1");
										if(room != null) {
												room.lasttitle = title;
										}
								} else if(room.pch == -3) {
										title = Lang.Get("clan_chat");
										tab.ICON.gotoAndStop("CLAN");
										if(room != null) {
												room.lasttitle = title;
										}
								} else {
										var _loc7_:int = 0;
										var _loc8_:* = room.users;
										for each(u in _loc8_) {
												title = String(u.name);
										}
										if(title == null) {
												title = "private_chat";
										}
										tab.ICON.gotoAndStop("MEMBER1");
								}
								if(room.users.length >= 2) {
										tab.VALUEMC.VALUE.FIELD.text = "+ " + room.users.length;
										tab.VALUEMC.visible = true;
										tab.ICON.gotoAndStop("MEMBERS");
								}
						} else {
								title = Lang.Get("main_chat");
								this.MTAB.ICON.gotoAndStop("LIST");
						}
						Imitation.CollectChildrenAll();
						if(active && Boolean(tab.FIELDMC)) {
								Util.SetText(tab.FIELDMC.CAPTION,title);
								if(tab.FIELDMC.CAPTION.numLines > 1) {
										tab.FIELDMC.CAPTION.y = -6;
								}
						}
						Imitation.AddEventClick(tab,this.OnTabClick);
						tab.useHandCursor = !active;
				}
				
				public function DrawTabs() : * {
						var room:Object = null;
						var i:int = 0;
						var tab:* = undefined;
						if(firstprivateroom - 1 + visbleprivatetabs > privaterooms.length) {
								firstprivateroom = privaterooms.length - visbleprivatetabs + 1;
						}
						if(firstprivateroom < 1) {
								firstprivateroom = 1;
						}
						this.SetupTab(this.MTAB,mainroom,false);
						if(this.MTAB.origx == undefined) {
								this.MTAB.origx = this.MTAB.x;
						}
						var xoffset:Number = 10;
						var nextx:Number = this.MTAB.origx + this.MTAB.width + xoffset;
						for(var n:* = 1; n <= visbleprivatetabs; n++) {
								room = null;
								i = firstprivateroom + n - 1;
								if(i <= privaterooms.length) {
										room = privaterooms[i - 1];
								}
								tab = this["PTAB" + n];
								if(tab.origx == undefined) {
										tab.origx = tab.x;
								}
								tab.x = tab.origx;
								if(room != null) {
										tab.visible = true;
										this.SetupTab(tab,room,true);
										tab.x = nextx;
										nextx += tab.width + xoffset;
								} else {
										tab.visible = false;
								}
						}
				}
				
				public function OnTabClick(e:*) : * {
						var num:int = 0;
						var tab:* = e.target;
						var room:ChatRoomData = null;
						if(tab.name == "MTAB") {
								room = mainroom;
						} else if(tab.name == "CTAB") {
								room = clanroom;
						} else {
								num = Util.IdFromStringEnd(tab.name);
								if(num > 0) {
										num = num + firstprivateroom - 1;
								}
								room = privaterooms[num - 1];
						}
						SetActiveRoom(room);
						this.MESSAGES.mask = null;
						this.MESSAGES.mask = this.MASK;
				}
				
				public function OnTabCloseClick(e:*) : * {
						Comm.SendCommand("CHATCLOSE","ID=\"" + activeroom.pch + "\"");
				}
				
				public function ObjectTrace(_obj:Object, sPrefix:String = "") : void {
						var i:* = undefined;
						if(sPrefix == "") {
								sPrefix = "-->";
						} else {
								sPrefix += " -->";
						}
						for(i in _obj) {
								trace(sPrefix,i + ":" + _obj[i]," ");
								if(typeof _obj[i] == "object") {
										this.ObjectTrace(_obj[i],sPrefix);
								}
						}
				}
		}
}

import syscode.LegoChatMessageBuffer;

class ChatRoomData {
		public var pch:int = 0;
		
		public var users:Array;
		
		public var uids:Array;
		
		public var showblinker:Boolean = false;
		
		public var lasttitle:String = "";
		
		public var buffer:LegoChatMessageBuffer;
		
		public function ChatRoomData(aid:int) {
				this.users = [];
				this.uids = [];
				this.buffer = new LegoChatMessageBuffer();
				super();
				this.pch = aid;
		}
}

