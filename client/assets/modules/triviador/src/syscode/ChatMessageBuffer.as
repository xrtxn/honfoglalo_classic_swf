package syscode {
		import flash.display.*;
		import flash.events.*;
		import flash.text.*;
		
		public class ChatMessageBuffer {
				public var allmsg:Vector.<ChatMessage>;
				
				public var fullheight:Number = 0;
				
				public var minheight:Number = 12;
				
				public var lastuserid:String = "";
				
				public var oddline:Boolean = false;
				
				public var clanchat:Boolean = false;
				
				public var top:Number = 0;
				
				public var default_line_height:Number = 25;
				
				public var OnUserClick:Function = null;
				
				public var pool:Array;
				
				public var num:int = 16;
				
				public var click_enabled:Boolean = true;
				
				public var lastisevent:Boolean = false;
				
				public function ChatMessageBuffer() {
						this.allmsg = new Vector.<ChatMessage>();
						this.pool = [];
						super();
				}
				
				public function Clear() : void {
				}
				
				public function AddSysMsg(msg:String, prototypemov:*) : void {
				}
				
				public function AddTimeStamp(ts:String, prototypemov:*) : void {
				}
				
				public function AddChatMessage(tag:Object, prototypemov:MovieClip = null) : ChatMessage {
						return null;
				}
				
				public function DrawMessages(chatmc:MovieClip, refresh:Boolean = false) : * {
				}
				
				public function OnUserLinkClick(e:*) : * {
				}
		}
}

