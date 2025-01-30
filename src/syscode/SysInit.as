package syscode
{
    import com.greensock.TweenMax;
    import com.greensock.easing.Bounce;

    import flash.display.*;
    import flash.events.ContextMenuEvent;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;

    public class SysInit
    {
        private static var rootmc:MovieClip;

        public static function StartLoading(arootmc:MovieClip, abootparams:Object):*
        {
            Sys.Init();
            Config.Init(arootmc.loaderInfo, abootparams);
            Aligner.Init(arootmc.stage.stageWidth, arootmc.stage.stageHeight);
            rootmc = arootmc;
            Platform.Init(SysInit.rootmc);
            DBG.Trace("SysInit.StartLoading: mobile: " + Config.bootparams.mobile);
            if (Config.bootparams.clientparams !== undefined && Config.bootparams.clientparams != "")
            {
                DBG.Trace("Loading clientparams...");
                Config.LoadClientParams(Config.bootparams.clientparams, OnClientParamsLoaded);
            }
            else
            {
                OnClientParamsLoaded(false);
            }
        }

        public static function OnClientParamsLoaded(updateprogress:Boolean = true):*
        {
            DBG.Trace("clientparams loaded.");
            Util.SendProstatData("clientparams");
            trace("Setting framereate to " + Config.framerate + " FPS");
            rootmc.stage.frameRate = Config.framerate;
            Modules.Init();
            Sys.LoadPolicyFiles();
            // DBG.AddErrorLogger(SysInit.rootmc.loaderInfo);
            // DBG.AddErrorLogger(Config.bootparams.syscodemc.loaderInfo);
            Lang.LoadLangData(Config.langjson, LangLoaded);
            Extdata.LoadCountries(null);
            Help.LoadData(Config.extdatauribase + "dat/help.json?ut=" + new Date().getTime());
            var prot:String = Config.android ? "app:/" : "";
            if (Config.siteid.substr(0, 1) == "x" || Config.siteid.length != 2)
            {
                ImageCache.AddImagePack(prot + "../assets/flags/xx/all.zip", "../assets/flags/xx/");
            }
            else
            {
                ImageCache.AddImagePack(prot + "../assets/flags/" + Config.siteid + "/all.zip", "../assets/flags/" + Config.siteid + "/");
            }
            //todo 
            OnLoadingFinished();
        }

        public static function LangLoaded(asuccess:Boolean):*
        {
            Util.SendProstatData("lang");
            var fontsurl:* = (Config.mobile || Boolean(Config.bootparams.air) ? Config.bootparams.appbaseurl + "assets/modules/" : "") + "fonts.swf";
            // loadermc.LoadSWF("fonts", fontsurl, OnFontsLoaded);
        }

        public static function OnFontsLoaded(aswf:Object):*
        {
            Modules.SetModuleSwf("fonts", aswf);
            DBG.Trace("Fonts loaded.");
            // loadermc.LoadSWF("uibase", Modules.GetModuleUrl("uibase"), OnUIBaseLoaded);
        }

        public static function OnUIBaseLoaded(aswf:Object):*
        {
            Modules.SetModuleSwf("uibase", aswf);
            trace("Start loading general sounds...");
            Sounds.Init();
            Sounds.LoadSounds("general", OnSoundsLoaded);
            // loadermc.PrepareModule("basegfx");
            Modules.ScheduleRequiredModules("general");
        }

        public static function OnBaseGfxLoaded():*
        {
            trace("Basegfx loaded.");
            Util.SendProstatData("basegfx");
            // loadermc.FinishCurrentModule();
            // loadermc.PrepareModule("villagemap");
            Modules.ScheduleLoadModule("villagemap");
            Modules.ScheduleRequiredModules("villagemap");
        }

        public static function OnVillageMapLoaded():*
        {
            Util.SendProstatData("villagemap");
            // loadermc.FinishCurrentModule();
            // loadermc.PrepareModule("triviador");
            Modules.ScheduleLoadModule("triviador");
            Modules.ScheduleRequiredModules("triviador");
        }

        public static function OnLoadingFinished():*
        {
            AvatarFactory.Init();
            InitImitation();
        }

        public static function OnSoundsLoaded():void
        {
            trace("Sounds loaded.");
        }

        public static function InitImitation():*
        {
            DBG.Trace("Loading finished, Imitation/GPU init...");
            if (Util.NumberVal(Config.flashvars.pepperflash) > 0)
            {
                Imitation.usegpu = false;
            }
            Imitation.Init(rootmc, null, OnImitationStarted);
        }

        public static function OnImitationStarted():*
        {
            DBG.Trace("Imitation initialized. GPU mode=" + Imitation.usegpu);
            Util.AddEventListener(Imitation.stage, "enterFrame", Sys.OnUpdateFrame);
            Util.AddEventListener(Imitation.stage, "resize", Sys.OnStageResize);
            WinMgr.Init();
            Sys.OnStageResize(null);
            // loadermc.parent.removeChild(MovieClip(loadermc));

            //FIXME this should not work like this
            // Imitation.rootmc.addChild(MovieClip(loadermc));
            Imitation.UpdateFrame();
            // var icon:MovieClip = Imitation.usegpu ? loadermc.GPUINIT.ICON.SUCCESS : loadermc.GPUINIT.ICON.FAILURE;
            // var toscale:Number = icon.scaleX;
            // icon.visible = true;
            // Imitation.UpdateAll(icon);
            // icon.scaleX = 0;
            // icon.scaleY = 0;
            // TweenMax.to(icon, 0.5, {
            //             "scaleX": toscale,
            //             "scaleY": toscale,
            //             "ease": Bounce.easeOut,
            //             "onComplete": ImitationInitialized
            //         });
            ImitationInitialized();
        }

        public static function ImitationInitialized():*
        {
            var showfps:int;
            var debuginfo:Object;
            trace("imitation initialized");
            debuginfo = null;
            DBG.Trace("GPU result shown.");
            Util.SendProstatData("gpuinit");
            SetContextMenu();
            showfps = Util.NumberVal(Config.settings.SHOWFPS);
            if (showfps == 1 || showfps == 3)
            {
                Modules.GetClass("uibase", "uibase.FPSIndicator").Show();
            }
            if (showfps == 2 || showfps == 3)
            {
                debuginfo = Modules.GetClass("uibase", "uibase.DebugInfo");
                TweenMax.delayedCall(3, function():*
                    {
                        debuginfo.Init();
                        debuginfo.mc.visible = true;
                    });
            }
            StartLogin();
        }

        public static function SetContextMenu():void
        {
            var appName:ContextMenuItem = new ContextMenuItem("Triviador v11." + Version.value);
            var company:ContextMenuItem = new ContextMenuItem("© Copyright THX Games");
            var renderer:ContextMenuItem = new ContextMenuItem("Driver:" + Imitation.driverinfo);
            var fpsdisp:ContextMenuItem = new ContextMenuItem("Toggle FPS display");
            Util.AddEventListener(fpsdisp, ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
            var contextMenu:ContextMenu = new ContextMenu();
            if (contextMenu.customItems)
            {
                contextMenu.hideBuiltInItems();
                contextMenu.customItems.push(appName, company, renderer, fpsdisp);
                contextMenu.builtInItems.forwardAndBack = false;
                contextMenu.builtInItems.loop = false;
                contextMenu.builtInItems.play = false;
                contextMenu.builtInItems.print = false;
                contextMenu.builtInItems.quality = true;
                contextMenu.builtInItems.rewind = false;
                contextMenu.builtInItems.save = false;
                contextMenu.builtInItems.zoom = false;
                Imitation.SetContextMenu(contextMenu);
                trace("SysInit.SetContextMenu");
            }
        }

        public static function StartLogin():*
        {
            var sysconf:Object = null;
            Util.SendProstatData("loader_finished");
            if (Config.indesigner && Config.loginuserid.length > 0 && Config.loginusername.length > 0)
            {
                Comm.Connect();
                return;
            }
            if (Config.inbrowser)
            {
                Comm.Connect(Config.startscreen);
                sysconf = Util.ExternalCall("GetClientSysConfig");
                Config.ProcessClientSysConfig(sysconf);
                Friends.LoadExternalFriendsWEB();
                return;
            }
            if (Semu.enabled)
            {
                DBG.Trace("*** SEMU CONNECT ***");
                Comm.Connect();
                return;
            }
            Sys.ShowLoginScreen();
        }

        public static function AfterConnect():*
        {
            DBG.Trace("AfterConnect...");
            Modules.GetClass("uibase", "uibase.LoginScreen").Hide();
            if (!Config.afterlogin)
            {
                Config.afterlogin = true;
                Friends.LoadInternalFriends(null);
                Platform.QueryMarketInventory(Platform.CheckMarketInventory);
            }
            DBG.Trace("Showing villagemap...");
            Util.SendProstatData("village_show");
            trace("--- finish afterconnect");
            if (Semu.enabled && Config.semuparams.SKIPWAITHALL == "1")
            {
            }
        }

        public function SysInit()
        {
            super();
        }

        public static function menuItemSelectHandler(event:ContextMenuEvent):void
        {
            var fps:Object = Modules.GetClass("uibase", "uibase.FPSIndicator");
            if (fps)
            {
                if (fps.mc)
                {
                    fps.Hide();
                }
                else
                {
                    fps.Show();
                }
            }
        }
    }
}
