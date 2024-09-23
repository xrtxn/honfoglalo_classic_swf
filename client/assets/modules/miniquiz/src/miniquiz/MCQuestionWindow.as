package miniquiz {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import fl.motion.easing.*;
		import flash.display.MovieClip;
		import flash.geom.Point;
		import flash.text.*;
		import flash.utils.getTimer;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol64")]
		public class MCQuestionWindow extends MovieClip {
				public static var active:Boolean = false;
				
				public static var question:Object = null;
				
				public static var goodanswer:String = "";
				
				public static var myanswer:String = "";
				
				public var ANSWER_1:MovieClip;
				
				public var ANSWER_2:MovieClip;
				
				public var ANSWER_3:MovieClip;
				
				public var ANSWER_4:MovieClip;
				
				public var CLOCK:MovieClip;
				
				public var MARK:MovieClip;
				
				public var NON_SENSE:MovieClip;
				
				public var OFFENSIVE:MovieClip;
				
				public var QUESTION:TextField;
				
				public var RATING:MovieClip;
				
				public var TXT_COUNTER:TextField;
				
				private var sqc:SqControl = null;
				
				private var answerpositions:Array;
				
				private var timeoutanswer:int = 0;
				
				private var answerstarttime:int = 0;
				
				public function MCQuestionWindow() {
						super();
						this.sqc = new SqControl("miniquiz.MCQuestion");
				}
				
				public function Show() : void {
						Util.StopAllChildrenMov(this);
						this.visible = true;
						MCQuestionWindow.active = true;
						MCQuestionWindow.myanswer = "";
						MCQuestionWindow.goodanswer = "";
						this.Draw();
						this.PlayShowAnim();
				}
				
				public function Draw() : void {
						Imitation.CollectChildrenAll(this);
						this.DrawTable();
						this.DrawRating();
				}
				
				private function DrawTable() : void {
						var lm:MovieClip = null;
						var lmframe:int = 0;
						var q:Object = MCQuestionWindow.question;
						this.answerpositions = [];
						this.TXT_COUNTER.text = 1 + (MiniQuiz.questioncounter - MiniQuiz.openquestioncounter) + " / " + MiniQuiz.questioncounter;
						var tf:TextField = this.QUESTION;
						Util.SetText(tf,q.QUESTION);
						tf.y = 70 - tf.textHeight / 2;
						Lang.Set(this.NON_SENSE.TXT,"no_sense");
						Lang.Set(this.OFFENSIVE.TXT,"offensive_question_short");
						this.MARK.visible = this.RATING.visible = this.CLOCK.visible = false;
						for(var i:uint = 1; i <= 4; i++) {
								lm = this["ANSWER_" + i];
								this.answerpositions[i] = new Point(lm.x,lm.y);
								Imitation.GotoFrame(lm.WINNER,1);
								lm.WINNER.visible = false;
								lmframe = int(lm.BTN.currentFrame);
								Imitation.GotoFrame(lm.BTN,1);
								if(lmframe != 1) {
										Imitation.FreeBitmapAll(lm.BTN);
								}
								Util.SetText(lm.TXT,Util.StringVal(q["A" + i]));
								lm.TXT.y = 30 - lm.TXT.textHeight / 2;
						}
				}
				
				public function DrawAnswers() : void {
						var lm:MovieClip = null;
						var prevframe:uint = 0;
						var p:int = 0;
						var fi:Object = {
								"1":2,
								"2":3,
								"3":4,
								"12":5,
								"13":6,
								"23":7,
								"123":8
						};
						var u:String = "";
						var a:int = 0;
						for(var i:int = 1; i <= 4; i++) {
								lm = this["ANSWER_" + i];
								u = "";
								a = 0;
								for(p = 1; p <= 3; p++) {
										a = 0;
										if(p == 1) {
												a = Util.NumberVal(MCQuestionWindow.myanswer);
										}
										if(a > 0 && a == i) {
												u += String(p);
										}
								}
								if(u.length > 0) {
										prevframe = uint(lm.BTN.currentFrame);
										lm.BTN.gotoAndStop(fi[u]);
										if(prevframe != lm.BTN.currentFrame) {
												Imitation.FreeBitmapAll(lm.BTN);
										}
								}
								lm.visible = true;
						}
				}
				
				private function DrawRating() : void {
						var w:MovieClip = this.RATING;
						Lang.Set(w.STRIP.LABEL,"miniquiz_send_rating");
						Imitation.GotoFrame(w.BTN_LEFT,1);
						Imitation.GotoFrame(w.BTN_RIGHT,2);
						Imitation.AddEventClick(w.BTN_RIGHT,this.OnIWantClick);
						Imitation.AddEventClick(w.BTN_LEFT,this.OnINotWantClick);
				}
				
				public function StartInput() : void {
						var lm:MovieClip = null;
						this.timeoutanswer = 0;
						this.answerstarttime = getTimer();
						TweenMax.fromTo(this.CLOCK.STRIP,MiniQuiz.CLOCKTIMEOUT,{"scaleY":1},{
								"scaleY":0,
								"ease":Linear.easeNone,
								"onComplete":this.TimeIsUp
						});
						TweenMax.fromTo(this.CLOCK.ALERT,1,{"frame":1},{
								"frame":30,
								"delay":MiniQuiz.CLOCKTIMEOUT - 5,
								"repeat":-1
						});
						this.QUESTION.visible = this.CLOCK.visible = true;
						Imitation.AddEventClick(this.NON_SENSE.BTN,this.OnNonSenseBtnClick);
						Imitation.AddEventClick(this.OFFENSIVE.BTN,this.OnOffensiveBtnClick);
						for(var i:int = 1; i <= 4; i++) {
								lm = this["ANSWER_" + i];
								Imitation.AddEventClick(lm,this.OnAnswerBtnClick,{"answer":i});
								Imitation.AddEventMouseDown(lm,this.OnAnswerBtnDown,{"answer":i});
						}
						Sounds.PlayEffect("answer_tiktak");
				}
				
				public function StopInput() : void {
						var lm:MovieClip = null;
						for(var i:int = 1; i <= 4; i++) {
								lm = this["ANSWER_" + i];
								Imitation.RemoveEvents(lm);
						}
						TweenMax.killChildTweensOf(this.CLOCK);
						this.CLOCK.ALERT.gotoAndStop(1);
						this.MARK.visible = this.CLOCK.visible = false;
						this.PlayFadeOutNonSense();
						this.PlayFadeOutOffensive();
				}
				
				public function SendAnswer(_answer:uint) : void {
						MCQuestionWindow.myanswer = String(_answer);
						this.StopInput();
						MiniQuiz.OnSendAnswer(_answer,Util.StringVal(MCQuestionWindow.question.ID),getTimer() - this.answerstarttime);
				}
				
				public function OnAnswerBtnClick(e:Object) : void {
				}
				
				public function OnAnswerBtnDown(e:Object) : void {
						var i:int = Util.NumberVal(e.params.answer);
						var scale:Point = new Point(e.target.scaleX,e.target.scaleY);
						TweenMax.killTweensOf(e.target);
						TweenMax.to(e.target,0.08,{
								"scaleX":scale.x - 0.2,
								"scaleY":scale.y - 0.2,
								"x":this.answerpositions[i].x + 0.2 * e.target.width / 2,
								"y":this.answerpositions[i].y + 0.2 * e.target.height / 2
						});
						TweenMax.to(e.target,0.2,{
								"delay":0.08,
								"scaleX":scale.x,
								"scaleY":scale.y,
								"x":this.answerpositions[i].x,
								"y":this.answerpositions[i].y
						});
						this.SendAnswer(i);
				}
				
				private function OnIWantClick(e:Object) : void {
						this.InActivate();
						CommentPanel.questionid = Util.StringVal(MCQuestionWindow.question.ID);
						MiniQuiz.ShowCommentPanel();
				}
				
				private function OnINotWantClick(e:Object) : void {
						this.InActivate();
						MiniQuiz.OnSendRating(Util.StringVal(MCQuestionWindow.question.ID),1,0,"");
				}
				
				private function OnNonSenseBtnClick(e:Object) : void {
						this.Hide();
						MiniQuiz.OnSendRating(Util.StringVal(MCQuestionWindow.question.ID),1,11,"");
				}
				
				private function OnOffensiveBtnClick(e:Object) : void {
						this.Hide();
						MiniQuiz.OnSendRating(Util.StringVal(MCQuestionWindow.question.ID),1,12,"");
				}
				
				public function sqadd_Evaluation() : void {
						var ao:* = undefined;
						var good:int = 0;
						good = Util.NumberVal(MCQuestionWindow.goodanswer);
						ao = this.sqc.AddObj("miniquiz.MCQuestion.evaluation.prepare");
						ao.self = this;
						ao.Start = function():* {
								this.self.StopInput();
								this.self.DrawAnswers();
								this.Next();
						};
						this.sqc.AddDelay(0.5);
						ao = this.sqc.AddObj("miniquiz.MCQuestion.evaluation.showgood");
						ao.self = this;
						ao.Start = function():* {
								var w:MovieClip = this.self["ANSWER_" + good].WINNER;
								TweenMax.fromTo(w,0.5,{
										"frame":1,
										"visible":true
								},{
										"frame":30,
										"repeat":-1
								});
								this.Next();
						};
						this.sqc.AddDelay(3);
						ao = this.sqc.AddObj("miniquiz.MCQuestion.evaluation.finish");
						ao.self = this;
						ao.Start = function():* {
								var w:MovieClip = this.self["ANSWER_" + good].WINNER;
								TweenMax.killTweensOf(w);
								w.gotoAndStop(1);
								this.Next();
						};
						ao = this.sqc.AddTweenObj("miniquiz.MCQuestion.showrating");
						ao.mov = this.RATING;
						ao.Start = function():* {
								this.AddTweenMaxFromTo(this.mov,0.3,{
										"visible":true,
										"alpha":0
								},{
										"alpha":1,
										"ease":Linear.easeNone
								});
								this.Next();
						};
				}
				
				public function PlayEvaluationAnim() : void {
						this.DrawAnswers();
						this.sqadd_Evaluation();
						this.sqc.Start();
				}
				
				private function PlayFadeOutNonSense() : void {
						var w:MovieClip = null;
						w = this.NON_SENSE;
						Imitation.RemoveEvents(w);
						TweenMax.to(w,0.3,{
								"alpha":0,
								"onComplete":function():* {
										w.visible = false;
								}
						});
				}
				
				private function PlayFadeOutOffensive() : void {
						var w:MovieClip = null;
						w = this.OFFENSIVE;
						Imitation.RemoveEvents(w);
						TweenMax.to(w,0.3,{
								"alpha":0,
								"onComplete":function():* {
										w.visible = false;
								}
						});
				}
				
				public function TimeIsUp() : void {
						this.MARK.scaleX = 1;
						this.MARK.scaleY = 1;
						this.MARK.alpha = 1;
						this.MARK.visible = true;
						Imitation.UpdateAll(this.MARK);
						this.MARK.scaleX = 0;
						this.MARK.scaleY = 0;
						TweenMax.to(this.MARK,0.15,{
								"scaleX":1,
								"scaleY":1,
								"ease":Expo.easeIn
						});
						Sounds.StopEffect("answer_tiktak");
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
										"ease":Strong.easeOut,
										"onComplete":StartInput
								});
						});
				}
				
				private function InActivate() : void {
						Imitation.DeleteEventGroup(this);
				}
				
				public function Hide() : void {
						TweenMax.killTweensOf(this);
						this.InActivate();
						this.visible = false;
						MCQuestionWindow.active = false;
				}
		}
}

