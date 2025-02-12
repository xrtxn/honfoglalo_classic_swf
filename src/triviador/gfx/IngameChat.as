package triviador.gfx
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import syscode.*;
	import triviador.Main;
	import triviador.Game;
	import triviador.Map;
	import triviador.Standings;
	import triviador.compat.TriviadorScrollBarMov2;

	[Embed(source="/modules/triviador_assets.swf", symbol="symbol1345")]
	public class IngameChat extends MovieClip
	{
		public static var mc:IngameChat = null;

		private static var sx:int = 0;

		private static var sy:int = 0;

		private static var mousedown:Boolean = false;

		public static var mute1:Boolean = false;

		public static var mute2:Boolean = false;

		public static var disabled:Boolean = false;

		public var BTNSEND:MovieClip;

		public var BTNX:MovieClip;

		public var HEADER:MovieClip;

		public var INPUT:TextField;

		public var MASK:MovieClip;

		public var MESSAGES:MovieClip;

		public var SCROLLBAR:TriviadorScrollBarMov2;

		public var chatbuf:ChatMessageBuffer;

		public var msgbuffer:Array;

		public function IngameChat()
		{
			this.chatbuf = new ChatMessageBuffer();
			this.msgbuffer = new Array();
			super();
		}

		public static function Init():*
		{
			if (!mc)
			{
				mc = new IngameChat();
				Imitation.rootmc.addChild(mc);
				Imitation.CollectChildrenAll(mc);
				mc.gotoAndStop(Config.mobile ? 2 : 1);
				Util.StopAllChildrenMov(mc);
				mc.chatbuf.num = 6;
				mc.chatbuf.click_enabled = false;
				mc.StartWaitingChat();
				mute1 = false;
				mute2 = false;
				disabled = false;
				Imitation.AddGlobalListener("GAMETAGSPROCESSED", OnGameTagsProcessed);
				Imitation.AddEventClick(mc.BTNX, Hide);
				mc.visible = false;
				mc.UpdateChatState(false);
			}
		}

		public static function Show(e:* = null):*
		{
			if (!mc)
			{
				Init();
			}
			else
			{
				Imitation.rootmc.addChild(mc);
			}
			if (!mc.visible)
			{
				Align();
			}
			mc.visible = true;
			TweenMax.delayedCall(0, function():*
				{
					if (mc.INPUT)
					{
						Imitation.EnableInput(mc.INPUT, true);
						Imitation.SetFocus(mc.INPUT);
					}
					Imitation.AddEventMouseOver(mc.HEADER, OnHeaderMouseOver);
					Imitation.AddEventMouseOut(mc.HEADER, OnHeaderMouseOut);
					Imitation.AddStageEventListener(MouseEvent.MOUSE_MOVE, OnHeaderMouseMove);
					Imitation.AddEventMouseDown(mc.HEADER, OnHeaderMouseDown);
					Imitation.AddEventMouseUp(mc.HEADER, OnHeaderMouseUp);
				});
		}

		private static function OnHeaderMouseOver(e:*):void
		{
			if (!mc)
			{
				return;
			}
		}

		private static function OnHeaderMouseOut(e:*):void
		{
			if (!mc)
			{
				return;
			}
		}

		private static function OnHeaderMouseMove(e:*):void
		{
			if (!mc)
			{
				return;
			}
			var p:* = Imitation.GetMousePos(Main.mc);
			if (mousedown)
			{
				mc.x = p.x - sx;
				mc.y = p.y - sy;
			}
		}

		private static function OnHeaderMouseDown(e:*):void
		{
			if (!mc)
			{
				return;
			}
			var p:* = Imitation.GetMousePos(Main.mc);
			mousedown = true;
			sx = p.x - mc.x;
			sy = p.y - mc.y;
		}

		private static function OnHeaderMouseUp(e:*):void
		{
			if (!mc)
			{
				return;
			}
			mousedown = false;
		}

		public static function BringToFront():*
		{
			if (!mc)
			{
				return;
			}
			Imitation.rootmc.addChild(mc);
		}

		public static function Hide(e:* = null):*
		{
			if (!mc)
			{
				return;
			}
			mc.visible = false;
			if (mc.INPUT)
			{
				Imitation.EnableInput(mc.INPUT, false);
			}
		}

		public static function Remove():*
		{
			if (!mc)
			{
				return;
			}
			Imitation.RemoveGlobalListener("GAMETAGSPROCESSED", OnGameTagsProcessed);
			Imitation.RemoveStageEventListener(TextEvent.TEXT_INPUT, mc.InputKeyUp);
			Imitation.RemoveStageEventListener("mouseWheel", mc.HandleMouseWheel);
			Hide();
			if (Imitation.rootmc.contains(mc))
			{
				Imitation.rootmc.removeChild(mc);
			}
			mc = null;
		}

		public static function Align():*
		{
			if (mc)
			{
				mc.height = Map.cleanheight - 20;
				mc.scaleY = Math.min(Game.boxscale * (Config.mobile ? 1.5 : 1), mc.scaleY);
				mc.scaleX = mc.scaleY;
				if (Map.verticallayout)
				{
					mc.x = 5;
					mc.y = Aligner.stageheight - mc.height - 130;
				}
				else
				{
					mc.x = Aligner.stagewidth - mc.width - 10;
					mc.y = Map.cleany + 15;
				}
			}
		}

		public static function tagproc_MESSAGE(tag:Object):void
		{
			trace("IngameChat.tagproc_MESSAGE");
			if (!mc)
			{
				return;
			}
			if (!IsChatEnabled())
			{
				return;
			}
			if (disabled)
			{
				return;
			}
			if (mute1 && Game.myopp1 == tag.FROM)
			{
				return;
			}
			if (mute2 && Game.myopp2 == tag.FROM)
			{
				return;
			}
			var f:* = Friends.GetUser(Game.players[Util.NumberVal(tag.FROM, Game.iam)].id);
			if (f && f.flag == 3)
			{
				return;
			}
			var pnum:int = Util.NumberVal(tag.FROM);
			var amsg:String = Util.StringVal(tag.MSG);
			var em:int = Config.emoticons.indexOf(amsg) + 1;
			var emo:Boolean = false;
			if (em > 0)
			{
				emo = Standings.ShowEmotion(pnum, em);
			}
			var cb:ChatMessageBuffer = mc.chatbuf;
			var fullheight:Number = cb.fullheight;
			var msg:Object = cb.AddChatMessage(tag, mc.MESSAGES.ITEMS.PROTOTYPE);
			if (cb.top > fullheight - mc.MASK.height - cb.default_line_height * 2)
			{
				cb.top = cb.fullheight - mc.MASK.height;
			}
			if (!mc.visible && !emo)
			{
				ShowBubble(pnum, amsg, em);
			}
		}

		public static function SendText(msg:String):*
		{
			if (Boolean(mc) && Game.KeepBufferedMessages())
			{
				mc.msgbuffer.push(msg);
			}
			else
			{
				Comm.SendCommand("MESSAGE", "TO=\"0\" TEXT=\"" + msg + "\"");
			}
		}

		public static function SendEmoticon(em:int):*
		{
			if (!mc)
			{
				return;
			}
			var msg:String = Config.emoticons[em - 1];
			if (Game.KeepBufferedMessages())
			{
				mc.msgbuffer.push(msg);
			}
			else
			{
				Comm.SendCommand("MESSAGE", "TO=\"0\" TEXT=\"" + msg + "\"");
			}
		}

		public static function OnGameTagsProcessed(e:*):*
		{
			trace("OnGameTagsProcessed");
			if (!mc)
			{
				return;
			}
			if (!IsChatEnabled())
			{
				return;
			}
			mc.DrawChatMessages();
			mc.UpdateScrollBar();
		}

		public static function ShowBubble(pnum:int, atext:String, em:int = 0):*
		{
			var b:* = new ChatBubbleMov(atext, em);
			Main.mc.addChild(b);
			Imitation.CollectChildrenAll(Main.mc);
			Imitation.UpdateAll(b);
			var pt:* = Standings.BoxPosition(pnum);
			b.x = pt.x + Game.boxscale * 50;
			b.y = pt.y + Game.boxscale * 70;
			if (b.x < 30)
			{
				b.x = 30;
			}
			if (b.y < 0)
			{
				b.y = 0;
			}
			b.BubbleIn();
		}

		public static function IsChatEnabled():Boolean
		{
			if (Game.iam == 0)
			{
				return false;
			}
			if (Sys.mydata.chatban == 1)
			{
				return false;
			}
			if (Game.isminitournament)
			{
				return false;
			}
			if (Game.roomtype == "F")
			{
				return true;
			}
			return (Game.players[Game.iam].chatstate & 8) == 0;
		}

		public function SysMsg(msg:String):void
		{
			this.chatbuf.AddChatMessage({
						"TS": 0,
						"UID": -1,
						"NAME": "",
						"MSG": msg
					}, mc.MESSAGES.ITEMS.PROTOTYPE);
			this.DrawChatMessages();
			this.chatbuf.top = this.chatbuf.fullheight - mc.MASK.height;
			this.UpdateScrollBar();
		}

		private function StartWaitingChat():*
		{
			Imitation.CollectChildren();
			mc.DrawChatMessages();
			var m:MovieClip = mc.MESSAGES.ITEMS;
			if (mc.BTNSEND)
			{
				Imitation.AddEventClick(mc.BTNSEND, mc.OnSendClick);
			}
			Imitation.AddStageEventListener(TextEvent.TEXT_INPUT, mc.InputKeyUp);
			mc.MESSAGES.condenseWhite = true;
			mc.MESSAGES.ITEMS.PROTOTYPE.visible = false;
			mc.SCROLLBAR.OnScroll = mc.OnScrollBarScroll;
			if (mc.INPUT)
			{
				mc.INPUT.restrict = Config.GetChatRestrictChars();
			}
			if (mc.INPUT)
			{
				Util.RTLEditSetup(mc.INPUT);
			}
			mc.SCROLLBAR.Set(mc.chatbuf.fullheight, mc.MASK.height, mc.chatbuf.fullheight - mc.MASK.height);
			mc.SCROLLBAR.SetScrollRect(mc.MASK);
			mc.SCROLLBAR.isaligned = false;
			mc.SCROLLBAR.visible = mc.chatbuf.fullheight > mc.MASK.height;
			mc.SCROLLBAR.buttonstep = 22;
			Imitation.SetMaskedMov(mc.MASK, mc.MESSAGES, false);
			Imitation.AddStageEventListener("mouseWheel", mc.HandleMouseWheel);
			this.DrawChatMessages(true);
		}

		public function DrawChatMessages(refresh:* = false):*
		{
			if (!mc || !mc.MESSAGES)
			{
				return;
			}
			if (!IsChatEnabled() && !refresh)
			{
				return;
			}
			this.chatbuf.DrawMessages(this, refresh);
		}

		public function SendBufferedMessages():*
		{
			var msg:String = null;
			if (Game.KeepBufferedMessages())
			{
				return;
			}
			while (this.msgbuffer.length > 0)
			{
				msg = this.msgbuffer.shift();
				Comm.SendCommand("MESSAGE", "TO=\"0\" TEXT=\"" + msg + "\"");
			}
		}

		public function InputKeyUp(e:TextEvent):void
		{
			if (e.text.charCodeAt() == 10)
			{
				e.preventDefault();
				this.OnSendClick();
			}
		}

		public function OnSendClick(e:* = null):*
		{
			var msg:* = Util.GetRTLEditText(this.INPUT);
			msg = Util.CleanupChatMessage(msg);
			if (msg.length < 2)
			{
				return;
			}
			if (Game.KeepBufferedMessages())
			{
				mc.msgbuffer.push(msg);
			}
			else
			{
				Comm.SendCommand("MESSAGE", "TO=\"0\" TEXT=\"" + msg + "\"");
			}
			Util.SetRTLEditText(this.INPUT, "");
		}

		public function FloodBlockReady():*
		{
			if (this.BTNSEND)
			{
				this.BTNSEND.SetEnabled(true);
			}
		}

		public function UpdateScrollBar():*
		{
			this.SCROLLBAR.visible = this.chatbuf.fullheight > this.MASK.height;
			if (!this.SCROLLBAR.dragging)
			{
				this.SCROLLBAR.Set(this.chatbuf.fullheight, this.MASK.height, this.chatbuf.top);
			}
		}

		public function OnScrollBarScroll(afirst:*):*
		{
			this.chatbuf.top = afirst;
			TweenMax.delayedCall(0, this.DrawChatMessages);
		}

		public function OnMessagesScroll(e:*):*
		{
			this.UpdateScrollBar();
		}

		public function HandleMouseWheel(e:MouseEvent):*
		{
			var cb:ChatMessageBuffer = this.chatbuf;
			cb.top -= e.delta * cb.default_line_height;
			cb.top = Math.min(this.chatbuf.fullheight - this.MASK.height, cb.top);
			cb.top = Math.max(0, cb.top);
			TweenMax.delayedCall(0, this.DrawChatMessages);
			this.UpdateScrollBar();
		}

		public function UpdateChatState(anim:Boolean = true):*
		{
			var chatenabled:* = IsChatEnabled();
			if (this.INPUT)
			{
				this.INPUT.visible = chatenabled;
				this.BTNSEND.visible = chatenabled;
			}
			if (Main.mc)
			{
				if (Standings.mc && Standings.mc.STATUS && Boolean(Standings.mc.STATUS.DISABLED))
				{
					Standings.mc.STATUS.DISABLED.visible = !chatenabled;
				}
			}
			this.SCROLLBAR.alpha = !!chatenabled ? 1 : 0;
			this.MESSAGES.visible = chatenabled;
		}
	}
}
