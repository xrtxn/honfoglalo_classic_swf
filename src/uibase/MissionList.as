package uibase
{
	import flash.display.MovieClip;
	import flash.utils.*;
	import syscode.*;
	import uibase.gfx.MissionListItem_5_5x8_5;

	public class MissionList extends MovieClip
	{
		public var LISTITEMS:MovieClip;

		public var MASK:MovieClip;

		public var SBAR:ScrollBarMov7;

		private var Building:Object;

		private var Map:Object;

		public var started:Boolean = false;

		public function MissionList()
		{
			super();
		}

		public function Start():*
		{
			if (this.started)
			{
				return;
			}
			this.LISTITEMS.oy = this.LISTITEMS.y;
			this.MASK.visible = false;
			this.Map = Modules.GetClass("triviador", "triviador.Map");
			this.Building = Modules.GetClass("uibase", "uibase.Building");
			this.Building.LoadGFX(this.OnAssetsLoaded);
			this.started = true;
		}

		public function OnAssetsLoaded(e:* = null):void
		{
			this.DrawList();
			Imitation.CollectChildrenAll(parent);
		}

		public function DrawList():void
		{
			var actItem:MovieClip = null;
			var o:Object = null;
			var bname:String = null;
			var blevel:int = 0;
			var i:int = 0;
			var spl:Array = null;
			var id_status:String = null;
			var ida:Array = null;
			var id:String = null;
			var status:String = null;
			var boo_num:Array = null;
			var booster:String = null;
			var booster_number:int = 0;
			var count:int = 0;
			var yoffset:Number = 5;
			if (Sys.mydata.tutorialmission != undefined && Sys.mydata.tutorialmission != "")
			{
				spl = Sys.mydata.tutorialmission.split(";");
				id_status = spl[0].split("TUTORIALMISSION:").join("");
				ida = id_status.split(",");
				id = ida[0];
				status = ida[1];
				boo_num = spl[1].split("=");
				booster = boo_num[0];
				booster_number = int(boo_num[1]);
				o = new Object();
				o.type = id;
				o.label = Lang.Get("tmission_" + id.toLowerCase() + "_task_1");
				if (status == "START" || status == "RUNNING")
				{
					o.num1 = 0;
				}
				if (status == "END")
				{
					o.num1 = 1;
				}
				o.num2 = 1;
				o.chest = "L1";
				if (status == "RUNNING" || status == "END")
				{
					actItem = new MissionListItem_5_5x8_5();
					this.LISTITEMS.addChild(actItem);
					actItem.y = actItem.height * count + yoffset * count;
					count++;
					this.SetupIconType(actItem, o);
				}
			}
			if (Sys.mydata.shieldmission !== undefined && Sys.mydata.shieldmission != 16777215 && this.popcount(Sys.mydata.shieldmission) < this.Map.areanum)
			{
				bname = "SHIELD";
				o = new Object();
				o.label = Lang.Get("shield_mission_desc");
				o.type = "CLAN";
				o.num1 = this.popcount(Sys.mydata.shieldmission);
				o.num2 = this.Map.areanum;
				o.chest = "L2";
				actItem = new MissionListItem_5_5x8_5();
				this.LISTITEMS.addChild(actItem);
				actItem.y = actItem.height * count + yoffset * count;
				count++;
				this.SetupIconType(actItem, o);
			}
			if (Sys.mydata.gamecount < 10)
			{
				bname = "EXT";
				o = new Object();
				o.label = Lang.Get("badge_task_ext");
				o.type = bname;
				blevel = 0;
				o.level = 0;
				o.num1 = Sys.mydata.gamecount;
				o.num2 = 10;
				actItem = new MissionListItem_5_5x8_5();
				this.LISTITEMS.addChild(actItem);
				actItem.y = actItem.height * count + yoffset * count;
				count++;
				this.SetupBadgeType(actItem, o);
			}
			if (Sys.mydata.xpt != undefined)
			{
				bname = "XPT";
				o = new Object();
				o.label = Lang.Get("badge_task_xpt");
				o.type = bname;
				blevel = 0;
				for (i = 0; i < Config.badgelevellimits.XPT.length; i++)
				{
					if (Sys.mydata.xpt >= Config.badgelevellimits.XPT[i])
					{
						blevel++;
					}
				}
				o.level = blevel;
				o.num1 = Sys.mydata.xpt;
				if (blevel >= Config.badgelevellimits.XPT.length)
				{
					o.num2 = Config.badgelevellimits.XPT[Config.badgelevellimits.XPT.length - 1];
				}
				else
				{
					o.num2 = Config.badgelevellimits.XPT[blevel];
				}
				o.rlresetremaining = Util.NumberVal(Sys.rlresetremaining);
				o.rlresettimeref = getTimer();
				actItem = new MissionListItem_5_5x8_5();
				this.LISTITEMS.addChild(actItem);
				actItem.y = actItem.height * count + yoffset * count;
				count++;
				this.SetupBadgeType(actItem, o);
			}
			if (Sys.mydata.twd != undefined)
			{
				bname = "TWD";
				o = new Object();
				o.label = Lang.Get("badge_task_twd");
				o.type = bname;
				blevel = 0;
				for (i = 0; i < Config.badgelevellimits.TWD.length; i++)
				{
					if (Sys.mydata.twd >= Config.badgelevellimits.TWD[i])
					{
						blevel++;
					}
				}
				o.level = blevel;
				o.num1 = Sys.mydata.twd;
				if (blevel >= Config.badgelevellimits.TWD.length)
				{
					o.num2 = Config.badgelevellimits.TWD[Config.badgelevellimits.TWD.length - 1];
				}
				else
				{
					o.num2 = Config.badgelevellimits.TWD[blevel];
				}
				o.rlresetremaining = Util.NumberVal(Sys.rlresetremaining);
				o.rlresettimeref = getTimer();
				actItem = new MissionListItem_5_5x8_5();
				this.LISTITEMS.addChild(actItem);
				actItem.y = actItem.height * count + yoffset * count;
				count++;
				this.SetupBadgeType(actItem, o);
			}
			if (Sys.mydata.xpm != undefined)
			{
				bname = "XPM";
				o = new Object();
				o.label = Lang.Get("badge_task_xpm");
				o.type = bname;
				blevel = 0;
				for (i = 0; i < Config.badgelevellimits.XPM.length; i++)
				{
					if (Sys.mydata.xpm >= Config.badgelevellimits.XPM[i])
					{
						blevel++;
					}
				}
				o.level = blevel;
				o.num1 = Sys.mydata.xpm;
				if (blevel >= Config.badgelevellimits.XPM.length)
				{
					o.num2 = Config.badgelevellimits.XPM[Config.badgelevellimits.XPM.length - 1];
				}
				else
				{
					o.num2 = Config.badgelevellimits.XPM[blevel];
				}
				o.rlresetremaining = Util.NumberVal(Sys.rlresetremaining);
				o.rlresettimeref = getTimer();
				actItem = new MissionListItem_5_5x8_5();
				this.LISTITEMS.addChild(actItem);
				actItem.y = actItem.height * count + yoffset * count;
				count++;
				this.SetupBadgeType(actItem, o);
			}
			if (Sys.mydata.cw1 != undefined)
			{
				bname = "CW1";
				o = new Object();
				o.label = Lang.Get("badge_task_cw1");
				o.type = bname;
				blevel = 0;
				for (i = 0; i < Config.badgelevellimits.CW1.length; i++)
				{
					if (Sys.mydata.cw1 >= Config.badgelevellimits.CW1[i])
					{
						blevel++;
					}
				}
				o.level = blevel;
				o.num1 = Sys.mydata.cw1;
				if (blevel >= Config.badgelevellimits.CW1.length)
				{
					o.num2 = Config.badgelevellimits.CW1[Config.badgelevellimits.CW1.length - 1];
				}
				else
				{
					o.num2 = Config.badgelevellimits.CW1[blevel];
				}
				actItem = new MissionListItem_5_5x8_5();
				this.LISTITEMS.addChild(actItem);
				actItem.y = actItem.height * count + yoffset * count;
				count++;
				this.SetupBadgeType(actItem, o);
			}
			if (Sys.mydata.cw2 != undefined)
			{
				bname = "CW2";
				o = new Object();
				o.label = Lang.Get("badge_task_cw2");
				o.type = bname;
				blevel = 0;
				for (i = 0; i < Config.badgelevellimits.CW2.length; i++)
				{
					if (Sys.mydata.cw1 >= Config.badgelevellimits.CW2[i])
					{
						blevel++;
					}
				}
				o.level = blevel;
				o.num1 = Sys.mydata.cw2;
				if (blevel >= Config.badgelevellimits.CW2.length)
				{
					o.num2 = Config.badgelevellimits.CW2[Config.badgelevellimits.CW2.length - 1];
				}
				else
				{
					o.num2 = Config.badgelevellimits.CW2[blevel];
				}
				actItem = new MissionListItem_5_5x8_5();
				this.LISTITEMS.addChild(actItem);
				actItem.y = actItem.height * count + yoffset * count;
				count++;
				this.SetupBadgeType(actItem, o);
			}
			Imitation.CollectChildrenAll(this.LISTITEMS);
			this.SetScrollBar();
		}

		private function SetScrollBar():void
		{
			this.MASK.visible = true;
			Imitation.CollectChildrenAll(this);
			Imitation.SetMaskedMov(this.MASK, this.LISTITEMS, false, true);
			Imitation.AddEventMask(this.MASK, this.LISTITEMS);
			this.SBAR.Set(this.LISTITEMS.height + 2, this.MASK.height, 0);
			this.SBAR.SetScrollRect(this.MASK);
			this.SBAR.OnScroll = this.OnScroll;
			this.SBAR.UpdateLayout();
			this.SBAR.UpdateThumb();
		}

		private function OnScroll(_n:Number):void
		{
			this.LISTITEMS.y = this.LISTITEMS.oy + -_n;
			Imitation.CollectChildrenAll(parent);
		}

		private function SetupBadgeType(_actItem:MovieClip, _data:Object):void
		{
			Util.StopAllChildrenMov(_actItem);
			var statuemc1:* = new this.Building("StatueBadge");
			var statuemc2:* = new this.Building("StatueBadge");
			_actItem.addChild(statuemc1);
			_actItem.addChild(statuemc2);
			statuemc1.scaleX = statuemc1.scaleY = 0.6;
			statuemc2.scaleX = statuemc2.scaleY = 0.6;
			statuemc1.x = _actItem.ICON1.x + 25;
			statuemc1.y = _actItem.ICON1.y + 42;
			statuemc2.x = _actItem.ICON2.x + 25;
			statuemc2.y = _actItem.ICON2.y + 42;
			statuemc1.SetLevel(1);
			statuemc2.SetLevel(1);
			statuemc1.BUILDINGGRAPH.gotoAndStop(_data.type);
			statuemc1.BUILDINGGRAPH.LEVEL.gotoAndStop(_data.level);
			if (_data.level == 0)
			{
				statuemc1.SetLevel(0);
			}
			statuemc2.BUILDINGGRAPH.gotoAndStop(_data.type);
			var icon2level:int = _data.level + 1;
			if (_data.level >= 7)
			{
				icon2level = 7;
			}
			statuemc2.BUILDINGGRAPH.LEVEL.gotoAndStop(icon2level);
			_actItem.ICON1.visible = false;
			_actItem.ICON2.visible = false;
			Util.SetText(_actItem.LABEL.FIELD, _data.label);
			Util.SetText(_actItem.BAR.FIELD.FIELD, _data.num1 + "/" + _data.num2);
			var p:Number = _data.num1 / _data.num2;
			if (p > 1)
			{
				p = 1;
			}
			if (p < 0)
			{
				p = 0;
			}
			_actItem.BAR.STRIP.scaleX = p;
			_actItem.ILABEL1.FIELD.text = "Lvl " + Util.NumberVal(_data.level);
			var nextlvl:Number = Util.NumberVal(Util.NumberVal(_data.level) + 1);
			if (nextlvl > 7)
			{
				nextlvl = 7;
			}
			_actItem.ILABEL2.FIELD.text = "Lvl " + nextlvl;
			_actItem.CHESTS.visible = false;
			_actItem.TIMER_SMALL.visible = false;
			if (Boolean(_data.rlresetremaining) && Boolean(_data.rlresettimeref))
			{
				_actItem.TIMER_SMALL.visible = true;
				_actItem.TIMER_SMALL.rlresetremaining = Util.NumberVal(Sys.rlresetremaining);
				_actItem.TIMER_SMALL.rlresettimeref = getTimer();
				_actItem.TIMER_SMALL.Start();
			}
		}

		private function SetupIconType(_actItem:MovieClip, _data:Object):void
		{
			_actItem.ICON1.gotoAndStop(_data.type);
			_actItem.ICON2.gotoAndStop(_data.type);
			Util.SetText(_actItem.LABEL.FIELD, _data.label);
			Util.SetText(_actItem.BAR.FIELD.FIELD, _data.num1 + "/" + _data.num2);
			var p:Number = _data.num1 / _data.num2;
			if (p > 1)
			{
				p = 1;
			}
			if (p < 0)
			{
				p = 0;
			}
			_actItem.BAR.STRIP.scaleX = p;
			_actItem.ILABEL1.visible = false;
			_actItem.ILABEL2.visible = false;
			if (_data.chest)
			{
				_actItem.ICON2.visible = false;
				_actItem.CHESTS.gotoAndStop(_data.chest);
			}
			_actItem.TIMER_SMALL.visible = false;
			if (Boolean(_data.rlresetremaining) && Boolean(_data.rlresettimeref))
			{
				_actItem.TIMER_SMALL.visible = true;
				_actItem.TIMER_SMALL.rlresetremaining = Util.NumberVal(Sys.rlresetremaining);
				_actItem.TIMER_SMALL.rlresettimeref = getTimer();
				_actItem.TIMER_SMALL.Start();
			}
		}

		private function popcount(i:int):*
		{
			i -= i >>> 1 & 0x55555555;
			i = (i & 0x33333333) + (i >>> 2 & 0x33333333);
			return (i + (i >>> 4) & 0x0F0F0F0F) * 16843009 >>> 24;
		}

		public function Destroy():void
		{
			var li:MovieClip = null;
			for (var i:int = 0; i < this.LISTITEMS.numChildren; i++)
			{
				li = MovieClip(this.LISTITEMS.getChildAt(i));
				if (li)
				{
					li.TIMER_SMALL.Destroy();
				}
			}
		}
	}
}
