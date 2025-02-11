package triviador.gfx
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import fl.motion.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	import syscode.*;
	import uibase.UniqueButton;
	import uibase.LegoUniqueButton;
	import triviador.Game;
	import triviador.Main;
	import triviador.PhaseDisplay;
	import triviador.Map;
	import triviador.Standings;
	import triviador.compat.BoosterButton;

	[Embed(source="/modules/triviador_assets.swf", symbol="symbol1057")]
	public class MCQuestionMov extends MovieClip
	{
		public static var mc:MCQuestionMov = null;

		private static var ansbtnpos:Array = [];

		public static var boosterbuttonscalex:Number = 1;

		public static var boosterbuttonscaley:Number = 1;

		public var ANIM1:MovieClip;

		public var ANIM2:MovieClip;

		public var ANSWER_1:MovieClip;

		public var ANSWER_2:MovieClip;

		public var ANSWER_3:MovieClip;

		public var ANSWER_4:MovieClip;

		public var AREAMARKER:AreaMarkerMov;

		public var BACK:MovieClip;

		public var BIG_AREAMARKER:AreaMarkerMov;

		public var BOUNDS:MovieClip;

		public var BTNRATE1:UniqueButton;

		public var BTNRATE5:UniqueButton;

		public var CLOCK:MovieClip;

		public var EXPLOSION:MovieClip;

		public var HELP1:BoosterButton;

		public var HELP2:BoosterButton;

		public var HELPOVERLAY:MovieClip;

		public var LARGE_PBOX_1:MovieClip;

		public var LARGE_PBOX_2:MovieClip;

		public var LEFTFLAGMOV:MovieClip;

		public var LEFTMASKMOV:MovieClip;

		public var PASSIVE:MovieClip;

		public var QUESTION:TextField;

		public var REPORT:MovieClip;

		public var RIGHTFLAGS:MovieClip;

		public var RIGHTMASKMOV:MovieClip;

		public var SHAPE:MovieClip;

		public var SMALL_PBOX_1:MovieClip;

		public var SMALL_PBOX_2:MovieClip;

		public var STRIPRATE:MovieClip;

		public var S_ANIM2:MovieClip;

		public var S_ANIM3:MovieClip;

		public var THEMEICON:MovieClip;

		public var WAIT_LARGE_1:MovieClip;

		public var WAIT_LARGE_2:MovieClip;

		public var WAIT_SMALL_1:MovieClip;

		public var WAIT_SMALL_2:MovieClip;

		public var WINANIM:MovieClip;

		public var timeoutanswer:int = 0;

		public var boosterprice:Vector.<int>;

		public var first:Boolean = true;

		public var input:Boolean = false;

		public function MCQuestionMov()
		{
			var ansbtn:* = undefined;
			this.boosterprice = new <int>[-9, -9, -9];
			super();
			MCQuestionMov.mc = this;
			Util.StopAllChildrenMov(this);
			this.BACK = Util.SwapSkin(this.BACK, "skin_triviador", "MCQQuestionBack");
			Util.SwapTextcolor(this.QUESTION, "mcqWinQuestionColor", "skin_triviador");
			this.REPORT.BUTTON = Util.SwapSkin(this.REPORT.BUTTON, "skin_triviador", "MCQWinReportBtnBg");
			Util.SwapTextcolor(this.REPORT.CAPTION, "mcqWinQuestionColor", "skin_triviador");
			this.THEMEICON = Util.SwapSkin(this.THEMEICON, "skin_triviador", "ThemeIcons");
			this.LEFTFLAGMOV = Util.SwapSkin(this.LEFTFLAGMOV, "skin_triviador", "FlagsLeft");
			this.RIGHTFLAGS = Util.SwapSkin(this.RIGHTFLAGS, "skin_triviador", "FlagsRight");
			Util.SwapTextcolor(this.ANSWER_1.TXT, "mcqWinAnswerButtonCaptionColor", "skin_triviador");
			Util.SwapTextcolor(this.ANSWER_2.TXT, "mcqWinAnswerButtonCaptionColor", "skin_triviador");
			Util.SwapTextcolor(this.ANSWER_3.TXT, "mcqWinAnswerButtonCaptionColor", "skin_triviador");
			Util.SwapTextcolor(this.ANSWER_4.TXT, "mcqWinAnswerButtonCaptionColor", "skin_triviador");
			this.ANSWER_1.BTN = Util.SwapSkin(this.ANSWER_1.BTN, "skin_triviador", "MCQAnswerbutton4x1Btn");
			this.ANSWER_2.BTN = Util.SwapSkin(this.ANSWER_2.BTN, "skin_triviador", "MCQAnswerbutton4x1Btn");
			this.ANSWER_3.BTN = Util.SwapSkin(this.ANSWER_3.BTN, "skin_triviador", "MCQAnswerbutton4x1Btn");
			this.ANSWER_4.BTN = Util.SwapSkin(this.ANSWER_4.BTN, "skin_triviador", "MCQAnswerbutton4x1Btn");
			this.ANSWER_1.WINNER = Util.SwapSkin(this.ANSWER_1.WINNER, "skin_triviador", "MCQAnswer4x1WinnerFrame");
			this.ANSWER_2.WINNER = Util.SwapSkin(this.ANSWER_2.WINNER, "skin_triviador", "MCQAnswer4x1WinnerFrame");
			this.ANSWER_3.WINNER = Util.SwapSkin(this.ANSWER_3.WINNER, "skin_triviador", "MCQAnswer4x1WinnerFrame");
			this.ANSWER_4.WINNER = Util.SwapSkin(this.ANSWER_4.WINNER, "skin_triviador", "MCQAnswer4x1WinnerFrame");
			Util.SwapTextcolor(this.HELP1.LABEL, "mcqWinHelpButtonCaptionColor", "skin_triviador");
			Util.SwapTextcolor(this.HELP2.LABEL, "mcqWinHelpButtonCaptionColor", "skin_triviador");
			this.HELPOVERLAY = Util.SwapSkin(this.HELPOVERLAY, "skin_triviador", "MCQuestionHelpOverlay");
			this.CLOCK = Util.SwapSkin(this.CLOCK, "skin_triviador", "BarClock");
			this.BOUNDS.visible = false;
			Imitation.CollectChildrenAll();
			Imitation.UpdateAll();
			this.visible = false;
			for (var n:int = 1; n <= 4; n++)
			{
				ansbtn = this["ANSWER_" + n];
				ansbtnpos[n] = {
						"x": ansbtn.x,
						"y": ansbtn.y
					};
			}
			boosterbuttonscalex = this.HELP1.scaleX;
			boosterbuttonscaley = this.HELP1.scaleY;
		}

		public static function ShowWRQReport(qwin:MovieClip, withanim:Boolean):*
		{
			trace("ShowWRQReport...");
			if (!qwin)
			{
				return;
			}
			var showbutton:Boolean = false;
			if (Game.roomtype == "M")
			{
				showbutton = false;
			}
			else if (Game.questionverified)
			{
				Lang.Set(qwin.REPORT.CAPTION, "verified_question");
				Imitation.RemoveEvents(qwin.REPORT.BUTTON);
				qwin.REPORT.BUTTON.alpha = 0.3;
				showbutton = true;
			}
			else if (Game.questionmarkable)
			{
				Lang.Set(qwin.REPORT.CAPTION, "report_wrong_question");
				Imitation.AddEventClick(qwin.REPORT.BUTTON, OnWRQReportClick);
				qwin.REPORT.BUTTON.alpha = 1;
				showbutton = true;
			}
			if (showbutton)
			{
				if (withanim)
				{
					qwin.REPORT.alpha = 0;
					qwin.REPORT.visible = true;
					TweenMax.to(qwin.REPORT, 0.5, {"alpha": 1});
				}
				else
				{
					qwin.REPORT.alpha = 1;
					qwin.REPORT.visible = true;
				}
			}
			else
			{
				qwin.REPORT.visible = false;
			}
			trace("  ... visible: " + showbutton);
		}

		public static function HideWRQReport(qwin:MovieClip, withanim:Boolean):*
		{
			if (!qwin)
			{
				return;
			}
			trace("HideWRQReport: " + withanim);
			if (withanim)
			{
				TweenMax.to(qwin.REPORT, 0.5, {"alpha": 0});
			}
			else
			{
				qwin.REPORT.visible = false;
			}
		}

		public static function OnWRQReportClick(e:*):void
		{
			Lang.Set(e.target.parent.CAPTION, "question_reported");
			Imitation.RemoveEvents(e.target);
			e.target.alpha = 0.3;
			if (Game.questionmarkable)
			{
				Comm.SendCommand("WRONGQMARK", "");
			}
		}

		public static function Dispose():*
		{
			if (Boolean(MCQuestionMov.mc) && !MCQuestionMov.mc.visible)
			{
				Imitation.FreeBitmapAll(MCQuestionMov.mc);
			}
		}

		public function Show():void
		{
			var i:int = 0;
			var tf:TextField = null;
			var a:* = undefined;
			var ab:* = undefined;
			var btnframe:* = undefined;
			Main.mc.QSHADER.visible = true;
			Main.mc.QSHADER.alpha = 0;
			for (i = 1; i <= 8; Imitation.SetBitmapScale(Main.mc.QSHADER["S" + i], 0.01), i++)
			{
			}
			this.input = false;
			if (Boolean(PhaseDisplay.mc) && Boolean(PhaseDisplay.mc.INFO))
			{
				TweenMax.killTweensOf(PhaseDisplay.mc.INFO);
				PhaseDisplay.mc.INFO.alpha = 0;
			}
			mc.WINANIM.gotoAndStop(1);
			mc.WINANIM.visible = false;
			mc.ANIM1.visible = false;
			mc.ANIM2.visible = false;
			mc.S_ANIM2.visible = false;
			mc.S_ANIM3.visible = false;
			Imitation.AddButtonStop(mc.BACK);
			tf = this.QUESTION;
			CommCrypt.SetQuestionText(tf, "mcq");
			tf.y = -170 - tf.textHeight / 2;
			var themenum:int = Util.NumberVal(Sys.tag_question.THEME);
			var icon_url:String = Util.StringVal(Sys.tag_question.ICON_URL);
			var color_code:String = Util.StringVal(Sys.tag_question.COLOR_CODE);
			if (themenum >= 1 && themenum <= 10)
			{
				this.THEMEICON.gotoAndStop("EMPTY");
				if (color_code !== "")
				{
					this.THEMEICON.gotoAndStop("CUSTOM");
				}
				else
				{
					this.THEMEICON.gotoAndStop(themenum);
				}
				this.THEMEICON.cahceAsBitmap = true;
				this.THEMEICON.visible = true;
				Imitation.FreeBitmapAll(this.THEMEICON);
			}
			else
			{
				this.THEMEICON.visible = false;
			}
			if (this.THEMEICON.IMAGE)
			{
				if (icon_url != "")
				{
					if (this.THEMEICON.ICON)
					{
						this.THEMEICON.ICON.visible = false;
					}
					Sys.SwapImage(this.THEMEICON.IMAGE, icon_url);
				}
				else
				{
					this.THEMEICON.IMAGE.visible = false;
				}
			}
			if (this.THEMEICON.FLAGCOLOR)
			{
				if (color_code !== "")
				{
					Util.SetColor(this.THEMEICON.FLAGCOLOR, Util.HexToInt(color_code));
				}
			}
			var passive:Boolean = Game.state == 4 && Game.offender != Game.iam && Game.defender != Game.iam;
			if (passive)
			{
				this.BTNRATE1.Set(LegoUniqueButton.DISLIKE_FRAME, this.OnRateButtonClick);
				this.BTNRATE5.Set(LegoUniqueButton.LIKE_FRAME, this.OnRateButtonClick);
				if (this.BTNRATE1.currentFrame <= 2)
				{
					this.BTNRATE1.BG = Util.SwapSkin(this.BTNRATE1.BG, "skin_triviador", "MCQRatingButtonBg1");
					this.BTNRATE1.ICON = Util.SwapSkin(this.BTNRATE1.ICON, "skin_triviador", "MCQRatingDislikeIcon");
				}
				if (this.BTNRATE5.currentFrame <= 2)
				{
					this.BTNRATE5.BG = Util.SwapSkin(this.BTNRATE5.BG, "skin_triviador", "MCQRatingButtonBg1");
					this.BTNRATE5.ICON = Util.SwapSkin(this.BTNRATE5.ICON, "skin_triviador", "MCQRatingLikeIcon");
				}
				if (this.BTNRATE1.currentFrame == 3)
				{
					this.BTNRATE1.BG = Util.SwapSkin(this.BTNRATE1.BG, "skin_triviador", "MCQRatingButtonBg2");
					Util.SwapTextcolor(this.BTNRATE1.LABEL, "TelescopeCaptionColor", "skin_triviador");
				}
				if (this.BTNRATE5.currentFrame == 3)
				{
					this.BTNRATE5.BG = Util.SwapSkin(this.BTNRATE5.BG, "skin_triviador", "MCQRatingButtonBg2");
					Util.SwapTextcolor(this.BTNRATE5.LABEL, "TelescopeCaptionColor", "skin_triviador");
				}
				this.STRIPRATE.BG = Util.SwapSkin(this.STRIPRATE.BG, "skin_triviador", "MCQRatingVoteStripBg");
				Util.SwapTextcolor(this.STRIPRATE.LABEL, "striprateColor", "skin_triviador");
				this.BTNRATE1.Init();
				this.BTNRATE5.Init();
				Lang.Set(this.STRIPRATE.LABEL, "rate_this_question_long");
				this.STRIPRATE.visible = true;
				this.STRIPRATE.alpha = 1;
			}
			else
			{
				this.BTNRATE1.Hide();
				this.BTNRATE5.Hide();
				this.STRIPRATE.visible = false;
			}
			this.AREAMARKER.visible = false;
			this.LARGE_PBOX_2.visible = false;
			this.SMALL_PBOX_1.visible = false;
			this.SMALL_PBOX_2.visible = false;
			this.RIGHTFLAGS.LARGE_FLAG.visible = false;
			this.RIGHTFLAGS.SMALL_FLAG_1.visible = false;
			this.RIGHTFLAGS.SMALL_FLAG_2.visible = false;
			this.WAIT_LARGE_1.visible = false;
			this.WAIT_LARGE_2.visible = false;
			this.WAIT_SMALL_1.visible = false;
			this.WAIT_SMALL_2.visible = false;
			this.WAIT_LARGE_1.gotoAndStop(1);
			this.WAIT_LARGE_2.gotoAndStop(1);
			this.WAIT_SMALL_1.gotoAndStop(1);
			this.WAIT_SMALL_2.gotoAndStop(1);
			this.BIG_AREAMARKER.visible = false;
			if (this.first)
			{
				this.LARGE_PBOX_1.alpha = 0;
				TweenMax.fromTo(this.LARGE_PBOX_1, 0.5, {
							"alpha": 1,
							"scaleX": 1.5,
							"scaleY": 1.5,
							"x": -400
						}, {
							"x": -335,
							"scaleX": 1,
							"scaleY": 1,
							"ease": fl.motion.easing.Back.easeOut,
							"delay": 0.5
						});
				TweenMax.fromTo(this.ANIM1, 0.5, {
							"alpha": 1,
							"visible": true,
							"scaleX": 1,
							"scaleY": 1
						}, {
							"visible": false,
							"alpha": 0,
							"scaleX": 2,
							"scaleY": 1.5,
							"delay": 0.9
						});
			}
			if (Game.state == 4 && Game.attackedarea > 0)
			{
				a = Game.areas[Game.attackedarea];
				this.AREAMARKER.Setup(a.owner, a.value, a.towers);
				this.AREAMARKER.cacheAsBitmap = false;
				this.AREAMARKER.CVALUE.visible = false;
				this.AREAMARKER.FORTRESS.visible = a.fortress;
				this.AREAMARKER.FORTRESS.gotoAndStop(17);
				this.AREAMARKER.visible = Game.showcastleattack;
				this.BIG_AREAMARKER.Setup(a.owner, a.value, a.towers);
				this.BIG_AREAMARKER.cacheAsBitmap = false;
				this.BIG_AREAMARKER.CVALUE.visible = false;
				this.BIG_AREAMARKER.FORTRESS.visible = a.fortress;
				this.BIG_AREAMARKER.FORTRESS.gotoAndStop(17);
				this.BIG_AREAMARKER.visible = false;
				this.LEFTFLAGMOV.gotoAndStop(1);
				this.LEFTFLAGMOV.FLAG.gotoAndStop(Game.offender);
				this.RIGHTFLAGS.LARGE_FLAG.gotoAndStop(1);
				this.RIGHTFLAGS.LARGE_FLAG.FLAG.gotoAndStop(Game.defender);
				this.SetPlayerBox(this.LARGE_PBOX_1, Game.offender, true);
				this.SetPlayerBox(this.LARGE_PBOX_2, Game.defender, true);
				if (this.first)
				{
					this.LARGE_PBOX_2.alpha = 0;
					TweenMax.fromTo(this.LARGE_PBOX_2, 0.5, {
								"alpha": 1,
								"scaleX": 1.5,
								"scaleY": 1.5,
								"x": 400
							}, {
								"x": 335,
								"scaleX": 1,
								"scaleY": 1,
								"ease": fl.motion.easing.Back.easeOut,
								"delay": 0.8
							});
					TweenMax.fromTo(this.ANIM2, 0.5, {
								"alpha": 1,
								"visible": true,
								"scaleX": 1,
								"scaleY": 1
							}, {
								"visible": false,
								"alpha": 0,
								"scaleX": 2,
								"scaleY": 1.5,
								"delay": 1.2
							});
				}
				this.RIGHTFLAGS.LARGE_FLAG.visible = true;
				this.LARGE_PBOX_2.visible = true;
			}
			else if (Game.state == 2)
			{
				this.LEFTFLAGMOV.gotoAndStop(1);
				this.LEFTFLAGMOV.FLAG.gotoAndStop(Game.iam);
				this.SetPlayerBox(this.LARGE_PBOX_1, Game.iam, false);
				this.RIGHTFLAGS.SMALL_FLAG_1.visible = true;
				this.RIGHTFLAGS.SMALL_FLAG_1.gotoAndStop(1);
				this.RIGHTFLAGS.SMALL_FLAG_1.FLAG.gotoAndStop(Game.myopp1);
				this.SetPlayerBox(this.SMALL_PBOX_1, Game.myopp1, false);
				this.SMALL_PBOX_1.visible = true;
				if (this.first)
				{
					this.SMALL_PBOX_1.alpha = 0;
					TweenMax.fromTo(this.SMALL_PBOX_1, 0.5, {
								"alpha": 1,
								"scaleX": 1.5,
								"scaleY": 1.5,
								"x": 400
							}, {
								"x": 335,
								"scaleX": 1,
								"scaleY": 1,
								"ease": fl.motion.easing.Back.easeOut,
								"delay": 0.8
							});
					TweenMax.fromTo(this.S_ANIM2, 0.5, {
								"alpha": 1,
								"visible": true,
								"scaleX": 1,
								"scaleY": 1
							}, {
								"visible": false,
								"alpha": 0,
								"scaleX": 2,
								"scaleY": 1.5,
								"delay": 1.2
							});
				}
				this.RIGHTFLAGS.SMALL_FLAG_2.visible = true;
				this.RIGHTFLAGS.SMALL_FLAG_2.gotoAndStop(1);
				this.RIGHTFLAGS.SMALL_FLAG_2.FLAG.gotoAndStop(Game.myopp2);
				this.SetPlayerBox(this.SMALL_PBOX_2, Game.myopp2, false);
				this.SMALL_PBOX_2.visible = true;
				if (this.first)
				{
					this.SMALL_PBOX_2.alpha = 0;
					TweenMax.fromTo(this.SMALL_PBOX_2, 0.5, {
								"alpha": 1,
								"scaleX": 1.5,
								"scaleY": 1.5,
								"x": 400
							}, {
								"x": 335,
								"scaleX": 1,
								"scaleY": 1,
								"ease": fl.motion.easing.Back.easeOut,
								"delay": 1.1
							});
					TweenMax.fromTo(this.S_ANIM3, 0.5, {
								"alpha": 1,
								"visible": true,
								"scaleX": 1,
								"scaleY": 1
							}, {
								"visible": false,
								"alpha": 0,
								"scaleX": 2,
								"scaleY": 1.5,
								"delay": 1.5
							});
				}
				this.RIGHTFLAGS.LARGE_FLAG.visible = false;
				this.LARGE_PBOX_2.visible = false;
			}
			else
			{
				this.LEFTFLAGMOV.gotoAndStop(1);
				this.LEFTFLAGMOV.FLAG.gotoAndStop(Game.iam);
				this.SetPlayerBox(this.LARGE_PBOX_1, Game.iam, true);
			}
			this.CLOCK.visible = false;
			this.EXPLOSION.gotoAndStop(1);
			this.EXPLOSION.visible = false;
			DBG.Trace("tag_question", Sys.tag_question);
			var helpdata:Object = Util.ParseJsVar(Sys.tag_question.HELP);
			this.boosterprice[1] = Util.NumberVal(helpdata.HALF, -9);
			this.boosterprice[2] = Util.NumberVal(helpdata.ANSWERS, -9);
			Game.SetupBoosterButton(this.HELP1, "SELHALF", this.boosterprice[1]);
			Game.SetupBoosterButton(this.HELP2, "SELANSW", this.boosterprice[2]);
			this.visible = true;
			Imitation.CollectChildrenAll();
			for (i = 1; i <= 4; i++)
			{
				ab = this["ANSWER_" + i];
				ab.WINNER.gotoAndStop(1);
				ab.WINNER.visible = false;
				ab.x = ansbtnpos[i].x;
				ab.y = ansbtnpos[i].y;
				ab.scaleX = 1;
				ab.scaleY = 1;
				ab.visible = true;
				btnframe = ab.BTN.currentFrame;
				ab.BTN.gotoAndStop(1);
				if (btnframe != 1)
				{
					Imitation.FreeBitmapAll(ab.BTN);
				}
				tf = ab.TXT;
				Util.SetText(tf, Sys.tag_question["OP" + i]);
				tf.y = 33 - tf.textHeight / 2;
			}
			this.PASSIVE.visible = passive;
			this.HELPOVERLAY.visible = false;
			Imitation.SetMaskedMov(this.LEFTMASKMOV, this.LEFTFLAGMOV, false, false);
			Imitation.SetMaskedMov(this.RIGHTMASKMOV, this.RIGHTFLAGS, false, false);
			if (Game.offender == Game.iam || Game.defender == Game.iam)
			{
				this.HideWaitAnims();
				if (Sys.tag_cmd != null && Util.StringVal(Sys.tag_cmd.CMD) == "ANSWER" && !Game.commandprocessed)
				{
					this.StartInput();
				}
			}
			else
			{
				this.ShowWaitAnims();
			}
			this.AlignFunc();
			Imitation.UpdateAll(this);
			this.HELP1.visible = false;
			this.HELP2.visible = false;
			MCQuestionMov.ShowWRQReport(this, true);
			Imitation.UpdateToDisplay(this, true);
			if (Game.warobserver)
			{
				Sounds.StopMusic("passive_player");
				Sounds.PlayMusic("passive_player");
			}
			this.first = false;
			if (!passive)
			{
				Sounds.PlayVoice("voice_answer_it");
			}
		}

		public function ShowTowers():void
		{
			var ab:* = undefined;
			this.BIG_AREAMARKER.visible = true;
			this.AREAMARKER.visible = false;
			this.CLOCK.visible = false;
			for (var i:int = 1; i <= 4; i++)
			{
				ab = this["ANSWER_" + i];
				ab.visible = false;
			}
			this.PASSIVE.visible = false;
			this.HELP1.visible = false;
			this.HELP2.visible = false;
			this.HELPOVERLAY.visible = false;
		}

		public function AlignFunc():*
		{
			var tweens:Array = null;
			Aligner.CenterWindow(this, true);
			this.y = Math.min(Map.cleany + 10 + Map.cleanheight - (this.BOUNDS.height * this.scaleY + 20), Math.max(this.y + this.BOUNDS.getBounds(this).top * this.scaleY, Map.cleany + 10)) - this.BOUNDS.getBounds(this).top * this.scaleY;
			if (TweenMax.isTweening(this))
			{
				tweens = TweenMax.getTweensOf(this);
				if (Boolean(tweens) && tweens.length == 1)
				{
					tweens[0].updateTo({
								"alpha": 1,
								"scaleX": this.scaleX,
								"scaleY": this.scaleY,
								"x": this.x,
								"y": this.y
							});
				}
			}
			Main.mc.QSHADER.transform.matrix = this.transform.matrix;
		}

		public function SetPlayerBox(pb:*, pnum:*, showscore:*):*
		{
			pb.gotoAndStop(pnum);
			Util.SetText(pb.NAME, Romanization.ToLatin(Game.players[pnum].name));
			pb.AFRAME.gotoAndStop(pnum);
			Imitation.FreeBitmapAll(pb.AFRAME);
			pb.POINT.gotoAndStop(pnum);
			pb.POINT.VALUE.text = Game.players[pnum].points;
			pb.POINT.visible = showscore;
			pb.AVATAR.mt = Game.roomtype == "M";
			pb.AVATAR.ShowUID(Game.players[pnum].id);
			pb.AVATAR.DisableClick();
		}

		public function Hide():void
		{
			Sounds.StopMusic("passive_player");
			Util.StopAllChildrenMov(this);
			this.input = false;
			this.visible = false;
			Main.mc.QSHADER.visible = false;
			Aligner.UnSetAutoAlign(this);
		}

		public function IsTutorialMission(name:String):Boolean
		{
			var spl:Array = null;
			var id_status:String = null;
			var ida:Array = null;
			var id:String = "";
			if (Sys.mydata.tutorialmission != undefined && Sys.mydata.tutorialmission != "")
			{
				spl = Sys.mydata.tutorialmission.split(";");
				id_status = spl[0].split("TUTORIALMISSION:").join("");
				ida = id_status.split(",");
				id = ida[0];
			}
			return name == id;
		}

		public function StartInput():void
		{
			var i:int;
			var w:* = undefined;
			var bbtn:MovieClip = null;
			var active:Boolean = false;
			var price:int = 0;
			var delay:Number = NaN;
			var tut:Boolean = false;
			if (this.input)
			{
				return;
			}
			this.input = true;
			Game.mylastanswer = 0;
			this.timeoutanswer = 0;
			this.HideWaitAnims();
			TweenMax.fromTo(this.CLOCK.STRIP, Game.clocktimeout, {"scaleY": 1}, {
						"scaleY": 0,
						"ease": fl.motion.easing.Linear.easeNone,
						"onComplete": this.SendAnswer
					});
			TweenMax.fromTo(this.CLOCK.ALERT, 1, {"frame": 1}, {
						"frame": 30,
						"delay": Game.clocktimeout - 5,
						"repeat": -1
					});
			this.CLOCK.visible = true;
			for (i = 1; i <= 4; i++)
			{
				w = this["ANSWER_" + i];
				Imitation.AddEventClick(w, this.AnsBtnMouseClick, {"answer": i});
				Imitation.AddEventMouseDown(w, this.AnsBtnMouseDown, {"answer": i});
			}
			if (!Sounds.IsPlaying("answer_tiktak"))
			{
				Sounds.PlayEffect("answer_tiktak");
			}
			for (i = 1; i <= 2; i++)
			{
				bbtn = this["HELP" + i];
				active = false;
				price = this.boosterprice[i];
				delay = (2 - i) * 0.2;
				bbtn.rotation = 0;
				if (price >= 0)
				{
					active = true;
					TweenMax.fromTo(bbtn, 0.4, {
								"visible": true,
								"alpha": 0
							}, {
								"delay": delay,
								"alpha": 1,
								"ease": fl.motion.easing.Linear.easeNone
							});
				}
				else if (price >= -5)
				{
					TweenMax.fromTo(bbtn, 0.4, {
								"visible": true,
								"alpha": 0
							}, {
								"delay": delay,
								"alpha": 1,
								"ease": fl.motion.easing.Linear.easeNone
							});
				}
				else
				{
					bbtn.visible = false;
				}
				tut = this.IsTutorialMission(bbtn.atype);
				if (active)
				{
					Imitation.AddEventClick(bbtn, function(e:*):*
						{
						});
					Imitation.AddEventMouseDown(bbtn, this.OnBoosterButtonClick, {"id": (i == 1 ? "HALF" : "ANSWERS")});
					TweenMax.delayedCall(1, this.BoosterButtonBold, [bbtn, (2 - i) * 0.2]);
					TweenMax.delayedCall(tut ? 1 : 6, this.BoosterButtonShake, [bbtn, true]);
					TweenMax.delayedCall(9, this.BoosterButtonInvisible, [bbtn]);
				}
			}
		}

		public function AnsBtnMouseClick(e:*):*
		{
		}

		public function AnsBtnMouseDown(e:*):*
		{
			this.SendAnswer(e);
			Sounds.PlayEffect("click");
			var i:int = int(e.params.answer);
			TweenMax.killTweensOf(e.target);
			TweenMax.to(e.target, 0.08, {
						"scaleX": 0.8,
						"scaleY": 0.8,
						"x": ansbtnpos[i].x + 0.2 * e.target.width / 2,
						"y": ansbtnpos[i].y + 0.2 * e.target.height / 2
					});
			TweenMax.to(e.target, 0.2, {
						"delay": 0.08,
						"scaleX": 1,
						"scaleY": 1,
						"x": ansbtnpos[i].x,
						"y": ansbtnpos[i].y
					});
		}

		public function SendAnswer(e:Object = null):void
		{
			this.StopInput();
			var answer:int = !!e ? Util.NumberVal(e.params.answer) : 0;
			if (answer == 0 && this.timeoutanswer != 0)
			{
				answer = this.timeoutanswer;
			}
			if (answer == 0 && this.timeoutanswer == 0)
			{
				Sounds.PlayVoice("voice_too_slow");
			}
			Game.mylastanswer = answer;
			this.DrawAnswers();
			this.ShowWaitAnims();
			Comm.SendCommand("ANSWER", "ANSWER=\"" + answer + "\"");
		}

		public function tagproc_HELP(tag:Object):void
		{
			trace("help handling is not implemented.");
		}

		public function DrawAnswers():*
		{
			var ansmov:* = undefined;
			var u:String = null;
			var p:int = 0;
			var a:int = 0;
			var prevframe:* = undefined;
			var fi:Object = {
					"1": 2,
					"2": 3,
					"3": 4,
					"12": 5,
					"13": 6,
					"23": 7,
					"123": 8
				};
			for (var i:int = 1; i <= 4; i++)
			{
				ansmov = this["ANSWER_" + i];
				u = "";
				for (p = 1; p <= 3; p++)
				{
					a = 0;
					if (Game.tag_answerresult)
					{
						a = Util.NumberVal(Game.tag_answerresult["PLAYER" + p], -1);
					}
					else if (p == Game.iam)
					{
						a = Game.mylastanswer;
					}
					if (a > 0 && a == i)
					{
						u += String(p);
					}
				}
				if (u.length > 0)
				{
					prevframe = ansmov.BTN.currentFrame;
					ansmov.BTN.gotoAndStop(fi[u]);
					if (prevframe != ansmov.BTN.currentFrame)
					{
						Imitation.FreeBitmapAll(ansmov.BTN);
					}
				}
				ansmov.visible = true;
			}
		}

		public function ShowWaitAnims():*
		{
			var wm:MovieClip = null;
			var pnum:* = undefined;
			var waitmovs:Array = [this.WAIT_LARGE_1, this.WAIT_LARGE_2];
			var pnums:Array = [Game.offender, Game.defender];
			if (Game.state == 2)
			{
				waitmovs = [this.WAIT_LARGE_1, this.WAIT_SMALL_1, this.WAIT_SMALL_2];
				pnums = [Game.iam, Game.myopp1, Game.myopp2];
			}
			for (var i:int = 0; i < waitmovs.length; i++)
			{
				wm = waitmovs[i];
				pnum = pnums[i];
				if (pnum == Game.iam)
				{
					wm.visible = false;
					wm.stop();
				}
				else
				{
					wm.visible = true;
					if (!TweenMax.isTweening(wm))
					{
						TweenMax.fromTo(wm, wm.totalFrames / 30, {"frame": 1}, {
									"frame": wm.totalFrames,
									"ease": fl.motion.easing.Linear.easeNone,
									"repeat": -1
								});
					}
				}
			}
		}

		public function HideWaitAnims():*
		{
			var wmov:MovieClip = null;
			var waitmovs:Array = [this.WAIT_LARGE_1, this.WAIT_LARGE_2, this.WAIT_SMALL_1, this.WAIT_SMALL_2];
			for each (wmov in waitmovs)
			{
				TweenMax.killTweensOf(wmov);
				wmov.stop();
				wmov.visible = false;
			}
		}

		public function StopInput():void
		{
			var w:* = undefined;
			TweenMax.killChildTweensOf(this.CLOCK);
			this.CLOCK.ALERT.gotoAndStop(1);
			this.CLOCK.visible = false;
			if (Sounds.IsPlaying("answer_tiktak"))
			{
				Sounds.StopEffect("answer_tiktak");
			}
			for (var i:int = 1; i <= 4; i++)
			{
				w = this["ANSWER_" + i];
				Imitation.RemoveEvents(w);
			}
			this.HideBoosterButtons();
		}

		public function OnBoosterButtonClick(e:*):void
		{
			this.HideBoosterButtons();
			Comm.SendCommand("HELP", "HELP=\"" + e.params.id + "\"", this.OnHelpCommandResult, this);
		}

		public function BoosterButtonBold(btn:MovieClip, delay:Number):void
		{
			if (Boolean(btn) && btn.visible)
			{
				TweenMax.to(btn, 0.2, {
							"delay": delay + 0,
							"scaleX": 1.05,
							"scaleY": 1.05,
							"ease": com.greensock.easing.Sine.easeIn
						});
				TweenMax.to(btn, 0.2, {
							"delay": delay + 0.2,
							"scaleX": boosterbuttonscalex,
							"scaleY": boosterbuttonscaley,
							"ease": com.greensock.easing.Sine.easeOut
						});
			}
		}

		public function BoosterButtonShake(btn:MovieClip, dirtoright:Boolean):void
		{
			if (Boolean(btn) && btn.visible)
			{
				TweenMax.to(btn, 0.1, {
							"rotation": (dirtoright ? 5 : -5),
							"ease": fl.motion.easing.Bounce.easeInOut,
							"onComplete": this.BoosterButtonShake,
							"onCompleteParams": [btn, !dirtoright]
						});
			}
		}

		public function BoosterButtonInvisible(btn:MovieClip):void
		{
			if (btn)
			{
				TweenMax.killTweensOf(btn);
				btn.visible = false;
			}
		}

		public function OnRateButtonClick(e:*):void
		{
			var striprate:MovieClip = null;
			var btn:MovieClip = null;
			var myrate:int = Util.IdFromStringEnd(e.target.name);
			striprate = this.STRIPRATE;
			Comm.SendCommand("RATEQUESTION", "RATE=\"" + myrate + "\"");
			if (striprate)
			{
				TweenMax.to(striprate, 0.5, {
							"alpha": 0,
							"onComplete": function():*
							{
								striprate.visible = false;
							}
						});
			}
			for each (btn in [this.BTNRATE1, this.BTNRATE5])
			{
				if (btn != e.target)
				{
					btn.FadeOut();
				}
			}
		}

		public function OnHelpCommandResult(res:int, xml:XML):void
		{
			var tohide:Array = null;
			var aarr:Array = null;
			var i:int = 0;
			var max:int = 0;
			var val:int = 0;
			var m:MovieClip = null;
			trace("MCQuestionMov.OnHelpCommandResult...");
			var xmlobj:Object = Util.XMLTagToObject(xml);
			DBG.Trace("xmlobj", xmlobj);
			if (res != 0 || !xmlobj.HELP)
			{
				trace("error in help result.");
				return;
			}
			var tag:Object = xmlobj.HELP;
			var helpname:String = Util.StringVal(tag.HELP);
			if (helpname == "HALF")
			{
				tohide = Util.StringVal(tag.RESULT).split(",");
				this["ANSWER_" + tohide[0]].visible = false;
				this["ANSWER_" + tohide[1]].visible = false;
				this.timeoutanswer = 1 + Util.Random(1, 4);
				while (tohide.indexOf(this.timeoutanswer) >= 0)
				{
					++this.timeoutanswer;
					if (this.timeoutanswer > 4)
					{
						this.timeoutanswer = 1;
					}
				}
				Sounds.PlayEffect("selhalf_using");
				Sounds.PlayEffect("help_clicked");
			}
			else if (helpname == "ANSWERS")
			{
				this.HELPOVERLAY.visible = true;
				Imitation.CollectChildrenAll(this);
				aarr = Util.StringVal(tag.RESULT).split(",");
				max = 0;
				for (i = 1; i <= 4; i++)
				{
					val = Util.NumberVal(aarr[i - 1]);
					if (val > max)
					{
						max = val;
						this.timeoutanswer = i;
					}
				}
				for (i = 1; i <= 4; i++)
				{
					val = Util.NumberVal(aarr[i - 1]);
					m = this.HELPOVERLAY["INDICATOR" + i];
					m.PERCENT.text = Util.NumberVal(aarr[i - 1]) + "%";
					m.BAR.scaleX = val / max;
				}
				Sounds.PlayEffect("selansw_using");
				Sounds.PlayEffect("help_clicked");
			}
		}

		public function HideBoosterButtons():void
		{
			var bbtn:MovieClip = null;
			for (var i:int = 1; i <= 2; i++)
			{
				bbtn = this["HELP" + i];
				TweenMax.killTweensOf(bbtn);
				bbtn.visible = false;
				Imitation.RemoveEvents(bbtn);
			}
			this.HELPOVERLAY.visible = false;
		}

		public function sqadd_Evaluation():*
		{
			var ao:* = undefined;
			var good:int = 0;
			var winnerflag:MovieClip = null;
			good = Util.NumberVal(Game.tag_answerresult.GOOD);
			winnerflag = null;
			if (Game.state == 4 && Game.defender != Game.offender)
			{
				if (Util.NumberVal(Game.tag_answerresult["PLAYER" + Game.offender], 0) == good)
				{
					winnerflag = this.LEFTFLAGMOV;
				}
				if (Util.NumberVal(Game.tag_answerresult["PLAYER" + Game.defender], 0) == good)
				{
					winnerflag = !!winnerflag ? null : this.RIGHTFLAGS.LARGE_FLAG;
				}
			}
			ao = Sys.gsqc.AddObj("MCQuestion.evaluation.prepare");
			ao.self = this;
			ao.Start = function():*
			{
				this.self.StopInput();
				this.self.HideWaitAnims();
				this.self.DrawAnswers();
				this.Next();
			};
			Sys.gsqc.AddDelay(0.5);
			ao = Sys.gsqc.AddObj("GOODSOUND");
			ao.Start = function():*
			{
				var opp:int = 0;
				if (!Game.warobserver)
				{
					if (Util.NumberVal(Game.tag_answerresult["PLAYER" + Game.iam], 0) == good)
					{
						opp = Game.offender == Game.iam ? Game.defender : Game.offender;
						if (Util.NumberVal(Game.tag_answerresult["PLAYER" + opp], 0) == good)
						{
							Sounds.PlayEffect("fanfare_draw");
						}
						else
						{
							Sounds.PlayEffect("fanfare_win");
						}
					}
					else
					{
						Sounds.PlayEffect("fanfare_lose");
					}
				}
				this.Next();
			};
			ao = Sys.gsqc.AddObj("MCQuestion.evaluation.showgood");
			ao.self = this;
			ao.Start = function():*
			{
				var w:MovieClip = this.self["ANSWER_" + good].WINNER;
				TweenMax.fromTo(w, 0.5, {
							"frame": 1,
							"visible": true
						}, {
							"frame": 30,
							"repeat": -1
						});
				if (winnerflag)
				{
					TweenMax.fromTo(winnerflag, 0.5, {
								"scaleX": 1,
								"scaleY": 1
							}, {
								"scaleX": 1.1,
								"scaleY": 1.1,
								"repeat": -1,
								"ease": fl.motion.easing.Linear.easeNone,
								"yoyo": true
							});
				}
				this.Next();
			};
			Sys.gsqc.AddDelay(3);
			ao = Sys.gsqc.AddObj("MCQuestion.evaluation.finish");
			ao.self = this;
			ao.Start = function():*
			{
				var w:MovieClip = this.self["ANSWER_" + good].WINNER;
				TweenMax.killTweensOf(w);
				w.gotoAndStop(1);
				TweenMax.killTweensOf(winnerflag);
				this.Next();
			};
		}

		public function sqadd_ShowQuestion():*
		{
			var ao:* = undefined;
			var gqvisible:Boolean = false;
			this.first = true;
			gqvisible = GuessQuestionMov.mc.visible;
			ao = Sys.gsqc.AddTweenObj("MCQuestion.show.prepare");
			ao.self = this;
			ao.Start = function():*
			{
				this.self.Show();
				this.self.visible = false;
				Imitation.UpdateToDisplay(this.self);
				this.Next();
			};
			ao = Sys.gsqc.AddTweenObj("MCQuestion.show");
			ao.self = this;
			ao.Start = function():*
			{
				if (gqvisible)
				{
					Sys.gsqc.PlayEffect("question_out");
					GuessQuestionMov.mc.visible = false;
				}
				this.AddTweenMaxTo(this.self, 0.01, {
							"visible": true,
							"onComplete": function():*
							{
								Standings.UpdateChatButtons();
							}
						});
				this.AddTweenMaxTo(this.self.BACK, 0.3, {
							"scaleX": this.self.scaleX * 1.03,
							"repeat": 1,
							"yoyo": true
						});
				this.AddTweenMaxTo(Main.mc.QSHADER, 0.3, {"alpha": 0.5});
				if (!gqvisible)
				{
					this.AddTweenMaxFromTo(this.self.WINANIM, 0.8, {
								"frame": 1,
								"visible": true
							}, {
								"visible": false,
								"frame": this.self.WINANIM.totalFrames,
								"ease": fl.motion.easing.Linear.easeNone
							});
					Sounds.PlayEffect("question_in");
				}
				Sys.gsqc.Stop();
				Sys.gsqc.Clear();
			};
		}

		public function sqadd_HideQuestion():*
		{
			var ao:* = undefined;
			var targety:Number = this.y;
			this.HideWaitAnims();
			ao = Sys.gsqc.AddTweenObj("MCQuestion hide 1");
			ao.self = this;
			ao.Start = function():*
			{
				this.AddTweenMaxTo(this.self, 0.3, {
							"y": Imitation.stage.stageHeight + this.self.BOUNDS.height,
							"ease": fl.motion.easing.Cubic.easeIn
						});
				this.AddTweenMaxTo(Main.mc.QSHADER, 0.8, {"alpha": 0});
			};
			ao = Sys.gsqc.AddObj("MCQuestion hide 2");
			ao.self = this;
			ao.Start = function():*
			{
				this.self.Hide();
				this.Next();
			};
			Sys.gsqc.AddDelay(0.2);
		}
	}
}
