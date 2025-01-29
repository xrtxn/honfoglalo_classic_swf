package syscode
{
    import flash.display.*;

    public class AvatarBodyMov extends MovieClip
    {
        public static function Init(callback:*):*
        {
        }

        public function AvatarBodyMov()
        {
            super();
            this.head = null;
            this.body = null;
            this.uid = "";
            this.removeChildAt(0);
            var classdefinition:* = Modules.GetClass("avatarbody", "AvatarBody");
            this.body = new classdefinition();
            addChild(this.body);
            this.body.stop();
        }
        public var body:MovieClip;
        public var head:MovieClip;
        public var uid:String;
        public var HEAD:MovieClip;

        public function Clear():void
        {
            if (this.head != null)
            {
                if (this.body.HEAD)
                {
                    this.body.HEAD.removeChild(this.head);
                }
                this.head = null;
            }
            this.uid = "";
        }

        public function ShowUID(userid:String, readyCallback:Function = null):void
        {
            var num:Number;
            var uid:String = null;
            var self:AvatarBodyMov = null;
            var HandleUserObject:Function = null;
            var u:Object = null;
            HandleUserObject = function():void
            {
                if (uid == self.uid)
                {
                    self.Clear();
                    self.ShowUID(uid, readyCallback);
                }
            };
            uid = Util.StringVal(userid);
            if (uid == this.uid)
            {
                return;
            }
            this.Clear();
            this.uid = uid;
            num = Util.NumberVal(uid);
            self = this;
            if (num <= 0)
            {
                this.body.gotoAndStop(3);
            }
            else
            {
                u = Extdata.GetUserData(uid);
                if (u)
                {
                    if (u.avatar.indexOf("//") >= 0)
                    {
                        this.body.gotoAndStop(3);
                    }
                    else if (uid == self.uid)
                    {
                        this.ShowInternal(uid, u.avatar, readyCallback);
                    }
                }
                else
                {
                    Extdata.GetSheduledData(HandleUserObject);
                }
            }
        }

        public function ShowInternal(uid:String, def:String, readyCallback:Function = null):void
        {
            var sex:* = undefined;
            var amov:AvatarMov = null;
            this.Clear();
            this.uid = uid;
            if (Boolean(def) && def.length > 0)
            {
                sex = def.substr(0, 1) == "1" ? 1 : 2;
                this.body.gotoAndStop(sex);
                if (this.body.HEAD.getChildAt(0))
                {
                    this.body.HEAD.removeChildAt(0);
                }
                amov = new AvatarMov();
                amov.anim = true;
                amov.ShowInternalShape(uid, def);
                this.head = amov.avatar as MovieClip;
                this.head.x = this.head.y = 0;
                this.head.scaleX = this.head.scaleY = 1;
                this.head.BACK.visible = false;
                this.head.HEAD.ARMOR.visible = false;
                this.body.HEAD.addChild(this.head);
            }
            else
            {
                this.body.gotoAndStop(3);
            }
            if (readyCallback != null)
            {
                readyCallback();
            }
        }
    }
}
