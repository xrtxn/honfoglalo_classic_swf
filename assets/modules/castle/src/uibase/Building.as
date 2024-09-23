package uibase {
		import flash.display.MovieClip;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol730")]
		public class Building extends MovieClip {
				public static var forge_classnames:Array = ["","Blacksmith","Inn","Petmerchant","Scientist","Wizard","General","Architect","Pirate","University","University","University","University"];
				
				public var category:String = "general";
				
				public var classdefinition:Object = null;
				
				public var type:int = 0;
				
				public var level:int = 1;
				
				public var data:Object;
				
				public var mc:MovieClip = null;
				
				public var ox:Number;
				
				public var oy:Number;
				
				public var BUILDINGGRAPH:MovieClip;
				
				public function Building(classname:* = "") {
						super();
				}
				
				public static function LoadGFX(completefunc:Function) : void {
				}
				
				public function SetupForge(atype:int, alevel:int) : * {
				}
				
				public function SetLevel(alevel:int) : * {
				}
				
				public function CreateMC(classname:*) : * {
				}
				
				public function RemoveMC() : * {
				}
				
				public function MovieClipHasLabel(movieClip:MovieClip, labelName:String) : Boolean {
						return false;
				}
		}
}

