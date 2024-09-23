package syscode {
		import flash.display.DisplayObject;
		import flash.display.DisplayObjectContainer;
		import flash.display.MovieClip;
		import flash.display.Stage;
		import flash.display.Stage3D;
		import flash.display3D.Context3D;
		import flash.events.Event;
		import flash.geom.ColorTransform;
		import flash.geom.Matrix;
		import flash.geom.Point;
		import flash.text.TextField;
		import flash.ui.ContextMenu;
		import flash.utils.Dictionary;
		
		public class Imitation {
				public static var gsqc:*;
				
				public static var active:Boolean = false;
				
				public static var usegpu:Boolean = true;
				
				public static var stage3d_error_checking:Boolean = false;
				
				public static var extendedcontext:Boolean = false;
				
				public static var TARGETDPI:int = 1000;
				
				public static var MAXTEXTURE:int = 1024;
				
				public static var maxtexturesize:int = 1024;
				
				public static var dpirate:Number = 1;
				
				public static var width:int = 0;
				
				public static var height:int = 0;
				
				public static var driverinfo:String = "oldschool";
				
				public static var showregions:* = false;
				
				public static var stage:Stage = null;
				
				public static var mobile:Boolean = false;
				
				public static var mainmc:MovieClip = null;
				
				public static var rootmc:MovieClip = null;
				
				public static var imitators:Dictionary = new Dictionary(true);
				
				public static var projmatrix:Matrix = new Matrix();
				
				public static var identitymatrix:Matrix = new Matrix();
				
				public static var stage3D:Stage3D = null;
				
				public static var context:Context3D = null;
				
				public static var activerendertarget:Object = null;
				
				public static var activerenderhalfwidth:Number = 1;
				
				public static var activerenderhalfheight:Number = 1;
				
				public static var activerenderpix:Number = 1;
				
				public static var showhot:Boolean = false;
				
				public static var color_gimage:Object = null;
				
				public static var color_gimage2:Object = null;
				
				public static var restoring:Boolean = false;
				
				public function Imitation() {
						super();
				}
				
				public static function Init(param1:MovieClip, param2:Class, param3:Function) : * {
				}
				
				public static function CheckContext() : Boolean {
						return false;
				}
				
				public static function SetContextMenu(param1:ContextMenu) : void {
				}
				
				public static function GlobalToLocal(param1:Point, param2:DisplayObject) : Point {
						return null;
				}
				
				public static function ConfigureProjection(param1:int, param2:int) : void {
				}
				
				public static function StageResized(param1:int, param2:int) : void {
				}
				
				public static function GotoFrame(param1:MovieClip, param2:*, param3:Boolean = true) : void {
				}
				
				public static function DrawQuad() : void {
				}
				
				public static function SetRenderTarget(param1:Object, param2:Number, param3:Number) : void {
				}
				
				public static function Render() : * {
				}
				
				public static function Restart() : void {
				}
				
				public static function Stop() : void {
				}
				
				public static function UpdateFrame() : void {
				}
				
				public static function Update(param1:DisplayObject) : void {
				}
				
				public static function UpdateAll(param1:DisplayObject = null) : void {
				}
				
				public static function UpdateToDisplay(param1:DisplayObject = null, param2:Boolean = false) : void {
				}
				
				public static function ChangeParent(param1:DisplayObject, param2:DisplayObjectContainer) : void {
				}
				
				public static function CollectChildren(param1:DisplayObject = null) : void {
				}
				
				public static function CollectChildrenAll(param1:DisplayObject = null) : void {
				}
				
				public static function FreeBitmapAll(param1:DisplayObject = null) : void {
				}
				
				public static function FreeBitmap(param1:DisplayObject) : void {
				}
				
				public static function Combine(param1:DisplayObject, param2:Boolean) : void {
				}
				
				public static function SetMaskedMov(param1:DisplayObject, param2:DisplayObject, param3:Boolean = false, param4:Boolean = false) : void {
				}
				
				public static function AddEventMask(param1:DisplayObject, param2:DisplayObject) : void {
				}
				
				public static function RemoveEventMask(param1:DisplayObject) : void {
				}
				
				public static function FreezeEvents(param1:DisplayObject) : void {
				}
				
				public static function UnFreezeEvents(param1:DisplayObject) : void {
				}
				
				public static function UnFreezeAllEvents() : void {
				}
				
				public static function SetFocus(param1:DisplayObject) : void {
				}
				
				public static function SetColor(param1:DisplayObject, param2:uint) : void {
				}
				
				public static function SetBoundsBorder(param1:DisplayObject, param2:Number) : void {
				}
				
				public static function SetBitmapScale(param1:DisplayObject, param2:Number) : void {
				}
				
				public static function CreateClone(param1:DisplayObject, param2:DisplayObjectContainer) : MovieClip {
						return null;
				}
				
				public static function EnableInput(param1:DisplayObject, param2:Boolean) : void {
				}
				
				public static function RTLEditSetup(param1:TextField) : * {
				}
				
				public static function SetRTLEditText(param1:TextField, param2:String) : void {
				}
				
				public static function GetRTLEditText(param1:TextField) : String {
						return "";
				}
				
				public static function GetMaxScrollV(param1:TextField) : int {
						return 0;
				}
				
				public static function GetScrollV(param1:TextField) : int {
						return 0;
				}
				
				public static function SetScrollV(param1:TextField, param2:int) : void {
				}
				
				public static function Prepare(param1:DisplayObject) : * {
				}
				
				public static function CollectStats(param1:DisplayObject = null, param2:Boolean = false) : Object {
						return null;
				}
				
				public static function GetRenderStat() : Object {
						return null;
				}
				
				public static function AddEventGroup(param1:DisplayObject) : * {
				}
				
				public static function AddButtonStop(param1:DisplayObject) : * {
				}
				
				public static function DeleteEventGroup(param1:DisplayObject) : * {
				}
				
				public static function AddEventClick(param1:DisplayObject, param2:Function, param3:Object = null) : * {
				}
				
				public static function AddEventMouseMove(param1:DisplayObject, param2:Function, param3:Object = null) : * {
				}
				
				public static function AddEventMouseDown(param1:DisplayObject, param2:Function, param3:Object = null) : * {
				}
				
				public static function AddEventMouseUp(param1:DisplayObject, param2:Function, param3:Object = null) : * {
				}
				
				public static function AddEventMouseOver(param1:DisplayObject, param2:Function, param3:Object = null) : * {
				}
				
				public static function AddEventMouseOut(param1:DisplayObject, param2:Function, param3:Object = null) : * {
				}
				
				public static function RemoveEvents(param1:DisplayObject) : void {
				}
				
				public static function AddGlobalListener(param1:String, param2:Function) : void {
				}
				
				public static function RemoveGlobalListener(param1:String, param2:Function) : void {
				}
				
				public static function DispatchGlobalEvent(param1:String, param2:Event = null) : void {
				}
				
				public static function AddStageEventListener(param1:String, param2:Function) : Function {
						return null;
				}
				
				public static function RemoveStageEventListener(param1:String, param2:Function) : void {
				}
				
				public static function DispatchStageEvent(param1:String, param2:Event = null) : void {
				}
				
				public static function HandleMouseDown(param1:Object, param2:Array = null) : void {
				}
				
				public static function HandleMouseUp(param1:Object, param2:Array = null) : void {
				}
				
				public static function HandleMouseMove(param1:Object, param2:Array = null) : void {
				}
				
				public static function GetMousePos(param1:DisplayObject = null) : Point {
						return null;
				}
				
				public static function CalculateBitmapScale(param1:DisplayObject) : Number {
						return 0;
				}
				
				public static function SetColorMultiplier(param1:DisplayObject, param2:ColorTransform) : void {
				}
		}
}

