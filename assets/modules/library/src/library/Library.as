package library {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import components.ButtonComponent;
		import flash.display.MovieClip;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol393")]
		public class Library extends MovieClip {
				public static var PAGE_THEMES:Array = [0,1,2,3,4,5,6,7,8,9,10];
				
				public static var mc:Library = null;
				
				public static var winopened:Boolean = false;
				
				public static var isdatawaiting:Boolean = false;
				
				public static var NONE:uint = 0;
				
				public static var USER_QUESTIONS:uint = 1;
				
				public static var USER_QUESTION_EDIT:uint = 2;
				
				public static var USER_QUESTION_STATS:uint = 3;
				
				public static var firstwarningshwon:Boolean = false;
				
				public static var themes:Array = [];
				
				public static var defaultthemeid:uint = 1;
				
				public var BACK:MovieClip;
				
				public var BOUNDS:MovieClip;
				
				public var BTN_CLOSE:ButtonComponent;
				
				public var PAGE:MovieClip;
				
				public var WARNING:WarningPanel;
				
				public var currentpage:MovieClip = null;
				
				public var currentpagenumber:Number = 0;
				
				public function Library() {
						super();
						this.__setProp_BTN_CLOSE_LibraryWindowMov_buttons_0();
				}
				
				public static function ArriveData() : void {
						if(Library.isdatawaiting) {
								WinMgr.WindowDataArrived(Library.mc);
								Library.isdatawaiting = false;
						}
				}
				
				public static function ProcessThemes(_data:Object) : void {
						var id:String = null;
						var n:uint = 0;
						Library.defaultthemeid = 1;
						var p:Object = {
								"CURW":0,
								"CURQ":0,
								"CURF":0,
								"LASTQ":0,
								"LASTF":0,
								"LASTG":0,
								"ALLQ":0,
								"ALLF":0,
								"ALLG":0
						};
						Library.themes = [p];
						for(var i:uint = 1; i <= 10; Library.themes[i] = {"questions":[]},i++) {
						}
						for(id in _data.THEMESTATS) {
								Library.themes[Number(id)] = _data.THEMESTATS[id];
								if(Library.themes[id].USQSTATE == 1) {
										Library.defaultthemeid = Number(id);
								}
								Library.themes[id].questions = [];
								p.CURW += Util.NumberVal(Library.themes[id].CURW);
								p.CURQ += Util.NumberVal(Library.themes[id].CURQ);
								p.CURF += Util.NumberVal(Library.themes[id].CURF);
								p.LASTQ += Util.NumberVal(Library.themes[id].LASTQ);
								p.LASTF += Util.NumberVal(Library.themes[id].LASTF);
								p.LASTG += Util.NumberVal(Library.themes[id].LASTG);
								p.ALLQ += Util.NumberVal(Library.themes[id].ALLQ);
								p.ALLF += Util.NumberVal(Library.themes[id].ALLF);
								p.ALLG += Util.NumberVal(Library.themes[id].ALLG);
						}
						for(id in _data.QUESTIONS) {
								p = _data.QUESTIONS[id];
								if(Util.NumberVal(p.THEMEID) > 0) {
										Library.themes[Number(p.THEMEID)].questions.push(p);
								}
						}
						n = Library.defaultthemeid;
						for(i = 1; i <= 10; i++) {
								Library.PAGE_THEMES[i] = n;
								n++;
								if(n > 10) {
										n = 1;
								}
						}
				}
				
				public static function ShowWarningPanel(_msg:String, _keyframe:uint, _callback:Function = null, _anim:Boolean = true) : void {
						if(Boolean(Library.mc) && !WarningPanel.active) {
								if(Library.mc.currentpage) {
										Imitation.Combine(Library.mc.currentpage,true);
								}
								Library.mc.WARNING.Show(_msg,_keyframe,_callback,_anim);
						}
				}
				
				public static function OnSendQuestion(_q:String) : void {
						WinMgr.ShowLoadWait();
						JsQuery.Load(Library.OnSentResult,[],Config.QUESTIONS_PHP + "act=savequestion" + _q);
				}
				
				public static function OnSentResult(_jsq:Object) : void {
						WinMgr.HideLoadWait();
						trace(Util.FormatTrace(_jsq));
						if(Util.NumberVal(_jsq.error) > 0) {
								Library.ShowWarningPanel(Util.StringVal(_jsq.errormsg),WarningPanel.ERROR,Boolean(Library.mc.currentpage) && UserQuestionEdit.active ? Library.mc.currentpage.Draw : null);
						} else {
								Library.OnLoadQuestion();
						}
				}
				
				public static function OnLoadQuestion() : void {
						WinMgr.ShowLoadWait();
						JsQuery.Load(Library.OnQuestionResult,[],Config.QUESTIONS_PHP + "act=list&stoc=" + Config.stoc + "&themeid=" + Library.PAGE_THEMES[1]);
				}
				
				public static function OnQuestionResult(_jsq:Object) : void {
						WinMgr.HideLoadWait();
						if(Util.NumberVal(_jsq.error) <= 0) {
								Library.ProcessThemes(_jsq.data);
								Library.mc.Draw(Library.USER_QUESTIONS);
						}
				}
				
				public function Prepare(aparams:Object) : void {
						Util.StopAllChildrenMov(this);
						Library.isdatawaiting = true;
						aparams.waitfordata = true;
						Library.OnLoadQuestion();
				}
				
				public function AfterOpen() : void {
						Library.winopened = true;
				}
				
				public function Draw(_pagenumber:Number) : void {
						if(this.currentpagenumber != _pagenumber) {
								this.currentpagenumber = _pagenumber;
								TweenMax.killTweensOf(this);
								this.HidePages();
								if(this.currentpagenumber == Library.USER_QUESTIONS) {
										this.SetCloseBtn("X",this.Hide);
										if(UserQuestions.refresh) {
												UserQuestions.Init();
										}
										this.currentpage = new UserQuestions();
								} else if(this.currentpagenumber == Library.USER_QUESTION_EDIT) {
										this.SetCloseBtn("LEFT",function(e:Object):* {
												Library.mc.Draw(Library.USER_QUESTIONS);
										});
										this.currentpage = new UserQuestionEdit();
								} else if(this.currentpagenumber == Library.USER_QUESTION_STATS) {
										this.SetCloseBtn("LEFT",function(e:Object):* {
												Library.mc.Draw(Library.USER_QUESTIONS);
										});
										this.currentpage = new UserQuestionStats();
								}
								if(this.currentpage) {
										this.PAGE.addChild(this.currentpage);
										this.currentpage.Show();
								}
						}
				}
				
				public function SetCloseBtn(_icon:String, _callback:Function) : void {
						if(this.BTN_CLOSE) {
								this.BTN_CLOSE.AddEventClick(_callback);
								this.BTN_CLOSE.SetCaption(_icon);
								this.BTN_CLOSE.icon = _icon;
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
						Library.mc.currentpage = null;
						Library.mc.currentpagenumber = 0;
						WinMgr.CloseWindow(this);
				}
				
				internal function __setProp_BTN_CLOSE_LibraryWindowMov_buttons_0() : * {
						try {
								this.BTN_CLOSE["componentInspectorSetting"] = true;
						}
						catch(e:Error) {
						}
						this.BTN_CLOSE.enabled = true;
						this.BTN_CLOSE.fontsize = "BIG";
						this.BTN_CLOSE.icon = "X";
						this.BTN_CLOSE.skin = "CANCEL";
						this.BTN_CLOSE.testcaption = "X";
						this.BTN_CLOSE.visible = true;
						this.BTN_CLOSE.wordwrap = false;
						try {
								this.BTN_CLOSE["componentInspectorSetting"] = false;
						}
						catch(e:Error) {
						}
				}
		}
}

