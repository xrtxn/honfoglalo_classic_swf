package com.xvisage.utils
{
    import flash.external.ExternalInterface;
    import flash.geom.Point;
    import flash.system.Capabilities;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextLineMetrics;

    public class StringUtils
    {
        public function StringUtils()
        {
            this.htmlTags = ["A", "B", "BR", "FONT", "IMG", "I", "LI", "P", "SPAN", "TEXTFORMAT", "U", "UL"];
            super();
            this.isMAC = false;
            var version:String = Capabilities.version;
            if (version.toLowerCase().indexOf("mac") != -1)
            {
                this.isMAC = true;
            }
            this.specialChars += String.fromCharCode(65276, 65275, 65272, 65271, 65274, 65273, 65270, 65269);
        }
        public var latinOnly:Boolean = false;
        public var wrapFactor:Number = 1;
        public var hindiNumeralsOnly:Boolean = true;
        public var americanFormat:Boolean = true;
        public var data:String;
        public var htmlLines:Array;
        public var numLines:Number;
        private var chars:String;
        private var tag:TextField;
        private var format:TextFormat;
        private var temp:TextField;
        private var tempData:String;
        private var htmlTags:Array;
        private var brackets:String = "(){}[]<>«»";
        private var specialChars:String = "اأإآدذرزوؤء";
        private var isMAC:Boolean;

        public function parseArabic(input:String, field:TextField, fieldFormat:TextFormat = null):String
        {
            var arabicChar:String = null;
            var arabicString:String = null;
            var latinChar:String = null;
            var latinString:String = null;
            var htmlString:String = null;
            var i:Number = NaN;
            var plainText:String = null;
            var plainArr:Array = null;
            var plainStr:String = null;
            var tempArr:Array = null;
            var toggleHTML:Boolean = false;
            var toggleArabic:Boolean = false;
            var singleLine:Array = null;
            var multiLines:Array = null;
            var v:Number = NaN;
            var e:Number = NaN;
            var hasHTML:Boolean = false;
            var hasArabic:Boolean = false;
            var htmlLine:String = null;
            var baseChars:String = null;
            this.tag = field;
            if (fieldFormat)
            {
                this.format = fieldFormat;
            }
            else
            {
                this.format = this.tag.getTextFormat();
            }
            this.data = input;
            this.htmlLines = [];
            var string:* = input;
            if (input.length > 0)
            {
                arabicChar = "";
                arabicString = "";
                latinChar = "";
                latinString = "";
                htmlString = "";
                i = 0;
                if (this.americanFormat)
                {
                    plainText = this.stripTags(input);
                    plainArr = plainText.split(" ");
                    for (i = 0; i < plainArr.length; i++)
                    {
                        if (this.isNumeric(plainArr[i]))
                        {
                            if (plainArr[i].length > 4 && plainArr[i].indexOf(",") == -1)
                            {
                                plainStr = this.toAmericanFormat(plainArr[i]);
                                input = input.split(plainArr[i]).join(plainStr);
                            }
                        }
                    }
                }
                plainText = this.stripTags(input);
                plainArr = plainText.split(" ");
                for (i = 0; i < plainArr.length; i++)
                {
                    if (this.isNumeric(plainArr[i]))
                    {
                        if (plainArr[i].indexOf(",") != -1)
                        {
                            tempArr = plainArr[i].split(",");
                            if (tempArr[1] != "")
                            {
                                tempArr.reverse();
                                input = input.split(plainArr[i]).join(tempArr.join(","));
                            }
                        }
                        if (plainArr[i].indexOf(".") != -1)
                        {
                            tempArr = plainArr[i].split(".");
                            tempArr.reverse();
                            input = input.split(plainArr[i]).join(tempArr.join(","));
                        }
                        if (plainArr[i].indexOf(":") != -1 && plainArr[i].indexOf(" : ") == -1)
                        {
                            tempArr = plainArr[i].split(":");
                            tempArr.reverse();
                            input = input.split(plainArr[i]).join(tempArr.join(":"));
                        }
                    }
                }
                i = 0;
                this.chars = input;
                this.chars = this.chars.split("\r\n").join("\n");
                if (this.tag.multiline)
                {
                    this.chars = this.chars.split("\r").join("<br />");
                    this.chars = this.chars.split("\n").join("<br />");
                    this.chars = this.properHTMLLines(this.chars);
                    this.chars = this.splitBulletList(this.chars);
                }
                else
                {
                    this.chars = this.chars.split("\r").join("");
                    this.chars = this.chars.split("\n").join("");
                }
                this.chars = this.stripDiacritics();
                if (this.hindiNumeralsOnly)
                {
                    this.chars = this.convertNumbers();
                }
                this.temp = new TextField();
                this.temp.x = -1000;
                this.temp.y = -1000;
                this.temp.width = Number(this.format.size);
                this.temp.height = Number(this.format.size) + 2;
                this.tag.parent.addChild(this.temp);
                this.temp.autoSize = TextFieldAutoSize.LEFT;
                if (this.tag.embedFonts)
                {
                    this.temp.embedFonts = true;
                }
                this.temp.selectable = false;
                this.temp.text = "";
                this.tempData = "";
                toggleHTML = false;
                toggleArabic = false;
                singleLine = [];
                multiLines = [];
                v = 0;
                e = 0;
                while (i < this.chars.length)
                {
                    if (this.chars.charAt(i - 1) == ">" && toggleHTML)
                    {
                        toggleHTML = false;
                    }
                    if (this.chars.charAt(i) == "<" && this.validateHTMLTag(i))
                    {
                        toggleHTML = true;
                    }
                    if (this.chars.charAt(i) != " ")
                    {
                        if (!this.latinOnly)
                        {
                            if (this.validateArabic(i) || this.validateSymbol(i, toggleHTML))
                            {
                                toggleArabic = true;
                            }
                            else
                            {
                                toggleArabic = false;
                            }
                        }
                    }
                    if (!toggleArabic)
                    {
                        if (arabicString.length > 0)
                        {
                            singleLine.push({
                                        "arabic": true,
                                        "html": false,
                                        "value": arabicString
                                    });
                            arabicString = "";
                        }
                    }
                    if (toggleArabic || !toggleArabic && toggleHTML)
                    {
                        if (latinString.length > 0)
                        {
                            singleLine.push({
                                        "arabic": false,
                                        "html": false,
                                        "value": latinString
                                    });
                            latinString = "";
                        }
                    }
                    if (toggleArabic || !toggleArabic && !toggleHTML)
                    {
                        if (htmlString.length > 0)
                        {
                            singleLine.push({
                                        "arabic": false,
                                        "html": true,
                                        "value": htmlString
                                    });
                            htmlString = "";
                        }
                    }
                    if (toggleArabic)
                    {
                        arabicChar = this.getCharState(i);
                        arabicChar = this.symmetricalSwapping(arabicChar, i, "rtl");
                        arabicString += arabicChar;
                        this.tempData += arabicChar;
                    }
                    else
                    {
                        latinChar = this.chars.charAt(i);
                        if (toggleHTML)
                        {
                            htmlString += latinChar;
                        }
                        else
                        {
                            latinChar = this.symmetricalSwapping(latinChar, i, "ltr");
                            latinString += latinChar;
                        }
                        this.tempData += this.chars.charAt(i);
                    }
                    this.temp.htmlText = this.getHTMLFormat(this.tempData);
                    this.temp.setTextFormat(this.format);
                    if (this.breakTextLine(i, toggleHTML))
                    {
                        if (arabicString.length > 0)
                        {
                            singleLine.push({
                                        "arabic": true,
                                        "html": false,
                                        "value": arabicString
                                    });
                            arabicString = "";
                        }
                        if (htmlString.length > 0)
                        {
                            if (this.chars.charAt(i) != ">")
                            {
                                v = i + 1;
                                while (v < this.chars.length)
                                {
                                    htmlString += this.chars.charAt(v);
                                    if (this.chars.charAt(v) == ">")
                                    {
                                        break;
                                    }
                                    v++;
                                }
                                i = v;
                            }
                            singleLine.push({
                                        "arabic": false,
                                        "html": true,
                                        "value": htmlString
                                    });
                            htmlString = "";
                        }
                        if (latinString.length > 0)
                        {
                            singleLine.push({
                                        "arabic": false,
                                        "html": false,
                                        "value": latinString
                                    });
                            latinString = "";
                        }
                        if (singleLine.length > 0)
                        {
                            multiLines.push(singleLine);
                            singleLine = [];
                        }
                        this.temp.text = "";
                        this.tempData = "";
                    }
                    i++;
                }
                this.tag.parent.removeChild(this.temp);
                if (arabicString.length > 0)
                {
                    singleLine.push({
                                "arabic": true,
                                "html": false,
                                "value": arabicString
                            });
                }
                if (htmlString.length > 0)
                {
                    singleLine.push({
                                "arabic": false,
                                "html": true,
                                "value": htmlString
                            });
                }
                if (latinString.length > 0)
                {
                    singleLine.push({
                                "arabic": false,
                                "html": false,
                                "value": latinString
                            });
                }
                if (singleLine.length > 0)
                {
                    multiLines.push(singleLine);
                }
                this.numLines = 0;
                string = "";
                for (v = 0; v < multiLines.length; v++)
                {
                    hasHTML = false;
                    for (e = 0; e < multiLines[v].length; e++)
                    {
                        if (multiLines[v][e].html)
                        {
                            hasHTML = true;
                            break;
                        }
                    }
                    if (hasHTML)
                    {
                        this.autoCompleteHTMLTags(v, multiLines);
                    }
                }
                for (v = 0; v < multiLines.length; v++)
                {
                    hasArabic = false;
                    for (e = 0; e < multiLines[v].length; e++)
                    {
                        if (multiLines[v][e].arabic)
                        {
                            hasArabic = true;
                            break;
                        }
                    }
                    if (hasArabic)
                    {
                        if (!this.isMAC || this.tag.embedFonts && this.isMAC)
                        {
                            multiLines.splice(v, 1, this.reorderTextLine(multiLines[v]));
                        }
                        else if (multiLines[v][0].arabic)
                        {
                        }
                    }
                    htmlLine = "";
                    for (e = 0; e < multiLines[v].length; e++)
                    {
                        htmlLine += multiLines[v][e].value;
                        if (multiLines[v][e].arabic)
                        {
                            string += this.reverseChars(multiLines[v][e].value);
                        }
                        else
                        {
                            baseChars = multiLines[v][e].value;
                            if (!this.latinOnly)
                            {
                                if (!this.isMAC || this.tag.embedFonts && this.isMAC)
                                {
                                    if (baseChars.charAt(baseChars.length - 1) == " " && !multiLines[v][e].html)
                                    {
                                        baseChars = " " + baseChars.substr(0, -1);
                                    }
                                }
                            }
                            string += baseChars;
                        }
                    }
                    this.htmlLines.push(htmlLine);
                    if (v < multiLines.length - 1)
                    {
                        string += "\n";
                    }
                    ++this.numLines;
                }
            }
            else
            {
                this.numLines = 1;
            }
            string = this.getHTMLFormat(string);
            string = string.split("<br />\n").join("<br />");
            plainText = this.stripTags(string);
            plainArr = plainText.split(" ");
            var arabicComma:String = String.fromCharCode(1548);
            for (i = 0; i < plainArr.length; i++)
            {
                if (this.isNumeric(this.convertBackNumbers(plainArr[i])))
                {
                    if (plainArr[i].indexOf(arabicComma) != -1)
                    {
                        tempArr = plainArr[i].split(arabicComma);
                        string = string.split(plainArr[i]).join(tempArr.join(","));
                    }
                }
            }
            return string;
        }

        public function createArabicInput(flashID:String, inputID:String, field:TextField, color:Number, bgColor:Number):void
        {
            this.tag = field;
            var c:String = "#000000";
            if (color)
            {
                c = this.getProperColor(color);
            }
            var b:String = "none";
            if (bgColor)
            {
                b = this.getProperColor(bgColor);
            }
            this.format = this.tag.getTextFormat();
            var point:Point = new Point(this.tag.x, this.tag.y);
            this.tag.localToGlobal(point);
            var type:String = "singleline";
            if (this.tag.multiline)
            {
                type = "multiline";
            }
            ExternalInterface.call("createArabicInput", flashID, inputID, this.tag.text, point.x, point.y, this.tag.width, this.tag.height, c, b, type);
        }

        public function showArabicInput():void
        {
            ExternalInterface.call("revealAllArabicInputs");
        }

        private function getProperColor(input:Number):String
        {
            var color:* = "#";
            var checker:Number = 0;
            if (input.toString(16).length < 6)
            {
                while (checker < 6 - input.toString(16).length)
                {
                    color += "0";
                    checker++;
                }
            }
            return color + input.toString(16);
        }

        private function getHTMLFormat(input:String):String
        {
            var htmlFormat:* = "<textformat leftmargin=\"" + (!!this.format.leftMargin ? this.format.leftMargin : 0) + "\" rightmargin=\"" + (!!this.format.rightMargin ? this.format.rightMargin : 0) + "\" leading=\"" + (!!this.format.leading ? this.format.leading : 0) + "\"><p align=\"" + (!!this.format.align ? this.format.align : "left") + "\"><font face=\"" + (!!this.format.font ? this.format.font : "Arial") + "\" color=\"" + (!!this.format.color ? this.getProperColor(Number(this.format.color)) : "#000000") + "\" size=\"" + (!!this.format.size ? this.format.size : 12) + "\" letterspacing=\"" + (!!this.format.letterSpacing ? this.format.letterSpacing : 0) + "\" kerning=\"" + (!!this.format.kerning ? this.format.kerning : 0) + "\">";
            if (this.format.bold)
            {
                htmlFormat += "<b>";
            }
            if (this.format.italic)
            {
                htmlFormat += "<i>";
            }
            if (this.format.underline)
            {
                htmlFormat += "<u>";
            }
            htmlFormat += input;
            if (this.format.underline)
            {
                htmlFormat += "</u>";
            }
            if (this.format.italic)
            {
                htmlFormat += "</i>";
            }
            if (this.format.bold)
            {
                htmlFormat += "</b>";
            }
            return htmlFormat + "</font></p></textformat>";
        }

        private function validateHTMLTag(i:Number):Boolean
        {
            var htmlTAG:String = "";
            var v:Number = i + 1;
            while (v < this.chars.length)
            {
                if (this.chars.charAt(v) == " " || this.chars.charAt(v) == ">")
                {
                    break;
                }
                htmlTAG += this.chars.charAt(v);
                v++;
            }
            var validHTMLTag:Boolean = false;
            for (v = 0; v < this.htmlTags.length; v++)
            {
                if (htmlTAG.toLowerCase() == this.htmlTags[v].toLowerCase() || htmlTAG.toLowerCase() == "/" + this.htmlTags[v].toLowerCase())
                {
                    validHTMLTag = true;
                    break;
                }
            }
            return validHTMLTag;
        }

        private function getHTMLOpenTag(i:Number, input:String):String
        {
            var htmlTAG:String = "";
            var toggleHTML:Boolean = false;
            var v:Number = i;
            while (v < input.length)
            {
                if (toggleHTML)
                {
                    if (input.charAt(v) == " " || input.charAt(v) == ">")
                    {
                        break;
                    }
                    htmlTAG += input.charAt(v);
                }
                if (input.charAt(v) == "<" && input.charAt(v + 1) != "/")
                {
                    toggleHTML = true;
                }
                v++;
            }
            var validHTMLOpenTag:Boolean = false;
            for (v = 0; v < this.htmlTags.length; v++)
            {
                if (htmlTAG.toLowerCase() == this.htmlTags[v].toLowerCase())
                {
                    validHTMLOpenTag = true;
                    break;
                }
            }
            if (validHTMLOpenTag)
            {
                return htmlTAG;
            }
            return "";
        }

        private function validateArabic(i:Number):Boolean
        {
            var valid:Boolean = false;
            var code:Number = Number(this.chars.charCodeAt(i));
            if (code >= 1536 && code <= 1791 || code >= 1872 && code <= 1919 || code >= 64336 && code <= 65023 || code >= 65136 && code <= 65279 || code == 8226)
            {
                valid = true;
            }
            return valid;
        }

        private function validateSymbol(i:Number, htmlOn:Boolean):Boolean
        {
            var bidirectional:Object = null;
            var valid:Boolean = false;
            var code:Number = Number(this.chars.charCodeAt(i));
            if (code >= 33 && code <= 47 || code >= 58 && code <= 63 || code >= 123 && code <= 126)
            {
                bidirectional = this.validateBiDirectional(i, htmlOn);
                if (Boolean(bidirectional.isBiDirectional) || Boolean(bidirectional.isArabic))
                {
                    valid = true;
                }
            }
            return valid;
        }

        private function validateBiDirectional(i:Number, htmlOn:Boolean):Object
        {
            var v:Number = NaN;
            var prevArabic:Boolean = false;
            var nextArabic:Boolean = false;
            var isBiDirectional:Boolean = false;
            var isArabic:Boolean = false;
            var htmlOff:Boolean = false;
            if (htmlOn)
            {
                if (i > 0)
                {
                    v = i - 1;
                    while (v >= 0)
                    {
                        if (this.chars.charAt(v) == "<" && !htmlOff)
                        {
                            htmlOff = true;
                        }
                        if (this.chars.charAt(v) != " " && htmlOff)
                        {
                            if (this.validateArabic(v))
                            {
                                prevArabic = true;
                            }
                            break;
                        }
                        v--;
                    }
                }
                htmlOff = false;
                if (i < this.chars.length)
                {
                    v = i + 1;
                    while (v <= this.chars.length)
                    {
                        if (this.chars.charAt(v) == ">" && !htmlOff)
                        {
                            htmlOff = true;
                        }
                        if (this.chars.charAt(v) != " " && htmlOff)
                        {
                            if (this.validateArabic(v))
                            {
                                nextArabic = true;
                            }
                            break;
                        }
                        v++;
                    }
                }
            }
            else
            {
                if (i > 0)
                {
                    v = i - 1;
                    while (v >= 0)
                    {
                        if (this.chars.charAt(v) != " ")
                        {
                            if (this.validateArabic(v))
                            {
                                prevArabic = true;
                            }
                            break;
                        }
                        v--;
                    }
                }
                if (i < this.chars.length)
                {
                    v = i + 1;
                    while (v <= this.chars.length)
                    {
                        if (this.chars.charAt(v) != " ")
                        {
                            if (this.validateArabic(v))
                            {
                                nextArabic = true;
                            }
                            break;
                        }
                        v++;
                    }
                }
            }
            if (!prevArabic && nextArabic || prevArabic && !nextArabic)
            {
                isBiDirectional = true;
            }
            else if (prevArabic && nextArabic)
            {
                isArabic = true;
            }
            return {
                    "isBiDirectional": isBiDirectional,
                    "isArabic": isArabic,
                    "prevArabic": prevArabic,
                    "nextArabic": nextArabic
                };
        }

        private function symmetricalSwapping(char:String, i:Number, dir:String):String
        {
            if (this.brackets.indexOf(char) != -1)
            {
                switch (dir)
                {
                    case "ltr":
                        switch (char)
                        {
                            case "<":
                                char = "&lt;";
                                break;
                            case ">":
                                char = "&gt;";
                        }
                        break;
                    case "rtl":
                        switch (char)
                        {
                            case "(":
                                char = ")";
                                break;
                            case ")":
                                char = "(";
                                break;
                            case "{":
                                char = "}";
                                break;
                            case "}":
                                char = "{";
                                break;
                            case "[":
                                char = "]";
                                break;
                            case "]":
                                char = "[";
                                break;
                            case "<":
                                if (!this.isMAC || this.tag.embedFonts && this.isMAC)
                                {
                                    char = ";tg&";
                                }
                                else
                                {
                                    char = "&gt;";
                                }
                                break;
                            case ">":
                                if (!this.isMAC || this.tag.embedFonts && this.isMAC)
                                {
                                    char = ";tl&";
                                }
                                else
                                {
                                    char = "&lt;";
                                }
                                break;
                            case "«":
                                char = "»";
                                break;
                            case "»":
                                char = "«";
                        }
                }
            }
            return char;
        }

        private function breakTextLine(i:Number, htmlOn:Boolean):Boolean
        {
            var htmlOff:Boolean = false;
            var initHTML:String = null;
            var v:Number = NaN;
            var measureLine:Boolean = false;
            var metrics:TextLineMetrics = null;
            var isNewLine:Boolean = false;
            if (this.tag.multiline && this.chars.charAt(i) == " ")
            {
                htmlOff = false;
                initHTML = this.tempData;
                v = i + 1;
                while (v < this.chars.length)
                {
                    initHTML += this.chars.charAt(v);
                    if (htmlOn)
                    {
                        if (this.chars.charAt(v) == ">")
                        {
                            if (this.chars.charAt(v - 5) == "<" && this.chars.charAt(v - 4) == "b" && this.chars.charAt(v - 3) == "r" && this.chars.charAt(v - 2) == " " && this.chars.charAt(v - 1) == "/")
                            {
                                isNewLine = true;
                                break;
                            }
                            htmlOff = true;
                        }
                    }
                    else
                    {
                        htmlOff = true;
                    }
                    if (this.chars.charAt(v) == " " && htmlOff)
                    {
                        break;
                    }
                    v++;
                }
                if (!isNewLine)
                {
                    this.temp.htmlText = this.getHTMLFormat(initHTML);
                    measureLine = false;
                    if (this.isMAC)
                    {
                        metrics = this.temp.getLineMetrics(0);
                        if (metrics.width >= this.tag.width * this.wrapFactor - (!!this.format.leftMargin ? Number(this.format.leftMargin) : 0) - (!!this.format.rightMargin ? Number(this.format.rightMargin) : 0))
                        {
                            measureLine = true;
                        }
                    }
                    else if (Math.ceil(this.temp.width) >= this.tag.width * this.wrapFactor - (!!this.format.leftMargin ? Number(this.format.leftMargin) : 0) - (!!this.format.rightMargin ? Number(this.format.rightMargin) : 0))
                    {
                        measureLine = true;
                    }
                    if (measureLine)
                    {
                        isNewLine = true;
                    }
                    else
                    {
                        this.temp.htmlText = this.getHTMLFormat(this.tempData);
                    }
                }
            }
            return isNewLine;
        }

        private function autoCompleteHTMLTags(index:Number, lines:Array):*
        {
            var prevLine:Array = null;
            var currentLine:Array = null;
            var openTag:String = null;
            var closeTag:String = null;
            var closeTags:Array = null;
            var toggleCloseTag:Boolean = false;
            var i:Number = NaN;
            var v:Number = NaN;
            var openIndex:Number = NaN;
            var closeIndex:Number = NaN;
            var validCloseTags:Array = null;
            var indexA:Number = NaN;
            var indexB:Number = NaN;
            var tempTag:Object = null;
            if (index > 0)
            {
                prevLine = lines[index - 1];
                currentLine = lines[index];
                openTag = "";
                closeTag = "";
                closeTags = [];
                toggleCloseTag = false;
                for (i = 0; i < currentLine.length; i++)
                {
                    if (Boolean(currentLine[i].html) && currentLine[i].value.indexOf("</") != -1)
                    {
                        v = 0;
                        while (v < currentLine[i].value.length)
                        {
                            if (currentLine[i].value.charAt(v - 2) == "<" && currentLine[i].value.charAt(v - 1) == "/")
                            {
                                toggleCloseTag = true;
                                closeTag = "";
                            }
                            if (toggleCloseTag)
                            {
                                if (currentLine[i].value.charAt(v) == ">")
                                {
                                    if (closeTag.length > 0)
                                    {
                                        closeTags.push(closeTag.toLowerCase());
                                    }
                                    toggleCloseTag = false;
                                }
                                else
                                {
                                    closeTag += currentLine[i].value.charAt(v);
                                }
                            }
                            v++;
                        }
                    }
                }
                validCloseTags = [];
                if (closeTags.length > 0)
                {
                    for (v = 0; v < closeTags.length; v++)
                    {
                        openIndex = -1;
                        for (i = 0; i < currentLine.length; i++)
                        {
                            if (currentLine[i].html)
                            {
                                if (currentLine[i].value.indexOf("<" + closeTags[v] + " ") != -1)
                                {
                                    openIndex = i;
                                }
                                else if (currentLine[i].value.indexOf("</" + closeTags[v] + ">") != -1)
                                {
                                    closeIndex = i;
                                }
                            }
                        }
                        if (openIndex == -1 || closeIndex < openIndex)
                        {
                            validCloseTags.push(closeTags[v]);
                        }
                    }
                    if (validCloseTags.length > 0)
                    {
                        for (v = 0; v < validCloseTags.length; v++)
                        {
                            for (i = prevLine.length - 1; i > 0; i--)
                            {
                                if (Boolean(prevLine[i].html) && prevLine[i].value.toLowerCase().indexOf("<" + validCloseTags[v] + " ") != -1)
                                {
                                    indexA = Number(prevLine[i].value.toLowerCase().lastIndexOf("<" + validCloseTags[v] + " "));
                                    indexB = indexA;
                                    while (indexB < prevLine[i].value.length)
                                    {
                                        if (prevLine[i].value.charAt(indexB) == ">")
                                        {
                                            break;
                                        }
                                        indexB++;
                                    }
                                    openTag = prevLine[i].value.substring(indexA, indexB + 1);
                                }
                            }
                            if (openTag.length > 0)
                            {
                                if (prevLine[prevLine.length - 1].html)
                                {
                                    tempTag = prevLine.pop();
                                    tempTag.value += "</" + validCloseTags[v] + ">";
                                }
                                else
                                {
                                    tempTag = {
                                            "arabic": false,
                                            "html": true,
                                            "value": "</" + validCloseTags[v] + ">"
                                        };
                                }
                                prevLine.push(tempTag);
                                if (currentLine[0].html)
                                {
                                    tempTag = currentLine.shift();
                                    tempTag.value = openTag + tempTag.value;
                                }
                                else
                                {
                                    tempTag = {
                                            "arabic": false,
                                            "html": true,
                                            "value": openTag
                                        };
                                }
                                currentLine.unshift(tempTag);
                            }
                        }
                    }
                }
            }
        }

        private function reorderTextLine(line:Array):Array
        {
            var tempElement:Object = null;
            var elements:Array = [];
            var htmlElement:Array = [];
            var tempElements:Array = [];
            var openTag:String = "";
            var toggleHTML:Boolean = false;
            var i:Number = 0;
            var v:Number = 0;
            var e:Number = 0;
            var index:Number = 0;
            while (i < line.length)
            {
                if (line[i].html)
                {
                    if (openTag == "")
                    {
                        v = 0;
                        while (v < line[i].value.length)
                        {
                            openTag = this.getHTMLOpenTag(v, line[i].value);
                            if (openTag != "")
                            {
                                toggleHTML = true;
                                break;
                            }
                            v++;
                        }
                    }
                    else
                    {
                        v = 0;
                        while (v < line[i].value.length)
                        {
                            if (line[i].value.indexOf("</" + openTag + ">") != -1)
                            {
                                openTag = "";
                                toggleHTML = false;
                                break;
                            }
                            v++;
                        }
                    }
                }
                if (toggleHTML)
                {
                    htmlElement.push(line[i]);
                }
                else if (htmlElement.length > 0)
                {
                    htmlElement.push(line[i]);
                    for (v = 0; v < htmlElement.length; v++)
                    {
                        if (!htmlElement[v].html)
                        {
                            tempElements.push(htmlElement[v]);
                        }
                    }
                    tempElements.reverse();
                    index = 0;
                    for (v = 0; v < htmlElement.length; v++)
                    {
                        if (!htmlElement[v].html)
                        {
                            htmlElement.splice(v, 1, tempElements[index]);
                            index++;
                        }
                    }
                    tempElements = [];
                    elements.push(htmlElement);
                    htmlElement = [];
                }
                else
                {
                    elements.push([line[i]]);
                }
                i++;
            }
            elements.reverse();
            var newLine:Array = [];
            for (i = 0; i < elements.length; i++)
            {
                for (v = 0; v < elements[i].length; v++)
                {
                    newLine.push(elements[i][v]);
                }
            }
            return newLine;
        }

        private function reverseChars(input:String):String
        {
            var chars:Array = input.split("");
            if (!this.isMAC || this.tag.embedFonts && this.isMAC)
            {
                chars.reverse();
            }
            return chars.join("");
        }

        private function properHTMLLines(input:String):String
        {
            if (this.tag.multiline)
            {
                if (input.indexOf("<BR />") != -1)
                {
                    input = input.split("<BR />").join("<br />");
                }
                if (input.indexOf("<bR />") != -1)
                {
                    input = input.split("<bR />").join("<br />");
                }
                if (input.indexOf("<Br />") != -1)
                {
                    return input.split("<Br />").join("<br />");
                }
                if (input.indexOf("<BR>") != -1)
                {
                    input = input.split("<BR>").join("<br />");
                }
                if (input.indexOf("<br>") != -1)
                {
                    input = input.split("<br>").join("<br />");
                }
                if (input.indexOf("<bR>") != -1)
                {
                    input = input.split("<bR>").join("<br />");
                }
                if (input.indexOf("<Br>") != -1)
                {
                    input = input.split("<Br>").join("<br />");
                }
            }
            return input;
        }

        private function splitBulletList(input:String):String
        {
            if (this.tag.multiline)
            {
                if (input.indexOf("<UL>") != -1)
                {
                    input = input.split("<UL>").join("");
                }
                if (input.indexOf("<Ul>") != -1)
                {
                    input = input.split("<Ul>").join("");
                }
                if (input.indexOf("<uL>") != -1)
                {
                    input = input.split("<uL>").join("");
                }
                if (input.indexOf("<ul>") != -1)
                {
                    input = input.split("<ul>").join("");
                }
                if (input.indexOf("</UL>") != -1)
                {
                    input = input.split("</UL>").join("<br />");
                }
                if (input.indexOf("</Ul>") != -1)
                {
                    input = input.split("</Ul>").join("<br />");
                }
                if (input.indexOf("</uL>") != -1)
                {
                    input = input.split("</uL>").join("<br />");
                }
                if (input.indexOf("</ul>") != -1)
                {
                    input = input.split("</ul>").join("<br />");
                }
                if (input.indexOf("<LI>") != -1)
                {
                    input = input.split("<LI>").join("<br /> • ");
                }
                if (input.indexOf("<Li>") != -1)
                {
                    input = input.split("<Li>").join("<br /> • ");
                }
                if (input.indexOf("<lI>") != -1)
                {
                    input = input.split("<lI>").join("<br /> • ");
                }
                if (input.indexOf("<li>") != -1)
                {
                    input = input.split("<li>").join("<br /> • ");
                }
                if (input.indexOf("</LI>") != -1)
                {
                    input = input.split("</LI>").join("");
                }
                if (input.indexOf("</Li>") != -1)
                {
                    input = input.split("</Li>").join("");
                }
                if (input.indexOf("</lI>") != -1)
                {
                    input = input.split("</lI>").join("");
                }
                if (input.indexOf("</li>") != -1)
                {
                    input = input.split("</li>").join("");
                }
            }
            return input;
        }

        private function validateArabicChar(i:Number):Boolean
        {
            var code:Number = NaN;
            var valid:Boolean = false;
            if (i >= 0 && i < this.chars.length)
            {
                code = Number(this.chars.charCodeAt(i));
                if (code >= 1570 && code <= 1594 || code >= 1600 && code <= 1610 || code >= 65154 && code <= 65276)
                {
                    valid = true;
                }
            }
            return valid;
        }

        private function getCharState(i:Number):String
        {
            var string:String = null;
            switch (this.chars.charAt(i))
            {
                case "ا":
                    string = this.setChar(i, String.fromCharCode(1575), String.fromCharCode(1575), String.fromCharCode(65166), String.fromCharCode(65166));
                    break;
                case "أ":
                    string = this.setChar(i, String.fromCharCode(1571), String.fromCharCode(1571), String.fromCharCode(65156), String.fromCharCode(65156));
                    break;
                case "إ":
                    string = this.setChar(i, String.fromCharCode(1573), String.fromCharCode(1573), String.fromCharCode(65160), String.fromCharCode(65160));
                    break;
                case "آ":
                    string = this.setChar(i, String.fromCharCode(1570), String.fromCharCode(1570), String.fromCharCode(65154), String.fromCharCode(65154));
                    break;
                case "ب":
                    string = this.setChar(i, String.fromCharCode(1576), String.fromCharCode(65169), String.fromCharCode(65170), String.fromCharCode(65168));
                    break;
                case "ت":
                    string = this.setChar(i, String.fromCharCode(1578), String.fromCharCode(65175), String.fromCharCode(65176), String.fromCharCode(65174));
                    break;
                case "ث":
                    string = this.setChar(i, String.fromCharCode(1579), String.fromCharCode(65179), String.fromCharCode(65180), String.fromCharCode(65178));
                    break;
                case "ج":
                    string = this.setChar(i, String.fromCharCode(1580), String.fromCharCode(65183), String.fromCharCode(65184), String.fromCharCode(65182));
                    break;
                case "ح":
                    string = this.setChar(i, String.fromCharCode(1581), String.fromCharCode(65187), String.fromCharCode(65188), String.fromCharCode(65186));
                    break;
                case "خ":
                    string = this.setChar(i, String.fromCharCode(1582), String.fromCharCode(65191), String.fromCharCode(65192), String.fromCharCode(65190));
                    break;
                case "د":
                    string = this.setChar(i, String.fromCharCode(1583), String.fromCharCode(1583), String.fromCharCode(65194), String.fromCharCode(65194));
                    break;
                case "ذ":
                    string = this.setChar(i, String.fromCharCode(1584), String.fromCharCode(1584), String.fromCharCode(65196), String.fromCharCode(65196));
                    break;
                case "ر":
                    string = this.setChar(i, String.fromCharCode(1585), String.fromCharCode(1585), String.fromCharCode(65198), String.fromCharCode(65198));
                    break;
                case "ز":
                    string = this.setChar(i, String.fromCharCode(1586), String.fromCharCode(1586), String.fromCharCode(65200), String.fromCharCode(65200));
                    break;
                case "س":
                    string = this.setChar(i, String.fromCharCode(1587), String.fromCharCode(65203), String.fromCharCode(65204), String.fromCharCode(65202));
                    break;
                case "ش":
                    string = this.setChar(i, String.fromCharCode(1588), String.fromCharCode(65207), String.fromCharCode(65208), String.fromCharCode(65206));
                    break;
                case "ص":
                    string = this.setChar(i, String.fromCharCode(1589), String.fromCharCode(65211), String.fromCharCode(65212), String.fromCharCode(65210));
                    break;
                case "ض":
                    string = this.setChar(i, String.fromCharCode(1590), String.fromCharCode(65215), String.fromCharCode(65216), String.fromCharCode(65214));
                    break;
                case "ط":
                    string = this.setChar(i, String.fromCharCode(1591), String.fromCharCode(65219), String.fromCharCode(65220), String.fromCharCode(65218));
                    break;
                case "ظ":
                    string = this.setChar(i, String.fromCharCode(1592), String.fromCharCode(65223), String.fromCharCode(65224), String.fromCharCode(65222));
                    break;
                case "ع":
                    string = this.setChar(i, String.fromCharCode(1593), String.fromCharCode(65227), String.fromCharCode(65228), String.fromCharCode(65226));
                    break;
                case "غ":
                    string = this.setChar(i, String.fromCharCode(1594), String.fromCharCode(65231), String.fromCharCode(65232), String.fromCharCode(65230));
                    break;
                case "ف":
                    string = this.setChar(i, String.fromCharCode(1601), String.fromCharCode(65235), String.fromCharCode(65236), String.fromCharCode(65234));
                    break;
                case "ق":
                    string = this.setChar(i, String.fromCharCode(1602), String.fromCharCode(65239), String.fromCharCode(65240), String.fromCharCode(65238));
                    break;
                case "ك":
                    string = this.setChar(i, String.fromCharCode(1603), String.fromCharCode(65243), String.fromCharCode(65244), String.fromCharCode(65242));
                    break;
                case "ل":
                    string = this.setChar(i, String.fromCharCode(1604), String.fromCharCode(65247), String.fromCharCode(65248), String.fromCharCode(65246));
                    break;
                case "م":
                    string = this.setChar(i, String.fromCharCode(1605), String.fromCharCode(65251), String.fromCharCode(65252), String.fromCharCode(65250));
                    break;
                case "ن":
                    string = this.setChar(i, String.fromCharCode(1606), String.fromCharCode(65255), String.fromCharCode(65256), String.fromCharCode(65254));
                    break;
                case "ه":
                    string = this.setChar(i, String.fromCharCode(1607), String.fromCharCode(65259), String.fromCharCode(65260), String.fromCharCode(65258));
                    break;
                case "ة":
                    string = this.setChar(i, String.fromCharCode(1577), "", "", String.fromCharCode(65172));
                    break;
                case "و":
                    string = this.setChar(i, String.fromCharCode(1608), String.fromCharCode(1608), String.fromCharCode(65262), String.fromCharCode(65262));
                    break;
                case "ؤ":
                    string = this.setChar(i, String.fromCharCode(1572), String.fromCharCode(1572), String.fromCharCode(65158), String.fromCharCode(65158));
                    break;
                case "ى":
                    string = this.setChar(i, String.fromCharCode(1609), String.fromCharCode(1609), String.fromCharCode(65264), String.fromCharCode(65264));
                    break;
                case "ي":
                    string = this.setChar(i, String.fromCharCode(1610), String.fromCharCode(65267), String.fromCharCode(65268), String.fromCharCode(65266));
                    break;
                case "ئ":
                    string = this.setChar(i, String.fromCharCode(1574), String.fromCharCode(65163), String.fromCharCode(65164), String.fromCharCode(65162));
                    break;
                case "ء":
                    string = String.fromCharCode(1569);
                    break;
                case "ـ":
                    string = String.fromCharCode(1600);
                    break;
                case "?":
                    string = String.fromCharCode(1567);
                    break;
                case ",":
                    string = String.fromCharCode(1548);
                    break;
                case ";":
                    string = String.fromCharCode(1563);
                    break;
                case "%":
                    string = String.fromCharCode(1642);
                    break;
                default:
                    string = this.chars.charAt(i);
            }
            return string;
        }

        private function setChar(i:Number, solo:String, begin:String, middle:String, end:String):String
        {
            var string:String = "";
            if (this.chars.charAt(i) == "ل" && this.chars.charAt(i + 1) == "ا")
            {
                if (this.validateArabicChar(i - 1) && this.specialChars.indexOf(this.chars.charAt(i - 1)) == -1)
                {
                    string = String.fromCharCode(65276);
                }
                else
                {
                    string = String.fromCharCode(65275);
                }
                this.chars = this.chars.substring(0, i) + string + this.chars.substring(i + 2, this.chars.length);
            }
            else if (this.chars.charAt(i) == "ل" && this.chars.charAt(i + 1) == "أ")
            {
                if (this.validateArabicChar(i - 1) && this.specialChars.indexOf(this.chars.charAt(i - 1)) == -1)
                {
                    string = String.fromCharCode(65272);
                }
                else
                {
                    string = String.fromCharCode(65271);
                }
                this.chars = this.chars.substring(0, i) + string + this.chars.substring(i + 2, this.chars.length);
            }
            else if (this.chars.charAt(i) == "ل" && this.chars.charAt(i + 1) == "إ")
            {
                if (this.validateArabicChar(i - 1) && this.specialChars.indexOf(this.chars.charAt(i - 1)) == -1)
                {
                    string = String.fromCharCode(65274);
                }
                else
                {
                    string = String.fromCharCode(65273);
                }
                this.chars = this.chars.substring(0, i) + string + this.chars.substring(i + 2, this.chars.length);
            }
            else if (this.chars.charAt(i) == "ل" && this.chars.charAt(i + 1) == "آ")
            {
                if (this.validateArabicChar(i - 1) && this.specialChars.indexOf(this.chars.charAt(i - 1)) == -1)
                {
                    string = String.fromCharCode(65270);
                }
                else
                {
                    string = String.fromCharCode(65269);
                }
                this.chars = this.chars.substring(0, i) + string + this.chars.substring(i + 2, this.chars.length);
            }
            else if (i == 0)
            {
                if (this.specialChars.indexOf(this.chars.charAt(i)) != -1 || !this.validateArabicChar(i + 1))
                {
                    string = solo;
                }
                else
                {
                    string = begin;
                }
            }
            else if (i == this.chars.length - 1)
            {
                if (this.specialChars.indexOf(this.chars.charAt(i - 1)) != -1 || !this.validateArabicChar(i - 1))
                {
                    string = solo;
                }
                else
                {
                    string = end;
                }
            }
            else if (this.validateArabicChar(i - 1) && this.validateArabicChar(i + 1))
            {
                if (this.specialChars.indexOf(this.chars.charAt(i - 1)) != -1)
                {
                    if (this.specialChars.indexOf(this.chars.charAt(i)) != -1)
                    {
                        string = solo;
                    }
                    else
                    {
                        string = begin;
                    }
                }
                else if (this.specialChars.indexOf(this.chars.charAt(i)) != -1 || this.chars.charAt(i + 1) == "ء" || this.chars.charAt(i) == "ة")
                {
                    if (this.chars.charAt(i - 1) != "ة")
                    {
                        string = end;
                    }
                    else
                    {
                        string = begin;
                    }
                }
                else if (this.chars.charAt(i - 1) != "ة")
                {
                    string = middle;
                }
                else
                {
                    string = begin;
                }
            }
            else if (this.validateArabicChar(i - 1) && !this.validateArabicChar(i + 1))
            {
                if (this.specialChars.indexOf(this.chars.charAt(i - 1)) != -1)
                {
                    string = solo;
                }
                else
                {
                    string = end;
                }
            }
            else if (!this.validateArabicChar(i - 1) && this.validateArabicChar(i + 1))
            {
                if (this.specialChars.indexOf(this.chars.charAt(i)) != -1)
                {
                    string = solo;
                }
                else
                {
                    string = begin;
                }
            }
            else if (!this.validateArabicChar(i - 1) && !this.validateArabicChar(i + 1))
            {
                string = solo;
            }
            return string;
        }

        private function stripDiacritics():String
        {
            var string:String = "";
            var i:Number = 0;
            while (i < this.chars.length)
            {
                if (this.chars.charCodeAt(i) < 1611 || this.chars.charCodeAt(i) > 1618)
                {
                    string += this.chars.charAt(i);
                }
                i++;
            }
            return string;
        }

        private function convertNumbers():String
        {
            var v:Number = NaN;
            var string:String = "";
            var toggleHTML:Boolean = false;
            var tempNumber:Array = [];
            var reversedNumber:String = "";
            var i:Number = 0;
            while (i < this.chars.length)
            {
                if (this.chars.charAt(i - 1) == ">" && toggleHTML)
                {
                    toggleHTML = false;
                }
                if (this.chars.charAt(i) == "<" && this.validateHTMLTag(i))
                {
                    toggleHTML = true;
                }
                if (!toggleHTML)
                {
                    switch (this.chars.charAt(i))
                    {
                        case "0":
                            string += String.fromCharCode(1632);
                            break;
                        case "1":
                            string += String.fromCharCode(1633);
                            break;
                        case "2":
                            string += String.fromCharCode(1634);
                            break;
                        case "3":
                            string += String.fromCharCode(1635);
                            break;
                        case "4":
                            string += String.fromCharCode(1636);
                            break;
                        case "5":
                            string += String.fromCharCode(1637);
                            break;
                        case "6":
                            string += String.fromCharCode(1638);
                            break;
                        case "7":
                            string += String.fromCharCode(1639);
                            break;
                        case "8":
                            string += String.fromCharCode(1640);
                            break;
                        case "9":
                            string += String.fromCharCode(1641);
                            break;
                        default:
                            string += this.chars.charAt(i);
                    }
                }
                else
                {
                    string += this.chars.charAt(i);
                }
                if (string.charCodeAt(i) >= 1632 && string.charCodeAt(i) <= 1641)
                {
                    tempNumber.push({
                                "index": i,
                                "char": string.charAt(i)
                            });
                }
                else
                {
                    if (tempNumber.length > 0)
                    {
                        reversedNumber = "";
                        for (v = tempNumber.length - 1; v >= 0; v--)
                        {
                            reversedNumber += tempNumber[v].char;
                        }
                        string = string.slice(0, tempNumber[0].index) + reversedNumber + string.slice(tempNumber[tempNumber.length - 1].index + 1, string.length);
                    }
                    tempNumber = [];
                }
                i++;
            }
            if (tempNumber.length > 0)
            {
                reversedNumber = "";
                for (v = tempNumber.length - 1; v >= 0; v--)
                {
                    reversedNumber += tempNumber[v].char;
                }
                string = string.slice(0, tempNumber[0].index) + reversedNumber + string.slice(tempNumber[tempNumber.length - 1].index + 1, string.length);
            }
            return string;
        }

        private function stripTags(input:String):String
        {
            return input.replace(/<.*?>/g, " ");
        }

        private function isNumeric(num:String):Boolean
        {
            return !isNaN(parseInt(num));
        }

        private function convertBackNumbers(input:String):String
        {
            var string:* = "";
            var i:Number = 0;
            while (i < input.length)
            {
                switch (input.charAt(i))
                {
                    case "٠":
                        string += "0";
                        break;
                    case "١":
                        string += "1";
                        break;
                    case "٢":
                        string += "2";
                        break;
                    case "٣":
                        string += "3";
                        break;
                    case "٤":
                        string += "4";
                        break;
                    case "٥":
                        string += "5";
                        break;
                    case "٦":
                        string += "6";
                        break;
                    case "٧":
                        string += "7";
                        break;
                    case "٨":
                        string += "8";
                        break;
                    case "٩":
                        string += "9";
                        break;
                    default:
                        string += input.charAt(i);
                        break;
                }
                i++;
            }
            return string;
        }

        private function toAmericanFormat(number:String):String
        {
            // this may not be correct
            return number.replace(number.indexOf(".") > -1 ? "/(?<=d)(?=(ddd)+(?!d)(?:.d*))/g" : /(?<=\d)(?=(\d\d\d)+(?!\d))/g, ",").replace(/,{2,}/g, ",");
        }
    }
}
