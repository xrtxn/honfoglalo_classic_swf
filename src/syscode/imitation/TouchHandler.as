package syscode.imitation
{
    import flash.display.*;
    import flash.geom.*;

    import syscode.Imitation;

    public class TouchHandler
    {
        public static var validhandlers:Array = ["click", "mousemove", "mousedown", "mouseup", "mouseover", "mouseout"];

        public function TouchHandler(aobj:DisplayObject)
        {
            this.handlers = {};
            super();
            this.obj = aobj;
        }
        public var obj:DisplayObject = null;
        public var buttonstop:Boolean = false;
        public var usehandcursor:Boolean = false;
        public var handlers:Object;

        public function SetHandler(atype:String, afunc:Function, aparams:Object = null):*
        {
            var pn:String = null;
            var htype:String = atype.toLocaleLowerCase();
            if (validhandlers.indexOf(htype) < 0)
            {
                throw new Error("Invalid touch event type: " + htype);
            }
            var h:Object = {
                    "func": afunc,
                    "params": {}
                };
            if (aparams)
            {
                for (pn in aparams)
                {
                    h.params[pn] = aparams[pn];
                }
            }
            this.handlers[atype] = h;
            if (afunc == null)
            {
                delete this.handlers[atype];
                if (atype == "click")
                {
                    this.usehandcursor = false;
                }
            }
            else if (atype == "click")
            {
                this.usehandcursor = true;
            }
        }

        public function HandleEvent(atype:String, evdata:Object):Boolean
        {
            var h:Object = this.handlers[atype];
            if (!h)
            {
                return false;
            }
            var e:Object = {};
            e.target = this.obj;
            e.params = h.params;
            e.stageX = evdata.stageX;
            e.stageY = evdata.stageY;
            e.buttonDown = evdata.buttonDown;
            var pt:Point = Imitation.GlobalToLocal(new Point(e.stageX, e.stageY), this.obj);
            e.localX = pt.x;
            e.localY = pt.y;
            if (h.func)
            {
                h.func.apply(null, [e]);
                return true;
            }
            return false;
        }
    }
}
