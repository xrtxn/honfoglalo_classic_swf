package triviador.gfx
{
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	import flash.utils.*;
	import syscode.*;
	import triviador.Waithall;
	import triviador.compat.lego_button_1x1_cancel_header;
	import triviador.compat.Missionlist5_5x8_5;
	import triviador.compat.TriviadorCharacters;

	[Embed(source="/modules/triviador_assets.swf", symbol="symbol444")]
	public class WaitingGameMov extends MovieClip
	{
		public static var mc:WaitingGameMov = null;

		public static var afteropencallback:Function = null;

		public var BOUNDS:MovieClip;

		public var BTNCANCEL:lego_button_1x1_cancel_header;

		public var BUBBLELESSTEN:MovieClip;

		public var LABEL:MovieClip;

		public var MISSION_LIST:Missionlist5_5x8_5;

		public var NPC:TriviadorCharacters;

		public var opened:Boolean = false;

		private var badges:Array;

		public function WaitingGameMov()
		{
			this.badges = [];
			super();
		}

		public static function DrawScreen():void
		{
			if (!mc)
			{
				Show();
				return;
			}
			mc.DoDrawScreen();
		}

		public static function Show():void
		{
			if (!mc)
			{
				WinMgr.OpenWindow(WaitingGameMov);
				return;
			}
		}

		public static function Hide():void
		{
			Sounds.StopMusic("passive_player");
			if (mc)
			{
				mc.MISSION_LIST.Destroy();
				WinMgr.CloseWindow(mc);
				return;
			}
		}

		public function Prepare(aparams:Object):void
		{
			this.BTNCANCEL.SetIcon("X");
			this.BTNCANCEL.AddEventClick(this.OnCancelClick);
			this.MISSION_LIST.Start();
			this.DoDrawScreen();
			Util.SetText(this.LABEL.FIELD, Lang.Get("waiting_game_tip_" + Util.Random(16, 0)));
			if (this.LABEL.FIELD.numLines == 1)
			{
				this.LABEL.FIELD.y = 23;
			}
			if (this.LABEL.FIELD.numLines == 2)
			{
				this.LABEL.FIELD.y = 18;
			}
			if (this.LABEL.FIELD.numLines == 3)
			{
				this.LABEL.FIELD.y = 13;
			}
			if (this.LABEL.FIELD.numLines == 4)
			{
				this.LABEL.FIELD.y = 9;
			}
			if (this.LABEL.FIELD.numLines >= 5)
			{
				this.LABEL.FIELD.y = 0;
			}
			this.NPC.Set("VETERAN");
			Imitation.CollectChildrenAll(this);
		}

		public function AfterOpen():*
		{
			this.opened = true;
			if (afteropencallback != null)
			{
				afteropencallback();
				afteropencallback = null;
			}
			Sounds.StopMusic("passive_player");
			Sounds.PlayMusic("passive_player");
			Imitation.CollectChildrenAll(this);
		}

		public function AfterClose():void
		{
		}

		public function DoDrawScreen():*
		{
			var tag:Object = Waithall.waitstatetag;
		}

		public function OnCancelClick(e:*):*
		{
			Sounds.StopMusic("passive_player");
			Comm.SendCommand("EXITROOM", "");
		}

		public function sqadd_PrepareForGame():*
		{
			this.BTNCANCEL.visible = false;
			Sys.gsqc.AddDelay(0.01);
			Sys.gsqc.AddDelay(1.5);
			Sys.gsqc.AddCallBack2(Hide);
		}
	}
}
