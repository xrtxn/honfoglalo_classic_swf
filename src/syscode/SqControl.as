package syscode
{
    import com.greensock.TimelineMax;
    import com.greensock.TweenAlign;
    import com.greensock.TweenMax;
    import com.greensock.easing.Linear;
    import com.greensock.events.TweenEvent;

    import flash.display.*;
    import flash.events.TimerEvent;
    import flash.utils.*;

    public class SqControl extends MovieClip
    {
        public function SqControl(aname:String)
        {
            super();
            this.running = false;
            this.anims = [];
            this.curanim = undefined;
            this.sqname = aname;
            this.info = "";
            this.timer = new Timer(33.3);
            Util.AddEventListener(this.timer, TimerEvent.TIMER, this.DoStep);
            this.timer.reset();
            this.increment = 0;
            Util.Trace("SqControl created");
        }
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

        public function Clear():void
        {
            this.anims = [];
            this.curanim = undefined;
            this.running = false;
            this.timer.reset();
        }

        public function Start(ainfo:String = ""):void
        {
            if (this.running)
            {
                Util.Trace("CSqControl.Start(): already running !!!!");
                Util.Trace("Current anim: " + this.curanim.animid);
            }
            else
            {
                this.running = true;
                this.timer.start();
                this.starttime = new Date().getTime();
                this.squence_info = [];
                this.info = ainfo;
                this.NextAnim();
            }
        }

        public function Stop(auto:Boolean = false):void
        {
            this.anims = [];
            if (!this.running)
            {
                return;
            }
            this.running = false;
            this.curanim = undefined;
            this.timer.reset();
            var now:Number = Number(new Date().getTime());
            this.time = Math.round((now - this.starttime) / 10) / 100;
            if (typeof this.OnFinished == "function" && this.OnFinished != null)
            {
                this.OnFinished();
            }
        }

        public function NextAnim():void
        {
            var time:Number = NaN;
            var elapsed:Number = NaN;
            var date:Date = null;
            var ctime:String = null;
            var log:* = undefined;
            if (this.curanim !== undefined)
            {
                this.anims.splice(0, 1);
                time = Number(new Date().getTime());
                elapsed = Math.round((time - this.curanim.__starttime__) / 10) / 100;
                this.squence_info.push({
                            "id": this.curanim.animid,
                            "time": elapsed
                        });
            }
            if (this.anims.length > 0 && (this.anims.length > 1 || this.anims[0].animid != "DELAY"))
            {
                this.curanim = this.anims[0];
                this.curanim.__starttime__ = new Date().getTime();
                if (this.showtraces)
                {
                    date = new Date();
                    ctime = Util.FormatDateTime(date.getUTCFullYear(), date.getUTCMonth() + 1, date.getUTCDate(), date.getUTCHours(), date.getUTCMinutes(), date.getUTCSeconds());
                    Util.Trace("SqControl.NextAnim:" + this.curanim.animid + " at " + ctime + " with remaining:" + this.anims.length + " anims");
                }
                if (typeof this.curanim == "object" && typeof this.curanim.Start == "function")
                {
                    this.curanim.Start();
                }
                else
                {
                    log = "curanim is not an object";
                    if (typeof this.curanim == "object")
                    {
                        log = "curanim w/o Start function: \"" + Util.StringVal(this.curanim.animid);
                    }
                    this.NextAnim();
                }
            }
            else
            {
                this.Stop(true);
            }
        }

        public function AnimFinished(aanimid:String):*
        {
            if (this.curanim === undefined || this.curanim.animid == aanimid)
            {
                this.NextAnim();
            }
            else
            {
                Util.Trace("anim finished with wrong id: \"" + aanimid + "\" expected: \"" + this.curanim.animid + "\"");
            }
        }

        public function AddObj(aname:String):Object
        {
            var ao:* = new Object();
            ao.sqc = this;
            ao.animid = aname;
            ao.Next = function():*
            {
                this.sqc.NextAnim();
            };
            this.anims.push(ao);
            return ao;
        }

        public function InsertObjForNext(aname:String):Object
        {
            var ao:* = new Object();
            ao.sqc = this;
            ao.animid = aname;
            ao.Next = function():*
            {
                this.sqc.NextAnim();
            };
            if (this.curanim)
            {
                this.anims.splice(this.anims.indexOf(this.curanim) + 1, 0, ao);
            }
            else
            {
                this.anims.splice(0, 0, ao);
            }
            return ao;
        }

        public function InsertDelayForNext(asecs:Number):Object
        {
            var ao:* = undefined;
            if (Boolean(this.anims[0]) && this.anims[0].animid == "DELAY")
            {
                if (this.anims[0].delayms < 3000)
                {
                    this.anims[0].delayms += asecs * 1000;
                }
                return this.anims[0];
            }
            if (asecs == 0)
            {
                return null;
            }
            ao = this.InsertObjForNext("DELAY");
            ao.delayms = asecs * 1000;
            ao.Start = function():*
            {
                this.starttime = getTimer();
            };
            ao.Step = function():*
            {
                if (getTimer() >= this.starttime + this.delayms)
                {
                    this.sqc.AnimFinished("DELAY");
                    trace("delay ", this.delayms / 1000);
                }
            };
            return ao;
        }

        public function AddDelay(asecs:Number):Object
        {
            var ao:* = this.AddObj("DELAY");
            ao.delayms = asecs * 1000;
            ao.Start = function():*
            {
                this.starttime = getTimer();
            };
            ao.Step = function():*
            {
                if (getTimer() >= this.starttime + this.delayms)
                {
                    this.sqc.AnimFinished("DELAY");
                }
            };
            return ao;
        }

        public function PlayEffect(name:String, start:Number = 0):*
        {
            var ao:* = this.AddObj("gsqc.PlayEffect:" + name);
            ao.Start = function():*
            {
                Sounds.PlayEffect(name, start);
                this.Next();
            };
        }

        public function PlayVoice(name:String, start:Number = 0):*
        {
            var ao:* = this.AddObj("gsqc.PlayVoice:" + name);
            ao.Start = function():*
            {
                Sounds.PlayVoice(name, start);
                this.Next();
            };
        }

        public function PlayMusic(name:String):*
        {
            var ao:* = this.AddObj("gsqc.PlayMusic:" + name);
            ao.Start = function():*
            {
                Sounds.PlayMusic(name);
                this.Next();
            };
        }

        public function PlayEffectWaitForEnd(name:String, start:Number = 0):*
        {
            var ao:* = this.AddObj("gsqc.PlayEffectWaitForEnd:" + name);
            ao.Start = function():*
            {
                var upvalue:* = undefined;
                var SoundFinished:Function = null;
                SoundFinished = function():*
                {
                    upvalue.Next();
                };
                upvalue = this;
                Sounds.PlayEffect(name, start, SoundFinished);
            };
        }

        public function PlayVoiceWaitForEnd(name:String, start:Number = 0):*
        {
            var ao:* = this.AddObj("gsqc.PlayVoiceWaitForEnd:" + name);
            ao.Start = function():*
            {
                var upvalue:* = undefined;
                var SoundFinished:Function = null;
                SoundFinished = function():*
                {
                    upvalue.Next();
                };
                upvalue = this;
                Sounds.PlayVoice(name, start, SoundFinished);
            };
        }

        public function StopSound(name:String):*
        {
            var ao:* = this.AddObj("STOPSOUND");
            ao.Start = function():*
            {
                Sounds.StopAll(name);
                this.Next();
            };
        }

        public function AddCallBack(aobj:*, afuncname:*, aparams:Array = null):*
        {
            var ao:* = this.AddObj("CALLBACK");
            ao.obj = aobj;
            ao.funcname = afuncname;
            ao.params = aparams;
            ao.Start = function():*
            {
                this.obj[this.funcname](this.params);
                this.sqc.NextAnim();
            };
            return ao;
        }

        public function AddCallBack2(afunc:Function, aparams:Array = null, athis:* = null):*
        {
            var ao:* = this.AddObj("CALLBACK2");
            ao.func = afunc;
            ao.params = aparams;
            ao.self = athis;
            ao.Start = function():*
            {
                this.func.apply(this.self, this.params);
                this.Next();
            };
            return ao;
        }

        public function AddCallBack3(funcName:String, thisObject:*, funcObject:Function, ...args):Object
        {
            var ao:* = this.AddObj("CALLBACK3:" + funcName);
            ao.Start = function():*
            {
                funcObject.apply(thisObject, args);
                this.Next();
            };
            return ao;
        }

        public function AddFadeIn(aobj:DisplayObject, asecs:Number, afedein:Boolean):*
        {
            var ao:* = this.AddTweenObj("FADEIN");
            ao.obj = aobj;
            ao.secs = asecs;
            ao.fadein = afedein;
            ao.Start = function():*
            {
                var t:* = undefined;
                if (this.Init !== undefined)
                {
                    this.Init();
                }
                if (this.fadein)
                {
                    this.obj.alpha = 0;
                    t = TweenMax.fromTo(this.obj, this.secs, {
                                "alpha": 0,
                                "visible": true
                            }, {
                                "x": this.obj.x,
                                "y": this.obj.y,
                                "alpha": 1,
                                "visible": true,
                                "ease": Linear.easeNone,
                                "delay": 0.1
                            });
                }
                else
                {
                    this.obj.alpha = 1;
                    t = TweenMax.to(this.obj, this.secs, {
                                "ease": Linear.easeNone,
                                "alpha": 0
                            });
                }
                this.AddTween(t);
            };
            return ao;
        }

        public function SetProps(aobj:DisplayObject, vars:Object, animid:String = "SETPROPS"):void
        {
            var ao:* = this.AddObj(animid);
            ao.Start = function():*
            {
                var name:String = null;
                for (name in vars)
                {
                    aobj[name] = vars[name];
                }
                this.Next();
            };
        }

        public function AddTweenMaxTo(aobj:DisplayObject, asecs:Number, avars:Object, animid:String = "TWEENMAX"):void
        {
            var ao:* = this.AddTweenObj(animid);
            ao.tweenparams = {
                    "o": aobj,
                    "s": asecs,
                    "v": avars
                };
            ao.Start = function():*
            {
                this.AddTweenMaxTo(this.tweenparams.o, this.tweenparams.s, this.tweenparams.v);
            };
        }

        public function AddTweenMaxFrom(aobj:DisplayObject, asecs:Number, avars:Object, animid:String = "TWEENMAX"):void
        {
            var ao:* = this.AddTweenObj(animid);
            ao.tweenparams = {
                    "o": aobj,
                    "s": asecs,
                    "v": avars
                };
            ao.Start = function():*
            {
                this.AddTweenMaxFrom(this.tweenparams.o, this.tweenparams.s, this.tweenparams.v);
            };
        }

        public function AddTweenMaxFromTo(aobj:DisplayObject, asecs:Number, fromvars:Object, tovars:Object, animid:String = "TWEENMAX"):void
        {
            var ao:* = this.AddTweenObj(animid);
            ao.tweenparams = {
                    "o": aobj,
                    "s": asecs,
                    "f": fromvars,
                    "t": tovars
                };
            ao.Start = function():*
            {
                this.AddTweenMaxFromTo(this.tweenparams.o, this.tweenparams.s, this.tweenparams.f, this.tweenparams.t);
            };
        }

        public function AddTweenAllMaxFromTo(aobjs:Array, asecs:Number, fromvars:Object, tovars:Object, animid:String = "TWEENMAX"):void
        {
            var ao:* = this.AddTweenObj(animid);
            ao.tweenparams = {
                    "o": aobjs,
                    "s": asecs,
                    "f": fromvars,
                    "t": tovars
                };
            ao.Start = function():*
            {
                this.AddTweenAllMaxFromTo(this.tweenparams.o, this.tweenparams.s, this.tweenparams.f, this.tweenparams.t);
            };
        }

        public function AddTweenMax(aobj:DisplayObject, asecs:Number, avars:Object, animid:String = "TWEENMAX"):void
        {
            this.AddTweenMaxTo(aobj, asecs, avars, animid);
        }

        public function AddTweenObj(aanimid:*):*
        {
            var cao:* = undefined;
            cao = this.AddObj(aanimid);
            cao.tweens = new Array();
            cao.Start = function():*
            {
            };
            cao.InternalFinish = function():*
            {
                this.sqc.AnimFinished(this.animid);
            };
            cao.onMotionFinished = function(tobj:*):*
            {
                for (var i:* = 0; i < this.tweens.length; i++)
                {
                    if (this.tweens[i] == tobj)
                    {
                        this.tweens.splice(i, 1);
                        break;
                    }
                }
                if (this.tweens.length < 1)
                {
                    this.InternalFinish();
                }
            };
            cao.AddTween = function(tobj:TweenMax):TweenMax
            {
                Util.AddEventListener(tobj, TweenEvent.COMPLETE, function(e:TweenEvent):*
                    {
                        cao.onMotionFinished(tobj);
                        Util.RemoveEventListener(tobj, TweenEvent.COMPLETE, arguments.callee);
                    });
                this.tweens.push(tobj);
                return tobj;
            };
            cao.AddTweenMaxTo = function(aobj:DisplayObject, asecs:Number, avars:Object):TweenMax
            {
                var tobj:* = TweenMax.to(aobj, asecs, avars);
                this.AddTween(tobj);
                return tobj;
            };
            cao.AddTweenMaxFrom = function(aobj:DisplayObject, asecs:Number, avars:Object):TweenMax
            {
                var tobj:* = TweenMax.from(aobj, asecs, avars);
                this.AddTween(tobj);
                return tobj;
            };
            cao.AddTweenMaxFromTo = function(aobj:DisplayObject, asecs:Number, fromvars:Object, tovars:Object):TweenMax
            {
                var tobj:* = TweenMax.fromTo(aobj, asecs, fromvars, tovars);
                this.AddTween(tobj);
                return tobj;
            };
            cao.AddTweenAllMaxFromTo = function(aobjs:Array, asecs:Number, fromvars:Object, tovars:Object):TweenMax
            {
                var tobj:* = TweenMax.allFromTo(aobjs, asecs, fromvars, tovars);
                this.AddTween(tobj);
                return tobj;
            };
            cao.AddTweenMax = function(aobj:DisplayObject, asecs:Number, avars:Object):TweenMax
            {
                return this.AddTweenMaxTo(aobj, asecs, avars);
            };
            return cao;
        }

        public function AddDelayedTweenObj(aanimid:*):*
        {
            var cao:* = undefined;
            cao = this.AddObj(aanimid);
            cao.delays = new Array();
            cao.tweens = new Array();
            cao.Start = function():*
            {
                var o:* = undefined;
                var tobj:* = undefined;
                this.Prepare();
                for (var i:* = 0; i < this.delays.length; i++)
                {
                    o = this.delays[i];
                    if (o.type == 3)
                    {
                        tobj = TweenMax.fromTo(o.obj, o.secs, o.fvars, o.tvars);
                        this.AddTween(tobj);
                    }
                    else if (o.type == 2)
                    {
                        tobj = TweenMax.from(o.obj, o.secs, o.vars);
                        this.AddTween(tobj);
                    }
                    else
                    {
                        tobj = TweenMax.to(o.obj, o.secs, o.vars);
                        this.AddTween(tobj);
                    }
                }
            };
            cao.Prepare = function():*
            {
            };
            cao.InternalFinish = function():*
            {
                this.sqc.AnimFinished(this.animid);
            };
            cao.onMotionFinished = function(tobj:*):*
            {
                for (var i:* = 0; i < this.tweens.length; i++)
                {
                    if (this.tweens[i] == tobj)
                    {
                        this.tweens.splice(i, 1);
                    }
                }
                if (this.tweens.length < 1)
                {
                    this.InternalFinish();
                }
            };
            cao.AddTween = function(tobj:TweenMax):TweenMax
            {
                Util.AddEventListener(tobj, TweenEvent.COMPLETE, function(e:TweenEvent):*
                    {
                        Util.RemoveEventListener(tobj, TweenEvent.COMPLETE, arguments.callee);
                        cao.onMotionFinished(tobj);
                    });
                this.tweens.push(tobj);
                return tobj;
            };
            cao.AddTweenMaxTo = function(aobj:DisplayObject, asecs:Number, avars:Object):void
            {
                this.delays.push({
                            "type": 1,
                            "obj": aobj,
                            "secs": asecs,
                            "vars": avars
                        });
            };
            cao.AddTweenMaxFrom = function(aobj:DisplayObject, asecs:Number, avars:Object):void
            {
                this.delays.push({
                            "type": 2,
                            "obj": aobj,
                            "secs": asecs,
                            "vars": avars
                        });
            };
            cao.AddTweenMaxFromTo = function(aobj:DisplayObject, asecs:Number, fvars:Object, tvars:Object):void
            {
                this.delays.push({
                            "type": 3,
                            "obj": aobj,
                            "secs": asecs,
                            "fvars": fvars,
                            "tvars": tvars
                        });
            };
            cao.AddTweenMax = function(aobj:DisplayObject, asecs:Number, avars:Object):void
            {
                this.AddTweenMaxTo(aobj, asecs, avars);
            };
            return cao;
        }

        public function AddTimelineAnim(aobj:MovieClip, frameFrom:Object, frameTo:Object, startChildren:Boolean = true, animid:String = "TIMELINE"):Object
        {
            var ao:* = this.AddObj(animid);
            ao.obj = aobj;
            ao.from = frameFrom;
            ao.to = frameTo;
            ao.Start = function():*
            {
                var self:Object = null;
                var end:uint = 0;
                var HandleOnReady:Function = null;
                HandleOnReady = function():void
                {
                    if (startChildren)
                    {
                        Util.StopAllChildrenMov(self.obj);
                    }
                    else
                    {
                        self.obj.stop();
                    }
                    self.obj.addFrameScript(end - 1, null, false, false);
                    self.Next();
                };
                self = this;
                var start:uint = uint(Util.GetFrameNum(this.obj, this.from) || 1);
                end = uint(Util.GetFrameNum(this.obj, this.to) || uint(this.obj.totalFrames));
                this.obj.gotoAndStop(start);
                this.obj.addFrameScript(end - 1, HandleOnReady);
                if (startChildren)
                {
                    Util.StartAllChildrenMov(this.obj);
                }
                else
                {
                    this.obj.play();
                }
            };
            return ao;
        }

        private function AddTimelineTween(aobj:MovieClip, frameFrom:Object, frameTo:Object, animid:String = "TIMELINETWEEN"):Object
        {
            var ao:* = this.AddObj(animid);
            ao.obj = aobj;
            ao.from = frameFrom;
            ao.to = frameTo;
            ao.Start = function():*
            {
                var self:Object = null;
                var HandleOnReady:Function = null;
                HandleOnReady = function():void
                {
                    self.Next();
                };
                self = this;
                var start:uint = uint(Util.GetFrameNum(this.obj, this.from) || 1);
                var end:uint = uint(Util.GetFrameNum(this.obj, this.to) || uint(this.obj.totalFrames));
                new TimelineMax({
                            "useFrames": false,
                            "align": TweenAlign.SEQUENCE,
                            "onComplete": HandleOnReady,
                            "tweens": [TweenMax.fromTo(this.obj, (end - start) / Config.framerate, {"frame": start}, {
                                        "frame": end,
                                        "ease": Linear.easeIn
                                    })]
                        });
            };
            return ao;
        }

        public function DoStep(e:TimerEvent):void
        {
            if (this.running)
            {
                if (this.curanim !== undefined)
                {
                    if (typeof this.curanim.Step == "function")
                    {
                        this.curanim.Step();
                    }
                }
                else
                {
                    this.NextAnim();
                }
            }
        }
    }
}
