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
				
				public static function SetModuleData(param1:String, param2:String, param3:String, param4:int = -1) : void {
				}
				
				public static function GetModuleUrl(param1:String) : String {
						return "";
				}
				
				public static function GetModuleSize(param1:String) : int {
						return 0;
				}
				
				public static function SetModuleSwf(param1:String, param2:Object) : void {
				}
				
				public static function GetModuleMC(param1:String) : MovieClip {
						return null;
				}
				
				public static function Loaded(param1:String) : Boolean {
						return false;
				}
				
				public static function GetClass(param1:String, param2:String) : Class {
						return null;
				}
				
				public static function GetProcessorClass(param1:String) : Class {
						return null;
				}
				
				public static function ShowModuleWait(param1:String, param2:Number = -1) : void {
				}
				
				public static function OnWaitMcFrame(param1:*) : void {
				}
				
				public static function AlignWaitMc() : void {
				}
				
				public static function HideModuleWait() : void {
				}
				
				public static function ScheduleLoadModule(param1:String) : void {
				}
				
				public static function LoadScheduledModules(param1:Function, param2:Function = null) : void {
				}
				
				public static function ScheduleRequiredModules(param1:String) : void {
				}
				
				public static function LoadModule(param1:String, param2:Function, param3:Function) : void {
				}
		}
}

