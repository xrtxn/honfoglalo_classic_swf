package ranklist {
		import com.greensock.TweenMax;
		import flash.display.*;
		import flash.events.*;
		import flash.net.*;
		import flash.text.*;
		import flash.utils.getTimer;
		import syscode.*;
		import uibase.ScrollBarMov7;
		import uibase.lego_button_1x1_cancel_header;
		import uibase.lego_button_1x1_normal;
		import uibase.lego_button_1x1_normal_header;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol508")]
		public class Ranklist extends MovieClip {
				public static var mc:Ranklist = null;
				
				public static var wassent_seen:Boolean = false;
				
				public static var shields_data:Object = {};
				
				public static var windowopened:* = false;
				
				public var BTNCLOSE:lego_button_1x1_cancel_header;
				
				public var BTNHELP:lego_button_1x1_normal_header;
				
				public var CITEMS:CItems;
				
				public var COUNTRY:MovieClip;
				
				public var CP1:ranklist_item_weekly_winner;
				
				public var CP2:ranklist_item_weekly_other;
				
				public var CP3:ranklist_item_weekly_other;
				
				public var CP4:ranklist_item_weekly_other;
				
				public var CP5:ranklist_item_weekly_other;
				
				public var CROWN:MovieClip;
				
				public var CSB:ScrollBarMov7;
				
				public var CSCROLLRECT:MovieClip;
				
				public var C_ACTLEAGUE:MovieClip;
				
				public var C_COUNTRIES:MovieClip;
				
				public var C_FRIENDS:MovieClip;
				
				public var C_INVITE:MovieClip;
				
				public var C_INVITE_BG:MovieClip;
				
				public var C_PERSONAL:MovieClip;
				
				public var DITEMS:DItems;
				
				public var DSB:ScrollBarMov7;
				
				public var DSCROLLRECT:MovieClip;
				
				public var FITEMS:FItems;
				
				public var FSB:ScrollBarMov7;
				
				public var FSCROLLRECT:MovieClip;
				
				public var INVITE:lego_button_1x1_normal;
				
				public var LEGO_DAILY_RESET_BIG:TimerBig;
				
				public var NOSCORE:MovieClip;
				
				public var P1:ranklist_item_weekly_winner;
				
				public var P2:ranklist_item_weekly_other;
				
				public var P3:ranklist_item_weekly_other;
				
				public var P4:ranklist_item_weekly_other;
				
				public var P5:ranklist_item_weekly_other;
				
				public var PITEMS:PItems;
				
				public var PLAYER:MovieClip;
				
				public var TABS:HeaderTabs;
				
				public var TITLE:MovieClip;
				
				public var WEEKLY_C_INFO:MovieClip;
				
				public var WEEKLY_P_INFO:MovieClip;
				
				private var initialized:Boolean = false;
				
				public var waitanim:Object = null;
				
				public var datas:Object;
				
				public var weeklydatas:Object = null;
				
				public var linesdata:Object;
				
				public var currenttype:int = 1;
				
				public var firstactivate:Boolean = true;
				
				public var extendedfriendist:Array;
				
				public var firstshow:Boolean = true;
				
				private var listlength:int = 7;
				
				private var parampage:Number = 1;
				
				public function Ranklist() {
						this.datas = {};
						this.linesdata = {};
						this.extendedfriendist = new Array();
						super();
				}
				
				public static function ShowWeeklyChallange(_jsq:Object) : void {
						WinMgr.HideLoadWait();
						if(_jsq.error > 0) {
								return;
						}
						WinMgr.OpenWindow("ranklist.Ranklist",{
								"data":_jsq.data,
								"type":"auto",
								"activepage":4
						});
				}
				
				public static function CheckAutoCalling(_jsq:Object) : void {
				}
				
				public static function DrawShield(smc:MovieClip, data:* = undefined) : * {
						if(!smc) {
								return;
						}
						if(data !== undefined) {
								smc.alpha = 1;
						} else {
								smc.alpha = 0.3;
								data = 0;
						}
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
				
				public static function LoadShieldsData() : void {
						var k:* = undefined;
						var i:int = 0;
						var lines:* = mc.linesdata[mc.currenttype];
						var uids:Array = [];
						for(k in lines) {
								for(i = 0; i < lines[k].length; i++) {
										if(Boolean(lines[k][i]) && Boolean(lines[k][i].UID) && uids.indexOf(lines[k][i].UID) == -1) {
												uids.push(Util.StringVal(lines[k][i].UID));
										}
								}
						}
						JsQuery.Load(OnShieldsData,[],"client_clans.php?" + Sys.FormatGetParamsStoc({},true),{
								"cmd":"shields",
								"users":uids
						});
				}
				
				private static function OnShieldsData(_jsq:Object) : void {
						var d:* = undefined;
						if(_jsq.error == 0) {
								for each(d in _jsq.data) {
										if(d) {
												shields_data[d.uid] = d.shield;
										}
								}
						}
						mc.LoadExdatas();
				}
				
				public function Hide(e:* = null) : void {
						var i:* = undefined;
						this.LEGO_DAILY_RESET_BIG.Destroy();
						if(mc) {
								for(i = 1; i < this.listlength + 2; i++) {
										if(Boolean(mc.FITEMS) && Boolean(mc.FITEMS["FLINE" + i])) {
												mc.FITEMS["FLINE" + i].AVATAR.Clear();
										}
										if(Boolean(mc.DITEMS) && Boolean(mc.DITEMS["DLINE" + i])) {
												mc.DITEMS["DLINE" + i].AVATAR.Clear();
										}
										if(Boolean(mc.PITEMS) && Boolean(mc.PITEMS["PLINE" + i])) {
												mc.PITEMS["PLINE" + i].AVATAR.Clear();
										}
								}
						}
						WinMgr.CloseWindow(this);
				}
				
				public function Prepare(aparams:Object) : void {
						windowopened = false;
						Util.StopAllChildrenMov(mc);
						mc.BTNCLOSE.AddEventClick(this.Hide);
						mc.BTNCLOSE.SetIcon("X");
						this.BTNHELP.SetIcon("HELP");
						this.BTNHELP.AddEventClick(this.OnHelpClick);
						this.INVITE.AddEventClick(this.OnInvite);
						this.LEGO_DAILY_RESET_BIG.Start();
						this.Clear();
						aparams.waitfordata = true;
						this.firstshow = true;
						if(aparams.activepage) {
								this.parampage = aparams.activepage;
						}
						this.TABS.visible = false;
						this.SetActiveType(1);
				}
				
				public function OnHelpClick(e:*) : void {
						WinMgr.OpenWindow("help.Help",{
								"tab":6,
								"subtab":1
						});
				}
				
				public function AfterOpen() : void {
						windowopened = true;
						if(this.datas[this.currenttype]) {
								TweenMax.delayedCall(0.1,this.ShowAllLines);
						}
						this.DrawTabs();
						if(this.parampage != 1) {
								TweenMax.delayedCall(0.3,this.TABS.SetActiveTab,[this.TABS["TTAB" + this.parampage]]);
						}
				}
				
				private function DrawTabs() : void {
						this.TABS.visible = true;
						this.TABS.Set(["weekly","alltime_ranklist_short","last_week","weekly_challange"],["THIS_WEEK","ALL_TIME","LAST_WEEK","WEEKLY_CHALLENGE"],this.SetActiveType);
						Imitation.FreeBitmapAll(this.TABS);
						Imitation.CollectChildrenAll(this.TABS);
				}
				
				internal function OnInvite(e:*) : * {
						if(Config.loginsystem != "FACE") {
								Util.ExternalCall("InviteFriends",[],"RANKLIST",Sys.FunnelVersion());
						} else {
								WinMgr.OpenWindow("invite.Invite",{"funnelid":"RANKLIST"});
						}
				}
				
				public function Clear() : void {
						if(this.FITEMS) {
								this.FITEMS.visible = false;
						}
						if(this.DITEMS) {
								this.DITEMS.visible = false;
						}
						if(this.PITEMS) {
								this.PITEMS.visible = false;
						}
						if(this.CITEMS) {
								this.CITEMS.visible = false;
						}
						if(this.FSCROLLRECT) {
								this.FSCROLLRECT.visible = false;
						}
						if(this.DSCROLLRECT) {
								this.DSCROLLRECT.visible = false;
						}
						if(this.CSCROLLRECT) {
								this.CSCROLLRECT.visible = false;
						}
						if(this.FSB) {
								this.FSB.visible = false;
						}
						if(this.DSB) {
								this.DSB.visible = false;
						}
						if(this.CSB) {
								this.CSB.visible = false;
						}
						if(this.NOSCORE) {
								this.NOSCORE.FIELD.text = "";
						}
				}
				
				public function SetActiveType(anum:*) : void {
						this.currenttype = anum;
						if(this.FITEMS) {
								this.FITEMS.UnSet();
						}
						if(this.DITEMS) {
								this.DITEMS.UnSet();
						}
						if(this.CITEMS) {
								this.CITEMS.UnSet();
						}
						gotoAndStop(this.currenttype);
						if(this.currenttype <= 3) {
								this.DrawWindow();
						} else if(this.currenttype == 4) {
								this.HideWeeklyElements();
								if(this.weeklydatas == null) {
										this.LoadWeeklyChallange();
								} else {
										this.DrawWeeklyChallenge();
								}
						} else if(this.currenttype == 5) {
						}
				}
				
				public function DrawWindow() : void {
						this.INVITE.SetIcon("PIPE");
						Lang.Set(this.C_INVITE.FIELD,"invite_help_country");
						Lang.Set(this.C_FRIENDS.FIELD,"friends2");
						if(this.C_PERSONAL) {
								Lang.Set(this.C_PERSONAL.FIELD,"personal_ranklist_short");
						}
						if(this.C_ACTLEAGUE) {
								this.C_ACTLEAGUE.FIELD.text = "-";
						}
						if(this.CROWN) {
								Imitation.GotoFrame(this.CROWN,8);
						}
						Lang.Set(this.C_COUNTRIES.FIELD,"countries");
						this.C_INVITE.visible = false;
						this.C_INVITE_BG.visible = false;
						this.INVITE.visible = false;
						if(String("|MMIR|KONG|NKLA|").indexOf(Config.loginsystem) >= 0 && !Config.mobile) {
								this.C_INVITE.visible = true;
								this.INVITE.visible = true;
								this.C_INVITE_BG.visible = true;
						}
						if(String("|FACE|").indexOf(Config.loginsystem) >= 0) {
								this.C_INVITE.visible = true;
								this.INVITE.visible = true;
								this.C_INVITE_BG.visible = true;
						}
						this.Clear();
						if(this.datas[this.currenttype]) {
								this.ShowAllLines();
						} else {
								this.GetRanklists();
						}
				}
				
				public function GetRanklists() : void {
						var f:Object = null;
						if(Comm.connstate < 5) {
								return;
						}
						this.datas[this.currenttype] = {
								"personal":{},
								"countries":{},
								"friends":{},
								"division":{}
						};
						this.linesdata[this.currenttype] = {
								"personal":[],
								"countries":[],
								"friends":[],
								"division":[]
						};
						if(this.initialized) {
								WinMgr.ShowLoadWait();
						}
						var isallstr:String = this.currenttype == 2 ? "1" : "0";
						var isprevstr:String = this.currenttype == 3 ? "1" : "0";
						var types:* = "";
						if(this.currenttype == 2) {
								types = "personal,friends,countries";
						} else {
								types = "division,friends,countries";
						}
						var fla:Array = new Array();
						for(var i:int = 0; i < Friends.all.length; i++) {
								f = Friends.all[i];
								if(Util.NumberVal(f.flag) == 1) {
										if(fla.indexOf(f.id) < 0) {
												fla.push(f.id);
										}
								}
						}
						var fls:String = fla.join(",");
						var uri:* = Comm.httpuri + "/rlquery?types=" + types + "&all=" + isallstr + "&prev=" + isprevstr + "&userid=" + Sys.mydata.id + "&from=-1&countryid=" + Sys.mydata.country;
						MyLoader.PostData(fls,uri,this.ProcessRLData,this);
				}
				
				public function ProcessRLData(adata:String) : void {
						var data:Object;
						var rdata:Object;
						var miss:Boolean;
						var tags:*;
						var n:* = undefined;
						var tagname:String = null;
						var lines:* = this.linesdata[this.currenttype];
						var xml:XML = null;
						try {
								xml = new XML("<?xml version=\"1.0\" encoding=\"utf-8\"?><ROOT>" + adata + "</ROOT>");
						}
						catch(err:Error) {
								WinMgr.HideLoadWait();
								return;
						}
						data = Util.XMLTagToObject(xml);
						rdata = data.RANKLISTS;
						miss = false;
						tags = {
								"friends":"FRIENDS",
								"division":"DIVISION",
								"personal":"ALLPERSONALRL",
								"countries":"COUNTRIES"
						};
						for(n in this.datas[this.currenttype]) {
								tagname = tags[n];
								if(rdata[tagname]) {
										this.datas[this.currenttype][n] = rdata[tagname];
										if(rdata[tagname].LINE) {
												lines[n] = rdata[tagname].LINE;
												if(!lines[n].length) {
														lines[n] = [lines[n]];
												}
										} else {
												lines[n] = [];
										}
								} else {
										this.datas[this.currenttype][n] = {};
										lines[n] = [];
								}
						}
						this.LEGO_DAILY_RESET_BIG.rlresetremaining = Util.NumberVal(rdata.RLRESET);
						this.LEGO_DAILY_RESET_BIG.rlresettimeref = getTimer();
						this.LEGO_DAILY_RESET_BIG.Start();
						LoadShieldsData();
				}
				
				public function LoadExdatas() : void {
						var k:* = undefined;
						var i:int = 0;
						var u:* = undefined;
						var lines:* = this.linesdata[this.currenttype];
						var miss:Boolean = false;
						for(k in lines) {
								for(i = 0; i < lines[k].length; i++) {
										u = Extdata.GetUserData(Util.StringVal(lines[k][i].UID));
										if(u == null) {
												miss = true;
										}
								}
						}
						if(miss) {
								Extdata.GetSheduledData(this.LoadExdatas);
						} else {
								this.ShowAllLines();
								if(this.initialized) {
										WinMgr.HideLoadWait();
								} else {
										TweenMax.delayedCall(0,WinMgr.WindowDataArrived,[mc]);
								}
								this.initialized = true;
								Friends.LoadInvitableFriends(this.DataReady);
						}
				}
				
				public function ShowAllLines() : void {
						var lines:*;
						var b:Boolean;
						var fla:Array = null;
						var need:Boolean = false;
						var i:int = 0;
						var j:int = 0;
						if(this.linesdata[this.currenttype] == null || this.linesdata[this.currenttype] == undefined) {
								this.Clear();
								return;
						}
						lines = this.linesdata[this.currenttype];
						b = false;
						if(Boolean(lines.friends.length) && Boolean(this.FITEMS)) {
								this.FITEMS.visible = true;
								this.FSCROLLRECT.visible = true;
								lines.friends.sort(function(a:*, b:*):* {
										return Util.NumberVal(b.XP) - Util.NumberVal(a.XP);
								});
								fla = new Array();
								need = true;
								fla.push(lines.friends[0]);
								for(i = 0; i < lines.friends.length; i++) {
										need = true;
										for(j = 0; j < fla.length; j++) {
												if(fla[j].UID == lines.friends[i].UID) {
														need = false;
														break;
												}
										}
										if(need) {
												fla.push(lines.friends[i]);
										}
								}
								lines.friends = fla;
								this.FITEMS.no_events = true;
								this.FITEMS.Set("FLINE",lines.friends,40,1,null,this.DrawFriendsLine,this.FSCROLLRECT,this.FSB);
								this.ScrollMe(this.FSB,lines.friends);
								b = true;
						}
						if(Boolean(lines.division.length) && Boolean(this.DITEMS)) {
								this.DITEMS.visible = true;
								this.DSCROLLRECT.visible = true;
								this.DITEMS.no_events = true;
								this.DITEMS.Set("DLINE",lines.division,40,1,null,this.DrawDivisionLine,this.DSCROLLRECT,this.DSB);
								this.ScrollMe(this.DSB,lines.division);
								b = true;
						}
						if(Boolean(lines.personal.length) && Boolean(this.PITEMS)) {
								this.PITEMS.visible = true;
								this.DrawPersonalLines();
								b = true;
						}
						if(Boolean(lines.countries.length) && Boolean(this.CITEMS)) {
								this.CITEMS.visible = true;
								this.CSCROLLRECT.visible = true;
								this.CITEMS.no_events = true;
								this.CITEMS.Set("CLINE",lines.countries,40,1,null,this.DrawCountryLine,this.CSCROLLRECT,this.CSB);
								this.ScrollMyCountry();
								b = true;
						}
						if(lines.friends.length == 0) {
								if(!b) {
										Lang.Set(this.NOSCORE.FIELD,"no_score_today");
								}
						}
				}
				
				public function ScrollMe(sb:MovieClip, list:Array) : void {
						var n:* = undefined;
						var idx:* = 0;
						for(n in list) {
								if(list[n].UID == Sys.mydata.id) {
										idx = n;
										break;
								}
						}
						sb.ScrollTo(idx - 2,0);
				}
				
				public function ScrollMyCountry() : void {
						var n:* = undefined;
						var lines:* = this.linesdata[this.currenttype];
						var idx:* = 0;
						for(n in lines.countries) {
								if(lines.countries[n].C == Sys.mydata.country) {
										idx = n;
										break;
								}
						}
						this.CSB.ScrollTo(idx - 2,0);
				}
				
				public function DrawFriendsLine(lm:*, id:*) : void {
						var lines:Object;
						var tag:*;
						var ln:int;
						var u:Object = null;
						if(this.linesdata[this.currenttype] == null || this.linesdata[this.currenttype] == undefined) {
								this.Clear();
								return;
						}
						lines = this.linesdata[this.currenttype];
						tag = lines.friends[id];
						ln = id + 1;
						lm.gotoAndStop(1);
						Imitation.CollectChildrenAll(lm);
						if(tag !== undefined) {
								lm.POSITION.FIELD.text = ln + ".";
								u = Extdata.GetUserData(Util.StringVal(tag.UID));
								if(u && u.name != null && u.name.length > 0) {
										Util.SetText(lm.NAMEE.FIELD,Romanization.ToLatin(u.name));
										if(windowopened) {
												lm.AVATAR.ShowUID(u.id);
										} else {
												lm.AVATAR.Clear();
										}
										lm.FLAG.Set(tag.C);
								} else {
										Util.SetText(lm.NAMEE.FIELD,"");
										lm.AVATAR.Clear();
										lm.FLAG.Clear();
								}
								lm.XPCHANGE.FIELD.text = Util.FormatNumber(tag.XP);
								lm.HILITE.visible = tag.UID == Sys.mydata.id;
								lm.visible = true;
								DrawShield(lm.SHIELD,shields_data[tag.UID]);
						} else if(this.extendedfriendist.length > 0 && this.extendedfriendist[id] !== undefined) {
								lm.HILITE.visible = false;
								lm.visible = true;
								lm.gotoAndStop(2);
								Util.SetText(lm.NAMEE.FIELD,Romanization.ToLatin(this.extendedfriendist[id].name));
								lm.AVATAR.ShowExternal(this.extendedfriendist[id].invite_token,this.extendedfriendist[id].avatar);
								Imitation.AddEventClick(lm,function():* {
										var list:Array = [];
										list.push(extendedfriendist[id].invite_token);
										if(Config.mobile) {
												Platform.FacebookInvite(list.join(),Lang.Get("invite_new_user"),Lang.Get("invite_message"),null);
												return;
										}
										Util.ExternalCall("InviteFriends",list);
								});
								DrawShield(lm.SHIELD,undefined);
						} else {
								lm.visible = false;
								lm.AVATAR.Clear();
								Util.StopAllChildrenMov(lm);
						}
						Imitation.FreeBitmapAll(lm);
						Imitation.UpdateAll(lm);
				}
				
				public function DrawCountryLine(lm:*, id:*) : void {
						var cid:String = null;
						if(this.linesdata[this.currenttype] == null || this.linesdata[this.currenttype] == undefined) {
								this.Clear();
								return;
						}
						var lines:* = this.linesdata[this.currenttype];
						var ln:int = id + 1;
						var tag:* = lines.countries[id];
						if(tag !== undefined) {
								lm.POSITION.FIELD.text = ln + ".";
								lm.FLAG.Set(tag.C);
								cid = tag.C;
								if(cid != "a1" && cid != "a2" && cid != "eu" && cid != "--") {
										Util.SetText(lm.COUNTRYNAME.FIELD,Extdata.CountryName(tag.C));
								} else {
										lm.FLAG.Set("--");
										Lang.Set(lm.COUNTRYNAME.FIELD,"unknown");
								}
								Imitation.UpdateAll(lm.FLAG);
								lm.XPCHANGE.FIELD.text = Util.FormatNumber(tag.XP);
								lm.HILITE.visible = tag.C == Sys.mydata.country;
								lm.visible = true;
						} else {
								lm.visible = false;
						}
				}
				
				public function DrawDivisionLine(lm:*, id:*) : void {
						if(this.linesdata[this.currenttype] == null || this.linesdata[this.currenttype] == undefined) {
								this.Clear();
								return;
						}
						var lines:* = this.linesdata[this.currenttype];
						var tag:Object = this.datas[this.currenttype].division;
						var u:Object = null;
						var p:Object = null;
						var league:int = Util.NumberVal(tag.L);
						if(this.C_ACTLEAGUE) {
								Util.SetText(this.C_ACTLEAGUE.FIELD,league + ". " + Lang.Get("league_name_" + league));
						}
						if(this.CROWN) {
								Imitation.GotoFrame(this.CROWN,league);
						}
						var upcount:* = Util.NumberVal(tag.UP);
						var downcount:* = Util.NumberVal(tag.DOWN);
						var ln:int = id + 1;
						p = lines.division[id];
						if(Boolean(p) && lm) {
								lm.visible = true;
								lm.HILITE.visible = Util.NumberVal(p.UID) == Sys.mydata.id;
								if(ln <= upcount) {
										lm.gotoAndStop(2);
								} else if(ln > lines.division.length - downcount) {
										lm.gotoAndStop(3);
								} else {
										lm.gotoAndStop(1);
								}
								u = Extdata.GetUserData(Util.StringVal(p.UID));
								if(u) {
										Util.SetText(lm.NAMEE.FIELD,Romanization.ToLatin(Util.StringVal(u.name)));
										if(windowopened) {
												lm.AVATAR.ShowUID(u.id,Imitation.Update,[lm.AVATAR]);
										} else {
												lm.AVATAR.Clear();
										}
										lm.FLAG.Set(p.C);
								} else {
										lm.AVATAR.Clear();
										lm.FLAG.Clear();
								}
								Util.SetText(lm.POSITION.FIELD,String(ln));
								Util.SetText(lm.XPCHANGE.FIELD,Util.StringVal(Util.FormatNumber(p.XP)) + " " + Lang.Get("xp"));
								DrawShield(lm.SHIELD,shields_data[p.UID]);
								Imitation.FreeBitmapAll(lm);
								Imitation.UpdateAll(lm);
						} else {
								lm.visible = false;
								lm.AVATAR.ShowUID(-1);
						}
				}
				
				public function DrawPersonalLines() : void {
						var mline:MovieClip = null;
						var dline:Object = null;
						var u:Object = null;
						if(this.linesdata[this.currenttype] == null || this.linesdata[this.currenttype] == undefined) {
								this.Clear();
								return;
						}
						var lines:* = this.linesdata[this.currenttype];
						if(lines.personal.length == 0) {
								return;
						}
						var rlrows:int = Util.NumberVal(this.datas[this.currenttype].personal.TOTAL);
						var ln:int = Util.NumberVal(this.datas[this.currenttype].personal.FROM);
						var pp:Number = 0;
						for(var i:int = 0; i < this.listlength; i++) {
								mline = this.PITEMS["PLINE" + (i + 1)];
								dline = lines.personal[i];
								if(dline) {
										mline.gotoAndStop(1);
										u = Extdata.GetUserData(dline.UID);
										mline.HILITE.visible = !!dline ? Util.NumberVal(dline.UID) == Sys.mydata.id : false;
										if(Boolean(u) && u.name.length > 0) {
												Util.SetText(mline.NAMEE.FIELD,Romanization.ToLatin(u.name));
												if(windowopened) {
														mline.AVATAR.ShowUID(u.id,Imitation.Update,[mline.AVATAR]);
												} else {
														mline.AVATAR.Clear();
												}
												mline.XPCHANGE.FIELD.text = Util.FormatNumber(dline.XP);
												mline.FLAG.Set(dline.C);
										} else {
												Util.SetText(mline.NAMEE.FIELD,"");
												mline.AVATAR.Clear();
												mline.XPCHANGE.FIELD.text = "";
												mline.FLAG.Clear();
										}
										if(ln >= 100) {
												pp = Math.floor(100 * ln / rlrows);
												if(pp < 1) {
														pp = 1;
												}
										}
										mline.POSITION.FIELD.text = ln >= 100 ? pp + "%" : ln + ".";
										ln++;
										DrawShield(mline.SHIELD,shields_data[dline.UID]);
										Imitation.FreeBitmapAll(mline);
										Imitation.UpdateAll(mline);
								} else {
										mline.visible = false;
								}
						}
				}
				
				public function OnCallWeeklyData(e:*) : void {
						WinMgr.ShowLoadWait();
						JsQuery.Load(ShowWeeklyChallange,[],"client_weekly.php?" + Sys.FormatGetParamsStoc({},true),{"cmd":"list"});
				}
				
				public function DataReady(e:* = null) : void {
						var lines:* = this.linesdata[this.currenttype];
						this.extendedfriendist = lines.friends.concat(Friends.invitable);
						if(this.FITEMS) {
								this.FITEMS.Draw();
						}
				}
				
				private function LoadWeeklyChallange() : void {
						WinMgr.ShowLoadWait();
						JsQuery.Load(this.OnLoadWeeklyChallange,[],"client_weekly.php?" + Sys.FormatGetParamsStoc({},true),{"cmd":"list"});
				}
				
				public function OnLoadWeeklyChallange(_jsq:Object) : void {
						WinMgr.HideLoadWait();
						if(_jsq.error > 0) {
								return;
						}
						this.weeklydatas = _jsq.data;
						this.LoadExdataForWeekly();
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
				
				public function LoadExdataForWeekly() : * {
						var u:Object = null;
						var miss:Boolean = false;
						var top:Array = this.weeklydatas.users;
						for(var i:int = 0; i < top.length; i++) {
								u = Extdata.GetUserData(Util.StringVal(top[i].userid));
								if(u == null) {
										miss = true;
								}
						}
						if(miss) {
								Extdata.GetSheduledData(this.LoadExdataForWeekly);
						} else {
								this.DrawWeeklyChallenge();
						}
				}
				
				public function DrawWeeklyChallenge() : void {
						var n:uint = 0;
						var infotext:* = null;
						var cinfotext:* = null;
						var top:* = this.weeklydatas.users;
						if(top.length < 5) {
								this.TITLE.visible = true;
								Util.SetText(this.TITLE.FIELD,Lang.Get("coming_soon"));
								this.PLAYER.visible = false;
								this.COUNTRY.visible = false;
								for(n = 1; n <= 5; n++) {
										this["P" + n].visible = false;
										this["CP" + n].visible = false;
								}
								this.WEEKLY_P_INFO.visible = false;
								this.WEEKLY_C_INFO.visible = false;
								return;
						}
						var tag:Object = null;
						var lm:MovieClip = null;
						var mydata:Object = this.weeklydatas.positions;
						this.TITLE.visible = true;
						this.PLAYER.visible = true;
						this.COUNTRY.visible = true;
						Util.SetText(this.TITLE.FIELD,Lang.Get("the_league_of_triviadors"));
						Util.SetText(this.PLAYER.FIELD,Lang.Get("personal_ranklist_short"));
						Util.SetText(this.COUNTRY.FIELD,Lang.Get("country"));
						this.WEEKLY_P_INFO.visible = false;
						for(var j:uint = 1; j <= 5; j++) {
								tag = top[j - 1];
								lm = this["P" + j];
								if(tag) {
										lm.visible = true;
										lm.AVATAR.visible = true;
										lm.FLAG.visible = false;
										lm.CFLAG.visible = false;
										lm.CNAME.visible = false;
										lm.NAME.visible = true;
										lm.COUNT.text = j;
										Util.SetText(lm.NAME.FIELD,Romanization.ToLatin(Util.Trim(Util.StringVal(tag.name))));
										if(j == 1) {
												if(lm.NAME.FIELD.numLines == 1) {
														lm.NAME.FIELD.y = 30;
												}
										}
										lm.FRAME.visible = false;
										lm.AVATAR.Clear();
										Util.SetText(lm.XP.FIELD,String(Util.FormatNumber(Util.NumberVal(tag.totalxp)) + " " + Lang.Get("xp")));
								} else {
										lm.visible = false;
								}
						}
						if(windowopened) {
								this.DrawWeeklyAvatars();
						}
						if(!mydata.users) {
								Lang.Set(this.WEEKLY_P_INFO.INFO.FIELD,"lets_play");
						} else if(Number(mydata.users.rownum) < 4) {
								Lang.Set(this.WEEKLY_P_INFO.INFO.FIELD,"congratulations");
						} else {
								infotext = Lang.Get("your_place+: ");
								infotext += Util.FormatNumber(Util.NumberVal(mydata.users.rownum));
								infotext += "\n";
								infotext += Lang.Get("your_xp+: ");
								infotext += Util.FormatNumber(Util.NumberVal(mydata.users.totalxp));
								Util.SetText(this.WEEKLY_P_INFO.INFO.FIELD,infotext);
						}
						if(this.WEEKLY_P_INFO.INFO.FIELD.numLines == 1) {
								this.WEEKLY_P_INFO.INFO.FIELD.y = 20;
						}
						if(this.WEEKLY_P_INFO.INFO.FIELD.numLines == 2) {
								this.WEEKLY_P_INFO.INFO.FIELD.y = 10;
						}
						top = this.weeklydatas.countries;
						this.WEEKLY_C_INFO.visible = true;
						for(j = 1; j <= 5; j++) {
								tag = top[j - 1];
								lm = this["CP" + j];
								if(tag) {
										lm.visible = true;
										lm.FRAME.visible = true;
										lm.AVATAR.visible = false;
										lm.FLAG.visible = false;
										lm.CFLAG.visible = true;
										lm.CNAME.visible = false;
										lm.NAME.visible = true;
										lm.COUNT.text = j;
										Util.SetText(lm.NAME.FIELD,Romanization.ToLatin(Util.Trim(Util.StringVal(tag.name))));
										if(j == 1) {
												if(lm.NAME.FIELD.numLines == 1) {
														lm.NAME.FIELD.y = 30;
												}
										}
										Util.SetText(lm.XP.FIELD,String(Util.FormatNumber(Util.NumberVal(tag.totalxp)) + " " + Lang.Get("xp")));
										lm.CFLAG.Set(tag.countryid);
								} else {
										lm.visible = false;
								}
						}
						if(!mydata.countries) {
								Lang.Set(this.WEEKLY_C_INFO.INFO.FIELD,"lets_country");
						} else if(Number(mydata.countries.rownum) < 4) {
								Lang.Set(this.WEEKLY_C_INFO.INFO.FIELD,"congratulations");
						} else {
								cinfotext = Lang.Get("your_place+: ");
								cinfotext += Util.FormatNumber(Util.NumberVal(mydata.countries.rownum));
								cinfotext += "\n";
								cinfotext += Lang.Get("your_country+: ");
								cinfotext += Util.FormatNumber(Util.NumberVal(mydata.countries.totalxp));
								cinfotext += " " + Lang.Get("xp");
								Util.SetText(this.WEEKLY_C_INFO.INFO.FIELD,cinfotext);
						}
						if(this.WEEKLY_C_INFO.INFO.FIELD.numLines == 1) {
								this.WEEKLY_C_INFO.INFO.FIELD.y = 20;
						}
						if(this.WEEKLY_C_INFO.INFO.FIELD.numLines == 2) {
								this.WEEKLY_C_INFO.INFO.FIELD.y = 10;
						}
						this.SendSeenCmd();
				}
				
				public function DrawWeeklyAvatars() : void {
						var top:Array = null;
						var tag:Object = null;
						var lm:MovieClip = null;
						top = this.weeklydatas.users;
						for(var j:uint = 1; j <= 5; j++) {
								tag = top[j - 1];
								lm = this["P" + j];
								if(tag) {
										lm.AVATAR.ShowUID(tag.userid);
										lm.AVATAR.ShowFrame(tag.xplevel,tag.actleague);
								}
						}
				}
				
				private function HideWeeklyElements() : void {
						var p:* = undefined;
						var cp:* = undefined;
						this.TITLE.visible = false;
						this.PLAYER.visible = false;
						this.COUNTRY.visible = false;
						this.WEEKLY_P_INFO.visible = false;
						this.WEEKLY_C_INFO.visible = false;
						for(var i:int = 1; i <= 5; i++) {
								p = this["P" + i];
								cp = this["CP" + i];
								p.visible = false;
								cp.visible = false;
						}
				}
				
				public function SendSeenCmd() : void {
						if(Ranklist.wassent_seen) {
								return;
						}
						JsQuery.Load(CheckAutoCalling,[],"client_weekly.php?" + Sys.FormatGetParamsStoc({},true),{"cmd":"seen"});
						Ranklist.wassent_seen = true;
				}
		}
}

