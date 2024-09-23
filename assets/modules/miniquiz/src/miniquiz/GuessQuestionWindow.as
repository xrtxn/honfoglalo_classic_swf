package miniquiz {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import fl.motion.easing.*;
		import flash.display.MovieClip;
		import flash.geom.Point;
		import flash.text.*;
		import flash.utils.getTimer;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol142")]
		public class GuessQuestionWindow extends MovieClip {
				public static var active:Boolean = false;
				
				public static var question:Object = null;
				
				public static var goodanswer:String = "";
				
				public static var myanswer:String = "";
				
				private static var evaluationanimproperties:Object = null;
				
				public static const ARROW_SCALE:Point = new Point(0.274,0.269);
				
				public static const BOX_SCALE:Point = new Point(0.982,0.959);
				
				public var ARROW:MovieClip;
				
				public var BOX:MovieClip;
				
				public var CENTER:MovieClip;
				
				public var CIRCLEMOV:MovieClip;
				
				public var GOODANSWER:MovieClip;
				
				public var INPUT:MovieClip;
				
				public var MARK:MovieClip;
				
				public var NON_SENSE:MovieClip;
				
				public var OFFENSIVE:MovieClip;
				
				public var QUESTION:TextField;
				
				public var RATING:MovieClip;
				
				public var TXT_COUNTER:TextField;
				
				private var sqc:SqControl = null;
				
				private var timeoutanswer:int = 0;
				
				private var answerstarttime:int = 0;
				
				public function GuessQuestionWindow() {
						super();
						this.sqc = new SqControl("miniquiz.GuessQuestionWindow");
				}
				
				public function Show() : void {
						Util.StopAllChildrenMov(this);
						this.visible = true;
						GuessQuestionWindow.active = true;
						this.Draw();
						this.PlayShowAnim();
				}
				
				public function Draw() : void {
						Imitation.CollectChildrenAll(this);
						this.DrawTable();
						this.DrawInput();
						this.DrawRating();
				}
				
				private function DrawTable() : void {
						var q:Object = GuessQuestionWindow.question;
						this.TXT_COUNTER.text = 1 + (MiniQuiz.questioncounter - MiniQuiz.openquestioncounter) + " / " + MiniQuiz.questioncounter;
						var tf:TextField = this.QUESTION;
						Util.SetText(tf,q.QUESTION);
						tf.y = 70 - tf.textHeight / 2;
						Lang.Set(this.NON_SENSE.TXT,"no_sense");
						Lang.Set(this.OFFENSIVE.TXT,"offensive_question_short");
						this.MARK.visible = this.RATING.visible = false;
						this.BOX.visible = this.ARROW.visible = this.GOODANSWER.visible = this.CIRCLEMOV.visible = this.CENTER.visible = false;
				}
				
				private function DrawInput() : void {
						var w:MovieClip = this.INPUT;
						w.VALUE.text = "";
						w.CURSOR.visible = w.CLOCK.visible = false;
						for(var i:uint = 0; i <= 9; w.BUTTONS["NUM" + i].CAPTION.text = String(i),i++) {
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
						this.timeoutanswer = 0;
						this.answerstarttime = getTimer();
						TweenMax.fromTo(this.INPUT.CLOCK.STRIP,MiniQuiz.CLOCKTIMEOUT,{"scaleY":1},{
								"scaleY":0,
								"ease":Linear.easeNone,
								"onComplete":this.TimeIsUp
						});
						TweenMax.fromTo(this.INPUT.CLOCK.ALERT,1,{"frame":1},{
								"frame":30,
								"delay":MiniQuiz.CLOCKTIMEOUT - 5,
								"repeat":-1
						});
						this.QUESTION.visible = this.INPUT.CLOCK.visible = true;
						Imitation.AddEventClick(this.NON_SENSE.BTN,this.OnNonSenseBtnClick);
						Imitation.AddEventClick(this.OFFENSIVE.BTN,this.OnOffensiveBtnClick);
						var w:MovieClip = this.INPUT;
						w.CURSOR.visible = true;
						for(var i:uint = 0; i <= 9; this.SetupButton(w.BUTTONS["NUM" + i],["number",i]),i++) {
						}
						this.SetupButton(w.BUTTONS["DEL"],["del"]);
						this.SetupButton(w.BUTTONS["BTNSEND"],["send"]);
						Util.AddEventListener(Imitation.stage,"keyDown",this.OnKeyDown);
						TweenMax.fromTo(w.CURSOR,0.7,{
								"frame":1,
								"visible":true
						},{
								"frame":30,
								"repeat":-1
						});
						Sounds.PlayEffect("answer_tiktak");
				}
				
				public function StopInput() : void {
						TweenMax.killChildTweensOf(this.INPUT.CLOCK);
						this.INPUT.CLOCK.ALERT.gotoAndStop(1);
						this.MARK.visible = this.INPUT.CLOCK.visible = false;
						Util.RemoveEventListener(Imitation.stage,"keyDown",this.OnKeyDown);
						Imitation.DeleteEventGroup(this.INPUT);
						TweenMax.killChildTweensOf(this.INPUT.CLOCK);
						this.INPUT.CLOCK.ALERT.gotoAndStop(1);
						TweenMax.to(this.INPUT,0.4,{
								"alpha":0,
								"visible":false
						});
						this.PlayFadeOutNonSense();
						this.PlayFadeOutOffensive();
				}
				
				public function SetupButton(_btn:MovieClip, _params:Array) : void {
						Imitation.AddEventMouseDown(_btn,this.OnButtonDown,_params);
						Imitation.AddEventClick(_btn,this.OnButtonClick,_params);
				}
				
				public function CalculateEvaluationAnim() : void {
						var distances:Array = [120,110,100,90,80];
						var distanceindex:uint = uint(Util.Random(4,0));
						var a:MovieClip = this.ARROW;
						var p:Object = {};
						p.angle = a.rotation;
						var pt:Point = this.GetPolarCoords(p.angle,420);
						p.startx = pt.x;
						p.starty = pt.y;
						p.value = Util.NumberVal(GuessQuestionWindow.myanswer);
						p.time = (getTimer() - this.answerstarttime) / 1000;
						p.distance = GuessQuestionWindow.myanswer == GuessQuestionWindow.goodanswer ? 12 : distances[distanceindex];
						p.realdifference = p.value - Util.NumberVal(GuessQuestionWindow.goodanswer);
						if(p.realdifference == 0) {
								p.realdifference = " 0";
						} else if(p.realdifference > 0) {
								p.realdifference = "+" + Util.StringVal(p.realdifference);
						}
						pt = this.GetPolarCoords(p.angle,p.distance);
						p.endx = pt.x;
						p.endy = pt.y;
						a = this.BOX;
						a.gotoAndStop(1);
						a["VALUE"].text = p.value <= -1000000000 ? "-" : (p.value >= 0 ? p.value : "");
						a["VALUE_TIME"].text = String(Util.RoundDecimalPlace(Util.NumberVal(p.time),2));
						a["VALUE_DIFF"].text = String(p.realdifference);
						if(GuessQuestionWindow.myanswer != GuessQuestionWindow.goodanswer) {
								Imitation.GotoFrame(this.CIRCLEMOV,distanceindex + 1);
								p.circle = this.CIRCLEMOV;
						} else {
								p.circle = this.CENTER;
						}
						GuessQuestionWindow.evaluationanimproperties = p;
				}
				
				public function SendAnswer() : void {
						var tmp:String = String(this.INPUT.VALUE.text);
						var tip:String = "";
						var idx:int = 0;
						while(idx < tmp.length && (tmp.charAt(idx) < "0" || tmp.charAt(idx) > "9")) {
								idx++;
						}
						while(idx < tmp.length && tip.length < 9 && (tmp.charAt(idx) >= "0" || tmp.charAt(idx) <= "9")) {
								tip += tmp.charAt(idx);
								idx++;
						}
						if(tip == "") {
								tip = "0";
						}
						GuessQuestionWindow.myanswer = tip;
						this.StopInput();
						MiniQuiz.OnSendAnswer(Util.NumberVal(tip),Util.StringVal(GuessQuestionWindow.question.ID),getTimer() - this.answerstarttime);
				}
				
				private function OnButtonClick(e:*) : void {
				}
				
				private function OnButtonDown(e:*) : void {
						var t:String = null;
						var bt:String = e.params[0];
						var w:MovieClip = this.INPUT;
						if("number" == bt) {
								t = w.VALUE.text;
								if(t.length < 9) {
										t += String(e.params[1]);
								}
								w.VALUE.text = t;
						} else if("del" == bt) {
								t = w.VALUE.text;
								w.VALUE.text = t.substr(0,t.length - 1);
						} else if("send" == bt) {
								this.SendAnswer();
						}
						var i:int = int(e.params.answer);
						var scale:Point = new Point(e.target.scaleX,e.target.scaleY);
						TweenMax.killTweensOf(e.target);
						TweenMax.to(e.target,0.08,{
								"scaleX":scale.x - 0.2,
								"scaleY":scale.y - 0.2
						});
						TweenMax.to(e.target,0.2,{
								"delay":0.08,
								"scaleX":scale.x,
								"scaleY":scale.y
						});
						Sounds.PlayEffect("click");
				}
				
				private function OnKeyDown(e:*) : void {
						var i:int = 0;
						var e2:Object = {"params":[]};
						if(e.charCode >= 48 && e.charCode <= 57) {
								i = e.charCode - 48;
								e2.params = ["number",i];
								e2.target = this.INPUT.BUTTONS["NUM" + i];
								this.OnButtonDown(e2);
						} else if(e.charCode == 13) {
								e2.params = ["send"];
								e2.target = this.INPUT.BUTTONS.BTNSEND;
								this.OnButtonDown(e2);
						} else if(e.charCode == 8) {
								e2.params = ["del"];
								e2.target = this.INPUT.BUTTONS.DEL;
								this.OnButtonDown(e2);
						}
				}
				
				private function OnIWantClick(e:Object) : void {
						this.InActivate();
						CommentPanel.questionid = Util.StringVal(GuessQuestionWindow.question.ID);
						MiniQuiz.ShowCommentPanel();
				}
				
				private function OnINotWantClick(e:Object) : void {
						this.InActivate();
						MiniQuiz.OnSendRating(Util.StringVal(GuessQuestionWindow.question.ID),1,0,"");
				}
				
				private function OnNonSenseBtnClick(e:Object) : void {
						this.Hide();
						MiniQuiz.OnSendRating(Util.StringVal(GuessQuestionWindow.question.ID),1,11,"");
				}
				
				private function OnOffensiveBtnClick(e:Object) : void {
						this.Hide();
						MiniQuiz.OnSendRating(Util.StringVal(GuessQuestionWindow.question.ID),1,12,"");
				}
				
				public function PlayEvaluationAnim() : void {
						this.sqadd_Evaluation();
						this.sqc.Start();
				}
				
				private function sqadd_Evaluation() : void {
						var good:int;
						var ao:* = undefined;
						this.CalculateEvaluationAnim();
						ao = this.sqc.AddObj("miniquiz.GuessQuestionWindow.evaluation.prepare");
						ao.self = this;
						good = Util.NumberVal(GuessQuestionWindow.goodanswer);
						this.GOODANSWER.ANSWER.text = String(good);
						this.GOODANSWER.scaleX = 0.982;
						this.GOODANSWER.scaleY = 0.959;
						this.GOODANSWER.alpha = 1;
						this.GOODANSWER.visible = true;
						Imitation.UpdateAll(this.GOODANSWER);
						this.GOODANSWER.visible = false;
						this.ARROW.visible = true;
						this.ARROW.scaleX = GuessQuestionWindow.ARROW_SCALE.x;
						this.ARROW.scaleY = GuessQuestionWindow.ARROW_SCALE.y;
						Imitation.UpdateAll(this.ARROW);
						this.ARROW.visible = false;
						this.BOX.visible = true;
						this.BOX.scaleX = GuessQuestionWindow.BOX_SCALE.x;
						this.BOX.scaleY = GuessQuestionWindow.BOX_SCALE.y;
						Imitation.UpdateAll(this.BOX);
						this.BOX.visible = false;
						this.sqc.AddDelay(1);
						ao = this.sqc.AddTweenObj("miniquiz.GuessEvaluate.showgood");
						ao.mov = this.GOODANSWER;
						ao.Start = function():* {
								this.AddTweenMaxFromTo(this.mov,0.5,{
										"visible":true,
										"scaleX":0,
										"scaleY":0
								},{
										"scaleX":0.982,
										"scaleY":0.959,
										"ease":Bounce.easeOut
								});
								Sounds.PlayEffect("guess_good_answer");
						};
						this.sqc.AddDelay(1);
						ao = this.sqc.AddTweenObj("miniquiz.GuessEvaluate.arrow");
						ao.mov = this.ARROW;
						ao.p = GuessQuestionWindow.evaluationanimproperties;
						ao.Start = function():* {
								this.AddTweenMaxFromTo(this.mov,0.1,{
										"visible":true,
										"x":this.p.startx,
										"y":this.p.starty
								},{
										"x":this.p.endx,
										"y":this.p.endy,
										"ease":Linear.easeOut
								});
						};
						ao = this.sqc.AddTweenObj("miniquiz.GuessEvaluate.arrowvibrate");
						ao.mov = this.ARROW;
						ao.box = this.BOX;
						ao.fromscale = GuessQuestionWindow.ARROW_SCALE;
						ao.Start = function():* {
								this.mov.MARK.visible = true;
								this.AddTweenMaxFromTo(this.mov,0.05,{"scaleX":this.fromscale.x},{
										"scaleX":this.fromscale.y * 0.95,
										"repeat":2,
										"yoyo":true
								});
								Sounds.PlayEffect("arrow_hit");
						};
						ao = this.sqc.AddTweenObj("miniquiz.GuessEvaluate.showbox");
						ao.mov = this.BOX;
						ao.Start = function():* {
								this.AddTweenMaxFromTo(this.mov,0.3,{
										"visible":true,
										"scaleX":0,
										"scaleY":0
								},{
										"scaleX":GuessQuestionWindow.BOX_SCALE.x,
										"scaleY":GuessQuestionWindow.BOX_SCALE.y,
										"ease":Bounce.easeOut
								});
						};
						this.sqc.AddDelay(0.3);
						ao = this.sqc.AddTweenObj("miniquiz.GuessEvaluate.showcircles");
						ao.circlemov = GuessQuestionWindow.evaluationanimproperties.circle;
						ao.Start = function():* {
								this.AddTweenMaxFromTo(this.circlemov,0.3,{
										"visible":true,
										"alpha":0
								},{
										"alpha":1,
										"ease":Linear.easeNone
								});
						};
						this.sqc.AddDelay(0.7);
						ao = this.sqc.AddTweenObj("miniquiz.GuessEvaluate.showrating");
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
				
				public function GetPolarCoords(_angle:Number, _distance:Number) : Point {
						return new Point(-Math.cos(Math.PI * _angle / 180) * _distance + this.width / 2,-Math.sin(Math.PI * _angle / 180) * _distance + this.height / 2 - 30);
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
										"ease":Strong.easeOut,
										"onComplete":StartInput
								});
						});
				}
				
				public function Hide() : void {
						TweenMax.killTweensOf(this);
						this.InActivate();
						this.visible = false;
						GuessQuestionWindow.active = false;
				}
		}
}

