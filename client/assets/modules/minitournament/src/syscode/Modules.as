package syscode {
		import flash.display.MovieClip;
		
		public class Modules {
				public static var moduledata:Object = {};
				
				public static var processorclasses:Object = {};
				
				public function Modules() {
						super();
				}
				
				public static function Init() : * {
				}
				
				public static function SetModuleData(aname:String, aurl:String, arequiredby:String, aestimatedbytes:int = -1) : void {
				}
				
				public static function GetModuleUrl(aname:String) : String {
						return "";
				}
				
				public static function GetModuleSize(aname:String) : int {
						return 0;
				}
				
				public static function SetModuleSwf(aname:String, amc:Object) : void {
				}
				
				public static function GetModuleMC(modulename:String) : MovieClip {
						return null;
				}
				
				public static function Loaded(modulename:String) : Boolean {
						return false;
				}
				
				public static function GetClass(modulename:String, classname:String) : Class {
						return null;
				}
				
				public static function GetProcessorClass(modulename:String) : Class {
						return null;
				}
				
				public static function ShowModuleWait(modulename:String, aprogress:Number = -1) : void {
				}
				
				public static function OnWaitMcFrame(e:*) : void {
				}
				
				public static function AlignWaitMc() : void {
				}
				
				public static function HideModuleWait() : void {
				}
				
				public static function ScheduleLoadModule(modulename:String) : void {
				}
				
				public static function LoadScheduledModules(afinishcallback:Function, aprogresscallback:Function = null) : void {
				}
				
				public static function ScheduleRequiredModules(aname:String) : void {
				}
				
				public static function LoadModule(modulename:String, finishcallback:Function, progresscallback:Function) : void {
				}
		}
}

