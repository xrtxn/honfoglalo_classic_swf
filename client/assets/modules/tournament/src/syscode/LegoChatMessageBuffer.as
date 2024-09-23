package syscode {
		import flash.display.*;
		import flash.events.*;
		import flash.text.*;
		
		public class LegoChatMessageBuffer {
				public var allmsg:Vector.<LegoChatMessage>;
				
				public var fullheight:Number = 0;
				
				public var minheight:Number = 12;
				
				public var lastuserid:String = "";
				
				public var oddline:Boolean = false;
				
				public var clanchat:Boolean = false;
				
				public var allow_hide:Boolean = true;
				
				public var top:Number = 0;
				
				public var default_line_height:Number = 25;
				
				public var OnUserClick:Function = null;
				
				public var pool:Array;
				
				public var num:int = 10;
				
				public var click_enabled:Boolean = true;
				
				public var lastisevent:Boolean = false;
				
				public var fgcode:String = "0000";
				
				public function LegoChatMessageBuffer() {
						this.allmsg = new Vector.<LegoChatMessage>();
						this.pool = [];
						super();
				}
				
				public function Clear() : void {
				}
				
				public function AddSysMsg(msg:String, prototypemov:*) : void {
				}
				
				public function AddTimeStamp(ts:String, prototypemov:*) : void {
				}
				
				public function AddChatMessage(tag:Object, prototypemov:MovieClip = null) : LegoChatMessage {
						return null;
				}
				
				public function HideChatMessage(tag:Object) : * {
				}
				
				public function DrawMessages(chatmc:MovieClip, refresh:Boolean = false) : * {
				}
				
				public function OnUserLinkClick(e:*) : * {
				}
				
				public function GoBottom() : * {
				}
		}
}

