package com.adobe.serialization.json {
		public final class ADOBEJSON {
				public function ADOBEJSON() {
						super();
				}
				
				public static function encode(o:Object) : String {
						return new JSONEncoder(o).getString();
				}
				
				public static function decode(s:String, strict:Boolean = true) : * {
						return new JSONDecoder(s,strict).getValue();
				}
				
				public static function stringify(o:Object, pretty:Boolean = false) : String {
						if(pretty) {
								return new JSONEncoder(o,true).getString();
						}
						return encode(o);
				}
		}
}

