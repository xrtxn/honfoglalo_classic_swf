package miniquiz {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import components.ButtonComponent;
		import components.CharacterComponent;
		import components.WindowFrame;
		import flash.display.MovieClip;
		import flash.text.TextField;
		import flash.utils.Dictionary;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol189")]
		public class CommentPanel extends MovieClip {
				public static var active:Boolean = false;
				
				public static var questionid:String = "";
				
				public static const WELCOME:uint = 1;
				
				public static const FINISH:uint = 2;
				
				public static const VERDICT:uint = 3;
				
				public var BACK:WindowFrame;
				
				public var BTN_CLOSE:ButtonComponent;
				
				public var BTN_OK:ButtonComponent;
				
				public var BUBBLE:MovieClip;
				
				public var INPUT_D:TextField;
				
				public var MC_INPUT:MovieClip;
				
				public var PANEL_1:MovieClip;
				
				public var PANEL_2:MovieClip;
				
				public var PANEL_3:MovieClip;
				
				public var PANEL_WELCOME:MovieClip;
				
				public var TXT_DESCRIPTON:TextField;
				
				public var TXT_INFO:TextField;
				
				public var __id0_:CharacterComponent;
				
				public var __id1_:CharacterComponent;
				
				public var __setPropDict:Dictionary;
				
				public var currentpagenumber:int = -1;
				
				public var currentwrongmode:int = 1;
				
				public function CommentPanel(_page:uint) {
						this.__setPropDict = new Dictionary(true);
						super();
						addFrameScript(0,this.frame1,2,this.frame3);
						this.currentpagenumber = _page;
				}
				
				public function Show(_anim:Boolean = false) : void {
						Util.StopAllChildrenMov(this);
						CommentPanel.active = true;
						this.visible = true;
						this.currentwrongmode = 1;
						this.Draw();
						if(_anim) {
								this.PlayShowAnim();
						}
				}
				
				public function Draw() : void {
						Imitation.CollectChildrenAll(this);
						if(this.currentpagenumber == CommentPanel.WELCOME) {
								this.DrawWelcome();
						} else if(this.currentpagenumber == CommentPanel.FINISH) {
								this.DrawFinish();
						} else if(this.currentpagenumber == CommentPanel.VERDICT) {
								this.DrawVerdict();
						}
				}
				
				private function DrawWelcome() : void {
						Imitation.GotoFrame(this,1);
						var w:MovieClip = this.PANEL_WELCOME;
						Lang.Set(this.TXT_INFO,"qprgame_info");
						this.TXT_INFO.y = 50 + (120 - this.TXT_INFO.textHeight) / 2;
						Lang.Set(w.TXT_QUESTION,"qprgame_are_you_ready",5);
						w.BTN_PLAY.SetLangAndClick("qprgame_play",this.OnPlayBtnClick);
						w.BTN_SKIP.SetLangAndClick("skip_today",this.OnSkipClick);
						w.BTN_NEVER.SetLangAndClick("qprgame_nevershow",this.OnNeverClick);
						this.BTN_CLOSE.visible = this.BACK.visible = false;
				}
				
				private function DrawFinish() : void {
						Imitation.GotoFrame(this,1);
						this.PANEL_WELCOME.visible = false;
						this.BTN_CLOSE.SetLangAndClick("close",this.OnCloseClick);
						Lang.Set(this.TXT_INFO,"qprgame_thank_you");
						this.TXT_INFO.y = 50 + (120 - this.TXT_INFO.textHeight) / 2;
						this.BACK.visible = false;
				}
				
				private function DrawVerdict() : void {
						Imitation.GotoFrame(this,3);
						Lang.Set(this.TXT_INFO,"did_you_find_question_errors");
						this.TXT_INFO.y = 50 + (120 - this.TXT_INFO.textHeight) / 2;
						Util.SetText(this.TXT_DESCRIPTON,Lang.Get("description") + ":");
						Lang.Set(this.PANEL_1.TXT,"no_question_errors");
						Lang.Set(this.PANEL_2.TXT,"wrq_subcode_1");
						Lang.Set(this.PANEL_3.TXT,"wrq_subcode_2");
						this.PANEL_1.RB.CHECK.visible = this.currentwrongmode == 1;
						this.PANEL_2.RB.CHECK.visible = this.currentwrongmode == 2;
						this.PANEL_3.RB.CHECK.visible = this.currentwrongmode == 3;
						Imitation.AddEventClick(this.PANEL_1.RB,this.OnWrongClick,{"wrongmmode":1});
						Imitation.AddEventClick(this.PANEL_2.RB,this.OnWrongClick,{"wrongmmode":2});
						Imitation.AddEventClick(this.PANEL_3.RB,this.OnWrongClick,{"wrongmmode":3});
						this.BTN_OK.SetLangAndClick("okay",this.OnOkBtnClick);
						this.InActivateInput();
				}
				
				private function OnOkBtnClick(e:Object = null) : void {
						MiniQuiz.OnSendRating(CommentPanel.questionid,5,this.currentwrongmode - 1,this.currentwrongmode == 1 ? "" : encodeURIComponent(Util.GetRTLEditText(this.INPUT_D)));
						if(MiniQuiz.mc.currentpage) {
								MiniQuiz.mc.currentpage.Hide();
						}
						MiniQuiz.HideCommentPanel();
				}
				
				private function OnWrongClick(e:Object) : void {
						this.currentwrongmode = Util.NumberVal(e.params.wrongmmode);
						this.PANEL_1.RB.CHECK.visible = this.currentwrongmode == 1;
						this.PANEL_2.RB.CHECK.visible = this.currentwrongmode == 2;
						this.PANEL_3.RB.CHECK.visible = this.currentwrongmode == 3;
						if(this.currentwrongmode > 1) {
								this.ActivateInput();
						} else {
								this.InActivateInput();
						}
				}
				
				private function ActivateInput() : void {
						this.MC_INPUT.alpha = 1;
						Imitation.EnableInput(this,true);
						Util.RTLEditSetup(this.INPUT_D);
						this.INPUT_D.visible = true;
				}
				
				private function InActivateInput() : void {
						this.MC_INPUT.alpha = 0.3;
						Imitation.EnableInput(this,false);
						this.INPUT_D.visible = false;
				}
				
				private function OnPlayBtnClick(e:Object) : void {
						MiniQuiz.OnLoadGameState();
				}
				
				private function OnSkipClick(e:Object) : void {
						MiniQuiz.OnSendAbort();
				}
				
				private function OnNeverClick(e:Object) : void {
						Sys.mydata.flags |= Config.UF_NOQPRGAME;
						Comm.SendCommand("SETDATA","FLAGS=\"" + Sys.mydata.flags + "\"");
						MiniQuiz.AskNeverShow();
				}
				
				private function OnCloseClick(e:Object) : void {
						MiniQuiz.mc.Hide();
				}
				
				private function InActivate() : void {
						Imitation.DeleteEventGroup(this);
				}
				
				private function PlayShowAnim() : void {
						var w:MovieClip = null;
						w = this;
						w.alpha = 0;
						w.x = -w.width;
						TweenMax.delayedCall(0.001,function():* {
								TweenMax.to(w,0.5,{
										"delay":0.3,
										"alpha":1,
										"x":0,
										"y":0,
										"overwrite":"none",
										"ease":Strong.easeOut
								});
						});
				}
				
				private function PlayHideAnim(e:Object = null) : void {
						var w:MovieClip = this;
						TweenMax.to(w,0.3,{
								"alpha":0,
								"x":-w.width,
								"overwrite":"none",
								"onComplete":this.Hide
						});
				}
				
				public function Hide() : void {
						TweenMax.killTweensOf(this);
						Imitation.EnableInput(this,false);
						this.visible = false;
						CommentPanel.active = false;
				}
				
				internal function __setProp___id0__CommentPanel_charachter_0() : * {
						if(this.__setPropDict[this.__id0_] == undefined || int(this.__setPropDict[this.__id0_]) != 1) {
								this.__setPropDict[this.__id0_] = 1;
								try {
										this.__id0_["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.__id0_.character = "LIBRARIAN";
								this.__id0_.enabled = true;
								this.__id0_.frame = 1;
								this.__id0_.shade = true;
								this.__id0_.shadow = false;
								this.__id0_.visible = true;
								try {
										this.__id0_["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTN_CLOSE_CommentPanel_text_0() : * {
						if(this.__setPropDict[this.BTN_CLOSE] == undefined || int(this.__setPropDict[this.BTN_CLOSE]) != 1) {
								this.__setPropDict[this.BTN_CLOSE] = 1;
								try {
										this.BTN_CLOSE["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTN_CLOSE.enabled = true;
								this.BTN_CLOSE.fontsize = "BIG";
								this.BTN_CLOSE.icon = "";
								this.BTN_CLOSE.skin = "OK";
								this.BTN_CLOSE.testcaption = "Close";
								this.BTN_CLOSE.visible = true;
								this.BTN_CLOSE.wordwrap = false;
								try {
										this.BTN_CLOSE["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp___id1__CommentPanel_charachter_2() : * {
						if(this.__setPropDict[this.__id1_] == undefined || int(this.__setPropDict[this.__id1_]) != 3) {
								this.__setPropDict[this.__id1_] = 3;
								try {
										this.__id1_["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.__id1_.character = "LIBRARIAN";
								this.__id1_.enabled = true;
								this.__id1_.frame = 1;
								this.__id1_.shade = true;
								this.__id1_.shadow = false;
								this.__id1_.visible = true;
								try {
										this.__id1_["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function __setProp_BTN_OK_CommentPanel_buttons_2() : * {
						if(this.__setPropDict[this.BTN_OK] == undefined || int(this.__setPropDict[this.BTN_OK]) != 3) {
								this.__setPropDict[this.BTN_OK] = 3;
								try {
										this.BTN_OK["componentInspectorSetting"] = true;
								}
								catch(e:Error) {
								}
								this.BTN_OK.enabled = true;
								this.BTN_OK.fontsize = "MEDIUM";
								this.BTN_OK.icon = "";
								this.BTN_OK.skin = "OK";
								this.BTN_OK.testcaption = "Ok";
								this.BTN_OK.visible = true;
								this.BTN_OK.wordwrap = false;
								try {
										this.BTN_OK["componentInspectorSetting"] = false;
								}
								catch(e:Error) {
								}
						}
				}
				
				internal function frame1() : * {
						this.__setProp_BTN_CLOSE_CommentPanel_text_0();
						this.__setProp___id0__CommentPanel_charachter_0();
				}
				
				internal function frame3() : * {
						this.__setProp_BTN_OK_CommentPanel_buttons_2();
						this.__setProp___id1__CommentPanel_charachter_2();
				}
		}
}

