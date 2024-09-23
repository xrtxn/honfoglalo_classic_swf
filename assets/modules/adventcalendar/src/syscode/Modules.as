package syscode {
		import flash.display.MovieClip;
		
		public class Modules {
				public function Modules() {
						super();
				}
				
				public static function GetClass(modulename:String, classname:String) : Class {
						return null;
				}
				
				public static function LoadModule(modulename:String, finishcallback:Function, progresscallback:Function) : void {
				}
				
				public static function Loaded(modulename:String) : Boolean {
						return false;
				}
				
				public static function GetModuleMC(modulename:String) : MovieClip {
						return null;
				}
				
				public static function ShowModuleWait(modulename:String, aprogress:Number = -1) : void {
				}
				
				public static function HideModuleWait() : void {
				}
				
				public static function ScheduleLoadModule(modulename:String) : void {
				}
				
				public static function LoadScheduledModules(afinishcallback:Function, aprogresscallback:Function = null) : void {
				}
		}
}

