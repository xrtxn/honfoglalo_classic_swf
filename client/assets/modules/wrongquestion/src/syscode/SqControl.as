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
				
				public function SqControl(aname:String) {
						super();
				}
				
				public function DoStep(e:TimerEvent) : void {
				}
				
				public function Clear() : void {
				}
				
				public function Start(ainfo:String = "") : void {
				}
				
				public function Stop(auto:Boolean = false) : void {
				}
				
				public function NextAnim() : void {
				}
				
				public function AnimFinished(aanimid:String) : * {
				}
				
				public function AddObj(aname:String) : Object {
						return null;
				}
				
				public function InsertObjForNext(aname:String) : Object {
						return null;
				}
				
				public function InsertDelayForNext(asecs:Number) : Object {
						return null;
				}
				
				public function AddDelay(asecs:Number) : Object {
						return null;
				}
				
				public function PlayEffect(name:String, start:Number = 0) : * {
				}
				
				public function PlayVoice(name:String, start:Number = 0) : * {
				}
				
				public function PlayMusic(name:String) : * {
				}
				
				public function PlayEffectWaitForEnd(name:String, start:Number = 0) : * {
				}
				
				public function PlayVoiceWaitForEnd(name:String, start:Number = 0) : * {
				}
				
				public function StopSound(name:String) : * {
				}
				
				public function AddCallBack(aobj:*, afuncname:*, aparams:Array = null) : * {
				}
				
				public function AddCallBack2(afunc:Function, aparams:Array = null, athis:* = null) : * {
				}
				
				public function AddCallBack3(funcName:String, thisObject:*, funcObject:Function, ... args) : Object {
						return null;
				}
				
				public function AddFadeIn(aobj:DisplayObject, asecs:Number, afedein:Boolean) : * {
				}
				
				public function SetProps(aobj:DisplayObject, vars:Object, animid:String = "SETPROPS") : void {
				}
				
				public function AddTweenMaxTo(aobj:DisplayObject, asecs:Number, avars:Object, animid:String = "TWEENMAX") : void {
				}
				
				public function AddTweenMaxFrom(aobj:DisplayObject, asecs:Number, avars:Object, animid:String = "TWEENMAX") : void {
				}
				
				public function AddTweenMaxFromTo(aobj:DisplayObject, asecs:Number, fromvars:Object, tovars:Object, animid:String = "TWEENMAX") : void {
				}
				
				public function AddTweenAllMaxFromTo(aobjs:Array, asecs:Number, fromvars:Object, tovars:Object, animid:String = "TWEENMAX") : void {
				}
				
				public function AddTweenMax(aobj:DisplayObject, asecs:Number, avars:Object, animid:String = "TWEENMAX") : void {
				}
				
				public function AddTweenObj(aanimid:*) : * {
				}
				
				public function AddDelayedTweenObj(aanimid:*) : * {
				}
				
				public function AddTimelineAnim(aobj:MovieClip, frameFrom:Object, frameTo:Object, startChildren:Boolean = true, animid:String = "TIMELINE") : Object {
						return null;
				}
		}
}

