package uibase
{
	import com.greensock.TweenMax;
	import fl.motion.easing.Cubic;
	import fl.motion.easing.Quadratic;
	import flash.display.*;
	import flash.text.TextField;
	import syscode.*;

	public class Anim
	{
		public function Anim()
		{
			super();
		}

		public static function RaiseItemOff(sqc:SqControl, obj:DisplayObject, mul:Number = 1.25):DisplayObject
		{
			var main:* = Imitation.rootmc;
			var sq:SqControl = sqc || new SqControl("RaiseItemOff.SQC");
			var pic:Object = Util.GetShot(obj);
			var bmp:Bitmap = new Bitmap(pic.b, "auto", true);
			var res:DisplayObject = main.addChild(bmp);
			res.x = pic.x;
			res.y = pic.y;
			res.visible = false;
			var x:Number = res.x - (res.width * mul - res.width) / 2;
			var y:Number = res.y - (res.height * mul - res.height) / 2;
			var w:Number = res.width;
			var h:Number = res.height;
			sq.SetProps(obj, {"visible": false});
			sq.SetProps(res, {"visible": true});
			sq.AddTweenMax(res, 0.2, {
						"x": x,
						"y": y,
						"width": res.width * mul,
						"height": res.height * mul,
						"dropShadowFilter": {
							"angle": 45,
							"blurX": 10,
							"blurY": 10,
							"distance": 10,
							"addFilter": true
						}
					}, "RaiseItemOff.Raise");
			if (sqc == null)
			{
				sq.Start();
			}
			return res;
		}

		public static function AnimateReward(sqc:SqControl, rewardmov:DisplayObject, rewardname:String, oldvalue:int, newvalue:int):void
		{
			var OnComplete:Function = null;
			var hidx:int = 0;
			var helpmov:MovieClip = null;
			OnComplete = function(rname:String):*
			{
			};
			var main:* = Imitation.rootmc;
			var sq:SqControl = sqc || new SqControl("AnimateReward.SQC");
			var valuetf:TextField = null;
			var targetpos:Object = {
					"x": main.stage.stageWidth / 2,
					"y": main.stage.stageHeight
				};
			if ("BONUSLIFE" == rewardname)
			{
				valuetf = main.LIVES.BONUSLIVES.VALUE;
			}
			else if ("LIFEREFILL" == rewardname)
			{
				targetpos = {
						"x": main.stage.stageWidth / 2 - 50,
						"y": -50
					};
			}
			else if ("LIFEINCREMENT" == rewardname)
			{
				targetpos = {
						"x": main.stage.stageWidth / 2 + 50,
						"y": -50
					};
				if (Sys.mydata.energy <= Sys.mydata.energymax)
				{
					--Sys.mydata.energy;
				}
				--Sys.mydata.energymax;
			}
			else if ("GOLDS" == rewardname || "GOLD" == rewardname)
			{
				valuetf = main.TREASURY.GOLDS;
			}
			else if ("PEBBLES" == rewardname)
			{
				targetpos = Util.LocalToGlobalBounded(main.TREASURY.GOLDS);
			}
			else
			{
				hidx = Util.NumberVal(Config.helpindexes[rewardname], 0);
				if (hidx > 0)
				{
					helpmov = main.INVENTORY["HELP" + hidx];
					if (helpmov)
					{
						valuetf = helpmov.NUM.VALUE;
					}
				}
			}
			if (valuetf)
			{
				targetpos = Util.LocalToGlobalBounded(valuetf);
			}
			sq.AddTweenMax(rewardmov, 0.4, {
						"x": targetpos.x,
						"y": targetpos.y,
						"scaleX": 0.5,
						"scaleY": 0.5,
						"ease": Quadratic.easeIn,
						"onComplete": OnComplete,
						"onCompleteParams": [rewardname],
						"dropShadowFilter": {"remove": true},
						"blurFilter": {
							"blurX": 5,
							"blurY": 5,
							"remove": true,
							"addFilter": true
						}
					}, "AnimateReward.Fly");
		}

		public static function AnimateRewardTo(sqc:SqControl, rewardmov:DisplayObject, valuetf:TextField, oldvalue:int, newvalue:int):void
		{
			var ao:Object;
			var main:* = undefined;
			main = Imitation.rootmc;
			var sq:SqControl = sqc || new SqControl("AnimateReward.SQC");
			var targetpos:Object = {
					"x": Imitation.stage.stageWidth / 2,
					"y": Imitation.stage.stageHeight
				};
			if (valuetf)
			{
				targetpos = Util.LocalToGlobalBounded(valuetf);
			}
			sq.AddTweenMax(rewardmov, 0.6, {
						"x": targetpos.x,
						"y": targetpos.y,
						"scaleX": 0.5,
						"scaleY": 0.5,
						"ease": Quadratic.easeIn,
						"dropShadowFilter": {"remove": true},
						"blurFilter": {
							"blurX": 5,
							"blurY": 5,
							"remove": true,
							"addFilter": true
						}
					}, "AnimateReward.Fly");
			ao = sq.AddObj("AnimateReward.Cleanup");
			ao.Start = function():*
			{
				rewardmov.visible = false;
				main.removeChild(rewardmov);
				rewardmov = null;
				this.Next();
			};
			if (valuetf)
			{
				Anim.ValueRollUp(sq, valuetf, oldvalue, newvalue);
			}
			if (sqc == null)
			{
				sq.Start();
			}
		}

		public static function ValueRollUp(sqc:SqControl, txt:TextField, oldvalue:int, newvalue:int):void
		{
			var sq:SqControl;
			var ao:Object;
			var diff:Number = NaN;
			var oldscalex:Number = NaN;
			var oldscaley:Number = NaN;
			var oldw:Number = NaN;
			var oldh:Number = NaN;
			var oldx:Number = NaN;
			var oldy:Number = NaN;
			var upscale:Number = NaN;
			diff = newvalue - oldvalue;
			if (diff == 0)
			{
				trace("ValueRollUp: diff=0");
				return;
			}
			sq = sqc || new SqControl("ValueRollUp.SQC");
			oldscalex = txt.scaleX;
			oldscaley = txt.scaleY;
			oldw = txt.width;
			oldh = txt.height;
			oldx = txt.x;
			oldy = txt.y;
			upscale = 1.5;
			txt.text = Util.FormatNumber(oldvalue);
			ao = sq.AddTweenObj("ValueRollUp");
			ao.Start = function():*
			{
				var tween:TweenMax = null;
				var progressfunc:Function = null;
				progressfunc = function():*
				{
					txt.text = Util.FormatNumber(Math.round(oldvalue + tween.currentProgress * diff));
				};
				txt.text = Util.StringVal(oldvalue);
				tween = this.AddTweenMaxTo(txt, 0.5, {
							"scaleX": oldscalex * upscale,
							"scaleY": oldscaley * upscale,
							"x": oldx - oldw * (upscale - 1) / 2,
							"y": oldy - oldh * (upscale - 1) / 2,
							"ease": Cubic.easeOut,
							"onUpdate": progressfunc
						});
			};
			ao = sq.AddTweenObj("ValueRollUp-cooldown");
			ao.Start = function():*
			{
				txt.text = Util.FormatNumber(newvalue);
				this.AddTweenMaxTo(txt, 0.1, {
							"scaleX": oldscalex,
							"scaleY": oldscaley,
							"x": oldx,
							"y": oldy,
							"onComplete": function():*
							{
								txt.scaleX = oldscalex;
								txt.scaleY = oldscaley;
								txt.x = oldx;
								txt.y = oldy;
							}
						});
			};
			if (sqc == null)
			{
				sq.Start();
			}
		}
	}
}
