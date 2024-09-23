package syscode {
		import flash.display.DisplayObject;
		import flash.display.DisplayObjectContainer;
		import flash.display.MovieClip;
		import flash.display.Stage;
		import flash.events.Event;
		import flash.geom.Point;
		
		public class Imitation {
				public static var usegpu:Boolean = true;
				
				public static var driverinfo:String = "oldschool";
				
				public static var stage:Stage = null;
				
				public static var mainmc:MovieClip = null;
				
				public static var rootmc:MovieClip = null;
				
				public static var showregions:* = false;
				
				public function Imitation() {
						super();
				}
				
				public static function GlobalToLocal(pt:Point, obj:DisplayObject) : Point {
						return null;
				}
				
				public static function Render() : * {
				}
				
				public static function UpdateFrame() : void {
				}
				
				public static function Update(obj:DisplayObject) : void {
				}
				
				public static function UpdateAll(aobj:DisplayObject = null) : void {
				}
				
				public static function UpdateToDisplay(aobj:DisplayObject = null, withchildren:Boolean = false) : void {
				}
				
				public static function GotoFrame(obj:MovieClip, aframe:*, aregenbmpnow:Boolean = true) : void {
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
				
				public static function SetMaskedMov(maskmov:DisplayObject, maskedmov:DisplayObject, alphamask:Boolean = false, movingmask:Boolean = false) : void {
				}
				
				public static function CreateClone(aclonedmov:DisplayObject, atargetmov:DisplayObjectContainer) : MovieClip {
						return null;
				}
				
				public static function RemoveMask(maskmov:DisplayObject) : void {
				}
				
				public static function SetFocus(obj:DisplayObject) : void {
				}
				
				public static function SetBitmapScale(amov:DisplayObject, ascale:Number) : void {
				}
				
				public static function EnableInput(amov:DisplayObject, aenable:Boolean) : void {
				}
				
				public static function Prepare(aobj:DisplayObject) : * {
				}
				
				public static function CollectStats(obj:DisplayObject = null) : Object {
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
				
				public static function AddStageEventListener(name:String, callback:Function) : Function {
						return null;
				}
				
				public static function RemoveStageEventListener(name:String, callback:Function) : void {
				}
				
				public static function HandleMouseDown(event:Object, excluedobjs:Array = null) : void {
				}
				
				public static function HandleMouseUp(event:Object, excluedobjs:Array = null) : void {
				}
				
				public static function HandleMouseMove(event:Object, excluedobjs:Array = null) : void {
				}
				
				public static function DispatchGlobalEvent(name:String, event:Event = null) : void {
				}
				
				public static function GetMousePos(aobj:DisplayObject = null) : Point {
						return null;
				}
		}
}

