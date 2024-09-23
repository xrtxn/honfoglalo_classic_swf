package syscode {
		import flash.display.Bitmap;
		import flash.display.MovieClip;
		
		public class AvatarFactory {
				public static var propcounts:Array = [null,{},{}];
				
				public static var sexcount:int = 2;
				
				public static var headcount:int = 6;
				
				public static var back_colors:Array = [16777215,11918264,12313327,16776136,16763379,15263976,10780768,8434615,14662005,16096256,4693059,12352963,8618883,2518197];
				
				public static var head_colors:Array = [16773360,16767449,16243127,15968120,12154929,7621407];
				
				public static var hair_colors:Array = [16769924,13541120,16358443,13192477,6827550,2102541,15658734];
				
				public static var eye_colors:Array = [0,8026746,1600173,3188644,2193437,9656380];
				
				public static var male_facial_colors:Array = [16769924,13541120,16358443,13192477,6827550,2102541,15658734];
				
				public static var female_hairdecor_colors:Array = [16769924,16742263,11158783,15289629,5614165,3355443,15658734,5605631];
				
				public function AvatarFactory() {
						super();
				}
				
				public static function Init() : void {
				}
				
				public static function AnalyzeAssetMov() : * {
				}
				
				public static function GetSymbolIndex(sex:int, head:int, m:MovieClip) : * {
				}
				
				public static function NewSymbols(aname:String, asex:int) : Array {
						return null;
				}
				
				public static function NewAvatarMC() : MovieClip {
						return null;
				}
				
				public static function StartAnim(members:Object, anim:int = 0, repeat:int = 10) : * {
				}
				
				public static function PreviewAnim(members:Object, anim:int = 0) : * {
				}
				
				public static function RestoreDefaultAnim(members:*) : * {
				}
				
				public static function CloneProperties(p:Object) : Object {
						return null;
				}
				
				public static function CreateProperties(astr:String = "") : Object {
						return null;
				}
				
				public static function RandomizeProperties(p:Object, asex:int) : * {
				}
				
				public static function ChangeSex(p:Object, asex:int) : * {
				}
				
				public static function SetProperty(p:Object, propname:String, value:int) : int {
						return 0;
				}
				
				public static function FormatProperties(p:Object) : String {
						return "";
				}
				
				public static function CreateAvatarMov(p:Object, amembers:Object = null, anim_id:int = 0) : MovieClip {
						return null;
				}
				
				public static function CreateAvatarAnim(astr:String, bg:Boolean, amembers:Object = null, anim_id:int = 0) : MovieClip {
						return null;
				}
				
				public static function CreateAvatarBitmap(astr:String, size:int = 35, scale:Number = 1) : Bitmap {
						return null;
				}
				
				public static function UpdateProperties(mc:MovieClip, p:Object, amembers:Object = null, anim:int = 0) : void {
				}
		}
}

