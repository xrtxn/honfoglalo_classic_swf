package syscode {
		import flash.display.*;
		import flash.events.*;
		
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
				
				public static var sysconf:Object = null;
				
				public static var flashvars:Object = null;
				
				public static var sourceurl:String = "";
				
				public static var protocol:String = "";
				
				public static var inbrowser:Boolean = false;
				
				public static var indesigner:Boolean = false;
				
				public static var globalhelptabs:Boolean = true;
				
				public static var framerate:int = 30;
				
				public static var siteid:String = "xe";
				
				public static var langid:String = "en";
				
				public static var loginsystem:String = "FACE";
				
				public static var skin:String = "test";
				
				public static var pagemode:String = "CANVAS";
				
				public static var clienttype:String = "PC";
				
				public static var rtl:Boolean = false;
				
				public static var settings:Object = {};
				
				public static var abtest:String = "a";
				
				public static var langjson:String = "dat/lang.json";
				
				public static var serveraddress:String = "test.triviador.com";
				
				public static var httpport:int = 80;
				
				public static var xsocketaddress:String = "";
				
				public static var xsocketport:int = 2019;
				
				public static var extdatauribase:* = "http://test.triviador.com/";
				
				public static var facebook_appid:String = "195139293840591";
				
				public static var facebook_appurl:String = "apps.facebook.com/cqworldtest/";
				
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
				
				public static var loginemail:String = "";
				
				public static var loginpassword:String = "";
				
				public static var loginuserid:String = "";
				
				public static var loginusername:String = "";
				
				public static var loginsign:String = "";
				
				public static var loginguid:String = "";
				
				public static var logintime:String = "";
				
				public static var stoc:String = "";
				
				public static var currency:String = "";
				
				public static var loginextid:String = "";
				
				public static var userfirstname:String = "";
				
				public static var userlastname:String = "";
				
				public static var useremail:String = "";
				
				public static var clientparamsxml:XML = null;
				
				public static var sites:* = [];
				
				public static var sitebyid:* = {};
				
				public static var nocache:Object = {};
				
				public static var noanims:String = "";
				
				public static var playercolorcodes:Array = [0,15925505,10072143,3648456];
				
				public static var emoticons:Array = [":-D",":-[",":\'("];
				
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
				
				public static var longrulesorder:* = "123231312132213321";
				
				public static var helpullevels:Array = [2,6,9,3,4,7,8,11,13,15,17,19];
				
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
				
				public static const CLAN_PHP:String = "client_clans.php?";
				
				public static const ADVENT_PHP:String = "client_advent.php?";
				
				public static const MINIQUIZ_PHP:String = "client_qprgame.php?";
				
				public static const QUESTIONS_PHP:String = "client_myquestions.php?";
				
				public static const WF_SELHALF:int = 1;
				
				public static const WF_SELANSW:int = 2;
				
				public static const WF_TIPAVER:int = 4;
				
				public static const WF_TIPRANG:int = 8;
				
				public static const WF_AIRBORNE:int = 16;
				
				public static const WF_SUBJECT:int = 32;
				
				public static const WF_FORTRESS:int = 64;
				
				public static var maps:Object = {};
				
				public function Config() {
						super();
				}
				
				public static function ProcessClientSysConfig(adata:Object) : * {
						var pn:String = null;
						Config.sysconf = {
								"ALLOWCHARS":"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890",
								"FB_FANPAGE_URL":""
						};
						if(adata) {
								for(pn in adata) {
										Config.sysconf[pn] = adata[pn];
								}
						}
				}
				
				public static function GetChatRestrictChars() : String {
						var chars:String = Util.StringVal(Config.sysconf.ALLOWCHARS);
						if(chars.length == 0) {
								chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890 ";
						}
						return chars + ("?!.,:;()+-=/*<>[]@#_%$&\"" + "\'");
				}
				
				public static function GetNameRestrictChars() : String {
						var chars:String = Util.StringVal(Config.sysconf.ALLOWCHARS);
						if(chars.length == 0) {
								chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890 ";
						}
						return chars;
				}
				
				public static function GetSettingS(name:String, def:String = "") : String {
						var tmp:String = null;
						if(Config.settings is Object && Config.settings != null) {
								tmp = Util.StringVal(Config.settings[name],def);
								return tmp.length > 0 ? tmp : def;
						}
						return def;
				}
				
				public static function GetSettingN(name:String, def:Number = 0) : Number {
						return Util.NumberVal(Config.GetSettingS(name,String(def)));
				}
				
				public static function GetFileReference(name:String) : String {
						return Util.StringVal(Config.nocache[name],name);
				}
		}
}

