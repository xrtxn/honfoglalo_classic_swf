package clan {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import flash.display.SimpleButton;
		import flash.events.Event;
		import flash.text.TextField;
		import flash.text.TextFieldType;
		import syscode.*;
		import uibase.lego_button_3x1_ok;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol562")]
		public class Settings extends MovieClip {
				public static const MAX_NAME_LENGTH:uint = 24;
				
				public static const MAX_INTRO_LENGTH:uint = 750;
				
				public static const INVITE_ONLY:uint = 0;
				
				public static const PRIVATE:uint = 1;
				
				public static const PUBLIC:uint = 2;
				
				public static const ALL_TYPE:uint = 3;
				
				public static const NONE:int = 4;
				
				public static var active:Boolean = false;
				
				public static var createclan:Boolean = false;
				
				public static var parentpagenumber:uint = Clan.SETTINGS_PAGE_NUMBER;
				
				private static var currentname:String = "";
				
				private static var currentintro:String = "";
				
				private static var currentcond:uint = 0;
				
				private static var currentadmission:uint = 2;
				
				private static var currentcondminlevel:uint = 0;
				
				private static var currentcondminleague:uint = 0;
				
				public var BOX_NAME:background_shape_6x1;
				
				public var BTN_LEAGUE:SimpleButton;
				
				public var BTN_SAVE:lego_button_3x1_ok;
				
				public var CONDITIONS:MovieClip;
				
				public var GRAPHICS:MovieClip;
				
				public var MC_DYNAMICINTRO:MovieClip;
				
				public var MC_INPUTINTRO:MovieClip;
				
				public var MC_INPUTNAME:MovieClip;
				
				public var RB_INVITE:RadioButton;
				
				public var RB_JOIN:RadioButton;
				
				public var RB_WAITING:RadioButton;
				
				public var SELECTOR_LEAGUE:MovieClip;
				
				public var TXT_ADDMISSON_INFO:MovieClip;
				
				public var TXT_CLAN_NAME_RULES:MovieClip;
				
				public var TXT_INFO_NAME:MovieClip;
				
				public var TXT_INTRO_COUNTER:MovieClip;
				
				public var TXT_NAME:MovieClip;
				
				public var TXT_NAME_COUNTER:MovieClip;
				
				public function Settings() {
						super();
				}
				
				public function Show() : void {
						var myadminright:* = Util.NumberVal(Clan.myclanproperties.alliance.adminright) > 0;
						Util.StopAllChildrenMov(this);
						this.visible = true;
						Settings.active = true;
						this.SetCurrentAdmissionProperties();
						this.Draw();
						if(Clan.namechange) {
								Clan.ShowErrorPanel(Lang.Get("clan_name_change"),null,false);
						} else if(Clan.blocked && myadminright) {
								Clan.ShowErrorPanel(Lang.Get("clan_rename_popup"),null,false);
						}
						Clan.ArriveData();
				}
				
				public function CallAfterOpenEvents() : void {
						var myadminright:* = false;
						if(Boolean(Clan.mc) && Settings.active) {
								this.InActivateInputIntro();
								myadminright = Util.NumberVal(Clan.myclanproperties.alliance.adminright) > 0;
								if(Clan.blocked && !Clan.namechange) {
										this.OnHiglightName(false);
								}
								if(Clan.blocked && !myadminright || Clan.namechange) {
										this.InActivateInputName();
								}
						}
				}
				
				private function SetCurrentAdmissionProperties() : void {
						var p:Object = Clan.myclanproperties.alliance;
						if(p) {
								Settings.currentname = Util.StringVal(p.name);
								Settings.currentintro = Util.StringVal(p.intro);
								Settings.currentcond = Util.NumberVal(p.cond);
								Settings.currentadmission = Util.NumberVal(p.admission);
								Settings.currentcondminlevel = Util.NumberVal(p.cond_minxplevel);
								Settings.currentcondminleague = Util.NumberVal(p.cond_minleague);
						}
				}
				
				public function Draw() : void {
						Imitation.CollectChildrenAll(this);
						this.HideLeagueSelector(null,false);
						this.DrawHeader();
						this.DrawRoster();
						this.DrawStoryOfTheClan();
						this.GRAPHICS.cacheAsBitmap = true;
						this.Activate();
				}
				
				private function DrawHeader() : void {
						var nextlevelxp:Number = NaN;
						var w:MovieClip = this.GRAPHICS;
						var p:Object = Clan.myclanproperties;
						var myadminright:* = Util.NumberVal(p.alliance.adminright) > 0;
						var activenamebox:Boolean = Settings.createclan || myadminright && Clan.blocked && !Clan.namechange;
						if(p) {
								nextlevelxp = Util.NumberVal(p.alliance.nextlevelxp) == -1 ? Util.NumberVal(p.alliance.xppoints) : Util.NumberVal(p.alliance.nextlevelxp);
								Lang.Set(this.TXT_INFO_NAME.FIELD,"clan_input_info");
								Lang.Set(this.TXT_CLAN_NAME_RULES.FIELD,"clan_name_rules");
								Util.SetText(this.TXT_NAME_COUNTER.FIELD,"(" + int(Settings.MAX_NAME_LENGTH - Settings.currentname.length) + ")");
								if(activenamebox) {
										this.HideDynamicName();
										this.DrawInputName();
										this.ActivateInputName();
								} else {
										this.HideInputName();
										this.DrawDynamicName();
										this.InActivateInputName();
								}
						}
				}
				
				private function DrawRoster() : void {
						var w:MovieClip = this.GRAPHICS.ROSTER;
						var p:Object = Clan.myclanproperties.alliance;
						var myadminright:* = Util.NumberVal(p.adminright) > 0;
						var warning:Boolean = Clan.blocked || Clan.namechange;
						var admission:uint = Settings.currentadmission;
						Imitation.GotoFrame(w,myadminright && !warning ? 1 : 3);
						Lang.Set(w.TXT_JOIN_TYPE.FIELD,"clan_settings");
						this.RB_INVITE.alpha = this.RB_WAITING.alpha = this.RB_JOIN.alpha = myadminright && !warning ? 1 : 0.5;
						this.RB_INVITE.CHECK.visible = admission == Settings.INVITE_ONLY;
						this.RB_WAITING.CHECK.visible = admission == Settings.PRIVATE;
						this.RB_JOIN.CHECK.visible = admission == Settings.PUBLIC;
						if(Settings.createclan || myadminright) {
								this.BTN_SAVE.visible = true;
								this.BTN_SAVE.SetCaption(Settings.createclan ? Lang.Get("found") : Lang.Get(!Clan.namechange ? "save" : "okay"));
						} else {
								this.BTN_SAVE.visible = false;
						}
						this.DrawConditions(admission);
				}
				
				private function DrawConditions(_admission:uint) : void {
						var w:MovieClip = this.CONDITIONS;
						var panel:MovieClip = this.CONDITIONS.PANEL;
						var p:Object = Clan.myclanproperties.alliance;
						var activecond:* = Settings.currentcond == 1;
						var warning:Boolean = Clan.blocked || Clan.namechange;
						var myadminright:* = Util.NumberVal(p.adminright) > 0;
						var league:String = Util.StringVal(Settings.currentcondminleague);
						Util.SetText(panel.TXT_CLEVEL.FIELD,Lang.Get("min_level") + ":");
						Util.SetText(panel.TXT_LEAGUE.FIELD,Lang.Get("min_league") + ":");
						Util.SetText(panel.INPUT_LEVEL.FIELD,"");
						Lang.Set(w.TXT_SET_COND.FIELD,"set_cond");
						Util.SetText(panel.TXT_LEVEL2.FIELD,"999");
						Lang.Set(this.TXT_ADDMISSON_INFO.FIELD,"admission_info_" + Settings.currentadmission);
						Imitation.RemoveEvents(this.BTN_LEAGUE);
						if(_admission == Settings.INVITE_ONLY && !warning) {
								w.CB_COND.CHECK.visible = false;
								panel.TXT_CLEAGUE.visible = false;
								this.HideInputConditionPanel();
								this.DrawDynamicConditionPanel(false);
								this.InActivateInputConditions();
								this.InActivateLeagueSelector();
								this.InActivateConditions();
								w.alpha = 0.5;
								panel.alpha = 1;
						} else if(myadminright && activecond && !warning) {
								w.CB_COND.CHECK.visible = true;
								panel.TXT_CLEAGUE.visible = true;
								Util.SetText(panel.TXT_CLEAGUE.FIELD,league + ". " + Lang.Get("league_name_" + league));
								this.HideDynamicConditionPanel();
								this.DrawInputConditionPanel();
								this.ActivateInputConditions();
								this.ActivateLeagueSelector();
								this.ActivateConditions();
								w.alpha = 1;
								panel.alpha = 1;
						} else if(myadminright && !activecond && !warning) {
								w.CB_COND.CHECK.visible = false;
								panel.TXT_CLEAGUE.visible = false;
								this.HideInputConditionPanel();
								this.DrawDynamicConditionPanel(false);
								this.InActivateInputConditions();
								this.InActivateLeagueSelector();
								this.ActivateConditions();
								w.alpha = 1;
								panel.alpha = 0.5;
						} else if(activecond && !warning) {
								w.CB_COND.CHECK.visible = true;
								panel.TXT_CLEAGUE.visible = true;
								Util.SetText(panel.TXT_CLEAGUE.FIELD,league + ". " + Lang.Get("league_name_" + league));
								this.HideInputConditionPanel();
								this.DrawDynamicConditionPanel(true);
								this.InActivateInputConditions();
								this.InActivateLeagueSelector();
								this.InActivateConditions();
								w.alpha = 0.5;
								panel.alpha = 1;
						} else {
								w.CB_COND.CHECK.visible = false;
								panel.TXT_CLEAGUE.visible = false;
								this.HideInputConditionPanel();
								this.DrawDynamicConditionPanel(false);
								this.InActivateInputConditions();
								this.InActivateLeagueSelector();
								this.InActivateConditions();
								w.alpha = 0.5;
								panel.alpha = 1;
						}
				}
				
				private function DrawStoryOfTheClan() : void {
						var warning:Boolean = Clan.blocked || Clan.namechange;
						Lang.Set(this.GRAPHICS.TXT_INFO_TITLE.FIELD,"story_of_the_clan");
						var activeintro:Boolean = Util.NumberVal(Clan.myclanproperties.alliance.adminright) > 0 && !warning;
						if(activeintro) {
								this.HideDynamicStoryOfTheClan();
								this.DrawInputStoryOfTheClan();
								this.ActivateInputIntro();
						} else {
								this.HideInputStoryOfTheClan();
								this.DrawDynamicStoryOfTheClan();
						}
				}
				
				private function DrawInputName() : void {
						var w:MovieClip = null;
						w = this.MC_INPUTNAME;
						var p:Object = Clan.myclanproperties;
						Util.SetText(w.INPUT.FIELD,Settings.currentname);
						w.INPUT.FIELD.type = TextFieldType.INPUT;
						w.INPUT.FIELD.maxChars = Settings.MAX_NAME_LENGTH;
						w.INPUT.FIELD.restrict = Config.GetNameRestrictChars();
						TweenMax.delayedCall(0,function():* {
								Util.RTLEditSetup(w.INPUT.FIELD);
						});
						this.TXT_INFO_NAME.visible = Settings.currentname.length == 0;
						this.MC_INPUTNAME.visible = this.TXT_NAME_COUNTER.visible = this.BOX_NAME.visible = true;
				}
				
				private function HideInputName() : void {
						this.MC_INPUTNAME.visible = this.TXT_INFO_NAME.visible = this.TXT_NAME_COUNTER.visible = this.BOX_NAME.visible = false;
				}
				
				private function DrawDynamicName() : void {
						var p:Object = Clan.myclanproperties;
						Util.SetText(this.TXT_NAME.FIELD,Settings.currentname);
						this.TXT_NAME.visible = true;
				}
				
				private function HideDynamicName() : void {
						this.TXT_NAME.visible = false;
				}
				
				private function DrawInputConditionPanel() : void {
						var w:MovieClip = this.CONDITIONS;
						var panel:MovieClip = this.CONDITIONS.PANEL;
						var p:Object = Clan.myclanproperties.alliance;
						Util.SetText(panel.INPUT_LEVEL.FIELD,Util.StringVal(Settings.currentcondminlevel));
						panel.INPUT_LEVEL.visible = true;
						panel.INPUT_LEVEL.FIELD.type = TextFieldType.INPUT;
						panel.INPUT_LEVEL.FIELD.maxChars = 3;
						panel.INPUT_LEVEL.FIELD.restrict = "0123456789";
						Util.RTLEditSetup(panel.INPUT_LEVEL.FIELD);
				}
				
				private function HideInputConditionPanel() : void {
						var w:MovieClip = this.CONDITIONS;
						var panel:MovieClip = this.CONDITIONS.PANEL;
				}
				
				private function DrawDynamicConditionPanel(_visible:Boolean = false) : void {
						var w:MovieClip = this.CONDITIONS;
						var panel:MovieClip = this.CONDITIONS.PANEL;
						var p:Object = Clan.myclanproperties.alliance;
						Util.SetText(panel.TXT_LEVEL.FIELD,Util.StringVal(Settings.currentcondminlevel));
						Util.SetText(panel.TXT_LEVEL2.FIELD,"999");
						panel.TXT_LEVEL.visible = _visible;
				}
				
				private function HideDynamicConditionPanel() : void {
						var w:MovieClip = this.CONDITIONS;
						var panel:MovieClip = this.CONDITIONS.PANEL;
						panel.TXT_LEVEL.visible = false;
				}
				
				private function DrawInputStoryOfTheClan() : void {
						var p:Object = Clan.myclanproperties.alliance;
						var w:MovieClip = this.MC_INPUTINTRO;
						w.visible = this.TXT_INTRO_COUNTER.visible = true;
						Util.SetText(w.INPUT.FIELD,Settings.currentintro);
						Util.SetText(this.TXT_INTRO_COUNTER.FIELD,"(" + int(Settings.MAX_INTRO_LENGTH - w.INPUT.FIELD.text.length) + ")");
						w.INPUT.FIELD.type = TextFieldType.INPUT;
						w.INPUT.FIELD.maxChars = Settings.MAX_INTRO_LENGTH;
						w.INPUT.FIELD.restrict = Config.GetChatRestrictChars();
						Util.RTLEditSetup(w.INPUT.FIELD);
						this.ShowInputIntroScrollBar();
						w.SB_INFO.buttonstep = 25;
						w.SB_INFO.OnScroll = this.OnInputIntroScrolling;
				}
				
				private function HideInputStoryOfTheClan() : void {
						this.MC_INPUTINTRO.visible = this.TXT_INTRO_COUNTER.visible = false;
				}
				
				private function DrawDynamicStoryOfTheClan() : void {
						var w:MovieClip = this.MC_DYNAMICINTRO;
						var p:Object = Clan.myclanproperties.alliance;
						w.INFO.TXT.FIELD.autoSize = "center";
						Util.SetText(w.INFO.TXT.FIELD,Util.StringVal(Settings.currentintro));
						w.INFO.y = 225;
						w.SB_INFO.buttonstep = 25;
						if(w.INFO.height > 208) {
								w.MASK_INFO.visible = w.SB_INFO.visible = true;
								w.SB_INFO.Set(w.INFO.height,204,0);
								w.SB_INFO.OnScroll = this.OnDynamicIntroScrolling;
								Imitation.CollectChildrenAll(Clan.mc);
								Imitation.SetMaskedMov(w.MASK_INFO,w.INFO);
								Imitation.AddEventMask(w.MASK_INFO,w.INFO);
								w.SB_INFO.SetScrollRect(w.INFO);
								w.SB_INFO.isaligned = false;
						} else {
								w.MASK_INFO.visible = w.SB_INFO.visible = false;
						}
				}
				
				private function HideDynamicStoryOfTheClan() : void {
						this.MC_DYNAMICINTRO.visible = false;
				}
				
				private function ShowInputIntroScrollBar() : void {
						var w:MovieClip = this.MC_INPUTINTRO;
						w.SB_INFO.visible = w.INPUT.FIELD.maxScrollV > 1;
						w.SB_INFO.Set(w.INPUT.FIELD.maxScrollV + 10 + 0.5,10,w.INPUT.FIELD.scrollV + 1);
				}
				
				private function OnInputIntroScrolling(_pos:Number) : void {
						this.MC_INPUTINTRO.INPUT.FIELD.scrollV = _pos;
				}
				
				private function OnDynamicIntroScrolling(_pos:Number) : void {
						this.MC_DYNAMICINTRO.INFO.FIELD.y = 225 + _pos * -1;
				}
				
				private function Activate() : void {
						var p:Object = Clan.myclanproperties.alliance;
						var warning:Boolean = Clan.blocked || Clan.namechange;
						var myadminright:Boolean = Util.NumberVal(p.adminright) > 0;
						this.BTN_SAVE.SetEnabled(true);
						if(Settings.createclan) {
								this.BTN_SAVE.AddEventClick(this.OnFoundClick);
						} else if(Clan.namechange) {
								this.BTN_SAVE.AddEventClick(Clan.mc.Hide);
						} else if(Clan.blocked && !myadminright) {
								this.BTN_SAVE.AddEventClick(Clan.mc.Hide);
						} else if(Clan.blocked && myadminright) {
								this.BTN_SAVE.AddEventClick(this.OnRenameClick);
						} else if(myadminright) {
								this.BTN_SAVE.AddEventClick(this.OnModifyClick);
						} else {
								this.BTN_SAVE.AddEventClick(function(e:Object):* {
										Clan.mc.Draw(Settings.parentpagenumber,true);
								});
						}
						if(myadminright && !warning) {
								Imitation.AddEventClick(this.RB_INVITE,this.OnRadioButtonClick,{"admission":Settings.INVITE_ONLY});
								Imitation.AddEventClick(this.RB_WAITING,this.OnRadioButtonClick,{"admission":Settings.PRIVATE});
								Imitation.AddEventClick(this.RB_JOIN,this.OnRadioButtonClick,{"admission":Settings.PUBLIC});
						}
				}
				
				public function OnHiglightName(_reset:Boolean = true) : void {
						Imitation.GotoFrame(this.BOX_NAME,3);
						if(_reset) {
								Settings.currentname = "";
								this.MC_INPUTNAME.INPUT.FIELD.text = Settings.currentname;
								this.TXT_INFO_NAME.visible = true;
								Util.SetText(this.TXT_NAME_COUNTER.FIELD,"(" + int(Settings.MAX_NAME_LENGTH - Settings.currentname.length) + ")");
						}
						Imitation.FreeBitmap(this.BOX_NAME);
						this.BOX_NAME.visible = true;
				}
				
				public function OffHiglightName() : void {
						Imitation.GotoFrame(this.BOX_NAME,1);
						Imitation.FreeBitmap(this.BOX_NAME);
				}
				
				private function ActivateLeagueSelector() : void {
						Imitation.AddEventClick(this.BTN_LEAGUE,this.OnShowLeagueSelector);
				}
				
				private function ActivateConditions() : void {
						var w:MovieClip = this.CONDITIONS;
						Imitation.AddEventClick(w.CB_COND,this.OnActivateConditions);
				}
				
				private function ActivateInputConditions() : void {
						var w:MovieClip = this.CONDITIONS.PANEL;
						Imitation.EnableInput(w,true);
						Util.AddEventListener(w.INPUT_LEVEL.FIELD,Event.CHANGE,this.OnInputLevelModify);
				}
				
				private function ActivateInputName() : void {
						var w:MovieClip = this.MC_INPUTNAME;
						Imitation.EnableInput(w,true);
						Imitation.AddEventMouseDown(w,this.OnInputNameActivate);
						Util.AddEventListener(w.INPUT.FIELD,Event.CHANGE,this.OnInputNameModify);
				}
				
				private function ActivateInputIntro() : void {
						var w:TextField = this.MC_INPUTINTRO.INPUT.FIELD;
						Imitation.EnableInput(this.MC_INPUTINTRO,true);
						Util.AddEventListener(w,Event.CHANGE,this.OnInputIntroModify);
				}
				
				private function InActivateLeagueSelector() : void {
						Imitation.RemoveEvents(this.BTN_LEAGUE);
				}
				
				private function InActivateInputConditions() : void {
						var w:MovieClip = this.CONDITIONS.PANEL;
						Imitation.EnableInput(w,false);
				}
				
				private function InActivateInputName() : void {
						var w:MovieClip = this.MC_INPUTNAME;
						Imitation.EnableInput(w,false);
						Imitation.AddEventMouseDown(w,this.OnInputNameActivate);
						if(w.INPUT.hasEventListener(Event.CHANGE)) {
								Util.RemoveEventListener(w.INPUT,Event.CHANGE,this.OnInputNameModify);
						}
				}
				
				private function InActivateInputIntro() : void {
						var w:TextField = this.MC_INPUTINTRO.INPUT.FIELD;
						Imitation.EnableInput(this.MC_INPUTINTRO.INPUT,false);
						if(w.hasEventListener(Event.CHANGE)) {
								Util.RemoveEventListener(w,Event.CHANGE,this.OnInputIntroModify);
						}
				}
				
				private function InActivateInput() : void {
						this.InActivateInputName();
						this.InActivateInputIntro();
						this.InActivateInputConditions();
				}
				
				private function InActivateConditions() : void {
						var w:MovieClip = this.CONDITIONS;
						Imitation.RemoveEvents(w.CB_COND);
				}
				
				private function InActivate() : void {
						this.InActivateInput();
						Imitation.DeleteEventGroup(this);
				}
				
				private function OnInputLevelModify(e:Event = null) : void {
						var w:TextField = this.CONDITIONS.PANEL.INPUT_LEVEL.FIELD;
						if(w) {
								Settings.currentcondminlevel = Util.NumberVal(w.text);
						}
				}
				
				private function OnInputIntroModify(e:Event = null) : void {
						var txt:String = null;
						var w:TextField = this.MC_INPUTINTRO.INPUT.FIELD;
						var p:Object = Clan.myclanproperties.alliance;
						var activeintro:* = Util.NumberVal(p.adminright) > 0;
						if(w) {
								this.ShowInputIntroScrollBar();
								if(activeintro) {
										txt = Util.GetRTLEditText(w);
										Settings.currentintro = txt;
										Util.SetText(this.TXT_INTRO_COUNTER.FIELD,"(" + int(Settings.MAX_INTRO_LENGTH - txt.length) + ")");
								}
						}
				}
				
				private function OnInputNameModify(e:Event = null) : void {
						var txt:String = null;
						var w:TextField = this.MC_INPUTNAME.INPUT.FIELD;
						if(w) {
								txt = Util.GetRTLEditText(w);
								Settings.currentname = txt;
								Util.SetText(this.TXT_NAME_COUNTER.FIELD,"(" + int(Settings.MAX_NAME_LENGTH - txt.length) + ")");
						}
				}
				
				private function OnInputNameActivate(e:Object = null) : void {
						if(this.TXT_INFO_NAME) {
								this.TXT_INFO_NAME.visible = false;
						}
				}
				
				private function OnShowLeagueSelector(e:Object = null) : void {
						this.InActivateInput();
						this.DrawLeagueSelector();
						Clan.mc.SetCloseBtn("LEFT",this.HideLeagueSelector);
						this.SELECTOR_LEAGUE.visible = true;
						Imitation.AddButtonStop(this.SELECTOR_LEAGUE.BACK);
				}
				
				private function OnActivateConditions(e:Object = null) : void {
						Settings.currentcond = Settings.currentcond == 0 ? 1 : 0;
						this.DrawConditions(Settings.currentadmission);
				}
				
				private function OnRadioButtonClick(e:Object) : void {
						var admission:int = Settings.currentadmission = Util.NumberVal(e.params.admission);
						this.RB_INVITE.CHECK.visible = admission == Settings.INVITE_ONLY;
						this.RB_WAITING.CHECK.visible = admission == Settings.PRIVATE;
						this.RB_JOIN.CHECK.visible = admission == Settings.PUBLIC;
						this.DrawConditions(admission);
				}
				
				private function OnLeagueSelect(e:Object) : void {
						Settings.currentcondminleague = Util.NumberVal(e.params.minleague);
						this.HideLeagueSelector(null,true);
				}
				
				private function OnRenameClick(e:Object = null) : void {
						var updateproperties:Object = null;
						var clanname:String = Util.StrTrim(Util.GetRTLEditText(this.MC_INPUTNAME.INPUT.FIELD));
						if(clanname.length > 3) {
								updateproperties = new Object();
								updateproperties.cmd = "update";
								updateproperties.name = clanname;
								this.BTN_SAVE.SetEnabled(false);
								this.InActivateInput();
								Clan.AskRenameRequest(updateproperties);
						} else {
								this.OnHiglightName();
						}
				}
				
				private function OnFoundClick(e:Object = null) : void {
						var newclanproperties:Object = null;
						var clanname:String = Util.StrTrim(Util.GetRTLEditText(this.MC_INPUTNAME.INPUT.FIELD));
						var clanintro:String = Util.GetRTLEditText(this.MC_INPUTINTRO.INPUT.FIELD);
						if(clanname.length > 3) {
								newclanproperties = new Object();
								newclanproperties.cmd = "found";
								newclanproperties.name = clanname;
								newclanproperties.intro = clanintro;
								newclanproperties.cond = Settings.currentcond;
								newclanproperties.admission = Settings.currentadmission;
								newclanproperties.cond_minxplevel = Math.min(200,Settings.currentcondminlevel);
								newclanproperties.cond_minleague = Settings.currentcondminleague;
								this.BTN_SAVE.SetEnabled(false);
								this.InActivateInput();
								this.OffHiglightName();
								Clan.OnFoundNewClan(newclanproperties);
						} else {
								this.OnHiglightName();
						}
				}
				
				private function OnModifyClick(e:Object = null) : void {
						var story:String = null;
						var isstorychanging:* = false;
						var admission:Number = NaN;
						var isadmissionchanging:* = false;
						var cond:Number = NaN;
						var iscondchanging:* = false;
						var condminlevel:Number = NaN;
						var iscondminlevelchanging:* = false;
						var condminleague:Number = NaN;
						var iscondminleaguechanging:* = false;
						var admissionproperties:Object = null;
						var p:Object = Clan.myclanproperties.alliance;
						if(p) {
								story = Util.GetRTLEditText(this.MC_INPUTINTRO.INPUT.FIELD);
								isstorychanging = story != Util.StringVal(p.intro);
								admission = Settings.currentadmission;
								isadmissionchanging = admission != Util.NumberVal(p.admission);
								cond = Settings.currentcond;
								iscondchanging = cond != Util.NumberVal(p.cond);
								condminlevel = Math.min(200,Settings.currentcondminlevel);
								iscondminlevelchanging = condminlevel != Util.StringVal(p.cond_minxplevel);
								condminleague = Settings.currentcondminleague;
								iscondminleaguechanging = condminleague != Util.NumberVal(p.cond_minleague);
								if(isstorychanging || (iscondchanging || isadmissionchanging || iscondminleaguechanging || iscondminlevelchanging)) {
										admissionproperties = new Object();
										admissionproperties.cmd = "update";
										if(isstorychanging) {
												admissionproperties.intro = story;
										}
										if(isadmissionchanging || iscondminleaguechanging || iscondminlevelchanging || iscondchanging) {
												admissionproperties.cond = cond;
												admissionproperties.admission = admission;
												admissionproperties.cond_minxplevel = condminlevel;
												admissionproperties.cond_minleague = condminleague;
										}
										this.BTN_SAVE.SetEnabled(false);
										this.InActivateInput();
										Clan.OnUpdateMyClanAdmission(admissionproperties);
								}
						}
				}
				
				private function DrawLeagueSelector() : void {
						var w:MovieClip = this.SELECTOR_LEAGUE;
						var tag:MovieClip = null;
						for(var i:int = 1; i <= 7; i++) {
								tag = w["BTN_" + i];
								if(tag) {
										Util.SetText(tag.LABEL.FIELD,i + ". " + Lang.Get("league_name_" + i));
										tag.RB.CHECK.visible = Settings.currentcondminleague >= i;
										Imitation.GotoFrame(tag.CROWNS,i);
										Imitation.AddEventClick(tag,this.OnLeagueSelect,{"minleague":i});
								}
						}
				}
				
				private function HideLeagueSelector(e:Object = null, _refresh:Boolean = true) : void {
						var w:MovieClip = this.SELECTOR_LEAGUE;
						Imitation.DeleteEventGroup(w);
						if(createclan) {
								Clan.mc.SetCloseBtn("LEFT",function(e:Object):* {
										Hide();
										Clan.mc.Draw(Clan.MEMBERLIST_PAGE_NUMBER,true);
								});
						} else {
								Clan.mc.SetCloseBtn("X",Clan.mc.Hide);
						}
						w.visible = false;
						if(_refresh) {
								this.Draw();
						}
				}
				
				public function Hide(e:Object = null) : void {
						Clan.mc.SetCloseBtn("X",Clan.mc.Hide);
						TweenMax.killTweensOf(this);
						this.HideLeagueSelector(null,false);
						this.InActivate();
						this.visible = false;
						Settings.active = false;
						if(Settings.parentpagenumber == Clan.LIST_PAGE_NUMBER) {
								List.refresh = false;
						}
				}
		}
}

