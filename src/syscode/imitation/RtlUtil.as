package syscode.imitation
{
    import com.greensock.TweenMax;
    import com.mywebzz.utils.text.TextFieldHealer;
    import com.xvisage.utils.StringUtils;

    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    import syscode.Modules;
    import syscode.Platform;
    import syscode.Util;

    public class RtlUtil
    {
        public static var rtl_config:Boolean = false;
        public static var caret_shape:Shape = null;
        public static var stringutils:StringUtils = null;
        public static var textformat:TextFormat = null;
        private static var hidden_focus:Object = null;

        public static function InitArabicUtils():*
        {
            var Fontclass:Class = null;
            var f:Font = null;
            if (stringutils == null)
            {
                stringutils = new StringUtils();
                stringutils.wrapFactor = 0.98;
                stringutils.hindiNumeralsOnly = false;
                stringutils.americanFormat = false;
                Fontclass = Modules.GetClass("fonts", "aarabicafontbold");
                f = null;
                if (Fontclass)
                {
                    f = new Fontclass();
                }
                textformat = new TextFormat();
                if (f)
                {
                    textformat.font = f.fontName;
                }
                textformat.bold = true;
                textformat.rightMargin = 4;
            }
        }

        public function RtlUtil()
        {
            super();
        }
        public var tf:TextField = null;
        public var eo:Object = null;
        private var hidden_tf:Object = null;
        private var frame:int = 0;
        private var caret_blink_state:Boolean = false;

        public function RTLEditSetup(tf:TextField):*
        {
            if (!rtl_config)
            {
                new TextFieldHealer(tf);
                return;
            }
            if (Boolean(this.eo) && tf.defaultTextFormat.align == "right")
            {
                return;
            }
            this.tf = tf;
            this.eo = {
                    "realtext": "",
                    "tfobj": tf,
                    "text": ""
                };
            if (!caret_shape)
            {
                caret_shape = new Shape();
                caret_shape.graphics.lineStyle(1.5, tf.textColor, 1);
                caret_shape.graphics.lineTo(0, 20);
                caret_shape.graphics.lineStyle(1, 0, 0.5);
                caret_shape.graphics.lineTo(0, 0);
            }
            tf.parent.addChild(caret_shape);
            caret_shape.alpha = 0;
            this.hidden_tf = Platform.CreateStageText(tf.x + 1, tf.y + 1, tf.width * tf.scaleX, tf.height * tf.scaleY, tf.multiline, 1000);
            this.hidden_tf.visible = false;
            this.hidden_tf.restrict = tf.restrict;
            this.hidden_tf.maxChars = tf.maxChars;
            Util.AddEventListener(tf, Event.ENTER_FRAME, this.OnEnterFrame);
            trace("RTL edit setup...");
            Util.AddEventListener(tf, FocusEvent.FOCUS_IN, this.OnFocusIn);
            Util.AddEventListener(this.hidden_tf, "change", this.OnRTLEditChange);
            Util.AddEventListener(this.hidden_tf, FocusEvent.FOCUS_OUT, this.OnHiddenFocusOut);
            Util.AddEventListener(tf, "click", this.OnRTLEditClick);
            trace("RTL edit setup...");
            this.SetRTLEditText("");
            var fmt:* = new TextFormat();
            fmt.align = "right";
            tf.defaultTextFormat = fmt;
            tf.tabEnabled = true;
        }

        public function GetRTLEditText():*
        {
            if (!rtl_config)
            {
                return this.tf.text;
            }
            if (!this.eo)
            {
                return "";
            }
            return this.eo.realtext;
        }

        public function UpdateRTLEdit():*
        {
            var fmt:* = undefined;
            if (!this.tf)
            {
                return;
            }
            this.LoadArabicText(this.eo.realtext, true);
            if (this.tf.defaultTextFormat.align != "right")
            {
                fmt = new TextFormat();
                fmt.align = "right";
                this.tf.defaultTextFormat = fmt;
            }
            this.eo.text = this.tf.htmlText;
        }

        public function SetRTLEditText(value:String):*
        {
            this.tf.text = value;
            if (!rtl_config)
            {
                return;
            }
            if (!this.eo)
            {
                return;
            }
            this.eo.realtext = value;
            this.hidden_tf.text = value;
            this.UpdateRTLEdit();
        }

        public function OnRTLEditChange(e:*):*
        {
            var htf:* = e.currentTarget;
            if (!htf)
            {
                return;
            }
            if (htf != this.hidden_tf)
            {
                return;
            }
            if (!this.eo)
            {
                return;
            }
            this.eo.realtext = this.hidden_tf.text;
            this.UpdateRTLEdit();
        }

        public function OnRTLEditClick(e:*):*
        {
            hidden_focus = this.hidden_tf;
            Platform.FocusStageText(this.hidden_tf);
            Platform.SelectEndStageText(this.hidden_tf);
            this.tf.tabEnabled = false;
        }

        public function LoadArabicText(str:String, keeplayout:Boolean = false):void
        {
            var fmt:* = undefined;
            InitArabicUtils();
            textformat.size = Math.round(Number(this.tf.defaultTextFormat.size) * 1);
            textformat.color = this.tf.defaultTextFormat.color;
            var oldleading:* = this.tf.defaultTextFormat.leading;
            textformat.leading = oldleading;
            textformat.align = this.tf.defaultTextFormat.align;
            if (!keeplayout)
            {
                if (this.tf.defaultTextFormat.align == "left")
                {
                    textformat.align = "right";
                }
                else if (this.tf.defaultTextFormat.align == "right")
                {
                    textformat.align = "left";
                }
            }
            if (this.tf.parent)
            {
                this.tf.htmlText = stringutils.parseArabic(str, this.tf, textformat);
            }
            if (oldleading != this.tf.defaultTextFormat.leading)
            {
                fmt = new TextFormat();
                fmt.leading = oldleading;
                this.tf.defaultTextFormat = fmt;
            }
        }

        public function Dispose():*
        {
            caret_shape.alpha = 0;
            if (this.tf)
            {
                Util.RemoveEventListener(this.tf, Event.ENTER_FRAME, this.OnEnterFrame);
                Util.RemoveEventListener(this.tf, FocusEvent.FOCUS_IN, this.OnFocusIn);
                Util.RemoveEventListener(this.tf, "click", this.OnRTLEditClick);
            }
            if (this.hidden_tf)
            {
                Util.RemoveEventListener(this.hidden_tf, "change", this.OnRTLEditChange);
                Util.RemoveEventListener(this.hidden_tf, FocusEvent.FOCUS_OUT, this.OnHiddenFocusOut);
            }
            if (this.tf && this.tf.parent && this.tf.parent.contains(this.tf))
            {
                this.tf.parent.removeChild(this.tf);
            }
            Platform.DisposeStageText(this.hidden_tf);
            this.tf = null;
            this.hidden_tf = null;
            hidden_focus = null;
        }

        private function OnFocusIn(e:FocusEvent):void
        {
            trace("OnFocusIn");
            if (hidden_focus != this.hidden_tf)
            {
                TweenMax.delayedCall(0, this.OnRTLEditClick, [e]);
            }
        }

        private function OnHiddenFocusOut(e:FocusEvent):void
        {
            trace("OnHiddenFocusOut");
            if (hidden_focus == this.tf)
            {
                hidden_focus = null;
            }
            caret_shape.alpha = 0;
            this.tf.tabEnabled = true;
        }

        private function OnEnterFrame(e:Event):void
        {
            var nl:int = 0;
            var m:TextLineMetrics = null;
            if ((!this.tf || !this.tf.parent) && this.frame > 0)
            {
                caret_shape.alpha = 0;
                return;
            }
            Platform.SetStageTextPos(this.hidden_tf, this.tf.x, this.tf.y);
            if (hidden_focus == this.hidden_tf)
            {
                Platform.SelectEndStageText(this.hidden_tf);
                nl = this.tf.numLines - 1;
                m = null;
                if (this.tf.multiline && nl > 0)
                {
                    while (nl > 0 && this.tf.getLineLength(nl) < 1)
                    {
                        nl--;
                    }
                    m = this.tf.getLineMetrics(nl);
                }
                else
                {
                    m = this.tf.getLineMetrics(0);
                }
                if (m)
                {
                    caret_shape.x = this.tf.x + (m.x - 1) * this.tf.scaleX;
                    caret_shape.y = this.tf.y + (nl - this.tf.scrollV + 1) * (m.ascent + m.descent) * this.tf.scaleY + 4;
                    caret_shape.height = int(this.tf.defaultTextFormat.size) * this.tf.scaleY;
                }
                caret_shape.alpha = Math.sin(this.frame / 22 * Math.PI) * 0.5 + 0.5;
            }
            ++this.frame;
        }
    }
}
