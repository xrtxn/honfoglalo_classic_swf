package com.greensock {
		import flash.display.DisplayObjectContainer;
		
		public class TweenMax {
				public static const version:Number = 11.641;
				
				public static var killTweensOf:Function = null;
				
				public var yoyo:Boolean;
				
				public function TweenMax(target:Object, duration:Number, vars:Object) {
						super();
				}
				
				public static function to(target:Object, duration:Number, vars:Object) : TweenMax {
						return null;
				}
				
				public static function from(target:Object, duration:Number, vars:Object) : TweenMax {
						return null;
				}
				
				public static function fromTo(target:Object, duration:Number, fromVars:Object, toVars:Object) : TweenMax {
						return null;
				}
				
				public static function allTo(targets:Array, duration:Number, vars:Object, stagger:Number = 0, onCompleteAll:Function = null, onCompleteAllParams:Array = null) : Array {
						return null;
				}
				
				public static function allFrom(targets:Array, duration:Number, vars:Object, stagger:Number = 0, onCompleteAll:Function = null, onCompleteAllParams:Array = null) : Array {
						return null;
				}
				
				public static function allFromTo(targets:Array, duration:Number, fromVars:Object, toVars:Object, stagger:Number = 0, onCompleteAll:Function = null, onCompleteAllParams:Array = null) : Array {
						return null;
				}
				
				public static function delayedCall(delay:Number, onComplete:Function, onCompleteParams:Array = null, useFrames:Boolean = false) : TweenMax {
						return null;
				}
				
				public static function getTweensOf(target:Object) : Array {
						return null;
				}
				
				public static function isTweening(target:Object) : Boolean {
						return false;
				}
				
				public static function getAllTweens() : Array {
						return null;
				}
				
				public static function killAll(complete:Boolean = false, tweens:Boolean = true, delayedCalls:Boolean = true) : void {
				}
				
				public static function killChildTweensOf(parent:DisplayObjectContainer, complete:Boolean = false) : void {
				}
				
				public static function pauseAll(tweens:Boolean = true, delayedCalls:Boolean = true) : void {
				}
				
				public static function resumeAll(tweens:Boolean = true, delayedCalls:Boolean = true) : void {
				}
				
				public static function get globalTimeScale() : Number {
						return 0;
				}
				
				public static function set globalTimeScale(n:Number) : void {
				}
				
				public function invalidate() : void {
				}
				
				public function updateTo(vars:Object, resetDuration:Boolean = false) : void {
				}
				
				public function setDestination(property:String, value:*, adjustStartValues:Boolean = true) : void {
				}
				
				public function killProperties(names:Array) : void {
				}
				
				public function renderTime(time:Number, suppressEvents:Boolean = false, force:Boolean = false) : void {
				}
				
				public function get currentProgress() : Number {
						return 0;
				}
				
				public function set currentProgress(n:Number) : void {
				}
				
				public function get totalProgress() : Number {
						return 0;
				}
				
				public function set totalProgress(n:Number) : void {
				}
				
				public function set currentTime(n:Number) : void {
				}
				
				public function get totalDuration() : Number {
						return 0;
				}
				
				public function set totalDuration(n:Number) : void {
				}
				
				public function get timeScale() : Number {
						return 0;
				}
				
				public function set timeScale(n:Number) : void {
				}
				
				public function get repeat() : int {
						return 0;
				}
				
				public function set repeat(n:int) : void {
				}
				
				public function get repeatDelay() : Number {
						return 0;
				}
				
				public function set repeatDelay(n:Number) : void {
				}
		}
}

