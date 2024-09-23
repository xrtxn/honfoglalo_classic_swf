package clan {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import flash.events.TextEvent;
		import syscode.*;
		import uibase.lego_button_2x1_ok;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol759")]
		public class Join extends MovieClip {
				public static var active:Boolean = false;
				
				public static var refresh:Boolean = true;
				
				public static var currenttab:uint = 0;
				
				public static var currentpos:int = -1;
				
				public static var billboardhot100mypositions:Array = [0,-1,-1,-1,-1];
				
				public static var billboardhot100datas:Array = [null,null,null,null,null];
				
				public static var dataquerytimestamps:Array = [null,-1,-1,-1,-1];
				
				public static var clanproperties:Object = null;
				
				public static var currentadmission:* = 3;
				
				public static var options:* = [true,true,false];
				
				public var BTNCREATE:lego_button_2x1_ok;
				
				public var CB_1:MovieClip;
				
				public var CB_2:MovieClip;
				
				public var CB_3:MovieClip;
				
				public var CLANINFO:MovieClip;
				
				public var CONTAINER_LIST:MovieClip;
				
				public var MEMBERLIST:MovieClip;
				
				public var MYJOIN:MovieClip;
				
				public var SEARCH:MovieClip;
				
				public function Join() {
						super();
				}
				
				public static function trace(... arguments) : * {
						MyTrace.myTrace(arguments);
				}
				
				public static function Init() : void {
						trace("Clan.Join.Init");
						Join.currentpos = -1;
						Join.currenttab = 2;
						Join.currentadmission = 3;
						options = [true,true,false];
						Clan.OnLoadRosterList(Join.currentadmission);
				}
				
				public function Show() : void {
						trace("Clan.Join.Show");
						Util.StopAllChildrenMov(this);
						this.MEMBERLIST.visible = false;
						this.CLANINFO.visible = false;
						this.MYJOIN.visible = false;
						List.currentdata = [];
						this.MYJOIN.MYAVATAR.ShowUID(Sys.mydata.id);
						Util.SetText(this.MYJOIN.TXT_MYNAME.FIELD,Sys.mydata.name);
						this.Draw(Join.refresh ? 0 : Join.currenttab);
						this.ClearSearchInput();
						Join.refresh = true;
						this.visible = true;
						Join.active = true;
				}
				
				private function DrawCheckBoxes() : void {
						var cb:MovieClip = null;
						for(var i:int = 1; i <= 3; i++) {
								cb = this["CB_" + i];
								if(cb) {
										Imitation.GotoFrame(cb.ICON,8 - i);
										cb.CHECK.CHECK.visible = options[i - 1] | options[2];
								}
						}
				}
				
				public function Draw(_tab:* = 1) : void {
						TweenMax.killTweensOf(this);
						Imitation.CollectChildrenAll(this);
						this.BTNCREATE.SetLangAndClick("create",this.OnCreateClick);
						Join.currentpos = Join.refresh ? 0 : Join.currentpos;
						this.HideSearch();
						this.DrawCheckBoxes();
						this.DrawRosterList();
						if(Boolean(List.currentdata) && Boolean(List.currentdata[currentpos])) {
								Clan.OnLoadForeignClanMembers(Util.NumberVal(List.currentdata[currentpos].allianceid));
						} else if(_tab != 0) {
								TweenMax.delayedCall(0.1,Clan.ArriveData);
						}
						this.DrawSearch();
						this.Activate();
						Join.refresh = false;
				}
				
				private function OnJoinClick(e:* = null) : void {
						var alliance:Object = List.currentdata[Join.currentpos];
						if(!alliance) {
								return;
						}
						var cmd:String = Util.StringVal(e.params.cmd);
						var label:String = Util.StringVal(e.params.label);
						var allianceid:String = Util.StringVal(Util.NumberVal(!!alliance.id ? alliance.id : alliance.allianceid));
						var params:Object = {};
						params.cmd = cmd;
						params.label = label;
						params.allianceid = allianceid;
						if(cmd == "user_delete_signup" || cmd == "signup" || cmd == "invite_accept") {
								Clan.AskSignupRequest(params);
						}
				}
				
				private function OnCreateClick(e:* = null) : void {
						Clan.mc.Draw(Clan.CREATE_PAGE_NUMBER,true);
				}
				
				private function DrawRosterList() : void {
						if(!List.currentdata) {
								return;
						}
						var myposvisible:Boolean = List.mypos == -1 && Clan.id > 0;
						var w:MovieClip = this.CONTAINER_LIST;
						if(w.MASK_LINES) {
								w.MASK_LINES.visible = true;
						}
						w.LINES.Set("LINE_",List.currentdata,40,1,this.OnLineClick,this.DrawLine,w.MASK_LINES,w.SB);
						w.SB.ScrollTo(Join.refresh ? List.mypos - 3 : Join.currentpos - 3,0);
						w.SB.dragging = true;
						w.visible = true;
				}
				
				private function DrawSearch() : void {
						this.ShowSearch();
				}
				
				private function DrawLine(_item:MovieClip, _id:int) : void {
						var tag:Object = null;
						var lm:MovieClip = null;
						var minleague:int = 0;
						if(_item) {
								tag = List.currentdata[_id];
								if(tag) {
										lm = _item.JOIN;
										if(_item.DEFAULT) {
												_item.DEFAULT.visible = false;
										}
										if(_item.MY) {
												_item.MY.visible = false;
										}
										if(lm) {
												lm.cacheAsBitmap = false;
												Util.SetText(lm.NAME.FIELD,tag.name);
												lm.LAYER.visible = _id == Join.currentpos;
												if(tag.admission == 0) {
														if(tag.invite) {
																lm.JOIN.gotoAndStop(7);
																Lang.Set(lm.JOIN.INVITED.FIELD,"you_were_invited");
														} else {
																lm.JOIN.gotoAndStop(5);
																Lang.Set(lm.JOIN.INVITE_ONLY.FIELD,"invite_only");
														}
														lm.BG.gotoAndStop(5);
														lm.LAYER.gotoAndStop(5);
												} else {
														if(tag.invite) {
																lm.JOIN.gotoAndStop(7);
																Lang.Set(lm.JOIN.INVITED.FIELD,"you_were_invited");
														} else {
																lm.JOIN.gotoAndStop(tag.admission == 1 ? 3 : 1);
																Util.SetText(lm.JOIN.LABEL_LVL.FIELD,"LvL");
																Util.SetText(lm.JOIN.TEXT_MIN_LVL.FIELD,Util.NumberVal(tag.cond_minxplevel).toString());
																Lang.Set(lm.JOIN.LABEL_LEAGUE.FIELD,"league");
																lm.JOIN.LABEL_LEAGUE.visible = false;
																minleague = Util.NumberVal(tag.cond_minleague);
																Imitation.GotoFrame(lm.JOIN.CROWN,minleague > 0 ? minleague : 9);
														}
														lm.BG.gotoAndStop(tag.admission == 1 ? 3 : 1);
														lm.LAYER.gotoAndStop(tag.admission == 1 ? 3 : 1);
														Clan.DrawShield(lm.SHIELD,tag.shield);
												}
												Util.SetText(lm.JOIN.MEMBERS.FIELD,Util.NumberVal(tag.members) + "/" + Math.max(4,Util.NumberVal(tag.xplevel)));
										}
										_item.visible = true;
								} else {
										_item.visible = false;
								}
						}
				}
				
				private function HideLinesStroke() : void {
						var i:int = 0;
						var w:MovieClip = this.CONTAINER_LIST;
						var item:MovieClip = null;
						var lm:MovieClip = null;
						if(w.LINES) {
								for(i = 1; i <= 7; i++) {
										item = w.LINES["LINE_" + i];
										if(item) {
												lm = item.JOIN;
												if(Boolean(lm) && Boolean(lm.LAYER.visible)) {
														lm.LAYER.visible = false;
												}
										}
								}
						}
				}
				
				private function Activate() : void {
						this.ActivateCB();
				}
				
				private function ActivateCB() : void {
						var cb:MovieClip = null;
						for(var i:int = 1; i <= 3; i++) {
								cb = this["CB_" + i];
								if(cb) {
										Imitation.AddEventClick(cb,this.OnCBClick,{"currenttab":i});
								}
						}
				}
				
				private function ActivateSearch() : void {
						Imitation.EnableInput(this,true);
						Imitation.AddStageEventListener(TextEvent.TEXT_INPUT,this.OnInputKeyUp);
						Imitation.AddEventClick(this.SEARCH.BTN_RESET,this.OnSearchReset);
						this.SEARCH.BTN_ENTER.AddEventClick(this.OnSearchSend);
						this.SEARCH.BTN_ENTER.SetIcon("PLAY");
				}
				
				private function InActivate() : void {
						this.InActivateCB();
						this.InActivateSearch();
				}
				
				private function InActivateSearch() : void {
						Imitation.EnableInput(this,false);
						Imitation.RemoveStageEventListener(TextEvent.TEXT_INPUT,this.OnInputKeyUp);
				}
				
				private function InActivateCB() : void {
						var tab:MovieClip = null;
						for(var i:int = 1; i <= 3; i++) {
								tab = this["CB_" + i];
								if(tab) {
										Imitation.RemoveEvents(tab);
								}
						}
				}
				
				private function OnLineClick(_item:MovieClip, _id:int) : void {
						var lm:MovieClip = null;
						var p:Object = null;
						if(_item) {
								Join.currentpos = _id;
								this.HideLinesStroke();
								lm = _item.JOIN;
								if(lm) {
										lm.LAYER.visible = true;
								}
								p = List.currentdata[Join.currentpos];
								if(p) {
										Clan.OnLoadForeignClanMembers(Util.NumberVal(!!p.id ? p.id : p.allianceid));
								}
						}
				}
				
				public function OnForeignClanMembersLoaded() : * {
						var w:MovieClip = this.CLANINFO;
						Util.SetText(w.CLAN_NAME.FIELD,List.clanproperties.alliance.name);
						w.INFO.FIELD.autoSize = "center";
						Util.SetText(w.INFO.FIELD,Util.StringVal(List.clanproperties.alliance.intro));
						Imitation.CollectChildrenAll(w);
						Imitation.SetMaskedMov(w.MASK_INFO,w.INFO);
						Imitation.AddEventMask(w.MASK_INFO,w.INFO);
						w.SB_INFO.Set(w.INFO.height + 20,100,0);
						w.SB_INFO.OnScroll = this.OnDynamicIntroScrolling;
						w.SB_INFO.SetScrollRect(w.MASK_INFO);
						w.SB_INFO.isaligned = false;
						w.SB_INFO.visible = w.INFO.height > 105;
						Clan.DrawShield(w.SHIELD,List.clanproperties.alliance.shield);
						w.visible = true;
						Util.SetText(w.MEMBERS.FIELD,List.clanproperties.members.length + "/" + Math.max(4,List.clanproperties.alliance.xplevel));
						Util.SetText(w.LEVEL.FIELD,List.clanproperties.alliance.xplevel.toString());
						Lang.Set(w.LVL.FIELD,"level");
						this.DrawMemberList();
						this.DrawReport();
						var p:Object = List.currentdata[Join.currentpos];
						if(p) {
								this.MYJOIN.visible = (Util.NumberVal(p.admission) > 0 || Boolean(p.invite)) && (Sys.mydata.xplevel >= Util.NumberVal(p.cond_minxplevel) && (Util.NumberVal(p.cond_minleague) == 0 || Sys.mydata.league <= Util.NumberVal(p.cond_minleague)));
								if(p.signup == 1) {
										this.MYJOIN.BTNJOIN.SetLangAndClick("revoke",this.OnJoinClick,{
												"cmd":"user_delete_signup",
												"label":"revoke"
										});
								} else if(p.invite) {
										this.MYJOIN.BTNJOIN.SetLangAndClick("accept",this.OnJoinClick,{
												"cmd":"invite_accept",
												"label":"join"
										});
								} else {
										this.MYJOIN.BTNJOIN.SetLangAndClick("join",this.OnJoinClick,{
												"cmd":"signup",
												"label":"join"
										});
								}
						} else {
								this.MYJOIN.visible = false;
						}
				}
				
				private function OnDynamicIntroScrolling(_pos:Number) : void {
						this.CLANINFO.INFO.y = 38 + _pos * -1;
				}
				
				private function DrawMemberList() : void {
						var p:Object = List.clanproperties;
						var w:MovieClip = this;
						var myadminright:Number = Util.NumberVal(p.alliance.adminright);
						w = this.MEMBERLIST;
						w.visible = true;
						w.FLINES.Set("FLINE_",p.members,40,1,null,this.DrawForeignLine,w.MASK_LINES,w.SB);
						w.SB.ScrollTo(0,0);
						w.SB.dragging = true;
				}
				
				private function DrawForeignLine(_item:MovieClip, _id:int) : void {
						var members:Array = null;
						var tag:Object = null;
						var friendly:* = false;
						if(_item) {
								members = List.clanproperties.members;
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
								_lm.OVER.visible = false;
								if(Boolean(u) && Clan.winopened) {
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
								DBG.Trace("DrawMemberLine _tag",_tag);
								w = this;
								u = Extdata.GetUserData(Util.StringVal(_tag.userid));
								_lm.visible = true;
								Util.SetText(_lm.TXT_NAME.FIELD,Romanization.ToLatin(Util.StringVal(_tag.name)));
								Util.SetText(_lm.TXT_ACTIVE.FIELD,_tag.days + " " + Lang.Get("days"));
								Util.SetText(_lm.TXT_INACTIVE.FIELD,_tag.days + " " + Lang.Get("days"));
								Lang.Set(_lm.XP.FIELD,"xp");
								Util.SetText(_lm.TXT_XPPOINTS.FIELD,_tag.xppoints);
								Util.SetText(_lm.TXT_XPWEEKLY.FIELD,_tag.xppoints_weekly);
								if(_tag.prev_week_pos == 0) {
										Imitation.GotoFrame(_lm.ARROW,7);
								} else if(_id == _tag.prev_week_pos) {
										Imitation.GotoFrame(_lm.ARROW,5);
								} else {
										Imitation.GotoFrame(_lm.ARROW,_id < _tag.prev_week_pos ? 1 : 3);
								}
								Imitation.GotoFrame(_lm.ICON,Util.NumberVal(_tag.adminright) + 1);
								_lm.TXT_ACTIVE.visible = Util.NumberVal(_tag.inactive) == 0;
								_lm.TXT_INACTIVE.visible = !_lm.TXT_ACTIVE.visible;
								_lm.OVER.visible = false;
								if(Boolean(u) && Clan.winopened) {
										_lm.AVATAR.ShowUID(u.id);
								} else {
										_lm.AVATAR.Clear();
								}
								_lm.AVATAR.DisableClick();
								Imitation.AddEventClick(_lm,function(e:Object):* {
										w.OnMemberLineClick(_lm,_id);
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
				
				public function OnMemberLineClick(_item:MovieClip, _id:int) : void {
						if(Boolean(_item) && !Modules.GetClass("uibase","uibase.ScrollBarMov").global_dragging) {
								WinMgr.OpenWindow("profile2.Profile2",{
										"user_id":List.clanproperties.members[_id].userid,
										"fadeIn":"left",
										"fadeOut":"left"
								});
						}
				}
				
				private function OnCBClick(e:Object) : void {
						var c:int = Util.NumberVal(e.params.currenttab);
						options[c - 1] = !options[c - 1];
						if(c < 3 && Boolean(options[2])) {
								options[0] = c != 1;
								options[1] = c != 2;
								options[2] = false;
						}
						Join.currentadmission = !!options[2] ? -1 : (!!options[0] ? Settings.PUBLIC : 0) | (!!options[1] ? Settings.PRIVATE : 0);
						Clan.OnLoadRosterList(Join.currentadmission);
				}
				
				private function OnSearchSend(e:Object = null) : void {
						var search:String = Util.Trim(Util.GetRTLEditText(this.SEARCH.INPUT.FIELD));
						if(search.length == 0) {
								search = null;
						}
						if(Boolean(search) && search.length >= 3) {
								billboardhot100datas = [null,null,null,null,null];
								this.InActivate();
								Clan.OnLoadRosterList(Join.currentadmission,search);
						}
				}
				
				private function OnSearchReset(e:Object) : void {
						var params:Array = null;
						if(Util.Trim(Util.GetRTLEditText(this.SEARCH.INPUT.FIELD)).length > 0) {
								this.ClearSearchInput();
								billboardhot100datas = [null,null,null,null,null];
								this.InActivate();
								params = [null,"alltime","weekly","prev","alltime"];
								Clan.OnLoadRosterList(Join.currentadmission);
						}
				}
				
				private function OnInputKeyUp(e:TextEvent) : void {
						if(e.text.charCodeAt() == 10 && Join.active) {
								e.preventDefault();
								this.OnSearchSend();
						}
				}
				
				private function ShowSearch() : void {
						this.ActivateSearch();
						this.SEARCH.visible = true;
						this.SEARCH.INPUT.FIELD.restrict = Config.GetNameRestrictChars();
						Util.RTLEditSetup(this.SEARCH.INPUT.FIELD);
				}
				
				private function ClearSearchInput() : void {
						this.SEARCH.INPUT.FIELD.text = "";
				}
				
				private function HideSearch() : void {
						this.InActivateSearch();
						this.SEARCH.visible = false;
				}
				
				public function Hide() : void {
						trace("Clan.Join.Hide");
						TweenMax.killTweensOf(this);
						Util.StopAllChildrenMov(this);
						this.HideSearch();
						this.InActivate();
						this.visible = false;
						Join.active = false;
						Join.refresh = true;
				}
				
				public function UpdateReport() : void {
						var p:Object = List.clanproperties.alliance;
						p.reported = 1;
						this.DrawReport();
				}
				
				private function DrawReport() : void {
						var w:MovieClip = this.CLANINFO.REPORT;
						var p:Object = List.clanproperties.alliance;
						var active:* = Util.NumberVal(p.reported) == 0;
						w.visible = !Sys.myclanproperties || Sys.myclanproperties.id != p.id;
						w.SetIcon("EXCLAMATION_MARK");
						if(active) {
								Imitation.AddEventClick(w,this.OnReportClick);
								w.alpha = 1;
						} else {
								Imitation.RemoveEvents(w);
								w.alpha = 0.3;
						}
				}
				
				private function OnReportClick(e:Object = null) : void {
						var p:Object = List.clanproperties.alliance;
						Modules.GetClass("uibase","uibase.MessageWin").AskYesNo("",Lang.Get("send_report_confirm") + "\n\n" + Util.StringVal(p.name),Lang.Get("ok"),Lang.Get("cancel"),Clan.OnSendReport);
				}
		}
}

