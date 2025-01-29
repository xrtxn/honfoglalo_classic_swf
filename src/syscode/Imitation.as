package syscode
{
    import flash.display.*;
    import flash.display3D.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.*;
    import flash.system.Capabilities;
    import flash.text.TextField;
    import flash.ui.ContextMenu;
    import flash.utils.*;

    import syscode.imitation.*;

    public class Imitation
    {
        public static var gsqc:*;
        public static var active:Boolean = false;
        public static var usegpu:Boolean = false;
        public static var texturerendering:Boolean = true;
        public static var stage3d_error_checking:Boolean = true;
        public static var extendedcontext:Boolean = false;
        public static var TARGETDPI:int = 600;
        public static var MAXTEXTURE:int = 1024;
        public static var maxtexturesize:int = 1024;
        public static var dpirate:Number = 1;
        public static var width:int = 1920;
        public static var height:int = 1080;
        public static var driverinfo:String = "oldschool";
        public static var showregions:* = false;
        public static var stage:Stage = null;
        public static var mainmc:MovieClip = null;
        public static var rootmc:MovieClip = null;
        public static var imitators:Dictionary = new Dictionary(true);
        public static var projmatrix:Matrix = new Matrix();
        public static var identitymatrix:Matrix = new Matrix();
        public static var stage3D:Stage3D = null;
        public static var context:Context3D = null;
        public static var activerendertarget:Imitator = null;
        public static var activerenderhalfwidth:Number = 1;
        public static var activerenderhalfheight:Number = 1;
        public static var activerenderpix:Number = 1;
        public static var showhot:Boolean = false;
        public static var color_gimage:GpuImage = null;
        public static var color_gimage2:GpuImage = null;
        public static var restoring:Boolean = false;
        private static var dragX:Number;
        private static var dragY:Number;
        private static var dragRect:Rectangle;
        private static var root:Imitator = null;
        private static var flamc:MovieClip = null;
        private static var initcallback:Function = null;
        private static var mainsceneclass:Class = null;
        private static var quadvertexes:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0]);
        private static var quadindexes:Vector.<uint> = Vector.<uint>([0, 1, 2, 0, 3, 2]);
        private static var quadvertbuf:VertexBuffer3D = null;
        private static var quadindexbuf:IndexBuffer3D = null;
        private static var renderCycles:uint = 0;
        private static var updateTimes:uint = 0;
        private static var renderTimes:uint = 0;
        private static var dragObj:DisplayObject = null;

        public static function Init(aflamc:MovieClip, amainsceneclass:Class, callback:Function):*
        {
            flamc = aflamc;
            stage = flamc.stage;
            mainsceneclass = amainsceneclass;
            initcallback = callback;
            flamc.stage.scaleMode = StageScaleMode.NO_SCALE;
            flamc.stage.align = StageAlign.TOP_LEFT;
            if (usegpu)
            {
                CreateContext();
            }
            else
            {
                DetectMaxTextureSize();
                InitRoot();
            }
        }

        public static function CheckContext():Boolean
        {
            var c:Context3D = null;
            if (!Imitation.usegpu)
            {
                return true;
            }
            if (Imitation.stage3D != null)
            {
                c = stage3D.context3D;
                if (c != null)
                {
                    if (c.driverInfo != "Disposed")
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        public static function SetContextMenu(contextMenu:ContextMenu):void
        {
            flamc.contextMenu = contextMenu;
        }

        public static function GlobalToLocal(pt:Point, obj:DisplayObject):Point
        {
            var m:Matrix = null;
            var matlist:Array = [];
            var o:DisplayObject = obj;
            while (o != null && o != rootmc)
            {
                matlist.unshift(o.transform.matrix);
                o = o.parent;
            }
            var mat:Matrix = new Matrix();
            for each (m in matlist)
            {
                mat.concat(m);
            }
            mat.invert();
            return mat.transformPoint(pt);
        }

        public static function ConfigureProjection(stw:int, sth:int):void
        {
            projmatrix.a = 2 / stw;
            projmatrix.d = -2 / sth;
            projmatrix.tx = -1;
            projmatrix.ty = 1;
            context.configureBackBuffer(stw, sth, 0, false);
        }

        public static function StageResized(stw:int, sth:int):void
        {
            if (stw != Imitation.width || sth != Imitation.height)
            {
                DetectMaxTextureSize();
                if (usegpu && CheckContext())
                {
                    ConfigureProjection(stw, sth);
                }
                restoring = true;
                FreeBitmapAll();
            }
        }

        public static function GotoFrame(obj:MovieClip, aframe:*, aregenbmpnow:Boolean = true):void
        {
            var prevframe:int = obj.currentFrame;
            obj.gotoAndStop(aframe);
            if (obj.currentFrame == prevframe)
            {
                return;
            }
            if (obj.cacheAsBitmap)
            {
                Imitation.FreeBitmapAll(obj);
            }
            else
            {
                Imitation.CollectChildrenAll(obj);
            }
            if (aregenbmpnow)
            {
                Imitation.UpdateAll(obj);
            }
        }

        public static function DrawQuad():void
        {
            context.drawTriangles(quadindexbuf, 0, 2);
        }

        public static function SetRenderTarget(im:Imitator, awidth:Number = 0, aheight:Number = 0):void
        {
            if (awidth == 0)
            {
                awidth = stage.stageWidth;
            }
            if (aheight == 0)
            {
                aheight = stage.stageHeight;
            }
            activerenderhalfwidth = awidth / 2;
            activerenderhalfheight = aheight / 2;
            activerenderpix = 1 / awidth;
            if (activerendertarget == im)
            {
                return;
            }
            activerendertarget = im;
        }

        public static function Render():*
        {
            if (!usegpu)
            {
                return;
            }
            if (!Imitation.CheckContext())
            {
                return;
            }
            var c:Context3D = stage3D.context3D;
            SetRenderTarget(null);
            c.clear((stage.color >> 16 & 0xFF) / 255, (stage.color >> 8 & 0xFF) / 255, (stage.color >> 0 & 0xFF) / 255, (stage.color >> 24 & 0xFF) / 255);
            GpuImage.renderCount = 0;
            GpuImage.renderSurface = 0;
            GpuImage.renderCollect = true;
            root.GpuRender(projmatrix, 1);
            GpuImage.renderCollect = false;
            c.present();
        }

        public static function Restart():void
        {
            Imitation.active = true;
        }

        public static function Stop():void
        {
            Imitation.FreeBitmapAll();
            Imitation.active = false;
        }

        public static function UpdateFrame():void
        {
            var t3:int = 0;
            if (!Imitation.active)
            {
                return;
            }
            var t1:int = 0;
            var t2:int = 0;
            if (usegpu)
            {
                t1 = int(getTimer());
            }
            if (dragObj)
            {
                UpdateDrag();
            }
            UpdateAll();
            if (usegpu)
            {
                t2 = int(getTimer());
            }
            Render();
            if (usegpu)
            {
                t3 = int(getTimer());
                ++Imitation.renderCycles;
                Imitation.updateTimes = Imitation.updateTimes + (t2 - t1);
                Imitation.renderTimes = Imitation.renderTimes + (t3 - t2);
            }
        }

        public static function Update(obj:DisplayObject):void
        {
            var im:Imitator = null;
            if (!Imitation.active)
            {
                return;
            }
            if (Imitation.root != null)
            {
                im = Imitation.FindImitator(obj);
                if (im)
                {
                    im.CollectChildren();
                    if (im.obj.cacheAsBitmap)
                    {
                        im.FreeBitmap();
                    }
                    im.UpdateAll();
                }
            }
        }

        public static function UpdateAll(aobj:DisplayObject = null):void
        {
            var startTime:int = 0;
            var im:Imitator = null;
            if (!Imitation.active)
            {
                return;
            }
            if (Boolean(aobj) && Imitation.root != null)
            {
                startTime = int(getTimer());
                im = Imitation.FindImitator(aobj);
                if (im)
                {
                    im.UpdateAll();
                }
                Imitation.gsqc.InsertDelayForNext((getTimer() - startTime) / 1000);
            }
            else if (Imitation.root != null)
            {
                Imitation.root.UpdateAll();
                TouchManager.CheckMouseOut();
                restoring = false;
            }
        }

        public static function UpdateToDisplay(aobj:DisplayObject = null, withchildren:Boolean = false):void
        {
            var im:Imitator = null;
            if (!usegpu)
            {
                im = Imitation.FindImitator(aobj);
                if (im)
                {
                    im.UpdateProperties();
                    if (withchildren)
                    {
                        UpdateToDisplayChildren(im);
                    }
                }
            }
        }

        public static function ChangeParent(aobj:DisplayObject, atarget:DisplayObjectContainer):void
        {
            var i:int = 0;
            if (aobj.parent)
            {
                if (aobj.parent == atarget)
                {
                    return;
                }
                aobj.parent.removeChild(aobj);
            }
            atarget.addChild(aobj);
            var im:Imitator = Imitation.FindImitator(aobj);
            if (!im)
            {
                return;
            }
            var targetim:Imitator = Imitation.FindImitator(atarget);
            if (!targetim)
            {
                return;
            }
            if (im.parent == targetim)
            {
                return;
            }
            var fspr:Sprite = null;
            if (im)
            {
                i = int(im.parent.children.indexOf(im));
                if (i >= 0)
                {
                    im.parent.children.splice(i, 1);
                    i = int(im.parent.fchildren.indexOf(im.obj));
                    if (i >= 0)
                    {
                        im.parent.fchildren.splice(i, 1);
                    }
                    if (!usegpu)
                    {
                        fspr = im.fspr;
                    }
                }
            }
            if (fspr)
            {
                targetim.fspr.addChild(fspr);
            }
            im.parent = targetim;
            targetim.children.push(im);
            targetim.fchildren.push(im.obj);
        }

        public static function CollectChildren(aobj:DisplayObject = null):void
        {
            var im:Imitator = null;
            if (!Imitation.active)
            {
                return;
            }
            if (Boolean(aobj) && Imitation.root != null)
            {
                im = Imitation.FindImitator(aobj);
                if (im)
                {
                    im.CollectChildren();
                }
            }
            else if (Imitation.root != null)
            {
                Imitation.root.CollectChildren();
            }
        }

        public static function CollectChildrenAll(aobj:DisplayObject = null):void
        {
            var im:Imitator = null;
            if (!Imitation.active)
            {
                return;
            }
            if (Boolean(aobj) && Imitation.root != null)
            {
                im = Imitation.FindImitator(aobj);
                if (im)
                {
                    im.CollectChildrenAll();
                }
            }
            else if (Imitation.root != null)
            {
                Imitation.root.CollectChildrenAll();
            }
        }

        public static function FreeBitmapAll(aobj:DisplayObject = null):void
        {
            var im:Imitator = null;
            if (!Imitation.active)
            {
                return;
            }
            if (aobj)
            {
                im = Imitation.FindImitator(aobj);
                if (im)
                {
                    im.FreeBitmapAll();
                }
            }
            else if (Imitation.root != null)
            {
                Imitation.root.FreeBitmapAll();
            }
        }

        public static function FreeBitmap(aobj:DisplayObject):void
        {
            if (!Imitation.active)
            {
                return;
            }
            var im:Imitator = Imitation.FindImitator(aobj);
            if (im)
            {
                im.FreeBitmap();
            }
        }

        public static function Combine(obj:DisplayObject, acombine:Boolean):void
        {
            var t1:int = 0;
            var t2:int = 0;
            var t3:int = 0;
            if (!Imitation.active)
            {
                return;
            }
            var im:Imitator = Imitation.FindImitator(obj);
            if (im)
            {
                t1 = int(getTimer());
                if (acombine)
                {
                    im.CollectChildrenAll();
                }
                t2 = int(getTimer());
                im.Combine(acombine);
                t3 = int(getTimer());
                if (!acombine)
                {
                    im.CollectChildrenAll();
                }
                if (acombine)
                {
                }
            }
        }

        public static function SetMaskedMov(maskmov:DisplayObject, maskedmov:DisplayObject, alphamask:Boolean = false, achangingmask:Boolean = false):void
        {
            if (!maskedmov)
            {
            }
            var mim:Imitator = Imitation.FindImitator(maskmov);
            if (mim)
            {
                mim.SetMaskedMov(maskedmov, alphamask, achangingmask);
            }
        }

        public static function AddEventMask(maskmov:DisplayObject, maskedmov:DisplayObject):void
        {
            TouchManager.AddMask(maskmov, maskedmov);
        }

        public static function RemoveEventMask(maskmov:DisplayObject):void
        {
            TouchManager.RemoveMask(maskmov);
        }

        public static function FreezeEvents(aobj:DisplayObject):void
        {
            TouchManager.Freeze(aobj);
        }

        public static function UnFreezeEvents(aobj:DisplayObject):void
        {
            TouchManager.UnFreeze(aobj);
        }

        public static function UnFreezeAllEvents():void
        {
            TouchManager.UnFreezeAll();
        }

        public static function SetFocus(obj:DisplayObject):void
        {
            var im:Imitator = null;
            if (Imitation.root != null)
            {
                im = Imitation.FindImitator(obj);
                if (im)
                {
                    if (im.input != null)
                    {
                        Imitation.stage.focus = im.input;
                    }
                }
            }
        }

        public static function SetColor(dobj:DisplayObject, color:uint):void
        {
            trace("Imitation.SetColor color:", color);
            var i:int = 0;
            var imc:Imitator = null;
            var c:ColorTransform = new ColorTransform();
            c.color = color;
            dobj.transform.colorTransform = c;
            var im:Imitator = FindImitator(dobj);
            if (im)
            {
                im.colorTransform = dobj.transform.concatenatedColorTransform;
                im.colorTransform.alphaMultiplier = 1;
                im.colorTransform.alphaOffset = 0;
                i = 0;
                while (i < im.children.length)
                {
                    imc = im.children[i];
                    imc.colorTransform = im.colorTransform;
                    i++;
                }
                im.FreeBitmapAll();
            }
        }

        public static function SetColorMultiplier(dobj:DisplayObject, ct:ColorTransform):void
        {
            trace("SetColorMultiplier");
            trace("dobj:", dobj);
            trace("ct:", ct);
            var im:Imitator = FindImitator(dobj);
            if (im)
            {
                im.colorMultiplier = ct;
            }
        }

        public static function SetBoundsBorder(amov:DisplayObject, border:Number):void
        {
            var im:Imitator = Imitation.FindImitator(amov);
            if (!im)
            {
                Imitation.root.CollectChildrenAll();
                im = Imitation.FindImitator(amov);
            }
            if (im)
            {
                im.boundsborder = border;
            }
        }

        public static function SetBitmapScale(amov:DisplayObject, ascale:Number):void
        {
            var im:Imitator = Imitation.FindImitator(amov);
            if (!im)
            {
                Imitation.root.CollectChildrenAll();
                im = Imitation.FindImitator(amov);
            }
            if (im)
            {
                im.SetBitmapScale(ascale);
            }
        }

        public static function CreateClone(aclonedmov:DisplayObject, atargetmov:DisplayObjectContainer):MovieClip
        {
            var targetim:Imitator = Imitation.FindImitator(atargetmov);
            if (!targetim)
            {
                Imitation.root.CollectChildrenAll();
                targetim = Imitation.FindImitator(atargetmov);
            }
            if (!targetim)
            {
                throw new Error("CreateClone failed: target mov imitator not found!!!");
            }
            var clonedim:Imitator = Imitation.FindImitator(aclonedmov);
            if (!clonedim)
            {
                Imitation.root.CollectChildrenAll();
                clonedim = Imitation.FindImitator(aclonedmov);
            }
            if (!clonedim)
            {
                throw new Error("CreateClone failed: cloned mov imitator not found!!!");
            }
            if (clonedim.cloneof)
            {
                throw new Error("CloneImage failed: cloned image is cloned !");
            }
            if (!clonedim.obj.cacheAsBitmap)
            {
                clonedim.obj.cacheAsBitmap = true;
                clonedim.CollectChildren();
            }
            var result:MovieClip = new MovieClip();
            result.cacheAsBitmap = true;
            atargetmov.addChild(result);
            targetim.CollectChildren();
            var resultim:Imitator = targetim.FindImitator(result);
            if (!resultim)
            {
                throw new Error("CloneImage bigfuck: result imitator not found !!!");
            }
            resultim.cloneof = clonedim;
            return result;
        }

        public static function EnableInput(amov:DisplayObject, aenable:Boolean):void
        {
            var im:Imitator = Imitation.FindImitator(amov);
            if (im)
            {
                im.EnableInput(aenable);
            }
        }

        public static function RTLEditSetup(tf:TextField):*
        {
            if (!Config.rtl)
            {
                return;
            }
            var im:Imitator = Imitation.FindImitator(tf);
            if (im)
            {
                im.rtl = true;
                if (im.input)
                {
                    if (!im.rtl_util)
                    {
                        im.rtl_util = new RtlUtil();
                    }
                    im.rtl_util.RTLEditSetup(im.input);
                    SetRTLEditText(tf, tf.text);
                }
                im.UpdateInput(tf as TextField);
            }
        }

        public static function SetRTLEditText(tf:TextField, value:String):void
        {
            tf.text = value;
            if (!Config.rtl)
            {
                return;
            }
            var im:Imitator = Imitation.FindImitator(tf);
            if (im && im.rtl && im.rtl_util && Boolean(im.rtl_util.eo))
            {
                im.rtl_util.SetRTLEditText(value);
            }
        }

        public static function GetRTLEditText(tf:TextField):String
        {
            if (!Config.rtl)
            {
                return tf.text;
            }
            var im:Imitator = Imitation.FindImitator(tf);
            if (im && im.rtl && im.rtl_util && Boolean(im.rtl_util.eo))
            {
                return im.rtl_util.eo.realtext;
            }
            return "";
        }

        public static function GetMaxScrollV(tf:TextField):int
        {
            var im:Imitator = Imitation.FindImitator(tf);
            if (!im)
            {
                return 0;
            }
            if (im.rtl && im.rtl_util && Boolean(im.rtl_util.eo))
            {
                return im.rtl_util.tf.maxScrollV;
            }
            if (im.input)
            {
                return im.input.maxScrollV;
            }
            return 0;
        }

        public static function GetScrollV(tf:TextField):int
        {
            var im:Imitator = Imitation.FindImitator(tf);
            if (!im)
            {
                return 0;
            }
            if (im.rtl && im.rtl_util && Boolean(im.rtl_util.eo))
            {
                return im.rtl_util.tf.scrollV;
            }
            if (im.input)
            {
                return im.input.scrollV;
            }
            return 0;
        }

        public static function SetScrollV(tf:TextField, value:int):void
        {
            var im:Imitator = Imitation.FindImitator(tf);
            if (!im)
            {
                return;
            }
            if (im.rtl && im.rtl_util && Boolean(im.rtl_util.eo))
            {
                im.rtl_util.tf.scrollV = value;
            }
            else if (im.input)
            {
                im.input.scrollV = value;
            }
        }

        public static function Prepare(aobj:DisplayObject):*
        {
            var startTime:int = int(getTimer());
            var im:Imitator = Imitation.FindImitator(aobj);
            if (!im)
            {
                Imitation.root.CollectChildrenAll();
                im = Imitation.FindImitator(aobj);
                if (!im)
                {
                    return;
                }
            }
            im.UpdateAll();
            Imitation.gsqc.InsertDelayForNext((getTimer() - startTime) / 1000);
        }

        public static function CollectStats(obj:DisplayObject = null, detailed:Boolean = false):Object
        {
            var im:Imitator = obj == null ? root : FindImitator(obj);
            var statobj:* = {
                    "imitatornum": 0,
                    "invisibles": 0,
                    "caches": 0,
                    "childrens": 0,
                    "parents": 0,
                    "masks": 0,
                    "maskedchilds": 0,
                    "container": 0,
                    "details": []
                };
            if (im)
            {
                im.CollectStats(statobj, detailed);
            }
            statobj.count = Imitator.count;
            statobj.containers = Imitator.containers;
            return statobj;
        }

        public static function GetRenderStat():Object
        {
            var res:Object = {};
            res.textureCount = GpuImage.textureCount;
            res.textureSurface = GpuImage.textureSurface;
            res.renderCount = GpuImage.renderCount;
            res.renderSurface = GpuImage.renderSurface;
            res.generateCount = GpuImage.generateCount;
            res.generateTime = GpuImage.generateTime;
            GpuImage.generateCount = 0;
            GpuImage.generateTime = 0;
            res.renderCycles = Imitation.renderCycles;
            res.updateTimes = Imitation.updateTimes;
            res.renderTimes = Imitation.renderTimes;
            Imitation.renderCycles = 0;
            Imitation.updateTimes = 0;
            Imitation.renderTimes = 0;
            res.touchHandlers = TouchManager.handlers.length;
            res.touchMasks = TouchManager.masks.length;
            res.touchFrozens = TouchManager.frozens.length;
            return res;
        }

        public static function AddEventGroup(aobj:DisplayObject):*
        {
        }

        public static function AddButtonStop(aobj:DisplayObject):*
        {
            TouchManager.AddButtonStop(aobj);
        }

        public static function DeleteEventGroup(aobj:DisplayObject):*
        {
            TouchManager.DeleteGroup(aobj);
        }

        public static function AddEventClick(aobj:DisplayObject, afunc:Function, aparams:Object = null):*
        {
            TouchManager.AddEventHandler(aobj, "click", afunc, aparams);
        }

        public static function AddEventMouseMove(aobj:DisplayObject, afunc:Function, aparams:Object = null):*
        {
            TouchManager.AddEventHandler(aobj, "mousemove", afunc, aparams);
        }

        public static function AddEventMouseDown(aobj:DisplayObject, afunc:Function, aparams:Object = null):*
        {
            TouchManager.AddEventHandler(aobj, "mousedown", afunc, aparams);
        }

        public static function AddEventMouseUp(aobj:DisplayObject, afunc:Function, aparams:Object = null):*
        {
            TouchManager.AddEventHandler(aobj, "mouseup", afunc, aparams);
        }

        public static function AddEventMouseOver(aobj:DisplayObject, afunc:Function, aparams:Object = null):*
        {
            TouchManager.AddEventHandler(aobj, "mouseover", afunc, aparams);
        }

        public static function AddEventMouseOut(aobj:DisplayObject, afunc:Function, aparams:Object = null):*
        {
            TouchManager.AddEventHandler(aobj, "mouseout", afunc, aparams);
        }

        public static function RemoveEvents(aobj:DisplayObject):void
        {
            if (aobj)
            {
                TouchManager.RemoveHandler(aobj);
            }
        }

        public static function AddGlobalListener(name:String, callback:Function):void
        {
            if (Imitation.rootmc)
            {
                Util.AddEventListener(Imitation.rootmc, name, callback);
                Imitation.rootmc.addEventListener(name, callback);
            }
        }

        public static function RemoveGlobalListener(name:String, callback:Function):void
        {
            if (Imitation.rootmc)
            {
                Util.RemoveEventListener(Imitation.rootmc, name, callback);
            }
        }

        public static function DispatchGlobalEvent(name:String, event:Event = null):void
        {
            if (Imitation.rootmc)
            {
                if (event == null)
                {
                    event = new Event(name);
                }
                Imitation.rootmc.dispatchEvent(event);
            }
        }

        public static function AddStageEventListener(name:String, callback:Function):Function
        {
            var func:Function = callback;
            if (Imitation.stage)
            {
                if (TouchManager.touchTestMode)
                {
                    if (name == MouseEvent.MOUSE_MOVE)
                    {
                        func = function(e:*):*
                        {
                            if (TouchManager.mousedown)
                            {
                                callback(e);
                            }
                        };
                    }
                }
                Util.AddEventListener(Imitation.stage, name, func);
            }
            return func;
        }

        public static function RemoveStageEventListener(name:String, callback:Function):void
        {
            if (Imitation.stage)
            {
                Util.RemoveEventListener(Imitation.stage, name, callback);
            }
        }

        public static function DispatchStageEvent(name:String, event:Event = null):void
        {
            if (Imitation.stage)
            {
                if (event == null)
                {
                    event = new Event(name);
                }
                Imitation.stage.dispatchEvent(event);
            }
        }

        public static function HandleMouseDown(event:Object, excluedobjs:Array = null):void
        {
            TouchManager.handleMouseDown(event, excluedobjs);
        }

        public static function HandleMouseUp(event:Object, excluedobjs:Array = null):void
        {
            TouchManager.handleMouseUp(event, excluedobjs);
        }

        public static function HandleMouseMove(event:Object, excluedobjs:Array = null):void
        {
            TouchManager.handleMouseMove(event, excluedobjs);
        }

        public static function GetMousePos(aobj:DisplayObject = null):Point
        {
            var p:Point = new Point(TouchManager.stageX, TouchManager.stageY);
            if (aobj)
            {
                p = aobj.globalToLocal(p);
            }
            return p;
        }

        public static function StartDrag(aobj:DisplayObject, rect:Rectangle):void
        {
            var pt:Point = GetMousePos(aobj.parent);
            dragObj = aobj;
            dragX = pt.x - aobj.x;
            dragY = pt.y - aobj.y;
            dragRect = rect;
        }

        public static function UpdateDrag():void
        {
            if (!dragObj)
            {
                return;
            }
            var pt:Point = GetMousePos(dragObj.parent);
            dragObj.x = Math.max(dragRect.left, Math.min(dragRect.right, pt.x - dragX));
            dragObj.y = Math.max(dragRect.top, Math.min(dragRect.bottom, pt.y - dragY));
            DispatchStageEvent("mouseMove", new MouseEvent("mouseMove"));
        }

        public static function StopDrag():void
        {
            dragObj = null;
        }

        public static function CalculateBitmapScale(aobj:DisplayObject):Number
        {
            var im:Imitator = FindImitator(aobj);
            if (!im)
            {
                return 1;
            }
            return im.CalculateBitmapScale(aobj);
        }

        private static function CreateContext():*
        {
            trace("CreateContext()");
            stage3D = flamc.stage.stage3Ds[0];
            Util.AddEventListener(stage3D, "error", OnStage3DError);
            Util.AddEventListener(stage3D, Event.CONTEXT3D_CREATE, OnFirstContextCreated);
            stage3D.requestContext3D("auto", "baseline");
        }

        private static function OnFirstContextCreated(e:*):*
        {
            trace("OnFirstContextCreated(e:*) " + e);
            var c:Context3D = stage3D.context3D;
            trace("stage3D.context3D: " + c);
            Util.RemoveEventListener(stage3D, Event.CONTEXT3D_CREATE, OnFirstContextCreated);
            usegpu = c.driverInfo.toLowerCase().indexOf("software") < 0;
            trace("usegpu: " + usegpu);
            if (usegpu)
            {
                driverinfo = c.driverInfo;
                trace("c.driverInfo" + c.driverInfo);
                Util.AddEventListener(stage3D, Event.CONTEXT3D_CREATE, OnNewContextCreated);
                InitContext();
            }
            trace("initroot: ");
            InitRoot();
        }

        private static function DetectMaxTextureSize():int
        {
            Imitation.dpirate = Imitation.TARGETDPI / Math.max(Capabilities.screenDPI, Imitation.TARGETDPI);
            Imitation.width = stage.stageWidth;
            Imitation.height = stage.stageHeight;
            var s:int = Math.max(Imitation.width, Imitation.height);
            s = Math.ceil(s * Imitation.dpirate);
            Imitation.MAXTEXTURE = 1024;
            if (Config.ios)
            {
                Imitation.MAXTEXTURE = 512;
            }
            Imitation.maxtexturesize = Math.min(GpuImage.CalculatePot(s + 1), Imitation.MAXTEXTURE);
            return Imitation.maxtexturesize;
        }

        private static function InitContext():void
        {
            context = stage3D.context3D;
            var c:Context3D = context;
            DetectMaxTextureSize();
            c.enableErrorChecking = stage3d_error_checking;
            GpuShader.Init();
            c.setDepthTest(false, "always");
            c.setCulling("none");
            quadindexbuf = c.createIndexBuffer(quadindexes.length);
            quadindexbuf.uploadFromVector(quadindexes, 0, quadindexes.length);
            quadvertbuf = c.createVertexBuffer(quadvertexes.length / 3, 3);
            quadvertbuf.uploadFromVector(quadvertexes, 0, quadvertexes.length / 3);
            c.setVertexBufferAt(0, quadvertbuf, 0, Context3DVertexBufferFormat.FLOAT_3);
            ConfigureProjection(stage.stageWidth, stage.stageHeight);
            showhot = Util.NumberVal(Config.settings.SHOWHOT) == 1;
            if (showhot)
            {
                color_gimage = new GpuImage(8, 8);
                color_gimage.DrawObj(new Bitmap(new BitmapData(8, 8, true, 4294901760)), new Matrix());
                color_gimage2 = new GpuImage(8, 8);
                color_gimage2.DrawObj(new Bitmap(new BitmapData(8, 8, true, 4278190335)), new Matrix());
            }
        }

        private static function InitRoot():void
        {
            rootmc = new MovieClip();
            rootmc.x = 0;
            rootmc.y = 0;
            rootmc.scaleX = 1;
            rootmc.scaleY = 1;
            root = new Imitator(null, rootmc);
            Imitation.active = true;
            if (!usegpu)
            {
                flamc.addChild(root.fspr);
            }
            TouchManager.Init(rootmc, flamc.stage);
            Util.AddEventListener(Imitation.rootmc, Event.ADDED, ContainterChangeHandler, false, 0, true);
            Util.AddEventListener(Imitation.rootmc, Event.REMOVED, ContainterChangeHandler, false, 0, true);
            if (mainsceneclass != null)
            {
                mainmc = new mainsceneclass();
                rootmc.addChild(mainmc);
                root.CollectChildren();
            }
            if (typeof Imitation.initcallback == "function")
            {
                Imitation.initcallback();
                Imitation.initcallback = null;
            }
        }

        private static function OnNewContextCreated(e:*):void
        {
            trace("OnNewContextCreated");
            InitContext();
            restoring = true;
            FreeBitmapAll();
        }

        private static function OnStage3DError(e:*):*
        {
            Util.RemoveEventListener(stage3D, "error", OnStage3DError);
            usegpu = false;
            InitRoot();
        }

        private static function FindImitator(aobj:DisplayObject):Imitator
        {
            return imitators[aobj];
        }

        private static function UpdateToDisplayChildren(im:Imitator):void
        {
            if (!im.obj.visible)
            {
                return;
            }
            var i:int = 0;
            while (i < im.children.length)
            {
                im.children[i].UpdateProperties();
                UpdateToDisplayChildren(im.children[i]);
                i++;
            }
        }

        private static function GetFullRef(aobj:DisplayObject):void
        {
            var pad:* = "  ";
            while (aobj)
            {
                aobj = aobj.parent;
                pad += "  ";
            }
        }

        public function Imitation()
        {
            super();
        }

        private static function ContainterChangeHandler(event:Event):void
        {
            var parent:DisplayObjectContainer = event.target.parent;
            var im:* = Imitation.FindImitator(parent);
            if (im)
            {
                im.changed = true;
            }
        }
    }
}
