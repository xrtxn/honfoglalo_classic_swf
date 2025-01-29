package syscode
{
    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.LoaderMax;
    import com.greensock.loading.SWFLoader;

    import flash.display.*;
    import flash.events.*;
    import flash.system.*;

    public class Modules
    {
        public static var moduledata:Object = {};

        public static var processorclasses:Object = {};
        public static var waitmc:MovieClip = null;
        private static var modulelist:Object = {};
        private static var joblist:Array = [];

        public static function Init():*
        {
            processorclasses["villagemap"] = "villagemap.VillageMap";
            processorclasses["triviador"] = "triviador.Main";
            processorclasses["lobby"] = "lobby.Lobby";
            SetModuleData("villagemap", "assets/modules/villagemap.swf", "");
            SetModuleData("triviador", "assets/modules/triviador.swf", "");
            SetModuleData("lobby", "assets/modules/lobby.swf", "");
            SetModuleData("uibase", "assets/modules/02_uibase.swf", "general");
            SetModuleData("knightgame", "assets/modules/knightgame.swf", "");
            SetModuleData("adventcalendar", "assets/modules/adventcalendar.swf", "");
            SetModuleData("reward", "assets/modules/reward.swf", "");
            SetModuleData("bank", "assets/modules/bank.swf", "");
            SetModuleData("energy", "assets/modules/energy.swf", "");
            SetModuleData("forge", "assets/modules/forge.swf", "");
            SetModuleData("settings", "assets/modules/settings.swf", "");
            SetModuleData("tutorial", "assets/modules/tutorial.swf", "villagemap");
            SetModuleData("invite", "assets/modules/invite.swf", "");
            SetModuleData("ranklist", "assets/modules/ranklist.swf", "");
            SetModuleData("castle", "assets/modules/castle.swf", "");
            SetModuleData("gameover", "assets/modules/gameover.swf", "");
            SetModuleData("testmodule", "assets/modules/testmodule.swf", "");
            SetModuleData("profile", "assets/modules/profile.swf", "");
            SetModuleData("profile2", "assets/modules/profile2.swf", "");
            SetModuleData("postoffice", "assets/modules/postoffice.swf", "");
            SetModuleData("friendlygame", "assets/modules/friendlygame.swf", "villagemap");
            SetModuleData("minitournament", "assets/modules/minitournament.swf", "triviador");
            SetModuleData("tournament", "assets/modules/tournament.swf", "triviador");
            SetModuleData("wrongquestion", "assets/modules/wrongquestion.swf", "triviador");
            SetModuleData("clan", "assets/modules/clan.swf", "");
            SetModuleData("library", "assets/modules/library.swf", "");
            SetModuleData("miniquiz", "assets/modules/miniquiz.swf", "");
            SetModuleData("help", "assets/modules/help.swf", "");
            if (String("|tr|xa|").indexOf(Config.siteid) >= 0)
            {
                SetModuleData("characters", "assets/gfx/characters_tr.swf", "general");
                SetModuleData("avatarbody", "assets/gfx/avatarbody_tr.swf", "general");
                SetModuleData("serialboosterchars", "assets/gfx/serialboosterchars_tr.swf", "general");
            }
            else
            {
                SetModuleData("characters", "assets/gfx/characters.swf", "general");
                SetModuleData("avatarbody", "assets/gfx/avatarbody.swf", "general");
                SetModuleData("serialboosterchars", "assets/gfx/serialboosterchars.swf", "general");
            }
            SetModuleData("avatars", "assets/gfx/avatars.swf", "general");
            SetModuleData("avatarframe", "assets/gfx/avatarframe.swf", "general");
            SetModuleData("soldiers", "assets/gfx/soldiers.swf", "triviador,settings");
            SetModuleData("castles", "assets/gfx/castles.swf", "triviador,gameover");
            SetModuleData("castles_ortho", "assets/gfx/castles_ortho.swf", "villagemap,castle");
            SetModuleData("houses", "assets/gfx/houses.swf", "forge");
            if (Config.season == 1)
            {
                SetModuleData("buildings", "assets/gfx/skin_buildings_winter.swf", "villagemap,forge");
            }
            else
            {
                SetModuleData("buildings", "assets/gfx/buildings.swf", "villagemap,forge");
            }
            var mapid:String = "WD";
            if (String("|HU|TR|CZ|ES|AR|PL|BR|RU|DE|RO|BG|SI|US|FR|RS|IND|SPRT|GC|").indexOf(Config.settings.DEFAULTMAP) >= 0)
            {
                mapid = String(Config.settings.DEFAULTMAP);
            }
            SetModuleData("map_hu", "assets/gfx/maps/hu.swf", "HU" == mapid ? "triviador" : "");
            SetModuleData("map_wd", "assets/gfx/maps/wd.swf", "WD" == mapid ? "triviador" : "");
            SetModuleData("map_tr", "assets/gfx/maps/tr.swf", "TR" == mapid ? "triviador" : "");
            SetModuleData("map_cz", "assets/gfx/maps/cz.swf", "CZ" == mapid ? "triviador" : "");
            SetModuleData("map_es", "assets/gfx/maps/es.swf", "ES" == mapid ? "triviador" : "");
            SetModuleData("map_ar", "assets/gfx/maps/ar.swf", "AR" == mapid ? "triviador" : "");
            SetModuleData("map_pl", "assets/gfx/maps/pl.swf", "PL" == mapid ? "triviador" : "");
            SetModuleData("map_br", "assets/gfx/maps/br.swf", "BR" == mapid ? "triviador" : "");
            SetModuleData("map_ru", "assets/gfx/maps/ru.swf", "RU" == mapid ? "triviador" : "");
            SetModuleData("map_de", "assets/gfx/maps/de.swf", "DE" == mapid ? "triviador" : "");
            SetModuleData("map_ro", "assets/gfx/maps/ro.swf", "RO" == mapid ? "triviador" : "");
            SetModuleData("map_bg", "assets/gfx/maps/bg.swf", "BG" == mapid ? "triviador" : "");
            SetModuleData("map_si", "assets/gfx/maps/si.swf", "SI" == mapid ? "triviador" : "");
            SetModuleData("map_us", "assets/gfx/maps/us.swf", "US" == mapid ? "triviador" : "");
            SetModuleData("map_fr", "assets/gfx/maps/fr.swf", "FR" == mapid ? "triviador" : "");
            SetModuleData("map_rs", "assets/gfx/maps/rs.swf", "RS" == mapid ? "triviador" : "");
            SetModuleData("map_ind", "assets/gfx/maps/ind.swf", "IND" == mapid ? "triviador" : "");
            SetModuleData("map_gc", "assets/gfx/maps/gc.swf", "GC" == mapid ? "triviador" : "");
            SetModuleData("map_sprt", "assets/gfx/maps/sport.swf", "SPRT" == mapid ? "triviador" : "");
            if (Config.skin != "NONE" && Config.skin != "none")
            {
                SetModuleData("skin_map", "assets/gfx/maps/skin_map_" + mapid.toLowerCase() + "_" + Config.skin + ".swf", "general");
                SetModuleData("skin_village", "assets/gfx/skin_village_" + Config.skin + ".swf", "general");
                SetModuleData("skin_triviador", "assets/gfx/skin_triviador_" + Config.skin + ".swf", "general");
                SetModuleData("skin_general_ui", "assets/gfx/skin_general_ui_" + Config.skin + ".swf", "general");
                SetModuleData("skin_notifications", "assets/gfx/skin_notifications_" + Config.skin + ".swf", "general");
            }
        }

        public static function SetModuleData(aname:String, aurl:String, arequiredby:String, aestimatedbytes:int = -1):void
        {
            var md:Object = {};
            md.name = aname;
            md.url = Config.bootparams.appbaseurl + aurl;
            md.requiredby = arequiredby;
            md.estimatedbytes = aestimatedbytes > 0 ? aestimatedbytes : 10000000;
            var fakeurl:String = "client/" + aurl;
            var newurl:String = Config.GetFileReference(fakeurl);
            if (newurl != fakeurl)
            {
                md.url = newurl;
            }
            md.size = Config.GetFileSize(fakeurl);
            moduledata[aname] = md;
        }

        public static function GetModuleUrl(aname:String):String
        {
            return moduledata[aname].url;
        }

        public static function GetModuleSize(aname:String):int
        {
            return moduledata[aname].size;
        }

        public static function SetModuleSwf(aname:String, amc:Object):void
        {
            if (!amc)
            {
                throw new Error("Modules.SetModuleSwf:" + aname + " got null MovieClip");
            }
            Util.StopAllChildrenMov(MovieClip(amc));
            var m:* = modulelist[aname];
            if (!m)
            {
                m = {
                        "name": aname,
                        "mc": null
                    };
                modulelist[aname] = m;
            }
            m.mc = amc;
            DBG.AddErrorLogger(amc.loaderInfo);
            if (m.mc.Init !== undefined)
            {
                m.mc.Init();
            }
        }

        public static function GetModuleMC(modulename:String):MovieClip
        {
            return modulelist[modulename].mc;
        }

        public static function Loaded(modulename:String):Boolean
        {
            return modulelist[modulename] !== undefined;
        }

        public static function GetClass(modulename:String, classname:String):Class
        {
            var m:* = modulelist[modulename];
            if (!m)
            {
                return null;
            }
            return m.mc.loaderInfo.applicationDomain.getDefinition(classname) as Class;
        }

        public static function GetProcessorClass(modulename:String):Class
        {
            var cname:String = String(processorclasses[modulename]);
            if (cname)
            {
                return GetClass(modulename, cname);
            }
            return null;
        }

        public static function ShowModuleWait(modulename:String, aprogress:Number = -1):void
        {
            var c:Class = null;
            if (!waitmc)
            {
                trace("Loading LoadWait");
                c = Modules.GetClass("uibase", "uibase.LoadWait");
                trace("LoadWait loaded");

                waitmc = new c();
                WinMgr.overlaymc.addChild(waitmc);
                Util.AddEventListener(WinMgr.overlaymc, Event.ENTER_FRAME, OnWaitMcFrame);
                Imitation.CollectChildrenAll(WinMgr.overlaymc);
                AlignWaitMc();
            }
            if (aprogress >= 0)
            {
                waitmc.PROGRESS.visible = true;
                waitmc.PROGRESS.BAR.scaleX = aprogress > 1 ? 1 : aprogress;
            }
            else
            {
                waitmc.PROGRESS.visible = false;
            }
            var notifs:Object = Modules.GetClass("uibase", "uibase.Notifications");
            if (Boolean(notifs) && Boolean(notifs.mc))
            {
                notifs.Hide();
            }
        }

        public static function OnWaitMcFrame(e:*):void
        {
            if (Boolean(waitmc) && Boolean(waitmc.BOOK))
            {
                if (waitmc.BOOK.currentFrame == waitmc.BOOK.totalFrames)
                {
                    waitmc.BOOK.gotoAndStop(1);
                }
                else
                {
                    waitmc.BOOK.gotoAndStop(Math.min(waitmc.BOOK.totalFrames, waitmc.BOOK.currentFrame + 2));
                }
                return;
            }
            Util.RemoveEventListener(WinMgr.overlaymc, Event.ENTER_FRAME, OnWaitMcFrame);
        }

        public static function AlignWaitMc():void
        {
            if (!waitmc)
            {
                return;
            }
            waitmc.x = Imitation.stage.stageWidth / 2;
            waitmc.y = Imitation.stage.stageHeight / 2;
        }

        public static function HideModuleWait():void
        {
            var notifs:Object = null;
            if (waitmc)
            {
                Util.RemoveEventListener(WinMgr.overlaymc, Event.ENTER_FRAME, OnWaitMcFrame);
                waitmc.parent.removeChild(waitmc);
                waitmc = null;
                notifs = Modules.GetClass("uibase", "uibase.Notifications");
                if (Boolean(notifs) && Boolean(notifs.mc))
                {
                    notifs.OnWindowChange({});
                }
            }
        }

        public static function ScheduleLoadModule(modulename:String):void
        {
            if (modulelist[modulename])
            {
                return;
            }
            var md:Object = moduledata[modulename];
            joblist.push({
                        "name": modulename,
                        "estimatedbytes": md.estimatedbytes
                    });
        }

        public static function LoadScheduledModules(afinishcallback:Function, aprogresscallback:Function = null):void
        {
            var job:Object = null;
            var params:Object = null;
            var size:int = 0;
            var sd:SecurityDomain = null;
            var check:Boolean = false;
            Comm.ModuleLoadingPhase = true;
            var lomax:LoaderMax = new LoaderMax({
                        "name": "modules",
                        "maxConnections": 1,
                        "myJobList": joblist,
                        "onProgress": OnLomaxProgress,
                        "myOnProgressCallback": aprogresscallback,
                        "onComplete": OnLomaxComplete,
                        "myOnCompleteCallback": afinishcallback,
                        "onError": OnLomaxError
                    });
            for each (job in joblist)
            {
                params = {"name": job.name};
                size = int(Modules.GetModuleSize(job.name));
                if (size > 0)
                {
                    params.estimatedBytes = size;
                }
                sd = null;
                check = false;
                if (Config.inbrowser)
                {
                    sd = SecurityDomain.currentDomain;
                    check = true;
                }
                params.context = new LoaderContext(check, ApplicationDomain.currentDomain, sd);
                lomax.append(new SWFLoader(Modules.GetModuleUrl(job.name), params));
            }
            lomax.load();
            joblist = [];
        }

        public static function ScheduleRequiredModules(aname:String):void
        {
            var md:Object = null;
            var stags:* = null;
            var tag:* = "," + aname + ",";
            for each (md in moduledata)
            {
                stags = "," + md.requiredby + ",";
                if (stags.indexOf(tag) >= 0)
                {
                    if (!modulelist[md.name])
                    {
                        ScheduleLoadModule(md.name);
                    }
                }
            }
        }

        public static function LoadModule(modulename:String, finishcallback:Function, progresscallback:Function):void
        {
            var md:Object = moduledata[modulename];
            if (!md)
            {
                throw new Error("Modules.LoadModule: unknown module to load:" + modulename);
            }
            var m:* = modulelist[modulename];
            if (m)
            {
                finishcallback();
                return;
            }
            ScheduleLoadModule(modulename);
            ScheduleRequiredModules(modulename);
            LoadScheduledModules(finishcallback, progresscallback);
        }

        private static function OnLomaxProgress(event:LoaderEvent):void
        {
            var callback:Function;
            var vars:*;
            while (vars == null)
            {
                try
                {
                    vars = event.target.vars;
                }
                catch (err:Error)
                {
                }
            }
            callback = event.target.vars.myOnProgressCallback;
            if (Boolean(callback))
            {
                callback(event);
            }
        }

        private static function OnLomaxComplete(event:LoaderEvent):void
        {
            var vars:*;
            var jobs:Array;
            var i:int;
            var callback:Function;
            var job:Object = null;
            Comm.ModuleLoadingPhase = false;
            while (vars == null)
            {
                try
                {
                    vars = event.target.vars;
                }
                catch (err:Error)
                {
                }
            }
            jobs = event.target.vars.myJobList;
            i = 0;
            while (i < jobs.length)
            {
                job = jobs[i];
                Modules.SetModuleSwf(job.name, LoaderMax.getLoader(job.name).rawContent as MovieClip);
                i++;
            }
            callback = event.target.vars.myOnCompleteCallback;
            callback();
        }

        private static function OnLomaxError(e:Object):void
        {
            throw new Error("Modules.OnLomaxError: Scheduled module loading error:" + e.text);
        }

        public function Modules()
        {
            super();
        }
    }
}
