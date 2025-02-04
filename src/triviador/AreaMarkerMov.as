package triviador {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import flash.display.*;
		import flash.events.*;
		import flash.filters.*;
		import flash.geom.Point;
		import flash.text.*;
		import syscode.*;
		import triviador.gfx.CastleMov;
		
		[Embed(source="/modules/triviador_assets.swf", symbol="symbol625")]
		public class AreaMarkerMov extends MovieClip {
				public var CASTLE:CastleMov;
				
				public var CVALUE:MovieClip;
				
				public var DISC:MovieClip;
				
				public var DUST:MovieClip;
				
				public var FORTRESS:MovieClip;
				
				public var FORTRESSBACK:MovieClip;
				
				public var GROUND:MovieClip;
				
				public var SHADOW:MovieClip;
				
				public var SOLDIER:MovieClip;
				
				public var id:int;
				
				public var value:int;
				
				public var player:int;
				
				public var skin:int;
				
				public var towers:int;
				
				public var glowtween:TweenMax;
				
				public var glowvalue:int;
				
				public var placeholder:Boolean;
				
				public var target:Boolean;
				
				public var grayed:Boolean;
				
				public var soldierColor:String;
				
				public var defaultpos:Point;
				
				public var shadowdefaultpos:Point;
				
				public var castlevel:int;
				
				public function AreaMarkerMov() {
						super();
						this.id = Util.IdFromStringEnd(this.name);
						this.value = 0;
						this.player = 0;
						this.towers = 0;
						this.placeholder = false;
						this.target = false;
						this.grayed = false;
						this.skin = 0;
						this.castlevel = 1;
						Util.StopAllChildrenMov(this);
				}
				
				public function Disc(_pnum:int, _value:int, _showvalue:Boolean = false) : void {
						this.Setup(_pnum,_value);
						for(var i:int = this.numChildren - 1; i >= 0; this.getChildAt(i).visible = false,i--) {
						}
						this.DISC.gotoAndStop(_pnum == 0 ? 4 : _pnum * 2);
						if(this.DISC.FLAGANIM) {
								this.DISC.FLAGANIM.gotoAndStop(1);
						}
						this.DISC.visible = true;
						this.CVALUE.visible = _showvalue;
						this.alpha = 1;
						this.placeholder = true;
						this.target = false;
						this.player = _pnum;
						this.value = _value;
				}
				
				public function InitDefaultPos() : void {
						this.defaultpos = new Point(this.x,this.y);
						this.shadowdefaultpos = new Point(this.SHADOW.x,this.SHADOW.y);
				}
				
				public function MoveDefaultPos() : void {
						if(Boolean(this.defaultpos) && Boolean(this.shadowdefaultpos)) {
								this.x = this.defaultpos.x;
								this.y = this.defaultpos.y;
								this.SHADOW.x = this.shadowdefaultpos.x;
								this.SHADOW.y = this.shadowdefaultpos.y;
						}
				}
				
				public function Setup(pnum:int, val:int, tow:int = 3) : * {
						var values:* = undefined;
						var colors:Array = [0,15990784,45056,1802433];
						var old:Object = {};
						old.skin = this.skin;
						old.player = this.player;
						old.value = this.value;
						old.towers = this.towers;
						this.skin = !!Game.players[pnum] ? int(Game.players[pnum].soldier) : 5;
						if(pnum == 0) {
								this.DISC.gotoAndStop(4);
								this.SOLDIER.SKIN.visible = false;
								this.SOLDIER.ADJUST.visible = true;
								this.SOLDIER.ADJUST.Setup(this.skin,4);
								this.CASTLE.Setup(1,1,3);
						} else {
								if(parent == Map.markerlayer && Map.shieldsmc && Boolean(Map.shieldsmc["S" + this.id]) && Map.shieldsmc.contains(Map.shieldsmc["S" + this.id])) {
										Map.shieldsmc.removeChild(Map.shieldsmc["S" + this.id]);
								}
								if(tow != this.towers || this.towers > 0) {
										this.castlevel = Game.players[pnum].castlelevel;
										if(Game.players[pnum].xplevel >= 3 && this.castlevel < 1) {
												this.castlevel = 1;
										}
								}
								this.SOLDIER.ADJUST.visible = this.grayed;
								if(this.grayed) {
										this.SOLDIER.ADJUST.Setup(this.skin,4);
								}
								this.SOLDIER.SKIN.visible = !this.grayed;
								this.SOLDIER.SKIN.Setup(this.skin,pnum);
								this.SOLDIER.SKIN.filters = [new DropShadowFilter(0,45,0,1,3,3,10,1),new GlowFilter(16777215,1,2,2,15,1),new GlowFilter(colors[pnum],0.5,3,3,20,1),new DropShadowFilter(5,45,0,1,0,0,0.5,1)];
								this.DISC.gotoAndStop((pnum - 1) * 2 + (val == 1000 ? 2 : 1));
								this.CASTLE.Setup(this.castlevel,pnum,tow);
						}
						this.HideMagicWingsAnim();
						this.CASTLE.visible = val == 1000 && pnum > 0;
						this.SOLDIER.visible = pnum > 0 && !this.CASTLE.visible;
						this.GROUND.visible = this.CASTLE.visible;
						this.DUST.visible = false;
						this.GROUND.visible = false;
						if(val == 1000 && tow < this.towers) {
								this.cacheAsBitmap = false;
								this.DUST.visible = true;
								this.DUST.alpha = (4 - tow) / 2;
								TweenMax.fromTo(this.DUST,this.DUST.totalFrames / 30,{"frameLabel":"BEGIN"},{
										"visible":false,
										"frameLabel":"END",
										"ease":Linear.easeNone
								});
						} else if(!TweenMax.isTweening(this.DUST)) {
								this.DUST.visible = false;
								this.DUST.stop();
						}
						this.FORTRESS.visible = false;
						this.FORTRESSBACK.visible = false;
						this.FORTRESS.scaleX = this.FORTRESS.scaleY = val == 1000 ? 0.65 : 0.55;
						this.FORTRESSBACK.scaleX = this.FORTRESSBACK.scaleY = val == 1000 ? 0.65 : 0.55;
						if(val == 0) {
								this.CVALUE.gotoAndStop(1);
								this.CVALUE.visible = false;
						} else {
								values = {
										1000:1,
										400:2,
										300:3,
										200:4
								};
								this.CVALUE.gotoAndStop((pnum - 1) * 4 + values[val]);
								this.CVALUE.visible = true;
						}
						this.DISC.visible = false;
						this.SHADOW.visible = false;
						this.alpha = 1;
						this.placeholder = false;
						this.target = false;
						this.player = pnum;
						this.value = val;
						this.towers = tow;
						this.buttonMode = false;
						this.useHandCursor = false;
						Imitation.SetBitmapScale(this,1.5);
						if(old.skin != this.skin || old.player != this.player || old.value != this.value || old.towers != this.towers) {
								Imitation.FreeBitmapAll(this);
						}
				}
				
				public function ShowTargetAnim(atarget:Boolean = true) : * {
						var f:Number = NaN;
						var s:MovieClip = null;
						this.cacheAsBitmap = false;
						this.target = atarget;
						this.alpha = 1;
						this.DISC.visible = true;
						this.DISC.gotoAndStop(9);
						this.visible = true;
						if(Boolean(this.DISC) && Boolean(this.DISC.SELECTOR)) {
								if(!TweenMax.isTweening(this.DISC.SELECTOR)) {
										f = this.player + (atarget ? 0 : (this.player == Game.iam ? 10 : 5));
										this.DISC.SELECTOR.gotoAndStop(1);
										Imitation.GotoFrame(this.DISC.SELECTOR.OBJ,f);
										s = this.DISC.SELECTOR.OBJ.SHAPE;
										if(s) {
												s.scaleX = f >= 5 && this.CASTLE.visible ? 1.4 : 1;
												s.scaleY = s.scaleX;
										}
										if(atarget || Map.selectedarea == this.id) {
												TweenMax.fromTo(this.DISC.SELECTOR,1,{"frame":1},{
														"frame":this.DISC.SELECTOR.totalFrames,
														"ease":Linear.easeNone,
														"repeat":-1
												});
										} else {
												TweenMax.killTweensOf(this.DISC.SELECTOR);
										}
								}
						}
				}
				
				public function HideTargetAnim(_discvisible:Boolean = false) : void {
						if(Boolean(this.DISC) && Boolean(this.DISC.SELECTOR)) {
								TweenMax.killTweensOf(this.DISC.SELECTOR);
						}
						this.target = false;
						this.alpha = 1;
						this.DISC.visible = this.DISC.currentFrame < 7 && !this.CASTLE.visible && !this.SOLDIER.visible ? _discvisible : false;
				}
				
				public function PlayMagicWingsAnim() : void {
						this.cacheAsBitmap = false;
						var mw:MovieClip = this.SOLDIER.MAGIC_WINGS;
						if(mw) {
								mw.CHEMTRAIL.gotoAndStop(1);
								Imitation.CollectChildrenAll(this);
								Imitation.GotoFrame(mw.WING_LEFT,1);
								Imitation.GotoFrame(mw.WING_LEFT.SHAPE,this.player);
								Imitation.GotoFrame(mw.WING_RIGHT,1);
								Imitation.GotoFrame(mw.WING_RIGHT.SHAPE,this.player);
								mw.visible = true;
								TweenMax.allFromTo([mw.WING_LEFT,mw.WING_RIGHT],0.25,{"frame":1},{
										"frame":16,
										"ease":Linear.easeNone,
										"repeat":-1
								});
								TweenMax.fromTo(mw.CHEMTRAIL,0.25,{"frame":1},{
										"frame":16,
										"ease":Linear.easeNone,
										"repeat":-1
								});
						}
				}
				
				public function HideMagicWingsAnim() : void {
						var mw:MovieClip = this.SOLDIER.MAGIC_WINGS;
						if(mw) {
								TweenMax.killTweensOf(mw);
								Util.StopAllChildrenMov(mw);
								mw.visible = false;
						}
				}
		}
}

