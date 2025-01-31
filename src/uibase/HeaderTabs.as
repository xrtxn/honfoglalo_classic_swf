package uibase
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import flash.display.MovieClip;
	import syscode.*;

	public class HeaderTabs extends MovieClip
	{
		public var current:int = 1;

		public var callback:Function = null;

		public var titles:Array;

		public var icons:Array;

		private var xoffset:Number = 104;

		public var active:Boolean = true;

		public var animating:Boolean = false;

		private var origpositions:Array;

		public function HeaderTabs()
		{
			this.titles = new Array();
			this.icons = new Array();
			this.origpositions = new Array();
			super();
		}

		public function Set(atitles:Array, aicons:Array, acallback:Function, selected:int = 0):void
		{
			var tab:MovieClip = null;
			this.titles = atitles;
			this.icons = aicons;
			this.callback = acallback;
			if (selected > 0)
			{
				this.current = selected;
			}
			var i:* = 1;
			while (tab = this.getChildByName("TTAB" + i) as MovieClip, tab)
			{
				tab.origx = tab.x;
				this.origpositions[i] = tab.x;
				tab.callbackid = i;
				tab.title = this.titles[i - 1];
				tab.position = i;
				tab.icon = this.icons[i - 1];
				tab.NOTIFY.stop();
				tab.NOTIFY.visible = false;
				tab.VALUEMC.visible = false;
				if (this.icons[i - 1])
				{
					tab.visible = true;
					tab.ICONSET.Set(this.icons[i - 1]);
					Imitation.AddEventClick(tab, this.TabClicked);
					Imitation.AddEventMouseOver(tab, this.TabOver);
					Imitation.AddEventMouseOut(tab, this.TabOut);
					this.CheckHelpEnabled(tab);
				}
				else
				{
					tab.visible = false;
				}
				if (Lang.Get(tab.title) == "(\"" + tab.title + "\")")
				{
					tab.visible = false;
				}
				i++;
			}
			this.SetActiveTab(this.getChildByName("TTAB" + this.current) as MovieClip);
		}

		public function Reorder(newOrder:Array = null, visibilities:Array = null):void
		{
			var i:int = 0;
			var tab:MovieClip = null;
			var settab:MovieClip = null;
			if (newOrder == null)
			{
				return;
			}
			for (i = 0; i < newOrder.length; i++)
			{
				tab = newOrder[i];
				tab.position = i + 1;
				tab.origx = this.origpositions[i + 1];
				tab.gotoAndStop("INACTIVE");
				TweenMax.killTweensOf(tab);
				if (tab.position == this.current)
				{
					settab = tab;
				}
				if (visibilities != null)
				{
					tab.visible = visibilities[i];
				}
				this.CheckHelpEnabled(tab);
			}
			this.SetActiveTab(settab);
		}

		public function TabClicked(e:*):void
		{
			if (!this.active)
			{
				return;
			}
			if (this.animating)
			{
				return;
			}
			var tab:* = MovieClip(e.target);
			this.SetActiveTab(tab);
			this.TabOver(e);
		}

		public function SetActiveTab(clickedmc:MovieClip):void
		{
			var tab:MovieClip = null;
			var self:HeaderTabs = null;
			this.animating = true;
			self = this;
			Sys.gsqc.AddCallBack2(function():*
				{
					var i:* = 1;
					while (tab = self.getChildByName("TTAB" + i) as MovieClip)
					{
						if (tab.visible)
						{
							if (tab.position < clickedmc.position)
							{
								if (tab.currentFrameLabel != "INACTIVE")
								{
									tab.gotoAndStop("TOINACTIVE");
									TweenMax.to(tab, 0.3, {"frameLabel": "INACTIVE"});
								}
								TweenMax.to(tab, 0.3, {"x": tab.origx});
							}
							if (tab == clickedmc)
							{
								if (tab.currentFrameLabel != "ACTIVE")
								{
									tab.gotoAndStop("TOACTIVE");
									TweenMax.to(tab, 0.3, {"frameLabel": "ACTIVE"});
								}
								Lang.Set(tab.FIELDMC.CAPTION, tab.title);
								if (tab.FIELDMC.CAPTION.numLines > 1)
								{
									tab.FIELDMC.CAPTION.y = -8;
								}
								Imitation.CollectChildrenAll(tab);
								Imitation.FreeBitmapAll(tab);
								TweenMax.to(tab, 0.3, {
											"x": tab.origx,
											"onComplete": function():*
											{
												TweenMax.delayedCall(0, function():*
													{
														animating = false;
													});
											}
										});
							}
							if (tab.position > clickedmc.position)
							{
								if (tab.currentFrameLabel != "INACTIVE")
								{
									tab.gotoAndStop("TOINACTIVE");
									TweenMax.to(tab, 0.3, {"frameLabel": "INACTIVE"});
								}
								TweenMax.to(tab, 0.3, {"x": tab.origx + xoffset});
							}
						}
						i++;
					}
				});
			Imitation.CollectChildrenAll(this);
			this.current = clickedmc.position;
			if (this.callback != null)
			{
				this.callback(clickedmc.callbackid);
			}
			if (!Sys.gsqc.running)
			{
				Sys.gsqc.Start();
			}
		}

		public function FreeTabBitmaps():void
		{
			var tab:MovieClip = null;
			var i:* = 1;
			while (tab = this.getChildByName("TTAB" + i) as MovieClip, tab)
			{
				Imitation.FreeBitmapAll(tab);
				i++;
			}
		}

		public function Freeze():void
		{
			var tab:MovieClip = null;
			var i:* = 1;
			while (tab = this.getChildByName("TTAB" + i) as MovieClip, tab)
			{
				Imitation.RemoveEvents(tab);
				i++;
			}
		}

		public function Unfreeze():void
		{
			var tab:MovieClip = null;
			var i:* = 1;
			while (tab = this.getChildByName("TTAB" + i) as MovieClip, tab)
			{
				Imitation.AddEventClick(tab, this.TabClicked);
				Imitation.AddEventMouseOver(tab, this.TabOver);
				Imitation.AddEventMouseOut(tab, this.TabOut);
				i++;
			}
		}

		public function Notify(tab:MovieClip, active:Boolean, text:String = "!"):void
		{
			tab.NOTIFY.visible = active;
			tab.NOTIFY.NOTIFYANIM.FIELD.text = text;
			if (active)
			{
				TweenMax.fromTo(tab.NOTIFY, 1, {"frame": 1}, {
							"frame": 29,
							"ease": Linear.easeNone,
							"repeat": -1
						});
			}
			else
			{
				TweenMax.killTweensOf(tab.NOTIFY);
			}
		}

		public function SetValue(tab:MovieClip, value:String):void
		{
			tab.VALUEMC.visible = true;
			tab.VALUEMC.VALUE.FIELD.text = value;
		}

		public function LockTab(tab:MovieClip):void
		{
			if (tab.locked)
			{
				return;
			}
			Imitation.RemoveEvents(tab);
			tab.ICONSET.Set("LOCK");
			tab.locked = true;
		}

		public function UnlockTab(tab:MovieClip):void
		{
			if (!tab.locked)
			{
				return;
			}
			tab.ICONSET.Set(tab.icon);
			Imitation.AddEventClick(tab, this.TabClicked);
			Imitation.AddEventMouseOver(tab, this.TabOver);
			Imitation.AddEventMouseOut(tab, this.TabOut);
			tab.locked = false;
		}

		private function CheckHelpEnabled(tab:MovieClip):void
		{
		}

		private function TabOver(e:*):void
		{
			if (!this.active)
			{
				return;
			}
			var tab:* = e.target;
			if (tab.currentFrame == 1)
			{
			}
		}

		private function TabOut(e:*):void
		{
			if (!this.active)
			{
				return;
			}
			var tab:* = e.target;
			if (!tab)
			{
				return;
			}
			if (tab.currentFrame == 1)
			{
			}
		}
	}
}
