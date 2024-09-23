package uibase {
		import com.greensock.easing.*;
		import flash.display.*;
		import flash.filters.DropShadowFilter;
		import flash.text.TextField;
		import syscode.*;
		
		public class LegoButton extends MovieClip {
				public static var validhandlers:Array = ["click","mousemove","mousedown","mouseup","mouseover","mouseout"];
				
				public var CAPTION:TextField;
				
				public var ICON:LegoIconset;
				
				public var btnenabled:Boolean = true;
				
				private var eventhandlers:Object;
				
				public var icon:MovieClip;
				
				public var caption:TextField;
				
				private var ox:Number;
				
				private var oy:Number;
				
				private var ow:Number;
				
				private var oh:Number;
				
				public function LegoButton() {
						this.eventhandlers = {};
						super();
						this.ox = x;
						this.oy = y;
						this.ow = width;
						this.oh = height;
						this.icon = MovieClip(getChildByName("ICON"));
						this.caption = TextField(getChildByName("CAPTION"));
						gotoAndStop(1);
						if(this.icon) {
								this.icon.gotoAndStop(1);
						}
						if(this.icon) {
								this.icon.visible = false;
						}
						if(this.caption) {
								this.caption.visible = false;
						}
						Imitation.AddEventMouseOver(this,this.OnRollOver);
						Imitation.AddEventMouseOut(this,this.OnRollOut);
						Imitation.AddEventMouseDown(this,this.OnMouseDown);
						Imitation.AddEventMouseUp(this,this.OnMouseUp);
						Imitation.AddEventClick(this,this.OnMouseClick);
				}
				
				public function AddEventClick(param1:Function, param2:Object = null) : void {
						this.SetHandler("click",param1,param2);
				}
				
				private function OnMouseClick(param1:*) : void {
						if(!this.btnenabled) {
								return;
						}
						this.HandleEvent("click",param1);
				}
				
				private function OnMouseDown(param1:*) : void {
						if(!this.btnenabled) {
								return;
						}
						gotoAndStop("OVER");
						width = this.ow - 2;
						height = this.oh - 2;
						x += 1;
						y += 1;
						filters = [new DropShadowFilter(2,45,0,0.8,2,2,1,1,true)];
						Imitation.SetBitmapScale(this,1.5);
						Imitation.FreeBitmapAll(this);
						Sounds.PlayEffect("Click",0.04);
				}
				
				private function OnMouseUp(param1:*) : void {
						if(!this.btnenabled) {
								return;
						}
						gotoAndStop("DEFAULT");
						filters = null;
						width = this.ow;
						height = this.oh;
						x = this.ox;
						y = this.oy;
						Imitation.SetBitmapScale(this,1);
						Imitation.FreeBitmapAll(this);
				}
				
				private function OnRollOver(param1:*) : void {
						if(!this.btnenabled) {
								return;
						}
						gotoAndStop("OVER");
						Imitation.FreeBitmapAll(this);
				}
				
				private function OnRollOut(param1:*) : void {
						if(!this.btnenabled) {
								return;
						}
						gotoAndStop("DEFAULT");
						filters = null;
						width = this.ow;
						height = this.oh;
						x = this.ox;
						y = this.oy;
						Imitation.FreeBitmapAll(this);
				}
				
				private function HandleEvent(param1:String, param2:Object) : Boolean {
						var _loc3_:Object = this.eventhandlers[param1];
						if(!_loc3_) {
								return false;
						}
						param2.params = _loc3_.params;
						if(_loc3_.func) {
								_loc3_.func.apply(null,[param2]);
								return true;
						}
						return false;
				}
				
				public function SetHandler(param1:String, param2:Function, param3:Object = null) : * {
						var _loc6_:String = null;
						var _loc4_:String = param1.toLocaleLowerCase();
						if(validhandlers.indexOf(_loc4_) < 0) {
								throw new Error("Invalid button event type: " + _loc4_);
						}
						var _loc5_:Object = {
								"func":param2,
								"params":{}
						};
						if(param3) {
								for(_loc6_ in param3) {
										_loc5_.params[_loc6_] = param3[_loc6_];
								}
						}
						this.eventhandlers[param1] = _loc5_;
						if(param2 == null) {
								delete this.eventhandlers[param1];
						}
				}
				
				public function SetLang(param1:String) : void {
						this.SetCaption(Lang.Get(param1));
				}
				
				public function SetLangAndClick(param1:String, param2:Function, param3:Object = null) : void {
						this.SetCaption(Lang.Get(param1));
						this.AddEventClick(param2,param3);
				}
				
				public function SetEnabled(param1:Boolean) : void {
						var _loc2_:* = this.btnenabled != param1;
						this.btnenabled = param1;
						mouseEnabled = param1;
						if(this.btnenabled) {
								gotoAndStop("DEFAULT");
						} else {
								gotoAndStop("DISABLED");
						}
						if(_loc2_) {
								Imitation.FreeBitmapAll(this);
						}
				}
				
				public function SetIcon(param1:String = "") : void {
						if(!this.icon) {
								return;
						}
						if(param1 == "") {
								return;
						}
						this.icon.visible = true;
						if(this.caption) {
								this.caption.visible = false;
						}
						if(this.MovieClipHasLabel(this.icon,param1)) {
								this.icon.gotoAndStop(param1);
						} else {
								this.icon.gotoAndStop("NO_ICON");
						}
						Imitation.FreeBitmapAll(this);
				}
				
				public function SetCaption(param1:String = "") : void {
						if(!this.caption) {
								return;
						}
						if(param1 == "") {
								return;
						}
						if(this.icon) {
								this.icon.visible = false;
						}
						this.caption.visible = true;
						Util.SetText(this.caption,param1);
						Imitation.FreeBitmapAll(this);
				}
				
				private function MovieClipHasLabel(param1:MovieClip, param2:String) : Boolean {
						var _loc6_:FrameLabel = null;
						var _loc3_:Array = param1.currentLabels;
						var _loc4_:Boolean = false;
						var _loc5_:uint = 0;
						while(_loc5_ < _loc3_.length) {
								_loc6_ = _loc3_[_loc5_];
								if(_loc6_.name == param2) {
										_loc4_ = true;
										break;
								}
								_loc5_++;
						}
						return _loc4_;
				}
		}
}

