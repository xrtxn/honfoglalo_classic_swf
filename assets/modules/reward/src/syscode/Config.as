package syscode {
		import flash.display.LoaderInfo;
		
		public class Config {
				public static var loaderinfo:LoaderInfo;
				
				public static var bootparams:Object;
				
				public static var mobile:Boolean;
				
				public static var ios:Boolean;
				
				public static var android:Boolean;
				
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
				
				public static var playercolorcodes:Array = [0,14224395,3188232,1868224];
				
				public static var emoticons:Array = [":-D",":-[",":\'("];
				
				public static var area_values:Array = [0,1000,400,300,200];
				
				public static var longrulesorder:* = "123231312132213321";
				
				public static var duelrulesorder:* = "133113311331";
				
				public static var helpfieldname:Array = ["SELHALF","SELANSW","TIPAVER","TIPRANG","AIRBORNE","SUBJECT","FORTRESS","SERIES1","SERIES2","SERIES3","SERIES4","SERIES5"];
				
				public static var helpindexes:Object = {
						"SELHALF":1,
						"SELANSW":2,
						"TIPAVER":3,
						"TIPRANG":4,
						"AIRBORNE":5,
						"SUBJECT":6,
						"FORTRESS":7,
						"SERIES1":8,
						"SERIES2":9,
						"SERIES3":10,
						"SERIES4":11,
						"SERIES5":12
				};
				
				public static var helpmakers:Array = ["blacksmith","innkeeper","pet_merchant","professor","wizard","general","architect","pirate","series2","series3","series4","series5"];
				
				public static var treasurenames:* = [];
				
				public static var helpullevels:Array = [2,6,9,3,4,7,8,11,13,15,17,19];
				
				public static var missionnames:* = ["","HELP_SELHALF","HELP_TIPRANG","HELP_AIRBORNE","TRYCHAT","HELP_SELANSW","HELP_SUBJECT","HELP_FORTRESS","HELP_TIPAVER","CREATESEPROOM","NOLOSS_SERIES","BADGES","WIN_SERIES","NOLOSS_SERIES2","WIN_SERIES2","WIN_SERIES3","LOBBY"];
				
				public static var badgenames:* = ["CW1","CW2","XPT","XPM","RLP","TWD","USQ"];
				
				public static var badgelevellimits:* = {
						"CW1":[5,10,20,40,60,80,100],
						"CW2":[5,10,20,40,60,80,100],
						"TWD":[10,20,50,100,200,500,1000],
						"XPT":[5000,10000,20000,50000,100000,200000,500000],
						"RLP":[50,40,30,20,10,5,1],
						"XPM":[500,750,1000,1250,1500,1750,2000],
						"USQ":[100,50,20,10,3,2,1]
				};
				
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
				
				public static var maps:Object = {};
				
				public static var semuparams:Object = {};
				
				public static var semufeatures:Object = {};
				
				public static var semuplayers:Object = {};
				
				public static var semulevelchange:Object = null;
				
				public static var semumissions:Object = {};
				
				public static const CLAN_PHP:String = "client_clans.php?";
				
				public static const ADVENT_PHP:String = "client_advent.php?";
				
				public static const MINIQUIZ_PHP:String = "client_qprgame.php?";
				
				public static const QUESTIONS_PHP:String = "client_myquestions.php?";
				
				public static var external_map:String = null;
				
				public static var external_skin:Object = {};
				
				public static var external_skin_path:String = "";
				
				public static var show_slots:Boolean = false;
				
				public function Config() {
						super();
				}
				
				public static function Init(param1:LoaderInfo, param2:Object) : void {
				}
				
				public static function LoadClientParams(param1:String, param2:Function) : void {
				}
				
				public static function ProcessClientParams(param1:String, param2:Function) : * {
				}
				
				public static function ProcessClientSysConfig(param1:Object) : * {
				}
				
				public static function GetChatRestrictChars() : String {
						return "";
				}
				
				public static function GetNameRestrictChars() : String {
						return "";
				}
				
				public static function PrepareSites() : * {
				}
				
				public static function AddSite(param1:String, param2:String, param3:int, param4:String, param5:String) : Object {
						return null;
				}
				
				public static function SelectSite(param1:String) : * {
				}
				
				public static function GetSettingS(param1:String, param2:String = "") : String {
						return "";
				}
				
				public static function GetSettingN(param1:String, param2:Number = 0) : Number {
						return 0;
				}
				
				public static function GetFileReference(param1:String) : String {
						return "";
				}
				
				public static function GetFileSize(param1:String) : int {
						return 0;
				}
		}
}

