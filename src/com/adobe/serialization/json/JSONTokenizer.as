package com.adobe.serialization.json
{
    public class JSONTokenizer
    {
        public function JSONTokenizer(s:String, strict:Boolean)
        {
            this.controlCharsRegExp = /[\x00-\x1F]/;
            super();
            jsonString = s;
            this.strict = strict;
            loc = 0;
            nextChar();
        }
        private var strict:Boolean;
        private var obj:Object;
        private var jsonString:String;
        private var loc:int;
        private var ch:String;
        private var controlCharsRegExp:RegExp;

        public function getNextToken():JSONToken
        {
            var token:JSONToken = null;
            skipIgnored();
            switch (ch)
            {
                case "{":
                    token = JSONToken.create(JSONTokenType.LEFT_BRACE, ch);
                    nextChar();
                    break;
                case "}":
                    token = JSONToken.create(JSONTokenType.RIGHT_BRACE, ch);
                    nextChar();
                    break;
                case "[":
                    token = JSONToken.create(JSONTokenType.LEFT_BRACKET, ch);
                    nextChar();
                    break;
                case "]":
                    token = JSONToken.create(JSONTokenType.RIGHT_BRACKET, ch);
                    nextChar();
                    break;
                case ",":
                    token = JSONToken.create(JSONTokenType.COMMA, ch);
                    nextChar();
                    break;
                case ":":
                    token = JSONToken.create(JSONTokenType.COLON, ch);
                    nextChar();
                    break;
                case "t":
                    var possibleTrue:String = "t" + nextChar() + nextChar() + nextChar();
                    if (possibleTrue == "true")
                    {
                        token = JSONToken.create(JSONTokenType.TRUE, true);
                        nextChar();
                        break;
                    }
                    parseError("Expecting 'true' but found " + possibleTrue);
                    break;
                case "f":
                    var possibleFalse:String = "f" + nextChar() + nextChar() + nextChar() + nextChar();
                    if (possibleFalse == "false")
                    {
                        token = JSONToken.create(JSONTokenType.FALSE, false);
                        nextChar();
                        break;
                    }
                    parseError("Expecting 'false' but found " + possibleFalse);
                    break;
                case "n":
                    var possibleNull:String = "n" + nextChar() + nextChar() + nextChar();
                    if (possibleNull == "null")
                    {
                        token = JSONToken.create(JSONTokenType.NULL, null);
                        nextChar();
                        break;
                    }
                    parseError("Expecting 'null' but found " + possibleNull);
                    break;
                case "N":
                    var possibleNaN:String = "N" + nextChar() + nextChar();
                    if (possibleNaN == "NaN")
                    {
                        token = JSONToken.create(JSONTokenType.NAN, NaN);
                        nextChar();
                        break;
                    }
                    parseError("Expecting 'NaN' but found " + possibleNaN);
                    break;
                case "\"":
                    token = readString();
                    break;
                default:
                    if (isDigit(ch) || ch == "-")
                    {
                        token = readNumber();
                    }
                    else if (ch == "")
                    {
                        token = null;
                    }
                    else
                    {
                        parseError("Unexpected " + ch + " encountered");
                    }
            }
            return token;
        }

        public function unescapeString(input:String):String
        {
            if (strict && controlCharsRegExp.test(input))
            {
                parseError("String contains unescaped control character (0x00-0x1F)");
            }
            var result:String = "";
            var backslashIndex:int = 0;
            var nextSubstringStartPosition:int = 0;
            var len:int = input.length;
            do
            {
                backslashIndex = int(input.indexOf("\\", nextSubstringStartPosition));
                if (backslashIndex < 0)
                {
                    result += input.substr(nextSubstringStartPosition);
                    break;
                }
                result += input.substr(nextSubstringStartPosition, backslashIndex - nextSubstringStartPosition);
                nextSubstringStartPosition = backslashIndex + 2;
                var escapedChar:String = input.charAt(backslashIndex + 1);
                switch (escapedChar)
                {
                    case "\"":
                        result += escapedChar;
                        break;
                    case "\\":
                        result += escapedChar;
                        break;
                    case "n":
                        result += "\n";
                        break;
                    case "r":
                        result += "\r";
                        break;
                    case "t":
                        result += "\t";
                        break;
                    case "u":
                        var hexValue:String = "";
                        var unicodeEndPosition:int = nextSubstringStartPosition + 4;
                        if (unicodeEndPosition > len)
                        {
                            parseError("Unexpected end of input.  Expecting 4 hex digits after \\u.");
                        }
                        var i:int = nextSubstringStartPosition;
                        while (i < unicodeEndPosition)
                        {
                            var possibleHexChar:String = input.charAt(i);
                            if (!isHexDigit(possibleHexChar))
                            {
                                parseError("Excepted a hex digit, but found: " + possibleHexChar);
                            }
                            hexValue += possibleHexChar;
                            i++;
                        }
                        result += String.fromCharCode(parseInt(hexValue, 16));
                        nextSubstringStartPosition = unicodeEndPosition;
                        break;
                    case "f":
                        result += "\f";
                        break;
                    case "/":
                        result += "/";
                        break;
                    case "b":
                        result += "\b";
                        break;
                    default:
                        result += "\\" + escapedChar;
                        break;
                }
            }
            while (nextSubstringStartPosition < len);

            return result;
        }

        final public function parseError(message:String):void
        {
            throw new JSONParseError(message, loc, jsonString);
        }

        final private function readString():JSONToken
        {
            var quoteIndex:int = loc;
            while (true)
            {
                quoteIndex = int(jsonString.indexOf("\"", quoteIndex));
                if (quoteIndex >= 0)
                {
                    var backspaceCount:int = 0;
                    var backspaceIndex:int = quoteIndex - 1;
                    while (jsonString.charAt(backspaceIndex) == "\\")
                    {
                        backspaceCount++;
                        backspaceIndex--;
                    }
                    if ((backspaceCount & 1) == 0)
                    {
                        break;
                    }
                    quoteIndex++;
                }
                else
                {
                    parseError("Unterminated string literal");
                }
            }
            var token:JSONToken = JSONToken.create(JSONTokenType.STRING, unescapeString(jsonString.substr(loc, quoteIndex - loc)));
            loc = quoteIndex + 1;
            nextChar();
            return token;
        }

        final private function readNumber():JSONToken
        {
            var input:String = "";
            if (ch == "-")
            {
                input += "-";
                nextChar();
            }
            if (!isDigit(ch))
            {
                parseError("Expecting a digit");
            }
            if (ch == "0")
            {
                input += ch;
                nextChar();
                if (isDigit(ch))
                {
                    parseError("A digit cannot immediately follow 0");
                }
                else if (!strict && ch == "x")
                {
                    input += ch;
                    nextChar();
                    if (isHexDigit(ch))
                    {
                        input += ch;
                        nextChar();
                    }
                    else
                    {
                        parseError("Number in hex format require at least one hex digit after \"0x\"");
                    }
                    while (isHexDigit(ch))
                    {
                        input += ch;
                        nextChar();
                    }
                }
            }
            else
            {
                while (isDigit(ch))
                {
                    input += ch;
                    nextChar();
                }
            }
            if (ch == ".")
            {
                input += ".";
                nextChar();
                if (!isDigit(ch))
                {
                    parseError("Expecting a digit");
                }
                while (isDigit(ch))
                {
                    input += ch;
                    nextChar();
                }
            }
            if (ch == "e" || ch == "E")
            {
                input += "e";
                nextChar();
                if (ch == "+" || ch == "-")
                {
                    input += ch;
                    nextChar();
                }
                if (!isDigit(ch))
                {
                    parseError("Scientific notation number needs exponent value");
                }
                while (isDigit(ch))
                {
                    input += ch;
                    nextChar();
                }
            }
            var num:Number = Number(input);
            if (isFinite(num) && !isNaN(num))
            {
                return JSONToken.create(JSONTokenType.NUMBER, num);
            }
            parseError("Number " + num + " is not valid!");
            return null;
        }

        final private function nextChar():String
        {
            return ch = jsonString.charAt(loc++);
        }

        final private function skipIgnored():void
        {
            do
            {
                var originalLoc:int = loc;
                skipWhite();
                skipComments();
            }
            while (originalLoc != loc);

        }

        private function skipComments():void
        {
            if (ch == "/")
            {
                nextChar();
                switch (ch)
                {
                    case "/":
                        do
                        {
                            nextChar();
                        }
                        while (ch != "\n" && ch != "");

                        nextChar();
                        break;
                    case "*":
                        nextChar();
                        while (true)
                        {
                            if (ch == "*")
                            {
                                nextChar();
                                if (ch == "/")
                                {
                                    break;
                                }
                            }
                            nextChar();
                            if (ch == "")
                            {
                                parseError("Multi-line comment not closed");
                            }
                        }
                        nextChar();
                        break;
                    default:
                        parseError("Unexpected " + ch + " encountered (expecting '/' or '*' )");
                }
            }
        }

        final private function skipWhite():void
        {
            while (isWhiteSpace(ch))
            {
                nextChar();
            }
        }

        final private function isWhiteSpace(ch:String):Boolean
        {
            if (ch == " " || ch == "\t" || ch == "\n" || ch == "\r")
            {
                return true;
            }
            if (!strict && ch.charCodeAt(0) == 160)
            {
                return true;
            }
            return false;
        }

        final private function isDigit(ch:String):Boolean
        {
            return ch >= "0" && ch <= "9";
        }

        final private function isHexDigit(ch:String):Boolean
        {
            return isDigit(ch) || ch >= "A" && ch <= "F" || ch >= "a" && ch <= "f";
        }
    }
}
