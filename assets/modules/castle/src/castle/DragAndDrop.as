package castle {
		import com.greensock.TweenMax;
		import fl.motion.easing.Linear;
		import flash.display.MovieClip;
		import flash.events.Event;
		import flash.events.MouseEvent;
		import flash.geom.Point;
		import syscode.*;
		
		public class DragAndDrop {
				public var mc:MovieClip = null;
				
				public var target:MovieClip = null;
				
				public var targets:Array;
				
				public var drag_scale:* = 1.5;
				
				public var phase:Number = 0;
				
				public var ondrop:Function = null;
				
				public var oncancel:Function = null;
				
				public var onupdate:Function = null;
				
				public var dragging:* = false;
				
				public var active:* = false;
				
				private var mousePos:Point;
				
				private var mouse_move_func:Function;
				
				public var mx:Number;
				
				public var my:Number;
				
				private var hot:Boolean;
				
				public function DragAndDrop(mc:MovieClip, ondrop:Function = null, oncancel:Function = null, onupdate:Function = null) {
						this.targets = [];
						super();
						this.ondrop = ondrop;
						this.oncancel = oncancel;
						this.onupdate = onupdate;
						this.mc = mc;
						mc.visible = false;
				}
				
				public function AddTarget(obj:MovieClip) : * {
						this.targets.push(obj);
				}
				
				public function Drag(source:MovieClip) : * {
						this.Cancel();
						this.mc.visible = true;
						Util.AddEventListener(this.mc,Event.ENTER_FRAME,this.OnEnterFrame);
						this.mouse_move_func = Imitation.AddStageEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
						Imitation.AddStageEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
						this.dragging = true;
						this.active = true;
						this.mousePos = Imitation.GetMousePos(this.mc.parent);
						this.mx = this.mousePos.x;
						this.my = this.mousePos.y;
						this.OnEnterFrame(null);
				}
				
				public function DragBack(source:MovieClip) : * {
						this.Drag(source);
						TweenMax.killTweensOf(this);
						this.target = source;
						this.phase = 0.01;
						this.hot = true;
						this.OnEnterFrame(null);
				}
				
				private function OnEnterFrame(e:Event) : void {
						if(!this.mc) {
								return;
						}
						if(this.Distance({
								"x":this.mx,
								"y":this.my
						},this.mousePos) < 50) {
								this.mx = this.mousePos.x;
								this.my = this.mousePos.y;
						} else {
								this.mx = (this.mx * 2 + this.mousePos.x) / 3;
								this.my = (this.my * 2 + this.mousePos.y) / 3;
						}
						var s:Number = this.drag_scale;
						if(this.phase > 0) {
								if(!this.hot && !TweenMax.isTweening(this)) {
										TweenMax.to(this,0.2,{
												"phase":0,
												"ease":Linear,
												"onComplete":this.OnComplete
										});
								}
						}
						if(this.target) {
								this.mx = this.target.x * this.phase + this.mx * (1 - this.phase);
								this.my = this.target.y * this.phase + this.my * (1 - this.phase) - Math.sin(this.phase * Math.PI) * 30;
								s = this.target.scaleX * this.phase + this.drag_scale * (1 - this.phase);
						}
						this.mc.x = this.mx;
						this.mc.y = this.my;
						this.mc.scaleX = this.mc.scaleY = s;
						if(this.onupdate != null) {
								this.onupdate();
						}
				}
				
				private function OnComplete() : void {
						if(!this.dragging) {
								this.Drop();
						}
				}
				
				private function Distance(obj1:Object, obj2:Object) : * {
						var a:Number = obj1.x - obj2.x;
						var b:Number = obj1.y - obj2.y;
						return Math.sqrt(a * a + b * b);
				}
				
				private function OnMouseMove(e:MouseEvent) : void {
						var obj:* = undefined;
						if(e == null) {
								this.mousePos = new Point(this.target.x,this.target.y);
						} else {
								this.mousePos = this.mc.parent.globalToLocal(new Point(e.stageX,e.stageY));
						}
						this.hot = false;
						for each(obj in this.targets) {
								if(this.Distance(this.mousePos,obj) < 50) {
										if(this.target != obj || this.phase == 0) {
												TweenMax.killTweensOf(this);
												TweenMax.fromTo(this,0.2,{"phase":0.01},{
														"phase":1,
														"ease":Linear,
														"onComplete":this.OnComplete
												});
												this.phase = 0.01;
												this.target = obj;
										}
										this.hot = true;
								}
						}
				}
				
				private function OnMouseUp(e:MouseEvent) : void {
						if(this.target && this.phase > 0 && this.phase < 1 && !TweenMax.isTweening(this)) {
								TweenMax.fromTo(this,0.2,{"phase":0.01},{
										"phase":1,
										"ease":Linear,
										"onComplete":this.OnComplete
								});
						}
						this.dragging = false;
						if(this.phase == 0) {
								this.OnEnterFrame(null);
						}
						if(this.phase == 1) {
								this.Drop();
						} else if(this.phase == 0) {
								this.Cancel();
						}
				}
				
				public function Drop() : * {
						if(!this.mc) {
								return;
						}
						if(!this.active) {
								return;
						}
						Util.RemoveEventListener(this.mc,Event.ENTER_FRAME,this.OnEnterFrame);
						Imitation.RemoveStageEventListener(MouseEvent.MOUSE_MOVE,this.mouse_move_func);
						Imitation.RemoveStageEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
						this.mc.visible = false;
						if(this.phase > 0 && this.ondrop != null) {
								this.ondrop();
						}
						if(this.phase == 0 && this.oncancel != null) {
								this.oncancel();
						}
						this.target = null;
						this.phase = 0;
						this.active = false;
				}
				
				public function Cancel() : * {
						this.phase = 0;
						this.hot = false;
						this.Drop();
				}
				
				public function Remove() : * {
						this.Cancel();
						this.targets = [];
						delete global[this];
				}
		}
}

