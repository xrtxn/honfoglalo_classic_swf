package library {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import components.ButtonComponent;
		import flash.display.MovieClip;
		import flash.text.TextField;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol300")]
		public class UserQuestions extends MovieClip {
				public static var active:Boolean = false;
				
				public static var refresh:Boolean = true;
				
				public static var currenttab:int = 1;
				
				public static var currentpos:int = -1;
				
				public var BTN_NEWGUESS:ButtonComponent;
				
				public var BTN_NEWMC:ButtonComponent;
				
				public var BTN_STATS:ButtonComponent;
				
				public var LIST:MovieClip;
				
				public var TAB_1:MovieClip;
				
				public var TAB_10:MovieClip;
				
				public var TAB_2:MovieClip;
				
				public var TAB_3:MovieClip;
				
				public var TAB_4:MovieClip;
				
				public var TAB_5:MovieClip;
				
				public var TAB_6:MovieClip;
				
				public var TAB_7:MovieClip;
				
				public var TAB_8:MovieClip;
				
				public var TAB_9:MovieClip;
				
				public var TAB_COVER:MovieClip;
				
				public var TXT_CREMAINING:TextField;
				
				public var TXT_CSUBJECT:TextField;
				
				public var TXT_HEADER_QUESTION:TextField;
				
				public var TXT_HEADER_RATING:TextField;
				
				public var TXT_HEADER_STATE:TextField;
				
				public var TXT_HEADER_SUBMIT:TextField;
				
				public var TXT_REMAINING:TextField;
				
				public var TXT_SUBJECT:TextField;
				
				public function UserQuestions() {
						super();
						this.__setProp_BTN_NEWGUESS_userquestions_buttons_0();
						this.__setProp_BTN_NEWMC_userquestions_buttons_0();
						this.__setProp_BTN_STATS_userquestions_buttons_0();
				}
				
				public static function Init() : void {
						UserQuestions.currentpos = -1;
						UserQuestions.currenttab = 1;
				}
				
				private static function GetStateInfo(_state:int) : String {
						if([11].indexOf(_state) >= 0) {
								return Lang.Get("usq_state_waiting");
						}
						if([21,31].indexOf(_state) >= 0) {
								return Lang.Get("usq_state_qualifying");
						}
						if([41].indexOf(_state) >= 0) {
								return Lang.Get("usq_state_final");
						}
						if([61,62].indexOf(_state) >= 0) {
								return Lang.Get("usq_state_ingame");
						}
						if(_state >= 42 && _state <= 49) {
								return Lang.Get("usq_state_notqualified");
						}
						return Lang.Get("usq_state_notqualified");
				}
				
				public function Show() : void {
						Util.StopAllChildrenMov(this);
						this.visible = true;
						UserQuestions.active = true;
						UserQuestions.refresh = true;
						this.Draw();
						this.Activate();
						Library.ArriveData();
				}
				
				public function Draw() : void {
						Imitation.CollectChildrenAll(this);
						this.DrawTabs();
						this.DrawContent();
						this.DrawList();
						this.DrawButtons();
				}
				
				private function DrawTabs() : void {
						var tag:Object = null;
						var tab:MovieClip = null;
						var active:* = false;
						var framename:* = "";
						for(var i:uint = 1; i <= 10; i++) {
								tab = this["TAB_" + i];
								tag = Library.themes[Library.PAGE_THEMES[i]];
								active = i == UserQuestions.currenttab;
								framename = active ? "ACTIVE" : "INACTIVE";
								if(tag.USQSTATE == 1) {
										framename += "_SENDING";
								} else if(tag.USQSTATE >= 2 && tag.USQSTATE <= 4) {
										framename += "_PROCESSING";
								} else {
										framename += "";
								}
								Imitation.GotoFrame(tab,framename);
								Imitation.GotoFrame(tab.ICON,Library.PAGE_THEMES[i]);
								if(tab.IND) {
										tab.IND.visible = Util.NumberVal(tag.USQSTATE) == 1;
								}
								Imitation.AddEventClick(tab,this.OnTabClick,{"id":i});
						}
				}
				
				private function DrawContent() : void {
						var tag:Object = Library.themes[Library.PAGE_THEMES[UserQuestions.currenttab]];
						if(tag) {
								Util.SetText(this.TXT_CSUBJECT,Lang.Get("subject") + ":");
								Util.SetText(this.TXT_SUBJECT,Lang.Get("question_subject_" + Library.PAGE_THEMES[UserQuestions.currenttab]));
								Util.RTLSwap("UserQuestions.SUBJECT",this.TXT_CSUBJECT,this.TXT_SUBJECT,true);
								this.DrawRemainingTime(tag);
						}
						Lang.Set(this.TXT_HEADER_SUBMIT,"send_date_short");
						Lang.Set(this.TXT_HEADER_QUESTION,"question");
						Lang.Set(this.TXT_HEADER_STATE,"state");
						Lang.Set(this.TXT_HEADER_RATING,"rating");
				}
				
				private function DrawRemainingTime(_tag:Object) : void {
						var extraweek:* = Config.siteid == "xe" ? 7 * 86400 : 0;
						var txt:String = "";
						var time:String = "";
						if(Util.NumberVal(_tag.USQSTATE) == 4) {
								txt = Lang.Get("remaining_to_final_results");
								time = Util.FormatRemaining(extraweek + 2 * 7 * 86400 - Util.NumberVal(_tag.FROMLASTQSTART));
						} else if(Util.NumberVal(_tag.USQSTATE) >= 2) {
								txt = Lang.Get("remaining_to_qualifying_close");
								time = Util.FormatRemaining(extraweek + 7 * 86400 - Util.NumberVal(_tag.FROMLASTQSTART));
						} else {
								txt = Lang.Get("remaining_to_competition");
								time = Util.FormatRemaining(_tag.TONEXTSTART);
						}
						Util.SetText(this.TXT_CREMAINING,txt + ":");
						Util.SetText(this.TXT_REMAINING,time);
						this.TXT_CREMAINING.visible = this.TXT_REMAINING.visible = false;
				}
				
				private function DrawList() : void {
						var tag:Object = Library.themes[Library.PAGE_THEMES[UserQuestions.currenttab]];
						var w:MovieClip = this.LIST;
						w.LINES.Set("LINE_",tag.questions,44,1,this.OnLineClick,this.DrawLine,w.MASK_LINES,w.SB);
				}
				
				private function DrawLine(_item:MovieClip, _id:int) : void {
						var tag:Object = null;
						var minrating:uint = 0;
						if(_item) {
								tag = Library.themes[Library.PAGE_THEMES[UserQuestions.currenttab]].questions[_id];
								if(tag) {
										Util.SetText(_item.DATE,Util.FormatLocalDate(tag.SENDTIME));
										Util.SetText(_item.QUESTION,Util.StringVal(tag.QUESTION));
										Util.SetText(_item.STATEINFO,UserQuestions.GetStateInfo(Util.NumberVal(tag.QSTATE)));
										_item.STATEINFO.y = _item.STATEINFO.numLines > 1 ? 1 : 8;
										minrating = Util.NumberVal(tag.QSTATE) > 30 && Util.NumberVal(tag.QSTATE) < 40 ? 3 : 5;
										_item.RATING.text = Util.NumberVal(tag.RATINGCOUNT) >= minrating ? Util.StringVal(tag.AVGRATING) : "-";
										_item.LAYER.visible = _id == UserQuestions.currentpos;
										_item.visible = true;
								} else {
										_item.visible = false;
								}
						}
				}
				
				private function DrawButtons() : void {
						this.BTN_NEWGUESS.SetCaption(Lang.Get("add"));
						this.BTN_NEWMC.SetCaption(Lang.Get("add"));
						this.BTN_STATS.SetCaption(Lang.Get("show_statistics"));
				}
				
				private function Activate() : void {
						this.BTN_NEWGUESS.AddEventClick(this.OnEditBtnClick,{"type":UserQuestionEdit.GUESS});
						this.BTN_NEWMC.AddEventClick(this.OnEditBtnClick,{"type":UserQuestionEdit.MC});
						this.BTN_STATS.AddEventClick(this.OnStatBtnClick);
				}
				
				private function InActivate() : void {
						Imitation.DeleteEventGroup(this);
				}
				
				private function OnLineClick(_item:MovieClip, _id:int) : void {
						if(_item) {
								this.HideLinesStroke();
								_item.LAYER.visible = true;
								UserQuestions.currentpos = _id;
								UserQuestionEdit.question = Library.themes[Library.PAGE_THEMES[UserQuestions.currenttab]].questions[_id];
								trace(Util.FormatTrace(UserQuestionEdit.question));
								if(UserQuestionEdit.question) {
										UserQuestionEdit.type = Util.NumberVal(UserQuestionEdit.question.QTYPE);
										UserQuestionEdit.editable = Util.NumberVal(UserQuestionEdit.question.QSTATE) == 11;
										Library.mc.Draw(Library.USER_QUESTION_EDIT);
								}
						}
				}
				
				private function OnTabClick(e:Object) : void {
						UserQuestions.currenttab = Util.NumberVal(e.params.id);
						this.Draw();
				}
				
				private function OnStatBtnClick(e:Object) : void {
						Library.mc.Draw(Library.USER_QUESTION_STATS);
				}
				
				private function OnEditBtnClick(e:Object) : void {
						UserQuestionEdit.question = null;
						UserQuestionEdit.editable = true;
						UserQuestionEdit.type = Util.NumberVal(e.params.type);
						if(!Library.firstwarningshwon) {
								Library.firstwarningshwon = true;
								Library.ShowWarningPanel(Lang.get("question_sending_info"),WarningPanel.WARNING,function():void {
										Library.mc.Draw(Library.USER_QUESTION_EDIT);
								});
						} else {
								Library.mc.Draw(Library.USER_QUESTION_EDIT);
						}
				}
				
				private function HideLinesStroke() : void {
						var i:int = 0;
						var w:MovieClip = this.LIST;
						var p:MovieClip = null;
						if(w.LINES) {
								for(i = 1; i <= 4; i++) {
										p = w.LINES["LINE_" + i];
										if(p) {
												p.LAYER.visible = false;
										}
								}
						}
				}
				
				public function Hide() : void {
						TweenMax.killTweensOf(this);
						this.InActivate();
						this.visible = false;
						UserQuestions.active = false;
						UserQuestions.refresh = true;
				}
				
				internal function __setProp_BTN_NEWGUESS_userquestions_buttons_0() : * {
						try {
								this.BTN_NEWGUESS["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN_NEWGUESS.enabled = true;
						this.BTN_NEWGUESS.fontsize = "MEDIUM";
						this.BTN_NEWGUESS.icon = "";
						this.BTN_NEWGUESS.skin = "OK";
						this.BTN_NEWGUESS.testcaption = "Add";
						this.BTN_NEWGUESS.visible = true;
						this.BTN_NEWGUESS.wordwrap = false;
						try {
								this.BTN_NEWGUESS["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_BTN_NEWMC_userquestions_buttons_0() : * {
						try {
								this.BTN_NEWMC["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN_NEWMC.enabled = true;
						this.BTN_NEWMC.fontsize = "MEDIUM";
						this.BTN_NEWMC.icon = "";
						this.BTN_NEWMC.skin = "OK";
						this.BTN_NEWMC.testcaption = "Add";
						this.BTN_NEWMC.visible = true;
						this.BTN_NEWMC.wordwrap = false;
						try {
								this.BTN_NEWMC["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_BTN_STATS_userquestions_buttons_0() : * {
						try {
								this.BTN_STATS["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN_STATS.enabled = true;
						this.BTN_STATS.fontsize = "MEDIUM";
						this.BTN_STATS.icon = "";
						this.BTN_STATS.skin = "NORMAL";
						this.BTN_STATS.testcaption = "Show stats";
						this.BTN_STATS.visible = true;
						this.BTN_STATS.wordwrap = false;
						try {
								this.BTN_STATS["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

