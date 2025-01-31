package uibase
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getTimer;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol360")]
	public class Notifications extends MovieClip
	{
		private static var slidebar:MovieClip;

		private static var itemsmc:MovieClip;

		private static var sbmc:*;

		public static var mc:MovieClip = null;

		public static var items:Array = new Array();

		private static var itemHeight:Number = 77;

		private static var itemWidth:Number = 249;

		private static var itempadding:Number = 5;

		private static var itemoffset:Number = 2;

		private static var state:String = "IN";

		public static var waitforfirsttime:Boolean = true;

		public static var appScale:Number = 1;

		public function Notifications()
		{
			super();
		}

		public static function Init():void
		{
			mc = new MovieClip();
			Imitation.rootmc.addChild(mc);
			slidebar = new MovieClip();
			mc.addChild(slidebar);
			slidebar.name = "SLIDEBAR";
			CalculateAppScale();
			slidebar.scaleX = slidebar.scaleY = appScale;
			var opener:Class = Modules.GetClass("uibase", "uibase.NotificationsOpener");
			var openermc:* = new opener();
			openermc.name = "OPENER";
			slidebar.addChild(openermc);
			openermc.ICONSET.Set("X2");
			openermc.ALERT.visible = false;
			Imitation.AddEventClick(openermc.BG, ItemClick);
			Imitation.AddEventClick(openermc.HITAREA, ItemClick);
			var bg:Class = Modules.GetClass("uibase", "uibase.NotificationsBg");
			var bgmc:* = new bg();
			bgmc.name = "BG";
			slidebar.addChild(bgmc);
			Imitation.AddEventClick(bgmc, ItemClick);
			itemsmc = new MovieClip();
			slidebar.addChild(itemsmc);
			Aligner.SetAutoAlignFunc(mc, OnAlignFunc);
			Imitation.AddStageEventListener("WINDOWCHANGE", OnWindowChange);
			Imitation.AddStageEventListener(MouseEvent.CLICK, OnStageClick);
			Imitation.AddGlobalListener("FRIENDLISTCHANGE", OnFriendListChange);
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			Util.AddEventListener(Imitation.stage, TransformGestureEvent.GESTURE_SWIPE, OnSwipe);
			SetState("OUT", true);
			Hide();
		}

		public static function Reset():void
		{
			for (var i:int = 0; i < items.length; i++)
			{
				Imitation.RemoveEvents(items[i].mc);
				itemsmc.removeChild(items[i].mc);
			}
			items = new Array();
			OnAlignFunc();
		}

		public static function Add(_data:Object):Object
		{
			var itemmc:* = undefined;
			var item:Class = Modules.GetClass("uibase", "uibase.NotifitemWithText");
			var replacedobj:Object = GetItemByName(_data.name);
			var replacedobjindex:int = GetItemIndexByName(_data.name);
			if (_data.priority == undefined)
			{
				_data.priority = 100;
			}
			if (replacedobj != null)
			{
				itemmc = replacedobj.mc;
				if (replacedobjindex != -1)
				{
					items[replacedobjindex] = _data;
				}
			}
			else
			{
				_data.time = getTimer();
				if (state == "OUT")
				{
					items.unshift(_data);
				}
				else
				{
					items.push(_data);
				}
				itemmc = new item();
				itemmc.name = String("I" + items.length);
				itemsmc.addChild(itemmc);
			}
			Util.SetText(itemmc.FIELD.FIELD, _data.text);
			if (itemmc.FIELD.FIELD.numLines == 1)
			{
				itemmc.FIELD.FIELD.y = 27;
			}
			if (itemmc.FIELD.FIELD.numLines == 2)
			{
				itemmc.FIELD.FIELD.y = 20;
			}
			if (itemmc.FIELD.FIELD.numLines == 3)
			{
				itemmc.FIELD.FIELD.y = 10;
			}
			if (itemmc.FIELD.FIELD.numLines == 4)
			{
				itemmc.FIELD.FIELD.y = 0;
			}
			_data.mc = itemmc;
			itemmc.ICONSET.Set(_data.icon);
			itemmc.callback = _data.callback;
			if (_data.priority <= 50)
			{
				itemmc.ALERT.visible = true;
			}
			else
			{
				itemmc.ALERT.visible = false;
			}
			Imitation.AddEventClick(itemmc.HITAREA, ItemClick);
			if (state == "OUT")
			{
				items.sortOn(["priority", "time"], [Array.NUMERIC, Array.DESCENDING]);
			}
			AnimateAll(true);
			OnAlignFunc();
			Imitation.FreeBitmapAll(mc);
			Imitation.UpdateAll(mc);
			return items[length - 1];
		}

		public static function Remove(_data:Object):Boolean
		{
			for (var i:int = 0; i < items.length; i++)
			{
				if (items[i].name == _data.name || items[i].mc == _data.mc)
				{
					Imitation.RemoveEvents(items[i].mc);
					itemsmc.removeChild(items[i].mc);
					items.splice(i, 1);
					AnimateAll();
					OnAlignFunc();
					if (items.length <= 0)
					{
						Hide();
					}
					return true;
				}
			}
			return false;
		}

		private static function GetItemByName(_name:String):Object
		{
			for (var i:int = 0; i < items.length; i++)
			{
				if (items[i].name == _name)
				{
					return items[i];
				}
			}
			return null;
		}

		private static function GetItemIndexByName(_name:String):int
		{
			for (var i:int = 0; i < items.length; i++)
			{
				if (items[i].name == _name)
				{
					return i;
				}
			}
			return -1;
		}

		private static function AnimateAll(_immediately:Boolean = false):void
		{
			var actmc:MovieClip = null;
			var ty:Number = NaN;
			var allitemsHeight:Number = itemHeight * items.length;
			var openeralertvisible:Boolean = false;
			for (var i:int = 0; i < items.length; i++)
			{
				actmc = items[i].mc;
				actmc.x = itempadding;
				TweenMax.killTweensOf(actmc);
				ty = itempadding + itemHeight * i + itemoffset * i;
				if (_immediately)
				{
					actmc.y = ty;
				}
				else
				{
					TweenMax.to(actmc, 0.3, {
								"y": ty,
								"delay": 0.05 * i,
								"ease": Back.easeOut
							});
				}
				if (actmc.ALERT.visible)
				{
					openeralertvisible = true;
				}
			}
			var opener:MovieClip = MovieClip(slidebar.getChildByName("OPENER"));
			if (openeralertvisible)
			{
				opener.ALERT.visible = true;
			}
			else
			{
				opener.ALERT.visible = false;
			}
		}

		public static function OnAlignFunc():void
		{
			mc.x = 0;
			mc.y = 0;
			var bg:MovieClip = MovieClip(slidebar.getChildByName("BG"));
			var opener:MovieClip = MovieClip(slidebar.getChildByName("OPENER"));
			opener.BG.filters = null;
			bg.BG.filters = null;
			bg.x = 0;
			bg.y = 0;
			var totalHeight:Number = itemHeight * items.length + (itemoffset * items.length - 1);
			bg.height = totalHeight + itempadding * 2;
			bg.width = itemWidth + itempadding * 2;
			slidebar.y = Imitation.stage.stageHeight / 2 - bg.height / 2 * appScale;
			opener.x = bg.width - 55;
			opener.y = bg.height / 2;
			TweenMax.to(opener.BG, 0, {"glowFilter": {
							"color": 0,
							"alpha": 0.8,
							"blurX": 10,
							"blurY": 10,
							"strength": 2
						}});
			TweenMax.to(bg.BG, 0, {"glowFilter": {
							"color": 0,
							"alpha": 0.8,
							"blurX": 10,
							"blurY": 10,
							"strength": 2
						}});
		}

		private static function ItemClick(e:Object):void
		{
			if (e.target.name == "BG")
			{
				return;
			}
			if (e.target.name == "HITAREA" && e.target.parent.name == "OPENER")
			{
				TweenMax.killTweensOf(SetState);
				if (state == "OUT")
				{
					SetState("IN");
				}
				else
				{
					SetState("OUT");
				}
			}
			else
			{
				TweenMax.delayedCall(0.3, SetState, ["OUT"]);
				if (e.target.parent.callback != null)
				{
					TweenMax.delayedCall(0.8, e.target.parent.callback);
				}
				Remove( {"mc": e.target.parent});
			}
		}

		public static function Show():void
		{
			if (items.length <= 0)
			{
				return;
			}
			mc.visible = true;
			Aligner.SetMargins();
		}

		public static function Hide():void
		{
			mc.visible = false;
			Aligner.SetMargins();
		}

		public static function SetState(_state:String, _immediately:Boolean = false):void
		{
			var opener:MovieClip = null;
			state = _state;
			var bg:MovieClip = MovieClip(slidebar.getChildByName("BG"));
			opener = MovieClip(slidebar.getChildByName("OPENER"));
			var speed:Number = 0.5;
			if (state == "IN")
			{
				TweenMax.killTweensOf(slidebar);
				if (_immediately)
				{
					slidebar.x = 0;
					opener.ICONSET.Set("X2");
				}
				else
				{
					TweenMax.to(slidebar, speed, {
								"x": 0,
								"ease": Sine.easeIn,
								"onComplete": function():*
								{
									opener.ICONSET.Set("X2");
								}
							});
				}
			}
			else if (state == "OUT")
			{
				TweenMax.killTweensOf(slidebar);
				if (_immediately)
				{
					slidebar.x = -(bg.width * appScale - 10);
					opener.ICONSET.Set("BELL");
				}
				else
				{
					TweenMax.to(slidebar, speed, {
								"x": -(bg.width * appScale - 10),
								"ease": Sine.easeIn,
								"onComplete": function():*
								{
									opener.ICONSET.Set("BELL");
								}
							});
				}
			}
		}

		public static function OnWindowChange(e:Object):void
		{
			var roomsel:int = 0;
			if (Sys.tag_waitstate)
			{
				roomsel = Util.NumberVal(Sys.tag_waitstate.ROOMSEL);
			}
			if (Sys.screen.substr(0, 3) != "MAP" && roomsel == 0)
			{
				if (!mc.visible)
				{
					Show();
				}
			}
			else if (mc.visible)
			{
				Hide();
			}
			if (Sys.screen == "VILLAGE" && state == "OUT")
			{
				waitforfirsttime = false;
				TweenMax.killTweensOf(SetState);
				TweenMax.delayedCall(5, SetState, ["IN", false]);
				TweenMax.delayedCall(5.15, SetState, ["OUT", false]);
			}
			Imitation.rootmc.setChildIndex(mc, Imitation.rootmc.numChildren - 1);
		}

		public static function OnFriendListChange(e:Object):void
		{
			Sys.CheckFriendInvites();
		}

		private static function OnStageClick(e:Object):void
		{
			var mp:Point = Imitation.GetMousePos(Imitation.stage);
			if (state == "IN")
			{
				if (mp.x > slidebar.width)
				{
					SetState("OUT");
				}
			}
			else if (state == "OUT")
			{
			}
		}

		private static function OnSwipe(evt:TransformGestureEvent):void
		{
			var mp:Point = Imitation.GetMousePos(Imitation.stage);
			if (evt.offsetX == 1)
			{
				if (state == "OUT")
				{
					if (mp.x < 300)
					{
						SetState("IN");
					}
				}
			}
			else if (evt.offsetX == -1)
			{
				if (state == "IN")
				{
					if (mp.x < 300)
					{
						SetState("OUT");
					}
				}
			}
		}

		public static function CalculateAppScale():void
		{
			var guiSize:Rectangle = new Rectangle(0, 0, 800, 480);
			var deviceSize:Rectangle = new Rectangle(0, 0, Math.max(Imitation.stage.stageWidth, Imitation.stage.stageHeight), Math.min(Imitation.stage.stageWidth, Imitation.stage.stageHeight));
			var appSize:Rectangle = guiSize.clone();
			var appLeftOffset:Number = 0;
			if (deviceSize.width / deviceSize.height > guiSize.width / guiSize.height)
			{
				appScale = deviceSize.height / guiSize.height;
				appSize.width = deviceSize.width / appScale;
				appLeftOffset = Math.round((appSize.width - guiSize.width) / 2);
			}
			else
			{
				appScale = deviceSize.width / guiSize.width;
				appSize.height = deviceSize.height / appScale;
				appLeftOffset = 0;
			}
			if (!Config.mobile)
			{
				appScale = 1;
			}
		}
	}
}
