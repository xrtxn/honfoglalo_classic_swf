package knightgame {
		import com.adobe.serialization.json.ADOBEJSON;
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import components.ButtonComponent;
		import flash.display.MovieClip;
		import flash.events.*;
		import flash.net.URLLoader;
		import flash.net.URLRequest;
		import flash.utils.Timer;
		import flash.utils.getTimer;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol284")]
		public class Knightgame extends MovieClip {
				private static var mc:Knightgame = null;
				
				public var ANIM:MovieClip;
				
				public var BOUNDS:MovieClip;
				
				public var BTNCLOSE:ButtonComponent;
				
				public var COUNTDOWN:MovieClip;
				
				public var ENEMYFLYPOINTS:MovieClip;
				
				public var FLYPOINTS:MovieClip;
				
				public var GAMEENDWIN:MovieClip;
				
				public var GAMETIMEMC:MovieClip;
				
				public var LEFTBAR:MovieClip;
				
				public var OPENGRAPH:MovieClip;
				
				public var POINTS1:MovieClip;
				
				public var POINTS2:MovieClip;
				
				public var QATABLE:MovieClip;
				
				public var RIGHTBAR:MovieClip;
				
				public var SBTN:ButtonComponent;
				
				public var WINBG:MovieClip;
				
				private var jsonData:Object;
				
				private var jsonArray:Array;
				
				public var gameTime:Number = 30;
				
				private var questionAnimTime:Number = 0.1;
				
				private var flyingPointsAnimTime:Number = 0.5;
				
				private var winner:String = "LEFT";
				
				private var actQA:Array;
				
				private var actPoints:int = 0;
				
				private var actEnemyPoints:int = 0;
				
				private var origPointsVariable:int = 5;
				
				private var pointsVariable:int = 0;
				
				private var enemyOrigPointsVariable:int = 5;
				
				private var enemyPointsVariable:int = 0;
				
				private var gameStartedTime:Number;
				
				private var gameActivities:Array;
				
				private var countdownTimer:Timer;
				
				private var gameTimer:Timer;
				
				private var countdownTime:Number = 5;
				
				private var gameStatus:int = 0;
				
				private var enemyActivities:Array;
				
				private var enemyEmulatorTimer:Timer;
				
				public function Knightgame() {
						this.questionAnimTime = 0.1;
						this.flyingPointsAnimTime = 0.5;
						this.jsonData = new Object();
						this.jsonArray = new Array();
						super();
						this.__setProp_BTNCLOSE__knightgamemainmc_BTNS_0();
						this.__setProp_SBTN__knightgamemainmc_BTNS_0();
				}
				
				public static function ObjectTrace(_obj:Object, sPrefix:String = "") : void {
						var i:* = undefined;
						if(sPrefix == "") {
								sPrefix = "-->";
						} else {
								sPrefix += " -->";
						}
						for(i in _obj) {
								trace(sPrefix,i + ":" + _obj[i]," ");
								if(typeof _obj[i] == "object") {
										ObjectTrace(_obj[i],sPrefix);
								}
						}
				}
				
				public function DrawScreens(_status:int = 10) : void {
						this.gameStatus = _status;
						if(this.gameStatus == 0) {
								this.ShowOpenGraph();
								this.HideCloseButton();
								this.ShowAnim();
								this.HideGameTime();
								this.HidePoints();
								this.HideCountdown();
								this.SetupButtons();
								this.HideQATable();
								this.HideFlyPoint();
								this.HideEnemyFlyPoint();
								this.HideGameEndWin();
								this.HideCountdown();
								this.HideSBTN();
								this.HidePowerBars();
						} else if(this.gameStatus == 10) {
								this.ShowCloseButton();
								this.ShowOpenGraph();
								this.ShowAnim();
								this.AnimReset();
								this.HideGameTime();
								this.HidePoints();
								this.HideCountdown();
								this.HideQATable();
								this.HideFlyPoint();
								this.HideEnemyFlyPoint();
								this.HideGameEndWin();
								this.HideCountdown();
								this.ShowSBTN();
								this.HidePowerBars();
						} else if(this.gameStatus == 20) {
								this.HideCloseButton();
								this.HideOpenGraph();
								this.ShowCountdown();
								this.StartCountdown();
								this.ShowAnim();
								this.HideSBTN();
								this.HideGameTime();
								this.HidePoints();
								this.HideQATable();
								this.HideFlyPoint();
								this.HideEnemyFlyPoint();
								this.HideGameEndWin();
								this.HidePowerBars();
						} else if(this.gameStatus == 30) {
								this.HideCloseButton();
								this.ShowAnim();
								this.HideOpenGraph();
								this.HideSBTN();
								this.ShowGameTime();
								this.DrawGameTime();
								this.ShowPoints();
								this.HideCountdown();
								this.HideFlyPoint();
								this.HideEnemyFlyPoint();
								this.ResetPoints();
								this.ShowQATable();
								this.ChangeQuestion();
								this.HideGameEndWin();
								this.StartGame();
								this.EnemyEmulatorReset();
								this.EnemyEmulatorGenerate();
								this.EnemyEmulatorStart();
								this.ShowPowerBars();
						} else if(this.gameStatus == 40) {
								this.HideCloseButton();
								this.HideOpenGraph();
								this.DisableAButtons();
								this.HideQATable();
								this.ShowGameEndWin();
								this.HidePowerBars();
						}
						Imitation.FreeBitmapAll(this);
						Imitation.UpdateAll();
				}
				
				public function Prepare(aparams:Object) : void {
						this.SBTN.SetEnabled(false);
						this.JSONLoad();
						this.DrawScreens(0);
						this.BOUNDS.visible = false;
				}
				
				public function AfterOpen() : void {
						this.ANIM.LEFTKNIGHT.ox = this.ANIM.LEFTKNIGHT.x;
						this.ANIM.RIGHTKNIGHT.ox = this.ANIM.RIGHTKNIGHT.x;
						this.QATABLE.QUESTION.oy = this.QATABLE.QUESTION.y;
						this.QATABLE.ANSWER1.oy = this.QATABLE.ANSWER1.y;
						this.QATABLE.ANSWER2.oy = this.QATABLE.ANSWER2.y;
						this.QATABLE.ANSWER3.oy = this.QATABLE.ANSWER3.y;
						this.QATABLE.ANSWER4.oy = this.QATABLE.ANSWER4.y;
						this.POINTS1.oy = this.POINTS1.y;
						this.POINTS2.oy = this.POINTS2.y;
						this.DrawScreens(10);
				}
				
				public function AfterClose() : void {
				}
				
				public function Hide(e:* = null) : void {
						WinMgr.CloseWindow(this);
				}
				
				private function SetupButtons() : void {
						this.BTNCLOSE.AddEventClick(this.Hide);
						this.BTNCLOSE.SetCaption("X");
						this.SBTN.AddEventClick(this.OnStartButtonClick);
						this.SBTN.SetCaption("START");
						this.GAMEENDWIN.CLOSEBTN.AddEventClick(this.GameEndWinCloseListener);
						this.GAMEENDWIN.CLOSEBTN.SetCaption("CLOSE");
						Imitation.AddEventClick(this.QATABLE.ANSWER1,this.QATableAnswerClick);
						Imitation.AddEventClick(this.QATABLE.ANSWER2,this.QATableAnswerClick);
						Imitation.AddEventClick(this.QATABLE.ANSWER3,this.QATableAnswerClick);
						Imitation.AddEventClick(this.QATABLE.ANSWER4,this.QATableAnswerClick);
						this.QATABLE.SKIPBTN.AddEventClick(this.SkipButtonClick);
						this.QATABLE.SKIPBTN.SetCaption("SKIP");
				}
				
				private function ShowPowerBars() : void {
						this.LEFTBAR.visible = true;
						this.RIGHTBAR.visible = true;
				}
				
				private function HidePowerBars() : void {
						this.LEFTBAR.visible = false;
						this.RIGHTBAR.visible = false;
				}
				
				private function ShowCloseButton() : void {
						this.BTNCLOSE.visible = true;
				}
				
				private function HideCloseButton() : void {
						this.BTNCLOSE.visible = false;
				}
				
				private function HideCountdown() : void {
						this.COUNTDOWN.visible = false;
				}
				
				private function ShowCountdown() : void {
						this.COUNTDOWN.visible = true;
				}
				
				private function HideAnim() : void {
						this.ANIM.visible = false;
				}
				
				private function ShowAnim() : void {
						this.ANIM.visible = true;
				}
				
				private function HideSBTN() : void {
						this.SBTN.visible = false;
				}
				
				private function ShowSBTN() : void {
						this.SBTN.visible = true;
				}
				
				private function ShowOpenGraph() : void {
						this.OPENGRAPH.visible = true;
				}
				
				private function HideOpenGraph() : void {
						this.OPENGRAPH.visible = false;
				}
				
				private function OnStartButtonClick(e:Object) : void {
						this.DrawScreens(20);
				}
				
				private function StartCountdown() : void {
						this.countdownTimer = new Timer(1000,this.countdownTime);
						this.countdownTimer.addEventListener(TimerEvent.TIMER,this.CountdownTimerListener);
						this.countdownTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.CountdownTimerCompleteListener);
						this.countdownTimer.start();
						this.COUNTDOWN.FIELD.text = this.countdownTime;
				}
				
				private function CountdownTimerCompleteListener(e:TimerEvent) : void {
						this.DrawScreens(30);
				}
				
				private function CountdownTimerListener(e:TimerEvent) : void {
						this.COUNTDOWN.FIELD.text = this.countdownTime - this.countdownTimer.currentCount;
				}
				
				private function StartGame() : void {
						TweenMax.killTweensOf(this.ANIM.LEFTKNIGHT);
						TweenMax.killTweensOf(this.ANIM.RIGHTKNIGHT);
						TweenMax.fromTo(this.ANIM.LEFTKNIGHT,this.gameTime,{"x":this.ANIM.LEFTKNIGHT.ox},{
								"x":-30,
								"ease":Linear.easeNone,
								"onComplete":this.AnimEnd
						});
						TweenMax.fromTo(this.ANIM.RIGHTKNIGHT,this.gameTime,{"x":this.ANIM.RIGHTKNIGHT.ox},{
								"x":30,
								"ease":Linear.easeNone,
								"onComplete":null
						});
						this.ANIM.LEFTKNIGHT.gotoAndPlay("RUN");
						this.ANIM.RIGHTKNIGHT.gotoAndPlay("RUN");
						this.gameStartedTime = getTimer();
						this.gameActivities = new Array();
				}
				
				private function AnimReset() : void {
						this.ANIM.LEFTKNIGHT.gotoAndStop("STAND");
						this.ANIM.RIGHTKNIGHT.gotoAndStop("STAND");
						this.ANIM.LEFTKNIGHT.x = this.ANIM.LEFTKNIGHT.ox;
						this.ANIM.RIGHTKNIGHT.x = this.ANIM.RIGHTKNIGHT.ox;
				}
				
				private function AnimEnd() : void {
						this.ANIM.BIGBADABOOM.gotoAndPlay(2);
						this.ANIM.LEFTKNIGHT.gotoAndStop("STAND");
						this.ANIM.RIGHTKNIGHT.gotoAndStop("STAND");
						if(this.winner == "LEFT") {
								this.ANIM.RIGHTKNIGHT.gotoAndPlay("BOOM");
						} else if(this.winner == "RIGHT") {
								this.ANIM.LEFTKNIGHT.gotoAndPlay("BOOM");
						} else if(this.winner == "EQ") {
								this.ANIM.LEFTKNIGHT.gotoAndPlay("BOOM");
								this.ANIM.RIGHTKNIGHT.gotoAndPlay("BOOM");
						}
						this.DrawScreens(40);
				}
				
				private function HideQATable() : void {
						this.QATABLE.visible = false;
				}
				
				private function ShowQATable(_data:Array = null) : void {
						this.QATABLE.visible = true;
				}
				
				private function DisableAButtons() : void {
						this.QATABLE.ANSWER1.enabled = false;
						this.QATABLE.ANSWER2.enabled = false;
						this.QATABLE.ANSWER3.enabled = false;
						this.QATABLE.ANSWER4.enabled = false;
						this.QATABLE.SKIPBTN.enabled = false;
				}
				
				private function EnableAButtons() : void {
						this.QATABLE.ANSWER1.enabled = true;
						this.QATABLE.ANSWER2.enabled = true;
						this.QATABLE.ANSWER3.enabled = true;
						this.QATABLE.ANSWER4.enabled = true;
						this.QATABLE.SKIPBTN.enabled = true;
				}
				
				private function ChangeQuestion() : void {
						this.DisableAButtons();
						this.actQA = new Array();
						var actQAData:Object = this.jsonArray[Math.round(Math.random() * (this.jsonArray.length - 1))];
						this.actQA.push({
								"text":actQAData.question,
								"flag":false
						});
						this.actQA.push({
								"text":actQAData.a1,
								"flag":true
						});
						this.actQA.push({
								"text":actQAData.a2,
								"flag":false
						});
						this.actQA.push({
								"text":actQAData.a3,
								"flag":false
						});
						this.actQA.push({
								"text":actQAData.a4,
								"flag":false
						});
						TweenMax.to(this.QATABLE.QUESTION,this.questionAnimTime,{
								"delay":0,
								"ease":Sine.easeOut,
								"alpha":0.5,
								"repeat":1,
								"yoyo":true,
								"onRepeat":this.QC,
								"onComplete":this.QATableReady
						});
						TweenMax.to(this.QATABLE.ANSWER1,this.questionAnimTime,{
								"y":this.QATABLE.ANSWER1.oy - 50,
								"scaleY":0,
								"delay":0.05,
								"ease":Sine.easeOut,
								"alpha":0,
								"repeat":1,
								"yoyo":true,
								"onRepeat":this.QARepeat,
								"onRepeatParams":[1]
						});
						TweenMax.to(this.QATABLE.ANSWER2,this.questionAnimTime,{
								"y":this.QATABLE.ANSWER2.oy - 50,
								"scaleY":0,
								"delay":0.1,
								"ease":Sine.easeOut,
								"alpha":0,
								"repeat":1,
								"yoyo":true,
								"onRepeat":this.QARepeat,
								"onRepeatParams":[2]
						});
						TweenMax.to(this.QATABLE.ANSWER3,this.questionAnimTime,{
								"y":this.QATABLE.ANSWER3.oy - 50,
								"scaleY":0,
								"delay":0.15,
								"ease":Sine.easeOut,
								"alpha":0,
								"repeat":1,
								"yoyo":true,
								"onRepeat":this.QARepeat,
								"onRepeatParams":[3]
						});
						TweenMax.to(this.QATABLE.ANSWER4,this.questionAnimTime,{
								"y":this.QATABLE.ANSWER4.oy - 50,
								"scaleY":0,
								"delay":0.2,
								"ease":Sine.easeOut,
								"alpha":0,
								"repeat":1,
								"yoyo":true,
								"onRepeat":this.QARepeat,
								"onRepeatParams":[4]
						});
				}
				
				private function QC() : void {
						this.QATABLE.QUESTION.FIELD.text = this.actQA[0].text;
						if(this.QATABLE.QUESTION.FIELD.numLines > 1) {
								this.QATABLE.QUESTION.FIELD.y = -23;
						} else {
								this.QATABLE.QUESTION.FIELD.y = -13;
						}
				}
				
				private function QARepeat(_param:*) : void {
						this.QATABLE["ANSWER" + _param].FIELD.text = this.actQA[_param].text;
						this.QATABLE["ANSWER" + _param].flag = this.actQA[_param].flag;
						if(this.QATABLE["ANSWER" + _param].FIELD.numLines > 1) {
								this.QATABLE["ANSWER" + _param].FIELD.y = -25;
						} else {
								this.QATABLE["ANSWER" + _param].FIELD.y = -12;
						}
				}
				
				private function QATableReady() : void {
						this.EnableAButtons();
				}
				
				private function QATableAnswerClick(e:Object) : void {
						if(e.target.enabled) {
								this.gameActivities.push({
										"time":(getTimer() - this.gameStartedTime) / 1000,
										"flag":e.target.flag,
										"skip":false
								});
								this.SetPoints(e.target.flag);
								this.FlyAPoint(e.stageX - x,e.stageY - y,e.target.flag);
								this.ChangeQuestion();
						}
				}
				
				private function SkipButtonClick(e:Object) : void {
						if(e.target.enabled) {
								this.gameActivities.push({
										"time":(getTimer() - this.gameStartedTime) / 1000,
										"flag":null,
										"skip":true
								});
								this.FlyAPoint(e.stageX - x,e.stageY - y,false,true);
								TweenMax.delayedCall(this.flyingPointsAnimTime,this.AnimatePoints);
								this.ChangeQuestion();
						}
				}
				
				private function ResetPoints() : void {
						this.pointsVariable = 0;
						this.enemyPointsVariable = 0;
						this.actPoints = 0;
						this.actEnemyPoints = 0;
						this.POINTS1.FIELD.text = this.actPoints;
						this.POINTS2.FIELD.text = this.actEnemyPoints;
						this.LEFTBAR.scaleX = 1;
						this.RIGHTBAR.scaleX = 1;
						this.LEFTBAR.gotoAndStop(1);
						this.RIGHTBAR.gotoAndStop(1);
						Imitation.FreeBitmapAll(this.RIGHTBAR);
						Imitation.UpdateAll(this.RIGHTBAR);
						Imitation.FreeBitmapAll(this.LEFTBAR);
						Imitation.UpdateAll(this.LEFTBAR);
						this.SetWinner();
				}
				
				private function ShowPoints() : void {
						this.POINTS1.visible = true;
						this.POINTS2.visible = true;
				}
				
				private function HidePoints() : void {
						this.POINTS1.visible = false;
						this.POINTS2.visible = false;
				}
				
				private function SetPoints(_param:Boolean) : void {
						if(_param) {
								this.pointsVariable += this.origPointsVariable;
								this.actPoints += this.pointsVariable;
						} else {
								this.pointsVariable = 0;
						}
						TweenMax.delayedCall(this.flyingPointsAnimTime,this.DrawPoints);
						TweenMax.delayedCall(this.flyingPointsAnimTime,this.AnimatePoints);
						this.SetWinner();
				}
				
				private function DrawPoints() : void {
						this.POINTS1.FIELD.text = this.actPoints;
						var s:Number = 1 + this.actPoints / 100;
						if(this.ANIM.LEFTKNIGHT.DUST1) {
								this.ANIM.LEFTKNIGHT.DUST1.scaleX = s;
								this.ANIM.LEFTKNIGHT.DUST1.scaleY = s;
								this.ANIM.LEFTKNIGHT.DUST2.scaleX = s;
								this.ANIM.LEFTKNIGHT.DUST2.scaleY = s;
						}
						this.CheckPowerBars();
						this.LEFTBAR.scaleX = 1 + this.actPoints / 100;
				}
				
				private function AnimatePoints() : void {
						TweenMax.fromTo(this.POINTS1,0.2,{"y":this.POINTS1.oy},{
								"y":this.POINTS1.oy - 10,
								"yoyo":true,
								"repeat":1,
								"ease":Sine.easeOut
						});
				}
				
				private function CheckPowerBars() : void {
						if(this.actPoints > this.actEnemyPoints) {
								this.LEFTBAR.gotoAndStop(2);
								this.RIGHTBAR.gotoAndStop(1);
						} else if(this.actPoints < this.actEnemyPoints) {
								this.LEFTBAR.gotoAndStop(1);
								this.RIGHTBAR.gotoAndStop(2);
						} else if(this.actPoints == this.actEnemyPoints) {
								this.LEFTBAR.gotoAndStop(1);
								this.RIGHTBAR.gotoAndStop(1);
						}
						Imitation.FreeBitmapAll(this.RIGHTBAR);
						Imitation.UpdateAll(this.RIGHTBAR);
						Imitation.FreeBitmapAll(this.LEFTBAR);
						Imitation.UpdateAll(this.LEFTBAR);
				}
				
				private function DrawEnemyPoints() : void {
						this.POINTS2.FIELD.text = this.actEnemyPoints;
						var s:Number = 1 + this.actEnemyPoints / 100;
						if(this.ANIM.RIGHTKNIGHT.DUST1) {
								this.ANIM.RIGHTKNIGHT.DUST1.scaleX = s;
								this.ANIM.RIGHTKNIGHT.DUST1.scaleY = s;
								this.ANIM.RIGHTKNIGHT.DUST2.scaleX = s;
								this.ANIM.RIGHTKNIGHT.DUST2.scaleY = s;
						}
						this.CheckPowerBars();
						this.RIGHTBAR.scaleX = 1 + this.actEnemyPoints / 100;
				}
				
				private function AnimateEnemyPoints() : void {
						TweenMax.fromTo(this.POINTS2,0.2,{"y":this.POINTS2.oy},{
								"y":this.POINTS2.oy - 10,
								"yoyo":true,
								"repeat":1,
								"ease":Sine.easeOut
						});
				}
				
				private function SetEnemyPoints(_param:Boolean) : void {
						if(_param) {
								this.enemyPointsVariable += this.enemyOrigPointsVariable;
								this.actEnemyPoints += this.enemyPointsVariable;
						} else {
								this.enemyPointsVariable = 0;
						}
						TweenMax.delayedCall(this.flyingPointsAnimTime,this.DrawEnemyPoints);
						this.SetWinner();
				}
				
				private function SetWinner() : void {
						if(this.actPoints == this.actEnemyPoints) {
								this.winner = "EQ";
						} else if(this.actPoints > this.actEnemyPoints) {
								this.winner = "LEFT";
						} else {
								this.winner = "RIGHT";
						}
				}
				
				private function ShowGameTime() : void {
						this.GAMETIMEMC.visible = true;
				}
				
				private function HideGameTime() : void {
						this.GAMETIMEMC.visible = false;
				}
				
				private function DrawGameTime() : void {
						this.gameTimer = new Timer(1000,this.gameTime);
						this.gameTimer.addEventListener(TimerEvent.TIMER,this.GameTimerListener);
						this.gameTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.GameTimerCompleteListener);
						this.gameTimer.start();
						this.GAMETIMEMC.FIELD.text = this.gameTime;
				}
				
				private function GameTimerCompleteListener(e:TimerEvent) : void {
				}
				
				private function GameTimerListener(e:TimerEvent) : void {
						this.GAMETIMEMC.FIELD.text = this.gameTime - this.gameTimer.currentCount;
				}
				
				private function HideFlyPoint() : void {
						this.FLYPOINTS.visible = false;
				}
				
				private function HideEnemyFlyPoint() : void {
						this.ENEMYFLYPOINTS.visible = false;
				}
				
				private function FlyAPoint(_mousex:Number, _mousey:Number, flag:Boolean = true, skip:Boolean = false) : void {
						this.FLYPOINTS.visible = true;
						this.FLYPOINTS.x = _mousex;
						this.FLYPOINTS.y = _mousey;
						if(skip) {
								this.FLYPOINTS.gotoAndStop(3);
								this.FLYPOINTS.FIELD.text = 0;
						} else if(flag) {
								this.FLYPOINTS.gotoAndStop(1);
								this.FLYPOINTS.FIELD.text = this.pointsVariable;
						} else {
								this.FLYPOINTS.gotoAndStop(2);
								this.FLYPOINTS.FIELD.text = 0;
						}
						Imitation.FreeBitmapAll(this.FLYPOINTS);
						TweenMax.fromTo(this.FLYPOINTS,this.flyingPointsAnimTime,{
								"alpha":0.5,
								"x":_mousex,
								"y":_mousey
						},{
								"alpha":1,
								"x":this.POINTS1.x,
								"y":this.POINTS1.y + this.POINTS1.height + this.FLYPOINTS.height / 2,
								"ease":Sine.easeOut,
								"onComplete":this.FlyAPointReady
						});
				}
				
				private function FlyAPointReady() : void {
						TweenMax.to(this.FLYPOINTS,0.2,{
								"alpha":0,
								"y":this.FLYPOINTS.y + 20,
								"ease":Linear.easeIn,
								"onComplete":this.HideFlyPoint
						});
				}
				
				private function FlyEnemyPoint(_mousex:Number, _mousey:Number, flag:Boolean = true, skip:Boolean = false) : void {
						this.ENEMYFLYPOINTS.visible = true;
						this.ENEMYFLYPOINTS.x = _mousex;
						this.ENEMYFLYPOINTS.y = _mousey;
						if(skip) {
								this.ENEMYFLYPOINTS.gotoAndStop(3);
								this.ENEMYFLYPOINTS.FIELD.text = 0;
						} else if(flag) {
								this.ENEMYFLYPOINTS.gotoAndStop(1);
								this.ENEMYFLYPOINTS.FIELD.text = this.enemyPointsVariable;
						} else {
								this.ENEMYFLYPOINTS.gotoAndStop(2);
								this.ENEMYFLYPOINTS.FIELD.text = 0;
						}
						Imitation.FreeBitmapAll(this.ENEMYFLYPOINTS);
						TweenMax.fromTo(this.ENEMYFLYPOINTS,this.flyingPointsAnimTime,{
								"alpha":0.5,
								"x":_mousex,
								"y":_mousey
						},{
								"alpha":1,
								"x":this.POINTS2.x,
								"y":this.POINTS2.y + this.POINTS2.height + this.ENEMYFLYPOINTS.height / 2,
								"ease":Sine.easeOut,
								"onComplete":this.FlyEnemyPointReady
						});
				}
				
				private function FlyEnemyPointReady() : void {
						TweenMax.to(this.ENEMYFLYPOINTS,0.2,{
								"alpha":0,
								"y":this.ENEMYFLYPOINTS.y + 20,
								"ease":Linear.easeIn,
								"onComplete":this.HideEnemyFlyPoint
						});
				}
				
				private function HideGameEndWin() : void {
						this.GAMEENDWIN.visible = false;
				}
				
				private function GameEndWinCloseListener(e:Object) : void {
						this.DrawScreens(10);
				}
				
				private function ShowGameEndWin() : void {
						var i:int = 0;
						var sig:MovieClip = null;
						if(this.GAMEENDWIN.getChildByName("sigs")) {
								this.GAMEENDWIN.removeChild(this.GAMEENDWIN.getChildByName("sigs"));
						}
						var s:MovieClip = new MovieClip();
						s.name = "sigs";
						this.GAMEENDWIN.addChild(s);
						var g:int = 0;
						var b:int = 0;
						var sk:int = 0;
						i = 0;
						while(i < this.gameActivities.length) {
								if(this.gameActivities[i].skip) {
										sig = new Sigskip();
										sk++;
								} else if(this.gameActivities[i].flag) {
										sig = new Siggreen();
										g++;
								} else {
										sig = new Sigred();
										b++;
								}
								s.addChild(sig);
								sig.y = this.GAMEENDWIN.BAR.y;
								sig.x = this.GAMEENDWIN.BAR.x + this.GAMEENDWIN.BAR.width / this.gameTime * this.gameActivities[i].time;
								sig.name = "sig" + i;
								i++;
						}
						this.GAMEENDWIN.visible = true;
						this.GAMEENDWIN.ALLFIELD.text = "Az összes válaszod: " + this.gameActivities.length;
						this.GAMEENDWIN.GOODFIELD.text = "Helyes válaszaid: " + g;
						this.GAMEENDWIN.BADFIELD.text = "Helytelen válaszaid: " + b;
						this.GAMEENDWIN.SKIPFIELD.text = "Kihagyott válaszaid: " + sk;
						this.GAMEENDWIN.POINTSFIELD.text = "Elért pontjaid: " + this.actPoints;
						g = 0;
						b = 0;
						sk = 0;
						i = 1;
						while(i < this.enemyActivities.length) {
								if(this.enemyActivities[i].skip) {
										sig = new Sigskip();
										sk++;
								} else if(this.enemyActivities[i].flag) {
										sig = new Siggreen();
										g++;
								} else {
										sig = new Sigred();
										b++;
								}
								s.addChild(sig);
								sig.y = this.GAMEENDWIN.EBAR.y;
								sig.x = this.GAMEENDWIN.EBAR.x + this.GAMEENDWIN.EBAR.width / this.gameTime * this.enemyActivities[i].time;
								sig.name = "esig" + i;
								i++;
						}
						this.GAMEENDWIN.EALLFIELD.text = "Az ellenfél összes válasza: " + (this.enemyActivities.length - 1);
						this.GAMEENDWIN.EGOODFIELD.text = "Helyes válaszai: " + g;
						this.GAMEENDWIN.EBADFIELD.text = "Helytelen válaszai: " + b;
						this.GAMEENDWIN.ESKIPFIELD.text = "Kihagyott válaszai: " + sk;
						this.GAMEENDWIN.EPOINTSFIELD.text = "Elért pontjai: " + this.actEnemyPoints;
				}
				
				private function EnemyEmulatorReset() : void {
						this.enemyActivities = new Array();
						if(this.enemyEmulatorTimer) {
								this.enemyEmulatorTimer.reset();
						} else {
								this.enemyEmulatorTimer = new Timer(3000,Math.floor(this.gameTime / 3));
								this.enemyEmulatorTimer.addEventListener(TimerEvent.TIMER,this.EnemyEmulatorTimerListener);
						}
				}
				
				private function EnemyEmulatorGenerate() : void {
						var flag:Boolean = false;
						var skip:Boolean = false;
						var i:int = 0;
						var skipnum:int = 0;
						this.enemyActivities = new Array();
						this.enemyActivities.push({
								"time":0,
								"flag":false,
								"skip":false
						});
						i = 1;
						while(i <= this.gameTime) {
								flag = false;
								skipnum = Util.Random(5,0);
								if(skipnum <= 1) {
										skip = true;
								} else {
										skip = false;
								}
								if(!skip) {
										flag = Boolean(Math.round(Math.random() * 4));
								}
								this.enemyActivities.push({
										"time":i,
										"flag":flag,
										"skip":skip
								});
								i++;
						}
				}
				
				private function EnemyEmulatorStart() : void {
						this.enemyEmulatorTimer.start();
				}
				
				private function EnemyEmulatorTimerListener(e:TimerEvent) : void {
						if(!this.enemyActivities[this.enemyEmulatorTimer.currentCount].skip) {
								this.SetEnemyPoints(this.enemyActivities[this.enemyEmulatorTimer.currentCount].flag);
						}
						this.FlyEnemyPoint(this.POINTS2.x,this.POINTS2.y + 300,this.enemyActivities[this.enemyEmulatorTimer.currentCount].flag,this.enemyActivities[this.enemyEmulatorTimer.currentCount].skip);
						TweenMax.delayedCall(this.flyingPointsAnimTime,this.AnimateEnemyPoints);
				}
				
				private function GenerateString(size:uint) : String {
						var returnString:String = new String();
						var a:uint = 0;
						while(a < size) {
								returnString += "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ".charAt(Math.floor(Math.random() * "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ".length));
								a++;
						}
						return returnString;
				}
				
				private function JSONLoad() : void {
						var jsonLoader:URLLoader = new URLLoader();
						jsonLoader.addEventListener(Event.COMPLETE,this.JSONOnLoad);
						jsonLoader.load(new URLRequest("client/fake_kg_questions.txt"));
				}
				
				private function JSONOnLoad(event:Event) : void {
						var s:String = null;
						trace("JSONOnLoad");
						this.jsonData = ADOBEJSON.decode(event.target.data);
						for(s in this.jsonData) {
								this.jsonArray.push(this.jsonData[s]);
						}
						this.SBTN.SetEnabled(true);
				}
				
				internal function __setProp_BTNCLOSE__knightgamemainmc_BTNS_0() : * {
						try {
								this.BTNCLOSE["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTNCLOSE.enabled = true;
						this.BTNCLOSE.fontsize = "BIG";
						this.BTNCLOSE.icon = "X";
						this.BTNCLOSE.skin = "CANCEL";
						this.BTNCLOSE.testcaption = "X";
						this.BTNCLOSE.visible = true;
						this.BTNCLOSE.wordwrap = false;
						try {
								this.BTNCLOSE["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
				
				internal function __setProp_SBTN__knightgamemainmc_BTNS_0() : * {
						try {
								this.SBTN["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.SBTN.enabled = true;
						this.SBTN.fontsize = "BIG";
						this.SBTN.icon = "";
						this.SBTN.skin = "OK";
						this.SBTN.testcaption = "";
						this.SBTN.visible = true;
						this.SBTN.wordwrap = false;
						try {
								this.SBTN["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

