package syscode
{
    import flash.display.MovieClip;
    import flash.globalization.DateTimeFormatter;

    internal class ChatMessage
    {
        public function ChatMessage(acb:ChatMessageBuffer, tag:Object)
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
            this.event = Util.StringVal(tag.EVENT);
            this.signup = Util.StringVal(tag.EVENT) == "signup";
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

        public function FormatMessage():String
        {
            var arr:Array = null;
            var time_s:* = undefined;
            var name_s:* = undefined;
            var sep:* = undefined;
            var rtlhint:* = undefined;
            var rtlhintsp:* = undefined;
            DBG.Trace("ChatMessage.FormatMessage");
            var d:* = new Date();
            d.setTime(1000 * this.timestamp);
            var df:* = new DateTimeFormatter("");
            df.setDateTimePattern("HH:mm");
            this.timestampstr = df.format(d);
            var s:* = "";
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
                s = "<font color=\"#FF8822\">" + (!!this.timestamp ? this.timestampstr + " " : "") + s + "</font>";
            }
            else
            {
                time_s = "<font color=\"#998877\" size=\"12\">" + this.timestampstr + "</font>";
                name_s = "";
                sep = "";
                if (this.userchange)
                {
                    sep = ":";
                    if (this.userid == Sys.mydata.id)
                    {
                        name_s += "<b><font color=\"#AA1100\">" + Romanization.ToLatin(Util.StrXmlSafe(this.username)) + "</font></b>";
                    }
                    else
                    {
                        name_s += "<font color=\"#EE5500\">" + Romanization.ToLatin(Util.StrXmlSafe(this.username)) + "</font>";
                    }
                }
                if (Config.rtl)
                {
                    rtlhint = String.fromCharCode(1544);
                    rtlhintsp = rtlhint + " ";
                    s = rtlhint + "<font color=\"#FFFFFF\" size=\"18\"> __ </font>" + (!!this.timestamp ? time_s + " " : "") + rtlhintsp + name_s + sep + " " + rtlhintsp + "<font color=\"#660000\" size=\"18\">" + Util.StrXmlSafe(this.message) + "</font>";
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
            DBG.Trace("ChatMessage.FormatClanMessage");
            var d:* = new Date();
            d.setTime(1000 * this.timestamp);
            var df:* = new DateTimeFormatter("");
            df.setDateTimePattern("HH:mm");
            this.timestampstr = df.format(d);
            var s:* = "";
            var fc:String = "#000000";
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
                s = "<font color=\"#FF8822\">" + (!!this.timestamp ? this.timestampstr + " " : "") + s + "</font>";
            }
            else
            {
                time_s = "<font color=\"#998877\" size=\"12\">" + this.timestampstr + "</font>";
                name_s = "";
                sep = "";
                if (this.userchange)
                {
                    sep = "\n";
                    if (this.userid == Sys.mydata.id)
                    {
                        name_s += "<b><font color=\"#7e5115\">" + Romanization.ToLatin(Util.StrXmlSafe(this.username)) + "</font></b>";
                    }
                    else
                    {
                        name_s += "<b><font color=\"#007171\">" + Romanization.ToLatin(Util.StrXmlSafe(this.username)) + "</font></b>";
                    }
                }
                if (this.event)
                {
                    fc = "#165a00";
                }
                else if (this.userid == Sys.mydata.id)
                {
                    fc = "#7e5115";
                }
                else
                {
                    fc = "#007171";
                }
                if (Config.rtl)
                {
                    rtlhint = String.fromCharCode(1544);
                    rtlhintsp = rtlhint + " ";
                    s = rtlhint + "<font color=\"#FFFFFF\" size=\"18\"> __ </font>" + (!!this.timestamp ? time_s + " " : "") + rtlhintsp + name_s + sep + " " + rtlhintsp + "<font color=\"#660000\" size=\"18\">" + Util.StrXmlSafe(this.message) + "</font>";
                }
                else
                {
                    s = name_s + (Boolean(this.timestamp) && this.userchange ? " " + time_s : "") + sep + "<font color=\"" + fc + "\" >" + Util.StrXmlSafe(this.message) + "</font>";
                }
            }
            return s;
        }

        public function CalculateHeight(prototypemov:MovieClip):Number
        {
            prototypemov.TEXT.htmlText = this.formattedmsg;
            this.height = prototypemov.TEXT.numLines > 1 ? prototypemov.TEXT.textHeight + 4 : this.cb.default_line_height;
            if (this.signup)
            {
                this.height = 90;
            }
            return this.height;
        }
    }
}
