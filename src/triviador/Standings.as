package triviador
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.text.*;
	import syscode.*;
	import triviador.gfx.IngameChat;
	import triviador.gfx.GuessQuestionMov;
	import triviador.gfx.MCQuestionMov;

	public class Standings
	{
		public static var mc:MovieClip;

		private static var boxorder:Array;

		public static const usecombine:Boolean = false;

		public static var boxpositionx:Array = [null, 0, 0, 0];

		public static var boxpositiony:Array = [null, 0, 0, 0];

		public static var currentx:Array = [null, 0, 0, 0];

		public static var currenty:Array = [null, 0, 0, 0];

		public static var prevx:Array = [null, 0, 0, 0];

		public static var prevy:Array = [null, 0, 0, 0];

		public static var attackerbox:int = 0;

		public static var defenderbox:int = 0;

		public static var removedbox:int = 0;

		public static var scores:Array = [0, 0, 0, 0];

		public static var playerdata:Array = [null, {}, {}, {}];

		public static var animrunning:Boolean = false;

		private static var current_pos:int = 0;

		private static var chatlength:int = 0;

		public static var current_player:int = 0;

		public static var defender_player:int = 0;

		public static var emotions:MovieClip = null;

		public static var buttons:MovieClip = null;

		public static var chatstate:String = "base";

		public static var firstframe:int = 1;

		public function Standings()
		{
			super();
		}

		public static function Init(amov:MovieClip):*
		{
			mc = amov;
			Clear();
			mc.STATUS.gotoAndStop(firstframe);
		}

		public static function Clear():*
		{
			var b:* = undefined;
			for (var n:int = 1; n <= 3; n++)
			{
				b = mc["BOX" + n];
				Util.StopAllChildrenMov(b);
				b.visible = false;
			}
		}

		public static function SetVisible(avisible:Boolean):void
		{
			mc.visible = avisible;
		}

		public static function UpdateLayout():*
		{
			var b:* = undefined;
			var boxgap:Number = 4 * Game.boxscale;
			mc.x = boxgap;
			mc.y = boxgap;
			var boxw:Number = mc.BOX1.BOUNDS.width * Game.boxscale + boxgap;
			var boxh:Number = mc.BOX1.BOUNDS.height * Game.boxscale + boxgap;
			boxpositionx[1] = 0;
			boxpositiony[1] = 0;
			if (Map.verticallayout)
			{
				boxpositionx[2] = 0;
				boxpositiony[2] = boxh;
				boxpositionx[3] = 0;
				boxpositiony[3] = 2 * boxh;
			}
			else
			{
				boxpositionx[2] = boxw;
				boxpositiony[2] = 0;
				boxpositionx[3] = 2 * boxw;
				boxpositiony[3] = 0;
			}
			for (var n:int = 1; n <= 3; n++)
			{
				b = mc["BOX" + n];
				b.x = boxpositionx[n];
				b.y = boxpositiony[n];
				b.FLAG.visible = false;
				b.ATTACK.visible = false;
				b.DEFEND.visible = false;
				b.DARK.alpha = 0;
			}
			UpdateBoxOrder();
			HiliteCurrentPlayer();
		}

		public static function AnimationComplete():*
		{
		}

		public static function Update():*
		{
			var n:int = 0;
			var p:* = undefined;
			for (n = 1; n <= 3; n++)
			{
				p = Game.players[n];
				SetPlayer(n, p.name, p.id, p.xplevel, p.countryid, p.actleague);
				SetScore(n, p.points);
			}
			if (!mc.visible)
			{
				mc.visible = true;
			}
			UpdateChatButtons();
		}

		public static function SetPlayer(pnum:int, aname:String, aid:Number, xplevel:String, countryid:String, actleague:int):void
		{
			var name:String = null;
			var a:Object = null;
			trace("Standings.SetPlayer(" + pnum + "," + aname + "," + aid + "," + xplevel + "," + countryid + ")");
			if (aid == Sys.mydata.id && aname.length <= 0)
			{
				name = Lang.Get("me");
			}
			else
			{
				name = Romanization.ToLatin(aname);
			}
			var b:* = mc["BOX" + pnum];
			b.BOUNDS.visible = false;
			b.BASE.NAME_HOLDER.gotoAndStop(pnum);
			Util.SetText(b.BASE.NAME_HOLDER.NAME, name);
			b.BASE.AFRAME.gotoAndStop(pnum);
			Imitation.FreeBitmapAll(b.BASE);
			b.SCOREANIM.gotoAndStop(1);
			b.SCOREANIM.SCOREMOV.gotoAndStop(pnum);
			Imitation.SetMaskedMov(b.SCOREANIM.SCOREMASK, b.SCOREANIM.SCOREMOV, false);
			b.AVATAR.AVATAR.mt = Game.roomtype == "M" || Game.roomtype == "T";
			b.AVATAR.ShowUID(aid, Imitation.FreeBitmapAll, [b.AVATAR]);
			if (aid)
			{
				b.AVATAR.ShowFrame(xplevel, actleague);
			}
			b.AVATAR.AVATAR.DisableClick();
			playerdata[pnum].id = aid;
			b.id = aid;
			var cid:* = Util.StringVal(countryid);
			playerdata[pnum].countryid = cid;
			if (usecombine)
			{
				Imitation.Combine(b, true);
			}
			if (b.EMO)
			{
				b.EMO.visible = false;
				if (Sys.mydata.id != aid && aid > 0)
				{
					Imitation.AddEventClick(b.AVATAR, OnButtons);
				}
			}
			var f:Object = null;
			for (var i:int = 0; i < Friends.all.length; i++)
			{
				a = Friends.all[i];
				if (a.id == Game.players[pnum].id && a.flag != 4)
				{
					f = a;
					break;
				}
			}
			b.FRIEND.visible = f && (f.flag == 0 || f.flag == 1);
			b.BLOCKED.visible = f && f.flag == 3;
			b.visible = true;
		}

		private static function OnButtons(e:*):void
		{
			var box:MovieClip;
			var m:MovieClip;
			var f:Object;
			if (buttons)
			{
				return;
			}
			Util.RemoveEventListener(Imitation.stage, MouseEvent.CLICK, OnStageClick);
			if (emotions)
			{
				MovieClip(emotions.parent).gotoAndStop(1);
			}
			emotions = null;
			box = e.target.parent;
			box.gotoAndStop(3);
			box.parent.addChild(box);
			Imitation.CollectChildrenAll(box.parent);
			IngameChat.Hide();
			m = box.BUTTONS;
			Util.StopAllChildrenMov(m);
			buttons = m;
			Imitation.CollectChildrenAll(box);
			TweenMax.delayedCall(0.1, function():*
				{
					Util.AddEventListener(Imitation.stage, MouseEvent.CLICK, OnStageClick);
				});
			f = Friends.GetUser(box.id);
			if (Boolean(f) && (f.flag == 0 || f.flag == 1))
			{
				m.gotoAndStop(2);
				m.BTNCANCELF.SetLangAndClick("cancel_friendship", OnButtonClick);
			}
			else if (Boolean(f) && f.flag == 3)
			{
				m.gotoAndStop(3);
				m.BTNCANCELB.SetLangAndClick("cancel_block", OnButtonClick);
			}
			else
			{
				m.gotoAndStop(1);
				Imitation.AddEventClick(m.BTNFRIEND, OnButtonClick);
				m.BTNFRIEND.SetCaption("");
				Imitation.AddEventClick(m.BTNBLOCK, OnButtonClick);
				m.BTNBLOCK.SetCaption("");
			}
		}

		private static function OnStageClick(e:MouseEvent):void
		{
			var hit:Boolean;
			if (!emotions && !buttons)
			{
				Util.RemoveEventListener(Imitation.stage, MouseEvent.CLICK, OnStageClick);
				return;
			}
			hit = Boolean(emotions) && emotions.getRect(Imitation.stage).contains(Imitation.stage.mouseX, Imitation.stage.mouseY) || Boolean(buttons) && buttons.getRect(Imitation.stage).contains(Imitation.stage.mouseX, Imitation.stage.mouseY);
			if (hit)
			{
				return;
			}
			Util.RemoveEventListener(Imitation.stage, MouseEvent.CLICK, OnStageClick);
			TweenMax.delayedCall(0.1, function():*
				{
					if (emotions)
					{
						MovieClip(emotions.parent).gotoAndStop(1);
					}
					if (buttons)
					{
						MovieClip(buttons.parent).gotoAndStop(1);
					}
					emotions = null;
					buttons = null;
				});
			e.stopImmediatePropagation();
		}

		private static function OnButtonClick(e:*):void
		{
			var box:MovieClip = null;
			Util.RemoveEventListener(Imitation.stage, MouseEvent.CLICK, OnStageClick);
			if (e.target)
			{
				box = e.target.parent.parent;
				box.gotoAndStop(1);
				if (e.target == buttons.BTNFRIEND)
				{
					Friends.AddFriendShip(box.id, Update);
				}
				if (e.target == buttons.BTNBLOCK)
				{
					Friends.BlockUser(box.id, Update);
				}
				if (e.target == buttons.BTNCANCELF)
				{
					Friends.CancelFriendShip(box.id, Update);
				}
				if (e.target == buttons.BTNCANCELB)
				{
					Friends.CancelBlock(box.id, Update);
				}
			}
			buttons = null;
		}

		public static function ShowEmotion(pnum:int, anim_id:int):Boolean
		{
			var box:MovieClip = mc["BOX" + pnum];
			var a:LegoAvatarMov = box.AVATAR.AVATAR;
			a.Clear();
			a.ShowUID(Game.players[pnum].id, null, null, anim_id);
			return a.isinternal;
		}

		public static function SetScore(pnum:*, ascore:*):void
		{
			scores[pnum] = ascore;
			var b:MovieClip = mc["BOX" + pnum];
			TweenMax.killChildTweensOf(b, true);
			b.SCOREANIM.gotoAndStop(1);
			b.SCOREANIM.SCOREMOV.SCORE1.text = ascore;
			b.SCOREANIM.SCOREMOV.SCORE1.alpha = 1;
			b.SCOREANIM.SCOREMOV.SCORE2.visible = false;
		}

		public static function GetScore(_pnum:int):int
		{
			var b:MovieClip = mc["BOX" + _pnum];
			return b.SCOREANIM.SCOREMOV.SCORE1.text;
		}

		public static function sqadd_ScoreChange(pnum:*, anewscore:*):*
		{
			var ao:*;
			var scorechange:* = undefined;
			scorechange = anewscore - scores[pnum];
			if (scorechange == 0)
			{
				return;
			}
			ao = Sys.gsqc.AddObj("SCORECHANGE");
			ao.boxmov = mc["BOX" + pnum];
			ao.samov = mc["BOX" + pnum].SCOREANIM;
			ao.oldscore = scores[pnum];
			ao.scorechange = scorechange;
			ao.Start = function():*
			{
				var sa:* = this.samov;
				if (usecombine)
				{
					Imitation.Combine(this.boxmov, false);
				}
				sa.CHANGEMOV1.visible = !Map.verticallayout;
				sa.CHANGEMOV2.visible = Map.verticallayout;
				sa.CHANGEMOV1.gotoAndStop(pnum);
				sa.CHANGEMOV2.gotoAndStop(pnum);
				sa.CHANGEMOV1.CHANGE.text = (this.scorechange > 0 ? "+" : "") + this.scorechange;
				sa.CHANGEMOV2.CHANGE.text = (this.scorechange > 0 ? "+" : "") + this.scorechange;
				if (this.scorechange > 0)
				{
					sa.SCOREMOV.SCORE1.text = this.oldscore;
					sa.SCOREMOV.SCORE2.text = this.oldscore + this.scorechange;
				}
				else
				{
					sa.SCOREMOV.SCORE2.text = this.oldscore;
					sa.SCOREMOV.SCORE1.text = this.oldscore + this.scorechange;
				}
				sa.SCOREMOV.SCORE2.visible = true;
				Sounds.PlayEffect("score_change");
				if (scorechange > 0)
				{
					TweenMax.fromTo(mc["BOX" + pnum].SCOREANIM, 0.95, {"frameLabel": "INCREMENT_BEGIN"}, {
								"frameLabel": "INCREMENT_END",
								"ease": Linear.easeNone
							});
				}
				else
				{
					TweenMax.fromTo(mc["BOX" + pnum].SCOREANIM, 0.95, {"frameLabel": "DECREMENT_BEGIN"}, {
								"frameLabel": "DECREMENT_END",
								"ease": Linear.easeNone
							});
				}
				TweenMax.delayedCall(0.98, function():*
					{
						// FIXME - this is a guess
						ScoreAnimFinished;
						// [mc["BOX" + pnum].SCOREANIM, anewscore];
						mc["BOX" + pnum].SCOREANIM = anewscore;
					});
				this.Next();
			};
			if (Game.lpnum == 3 || Game.state == 4)
			{
				Sys.gsqc.AddDelay(1);
			}
			else
			{
				Sys.gsqc.AddDelay(0.1);
			}
			scores[pnum] = anewscore;
		}

		public static function ScoreAnimFinished(sa:MovieClip, anewscore:int):*
		{
			sa.SCOREMOV.SCORE1.text = anewscore;
			sa.SCOREMOV.SCORE2.text = anewscore;
			sa.CHANGEMOV1.visible = false;
			sa.CHANGEMOV2.visible = false;
			if (usecombine)
			{
				Imitation.Combine(sa.parent, true);
			}
		}

		public static function CalculateBoxOrder(scores:* = null):Array
		{
			var result:Array;
			var sortfunc:*;
			if (!scores)
			{
				scores = Standings.scores;
			}
			result = [1, 2, 3];
			sortfunc = function(a:*, b:*):*
			{
				if (scores[a] > scores[b])
				{
					return -1;
				}
				if (scores[a] < scores[b])
				{
					return 1;
				}
				if (!Map.verticallayout)
				{
					if (currentx[a] < currentx[b])
					{
						return -1;
					}
					if (currentx[a] > currentx[b])
					{
						return 1;
					}
				}
				else
				{
					if (currenty[a] < currenty[b])
					{
						return -1;
					}
					if (currenty[a] > currenty[b])
					{
						return 1;
					}
				}
				return 0;
			};
			result.sort(sortfunc);
			return result;
		}

		public static function sqadd_ReorderBoxes(aneworder:Array = null):*
		{
			var aor:Object;
			var aom:Object;
			var aod:Object;
			var n:*;
			var tx:* = undefined;
			var ty:* = undefined;
			var boxnum:* = undefined;
			var box:* = undefined;
			var neworder:Array = aneworder;
			if (neworder == null)
			{
				neworder = CalculateBoxOrder();
			}
			aor = null;
			aom = null;
			aod = null;
			for (n = 1; n <= 3; n++)
			{
				tx = boxpositionx[n];
				ty = boxpositiony[n];
				boxnum = neworder[n - 1];
				box = mc["BOX" + boxnum];
				if (currentx[boxnum] != tx || currenty[boxnum] != ty)
				{
					Standings.SetAnimRunning(true);
					if (aor == null)
					{
						aor = Sys.gsqc.AddDelayedTweenObj("BOXRISE");
						aom = Sys.gsqc.AddDelayedTweenObj("BOXMOVE");
						aod = Sys.gsqc.AddDelayedTweenObj("BOXDROP");
						aor.boxorder = neworder;
						aor.smov = mc;
						aor.Prepare = function():*
						{
							Standings.boxorder = this.boxorder;
							for (var i:int = 1; i <= 3; i++)
							{
								this.smov.setChildIndex(this.smov["BOX" + this.boxorder[i - 1]], this.smov.numChildren - i);
							}
							Imitation.CollectChildren(this.smov);
						};
					}
					if (tx < currentx[boxnum] || ty < currenty[boxnum])
					{
						aor.AddTweenMaxTo(box, 0.15, {
									"scaleX": Game.boxscale * 1.1,
									"scaleY": Game.boxscale * 1.1
								});
						if (boxnum == Game.iam && n == 1)
						{
							Sys.gsqc.PlayVoiceWaitForEnd("OnTheLead");
						}
					}
					else
					{
						aor.AddTweenMaxTo(box, 0.15, {
									"scaleX": Game.boxscale * 0.9,
									"scaleY": Game.boxscale * 0.9
								});
						if (boxnum == Game.iam)
						{
							Sys.gsqc.PlayVoiceWaitForEnd("FallBack");
						}
					}
					aom.AddTweenMaxTo(box, 0.5, {
								"x": tx,
								"y": ty,
								"onComplete": Standings.SetAnimRunning,
								"onCompleteParams": [false]
							});
					aod.AddTweenMaxTo(box, 0.15, {
								"scaleX": Game.boxscale * 1,
								"scaleY": Game.boxscale * 1
							});
					currentx[boxnum] = tx;
					currenty[boxnum] = ty;
					prevx[n] = mc["BOX" + n].x;
					prevy[n] = mc["BOX" + n].y;
				}
			}
		}

		public static function UpdateBoxOrder(aneworder:Array = null):*
		{
			var boxnum:* = undefined;
			var box:* = undefined;
			var tx:* = undefined;
			var ty:* = undefined;
			boxorder = aneworder;
			if (boxorder == null)
			{
				boxorder = CalculateBoxOrder();
			}
			for (var n:* = 1; n <= 3; n++)
			{
				boxnum = boxorder[n - 1];
				box = mc["BOX" + boxnum];
				if (!Map.verticallayout)
				{
					tx = boxpositionx[n];
					box.x = tx;
					box.y = 0;
					currentx[boxnum] = tx;
					currenty[boxnum] = 0;
				}
				else
				{
					ty = boxpositiony[n];
					box.x = 0;
					box.y = ty;
					currentx[boxnum] = 0;
					currenty[boxnum] = ty;
				}
			}
		}

		public static function BoxPosition(pnum:*):*
		{
			return Util.LocalToGlobal(mc["BOX" + pnum]);
		}

		public static function SetAnimRunning(_active:Boolean):void
		{
			Standings.animrunning = _active;
		}

		public static function HiliteCurrentPlayer():void
		{
			var sx:Number = NaN;
			var sy:Number = NaN;
			var n:int = 0;
			var box:* = undefined;
			var a:MovieClip = null;
			if (Config.noanims.indexOf("STANDINGS") >= 0)
			{
				return;
			}
			var boxgap:Number = 4 * Game.boxscale;
			var tx:Number = 0;
			var ty:Number = 0;
			for (var i:int = 1; i <= 3; i++)
			{
				sx = 1;
				sy = 1;
				n = int(boxorder[i - 1]);
				box = Standings.mc["BOX" + n];
				box.FLAG.visible = false;
				box.ATTACK.visible = false;
				box.DEFEND.visible = false;
				if (current_player == 0 || Game.state >= 5)
				{
					box.DARK.alpha = 0;
				}
				else if (n == current_player)
				{
					if (Game.offender)
					{
						a = box.ATTACK;
					}
					else
					{
						a = box.FLAG;
					}
					a.visible = true;
					TweenMax.fromTo(a, a.totalFrames / 60, {"frame": 1}, {
								"frame": a.totalFrames,
								"ease": Linear.easeNone,
								"repeat": -1
							});
					sx = 1.1;
					sy = 1.1;
					box.DARK.alpha = 0;
					mc.setChildIndex(box, mc.numChildren - 1);
				}
				else if (n == defender_player)
				{
					box.DEFEND.visible = true;
					TweenMax.fromTo(box.DEFEND, box.DEFEND.totalFrames / 60, {"frame": 1}, {
								"frame": box.DEFEND.totalFrames,
								"ease": Linear.easeNone,
								"repeat": -1
							});
					sx = 1.1;
					sy = 1.1;
					box.DARK.alpha = 0;
					mc.setChildIndex(box, mc.numChildren - 2);
				}
				else
				{
					sx = 0.93;
					sy = 0.93;
					box.DARK.alpha = 0.4;
				}
				if (Boolean(current_player) && Boolean(defender_player))
				{
					sx /= 1.05;
					sy /= 1.05;
				}
				box.scaleX = sx * Game.boxscale;
				box.scaleY = sy * Game.boxscale;
				box.x = tx;
				box.y = ty;
				if (Map.verticallayout)
				{
					ty += box.BOUNDS.height * sy * Game.boxscale + boxgap;
				}
				else
				{
					tx += box.BOUNDS.width * sx * Game.boxscale + boxgap;
				}
			}
		}

		public static function sqadd_HiliteCurrentPlayer():void
		{
			var ao:*;
			var q:Number = NaN;
			var d:Number = NaN;
			if (Config.noanims.indexOf("STANDINGS") >= 0)
			{
				return;
			}
			q = 0.4;
			d = 0.3;
			ao = Sys.gsqc.AddTweenObj("sqadd_HiliteCurrentPlayer");
			ao.Start = function():*
			{
				var sx:Number = NaN;
				var sy:Number = NaN;
				var n:int = 0;
				var box:* = undefined;
				var a:MovieClip = null;
				var boxgap:Number = 4 * Game.boxscale;
				var tx:Number = 0;
				var ty:Number = 0;
				for (var i:int = 1; i <= 3; i++)
				{
					sx = 1;
					sy = 1;
					n = int(boxorder[i - 1]);
					box = Standings.mc["BOX" + n];
					box.FLAG.visible = false;
					box.ATTACK.visible = false;
					box.DEFEND.visible = false;
					if (current_player == 0 || Game.state >= 5)
					{
						this.AddTweenMaxTo(box.DARK, q, {
									"alpha": 0,
									"delay": d
								});
					}
					else if (n == current_player)
					{
						if (Game.offender)
						{
							a = box.ATTACK;
						}
						else
						{
							a = box.FLAG;
						}
						a.visible = true;
						TweenMax.fromTo(a, a.totalFrames / 60 * q, {"frame": 1}, {
									"frame": a.totalFrames,
									"ease": Linear.easeNone,
									"repeat": -1
								});
						sx = 1.1;
						sy = 1.1;
						this.AddTweenMaxTo(box.DARK, q, {
									"alpha": 0,
									"delay": d
								});
					}
					else if (n == defender_player)
					{
						box.DEFEND.visible = true;
						TweenMax.fromTo(box.DEFEND, box.DEFEND.totalFrames / 60 * q, {"frame": 1}, {
									"frame": box.DEFEND.totalFrames,
									"ease": Linear.easeNone,
									"repeat": -1
								});
						sx = 1.1;
						sy = 1.1;
						this.AddTweenMaxTo(box.DARK, q, {
									"alpha": 0,
									"delay": d
								});
					}
					else
					{
						sx = 0.93;
						sy = 0.93;
						this.AddTweenMaxTo(box.DARK, q, {
									"alpha": 0.4,
									"delay": d
								});
					}
					if (Boolean(current_player) && Boolean(defender_player))
					{
						sx /= 1.05;
						sy /= 1.05;
					}
					this.AddTweenMaxTo(box, q, {
								"scaleX": sx * Game.boxscale,
								"scaleY": sy * Game.boxscale,
								"delay": d
							});
					this.AddTweenMaxTo(box, q, {
								"x": tx,
								"delay": d
							});
					this.AddTweenMaxTo(box, q, {
								"y": ty,
								"delay": d
							});
					if (Map.verticallayout)
					{
						ty += box.BOUNDS.height * sy * Game.boxscale + boxgap;
					}
					else
					{
						tx += box.BOUNDS.width * sx * Game.boxscale + boxgap;
					}
				}
			};
		}

		public static function sqadd_RestorePlayers():void
		{
			var q:Number = NaN;
			q = 0.5;
			var ao:* = Sys.gsqc.AddTweenObj("sqadd_HiliteCurrentPlayer");
			ao.Start = function():*
			{
				var n:int = 0;
				var box:* = undefined;
				var boxgap:Number = 4 * Game.boxscale;
				var tx:Number = 0;
				var ty:Number = 0;
				for (var i:int = 1; i <= 3; i++)
				{
					n = int(boxorder[i - 1]);
					box = Standings.mc["BOX" + n];
					box.FLAG.visible = false;
					box.ATTACK.visible = false;
					box.DEFEND.visible = false;
					this.AddTweenMaxTo(box.DARK, q, {"alpha": 0});
					this.AddTweenMaxTo(box, q, {
								"scaleX": Game.boxscale,
								"scaleY": Game.boxscale
							});
					this.AddTweenMaxTo(box, q, {"x": tx});
					this.AddTweenMaxTo(box, q, {"y": ty});
					if (Map.verticallayout)
					{
						ty += box.BOUNDS.height * Game.boxscale + boxgap;
					}
					else
					{
						tx += box.BOUNDS.width * Game.boxscale + boxgap;
					}
				}
			};
		}

		public static function UpdateSlide(mc:MovieClip, muted:Boolean):*
		{
			if (mc.SLIDE)
			{
				if (mc.SLIDE.value !== undefined)
				{
					TweenMax.to(mc.SLIDE.THUMB, 0.2, {"y": (muted ? 50 : 35)});
				}
				else
				{
					mc.SLIDE.THUMB.y = muted ? 50 : 35;
				}
				mc.SLIDE.value = muted;
			}
		}

		public static function UpdateChatButtons():void
		{
			var ingame:Boolean;
			var two_bots:Boolean;
			var competition_chat:*;
			var friendlygame_chat:*;
			var anychat:*;
			var closurefunc:Function;
			var b2:* = undefined;
			var passive:Boolean = false;
			var isquestion:* = undefined;
			var color:* = undefined;
			var uid:* = undefined;
			var a:* = undefined;
			var i:int = 0;
			var chatenabled:* = undefined;
			var f:Object = null;
			if (!Standings.mc)
			{
				return;
			}
			b2 = Standings.mc.STATUS;
			if (!b2)
			{
				return;
			}
			if (b2.CHATBTN)
			{
				Imitation.RemoveEvents(b2.CHATBTN);
			}
			Imitation.CollectChildrenAll(b2);
			b2.visible = true;
			b2.scaleX = Game.boxscale;
			b2.scaleY = Game.boxscale;
			ingame = "MAP" == Sys.screen.substr(0, 3);
			passive = Game.state == 4 && Game.offender != Game.iam && Game.defender != Game.iam;
			two_bots = Boolean(Game.players[Game.myopp1]) && Game.players[Game.myopp1].id <= -1 && Boolean(Game.players[Game.myopp2]) && Game.players[Game.myopp2].id <= -1;
			competition_chat = Game.roomtype == "C" && Sys.mydata.chatban == 0 && Util.NumberVal(Sys.mydata.uls[3]) == 1;
			friendlygame_chat = Game.roomtype == "F";
			isquestion = MCQuestionMov.mc.visible || GuessQuestionMov.mc.visible;
			anychat = Game.players[Game.iam] && Game.players[Game.iam].chatstate == 0 && (Game.players[Game.myopp1].chatstate == 0 || Game.players[Game.myopp2].chatstate == 0);
			if (Map.verticallayout)
			{
				b2.y = Aligner.stageheight - b2.height - 64 * Game.boxscale;
				b2.x = 0;
			}
			else
			{
				b2.x = Aligner.stagewidth - b2.width - 4 * Game.boxscale;
				b2.y = 0;
			}
			if (ingame && Game.iam && !IngameChat.IsChatEnabled() && Util.NumberVal(Sys.mydata.xplevel) >= Config.ULL_CHAT)
			{
				if (b2.currentFrame != 6)
				{
					b2.gotoAndStop(6);
				}
			}
			firstframe = Config.mobile || !(competition_chat || friendlygame_chat && anychat) ? 2 : 1;
			if (Game.players[Game.iam])
			{
				trace("CHATSTATE", Game.players[Game.iam].chatstate);
			}
			if (Boolean(b2.BTN2) && Boolean(b2.ICON2))
			{
				b2.BTN2.alpha = friendlygame_chat && !anychat ? 0.5 : 1;
				b2.ICON2.alpha = b2.BTN2.alpha;
			}
			if (ingame && !two_bots && !(Game.iam == 0 || Sys.mydata.chatban == 1 || Game.isminitournament) && (Util.NumberVal(Sys.mydata.xplevel) >= Config.ULL_CHAT || friendlygame_chat))
			{
				b2.visible = true;
				if (b2.currentFrame <= 2)
				{
					if (b2.currentframe != firstframe)
					{
						b2.gotoAndStop(firstframe);
					}
					if (Boolean(b2.CHATBTN) && Boolean(b2.BASE))
					{
						if (!isquestion)
						{
							Imitation.AddEventClick(b2.CHATBTN, function():*
								{
									if (Boolean(IngameChat.mc) && IngameChat.mc.visible)
									{
										IngameChat.Hide();
									}
									else if (!MCQuestionMov.mc.visible && !GuessQuestionMov.mc.visible || passive)
									{
										IngameChat.Show();
									}
								});
						}
						else
						{
							Imitation.RemoveEvents(b2.CHATBTN);
						}
						if (b2.currentFrame == 1)
						{
							Imitation.RemoveEvents(b2.BASE);
							if (!isquestion)
							{
								Imitation.AddEventClick(b2.BASE, function():*
									{
										if (Boolean(IngameChat.mc) && IngameChat.mc.visible)
										{
											IngameChat.Hide();
										}
										if (!isquestion)
										{
											Imitation.EnableInput(b2.INPUT, true);
											Imitation.SetFocus(b2.INPUT);
											b2.MESSAGES.visible = false;
											b2.BTNSEND.visible = true;
											b2.BTNUP.visible = false;
											b2.BTNDOWN.visible = false;
											Util.SetRTLEditText(Standings.mc.STATUS.INPUT, "");
											Imitation.AddEventClick(b2.BTNSEND, OnSendClick);
										}
									});
							}
							Imitation.EnableInput(b2.INPUT, !isquestion);
							if (b2.FADE)
							{
								b2.FADE.visible = isquestion;
							}
							Imitation.RemoveStageEventListener(TextEvent.TEXT_INPUT, InputKeyUp);
							if (!isquestion)
							{
								Imitation.AddStageEventListener(TextEvent.TEXT_INPUT, InputKeyUp);
							}
							if (b2.BTNSEND)
							{
								b2.BTNSEND.visible = !b2.BTNUP.visible;
							}
						}
					}
					if (!isquestion)
					{
						Imitation.AddEventClick(b2.BTN1, OnChatClick);
						Imitation.AddEventClick(b2.BTN2, OnChatClick);
						Imitation.AddEventClick(b2.BTN3, OnChatClick);
					}
					else
					{
						Imitation.RemoveEvents(b2.BTN1);
						Imitation.RemoveEvents(b2.BTN2);
						Imitation.RemoveEvents(b2.BTN3);
					}
					if (b2.BTNUP)
					{
						Imitation.AddEventClick(b2.BTNUP, OnArrowClick);
					}
					if (b2.BTNDOWN)
					{
						Imitation.AddEventClick(b2.BTNDOWN, OnArrowClick);
					}
					if (Boolean(IngameChat.mc) && IngameChat.mc.chatbuf.allmsg.length != chatlength)
					{
						chatlength = IngameChat.mc.chatbuf.allmsg.length;
						current_pos = chatlength - 1;
					}
					if (b2.BTNUP)
					{
						b2.BTNUP.alpha = current_pos > 0;
					}
					if (b2.BTNDOWN)
					{
						b2.BTNDOWN.alpha = current_pos < chatlength - 1;
					}
					if (Boolean(IngameChat.mc) && chatlength > 0)
					{
						color = 0;
						uid = IngameChat.mc.chatbuf.allmsg[current_pos].userid;
						if (uid == Game.players[Game.iam].id)
						{
							color = Config.playercolorcodes[Game.iam];
						}
						if (uid == Game.players[Game.myopp1].id)
						{
							color = Config.playercolorcodes[Game.myopp1];
						}
						if (uid == Game.players[Game.myopp2].id)
						{
							color = Config.playercolorcodes[Game.myopp2];
						}
						Util.SetColor(b2.MESSAGES, color);
						Util.SetText(b2.MESSAGES, IngameChat.mc.chatbuf.allmsg[current_pos].message);
					}
					else
					{
						Util.SetText(b2.MESSAGES, "");
					}
				}
				else if (b2.currentFrame == 3)
				{
					Imitation.AddEventClick(b2.EMO1, OnEmotionClick);
					Imitation.AddEventClick(b2.EMO2, OnEmotionClick);
					Imitation.AddEventClick(b2.EMO3, OnEmotionClick);
				}
				else if (b2.currentFrame == 4)
				{
					a = {
							1: "base",
							2: "spreading",
							3: "spreading",
							4: "war",
							5: "end",
							15: "end"
						};
					if (a[Game.state])
					{
						chatstate = a[Game.state];
					}
					for (i = 1; i <= 3; i++)
					{
						closurefunc = function(i:int):*
						{
							var textvalue:* = undefined;
							Lang.SetLang(b2["TXT" + i], "chat_default_text_" + chatstate + i);
							textvalue = Lang.Get("chat_default_text_" + chatstate + i);
							Imitation.AddEventClick(b2["MSGBTN" + i], function(e2:*):*
								{
									IngameChat.SendText(textvalue);
									b2.gotoAndStop(firstframe);
									UpdateChatButtons();
								});
						};
						closurefunc(i);
					}
				}
				else if (b2.currentFrame == 5)
				{
					chatenabled = IngameChat.mc && IngameChat.IsChatEnabled();
					b2.MUTE1.gotoAndStop(Game.myopp1);
					b2.MUTE2.gotoAndStop(Game.myopp2);
					b2.DISABLE.gotoAndStop(4);
					UpdateSlide(b2.MUTE1, IngameChat.mute1);
					UpdateSlide(b2.MUTE2, IngameChat.mute2);
					UpdateSlide(b2.DISABLE, false);
					b2.MUTE1.alpha = 1;
					b2.MUTE2.alpha = 1;
					Imitation.AddEventClick(b2.MUTE1, OnChatMute);
					Imitation.AddEventClick(b2.MUTE2, OnChatMute);
					Imitation.AddEventClick(b2.DISABLE, OnChatEnableClick);
					for (i = 0; i < Friends.all.length; i++)
					{
						f = Friends.all[i];
						if (f.id == Game.players[Game.myopp1].id && (f && f.flag == 3))
						{
							b2.MUTE1.alpha = 0.5;
						}
						if (f.id == Game.players[Game.myopp2].id && (f && f.flag == 3))
						{
							b2.MUTE2.alpha = 0.5;
						}
					}
				}
				else if (b2.currentFrame == 6)
				{
					b2.DISABLE.gotoAndStop(4);
					Imitation.AddEventClick(b2.DISABLE, OnChatEnableClick);
					UpdateSlide(b2.DISABLE, true);
				}
				else if (b2.currentFrame == 7)
				{
				}
				if (b2.BACKBTN)
				{
					Imitation.AddEventClick(b2.BACKBTN, OnChatClick);
				}
			}
			else
			{
				b2.visible = false;
				Imitation.RemoveEvents(b2);
			}
		}

		public static function InputKeyUp(e:TextEvent):void
		{
			if (!Standings.mc)
			{
				return;
			}
			if (!Standings.mc.STATUS)
			{
				return;
			}
			if (e.text.charCodeAt() == 10)
			{
				e.preventDefault();
				OnSendClick();
			}
		}

		public static function OnSendClick(e:* = null):*
		{
			var msg:* = Util.GetRTLEditText(Standings.mc.STATUS.INPUT);
			msg = Util.CleanupChatMessage(msg);
			if (msg.length > 0)
			{
				if (Game.KeepBufferedMessages())
				{
					mc.msgbuffer.push(msg);
				}
				else
				{
					Comm.SendCommand("MESSAGE", "TO=\"0\" TEXT=\"" + msg + "\"");
				}
			}
			Util.SetRTLEditText(Standings.mc.STATUS.INPUT, "");
			Imitation.EnableInput(Standings.mc.STATUS.INPUT, false);
			var b2:* = Standings.mc.STATUS;
			b2.MESSAGES.visible = true;
			b2.BTNSEND.visible = false;
			b2.BTNUP.visible = true;
			b2.BTNDOWN.visible = true;
		}

		private static function OnArrowClick(e:*):void
		{
			if (e.target.name == "BTNUP" && current_pos > 0)
			{
				--current_pos;
			}
			if (e.target.name == "BTNDOWN" && current_pos < chatlength - 1)
			{
				++current_pos;
			}
			UpdateChatButtons();
		}

		private static function OnChatClick(e:*):void
		{
			var b2:* = Standings.mc.STATUS;
			if (e.target == b2.BTN1)
			{
				b2.gotoAndStop(3);
			}
			if (e.target == b2.BTN2 && b2.BTN2.alpha == 1)
			{
				b2.gotoAndStop(4);
			}
			if (e.target == b2.BTN3)
			{
				b2.gotoAndStop(5);
			}
			if (e.target == b2.BACKBTN)
			{
				b2.gotoAndStop(firstframe);
			}
			UpdateChatButtons();
		}

		private static function OnChatMute(e:*):void
		{
			var id:int = Util.IdFromStringEnd(e.target.name);
			if (id == 1)
			{
				IngameChat.mute1 = !IngameChat.mute1;
			}
			if (id == 2)
			{
				IngameChat.mute2 = !IngameChat.mute2;
			}
			UpdateChatButtons();
		}

		private static function OnEmotionClick(e:*):void
		{
			var b2:* = Standings.mc.STATUS;
			IngameChat.SendEmoticon(Util.IdFromStringEnd(e.target.name));
			b2.gotoAndStop(firstframe);
			UpdateChatButtons();
		}

		public static function OnChatEnableClick(e:*):*
		{
			var b2:* = undefined;
			var chatenabled:* = undefined;
			b2 = Standings.mc.STATUS;
			if (Sys.mydata.chatban == 1)
			{
				return;
			}
			if (Game.roomtype == "F")
			{
				IngameChat.disabled = !IngameChat.disabled;
				chatenabled = !IngameChat.disabled;
			}
			else
			{
				Game.players[Game.iam].chatstate ^= 8;
				chatenabled = IngameChat.IsChatEnabled();
				Comm.SendCommand("SETCHATSTATE", "ENABLED=\"" + (!!chatenabled ? "1" : "0") + "\"", function(e:*):*
					{
						DBG.Trace("SETCHATSTATE result", e);
					});
			}
			if (chatenabled)
			{
				if (b2.DISABLE)
				{
					UpdateSlide(b2.DISABLE, false);
					TweenMax.to(b2.BASE, 0.4, {"onComplete": function():*
							{
								b2.gotoAndStop(firstframe);
								UpdateChatButtons();
							}
						});
				}
			}
			else
			{
				IngameChat.mc.visible = false;
				b2.gotoAndStop(6);
				if (b2.DISABLE)
				{
					UpdateSlide(b2.DISABLE, true);
				}
				TweenMax.to(b2.BASE, 0.6, {"onComplete": function():*
						{
							UpdateChatButtons();
						}
					});
			}
		}
	}
}
