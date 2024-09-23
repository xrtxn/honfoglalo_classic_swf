package syscode {
		import flash.display.DisplayObject;
		import flash.display.MovieClip;
		import flash.events.TimerEvent;
		import flash.utils.Timer;
		
		public class SqControl extends MovieClip {
				public var timer:Timer;
				
				public var running:Boolean;
				
				public var anims:Array;
				
				public var curanim:*;
				
				public var sqname:String;
				
				public var OnFinished:Function = null;
				
				public var increment:int;
				
				public var info:String;
				
				public var starttime:Number;
				
				public var squence_info:Array;
				
				public var time:Number;
				
				public var showtraces:Boolean = false;
				
				public function SqControl(param1:String) {
						super();
				}
				
				public function DoStep(param1:TimerEvent) : void {
				}
				
				public function Clear() : void {
				}
				
				public function Start(param1:String = "") : void {
				}
				
				public function Stop(param1:Boolean = false) : void {
				}
				
				public function NextAnim() : void {
				}
				
				public function AnimFinished(param1:String) : * {
				}
				
				public function AddObj(param1:String) : Object {
						return null;
				}
				
				public function InsertObjForNext(param1:String) : Object {
						return null;
				}
				
				public function InsertDelayForNext(param1:Number) : Object {
						return null;
				}
				
				public function AddDelay(param1:Number) : Object {
						return null;
				}
				
				public function PlayEffect(param1:String, param2:Number = 0) : * {
				}
				
				public function PlayVoice(param1:String, param2:Number = 0) : * {
				}
				
				public function PlayMusic(param1:String) : * {
				}
				
				public function PlayEffectWaitForEnd(param1:String, param2:Number = 0) : * {
				}
				
				public function PlayVoiceWaitForEnd(param1:String, param2:Number = 0) : * {
				}
				
				public function StopSound(param1:String) : * {
				}
				
				public function AddCallBack(param1:*, param2:*, param3:Array = null) : * {
				}
				
				public function AddCallBack2(param1:Function, param2:Array = null, param3:* = null) : * {
				}
				
				public function AddCallBack3(param1:String, param2:*, param3:Function, ... rest) : Object {
						return null;
				}
				
				public function AddFadeIn(param1:DisplayObject, param2:Number, param3:Boolean) : * {
				}
				
				public function SetProps(param1:DisplayObject, param2:Object, param3:String = "SETPROPS") : void {
				}
				
				public function AddTweenMaxTo(param1:DisplayObject, param2:Number, param3:Object, param4:String = "TWEENMAX") : void {
				}
				
				public function AddTweenMaxFrom(param1:DisplayObject, param2:Number, param3:Object, param4:String = "TWEENMAX") : void {
				}
				
				public function AddTweenMaxFromTo(param1:DisplayObject, param2:Number, param3:Object, param4:Object, param5:String = "TWEENMAX") : void {
				}
				
				public function AddTweenAllMaxFromTo(param1:Array, param2:Number, param3:Object, param4:Object, param5:String = "TWEENMAX") : void {
				}
				
				public function AddTweenMax(param1:DisplayObject, param2:Number, param3:Object, param4:String = "TWEENMAX") : void {
				}
				
				public function AddTweenObj(param1:*) : * {
				}
				
				public function AddDelayedTweenObj(param1:*) : * {
				}
				
				public function AddTimelineAnim(param1:MovieClip, param2:Object, param3:Object, param4:Boolean = true, param5:String = "TIMELINE") : Object {
						return null;
				}
		}
}

