package syscode
{
    import flash.display.*;

    public class AvatarAnimMov extends MovieClip
    {
        public function AvatarAnimMov()
        {
            super();
            this.FRAMEPLACEHOLDER.visible = false;
            this.MASK.visible = false;
        }
        public var frame:MovieClip = null;
        public var AVATAR:MovieClip;
        public var FRAMEPLACEHOLDER:MovieClip;
        public var MASK:MovieClip;

        public function ShowUID(userid:String, readyCallback:Function = null, readyParams:Array = null):void
        {
            var mc:* = undefined;
            var ready:Function = null;
            ready = function():*
            {
                if (userid == Sys.mydata.id)
                {
                    ShowFrame(Sys.mydata.xplevel, Sys.mydata.league);
                }
                Imitation.CollectChildrenAll(mc);
                Imitation.FreeBitmapAll(mc);
                Imitation.UpdateAll(mc);
                if (Boolean(readyCallback))
                {
                    readyCallback.apply(null, readyParams);
                }
            };
            mc = this;
            Imitation.CollectChildrenAll(mc.parent);
            this.AVATAR.anim = true;
            this.AVATAR.ShowUID(userid, ready);
        }

        public function ShowFrame(xplevel:int = 0, actleague:int = 0):*
        {
            var classdefinition:* = undefined;
            if (!this.frame)
            {
                classdefinition = Modules.GetClass("avatarframe", "AvatarFrame");
                this.frame = new classdefinition();
                addChild(this.frame);
                this.frame.cacheAsBitmap = true;
            }
            this.frame.gotoAndStop(xplevel + 1);
            Util.SetText(this.frame.XPLEVEL, xplevel.toString());
            this.frame.CROWN.gotoAndStop(8 - actleague);
            Imitation.FreeBitmapAll(this.frame);
            Imitation.UpdateAll(this.frame);
        }

        public function Clear():*
        {
            this.AVATAR.Clear();
        }
    }
}
