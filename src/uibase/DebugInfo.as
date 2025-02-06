package uibase
{
	import com.greensock.TweenMax;
	import uibase.components.UIBaseButtonComponent;
	import flash.display.*;
	import flash.events.*;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.*;
	import syscode.*;
	import uibase.stub.Pool;
	import uibase.stub.BitmapDataPool;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol1237")]
	public class DebugInfo extends MovieClip
	{
		public static var mc:DebugInfo = null;

		public static var FPSTimer:Timer = new Timer(1000, 0);

		public static var fps_values:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

		public static var fps_time:Number = 0;

		public static var fps_counter:Number = 0;

		internal static var heatmap:* = null;

		internal static var heatdata:* = [];

		public static var display_object_count:int = 0;

		public static var visible_object_count:int = 0;

		public static var tweened_object_count:int = 0;

		public var DISPATCH:TextField;

		public var DISPATCHBTN:SimpleButton;

		public var EVT:TextField;

		public var EVTBTN:SimpleButton;

		public var FPS:TextField;

		public var IBTN:UIBaseButtonComponent;

		public var IMIT:TextField;

		public var MEM:TextField;

		public var OBJ:TextField;

		public var OBJBTN:SimpleButton;

		public var POOL:TextField;

		public var REGIONS:MovieClip;

		public var SHADOW:MovieClip;

		public var SQ:TextField;

		public var SQBTN:SimpleButton;

		public var T1:MovieClip;

		public var T10:MovieClip;

		public var T2:MovieClip;

		public var T3:MovieClip;

		public var T4:MovieClip;

		public var T5:MovieClip;

		public var T6:MovieClip;

		public var T7:MovieClip;

		public var T8:MovieClip;

		public var T9:MovieClip;

		public var TWEEN:TextField;

		public var TWEENBTN:SimpleButton;

		public var VISBTN:SimpleButton;

		public var VISIBLE:TextField;

		// stub
		// private var pool:Pool;

		// private var bitmapDataPool:BitmapDataPool;

		public function DebugInfo()
		{
			super();
			this.__setProp_IBTN_DebugInfo_Layer4_0();
		}

		public static function Init():void
		{
			if (mc)
			{
				return;
			}
			mc = new DebugInfo();
			mc.addEventListener("enterFrame", OnEnterFrame);
			Imitation.rootmc.addChild(mc);
			mc.visible = false;
			InitDebugInfo();
		}

		public static function Hide():void
		{
			if (!mc)
			{
				return;
			}
			mc.removeEventListener("enterFrame", OnEnterFrame);
			if (mc.parent)
			{
				mc.parent.removeChild(mc);
			}
			mc = null;
		}

		private static function InitDebugInfo():*
		{
			var key:Array = null;
			var onUp:Function = null;
			var onDown:Function = null;
			onUp = function(e:KeyboardEvent):void
			{
				key[e.keyCode] = false;
			};
			onDown = function(e:KeyboardEvent):void
			{
				key[e.keyCode] = true;
				if (Boolean(key[65]) && Boolean(key[83]) && Boolean(key[68]) && Boolean(key[70]))
				{
					mc.visible = !mc.visible;
				}
			};
			mc.x = 110;
			mc.y = 110;
			FPSTimer.addEventListener(TimerEvent.TIMER, HandleTimer);
			FPSTimer.start();
			Imitation.stage.addEventListener(KeyboardEvent.KEY_DOWN, onDown);
			Imitation.stage.addEventListener(KeyboardEvent.KEY_UP, onUp);
			key = [];
			Imitation.AddEventClick(mc.REGIONS, function(e:*):*
				{
					Imitation.showregions = !Imitation.showregions;
					Imitation.FreeBitmapAll();
					Imitation.UpdateAll();
				});
			Imitation.AddEventClick(mc.SHADOW, function(e:*):*
				{
					if (heatmap)
					{
						Imitation.rootmc.removeChild(heatmap);
						heatmap = null;
					}
					else
					{
						heatmap = new MovieClip();
						Imitation.rootmc.addChild(heatmap);
					}
				});
			Imitation.AddEventClick(mc.IBTN, function(e:*):*
				{
					var stat:* = Imitation.CollectStats(null, true);
					trace(stat.details.length);
					for (var i:* = 0; i < stat.details.length; i++)
					{
						trace(Util.MovPathName(stat.details[i][0]), stat.details[i][1]);
					}
					trace("---");
					Util.trace_event_listeners = true;
				});
		}

		public static function OnEnterFrame(e:*):*
		{
			++fps_counter;
		}

		public static function HandleTimer(e:*):*
		{
			var k:* = undefined;
			var diff:Number = NaN;
			var i:uint = 0;
			var Map:* = undefined;
			var stat:Object = null;
			var stat2:Object = null;
			var a:String = null;
			if (!mc || !mc.parent)
			{
				return;
			}
			var now:Number = Number(new Date().getTime());
			var fps:uint = 0;
			if (fps_time > 0)
			{
				diff = now - fps_time;
				if (diff > 0 && diff < 60000)
				{
					fps = Math.round(fps_counter * 1000 / diff);
					for (i = fps_values.length - 1; i >= 1; fps_values[i] = fps_values[i - 1], i--)
					{
					}
					fps_values[0] = fps;
				}
			}
			fps_time = now;
			fps_counter = 0;
			for (k in fps_values)
			{
				mc["T" + (10 - k)].scaleY = fps_values[k] / 60;
			}
			if (mc.visible)
			{
				mc.FPS.text = fps.toString();
				Map = Modules.GetClass("triviador", "triviador.Map");
				CountAllObjects(0, Imitation.rootmc);
				mc.EVT.text = Util.CountEventListeners().toString();
				mc.DISPATCH.text = Util.dispatch_count.toString();
				Util.dispatch_count = 0;
				mc.OBJ.text = display_object_count.toString();
				mc.VISIBLE.text = visible_object_count.toString();
				mc.TWEEN.text = tweened_object_count.toString();
				if (Sys.gsqc)
				{
					mc.SQ.text = Sys.gsqc.anims.length.toString();
				}
				mc.MEM.text = (int(System.totalMemory / 1024 / 1024 * 10) / 10).toString();
				mc.IMIT.text = "";
				stat = Imitation.CollectStats();
				mc.IMIT.appendText("count:" + stat.count + "\n");
				mc.IMIT.appendText("containers:" + stat.containers + "\n");
				mc.IMIT.appendText("imitatornum:" + stat.imitatornum + "\n");
				mc.IMIT.appendText("container:" + stat.container + "\n");
				mc.IMIT.appendText("invisibles:" + stat.invisibles + "\n");
				mc.IMIT.appendText("caches:" + stat.caches + "\n");
				mc.IMIT.appendText("masks:" + stat.masks + "\n");
				mc.IMIT.appendText("maskedchilds:" + stat.maskedchilds + "\n");
				mc.POOL.text = "";
				stat2 = {};
				for (k in Pool.pool)
				{
					if (Pool.pool[k][0])
					{
						a = getQualifiedClassName(Pool.pool[k][0]);
						a = a.substring(a.lastIndexOf("::") + 2);
						stat2[a] = Util.NumberVal(stat2[a]) + Pool.pool[k].length;
					}
				}
				for (k in stat2)
				{
					mc.POOL.appendText(k + ":" + stat2[k] + "\n");
				}
				mc.POOL.appendText("BitmapData:" + BitmapDataPool.pool.length + "\n");
				mc.POOL.appendText(BitmapDataPool.stat_pop + "," + BitmapDataPool.stat_new + "," + BitmapDataPool.stat_push + "\n");
				mc.POOL.appendText(Math.round(BitmapDataPool.stat_pop * 100 / (BitmapDataPool.stat_pop + BitmapDataPool.stat_new)).toString());
				BitmapDataPool.stat_pop = 0;
				BitmapDataPool.stat_push = 0;
				BitmapDataPool.stat_new = 0;
				if (heatmap)
				{
					Imitation.FreeBitmap(heatmap);
					Imitation.rootmc.removeChild(heatmap);
					heatmap = new MovieClip();
					heatmap.graphics.clear();
					heatmap.graphics.beginFill(0, 0.5);
					heatmap.graphics.drawRect(0, 0, Imitation.stage.width, Imitation.stage.height);
					heatmap.graphics.endFill();
					heatmap.mouseEnabled = false;
					HeatAllChildrenMov(Imitation.rootmc);
					heatmap.cacheAsBitmap = true;
					Imitation.rootmc.addChild(heatmap);
				}
			}
		}

		private static function InternalCountAllObjects(show:int, doc:DisplayObjectContainer, vis:Boolean):void
		{
			var child:DisplayObject = null;
			if (doc == mc)
			{
				return;
			}
			if (doc == heatmap)
			{
				return;
			}
			for (var cidx:int = 0; cidx < doc.numChildren; cidx++)
			{
				child = doc.getChildAt(cidx);
				if (child)
				{
					++display_object_count;
					if (TweenMax.isTweening(child))
					{
						++tweened_object_count;
						if (show == 3)
						{
							trace(Util.MovPathName(child));
						}
					}
					if (vis && child.visible)
					{
						++visible_object_count;
						if (show == 1)
						{
							trace(Util.MovPathName(child));
						}
					}
					else if (show == 2)
					{
						trace(Util.MovPathName(child));
					}
					if (child is DisplayObjectContainer)
					{
						InternalCountAllObjects(show, child as DisplayObjectContainer, vis && child.visible);
					}
				}
			}
		}

		private static function CountAllObjects(show:int, doc:DisplayObjectContainer):void
		{
			display_object_count = 0;
			visible_object_count = 0;
			tweened_object_count = 0;
			InternalCountAllObjects(show, doc, true);
		}

		private static function HeatAllChildrenMov(amc:MovieClip, cached:* = false):*
		{
			var m:* = undefined;
			var p:* = undefined;
			var b:* = undefined;
			var n:* = undefined;
			var i:* = undefined;
			var changed:* = undefined;
			var d:* = undefined;
			if (!amc)
			{
				return;
			}
			for (var cidx:* = 0; cidx < amc.numChildren; cidx++)
			{
				m = amc.getChildAt(cidx);
				if (m)
				{
					if (m is MovieClip)
					{
						if (m.visible)
						{
							p = Util.LocalToGlobal(m);
							b = Util.LocalToGlobalBounded(m);
							n = -1;
							for (i in heatdata)
							{
								if (heatdata[i][0] == m)
								{
									n = i;
									break;
								}
							}
							if (n == -1)
							{
								heatdata.push([m, {}]);
								n = heatdata.length - 1;
							}
							changed = false;
							d = heatdata[n][1];
							if (d.x != b.x || d.y != b.y || d.w != b.w || d.h != b.h || d.a != m.alpha)
							{
								changed = true;
							}
							heatmap.graphics.beginFill(16776960, !!cached ? 0 : 0.1);
							if (changed && (cached || Boolean(m.cacheAsBitmap)))
							{
								heatmap.graphics.lineStyle(1, 16711680, 0.8);
							}
							else if (cached)
							{
								heatmap.graphics.lineStyle(1, 65280, 0.1);
							}
							else
							{
								heatmap.graphics.lineStyle(1, 255, 0.5);
							}
							heatmap.graphics.drawRect(b.x, b.y, b.w, b.h);
							heatmap.graphics.endFill();
							HeatAllChildrenMov(m, cached || m.cacheAsBitmap);
							d.x = b.x;
							d.y = b.y;
							d.w = b.w;
							d.h = b.h;
							d.a = m.alpha;
						}
					}
				}
			}
		}

		internal function __setProp_IBTN_DebugInfo_Layer4_0():*
		{
			try
			{
				this.IBTN["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.IBTN.enabled = true;
			this.IBTN.fontsize = "BIG";
			this.IBTN.icon = "";
			this.IBTN.skin = "NORMAL";
			this.IBTN.testcaption = "I";
			this.IBTN.visible = true;
			this.IBTN.wordwrap = false;
			try
			{
				this.IBTN["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
		}
	}
}
