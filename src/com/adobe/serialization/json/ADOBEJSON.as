package com.adobe.serialization.json
{
    public final class ADOBEJSON
    {
        public static function encode(o:Object):String
        {
            return new JSONEncoder(o).getString();
        }

        public static function decode(s:String, strict:Boolean = true):*
        {
            return new JSONDecoder(s, strict).getValue();
        }

        public static function stringify(o:Object, pretty:Boolean = false):String
        {
            trace("DEPRECATED will be removed in the future");
            if (pretty)
            {
                return new JSONEncoder(o).getString();
            }
            return encode(o);
        }

        public function ADOBEJSON()
        {
            super();
        }
    }
}
