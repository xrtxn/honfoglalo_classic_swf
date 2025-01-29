package syscode.imitation
{
    import flash.display.*;
    import flash.events.*;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import flash.utils.*;

    import syscode.*;

    public class TouchManager
    {
        public static var stageX:Number;

        public static var stageY:Number;

        public static var traceEvents:Boolean = false;

        public static var mouseDownPoint:MovieClip = null;

        public static var mouseUpPoint:MovieClip = null;

        public static var handlers:Vector.<TouchHandler> = null;

        public static var objects:Vector.<DisplayObject> = null;

        public static var masks:Dictionary = null;

        public static var maskeds:Dictionary = null;

        public static var frozens:Dictionary = null;

        public static var mainmc:DisplayObject = null;

        public static var stage:Stage = null;

        public static var mousedown:Boolean = false;

        public static var activeHandler:TouchHandler = null;

        public static var passiveHandler:TouchHandler = null;

        public static var touchTestMode:Boolean = false;

        public static var lastTestEvent:MouseEvent = null;

        public static function Init(amain:DisplayObject, astage:Stage):void
        {
            handlers = new Vector.<TouchHandler>();
            objects = new Vector.<DisplayObject>();
            masks = new Dictionary(true);
            maskeds = new Dictionary(true);
            frozens = new Dictionary(true);
            mainmc = amain;
            stage = astage;
            Util.AddEventListener(stage, "mouseDown", handleMouseDown);
            Util.AddEventListener(stage, "mouseUp", handleMouseUp);
            Util.AddEventListener(stage, Event.ENTER_FRAME, function():*
                {
                    if (stageX != stage.mouseX || stageY != stage.mouseY)
                    {
                        handleMouseMove({
                                    "stageX": stage.mouseX,
                                    "stageY": stage.mouseY
                                });
                    }
                });
        }

        public static function handleMouseDown(event:*, excludedobjs:Array = null):void
        {
            var missclick:MouseEvent = null;
            TouchManager.ShowMouseDownPoint(event.stageX, event.stageY);
            mousedown = true;
            if (touchTestMode && Boolean(lastTestEvent))
            {
                lastTestEvent.localX = lastTestEvent.stageX;
                lastTestEvent.localY = lastTestEvent.stageY;
                stage.dispatchEvent(lastTestEvent);
            }
            var th:TouchHandler = FindHandlerAt(event.stageX, event.stageY, excludedobjs);
            if (th)
            {
                passiveHandler = th;
                th.HandleEvent("mousedown", event);
            }
            else
            {
                missclick = new MouseEvent("missclick");
                missclick.localX = event.stageX;
                missclick.localY = event.stageY;
                stage.dispatchEvent(missclick);
            }
        }

        public static function handleMouseUp(event:*, excludedobjs:Array = null):void
        {
            var th:TouchHandler = null;
            TouchManager.ShowMouseUpPoint(event.stageX, event.stageY);
            mousedown = false;
            if (passiveHandler != null)
            {
                passiveHandler.HandleEvent("mouseup", event);
                th = FindHandlerAt(event.stageX, event.stageY, excludedobjs);
                if (passiveHandler == th)
                {
                    th.HandleEvent("click", event);
                }
            }
            passiveHandler = null;
        }

        public static function CheckMouseOut():*
        {
            if (touchTestMode && !mousedown)
            {
                return;
            }
            var th:TouchHandler = FindHandlerAt(stage.mouseX, stage.mouseY);
            if (activeHandler != null && activeHandler != th)
            {
                handleMouseMove({
                            "stageX": stage.mouseX,
                            "stageY": stage.mouseY
                        });
                Mouse.hide();
                Mouse.show();
            }
        }

        public static function handleMouseMove(event:*, excludedobjs:Array = null):void
        {
            if (touchTestMode)
            {
                if (!mousedown)
                {
                    lastTestEvent = event;
                    return;
                }
            }
            stageX = stage.mouseX;
            stageY = stage.mouseY;
            var th:TouchHandler = FindHandlerAt(event.stageX, event.stageY, excludedobjs);
            if (activeHandler != null && activeHandler != th && (!excludedobjs || excludedobjs.indexOf(activeHandler.obj) == -1))
            {
                activeHandler.HandleEvent("mouseout", event);
            }
            var usehandcursor:Boolean = false;
            if (th)
            {
                usehandcursor = th.usehandcursor;
                if (th != activeHandler)
                {
                    th.HandleEvent("mouseover", event);
                }
                th.HandleEvent("mousemove", event);
            }
            activeHandler = th;
            if (usehandcursor)
            {
                Mouse.cursor = MouseCursor.BUTTON;
            }
            else
            {
                Mouse.cursor = MouseCursor.AUTO;
            }
        }

        public static function ShowMouseDownPoint(x:Number, y:Number):void
        {
            if (TouchManager.traceEvents)
            {
                if (TouchManager.mouseDownPoint == null)
                {
                    TouchManager.mouseDownPoint = new MovieClip();
                    TouchManager.mouseDownPoint.graphics.lineStyle(0);
                    TouchManager.mouseDownPoint.graphics.beginFill(16711680, 1);
                    TouchManager.mouseDownPoint.graphics.drawCircle(5, 5, 5);
                    TouchManager.mouseDownPoint.graphics.endFill();
                    TouchManager.mouseDownPoint.mouseEnabled = false;
                    TouchManager.mouseDownPoint.cacheAsBitmap = true;
                    TouchManager.mouseDownPoint.width = 10;
                    TouchManager.mouseDownPoint.height = 10;
                }
                if (TouchManager.mouseDownPoint.parent == TouchManager.stage)
                {
                    TouchManager.stage.removeChild(TouchManager.mouseDownPoint);
                }
                TouchManager.stage.addChild(TouchManager.mouseDownPoint);
                TouchManager.mouseDownPoint.x = x - 5;
                TouchManager.mouseDownPoint.y = y - 5;
            }
        }

        public static function ShowMouseUpPoint(x:Number, y:Number):void
        {
            if (TouchManager.traceEvents)
            {
                if (TouchManager.mouseUpPoint == null)
                {
                    TouchManager.mouseUpPoint = new MovieClip();
                    TouchManager.mouseUpPoint.graphics.lineStyle(0);
                    TouchManager.mouseUpPoint.graphics.beginFill(65280, 1);
                    TouchManager.mouseUpPoint.graphics.drawCircle(5, 5, 5);
                    TouchManager.mouseUpPoint.graphics.endFill();
                    TouchManager.mouseUpPoint.mouseEnabled = false;
                    TouchManager.mouseUpPoint.cacheAsBitmap = true;
                    TouchManager.mouseUpPoint.width = 10;
                    TouchManager.mouseUpPoint.height = 10;
                }
                if (TouchManager.mouseUpPoint.parent == TouchManager.stage)
                {
                    TouchManager.stage.removeChild(TouchManager.mouseUpPoint);
                }
                TouchManager.stage.addChild(TouchManager.mouseUpPoint);
                TouchManager.mouseUpPoint.x = x - 5;
                TouchManager.mouseUpPoint.y = y - 5;
            }
        }

        public static function FindHandlerAt(x:Number, y:Number, aexcludedobjs:Array = null):TouchHandler
        {
            var i:int = 0;
            var th:TouchHandler = null;
            var hit:Boolean = false;
            var pobj:DisplayObject = null;
            var list:* = undefined;
            var higher:* = undefined;
            var j:int = 0;
            var excluded:Array = aexcludedobjs != null ? aexcludedobjs : [];
            var hitlist:Vector.<TouchHandler> = new Vector.<TouchHandler>();
            for (i = int(handlers.length - 1); i >= 0; i--)
            {
                th = handlers[i];
                hit = th.obj.visible && th.obj.getRect(mainmc).contains(x, y);
                if (hit && th.obj is InteractiveObject && !InteractiveObject(th.obj).mouseEnabled)
                {
                    hit = false;
                }
                if (excluded.indexOf(th.obj) >= 0)
                {
                    hit = false;
                }
                if (hit)
                {
                    pobj = th.obj.parent;
                    while (pobj != mainmc)
                    {
                        if (pobj == null || !pobj.visible || pobj is InteractiveObject && !InteractiveObject(pobj).mouseEnabled)
                        {
                            hit = false;
                            break;
                        }
                        if (frozens[pobj])
                        {
                            hit = false;
                            break;
                        }
                        if (maskeds[pobj])
                        {
                            if (!maskeds[pobj].getRect(mainmc).contains(x, y))
                            {
                                hit = false;
                                break;
                            }
                        }
                        pobj = pobj.parent;
                    }
                }
                if (hit)
                {
                    hitlist.push(th);
                }
            }
            if (hitlist.length == 0)
            {
                return null;
            }
            if (hitlist.length == 1)
            {
                return hitlist[0];
            }
            var maxlist:Array = MakeChildIndexList(hitlist[0].obj);
            var maxindex:int = 0;
            for (i = 1; i < hitlist.length; i++)
            {
                list = MakeChildIndexList(hitlist[i].obj);
                higher = false;
                j = 0;
                while (j < Math.max(list.length, maxlist.length))
                {
                    if (j >= maxlist.length)
                    {
                        higher = true;
                        break;
                    }
                    if (j >= list.length)
                    {
                        higher = false;
                        break;
                    }
                    if (list[j] > maxlist[j])
                    {
                        higher = true;
                        break;
                    }
                    if (list[j] < maxlist[j])
                    {
                        higher = false;
                        break;
                    }
                    j++;
                }
                if (higher)
                {
                    maxlist = list;
                    maxindex = i;
                }
            }
            return hitlist[maxindex];
        }

        public static function DeleteGroup(agroup:DisplayObject):void
        {
            var ingroup:Boolean = false;
            var linger:Boolean = false;
            var pobj:DisplayObject = null;
            var n:int = 0;
            var mobj:* = undefined;
            var th:TouchHandler = null;
            n = 0;
            while (n < handlers.length)
            {
                th = handlers[n];
                ingroup = false;
                linger = false;
                pobj = th.obj;
                while (pobj != null && pobj != mainmc)
                {
                    if (pobj == agroup)
                    {
                        ingroup = true;
                        break;
                    }
                    pobj = pobj.parent;
                }
                if (ingroup || pobj == null)
                {
                    th.obj = null;
                    handlers.splice(n, 1);
                    objects.splice(n, 1);
                }
                else
                {
                    n++;
                }
                th = null;
            }
            for (mobj in masks)
            {
                ingroup = false;
                while (mobj != null && mobj != mainmc)
                {
                    if (mobj == agroup)
                    {
                        ingroup = true;
                        break;
                    }
                    mobj = mobj.parent;
                }
                if (ingroup || mobj == null)
                {
                    RemoveMask(mobj);
                }
            }
        }

        public static function GetHandler(aobj:DisplayObject):TouchHandler
        {
            var i:int = int(objects.indexOf(aobj));
            if (i >= 0)
            {
                return handlers[i];
            }
            var th:TouchHandler = new TouchHandler(aobj);
            handlers.push(th);
            objects.push(th.obj);
            return th;
        }

        public static function AddButtonStop(aobj:DisplayObject):TouchHandler
        {
            var th:TouchHandler = GetHandler(aobj);
            th.buttonstop = true;
            return th;
        }

        public static function RemoveHandler(aobj:DisplayObject):*
        {
            var i:int = int(objects.indexOf(aobj));
            if (i >= 0)
            {
                objects.splice(i, 1);
                handlers.splice(i, 1);
            }
        }

        public static function AddEventHandler(aobj:DisplayObject, atype:String, afunc:Function, aparams:Object = null):*
        {
            var th:TouchHandler = GetHandler(aobj);
            th.SetHandler(atype, afunc, aparams);
        }

        public static function AddMask(maskmov:DisplayObject, maskedmov:DisplayObject):void
        {
            if (!masks[maskmov])
            {
                masks[maskmov] = true;
            }
            if (!maskeds[maskedmov])
            {
                maskeds[maskedmov] = maskmov;
            }
        }

        public static function RemoveMask(maskobj:DisplayObject):void
        {
            var d:* = undefined;
            for (d in maskeds)
            {
                if (maskeds[d] == maskobj)
                {
                    delete maskeds[d];
                }
            }
            delete masks[maskobj];
        }

        public static function Freeze(aobj:DisplayObject):void
        {
            if (!frozens[aobj])
            {
                frozens[aobj] = true;
            }
        }

        public static function UnFreeze(aobj:DisplayObject):void
        {
            delete frozens[aobj];
        }

        public static function UnFreezeAll():void
        {
            var d:* = undefined;
            for (d in frozens)
            {
                delete frozens[d];
            }
        }

        private static function MakeChildIndexList(aobj:DisplayObject):Array
        {
            var pobj:DisplayObject = aobj;
            var result:Array = [];
            while (pobj.parent != null)
            {
                result.unshift(pobj.parent.getChildIndex(pobj));
                pobj = pobj.parent;
            }
            return result;
        }

        public function TouchManager()
        {
            super();
        }
    }
}
