package syscode {
		internal class ChatMessage {
				public var cb:ChatMessageBuffer;
				
				public var timestamp:uint;
				
				public var timestampstr:String = "";
				
				public var userid:String = "";
				
				public var username:String;
				
				public var message:String;
				
				public var uuid:String;
				
				public var formattedmsg:String = "";
				
				public var y:Number = -1;
				
				public var height:Number = -1;
				
				public var odd:Boolean;
				
				public var userchange:Boolean;
				
				public var event:Boolean = false;
				
				public var signup:Boolean = false;
				
				public function ChatMessage(acb:ChatMessageBuffer, tag:Object) {
						super();
				}
				
				public function FormatMessage() : String {
						return "";
				}
				
				public function FormatClanMessage() : String {
						return "";
				}
				
				public function CalculateHeight(prototypemov:MovieClip) : Number {
						return 0;
				}
		}
}

