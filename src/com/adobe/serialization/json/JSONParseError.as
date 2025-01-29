package com.adobe.serialization.json
{
    public class JSONParseError extends Error
    {
        public function JSONParseError(message:String = "", location:int = 0, text:String = "")
        {
            super(message);
            name = "JSONParseError";
            _location = location;
            _text = text;
        }

        private var _location:int;

        public function get location():int
        {
            return _location;
        }

        private var _text:String;

        public function get text():String
        {
            return _text;
        }
    }
}
