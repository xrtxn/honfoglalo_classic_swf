package com.adobe.serialization.json
{
    public final class JSONToken
    {
        internal static const token:JSONToken = new JSONToken();

        internal static function create(type:int = -1, value:Object = null):JSONToken
        {
            token.type = type;
            token.value = value;
            return token;
        }

        public function JSONToken(type:int = -1, value:Object = null)
        {
            super();
            this.type = type;
            this.value = value;
        }
        public var type:int;
        public var value:Object;
    }
}
