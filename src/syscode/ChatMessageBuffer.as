package syscode
{
    import flash.display.*;
    import flash.globalization.DateTimeFormatter;

    public class ChatMessageBuffer
    {
        public function ChatMessageBuffer()
        {
            this.allmsg = new Vector.<ChatMessage>();
            this.pool = [];
            super();
            for (var i:* = 1; i <= this.num; i++)
            {
                this.pool[i] = -1;
            }
        }
        public var allmsg:Vector.<ChatMessage>;
        public var fullheight:Number = 0;
        public var minheight:Number = 12;
        public var lastuserid:String = "";
        public var oddline:Boolean = false;
        public var clanchat:Boolean = false;
        public var top:Number = 0;

        public var default_line_height:Number = 25;

        public var OnUserClick:Function = null;

        public var pool:Array;

        public var num:int = 16;

        public var click_enabled:Boolean = true;

        public var lastisevent:Boolean = false;
        private var lastdate:int = -1;

        public function Clear():void
        {
            this.allmsg = new Vector.<ChatMessage>();
            this.fullheight = 0;
            this.lastuserid = "";
            this.oddline = false;
            this.top = 0;
            this.lastdate = -1;
            this.lastisevent = false;
            for (var i:* = 1; i <= this.num; i++)
            {
                this.pool[i] = -1;
            }
        }

        public function AddSysMsg(msg:String, prototypemov:*):void
        {
            this.AddChatMessage({
                        "TS": 0,
                        "UID": -1,
                        "NAME": "",
                        "MSG": msg
                    }, prototypemov);
        }

        public function AddTimeStamp(ts:String, prototypemov:*):void
        {
            if (!prototypemov.DAY)
            {
                return;
            }
            this.AddChatMessage({
                        "TS": ts,
                        "UID": -1,
                        "UUID": -1,
                        "NAME": "",
                        "MSG": "TIMESTAMP"
                    }, prototypemov);
        }

        public function AddChatMessage(tag:Object, prototypemov:MovieClip = null):ChatMessage
        {
            var d:Date = null;
            var dt:int = 0;
            var f:* = Friends.GetUser(Util.StringVal(tag.UID));
            if (f && f.flag == 3)
            {
                return null;
            }
            if (this.lastuserid != Util.StringVal(tag.UID))
            {
                this.oddline = !this.oddline;
            }
            if (tag.UID != -1)
            {
                d = new Date();
                d.setTime(1000 * tag.TS);
                dt = int(d.getDate());
                if (this.lastdate != dt)
                {
                    this.AddTimeStamp(tag.TS, prototypemov);
                    this.lastdate = dt;
                }
            }
            var msg:ChatMessage = new ChatMessage(this, tag);
            this.allmsg.push(msg);
            this.lastuserid = msg.userid;
            this.lastisevent = msg.event;
            if (prototypemov)
            {
                msg.height = msg.CalculateHeight(prototypemov);
                msg.y = this.fullheight;
                this.fullheight += msg.height;
            }
            return msg;
        }

        public function DrawMessages(chatmc:MovieClip, refresh:Boolean = false):*
        {
            var newpool:*;
            var _closure:Function;
            var n:int = 0;
            var fish:int = 0;
            var m2:MovieClip = null;
            var i:int = 0;
            var m:ChatMessage = null;
            var d:* = undefined;
            var df:* = undefined;
            var s:String = null;
            var Game:Object = null;
            var color:* = undefined;
            var h2:Number = chatmc.MASK.height + 25;
            var first:int = -1;
            var last:int = -2;
            this.top = int(this.top);
            chatmc.MASK.gotoAndStop(Math.round(Math.min(50, Math.max(1, 50 - this.top))));
            if (refresh)
            {
                for (i = 1; i <= this.num; this.pool[i] = -1, i++)
                {
                }
            }
            newpool = [];
            for (fish = 1; fish <= this.num; fish++)
            {
                newpool[fish] = -1;
                m2 = chatmc.MESSAGES.ITEMS["MESSAGE" + fish];
                m2.visible = false;
            }
            for (i = 0; i < this.allmsg.length; i++)
            {
                m = this.allmsg[i];
                if (m.height < 0)
                {
                    m.height = m.CalculateHeight(chatmc.MESSAGES.ITEMS.PROTOTYPE);
                    m.y = this.fullheight;
                    this.fullheight += m.height;
                }
                if (m.y + m.height >= this.top)
                {
                    if (m.y >= this.top + h2)
                    {
                        break;
                    }
                    if (first == -1)
                    {
                        first = i;
                    }
                    last = i;
                    for (n = 1; n <= this.num; n++)
                    {
                        fish = int(this.pool.indexOf(i, 1));
                        if (fish >= 0)
                        {
                            newpool[fish] = i;
                            break;
                        }
                    }
                }
            }
            for (i = first; i <= last; i++)
            {
                m = this.allmsg[i];
                fish = int(newpool.indexOf(i, 1));
                if (fish >= 0)
                {
                    m2 = chatmc.MESSAGES.ITEMS["MESSAGE" + fish];
                    m2.visible = true;
                }
                else
                {
                    fish = int(newpool.indexOf(-1, 1));
                    if (fish == -1)
                    {
                        trace("no fish today!");
                        continue;
                    }
                    newpool[fish] = i;
                    m2 = chatmc.MESSAGES.ITEMS["MESSAGE" + fish];
                    if (m2)
                    {
                        if (Config.rtl)
                        {
                            m2.gotoAndStop(m.userid == Sys.mydata.id ? 2 : 1);
                        }
                        else
                        {
                            m2.gotoAndStop(m.userid == Sys.mydata.id ? 2 : 1);
                        }
                        if (m2.DAY)
                        {
                            m2.DAY.visible = false;
                        }
                        if (m2.BTNHIDE)
                        {
                            _closure = function(m:*, m2:*):*
                            {
                                Imitation.AddEventClick(m2.BTNHIDE, function(e:*):*
                                    {
                                        m2.BTNHIDE.alpha = 1;
                                        m2.TEXT.alpha = 0;
                                        Imitation.FreeBitmapAll(m2);
                                        Comm.SendCommand("HIDEMSG", "UUID=\"" + m.uuid + "\"");
                                        Imitation.RemoveEvents(m2.BTNHIDE);
                                    });
                            };
                            m2.BTNHIDE.alpha = 0.2;
                            _closure(m, m2);
                        }
                        if (m2.DAY && m.userid == "-1" && m.message == "TIMESTAMP")
                        {
                            d = new Date();
                            d.setTime(1000 * m.timestamp);
                            df = new DateTimeFormatter("");
                            df.setDateTimePattern("YYYY:MM:DD - HH:mm");
                            m2.DAY.visible = true;
                            m2.DAY.text = df.format(d);
                            if (m2.ODD)
                            {
                                m2.ODD.visible = false;
                            }
                            if (m2.MYCOLOR)
                            {
                                m2.MYCOLOR.visible = false;
                            }
                            m2.TEXT.visible = false;
                            if (m2.EVEN)
                            {
                                m2.EVEN.visible = false;
                            }
                            m2.AVATAR.Clear();
                            m2.AVATAR.visible = false;
                            m2.DOT.visible = false;
                            m2.EVENT.visible = false;
                            m2.MANAGE.visible = false;
                        }
                        else
                        {
                            m2.TEXT.visible = true;
                            if (m.message == "TIMESTAMP")
                            {
                                m.message = "";
                            }
                            if (m2.ODD)
                            {
                                m2.ODD.visible = m.odd && m.userid != Sys.mydata.id && !m.event;
                                m2.ODD.height = m.height;
                            }
                            if (m2.EVEN)
                            {
                                m2.EVEN.visible = !m2.ODD.visible && !m.event;
                                m2.EVEN.height = m.height;
                            }
                            if (m2.MYCOLOR)
                            {
                                m2.MYCOLOR.visible = m.userid == Sys.mydata.id && !m.event;
                                m2.MYCOLOR.height = m.height;
                            }
                            if (m2.EVENT)
                            {
                                m2.EVENT.visible = m.event;
                                m2.EVENT.height = m.height;
                            }
                            if (m2.MANAGE)
                            {
                                m2.MANAGE.visible = m.signup;
                                if (m.signup)
                                {
                                    m2.MANAGE.BTN.SetCaption("MANAGE");
                                    m2.MANAGE.BTN.AddEventClick(function(e:* = null):*
                                        {
                                            WinMgr.OpenWindow("profile.Profile", {
                                                        "user_id": m.userid,
                                                        "fadeIn": "left",
                                                        "fadeOut": "left"
                                                    });
                                        });
                                }
                            }
                            if (m.userchange && Number(m.userid) > 0)
                            {
                                m2.AVATAR.internal_flipped = m.userid == Sys.mydata.id;
                                m2.AVATAR.ShowUID(m.userid);
                                if (!this.click_enabled)
                                {
                                    m2.AVATAR.DisableClick();
                                }
                                m2.AVATAR.visible = true;
                                m2.DOT.visible = false;
                            }
                            else
                            {
                                m2.AVATAR.Clear();
                                m2.AVATAR.visible = false;
                                m2.DOT.visible = true;
                            }
                            s = m.formattedmsg;
                            if (Config.rtl)
                            {
                                Util.SetText(m2.TEXT, s, true);
                            }
                            else
                            {
                                m2.TEXT.htmlText = s;
                            }
                        }
                        m2.TEXT.height = m.height;
                        m2.TEXT.scrollV = 0;
                        m2.visible = true;
                        if (Sys.screen != "VILAGE")
                        {
                            Game = Modules.GetClass("triviador", "triviador.Game");
                            if (Game)
                            {
                                color = 0;
                                trace(m.userid, Game.players[Game.iam].id);
                                if (m.userid == Game.players[Game.iam].id)
                                {
                                    color = Config.playercolorcodes[Game.iam];
                                }
                                if (m.userid == Game.players[Game.myopp1].id)
                                {
                                    color = Config.playercolorcodes[Game.myopp1];
                                }
                                if (m.userid == Game.players[Game.myopp2].id)
                                {
                                    color = Config.playercolorcodes[Game.myopp2];
                                }
                                Util.SetColor(m2.TEXT, color);
                            }
                        }
                        m2.cacheAsBitmap = true;
                        Imitation.FreeBitmapAll(m2);
                        Imitation.UpdateAll(m2);
                    }
                }
                if (m2)
                {
                    m2.y = m.y - this.top;
                }
            }
            this.pool = newpool;
            chatmc.MESSAGES.visible = true;
        }

        public function OnUserLinkClick(e:*):*
        {
            trace("Link data: " + e.text);
            var s:* = e.text.split("=");
            if (s[0] == "userid")
            {
                if (this.OnUserClick != null)
                {
                    this.OnUserClick(s[1]);
                }
            }
        }
    }
}
