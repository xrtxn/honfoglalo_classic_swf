package com.greensock {
		import com.greensock.core.*;
		import com.greensock.plugins.*;
		import flash.display.*;
		import flash.events.*;
		import flash.utils.*;
		
		public class TweenLite extends TweenCore {
				public static var onPluginEvent:Function;
				
				public static var overwriteManager:Object;
				
				public static var rootFrame:Number;
				
				public static var rootTimeline:SimpleTimeline;
				
				public static var rootFramesTimeline:SimpleTimeline;
				
				public static const version:Number = 11.63;
				
				public static var plugins:Object = {};
				
				public static var fastEaseLookup:Dictionary = new Dictionary(false);
				
				public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
				
				public static var defaultEase:Function = TweenLite.easeOut;
				
				public static var masterList:Dictionary = new Dictionary(false);
				
				private static var _shape:Shape = new Shape();
				
				protected static var _reservedProps:Object = {
						"ease":1,
						"delay":1,
						"overwrite":1,
						"onComplete":1,
						"onCompleteParams":1,
						"useFrames":1,
						"runBackwards":1,
						"startAt":1,
						"onUpdate":1,
						"onUpdateParams":1,
						"onStart":1,
						"onStartParams":1,
						"onInit":1,
						"onInitParams":1,
						"onReverseComplete":1,
						"onReverseCompleteParams":1,
						"onRepeat":1,
						"onRepeatParams":1,
						"proxiedEase":1,
						"easeParams":1,
						"yoyo":1,
						"onCompleteListener":1,
						"onUpdateListener":1,
						"onStartListener":1,
						"onReverseCompleteListener":1,
						"onRepeatListener":1,
						"orientToBezier":1,
						"timeScale":1,
						"immediateRender":1,
						"repeat":1,
						"repeatDelay":1,
						"timeline":1,
						"data":1,
						"paused":1
				};
				
				public var target:Object;
				
				public var propTweenLookup:Object;
				
				public var ratio:Number = 0;
				
				public var cachedPT1:PropTween;
				
				protected var _ease:Function;
				
				protected var _overwrite:int;
				
				protected var _overwrittenProps:Object;
				
				protected var _hasPlugins:Boolean;
				
				protected var _notifyPluginsOfEnabled:Boolean;
				
				public function TweenLite(target:Object, duration:Number, vars:Object) {
						super(duration,vars);
						if(target == null) {
								throw new Error("Cannot tween a null object.");
						}
						this.target = target;
						if(this.target is TweenCore && this.vars.timeScale) {
								this.cachedTimeScale = 1;
						}
						propTweenLookup = {};
						_ease = defaultEase;
						_overwrite = Number(vars.overwrite) <= -1 || !overwriteManager.enabled && vars.overwrite > 1 ? overwriteManager.mode : int(vars.overwrite);
						var a:Array = masterList[target];
						if(!a) {
								masterList[target] = [this];
						} else if(_overwrite == 1) {
								for each(var sibling in a) {
										if(!sibling.gc) {
												sibling.setEnabled(false,false);
										}
								}
								masterList[target] = [this];
						} else {
								a[a.length] = this;
						}
						if(this.active || this.vars.immediateRender) {
								renderTime(0,false,true);
						}
				}
				
				public static function initClass() : void {
						rootFrame = 0;
						rootTimeline = new SimpleTimeline(null);
						rootFramesTimeline = new SimpleTimeline(null);
						rootTimeline.cachedStartTime = getTimer() * 0.001;
						rootFramesTimeline.cachedStartTime = rootFrame;
						rootTimeline.autoRemoveChildren = true;
						rootFramesTimeline.autoRemoveChildren = true;
						_shape.addEventListener(Event.ENTER_FRAME,updateAll,false,0,true);
						if(overwriteManager == null) {
								overwriteManager = {
										"mode":1,
										"enabled":false
								};
						}
				}
				
				public static function to(target:Object, duration:Number, vars:Object) : TweenLite {
						return new TweenLite(target,duration,vars);
				}
				
				public static function from(target:Object, duration:Number, vars:Object) : TweenLite {
						if(vars.isGSVars) {
								vars = vars.vars;
						}
						vars.runBackwards = true;
						if(!("immediateRender" in vars)) {
								vars.immediateRender = true;
						}
						return new TweenLite(target,duration,vars);
				}
				
				public static function delayedCall(delay:Number, onComplete:Function, onCompleteParams:Array = null, useFrames:Boolean = false) : TweenLite {
						return new TweenLite(onComplete,0,{
								"delay":delay,
								"onComplete":onComplete,
								"onCompleteParams":onCompleteParams,
								"immediateRender":false,
								"useFrames":useFrames,
								"overwrite":0
						});
				}
				
				protected static function updateAll(e:Event = null) : void {
						rootTimeline.renderTime((getTimer() * 0.001 - rootTimeline.cachedStartTime) * rootTimeline.cachedTimeScale,false,false);
						rootFrame += 1;
						rootFramesTimeline.renderTime((rootFrame - rootFramesTimeline.cachedStartTime) * rootFramesTimeline.cachedTimeScale,false,false);
						if(!(rootFrame % 60)) {
								var ml:Dictionary = masterList;
								for(var tgt in ml) {
										var a:Array = ml[tgt];
										var i:int = int(a.length);
										while(--i > -1) {
												if(TweenLite(a[i]).gc) {
														a.splice(i,1);
												}
										}
										if(a.length == 0) {
												delete ml[tgt];
										}
								}
						}
				}
				
				public static function killTweensOf(target:Object, complete:Boolean = false, vars:Object = null) : void {
						if(target in masterList) {
								var a:Array = masterList[target];
								var i:int = int(a.length);
								while(--i > -1) {
										var tween:TweenLite = a[i];
										if(!tween.gc) {
												if(complete) {
														tween.complete(false,false);
												}
												if(vars != null) {
														tween.killVars(vars);
												}
												if(vars == null || tween.cachedPT1 == null && tween.initted) {
														tween.setEnabled(false,false);
												}
										}
								}
								if(vars == null) {
										delete masterList[target];
								}
						}
				}
				
				protected static function easeOut(t:Number, b:Number, c:Number, d:Number) : Number {
						return 1 - (t = 1 - t / d) * t;
				}
				
				protected function init() : void {
						if(this.vars.onInit) {
								this.vars.onInit.apply(null,this.vars.onInitParams);
						}
						if(typeof this.vars.ease == "function") {
								_ease = this.vars.ease;
						}
						if(this.vars.easeParams) {
								this.vars.proxiedEase = _ease;
								_ease = easeProxy;
						}
						this.cachedPT1 = null;
						this.propTweenLookup = {};
						for(var p in this.vars) {
								if(!(p in _reservedProps && !(p == "timeScale" && this.target is TweenCore))) {
										var plugin:*;
										if(p in plugins && (plugin = new (plugins[p] as Class)()).onInitTween(this.target,this.vars[p],this)) {
												this.cachedPT1 = new PropTween(plugin,"changeFactor",0,1,plugin.overwriteProps.length == 1 ? plugin.overwriteProps[0] : "_MULTIPLE_",true,this.cachedPT1);
												if(this.cachedPT1.name == "_MULTIPLE_") {
														var i:int = int(plugin.overwriteProps.length);
														while(--i > -1) {
																this.propTweenLookup[plugin.overwriteProps[i]] = this.cachedPT1;
														}
												} else {
														this.propTweenLookup[this.cachedPT1.name] = this.cachedPT1;
												}
												if(plugin.priority) {
														this.cachedPT1.priority = plugin.priority;
														var prioritize:Boolean = true;
												}
												if(plugin.onDisable || plugin.onEnable) {
														_notifyPluginsOfEnabled = true;
												}
												_hasPlugins = true;
										} else {
												this.cachedPT1 = new PropTween(this.target,p,Number(this.target[p]),typeof this.vars[p] == "number" ? Number(this.vars[p]) - this.target[p] : Number(this.vars[p]),p,false,this.cachedPT1);
												this.propTweenLookup[p] = this.cachedPT1;
										}
								}
						}
						if(prioritize) {
								onPluginEvent("onInitAllProps",this);
						}
						if(this.vars.runBackwards) {
								var pt:PropTween = this.cachedPT1;
								while(pt) {
										pt.start += pt.change;
										pt.change = -pt.change;
										pt = pt.nextNode;
								}
						}
						_hasUpdate = Boolean(this.vars.onUpdate != null);
						if(_overwrittenProps) {
								killVars(_overwrittenProps);
								if(this.cachedPT1 == null) {
										this.setEnabled(false,false);
								}
						}
						var siblings:Array = masterList[this.target];
						if(_overwrite > 1 && this.cachedPT1 && siblings && siblings.length > 1) {
								if(overwriteManager.manageOverwrites(this,this.propTweenLookup,siblings,_overwrite)) {
										init();
								}
						}
						this.initted = true;
				}
				
				override public function renderTime(time:Number, suppressEvents:Boolean = false, force:Boolean = false) : void {
						var prevTime:Number = this.cachedTime;
						if(time >= this.cachedDuration) {
								this.cachedTotalTime = this.cachedTime = this.cachedDuration;
								this.ratio = 1;
								var isComplete:Boolean = true;
								if(this.cachedDuration == 0) {
										if((time == 0 || _rawPrevTime < 0) && _rawPrevTime != time) {
												force = true;
										}
										_rawPrevTime = time;
								}
						} else if(time <= 0) {
								this.cachedTotalTime = this.cachedTime = this.ratio = 0;
								if(time < 0) {
										this.active = false;
										if(this.cachedDuration == 0) {
												if(_rawPrevTime >= 0) {
														force = true;
														isComplete = true;
												}
												_rawPrevTime = time;
										}
								}
								if(this.cachedReversed && prevTime != 0) {
										isComplete = true;
								}
						} else {
								this.cachedTotalTime = this.cachedTime = time;
								this.ratio = _ease(time,0,1,this.cachedDuration);
						}
						if(this.cachedTime == prevTime && !force) {
								return;
						}
						if(!this.initted) {
								init();
								if(!isComplete && this.cachedTime) {
										this.ratio = _ease(this.cachedTime,0,1,this.cachedDuration);
								}
						}
						if(!this.active && !this.cachedPaused) {
								this.active = true;
						}
						if(prevTime == 0 && this.vars.onStart && (this.cachedTime != 0 || this.cachedDuration == 0) && !suppressEvents) {
								this.vars.onStart.apply(null,this.vars.onStartParams);
						}
						var pt:PropTween = this.cachedPT1;
						while(pt) {
								pt.target[pt.property] = pt.start + this.ratio * pt.change;
								pt = pt.nextNode;
						}
						if(_hasUpdate && !suppressEvents) {
								this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
						}
						if(isComplete && !this.gc) {
								if(_hasPlugins && this.cachedPT1) {
										onPluginEvent("onComplete",this);
								}
								complete(true,suppressEvents);
						}
				}
				
				public function killVars(vars:Object, permanent:Boolean = true) : Boolean {
						if(_overwrittenProps == null) {
								_overwrittenProps = {};
						}
						for(var p in vars) {
								if(p in propTweenLookup) {
										var pt:PropTween = propTweenLookup[p];
										if(pt.isPlugin && pt.name == "_MULTIPLE_") {
												pt.target.killProps(vars);
												if(pt.target.overwriteProps.length == 0) {
														pt.name = "";
												}
												if(p != pt.target.propName || pt.name == "") {
														delete propTweenLookup[p];
												}
										}
										if(pt.name != "_MULTIPLE_") {
												if(pt.nextNode) {
														pt.nextNode.prevNode = pt.prevNode;
												}
												if(pt.prevNode) {
														pt.prevNode.nextNode = pt.nextNode;
												} else if(this.cachedPT1 == pt) {
														this.cachedPT1 = pt.nextNode;
												}
												if(pt.isPlugin && pt.target.onDisable) {
														pt.target.onDisable();
														if(pt.target.activeDisable) {
																var changed:Boolean = true;
														}
												}
												delete propTweenLookup[p];
										}
								}
								if(permanent && vars != _overwrittenProps) {
										_overwrittenProps[p] = 1;
								}
						}
						return changed;
				}
				
				override public function invalidate() : void {
						if(_notifyPluginsOfEnabled && this.cachedPT1) {
								onPluginEvent("onDisable",this);
						}
						this.cachedPT1 = null;
						_overwrittenProps = null;
						_hasUpdate = this.initted = this.active = _notifyPluginsOfEnabled = false;
						this.propTweenLookup = {};
				}
				
				protected function easeProxy(t:Number, b:Number, c:Number, d:Number) : Number {
						return this.vars.proxiedEase.apply(null,arguments.concat(this.vars.easeParams));
				}
		}
}
