package library {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import components.ButtonComponent;
		import flash.display.MovieClip;
		import flash.events.Event;
		import flash.text.TextField;
		import flash.text.TextFieldType;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol370")]
		public class UserQuestionEdit extends MovieClip {
				public static const MC:uint = 1;
				
				public static const GUESS:uint = 2;
				
				public static const MAX_QUESTION_LENGTH:uint = 120;
				
				public static const MAX_SOURCE_LENGTH:uint = 250;
				
				public static var active:Boolean = false;
				
				public static var type:uint = 1;
				
				public static var question:Object = null;
				
				public static var editable:Boolean = true;
				
				public var BTN_CANCEL:ButtonComponent;
				
				public var BTN_CHANGE:ButtonComponent;
				
				public var BTN_SEND:ButtonComponent;
				
				public var CNT_QUESTION:TextField;
				
				public var CNT_SOURCE:TextField;
				
				public var EDITOR:MovieClip;
				
				public var GRAPHICS:MovieClip;
				
				public var SELECTOR_SUBJECT:MovieClip;
				
				public var TXT_1:TextField;
				
				public var TXT_2:TextField;
				
				public var TXT_3:TextField;
				
				public var TXT_CSUBJECT:TextField;
				
				public var TXT_GOOD:TextField;
				
				public var TXT_INFO:TextField;
				
				public var TXT_QUESTION:TextField;
				
				public var TXT_SOURCE:TextField;
				
				public var TXT_SUBJECT:TextField;
				
				public var TXT_TYPE:TextField;
				
				public var TXT_WRONG:TextField;
				
				public function UserQuestionEdit() {
						super();
						this.__setProp_BTN_CHANGE_userquestionedit_buttons_0();
						this.__setProp_BTN_SEND_userquestionedit_buttons_0();
						this.__setProp_BTN_CANCEL_userquestionedit_buttons_0();
				}
				
				private static function CreateEmptyQuestion() : void {
						UserQuestionEdit.question = {
								"ID":-1,
								"QSTATE":11,
								"QTYPE":UserQuestionEdit.type,
								"THEMEID":Library.PAGE_THEMES[UserQuestions.currenttab],
								"QUESTION":"",
								"ANSTIP":"",
								"A1":"",
								"A2":"",
								"A3":"",
								"A4":"",
								"SOURCE":""
						};
				}
				
				public function Show() : void {
						Util.StopAllChildrenMov(this);
						this.visible = true;
						UserQuestionEdit.active = true;
						UserQuestions.refresh = false;
						if(!UserQuestionEdit.question) {
								UserQuestionEdit.CreateEmptyQuestion();
						}
						this.Draw();
				}
				
				private function SaveQuestion() : void {
						var w:MovieClip = this.EDITOR;
						UserQuestionEdit.question.QUESTION = Util.GetRTLEditText(w.INPUT_Q);
						UserQuestionEdit.question.ANSTIP = Util.GetRTLEditText(w.INPUT_A);
						UserQuestionEdit.question.A1 = Util.GetRTLEditText(w.INPUT_A);
						if(w.INPUT_W1) {
								UserQuestionEdit.question.A2 = Util.GetRTLEditText(w.INPUT_W1);
						}
						if(w.INPUT_W2) {
								UserQuestionEdit.question.A3 = Util.GetRTLEditText(w.INPUT_W2);
						}
						if(w.INPUT_W3) {
								UserQuestionEdit.question.A4 = Util.GetRTLEditText(w.INPUT_W3);
						}
						UserQuestionEdit.question.SOURCE = Util.GetRTLEditText(w.INPUT_S);
				}
				
				public function Draw() : void {
						this.gotoAndStop(UserQuestionEdit.type);
						Imitation.CollectChildrenAll(this);
						this.HideSubjectSelector(null,false);
						this.DrawGraphics();
						Imitation.Combine(this.GRAPHICS,true);
						this.DrawButtons();
						this.DrawContent();
						TweenMax.delayedCall(0.1,function():* {
								Activate();
								TweenMax.delayedCall(0.1,DrawInputs);
						});
				}
				
				private function DrawGraphics() : void {
						var w:MovieClip = this.GRAPHICS;
						w.MC_BOXES.visible = UserQuestionEdit.type == UserQuestionEdit.MC;
						w.GUESS_BOXES.visible = UserQuestionEdit.type == UserQuestionEdit.GUESS;
						w.MC_BOXES.alpha = UserQuestionEdit.editable ? 1 : 0.3;
						w.GUESS_BOXES.alpha = UserQuestionEdit.editable ? 1 : 0.3;
				}
				
				private function DrawContent() : void {
						var w:MovieClip = this.EDITOR;
						Lang.Set(this.TXT_TYPE,UserQuestionEdit.type == UserQuestionEdit.MC ? "multiple_choice_question" : "tip_question");
						Util.SetText(this.TXT_CSUBJECT,Lang.Get("subject") + ":");
						Util.SetText(this.TXT_SUBJECT,Lang.Get("question_subject_" + Library.PAGE_THEMES[UserQuestions.currenttab]));
						Util.RTLSwap("UserQuestionsEdit.SUBJECT",this.TXT_CSUBJECT,this.TXT_SUBJECT,true);
						Lang.Set(this.TXT_INFO,"qsubject_info_" + Library.PAGE_THEMES[UserQuestions.currenttab]);
						Util.SetText(this.TXT_QUESTION,Lang.Get("question") + ":");
						Util.SetText(this.TXT_GOOD,Lang.Get("good_answer") + ":");
						Util.SetText(this.TXT_SOURCE,Lang.Get("source") + ":");
						if(this.TXT_WRONG) {
								Util.SetText(this.TXT_WRONG,Lang.Get("wrong_answers") + ":");
						}
						if(this.TXT_1) {
								Util.SetText(this.TXT_1,"1:");
						}
						if(this.TXT_2) {
								Util.SetText(this.TXT_2,"2:");
						}
						if(this.TXT_3) {
								Util.SetText(this.TXT_3,"3:");
						}
				}
				
				private function DrawInputs() : void {
						var w:MovieClip = this.EDITOR;
						Util.SetRTLEditText(w.INPUT_Q,Util.StringVal(UserQuestionEdit.question.QUESTION));
						Util.SetRTLEditText(w.INPUT_S,Util.StringVal(UserQuestionEdit.question.SOURCE));
						Util.SetRTLEditText(w.INPUT_A,Util.StringVal(UserQuestionEdit.type == UserQuestionEdit.MC ? UserQuestionEdit.question.A1 : UserQuestionEdit.question.ANSTIP));
						if(w.INPUT_W1) {
								Util.SetRTLEditText(w.INPUT_W1,Util.StringVal(UserQuestionEdit.question.A2));
						}
						if(w.INPUT_W2) {
								Util.SetRTLEditText(w.INPUT_W2,Util.StringVal(UserQuestionEdit.question.A3));
						}
						if(w.INPUT_W3) {
								Util.SetRTLEditText(w.INPUT_W3,Util.StringVal(UserQuestionEdit.question.A4));
						}
						if(w.INPUT_Q) {
								w.INPUT_Q.alpha = UserQuestionEdit.editable ? 1 : 0.7;
						}
						if(w.INPUT_S) {
								w.INPUT_S.alpha = UserQuestionEdit.editable ? 1 : 0.7;
						}
						if(w.INPUT_A) {
								w.INPUT_A.alpha = UserQuestionEdit.editable ? 1 : 0.7;
						}
						if(w.INPUT_W1) {
								w.INPUT_W1.alpha = UserQuestionEdit.editable ? 1 : 0.7;
						}
						if(w.INPUT_W2) {
								w.INPUT_W2.alpha = UserQuestionEdit.editable ? 1 : 0.7;
						}
						if(w.INPUT_W3) {
								w.INPUT_W3.alpha = UserQuestionEdit.editable ? 1 : 0.7;
						}
				}
				
				private function DrawButtons() : void {
						this.BTN_CHANGE.SetCaption(Lang.Get("change_subject"));
						this.BTN_SEND.SetCaption(Lang.Get(Util.NumberVal(UserQuestionEdit.question.ID) > 0 ? "modify_question" : "send_in_question"));
						this.BTN_CANCEL.SetCaption(Lang.Get(UserQuestionEdit.editable ? "cancel" : "close"));
						this.BTN_CHANGE.SetEnabled(true);
						this.BTN_SEND.SetEnabled(true);
						this.BTN_CANCEL.SetEnabled(true);
						this.BTN_SEND.visible = UserQuestionEdit.editable;
						this.BTN_CHANGE.visible = UserQuestionEdit.editable;
				}
				
				private function DrawSubjectSelector() : void {
						var w:MovieClip = this.SELECTOR_SUBJECT;
						var tag:Object = null;
						var btn:MovieClip = null;
						for(var i:int = 1; i <= 10; i++) {
								tag = Library.themes[Library.PAGE_THEMES[i]];
								btn = w["BTN_" + i];
								if(tag) {
										Util.SetText(btn.LABEL,Lang.Get("question_subject_" + Library.PAGE_THEMES[i]));
										btn.RB.CHECK.visible = i == UserQuestions.currenttab;
										Imitation.GotoFrame(btn.ICON,Library.PAGE_THEMES[i]);
										Imitation.AddEventClick(btn,this.OnSubjectSelect,{"id":i});
								}
						}
				}
				
				private function Activate() : void {
						this.BTN_CHANGE.AddEventClick(this.OnShowSubjectSelector);
						this.BTN_SEND.AddEventClick(this.OnSendQuestion);
						this.BTN_CANCEL.AddEventClick(this.OnCancelBtnClick);
						this.SetInput();
				}
				
				private function OnSendQuestion(e:Object) : void {
						var w:MovieClip = this.EDITOR;
						var p:int = !Config.mobile ? 1 : (Config.android ? 2 : 3);
						this.BTN_CHANGE.SetEnabled(false);
						this.BTN_SEND.SetEnabled(false);
						this.BTN_CANCEL.SetEnabled(false);
						this.SaveQuestion();
						this.InActivateInput();
						var q:String = "";
						q += "&stoc=" + Config.stoc;
						q += "&platform=" + p;
						q += "&id=" + Util.NumberVal(UserQuestionEdit.question.ID);
						q += "&qtype=" + UserQuestionEdit.type;
						q += "&themeid=" + Util.NumberVal(Library.PAGE_THEMES[UserQuestions.currenttab]);
						q += "&question=" + encodeURIComponent(Util.GetRTLEditText(w.INPUT_Q));
						q += "&source=" + encodeURIComponent(Util.GetRTLEditText(w.INPUT_S));
						if(UserQuestionEdit.type == UserQuestionEdit.MC) {
								q += "&a1=" + encodeURIComponent(Util.GetRTLEditText(w.INPUT_A));
								q += "&a2=" + encodeURIComponent(Util.GetRTLEditText(w.INPUT_W1));
								q += "&a3=" + encodeURIComponent(Util.GetRTLEditText(w.INPUT_W2));
								q += "&a4=" + encodeURIComponent(Util.GetRTLEditText(w.INPUT_W3));
						} else {
								q += "&anstip=" + w.INPUT_A.text;
						}
						Library.OnSendQuestion(q);
				}
				
				private function OnCancelBtnClick(e:Object) : void {
						Library.mc.Draw(Library.USER_QUESTIONS);
				}
				
				private function SetInput() : void {
						var w:MovieClip = null;
						w = this.EDITOR;
						Imitation.EnableInput(w,UserQuestionEdit.editable);
						if(UserQuestionEdit.editable) {
								w.INPUT_Q.type = TextFieldType.INPUT;
								w.INPUT_S.type = TextFieldType.INPUT;
								w.INPUT_A.type = TextFieldType.INPUT;
								TweenMax.delayedCall(0,function():* {
										Util.RTLEditSetup(w.INPUT_Q);
										Util.RTLEditSetup(w.INPUT_S);
										Util.RTLEditSetup(w.INPUT_A);
								});
								if(UserQuestionEdit.type == UserQuestionEdit.GUESS) {
										w.INPUT_A.restrict = "0123456789";
								}
								if(UserQuestionEdit.type == UserQuestionEdit.MC) {
										w.INPUT_W1.type = TextFieldType.INPUT;
										w.INPUT_W2.type = TextFieldType.INPUT;
										w.INPUT_W3.type = TextFieldType.INPUT;
										TweenMax.delayedCall(0,function():* {
												Util.RTLEditSetup(w.INPUT_W1);
												Util.RTLEditSetup(w.INPUT_W2);
												Util.RTLEditSetup(w.INPUT_W3);
										});
								}
								Util.SetText(this.CNT_QUESTION,"(" + int(UserQuestionEdit.MAX_QUESTION_LENGTH - w.INPUT_Q.text.length) + ")");
								Util.SetText(this.CNT_SOURCE,"(" + int(UserQuestionEdit.MAX_SOURCE_LENGTH - w.INPUT_S.text.length) + ")");
								Util.AddEventListener(w.INPUT_Q,Event.CHANGE,this.OnInputQuestionModify);
								Util.AddEventListener(w.INPUT_S,Event.CHANGE,this.OnInputSourceModify);
						} else {
								if(w.INPUT_Q) {
										w.INPUT_Q.type = TextFieldType.DYNAMIC;
								}
								if(w.INPUT_S) {
										w.INPUT_S.type = TextFieldType.DYNAMIC;
								}
								if(w.INPUT_A) {
										w.INPUT_A.type = TextFieldType.DYNAMIC;
								}
								if(w.INPUT_W1) {
										w.INPUT_W1.type = TextFieldType.DYNAMIC;
								}
								if(w.INPUT_W2) {
										w.INPUT_W2.type = TextFieldType.DYNAMIC;
								}
								if(w.INPUT_W3) {
										w.INPUT_W3.type = TextFieldType.DYNAMIC;
								}
								this.CNT_QUESTION.text = "";
								this.CNT_SOURCE.text = "";
						}
				}
				
				private function OnInputQuestionModify(e:Event = null) : void {
						var w:MovieClip = this.EDITOR;
						Util.SetText(this.CNT_QUESTION,"(" + int(UserQuestionEdit.MAX_QUESTION_LENGTH - w.INPUT_Q.text.length) + ")");
				}
				
				private function OnInputSourceModify(e:Event = null) : void {
						var w:MovieClip = this.EDITOR;
						Util.SetText(this.CNT_SOURCE,"(" + int(UserQuestionEdit.MAX_SOURCE_LENGTH - w.INPUT_S.text.length) + ")");
				}
				
				private function OnSubjectSelect(e:Object) : void {
						UserQuestions.currenttab = Util.NumberVal(e.params.id);
						this.HideSubjectSelector(null,true);
				}
				
				private function InActivateInput() : void {
						var w:MovieClip = this.EDITOR;
						Imitation.EnableInput(w,false);
						if(w.INPUT_Q.hasEventListener(Event.CHANGE)) {
								Util.RemoveEventListener(w.INPUT_Q,Event.CHANGE,this.OnInputQuestionModify);
						}
						if(w.INPUT_S.hasEventListener(Event.CHANGE)) {
								Util.RemoveEventListener(w.INPUT_S,Event.CHANGE,this.OnInputSourceModify);
						}
				}
				
				private function InActivate() : void {
						this.InActivateInput();
						Imitation.DeleteEventGroup(this);
				}
				
				private function OnShowSubjectSelector(e:Object = null) : void {
						this.InActivateInput();
						this.SaveQuestion();
						this.DrawSubjectSelector();
						Library.mc.SetCloseBtn("LEFT",this.HideSubjectSelector);
						this.SELECTOR_SUBJECT.visible = true;
						Imitation.AddButtonStop(this.SELECTOR_SUBJECT.BACK);
				}
				
				private function HideSubjectSelector(e:Object = null, _refresh:Boolean = true) : void {
						var w:MovieClip = this.SELECTOR_SUBJECT;
						Imitation.DeleteEventGroup(w);
						Library.mc.SetCloseBtn("LEFT",function(e:Object):* {
								Library.mc.Draw(Library.USER_QUESTIONS);
						});
						w.visible = false;
						if(_refresh) {
								this.Draw();
						}
				}
				
				public function Hide() : void {
						TweenMax.killTweensOf(this);
						this.HideSubjectSelector(null,false);
						this.InActivate();
						this.visible = false;
						UserQuestionEdit.active = false;
				}
				
				internal function __setProp_BTN_CHANGE_userquestionedit_buttons_0() : * {
						try {
								this.BTN_CHANGE["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN_CHANGE.enabled = true;
						this.BTN_CHANGE.fontsize = "BIG";
						this.BTN_CHANGE.icon = "";
						this.BTN_CHANGE.skin = "NORMAL";
						this.BTN_CHANGE.testcaption = "Change Subject";
						this.BTN_CHANGE.visible = true;
						this.BTN_CHANGE.wordwrap = false;
						try {
								this.BTN_CHANGE["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_BTN_SEND_userquestionedit_buttons_0() : * {
						try {
								this.BTN_SEND["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN_SEND.enabled = true;
						this.BTN_SEND.fontsize = "BIG";
						this.BTN_SEND.icon = "";
						this.BTN_SEND.skin = "OK";
						this.BTN_SEND.testcaption = "Send Question";
						this.BTN_SEND.visible = true;
						this.BTN_SEND.wordwrap = false;
						try {
								this.BTN_SEND["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_BTN_CANCEL_userquestionedit_buttons_0() : * {
						try {
								this.BTN_CANCEL["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN_CANCEL.enabled = true;
						this.BTN_CANCEL.fontsize = "BIG";
						this.BTN_CANCEL.icon = "";
						this.BTN_CANCEL.skin = "NORMAL";
						this.BTN_CANCEL.testcaption = "Cancel";
						this.BTN_CANCEL.visible = true;
						this.BTN_CANCEL.wordwrap = false;
						try {
								this.BTN_CANCEL["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

