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
				
				public static function Init(aflamc:MovieClip, amainsceneclass:Class, callback:Function) : * {
				}
				
				public static function CheckContext() : Boolean {
						return false;
				}
				
				public static function SetContextMenu(contextMenu:ContextMenu) : void {
				}
				
				public static function GlobalToLocal(pt:Point, obj:DisplayObject) : Point {
						return null;
				}
				
				public static function ConfigureProjection(stw:int, sth:int) : void {
				}
				
				public static function StageResized(stw:int, sth:int) : void {
				}
				
				public static function GotoFrame(obj:MovieClip, aframe:*, aregenbmpnow:Boolean = true) : void {
				}
				
				public static function DrawQuad() : void {
				}
				
				public static function SetRenderTarget(agimage:Object, awidth:Number, aheight:Number) : void {
				}
				
				public static function Render() : * {
				}
				
				public static function Restart() : void {
				}
				
				public static function Stop() : void {
				}
				
				public static function UpdateFrame() : void {
				}
				
				public static function Update(obj:DisplayObject) : void {
				}
				
				public static function UpdateAll(aobj:DisplayObject = null) : void {
				}
				
				public static function UpdateToDisplay(aobj:DisplayObject = null, withchildren:Boolean = false) : void {
				}
				
				public static function ChangeParent(aobj:DisplayObject, atarget:DisplayObjectContainer) : void {
				}
				
				public static function CollectChildren(aobj:DisplayObject = null) : void {
				}
				
				public static function CollectChildrenAll(aobj:DisplayObject = null) : void {
				}
				
				public static function FreeBitmapAll(aobj:DisplayObject = null) : void {
				}
				
				public static function FreeBitmap(aobj:DisplayObject) : void {
				}
				
				public static function Combine(obj:DisplayObject, acombine:Boolean) : void {
				}
				
				public static function SetMaskedMov(maskmov:DisplayObject, maskedmov:DisplayObject, alphamask:Boolean = false, achangingmask:Boolean = false) : void {
				}
				
				public static function AddEventMask(maskmov:DisplayObject, maskedmov:DisplayObject) : void {
				}
				
				public static function RemoveEventMask(maskmov:DisplayObject) : void {
				}
				
				public static function FreezeEvents(aobj:DisplayObject) : void {
				}
				
				public static function UnFreezeEvents(aobj:DisplayObject) : void {
				}
				
				public static function UnFreezeAllEvents() : void {
				}
				
				public static function SetFocus(obj:DisplayObject) : void {
				}
				
				public static function SetColor(dobj:DisplayObject, color:uint) : void {
				}
				
				public static function SetBoundsBorder(amov:DisplayObject, border:Number) : void {
				}
				
				public static function SetBitmapScale(amov:DisplayObject, ascale:Number) : void {
				}
				
				public static function CreateClone(aclonedmov:DisplayObject, atargetmov:DisplayObjectContainer) : MovieClip {
						return null;
				}
				
				public static function EnableInput(amov:DisplayObject, aenable:Boolean) : void {
				}
				
				public static function RTLEditSetup(tf:TextField) : * {
				}
				
				public static function SetRTLEditText(tf:TextField, value:String) : void {
				}
				
				public static function GetRTLEditText(tf:TextField) : String {
						return "";
				}
				
				public static function GetMaxScrollV(tf:TextField) : int {
						return 0;
				}
				
				public static function GetScrollV(tf:TextField) : int {
						return 0;
				}
				
				public static function SetScrollV(tf:TextField, value:int) : void {
				}
				
				public static function Prepare(aobj:DisplayObject) : * {
				}
				
				public static function CollectStats(obj:DisplayObject = null, detailed:Boolean = false) : Object {
						return null;
				}
				
				public static function GetRenderStat() : Object {
						return null;
				}
				
				public static function AddEventGroup(aobj:DisplayObject) : * {
				}
				
				public static function AddButtonStop(aobj:DisplayObject) : * {
				}
				
				public static function DeleteEventGroup(aobj:DisplayObject) : * {
				}
				
				public static function AddEventClick(aobj:DisplayObject, afunc:Function, aparams:Object = null) : * {
				}
				
				public static function AddEventMouseMove(aobj:DisplayObject, afunc:Function, aparams:Object = null) : * {
				}
				
				public static function AddEventMouseDown(aobj:DisplayObject, afunc:Function, aparams:Object = null) : * {
				}
				
				public static function AddEventMouseUp(aobj:DisplayObject, afunc:Function, aparams:Object = null) : * {
				}
				
				public static function AddEventMouseOver(aobj:DisplayObject, afunc:Function, aparams:Object = null) : * {
				}
				
				public static function AddEventMouseOut(aobj:DisplayObject, afunc:Function, aparams:Object = null) : * {
				}
				
				public static function RemoveEvents(aobj:DisplayObject) : void {
				}
				
				public static function AddGlobalListener(name:String, callback:Function) : void {
				}
				
				public static function RemoveGlobalListener(name:String, callback:Function) : void {
				}
				
				public static function DispatchGlobalEvent(name:String, event:Event = null) : void {
				}
				
				public static function AddStageEventListener(name:String, callback:Function) : Function {
						return null;
				}
				
				public static function RemoveStageEventListener(name:String, callback:Function) : void {
				}
				
				public static function DispatchStageEvent(name:String, event:Event = null) : void {
				}
				
				public static function HandleMouseDown(event:Object, excluedobjs:Array = null) : void {
				}
				
				public static function HandleMouseUp(event:Object, excluedobjs:Array = null) : void {
				}
				
				public static function HandleMouseMove(event:Object, excluedobjs:Array = null) : void {
				}
				
				public static function GetMousePos(aobj:DisplayObject = null) : Point {
						return null;
				}
				
				public static function CalculateBitmapScale(aobj:DisplayObject) : Number {
						return 0;
				}
				
				public static function SetColorMultiplier(dobj:DisplayObject, ct:ColorTransform) : void {
				}
		}
}

