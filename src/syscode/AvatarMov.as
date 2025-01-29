package syscode
{
    import com.greensock.TweenMax;

    import flash.display.*;

    public class AvatarMov extends MovieClip
    {
        public static function GetGlobalScale(obj:MovieClip):Number
        {
            var s:Number = 1;
            var o:* = obj;
            while (o)
            {
                s *= o.scaleY;
                o = o.parent;
            }
            return s;
        }

        public function AvatarMov()
        {
            this.members = {};
            super();
            this.avatar = null;
            this.uid = "";
            Util.StopAllChildrenMov(this);
        }
        public var avatar:DisplayObject;
        public var uid:String;
        public var PIC:MovieClip;
        public var anim:Boolean = false;
        public var members:Object;
        public var isinternal:Boolean = true;
        public var internal_flipped:Boolean = false;
        public var mt:Boolean = false;
        public var BACK:MovieClip;
        public var HEAD:MovieClip;
        public var anim_id:int = 0;
        private var clickenabled:Boolean = true;

        public function Clear():void
        {
            if (this.avatar != null)
            {
                TweenMax.killTweensOf(this.avatar);
                if (this.avatar is DisplayObjectContainer)
                {
                    TweenMax.killChildTweensOf(this.avatar as DisplayObjectContainer);
                }
                this.removeChild(this.avatar);
                this.avatar = null;
            }
            this.uid = "";
            if (this.mt)
            {
                Imitation.GotoFrame(this, "MT");
            }
            else
            {
                this.gotoAndStop(1);
                this.PIC.gotoAndStop(1);
            }
            Imitation.RemoveEvents(this);
        }

        public function ShowUID(userid:String, readyCallback:Function = null, readyParams:Array = null, anim_id:int = 0):void
        {
            var num:Number;
            var uid:String = null;
            var self:AvatarMov = null;
            var HandleUserObject:Function = null;
            var u:Object = null;
            HandleUserObject = function():void
            {
                if (uid == self.uid)
                {
                    self.Clear();
                    self.ShowUID(uid, readyCallback, readyParams);
                }
            };
            uid = Util.StringVal(userid);
            this.anim_id = anim_id;
            if (uid == this.uid)
            {
                return;
            }
            this.Clear();
            this.uid = uid;
            num = Util.NumberVal(uid);
            self = this;
            if (num == 0)
            {
                this.CallCallback(readyCallback, readyParams);
                Imitation.RemoveEvents(this);
            }
            else if (num < 0)
            {
                this.gotoAndStop(1);
                Imitation.GotoFrame(this.PIC, 2 + (1 - num) % 2);
                Imitation.CollectChildrenAll(this);
                Imitation.FreeBitmapAll(this);
                Imitation.UpdateAll(this);
                this.CallCallback(readyCallback, readyParams);
                Imitation.RemoveEvents(this);
            }
            else
            {
                u = Extdata.GetUserData(uid);
                if (u)
                {
                    if (u.avatar.indexOf("//") >= 0)
                    {
                        if (u.invite_token)
                        {
                            uid = u.invite_token;
                        }
                        self.uid = uid;
                        this.ShowExternal(uid, this.width > 35 ? u.bigavatar : u.avatar, readyCallback, readyParams);
                        this.isinternal = false;
                    }
                    else
                    {
                        this.isinternal = true;
                        if (this.anim || anim_id > 0)
                        {
                            this.ShowInternalShape(uid, u.avatar, readyCallback, readyParams, anim_id);
                        }
                        else
                        {
                            this.ShowInternalBitmap(uid, u.avatar, readyCallback, readyParams);
                        }
                    }
                }
                else
                {
                    Extdata.GetSheduledData(HandleUserObject);
                }
                if (this.clickenabled)
                {
                    Imitation.AddEventClick(this, this.OnClick);
                }
            }
        }

        public function DisableClick():void
        {
            Imitation.RemoveEvents(this);
            this.clickenabled = false;
        }

        public function ShowInternalBitmap(uid:String, def:String, readyCallback:Function = null, readyParams:Array = null):void
        {
            this.Clear();
            this.gotoAndStop(1);
            this.PIC.gotoAndStop(1);
            this.uid = uid;
            var scale:* = Imitation.CalculateBitmapScale(this) * 70 / this.width;
            if (Boolean(def) && def.length > 0)
            {
                this.ShowBitmap(AvatarFactory.CreateAvatarBitmap(def, this.width, scale), uid, readyCallback, readyParams, scale);
            }
            else
            {
                this.PIC.visible = true;
                this.CallCallback(readyCallback, readyParams);
            }
        }

        public function ShowInternalShape(uid:String, def:String, readyCallback:Function = null, readyParams:Array = null, anim_id:* = 0):void
        {
            this.Clear();
            this.uid = uid;
            this.members = {};
            if (!this.avatar && def && def.length > 0)
            {
                this.avatar = AvatarFactory.CreateAvatarAnim(def, true, this.members, anim_id);
                if (this.avatar)
                {
                    if (this.PIC)
                    {
                        this.PIC.visible = false;
                    }
                    TweenMax.killTweensOf(this.avatar);
                    TweenMax.killChildTweensOf(this.avatar as DisplayObjectContainer);
                    this.avatar.x = 35;
                    this.avatar.y = 70;
                    this.avatar.scaleY = 70 / 250;
                    this.avatar.scaleX = this.avatar.scaleY * (this.internal_flipped ? -1 : 1);
                    this.addChild(this.avatar);
                }
                Util.StopAllChildrenMov(this);
                Imitation.CollectChildrenAll(this.parent);
                if (this.avatar)
                {
                    AvatarFactory.StartAnim(this.members, anim_id);
                    if (!this.anim)
                    {
                        AvatarFactory.PreviewAnim(this.members, anim_id);
                    }
                }
            }
            else if (this.PIC)
            {
                this.PIC.visible = true;
            }
            this.CallCallback(readyCallback, readyParams);
        }

        public function ShowExternal(uid:String, url:String, readyCallback:Function = null, readyParams:Array = null):void
        {
            this.Clear();
            this.gotoAndStop(1);
            this.PIC.gotoAndStop(1);
            this.uid = uid;
            if (Boolean(url) && url.length > 0)
            {
                ImageCache.LoadImage(this.ShowBitmap, this, [this.uid, readyCallback, readyParams], url);
            }
            else
            {
                this.CallCallback(readyCallback, readyParams);
            }
        }

        public function ShowDoll():void
        {
            this.Clear();
            this.ShowUID("-1");
        }

        private function ShowBitmap(bitmap:Bitmap, uid:String, readyCallback:Function, readyParams:Array = null, scale:Number = 1):void
        {
            if (uid != this.uid)
            {
                return;
            }
            this.avatar = bitmap;
            var flip:* = this.internal_flipped;
            var u:Object = Extdata.GetUserData(uid);
            if (u)
            {
                if (u.avatar.indexOf("//") >= 0)
                {
                    flip = false;
                }
            }
            this.avatar.width = Math.round(this.width * scale) / scale * (70 / this.width);
            this.avatar.height = this.avatar.width;
            this.avatar.scaleX *= !!flip ? -1 : 1;
            this.avatar.x = !!flip ? int(this.avatar.width) : 0;
            this.avatar.y = 0;
            this.addChild(bitmap);
            (this.avatar as Bitmap).smoothing = true;
            this.visible = true;
            this.CallCallback(readyCallback, readyParams);
        }

        private function CallCallback(readyCallback:Function = null, readyParams:Array = null):void
        {
            if (Boolean(readyCallback))
            {
                if (readyParams)
                {
                    readyCallback.apply(null, readyParams);
                }
                else
                {
                    readyCallback();
                }
            }
        }

        private function OnClick(e:*):void
        {
            var pr3:Object = null;
            if (Modules.GetClass("uibase", "uibase.ScrollBarMov").global_dragging)
            {
                return;
            }
            var pr:Object = Modules.GetClass("profile", "profile.Profile");
            if (Boolean(pr) && Boolean(pr.mc))
            {
                WinMgr.OpenWindow("settings.AvatarWin", {
                            "strdef": Sys.mydata.customavatar,
                            "previewmc": null,
                            "callback": null
                        });
                return;
            }
            var pr2:Object = Modules.GetClass("profile2", "profile2.Profile2");
            if (Boolean(pr2) && Boolean(pr2.mc))
            {
                if (this.uid == Sys.mydata.id)
                {
                    WinMgr.OpenWindow("settings.AvatarWin", {
                                "strdef": Sys.mydata.customavatar,
                                "previewmc": null,
                                "callback": null
                            });
                    return;
                }
            }
            if (Sys.mydata.name == "")
            {
                WinMgr.OpenWindow("settings.AvatarWin", {
                            "strdef": Sys.mydata.customavatar,
                            "previewmc": null,
                            "callback": null
                        });
            }
            else
            {
                pr3 = Modules.GetClass("profile2", "profile2.Profile2");
                if (Boolean(pr3) && Boolean(pr3.mc))
                {
                    WinMgr.RemoveWindow("profile2.Profile2");
                    WinMgr.OpenWindow("profile2.Profile2", {"user_id": this.uid});
                }
                else
                {
                    WinMgr.OpenWindow("profile2.Profile2", {"user_id": this.uid});
                }
            }
        }
    }
}
