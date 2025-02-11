package triviador
{
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import syscode.*;
	import triviador.gfx.GuessQuestionMov;
	import triviador.gfx.MCQuestionMov;
	import triviador.gfx.AreaMarkerMov;

	public class PhaseDisplay
	{
		private static var gs:Object;

		public static var mc:MovieClip = null;

		public static var turnmc:MovieClip = null;

		public static var turnshader:MovieClip = null;

		public static var aligned:Boolean = true;

		public static var keyframename:String = "NORMAL";

		public static var gamerules:int = 1;

		public static var warrounds:int = 4;

		public function PhaseDisplay()
		{
			super();
		}

		public static function Init(amc:MovieClip, aturnmc:MovieClip, aturnshader:MovieClip):void
		{
			mc = amc;
			Util.StopAllChildrenMov(mc);
			mc.visible = false;
			if (mc.INFO)
			{
				mc.INFO.alpha = 0;
				mc.INFO.visible = false;
			}
			turnmc = aturnmc;
			turnshader = aturnshader;
			if (turnmc)
			{
				Imitation.GotoFrame(turnmc.BG, 1);
				turnmc.visible = false;
				turnshader.visible = false;
				aligned = true;
			}
			else
			{
				aligned = false;
			}
		}

		public static function Order():*
		{
			if (!mc)
			{
				return;
			}
			var zid:* = Map.mc.numChildren - 1;
			if (GuessQuestionMov.mc)
			{
				zid = Main.mc.getChildIndex(GuessQuestionMov.mc) - 1;
			}
			if (MCQuestionMov.mc)
			{
				zid = Main.mc.getChildIndex(MCQuestionMov.mc) - 1;
			}
			Main.mc.setChildIndex(PhaseDisplay.mc, zid);
		}

		public static function UpdateSize():*
		{
			var rm:MovieClip = null;
			var p:int = 0;
			var pm:MovieClip = null;
			trace("!!! UpdateSize");
			var lastpm:MovieClip = null;
			for (var r:int = 1; r <= 7; r++)
			{
				rm = mc.ROUNDS["R" + r];
				for (p = 1; p <= 3; p++)
				{
					pm = rm["P" + p];
					if (Game.state == 4)
					{
						pm.visible = r <= warrounds;
					}
					else if (gamerules == 0)
					{
						pm.visible = r <= 6;
					}
					else
					{
						pm.visible = r * 3 + p <= Map.areanum;
					}
					if (pm.visible)
					{
						lastpm = pm;
					}
				}
			}
			if (lastpm)
			{
				mc.BG.width = lastpm.parent.x + lastpm.x + 65;
			}
		}

		public static function Update(gs:Object = null):void
		{
			Order();
			PhaseDisplay.gs = gs;
			if (!gs)
			{
				gamerules = Game.rules;
				warrounds = Game.warrounds;
				gs = {
						"state": Game.state,
						"linplayer": Game.lpnum,
						"gameround": Game.gameround,
						"curplayer": Game.nextplayer
					};
			}
			else
			{
				gamerules = 1;
				warrounds = 4;
			}
			if (gamerules == 0)
			{
				PhaseDisplay.keyframename = "LONG";
			}
			else
			{
				PhaseDisplay.keyframename = "NORMAL";
			}
			UpdateSize();
			if (gs.state == 1 && gamerules == 0)
			{
				mc.visible = true;
				mc.ROUNDS.visible = false;
				Imitation.GotoFrame(mc.ICON, gs.state);
				UpdateBaseSelection();
				mc.SIGN.visible = false;
			}
			else if (gs.state == 2 || gs.state == 3)
			{
				mc.visible = true;
				mc.ROUNDS.visible = true;
				Imitation.GotoFrame(mc.ICON, gs.state);
				if (gs.state == 2)
				{
					UpdateSpreadingOrder();
				}
				else
				{
					UpdateFreeAreasOrder();
				}
				if (gs.linplayer >= 1 && gs.linplayer <= 3 && !(gs.state == 3 && gamerules == 0))
				{
					mc.SIGN.visible = true;
					Imitation.GotoFrame(mc.SIGN, gs.state == 2 ? gs.curplayer : gs.linplayer);
					mc.SIGN.x = RoundPlayerX(gs.gameround, gs.linplayer);
				}
				else
				{
					mc.SIGN.visible = false;
				}
			}
			else if (gs.state == 4)
			{
				mc.visible = true;
				mc.ROUNDS.visible = true;
				Imitation.GotoFrame(mc.ICON, 4);
				UpdateWarOrder();
				UpdatePointer();
			}
			else
			{
				mc.visible = false;
			}
			if (turnmc)
			{
				turnmc.visible = false;
				turnshader.visible = false;
			}
			if (aligned)
			{
				Map.AlignPhaseDisplay();
			}
		}

		public static function sqadd_ShowTurn():void
		{
			var lid:String;
			var r:Rectangle;
			var targety:Number = NaN;
			var fromy:Number = NaN;
			var ao:* = undefined;
			var grounds:Array = [1, 2, 3, 4, 5, 15];
			if (!turnmc)
			{
				return;
			}
			if (grounds.indexOf(Game.state) < 0)
			{
				return;
			}
			if (Game.gameround > 1)
			{
				return;
			}
			Imitation.GotoFrame(turnmc.BG, 1);
			Imitation.GotoFrame(turnmc.ICON, Game.state);
			lid = "gameround_" + Game.state;
			if (Game.state == 1 && Game.rules == 1)
			{
				lid = "gameround_1b";
			}
			Lang.Set(turnmc.CAPTION, lid);
			turnmc.CAPTION.y = -5 - turnmc.CAPTION.textHeight / 2;
			turnshader.width = Imitation.stage.stageWidth;
			turnshader.height = Imitation.stage.stageHeight;
			turnmc.scaleX = 1;
			turnmc.scaleY = 1;
			turnmc.x = Aligner.stagewidth / 2;
			turnmc.y = Aligner.stageheight / 2;
			r = turnmc.getBounds(turnmc.parent);
			if (r.top > 0)
			{
				turnmc.y -= r.top;
			}
			turnshader.alpha = 1;
			turnshader.visible = true;
			Imitation.UpdateAll(turnshader);
			turnshader.visible = false;
			turnmc.alpha = 1;
			turnmc.visible = true;
			Imitation.UpdateAll(turnmc);
			turnmc.visible = false;
			mc.visible = true;
			Imitation.UpdateAll(mc);
			mc.visible = false;
			targety = turnmc.y;
			fromy = -70 * Aligner.basescale;
			Sys.gsqc.AddDelay(0.1);
			if (Game.state == 1)
			{
				Sounds.PlayVoice("voice_base_selection");
			}
			else if (Game.state == 2)
			{
				Sounds.PlayVoice("voice_spreading");
			}
			else if (Game.state == 3)
			{
				Sounds.PlayVoice("voice_expand_your_empire");
			}
			else if (Game.state == 4)
			{
				Sounds.PlayVoice("voice_let_the_battle_begin");
			}
			else if (Game.state == 5)
			{
				Sounds.PlayVoice("voice_draw");
			}
			else if (Game.state == 15)
			{
				Sounds.PlayVoice("voice_game_over");
			}
			Sys.gsqc.PlayEffect("board_appear");
			if (Imitation.usegpu)
			{
				UpdateShader(true);
				turnshader.alpha = 0;
				ao = Sys.gsqc.AddTweenObj("ROUNDS-SHOWTURN");
				ao.Start = function():*
				{
					this.AddTweenMaxTo(turnshader, 0.3, {"alpha": 0.4});
					this.AddTweenMaxFromTo(turnmc, 0.5, {
								"visible": true,
								"y": fromy
							}, {"y": targety});
				};
			}
			else
			{
				Sys.gsqc.AddCallBack2(UpdateShader, [true]);
				Sys.gsqc.AddDelay(0.2);
				Sys.gsqc.AddTweenMaxFromTo(turnmc, 0.5, {
							"visible": true,
							"y": fromy
						}, {"y": targety});
			}
			Sys.gsqc.AddDelay(1.3);
			if (Imitation.usegpu)
			{
				ao = Sys.gsqc.AddTweenObj("ROUNDS-HIDETURN");
				ao.Start = function():*
				{
					this.AddTweenMaxTo(turnshader, 0.3, {"alpha": 0});
					this.AddTweenMaxFromTo(turnmc, 0.3, {
								"visible": true,
								"y": targety
							}, {
								"y": fromy,
								"visible": false
							});
				};
			}
			else
			{
				Sys.gsqc.AddTweenMaxFromTo(turnmc, 0.3, {
							"visible": true,
							"y": targety
						}, {
							"y": fromy,
							"visible": false
						});
				Sys.gsqc.AddDelay(0.2);
			}
			Sys.gsqc.AddCallBack2(UpdateShader, [false]);
			if (Game.state == 1 && Game.rules == 0 || Game.state == 2 || Game.state == 3 || Game.state == 4)
			{
				Sys.gsqc.AddTweenMaxFromTo(mc, 0.5, {
							"visible": true,
							"alpha": 0
						}, {"alpha": 1});
			}
		}

		public static function InitInfo():*
		{
			if (!mc)
			{
				return;
			}
			if (!mc.INFO)
			{
				return;
			}
			Order();
			mc.INFO.visible = true;
			mc.INFO.alpha = 0;
			var oname:String = Game.players[Game.nextplayer].name;
			if (oname == "")
			{
				oname = Lang.get ("nth_opponent", Game.myopp1 == Game.nextplayer ? 1 : 2);
			}
			Lang.Set(mc.INFO.OPPNAME, "xy_turns", oname);
			mc.INFO.OPPNAME.y = mc.INFO.OPPNAME.numLines == 1 ? -85 : -100;
			mc.INFO.CHAR.scaleX = Math.abs(mc.INFO.CHAR.scaleX) * (mc.x > Aligner.stagewidth / 2 ? -1 : 1);
			var lid:String = "gameround_" + Game.state;
			if (Game.state == 1 && Game.rules == 1)
			{
				lid = "gameround_1b";
			}
			Lang.Set(mc.INFO.GAMESTATE, lid);
			if (Game.gameround > 0)
			{
				mc.INFO.GAMESTATE.y = -177;
				mc.INFO.GAMEROUND.visible = true;
				Lang.Set(mc.INFO.GAMEROUND, "roundnumber_" + Game.gameround);
			}
			else
			{
				mc.INFO.GAMESTATE.y = -160;
				mc.INFO.GAMEROUND.visible = false;
			}
		}

		private static function UpdateShader(_visible:Boolean):void
		{
			turnshader.visible = _visible;
			turnshader.alpha = _visible ? 0.4 : 1;
		}

		public static function SoldierPos(lpnum:int):Point
		{
			var sscale:Number = PhaseDisplay.mc.scaleX;
			var p:Point = new Point(0, PhaseDisplay.mc.y - 43 * sscale);
			if (Game.rules == 1 && Game.state == 3)
			{
				p.x = PhaseDisplay.RoundPlayerGlobalX(Game.gameround, 2) + (lpnum - 2) * 35 * sscale;
			}
			else if (Game.rules == 0 && Game.state == 3)
			{
				p.x = PhaseDisplay.RoundPlayerGlobalX(1, 1);
			}
			else
			{
				p.x = PhaseDisplay.RoundPlayerGlobalX(Game.gameround, lpnum);
			}
			return p;
		}

		public static function sqadd_RoundsAppear():void
		{
			var r:int;
			var ao:*;
			var p:int = 0;
			var m:MovieClip = null;
			trace("!!! sqadd_RoundsAppear");
			Imitation.CollectChildrenAll(mc);
			for (r = 1; r <= 7; r++)
			{
				for (p = 1; p <= 3; p++)
				{
					m = mc.ROUNDS["R" + r]["P" + p];
					if (m.visible)
					{
						m.alpha = 0;
						m.cacheAsBitmap = true;
						Imitation.SetBitmapScale(m, 1.5);
						Imitation.UpdateAll(m);
					}
				}
			}
			mc.SIGN.visible = false;
			mc.SIGN.x = RoundPlayerX(0, 0);
			ao = Sys.gsqc.AddTweenObj("ROUNDS-APPEAR");
			ao.mov = mc.ROUNDS;
			ao.Start = function():*
			{
				var rm:MovieClip = null;
				var p:int = 0;
				var pm:MovieClip = null;
				var del:Number = 0;
				for (var r:int = 1; r <= 7; r++)
				{
					rm = this.mov["R" + r];
					for (p = 1; p <= 3; p++)
					{
						pm = rm["P" + p];
						if (pm.visible)
						{
							this.AddTweenMaxFromTo(pm, 0.3, {
										"alpha": 0,
										"scaleX": 5,
										"scaleY": 5
									}, {
										"delay": del,
										"alpha": 1,
										"scaleX": 1,
										"scaleY": 1,
										"ease": Cubic.easeIn
									});
							del += PhaseDisplay.keyframename == "LONG" ? 0.12 : 0.15;
						}
					}
				}
			};
		}

		public static function sqadd_SpreadingRoundsDisappear():void
		{
			var ao:*;
			Imitation.CollectChildrenAll(mc);
			ao = Sys.gsqc.AddTweenObj("ROUNDS-DISAPPEAR");
			ao.mov = mc.ROUNDS;
			ao.Start = function():*
			{
				var rm:MovieClip = null;
				var p:int = 0;
				var pm:MovieClip = null;
				var del:Number = 0;
				for (var r:int = 1 + Game.gameround; r <= 7; r++)
				{
					rm = this.mov["R" + r];
					for (p = 1; p <= 3; p++)
					{
						pm = rm["P" + p];
						pm.visible = r <= warrounds;
						if (pm.visible)
						{
							this.AddTweenMaxFromTo(pm, 0.3, {
										"alpha": 0,
										"scaleX": 5,
										"scaleY": 5
									}, {
										"delay": del,
										"alpha": 1,
										"scaleX": 0,
										"scaleY": 0,
										"ease": Cubic.easeIn
									});
							del += 0.15;
						}
					}
				}
			};
		}

		public static function sqadd_FreeAreaAppear():void
		{
			var ao:* = undefined;
			if (!(Game.gameround > 1 && Game.rules == 0))
			{
				return;
			}
			ao = Sys.gsqc.AddTweenObj("PhaseDisplay.FreeAreaAppear");
			ao.Start = function():*
			{
				var c:MovieClip = PhaseDisplay.mc.LONGFREEAREA;
				c.visible = true;
				Imitation.SetBitmapScale(c, 1.5);
				Imitation.UpdateAll(c);
				c.scaleX = c.scaleY = 0;
				this.AddTweenMaxTo(c, 0.5, {
							"scaleX": 1,
							"scaleY": 1,
							"delay": 0.5,
							"ease": Back.easeOut
						});
			};
			Sys.gsqc.AddDelay(0.7);
		}

		public static function sqadd_FreeAreasResult():void
		{
			var ao:* = undefined;
			ao = Sys.gsqc.AddTweenObj("PhaseDisplay.MoveSoldiers");
			ao.Start = function():*
			{
				var sm:AreaMarkerMov = null;
				var pm:MovieClip = null;
				var p:Point = null;
				var sscale:Number = PhaseDisplay.mc.scaleX;
				var b:Boolean = false;
				for (var i:int = 1; i <= 3; i++)
				{
					sm = Main.mc["FASOLDIER" + i];
					pm = null;
					if (Game.rules > 0)
					{
						pm = mc.ROUNDS["R" + Game.gameround]["P" + i];
					}
					if (sm.visible && (pm == null || pm.visible))
					{
						sm.alpha = 1;
						p = SoldierPos(i);
						this.AddTweenMaxTo(sm, 1, {
									"x": p.x,
									"y": p.y,
									"scaleX": sscale,
									"scaleY": sscale
								});
						b = true;
					}
					else
					{
						sm.visible = false;
					}
				}
				if (!b)
				{
					this.Next();
				}
			};
		}

		public static function sqadd_UpdateFreeAreasPointer():*
		{
			var r:int;
			var oldx:Number;
			var newx:Number;
			var ao:* = undefined;
			var rm:MovieClip = null;
			var p:int = 0;
			var pm:MovieClip = null;
			var pnum:int = 0;
			var fao:String = Util.StringVal(Sys.tag_state.FAO);
			for (r = 1; r <= 7; r++)
			{
				rm = mc.ROUNDS["R" + r];
				for (p = 1; p <= 3; p++)
				{
					pm = rm["P" + p];
					if (pm.visible)
					{
						pnum = Util.NumberVal(fao.charAt((r - 1) * 3 + p - 1), 4);
						if (pnum < 1 || pnum > 3)
						{
							pnum = 4;
						}
						if (pm.currentFrame != pnum)
						{
							ao = Sys.gsqc.AddTweenObj("Phasedisplay.faochange.1");
							ao.mov = pm;
							ao.Start = function():*
							{
								this.AddTweenMaxTo(this.mov, 0.1, {
											"scaleX": 0,
											"scaleY": 0,
											"ease": Cubic.easeIn
										});
							};
							ao = Sys.gsqc.AddTweenObj("Phasedisplay.faochange.2");
							ao.mov = pm;
							ao.pnum = pnum;
							ao.Start = function():*
							{
								this.mov.scaleX = 1;
								this.mov.scaleY = 1;
								Imitation.GotoFrame(this.mov, this.pnum);
								this.mov.scaleX = 0;
								this.mov.scaleY = 0;
								this.AddTweenMaxTo(this.mov, 0.1, {
											"scaleX": 1,
											"scaleY": 1,
											"ease": Cubic.easeOut
										});
							};
						}
					}
				}
			}
			oldx = Number(mc.SIGN.x);
			newx = RoundPlayerX(Game.gameround, Game.lpnum);
			mc.SIGN.alpha = !!mc.SIGN.visible ? mc.SIGN.alpha : 0;
			mc.SIGN.visible = true;
			Imitation.GotoFrame(mc.SIGN, Game.nextplayer);
			if (oldx != newx || mc.SIGN.alpha != 1)
			{
				ao = Sys.gsqc.AddTweenObj("Phasedisplay.signmove");
				ao.mov = mc.SIGN;
				ao.newx = newx;
				ao.Start = function():*
				{
					this.mov.visible = true;
					this.AddTweenMaxTo(this.mov, 0.5, {
								"alpha": 1,
								"x": this.newx,
								"ease": Linear.easeNone
							});
				};
			}
		}

		public static function sqadd_FreeAreasFinish():*
		{
			var ao:* = undefined;
			if (Game.rules == 0 || Game.lpnum == 3)
			{
				if (mc.SIGN.visible)
				{
					ao = Sys.gsqc.AddTweenObj("Phasedisplay.sign-out");
					ao.mov = mc.SIGN;
					ao.Start = function():*
					{
						this.AddTweenMaxTo(this.mov, 0.5, {
									"alpha": 0,
									"visible": false,
									"ease": Linear.easeNone
								});
					};
				}
			}
		}

		public static function sqadd_UpdateSign():void
		{
			var ao:* = undefined;
			Imitation.GotoFrame(mc.SIGN, Game.nextplayer);
			ao = Sys.gsqc.AddTweenObj("Phasedisplay.sign");
			ao.mov = mc.SIGN;
			ao.newx = RoundPlayerX(Game.gameround, Game.lpnum);
			ao.Start = function():*
			{
				this.mov.visible = true;
				this.AddTweenMaxTo(this.mov, 0.5, {
							"alpha": 1,
							"x": this.newx,
							"ease": Linear.easeNone
						});
			};
		}

		public static function sqadd_UpdateWarPointer():void
		{
			var am:AreaMarkerMov;
			var p:Point;
			var ao:*;
			PhaseDisplay.sqadd_UpdateSign();
			am = Main.mc["ATTACKANIM"];
			am.visible = true;
			am.alpha = 1;
			am.scaleX = Map.markerscale;
			am.scaleY = Map.markerscale;
			am.Setup(Game.nextplayer, 400, 0);
			am.CVALUE.visible = false;
			p = SoldierPos(Game.lpnum);
			am.x = p.x;
			am.y = p.y;
			am.alpha = 0;
			am.scaleX = PhaseDisplay.mc.scaleX;
			am.scaleY = PhaseDisplay.mc.scaleX;
			ao = Sys.gsqc.AddTweenObj("Phasedisplay.areamarker");
			ao.mov = am;
			ao.Start = function():*
			{
				this.mov.visible = true;
				this.AddTweenMaxTo(this.mov, 0.5, {
							"alpha": 1,
							"ease": Linear.easeNone
						});
			};
		}

		public static function UpdateFreeAreasOrder():void
		{
			var c:MovieClip = null;
			var r:int = 0;
			var rm:MovieClip = null;
			var p:int = 0;
			var pm:MovieClip = null;
			var pnum:int = 0;
			Imitation.GotoFrame(mc, "NORMAL");
			HideCastles();
			var fao:String = Util.StringVal(Sys.tag_state.FAO);
			PhaseDisplay.mc.ROUNDS.visible = Game.rules == 1;
			if (Game.rules == 0)
			{
				c = PhaseDisplay.mc.LONGFREEAREA;
				if (c)
				{
					Lang.Set(c.ROUND, "roundnumber_" + Game.gameround);
					c.visible = Game.gameround == 1 || Game.phase > 0;
				}
			}
			else
			{
				HideFreeAreaLabel();
				PhaseDisplay.mc.ROUNDS.visible = true;
				for (r = 1; r <= 7; r++)
				{
					rm = mc.ROUNDS["R" + r];
					for (p = 1; p <= 3; p++)
					{
						pm = rm["P" + p];
						if (pm.visible)
						{
							pm.cacheAsBitmap = true;
							pnum = Util.NumberVal(fao.charAt((r - 1) * 3 + p - 1), 4);
							if (pnum < 1 || pnum > 3)
							{
								pnum = 4;
							}
							Imitation.GotoFrame(pm, pnum);
						}
					}
				}
			}
		}

		public static function UpdateBaseSelection():void
		{
			Imitation.GotoFrame(mc, PhaseDisplay.keyframename);
			HideFreeAreaLabel();
			var c:MovieClip = null;
			var mscale:Number = 1 - PhaseDisplay.mc.scaleX;
			if (mscale >= 0)
			{
				mscale = (mscale + 1) * Map.markerscale;
			}
			else
			{
				mscale = 1;
			}
			for (var i:int = 1; i <= 3; i++)
			{
				c = mc["CASTLE" + i];
				if (c)
				{
					c.Setup(Game.players[i].castlelevel, i, 3);
					c.scaleX = c.scaleY = mscale;
					c.visible = Game.lpnum < i;
					Map.ScaleEffects("CASTLE", c, mscale);
				}
			}
		}

		public static function UpdateSpreadingOrder():void
		{
			var rm:MovieClip = null;
			var p:int = 0;
			var pm:MovieClip = null;
			var pnum:int = 0;
			Imitation.GotoFrame(mc, PhaseDisplay.keyframename);
			HideCastles();
			HideFreeAreaLabel();
			for (var r:int = 1; r <= 7; r++)
			{
				rm = mc.ROUNDS["R" + r];
				for (p = 1; p <= 3; p++)
				{
					pm = rm["P" + p];
					if (pm.visible)
					{
						pm.cacheAsBitmap = true;
						pnum = Game.DecodeSpreadingorder(Game.warorder, r, p);
						if (pnum < 1 || pnum > 3)
						{
							pnum = 4;
						}
						Imitation.GotoFrame(pm, pnum);
					}
				}
			}
		}

		public static function UpdateWarOrder():void
		{
			var rm:MovieClip = null;
			var p:int = 0;
			var pm:MovieClip = null;
			var pnum:int = 0;
			trace("!!! UpdateWarOrder");
			Imitation.GotoFrame(mc, gamerules == 0 ? "LONG" : "NORMAL");
			HideCastles();
			HideFreeAreaLabel();
			for (var r:int = 1; r <= warrounds; r++)
			{
				rm = mc.ROUNDS["R" + r];
				for (p = 1; p <= 3; p++)
				{
					pm = rm["P" + p];
					pm.visible = r <= warrounds;
					if (pm.visible)
					{
						pm.cacheAsBitmap = true;
						pnum = Game.DecodeWarorder(Game.warorder, r, p);
						if (pnum < 1 || pnum > 3)
						{
							pnum = 4;
						}
						Imitation.GotoFrame(pm, pnum);
					}
				}
			}
		}

		public static function UpdatePointer():void
		{
			if (!gs)
			{
				return;
			}
			mc.SIGN.x = RoundPlayerX(gs.gameround, gs.linplayer);
		}

		public static function RoundPlayerX(r:int, p:int):Number
		{
			var rm:MovieClip = null;
			var x:Number = NaN;
			if (r < 1)
			{
				rm = mc.ROUNDS.R1;
				x = rm.P1.x - 7;
			}
			else
			{
				rm = mc.ROUNDS["R" + r];
				if (p < 0)
				{
					x = rm.P1.x - 7;
				}
				else if (p > 3)
				{
					x = rm.P3.x + 7;
				}
				else
				{
					x = Number(rm["P" + p].x);
				}
			}
			return (x * rm.scaleX + rm.x) * mc.ROUNDS.scaleX + mc.ROUNDS.x;
		}

		public static function RoundPlayerGlobalX(r:int, p:int):Number
		{
			var x:Number = RoundPlayerX(r, p);
			return mc.x + x * mc.scaleX;
		}

		private static function HideFreeAreaLabel():void
		{
			var c:MovieClip = PhaseDisplay.mc.LONGFREEAREA;
			if (c)
			{
				c.visible = false;
			}
		}

		private static function HideCastles():void
		{
			var i:int = 0;
			var c:MovieClip = null;
			if (PhaseDisplay.mc.currentFrame == 2)
			{
				for (i = 1; i <= 3; i++)
				{
					c = mc["CASTLE" + i];
					if (c)
					{
						c.visible = false;
					}
				}
			}
		}

		public static function GetCastle(_pnum:uint):MovieClip
		{
			return PhaseDisplay.mc["CASTLE" + _pnum];
		}
	}
}
