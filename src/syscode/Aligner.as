package syscode
{
    import com.greensock.TweenMax;

    import flash.display.*;
    import flash.system.Capabilities;
    import flash.utils.*;

    public class Aligner
    {
        public static var stagewidth:Number;

        public static var stageheight:Number;

        public static var margins:Object = {
                "left": 25,
                "top": 5,
                "right": 5,
                "bottom": 5
            };

        public static var basescale:Number = 1;

        public static var autoaligned:Object = {};

        public static function Init(awidth:Number, aheight:Number):*
        {
            StageResized(awidth, aheight);
        }

        public static function StageResized(awidth:Number, aheight:Number):*
        {
            trace("Aligner resize: " + awidth + "," + aheight);
            stagewidth = awidth;
            stageheight = aheight;
            basescale = Capabilities.screenDPI / 160;
            if (basescale < 1)
            {
                basescale = 1;
            }
            DoAutoAlign();
        }

        public static function CenterWindow(awin:MovieClip, tostage:Boolean = false):*
        {
            var bm:Object = null;
            var wsc:Number = NaN;
            var tweens:Array = null;
            if (!awin)
            {
                return;
            }
            var cw:Number = stagewidth - margins.left - margins.right;
            var ch:Number = stageheight - margins.top - margins.bottom;
            var cx:Number = Number(margins.left);
            var cy:Number = Number(margins.top);
            if (awin.getChildByName("BOUNDS"))
            {
                bm = awin.BOUNDS;
            }
            else if (awin.getChildByName("FRAME"))
            {
                bm = awin.FRAME;
            }
            else
            {
                bm = awin.getBounds(awin);
            }
            var winscale:Number = basescale;
            wsc = cw / bm.width;
            if (wsc < winscale)
            {
                winscale = wsc;
            }
            wsc = ch / bm.height;
            if (wsc < winscale)
            {
                winscale = wsc;
            }
            awin.scaleX = winscale;
            awin.scaleY = winscale;
            awin.x = int(cx + cw / 2 - winscale * (bm.width / 2 + bm.x));
            awin.y = int(cy + ch / 2 - winscale * (bm.height / 2 + bm.y));
            if (TweenMax.isTweening(awin))
            {
                tweens = TweenMax.getTweensOf(awin);
                if (Boolean(tweens) && tweens.length == 1)
                {
                    tweens[0].updateTo({
                                "alpha": 1,
                                "scaleX": awin.scaleX,
                                "scaleY": awin.scaleY,
                                "x": awin.x,
                                "y": awin.y
                            });
                }
            }
        }

        public static function SetAutoAlign(amc:MovieClip, atostage:Boolean = false):void
        {
            var cname:String = getQualifiedClassName(amc);
            if (cname == "")
            {
                return;
            }
            var aao:Object = autoaligned[cname];
            if (!aao)
            {
                aao = {
                        "classname": cname,
                        "mc": amc,
                        "tostage": atostage,
                        "func": null
                    };
                autoaligned[cname] = aao;
            }
            aao.mc = amc;
            aao.tostage = atostage;
            Aligner.SetMargins();
            AutoAlignWindow(aao);
        }

        public static function SetAutoAlignFunc(amc:MovieClip, afunction:Function):void
        {
            var cname:String = getQualifiedClassName(amc);
            if (cname == "")
            {
                return;
            }
            var aao:Object = autoaligned[cname];
            if (!aao)
            {
                aao = {
                        "classname": cname,
                        "mc": amc,
                        "tostage": false,
                        "func": afunction
                    };
                autoaligned[cname] = aao;
            }
            aao.mc = amc;
            aao.func = afunction;
            AutoAlignWindow(aao);
        }

        public static function AutoAlignWindow(aao:Object):void
        {
            if (typeof aao.func == "function")
            {
                aao.func();
            }
            else
            {
                CenterWindow(aao.mc, aao.tostage);
            }
        }

        public static function UnSetAutoAlign(amc:MovieClip):void
        {
            var cname:String = getQualifiedClassName(amc);
            if (cname != "" && autoaligned[cname] !== undefined)
            {
                autoaligned[cname] = undefined;
            }
        }

        public static function SetMargins():void
        {
            var leftmargin:Number = Number(Aligner.margins.left);
            var notifs:Object = Modules.GetClass("uibase", "uibase.Notifications");
            if (notifs && notifs.mc && Boolean(notifs.mc.visible))
            {
                Aligner.margins.left = 25;
            }
            else
            {
                Aligner.margins.left = 5;
            }
            if (leftmargin != Aligner.margins.left)
            {
                Aligner.DoAutoAlign();
            }
        }

        public static function DoAutoAlign():void
        {
            var cname:String = null;
            var aao:Object = null;
            Aligner.SetMargins();
            for (cname in autoaligned)
            {
                aao = autoaligned[cname];
                if (Boolean(aao) && Boolean(aao.mc))
                {
                    if (aao.mc.parent != null)
                    {
                        AutoAlignWindow(aao);
                    }
                    else
                    {
                        autoaligned[cname] = undefined;
                    }
                }
            }
        }

        public function Aligner()
        {
            super();
        }
    }
}
