package com.greensock {
		import com.greensock.core.*;
		import com.greensock.events.TweenEvent;
		import flash.events.*;
		
		public class TimelineMax extends TimelineLite implements IEventDispatcher {
				public static const version:Number = 1.64;
				
				protected var _repeat:int;
				
				protected var _repeatDelay:Number;
				
				protected var _cyclesComplete:int;
				
				protected var _dispatcher:EventDispatcher;
				
				protected var _hasUpdateListener:Boolean;
				
				public var yoyo:Boolean;
				
				public function TimelineMax(vars:Object = null) {
						super(vars);
						this._repeat = !!this.vars.repeat ? int(Number(this.vars.repeat)) : 0;
						this._repeatDelay = !!this.vars.repeatDelay ? Number(this.vars.repeatDelay) : 0;
						this._cyclesComplete = 0;
						this.yoyo = Boolean(this.vars.yoyo == true);
						this.cacheIsDirty = true;
						if(this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null || this.vars.onRepeatListener != null || this.vars.onReverseCompleteListener != null) {
								this.initDispatcher();
						}
				}
				
				private static function onInitTweenTo(tween:TweenLite, timeline:TimelineMax, fromTime:Number) : void {
						timeline.paused = true;
						if(!isNaN(fromTime)) {
								timeline.currentTime = fromTime;
						}
						if(tween.vars.currentTime != timeline.currentTime) {
								tween.duration = Math.abs(Number(tween.vars.currentTime) - timeline.currentTime) / timeline.cachedTimeScale;
						}
				}
				
				private static function easeNone(t:Number, b:Number, c:Number, d:Number) : Number {
						return t / d;
				}
				
				public function addCallback(callback:Function, timeOrLabel:*, params:Array = null) : TweenLite {
						var cb:TweenLite = new TweenLite(callback,0,{
								"onComplete":callback,
								"onCompleteParams":params,
								"overwrite":0,
								"immediateRender":false
						});
						insert(cb,timeOrLabel);
						return cb;
				}
				
				public function removeCallback(callback:Function, timeOrLabel:* = null) : Boolean {
						var a:Array = null;
						var success:Boolean = false;
						var i:int = 0;
						if(timeOrLabel == null) {
								return killTweensOf(callback,false);
						}
						if(typeof timeOrLabel == "string") {
								if(!(timeOrLabel in _labels)) {
										return false;
								}
								timeOrLabel = _labels[timeOrLabel];
						}
						a = getTweensOf(callback,false);
						i = int(a.length);
						while(--i > -1) {
								if(a[i].cachedStartTime == timeOrLabel) {
										remove(a[i] as TweenCore);
										success = true;
								}
						}
						return success;
				}
				
				public function tweenTo(timeOrLabel:*, vars:Object = null) : TweenLite {
						var p:String = null;
						var tl:TweenLite = null;
						var varsCopy:Object = {
								"ease":easeNone,
								"overwrite":2,
								"useFrames":this.useFrames,
								"immediateRender":false
						};
						for(p in vars) {
								varsCopy[p] = vars[p];
						}
						varsCopy.onInit = onInitTweenTo;
						varsCopy.onInitParams = [null,this,NaN];
						varsCopy.currentTime = parseTimeOrLabel(timeOrLabel);
						tl = new TweenLite(this,Math.abs(Number(varsCopy.currentTime) - this.cachedTime) / this.cachedTimeScale || 0.001,varsCopy);
						tl.vars.onInitParams[0] = tl;
						return tl;
				}
				
				public function tweenFromTo(fromTimeOrLabel:*, toTimeOrLabel:*, vars:Object = null) : TweenLite {
						var tl:TweenLite = this.tweenTo(toTimeOrLabel,vars);
						tl.vars.onInitParams[2] = parseTimeOrLabel(fromTimeOrLabel);
						tl.duration = Math.abs(Number(tl.vars.currentTime) - tl.vars.onInitParams[2]) / this.cachedTimeScale;
						return tl;
				}
				
				override public function renderTime(time:Number, suppressEvents:Boolean = false, force:Boolean = false) : void {
						var tween:TweenCore = null;
						var isComplete:* = false;
						var rendered:Boolean = false;
						var repeated:Boolean = false;
						var next:TweenCore = null;
						var dur:Number = NaN;
						var cycleDuration:Number = NaN;
						var prevCycles:int = 0;
						var forward:Boolean = false;
						var prevForward:* = false;
						var wrap:Boolean = false;
						if(this.gc) {
								this.setEnabled(true,false);
						} else if(!this.active && !this.cachedPaused) {
								this.active = true;
						}
						var totalDur:Number = this.cacheIsDirty ? this.totalDuration : this.cachedTotalDuration;
						var prevTime:Number = this.cachedTime;
						var prevStart:Number = this.cachedStartTime;
						var prevTimeScale:Number = this.cachedTimeScale;
						var prevPaused:Boolean = this.cachedPaused;
						if(time >= totalDur) {
								if(_rawPrevTime <= totalDur && _rawPrevTime != time) {
										if(!this.cachedReversed && this.yoyo && this._repeat % 2 != 0) {
												forceChildrenToBeginning(0,suppressEvents);
												this.cachedTime = 0;
										} else {
												forceChildrenToEnd(this.cachedDuration,suppressEvents);
												this.cachedTime = this.cachedDuration;
										}
										this.cachedTotalTime = totalDur;
										isComplete = !this.hasPausedChild();
										rendered = true;
										if(this.cachedDuration == 0 && isComplete && (time == 0 || _rawPrevTime < 0)) {
												force = true;
										}
								}
						} else if(time <= 0) {
								if(time < 0) {
										this.active = false;
										if(this.cachedDuration == 0 && _rawPrevTime >= 0) {
												force = true;
												isComplete = true;
										}
								} else if(time == 0 && !this.initted) {
										force = true;
								}
								if(_rawPrevTime >= 0 && _rawPrevTime != time) {
										this.cachedTotalTime = 0;
										forceChildrenToBeginning(0,suppressEvents);
										this.cachedTime = 0;
										rendered = true;
										if(this.cachedReversed) {
												isComplete = true;
										}
								}
						} else {
								this.cachedTotalTime = this.cachedTime = time;
						}
						_rawPrevTime = time;
						if(this._repeat != 0) {
								cycleDuration = this.cachedDuration + this._repeatDelay;
								prevCycles = this._cyclesComplete;
								if(isComplete) {
										if(this.yoyo && Boolean(this._repeat % 2)) {
												this.cachedTime = 0;
										}
								} else if(time > 0) {
										this._cyclesComplete = this.cachedTotalTime / cycleDuration >> 0;
										if(this._cyclesComplete == this.cachedTotalTime / cycleDuration) {
												--this._cyclesComplete;
										}
										if(prevCycles != this._cyclesComplete) {
												repeated = true;
										}
										this.cachedTime = (this.cachedTotalTime / cycleDuration - this._cyclesComplete) * cycleDuration;
										if(this.yoyo && Boolean(this._cyclesComplete % 2)) {
												this.cachedTime = this.cachedDuration - this.cachedTime;
										} else if(this.cachedTime >= this.cachedDuration) {
												this.cachedTime = this.cachedDuration;
										}
										if(this.cachedTime < 0) {
												this.cachedTime = 0;
										}
								} else {
										this._cyclesComplete = 0;
								}
								if(repeated && !isComplete && (this.cachedTime != prevTime || force)) {
										forward = Boolean(!this.yoyo || this._cyclesComplete % 2 == 0);
										prevForward = Boolean(!this.yoyo || prevCycles % 2 == 0);
										wrap = Boolean(forward == prevForward);
										if(prevCycles > this._cyclesComplete) {
												prevForward = !prevForward;
										}
										if(prevForward) {
												prevTime = forceChildrenToEnd(this.cachedDuration,suppressEvents);
												if(wrap) {
														prevTime = forceChildrenToBeginning(0,true);
												}
										} else {
												prevTime = forceChildrenToBeginning(0,suppressEvents);
												if(wrap) {
														prevTime = forceChildrenToEnd(this.cachedDuration,true);
												}
										}
										rendered = false;
								}
						}
						if(this.cachedTime == prevTime && !force) {
								return;
						}
						if(!this.initted) {
								this.initted = true;
						}
						if(prevTime == 0 && this.cachedTotalTime != 0 && !suppressEvents) {
								if(this.vars.onStart) {
										this.vars.onStart.apply(null,this.vars.onStartParams);
								}
								if(this._dispatcher) {
										this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
								}
						}
						if(!rendered) {
								if(this.cachedTime - prevTime > 0) {
										tween = _firstChild;
										while(tween) {
												next = tween.nextNode;
												if(this.cachedPaused && !prevPaused) {
														break;
												}
												if(tween.active || !tween.cachedPaused && tween.cachedStartTime <= this.cachedTime && !tween.gc) {
														if(!tween.cachedReversed) {
																tween.renderTime((this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
														} else {
																dur = tween.cacheIsDirty ? tween.totalDuration : tween.cachedTotalDuration;
																tween.renderTime(dur - (this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
														}
												}
												tween = next;
										}
								} else {
										tween = _lastChild;
										while(tween) {
												next = tween.prevNode;
												if(this.cachedPaused && !prevPaused) {
														break;
												}
												if(tween.active || !tween.cachedPaused && tween.cachedStartTime <= prevTime && !tween.gc) {
														if(!tween.cachedReversed) {
																tween.renderTime((this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
														} else {
																dur = tween.cacheIsDirty ? tween.totalDuration : tween.cachedTotalDuration;
																tween.renderTime(dur - (this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
														}
												}
												tween = next;
										}
								}
						}
						if(_hasUpdate && !suppressEvents) {
								this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
						}
						if(this._hasUpdateListener && !suppressEvents) {
								this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
						}
						if(isComplete && (prevStart == this.cachedStartTime || prevTimeScale != this.cachedTimeScale) && (totalDur >= this.totalDuration || this.cachedTime == 0)) {
								this.complete(true,suppressEvents);
						} else if(repeated && !suppressEvents) {
								if(this.vars.onRepeat) {
										this.vars.onRepeat.apply(null,this.vars.onRepeatParams);
								}
								if(this._dispatcher) {
										this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REPEAT));
								}
						}
				}
				
				override public function complete(skipRender:Boolean = false, suppressEvents:Boolean = false) : void {
						super.complete(skipRender,suppressEvents);
						if(Boolean(this._dispatcher) && !suppressEvents) {
								if(this.cachedReversed && this.cachedTotalTime == 0 && this.cachedDuration != 0) {
										this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REVERSE_COMPLETE));
								} else {
										this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
								}
						}
				}
				
				public function getActive(nested:Boolean = true, tweens:Boolean = true, timelines:Boolean = false) : Array {
						var i:int = 0;
						var a:Array = [];
						var all:Array = getChildren(nested,tweens,timelines);
						var l:int = int(all.length);
						var cnt:int = 0;
						for(i = 0; i < l; i += 1) {
								if(TweenCore(all[i]).active) {
										var _loc9_:*;
										a[_loc9_ = cnt++] = all[i];
								}
						}
						return a;
				}
				
				override public function invalidate() : void {
						this._repeat = !!this.vars.repeat ? int(Number(this.vars.repeat)) : 0;
						this._repeatDelay = !!this.vars.repeatDelay ? Number(this.vars.repeatDelay) : 0;
						this.yoyo = Boolean(this.vars.yoyo == true);
						if(this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null || this.vars.onRepeatListener != null || this.vars.onReverseCompleteListener != null) {
								this.initDispatcher();
						}
						setDirtyCache(true);
						super.invalidate();
				}
				
				public function getLabelAfter(time:Number = NaN) : String {
						if(!time && time != 0) {
								time = this.cachedTime;
						}
						var labels:Array = this.getLabelsArray();
						var l:int = int(labels.length);
						for(var i:int = 0; i < l; i += 1) {
								if(labels[i].time > time) {
										return labels[i].name;
								}
						}
						return null;
				}
				
				public function getLabelBefore(time:Number = NaN) : String {
						if(!time && time != 0) {
								time = this.cachedTime;
						}
						var labels:Array = this.getLabelsArray();
						var i:int = int(labels.length);
						while(--i > -1) {
								if(labels[i].time < time) {
										return labels[i].name;
								}
						}
						return null;
				}
				
				protected function getLabelsArray() : Array {
						var p:String = null;
						var a:Array = [];
						for(p in _labels) {
								a[a.length] = {
										"time":_labels[p],
										"name":p
								};
						}
						a.sortOn("time",Array.NUMERIC);
						return a;
				}
				
				protected function initDispatcher() : void {
						if(this._dispatcher == null) {
								this._dispatcher = new EventDispatcher(this);
						}
						if(this.vars.onStartListener is Function) {
								this._dispatcher.addEventListener(TweenEvent.START,this.vars.onStartListener,false,0,true);
						}
						if(this.vars.onUpdateListener is Function) {
								this._dispatcher.addEventListener(TweenEvent.UPDATE,this.vars.onUpdateListener,false,0,true);
								this._hasUpdateListener = true;
						}
						if(this.vars.onCompleteListener is Function) {
								this._dispatcher.addEventListener(TweenEvent.COMPLETE,this.vars.onCompleteListener,false,0,true);
						}
						if(this.vars.onRepeatListener is Function) {
								this._dispatcher.addEventListener(TweenEvent.REPEAT,this.vars.onRepeatListener,false,0,true);
						}
						if(this.vars.onReverseCompleteListener is Function) {
								this._dispatcher.addEventListener(TweenEvent.REVERSE_COMPLETE,this.vars.onReverseCompleteListener,false,0,true);
						}
				}
				
				public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void {
						if(this._dispatcher == null) {
								this.initDispatcher();
						}
						if(type == TweenEvent.UPDATE) {
								this._hasUpdateListener = true;
						}
						this._dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
				}
				
				public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void {
						if(this._dispatcher != null) {
								this._dispatcher.removeEventListener(type,listener,useCapture);
						}
				}
				
				public function hasEventListener(type:String) : Boolean {
						return this._dispatcher == null ? false : this._dispatcher.hasEventListener(type);
				}
				
				public function willTrigger(type:String) : Boolean {
						return this._dispatcher == null ? false : this._dispatcher.willTrigger(type);
				}
				
				public function dispatchEvent(e:Event) : Boolean {
						return this._dispatcher == null ? false : this._dispatcher.dispatchEvent(e);
				}
				
				public function get totalProgress() : Number {
						return this.cachedTotalTime / this.totalDuration;
				}
				
				public function set totalProgress(n:Number) : void {
						setTotalTime(this.totalDuration * n,false);
				}
				
				override public function get totalDuration() : Number {
						var temp:Number = NaN;
						if(this.cacheIsDirty) {
								temp = super.totalDuration;
								this.cachedTotalDuration = this._repeat == -1 ? 999999999999 : this.cachedDuration * (this._repeat + 1) + this._repeatDelay * this._repeat;
						}
						return this.cachedTotalDuration;
				}
				
				override public function set currentTime(n:Number) : void {
						if(this._cyclesComplete == 0) {
								setTotalTime(n,false);
						} else if(this.yoyo && this._cyclesComplete % 2 == 1) {
								setTotalTime(this.duration - n + this._cyclesComplete * (this.cachedDuration + this._repeatDelay),false);
						} else {
								setTotalTime(n + this._cyclesComplete * (this.duration + this._repeatDelay),false);
						}
				}
				
				public function get repeat() : int {
						return this._repeat;
				}
				
				public function set repeat(n:int) : void {
						this._repeat = n;
						setDirtyCache(true);
				}
				
				public function get repeatDelay() : Number {
						return this._repeatDelay;
				}
				
				public function set repeatDelay(n:Number) : void {
						this._repeatDelay = n;
						setDirtyCache(true);
				}
				
				public function get currentLabel() : String {
						return this.getLabelBefore(this.cachedTime + 1e-8);
				}
		}
}
