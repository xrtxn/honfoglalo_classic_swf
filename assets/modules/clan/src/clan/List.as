package clan {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import flash.events.TextEvent;
		import flash.utils.getTimer;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol754")]
		public class List extends MovieClip {
				public static var active:Boolean = false;
				
				public static var refresh:Boolean = true;
				
				public static var currenttab:uint = 0;
				
				public static var currentpos:int = -1;
				
				public static var mypos:int = -1;
				
				public static var currentdata:Array = null;
				
				public static var billboardhot100mypositions:Array = [0,-1,-1,-1,-1];
				
				public static var billboardhot100datas:Array = [null,null,null,null,null];
				
				public static var dataquerytimestamps:Array = [null,-1,-1,-1,-1];
				
				public static var clanproperties:Object = null;
				
				public var CLANINFO:MovieClip;
				
				public var CONTAINER_LIST:MovieClip;
				
				public var MEMBERLIST:MovieClip;
				
				public var SEARCH:MovieClip;
				
				public var TAB_1:MovieClip;
				
				public var TAB_2:MovieClip;
				
				public var TAB_3:MovieClip;
				
				public function List() {
						super();
				}
				
				public static function Init() : void {
						List.currentpos = -1;
						List.currenttab = 2;
						Clan.OnLoadClanList("weekly");
				}
				
				public function Show() : void {
						Util.StopAllChildrenMov(this);
						this.MEMBERLIST.visible = false;
						this.CLANINFO.visible = false;
						this.Draw(List.refresh ? 0 : List.currenttab);
						this.ClearSearchInput();
						List.refresh = true;
						this.visible = true;
						List.active = true;
				}
				
				private function DrawTabs() : void {
						var tab:MovieClip = null;
						for(var i:int = 1; i <= 3; i++) {
								tab = this["TAB_" + i];
								if(tab) {
										Imitation.GotoFrame(tab,i == List.currenttab ? 1 : 3);
										Imitation.GotoFrame(tab.ICON,i);
										Imitation.FreeBitmapAll(tab);
										Imitation.UpdateAll(tab);
								}
						}
				}
				
				public function Draw(_tab:uint) : void {
						TweenMax.killTweensOf(this);
						Imitation.CollectChildrenAll(this);
						if(_tab == 0) {
								this.DrawTabs();
								this.HideSearch();
								if(this.CONTAINER_LIST) {
										this.CONTAINER_LIST.visible = false;
								}
								this.InActivate();
						} else {
								List.currentpos = List.refresh ? -1 : List.currentpos;
								this.DrawTabs();
								this.DrawTop();
								this.DrawSearch();
								this.Activate();
								Clan.ArriveData();
						}
				}
				
				private function DrawTop() : void {
						var titles:Array = [null,"top","weekly_top","last_week_top"];
						var myclanxp:Array = [null,Clan.xp,Clan.weeklyxp,Clan.lastweekxp];
						if(List.billboardhot100datas[List.currenttab]) {
								List.currentdata = List.billboardhot100datas[List.currenttab];
								List.mypos = List.billboardhot100mypositions[List.currenttab];
						} else {
								List.billboardhot100datas[List.currenttab] = List.currentdata;
								List.billboardhot100mypositions[List.currenttab] = List.mypos;
						}
						this.DrawList(myclanxp[List.currenttab]);
				}
				
				private function DrawList(_xp:uint) : void {
						var myposvisible:Boolean = List.mypos == -1 && Clan.id > 0;
						var w:MovieClip = this.CONTAINER_LIST;
						if(w.MASK_LINES) {
								w.MASK_LINES.visible = true;
						}
						w.LINES.Set("LINE_",List.currentdata,40,1,this.OnLineClick,this.DrawLine,w.MASK_LINES,w.SB);
						w.SB.ScrollTo(List.refresh ? List.mypos - 3 : List.currentpos - 3,0);
						w.SB.dragging = true;
						w.visible = true;
				}
				
				private function DrawSearch() : void {
						this.ShowSearch();
				}
				
				private function DrawLine(_item:MovieClip, _id:int) : void {
						var tag:Object = null;
						var lm:MovieClip = null;
						if(_item) {
								tag = List.currentdata[_id];
								if(tag) {
										lm = _id == List.mypos ? _item.MY : _item.DEFAULT;
										if(_item.MY) {
												_item.MY.visible = _id == List.mypos;
										}
										if(Boolean(_item.MY) && Boolean(_item.DEFAULT)) {
												_item.DEFAULT.visible = !_item.MY.visible;
										}
										if(_item.JOIN) {
												_item.JOIN.visible = false;
										}
										if(lm) {
												lm.cacheAsBitmap = false;
												lm.LAYER.visible = _id == List.currentpos;
												lm.LAYER.gotoAndStop(7);
												lm.RANK.FIELD.text = _id + 1 + ".";
												Util.SetText(lm.NAME.FIELD,tag.name);
												Lang.Set(lm.XP_L.FIELD,"xp");
												lm.SCORE.FIELD.text = Util.FormatNumber(Util.NumberVal(tag.xp)) + " " + Lang.Get("xp");
												lm.LAYER.visible = _id == List.currentpos;
												Util.SetText(lm.LEVEL.FIELD,Util.NumberVal(tag.xplevel).toString());
												Util.SetText(lm.MEMBERS.FIELD,Util.NumberVal(tag.members) + "/" + Math.max(4,Util.NumberVal(tag.xplevel)));
												lm.ARROW.visible = currenttab == 2;
												if(tag.prev_week_pos == 0) {
														Imitation.GotoFrame(lm.ARROW,7);
												} else if(_id + 1 == tag.prev_week_pos) {
														Imitation.GotoFrame(lm.ARROW,5);
												} else {
														Imitation.GotoFrame(lm.ARROW,_id + 1 < tag.prev_week_pos ? 1 : 3);
												}
												Clan.DrawShield(lm.SHIELD,tag.shield);
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
												lm = !!item.MY.visible ? item.MY : item.DEFAULT;
												if(lm) {
														lm.LAYER.visible = false;
												}
										}
								}
						}
				}
				
				private function Activate() : void {
						this.ActivateTabs();
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
				
				private function ActivateSearch() : void {
						Imitation.EnableInput(this,true);
						Imitation.AddStageEventListener(TextEvent.TEXT_INPUT,this.OnInputKeyUp);
						Imitation.AddEventClick(this.SEARCH.BTN_RESET,this.OnSearchReset);
						this.SEARCH.BTN_ENTER.AddEventClick(this.OnSearchSend);
						this.SEARCH.BTN_ENTER.SetIcon("PLAY");
				}
				
				private function InActivate() : void {
						this.InActivateTabs();
						this.InActivateSearch();
				}
				
				private function InActivateSearch() : void {
						Imitation.EnableInput(this,false);
						Imitation.RemoveStageEventListener(TextEvent.TEXT_INPUT,this.OnInputKeyUp);
				}
				
				private function InActivateTabs() : void {
						var tab:MovieClip = null;
						for(var i:int = 1; i <= 3; i++) {
								tab = this["TAB_" + i];
								if(tab) {
										Imitation.RemoveEvents(tab);
								}
						}
				}
				
				private function OnLineClick(_item:MovieClip, _id:int) : void {
						var lm:MovieClip = null;
						var p:Object = null;
						if(_item) {
								List.currentpos = _id;
								this.HideLinesStroke();
								lm = !!_item.MY.visible ? _item.MY : _item.DEFAULT;
								if(lm) {
										lm.LAYER.visible = true;
								}
								p = List.currentdata[List.currentpos];
								if(p) {
										Clan.OnLoadForeignClanMembers(Util.NumberVal(p.id));
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
						Lang.Set(w.LVL.FIELD,"level");
						Util.SetText(w.MEMBERS.FIELD,List.clanproperties.members.length + "/" + Math.max(4,List.clanproperties.alliance.xplevel));
						Util.SetText(w.LEVEL.FIELD,List.clanproperties.alliance.xplevel.toString());
						this.DrawMemberList();
						this.DrawReport();
				}
				
				private function OnDynamicIntroScrolling(_pos:Number) : void {
						this.CLANINFO.INFO.y = 38 + _pos * -1;
				}
				
				private function DrawMemberList() : void {
						var p:Object = List.clanproperties;
						var w:MovieClip = this;
						if(!p) {
								return;
						}
						var myadminright:Number = Util.NumberVal(p.alliance.adminright);
						w = this.MEMBERLIST;
						w.visible = true;
						w.FLINES.Set("FLINE_",p.members,40,1,null,this.DrawForeignLine,w.MASK_LINES,w.SB);
						w.SB.ScrollTo(0,0);
						w.SB.dragging = true;
						this.CONTAINER_LIST.LINES.Draw(true);
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
								Util.SetText(_lm.TXT_NAME.FIELD,Romanization.ToLatin(Util.StringVal(_tag.name)));
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
								w = this;
								u = Extdata.GetUserData(Util.StringVal(_tag.userid));
								_lm.visible = true;
								Util.SetText(_lm.TXT_NAME.FIELD,Romanization.ToLatin(Util.StringVal(_tag.name)));
								Util.SetText(_lm.TXT_ACTIVE.FIELD,_tag.days + " " + Lang.Get("days"));
								Util.SetText(_lm.TXT_INACTIVE.FIELD,_tag.days + " " + Lang.Get("days"));
								Lang.Set(_lm.XP.FIELD,"xp");
								Util.SetText(_lm.TXT_XPPOINTS.FIELD,_tag.xppoints);
								if(currenttab == 3) {
										Util.SetText(_lm.TXT_XPWEEKLY.FIELD,_tag.xppoints_weekly_prev);
								} else {
										Util.SetText(_lm.TXT_XPWEEKLY.FIELD,_tag.xppoints_weekly);
								}
								_lm.OVER.visible = false;
								_lm.ARROW.visible = currenttab == 2;
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
				
				private function OnTabClick(e:Object) : void {
						var params:Array = null;
						var p:Object = null;
						if(List.currenttab != Util.NumberVal(e.params.currenttab)) {
								params = [null,"alltime","weekly","prev","alltime"];
								List.currenttab = Util.NumberVal(e.params.currenttab);
								if(Util.Trim(Util.GetRTLEditText(this.SEARCH.INPUT.FIELD)).length > 0) {
										this.ClearSearchInput();
										billboardhot100datas = [null,null,null,null,null];
								}
								if(List.currenttab < 3 && List.billboardhot100datas[List.currenttab] && 180000 > getTimer() - List.dataquerytimestamps[List.currenttab] || List.currenttab == 3 && List.billboardhot100datas[List.currenttab] || List.currenttab == 0) {
										this.Draw(List.currenttab);
										p = List.currentdata[List.currentpos];
										if(p) {
												Clan.OnLoadForeignClanMembers(Util.NumberVal(p.id));
										} else if(List.active) {
												Clan.mc.currentpage.OnForeignClanMembersLoaded();
										}
								} else {
										this.InActivate();
										List.dataquerytimestamps[List.currenttab] = getTimer();
										Clan.OnLoadClanList(params[List.currenttab]);
								}
						}
				}
				
				private function OnSearchSend(e:Object = null) : void {
						var search:String = Util.Trim(Util.GetRTLEditText(this.SEARCH.INPUT.FIELD));
						if(search.length == 0) {
								search = null;
						}
						if(Boolean(search) && search.length >= 3) {
								billboardhot100datas = [null,null,null,null,null];
								this.InActivate();
								Clan.OnLoadClanList("search",search);
						}
				}
				
				private function OnSearchReset(e:Object) : void {
						var params:Array = null;
						if(Util.Trim(Util.GetRTLEditText(this.SEARCH.INPUT.FIELD)).length > 0) {
								this.ClearSearchInput();
								billboardhot100datas = [null,null,null,null,null];
								this.InActivate();
								params = [null,"alltime","weekly","prev","alltime"];
								Clan.OnLoadClanList(params[List.currenttab]);
						}
				}
				
				private function OnInputKeyUp(e:TextEvent) : void {
						if(e.text.charCodeAt() == 10 && List.active) {
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
						TweenMax.killTweensOf(this);
						Util.StopAllChildrenMov(this);
						this.HideSearch();
						this.InActivate();
						this.visible = false;
						List.active = false;
						List.refresh = true;
						if(this.CONTAINER_LIST.SB) {
								this.CONTAINER_LIST.SB.Remove();
						}
						if(this.CLANINFO.SB_INFO) {
								this.CLANINFO.SB_INFO.Remove();
						}
						if(this.MEMBERLIST.SB) {
								this.MEMBERLIST.SB.Remove();
						}
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

