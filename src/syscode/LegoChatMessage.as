package syscode
{
    import flash.display.MovieClip;
    import flash.globalization.DateTimeFormatter;
    import flash.text.TextField;

    internal class LegoChatMessage
    {
        public function LegoChatMessage(acb:LegoChatMessageBuffer, tag:Object)
        {
            var Game:Object = null;
            var fromid:* = undefined;
            super();
            this.cb = acb;
            if (tag.FROM)
            {
                Game = Modules.GetClass("triviador", "triviador.Game");
                fromid = Util.NumberVal(tag.FROM);
                this.userid = Util.StringVal(Game.players[fromid].id);
                this.username = Util.StringVal(Game.players[fromid].name);
            }
            else
            {
                this.userid = Util.StringVal(tag.UID);
                this.username = Util.StringVal(tag.NAME);
            }
            this.timestamp = Util.NumberVal(tag.TS);
            this.message = Util.StringVal(tag.MSG);
            this.uuid = Util.StringVal(tag.UUID);
            this.hidden = false;
            this.event = Util.StringVal(tag.EVENT) != "";
            this.signup = Util.StringVal(tag.EVENT) == "signup";
            this.fg = Util.NumberVal(tag.FG) != 0;
            this.fgcode = Util.StringVal(tag.FGCODE);
            this.odd = this.cb.oddline;
            this.userchange = this.cb.lastuserid != this.userid || this.event != this.cb.lastisevent;
            if (this.cb.clanchat)
            {
                this.formattedmsg = this.FormatClanMessage();
            }
            else
            {
                this.formattedmsg = this.FormatMessage();
            }
        }
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

        public function FormatMessage():String
        {
            var arr:Array = null;
            var time_s:* = undefined;
            var name_s:* = undefined;
            var sep:* = undefined;
            var rtlhint:* = undefined;
            var rtlhintsp:* = undefined;
            var d:* = new Date();
            d.setTime(1000 * this.timestamp);
            var df:* = new DateTimeFormatter("");
            df.setDateTimePattern("HH:mm");
            this.timestampstr = df.format(d);
            var s:String = "";
            if (this.message == "TIMESTAMP")
            {
                return this.message;
            }
            if (this.userid == "-1")
            {
                s = this.message;
                arr = this.message.split("|");
                if (arr[0] == "1")
                {
                    s = Lang.Get("user_x_entered", arr[1]);
                }
                else if (arr[0] == "2")
                {
                    s = Lang.Get("user_x_exited", arr[1]);
                }
                this.username = "";
                s = (!!this.timestamp ? this.timestampstr + " " : "") + s;
            }
            else
            {
                time_s = "<font size=\"12\">" + this.timestampstr + "</font>";
                name_s = "";
                sep = "";
                if (this.userchange)
                {
                    sep = ":";
                    name_s += Romanization.ToLatin(Util.StrXmlSafe(this.username));
                }
                if (Config.rtl)
                {
                    rtlhint = String.fromCharCode(1544);
                    rtlhintsp = rtlhint + " ";
                    s = rtlhint + "<font color=\"#FFFFFF\" size=\"18\"> __ </font>" + (!!this.timestamp ? time_s + " " : "") + rtlhintsp + name_s + sep + " " + rtlhintsp + Util.StrXmlSafe(this.message);
                }
                else if (this.userid == Sys.mydata.id)
                {
                    s = Util.StrXmlSafe(this.message) + (!!this.timestamp ? " " + time_s : "");
                }
                else
                {
                    s = (!!this.timestamp ? time_s + " " : "") + name_s + sep + " " + Util.StrXmlSafe(this.message);
                }
            }
            return s;
        }

        public function FormatClanMessage():String
        {
            var arr:Array = null;
            var time_s:* = undefined;
            var name_s:* = undefined;
            var sep:* = undefined;
            var rtlhint:* = undefined;
            var rtlhintsp:* = undefined;
            var d:* = new Date();
            d.setTime(1000 * this.timestamp);
            var df:* = new DateTimeFormatter("");
            df.setDateTimePattern("HH:mm");
            this.timestampstr = df.format(d);
            var s:String = "";
            var fc:String = "#000000";
            if (this.userid == "-1" || Boolean(this.fgcode))
            {
                s = this.message;
                arr = this.message.split("|");
                if (arr[0] == "1")
                {
                    s = Lang.Get("user_x_entered", arr[1]);
                }
                else if (arr[0] == "2")
                {
                    s = Lang.Get("user_x_exited", arr[1]);
                }
                this.username = "";
                s = (!!this.timestamp ? this.timestampstr + " " : "") + s;
            }
            else
            {
                time_s = "<font size=\"12\">" + this.timestampstr + "</font>";
                name_s = "";
                sep = "";
                if (this.userchange)
                {
                    sep = "\n";
                    name_s += "<b>" + Romanization.ToLatin(Util.StrXmlSafe(this.username)) + "</b>";
                }
                if (Config.rtl)
                {
                    rtlhint = String.fromCharCode(1544);
                    rtlhintsp = rtlhint + " ";
                    s = rtlhint + "<font color=\"#FFFFFF\" size=\"18\"> __ </font>" + (!!this.timestamp ? time_s + " " : "") + rtlhintsp + name_s + sep + " " + rtlhintsp + Util.StrXmlSafe(this.message);
                }
                else
                {
                    s = name_s + (Boolean(this.timestamp) && this.userchange ? " " + time_s : "") + sep + Util.StrXmlSafe(this.message);
                }
            }
            return s;
        }

        public function CalculateLineCount(prototypemov:MovieClip):Number
        {
            var textfield:TextField = prototypemov.TEXT is TextField ? prototypemov.TEXT : prototypemov.TEXT.FIELD;
            textfield.htmlText = this.formattedmsg;
            this.height = 40;
            if (this.signup)
            {
                this.height = 80;
            }
            return textfield.numLines;
        }
    }
}
