package com.adobe.serialization.json
{
    public class JSONDecoder
    {
        public function JSONDecoder(s:String, strict:Boolean)
        {
            super();
            this.strict = strict;
            tokenizer = new JSONTokenizer(s, strict);
            nextToken();
            value = parseValue();
            if (strict && nextToken() != null)
            {
                tokenizer.parseError("Unexpected characters left in input stream");
            }
        }
        private var strict:Boolean;
        private var value:*;
        private var tokenizer:JSONTokenizer;
        private var token:JSONToken;

        public function getValue():*
        {
            return value;
        }

        final private function nextToken():JSONToken
        {
            return token = tokenizer.getNextToken();
        }

        final private function nextValidToken():JSONToken
        {
            token = tokenizer.getNextToken();
            checkValidToken();
            return token;
        }

        final private function checkValidToken():void
        {
            if (token == null)
            {
                tokenizer.parseError("Unexpected end of input");
            }
        }

        final private function parseArray():Array
        {
            var a:Array = new Array();
            nextValidToken();
            if (token.type == JSONTokenType.RIGHT_BRACKET)
            {
                return a;
            }
            if (!strict && token.type == JSONTokenType.COMMA)
            {
                nextValidToken();
                if (token.type == JSONTokenType.RIGHT_BRACKET)
                {
                    return a;
                }
                tokenizer.parseError("Leading commas are not supported.  Expecting ']' but found " + token.value);
            }
            while (true)
            {
                a.push(parseValue());
                nextValidToken();
                if (token.type == JSONTokenType.RIGHT_BRACKET)
                {
                    break;
                }
                if (token.type == JSONTokenType.COMMA)
                {
                    nextToken();
                    if (!strict)
                    {
                        checkValidToken();
                        if (token.type == JSONTokenType.RIGHT_BRACKET)
                        {
                            return a;
                        }
                    }
                }
                else
                {
                    tokenizer.parseError("Expecting ] or , but found " + token.value);
                }
            }
            return a;
        }

        final private function parseObject():Object
        {
            var o:Object = new Object();
            nextValidToken();
            if (token.type == JSONTokenType.RIGHT_BRACE)
            {
                return o;
            }
            if (!strict && token.type == JSONTokenType.COMMA)
            {
                nextValidToken();
                if (token.type == JSONTokenType.RIGHT_BRACE)
                {
                    return o;
                }
                tokenizer.parseError("Leading commas are not supported.  Expecting '}' but found " + token.value);
            }
            while (true)
            {
                if (token.type == JSONTokenType.STRING)
                {
                    var key:String = String(token.value);
                    nextValidToken();
                    if (token.type == JSONTokenType.COLON)
                    {
                        nextToken();
                        o[key] = parseValue();
                        nextValidToken();
                        if (token.type == JSONTokenType.RIGHT_BRACE)
                        {
                            break;
                        }
                        if (token.type == JSONTokenType.COMMA)
                        {
                            nextToken();
                            if (!strict)
                            {
                                checkValidToken();
                                if (token.type == JSONTokenType.RIGHT_BRACE)
                                {
                                    return o;
                                }
                            }
                        }
                        else
                        {
                            tokenizer.parseError("Expecting } or , but found " + token.value);
                        }
                    }
                    else
                    {
                        tokenizer.parseError("Expecting : but found " + token.value);
                    }
                }
                else
                {
                    tokenizer.parseError("Expecting string but found " + token.value);
                }
            }
            return o;
        }

        final private function parseValue():Object
        {
            checkValidToken();
            switch (token.type)
            {
                case JSONTokenType.LEFT_BRACE:
                    return parseObject();
                case JSONTokenType.LEFT_BRACKET:
                    return parseArray();
                case JSONTokenType.STRING:
                case JSONTokenType.NUMBER:
                case JSONTokenType.TRUE:
                case JSONTokenType.FALSE:
                case JSONTokenType.NULL:
                    return token.value;
                case JSONTokenType.NAN:
                    if (!strict)
                    {
                        return token.value;
                    }
                    tokenizer.parseError("Unexpected " + token.value);
                    break;
            }
            tokenizer.parseError("Unexpected " + token.value);
            return null;
        }
    }
}
