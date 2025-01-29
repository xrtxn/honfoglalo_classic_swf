package syscode
{
    import flash.display.*;
    import flash.events.*;
    import flash.globalization.DateTimeFormatter;

    public class LegoChatMessageBuffer
    {
        public function LegoChatMessageBuffer()
        {
            this.allmsg = new Vector.<LegoChatMessage>();
            this.pool = [];
            super();
            var i:* = 1;
            while (i <= this.num)
            {
                this.pool[i] = -1;
                i++;
            }
        }
        public var allmsg:Vector.<LegoChatMessage>;
        public var fullheight:Number = 0;
        public var minheight:Number = 12;
        public var lastuserid:String = "";
        public var oddline:Boolean = false;
        public var clanchat:Boolean = false;
        public var allow_hide:Boolean = true;

        public var top:Number = 0;

        public var default_line_height:Number = 25;

        public var OnUserClick:Function = null;

        public var pool:Array;

        public var num:int = 10;

        public var click_enabled:Boolean = true;

        public var lastisevent:Boolean = false;

        public var fgcode:String = "0000";
        private var lastdate:int = -1;

        public function Clear():void
        {
            this.allmsg = new Vector.<LegoChatMessage>();
            this.fullheight = 0;
            this.lastuserid = "";
            this.oddline = false;
            this.top = 0;
            this.lastdate = -1;
            this.lastisevent = false;
            var i:* = 1;
            while (i <= this.num)
            {
                this.pool[i] = -1;
                i++;
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

        public function AddChatMessage(tag:Object, prototypemov:MovieClip = null):LegoChatMessage
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
            if (tag.MSG != "TIMESTAMP")
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
            var msg:LegoChatMessage = new LegoChatMessage(this, tag);
            this.allmsg.push(msg);
            this.lastuserid = msg.userid;
            this.lastisevent = msg.event;
            if (prototypemov)
            {
                if (msg.signup || msg.fg || Boolean(msg.fgcode))
                {
                    msg.linecount = 4;
                }
                else
                {
                    msg.linecount = msg.CalculateLineCount(prototypemov);
                }
                msg.height = msg.linecount > 2 ? 80 : 42;
                msg.y = this.fullheight;
                this.fullheight += msg.height;
            }
            return msg;
        }

        public function HideChatMessage(tag:Object):*
        {
            var uuid:String = Util.StringVal(tag.UUID);
            var i:Number = 0;
            while (i < this.allmsg.length)
            {
                if (this.allmsg[i].uuid == uuid)
                {
                    this.allmsg[i].hidden = true;
                }
                i++;
            }
        }

        public function DrawMessages(chatmc:MovieClip, refresh:Boolean = false):*
        {
            var newpool:*;
            var _closure:Function;
            var __closure:Function;
            var __closure2:Function;
            var n:int = 0;
            var fish:int = 0;
            var m2:MovieClip = null;
            var i:int = 0;
            var m:LegoChatMessage = null;
            var d:* = undefined;
            var df:* = undefined;
            var buf:LegoChatMessageBuffer = null;
            var s:String = null;
            var h2:Number = chatmc.MASK.height + 25;
            var first:int = -1;
            var last:int = -2;
            this.top = int(this.top);
            chatmc.MASK.gotoAndStop(Math.round(Math.min(50, Math.max(1, 50 - this.top))));
            if (refresh)
            {
                i = 1;
                while (i <= this.num)
                {
                    this.pool[i] = -1;
                    i++;
                }
            }
            newpool = [];
            fish = 1;
            while (fish <= this.num)
            {
                newpool[fish] = -1;
                m2 = chatmc.MESSAGES.ITEMS["MESSAGE" + fish];
                if (m2.AVATARFRAME)
                {
                    m2.AVATARFRAME.visible = false;
                }
                m2.visible = false;
                fish++;
            }
            i = 0;
            while (i < this.allmsg.length)
            {
                m = this.allmsg[i];
                if (m.height < 0)
                {
                    if (m.signup || m.fg || Boolean(m.fgcode))
                    {
                        m.linecount = 4;
                    }
                    else
                    {
                        m.linecount = m.CalculateLineCount(chatmc.MESSAGES.ITEMS.PROTOTYPE);
                    }
                    m.height = m.linecount > 2 || m.signup || m.fg || Boolean(m.fgcode) ? 80 : 40;
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
                    n = 1;
                    while (n <= this.num)
                    {
                        fish = int(this.pool.indexOf(i, 1));
                        if (fish >= 0)
                        {
                            newpool[fish] = i;
                            break;
                        }
                        n++;
                    }
                }
                i++;
            }
            i = first;
            for (; i <= last; i++)
            {
                m = this.allmsg[i];
                fish = int(newpool.indexOf(i, 1));
                if (fish >= 0)
                {
                    m2 = chatmc.MESSAGES.ITEMS["MESSAGE" + fish];
                    if (m2.AVATARFRAME)
                    {
                        m2.AVATARFRAME.visible = false;
                    }
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
                    if (m2.AVATARFRAME)
                    {
                        m2.AVATARFRAME.visible = false;
                    }
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
                            if (m.userid != "-1")
                            {
                                _closure = function(m:*, m2:*):*
                                {
                                    Imitation.AddEventClick(m2.BTNHIDE.BTN, function(e:*):*
                                        {
                                            if (m.hidden)
                                            {
                                                m.revealed = !m.revealed;
                                            }
                                            if (!m.hidden && allow_hide)
                                            {
                                                Comm.SendCommand("HIDEMSG", "UUID=\"" + m.uuid + "\"");
                                            }
                                            m.hidden = true;
                                            m2.TEXT.visible = !m.hidden || m.revealed;
                                            Imitation.GotoFrame(m2.BTNHIDE.BTN, !!m2.TEXT.visible ? 2 : 1);
                                            Imitation.FreeBitmapAll(m2);
                                            m2.SYSTEXT.visible = !m2.TEXT.visible;
                                            if (m2.SYSTEXT.visible)
                                            {
                                                Lang.Set(m2.SYSTEXT.FIELD, "hidden_message");
                                            }
                                        });
                                };
                                m2.BTNHIDE.visible = m.userid != Sys.mydata.id;
                                Imitation.GotoFrame(m2.BTNHIDE.BTN, m.hidden && !m.revealed ? 1 : 2);
                                _closure(m, m2);
                            }
                            else
                            {
                                m2.BTNHIDE.visible = false;
                            }
                        }
                        if (m2.DAY && m.userid == "-1" && m.message == "TIMESTAMP")
                        {
                            d = new Date();
                            d.setTime(1000 * m.timestamp);
                            df = new DateTimeFormatter("");
                            df.setDateTimePattern("YYYY:MM:DD - HH:mm");
                            m2.DAY.visible = true;
                            m2.DAY.FIELD.text = df.format(d);
                            if (m2.BG)
                            {
                                m2.BG.visible = false;
                            }
                            if (m2.SYSBG)
                            {
                                m2.SYSBG.visible = false;
                            }
                            m2.TEXT.FIELD.text = "";
                            m2.TEXT.visible = false;
                            if (m2.SYSTEXT)
                            {
                                m2.SYSTEXT.FIELD.text = "";
                                m2.SYSTEXT.visible = false;
                            }
                            m2.AVATAR.Clear();
                            m2.AVATAR.visible = false;
                            m2.MANAGE.visible = false;
                        }
                        else
                        {
                            if (m.message == "TIMESTAMP")
                            {
                                m.message = "";
                            }
                            if (m2.BG)
                            {
                                m2.BG.visible = !m.event && !m.fgcode && m.userid != "-1";
                                if (m2.BG)
                                {
                                    Imitation.GotoFrame(m2.BG, m.linecount > 2 ? 2 : 1);
                                }
                                m2.TEXT.visible = m2.BG.visible && (!m.hidden || m.revealed);
                                if (m2.SYSBG)
                                {
                                    Imitation.GotoFrame(m2.SYSBG, m.linecount > 2 ? 2 : 1);
                                    m2.SYSBG.visible = !m2.BG.visible;
                                    m2.SYSTEXT.visible = !m2.TEXT.visible;
                                }
                            }
                            buf = this;
                            trace("m.fg: " + m.fg);
                            if (m2.MANAGE)
                            {
                                if (m.signup)
                                {
                                    __closure = function(userid:String):*
                                    {
                                        m2.MANAGE.AddEventClick(function(e:* = null):*
                                            {
                                                WinMgr.OpenWindow("profile.Profile", {
                                                            "user_id": userid,
                                                            "fadeIn": "left",
                                                            "fadeOut": "left"
                                                        });
                                            });
                                    };
                                    m2.MANAGE.visible = true;
                                    m2.MANAGE.SetLang("manage");
                                    __closure(m.userid);
                                }
                                else if (m.fg)
                                {
                                    m2.MANAGE.visible = true;
                                    m2.MANAGE.SetLang("join");
                                    m2.MANAGE.AddEventClick(function(e:* = null):*
                                        {
                                            buf.fgcode = "";
                                            Imitation.AddGlobalListener("GAMETAGSPROCESSED", OnGameTagsProcessed);
                                            Comm.SendCommand("CHANGEWAITHALL", "WH=\"GAME\"", function():*
                                                {
                                                });
                                        });
                                }
                                else if (m.fgcode)
                                {
                                    __closure2 = function(code:String):*
                                    {
                                        m2.MANAGE.AddEventClick(function(e:* = null):*
                                            {
                                                buf.fgcode = code;
                                                Imitation.AddGlobalListener("GAMETAGSPROCESSED", OnGameTagsProcessed);
                                                Comm.SendCommand("CHANGEWAITHALL", "WH=\"GAME\"", function():*
                                                    {
                                                    });
                                            });
                                    };
                                    m2.MANAGE.visible = true;
                                    m2.MANAGE.SetLang("join");
                                    __closure2(m.fgcode);
                                }
                                else
                                {
                                    m2.MANAGE.visible = false;
                                }
                            }
                            if (m.userchange && Number(m.userid) > 0)
                            {
                                m2.AVATAR.internal_flipped = m.userid == Sys.mydata.id;
                                m2.AVATAR.ShowUID(m.userid);
                                if (m2.AVATARFRAME)
                                {
                                    m2.AVATARFRAME.visible = true;
                                }
                                if (!this.click_enabled)
                                {
                                    m2.AVATAR.DisableClick();
                                }
                                m2.AVATAR.visible = true;
                                if (Boolean(m2.BG) && Boolean(m2.BG.DOT))
                                {
                                    m2.BG.DOT.visible = true;
                                }
                                if (Boolean(m2.SYSBG) && Boolean(m2.SYSBG.DOT))
                                {
                                    m2.SYSBG.DOT.visible = true;
                                }
                            }
                            else
                            {
                                m2.AVATAR.Clear();
                                m2.AVATAR.visible = false;
                                if (Boolean(m2.BG) && Boolean(m2.BG.DOT))
                                {
                                    m2.BG.DOT.visible = false;
                                }
                                if (Boolean(m2.SYSBG) && Boolean(m2.SYSBG.DOT))
                                {
                                    m2.SYSBG.DOT.visible = false;
                                }
                            }
                            s = m.formattedmsg;
                            if (Config.rtl)
                            {
                                Util.SetText(m2.TEXT.FIELD, s, true);
                                if (m2.SYSTEXT)
                                {
                                    Util.SetText(m2.SYSTEXT.FIELD, s, true);
                                }
                            }
                            else
                            {
                                m2.TEXT.FIELD.htmlText = s;
                                m2.SYSTEXT.FIELD.htmlText = s;
                            }
                            if (m.hidden)
                            {
                                Lang.Set(m2.SYSTEXT.FIELD, "hidden_message");
                            }
                        }
                        m2.TEXT.FIELD.height = m.height;
                        if (m2.SYSTEXT)
                        {
                            m2.SYSTEXT.FIELD.height = m.height;
                        }
                        if (m2.MANAGE)
                        {
                            m2.MANAGE.y = m.height - m2.MANAGE.height - 15;
                        }
                        m2.TEXT.FIELD.scrollV = 0;
                        if (m2.SYSTEXT)
                        {
                            m2.SYSTEXT.FIELD.scrollV = 0;
                        }
                        m2.visible = true;
                        Util.StopAllChildrenMov(m2);
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
            var s:* = e.text.split("=");
            if (s[0] == "userid")
            {
                if (this.OnUserClick != null)
                {
                    this.OnUserClick(s[1]);
                }
            }
        }

        private function SendCode(e:* = null):void
        {
            Comm.SendCommand("ENTERSEPROOM", "CODE=\"" + this.fgcode + "\"", function(res:int, xml:XML):*
                {
                    if (res > 0)
                    {
                        WinMgr.ReplaceWindow(WinMgr.currentwindow.mc, "friendlygame.FriendlyGame", {
                                    "page": 3,
                                    "error": "CODE"
                                });
                    }
                    else
                    {
                        Sys.codeclan = true;
                        WinMgr.ReplaceWindow(WinMgr.currentwindow.mc, "friendlygame.FriendlyGame");
                    }
                });
        }

        private function OnGameTagsProcessed(e:Event):void
        {
            trace("OnGameTagsProcessed");
            Imitation.RemoveGlobalListener("GAMETAGSPROCESSED", this.OnGameTagsProcessed);
            if (this.fgcode != "")
            {
                this.SendCode(null);
            }
            else
            {
                WinMgr.ReplaceWindow(WinMgr.currentwindow.mc, "friendlygame.FriendlyGame", {"page": 2});
            }
        }
    }
}
