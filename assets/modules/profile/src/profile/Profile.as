package profile {
		import com.adobe.serialization.json.ADOBEJSON;
		import components.ButtonComponent;
		import flash.display.MovieClip;
		import flash.events.Event;
		import flash.geom.Point;
		import flash.text.TextField;
		import flash.utils.Dictionary;
		import syscode.*;
		import uibase.ScrollBarMov;
		import uibase.TabMov;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol163")]
		public class Profile extends MovieClip {
				public static var hasmorelines:Boolean;
				
				private static var opening:Boolean;
				
				public static var mc:Profile = null;
				
				public static var newmessages:int = 0;
				
				public static var incount:int = 0;
				
				public static var outcount:int = 0;
				
				public static var maxin:int = 500;
				
				public static var maxout:int = 500;
				
				public static var messages:Array = [];
				
				public static var loading:Boolean = false;
				
				public static var firstload:Boolean = true;
				
				public static var firstitem:int = 0;
				
				public static var message:Object = null;
				
				public static var prior_msg_id:String = "0";
				
				public static var mytitle:String = "";
				
				public static var mytext:String = "";
				
				public static var linelimit:int = 50;
				
				public static var priorshown:Boolean = false;
				
				public var AVATAR:AvatarAnimMov;
				
				public var BG:MovieClip;
				
				public var BTNCANCELF:ButtonComponent;
				
				public var BTNCLOSE:ButtonComponent;
				
				public var BTNSEND:ButtonComponent;
				
				public var BUTTONS:MovieClip;
				
				public var CLAN:MovieClip;
				
				public var CLANBUTTONS:MovieClip;
				
				public var CMSG:TextField;
				
				public var CTITLE:TextField;
				
				public var C_FIRSTLOGIN:TextField;
				
				public var C_FULLMAPVICTORY:TextField;
				
				public var C_GAMECOUNT:TextField;
				
				public var C_GAMECOUNTSR:TextField;
				
				public var C_GLORIOUSVICTORY:TextField;
				
				public var C_GUESS:TextField;
				
				public var C_LASTGAME:TextField;
				
				public var C_MCQ:TextField;
				
				public var C_VEP:TextField;
				
				public var FIRSTLOGIN:TextField;
				
				public var FULLMAPVICTORY:TextField;
				
				public var GAMECOUNT:TextField;
				
				public var GAMECOUNTSR:TextField;
				
				public var GLORIOUSVICTORY:TextField;
				
				public var GUESS:TextField;
				
				public var INFO:TextField;
				
				public var LASTGAME:TextField;
				
				public var MASK:MovieClip;
				
				public var MCQ:TextField;
				
				public var MESSAGE:mailbox;
				
				public var MESSAGES:maillistcopy2;
				
				public var MSB:ScrollBarMov;
				
				public var MSG:TextField;
				
				public var MSGSB:ScrollBarMov;
				
				public var MSGTITLE:TextField;
				
				public var NAME:TextField;
				
				public var PLACE1:TextField;
				
				public var PLACE2:TextField;
				
				public var PLACE3:TextField;
				
				public var SB:ScrollBarMov;
				
				public var TABS:TabMov;
				
				public var TOTALXP:TextField;
				
				public var USERID:TextField;
				
				public var VEP:TextField;
				
				public var XPINFO:MovieClip;
				
				public var __setPropDict:Dictionary;
				
				public var waitanim:Object = null;
				
				public var funnelid:String;
				
				public var uid:String;
				
				public var friendship:Object = null;
				
				private var usersdata:Object = null;
				
				private var xpos:Number = 0;
				
				private var mousedown:Boolean = false;
				
				private var mousedown_x:Number = 0;
				
				private var lastmaxscrollv:int = 0;
				
				public function Profile() {
						this.__setPropDict = new Dictionary(true);
						super();
						addFrameScript(1,this.frame2,3,this.frame4,5,this.frame6);
						this.__setProp_BTNCLOSE_ProfileWindowMov_buttons_0();
				}
				
				private static function OnEnterFrame(e:Event) : void {
						if(!mc) {
								return;
						}
						if(Boolean(mc.MSB) && Boolean(mc.MSB.dragging)) {
								return;
						}
						var p:Point = Imitation.GetMousePos();
						if(mc.mousedown && p.x < mc.mousedown_x - 10) {
								mc.x = mc.xpos + p.x - mc.mousedown_x;
						} else if(mc.x < mc.xpos - 1) {
								mc.x = (mc.x + mc.xpos) / 2;
						} else {
								mc.x = mc.xpos;
						}
				}
				
				public static function UserDataProc(jsq:*) : * {
						if(!mc) {
								return;
						}
						DBG.Trace("jsq",jsq);
						if(jsq.error != 0) {
								if(opening) {
										WinMgr.WindowDataArrived(mc);
								}
								mc.Hide();
								return;
						}
						mc.usersdata = jsq.data;
						mc.DrawUserData(mc.TABS.current);
						if(opening) {
								WinMgr.WindowDataArrived(mc);
						}
				}
				
				private static function OnClanCommandReady(e:* = null) : void {
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
						} else if(mc) {
								mc.DrawUserData();
						}
				}
				
				public static function OnMemberRequestResult(_jsq:Object, _params:Object) : void {
						if(Util.NumberVal(_jsq.error) > 0) {
								WinMgr.HideLoadWait();
						} else {
								OnClanCommandReady();
						}
				}
				
				public static function OnAcceptSignup(e:*) : void {
						WinMgr.ShowLoadWait();
						mc.CLANBUTTONS.BTN_1.SetEnabled(false);
						mc.CLANBUTTONS.BTN_2.SetEnabled(false);
						JsQuery.Load(OnClanCommandReady,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
								"cmd":"accept_signup",
								"signupid":e.params.target
						});
				}
				
				public static function OnDenySignup(e:*) : void {
						WinMgr.ShowLoadWait();
						mc.CLANBUTTONS.BTN_1.SetEnabled(false);
						mc.CLANBUTTONS.BTN_2.SetEnabled(false);
						JsQuery.Load(OnClanCommandReady,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
								"cmd":"alliance_delete_signup",
								"signupid":e.params.target
						});
				}
				
				public static function ProcessSend(jsq:*) : * {
						if(!mc) {
								return;
						}
						var MessageWin:* = Modules.GetClass("uibase","uibase.MessageWin");
						if(!jsq.error) {
								Profile.message = null;
								mc.DrawUserData(2);
								mc.BTNSEND.SetEnabled(false);
								Profile.mytitle = "";
								Profile.mytext = "";
								mc.MSGTITLE.text = "";
								mc.MSG.text = "";
						} else if(jsq.error == 7) {
								if(mc.usersdata) {
										MessageWin.Show(Lang.get("outbox"),Lang.get("warn_partner_full",Sys.mydata.name,mc.usersdata.name));
								}
						} else {
								MessageWin.Show(Lang.get("error"),Lang.get(jsq.errormsg));
						}
				}
				
				public static function UpdateItem(mid:String, flag:int = 0) : * {
						if(!mc) {
								return;
						}
						if(Profile.loading) {
								return;
						}
						Profile.loading = true;
						if(flag == 2) {
								Profile.message = null;
								mc.DrawUserData(2);
						}
						var draw:* = flag == 2;
						JsQuery.Load(Profile.ProcessMessages,[draw,false,!!mc.SB ? mc.SB.firstpos : 0],"client_messages.php?" + Sys.FormatGetParamsStoc({
								"cmd":"set",
								"msgid":mid,
								"partnerid":mc.uid,
								"flag":flag
						},true));
				}
				
				public static function ProcessPrior(jsq:Object) : * {
						var separator:String = null;
						var n:String = null;
						var msg:Object = null;
						if(!mc) {
								return;
						}
						trace(ADOBEJSON.encode(jsq));
						Profile.message.priorhtml = mc.FormatPriorMessage(Profile.message.toid,Profile.message.text);
						if(Config.rtl) {
								separator = "\r\n__________________________________________\r\n\r\n";
						} else {
								separator = "<br /><font color=\"#EEBBAA\">__________________________________________</font><br /><br />";
						}
						if(!jsq.error) {
								for(n in jsq.data) {
										msg = jsq.data[n];
										Profile.message.priorhtml = Profile.message.priorhtml + (separator + mc.FormatPriorMessage(msg.toid,msg.text));
								}
						}
						if(Config.rtl) {
								Util.SetText(mc.MESSAGE.MESSAGE.TEXT,Profile.message.priorhtml);
						} else {
								mc.MESSAGE.MESSAGE.TEXT.htmlText = Profile.message.priorhtml;
						}
						var pos:Number = Number(mc.MSB.firstpos);
						mc.ShowMessageScroll();
						mc.MSB.ScrollTo(pos);
						mc.MESSAGE.MESSAGE.BTNPRIOR.SetLang("hide_prior");
						mc.MESSAGE.MESSAGE.BTNPRIOR.visible = true;
						Profile.priorshown = true;
				}
				
				public static function UpdateList(fromindex:int = 0, scroll:int = 0) : * {
						if(loading) {
								return;
						}
						loading = true;
						if(fromindex == 0) {
								messages = [];
								hasmorelines = false;
								firstitem = 0;
						}
						JsQuery.Load(ProcessMessages,[false,fromindex,scroll],"client_messages.php?" + Sys.FormatGetParamsStoc({
								"cmd":"list",
								"first":fromindex,
								"partnerid":(mc.uid == Sys.mydata.id ? 0 : mc.uid),
								"lines":linelimit + 1
						},true));
				}
				
				public static function ProcessMessages(jsq:Object, update_postoffice:Boolean, first:int, scroll:int = 0) : * {
						var n:String = null;
						loading = false;
						DBG.Trace("jsq",jsq);
						if(jsq == null || jsq.error || mc.currentFrame != 4 && mc.currentFrame != 5) {
								return;
						}
						messages = messages.slice(0,first);
						hasmorelines = false;
						var lcnt:int = 0;
						for(n in jsq.data) {
								lcnt++;
								if(lcnt > linelimit) {
										hasmorelines = true;
										break;
								}
								messages.push(jsq.data[n]);
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
						mc.MESSAGES.Set("LINE",messages,59,1,mc.LineClick,mc.DrawMessageListItem,mc.MASK,mc.SB);
						mc.SB.ScrollTo(scroll);
						if(update_postoffice) {
								if(WinMgr.WindowOpened("postoffice.PostOffice")) {
										Modules.GetClass("postoffice","postoffice.PostOffice").UpdateList();
								}
						}
				}
				
				public function Prepare(aparams:Object) : void {
						opening = true;
						this.funnelid = Util.StringVal(aparams.funnelid,"PROFILE");
						if(aparams.user_id) {
								this.uid = aparams.user_id;
						} else {
								this.uid = Sys.mydata.id;
						}
						this.BTNCLOSE.AddEventClick(this.Hide);
						this.BTNCLOSE.SetCaption("X");
						aparams.waitfordata = true;
						message = aparams.message;
						this.LoadUserData();
						this.USERID.visible = false;
						if(this.uid == Sys.mydata.id) {
								this.TABS.Set(["info","system_messages"],this.DrawUserData);
						} else {
								this.TABS.Set(["info","mails"],this.DrawUserData);
						}
						if(aparams.page == "MAILS") {
								this.TABS.SetActiveTab(2);
								if(mc.MSGTITLE) {
										mc.MSGTITLE.visible = false;
								}
								if(mc.MSG) {
										mc.MSG.visible = false;
								}
								if(mc.CTITLE) {
										Lang.Set(mc.CTITLE,"message_title+:");
								}
								if(mc.CMSG) {
										Lang.Set(mc.CMSG,"message+:");
								}
						}
						Imitation.AddGlobalListener("MYDATACHANGE",this.OnMyDataChange);
				}
				
				private function OnMouseDown(e:*) : void {
						var p:Point = Imitation.GetMousePos();
						if(Boolean(mc.MSB) && Boolean(mc.MSB.dragging)) {
								return;
						}
						if(Boolean(mc.MSG) && mc.MSG.text != "") {
								return;
						}
						if(Boolean(mc.MSGTITLE) && mc.MSGTITLE.getRect(Imitation.stage).contains(Imitation.stage.mouseX,Imitation.stage.mouseY)) {
								return;
						}
						if(Boolean(mc.MSG) && mc.MSG.getRect(Imitation.stage).contains(Imitation.stage.mouseX,Imitation.stage.mouseY)) {
								return;
						}
						this.mousedown = true;
						this.mousedown_x = p.x;
				}
				
				private function OnMouseUp(e:*) : void {
						this.mousedown = false;
						var p:Point = Imitation.GetMousePos();
						if(p.x < this.mousedown_x - 60) {
								this.Hide();
						}
				}
				
				private function LoadUserData() : void {
						JsQuery.Load(UserDataProc,[],"client_userdata.php?stoc=" + Config.stoc,{"userid":this.uid});
				}
				
				private function ShowMSGScroll(e:* = null) : * {
						if(!mc.MSG) {
								return;
						}
						var maxScrollV:int = Imitation.GetMaxScrollV(mc.MSG) - 1;
						var scrollV:int = Imitation.GetScrollV(mc.MSG);
						if(this.lastmaxscrollv != maxScrollV) {
								scrollV = maxScrollV;
								Imitation.SetScrollV(mc.MSG,scrollV);
						}
						mc.MSGSB.visible = maxScrollV > 1;
						mc.MSGSB.Set(maxScrollV + 7.5,7,scrollV + 1);
				}
				
				private function OnMSGScroll(pos:*) : * {
						Imitation.SetScrollV(mc.MSG,pos);
				}
				
				private function ShowMessageScroll() : * {
						mc.MESSAGE.MESSAGE.TEXT.height = mc.MESSAGE.MESSAGE.TEXT.textHeight + 30;
						mc.MSB.visible = mc.MESSAGE.MESSAGE.TEXT.height > 100;
						mc.MSB.Set(mc.MESSAGE.MESSAGE.TEXT.height + 100,150,0);
						Imitation.SetMaskedMov(mc.MESSAGE.MASK,mc.MESSAGE.MESSAGE);
						mc.MSB.SetScrollRect(mc.MESSAGE.MASK);
						mc.MSB.isaligned = false;
						mc.MSB.isfloat = false;
						this.OnMessageScroll(0);
						mc.MESSAGE.MESSAGE.BTNPRIOR.y = mc.MESSAGE.MESSAGE.TEXT.height + 5;
				}
				
				private function OnMessageScroll(pos:*) : * {
						mc.MESSAGE.MESSAGE.y = -pos + 40;
				}
				
				private function DrawClanInfo() : void {
						var u:Object = this.usersdata;
						if(u.clan_id) {
								mc.CLAN.gotoAndStop(1);
								Util.SetText(mc.CLAN.CLAN_NAME,u.clan_name);
								Util.SetText(mc.CLAN.CLAN_XP,u.clan_xppoints);
								Util.SetText(mc.CLAN.CLAN_DAYS,u.clan_days);
						} else {
								mc.CLAN.gotoAndStop(3);
								Lang.Set(mc.CLAN.CLAN_INFO,"no_clan");
								Lang.Set(mc.CLAN.INVITED,"invited_to_clan");
								mc.CLAN.INVITED.visible = Util.NumberVal(u.clan_invited) != 0;
						}
				}
				
				private function DrawClanMemberButtons() : void {
						var w:MovieClip = null;
						var friendly:Boolean = false;
						var myadminright:Number = NaN;
						var u:Object = this.usersdata;
						if(u) {
								w = this.CLANBUTTONS;
								w.BTN_1.visible = false;
								w.BTN_2.visible = false;
								w.BTN_3.visible = false;
								friendly = Boolean(this.friendship) && this.friendship.flag == 1;
								myadminright = Util.NumberVal(Sys.myclanproperties.adminright);
								if(u.signup_time) {
										w.BTN_1.visible = true;
										w.BTN_1.skin = "OK";
										w.BTN_1.SetEnabled(true);
										w.BTN_1.AddEventClick(OnAcceptSignup,{"target":Util.StringVal(u.id)});
										w.BTN_1.SetCaption(Lang.Get("accept"));
										w.BTN_2.visible = true;
										w.BTN_2.skin = "CANCEL";
										w.BTN_2.SetEnabled(true);
										w.BTN_2.AddEventClick(OnDenySignup,{"target":Util.StringVal(u.id)});
										w.BTN_2.SetCaption(Lang.Get("deny"));
										w.BTN_3.visible = false;
								} else if(Util.NumberVal(u.id) != Util.NumberVal(Sys.mydata.id) && myadminright > 0 && Util.NumberVal(u.clan_id) == 0 && Util.NumberVal(u.clan_invited) == 0) {
										w.BTN_1.visible = true;
										w.BTN_1.skin = "OK";
										w.BTN_1.SetEnabled(true);
										w.BTN_1.AddEventClick(this.OnInviteClick,{"target":Util.StringVal(u.id)});
										w.BTN_1.SetCaption(Lang.Get("invite"));
								} else if(Util.NumberVal(u.clan_id) != 0) {
										if(Util.NumberVal(u.id) == Util.NumberVal(Sys.mydata.id)) {
												w.BTN_1.visible = true;
												w.BTN_1.skin = "CANCEL";
												w.BTN_1.SetEnabled(true);
												w.BTN_1.AddEventClick(this.OnButtonClick,{
														"cmd":"exit",
														"msg":Lang.Get("ask_quit_clan"),
														"target":Util.StringVal(u.id)
												});
												w.BTN_1.SetCaption(Lang.Get("leave_the_clan"));
										} else if(Boolean(Sys.myclanproperties) && Util.NumberVal(u.clan_id) == Util.NumberVal(Sys.myclanproperties.id)) {
												if(myadminright == 1 && Util.NumberVal(u.clan_adminright) == 0) {
														w.BTN_1.visible = true;
														w.BTN_1.skin = "CANCEL";
														w.BTN_1.SetEnabled(true);
														w.BTN_1.AddEventClick(this.OnButtonClick,{
																"cmd":"kick",
																"msg":Lang.Get("ask_kick_clan_member"),
																"target":Util.StringVal(u.id)
														});
														w.BTN_1.SetCaption(Lang.Get("kick_klan"));
												} else if(myadminright == 2 && Util.NumberVal(u.clan_adminright) == 1) {
														w.BTN_1.visible = true;
														w.BTN_1.skin = "CANCEL";
														w.BTN_1.SetEnabled(true);
														w.BTN_1.AddEventClick(this.OnButtonClick,{
																"cmd":"revoke",
																"msg":Lang.Get("sure_cancel_admin"),
																"target":Util.StringVal(u.id)
														});
														w.BTN_1.SetCaption(Lang.Get("demote_member"));
												} else if(myadminright == 2 && Util.NumberVal(u.clan_adminright) == 0) {
														w.BTN_1.visible = true;
														w.BTN_1.skin = "OK";
														w.BTN_1.SetEnabled(true);
														w.BTN_1.AddEventClick(this.OnButtonClick,{
																"cmd":"grant",
																"msg":Lang.Get("sure_make_admin"),
																"target":Util.StringVal(u.id)
														});
														w.BTN_1.SetCaption(Lang.Get("promote_admin"));
														w.BTN_2.visible = true;
														w.BTN_2.skin = "CANCEL";
														w.BTN_2.SetEnabled(true);
														w.BTN_2.AddEventClick(this.OnButtonClick,{
																"cmd":"kick",
																"msg":Lang.Get("ask_kick_clan_member"),
																"target":Util.StringVal(u.id)
														});
														w.BTN_2.SetCaption(Lang.Get("kick_klan"));
												}
										}
								}
						}
				}
				
				private function OnButtonClick(e:Object) : void {
						mc.CLANBUTTONS.BTN_1.SetEnabled(false);
						mc.CLANBUTTONS.BTN_2.SetEnabled(false);
						mc.CLANBUTTONS.BTN_3.SetEnabled(false);
						var msg:String = Util.StringVal(e.params.msg);
						Modules.GetClass("uibase","uibase.MessageWin").AskYesNo("",msg,Lang.Get("ok"),Lang.Get("cancel"),OnSendMemberRequest,[e.params]);
				}
				
				private function OnInviteClick(e:Object) : void {
						WinMgr.ShowLoadWait();
						mc.CLANBUTTONS.BTN_1.SetEnabled(false);
						JsQuery.Load(OnClanCommandReady,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
								"cmd":"invite_send",
								"target":e.params.target
						});
				}
				
				public function DrawUserData(apage:* = 1) : * {
						var a:Object = null;
						var m:MovieClip = null;
						var p:MovieClip = null;
						var scale:Number = NaN;
						var sp:Number = NaN;
						var u:Object = this.usersdata;
						var f:Object = null;
						var i:int = 0;
						while(i < Friends.all.length) {
								a = Friends.all[i];
								if(a.id == this.uid && a.flag != 4) {
										f = a;
										break;
								}
								i++;
						}
						this.friendship = f;
						mc.TABS.TTAB2.visible = Boolean(f) && f.flag == 1 || Sys.mydata.id == this.uid;
						Imitation.AddEventMouseDown(this.BG,this.OnMouseDown);
						Imitation.AddEventMouseUp(this.BG,this.OnMouseUp);
						if(apage == 2) {
								if(message) {
										if(this.uid == Sys.mydata.id) {
												this.gotoAndStop(7);
										} else {
												this.gotoAndStop(6);
										}
								} else if(this.uid == Sys.mydata.id) {
										this.gotoAndStop(5);
								} else {
										this.gotoAndStop(4);
								}
						} else if(this.uid == Sys.mydata.id) {
								this.gotoAndStop(1);
						} else if(Boolean(f) && (f.external || f.flag == 1)) {
								this.gotoAndStop(2);
						} else {
								this.gotoAndStop(3);
						}
						Util.StopAllChildrenMov(this);
						if(!u) {
								return;
						}
						Imitation.CollectChildrenAll(this);
						this.AVATAR.ShowUID(this.uid);
						this.AVATAR.ShowFrame(u.xplevel,u.actleague);
						Util.SetText(this.NAME,u.name);
						if(u.id == Sys.mydata.id) {
								this.TOTALXP.visible = true;
								Util.SetText(this.TOTALXP,Lang.Get("total_xp") + ": " + Util.FormatNumber(Util.NumberVal(Sys.mydata.xppoints)));
						} else {
								this.TOTALXP.visible = false;
						}
						if(currentFrame == 1) {
								Lang.Set(this.C_VEP,"answer_power+:");
								Lang.Set(this.C_MCQ,"multiple_choice_answer_power+:");
								Lang.Set(this.C_GUESS,"guess_answer_power+:");
								Util.SetText(this.VEP,Math.round(Util.NumberVal(Sys.mydata.vep) / 100) + "%");
								Util.SetText(this.MCQ,Math.round(Util.NumberVal(Sys.mydata.mcq) / 100) + "%");
								Util.SetText(this.GUESS,Math.round(Util.NumberVal(Sys.mydata.guess) / 100) + "%");
						} else if(currentFrame == 4) {
								this.MASK.visible = false;
								mc.MESSAGES.visible = false;
								UpdateList();
								mc.BTNSEND.SetLangAndClick("send",this.SendMailClick);
								if(mc.CTITLE) {
										Lang.Set(mc.CTITLE,"message_title+:");
								}
								if(mc.CMSG) {
										Lang.Set(mc.CMSG,"message+:");
								}
								Util.RTLEditSetup(mc.MSG);
								Util.RTLEditSetup(mc.MSGTITLE);
								Util.AddEventListener(mc.MSG,Event.CHANGE,this.ShowMSGScroll);
								this.ShowMSGScroll();
								mc.MSGSB.OnScroll = this.OnMSGScroll;
								mc.MSGTITLE.text = mytitle;
								Util.SetRTLEditText(mc.MSGTITLE,mytitle);
								this.VerifyMessage();
								Util.AddEventListener(mc.MSGTITLE,"change",this.OnTextChanged);
								Util.AddEventListener(mc.MSG,"change",this.OnTextChanged);
						} else if(currentFrame == 5) {
								this.MASK.visible = false;
								mc.MESSAGES.visible = false;
								if(mc.SB) {
										mc.SB.visible = false;
								}
								UpdateList();
						} else if(currentFrame == 6) {
								priorshown = false;
								if(mc.CTITLE) {
										Lang.Set(mc.CTITLE,"message_title+:");
								}
								if(mc.CMSG) {
										Lang.Set(mc.CMSG,"message+:");
								}
								Util.RTLEditSetup(mc.MSG);
								Util.RTLEditSetup(mc.MSGTITLE);
								message.title = message.title.replace(/&gt;/gi,">");
								Util.SetRTLEditText(mc.MSGTITLE,(Config.rtl ? "" : ">") + message.title);
								Util.SetRTLEditText(mc.MSG,mytext);
								mc.BTNSEND.SetLangAndClick("answer",this.SendMailClick);
								Util.AddEventListener(mc.MSG,Event.CHANGE,this.ShowMSGScroll);
								this.ShowMSGScroll();
								mc.MSGSB.OnScroll = this.OnMSGScroll;
								message.text = message.text.replace(/<br \/>\r\n/gi,"\r\n");
								Util.AddEventListener(mc.MSGTITLE,"change",this.OnTextChanged);
								Util.AddEventListener(mc.MSG,"change",this.OnTextChanged);
								this.VerifyMessage();
								m = mc.MESSAGE;
								Util.SetText(m.TIMEVALUE,message.time);
								Util.SetText(m.MSGTITLE,message.title);
								Util.SetText(m.MESSAGE.TEXT,message.text);
								this.ShowMessageScroll();
								mc.MESSAGE.MESSAGE.BTNPRIOR.y = mc.MESSAGE.MESSAGE.TEXT.height + 25;
								mc.MESSAGE.MESSAGE.BTNPRIOR.SetLangAndClick("load_prior",this.PriorClick);
								mc.MESSAGE.MESSAGE.BTNPRIOR.visible = message.priorid;
								mc.MSB.OnScroll = this.OnMessageScroll;
								m.BTNCLOSE.visible = true;
								m.BTNCLOSE.SetLangAndClick("close",function():* {
										message = null;
										DrawUserData(2);
								});
								m.BTNDELETE.SetLangAndClick("delete",this.DeleteMailClick);
								if(message.flag != 1) {
										UpdateItem(message.id,1);
								}
						} else if(currentFrame == 7) {
								priorshown = false;
								message.text = message.text.replace(/<br \/>\r\n/gi,"\r\n");
								m = mc.MESSAGE;
								Util.SetText(m.TIMEVALUE,message.time);
								Util.SetText(m.MSGTITLE,message.title);
								Util.SetText(m.MESSAGE.TEXT,message.text);
								this.ShowMessageScroll();
								mc.MESSAGE.MESSAGE.BTNPRIOR.y = mc.MESSAGE.MESSAGE.TEXT.height + 25;
								mc.MESSAGE.MESSAGE.BTNPRIOR.SetLangAndClick("load_prior",this.PriorClick);
								mc.MESSAGE.MESSAGE.BTNPRIOR.visible = message.priorid;
								mc.MSB.OnScroll = this.OnMessageScroll;
								m.BTNCLOSE.visible = true;
								m.BTNCLOSE.SetLangAndClick("close",function():* {
										message = null;
										DrawUserData(2);
								});
								m.BTNDELETE.SetLangAndClick("delete",this.DeleteMailClick);
								if(message.flag != 1) {
										UpdateItem(message.id,1);
								}
						}
						if(currentFrame <= 2) {
								Util.SetText(this.FIRSTLOGIN,Util.StringVal(u.firstlogin));
								Util.SetText(this.LASTGAME,Util.StringVal(u.lastgame));
								Lang.Set(this.C_FIRSTLOGIN,"firstlogin+:");
								Lang.Set(this.C_LASTGAME,"last_game+:");
								p = this.XPINFO;
								if(u.id == Sys.mydata.id) {
										p.LVLFIELD.text = u.xplevel;
										p.NEXTLVLFIELD.text = u.xplevel + 1;
										p.XPPOINTS.text = Util.FormatNumber(Util.NumberVal(Sys.mydata.xppoints) - Util.NumberVal(Sys.mydata.xpactmin)) + " / " + Util.FormatNumber(Util.NumberVal(Sys.mydata.xptonextlevel) - Util.NumberVal(Sys.mydata.xpactmin)) + " " + Lang.Get("xp");
										if(Sys.mydata.xppoints !== undefined) {
												scale = (Sys.mydata.xppoints - Sys.mydata.xpactmin) / (Sys.mydata.xptonextlevel - Sys.mydata.xpactmin);
												sp = scale;
												if(sp > 1) {
														sp = 1;
												}
												if(sp < 0) {
														sp = 0;
												}
												p.BAR.scaleX = sp;
										} else {
												p.BAR.scaleX = 0.01;
										}
										p.visible = true;
								} else {
										p.visible = false;
								}
								Util.SetText(this.PLACE1,Util.NumberVal(u.place1cnt).toString());
								Util.SetText(this.PLACE2,Util.NumberVal(u.place2cnt).toString());
								Util.SetText(this.PLACE3,Util.NumberVal(u.place3cnt).toString());
								Util.SetText(this.GLORIOUSVICTORY,Util.NumberVal(u.map50pcnt).toString());
								Util.SetText(this.FULLMAPVICTORY,Util.NumberVal(u.map100pcnt).toString());
								Util.SetText(this.GAMECOUNT,Util.NumberVal(u.gamecount).toString());
								Util.SetText(this.GAMECOUNTSR,Util.NumberVal(u.gamecountsr).toString());
								Lang.Set(this.C_GAMECOUNT,"game_count+:");
								Lang.Set(this.C_GAMECOUNTSR,"game_count_separate+:");
								Lang.Set(this.C_FULLMAPVICTORY,"fullmap_victory+:");
								Lang.Set(this.C_GLORIOUSVICTORY,"glorious_victory+:");
						}
						if(currentFrame <= 3) {
								this.DrawButtons();
								this.DrawClanInfo();
								this.DrawClanMemberButtons();
						}
				}
				
				private function OnTextChanged(e:*) : void {
						mytitle = Util.GetRTLEditText(mc.MSGTITLE);
						mytext = Util.GetRTLEditText(mc.MSG);
						this.VerifyMessage();
				}
				
				private function DeleteMailClick(e:*) : void {
						var mid:* = undefined;
						var MessageWin:* = Modules.GetClass("uibase","uibase.MessageWin");
						mid = message.id;
						MessageWin.AskYesNo(Lang.get("delete"),Lang.get("ask_delete_msg"),Lang.get("yes"),Lang.get("no"),function(a:*):* {
								if(a == 1) {
										UpdateItem(mid,2);
								}
						});
				}
				
				private function SendMailClick(e:*) : void {
						var MessageWin:* = Modules.GetClass("uibase","uibase.MessageWin");
						if(!this.BTNSEND.btnenabled) {
								return;
						}
						this.BTNSEND.SetEnabled(false);
						if(outcount > maxout) {
								MessageWin.Show(Lang.get("outbox"),Lang.get("warn_outbox_full",Sys.mydata.name));
								return;
						}
						var socials:String = Util.StringVal(Config.flashvars.social_friends);
						prior_msg_id = !!message ? String(message.id) : "0";
						JsQuery.Load(ProcessSend,[],"client_messages.php?" + Sys.FormatGetParamsStoc({"cmd":"send"},true),{
								"to":this.uid,
								"priorid":prior_msg_id,
								"title":Util.GetRTLEditText(this.MSGTITLE),
								"message":Util.GetRTLEditText(this.MSG),
								"social_friends":socials
						});
				}
				
				public function VerifyMessage(e:Event = null) : void {
						var result:Boolean = Util.StrTrim(this.MSG.text) != "" && Util.StrTrim(this.MSGTITLE.text) != "" && (Boolean(this.friendship) && this.friendship.flag == 1);
						this.BTNSEND.SetEnabled(result);
				}
				
				public function PriorClick(e:*) : * {
						if(priorshown) {
								if(Config.rtl) {
										Util.SetText(mc.MESSAGE.MESSAGE.TEXT,message.text);
								} else {
										mc.MESSAGE.MESSAGE.TEXT.htmlText = message.text;
								}
								this.ShowMessageScroll();
								priorshown = false;
								mc.MESSAGE.MESSAGE.BTNPRIOR.SetLang("load_prior");
						} else {
								this.UpdatePrior(message.priorid);
								mc.MESSAGE.MESSAGE.BTNPRIOR.visible = false;
						}
				}
				
				public function UpdatePrior(mid:String) : * {
						JsQuery.Load(ProcessPrior,[],"client_messages.php?" + Sys.FormatGetParamsStoc({
								"cmd":"prior",
								"priorid":mid
						},true));
				}
				
				public function FormatPriorMessage(uid:*, text:String) : String {
						if(Config.rtl) {
								return text.replace(/<br \/>\r\n/gi,"\r\n");
						}
						return "<font color=\"" + (uid == Sys.mydata.id ? "#881100" : "#001188") + "\">" + text.replace(/<br \/>\r\n/gi,"<br />") + "</font>";
				}
				
				public function DrawButtons() : * {
						var f:Object = null;
						var w:MovieClip = this.BUTTONS;
						f = this.friendship;
						if(this.uid == Sys.mydata.id) {
								return;
						}
						if(f == null) {
								w.gotoAndStop("INVITE");
								w.BTNINVITE.SetLangAndClick("invite",function():* {
										Friends.AddFriendShip(uid,OnFriendsChanged);
								});
								w.BTNBLOCK.SetLangAndClick("block",function():* {
										Friends.BlockUser(uid,OnFriendsChanged);
								});
								Lang.Set(this.INFO,"friendship_info_pending");
								if(w.INFO) {
										Lang.Set(w.INFO,"invite_or_block");
								}
						} else if(f.external) {
								this.BTNCANCELF.visible = false;
						} else if(0 == f.flag) {
								w.gotoAndStop("PENDING");
								w.BTNCANCELP.SetLangAndClick("cancel_invitation",function():* {
										Friends.CancelFriendShip(f.id,OnFriendsChanged);
								});
								Lang.Set(this.INFO,"friendship_info_pending");
								if(w.INFO) {
										Lang.Set(w.INFO,"cancel_friendship");
								}
						} else if(1 == f.flag) {
								this.BTNCANCELF.SetLangAndClick("cancel_friendship",function():* {
										Modules.GetClass("uibase","uibase.MessageWin").AskYesNo(Lang.Get("cancel_friendship"),Lang.Get("ask_cancel_friendship"),Lang.Get("yes"),Lang.Get("cancel"),function(result:*):* {
												if(result == 1) {
														Friends.CancelFriendShip(f.id,OnFriendsChanged);
												}
										});
								});
								this.BTNCANCELF.visible = true;
						} else if(2 == f.flag) {
								w.gotoAndStop("INVITED");
								w.BTNACCEPT.SetLangAndClick("accept",function():* {
										Friends.AddFriendShip(f.id,OnFriendsChanged);
								});
								w.BTNDENY.SetLangAndClick("deny",function():* {
										Friends.DenyFriendShip(f.id,OnFriendsChanged);
								});
								w.BTNBLOCK.SetLangAndClick("block",function():* {
										Friends.BlockUser(f.id,OnFriendsChanged);
								});
								Lang.Set(mc.INFO,"friendship_info_invite");
								if(w.INFO) {
										Lang.Set(w.INFO,"ask_friendship");
								}
						} else if(3 == f.flag) {
								w.gotoAndStop("BLOCKED");
								w.BTNCANCELB.SetLangAndClick("cancel_block",function():* {
										Friends.CancelBlock(f.id,OnFriendsChanged);
								});
								Lang.Set(this.INFO,"friendship_info_blocked");
								if(w.INFO) {
										Lang.Set(w.INFO,"cancel_block");
								}
						}
				}
				
				public function OnFriendsChanged(e:* = null) : void {
						this.DrawUserData();
						if(e == null && WinMgr.WindowOpened("postoffice.PostOffice")) {
								Modules.GetClass("postoffice","postoffice.PostOffice").mc.OnFriendsChanged(null);
						}
				}
				
				public function AfterOpen() : void {
						opening = false;
						Imitation.AddGlobalListener("FRIENDSCHANGED",this.OnFriendsChanged);
						this.xpos = mc.x;
						Imitation.AddGlobalListener(Event.ENTER_FRAME,OnEnterFrame);
						if(mc.MSGTITLE) {
								mc.MSGTITLE.visible = true;
								mc.MSG.visible = true;
						}
						if(mc.USERID) {
								mc.USERID.visible = true;
								mc.USERID.text = this.uid;
						}
				}
				
				public function OnMyDataChange(e:Event = null) : void {
						trace("profile.OnMyDataChange");
						if(this.uid == Sys.mydata.id) {
								this.AVATAR.Clear();
								this.AVATAR.ShowUID(this.uid);
						}
				}
				
				public function Hide(e:Object = null) : void {
						if(mc.MSG) {
								Util.RemoveEventListener(mc.MSG,"change",this.OnTextChanged);
						}
						if(mc.MSG) {
								mc.MSG.removeEventListener(Event.CHANGE,this.ShowMSGScroll);
						}
						if(mc.MSGTITLE) {
								Util.RemoveEventListener(mc.MSGTITLE,"change",this.OnTextChanged);
						}
						Imitation.RemoveGlobalListener("MYDATACHANGE",mc.OnMyDataChange);
						Imitation.RemoveGlobalListener("FRIENDSCHANGED",this.OnFriendsChanged);
						Imitation.RemoveGlobalListener(Event.ENTER_FRAME,OnEnterFrame);
						Imitation.RemoveEvents(this);
						WinMgr.CloseWindow(this);
				}
				
				public function LineClick(item:*, idx:*) : * {
						trace("LineClick");
						message = messages[idx];
						this.DrawUserData(2);
				}
				
				public function DrawMessageListItem(mov:*, id:*) : * {
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
										if(parseInt(msg.fromid) == 0) {
												Imitation.GotoFrame(mov.BG,3);
										} else {
												Imitation.GotoFrame(mov.BG,parseInt(msg.flag) == 1 ? 1 : 2);
										}
										mov.x = msg.fromid == Sys.mydata.id ? 10 : 0;
										uname = msg.toid == Sys.mydata.id ? msg.fromname : msg.toname;
										Util.SetText(mov.TITLE,msg.title);
										Util.SetText(mov.TIMEVALUE,msg.time);
										Imitation.AddEventClick(mov.BTNDELETE,this.DeleteItemClick);
										Imitation.AddEventMouseOver(mov.BTNDELETE,this.OnBtnDeleteOver);
										Imitation.AddEventMouseOut(mov.BTNDELETE,this.OnBtnDeleteOut);
								}
						} else {
								mov.visible = false;
								mov.stop();
								mov.BG.stop();
								Imitation.RemoveEvents(mov);
						}
				}
				
				private function OnBtnDeleteOver(e:*) : void {
						Imitation.GotoFrame(e.target,2);
				}
				
				private function OnBtnDeleteOut(e:*) : void {
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
				
				public function LoadMoreClick(e:*) : * {
						e.target.SetEnabled(false);
						UpdateList(messages.length - 1,mc.SB.firstpos);
				}
				
				internal function __setProp_BTNCLOSE_ProfileWindowMov_buttons_0() : * {
						try {
								this.BTNCLOSE["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTNCLOSE.enabled = true;
						this.BTNCLOSE.fontsize = "BIG";
						this.BTNCLOSE.icon = "LEFT";
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
				
				internal function __setProp_BTNCANCELF_ProfileWindowMov_Layer2_1() : * {
						if(this.__setPropDict[this.BTNCANCELF] == undefined || int(this.__setPropDict[this.BTNCANCELF]) != 2) {
								this.__setPropDict[this.BTNCANCELF] = 2;
								try {
										this.BTNCANCELF["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNCANCELF.enabled = true;
								this.BTNCANCELF.fontsize = "SMALL";
								this.BTNCANCELF.icon = "";
								this.BTNCANCELF.skin = "CANCEL";
								this.BTNCANCELF.testcaption = "Delete friendship";
								this.BTNCANCELF.visible = true;
								this.BTNCANCELF.wordwrap = false;
								try {
										this.BTNCANCELF["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTNSEND_ProfileWindowMov_Layer4_3() : * {
						if(this.__setPropDict[this.BTNSEND] == undefined || int(this.__setPropDict[this.BTNSEND]) != 4) {
								this.__setPropDict[this.BTNSEND] = 4;
								try {
										this.BTNSEND["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNSEND.enabled = true;
								this.BTNSEND.fontsize = "MEDIUM";
								this.BTNSEND.icon = "";
								this.BTNSEND.skin = "OK";
								this.BTNSEND.testcaption = "Send letter";
								this.BTNSEND.visible = true;
								this.BTNSEND.wordwrap = false;
								try {
										this.BTNSEND["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTNSEND_ProfileWindowMov_Layer4_5() : * {
						if(this.__setPropDict[this.BTNSEND] == undefined || int(this.__setPropDict[this.BTNSEND]) != 6) {
								this.__setPropDict[this.BTNSEND] = 6;
								try {
										this.BTNSEND["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTNSEND.enabled = true;
								this.BTNSEND.fontsize = "MEDIUM";
								this.BTNSEND.icon = "";
								this.BTNSEND.skin = "OK";
								this.BTNSEND.testcaption = "Send letter";
								this.BTNSEND.visible = true;
								this.BTNSEND.wordwrap = false;
								try {
										this.BTNSEND["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function frame2() : * {
						this.__setProp_BTNCANCELF_ProfileWindowMov_Layer2_1();
				}
				
				internal function frame4() : * {
						this.__setProp_BTNSEND_ProfileWindowMov_Layer4_3();
				}
				
				internal function frame6() : * {
						this.__setProp_BTNSEND_ProfileWindowMov_Layer4_5();
				}
		}
}

