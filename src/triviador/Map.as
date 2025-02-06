package triviador
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import fl.motion.easing.*;
	import fl.transitions.easing.Regular;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.geom.*;
	import flash.system.Capabilities;
	import flash.text.*;
	import flash.utils.*;
	import syscode.*;
	import triviador.gfx.libmc_AreaEffects;

	public class Map
	{
		private static var clockplacemc:MovieClip;

		public static var useselectring:Boolean = true;

		public static var selectedarea:int = 0;

		internal static var combined:Boolean = false;

		internal static var initialized:Boolean = false;

		internal static var effectsmc:MovieClip = null;

		public static var mapid:String = "";

		internal static var loadedmaps:Object = {};

		internal static var currentmapswf:MovieClip = null;

		public static var loaded:Boolean = false;

		internal static var isloading:Boolean = false;

		internal static var updateafterload:Boolean = false;

		internal static var mapbitmap:Bitmap = null;

		internal static var mapbitmapdata:BitmapData = null;

		internal static var shadebitmap:Bitmap = null;

		internal static var shadebitmapdata:BitmapData = null;

		public static var mc:MovieClip = null;

		public static var colorlayers:MovieClip = null;

		public static var areacolors:Vector.<MovieClip> = null;

		public static var fills:Vector.<MovieClip> = null;

		public static var borders:Vector.<MovieClip> = null;

		public static var intborders:Vector.<MovieClip> = null;

		public static var disabledlayer:MovieClip = null;

		public static var disabledareas:Vector.<MovieClip> = null;

		public static var arrowsmc:MovieClip = null;

		public static var roadsmc:MovieClip = null;

		public static var roadsbackmc:MovieClip = null;

		public static var shieldsmc:MovieClip = null;

		public static var captionsmc:MovieClip = null;

		public static var overlaycaptionsmc:MovieClip = null;

		public static var ways:Object = null;

		private static var origpos:Object = {};

		public static var markerlayer:MovieClip = null;

		public static var areamarkers:Vector.<AreaMarkerMov> = null;

		public static var maphelplayer:MovieClip = null;

		public static var maphelpmarkers:Vector.<MapHelpMarkerMov> = null;

		public static var areafillscales:Vector.<Number> = null;

		public static var prevowners:Array = [];

		private static var prevcolors:Array = [];

		public static var selection_enabled:Boolean = false;

		public static var verticallayout:Boolean = false;

		public static var mapscale:Number = 1;

		public static var markerscale:Number = 1;

		public static var mapshiftx:Number = 0;

		public static var mapshifty:Number = 0;

		public static var cleanx:Number = 0;

		public static var cleany:Number = 0;

		public static var cleanwidth:Number = 0;

		public static var cleanheight:Number = 0;

		public static var usedwidth:Number = 1;

		public static var usedheight:Number = 1;

		public static var areanum:int = 0;

		public static var neighbours:Array = [];

		public static var originaleffects:* = {};

		public static var autoselectstarttime:int = 0;

		public static var autoselecttime:int = 2000;

		public static var autoattacktime:int = 3000;

		public static var autoselectparts:Array = [];

		public static var pdplacemc:MovieClip = null;

		public static var bg_anim:MovieClip = null;

		public static var submc:MovieClip = null;

		public static var roadsallmc:MovieClip = null;

		public static var mapcombine:Boolean = false;

		internal static var animstep:int = 0;

		public function Map()
		{
			super();
		}

		public static function Init():*
		{
			var i:int = 0;
			trace("MAP.INIT");
			if (initialized)
			{
				return;
			}
			mc = new MovieClip();
			mc.name = "MAPmc";
			effectsmc = new libmc_AreaEffects();
			Util.StopAllChildrenMov(effectsmc);
			submc = new MovieClip();
			roadsallmc = new MovieClip();
			colorlayers = new MovieClip();
			areacolors = new Vector.<MovieClip>();
			areafillscales = new Vector.<Number>();
			fills = new Vector.<MovieClip>();
			borders = new Vector.<MovieClip>();
			intborders = new Vector.<MovieClip>();
			disabledlayer = new MovieClip();
			disabledareas = new Vector.<MovieClip>();
			markerlayer = new MovieClip();
			areamarkers = new Vector.<AreaMarkerMov>();
			maphelplayer = new MovieClip();
			maphelpmarkers = new Vector.<MapHelpMarkerMov>();
			areanum = 20;
			areacolors[0] = null;
			areafillscales[0] = 1;
			fills[0] = null;
			borders[0] = null;
			intborders[0] = null;
			areamarkers[0] = null;
			maphelpmarkers[0] = null;
			disabledareas[0] = null;
			i = 1;
			while (i <= areanum)
			{
				areacolors[i] = new MovieClip();
				areacolors[i].name = "areacolor_" + i;
				areacolors[i].cacheAsBitmap = true;
				areacolors[i].visible = false;
				colorlayers.addChild(areacolors[i]);
				areafillscales[i] = 1;
				areamarkers[i] = null;
				maphelpmarkers[i] = null;
				disabledareas[i] = new MovieClip();
				disabledareas[i].cacheAsBitmap = true;
				disabledlayer.addChild(disabledareas[i]);
				i++;
			}
			i = 1;
			while (i <= areanum)
			{
				prevowners[i] = 0;
				prevcolors[i] = 0;
				i++;
			}
			var originalmarker:* = new AreaMarkerMov();
			Util.StopAllChildrenMov(originalmarker);
			Util.StopAllChildrenMov(originalmarker);
			originaleffects["SOLDIER.SKIN"] = [new DropShadowFilter(0, 45, 0, 1, 3, 3, 10, 1), new GlowFilter(16777215, 1, 2, 2, 15, 1), new GlowFilter(0, 0.5, 3, 3, 20, 1), new DropShadowFilter(5, 45, 0, 1, 0, 0, 0.5, 1)];
			InitEffectScales("CASTLE", originalmarker.CASTLE);
			InitEffectScales("FILLS", effectsmc.FILL1);
			InitEffectScales("BORDERS", effectsmc.BORDER1);
			InitEffectScales("INTBORDERS", effectsmc.INTBORDER1);
			InitEffectScales("ROADS", effectsmc.ROADS);
			InitEffectScales("CAPTIONS", effectsmc.CAPTIONS1);
			InitEffectScales("DISABLED", effectsmc.DISABLED);
			initialized = true;
		}

		public static function InitEffectScales(id:String, m:DisplayObject):void
		{
			if (originaleffects[id])
			{
				return;
			}
			originaleffects[id] = m.filters;
		}

		public static function ScaleEffects(id:String, m:DisplayObject, scale:Number):void
		{
			var f:* = undefined;
			var e:* = undefined;
			var o:* = undefined;
			if (!m)
			{
				return;
			}
			var filters:Array = m.filters;
			for (f in originaleffects[id])
			{
				e = filters[f];
				o = originaleffects[id][f];
				if (e && o)
				{
					if (e.hasOwnProperty("blurX"))
					{
						e.blurX = Math.max(1.5, o.blurX * scale);
					}
					if (e.hasOwnProperty("blurY"))
					{
						e.blurY = Math.max(1.5, o.blurY * scale);
					}
					if (!(e is GradientGlowFilter) && Boolean(e.hasOwnProperty("distance")))
					{
						e.distance = o.distance * scale;
					}
				}
			}
			m.filters = filters;
		}

		public static function SwapMapBitmap(_src:DisplayObject, _target:Bitmap):MovieClip
		{
			if (!_target)
			{
				return null;
			}
			var bounds:Rectangle = _src.getBounds(_src);
			var smc:MovieClip = new MovieClip();
			smc.addChild(_target);
			_target.x = bounds.left;
			_target.y = bounds.top;
			_target.width = _src.width;
			_target.height = _src.height;
			smc.name = _src.name;
			_target.cacheAsBitmap = _src.cacheAsBitmap;
			_src.parent.addChildAt(smc, _src.parent.getChildIndex(_src));
			_src.parent.removeChild(_src);
			_src = null;
			Imitation.FreeBitmapAll(smc.parent);
			Imitation.CollectChildrenAll(smc.parent);
			Imitation.UpdateAll(smc.parent);
			return smc;
		}

		public static function InitLoadedMap(aswf:MovieClip):void
		{
			var n:int = 0;
			var i:int = 0;
			var amc:MovieClip = null;
			var narr:Array = null;
			var mm:MovieClip = null;
			var om:MovieClip = null;
			var a:MovieClip = null;
			var m:MovieClip = null;
			var s:MovieClip = null;
			var sma:* = false;
			trace("Init loaded map...");
			currentmapswf = aswf;
			if (!Config.external_map)
			{
				Util.SwapSkin(MovieClip(currentmapswf["MAPGFX"]), "skin_map", "MapBg");
			}
			Util.StopAllChildrenMov(currentmapswf);
			var areasmc:MovieClip = MovieClip(currentmapswf["AREAS"]);
			neighbours = [null];
			areanum = 0;
			while (areasmc["A" + (areanum + 1)] !== undefined)
			{
				++areanum;
				neighbours[areanum] = "";
			}
			var neighbourstf:TextField = TextField(currentmapswf["NEIGHBOURS"]);
			n = 1;
			while (n <= neighbourstf.numLines)
			{
				narr = neighbourstf.getLineText(n - 1).split(":");
				neighbours[Util.NumberVal(narr[0])] = Util.Trim(Util.StringVal(narr[1]));
				n++;
			}
			trace("Map " + mapid + " area number: " + areanum);
			Semu.SetMap(mapid, areanum, neighbours);
			trace("map anims:off");
			bg_anim = null;
			FreeMapGfx();
			// FIXME for some reason this shows an error in the IDE, but compiles
			var fillsmc:MovieClip = new areasmc.constructor();
			var bordersmc:MovieClip = new areasmc.constructor();
			var intbordersmc:MovieClip = new areasmc.constructor();
			var disabledareasmc:MovieClip = new areasmc.constructor();
			var changemasksmc:MovieClip = new areasmc.constructor();
			trace("constructor ok");
			n = 1;
			while (n <= areanum)
			{
				fills[n] = fillsmc["A" + n];
				borders[n] = bordersmc["A" + n];
				intborders[n] = intbordersmc["A" + n];
				areacolors[n].addChild(fills[n]);
				areacolors[n].addChild(borders[n]);
				areacolors[n].addChild(intborders[n]);
				if (!areamarkers[n])
				{
					areamarkers[n] = new AreaMarkerMov();
					areamarkers[n].id = n;
					trace("marker " + n + " created");
					areamarkers[n].Setup(0, 0, 0);
					trace("marker " + n + " setup");
					areamarkers[n].visible = false;
					markerlayer.addChild(areamarkers[n]);

				}
				mm = new effectsmc["NEWMASK"].constructor();
				trace("-1");
				mm.gotoAndStop(1);
				trace("-0");
				om = currentmapswf["MARKER" + n];
				if (om)
				{
					mm.x = om.x - currentmapswf["AREAS"].x;
					mm.y = om.y - currentmapswf["AREAS"].y;
				}
				else
				{
					mm.x = fills[n].x;
					mm.y = fills[n].y;
				}
				mm.width = Math.max(fills[n].width, fills[n].height) * 1.4;
				mm.scaleY = mm.scaleX;
				areafillscales[n] = mm.scaleX;
				mm.visible = false;
				mm.cacheAsBitmap = true;
				if (!maphelpmarkers[n])
				{
					maphelpmarkers[n] = new MapHelpMarkerMov();
					maphelpmarkers[n].visible = false;
					maphelpmarkers[n].active = false;
				}
				amc = disabledareasmc["A" + n];
				amc.transform.colorTransform = effectsmc["DISABLED"].transform.colorTransform;
				amc.filters = effectsmc["DISABLED"].filters;
				disabledareas[n].addChild(amc);
				n++;
			}
			trace(0);
			i = 1;
			while (i <= areanum)
			{
				areacolors[i].visible = false;
				i++;
			}
			roadsmc = MovieClip(currentmapswf["ROADS"]);
			if (roadsmc)
			{
				roadsbackmc = MovieClip(new currentmapswf["ROADS"].constructor());
			}
			trace("before arrows");
			arrowsmc = MovieClip(currentmapswf["ARROWS"]);
			shieldsmc = MovieClip(currentmapswf["SHIELDS"]);
			captionsmc = MovieClip(currentmapswf["CAPTIONS"]);
			overlaycaptionsmc = new MovieClip();
			if (arrowsmc)
			{
				i = 1;
				while (i <= areanum)
				{
					a = new AttackArrow();
					arrowsmc.addChild(a);
					arrowsmc["A" + i] = a;
					i++;
				}
			}
			Util.StopAllChildrenMov(arrowsmc);
			if (arrowsmc)
			{
				if (!origpos["ARROWS"])
				{
					origpos["ARROWS"] = {
							"x": arrowsmc.x,
							"y": arrowsmc.y
						};
				}
			}
			if (roadsmc)
			{
				if (!origpos["ROADS"])
				{
					origpos["ROADS"] = {
							"x": roadsmc.x,
							"y": roadsmc.y
						};
				}
			}
			if (captionsmc)
			{
				if (!origpos["CAPTIONS"])
				{
					origpos["CAPTIONS"] = {
							"x": captionsmc.x,
							"y": captionsmc.y
						};
				}
			}
			if (!shieldsmc)
			{
				shieldsmc = new MovieClip();
				i = 1;
				while (i <= areanum)
				{
					m = currentmapswf["MARKER" + i];
					s = new DefaultShield();
					shieldsmc["S" + i] = s;
					s.x = m.x;
					s.y = m.y;
					origpos["S" + i] = {
							"x": s.x,
							"y": s.y
						};
					shieldsmc.addChild(s);
					i++;
				}
			}
			trace(1);
			if (shieldsmc)
			{
				Util.StopAllChildrenMov(shieldsmc);
				if (!origpos["SHIELDS"])
				{
					origpos["SHIELDS"] = {
							"x": shieldsmc.x,
							"y": shieldsmc.y
						};
				}
				HideMapShields();
				i = 1;
				while (i <= areanum)
				{
					m = currentmapswf["MARKER" + i];
					s = shieldsmc["S" + i];
					if (!origpos["S" + i])
					{
						origpos["S" + i] = {
								"x": m.x - shieldsmc.x,
								"y": m.y - shieldsmc.y
							};
					}
					if (!s.sm)
					{
						s.sm = new ShieldMissionGfx();
						shieldsmc.addChildAt(s.sm, 0);
					}
					if (!s.sm2)
					{
						s.sm2 = new SMCheck();
						shieldsmc.addChild(s.sm2);
					}
					Util.StopAllChildrenMov(s.sm);
					s.sm.gotoAndStop(1);
					s.sm.ANIM.gotoAndStop(1);
					s.sm2.gotoAndStop(2);
					s.sm.visible = false;
					s.sm2.visible = false;
					s.rotation = 0;
					s.scaleX = 1;
					s.scaleY = 1;
					s.x = origpos["S" + i].x;
					s.y = origpos["S" + i].y;
					s.alpha = 1;
					s.sm.alpha = 1;
					s.sm2.alpha = 1;
					s.sm.transform.matrix = s.transform.matrix;
					s.sm2.transform.matrix = s.transform.matrix;
					s.visible = false;
					s.c = 0;
					s.cacheAsBitmap = false;
					sma = (Sys.mydata.shieldmission & 1 << i - 1) != 0;
					s.sm2.visible = !sma;
					i++;
				}
			}
			trace(2);
			if (Boolean(arrowsmc) && Boolean(roadsmc))
			{
				InitWays();
				HideAllWays(false);
			}
			if (Config.noanims.indexOf("ARROWS") >= 0)
			{
				if (roadsmc)
				{
					Cleanup(roadsmc);
					roadsmc = null;
				}
				if (roadsbackmc)
				{
					Cleanup(roadsbackmc);
					roadsbackmc = null;
				}
				if (arrowsmc)
				{
					Cleanup(arrowsmc);
					arrowsmc = null;
				}
				if (ways)
				{
					ways = null;
				}
			}
			trace(3);
			Imitation.AddEventMouseDown(mc, OnMapMouseDown);
			selection_enabled = false;
			AlignMap();
			UpdateLayers();
			Imitation.UpdateAll(colorlayers);
		}

		public static function Cleanup(mc:MovieClip):void
		{
			if (mc)
			{
				Imitation.RemoveEvents(mc);
				Util.StopAllChildrenMov(mc);
				if (mc.parent)
				{
					mc.parent.removeChild(mc);
					Imitation.CollectChildrenAll(mc.parent);
				}
			}
		}

		public static function HotShield(num:*, hot:Boolean):void
		{
			if (!shieldsmc["S" + num])
			{
				return;
			}
			if (hot)
			{
				TweenMax.to(shieldsmc["S" + num], 0.4, {
							"scaleX": 1.2,
							"scaleY": 1.2
						});
			}
			else
			{
				TweenMax.to(shieldsmc["S" + num], 0.4, {
							"scaleX": 1,
							"scaleY": 1
						});
			}
		}

		private static function GetDistance(a:MovieClip, b:MovieClip):*
		{
			var tx:Number = a.x - b.x;
			var ty:Number = a.y - b.y;
			return Math.sqrt(tx * tx + ty * ty);
		}

		public static function ShowWays(myturn:Boolean, anim:Boolean):void
		{
			var available:* = false;
			var node:* = undefined;
			var best:int = 0;
			var used_min:int = 0;
			var dist_min:int = 0;
			var way:Object = null;
			var o:* = undefined;
			var wu:int = 0;
			var distance:* = undefined;
			var amc:MovieClip = null;
			var ashape:MovieClip = null;
			trace("ShowWays");
			anim = false;
			if (!arrowsmc)
			{
				return;
			}
			Imitation.CollectChildrenAll(roadsmc);
			Imitation.CollectChildrenAll(arrowsmc);
			var nodes_used:* = {};
			var n:int = 1;
			while (n <= Game.areanum)
			{
				available = (Game.availableareasmask & 1 << n - 1) != 0;
				if (available && Game.areas[n].owner != Game.nextplayer)
				{
					node = ways[n];
					best = 0;
					used_min = int.MAX_VALUE;
					dist_min = int.MAX_VALUE;
					if (Game.state == 4 && Game.gameround == Game.warrounds)
					{
						way = ways[0][n];
						best = 0;
					}
					else
					{
						for (o in node)
						{
							if (o > 0 && Game.areas[o].owner == Game.nextplayer)
							{
								way = ways[o][n];
								wu = !!nodes_used[o] ? int(nodes_used[o]) : 0;
								distance = GetDistance(areamarkers[o], areamarkers[n]);
								if (wu < used_min || wu == used_min && distance < dist_min)
								{
									best = o;
									used_min = int(nodes_used[o]);
									dist_min = distance;
								}
							}
						}
					}
					if (best > 0)
					{
						if (!nodes_used[best])
						{
							nodes_used[best] = 1;
						}
						else
						{
							++nodes_used[best];
						}
					}
					for (o in node)
					{
						if (o == 0 || Game.areas[o].owner == Game.nextplayer)
						{
							way = ways[o][n];
							if (o == best)
							{
								if (Boolean(way.a) && way.a.numChildren > 0)
								{
									TweenMax.killTweensOf(way.a);
									way.a.alpha = 1;
									way.a.visible = true;
									amc = MovieClip(way.a.getChildAt(0));
									amc.gotoAndStop(Game.nextplayer);
									ashape = MovieClip(amc.getChildAt(0));
									ashape.cacheAsBitmap = true;
									ashape.scaleX = ashape.scaleY = 0.6;
									if (way.o)
									{
										ashape.rotation = 180;
										if (way.a.V)
										{
											way.a.V.OBJ.scaleX = -1;
										}
										way.a.gotoAndStop(15);
									}
									else
									{
										ashape.rotation = 0;
										if (way.a.V)
										{
											way.a.V.OBJ.scaleX = 1;
										}
										way.a.gotoAndStop(105);
									}
									Imitation.FreeBitmapAll(amc);
									Imitation.UpdateAll(amc);
								}
							}
							if (way.r)
							{
								way.ra.visible = o == best;
								if (way.r.pnum != Game.nextplayer && Boolean(way.ra.visible))
								{
									way.r.pnum = Game.nextplayer;
									way.r.cacheAsBitmap = true;
									Util.SetTint(way.r, Config.playercolorcodes[Game.nextplayer], 1);
									Imitation.SetBoundsBorder(way.ra, 5);
									Imitation.FreeBitmapAll(way.ra);
									Imitation.UpdateAll(way.ra);
								}
							}
						}
					}
				}
				n++;
			}
			if (selection_enabled)
			{
				AreaSelectionStep();
			}
		}

		public static function AnimArrowTo(area:int):Boolean
		{
			var i:* = undefined;
			var n:* = undefined;
			var way:* = undefined;
			if (area == 0)
			{
				return true;
			}
			var b:* = true;
			for (i in ways)
			{
				for (n in ways[i])
				{
					way = ways[i][n];
					if (Boolean(way.a) && Boolean(way.a.visible) && Boolean(way.o) && i > 0)
					{
						way.a.alpha = 1;
						if (area == n)
						{
							b = !TweenMax.isTweening(way.a);
							if (b)
							{
								if (way.a.V)
								{
									way.a.V.OBJ.scaleX = -1;
								}
								TweenMax.fromTo(way.a, 0.4, {"frame": 15}, {
											"frame": 0,
											"repeat": 1,
											"yoyo": true,
											"ease": Regular.easeIn
										});
							}
						}
						else if (area == i)
						{
							b = !TweenMax.isTweening(way.a);
							if (b)
							{
								if (way.a.V)
								{
									way.a.V.OBJ.scaleX = 1;
								}
								TweenMax.fromTo(way.a, 0.4, {"frame": 105}, {
											"frame": 120,
											"repeat": 1,
											"yoyo": true,
											"ease": Regular.easeIn
										});
							}
						}
						else if (way.a)
						{
						}
					}
				}
			}
			return b;
		}

		public static function HideAllWays(anim:Boolean):void
		{
			var aanim:AreaMarkerMov;
			var node:* = undefined;
			var way:* = undefined;
			trace("HideAllWays");
			aanim = Main.mc.ATTACKANIM;
			TweenMax.killTweensOf(aanim);
			TweenMax.killChildTweensOf(aanim);
			TweenMax.killTweensOf(roadsbackmc);
			anim = false;
			for each (node in ways)
			{
				for each (way in node)
				{
					if (anim)
					{
						if (way.r)
						{
							TweenMax.to(way.r, 0.8, {
										"alpha": 0,
										"visible": 0
									});
						}
						if (way.b)
						{
							TweenMax.to(way.b, 0.8, {
										"alpha": 0,
										"visible": 0
									});
						}
						if (way.a)
						{
							TweenMax.to(way.a, 0.8, {
										"alpha": 0,
										"visible": 0,
										"onComplete": function():*
										{
											TweenMax.killTweensOf(way.a);
										}
									});
						}
					}
					else
					{
						if (way.ra)
						{
							way.ra.visible = false;
						}
						if (way.a)
						{
							TweenMax.killTweensOf(way.a);
							way.a.alpha = 0;
							way.a.visible = false;
						}
					}
				}
			}
		}

		public static function ShowSelectedWay(area:int):void
		{
			var i:* = undefined;
			var n:* = undefined;
			var way:* = undefined;
			trace("ShowSelectedWay");
			if (Game.areas[area].owner == Game.iam)
			{
				HideAllWays(false);
				return;
			}
			var aanim:AreaMarkerMov = Main.mc.ATTACKANIM;
			TweenMax.killTweensOf(aanim);
			TweenMax.killChildTweensOf(aanim);
			if (mapcombine)
			{
				Imitation.Combine(submc, false);
			}
			for (i in ways)
			{
				for (n in ways[i])
				{
					way = ways[i][n];
					if (Boolean(way.a) && Boolean(way.a.visible) && Boolean(way.o))
					{
						way.a.alpha = 1;
						if (area == n)
						{
							TweenMax.fromTo(way.a, 1.5, {
										"frame": 120,
										"visible": true
									}, {
										"frame": 1,
										"visible": false,
										"repeat": -1,
										"ease": fl.motion.easing.Linear.easeNone,
										"repeatDelay": 0
									});
							if (way.a.V)
							{
								way.a.V.OBJ.scaleX = -1;
							}
						}
						else if (area == i)
						{
							if (way.a.V)
							{
								way.a.V.OBJ.scaleX = 1;
							}
							TweenMax.fromTo(way.a, 1.5, {
										"frame": 1,
										"visible": true
									}, {
										"frame": 120,
										"visible": false,
										"repeat": -1,
										"ease": fl.motion.easing.Linear.easeNone,
										"repeatDelay": 0
									});
						}
						else
						{
							if (way.a)
							{
								TweenMax.killTweensOf(way.a);
								way.a.alpha = 0;
							}
							if (way.ra)
							{
								TweenMax.killTweensOf(way.ra);
								way.ra.visible = false;
							}
						}
					}
				}
			}
			if (mapcombine)
			{
				Imitation.Combine(submc, true);
			}
		}

		public static function AlignMapCaptions():*
		{
			var a:* = undefined;
			var mh:MapHelpMarkerMov = null;
			var z:int = 0;
			var cmc:MovieClip = null;
			if (!captionsmc)
			{
				return;
			}
			var n:int = 1;
			while (n <= areanum)
			{
				a = (Game.availableareasmask & 1 << n - 1) != 0;
				mh = maphelpmarkers[n];
				z = z = ((!!Game.areas[n].base ? 42 : 35) + (!a && mh.active ? 4 : 0)) * markerscale;
				if (selectedarea == n)
				{
					z = Math.max(z, 115 * captionsmc.scaleY);
				}
				cmc = captionsmc["C" + n];
				cmc.x = (Map.areamarkers[n].x - captionsmc.x) / captionsmc.scaleX;
				TweenMax.to(cmc, 0.2, {
							"y": (Map.areamarkers[n].y + z - captionsmc.y) / captionsmc.scaleY,
							"alpha": (a || selectedarea == n ? 1 : 0.6),
							"ease": fl.motion.easing.Back.easeOut
						});
				n++;
			}
		}

		public static function ShowMapShields():void
		{
			var a:* = undefined;
			var mh:MapHelpMarkerMov = null;
			var sc:int = 0;
			var s:MovieClip = null;
			var sma:Boolean = false;
			var cmc:MovieClip = null;
			var c:int = 0;
			if (!shieldsmc)
			{
				return;
			}
			var n:int = 1;
			while (n <= areanum)
			{
				a = (Game.availableareasmask & 1 << n - 1) != 0;
				mh = maphelpmarkers[n];
				if ((a || mh.active && Game.areas[n].owner != Game.nextplayer) && Boolean(Game.nextplayer))
				{
					sc = int(Config.playercolorcodes[Game.nextplayer]);
					s = shieldsmc["S" + n];
					if (s)
					{
						shieldsmc.addChild(s);
						shieldsmc.addChild(s.sm2);
						if (Game.rules == 1 && Game.state < 4 && Game.roomtype == "C" && Game.room <= 32)
						{
							sma = (Sys.mydata.shieldmission & 1 << n - 1) == 0 && Game.areas[n].owner == 0;
							if (Game.iam == Game.nextplayer)
							{
								s.sm.visible = sma;
								s.sm2.visible = false;
								if (sma)
								{
									s.sm.ANIM.gotoAndStop(1);
									TweenMax.fromTo(s.sm, 3, {"rotation": 0}, {
												"rotation": 360,
												"ease": fl.motion.easing.Linear.easeNone,
												"repeat": -1
											});
								}
							}
							else
							{
								s.sm.visible = false;
								s.sm2.visible = sma;
							}
						}
						else
						{
							s.sm.visible = false;
							s.sm2.visible = false;
						}
						if (a && Game.state != 4)
						{
							if (s.c != sc)
							{
								s.c = sc;
								Util.SetTint(s.getChildAt(1), sc, 1);
								Util.SetTint(MovieClip(s.getChildAt(0)).getChildAt(1), sc, 1);
								s.cacheAsBitmap = true;
								Imitation.FreeBitmapAll(s);
								Imitation.UpdateAll(s);
							}
							s.visible = true;
							s.x = origpos["S" + n].x;
							s.y = origpos["S" + n].y;
						}
						else
						{
							s.visible = false;
						}
						s.alpha = 1;
						if (captionsmc)
						{
							cmc = captionsmc["C" + n];
							if (cmc)
							{
								c = !!Game.areas[n].owner ? int(Game.areas[n].owner) : Game.nextplayer;
								cmc.visible = true;
								if (cmc.c != c)
								{
									cmc.c = c;
									cmc.filters = effectsmc["CAPTIONS" + c].filters;
									ScaleEffects("CAPTIONS", cmc, mapscale * fills[n].scaleX);
									Imitation.FreeBitmapAll(cmc);
									Imitation.UpdateAll(cmc);
								}
							}
						}
						if (Game.nextplayer == Game.iam)
						{
							Imitation.AddEventClick(s, OnMapMouseDown);
						}
						else
						{
							Imitation.RemoveEvents(s);
						}
					}
				}
				else if (Boolean(captionsmc) && Boolean(captionsmc["C" + n]))
				{
					captionsmc["C" + n].visible = false;
				}
				if (Boolean(s) && Boolean(s.sm))
				{
					s.sm.transform.matrix = s.transform.matrix;
					s.sm2.transform.matrix = s.transform.matrix;
				}
				n++;
			}
			AlignMapCaptions();
		}

		public static function HideMapShields():void
		{
			var s:MovieClip = null;
			var sma:* = false;
			var n:int = 1;
			while (n <= areanum)
			{
				if (shieldsmc)
				{
					s = shieldsmc["S" + n];
					s.visible = false;
					TweenMax.killTweensOf(s);
					if (s.sm)
					{
						TweenMax.killTweensOf(s.sm);
						s.sm.visible = false;
					}
					if (s.sm2)
					{
						if (Game.areas[n].owner == 0 && Game.roomtype == "C" && Game.rules == 1 && Game.room <= 32)
						{
							sma = (Sys.mydata.shieldmission & 1 << n - 1) != 0;
							s.sm2.visible = !sma;
						}
						else
						{
							s.sm2.visible = false;
							Util.StopAllChildrenMov(s.sm);
							s.sm.gotoAndStop(1);
							s.sm.ANIM.gotoAndStop(1);
							s.sm2.gotoAndStop(2);
							s.sm.visible = false;
							s.sm2.visible = false;
							s.rotation = 0;
							s.scaleX = 1;
							s.scaleY = 1;
							s.x = origpos["S" + n].x;
							s.y = origpos["S" + n].y;
							s.alpha = 1;
							s.sm.alpha = 1;
							s.sm2.alpha = 1;
							s.sm.transform.matrix = s.transform.matrix;
							s.sm2.transform.matrix = s.transform.matrix;
							s.visible = false;
							s.c = 0;
							s.cacheAsBitmap = false;
						}
					}
				}
				if (Boolean(captionsmc) && Boolean(captionsmc["C" + n]))
				{
					captionsmc["C" + n].visible = false;
				}
				n++;
			}
		}

		private static function InitWays():Object
		{
			var i:int = 0;
			var j:int = 0;
			var a2:MovieClip = null;
			var r:MovieClip = null;
			var b:MovieClip = null;
			var a:MovieClip = null;
			var ra:MovieClip = null;
			trace("InitWays");
			ways = {};
			ways[0] = {};
			i = 1;
			while (i <= areanum)
			{
				ways[i] = {};
				a2 = arrowsmc["A" + i];
				if (Boolean(a2) && Boolean(areamarkers[i]))
				{
					ways[0][i] = {"a": a2};
					ways[i][0] = {
							"a": a2,
							"o": true
						};
					a2.x = shieldsmc["S" + i].x + origpos["SHIELDS"].x - origpos["ARROWS"].x;
					a2.y = shieldsmc["S" + i].y + origpos["SHIELDS"].y - origpos["ARROWS"].y - 80 * Map.markerscale;
				}
				i++;
			}
			i = 1;
			while (i <= areanum)
			{
				j = 1;
				while (j <= areanum)
				{
					r = roadsmc["W_" + i + "_" + j];
					b = roadsbackmc["W_" + i + "_" + j];
					a = arrowsmc["N" + i + "_" + j];
					if (Boolean(a) || Boolean(r))
					{
						if (!ways[i][j])
						{
							ways[i][j] = {};
						}
						if (!ways[j][i])
						{
							ways[j][i] = {};
						}
					}
					if (Boolean(r) && Boolean(b))
					{
						ra = new MovieClip();
						roadsallmc.addChild(ra);
						ra.cacheAsBitmap = true;
						roadsallmc["W_" + i + "_" + j] = ra;
						ra.name = "W_" + i + "_" + j;
						ra.addChild(r);
						ra.addChild(b);
						ways[i][j].ra = ra;
						ways[j][i].ra = ra;
					}
					if (a)
					{
						ways[i][j].a = a;
						ways[j][i].a = a;
						ways[j][i].o = true;
					}
					if (r)
					{
						ways[i][j].r = r;
						ways[j][i].r = r;
						ways[i][j].b = b;
						ways[j][i].b = b;
					}
					j++;
				}
				i++;
			}
			Imitation.CollectChildrenAll(roadsallmc);
			return ways;
		}

		public static function CreateMapView(owner:MovieClip, areas:*):Object
		{
			var n:int = 0;
			var i:int = 0;
			var m:* = {
					"fills": [],
					"base": null,
					"type": "horizontal",
					"borders": null,
					"mc": null,
					"owner": owner
				};
			if (m.type == "horizontal")
			{
				owner.gotoAndStop(1);
			}
			else
			{
				owner.gotoAndStop(2);
			}
			n = 1;
			while (n <= 3)
			{
				// this was replaced
				m.fills[n] = new (currentmapswf.AREAS as Class)();
				n++;
			}
			m.base = new (currentmapswf.AREAS as Class)();
			m.borders = new (currentmapswf.AREAS as Class)();
			m.mc = new MovieClip();
			m.mc.addChild(m.base);
			m.mc.width = owner.width - 20;
			m.mc.scaleY = m.mc.scaleX;
			if (m.mc.height > owner.height - 20)
			{
				m.mc.height = owner.height - 20;
				m.mc.scaleX = m.mc.scaleY;
			}
			m.mc.x = owner.width / 2 - m.mc.width / 2 - m.base.getBounds(m.mc).left * m.mc.scaleX;
			m.mc.y = owner.height / 2 - m.mc.height / 2 - m.base.getBounds(m.mc).top * m.mc.scaleY;
			Util.SetColor(m.base, 15658734);
			owner.addChild(m.mc);
			m.mc.filters = owner.EFFECTS.filters;
			owner.EFFECTS.visible = false;
			var player_colors:Array = [0, 15859712, 3394560, 39423];
			n = 1;
			while (n <= 3)
			{
				Util.SetColor(m.fills[n], player_colors[n]);
				m.mc.addChild(m.fills[n]);
				n++;
			}
			i = 1;
			while (i <= areanum)
			{
				m.borders["A" + i].filters = owner.BORDEREFFECTS.filters;
				i++;
			}
			owner.BORDEREFFECTS.visible = false;
			m.mc.addChild(m.borders);
			Map.UpdateView(m, areas);
			return m;
		}

		public static function UpdateView(view:*, areas:*):void
		{
			var a:* = undefined;
			var pnum:int = 0;
			var b:* = false;
			var i:uint = 1;
			while (i <= Game.areanum)
			{
				a = areas[i];
				pnum = 1;
				while (pnum <= 3)
				{
					b = a.owner == pnum;
					view.fills[pnum]["A" + i].visible = b;
					pnum++;
				}
				i++;
			}
		}

		public static function FreeMapGfx():*
		{
			var n:int = 0;
			if (mapbitmapdata)
			{
				mapbitmapdata.dispose();
			}
			if (Boolean(mapbitmap) && Boolean(mapbitmap.parent))
			{
				mapbitmap.parent.removeChild(mapbitmap);
			}
			if (shadebitmapdata)
			{
				shadebitmapdata.dispose();
			}
			if (Boolean(shadebitmap) && Boolean(mapbitmap.parent))
			{
				shadebitmap.parent.removeChild(shadebitmap);
			}
			n = 1;
			while (n <= areanum)
			{
				while (areacolors[n].numChildren > 0)
				{
					areacolors[n].removeChildAt(0);
				}
				fills[n] = null;
				borders[n] = null;
				intborders[n] = null;
				while (disabledareas[n].numChildren > 0)
				{
					disabledareas[n].removeChildAt(0);
				}
				n++;
			}
		}

		public static function Clear():void
		{
			trace("Map.Clear()");
			Imitation.FreeBitmapAll(mc);
			FreeMapGfx();
			submc = new MovieClip();
			roadsallmc = new MovieClip();
			disabledlayer = new MovieClip();
			markerlayer = new MovieClip();
			maphelplayer = new MovieClip();
			currentmapswf = null;
			mapid = "";
		}

		public static function ClearShields():void
		{
			var i:uint = 0;
			if (shieldsmc)
			{
				i = 1;
				while (i <= Game.areanum)
				{
					if (Boolean(shieldsmc["S" + i]) && Boolean(shieldsmc["S" + i].sm) && shieldsmc.contains(shieldsmc["S" + i].sm))
					{
						shieldsmc.removeChild(shieldsmc["S" + i].sm);
						shieldsmc.removeChild(shieldsmc["S" + i].sm2);
						shieldsmc["S" + i].sm = null;
						shieldsmc["S" + i].sm2 = null;
					}
					i++;
				}
			}
		}

		public static function sqadd_AreaChanges(areas:Array):void
		{
			var ao:* = undefined;
			ao = Sys.gsqc.AddTweenObj("Prepare-masks");
			ao.areas = areas;
			ao.Start = function():*
			{
				var area:Object = null;
				Map.Combine(false);
				if (mapcombine)
				{
					Imitation.Combine(submc, false);
				}
				for each (area in this.areas)
				{
					if (area.oldcolor == 0)
					{
						areacolors[area.areanum].visible = false;
					}
				}
				this.Next();
			};
			ao = Sys.gsqc.AddTweenObj("AreaChanges-oldout");
			ao.areas = areas;
			ao.Start = function():*
			{
				var area:Object = null;
				var sscale:Number = NaN;
				var haswork:Boolean = false;
				for each (area in this.areas)
				{
					if (area.oldcolor > 0)
					{
						sscale = areafillscales[area.areanum];
						this.AddTweenMaxFromTo(Map.areacolors[area.areanum], 0.3, {"alpha": 1}, {
									"alpha": 0,
									"ease": fl.motion.easing.Linear.easeNone
								});
						haswork = true;
					}
				}
				if (!haswork)
				{
					this.Next();
				}
			};
			ao = Sys.gsqc.AddTweenObj("change colors");
			ao.areas = areas;
			ao.Start = function():*
			{
				var area:Object = null;
				Map.Update();
				Sounds.PlayEffect("select_base");
				for each (area in this.areas)
				{
					areacolors[area.areanum].alpha = 0;
					Imitation.UpdateToDisplay(areacolors[area.areanum]);
				}
				this.Next();
			};
			Sys.gsqc.AddDelay(0.01);
			ao = Sys.gsqc.AddTweenObj("new colors in");
			ao.areas = areas;
			ao.Start = function():*
			{
				var area:Object = null;
				var msc:Number = NaN;
				var haswork:Boolean = false;
				for each (area in this.areas)
				{
					if (area.newcolor > 0)
					{
						msc = areafillscales[area.areanum];
						this.AddTweenMaxFromTo(Map.areacolors[area.areanum], 0.3, {"alpha": 0}, {
									"alpha": 1,
									"ease": fl.motion.easing.Linear.easeNone
								});
						haswork = true;
					}
				}
				if (!haswork)
				{
					this.Next();
				}
			};
			ao = Sys.gsqc.AddTweenObj("kill-masks");
			ao.areas = areas;
			ao.Start = function():*
			{
				if (mapcombine)
				{
					Imitation.Combine(submc, true);
				}
				this.Next();
			};
		}

		public static function sqadd_MapChanges():void
		{
			if (!loaded)
			{
				return;
			}
			Combine(false);
			var acarr:Array = [];
			var n:int = 1;
			while (n <= areanum)
			{
				if (prevowners[n] != Game.areas[n].owner)
				{
					acarr.push({
								"areanum": n,
								"oldcolor": prevowners[n],
								"newcolor": Game.areas[n].owner
							});
					prevowners[n] = Game.areas[n].owner;
				}
				n++;
			}
			if (acarr.length > 0)
			{
				sqadd_AreaChanges(acarr);
			}
		}

		public static function UpdateMapBitmap():*
		{
			var gfx:DisplayObject = null;
			trace("UpdateMapBitmap...");
			if (mapbitmapdata)
			{
				mapbitmapdata.dispose();
			}
			if (Boolean(mapbitmap) && Boolean(mapbitmap.parent))
			{
				mapbitmap.parent.removeChild(mapbitmap);
			}
			if (shadebitmapdata)
			{
				shadebitmapdata.dispose();
			}
			if (Boolean(shadebitmap) && Boolean(shadebitmap.parent))
			{
				shadebitmap.parent.removeChild(shadebitmap);
			}
			var stw:Number = Imitation.stage.stageWidth;
			var sth:Number = Imitation.stage.stageHeight;
			var mat:Matrix = new Matrix(mapscale, 0, 0, mapscale, mapshiftx, mapshifty);
			if (Config.inbrowser)
			{
				gfx = currentmapswf.getChildByName("MAPGFX");
				mapbitmapdata = new BitmapData(stw, sth, true, 0);
				mapbitmapdata.drawWithQuality(gfx, mat, null, null, null, true, StageQuality.BEST);
				mapbitmap = new Bitmap(mapbitmapdata, "auto", true);
				mapbitmap.name = "mapbitmap";
			}
			else
			{
				mapbitmapdata = new BitmapData(stw, sth, true, 0);
				mapbitmapdata.draw(currentmapswf.getChildByName("MAPGFX"), mat, null, null, null, true);
				mapbitmap = new Bitmap(mapbitmapdata, "auto", false);
				mapbitmap.name = "mapbitmap";
			}
			shadebitmapdata = new BitmapData(stw, sth, true, 0);
			shadebitmapdata.copyPixels(mapbitmapdata, new Rectangle(0, 0, stw, sth), new Point(0, 0));
			shadebitmapdata.draw(currentmapswf.getChildByName("SELECTSHADE"), mat, null, null, null, true);
			shadebitmap = new Bitmap(shadebitmapdata, "auto", false);
			shadebitmap.name = "shadebitmap";
			var zid:int = 0;
			var zid2:int = 0;
			submc.addChildAt(mapbitmap, zid2++);
			submc.addChildAt(shadebitmap, zid2++);
			submc.addChildAt(colorlayers, zid2++);
			submc.addChildAt(disabledlayer, zid2++);
			if (roadsmc)
			{
				submc.addChildAt(roadsallmc, zid2++);
			}
			mc.addChildAt(submc, zid++);
			if (captionsmc)
			{
				mc.addChildAt(captionsmc, zid++);
			}
			mc.addChildAt(markerlayer, zid++);
			if (shieldsmc)
			{
				mc.addChildAt(shieldsmc, zid++);
			}
			if (arrowsmc)
			{
				mc.addChildAt(arrowsmc, zid++);
			}
			if (overlaycaptionsmc)
			{
				Main.mc.addChild(overlaycaptionsmc);
			}
			Imitation.FreeBitmapAll(mapbitmap);
			Imitation.FreeBitmapAll(shadebitmap);
			Imitation.FreeBitmapAll(colorlayers);
			Imitation.FreeBitmapAll(submc);
			if (Map.combined)
			{
				Imitation.Combine(Map.mc, true);
			}
		}

		public static function MapAnim(shuffle:Boolean):*
		{
			var lucky_1:int;
			var lucky_2:int;
			var i:*;
			var m:MovieClip = null;
			var d:* = undefined;
			var d2:* = undefined;
			var m2:MovieClip = null;
			if (!bg_anim)
			{
				return;
			}
			lucky_1 = int(Math.random() * bg_anim.numChildren);
			lucky_2 = int(Math.random() * bg_anim.numChildren);
			i = 0;
			while (i < bg_anim.numChildren)
			{
				m = MovieClip(bg_anim.getChildAt(i) as MovieClip);
				if (m)
				{
					if (shuffle)
					{
						m.visible = i == lucky_1 || i == lucky_2;
					}
					d = int(Math.random() * 15);
					d2 = int(Math.random() * 10);
					m2 = m;
					while (m2.name != "OBJ")
					{
						m2 = m2.getChildAt(0) as MovieClip;
					}
					if (m2.parent.numChildren == 2)
					{
						Imitation.SetMaskedMov(m2.parent.getChildAt(1), m2);
					}
					if (!TweenMax.isTweening(m))
					{
						TweenMax.fromTo(m, d, {"alpha": 0}, {
									"alpha": 1,
									"onComplete": function(m:*, m2:*):*
									{
										TweenMax.fromTo(m, m.totalFrames / 60, {"frame": 1}, {
													"frame": m.totalFrames,
													"ease": fl.motion.easing.Linear.easeNone,
													"repeat": -1,
													"repeatDelay": Math.random() * 10
												});
										m2 = m;
										while (m2.name != "OBJ")
										{
											m2 = m2.getChildAt(0) as MovieClip;
										}
										TweenMax.fromTo(m2, m2.totalFrames / 60, {"frame": 1}, {
													"frame": m2.totalFrames,
													"ease": fl.motion.easing.Linear.easeNone,
													"repeat": -1,
													"repeatDelay": d2
												});
										if (m2.WHALE)
										{
											TweenMax.fromTo(m2.WHALE, m2.totalFrames / 60, {"frame": 1}, {
														"frame": m2.totalFrames,
														"ease": fl.motion.easing.Linear.easeNone,
														"repeat": -1,
														"repeatDelay": d2
													});
										}
									},
									"onCompleteParams": [m, m2]
								});
					}
				}
				i++;
			}
		}

		public static function StopAnim():*
		{
			if (bg_anim)
			{
				TweenMax.to(bg_anim, 0.3, {"alpha": 0});
			}
		}

		public static function AlignMap():*
		{
			var n:int = 0;
			var mm:MovieClip = null;
			var om:MovieClip = null;
			var mh:MapHelpMarkerMov = null;
			var way:* = undefined;
			var stw:Number = Imitation.stage.stageWidth;
			var sth:Number = Imitation.stage.stageHeight;
			if (!currentmapswf)
			{
				return;
			}
			var boundsmc:MovieClip = MovieClip(currentmapswf.getChildByName("MINBOUNDS"));
			clockplacemc = MovieClip(currentmapswf.getChildByName("CLOCKPLACE"));
			pdplacemc = MovieClip(currentmapswf.getChildByName("PDPLACE"));
			var screendpi:int = Capabilities.screenDPI;
			if (screendpi <= 72)
			{
				screendpi = 90;
			}
			var boundsmc2:MovieClip = MovieClip(currentmapswf.getChildByName("MINBOUNDS2"));
			if (Boolean(boundsmc2) && sth / screendpi > 3.5)
			{
				boundsmc = boundsmc2;
				clockplacemc = MovieClip(currentmapswf.getChildByName("CLOCKPLACE2"));
				pdplacemc = MovieClip(currentmapswf.getChildByName("PDPLACE2"));
			}
			var boxheight:Number = 80 * Game.boxscale;
			var boxwidth:Number = 200 * Game.boxscale;
			var boxgap:Number = 4 * Game.boxscale;
			var mbwidth:Number = boundsmc.width;
			var mbheight:Number = boundsmc.height;
			cleanx = 0;
			cleany = boxheight + 2 * boxgap;
			cleanwidth = stw - cleanx;
			cleanheight = sth - cleany;
			var hcleanwidth:Number = cleanwidth;
			var hcleanheight:Number = cleanheight;
			var vcleanx:Number = boxwidth + 2 * boxgap;
			var vcleanwidth:Number = stw - vcleanx;
			var vcleanheight:Number = sth - 0;
			var hmapscale:Number = cleanwidth / mbwidth;
			if (cleanheight / mbheight < hmapscale)
			{
				hmapscale = cleanheight / mbheight;
			}
			var vmapscale:Number = vcleanwidth / mbwidth;
			if (vcleanheight / mbheight < vmapscale)
			{
				vmapscale = vcleanheight / mbheight;
			}
			if (vmapscale > hmapscale)
			{
				verticallayout = true;
				if (!Config.mobile && 0.9 < vmapscale)
				{
					mapscale = 0.9;
					cleanwidth = 0.9 / vmapscale * vcleanwidth;
					cleanheight = 0.9 / vmapscale * vcleanheight;
					cleanx = vcleanx - (cleanwidth - vcleanwidth) / 2;
					cleany = 0 - (cleanheight - vcleanheight) / 2;
				}
				else
				{
					verticallayout = true;
					mapscale = vmapscale;
					cleanwidth = vcleanwidth;
					cleanheight = vcleanheight;
					cleanx = vcleanx;
					cleany = 0;
				}
			}
			else
			{
				verticallayout = false;
				if (!Config.mobile && 0.9 < hmapscale)
				{
					mapscale = 0.9;
					cleanwidth = 0.9 / hmapscale * cleanwidth;
					cleanheight = 0.9 / hmapscale * cleanheight;
					cleanx -= (cleanwidth - hcleanwidth) / 2;
					cleany -= (cleanheight - hcleanheight) / 2;
				}
				else
				{
					mapscale = hmapscale;
				}
			}
			var mbx:Number = cleanx + cleanwidth / 2 - mbwidth * mapscale / 2;
			var mby:Number = cleany + cleanheight / 2 - mbheight * mapscale / 2;
			mapshiftx = mbx - boundsmc.x * mapscale;
			mapshifty = mby - boundsmc.y * mapscale;
			colorlayers.scaleX = mapscale;
			colorlayers.scaleY = mapscale;
			colorlayers.x = mapshiftx + currentmapswf.AREAS.x * mapscale;
			colorlayers.y = mapshifty + currentmapswf.AREAS.y * mapscale;
			disabledlayer.scaleX = colorlayers.scaleX;
			disabledlayer.scaleY = colorlayers.scaleY;
			disabledlayer.x = colorlayers.x;
			disabledlayer.y = colorlayers.y;
			if (bg_anim)
			{
				bg_anim.scaleX = bg_anim.scaleY = mapscale;
				bg_anim.x = mapshiftx;
				bg_anim.y = mapshifty;
				Imitation.CollectChildrenAll(bg_anim);
				MapAnim(false);
			}
			if (arrowsmc)
			{
				arrowsmc.scaleX = mapscale;
				arrowsmc.scaleY = mapscale;
				arrowsmc.x = mapshiftx + origpos["ARROWS"].x * mapscale;
				arrowsmc.y = mapshifty + origpos["ARROWS"].y * mapscale;
			}
			if (Boolean(roadsmc) && Boolean(origpos["ROADS"]))
			{
				roadsallmc.scaleX = mapscale;
				roadsallmc.scaleY = mapscale;
				roadsallmc.x = mapshiftx + origpos["ROADS"].x * mapscale;
				roadsallmc.y = mapshifty + origpos["ROADS"].y * mapscale;
			}
			if (captionsmc)
			{
				captionsmc.scaleX = mapscale;
				captionsmc.scaleY = mapscale;
				captionsmc.x = mapshiftx + origpos["CAPTIONS"].x * mapscale;
				captionsmc.y = mapshifty + origpos["CAPTIONS"].y * mapscale;
				overlaycaptionsmc.x = captionsmc.x;
				overlaycaptionsmc.y = captionsmc.y;
				overlaycaptionsmc.scaleX = captionsmc.scaleX;
				overlaycaptionsmc.scaleY = captionsmc.scaleY;
			}
			if (shieldsmc)
			{
				shieldsmc.scaleX = mapscale;
				shieldsmc.scaleY = mapscale;
				shieldsmc.x = mapshiftx + origpos["SHIELDS"].x * mapscale;
				shieldsmc.y = mapshifty + origpos["SHIELDS"].y * mapscale;
			}
			var origmarkerscale:Number = Number(currentmapswf["MARKER1"].scaleX);
			markerscale = origmarkerscale * mapscale;
			if (markerscale > 1.8)
			{
				markerscale = 1.8;
			}
			n = 1;
			while (n <= areanum)
			{
				mm = areamarkers[n];
				om = currentmapswf["MARKER" + n];
				if (om)
				{
					mm.scaleX = markerscale;
					mm.scaleY = markerscale;
					mm.x = mapshiftx + om.x * mapscale;
					mm.y = mapshifty + om.y * mapscale;
					mh = maphelpmarkers[n];
					mh.scaleX = markerscale;
					mh.scaleY = markerscale;
					mh.x = mm.x + 27 * markerscale;
					mh.y = mm.y + 17 * markerscale;
					ScaleEffects("FILLS", fills[n], mapscale * fills[n].scaleX);
					ScaleEffects("BORDERS", borders[n], mapscale * fills[n].scaleX);
					ScaleEffects("INTBORDERS", intborders[n], mapscale * fills[n].scaleX);
					if (Boolean(mm.SOLDIER) && Boolean(mm.SOLDIER.SKIN))
					{
						ScaleEffects("SOLDIER.SKIN", mm.SOLDIER.SKIN, markerscale);
					}
					if (mm.CASTLE)
					{
						ScaleEffects("CASTLE", mm.CASTLE, markerscale);
					}
					if (Boolean(captionsmc) && Boolean(captionsmc["C" + n]))
					{
						ScaleEffects("CAPTIONS", captionsmc["C" + n], mapscale * fills[n].scaleX);
					}
					if (roadsmc)
					{
						for each (way in ways[n])
						{
							if (way.b)
							{
								way.b.filters = effectsmc["ROADS"].filters;
								ScaleEffects("ROADS", way.b, mapscale * fills[n].scaleX);
							}
						}
					}
					mm.InitDefaultPos();
				}
				n++;
			}
			ShowAvailableAreas(selection_enabled);
			AlignPhaseDisplay();
			AlignClock();
			UpdateMapBitmap();
			shadebitmap.visible = false;
			mapbitmap.visible = true;
			var srmov:MovieClip = Main.mc.SELECTRING;
			if (srmov.visible)
			{
				PrepareSelectRing();
			}
			if (selectedarea)
			{
				if (srmov.visible)
				{
					srmov.x = areamarkers[selectedarea].x;
					srmov.y = areamarkers[selectedarea].y;
					srmov.alpha = 1;
				}
			}
		}

		public static function AlignClock():void
		{
			if (!clockplacemc)
			{
				return;
			}
			var cmcb:Rectangle = clockplacemc.getBounds(clockplacemc.parent);
			var clockmc:MovieClip = Main.mc.MAPCLOCK;
			clockmc.width = cmcb.width * mapscale;
			clockmc.scaleY = clockmc.scaleX;
			clockmc.x = mapshiftx + (cmcb.left + cmcb.width / 2) * mapscale;
			clockmc.y = mapshifty + (cmcb.top + cmcb.height / 2) * mapscale;
		}

		public static function AlignPhaseDisplay():*
		{
			if (!pdplacemc)
			{
				return;
			}
			var tw:int = pdplacemc.width * mapscale;
			var tx:int = mapshiftx + pdplacemc.x * mapscale;
			var ty:int = mapshifty + pdplacemc.y * mapscale;
			if (Math.abs(PhaseDisplay.mc.width - tw) > 3)
			{
				PhaseDisplay.mc.width = tw;
				PhaseDisplay.mc.scaleY = PhaseDisplay.mc.scaleX;
			}
			if (Math.abs(PhaseDisplay.mc.x - tx) > 3)
			{
				PhaseDisplay.mc.x = tx;
			}
			if (Math.abs(PhaseDisplay.mc.y - ty) > 3)
			{
				PhaseDisplay.mc.y = ty;
			}
		}

		public static function Combine(acombine:Boolean, callback:Function = null):*
		{
			var OnComplete:Function = null;
			OnComplete = function():*
			{
				Imitation.Combine(Map.mc, true);
				if (Boolean(callback))
				{
					callback();
				}
			};
			if (combined == acombine)
			{
				if (Boolean(callback))
				{
					callback();
				}
				return;
			}
			combined = acombine;
			if (acombine)
			{
				if (bg_anim)
				{
					TweenMax.to(bg_anim, 0.3, {
								"alpha": 0,
								"onComplete": OnComplete
							});
				}
				else
				{
					OnComplete();
				}
			}
			else
			{
				Imitation.Combine(Map.mc, false);
			}
		}

		public static function Update():*
		{
			StopAreaSelection();
			UpdateLayers();
			MoveAreaMarkersDefPos();
		}

		public static function UpdateLayers():*
		{
			var a:Object = null;
			var waschange:Boolean = false;
			if (!currentmapswf)
			{
				return;
			}
			var i:int = 1;
			while (i <= areanum)
			{
				a = Game.areas[i];
				fills[i].filters = effectsmc["FILL0"].filters;
				borders[i].filters = effectsmc["BORDER0"].filters;
				intborders[i].filters = effectsmc["INTBORDER0"].filters;
				areacolors[i].scaleX = 1;
				areacolors[i].scaleY = 1;
				ScaleEffects("FILLS", fills[i], mapscale * fills[i].scaleX);
				ScaleEffects("BORDERS", borders[i], mapscale * fills[i].scaleX);
				ScaleEffects("INTBORDERS", intborders[i], mapscale * fills[i].scaleX);
				if (a.owner > 0)
				{
					areacolors[i].visible = true;
					if (prevcolors[i] != a.owner)
					{
						waschange = true;
						var test:ColorTransform = effectsmc["INTBORDER" + a.owner].transform.colorTransform;
						trace("color: ", test.color);
						trace("colorTransform:", effectsmc["INTBORDER" + a.owner].transform.colorTransform);
						trace("FIXME: overwriting color for area:", i);
						var ovcolor:* = new ColorTransform();
						if (a.owner == 1)
						{
							ovcolor.color = 14224139;
						}
						else if (a.owner == 2)
						{
							ovcolor.color = 3122696;
						}
						else if (a.owner == 3)
						{
							ovcolor.color = 1802433;
						}
						if (ovcolor.color != 0)
						{
							trace("over");
							effectsmc["INTBORDER" + a.owner].transform.colorTransform = ovcolor;
						}
						trace("area id:", i);
						trace("owner: ", a.owner);
						Imitation.SetColorMultiplier(areacolors[i], effectsmc["INTBORDER" + a.owner].transform.colorTransform);
					}
				}
				else
				{
					areacolors[i].visible = false;
				}
				if (prevcolors[i] != a.owner || areamarkers[i].visible && a.owner == 0)
				{
					UpdateAreaMarker(i);
				}
				prevcolors[i] = a.owner;
				prevowners[i] = a.owner;
				i++;
			}
		}

		public static function UpdateAreaMarker(n:int):*
		{
			var a:Object = Game.areas[n];
			var m:AreaMarkerMov = areamarkers[n];
			if (a.owner == 0)
			{
				m.Setup(0, 0, 0);
				m.visible = false;
				m.FORTRESS.visible = false;
				m.FORTRESSBACK.visible = false;
			}
			else
			{
				m.visible = true;
				if (Boolean(shieldsmc) && Boolean(shieldsmc["S" + n]))
				{
					shieldsmc["S" + n].sm2.visible = false;
				}
				if (a.base)
				{
					m.Setup(a.owner, a.value, a.towers);
				}
				else
				{
					m.Setup(a.owner, a.value, 0);
				}
				m.FORTRESS.visible = a.fortress;
				m.FORTRESSBACK.visible = a.fortress;
				if (m.SOLDIER)
				{
					ScaleEffects("SOLDIER.SKIN", m.SOLDIER.SKIN, markerscale);
				}
				if (m.CASTLE)
				{
					ScaleEffects("CASTLE", m.CASTLE, markerscale);
				}
			}
			Imitation.FreeBitmapAll(m);
			Imitation.UpdateAll(m);
		}

		public static function ShowMapHelps():*
		{
			var area:Object = null;
			var h:MapHelpMarkerMov = null;
			trace("ShowMapHelps");
			if (Game.state != 4)
			{
				return;
			}
			if (Sys.tag_cmd == null || Sys.tag_cmd.MAPHELPS === undefined)
			{
				return;
			}
			var mhdata:Object = Util.ParseJsVar(Sys.tag_cmd.MAPHELPS);
			var i:int = 1;
			while (i <= areanum)
			{
				area = Game.areas[i];
				h = maphelpmarkers[i];
				h.Hide();
				if (area.owner == Game.iam)
				{
					if (mhdata.FORTRESS >= 0)
					{
						h.Show("FORTRESS", mhdata.FORTRESS);
					}
				}
				else if (Game.availableareasmask & 1 << i - 1)
				{
					if (mhdata.SUBJECT >= 0)
					{
						h.Show("SUBJECT", mhdata.SUBJECT);
					}
				}
				else if (mhdata.AIRBORNE >= 0)
				{
					h.Show("AIRBORNE", mhdata.AIRBORNE);
				}
				i++;
			}
			Imitation.CollectChildrenAll(Map.mc);
			Imitation.UpdateAll(Map.mc);
		}

		public static function HideMapHelps():*
		{
			var n:int = 1;
			while (n <= areanum)
			{
				maphelpmarkers[n].Hide();
				n++;
			}
			Main.mc.MHSUBJECTS.visible = false;
		}

		public static function ShowAvailableAreas(ashow:Boolean):void
		{
			var n:int = 0;
			var av:* = false;
			var v:Boolean = false;
			var s:* = undefined;
			var oldgrayed:Boolean = false;
			trace("ShowAvailableAreas: " + ashow);
			var waschange:Boolean = false;
			n = 1;
			while (n <= areanum)
			{
				av = (Game.availableareasmask & 1 << n - 1) != 0;
				if (Game.nextplayer == Game.iam)
				{
					v = ashow && !av;
				}
				else
				{
					v = ashow;
				}
				if (v != disabledareas[n].visible)
				{
					waschange = true;
				}
				disabledareas[n].visible = v;
				v = ashow && av;
				TweenMax.killTweensOf(areamarkers[n]);
				areamarkers[n].scaleX = markerscale;
				areamarkers[n].scaleY = markerscale;
				if (Game.iam == Game.nextplayer && v)
				{
					s = !!Game.areas[n].base ? 1.1 : 1.2;
				}
				if (Game.state == 4)
				{
					oldgrayed = areamarkers[n].grayed;
					if (ashow)
					{
						if (Game.areas[n].owner != Game.nextplayer)
						{
							areamarkers[n].alpha = 1;
							areamarkers[n].grayed = !av;
						}
						else
						{
							areamarkers[n].alpha = 1;
							areamarkers[n].grayed = false;
						}
					}
					else
					{
						areamarkers[n].alpha = 1;
						areamarkers[n].grayed = false;
					}
					if (oldgrayed != areamarkers[n].grayed)
					{
						UpdateAreaMarker(n);
					}
				}
				n++;
			}
		}

		public static function StartAreaSelection():void
		{
			var a:* = undefined;
			var mh:MapHelpMarkerMov = null;
			trace("Starting area selection...");
			IngameChat.Hide();
			Combine(false);
			selectedarea = 0;
			if (mapcombine)
			{
				Imitation.Combine(submc, false);
			}
			ShowAvailableAreas(true);
			ShowMapHelps();
			ShowWays(true, true);
			ShowMapShields();
			shadebitmap.visible = true;
			mapbitmap.visible = false;
			if (mapcombine)
			{
				Imitation.CollectChildrenAll(submc);
				Imitation.UpdateAll(submc);
				Imitation.Combine(submc, true);
			}
			if (Boolean(bg_anim) && !TweenMax.isTweening(bg_anim))
			{
				MapAnim(bg_anim.alpha == 0);
				TweenMax.to(bg_anim, 0.3, {"alpha": 0.5});
			}
			var n:int = 1;
			while (n <= areanum)
			{
				a = (Game.availableareasmask & 1 << n - 1) != 0;
				mh = maphelpmarkers[n];
				if (a && Game.nextplayer == Game.iam)
				{
					Imitation.AddEventClick(areamarkers[n], Map.OnMapMouseDown);
				}
				else
				{
					Imitation.RemoveEvents(areamarkers[n]);
				}
				if (mh.active && !a)
				{
					areamarkers[n].ShowTargetAnim(false);
					Imitation.CollectChildrenAll(areamarkers[n]);
					Imitation.FreeBitmapAll(areamarkers[n]);
					Imitation.UpdateAll(areamarkers[n]);
				}
				n++;
			}
			var clockmc:MovieClip = Main.mc.MAPCLOCK;
			var t1:int = int(getTimer());
			clockmc.visible = true;
			clockmc.gotoAndStop(1);
			Main.mc.MAPCLOCK.BG1 = Util.SwapSkin(Main.mc.MAPCLOCK.BG1, "skin_triviador", "SelectAreaBg");
			Main.mc.MAPCLOCK.STRIP = Util.SwapSkin(Main.mc.MAPCLOCK.STRIP, "skin_triviador", "SelectAreaBar");
			Util.SwapTextcolor(Main.mc.MAPCLOCK.CAPTION, "selectAreaCaptionColor", "skin_triviador");
			Imitation.CollectChildrenAll(clockmc);
			clockmc.STRIP.scaleX = 1;
			Imitation.GotoFrame(clockmc.STRIP, Game.nextplayer);
			Lang.Set(clockmc.CAPTION, "do_select");
			clockmc.CAPTION.scaleX = 1;
			var tw:Number = clockmc.CAPTION.textWidth + 8;
			if (tw > 350)
			{
				clockmc.CAPTION.width = tw;
				clockmc.CAPTION.scaleX = 350 / tw;
			}
			clockmc.CAPTION.x = -clockmc.CAPTION.width / 2;
			Imitation.UpdateAll(clockmc);
			clockmc.visible = false;
			if (useselectring)
			{
				PrepareSelectRing();
			}
			var targetscale:Number = clockmc.scaleX;
			TweenMax.fromTo(clockmc, 0.5, {
						"visible": true,
						"alpha": 0,
						"scaleX": 0,
						"scaleY": 0
					}, {
						"alpha": 1,
						"scaleX": targetscale,
						"scaleY": targetscale,
						"ease": fl.motion.easing.Bounce.easeOut
					});
			TweenMax.fromTo(clockmc.STRIP, Game.clocktimeout, {"scaleX": 1}, {
						"scaleX": 0,
						"ease": fl.motion.easing.Linear.easeNone,
						"onComplete": OnSelectClockTimeout
					});
			if (!Sounds.IsPlaying("answer_tiktak"))
			{
				Sounds.PlayEffect("answer_tiktak");
			}
			Imitation.AddEventMouseDown(mc, OnMapMouseDown);
			selection_enabled = true;
			AreaSelectionStep();
		}

		private static function AreaSelectionStep():void
		{
			var area:int = 0;
			var anim:AreaMarkerMov = Main.mc.ATTACKANIM;
			var avail:Array = Game.DecodeAvailable(Game.availableareasmask);
			if (animstep > avail.length)
			{
				animstep = -5;
			}
			if (animstep < 0)
			{
				++animstep;
			}
			else
			{
				area = int(avail[animstep]);
				if (AnimArrowTo(area))
				{
					++animstep;
				}
			}
			TweenMax.to(anim, 0.1, {
						"delay": 0.1,
						"onComplete": AreaSelectionStep
					});
		}

		public static function StopAreaSelection():void
		{
			if (!currentmapswf)
			{
				return;
			}
			var anim:AreaMarkerMov = Main.mc.ATTACKANIM;
			TweenMax.killTweensOf(anim);
			TweenMax.killChildTweensOf(anim);
			var clockmc:MovieClip = Main.mc.MAPCLOCK;
			autoselectstarttime = 0;
			if (clockmc.WAIT)
			{
				TweenMax.killTweensOf(clockmc.WAIT);
			}
			TweenMax.killTweensOf(clockmc.STRIP);
			TweenMax.killTweensOf(clockmc);
			if (Sounds.IsPlaying("answer_tiktak"))
			{
				Sounds.StopEffect("answer_tiktak");
			}
			if (clockmc.visible)
			{
				TweenMax.fromTo(clockmc, 0.2, {"alpha": 1}, {
							"visible": false,
							"alpha": 0
						});
			}
			var n:int = 1;
			while (n <= areanum)
			{
				areamarkers[n].HideTargetAnim(Game.state == 2);
				Imitation.RemoveEvents(areamarkers[n]);
				n++;
			}
			if (mapcombine)
			{
				Imitation.Combine(Map.submc, false);
			}
			ShowAvailableAreas(false);
			HideAllWays(false);
			HideMapShields();
			HideMapHelps();
			shadebitmap.visible = false;
			mapbitmap.visible = true;
			if (mapcombine)
			{
				Imitation.CollectChildrenAll(Map.submc);
				Imitation.UpdateAll(Map.submc);
				Imitation.Combine(Map.submc, true);
			}
			selection_enabled = false;
			HideSelectRing();
			if (PhaseDisplay.mc.INFO)
			{
				TweenMax.to(PhaseDisplay.mc.INFO, 0.3, {
							"alpha": 0,
							"y": -150
						});
			}
		}

		public static function OnSelectClockTimeout():void
		{
			var asarea:int = selectedarea;
			StopAreaSelection();
			if (Game.state != 4)
			{
				StopAnim();
			}
			Comm.SendCommand("SELECT", "AREA=\"" + asarea + "\"");
		}

		public static function OnMapMouseDown(e:*):*
		{
			var n:int = 0;
			var amm:AreaMarkerMov = null;
			var distance:Number = NaN;
			var available:* = false;
			if (IngameChat.mc != null && IngameChat.mc.visible)
			{
				if (IngameChat.mc.hitTestPoint(e.stageX, e.stageY))
				{
					return;
				}
			}
			trace("Map mouse down: " + e.stageX + ", " + e.stageY);
			if (!selection_enabled && Game.nextplayer && Game.nextplayer != Game.iam && !MCQuestionMov.mc.visible && !GuessQuestionMov.mc.visible && !IngameChat.mc.visible)
			{
				if (PhaseDisplay.mc.INFO)
				{
					TweenMax.to(PhaseDisplay.mc.INFO, 0.3, {
								"alpha": 1,
								"y": -270
							});
					TweenMax.to(PhaseDisplay.mc.INFO, 0.3, {
								"alpha": 0,
								"y": -150,
								"delay": 4
							});
				}
				Main.mc.setChildIndex(PhaseDisplay.mc, Main.mc.numChildren - 1);
				return;
			}
			if (!selection_enabled)
			{
				return;
			}
			var area:int = 0;
			var mindistance:Number = 1000000;
			n = 1;
			while (n <= areanum)
			{
				available = (Game.availableareasmask & 1 << n - 1) != 0;
				if (available || maphelpmarkers[n].active)
				{
					amm = areamarkers[n];
					distance = Math.sqrt((amm.x - e.stageX) * (amm.x - e.stageX) + (amm.y - e.stageY) * (amm.y - e.stageY));
					if (distance < mindistance)
					{
						area = n;
						mindistance = distance;
					}
				}
				n++;
			}
			if (mindistance > 100 * markerscale)
			{
				if (Main.mc.SELECTRING.visible)
				{
					HideSelectRing();
					if (Map.mapcombine)
					{
						Imitation.Combine(submc, false);
					}
					ShowWays(Game.nextplayer == Game.iam, true);
					if (Map.mapcombine)
					{
						Imitation.Combine(submc, true);
					}
				}
				return;
			}
			if (Main.mc.SELECTRING.visible || useselectring || maphelpmarkers[area].active)
			{
				if (!Main.mc.SELECTRING.visible || !selectedarea)
				{
					ShowSelectRing(area);
					ShowSelectedWay(area);
					return;
				}
				amm = areamarkers[selectedarea];
				distance = Math.sqrt((amm.x - e.stageX) * (amm.x - e.stageX) + (amm.y - e.stageY) * (amm.y - e.stageY));
				if (distance > markerscale * 55 || area != selectedarea)
				{
					HideSelectRing();
					ShowWays(Game.nextplayer == Game.iam, true);
					if (distance < markerscale * 100)
					{
						return;
					}
					ShowSelectRing(area);
					ShowSelectedWay(area);
					return;
				}
			}
			SelectArea(area);
		}

		public static function SelectArea(area:int, towerbuild:Boolean = false):void
		{
			if (maphelpmarkers[area].active && maphelpmarkers[area].helptype != "SUBJECT" && !towerbuild)
			{
				StopAreaSelection();
				Comm.SendCommand("SELECTMH", "AREA=\"" + area + "\" TYPE=\"" + (maphelpmarkers[area].helptype == "FORTRESS" ? 3 : 1) + "\"");
				return;
			}
			StopAreaSelection();
			Comm.SendCommand("SELECT", "AREA=\"" + area + "\"");
		}

		public static function HideSelectRing():void
		{
			var p:MovieClip = null;
			while (autoselectparts.length > 0)
			{
				p = autoselectparts.shift();
				p.parent.removeChild(p);
			}
			Util.RemoveEventListener(Main.mc.SELECTRING, Event.ENTER_FRAME, OnAutoSelectFrame);
			Main.mc.SELECTRING.visible = false;
			HideMHSubjects();
			Imitation.RemoveEvents(Main.mc.SELECTRING);
			if (Boolean(captionsmc) && Boolean(captionsmc["C" + selectedarea]))
			{
				captionsmc.addChild(captionsmc["C" + selectedarea]);
			}
			selectedarea = 0;
			AlignMapCaptions();
		}

		public static function ShowOpponentSelectRing(area:int):void
		{
			var amm:AreaMarkerMov;
			var w:MovieClip = null;
			var ringmov:MovieClip = null;
			var ringscaleto:Number = NaN;
			var ringscalefrom:Number = NaN;
			trace("ShowOpponentSelectRing", area);
			if (area < 1)
			{
				HideSelectRing();
				return;
			}
			selectedarea = area;
			if (captionsmc)
			{
				AlignMapCaptions();
				if (captionsmc["C" + area])
				{
					overlaycaptionsmc.addChild(captionsmc["C" + area]);
				}
			}
			selectedarea = 0;
			amm = areamarkers[area];
			w = Main.mc.SELECTRING;
			Util.StopAllChildrenMov(w.SELECTOR);
			w.x = amm.x;
			w.y = amm.y;
			w.visible = true;
			w.PASSIVERING.visible = true;
			w.RING.visible = false;
			w.BG.visible = false;
			w.SELECTOR.visible = false;
			ringmov = w.PASSIVERING;
			ringscaleto = 0.7;
			ringscalefrom = 0.6;
			TweenMax.killTweensOf(ringmov);
			TweenMax.killTweensOf(w.AUTOSELECT);
			w.AUTOSELECT.MASTER.visible = false;
			if (autoselectstarttime == 0)
			{
				autoselectstarttime = getTimer();
			}
			Util.AddEventListener(w, Event.ENTER_FRAME, OnAutoSelectFrame);
			Imitation.UpdateToDisplay(w, true);
			TweenMax.delayedCall(0, function():*
				{
					TweenMax.fromTo(ringmov, 0.2, {
								"scaleX": ringscalefrom,
								"scaleY": ringscalefrom,
								"alpha": 0
							}, {
								"scaleX": ringscaleto,
								"scaleY": ringscaleto,
								"alpha": 1,
								"ease": Regular.easeOut
							});
					TweenMax.fromTo(w.AUTOSELECT, 0.2, {
								"scaleX": ringscalefrom / 0.7,
								"scaleY": ringscalefrom / 0.7,
								"alpha": 0
							}, {
								"scaleX": ringscaleto / 0.7,
								"scaleY": ringscaleto / 0.7,
								"alpha": 1,
								"ease": Regular.easeOut
							});
					TweenMax.to(ringmov, 0.2, {
								"scaleX": ringscalefrom,
								"scaleY": ringscalefrom,
								"alpha": 0,
								"ease": Regular.easeIn,
								"delay": 0.8
							});
					TweenMax.to(w.AUTOSELECT, 0.2, {
								"scaleX": ringscalefrom / 0.7,
								"scaleY": ringscalefrom / 0.7,
								"alpha": 0,
								"ease": Regular.easeIn,
								"delay": 0.8
							});
				});
		}

		public static function ShowSelectRing(area:int):void
		{
			var amm:AreaMarkerMov;
			var w:MovieClip;
			var mh:MapHelpMarkerMov;
			var bb:MovieClip;
			var ub:MovieClip;
			var mhs_x:Number;
			var mhs_y:Number;
			var mhs_scale:Number;
			var OnTowerBuildClick:Function;
			var ringmov:MovieClip = null;
			var avaibletowerbuilding:Boolean = false;
			var tbb:MovieClip = null;
			var ringscaleto:Number = NaN;
			var ringscalefrom:Number = NaN;
			var mhs:MovieClip = null;
			var selector:MovieClip = null;
			trace("ShowSelectRing");
			if (area < 1)
			{
				HideSelectRing();
				return;
			}
			Sounds.PlayEffect("Click");
			selectedarea = area;
			if (captionsmc)
			{
				AlignMapCaptions();
				if (captionsmc["C" + area])
				{
					overlaycaptionsmc.addChild(captionsmc["C" + area]);
				}
			}
			amm = areamarkers[selectedarea];
			w = Main.mc.SELECTRING;
			Util.StopAllChildrenMov(w.SELECTOR);
			w.x = amm.x;
			w.y = amm.y;
			w.visible = true;
			w.PASSIVERING.visible = false;
			w.RING.visible = true;
			ringmov = w.RING;
			if (w.y < w.SELECTOR.height / 2 + 10 || !Map.verticallayout && Standings.mc.BOX1 && w.y - w.PASSIVERING.height * markerscale / 2 < Util.NumberVal(Standings.boxpositiony[1]) + Standings.mc.BOX1.height * Game.boxscale)
			{
				selector = w.SELECTOR.BOTTOM;
				w.SELECTOR.BOTTOM.visible = true;
				w.SELECTOR.TOP.visible = !w.SELECTOR.BOTTOM.visible;
			}
			else
			{
				selector = w.SELECTOR.TOP;
				w.SELECTOR.TOP.visible = true;
				w.SELECTOR.BOTTOM.visible = !w.SELECTOR.TOP.visible;
			}
			mh = maphelpmarkers[area];
			avaibletowerbuilding = Game.rules == 0 && mh.helptype == "FORTRESS" && Game.players[Game.nextplayer].base == area && Game.players[Game.nextplayer].base == Game.players[Game.iam].base && Boolean(Map.areamarkers[area]) && Map.areamarkers[area].towers < 3;
			Imitation.GotoFrame(selector, avaibletowerbuilding && mh.active ? 3 : 1);
			Imitation.FreeBitmapAll(selector);
			Imitation.UpdateAll(selector);
			bb = selector.BOOSTERBOX;
			ub = selector.USERBOX;
			tbb = selector.TOWERBUILDBOX;
			if (mh.active)
			{
				if (mh.helptype == "SUBJECT")
				{
					bb = Main.mc.MHSUBJECTS.BOOSTERBOX;
					selector.BOOSTERBOX.visible = false;
					ShowMHSubjects();
				}
				else
				{
					Main.mc.MHSUBJECTS.visible = false;
					w.RING.visible = false;
					w.PASSIVERING.visible = true;
					ringmov = w.PASSIVERING;
					Imitation.AddEventMouseDown(bb, OnBoosterBoxClick, {"area": area});
					Imitation.AddEventClick(bb, OnBoosterBoxClick, {"area": area});
				}
				tbb.visible = avaibletowerbuilding;
				bb.visible = true;
				bb.alpha = 1;
				if (mh.helpprice == 0)
				{
					bb.gotoAndStop(2);
					bb.STOCK.text = Sys.mydata.freehelps[Config.helpindexes[mh.helptype]];
				}
				else
				{
					bb.gotoAndStop(1);
					bb.PRICE.text = mh.helpprice;
				}
				Imitation.GotoFrame(bb.ICON, mh.helptype);
			}
			else if (avaibletowerbuilding)
			{
				w.RING.visible = false;
				w.PASSIVERING.visible = true;
				ringmov = w.PASSIVERING;
				bb.visible = false;
				tbb.visible = true;
			}
			else
			{
				bb.visible = false;
				w.PASSIVERING.visible = false;
			}
			if (ub)
			{
				if (Game.state == 4)
				{
					ub.visible = !(bb == selector.BOOSTERBOX && bb.visible) && Game.areas[area].owner != Game.iam;
					Imitation.AddEventClick(ub, function(e:*):*
						{
							if (IngameChat.mc != null && IngameChat.mc.visible)
							{
								if (IngameChat.mc.hitTestPoint(e.stageX, e.stageY))
								{
									return;
								}
							}
							Map.SelectArea(area, true);
						});
					ub.AVATAR.ShowUID(Game.players[Game.areas[area].owner].id);
					ub.VALUEMOV.gotoAndStop(Game.areas[area].owner);
					ub.VALUEMOV.VALUE.text = Game.areas[area].value;
					Imitation.CollectChildrenAll(ub.VALUEMOV);
					Imitation.FreeBitmapAll(ub.VALUEMOV);
					Imitation.UpdateAll(ub.VALUEMOV);
				}
				else
				{
					ub.visible = false;
				}
			}
			ringscaleto = 0.7;
			ringscalefrom = 1.4;
			w.BG.alpha = 0.5;
			ringmov.alpha = 0;
			selector.BOOSTERBOX.alpha = 0;
			if (avaibletowerbuilding)
			{
				OnTowerBuildClick = function(e:Object):void
				{
					if (IngameChat.mc != null && IngameChat.mc.visible)
					{
						if (IngameChat.mc.hitTestPoint(e.stageX, e.stageY))
						{
							return;
						}
					}
					Map.SelectArea(area, true);
				};
				tbb.alpha = 0;
				Imitation.AddEventMouseDown(tbb, OnTowerBuildClick);
				Imitation.AddEventClick(tbb, OnTowerBuildClick);
			}
			mhs = Main.mc.MHSUBJECTS;
			Imitation.UpdateAll(w);
			Imitation.UpdateAll(mhs);
			ringmov.scaleX = ringscalefrom;
			ringmov.scaleY = ringscalefrom;
			mhs_x = mhs.x;
			mhs_y = mhs.y;
			mhs_scale = mhs.scaleX;
			if (mhs.visible)
			{
				mhs.alpha = 0;
			}
			TweenMax.killTweensOf(ringmov);
			TweenMax.killTweensOf(w.AUTOSELECT);
			w.AUTOSELECT.alpha = 1;
			w.AUTOSELECT.scaleY = 1;
			w.AUTOSELECT.scaleX = 1;
			w.AUTOSELECT.MASTER.visible = false;
			autoselectstarttime = getTimer();
			Util.AddEventListener(w, Event.ENTER_FRAME, OnAutoSelectFrame);
			Imitation.UpdateToDisplay(w, true);
			TweenMax.delayedCall(0, function():*
				{
					TweenMax.fromTo(ringmov, 0.2, {
								"scaleX": ringscalefrom,
								"scaleY": ringscalefrom,
								"alpha": 0
							}, {
								"scaleX": ringscaleto,
								"scaleY": ringscaleto,
								"alpha": 1,
								"ease": fl.motion.easing.Back.easeOut
							});
					if (selector.BOOSTERBOX.visible)
					{
						TweenMax.fromTo(selector.BOOSTERBOX, 0.2, {"alpha": 0}, {"alpha": 1});
					}
					if (avaibletowerbuilding)
					{
						TweenMax.fromTo(tbb, 0.2, {"alpha": 0}, {"alpha": 1});
					}
					if (mhs.visible)
					{
						TweenMax.to(mhs, 0.4, {
									"alpha": 1,
									"ease": fl.motion.easing.Cubic.easeIn
								});
					}
				});
		}

		public static function OnAutoSelectFrame(e:*):void
		{
			var p:MovieClip = null;
			var atm:int = Game.state == 4 ? autoattacktime : autoselecttime;
			var w:MovieClip = Main.mc.SELECTRING;
			var mh:MapHelpMarkerMov = maphelpmarkers[Map.selectedarea];
			var avaibletowerbuilding:Boolean = Game.rules == 0 && mh && mh.helptype == "FORTRESS" && Game.players[Game.nextplayer].base == Map.selectedarea && Game.players[Game.nextplayer].base == Game.players[Game.iam].base && Boolean(Map.areamarkers[Map.selectedarea]) && Map.areamarkers[Map.selectedarea].towers < 3;
			if (!w.visible)
			{
				Util.RemoveEventListener(w, Event.ENTER_FRAME, OnAutoSelectFrame);
				return;
			}
			var elapsed:int = getTimer() - autoselectstarttime;
			var arclen:Number = 360 * (elapsed / atm);
			if (arclen > 360)
			{
				arclen = 360;
			}
			if (Game.iam != Game.nextplayer)
			{
				arclen = 360;
			}
			var requiredparts:* = Math.floor(arclen / 6);
			Imitation.GotoFrame(w.AUTOSELECT.MASTER, Game.nextplayer);
			while (autoselectparts.length < requiredparts)
			{
				p = Imitation.CreateClone(w.AUTOSELECT.MASTER, w.AUTOSELECT);
				p.rotation = autoselectparts.length * 6;
				Imitation.GotoFrame(p, Game.nextplayer);
				autoselectparts.push(p);
			}
			if (elapsed >= atm && selection_enabled)
			{
				SelectArea(Map.selectedarea, avaibletowerbuilding);
			}
		}

		public static function ShowMHSubjects():void
		{
			var sbtn:MovieClip = null;
			var w:MovieClip = Main.mc.MHSUBJECTS;
			w.scaleX = markerscale;
			w.scaleY = markerscale;
			w.alpha = 1;
			Imitation.AddButtonStop(w);
			var sx:Number = Main.mc.SELECTRING.x;
			var sy:Number = Main.mc.SELECTRING.y;
			if (sx > Imitation.stage.stageWidth / 2)
			{
				w.x = sx - 240 * markerscale;
			}
			else
			{
				w.x = sx + 240 * markerscale;
			}
			w.y = sy;
			var wr:Number = w.height / 2;
			if (w.y - wr < 10)
			{
				w.y = 10 + wr;
			}
			if (w.y + wr > Imitation.stage.stageHeight - 10)
			{
				w.y = Imitation.stage.stageHeight - 10 - wr;
			}
			var n:int = 1;
			while (n <= 10)
			{
				sbtn = w["SUBJECT" + n];
				sbtn.alpha = 1;
				sbtn.scaleX = 1;
				sbtn.scaleY = 1;
				Imitation.AddEventMouseDown(sbtn, OnMHSubjectSelected, {
							"area": selectedarea,
							"subject": n
						});
				n++;
			}
			w.visible = true;
		}

		public static function MoveAreaMarkersDefPos():void
		{
			var i:int = 0;
			while (i < Map.areamarkers.length)
			{
				if (Map.areamarkers[i])
				{
					Map.areamarkers[i].MoveDefaultPos();
				}
				i++;
			}
		}

		public static function OnMHSubjectSelected(e:*):void
		{
			var w:MovieClip;
			var ao:* = undefined;
			StopAreaSelection();
			Main.mc.SELECTRING.visible = true;
			w = Main.mc.MHSUBJECTS;
			w.visible = true;
			ao = Sys.gsqc.AddTweenObj("mhsubject.hightlight.1");
			ao.Start = function():*
			{
				var sbtn:MovieClip = null;
				var n:int = 1;
				while (n <= 10)
				{
					sbtn = Main.mc.MHSUBJECTS["SUBJECT" + n];
					if (e.params.subject == n)
					{
						this.AddTweenMaxFromTo(sbtn, 0.15, {
									"scaleX": 1,
									"scaleY": 1
								}, {
									"scaleX": 1.4,
									"scaleY": 1.4,
									"yoyo": true,
									"repeat": 4
								});
					}
					else
					{
						this.AddTweenMaxFromTo(sbtn, 0.3, {"alpha": 1}, {"alpha": 0});
					}
					n++;
				}
			};
			ao = Sys.gsqc.AddObj("mhsubject.sendcommand");
			ao.Start = function():*
			{
				Sounds.PlayEffect("subject_using");
				Comm.SendCommand("SELECTMH", "AREA=\"" + e.params.area + "\" TYPE=\"2\" CATID=\"" + e.params.subject + "\"");
				this.Next();
			};
			if (!Sys.gsqc.running)
			{
				Sys.gsqc.Start();
			}
		}

		public static function OnBoosterBoxClick(e:*):void
		{
			StopAreaSelection();
			var ht:int = maphelpmarkers[e.params.area].helptype == "FORTRESS" ? 3 : 1;
			if (ht == 3)
			{
				Sounds.PlayEffect("fortress_using");
			}
			if (ht == 1)
			{
				Sounds.PlayEffect("airborne_using");
			}
			Comm.SendCommand("SELECTMH", "AREA=\"" + e.params.area + "\" TYPE=\"" + ht + "\"");
		}

		public static function HideMHSubjects():void
		{
			Main.mc.MHSUBJECTS.visible = false;
			Imitation.RemoveEvents(Main.mc.MHSUBJECTS);
		}

		public static function PrepareSelectRing():void
		{
			var sbtn:MovieClip = null;
			var srmov:MovieClip = Main.mc.SELECTRING;
			Util.StopAllChildrenMov(srmov.SELECTOR);
			srmov.scaleX = markerscale;
			srmov.scaleY = markerscale;
			if (srmov.RING)
			{
				srmov.RING.visible = true;
			}
			if (srmov.PASSIVERING)
			{
				srmov.PASSIVERING.visible = true;
			}
			if (srmov.SELECTOR.TOP.TOWERBUILDBOX)
			{
				srmov.SELECTOR.TOP.TOWERBUILDBOX.visible = false;
			}
			if (srmov.SELECTOR.BOTTOM.TOWERBUILDBOX)
			{
				srmov.SELECTOR.BOTTOM.TOWERBUILDBOX.visible = false;
			}
			var bg:MovieClip = srmov.BG;
			var hfs:Number = (Imitation.stage.stageWidth / markerscale - 150) / 100;
			var vfs:Number = (Imitation.stage.stageHeight / markerscale - 150) / 100;
			var hfs2:Number = hfs + 300 / 100;
			var vfs2:Number = vfs + 300 / 100;
			bg.LEFT.scaleX = vfs2;
			bg.LEFT.scaleY = hfs;
			bg.RIGHT.scaleX = vfs2;
			bg.RIGHT.scaleY = hfs;
			bg.TOP.scaleX = hfs2;
			bg.TOP.scaleY = vfs;
			bg.BOTTOM.scaleX = hfs2;
			bg.BOTTOM.scaleY = vfs;
			bg.alpha = 0.5;
			var wasv:Boolean = srmov.visible;
			srmov.visible = true;
			Imitation.UpdateAll(srmov);
			srmov.visible = wasv;
			Imitation.UpdateToDisplay(srmov);
			var mhs:MovieClip = Main.mc.MHSUBJECTS;
			mhs.scaleX = markerscale;
			mhs.scaleY = markerscale;
			var n:int = 1;
			while (n <= 10)
			{
				sbtn = mhs["SUBJECT" + n];
				sbtn.alpha = 1;
				sbtn.scaleX = 1;
				sbtn.scaleY = 1;
				Imitation.GotoFrame(sbtn.ICON, n);
				n++;
			}
			var instock:int = int(Sys.mydata.freehelps[Config.helpindexes["SUBJECT"]]);
			if (instock > 0)
			{
				mhs.BOOSTERBOX.gotoAndStop(2);
				mhs.BOOSTERBOX.STOCK.text = instock;
			}
			else
			{
				mhs.BOOSTERBOX.gotoAndStop(1);
			}
			wasv = mhs.visible;
			mhs.visible = true;
			Imitation.UpdateAll(mhs);
			mhs.visible = wasv;
			Imitation.UpdateToDisplay(mhs);
		}

		public static function SelectMap(amapid:String):*
		{
			var mi:MovieClip = null;
			var modulename:String = null;
			trace("SelectMap: " + amapid);
			if (mapid == amapid)
			{
				return;
			}
			mi = loadedmaps[amapid];
			if (MovieClip(mi) === null)
			{
				modulename = "map_" + amapid.toLowerCase();
				mi = Modules.GetModuleMC(modulename);
			}
			if (Boolean(Config.external_map) && Config.external_map != "")
			{
				MyLoader.LoadBitmap(Config.external_map, function(bitmap:*):*
					{
						mi["MAPGFX"] = SwapMapBitmap(mi["MAPGFX"], bitmap);
						SetCurrentMap(amapid, mi);
					});
			}
			else
			{
				SetCurrentMap(amapid, mi);
			}
		}

		private static function SetCurrentMap(amapid:String, aswf:MovieClip):void
		{
			trace("SetCurrentMap: " + amapid);
			isloading = false;
			loaded = true;
			if (loadedmaps[amapid] != aswf)
			{
				loadedmaps[amapid] = aswf;
			}
			mapid = amapid;
			InitLoadedMap(aswf);
		}

		private static function SelectWDLabels():void
		{
			var mapgfx:MovieClip = null;
			if (Map.mapid == "WD")
			{
				mapgfx = MovieClip(Map.currentmapswf.getChildByName("MAPGFX"));
				mapgfx.LABELS_XE.visible = Config.siteid == "xe";
				mapgfx.LABELS_XS.visible = Config.siteid == "xs";
				mapgfx.LABELS_XA.visible = Config.siteid == "xa";
				if (!mapgfx.LABELS_XE.visible && !mapgfx.LABELS_XS.visible && !mapgfx.LABELS_XA.visible)
				{
					mapgfx.LABELS_XE.visible = true;
				}
			}
		}

		public static function GetFreeAreaNumber():int
		{
			var a:Object = null;
			var freeareacounter:uint = 0;
			var n:uint = 1;
			while (n <= Game.areanum)
			{
				a = Game.areas[n];
				if (Boolean(a) && a.owner == 0)
				{
					freeareacounter++;
				}
				n++;
			}
			return freeareacounter;
		}
	}
}
