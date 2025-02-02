package syscode
{
    import com.greensock.TweenMax;
    import com.greensock.easing.Back;
    import com.greensock.easing.Strong;

    import flash.display.*;
    import flash.events.Event;
    import flash.system.*;
    import uibase.LoadWait;

    public class WinMgr
    {
        public static const shaderalpha:Number = 0.7;

        public static const shadercolor:Number = 0;

        public static var initialized:Boolean = false;

        public static var basemc:MovieClip = null;

        public static var overlaymc:MovieClip = null;
        public static var currentwindow:WinObj = null;
        public static var closingwindow:WinObj = null;
        public static var loadingwindow:WinObj = null;
        public static var basehandler:WinObj = null;
        public static var loadwait:MovieClip = null;
        public static var shaderanim:Boolean = false;
        private static var backgroundmc:MovieClip = null;
        private static var foregroundmc:MovieClip = null;
        private static var bgwindowsmc:MovieClip = null;
        private static var shadermc:Shape = null;
        private static var overshadermc:Shape = null;
        private static var windowstack:Vector.<WinObj> = new Vector.<WinObj>();
        private static var sheduledwindows:Vector.<WinObj> = new Vector.<WinObj>();

        public static function Init():*
        {
            backgroundmc = new MovieClip();
            basemc = new MovieClip();
            bgwindowsmc = new MovieClip();
            shadermc = CreateTheShaderShape();
            backgroundmc.addChild(basemc);
            backgroundmc.addChild(bgwindowsmc);
            backgroundmc.addChild(shadermc);
            foregroundmc = new MovieClip();
            overlaymc = new MovieClip();
            overshadermc = CreateTheShaderShape();
            overlaymc.addChild(overshadermc);
            trace("Loading LoadWait 1");
            loadwait = new (Modules.GetClass("uibase", "uibase.LoadWait"))();
            trace("Loadwait loaded 1");
            overlaymc.addChild(loadwait);
            loadwait.BOOK.stop();
            HideLoadWait();
            Imitation.rootmc.addChild(backgroundmc);
            Imitation.rootmc.addChild(foregroundmc);
            Imitation.rootmc.addChild(overlaymc);
            trace("to Init Imitation.CollectChildrenAll");
            Imitation.CollectChildrenAll();
            trace("after Init Imitation.CollectChildrenAll");
            Imitation.AddButtonStop(shadermc);
            Imitation.SetBitmapScale(shadermc, -1);
            Imitation.AddButtonStop(overshadermc);
            Imitation.SetBitmapScale(overshadermc, -1);
            WinMgr.initialized = true;
            ReAlign();
        }

        public static function ShowBaseHandler(aclass:Object, aprops:Object = null):void
        {
            var wo:WinObj;
            if (basehandler)
            {
                HideBaseHandler(basehandler.winclass);
            }
            if (!aclass)
            {
                return;
            }
            wo = new WinObj(aclass, aprops);
            trace("wo.classname: " + wo.classname);
            if (!wo.loaded)
            {
                throw new Error("WinMgr.SetBaseHandler: base handler not loaded: \"" + wo.classname + "\"");
            }
            basehandler = wo;
            if (basehandler.winclass != undefined || basehandler.winclass != null)
            {
                try
                {
                    basehandler.mc = new basehandler.winclass();
                }
                catch (e:Error)
                {
                }
                if (basehandler.winclass.mc !== undefined)
                {
                    basehandler.winclass.mc = basehandler.mc;
                }
                basemc.addChild(basehandler.mc);
                if (basehandler.mc.hasOwnProperty("Prepare"))
                {
                    basehandler.mc.Prepare(wo.properties);
                }
                Imitation.DispatchStageEvent("WINDOWCHANGE");
                return;
            }
        }

        public static function HideBaseHandler(aclass:Object):void
        {
            var wo:WinObj = new WinObj(aclass, null);
            var mc:MovieClip = null;
            if (Boolean(wo.winclass) && Boolean(wo.winclass.mc))
            {
                mc = wo.winclass.mc;
                if (mc.hasOwnProperty("AfterClose"))
                {
                    mc.AfterClose();
                }
                mc.parent.removeChild(mc);
                wo.winclass.mc = null;
            }
            if (mc && basehandler && basehandler.mc == mc)
            {
                basehandler = null;
            }
            wo.Dispose();
            if (mc)
            {
                Imitation.DeleteEventGroup(mc);
                mc = null;
                Imitation.DispatchStageEvent("WINDOWCHANGE");
                TweenMax.delayedCall(0.01, Imitation.CollectChildrenAll);
                TweenMax.delayedCall(0.5, System.gc);
            }
        }

        public static function OpenWindow(aclass:Object, aprops:Object = null):void
        {
            var i:int = 0;
            var swo:WinObj = null;
            var wo:WinObj = new WinObj(aclass, aprops);
            DBG.Trace("WinMgr.OpenWindow:" + wo.classname);
            if (wo.winclass && wo.winclass.mc !== undefined && wo.winclass.mc != null)
            {
                trace("WinMgr.OpenWindow: window is already open!");
                if (currentwindow == wo)
                {
                    return;
                }
                i = 0;
                while (i < windowstack.length)
                {
                    swo = windowstack[i];
                    if (swo.mc == wo.winclass.mc)
                    {
                        Imitation.ChangeParent(swo.mc, foregroundmc);
                        windowstack.splice(i, 1);
                        WindowToBackgrond(currentwindow);
                        currentwindow = swo;
                        UpdateBackground();
                        return;
                    }
                    i++;
                }
                trace("WinMgr.OpenWindow: already open window not found !!!");
                return;
            }
            i = 0;
            while (i < sheduledwindows.length)
            {
                swo = sheduledwindows[i];
                if (swo.classname == wo.classname)
                {
                    if (!swo.winclass || swo.winclass && swo.winclass.mc !== undefined)
                    {
                        DBG.Trace("WinMgr.OpenWindow: Window \"" + swo.classname + "\" is already sheduled for Open!");
                        return;
                    }
                }
                i++;
            }
            sheduledwindows.push(wo);
            if (!(Boolean(currentwindow) && Boolean(currentwindow.properties.waitfordata)))
            {
                if (!(Boolean(currentwindow) && Boolean(currentwindow.properties.openanim)))
                {
                    if (!loadingwindow)
                    {
                        if (!shaderanim)
                        {
                            if (!closingwindow)
                            {
                                ShaderFadeIn();
                            }
                        }
                    }
                }
            }
        }

        public static function CloseWindow(amc:MovieClip):void
        {
            var wo:WinObj = null;
            trace("WinMgr.CloseWindow");
            if (Boolean(currentwindow) && amc == currentwindow.mc)
            {
                closingwindow = currentwindow;
                trace("trying to show animation...");
                StartWindowCloseAnim();
                trace("returning...");
                return;
            }
            var i:int = 0;
            trace("windowstack.length: " + windowstack.length);
            while (i < windowstack.length)
            {
                wo = windowstack[i];
                if (wo.mc == amc)
                {
                    HideWindow(wo);
                    return;
                }
                i++;
            }
            ShowNextWindow();
        }

        public static function RemoveWindow(aclass:Object):void
        {
            var swo:WinObj = null;
            var i:int = 0;
            var wo:WinObj = new WinObj(aclass, {});
            if (Boolean(closingwindow) && closingwindow.classname == wo.classname)
            {
                closingwindow = null;
            }
            if (Boolean(loadingwindow) && loadingwindow.classname == wo.classname)
            {
                loadingwindow = null;
            }
            if (Boolean(currentwindow) && currentwindow.classname == wo.classname)
            {
                HideWindow(currentwindow);
                currentwindow = null;
            }
            for each (swo in windowstack)
            {
                if (swo.classname == wo.classname)
                {
                    HideWindow(swo);
                    break;
                }
            }
            i = 0;
            while (i < sheduledwindows.length)
            {
                swo = sheduledwindows[i];
                if (swo.classname == wo.classname)
                {
                    sheduledwindows.splice(i, 1);
                    i--;
                }
                i++;
            }
        }

        public static function ReplaceWindow(amc:MovieClip, aclass:Object, aprops:Object = null):void
        {
            var swo:WinObj = null;
            var wo:WinObj = new WinObj(aclass, aprops);
            for each (swo in windowstack)
            {
                if (swo.classname == wo.classname)
                {
                    return;
                }
            }
            for each (swo in sheduledwindows)
            {
                if (swo.classname == wo.classname)
                {
                    if (!swo.winclass || swo.winclass && swo.winclass.mc !== undefined)
                    {
                        return;
                    }
                }
            }
            sheduledwindows.push(wo);
            CloseWindow(amc);
        }

        public static function WindowOpened(aclass:Object):Boolean
        {
            var swo:WinObj = null;
            var wo:WinObj = new WinObj(aclass, null);
            if (Boolean(currentwindow) && currentwindow.classname == wo.classname)
            {
                return true;
            }
            for each (swo in windowstack)
            {
                if (swo.classname == wo.classname)
                {
                    return true;
                }
            }
            for each (swo in sheduledwindows)
            {
                if (swo.classname == wo.classname)
                {
                    return true;
                }
            }
            return false;
        }

        public static function UpdateBackground(aforceshader:Boolean = false):void
        {
            if (currentwindow || windowstack.length > 0 || aforceshader)
            {
                if (Boolean(shadermc) && Boolean(backgroundmc))
                {
                    shadermc.visible = true;
                    shadermc.alpha = 1;
                    if (!Imitation.usegpu || Imitation.texturerendering)
                    {
                        Imitation.Combine(backgroundmc, true);
                    }
                }
            }
            else if (Boolean(shadermc) && Boolean(backgroundmc))
            {
                shadermc.visible = false;
                Imitation.Combine(backgroundmc, false);
            }
        }

        public static function ReAlign():void
        {
            AlignShader();
        }

        public static function ShowLoadWait():void
        {
            if (loadwait)
            {
                if (!TweenMax.isTweening(loadwait))
                {
                    TweenMax.to(loadwait, 0.2, {"visible": true});
                    loadwait.BOOK.gotoAndStop(Config.mobile ? 10 : 1);
                }
                else
                {
                    TweenMax.killTweensOf(loadwait);
                    loadwait.visible = true;
                }
                if (!Config.mobile)
                {
                    Util.AddEventListener(loadwait, Event.ENTER_FRAME, OnLoadWaitFrame);
                }
                loadwait.PROGRESS.visible = false;
            }
        }

        public static function OnLoadWaitFrame(e:*):void
        {
            if (Boolean(loadwait) && Boolean(loadwait.BOOK))
            {
                if (loadwait.BOOK.currentFrame == loadwait.BOOK.totalFrames)
                {
                    loadwait.BOOK.gotoAndStop(1);
                }
                else
                {
                    loadwait.BOOK.gotoAndStop(Math.min(loadwait.BOOK.totalFrames, loadwait.BOOK.currentFrame + 2));
                }
            }
        }

        public static function HideLoadWait():void
        {
            if (loadwait)
            {
                if (loadwait.BOOK)
                {
                }
                Util.RemoveEventListener(loadwait, Event.ENTER_FRAME, OnLoadWaitFrame);
                TweenMax.killTweensOf(loadwait);
                loadwait.visible = false;
                TweenMax.to(loadwait, 0.1, {});
            }
        }

        public static function SetWaitProgress(avalue:Number):void
        {
            var p:Number = NaN;
            if (loadwait)
            {
                if (!loadwait.visible)
                {
                    ShowLoadWait();
                }
                p = avalue > 1 ? 1 : avalue;
                loadwait.PROGRESS.BAR.scaleX = p;
                loadwait.PROGRESS.visible = true;
            }
        }

        public static function WindowDataArrived(mc:MovieClip):void
        {
            var wo:WinObj = null;
            if (mc == null)
            {
                return;
            }
            if (Boolean(currentwindow) && mc == currentwindow.mc)
            {
                if (currentwindow.properties)
                {
                    currentwindow.properties.waitfordata = false;
                }
                StartWindowOpenAnim();
                return;
            }
            var i:int = 0;
            while (i < windowstack.length)
            {
                wo = windowstack[i];
                if (wo.mc == mc)
                {
                    if (currentwindow.properties)
                    {
                        currentwindow.properties.waitfordata = false;
                    }
                    return;
                }
                i++;
            }
        }

        private static function ShaderFadeIn():void
        {
            var mc:Shape = null;
            WinMgr.shaderanim = true;
            if (!currentwindow)
            {
                if (shadermc)
                {
                    shadermc.alpha = 0;
                    shadermc.visible = true;
                    Imitation.UpdateAll(shadermc);
                    mc = shadermc;
                    TweenMax.delayedCall(0.001, function():*
                        {
                            TweenMax.to(mc, 0.15, {
                                        "alpha": 1,
                                        "onComplete": OnShaderFadeIn
                                    });
                        });
                }
                else
                {
                    OnShaderFadeIn();
                }
            }
            else
            {
                overshadermc.visible = true;
                overshadermc.alpha = 1;
                Imitation.UpdateAll(overshadermc);
                OnShaderFadeIn();
            }
        }

        private static function OnShaderFadeIn():void
        {
            WinMgr.shaderanim = false;
            ShowLoadWait();
            Imitation.UpdateFrame();
            if (currentwindow)
            {
                WindowToBackgrond(currentwindow);
                currentwindow = null;
            }
            UpdateBackground(true);
            overshadermc.visible = false;
            ShowNextWindow();
        }

        private static function ShowNextWindow():void
        {
            var wo:WinObj = sheduledwindows.shift();
            if (!wo)
            {
                currentwindow = windowstack.pop();
                if (currentwindow && currentwindow.mc && Boolean(foregroundmc))
                {
                    Imitation.ChangeParent(currentwindow.mc, foregroundmc);
                    Imitation.EnableInput(currentwindow.mc, true);
                }
                UpdateBackground();
                return;
            }
            if (!wo.loaded)
            {
                LoadWindow(wo);
                return;
            }
            DisplayLoadedWindow(wo);
        }

        private static function DisplayLoadedWindow(wo:WinObj):void
        {
            if (!wo.winclass)
            {
                throw new Error("WinMgr.DisplayLoadedWindow: no window class for window \"" + wo.classname + "\"");
            }
            if (wo.winclass.mc === undefined)
            {
            }
            if (!wo.mc)
            {
                wo.mc = new wo.winclass();
                if (wo.winclass.mc !== undefined)
                {
                    wo.winclass.mc = wo.mc;
                }
                foregroundmc.addChild(wo.mc);
                Imitation.CollectChildren(foregroundmc);
                wo.properties.waitfordata = false;
                Imitation.FreezeEvents(wo.mc);
                CallCallback(wo, "Prepare", [wo.properties]);
                Aligner.SetAutoAlign(wo.mc, true);
                Imitation.DispatchStageEvent("WINDOWCHANGE");
            }
            currentwindow = wo;
            wo.mc.alpha = 0;
            wo.mc.visible = true;
            Imitation.UpdateAll(wo.mc);
            if (!wo.properties.waitfordata)
            {
                StartWindowOpenAnim();
            }
        }

        private static function LoadWindow(wo:WinObj):void
        {
            if (loadingwindow)
            {
                throw new Error("WinMgr.LoadWindow: already loading module \"" + loadingwindow.modulename + "\" while trying load \"" + wo.modulename + "\"");
            }
            loadingwindow = wo;
            SetWaitProgress(0);
            Modules.LoadModule(wo.modulename, OnLoadFinished, OnLoadProgress);
        }

        private static function OnLoadProgress(e:Object):void
        {
            SetWaitProgress(e.target.progress);
        }

        private static function OnLoadFinished():void
        {
            if (!loadingwindow)
            {
                return;
            }
            var wo:WinObj = loadingwindow;
            loadingwindow = null;
            wo.winclass = Modules.GetClass(wo.modulename, wo.classname);
            wo.loaded = true;
            ShowLoadWait();
            Imitation.Render();
            DisplayLoadedWindow(wo);
        }

        private static function StartWindowOpenAnim():void
        {
            var fadeIn:String;
            var ao:*;
            var mc:MovieClip = null;
            var tscale:Number = NaN;
            var tx:Number = NaN;
            var ty:Number = NaN;
            var ease:* = undefined;
            var ss:Number = NaN;
            currentwindow.properties.openanim = true;
            mc = currentwindow.mc;
            tscale = mc.scaleX;
            tx = mc.x;
            ty = mc.y;
            mc.alpha = 0;
            mc.visible = true;
            Imitation.UpdateAll(mc);
            HideLoadWait();
            ease = Back.easeInOut;
            fadeIn = String(currentwindow.properties.fadeIn);
            if (!fadeIn || fadeIn == "zoom_in")
            {
                ss = 0.75;
                mc.scaleX = ss;
                mc.scaleY = ss;
                mc.x = Imitation.stage.stageWidth / 2 * (1 - ss) + mc.x * ss;
                mc.y = Imitation.stage.stageHeight / 2 * (1 - ss) + mc.y * ss;
            }
            else if (fadeIn == "zoom_out")
            {
                mc.scaleX = 1.5;
                mc.scaleY = 1.5;
            }
            else if (fadeIn == "left")
            {
                ease = Strong.easeOut;
                mc.x -= mc.width;
            }
            ao = Sys.gsqc.InsertDelayForNext(0.001);
            TweenMax.delayedCall(ao.delayms / 1000, function():*
                {
                    TweenMax.to(mc, 0.4, {
                                "alpha": 1,
                                "scaleX": tscale,
                                "scaleY": tscale,
                                "x": tx,
                                "y": ty,
                                "overwrite": "none",
                                "ease": ease,
                                "onComplete": OnOpenAnimFinished,
                                "onCompleteParams": [currentwindow]
                            });
                });
            if (!Sys.gsqc.running)
            {
                Sys.gsqc.Start();
            }
        }

        private static function OnOpenAnimFinished(win:WinObj):void
        {
            if (win != currentwindow || win.mc != currentwindow.mc)
            {
                DBG.SendWarning("WinMgr.OnOpenAnimFinished ERROR, expected:" + win.classname + ", got:" + (currentwindow == null ? "null" : currentwindow.classname));
                return;
            }
            Imitation.UpdateToDisplay(currentwindow.mc);
            TweenMax.delayedCall(0.01, function():*
                {
                    currentwindow.properties.openanim = false;
                    Imitation.UnFreezeEvents(currentwindow.mc);
                    ShowState();
                    Platform.AddBackHandler(currentwindow.BackHandler);
                    Imitation.EnableInput(currentwindow.mc, true);
                    CallCallback(currentwindow, "AfterOpen", []);
                });
        }

        private static function ShowState():void
        {
            var i:int = 0;
            i = int(windowstack.length - 1);
            while (i >= 0)
            {
                i--;
            }
            i = 0;
            while (i < sheduledwindows.length)
            {
                i++;
            }
        }

        private static function StartWindowCloseAnim():void
        {
            var cx:Number = Imitation.stage.stageWidth / 2 * (1 - 0.66) + closingwindow.mc.x * 0.66;
            var cy:Number = Imitation.stage.stageHeight / 2 * (1 - 0.66) + closingwindow.mc.y * 0.66;
            var fadeOut:String = String(currentwindow.properties.fadeOut);
            if (fadeOut == "undefined")
            {
                trace("currentwindow.properties.fadeOut IS UNDEFINED! Replacing it with zoom_out...");
                fadeOut = "zoom_out";
            }
            if (!fadeOut || fadeOut == "zoom_out")
            {
                TweenMax.to(closingwindow.mc, 0.2, {
                            "alpha": 0,
                            "scaleX": 0.66,
                            "scaleY": 0.66,
                            "x": cx,
                            "y": cy,
                            "overwrite": "none",
                            "onComplete": OnCloseAnimFinished
                        });
            }
            else if (fadeOut == "zoom_in")
            {
                TweenMax.to(closingwindow.mc, 0.3, {
                            "alpha": 0,
                            "scaleX": 1.5,
                            "scaleY": 1.5,
                            "overwrite": "none",
                            "onComplete": OnCloseAnimFinished
                        });
            }
            else if (fadeOut == "left")
            {
                TweenMax.to(closingwindow.mc, 0.3, {
                            "alpha": 0,
                            "x": -currentwindow.mc.width,
                            "overwrite": "none",
                            "onComplete": OnCloseAnimFinished
                        });
            }
            else
            {
                trace("else!!");
                TweenMax.to(closingwindow.mc, 0.2, {
                            "alpha": 0,
                            "scaleX": 0.66,
                            "scaleY": 0.66,
                            "x": cx,
                            "y": cy,
                            "overwrite": "none",
                            "onComplete": OnCloseAnimFinished
                        });
            }
        }

        private static function OnCloseAnimFinished():void
        {
            trace("OnCloseAnimFinished");
            if (Boolean(closingwindow) && Boolean(closingwindow.mc))
            {
                closingwindow.mc.alpha = 0;
                Imitation.UpdateToDisplay(closingwindow.mc);
            }
            TweenMax.delayedCall(0.01, function():*
                {
                    if (closingwindow == null)
                    {
                        return;
                    }
                    HideWindow(closingwindow);
                    closingwindow = null;
                    ShowState();
                    ShowNextWindow();
                });
        }

        private static function CallCallback(wo:WinObj, funcname:String, aparams:Array):void
        {
            if (!wo)
            {
                return;
            }
            if (!wo.mc)
            {
                return;
            }
            if (wo.mc.hasOwnProperty(funcname) && typeof wo.mc[funcname] == "function")
            {
                wo.mc[funcname].apply(wo.mc, aparams);
            }
        }

        private static function HideWindow(wo:WinObj):void
        {
            if (!wo.mc)
            {
                return;
            }
            TweenMax.killChildTweensOf(wo.mc);
            Aligner.UnSetAutoAlign(wo.mc);
            Imitation.RemoveEvents(wo.mc);
            wo.mc.visible = false;
            wo.mc.parent.removeChild(wo.mc);
            Util.StopAllChildrenMov(wo.mc);
            if (wo.winclass.mc !== undefined)
            {
                wo.winclass.mc = null;
            }
            var i:int = int(windowstack.indexOf(wo));
            if (i >= 0)
            {
                windowstack.splice(i, 1);
                UpdateBackground();
            }
            CallCallback(wo, "AfterClose", []);
            Imitation.DeleteEventGroup(wo.mc);
            wo.mc = null;
            Platform.RemoveBackHandler(wo.BackHandler);
            wo.Dispose();
            wo = null;
            Imitation.DispatchStageEvent("WINDOWCHANGE");
            Imitation.CollectChildrenAll();
            System.gc();
        }

        private static function WindowToBackgrond(wo:WinObj):void
        {
            Imitation.EnableInput(wo.mc, false);
            Imitation.ChangeParent(wo.mc, bgwindowsmc);
            windowstack.push(wo);
        }

        private static function CreateTheShaderShape():Shape
        {
            trace("CreateTheShaderShape");
            trace("shadercolor:", shadercolor);
            trace("shaderalpha", shaderalpha);
            var ss:Shape = new Shape();
            ss.graphics.beginFill(shadercolor, shaderalpha);
            ss.graphics.drawRect(0, 0, 16, 16);
            ss.graphics.endFill();
            ss.cacheAsBitmap = true;
            ss.visible = false;
            return ss;
        }

        private static function AlignShader():void
        {
            if (shadermc)
            {
                shadermc.x = -1;
                shadermc.y = -1;
                shadermc.width = Imitation.stage.stageWidth + 2;
                shadermc.height = Imitation.stage.stageHeight + 2;
                overshadermc.x = -1;
                overshadermc.y = -1;
                overshadermc.width = Imitation.stage.stageWidth + 2;
                overshadermc.height = Imitation.stage.stageHeight + 2;
            }
            if (loadwait)
            {
                loadwait.x = Imitation.stage.stageWidth / 2;
                loadwait.y = Imitation.stage.stageHeight / 2;
            }
            trace("alignshader end");
            UpdateBackground();
        }

        public function WinMgr()
        {
            super();
        }
    }
}
