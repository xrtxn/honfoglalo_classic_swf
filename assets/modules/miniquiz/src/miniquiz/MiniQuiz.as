package miniquiz {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import components.WindowFrame;
		import flash.display.MovieClip;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol6")]
		public class MiniQuiz extends MovieClip {
				public static var mc:MiniQuiz = null;
				
				public static var winopened:Boolean = false;
				
				public static var isdatawaiting:Boolean = false;
				
				public static const NONE:uint = 0;
				
				public static const MC:uint = 1;
				
				public static const GUESS:uint = 2;
				
				public static const WELCOME:uint = 3;
				
				public static const FINISH:uint = 4;
				
				public static const CLOCKTIMEOUT:int = 15;
				
				public static var gameid:String = "-1";
				
				public static var questioncounter:int = 0;
				
				public static var openquestioncounter:int = 0;
				
				public var BACK:WindowFrame;
				
				public var BOUNDS:MovieClip;
				
				public var COMMENT:MovieClip;
				
				public var ERROR:MovieClip;
				
				public var PAGE:MovieClip;
				
				public var currentpage:MovieClip = null;
				
				public var currentpagenumber:int = -1;
				
				public var errorpanel:MovieClip = null;
				
				public var commentpanel:MovieClip = null;
				
				public function MiniQuiz() {
						super();
				}
				
				public static function ArriveData() : void {
						if(MiniQuiz.isdatawaiting) {
								WinMgr.WindowDataArrived(MiniQuiz.mc);
								MiniQuiz.isdatawaiting = false;
						}
				}
				
				public static function ShowCommentPanel(_anim:Boolean = true) : void {
						var p:CommentPanel = null;
						if(Boolean(MiniQuiz.mc) && !MiniQuiz.mc.commentpanel) {
								p = new CommentPanel(CommentPanel.VERDICT);
								p.Show(_anim);
								if(MiniQuiz.mc.currentpage) {
										Imitation.Combine(MiniQuiz.mc.currentpage,true);
								}
								MiniQuiz.mc.commentpanel = p;
								MiniQuiz.mc.COMMENT.addChild(MiniQuiz.mc.commentpanel);
						}
				}
				
				public static function HideCommentPanel() : void {
						if(MiniQuiz.mc) {
								MiniQuiz.mc.commentpanel.Hide();
								if(MiniQuiz.mc.currentpage) {
										Imitation.Combine(MiniQuiz.mc.currentpage,false);
								}
								Util.RemoveChildren(MiniQuiz.mc.COMMENT);
								MiniQuiz.mc.commentpanel = null;
						}
				}
				
				public static function ShowErrorPanel(_msg:String, _callback:Function = null, _anim:Boolean = true) : void {
						var p:ErrorPanel = null;
						if(Boolean(MiniQuiz.mc) && !MiniQuiz.mc.errorpanel) {
								p = new ErrorPanel();
								p.Show(_msg,_callback,_anim);
								if(MiniQuiz.mc.currentpage) {
										Imitation.Combine(MiniQuiz.mc.currentpage,true);
								}
								MiniQuiz.mc.errorpanel = p;
								MiniQuiz.mc.ERROR.addChild(MiniQuiz.mc.errorpanel);
						}
				}
				
				public static function HideErrorPanel() : void {
						if(MiniQuiz.mc) {
								if(MiniQuiz.mc.currentpage) {
										Imitation.Combine(MiniQuiz.mc.currentpage,false);
								}
								Util.RemoveChildren(MiniQuiz.mc.ERROR);
								MiniQuiz.mc.errorpanel = null;
						}
				}
				
				public static function OnLoadGameState(e:Object = null) : void {
						WinMgr.ShowLoadWait();
						JsQuery.Load(MiniQuiz.OnGameStateResult,[],Config.MINIQUIZ_PHP + "act=getgamestate&stoc=" + Config.stoc);
				}
				
				public static function OnGameStateResult(_jsq:Object, _draw:Boolean = true) : void {
						var q:Object = null;
						WinMgr.HideLoadWait();
						trace("OnGameStateResult: " + Util.FormatTrace(_jsq));
						if(Util.NumberVal(_jsq.error) <= 0) {
								if(_jsq.data.GAMESTATE) {
										MiniQuiz.gameid = Util.StringVal(_jsq.data.GAMESTATE.GAMEID);
										MiniQuiz.questioncounter = Util.NumberVal(_jsq.data.GAMESTATE.QCNT);
										MiniQuiz.openquestioncounter = Util.NumberVal(_jsq.data.GAMESTATE.OPENQCNT);
										if(_jsq.data.GAMESTATE.NEXTQUESTION === undefined) {
												MiniQuiz.OnCloseGame();
												MiniQuiz.mc.Draw(MiniQuiz.FINISH);
										} else {
												q = _jsq.data.GAMESTATE.NEXTQUESTION;
												if(Util.NumberVal(q.QTYPE) == MiniQuiz.MC) {
														MCQuestionWindow.question = q;
												} else if(Util.NumberVal(q.QTYPE) == MiniQuiz.GUESS) {
														GuessQuestionWindow.question = q;
												}
												if(_draw) {
														MiniQuiz.mc.currentpagenumber = MiniQuiz.NONE;
														MiniQuiz.mc.Draw(Util.NumberVal(q.QTYPE));
												}
										}
								} else {
										MiniQuiz.mc.Draw(MiniQuiz.FINISH);
								}
						}
				}
				
				public static function OnSendAnswer(_answer:int, _id:String, _time:int) : void {
						JsQuery.Load(MiniQuiz.OnAnswerResult,[],Config.MINIQUIZ_PHP + "act=questionanswer&stoc=" + Config.stoc + "&qid=" + _id + "&answer=" + _answer + "&atime=" + _time);
				}
				
				public static function OnAnswerResult(_jsq:Object) : void {
						WinMgr.HideLoadWait();
						trace("OnAnswerResult: " + Util.FormatTrace(_jsq));
						if(Util.NumberVal(_jsq.error) > 0) {
								MiniQuiz.ShowErrorPanel(Util.StringVal(_jsq.errormsg),MiniQuiz.mc.Hide);
						} else {
								if(MCQuestionWindow.active) {
										MCQuestionWindow.goodanswer = Util.StringVal(_jsq.data.GOODANSWER);
								} else {
										GuessQuestionWindow.goodanswer = Util.StringVal(_jsq.data.GOODANSWER);
								}
								if(Boolean(MiniQuiz.mc) && Boolean(MiniQuiz.mc.currentpage)) {
										MiniQuiz.mc.currentpage.PlayEvaluationAnim();
								}
						}
				}
				
				public static function OnSendRating(_id:String, _rating:uint, _wrongmark:int, _comment:String) : void {
						JsQuery.Load(MiniQuiz.OnRatingResult,[],Config.MINIQUIZ_PHP + "act=questionrating&stoc=" + Config.stoc + "&qid=" + _id + "&rating=" + _rating + "&wrmark=" + _wrongmark + "&comment=" + _comment);
				}
				
				public static function OnRatingResult(_jsq:Object) : void {
						WinMgr.HideLoadWait();
						trace("OnRatingResult: " + Util.FormatTrace(_jsq));
						if(Util.NumberVal(_jsq.error) > 0) {
								MiniQuiz.ShowErrorPanel(Util.StringVal(_jsq.errormsg),MiniQuiz.mc.Hide);
						} else {
								MiniQuiz.OnGameStateResult(_jsq);
						}
				}
				
				public static function AskNeverShow() : void {
						Modules.GetClass("uibase","uibase.MessageWin").Show(Lang.Get("qprgame_title"),Lang.Get("qprgame_turnback_info"),MiniQuiz.OnSendAbort);
				}
				
				public static function OnSendAbort() : void {
						JsQuery.Load(MiniQuiz.OnAbortResult,[],Config.MINIQUIZ_PHP + "act=abortgame&stoc=" + Config.stoc + "&gameid=" + MiniQuiz.gameid);
				}
				
				public static function OnAbortResult(_jsq:Object) : void {
						WinMgr.HideLoadWait();
						trace("OnAbortResult: " + Util.FormatTrace(_jsq));
						MiniQuiz.mc.Hide();
				}
				
				public static function OnCloseGame() : void {
						JsQuery.Load(MiniQuiz.OnCloseResult,[],Config.MINIQUIZ_PHP + Sys.FormatGetParamsStoc({},true),{
								"cmd":"close_game",
								"gameid":MiniQuiz.gameid
						});
				}
				
				public static function OnCloseResult(_jsq:Object) : void {
						trace("OnCloseResult: " + Util.FormatTrace(_jsq));
				}
				
				public function Prepare(aparams:Object) : void {
						Util.StopAllChildrenMov(this);
						MiniQuiz.isdatawaiting = false;
						aparams.waitfordata = false;
						this.Draw(MiniQuiz.WELCOME);
				}
				
				public function AfterOpen() : void {
						MiniQuiz.winopened = true;
				}
				
				public function Draw(_pagenumber:Number) : void {
						if(this.currentpagenumber != _pagenumber) {
								this.currentpagenumber = _pagenumber;
								TweenMax.killTweensOf(this);
								this.HidePages();
								if(this.currentpagenumber == MiniQuiz.WELCOME) {
										this.currentpage = new CommentPanel(CommentPanel.WELCOME);
								} else if(this.currentpagenumber == MiniQuiz.FINISH) {
										this.currentpage = new CommentPanel(CommentPanel.FINISH);
								} else if(this.currentpagenumber == MiniQuiz.MC) {
										this.currentpage = new MCQuestionWindow();
								} else if(this.currentpagenumber == MiniQuiz.GUESS) {
										this.currentpage = new GuessQuestionWindow();
								}
								if(this.currentpage) {
										this.PAGE.addChild(this.currentpage);
										this.currentpage.Show();
								}
						}
				}
				
				private function HidePages() : void {
						if(this.currentpage) {
								this.currentpage.Hide();
								this.currentpage = null;
						}
						Util.RemoveChildren(this.PAGE);
				}
				
				public function Hide(e:Object = null) : void {
						TweenMax.killTweensOf(this);
						MiniQuiz.mc.currentpage = null;
						MiniQuiz.mc.currentpagenumber = MiniQuiz.NONE;
						WinMgr.CloseWindow(this);
				}
		}
}

