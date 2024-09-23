package clan {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import flash.utils.getTimer;
		import syscode.*;
		import uibase.lego_button_1x1_cancel_header;
		import uibase.lego_button_1x1_normal_header;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol466")]
		public class Clan extends MovieClip {
				public static var mc:Clan = null;
				
				public static var winopened:Boolean = false;
				
				public static var isdatawaiting:Boolean = false;
				
				public static var NONE:uint = 0;
				
				public static var JOIN_PAGE_NUMBER:uint = 1;
				
				public static var LIST_PAGE_NUMBER:uint = 2;
				
				public static var SETTINGS_PAGE_NUMBER:uint = 3;
				
				public static var HELP_PAGE_NUMBER:uint = 3;
				
				public static var MEMBERLIST_PAGE_NUMBER:uint = 1;
				
				public static var CREATE_PAGE_NUMBER:uint = 7;
				
				public static var SHIELDS_PAGE_NUMBER:uint = 4;
				
				public static const CHAT_PCH:String = "-3";
				
				public static var myclanproperties:Object = null;
				
				public static var id:Number = 0;
				
				public static var name:String = "";
				
				public static var xplevel:uint = 0;
				
				public static var members:uint = 0;
				
				public static var invites:uint = 0;
				
				public static var signups:uint = 0;
				
				public static var blocked:Boolean = false;
				
				public static var namechange:Boolean = false;
				
				public static var xp:Number = 0;
				
				public static var weeklyxp:Number = 0;
				
				public static var lastweekxp:Number = 0;
				
				public static var shield_symbol:Number = 0;
				
				public static var shield_bg:Number = 0;
				
				private static var firstprocessed:* = false;
				
				private static var chatshown:Boolean = false;
				
				public var BOUNDS:MovieClip;
				
				public var BTNHELP:lego_button_1x1_normal_header;
				
				public var BTN_CLOSE:lego_button_1x1_cancel_header;
				
				public var ERROR:MovieClip;
				
				public var FOOTER:MovieClip;
				
				public var PAGE:MovieClip;
				
				public var TABS:HeaderTabs;
				
				public var currentpage:MovieClip = null;
				
				public var currentpagenumber:Number = 0;
				
				public var errorpanel:MovieClip = null;
				
				public function Clan() {
						super();
				}
				
				public static function trace(... arguments) : * {
						MyTrace.myTrace(arguments);
				}
				
				public static function OnTagsProcessed(_jsq:Object = null) : void {
						trace("Clan.OnTagsProcessed");
						if(Clan.firstprocessed) {
								if(!Clan.chatshown && Clan.winopened && MemberList.active && Boolean(mc.currentpage)) {
										InsertOtherMessages(int.MAX_VALUE);
										MemberList.chatbuf.top = MemberList.chatbuf.fullheight - mc.currentpage.MASK.height + 20;
										Clan.chatshown = true;
								}
						}
						if(Clan.isdatawaiting) {
								TweenMax.delayedCall(0.1,ArriveData);
						}
						if(Clan.winopened && MemberList.active && Boolean(mc.currentpage)) {
								mc.currentpage.MESSAGES.ITEMS.visible = true;
								mc.currentpage.DrawChatMessages(false);
								mc.currentpage.UpdateChatScrollBar();
								mc.currentpage.UpdateChatPos();
						}
						Clan.firstprocessed = true;
				}
				
				public static function DrawScreen() : * {
				}
				
				public static function DrawShield(smc:MovieClip, data:uint) : * {
						var shield_symbol:int = data % 256;
						var shield_bg:int = int(data / 256);
						if(shield_symbol) {
								smc.gotoAndStop(shield_bg + 1);
								smc.SYMBOL.gotoAndStop(shield_symbol);
						} else {
								smc.gotoAndStop(4);
						}
						Imitation.FreeBitmapAll(smc);
				}
				
				public static function ShowErrorPanel(_msg:String, _callback:Function = null, _anim:Boolean = true) : void {
						var p:ErrorPanel = null;
						if(Boolean(Clan.mc) && !Clan.mc.errorpanel) {
								p = new ErrorPanel();
								p.Show(_msg,_callback,_anim);
								if(Clan.mc.currentpage) {
										Imitation.Combine(Clan.mc.currentpage,true);
								}
								Clan.mc.errorpanel = p;
								Clan.mc.ERROR.addChild(Clan.mc.errorpanel);
						}
				}
				
				public static function HideErrorPanel() : void {
						if(Clan.mc) {
								if(Clan.mc.currentpage) {
										Imitation.Combine(Clan.mc.currentpage,false);
								}
								Util.RemoveChildren(Clan.mc.ERROR);
								Clan.mc.errorpanel = null;
						}
				}
				
				public static function ProcessMyClanData() : void {
						var p:Object = Sys.myclanproperties;
						trace("SYS:: " + Util.FormatTrace(p));
						if(p) {
								Clan.id = Util.NumberVal(p.id);
								Clan.name = Util.StringVal(p.name);
								Clan.xplevel = Util.NumberVal(p.xplevel);
								Clan.members = Util.NumberVal(p.members);
								Clan.invites = Util.NumberVal(p.invites);
								Clan.signups = Util.NumberVal(p.signups);
								Clan.blocked = Util.NumberVal(p.blocked) == 1;
								Clan.namechange = Util.NumberVal(p.namechange) == 1;
						}
				}
				
				public static function UpdateMyClanData() : void {
						var p:Object = Clan.myclanproperties.alliance;
						if(p) {
								Clan.id = Util.NumberVal(p.id);
								Clan.name = Util.StringVal(p.name);
								Clan.xplevel = Util.NumberVal(p.xplevel);
								Clan.members = Clan.myclanproperties.members.length;
								Clan.invites = Util.NumberVal(p.invite);
								Clan.signups = Util.NumberVal(p.signup);
								Clan.blocked = Util.NumberVal(p.blocked) == 1;
								Clan.namechange = Util.NumberVal(p.namechange) == 1;
								Clan.shield_symbol = Util.NumberVal(p.shield) % 256;
								Clan.shield_bg = int(Util.NumberVal(p.shield) / 256);
						}
				}
				
				public static function ArriveData() : void {
						if(Clan.isdatawaiting) {
								trace("Clan.ArriveData");
								WinMgr.WindowDataArrived(Clan.mc);
								Clan.isdatawaiting = false;
						}
				}
				
				public static function CreateEmptyMyClanProperties() : void {
						Clan.myclanproperties = new Object();
						Clan.myclanproperties.history = [];
						Clan.myclanproperties.members = [];
						Clan.myclanproperties.friends = [];
						Clan.myclanproperties.pages = 0;
						var d:Date = new Date();
						var alliance:Object = new Object();
						alliance.namechange = 0;
						alliance.intro = "";
						alliance.id = 0;
						alliance.lastlevelxp = 0;
						alliance.cond = 0;
						alliance.admission = 2;
						alliance.adminright = 2;
						alliance.name = "";
						alliance.nextlevelxp = 0;
						alliance.founded = d.fullYear + "-" + (d.month + 1) + "-" + d.date;
						alliance.cond_minleague = 7;
						alliance.xppoints_weekly = 0;
						alliance.xppoints = 0;
						alliance.blocked = 0;
						alliance.xppoints_weekly_prev = 0;
						alliance.xplevel = 0;
						alliance.cond_minxplevel = 0;
						Clan.myclanproperties.alliance = alliance;
				}
				
				public static function InsertOtherMessages(ts:int) : void {
						var atag:Object;
						var htag:Object = MemberList.historylines[MemberList.history_n];
						while(Boolean(htag) && htag.uts < ts) {
								Extdata.GetUserData(htag.userid);
								MemberList.chatbuf.AddChatMessage({
										"EVENT":true,
										"TS":Util.NumberVal(htag.uts),
										"UID":htag.userid,
										"NAME":htag.username,
										"MSG":Lang.Get("clan_history_" + Util.StringVal(htag.event).toLowerCase(),"",htag.targetname)
								},mc.currentpage.MESSAGES.ITEMS.PROTOTYPE);
								++MemberList.history_n;
								if(MemberList.history_n >= MemberList.historylines.length) {
										break;
								}
								htag = MemberList.historylines[MemberList.history_n];
						}
						atag = null;
						if(Clan.myclanproperties && Clan.myclanproperties.alliance && Boolean(Clan.myclanproperties.alliance.adminright)) {
								atag = MemberList.applicants[MemberList.applicants_n];
								while(Boolean(atag) && atag.uts < ts) {
										Extdata.GetUserData(atag.userid);
										MemberList.chatbuf.AddChatMessage({
												"EVENT":"signup",
												"TS":Util.NumberVal(atag.uts),
												"UID":atag.userid,
												"NAME":atag.username,
												"MSG":Lang.Get("clan_history_signup","")
										},mc.currentpage.MESSAGES.ITEMS.PROTOTYPE);
										++MemberList.applicants_n;
										if(MemberList.applicants_n >= MemberList.applicants.length) {
												break;
										}
										atag = MemberList.applicants[MemberList.applicants_n];
								}
						}
						if(Boolean(htag) || Boolean(atag)) {
								Extdata.GetSheduledData(function():* {
								});
						}
				}
				
				public static function tagproc_CHATMSG(_tag:Object) : void {
						var cb:LegoChatMessageBuffer = null;
						var msg:Object = null;
						if(Boolean(Clan.mc) && Util.StringVal(_tag.PCH) == Clan.CHAT_PCH) {
								cb = MemberList.chatbuf;
								InsertOtherMessages(_tag.TS);
								if(_tag.UID != Sys.mydata.id && _tag.MSG.indexOf(Lang.get("share_clan_code","")) > -1 && new Date().getTime() / 1000 < Util.NumberVal(_tag.TS) + 60 * 5) {
										_tag.FGCODE = _tag.MSG.substr(_tag.MSG.length - 4,4);
								}
								if(MemberList.active) {
										msg = cb.AddChatMessage(_tag,mc.currentpage.MESSAGES.ITEMS.PROTOTYPE);
										Clan.mc.currentpage.UpdateChatScrollBar();
										Clan.mc.currentpage.UpdateChatPos();
								}
						}
				}
				
				public static function OnAcceptSignup(_signupid:String) : void {
						WinMgr.ShowLoadWait();
						JsQuery.Load(Clan.OnLoadSignupList,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
								"cmd":"accept_signup",
								"signupid":_signupid
						});
				}
				
				public static function OnDenySignup(_signupid:String) : void {
						WinMgr.ShowLoadWait();
						JsQuery.Load(Clan.OnLoadSignupList,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
								"cmd":"alliance_delete_signup",
								"signupid":_signupid
						});
				}
				
				public static function AskRenameRequest(_params:Object) : void {
						var msg:String = Lang.Get("confirm_new_clan_name") + "\n\n" + Util.StringVal(_params.name);
						Modules.GetClass("uibase","uibase.MessageWin").AskYesNo("",msg,Lang.Get("ok"),Lang.Get("cancel"),Clan.OnSendRenameRequest,[_params]);
				}
				
				public static function OnSendRenameRequest(_result:int, _params:Object) : void {
				}
				
				public static function AskMemberRequest(_params:Object) : void {
						var msg:String = Util.StringVal(_params.msg);
						Modules.GetClass("uibase","uibase.MessageWin").AskYesNo("",msg,Lang.Get("ok"),Lang.Get("cancel"),Clan.OnSendMemberRequest,[_params]);
				}
				
				public static function OnSendMemberRequest(_result:int, _params:Object) : void {
						if(_result == 1) {
								WinMgr.ShowLoadWait();
								MemberList.currentcmd = Util.StringVal(_params.cmd).toUpperCase();
								JsQuery.Load(Clan.OnMemberRequestResult,[_params],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),_params);
						} else if(Boolean(Clan.mc.currentpage) && MemberList.active) {
								Clan.mc.currentpage.Draw();
						}
				}
				
				public static function OnMemberRequestResult(_jsq:Object, _params:Object) : void {
						if(Util.NumberVal(_jsq.error) > 0) {
								WinMgr.HideLoadWait();
								Clan.ShowErrorPanel(Util.StringVal(_jsq.errormsg),Boolean(Clan.mc.currentpage) && MemberList.active ? Clan.mc.currentpage.Draw : null);
						} else if(String("|GRANT|REVOKE|KICK|").indexOf(Util.StringVal(_params.cmd).toUpperCase()) >= 0) {
								Clan.OnLoadMyClanProperties();
						} else {
								WinMgr.HideLoadWait();
								Clan.OnExitHACK();
						}
				}
				
				public static function AskSignupRequest(_params:Object) : void {
						Modules.GetClass("uibase","uibase.MessageWin").AskYesNo("",Lang.Get("warning_" + Util.StringVal(_params.label)),Lang.Get("ok"),Lang.Get("cancel"),Clan.OnSendSignupRequest,[_params]);
				}
				
				public static function OnSendSignupRequest(_result:int, _params:Object) : void {
						if(_result == 1) {
								WinMgr.ShowLoadWait();
								JsQuery.Load(Clan.OnSignupResult,[_params],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),_params);
						} else if(Boolean(Clan.mc.currentpage) && Join.active) {
								Clan.mc.currentpage.Draw(Join.currentadmission);
						}
				}
				
				public static function OnSignupResult(_jsq:Object, _params:Object) : void {
						trace("Clan.OnSignupResult");
						WinMgr.HideLoadWait();
						DBG.Trace("params",_params);
						if(Util.NumberVal(_jsq.error) > 0) {
								Clan.ShowErrorPanel(Util.StringVal(_jsq.errormsg));
						} else if(_params && (Util.StringVal(_params.cmd) == "signup" || Util.StringVal(_params.cmd) == "invite_accept") && List.currentdata[Join.currentpos].admission != 1) {
								Clan.OnLoadMyClanProperties();
						} else if(Boolean(_params) && Join.active) {
								Clan.OnLoadRosterList(Join.currentadmission);
						} else {
								Clan.mc.Draw(Clan.JOIN_PAGE_NUMBER,true);
						}
				}
				
				public static function OnLoadMyClanProperties(_jsq:Object = null) : void {
						WinMgr.ShowLoadWait();
						var socials:String = Util.StringVal(Config.flashvars.social_friends);
						JsQuery.Load(Clan.OnMyClanPropertiesResult,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
								"cmd":"alliance",
								"social_friends":socials
						});
				}
				
				public static function OnMyClanPropertiesResult(_jsq:Object) : void {
						WinMgr.HideLoadWait();
						if(Util.NumberVal(_jsq.error) <= 0) {
								Clan.myclanproperties = _jsq.data;
								if(Boolean(Clan.mc) && Boolean(Clan.myclanproperties)) {
										Clan.UpdateMyClanData();
										Clan.mc.UpdateTabs();
										if(Boolean(Clan.mc.currentpage) && ClanShields.active) {
												Clan.mc.currentpage.Draw();
										} else if(Clan.mc.currentpage && Settings.active && !Settings.createclan) {
												Clan.mc.currentpage.Draw();
										} else {
												mc.currentpagenumber = MEMBERLIST_PAGE_NUMBER;
												Clan.mc.Draw(Clan.MEMBERLIST_PAGE_NUMBER,true);
										}
										OnLoadHistory();
								}
						}
				}
				
				public static function OnLoadRosterList(_admission:int, _search:String = null) : void {
						WinMgr.ShowLoadWait();
						var params:Object = {"cmd":"rosterlist"};
						params.admission = _admission;
						if(_search) {
								params.search = _search;
						}
						JsQuery.Load(Clan.OnRosterResult,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),params);
				}
				
				public static function OnRosterResult(_jsq:Object) : void {
						trace("Clan.OnRosterResult");
						WinMgr.HideLoadWait();
						if(Util.NumberVal(_jsq.error) <= 0) {
								List.currentdata = _jsq.data;
								if(Clan.mc && Join.active && Boolean(Clan.mc.currentpage)) {
										Clan.mc.currentpage.Draw();
								}
						}
				}
				
				public static function OnLoadSignupList(_jsq:Object = null) : void {
						WinMgr.ShowLoadWait();
						trace("! get_alliancesignups");
						JsQuery.Load(Clan.OnSignupListResult,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{"cmd":"get_alliancesignups"});
				}
				
				public static function OnSignupListResult(_jsq:Object) : void {
						trace("Clan.OnSignupListResult");
						WinMgr.HideLoadWait();
						if(Util.NumberVal(_jsq.error) > 0) {
								Clan.ShowErrorPanel(Util.StringVal(_jsq.errormsg),Boolean(Clan.mc.currentpage) && MemberList.active ? Clan.mc.currentpage.Draw : null);
						} else {
								MemberList.applicants = _jsq.data;
								if(myclanproperties == null) {
										Clan.OnLoadMyClanProperties();
								} else if(MemberList.active && Boolean(Clan.mc.currentpage)) {
										Clan.mc.currentpage.Draw();
								}
						}
						DBG.Trace("jsq",_jsq.data);
						MemberList.history_n = 0;
						Clan.firstprocessed = false;
						Clan.chatshown = false;
						MemberList.chatbuf.Clear();
						Imitation.AddGlobalListener("TAGSPROCESSED",Clan.OnTagsProcessed);
						Comm.SendCommand("STARTCLANCHAT","");
				}
				
				public static function OnLoadClanList(_cmd:String, _search:String = null) : void {
						WinMgr.ShowLoadWait();
						var params:Object = {"cmd":_cmd};
						if(_search) {
								params.search = _search;
						}
						JsQuery.Load(Clan.OnClanListResult,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),params);
				}
				
				public static function OnClanListResult(_jsq:Object) : void {
						var clans:Array = null;
						var i:uint = 0;
						var p:Object = null;
						var myclanprop:Object = null;
						WinMgr.HideLoadWait();
						if(Util.NumberVal(_jsq.error) > 0) {
								Clan.ShowErrorPanel(Util.StringVal(_jsq.errormsg));
						} else {
								if(_jsq.data.own) {
										myclanprop = _jsq.data.own;
										if(myclanprop) {
												Clan.xp = Util.NumberVal(myclanprop.xppoints);
												Clan.weeklyxp = Util.NumberVal(myclanprop.xppoints_weekly);
												Clan.lastweekxp = Util.NumberVal(myclanprop.xppoints_weekly_prev);
										}
								}
								clans = _jsq.data.clans;
								List.currentdata = [];
								List.mypos = -1;
								for(i = 0; i < clans.length; i++) {
										List.currentdata.push(clans[i]);
										if(Util.NumberVal(clans[i].id) == Clan.id) {
												List.mypos = i;
										}
								}
								if(List.active && Boolean(Clan.mc.currentpage)) {
										Clan.mc.currentpage.Draw(List.currenttab);
								}
								if(Join.active && Boolean(Clan.mc.currentpage)) {
										Clan.mc.currentpage.Draw();
								}
								List.currentpos = List.mypos > -1 ? List.mypos : 0;
								p = List.currentdata[List.currentpos];
								if(p) {
										Clan.OnLoadForeignClanMembers(Util.NumberVal(p.id));
								} else {
										if(List.active) {
												Clan.mc.currentpage.OnForeignClanMembersLoaded();
										}
										if(Join.active) {
												Clan.mc.currentpage.OnForeignClanMembersLoaded();
										}
								}
						}
				}
				
				public static function OnLoadMyClanMembersExdatas(e:Object = null) : void {
						var i:int = 0;
						var u:Object = null;
						WinMgr.ShowLoadWait();
						var emptydata:Boolean = false;
						var p:Object = Clan.myclanproperties;
						if(p) {
								for(i = 0; i < p.members.length; i++) {
										u = Extdata.GetUserData(Util.StringVal(p.members[i].userid));
										if(u == null) {
												emptydata = true;
										}
								}
						}
						if(emptydata) {
								Extdata.GetSheduledData(Clan.OnLoadMyClanMembersExdatas);
						} else {
								WinMgr.HideLoadWait();
								Clan.mc.Draw(Clan.MEMBERLIST_PAGE_NUMBER,true);
						}
				}
				
				public static function OnLoadForeignClanMembers(_clanid:uint) : void {
						if(_clanid) {
								WinMgr.ShowLoadWait();
								JsQuery.Load(Clan.OnForeignClanMembersResult,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
										"cmd":"alliance",
										"allianceid":_clanid
								});
						} else {
								TweenMax.delayedCall(0.1,Clan.ArriveData);
						}
				}
				
				public static function OnForeignClanMembersResult(_jsq:Object) : void {
						if(Util.NumberVal(_jsq.error) > 0) {
								WinMgr.HideLoadWait();
								Clan.ShowErrorPanel(Util.StringVal(_jsq.errormsg));
						} else {
								List.clanproperties = _jsq.data;
								Clan.OnLoadForeignClanExdatas();
						}
				}
				
				public static function OnLoadForeignClanExdatas() : void {
						var i:int = 0;
						var u:Object = null;
						var emptydata:Boolean = false;
						if(List.clanproperties) {
								for(i = 0; i < List.clanproperties.members.length; i++) {
										u = Extdata.GetUserData(Util.StringVal(List.clanproperties.members[i].userid));
										if(u == null) {
												emptydata = true;
										}
								}
						}
						if(emptydata) {
								Extdata.GetSheduledData(Clan.OnLoadForeignClanExdatas);
						} else {
								WinMgr.HideLoadWait();
								if(List.active) {
										Clan.mc.currentpage.OnForeignClanMembersLoaded();
								}
								if(Join.active) {
										Clan.mc.currentpage.OnForeignClanMembersLoaded();
								}
								TweenMax.delayedCall(0.1,Clan.ArriveData);
						}
				}
				
				public static function OnSendReport(_result:int) : void {
						var p:Object = null;
						if(_result == 1) {
								p = List.clanproperties.alliance;
								WinMgr.ShowLoadWait();
								JsQuery.Load(Clan.OnReportResult,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
										"cmd":"report",
										"aid":Util.StringVal(p.id)
								});
						}
				}
				
				public static function OnReportResult(_jsq:Object) : void {
						WinMgr.HideLoadWait();
						if(Util.NumberVal(_jsq.error) > 0) {
								Clan.ShowErrorPanel(Util.StringVal(_jsq.errormsg));
						} else if(List.active && Boolean(Clan.mc.currentpage)) {
								Clan.mc.currentpage.UpdateReport();
						}
				}
				
				public static function OnLoadHistory() : void {
						WinMgr.ShowLoadWait();
						JsQuery.Load(Clan.OnHistoryResult,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
								"cmd":"history",
								"allianceid":Clan.id,
								"page":0
						});
				}
				
				public static function OnHistoryResult(_jsq:Object) : void {
						WinMgr.HideLoadWait();
						if(Util.NumberVal(_jsq.error) > 0) {
								Clan.ShowErrorPanel(Util.StringVal(_jsq.errormsg));
						} else {
								MemberList.historylines = [];
								MemberList.historylines = _jsq.data.history;
						}
						OnLoadSignupList();
				}
				
				public static function OnFoundNewClan(_clanproperties:Object) : void {
						if(_clanproperties) {
								WinMgr.ShowLoadWait();
								JsQuery.Load(Clan.OnNewClanResult,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),_clanproperties);
						}
				}
				
				public static function OnNewClanResult(_jsq:Object) : void {
						var errormsg:String = null;
						WinMgr.HideLoadWait();
						if(Util.NumberVal(_jsq.error) > 0) {
								if(_jsq.error == 11) {
										errormsg = Lang.Get("clan_name_rules");
								} else if(_jsq.error == 12) {
										errormsg = Lang.Get("not_enough_golds");
								} else if(_jsq.error == 13) {
										errormsg = "User already alliance member";
								} else if(_jsq.error == 14) {
										errormsg = Lang.Get("name_exists");
								}
								Clan.ShowErrorPanel(errormsg,Boolean(Clan.mc.currentpage) && Settings.active ? Clan.mc.currentpage.Draw : null);
						} else {
								mc.Hide();
								TweenMax.delayedCall(0.5,function():* {
										WinMgr.OpenWindow("clan.Clan");
								});
						}
				}
				
				public static function OnUpdateMyClanAdmission(_admissionproperties:Object) : void {
						if(_admissionproperties) {
								WinMgr.ShowLoadWait();
								JsQuery.Load(Clan.OnMyClanAdmissionResult,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),_admissionproperties);
						}
				}
				
				public static function OnMyClanAdmissionResult(_jsq:Object) : void {
						WinMgr.HideLoadWait();
						if(Util.NumberVal(_jsq.error) > 0) {
								Clan.ShowErrorPanel(Util.StringVal(_jsq.errormsg),Boolean(Clan.mc.currentpage) && Settings.active ? Clan.mc.currentpage.Draw : null);
						} else {
								Clan.OnLoadMyClanProperties();
						}
				}
				
				public static function OnUpdateMyClanShield(_shieldproperties:Object) : void {
						if(_shieldproperties) {
								WinMgr.ShowLoadWait();
								JsQuery.Load(Clan.OnMyClanShieldResult,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),_shieldproperties);
						}
				}
				
				public static function OnMyClanShieldResult(_jsq:Object) : void {
						WinMgr.HideLoadWait();
						if(Util.NumberVal(_jsq.error) > 0) {
								Clan.ShowErrorPanel(Util.StringVal(_jsq.errormsg),Boolean(Clan.mc.currentpage) && ClanShields.active ? Clan.mc.currentpage.Draw : null);
						} else {
								mc.Draw(SHIELDS_PAGE_NUMBER,true);
						}
				}
				
				public static function OnSendInvite(_target:String) : void {
						if(_target) {
								WinMgr.ShowLoadWait();
								JsQuery.Load(Clan.OnSendInviteResult,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
										"cmd":"invite_send",
										"target":_target
								});
						}
				}
				
				public static function OnSendInviteResult(_jsq:Object) : void {
						if(Util.NumberVal(_jsq.error) > 0) {
								WinMgr.HideLoadWait();
								Clan.ShowErrorPanel(Util.StringVal(_jsq.errormsg),Boolean(Clan.mc.currentpage) && MemberList.active ? Clan.mc.currentpage.Draw : null);
						} else {
								Clan.OnLoadMyClanProperties();
						}
				}
				
				public static function OnAcceptInvite(_allianceid:String) : void {
						if(_allianceid) {
								WinMgr.ShowLoadWait();
								JsQuery.Load(Clan.OnAcceptInviteResult,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
										"cmd":"invite_accept",
										"allianceid":_allianceid
								});
						}
				}
				
				public static function OnAcceptInviteResult(_jsq:Object) : void {
				}
				
				public static function OnRejectInvite(_allianceid:String) : void {
						if(_allianceid) {
								WinMgr.ShowLoadWait();
								JsQuery.Load(Clan.OnRejectInviteResult,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
										"cmd":"invite_reject",
										"allianceid":_allianceid
								});
						}
				}
				
				public static function OnRejectInviteResult(_jsq:Object) : void {
				}
				
				public static function CheckSysClanProperties() : void {
						JsQuery.Load(Clan.OnSysClanPropertiesResult,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{"cmd":"menubutton"});
				}
				
				public static function OnSysClanPropertiesResult(_jsq:Object) : void {
						if(Util.NumberVal(_jsq.error) == 0) {
								Sys.myclanproperties = _jsq.data;
						}
				}
				
				public static function OnExitHACK() : void {
						Clan.id = 0;
						Clan.name = "";
						Clan.xplevel = 0;
						Clan.members = 0;
						Clan.invites = 0;
						Clan.blocked = false;
						Clan.namechange = false;
						if(mc) {
								List.Init();
								Clan.mc.UpdateTabs();
								mc.SetCloseBtn("X",mc.Hide);
						}
				}
				
				public function Prepare(aparams:Object) : void {
						Util.StopAllChildrenMov(this);
						myclanproperties = null;
						Clan.isdatawaiting = true;
						aparams.waitfordata = true;
						Clan.ProcessMyClanData();
						this.SetCloseBtn("X",this.Hide);
						if(Clan.isdatawaiting) {
								Clan.mc.SetTab();
								if(Clan.id > 0) {
										Clan.OnLoadMyClanProperties();
										this.ShowHeader();
								} else {
										this.currentpagenumber = Clan.JOIN_PAGE_NUMBER;
										this.HideHeader();
								}
						}
						this.BTNHELP.SetIcon("HELP");
						this.BTNHELP.AddEventClick(this.OnHelpClick);
						if(Boolean(Sys.myclanproperties) && Sys.myclanproperties.week_close !== undefined) {
								this.FOOTER.LEGO_DAILY_RESET_BIG.rlresetremaining = Util.NumberVal(Sys.myclanproperties.week_close);
								this.FOOTER.LEGO_DAILY_RESET_BIG.rlresettimeref = getTimer();
								this.FOOTER.LEGO_DAILY_RESET_BIG.Start();
						}
				}
				
				public function OnHelpClick(e:*) : void {
						WinMgr.OpenWindow("help.Help",{
								"tab":4,
								"subtab":1
						});
				}
				
				public function AfterOpen() : void {
						trace("Clan.AfterOpen");
						if(Sys.mydata.name == "") {
								this.Hide();
								WinMgr.OpenWindow("settings.AvatarWin");
								return;
						}
						if(Boolean(Sys.myclanproperties) && Sys.myclanproperties.week_close !== undefined) {
								this.FOOTER.LEGO_DAILY_RESET_BIG.rlresetremaining = Util.NumberVal(Sys.myclanproperties.week_close);
								this.FOOTER.LEGO_DAILY_RESET_BIG.rlresettimeref = getTimer();
								this.FOOTER.LEGO_DAILY_RESET_BIG.Start();
						}
						Clan.winopened = true;
						if(this.currentpage) {
								this.currentpage.Draw();
						}
						Imitation.FreeBitmapAll(this.TABS["TTAB" + this.currentpagenumber]);
						Imitation.UpdateAll(this.TABS["TTAB" + this.currentpagenumber]);
				}
				
				public function Draw(_pagenumber:Number, refresh:Boolean = false) : void {
						var p:Object = null;
						var w:MovieClip = null;
						var nextlevelxp:Number = NaN;
						trace("Clan.Draw",_pagenumber,refresh);
						var ischanging:* = this.currentpagenumber != _pagenumber;
						if(ischanging || refresh) {
								this.currentpagenumber = _pagenumber;
								TweenMax.killTweensOf(this);
								this.HidePages();
								p = Clan.myclanproperties;
								if(Boolean(p) && Boolean(p.alliance)) {
										Util.SetText(this.FOOTER.CLAN_NAME.FIELD,Clan.name);
										if(Clan.shield_symbol) {
												this.FOOTER.SHIELD.gotoAndStop(Clan.shield_bg + 1);
												this.FOOTER.SHIELD.SYMBOL.gotoAndStop(Clan.shield_symbol);
										} else {
												this.FOOTER.SHIELD.gotoAndStop(4);
										}
										Imitation.FreeBitmapAll(this.FOOTER.SHIELD);
										w = this.FOOTER.XPINFO;
										nextlevelxp = Util.NumberVal(p.alliance.nextlevelxp) == -1 ? Util.NumberVal(p.alliance.xppoints) : Util.NumberVal(p.alliance.nextlevelxp);
										Util.SetText(w.TXT_XPLEVEL,Util.StringVal(p.alliance.xplevel));
										Util.SetText(w.TXT_NEXTLEVEL,Util.StringVal(p.alliance.xplevel + 1));
										if(p.alliance.xplevel < 50) {
												Util.SetText(w.TXT_XPS,Util.FormatNumber(Util.NumberVal(p.alliance.xppoints)) + " / " + Util.FormatNumber(nextlevelxp));
												w.STRIP.visible = true;
												w.TXT_NEXTLEVEL.visible = true;
										} else {
												Util.SetText(w.TXT_XPS,Util.FormatNumber(Util.NumberVal(p.alliance.xppoints)) + " " + Lang.get("xp"));
												w.STRIP.visible = false;
												w.TXT_NEXTLEVEL.visible = false;
										}
										w.STRIP.scaleX = (Util.NumberVal(p.alliance.nextlevelxp) - Util.NumberVal(p.alliance.xppoints)) / (Util.NumberVal(p.alliance.nextlevelxp) - Util.NumberVal(p.alliance.lastlevelxp));
										if(w.STRIP.scaleX > 1) {
												w.STRIP.scaleX = 1;
										}
										Util.SetText(this.FOOTER.TXT_MEMBERS.FIELD,members + "/" + (Util.NumberVal(xplevel) <= 4 ? 4 : Util.NumberVal(xplevel)));
										Util.SetText(this.FOOTER.TXT_RANK.FIELD,Util.NumberVal(p.alliance.weekly_position).toString());
								}
								if(this.currentpagenumber == Clan.JOIN_PAGE_NUMBER && Clan.id == 0) {
										this.currentpage = new Join();
										if(Join.refresh) {
												Join.Init();
										}
								} else if(this.currentpagenumber == Clan.LIST_PAGE_NUMBER) {
										this.currentpage = new List();
										if(List.refresh) {
												List.Init();
										}
								} else if(this.currentpagenumber != Clan.HELP_PAGE_NUMBER) {
										if(this.currentpagenumber == Clan.SETTINGS_PAGE_NUMBER) {
												Settings.createclan = false;
												this.currentpage = new Settings();
										} else if(this.currentpagenumber == Clan.MEMBERLIST_PAGE_NUMBER) {
												this.currentpage = new MemberList();
										} else if(this.currentpagenumber == Clan.CREATE_PAGE_NUMBER) {
												Settings.createclan = true;
												Clan.CreateEmptyMyClanProperties();
												this.currentpage = new Settings();
										} else if(this.currentpagenumber == Clan.SHIELDS_PAGE_NUMBER) {
												this.currentpage = new ClanShields();
										}
								}
								if(this.currentpagenumber != Clan.CREATE_PAGE_NUMBER) {
										this.SetCloseBtn("X",this.Hide);
								}
								if(this.currentpage) {
										this.PAGE.addChild(this.currentpage);
										this.currentpage.Show();
								}
						}
				}
				
				private function HidePages() : void {
						if(this.currentpage) {
								this.currentpage.Hide();
								this.currentpage = null;
						}
						Util.RemoveChildren(this.PAGE);
				}
				
				public function AfterClose() : void {
						Clan.winopened = false;
				}
				
				public function SetCloseBtn(_icon:String, _callback:Function = null) : void {
						if(this.BTN_CLOSE) {
								if(_callback !== null) {
										this.BTN_CLOSE.AddEventClick(_callback);
								}
								this.BTN_CLOSE.SetIcon("X");
								this.BTN_CLOSE.visible = !(Clan.blocked || Clan.namechange);
						}
				}
				
				public function ShowHeader() : void {
						this.FOOTER.visible = true;
						this.ShowTabs();
				}
				
				public function HideHeader(_closeBtnCallback:Function = null) : void {
						this.FOOTER.visible = false;
				}
				
				private function ShowTabs() : void {
						this.TABS.visible = true;
				}
				
				public function SetTab() : void {
						this.TABS.Set(["my_clan","clan_list","settings","shield"],["CLAN","LIST","SETTINGS","TOURNAMENT_SHIELD"],Clan.mc.Draw);
						HELP_PAGE_NUMBER = 5;
						this.UpdateTabs();
				}
				
				public function UpdateTabs() : void {
						if(Clan.id > 0) {
								this.TABS.TTAB1.title = "my_clan";
								if(Clan.myclanproperties && Clan.myclanproperties.alliance && Clan.myclanproperties.alliance.adminright > 0) {
										this.TABS.Reorder([this.TABS.TTAB1,this.TABS.TTAB2,this.TABS.TTAB3,this.TABS.TTAB4],[true,true,true,true]);
								} else {
										this.TABS.Reorder([this.TABS.TTAB1,this.TABS.TTAB2,this.TABS.TTAB3,this.TABS.TTAB4],[true,true,true,false]);
								}
						} else {
								this.TABS.TTAB1.title = "join";
								this.TABS.Reorder([this.TABS.TTAB1,this.TABS.TTAB2,this.TABS.TTAB3,this.TABS.TTAB4],[true,true,false,false]);
						}
				}
				
				public function HideTabs() : void {
						this.TABS.visible = false;
				}
				
				public function Hide(e:Object = null) : void {
						TweenMax.killTweensOf(this);
						this.FOOTER.LEGO_DAILY_RESET_BIG.Destroy();
						this.HidePages();
						Clan.mc.currentpage = null;
						Clan.mc.currentpagenumber = 0;
						Clan.CheckSysClanProperties();
						Imitation.RemoveGlobalListener("TAGSPROCESSED",Clan.OnTagsProcessed);
						WinMgr.CloseWindow(this);
				}
		}
}

