package syscode {
		internal class LegoChatMessage {
				public var cb:LegoChatMessageBuffer;
				
				public var timestamp:uint;
				
				public var timestampstr:String = "";
				
				public var userid:String = "";
				
				public var username:String;
				
				public var message:String;
				
				public var uuid:String;
				
				public var hidden:Boolean = false;
				
				public var revealed:Boolean = false;
				
				public var formattedmsg:String = "";
				
				public var y:Number = -1;
				
				public var linecount:Number = -1;
				
				public var height:Number = -1;
				
				public var odd:Boolean;
				
				public var userchange:Boolean;
				
				public var event:Boolean = false;
				
				public var signup:Boolean = false;
				
				public var fg:Boolean = false;
				
				public var fgcode:String = "";
				
				public function LegoChatMessage(acb:LegoChatMessageBuffer, tag:Object) {
						super();
				}
				
				public function FormatMessage() : String {
						return "";
				}
				
				public function FormatClanMessage() : String {
						return "";
				}
				
				public function CalculateLineCount(prototypemov:MovieClip) : Number {
						return 0;
				}
		}
}

