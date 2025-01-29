package syscode
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    import syscode.imitation.RtlUtil;

    public class Config
    {
        public static const UF_CHATENABLED:int = 1;
        public static const UF_NOQPRGAME:int = 2;
        public static const UF_NOFRIENDLY:int = 4;
        public static const UF_CLIENT4:int = 8;
        public static const UF_NOAUTOBOTS:int = 16;
        public static const UF_CLIENT6:int = 32;
        public static const UF_CLIENT7:int = 64;
        public static const UF_CLIENT8:int = 128;
        public static const UF_CHATBANNED:int = 256;
        public static const UF_MINITOURTRY:int = 512;
        public static const UF_NAMECHANGE:int = 1024;
        public static const UF_ACCEPTRULES:int = 2048;
        public static const UF_SALESHANG:int = 8192;
        public static const UF_SUSPENDED:int = 16384;
        public static const UF_SEENOUTOFENERGY:int = 32768;
        public static const UF_SEENBANKWINDOW:int = 65536;
        public static const UF_ELDORADO:int = 131072;
        public static const ULL_MINIQUIZ:* = 15;
        public static const ULL_USQSEND:* = 15;
        public static const ULL_COMMONCHAT:* = 20;
        public static const ULL_LOBBY:* = 5;
        public static const ULL_CHAT:* = 14;
        public static const ULL_FRIENDLYGAME:* = 10;
        public static const ULL_MINITOURNAMENT:* = 10;
        public static const ULL_SPONSORPAY:* = 10;
        public static const ULL_FREEBOOSTERS:* = 10;
        public static const ULL_FRIENDS:* = 10;
        public static const WF_SELHALF:int = 1;
        public static const WF_SELANSW:int = 2;
        public static const WF_TIPAVER:int = 4;
        public static const WF_TIPRANG:int = 8;
        public static const WF_AIRBORNE:int = 16;
        public static const WF_SUBJECT:int = 32;
        public static const WF_FORTRESS:int = 64;
        public static const CLAN_PHP:String = "client_clans.php?";
        public static const ADVENT_PHP:String = "client_advent.php?";
        public static const MINIQUIZ_PHP:String = "client_qprgame.php?";
        public static const QUESTIONS_PHP:String = "client_myquestions.php?";
        public static var loaderinfo:LoaderInfo;
        public static var bootparams:Object;
        public static var mobile:Boolean;
        public static var ios:Boolean;
        public static var android:Boolean;
        public static var desktop:Boolean;
        public static var baseurl:String;
        public static var sourceDomain:String;
        public static var releaseversion:Boolean = false;
        public static var experimental:Boolean = false;
        public static var season:int = 0;
        public static var afterlogin:Boolean = false;
        public static var tracetoconsole:Boolean = false;
        public static var sysconf:Object = null;
        public static var flashvars:Object = null;
        public static var sourceurl:String = "";
        public static var protocol:String = "";
        public static var inbrowser:Boolean = false;
        public static var indesigner:Boolean = false;
        public static var globalhelptabs:Boolean = false;
        public static var framerate:int = 30;
        public static var startscreen:String = "";
        public static var siteid:String = "xe";
        public static var langid:String = "en";
        public static var loginsystem:String = "FACE";
        public static var skin:String = "none";
        public static var bank_board_game:String = "0";
        public static var notifrecollectlimit:Number = 300;
        public static var pagemode:String = "CANVAS";
        public static var clienttype:String = "PC";
        public static var rtl:Boolean = false;
        public static var settings:Object = {};
        public static var abtest:String = "a";
        public static var langjson:String = "dat/lang.json";
        public static var serveraddress:String = "test.triviador.com";
        public static var httpport:int = 0;
        public static var xsocketaddress:String = "";
        public static var xsocketport:int = 2019;
        public static var extdatauribase:* = "http://test.triviador.com/";
        public static var facebook_appid:String = "195139293840591";
        public static var facebook_appurl:String = "apps.facebook.com/cqworldtest/";
        public static var facebook_fp_url_v11:String = "https://www.facebook.com/triviador";
        public static var facebook_fp_url_xe:String = "https://www.facebook.com/triviador";
        public static var facebook_fp_url_us:String = "https://www.facebook.com/triviador";
        public static var facebook_fp_url_xs:String = "https://www.facebook.com/triviadormundo";
        public static var facebook_fp_url_ar:String = "https://www.facebook.com/triviadormundo";
        public static var facebook_fp_url_xa:String = "https://www.facebook.com/saifalmarifa";
        public static var facebook_fp_url_tr:String = "https://www.facebook.com/bilvefethet";
        public static var facebook_fp_url_br:String = "https://www.facebook.com/triviadorbr";
        public static var facebook_fp_url_bg:String = "https://www.facebook.com/conQUIZtador.bg";
        public static var facebook_fp_url_de:String = "https://www.facebook.com/TriviadorDeutschland";
        public static var facebook_fp_url_es:String = "https://www.facebook.com/triviadorespana";
        public static var facebook_fp_url_pl:String = "https://www.facebook.com/triviadorpolska";
        public static var facebook_fp_url_ro:String = "https://www.facebook.com/triviador.romania";
        public static var facebook_fp_url_ru:String = "https://www.facebook.com/triviadorrussia";
        public static var facebook_fp_url_si:String = "https://www.facebook.com/pages/Triviador-Slovenija/166876696841699";
        public static var facebook_fp_url_fr:String = "https://www.facebook.com/triviadorfrance/";
        public static var facebook_fp_url_cz:String = "https://www.facebook.com/Dobyvatel/?fref=ts";
        public static var facebook_fp_url_hu:String = "https://www.facebook.com/honfoglalo/";
        public static var facebook_fp_url_rs:String = "https://www.facebook.com/triviadorsrbija";
        public static var loginemail:String = "";
        public static var loginpassword:String = "";
        public static var loginextid:String = "";
        public static var loginuserid:String = "";
        public static var loginusername:String = "";
        public static var loginsign:String = "";
        public static var loginguid:String = "";
        public static var logintime:String = "";
        public static var stoc:String = "";
        public static var currency:String = "";
        public static var userfirstname:String = "";
        public static var userlastname:String = "";
        public static var useremail:String = "";
        public static var clientparamsxml:XML = null;
        public static var sites:* = [];
        public static var sitebyid:* = {};
        public static var nocache:Object = {};
        public static var noanims:String = "";
        public static var TIMEOUT_SENDING:* = 10000;
        public static var TIMEOUT_LISTEN:* = 40000;
        public static var TIMEOUT_LRESPONSE:* = 15000;
        public static var TIMEOUT_CRESPONSE:* = 2000;
        public static var TIMEOUT_REPEAT:* = 2000;
        public static var focuslossprotection:Boolean = true;
        public static var playercolorcodes:Array = [0, 14224395, 3188232, 1868224];
        public static var emoticons:Array = [":-D", ":-[", ":'("];
        public static var area_values:Array = [0, 1000, 400, 300, 200];
        public static var longrulesorder:* = "123231312132213321";
        public static var duelrulesorder:* = "133113311331";
        public static var helpfieldname:Array = ["SELHALF", "SELANSW", "TIPAVER", "TIPRANG", "AIRBORNE", "SUBJECT", "FORTRESS", "SERIES1", "SERIES2", "SERIES3", "SERIES4", "SERIES5"];
        public static var helpindexes:Object = {
                "SELHALF": 1,
                "SELANSW": 2,
                "TIPAVER": 3,
                "TIPRANG": 4,
                "AIRBORNE": 5,
                "SUBJECT": 6,
                "FORTRESS": 7,
                "SERIES1": 8,
                "SERIES2": 9,
                "SERIES3": 10,
                "SERIES4": 11,
                "SERIES5": 12
            };
        public static var helpmakers:Array = ["blacksmith", "innkeeper", "pet_merchant", "professor", "wizard", "general", "architect", "pirate", "series2", "series3", "series4", "series5"];
        public static var treasurenames:* = [];
        public static var helpullevels:Array = [2, 6, 9, 3, 4, 7, 8, 11, 13, 15, 17, 19];
        public static var missionnames:* = ["", "HELP_SELHALF", "HELP_TIPRANG", "HELP_AIRBORNE", "TRYCHAT", "HELP_SELANSW", "HELP_SUBJECT", "HELP_FORTRESS", "HELP_TIPAVER", "CREATESEPROOM", "NOLOSS_SERIES", "BADGES", "WIN_SERIES", "NOLOSS_SERIES2", "WIN_SERIES2", "WIN_SERIES3", "LOBBY"];
        public static var badgenames:* = ["CW1", "CW2", "XPT", "XPM", "RLP", "TWD", "USQ"];
        public static var badgelevellimits:* = {
                "CW1": [5, 10, 20, 40, 60, 80, 100],
                "CW2": [5, 10, 20, 40, 60, 80, 100],
                "TWD": [10, 20, 50, 100, 200, 500, 1000],
                "XPT": [5000, 10000, 20000, 50000, 100000, 200000, 500000],
                "RLP": [50, 40, 30, 20, 10, 5, 1],
                "XPM": [500, 750, 1000, 1250, 1500, 1750, 2000],
                "USQ": [100, 50, 20, 10, 3, 2, 1]
            };
        public static var maps:Object = {};
        public static var semuparams:Object = {};
        public static var semufeatures:Object = {};
        public static var semuplayers:Object = {};
        public static var semulevelchange:Object = null;
        public static var semumissions:Object = {};
        public static var external_map:String = null;

        public static var external_skin:Object = {};

        public static var external_skin_path:String = "";

        public static var show_slots:Boolean = false;

        public static var xsolla_currency:String = "";

        public static var facebook_convert_url:String = "https://test.triviador.com/facebookconvert.html";

        public static function Init(aloaderinfo:LoaderInfo, abootparams:Object):void
        {
            trace("Config.init...");
            loaderinfo = aloaderinfo;
            bootparams = abootparams;
            Config.mobile = bootparams.mobile;
            Config.ios = Config.mobile && Boolean(bootparams.ios);
            Config.android = Config.mobile && !bootparams.ios;
            Config.desktop = bootparams.desktop;
            Config.xsolla_currency = Util.StringVal(bootparams.xsolla_currency);
            if (Config.desktop)
            {
                Config.pagemode = "DESKTOP";
            }
            Imitation.texturerendering = !Config.ios;
            Config.flashvars = loaderinfo.parameters;
            Config.sourceurl = Util.StringVal(loaderinfo.url);
            Config.protocol = Util.StringVal(Config.sourceurl.split(":")[0]);
            Config.maps = {};
            var u:String = Config.sourceurl;
            var i:int = int(u.indexOf("://"));
            u = u.substr(i + 3);
            Config.sourceDomain = u.substring(0, u.indexOf("/"));
            Config.baseurl = Config.protocol + "://" + Config.sourceDomain;
            if (Config.protocol == "http" || Config.protocol == "https")
            {
                Config.inbrowser = true;
                Config.langjson = "dat/lang.json";
                Config.extdatauribase = "";
                Config.semuparams.ENABLED = 0;
                Config.loginuserid = Config.flashvars.userid;
                Config.loginusername = Config.flashvars.username;
                Config.abtest = Util.StringVal(Config.flashvars.version, "a");
                Config.userlastname = Util.StringVal(Config.flashvars.last_name);
                Config.useremail = Util.StringVal(Config.flashvars.email);
                Config.loginsign = Config.flashvars.sign;
                Config.stoc = Config.flashvars.stoc;
                Config.currency = Util.StringVal(Config.flashvars.currency);
                Config.logintime = Config.flashvars.time;
                Config.loginguid = Config.flashvars.guid;
                Config.loginsign = Config.flashvars.sign;
                Config.loginsystem = Util.StringVal(Config.flashvars.loginsystem, Config.loginsystem);
                Config.pagemode = Util.StringVal(Config.flashvars.pagemode, Config.pagemode);
                Config.loginextid = Util.StringVal(Config.flashvars.extid, Config.loginextid);
            }
            else
            {
                Config.inbrowser = false;
                Config.protocol = !!Config.mobile ? "https" : "http";
            }
            Config.indesigner = !Config.inbrowser && !Config.mobile && !Config.desktop;
            ProcessClientSysConfig({});
            PrepareSites();
            SelectSite(bootparams.siteid);
        }

        public static function LoadClientParams(aurl:String, aoncompletefunc:Function):void
        {
            var uldr:URLLoader;
            var paramsurl:String = aurl;
            if (Config.inbrowser)
            {
                paramsurl += "?" + new Date().getTime();
            }
            uldr = new URLLoader();
            uldr.addEventListener(Event.COMPLETE, function(e:Event):void
                {
                    Config.ProcessClientParams(e.target.data, aoncompletefunc);
                });
            uldr.load(new URLRequest(paramsurl));
        }

        public static function ProcessClientParams(adata:String, func:Function):*
        {
            var node:* = undefined;
            var nname:String = null;
            var tag:Object = null;
            var name:String = null;
            var i:int = 0;
            var file:Object = null;
            var ref:String = null;
            var size:String = null;
            var k:* = undefined;
            var vol:Number = NaN;
            trace("Processing clientparams.xml...");
            Config.clientparamsxml = new XML(adata);
            var cl:* = Config.clientparamsxml.children();
            maps = {};
            var n:* = 0;
            for each (node in cl)
            {
                nname = String(node.name());
                tag = Util.XMLTagToObject(node);
                if (nname == "SERVER")
                {
                    if (tag.HTTPPORT !== undefined)
                    {
                        Config.httpport = Util.StringVal(tag.HTTPPORT);
                    }
                    if (tag.SERVERADDRESS !== undefined)
                    {
                        Config.serveraddress = Util.StringVal(tag.SERVERADDRESS);
                    }
                    if (tag.XSOCKETADDRESS !== undefined)
                    {
                        Config.xsocketaddress = Util.StringVal(tag.XSOCKETADDRESS);
                    }
                    else
                    {
                        Config.xsocketaddress = Config.serveraddress;
                    }
                    if (tag.XSOCKETPORT !== undefined)
                    {
                        Config.xsocketport = Util.NumberVal(tag.XSOCKETPORT);
                    }
                }
                else if (nname == "EXTDATA")
                {
                    Config.extdatauribase = tag.URIBASE;
                }
                else if (nname == "LANG")
                {
                    Config.langid = tag.ID !== undefined ? String(tag.ID) : String(tag.LANGID);
                    Config.rtl = Config.langid == "xa";
                    RtlUtil.rtl_config = Config.rtl;
                    Config.langjson = Util.StringVal(tag.JSON);
                }
                else if (nname == "LOGIN")
                {
                    Config.loginemail = Util.StringVal(tag.LOGINEMAIL);
                    Config.loginpassword = Util.StringVal(tag.LOGINPASSWORD);
                    Config.loginuserid = Util.StringVal(tag.USERID);
                    Config.loginusername = Util.StringVal(tag.NAME);
                    Config.stoc = Util.StringVal(tag.STOC);
                    Config.loginsystem = Util.StringVal(tag.LOGINSYSTEM, Config.loginsystem);
                    Config.pagemode = Util.StringVal(tag.PAGEMODE, Config.pagemode);
                    Config.loginextid = Util.StringVal(tag.EXTID, Config.loginextid);
                }
                else if (nname == "SETTINGS")
                {
                    Config.settings = tag;
                }
                else if (nname == "SYSCONFIG")
                {
                    ProcessClientSysConfig(tag);
                }
                else if (nname == "SERVEREMU" || nname == "SEMU")
                {
                    Config.semuparams = tag;
                }
                else if (nname == "SEMUFEATURES")
                {
                    Config.semufeatures = tag;
                }
                else if (nname == "SEMUPLAYER")
                {
                    Config.semuplayers[tag.NAME] = tag;
                }
                else if (nname == "SEMULEVELCHANGE")
                {
                    Config.semulevelchange = tag;
                }
                else if (nname == "SEMUMISSIONS")
                {
                    Config.semumissions = tag;
                }
                else if (nname == "FLASHVARS")
                {
                    if (Config.flashvars == null)
                    {
                        Config.flashvars = {};
                    }
                    for (name in tag)
                    {
                        Config.flashvars[name] = Util.StringVal(tag[name]);
                    }
                }
                else if (nname == "MAP")
                {
                    maps[tag.ID] = tag;
                }
                else if (nname == "NOCACHE")
                {
                    i = 0;
                    while (i < tag.FILE.length)
                    {
                        file = tag.FILE[i];
                        name = Util.StringVal(file.NAME);
                        ref = Util.StringVal(file.REF);
                        size = Util.StringVal(file.SIZE);
                        Config.nocache[name] = {
                                "ref": ref,
                                "size": size
                            };
                        i++;
                    }
                }
                else if (nname == "EXTERNALSKIN")
                {
                    for (k in tag)
                    {
                        if (k == "SHOWSLOTS")
                        {
                            Config.show_slots = Util.NumberVal(tag[k]);
                        }
                    }
                }
            }
            Config.siteid = Util.StringVal(Config.flashvars.siteid, Util.StringVal(Config.semuparams.SITEID, Config.siteid));
            Semu.enabled = Config.semuparams.ENABLED == "1";
            if (Semu.enabled)
            {
                vol = Util.NumberVal(Config.semuparams.VOL, -1);
                if (vol >= 0)
                {
                    Sounds.volume_master = vol;
                }
            }
            Config.framerate = Util.NumberVal(bootparams.fps, 30);
            if (Config.settings is Object && Config.settings != null)
            {
                Config.startscreen = Util.StrTrim(Util.StringVal(Config.settings.STARTSCREEN));
                Config.releaseversion = Util.NumberVal(Config.settings.RELEASEVERSION, 0) == 1;
                Config.experimental = Util.NumberVal(Config.settings.EXPERIMENTAL, 0) == 1;
                Config.season = Util.NumberVal(Config.settings.SEASON, 0);
                Config.tracetoconsole = Util.NumberVal(Config.settings.TRACETOCONSOLE, 0) == 1;
                Config.framerate = Util.NumberVal(Config.settings.FPS, Config.framerate);
                Config.noanims = Util.StringVal(Config.settings.NOANIMS);
                Config.external_map = Util.StringVal(Config.settings.EXTERNAL_MAP);
                Comm.commlog = Util.NumberVal(Config.settings.COMMLOG);
                if (Config.settings.SKIN != undefined && Config.settings.SKIN != null && Config.settings.SKIN != "")
                {
                    Config.skin = Config.settings.SKIN.toLowerCase();
                }
                if (Config.settings.BANK_BOARD_GAME != undefined && Config.settings.BANK_BOARD_GAME != null && Config.settings.BANK_BOARD_GAME != "")
                {
                    Config.bank_board_game = String(Config.settings.BANK_BOARD_GAME);
                }
                if (Config.settings.NOFITRECOLLECTLIMIT != undefined && Config.settings.NOFITRECOLLECTLIMIT != null && Config.settings.NOFITRECOLLECTLIMIT != "")
                {
                    Config.notifrecollectlimit = Number(Config.settings.NOFITRECOLLECTLIMIT);
                }
                if (Config.settings.NOTIFRECOLLECTLIMIT != undefined && Config.settings.NOTIFRECOLLECTLIMIT != null && Config.settings.NOTIFRECOLLECTLIMIT != "")
                {
                    Config.notifrecollectlimit = Number(Config.settings.NOTIFRECOLLECTLIMIT);
                }
            }
            JsQuery.baseuri = Config.extdatauribase;
            if (func != null)
            {
                func.apply(null);
            }
        }

        public static function ProcessClientSysConfig(adata:Object):*
        {
            var pn:String = null;
            Config.sysconf = {
                    "ALLOWCHARS": "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890",
                    "FB_FANPAGE_URL": "",
                    "DEVMODE": 1
                };
            if (adata)
            {
                for (pn in adata)
                {
                    Config.sysconf[pn] = adata[pn];
                }
            }
        }

        public static function GetChatRestrictChars():String
        {
            var chars:String = Util.StringVal(Config.sysconf.ALLOWCHARS);
            if (chars.length == 0)
            {
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890 ";
            }
            return chars + ("?!.,:;()+-=/*<>[]@#_%$&\"" + "'");
        }

        public static function GetNameRestrictChars():String
        {
            var chars:String = Util.StringVal(Config.sysconf.ALLOWCHARS);
            if (chars.length == 0)
            {
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890 ";
            }
            return chars;
        }

        public static function PrepareSites():*
        {
            var site:* = undefined;
            AddSite("xe", "en", 2004, "247891555256412", "triviador");
            sitebyid["xe"].map = "WD";
            AddSite("us", "en", 2002, "126677284112469", "triviador_usa");
            AddSite("xs", "es", 2002, "267437456639902", "triviador_mundo");
            sitebyid["xs"].map = "WD";
            AddSite("ar", "es", 2004, "365809930098093", "triviador_argentina");
            AddSite("es", "es", 2002, "1399159243654709", "triviador_espana");
            AddSite("xa", "xa", 2002, "113189532154872", "saif_almarifa");
            sitebyid["xa"].map = "WD";
            AddSite("de", "de", 2002, "433940386664596", "triviador_deutsch");
            AddSite("ru", "ru", 2002, "242521419215697", "triviador_russian");
            AddSite("tr", "tr", 2002, "314170211981069", "bil_ve_fethet");
            AddSite("ro", "ro", 2004, "134751919917644", "triviador_romania");
            AddSite("pl", "pl", 2002, "311084479033479", "triviador_polska");
            AddSite("br", "br", 2006, "160283864086995", "triviador_brasil");
            AddSite("bg", "bg", 2006, "180139765341109", "triviador_bulgaria");
            AddSite("si", "si", 2006, "369356599865592", "triviador_slovenija");
            AddSite("fr", "fr", 0, "150750461622203", "triviador_france");
            AddSite("cz", "cz", 0, "189907841025410", "dobyvatel_cz");
            AddSite("hu", "hu", 0, "162299777139216", "honfoglalo");
            AddSite("rs", "rs", 0, "144195745635832", "triviador_srbija");
            AddSite("v11", "en", 2019, "741859649205390", "trdev_secondversion");
            maps = {};
            for each (site in sites)
            {
                maps[site.map] = {
                        "ID": site.map.toUpperCase(),
                        "AREANUM": 15,
                        "IMAGE": "assets/maps/" + site.map.toLowerCase() + ".swf"
                    };
            }
        }

        public static function AddSite(asiteid:String, alangid:String, axsocketport:int, afbappid:String, afbnamespace:String):Object
        {
            var site:Object = {
                    "siteid": asiteid,
                    "langid": alangid,
                    "xsocketport": axsocketport,
                    "fbappid": afbappid,
                    "fbnamespace": afbnamespace,
                    "map": asiteid.toUpperCase()
                };
            sites.push(site);
            sitebyid[asiteid] = site;
            return site;
        }

        public static function SelectSite(asiteid:String):*
        {
            var site:* = sitebyid[asiteid];
            if (!site)
            {
                return;
            }
            trace("Config.SelectSite: " + asiteid);
            Config.siteid = asiteid;
            trace("Config.SelectSite: " + Config.siteid);
            Config.serveraddress = asiteid + "game.triviador.com";
            Config.facebook_appid = site.fbappid;
            Config.facebook_appurl = "apps.facebook.com/" + site.fbnamespace + "/";
            Config.xsocketport = site.xsocketport;
            Config.extdatauribase = "http://" + siteid + "web.triviador.com/";
            Config.loginsystem = "FACE";
            Config.inbrowser = false;
            Config.pagemode = "NONE";
            Config.clienttype = !!Config.ios ? "IOS" : "ANDR";
            Config.langid = site.langid;
            Config.langjson = "http://" + siteid + "web.triviador.com/dat/lang.json";
            Config.rtl = Config.langid == "xa";
            RtlUtil.rtl_config = Config.rtl;
            Config.settings.DEFAULTMAP = site.map;
        }

        public static function GetSettingS(name:String, def:String = ""):String
        {
            var tmp:String = null;
            if (Config.settings is Object && Config.settings != null)
            {
                tmp = Util.StringVal(Config.settings[name], def);
                return tmp.length > 0 ? tmp : def;
            }
            return def;
        }

        public static function GetSettingN(name:String, def:Number = 0):Number
        {
            return Util.NumberVal(Config.GetSettingS(name, String(def)));
        }

        public static function GetFileReference(name:String):String
        {
            if (typeof Config.nocache[name] == "object")
            {
                return Util.StringVal(Config.nocache[name].ref, name);
            }
            return name;
        }

        public static function GetFileSize(name:String):int
        {
            if (typeof Config.nocache[name] == "object")
            {
                return Util.NumberVal(Config.nocache[name].size, 0);
            }
            return 0;
        }

        public function Config()
        {
            super();
        }
    }
}
