package triviador.gfx
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import fl.motion.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	import syscode.*;
	import uibase.LegoUniqueButton;
	import uibase.UniqueButton;
	import triviador.Main;
	import triviador.Standings;
	import triviador.PhaseDisplay;
	import triviador.Game;
	import triviador.Map;
	import triviador.compat.BoosterButton;

	[Embed(source="/modules/triviador_assets.swf", symbol="symbol1169")]
	public class GuessQuestionMov extends MovieClip
	{
		public static var mc:GuessQuestionMov = null;

		public static const circle_colors:Array = [0, 14224395, 3188232, 1868224];

		public static const target_radius:Number = 245;

		public static const closest_radius:Number = 30;

		public static const worst_radius:Number = 192;

		public static const arrowscale:Number = 0.28;

		public static const min_arrow_distance:Number = 15;

		public static var boosterbuttonscalex:Number = 1;

		public static var boosterbuttonscaley:Number = 1;

		public var ANIM1:MovieClip;

		public var ANIM2:MovieClip;

		public var AREAMARKER:AreaMarkerMov;

		public var ARROW_1:MovieClip;

		public var ARROW_2:MovieClip;

		public var ARROW_3:MovieClip;

		public var BACK:MovieClip;

		public var BIG_AREAMARKER:AreaMarkerMov;

		public var BOUNDS:MovieClip;

		public var BOX_1:MovieClip;

		public var BOX_2:MovieClip;

		public var BOX_3:MovieClip;

		public var BTNRATE1:UniqueButton;

		public var BTNRATE5:UniqueButton;

		public var CENTER:MovieClip;

		public var CIRCLEMOV:MovieClip;

		public var EXPLOSION:MovieClip;

		public var GOODANSWER:MovieClip;

		public var HELP1:BoosterButton;

		public var HELP2:BoosterButton;

		public var HELPOVERLAY:MovieClip;

		public var INPUT:MovieClip;

		public var LARGE_PBOX_1:MovieClip;

		public var LARGE_PBOX_2:MovieClip;

		public var LEFTFLAG:MovieClip;

		public var LEFTMASKMOV:MovieClip;

		public var MYANSWERBOX:MovieClip;

		public var QUESTION:TextField;

		public var REPORT:MovieClip;

		public var RIGHTFLAGS:MovieClip;

		public var RIGTMASKMOV:MovieClip;

		public var SHOOT_LARGE_1:MovieClip;

		public var SHOOT_LARGE_2:MovieClip;

		public var SHOOT_SMALL_1:MovieClip;

		public var SHOOT_SMALL_2:MovieClip;

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

		private var mytip:int = -1;

		private var timeoutanswer:int = -1;

		private var playercount:int = 3;

		public var first:Boolean = true;

		private var tipboxes:Vector.<MovieClip>;

		private var playerboxes:Vector.<MovieClip>;

		private var playerflags:Vector.<MovieClip>;

		private var waitanims:Vector.<MovieClip>;

		private var shootsigns:Vector.<MovieClip>;

		private var playertipboxnum:Vector.<int>;

		private var mytipboxnum:int = 0;

		private var waitingmytip:Boolean = false;

		private var tipboxy:Vector.<Number>;

		private var tipboxx:Vector.<Number>;

		public var playertips:Array;

		public var tiptimeorder:Array;

		public var tipwinorder:Array;

		public var arrowparams:Array;

		public var equalmask:int = 0;

		private var animatemytiptoplace:Boolean = false;

		public var boosterprice:Vector.<int>;

		public function GuessQuestionMov()
		{
			var i:int = 0;
			var pt:Point = null;
			this.tipboxes = new <MovieClip>[null, null, null, null];
			this.playerboxes = new <MovieClip>[null, null, null, null];
			this.playerflags = new <MovieClip>[null, null, null, null];
			this.waitanims = new <MovieClip>[null, null, null, null];
			this.shootsigns = new <MovieClip>[null, null, null, null];
			this.playertipboxnum = new <int>[0, 0, 0, 0];
			this.tipboxy = new <Number>[0, 0, 0, 0];
			this.tipboxx = new <Number>[0, 0, 0, 0];
			this.playertips = [null, {}, {}, {}];
			this.tiptimeorder = [];
			this.tipwinorder = [];
			this.arrowparams = [null, {}, {}, {}];
			this.boosterprice = new <int>[-9, -9, -9];
			super();
			GuessQuestionMov.mc = this;
			this.BACK = Util.SwapSkin(this.BACK, "skin_triviador", "QuestionBack");
			Util.SwapTextcolor(this.QUESTION, "guessQuestionWinQuestionColor", "skin_triviador");
			this.REPORT.BUTTON = Util.SwapSkin(this.REPORT.BUTTON, "skin_triviador", "MCQWinReportBtnBg");
			Util.SwapTextcolor(this.REPORT.CAPTION, "mcqWinQuestionColor", "skin_triviador");
			this.THEMEICON = Util.SwapSkin(this.THEMEICON, "skin_triviador", "ThemeIcons");
			this.LEFTFLAG = Util.SwapSkin(this.LEFTFLAG, "skin_triviador", "FlagsLeft");
			this.RIGHTFLAGS = Util.SwapSkin(this.RIGHTFLAGS, "skin_triviador", "FlagsRight");
			Util.SwapTextcolor(this.HELP1.LABEL, "mcqWinHelpButtonCaptionColor", "skin_triviador");
			Util.SwapTextcolor(this.HELP2.LABEL, "mcqWinHelpButtonCaptionColor", "skin_triviador");
			this.HELPOVERLAY = Util.SwapSkin(this.HELPOVERLAY, "skin_triviador", "MCQuestionHelpOverlay");
			this.MYANSWERBOX = Util.SwapSkin(this.MYANSWERBOX, "skin_triviador", "ArrowBox");
			this.BOX_1 = Util.SwapSkin(this.BOX_1, "skin_triviador", "ArrowBox");
			this.BOX_2 = Util.SwapSkin(this.BOX_2, "skin_triviador", "ArrowBox");
			this.BOX_3 = Util.SwapSkin(this.BOX_3, "skin_triviador", "ArrowBox");
			this.GOODANSWER = Util.SwapSkin(this.GOODANSWER, "skin_triviador", "GoodAnswerBox");
			this.INPUT.CLOCK = Util.SwapSkin(this.INPUT.CLOCK, "skin_triviador", "BarClock");
			this.ARROW_1 = Util.SwapSkin(this.ARROW_1, "skin_triviador", "ArrowAnim");
			this.ARROW_2 = Util.SwapSkin(this.ARROW_2, "skin_triviador", "ArrowAnim");
			this.ARROW_3 = Util.SwapSkin(this.ARROW_3, "skin_triviador", "ArrowAnim");
			this.CENTER = Util.SwapSkin(this.CENTER, "skin_triviador", "ArcheryCenter");
			this.INPUT.WOOD_BG = Util.SwapSkin(this.INPUT.WOOD_BG, "skin_triviador", "GuessQuestionWindowInputBg");
			Util.SwapTextcolor(this.INPUT.VALUE, "guessQuestionWinInputValueColor", "skin_triviador");
			this.INPUT.BOX = Util.SwapSkin(this.INPUT.BOX, "skin_triviador", "GuessQuestionAnswerBoxAnim");
			this.INPUT.BUTTONS = Util.SwapSkin(this.INPUT.BUTTONS, "skin_triviador", "GuessQuestionWindowInputButtons");
			Util.StopAllChildrenMov(this);
			for (i = 0; i <= 9; i++)
			{
				this.INPUT.BUTTONS["NUM" + i].CAPTION.text = String(i);
			}
			this.tipboxy[1] = 150;
			this.tipboxy[2] = 170;
			this.tipboxy[3] = 190;
			this.tipboxx[1] = -186;
			this.tipboxx[2] = 0;
			this.tipboxx[3] = 186;
			this.tipboxes[1] = this.BOX_1;
			this.tipboxes[2] = this.BOX_2;
			this.tipboxes[3] = this.BOX_3;
			boosterbuttonscalex = this.HELP1.scaleX;
			boosterbuttonscaley = this.HELP1.scaleY;
			this.arrowparams[1].angle = this.ARROW_1.rotation;
			pt = this.PolarCoords(this.arrowparams[1].angle, 420);
			this.arrowparams[1].startx = pt.x;
			this.arrowparams[1].starty = pt.y;
			this.arrowparams[2].angle = this.ARROW_2.rotation;
			pt = this.PolarCoords(this.arrowparams[2].angle, 420);
			this.arrowparams[2].startx = pt.x;
			this.arrowparams[2].starty = pt.y;
			this.arrowparams[3].angle = this.ARROW_3.rotation;
			pt = this.PolarCoords(this.arrowparams[3].angle, 420);
			this.arrowparams[3].startx = pt.x;
			this.arrowparams[3].starty = pt.y;
			this.mytipboxnum = 0;
			this.BOUNDS.visible = false;
			Imitation.CollectChildrenAll();
			Imitation.UpdateAll();
			this.visible = false;
		}

		public static function Dispose():*
		{
			if (Boolean(GuessQuestionMov.mc) && !GuessQuestionMov.mc.visible)
			{
				Imitation.FreeBitmapAll(GuessQuestionMov.mc);
			}
		}

		public function Show():void
		{
			var i:int = 0;
			var pnum:int = 0;
			var boxnum:int = 0;
			var tf:TextField = null;
			var a:* = undefined;
			var cnt:int = 0;
			var tb:MovieClip = null;
			var am:MovieClip = null;
			Main.mc.QSHADER.visible = true;
			Main.mc.QSHADER.alpha = 0;
			for (i = 1; i <= 8; Imitation.SetBitmapScale(Main.mc.QSHADER["S" + i], 0.01), i++)
			{
			}
			Standings.UpdateChatButtons();
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
			this.playerboxes = new <MovieClip>[null, null, null, null];
			this.playerflags = new <MovieClip>[null, null, null, null];
			this.waitanims = new <MovieClip>[null, null, null, null];
			this.shootsigns = new <MovieClip>[null, null, null, null];
			Imitation.AddButtonStop(mc.BACK);
			tf = this.QUESTION;
			CommCrypt.SetQuestionText(tf, "tip");
			tf.y = -170 - tf.textHeight / 2;
			this.BIG_AREAMARKER.visible = false;
			this.AREAMARKER.visible = false;
			this.MYANSWERBOX.visible = false;
			this.LARGE_PBOX_1.visible = true;
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
			this.SHOOT_LARGE_1.visible = false;
			this.SHOOT_LARGE_2.visible = false;
			this.SHOOT_SMALL_1.visible = false;
			this.SHOOT_SMALL_2.visible = false;
			this.playertipboxnum[1] = 0;
			this.playertipboxnum[2] = 0;
			this.playertipboxnum[3] = 0;
			if (Game.state == 3)
			{
				this.playercount = 3;
				this.playertipboxnum[Game.iam] = 1;
				this.playertipboxnum[Game.myopp1] = 2;
				this.playertipboxnum[Game.myopp2] = 3;
				if (this.first)
				{
					this.SMALL_PBOX_1.alpha = 0;
					this.SMALL_PBOX_2.alpha = 0;
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
			}
			else if (Game.state == 4)
			{
				this.playercount = 2;
				this.playertipboxnum[Game.offender] = 1;
				this.playertipboxnum[Game.defender] = 3;
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
			}
			else
			{
				if (Game.state != 5)
				{
					throw new Error("Unhandled state for GuessQuestionMov!");
				}
				this.equalmask = 0;
				if (Game.players[1].points == Game.players[2].points)
				{
					this.equalmask |= 1 + 2;
				}
				if (Game.players[1].points == Game.players[3].points)
				{
					this.equalmask |= 1 + 4;
				}
				if (Game.players[2].points == Game.players[3].points)
				{
					this.equalmask |= 2 + 4;
				}
				this.playercount = this.equalmask == 1 + 2 + 4 ? 3 : 2;
				cnt = 0;
				if ((this.equalmask & 1 << Game.iam - 1) != 0)
				{
					this.playertipboxnum[Game.iam] = 1;
					cnt++;
				}
				for (pnum = 1; pnum <= 3; pnum++)
				{
					if (pnum != Game.iam && (this.equalmask & 1 << pnum - 1) != 0)
					{
						cnt++;
						if (cnt == 2 && this.playercount == 2)
						{
							cnt++;
						}
						this.playertipboxnum[pnum] = cnt;
					}
				}
				if (this.first)
				{
					this.LARGE_PBOX_2.alpha = 0;
					this.SMALL_PBOX_1.alpha = 0;
					this.SMALL_PBOX_2.alpha = 0;
					if (cnt == 2)
					{
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
					else
					{
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
				}
			}
			this.mytipboxnum = this.playertipboxnum[Game.iam];
			var themenum:int = Util.NumberVal(Sys.tag_tipquestion.THEME);
			var icon_url:String = Util.StringVal(Sys.tag_tipquestion.ICON_URL);
			if (themenum >= 1 && themenum <= 10)
			{
				this.THEMEICON.gotoAndStop("EMPTY");
				this.THEMEICON.gotoAndStop(themenum);
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
			var passive:Boolean = Game.state == 4 && Game.offender != Game.iam && Game.defender != Game.iam;
			if (passive)
			{
				// these are consts this is fine to use
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
			for (pnum = 1; pnum <= 3; pnum++)
			{
				boxnum = this.playertipboxnum[pnum];
				if (boxnum == 1)
				{
					this.playerboxes[pnum] = this.LARGE_PBOX_1;
					this.playerflags[pnum] = this.LEFTFLAG;
					this.waitanims[pnum] = this.WAIT_LARGE_1;
					this.shootsigns[pnum] = this.SHOOT_LARGE_1;
				}
				else if (boxnum == 2)
				{
					this.playerboxes[pnum] = this.SMALL_PBOX_1;
					this.playerflags[pnum] = this.RIGHTFLAGS.SMALL_FLAG_1;
					this.waitanims[pnum] = this.WAIT_SMALL_1;
					this.shootsigns[pnum] = this.SHOOT_SMALL_1;
				}
				else if (boxnum == 3)
				{
					if (this.playercount == 2)
					{
						this.playerboxes[pnum] = this.LARGE_PBOX_2;
						this.playerflags[pnum] = this.RIGHTFLAGS.LARGE_FLAG;
						this.waitanims[pnum] = this.WAIT_LARGE_2;
						this.shootsigns[pnum] = this.SHOOT_LARGE_2;
					}
					else
					{
						this.playerboxes[pnum] = this.SMALL_PBOX_2;
						this.playerflags[pnum] = this.RIGHTFLAGS.SMALL_FLAG_2;
						this.waitanims[pnum] = this.WAIT_SMALL_2;
						this.shootsigns[pnum] = this.SHOOT_SMALL_2;
					}
				}
				if (boxnum > 0)
				{
					this.SetPlayerBox(this.playerboxes[pnum], pnum, boxnum == 1 || this.playercount < 3);
					this.playerflags[pnum].visible = true;
					this.playerflags[pnum].gotoAndStop(1);
					this.playerflags[pnum].FLAG.gotoAndStop(pnum);
					tb = this.tipboxes[boxnum];
					tb.gotoAndStop(pnum);
					tb.VALUE.text = "";
					tb.VALUE_TIME.text = "";
					tb.VALUE_DIFF.text = "";
					tb.RANK.visible = false;
					tb.TIME.visible = false;
					tb.DIFF.visible = false;
					am = this["ARROW_" + boxnum];
					Imitation.GotoFrame(am.SHAPE, pnum, false);
					am.MARK.visible = false;
				}
				this.tipboxes[pnum].visible = false;
				this["ARROW_" + pnum].visible = false;
			}
			this.GOODANSWER.visible = false;
			this.CENTER.visible = false;
			this.CIRCLEMOV.visible = false;
			this.HELPOVERLAY.visible = false;
			this.EXPLOSION.gotoAndStop(1);
			this.EXPLOSION.visible = false;
			this.ProcessTipInfo();
			this.DrawShootInfo();
			DBG.Trace("tag_tipquestion", Sys.tag_tipquestion);
			var helpdata:Object = Util.ParseJsVar(Sys.tag_tipquestion.HELP);
			this.boosterprice[1] = Util.NumberVal(helpdata.AVERAGE, -9);
			this.boosterprice[2] = Util.NumberVal(helpdata.RANGE, -9);
			Game.SetupBoosterButton(this.HELP1, "TIPAVER", this.boosterprice[1]);
			Game.SetupBoosterButton(this.HELP2, "TIPRANG", this.boosterprice[2]);
			this.visible = true;
			Imitation.CollectChildrenAll();
			Imitation.SetMaskedMov(this.LEFTMASKMOV, this.LEFTFLAG, false, false);
			Imitation.SetMaskedMov(this.RIGTMASKMOV, this.RIGHTFLAGS, false, false);
			this.INPUT.visible = true;
			this.INPUT.alpha = 1;
			this.INPUT.VALUE.text = "";
			this.AlignFunc();
			Imitation.UpdateAll(this);
			this.INPUT.visible = false;
			if (Sys.tag_cmd != null && Util.StringVal(Sys.tag_cmd.CMD) == "TIP" && !Game.commandprocessed)
			{
				this.StartInput();
			}
			this.HELP1.visible = false;
			this.HELP2.visible = false;
			MCQuestionMov.ShowWRQReport(this, true);
			Imitation.UpdateToDisplay(this, true);
			if (Game.warobserver)
			{
				Sounds.StopMusic("passive_player");
				Sounds.PlayMusic("passive_player");
			}
			if (!passive)
			{
				Sounds.PlayVoice("voice_guess_fast");
			}
		}

		public function ShowTowers():void
		{
			this.BIG_AREAMARKER.visible = true;
			this.AREAMARKER.visible = false;
			this.MYANSWERBOX.visible = false;
			this.WAIT_LARGE_1.visible = false;
			this.WAIT_LARGE_2.visible = false;
			this.WAIT_SMALL_1.visible = false;
			this.WAIT_SMALL_2.visible = false;
			this.SHOOT_LARGE_1.visible = false;
			this.SHOOT_LARGE_2.visible = false;
			this.SHOOT_SMALL_1.visible = false;
			this.SHOOT_SMALL_2.visible = false;
			this.GOODANSWER.visible = false;
			this.CENTER.visible = false;
			this.CIRCLEMOV.visible = false;
			this.INPUT.visible = false;
			this.HELPOVERLAY.visible = false;
			this.HELP1.visible = false;
			this.HELP2.visible = false;
			this.BTNRATE1.Hide();
			this.BTNRATE5.Hide();
			this.STRIPRATE.visible = false;
			this.BOX_1.visible = false;
			this.BOX_2.visible = false;
			this.BOX_3.visible = false;
			this.ARROW_1.visible = false;
			this.ARROW_2.visible = false;
			this.ARROW_3.visible = false;
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

		public function Hide():void
		{
			Sounds.StopMusic("passive_player");
			Util.StopAllChildrenMov(this);
			this.visible = false;
			Main.mc.QSHADER.visible = false;
			Aligner.UnSetAutoAlign(this);
		}

		public function SetPlayerBox(pb:*, pnum:*, showscore:*):*
		{
			Imitation.GotoFrame(pb, pnum, false);
			Util.SetText(pb.NAME, Romanization.ToLatin(Game.players[pnum].name));
			Imitation.GotoFrame(pb.AFRAME, pnum, false);
			Imitation.GotoFrame(pb.POINT, pnum, false);
			pb.POINT.VALUE.text = Game.players[pnum].points;
			pb.POINT.visible = showscore;
			pb.AVATAR.mt = Game.roomtype == "M" || Game.roomtype == "T";
			pb.AVATAR.ShowUID(Game.players[pnum].id);
			pb.AVATAR.DisableClick();
			pb.visible = true;
		}

		public function PolarCoords(aangle:Number, adistance:Number):Point
		{
			return new Point(-Math.cos(Math.PI * aangle / 180) * adistance, -Math.sin(Math.PI * aangle / 180) * adistance);
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
			var w:MovieClip;
			var i:int = 0;
			var bbtn:MovieClip = null;
			var active:Boolean = false;
			var price:int = 0;
			var delay:Number = NaN;
			var tut:Boolean = false;
			if (this.INPUT.visible)
			{
				return;
			}
			this.waitingmytip = true;
			this.DrawShootInfo();
			this.BOX_1.visible = false;
			this.BOX_2.visible = false;
			this.BOX_3.visible = false;
			this.INPUT.visible = true;
			this.INPUT.alpha = 1;
			this.INPUT.VALUE.text = "";
			this.INPUT.CURSOR.visible = true;
			this.mytip = -1;
			this.timeoutanswer = -1;
			w = this.INPUT.BUTTONS;
			for (i = 0; i <= 9; i++)
			{
				this.SetupButton(w["NUM" + i], ["number", i]);
			}
			this.SetupButton(w["DEL"], ["del"]);
			this.SetupButton(w["BTNSEND"], ["send"]);
			Util.AddEventListener(Imitation.stage, "keyDown", this.OnKeyDown);
			if (!Sounds.IsPlaying("answer_tiktak"))
			{
				Sounds.PlayEffect("answer_tiktak");
			}
			Platform.VibrateDevice();
			TweenMax.fromTo(this.INPUT.CLOCK.STRIP, Game.clocktimeout, {"scaleY": 1}, {
						"scaleY": 0,
						"ease": fl.motion.easing.Linear.easeNone,
						"onComplete": this.SendTip
					});
			TweenMax.fromTo(this.INPUT.CLOCK.ALERT, 1, {"frame": 1}, {
						"frame": 30,
						"delay": Game.clocktimeout - 5,
						"repeat": -1
					});
			TweenMax.fromTo(this.INPUT.CURSOR, 0.7, {
						"frame": 1,
						"visible": true
					}, {
						"frame": 30,
						"repeat": -1
					});
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
					Imitation.AddEventMouseDown(bbtn, this.OnBoosterButtonClick, {"id": (i == 1 ? "AVERAGE" : "RANGE")});
					TweenMax.delayedCall(1, this.BoosterButtonBold, [bbtn, (2 - i) * 0.2]);
					TweenMax.delayedCall(tut ? 1 : 6, this.BoosterButtonShake, [bbtn, true]);
					TweenMax.delayedCall(9, this.BoosterButtonInvisible, [bbtn]);
				}
			}
		}

		public function SetupButton(abtn:MovieClip, aparams:Array):void
		{
			Imitation.AddEventMouseDown(abtn, this.OnButtonDown, aparams);
			Imitation.AddEventClick(abtn, this.OnButtonClick, aparams);
		}

		private function OnKeyDown(e:*):*
		{
			var i:int = 0;
			var e2:Object = {"params": []};
			if (e.charCode >= 48 && e.charCode <= 57)
			{
				i = e.charCode - 48;
				e2.params = ["number", i];
				e2.target = this.INPUT.BUTTONS["NUM" + i];
				this.OnButtonDown(e2);
			}
			else if (e.charCode == 13)
			{
				e2.params = ["send"];
				e2.target = this.INPUT.BUTTONS.BTNSEND;
				this.OnButtonDown(e2);
			}
			else if (e.charCode == 8)
			{
				e2.params = ["del"];
				e2.target = this.INPUT.BUTTONS.DEL;
				this.OnButtonDown(e2);
			}
		}

		private function OnButtonDown(e:*):*
		{
			var t:String = null;
			var bt:String = e.params[0];
			if ("number" == bt)
			{
				t = this.INPUT.VALUE.text;
				if (t.length < 9)
				{
					t += String(e.params[1]);
				}
				this.INPUT.VALUE.text = t;
			}
			else if ("del" == bt)
			{
				t = this.INPUT.VALUE.text;
				this.INPUT.VALUE.text = t.substr(0, t.length - 1);
			}
			else if ("send" == bt)
			{
				this.SendTip(true);
			}
			var i:int = int(e.params.answer);
			TweenMax.killTweensOf(e.target);
			TweenMax.to(e.target, 0.08, {
						"scaleX": 0.8,
						"scaleY": 0.8
					});
			TweenMax.to(e.target, 0.2, {
						"delay": 0.08,
						"scaleX": 1,
						"scaleY": 1
					});
			Sounds.PlayEffect("click");
		}

		private function OnButtonClick(e:*):*
		{
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

		public function SendTip(ahuman:Boolean = false, too_slow:Boolean = true):void
		{
			this.waitingmytip = false;
			this.LARGE_PBOX_1.visible = true;
			if (!ahuman && too_slow)
			{
				Sounds.PlayVoice("voice_too_slow");
			}
			var israngehelpusing:Boolean = this.HELPOVERLAY.visible;
			this.StopInput();
			var tmp:String = String(this.INPUT.VALUE.text);
			var tip:String = "";
			var idx:int = 0;
			while (idx < tmp.length && (tmp.charAt(idx) < "0" || tmp.charAt(idx) > "9"))
			{
				idx++;
			}
			while (idx < tmp.length && tip.length < 9 && (tmp.charAt(idx) >= "0" || tmp.charAt(idx) <= "9"))
			{
				tip += tmp.charAt(idx);
				idx++;
			}
			if (tip.length > 0)
			{
				Game.mylastguess = parseInt(tip);
			}
			else
			{
				Game.mylastguess = -1;
			}
			if ((!ahuman || tip == "") && Game.mylastguess == 0 && this.timeoutanswer >= 0)
			{
				Game.mylastguess = this.timeoutanswer;
				tip = Util.StringVal(this.timeoutanswer);
			}
			if (tip == "" && israngehelpusing)
			{
				tip = Util.StringVal(this.HELPOVERLAY.BTN1.LABEL.text);
			}
			else if (tip == "")
			{
				tip = "0";
			}
			Comm.SendCommand("TIP", "TIP=\"" + tip + "\"" + (ahuman ? " HUMAN=\"1\"" : ""));
			this.mytip = Util.NumberVal(tip);
			this.sqadd_ShowMyTip();
			TweenMax.to(this.INPUT, 0.4, {
						"alpha": 0,
						"visible": false
					});
			this.DrawShootInfo();
			if (!Sys.gsqc.running)
			{
				Sys.gsqc.Start();
			}
		}

		public function OnBoosterButtonClick(e:*):void
		{
			this.HideBoosterButtons();
			Comm.SendCommand("HELP", "HELP=\"" + e.params.id + "\"", this.OnHelpCommandResult, this);
		}

		public function BoosterButtonBold(btn:MovieClip, delay:Number):void
		{
			if (btn && btn.visible && this.waitingmytip)
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
			if (btn && btn.visible && this.waitingmytip)
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

		public function OnHelpCommandResult(res:int, xml:XML):void
		{
			var aarr:Array = null;
			var toarow:int = 0;
			var i:int = 0;
			var btn:MovieClip = null;
			var tip:String = null;
			trace("QuessQuestionMov.OnHelpCommandResult...");
			var xmlobj:Object = Util.XMLTagToObject(xml);
			DBG.Trace("xmlobj", xmlobj);
			if (res != 0 || !xmlobj.HELP)
			{
				trace("error in help result.");
				return;
			}
			var tag:Object = xmlobj.HELP;
			var helpname:String = Util.StringVal(tag.HELP);
			if (helpname == "AVERAGE")
			{
				this.INPUT.VALUE.text = parseInt(tag.RESULT);
				Sounds.PlayEffect("tipaver_using");
				Sounds.PlayEffect("help_clicked");
			}
			else if (helpname == "RANGE")
			{
				this.HELPOVERLAY.visible = true;
				this.LARGE_PBOX_1.visible = false;
				Imitation.CollectChildrenAll(this);
				aarr = Util.StringVal(tag.RESULT).split(",");
				toarow = Util.Random(1, 4);
				for (i = 1; i <= 4; i++)
				{
					btn = this.HELPOVERLAY["BTN" + i];
					tip = Util.StringVal(aarr[i - 1]);
					btn.LABEL.text = tip;
					btn.visible = true;
					Imitation.AddEventClick(btn, this.OnRangeHelpClicked, {"value": tip});
					if (i == toarow)
					{
						this.timeoutanswer = aarr[i - 1];
					}
				}
				Sounds.PlayEffect("tiprang_using");
				Sounds.PlayEffect("help_clicked");
			}
		}

		public function OnRangeHelpClicked(e:*):*
		{
			trace("OnRangeHelpClicked: " + e.params.value);
			this.INPUT.VALUE.text = parseInt(e.params.value);
			this.SendTip(true, false);
		}

		public function StopInput():void
		{
			if (Sounds.IsPlaying("answer_tiktak"))
			{
				Sounds.StopEffect("answer_tiktak");
			}
			TweenMax.killChildTweensOf(this.INPUT.CLOCK);
			this.INPUT.CLOCK.ALERT.gotoAndStop(1);
			Util.RemoveEventListener(Imitation.stage, "keyDown", this.OnKeyDown);
			Imitation.DeleteEventGroup(this.INPUT);
			this.HideBoosterButtons();
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

		public function sqadd_ShowMyTip():void
		{
			var ao:* = undefined;
			var mytipbox:MovieClip = null;
			var targetx:Number = NaN;
			var self:GuessQuestionMov = this;
			mytipbox = this.MYANSWERBOX;
			Imitation.GotoFrame(mytipbox, Game.iam);
			mytipbox.VALUE.text = this.mytip;
			mytipbox.VALUE_TIME.text = "";
			mytipbox.VALUE_DIFF.text = "";
			mytipbox.TIME.visible = false;
			mytipbox.DIFF.visible = false;
			mytipbox.RANK.visible = false;
			this.animatemytiptoplace = true;
			mytipbox.x = 0;
			mytipbox.y = -90;
			mytipbox.scaleX = 0.7;
			mytipbox.scaleY = 0.7;
			mytipbox.alpha = 1;
			mytipbox.visible = true;
			targetx = -310;
			if (this.playertipboxnum[Game.iam] > 1)
			{
				targetx = 310;
			}
			Imitation.UpdateAll(mytipbox);
			mytipbox.visible = false;
			TweenMax.delayedCall(0.001, function():*
				{
					TweenMax.fromTo(mytipbox, 0.5, {
								"visible": true,
								"x": 0,
								"y": -90
							}, {
								"x": targetx,
								"y": 178,
								"ease": fl.motion.easing.Cubic.easeOut
							});
				});
		}

		public function ProcessTipInfo():*
		{
			var n:int = 0;
			var ti:Object = null;
			var pnum:int = 0;
			var tag:Object = Game.tag_tipinfo;
			for (n = 1; n <= 3; n++)
			{
				ti = this.playertips[n];
				ti.pnum = n;
				ti.value = -1;
				ti.timeorder = 0;
				ti.time = "";
				ti.accuracy = 0;
			}
			if (tag == null)
			{
				return;
			}
			this.tiptimeorder = [];
			var tor:String = Util.StringVal(tag.TIMEORDER);
			for (n = 1; n <= tor.length; n++)
			{
				pnum = Util.NumberVal(tor.charAt(n - 1));
				this.tiptimeorder.push(pnum);
				ti = this.playertips[pnum];
				ti.pnum = pnum;
				ti.value = Util.NumberVal(tag["V" + pnum], -1);
				if (ti.value > -1000000000 && ti.value < 0 && pnum == Game.iam && this.mytip >= 0)
				{
					ti.value = this.mytip;
				}
				ti.time = Util.StringVal(tag["T" + pnum], "");
				ti.timeorder = n;
				ti.accuracy = Util.NumberVal(tag["A" + pnum], 0);
			}
		}

		public function ProcesTipResult():*
		{
			var i:int = 0;
			var pnum:int = 0;
			var good:int = Util.NumberVal(Game.tag_tipresult.GOOD);
			var winner:int = Util.NumberVal(Game.tag_tipresult.WINNER);
			var second:int = Util.NumberVal(Game.tag_tipresult.SECOND, 0);
			for (i = 0; i < this.tiptimeorder.length; i++)
			{
				pnum = int(this.tiptimeorder[i]);
				this.playertips[pnum].difference = Math.abs(this.playertips[pnum].value - good);
				this.playertips[pnum].realdifference = this.playertips[pnum].value - good;
				if (this.playertips[pnum].realdifference == 0)
				{
					this.playertips[pnum].realdifference = " 0";
				}
				else if (this.playertips[pnum].realdifference > 0)
				{
					this.playertips[pnum].realdifference = "+" + Util.StringVal(this.playertips[pnum].realdifference);
				}
				if (second == 0 && pnum != winner)
				{
					second = pnum;
				}
			}
			this.tipwinorder = [];
			this.tipwinorder.push(winner);
			this.tipwinorder.push(second);
			if (this.tiptimeorder.length > 2)
			{
				this.tipwinorder.push(6 - winner - second);
			}
			for (i = 1; i <= 3; this.playertips[i].winorder = 3, i++)
			{
			}
			this.playertips[second].winorder = 2;
			this.playertips[winner].winorder = 1;
		}

		public function AnswerArrived():*
		{
			this.ProcessTipInfo();
			this.DrawShootInfo();
			if (!this.waitingmytip)
			{
				this.DrawAnswers();
			}
			Sounds.PlayEffect("arrow_shoot");
		}

		private function CheckSameTime():void
		{
			var newtime:Number = NaN;
			var t1:Object = this.playertips[this.tipwinorder[0]];
			var t2:Object = this.playertips[this.tipwinorder[1]];
			var t3:Object = !!this.tipwinorder[2] ? this.playertips[this.tipwinorder[2]] : null;
			if (t1 && t2 && t1.value == t2.value && t1.time == t2.time)
			{
				newtime = Util.NumberVal(t1.time) - 0.01;
				t1.time = Util.StringVal(newtime, "");
			}
			if (t2 && t3 && t2.value == t3.value && t2.time == t3.time)
			{
				newtime = Util.NumberVal(t3.time) + 0.01;
				t3.time = Util.StringVal(newtime, "");
			}
		}

		public function DrawShootInfo():*
		{
			var m:MovieClip = null;
			var ti:Object = null;
			var wvisible:Boolean = false;
			for (var pnum:int = 1; pnum <= 3; pnum++)
			{
				m = this.waitanims[pnum];
				if (m)
				{
					ti = this.playertips[pnum];
					wvisible = !this.waitingmytip && ti.timeorder < 1;
					if (wvisible)
					{
						if (!TweenMax.isTweening(this.waitanims[pnum]))
						{
							TweenMax.fromTo(this.waitanims[pnum], this.waitanims[pnum].totalFrames / 30, {"frame": 1}, {
										"frame": this.waitanims[pnum].totalFrames,
										"ease": fl.motion.easing.Linear.easeNone,
										"repeat": -1
									});
						}
						this.waitanims[pnum].visible = true;
					}
					else
					{
						TweenMax.killTweensOf(this.waitanims[pnum]);
						this.waitanims[pnum].gotoAndStop(1);
						this.waitanims[pnum].visible = false;
					}
					if (ti.timeorder > 0)
					{
						this.shootsigns[pnum].gotoAndStop(ti.timeorder);
						this.shootsigns[pnum].visible = true;
						this.shootsigns[pnum].alpha = 1;
					}
					else
					{
						this.shootsigns[pnum].visible = false;
					}
				}
			}
		}

		public function DrawCircles():*
		{
			var i:int = 0;
			var c:Object = null;
			var pnum:int = 0;
			var pt:* = undefined;
			var ap:* = undefined;
			var leftcolor:int = 0;
			var rightcolor:int = 0;
			var linewidth:Number = NaN;
			var maxcircles:int = this.playercount == 3 ? 2 : 1;
			var good:int = Util.NumberVal(Game.tag_tipresult.GOOD);
			this.CENTER.gotoAndStop(6);
			Util.RemoveChildren(this.CIRCLEMOV);
			this.CIRCLEMOV.graphics.clear();
			this.CIRCLEMOV.cacheAsBitmap = true;
			var bulls:Array = [];
			var circles:Array = [];
			for (i = 0; i < this.tipwinorder.length; i++)
			{
				pnum = int(this.tipwinorder[i]);
				pt = this.playertips[pnum];
				ap = this.arrowparams[this.playertipboxnum[pnum]];
				if (pt.value == good)
				{
					bulls.push(pnum);
					if (bulls.length == 1)
					{
						this.CENTER.gotoAndStop(pnum);
					}
					else if (bulls.length == 2)
					{
						if (this.playercount == 2 || (bulls[0] == Game.iam || bulls[1] == Game.iam))
						{
							this.CENTER.gotoAndStop(4);
							leftcolor = int(this.ARROW_1.SHAPE.currentFrame);
							rightcolor = bulls[1] == leftcolor ? int(bulls[0]) : int(bulls[1]);
							this.CENTER.LEFT.gotoAndStop(leftcolor);
							this.CENTER.RIGHT.gotoAndStop(rightcolor);
						}
						else
						{
							this.CENTER.gotoAndStop(5);
							this.CENTER.LEFT.visible = false;
							this.CENTER.TOP.gotoAndStop(this.ARROW_2.SHAPE.currentFrame);
							this.CENTER.BOTTOM.gotoAndStop(this.ARROW_3.SHAPE.currentFrame);
						}
					}
					else
					{
						this.CENTER.gotoAndStop(5);
						this.CENTER.LEFT.visible = true;
						this.CENTER.LEFT.gotoAndStop(this.ARROW_1.SHAPE.currentFrame);
						this.CENTER.TOP.gotoAndStop(this.ARROW_2.SHAPE.currentFrame);
						this.CENTER.BOTTOM.gotoAndStop(this.ARROW_3.SHAPE.currentFrame);
					}
				}
				else
				{
					c = {
							"distance": ap.distance,
							"colors": [pnum]
						};
					if (circles.length > 0 && circles[circles.length - 1].distance == c.distance)
					{
						circles[circles.length - 1].colors.push(pnum);
					}
					else
					{
						circles.push(c);
					}
				}
			}
			for (i = 0; i < circles.length; i++)
			{
				if (bulls.length + i >= maxcircles)
				{
					break;
				}
				linewidth = 3 - 1.75 * (bulls.length + i);
				this.DrawColorCircle(circles[i].distance, circles[i].colors, linewidth);
			}
			this.CIRCLEMOV.visible = true;
			Imitation.FreeBitmapAll(this.CIRCLEMOV);
			Imitation.UpdateAll(this.CIRCLEMOV);
			Imitation.UpdateAll(this.CENTER);
			this.CIRCLEMOV.visible = false;
			this.CENTER.visible = false;
		}

		internal function DrawColorCircle(distance:Number, pnums:Array, linewidth:Number):*
		{
			var arclen2:Number = NaN;
			var fi:Number = 0;
			if (distance > 90)
			{
				fi = 90 - Math.asin(90 / distance) * 180 / Math.PI;
			}
			var startangle:Number = 90 + fi;
			var arcangle:Number = 360 - 2 * fi;
			var endangle:Number = startangle + arcangle;
			if (pnums.length == 1)
			{
				this.CIRCLEMOV.graphics.lineStyle(linewidth, circle_colors[pnums[0]]);
				this.DrawArc(this.CIRCLEMOV.graphics, distance, startangle, arcangle);
				return;
			}
			var i:int = 0;
			var arcstart:Number = startangle;
			var coloredportion:Number = 0.5;
			var arclen:Number = 10 * 100 / distance;
			while (arcstart < endangle)
			{
				arclen2 = arclen;
				if (arcstart + arclen2 > endangle)
				{
					arclen2 = endangle - arcstart;
				}
				this.CIRCLEMOV.graphics.lineStyle(linewidth, circle_colors[pnums[i]]);
				this.DrawArc(this.CIRCLEMOV.graphics, distance, arcstart, arclen2 * coloredportion);
				arcstart += arclen;
				i++;
				if (i >= pnums.length)
				{
					i = 0;
				}
			}
		}

		internal function DrawArc(gr:Graphics, _r:Number, _startangle:Number, _arcangle:Number):void
		{
			var i:int = 0;
			var yradius:Number = _r;
			var cx:Number = 0;
			var cy:Number = 0;
			var segs:Number = Math.ceil(Math.abs(_arcangle) / 45);
			var segangle:Number = _arcangle / segs;
			var theta:Number = -(segangle / 180) * Math.PI;
			var angle:Number = -(_startangle / 180) * Math.PI;
			var ax:Number = 0;
			var ay:Number = 0;
			var anglemid:Number = angle - theta / 2;
			var bx:Number = ax + Math.cos(angle) * _r;
			var by:Number = ay + Math.sin(angle) * yradius;
			gr.moveTo(bx, by);
			if (segs > 0)
			{
				for (i = 0; i < segs; i++)
				{
					angle += theta;
					anglemid = angle - theta / 2;
					bx = ax + Math.cos(angle) * _r;
					by = ay + Math.sin(angle) * yradius;
					cx = ax + Math.cos(anglemid) * (_r / Math.cos(theta / 2));
					cy = ay + Math.sin(anglemid) * (yradius / Math.cos(theta / 2));
					gr.curveTo(cx, cy, bx, by);
				}
			}
		}

		public function HideWaitAnims():*
		{
			var m:MovieClip = null;
			for (var pnum:int = 1; pnum <= 3; pnum++)
			{
				m = this.waitanims[pnum];
				if (m)
				{
					TweenMax.killTweensOf(this.waitanims[pnum]);
					this.waitanims[pnum].gotoAndStop(1);
					this.waitanims[pnum].visible = false;
				}
			}
		}

		public function DrawAnswers():*
		{
			var pnum:int = 0;
			var tb:MovieClip = null;
			var ti:Object = null;
			for (pnum = 1; pnum <= 3; pnum++)
			{
				tb = this.tipboxes[this.playertipboxnum[pnum]];
				if (tb)
				{
					ti = this.playertips[pnum];
					if (ti.timeorder > 0)
					{
						tb.gotoAndStop(ti.pnum);
						tb["VALUE"].text = ti.value <= -1000000000 ? "-" : (ti.value >= 0 ? ti.value : "");
						tb["VALUE_TIME"].text = ti.value <= -1000000000 ? "" : String(Util.RoundDecimalPlace(Util.NumberVal(ti.time), 2));
						tb["VALUE_DIFF"].text = ti.value < 0 ? "" : String(ti.realdifference);
						tb["DIFF"].visible = ti.value >= 0;
						tb["TIME"].visible = ti.value >= 0;
						tb["RANK"].visible = false;
						tb.x = this.tipboxx[this.playertipboxnum[pnum]];
						tb.y = this.tipboxy[ti.timeorder];
						tb.scaleY = 1;
						tb.scaleX = 1;
						if (this.playercount == 3)
						{
							Imitation.GotoFrame(tb["RANK"], Util.NumberVal(ti.winorder));
							Imitation.FreeBitmapAll(tb["RANK"]);
						}
					}
					tb.visible = false;
				}
			}
		}

		public function sqadd_Evaluate():*
		{
			var good:int;
			var fasoldiercount:int;
			var ao:* = undefined;
			var i:int = 0;
			var pnum:int = 0;
			var m:MovieClip = null;
			var self:MovieClip = null;
			var winner:int = 0;
			var second:int = 0;
			var tb:MovieClip = null;
			var sm:AreaMarkerMov = null;
			var smscale:Number = NaN;
			var tbnum:int = 0;
			var boxnum:int = 0;
			self = this;
			this.waitingmytip = false;
			this.ProcessTipInfo();
			this.ProcesTipResult();
			this.CalculateArrows();
			this.CheckSameTime();
			this.DrawShootInfo();
			this.DrawCircles();
			this.DrawAnswers();
			this.HideWaitAnims();
			good = Util.NumberVal(Game.tag_tipresult.GOOD);
			winner = Util.NumberVal(Game.tag_tipresult.WINNER);
			second = int(this.tipwinorder[1]);
			for (pnum = 1; pnum <= 3; pnum++)
			{
				tb = this.tipboxes[this.playertipboxnum[pnum]];
				if (tb)
				{
					tb.visible = true;
					tb.scaleX = 1;
					tb.scaleY = 1;
					Imitation.UpdateAll(tb);
					tb.visible = false;
				}
			}
			this.GOODANSWER.ANSWER.text = String(good);
			this.GOODANSWER.scaleX = 1;
			this.GOODANSWER.scaleY = 1;
			this.GOODANSWER.alpha = 1;
			this.GOODANSWER.visible = true;
			Imitation.UpdateAll(this.GOODANSWER);
			this.GOODANSWER.visible = false;
			for (i = 1; i <= 3; i++)
			{
				m = this["ARROW_" + i];
				m.visible = true;
				m.scaleX = arrowscale;
				m.scaleY = arrowscale;
				Imitation.UpdateAll(m);
				m.visible = false;
			}
			fasoldiercount = Math.min(3, Map.areanum - Game.gameround * 3);
			if (Game.rules == 0)
			{
				fasoldiercount = 1;
			}
			if (Game.state == 3)
			{
				for (i = 1; i <= fasoldiercount; i++)
				{
					sm = Main.mc["FASOLDIER" + i];
					pnum = i < 3 ? winner : second;
					sm.Setup(pnum, 200, 0);
					sm.CVALUE.visible = false;
					smscale = this.scaleY / 0.97;
					sm.scaleX = smscale;
					sm.scaleY = smscale;
					tbnum = this.playertipboxnum[pnum];
					if (tbnum == 1)
					{
						sm.x = this.x + -280 * this.scaleX;
						sm.y = -70;
						if (i == 2)
						{
							sm.x += 35 * smscale;
						}
					}
					else
					{
						sm.x = this.x + 275 * this.scaleX;
						sm.y = tbnum == 2 ? -65 : 25;
						if (i == 1)
						{
							sm.x -= 35 * smscale;
						}
					}
					sm.y = this.y + sm.y * this.scaleY;
					sm.alpha = 1;
					sm.visible = true;
					Imitation.UpdateAll(sm);
					sm.visible = false;
				}
			}
			Sys.gsqc.AddDelay(0.6);
			ao = Sys.gsqc.AddTweenObj("GuessEvaluate.showgood");
			ao.mov = this.GOODANSWER;
			ao.Start = function():*
			{
				this.AddTweenMaxFromTo(this.mov, 0.5, {
							"visible": true,
							"scaleX": 0,
							"scaleY": 0
						}, {
							"scaleX": 1,
							"scaleY": 1,
							"ease": fl.motion.easing.Bounce.easeOut
						});
				Sounds.PlayEffect("guess_good_answer");
			};
			for (i = 0; i < this.tiptimeorder.length; i++)
			{
				pnum = int(this.tiptimeorder[i]);
				boxnum = this.playertipboxnum[pnum];
				ao = Sys.gsqc.AddTweenObj("GuessEvaluate.hideshoot." + i);
				ao.mov = this.shootsigns[pnum];
				ao.Start = function():*
				{
					this.AddTweenMaxFromTo(this.mov, 0.03, {
								"visible": true,
								"alpha": 1
							}, {
								"alpha": 0,
								"visible": false
							});
				};
				ao = Sys.gsqc.AddTweenObj("GuessEvaluate.arrow." + i);
				ao.mov = this["ARROW_" + boxnum];
				ao.params = this.arrowparams[boxnum];
				ao.Start = function():*
				{
					var apar:Object = this.params;
					this.AddTweenMaxFromTo(this.mov, 0.1, {
								"visible": true,
								"x": apar.startx,
								"y": apar.starty
							}, {
								"x": apar.endx,
								"y": apar.endy,
								"ease": fl.motion.easing.Linear.easeOut
							});
				};
				ao = Sys.gsqc.AddTweenObj("GuessEvaluate.arrowvibrate." + i);
				ao.mov = this["ARROW_" + boxnum];
				ao.box = this["BOX_" + boxnum];
				ao.params = this.arrowparams[boxnum];
				ao.fromscale = arrowscale;
				ao.Start = function():*
				{
					this.mov.MARK.visible = true;
					this.AddTweenMaxFromTo(this.mov, 0.05, {"scaleX": this.fromscale}, {
								"scaleX": this.fromscale * 0.95,
								"repeat": 2,
								"yoyo": true
							});
					Sounds.PlayEffect("arrow_hit");
				};
				ao = Sys.gsqc.AddTweenObj("GuessEvaluate.showbox." + i);
				ao.mov = this["BOX_" + boxnum];
				ao.pnum = pnum;
				ao.Start = function():*
				{
					var sx:Number = Number(this.mov.x);
					var sy:Number = Number(this.mov.y);
					var ss:Number = 0;
					var easing:* = fl.motion.easing.Bounce.easeOut;
					if (this.pnum == Game.iam)
					{
						sx = Number(self.MYANSWERBOX.x);
						sy = Number(self.MYANSWERBOX.y);
						ss = Number(self.MYANSWERBOX.scaleX);
						self.MYANSWERBOX.visible = false;
						easing = fl.motion.easing.Cubic.easeOut;
					}
					this.AddTweenMaxFromTo(this.mov, 0.3, {
								"visible": true,
								"scaleX": ss,
								"scaleY": ss,
								"x": sx,
								"y": sy
							}, {
								"scaleX": 1,
								"scaleY": 1,
								"x": this.mov.x,
								"y": this.mov.y,
								"ease": easing
							});
				};
			}
			ao = Sys.gsqc.AddTweenObj("GuessEvaluate.showcircles.2");
			ao.centermov = this.CENTER;
			ao.circlemov = this.CIRCLEMOV;
			ao.Start = function():*
			{
				this.AddTweenMaxFromTo(this.centermov, 0.3, {
							"visible": true,
							"alpha": 0
						}, {
							"alpha": 1,
							"ease": fl.motion.easing.Linear.easeNone
						});
				this.AddTweenMaxFromTo(this.circlemov, 0.3, {
							"visible": true,
							"alpha": 0
						}, {
							"alpha": 1,
							"ease": fl.motion.easing.Linear.easeNone
						});
			};
			if (this.playercount == 3)
			{
				ao = Sys.gsqc.AddTweenObj("GuessEvaluate.showranks");
				ao.boxranks = [null, this.BOX_1.RANK, this.BOX_2.RANK, this.BOX_3.RANK];
				ao.Start = function():*
				{
					for (i = 1; i <= 3; ++i)
					{
						this.AddTweenMaxFromTo(this.boxranks[i], 0.2, {
									"visible": true,
									"alpha": 0
								}, {
									"alpha": 1,
									"ease": fl.motion.easing.Linear.easeNone
								});
					}
				};
			}
			ao = Sys.gsqc.AddObj("GuessEvaluate.flashwinner");
			ao.winnerbox = this.tipboxes[this.playertipboxnum[winner]];
			ao.winnerflag = this.playerflags[winner];
			ao.Start = function():*
			{
				TweenMax.fromTo(this.winnerbox, 0.2, {
							"scaleX": 1,
							"scaleY": 1
						}, {
							"scaleX": 1.1,
							"scaleY": 1.1,
							"repeat": -1,
							"ease": fl.motion.easing.Cubic.easeOut,
							"yoyo": true
						});
				TweenMax.fromTo(this.winnerflag, 0.5, {
							"scaleX": 1,
							"scaleY": 1
						}, {
							"scaleX": 1.1,
							"scaleY": 1.1,
							"repeat": -1,
							"ease": fl.motion.easing.Linear.easeNone,
							"yoyo": true
						});
				this.Next();
				if (winner == Game.iam)
				{
					Sounds.PlayEffect("fanfare_win");
				}
				else if (Game.state == 3 && second != Game.iam)
				{
					Sounds.PlayEffect("fanfare_lose");
				}
				else if (Game.state == 4 && (Game.offender == Game.iam || Game.defender == Game.iam))
				{
					Sounds.PlayEffect("fanfare_lose");
				}
				else
				{
					Sounds.PlayEffect("fanfare_draw");
				}
			};
			ao = Sys.gsqc.AddObj("GuessEvaluate.reorder");
			ao.self = this;
			ao.Start = function():*
			{
				var boxnum:int = 0;
				var tb:MovieClip = null;
				var wo:int = 0;
				for (var pnum:int = 1; pnum <= 3; pnum++)
				{
					boxnum = int(this.self.playertipboxnum[pnum]);
					tb = this.self.tipboxes[boxnum];
					if (tb)
					{
						wo = int(this.self.playertips[pnum].winorder);
						TweenMax.to(tb, 1, {"y": this.self.tipboxy[wo]});
					}
				}
				this.Next();
			};
			Sys.gsqc.AddDelay(1);
			if (Game.state == 3)
			{
				for (i = 1; i <= fasoldiercount; i++)
				{
					ao = Sys.gsqc.AddTweenObj("GuessEvaluate.showsoldiers");
					ao.mov = Main.mc["FASOLDIER" + i];
					ao.Start = function():*
					{
						this.AddTweenMaxFromTo(this.mov, 0.25, {
									"visible": true,
									"scaleX": smscale * 2,
									"scaleY": smscale * 2,
									"alpha": 0
								}, {
									"scaleX": smscale,
									"scaleY": smscale,
									"alpha": 1
								});
					};
					if (i == 2)
					{
						Sys.gsqc.AddDelay(0.1);
					}
				}
			}
			Sys.gsqc.AddDelay(1);
			ao = Sys.gsqc.AddObj("GuessEvaluate.finalization");
			ao.winnerbox = this.tipboxes[this.playertipboxnum[winner]];
			ao.winnerflag = this.playerflags[winner];
			ao.Start = function():*
			{
				TweenMax.killTweensOf(this.winnerbox);
				TweenMax.killTweensOf(this.winnerflag);
				this.Next();
			};
		}

		public function CalculateArrows():*
		{
			var i:int = 0;
			var pnum:int = 0;
			var pt:* = undefined;
			var ap:* = undefined;
			var p:Point = null;
			var good:int = Util.NumberVal(Game.tag_tipresult.GOOD);
			var lastdistance:Number = 0;
			var lastdifference:Number = -1;
			for (i = 0; i < this.tipwinorder.length; i++)
			{
				pnum = int(this.tipwinorder[i]);
				pt = this.playertips[pnum];
				ap = this.arrowparams[this.playertipboxnum[pnum]];
				if (pt.value == good)
				{
					ap.distance = 12;
				}
				else
				{
					ap.distance = Math.round(closest_radius + (worst_radius - closest_radius) * (100 - pt.accuracy) / 100);
					if (lastdistance < closest_radius - min_arrow_distance)
					{
						lastdistance = closest_radius - min_arrow_distance;
					}
					if (ap.distance < lastdistance)
					{
						ap.distance = lastdistance;
					}
					if (i > 0 && pt.difference > lastdifference && ap.distance < lastdistance + min_arrow_distance)
					{
						ap.distance = lastdistance + min_arrow_distance;
					}
				}
				p = this.PolarCoords(ap.angle, ap.distance);
				ap.endx = p.x;
				ap.endy = p.y;
				lastdifference = Number(pt.difference);
				lastdistance = Number(ap.distance);
			}
			var maxboxdist:* = 195;
			for (i = 0; i < this.tipwinorder.length; i++)
			{
				pnum = int(this.tipwinorder[i]);
				pt = this.playertips[pnum];
				ap = this.arrowparams[this.playertipboxnum[pnum]];
				if (this.playertipboxnum[pnum] == 1)
				{
					ap.boxy = ap.endy + 30;
					ap.boxx = ap.endx - 70;
				}
				else
				{
					ap.boxy = ap.endy + 30;
					ap.boxx = ap.endx + 70;
					if (this.tipwinorder.length == 3)
					{
						if (this.playertipboxnum[pnum] == 2)
						{
							ap.boxy = ap.endy - 17;
						}
					}
				}
			}
		}

		public function sqadd_ShowQuestion():*
		{
			var ao:* = undefined;
			var mcvisible:Boolean = false;
			this.first = true;
			mcvisible = MCQuestionMov.mc.visible;
			ao = Sys.gsqc.AddTweenObj("GuessQuestion.show.prepare");
			ao.self = this;
			ao.Start = function():*
			{
				this.self.Show();
				this.self.visible = false;
				Imitation.UpdateToDisplay(this.self);
				this.Next();
			};
			ao = Sys.gsqc.AddTweenObj("GuessQuestion.show");
			ao.self = this;
			ao.Start = function():*
			{
				if (mcvisible)
				{
					Sys.gsqc.PlayEffect("question_out");
					MCQuestionMov.mc.visible = false;
				}
				this.AddTweenMaxTo(this.self, 0.01, {
							"visible": true,
							"onComplete": function():*
							{
								Standings.UpdateChatButtons();
							}
						});
				this.AddTweenMaxTo(this.self.BACK, 0.3, {
							"scaleX": this.self.scaleX * 1.05,
							"repeat": 1,
							"yoyo": true
						});
				this.AddTweenMaxTo(Main.mc.QSHADER, 0.3, {"alpha": 0.5});
				if (!mcvisible)
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
			ao = Sys.gsqc.AddTweenObj("GuessQuestion.hide 1");
			ao.self = this;
			ao.Start = function():*
			{
				this.AddTweenMaxTo(this.self, 0.3, {
							"y": Imitation.stage.stageHeight + this.self.BOUNDS.height,
							"ease": fl.motion.easing.Cubic.easeIn
						});
				this.AddTweenMaxTo(Main.mc.QSHADER, 0.5, {"alpha": 0});
				Sounds.PlayEffect("question_out");
			};
			ao = Sys.gsqc.AddObj("GuessQuestion.hide 2");
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
