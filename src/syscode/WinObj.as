package syscode
{
    import flash.display.MovieClip;
    import flash.utils.*;

    public class WinObj
    {
        public function WinObj(aclass:Object, aprops:Object)
        {
            var arr:Array = null;
            super();
            if (aprops)
            {
                this.properties = aprops;
            }
            else
            {
                this.properties = {};
            }
            this.properties.openanim = false;
            this.properties.canclose = true;
            if (aclass is Class)
            {
                this.winclass = aclass;
                this.classname = getQualifiedClassName(this.winclass);
                arr = String(this.classname).split(".");
                this.modulename = arr[0];
            }
            else
            {
                if (!(aclass is String))
                {
                    throw new Error("WinMgr: invalid window class: " + typeof aclass);
                }
                this.classname = String(aclass);
                arr = this.classname.split(".");
                this.modulename = arr[0];
                if (!Modules.GetModuleUrl(this.modulename))
                {
                    throw new Error("WinMgr: Module not found for the window: \"" + aclass + "\"");
                }
                if (Modules.Loaded(this.modulename))
                {
                    this.winclass = Modules.GetClass(this.modulename, this.classname);
                    if (!this.winclass)
                    {
                        throw new Error("WinMgr: window class \"" + this.classname + "\" not found in module \"" + this.modulename + "\"");
                    }
                    this.loaded = true;
                }
                else
                {
                    this.winclass = null;
                    this.loaded = false;
                }
            }
        }
        public var mc:MovieClip = null;
        public var winclass:Object;
        public var classname:String;
        public var modulename:String;
        public var properties:Object;
        public var loaded:Boolean = true;

        public function BackHandler(event:Object):void
        {
            var canclose:Boolean = true;
            if (this.properties.canclose !== undefined && this.properties.canclose != null)
            {
                canclose = Boolean(this.properties.canclose);
            }
            if (Boolean(this.mc.hasOwnProperty("CanClose")) && typeof this.mc["CanClose"] == "function")
            {
                canclose = Boolean(this.mc["CanClose"].apply(this.mc));
            }
            if (canclose)
            {
                WinMgr.CloseWindow(this.mc);
            }
        }

        public function Dispose():void
        {
            this.mc = null;
            this.winclass = null;
            this.classname = null;
            this.modulename = null;
            this.properties = null;
            this.loaded = false;
        }
    }
}
