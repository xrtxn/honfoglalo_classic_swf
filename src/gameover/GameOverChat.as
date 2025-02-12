package gameover
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import syscode.*;
	import gameover.compat.ScrollBarMov6;

	[Embed(source="/modules/gameover_assets.swf", symbol="symbol607")]
	public class GameOverChat extends MovieClip
	{
		public static var mc:GameOverChat = null;

		private static var sx:int = 0;

		private static var sy:int = 0;

		private static var mousedown:Boolean = false;

		private static var Game:Object = null;

		public var BTNSEND:MovieClip;

		public var INPUT:TextField;

		public var MASK:MovieClip;

		public var MESSAGES:MovieClip;

		public var MSGBTN1:MovieClip;

		public var MSGBTN2:MovieClip;

		public var MSGBTN3:MovieClip;

		public var SCROLLBAR:ScrollBarMov6;

		public var TXT1:TextField;

		public var TXT2:TextField;

		public var TXT3:TextField;

		public var chatbuf:ChatMessageBuffer = null;

		public var msgbuffer:Array;

		public function GameOverChat()
		{
			this.msgbuffer = new Array();
			super();
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
			Imitation.EnableInput(mc.INPUT, false);
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
			mc = null;
		}

		public static function tagproc_MESSAGE(tag:Object):void
		{
			trace("! GameOverChat.tagproc_MESSAGE");
			if (!mc)
			{
				return;
			}
			if (!mc.IsChatEnabled())
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
			var cb:ChatMessageBuffer = mc.chatbuf;
			var fullheight:Number = cb.fullheight;
			var msg:Object = cb.AddChatMessage(tag, mc.MESSAGES.ITEMS.PROTOTYPE);
			if (cb.top > fullheight - mc.MASK.height - cb.default_line_height * 2)
			{
				cb.top = cb.fullheight - mc.MASK.height;
			}
		}

		public static function SendText(msg:String):*
		{
			if (!mc)
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
			if (!mc.IsChatEnabled())
			{
				return;
			}
			mc.DrawChatMessages();
			mc.UpdateScrollBar();
		}

		public function Init(buf:* = null):*
		{
			if (!mc)
			{
				mc = this;
				Game = Modules.GetClass("triviador", "triviador.Game");
				Util.StopAllChildrenMov(mc);
				if (buf)
				{
					mc.chatbuf = buf;
				}
				else
				{
					mc.chatbuf = new ChatMessageBuffer();
				}
				mc.chatbuf.num = 16;
				mc.chatbuf.click_enabled = false;
				mc.StartWaitingChat();
				Imitation.AddGlobalListener("GAMETAGSPROCESSED", OnGameTagsProcessed);
				mc.UpdateChatState(false);
			}
		}

		public function Show(e:* = null):*
		{
			mc.visible = true;
			Imitation.EnableInput(mc.INPUT, true);
			Imitation.SetFocus(mc.INPUT);
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

		public function GoBottom():*
		{
			this.chatbuf.top = this.chatbuf.fullheight - mc.MASK.height;
			this.UpdateScrollBar();
			this.DrawChatMessages(true);
		}

		private function StartWaitingChat():*
		{
			Imitation.CollectChildren();
			mc.DrawChatMessages();
			var m:MovieClip = mc.MESSAGES.ITEMS;
			if (this.BTNSEND)
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
			if (!mc.IsChatEnabled() && !refresh)
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
			this.BTNSEND.SetEnabled(true);
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

		public function IsChatEnabled():Boolean
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
			return (Game.players[Game.iam].chatstate & 8) == 0;
		}

		public function OnEnableClick(e:*):*
		{
			var chatenabled:*;
			if (Sys.mydata.chatban == 1)
			{
				return;
			}
			Game.players[Game.iam].chatstate ^= 8;
			chatenabled = this.IsChatEnabled();
			Comm.SendCommand("SETCHATSTATE", "ENABLED=\"" + (!!chatenabled ? "1" : "0") + "\"", function():*
				{
				});
			this.UpdateChatState();
			Imitation.SetFocus(mc.INPUT);
		}

		public function UpdateChatState(anim:Boolean = true):*
		{
			var chatenabled:* = this.IsChatEnabled();
			if (this.INPUT)
			{
				this.INPUT.visible = chatenabled;
			}
			if (this.BTNSEND)
			{
				this.BTNSEND.visible = chatenabled;
			}
			this.SCROLLBAR.alpha = !!chatenabled ? 1 : 0;
			this.MESSAGES.visible = chatenabled;
		}
	}
}
