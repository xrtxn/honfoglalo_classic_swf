package profile2 {
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import flash.events.Event;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol408")]
		public class MessagesPage extends MovieClip {
				public var BODY:MovieClip;
				
				public var MESSAGE_LIST_MAIN:MovieClip;
				
				public var NEW_MESSAGE_MC:MovieClip;
				
				public var state:String = "inbox";
				
				public var loadMessages:Boolean = false;
				
				public var linelimit:int = 500;
				
				public var allmessages:Array;
				
				public var messages:Array;
				
				public var hasmorelines:Boolean;
				
				public var firstitem:int = 0;
				
				public var actMessage:Object;
				
				private var filteredFriends:Array;
				
				private var toid:Number = -1;
				
				public function MessagesPage() {
						var i:int = 0;
						var cb:MovieClip = null;
						this.allmessages = [];
						this.messages = [];
						super();
						for(i = 1; i <= 3; i++) {
								cb = this.MESSAGE_LIST_MAIN["CB_" + i];
								cb.CHECK.visible = false;
								Imitation.AddEventClick(cb,this.OnCheckboxClick,{"index":i});
						}
						this.MESSAGE_LIST_MAIN.BTN_NEW.SetIcon("MSG_WHITE");
						Imitation.AddEventClick(this.MESSAGE_LIST_MAIN.BTN_NEW,this.OnNewMessageButtonClick);
						Util.SetText(this.MESSAGE_LIST_MAIN.C_NEW.FIELD,Lang.Get("new_message"));
						this.MESSAGE_LIST_MAIN.BTN_DELETE.SetIcon("X");
						this.MESSAGE_LIST_MAIN.BTN_DELETE.visible = false;
						Util.SetText(this.MESSAGE_LIST_MAIN.C_DELETE.FIELD,Lang.Get("delete"));
						this.MESSAGE_LIST_MAIN.C_DELETE.visible = false;
						Util.AddEventListener(this.BODY.INPUT_MC.INPUT_FIELD,"change",this.OnInputTextChanged);
						this.BODY.BTN_SEND.SetEnabled(false);
						this.BODY.BTN_SEND.SetIcon("PLAY");
						Imitation.AddEventClick(this.BODY.BTN_SEND,this.OnSendAnswerButtonClick);
						Imitation.AddEventClick(this.NEW_MESSAGE_MC.BTN_CANCEL,this.OnCancelNewMessageButtonClick);
						this.NEW_MESSAGE_MC.BTN_CANCEL.SetIcon("X");
						Imitation.AddEventClick(this.NEW_MESSAGE_MC.BTN_SEND,this.OnSendNewMessageButtonClick);
						this.NEW_MESSAGE_MC.BTN_SEND.SetIcon("PLAY");
						Util.SetText(this.NEW_MESSAGE_MC.C_SUBJECT.FIELD,Lang.Get("subject"));
						Util.SetText(this.NEW_MESSAGE_MC.C_TEXT.FIELD,Lang.Get("message"));
						this.SwitchView("hide");
				}
				
				public function Start(_data:Object = null) : void {
						this.SwitchView("hide");
						this.GetMessages();
				}
				
				public function Draw(_obj:Object = null) : void {
						this.SetState(this.state);
				}
				
				public function SetState(_state:String = "inbox") : void {
						this.state = _state;
						this.SetRadioButtons();
						this.FilterMessages();
						this.SwitchView("read");
						this.ShowMessageBody(this.messages[0]);
				}
				
				public function SetRadioButtons() : void {
						var i:int = 0;
						var cb:MovieClip = null;
						for(i = 1; i <= 3; i++) {
								cb = this.MESSAGE_LIST_MAIN["CB_" + i];
								cb.CHECK.visible = false;
						}
						if(this.state == "inbox") {
								this.MESSAGE_LIST_MAIN.CB_1.CHECK.visible = true;
						} else if(this.state == "outbox") {
								this.MESSAGE_LIST_MAIN.CB_2.CHECK.visible = true;
						} else if(this.state == "system") {
								this.MESSAGE_LIST_MAIN.CB_3.CHECK.visible = true;
						}
				}
				
				public function OnCheckboxClick(e:Object) : void {
						if(e.params.index == 1) {
								this.SetState("inbox");
						}
						if(e.params.index == 2) {
								this.SetState("outbox");
						}
						if(e.params.index == 3) {
								this.SetState("system");
						}
						this.GetMessages();
				}
				
				public function GetMessages(fromindex:int = 0, scroll:* = 0) : * {
						if(this.loadMessages) {
								return;
						}
						this.loadMessages = true;
						WinMgr.ShowLoadWait();
						this.MESSAGE_LIST_MAIN.MESSAGES_LIST.visible = false;
						if(fromindex == 0) {
								this.messages = [];
								this.allmessages = [];
								this.hasmorelines = false;
								this.firstitem = 0;
						}
						var postbox:String = "inbox";
						if(this.state == "inbox") {
								postbox = "to";
						}
						if(this.state == "outbox") {
								postbox = "from";
						}
						if(this.state == "system") {
								postbox = "sys";
						}
						if(postbox == "sys") {
								JsQuery.Load(this.ProcessMessages,[false,fromindex,scroll],"client_messages.php?" + Sys.FormatGetParamsStoc({
										"cmd":"list",
										"first":fromindex,
										"partnerid":(MovieClip(parent).uid == Sys.mydata.id ? 0 : MovieClip(parent).uid),
										"lines":this.linelimit + 1
								},true));
						} else {
								JsQuery.Load(this.ProcessMessages,[true,fromindex,scroll],"client_messages.php?" + Sys.FormatGetParamsStoc({
										"cmd":"list",
										"first":fromindex,
										"postbox":postbox,
										"lines":this.linelimit + 1
								},true));
						}
				}
				
				public function ProcessMessages(jsq:Object, draw:Boolean, first:int, scroll:int = 0) : * {
						var n:String = null;
						WinMgr.HideLoadWait();
						this.loadMessages = false;
						if(jsq == null || Boolean(jsq.error)) {
								return;
						}
						this.allmessages = this.allmessages.slice(0,first);
						this.hasmorelines = false;
						var lcnt:int = 0;
						for(n in jsq.data) {
								lcnt++;
								if(lcnt > this.linelimit) {
										this.hasmorelines = true;
										break;
								}
								this.allmessages.push(jsq.data[n]);
						}
						this.Draw();
				}
				
				public function FilterMessages() : * {
						this.messages = [];
						for(var i:int = 0; i < this.allmessages.length; i++) {
								this.allmessages[i].fromname = this.allmessages[i].fromname.replace("&gt;",">");
								this.allmessages[i].fromname = this.allmessages[i].fromname.replace("&lt;","<");
								this.allmessages[i].toname = this.allmessages[i].toname.replace("&gt;",">");
								this.allmessages[i].toname = this.allmessages[i].toname.replace("&lt;","<");
								this.allmessages[i].text = this.allmessages[i].text.replace("&gt;",">");
								this.allmessages[i].text = this.allmessages[i].text.replace("&lt;","<");
								this.allmessages[i].title = this.allmessages[i].title.replace("&gt;",">");
								this.allmessages[i].title = this.allmessages[i].title.replace("&lt;","<");
								this.messages.push(this.allmessages[i]);
						}
						if(this.hasmorelines) {
								this.messages.push({
										"name":"",
										"time":"",
										"id":-1
								});
						}
						this.MESSAGE_LIST_MAIN.MESSAGES_LIST.visible = true;
						this.MESSAGE_LIST_MAIN.MESSAGES_LIST.MELINES.Set("MELINE",this.messages,39,1,this.OnMessageListClick,this.DrawMessageLine,this.MESSAGE_LIST_MAIN.MESSAGES_LIST.MASK_LINES,this.MESSAGE_LIST_MAIN.MESSAGES_LIST.SB);
						this.MESSAGE_LIST_MAIN.MESSAGES_LIST.SB.ScrollTo(0,0);
						this.MESSAGE_LIST_MAIN.MESSAGES_LIST.SB.dragging = true;
				}
				
				public function OnMessageListClick(_item:MovieClip, _id:int) : void {
						this.ShowMessageBody(this.messages[_id]);
						if(this.messages[_id].flag != 1) {
								JsQuery.Load(this.ProcessMessages,[false,0],"client_messages.php?" + Sys.FormatGetParamsStoc({
										"cmd":"set",
										"msgid":this.messages[_id].id,
										"postbox":(this.state == "inbox" ? "to" : "from"),
										"flag":1
								},true));
						}
				}
				
				public function DrawMessageLine(_item:MovieClip, _id:int) : void {
						if(this.messages[_id]) {
								_item.visible = true;
								if(Boolean(this.messages[_id].hasOwnProperty("flag")) && this.messages[_id].flag == 1) {
										_item.gotoAndStop(1);
								} else {
										_item.gotoAndStop(2);
								}
								if(this.state == "inbox") {
										_item.AVATAR.ShowUID(this.messages[_id].fromid);
										Util.SetText(_item.CNAME.FIELD,this.messages[_id].fromname);
										Util.SetText(_item.CTITLE.FIELD,this.messages[_id].title);
										_item.POSTBOXICON.Set("INBOX");
								}
								if(this.state == "outbox") {
										_item.AVATAR.ShowUID(this.messages[_id].toid);
										Util.SetText(_item.CNAME.FIELD,this.messages[_id].toname);
										Util.SetText(_item.CTITLE.FIELD,this.messages[_id].title);
										_item.POSTBOXICON.Set("OUTBOX");
								}
								if(this.state == "system") {
										_item.AVATAR.ShowUID(-1);
										_item.POSTBOXICON.Set("SYSBOX");
								}
								_item.BTN_DELETE.SetIcon("X");
								Imitation.AddEventClick(_item.BTN_DELETE,this.DeleteMessage,{"id":this.messages[_id].id});
						} else {
								_item.AVATAR.Clear();
								_item.visible = false;
						}
				}
				
				public function DeleteMessage(e:Object) : void {
						var postbox:String = null;
						var MessageWin:* = Modules.GetClass("uibase","uibase.MessageWin");
						postbox = "inbox";
						if(this.state == "inbox") {
								postbox = "to";
						}
						if(this.state == "outbox") {
								postbox = "from";
						}
						if(this.state == "system") {
								postbox = "sys";
						}
						MessageWin.AskYesNo(Lang.Get("delete"),Lang.Get("ask_delete_msg"),Lang.Get("yes"),Lang.Get("no"),function(a:*):* {
								if(a == 1) {
										if(postbox == "sys") {
												JsQuery.Load(ProcessMessages,[false,0,0],"client_messages.php?" + Sys.FormatGetParamsStoc({
														"cmd":"set",
														"msgid":e.params.id,
														"partnerid":(MovieClip(parent).uid == Sys.mydata.id ? 0 : MovieClip(parent).uid),
														"flag":2
												},true));
										} else {
												JsQuery.Load(ProcessMessages,[true,0,0],"client_messages.php?" + Sys.FormatGetParamsStoc({
														"cmd":"set",
														"msgid":e.params.id,
														"postbox":postbox,
														"flag":2
												},true));
										}
								}
						});
				}
				
				public function ShowMessageBody(_body:Object) : void {
						trace("MessagesPage.ShowMessageBody");
						DBG.Trace("ShowMessageBody",_body);
						if(_body == null) {
								this.BODY.visible = false;
								return;
						}
						if(!_body.hasOwnProperty("fromid")) {
								this.BODY.visible = false;
								return;
						}
						this.actMessage = _body;
						var pagesize:Number = 190;
						this.BODY.visible = true;
						this.BODY.BODY_MC.BODY.FIELD.autoSize = "left";
						Util.SetText(this.BODY.SUBJECT.FIELD,_body.title);
						Util.SetText(this.BODY.DATE.FIELD,_body.time);
						Util.SetText(this.BODY.BODY_MC.BODY.FIELD,_body.text);
						this.BODY.AVATAR.ShowUID(_body.fromid);
						this.BODY.MYAVATAR.ShowUID(Sys.mydata.id);
						if(this.BODY.BODY_MC.BODY.FIELD.height > pagesize) {
								this.BODY.SB.visible = true;
						} else {
								this.BODY.SB.visible = false;
						}
						this.BODY.SB.Set(this.BODY.BODY_MC.BODY.FIELD.height,pagesize,0);
						Imitation.SetMaskedMov(this.BODY.MASK_BODY,this.BODY.BODY_MC);
						this.BODY.SB.SetScrollRect(this.BODY.MASK_BODY);
						this.BODY.SB.isaligned = true;
						this.BODY.SB.isfloat = true;
						this.BODY.SB.OnScroll = this.OnMessageScroll;
						this.OnMessageScroll(0);
						this.BODY.INPUT_MC.INPUT_FIELD.text = "";
						this.BODY.BTN_SEND.SetEnabled(false);
						Imitation.FreeBitmapAll(this);
						Imitation.CollectChildrenAll(this);
				}
				
				private function OnMessageScroll(pos:*) : * {
						this.BODY.BODY_MC.y = Math.round(50 - pos);
				}
				
				private function OnSendAnswerButtonClick(e:Object) : void {
						var txtbody:String = Util.GetRTLEditText(this.BODY.INPUT_MC.INPUT_FIELD);
						DBG.Trace("actMessage",this.actMessage);
						var socials:String = Util.StringVal(Config.flashvars.social_friends);
						var prior_msg_id:* = !!this.actMessage ? this.actMessage.id : "0";
						JsQuery.Load(this.OnProcessSendMessage,[],"client_messages.php?" + Sys.FormatGetParamsStoc({"cmd":"send"},true),{
								"to":this.actMessage.fromid,
								"priorid":prior_msg_id,
								"title":this.actMessage.title,
								"message":txtbody,
								"social_friends":socials
						});
				}
				
				public function OnProcessSendMessage(jsq:*) : * {
						var MessageWin:* = Modules.GetClass("uibase","uibase.MessageWin");
						if(!jsq.error) {
								this.SetState("outbox");
								this.GetMessages();
								this.BODY.INPUT_MC.INPUT_FIELD.text = "";
						} else if(jsq.error == 7) {
								MessageWin.Show(Lang.Get("outbox"),Lang.Get("warn_partner_full"));
						} else {
								MessageWin.Show(Lang.Get("error"),Lang.Get(jsq.errormsg));
						}
				}
				
				private function OnInputTextChanged(e:Object) : void {
						var txtbody:String = Util.GetRTLEditText(this.BODY.INPUT_MC.INPUT_FIELD);
						if(this.state == "inbox") {
								if(txtbody.length <= 2) {
										this.BODY.BTN_SEND.SetEnabled(false);
								} else {
										this.BODY.BTN_SEND.SetEnabled(true);
								}
						} else if(this.state == "outbox") {
								this.BODY.BTN_SEND.SetEnabled(false);
						} else if(this.state == "system") {
								this.BODY.BTN_SEND.SetEnabled(false);
						}
				}
				
				private function OnNewMessageButtonClick(e:Object) : void {
						this.SwitchView("write");
				}
				
				private function OnCancelNewMessageButtonClick(e:Object) : void {
						this.SwitchView("read");
				}
				
				private function OnSendNewMessageButtonClick(e:Object) : void {
						if(this.toid == -1) {
								return;
						}
						var subject:String = Util.GetRTLEditText(this.NEW_MESSAGE_MC.INPUT_SUBJECT);
						var body:String = Util.GetRTLEditText(this.NEW_MESSAGE_MC.INPUT_TEXT);
						var socials:String = Util.StringVal(Config.flashvars.social_friends);
						var prior_msg_id:* = "0";
						if(subject != "" && body != "") {
								JsQuery.Load(this.OnProcessSendMessage,[],"client_messages.php?" + Sys.FormatGetParamsStoc({"cmd":"send"},true),{
										"to":this.toid,
										"priorid":prior_msg_id,
										"title":subject,
										"message":body,
										"social_friends":socials
								});
								this.NEW_MESSAGE_MC.INPUT_SUBJECT.text = "";
								this.NEW_MESSAGE_MC.INPUT_TEXT.text = "";
								this.SwitchView();
						}
				}
				
				public function SwitchView(_state:String = "read") : void {
						trace("MessagesPage.SwitchView: ",_state);
						if(_state == "read") {
								this.MESSAGE_LIST_MAIN.visible = true;
								this.BODY.visible = true;
								this.NEW_MESSAGE_MC.visible = false;
						} else if(_state == "write") {
								this.MESSAGE_LIST_MAIN.visible = false;
								this.BODY.INPUT_MC.INPUT_FIELD.text = "";
								this.BODY.visible = false;
								this.NEW_MESSAGE_MC.visible = true;
								this.NEW_MESSAGE_MC.x = this.NEW_MESSAGE_MC.y = 0;
								this.toid = -1;
								this.NEW_MESSAGE_MC.BTN_SEND.SetEnabled(false);
								this.FilterFriends(1);
								Util.SetText(this.NEW_MESSAGE_MC.NAME.FIELD,"");
						} else if(_state == "hide") {
								this.MESSAGE_LIST_MAIN.visible = false;
								this.NEW_MESSAGE_MC.visible = false;
								this.BODY.visible = false;
						}
						if(this.state == "outbox" || this.state == "system") {
								this.BODY.INPUT_MC.visible = false;
								this.BODY.BTN_SEND.visible = false;
								this.BODY.MYAVATAR.visible = false;
								this.BODY.INPUT_BG.visible = false;
								this.BODY.AFRAME.visible = false;
						} else {
								this.BODY.INPUT_MC.visible = true;
								this.BODY.BTN_SEND.visible = true;
								this.BODY.MYAVATAR.visible = true;
								this.BODY.INPUT_BG.visible = true;
								this.BODY.AFRAME.visible = true;
						}
						Imitation.EnableInput(this.BODY,this.BODY.visible);
						Imitation.EnableInput(this.NEW_MESSAGE_MC,this.NEW_MESSAGE_MC.visible);
				}
				
				public function FilterFriends(_flag:int = 1, _name:String = "") : void {
						var i:int = 0;
						var friend:Object = null;
						this.filteredFriends = new Array();
						for(i = 0; i < Friends.all.length; i++) {
								friend = Friends.all[i];
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
						this.NEW_MESSAGE_MC.FRIEND_LIST.NFLINES.Set("NFLINE",this.filteredFriends,37,1,this.OnFriendListClick,this.DrawFriendLine,this.NEW_MESSAGE_MC.FRIEND_LIST.MASK_LINES,this.NEW_MESSAGE_MC.FRIEND_LIST.SB);
						this.NEW_MESSAGE_MC.FRIEND_LIST.SB.ScrollTo(0,0);
						this.NEW_MESSAGE_MC.FRIEND_LIST.SB.dragging = true;
				}
				
				public function OnFriendListClick(_item:MovieClip, _id:int) : void {
						this.NEW_MESSAGE_MC.AVATAR.ShowUID(this.filteredFriends[_id].id);
						Util.SetText(this.NEW_MESSAGE_MC.NAME.FIELD,this.filteredFriends[_id].name);
						this.toid = this.filteredFriends[_id].id;
						this.NEW_MESSAGE_MC.BTN_SEND.SetEnabled(true);
				}
				
				public function DrawFriendLine(_item:MovieClip, _id:int) : void {
						if(this.filteredFriends[_id]) {
								_item.visible = true;
								_item.AVATAR.ShowUID(this.filteredFriends[_id].id);
								Util.SetText(_item.CNAME.FIELD,this.filteredFriends[_id].name);
						} else {
								_item.visible = false;
						}
				}
				
				public function Destroy() : void {
						var i:int = 0;
						var cb:MovieClip = null;
						for(i = 1; i <= 3; i++) {
								cb = this.MESSAGE_LIST_MAIN["CB_" + i];
								Imitation.RemoveEvents(cb);
						}
						Util.RemoveEventListener(this.BODY.INPUT_MC.INPUT_FIELD,Event.CHANGE,this.OnInputTextChanged);
				}
		}
}

