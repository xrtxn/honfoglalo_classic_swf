package clan {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import flash.geom.Point;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol776")]
		public class ErrorPanel extends MovieClip {
				public static var active:Boolean = false;
				
				public static var PANEL_POS:Point = new Point();
				
				public var BACK:MovieClip;
				
				public var PANEL:MovieClip;
				
				public var msg:String;
				
				public var callback:Function;
				
				public function ErrorPanel() {
						super();
						ErrorPanel.PANEL_POS = new Point(this.PANEL.x,this.PANEL.y);
				}
				
				public function Show(_msg:String, _callback:Function = null, _anim:Boolean = true) : void {
						this.msg = _msg;
						this.callback = _callback;
						Util.StopAllChildrenMov(this);
						this.visible = true;
						ErrorPanel.active = true;
						this.Draw();
						if(_anim) {
								this.PlayShowAnim();
						}
				}
				
				private function PlayShowAnim() : void {
						var w:MovieClip = null;
						w = this.PANEL;
						w.alpha = 0;
						w.x = -w.width;
						TweenMax.delayedCall(0.001,function():* {
								TweenMax.to(w,0.5,{
										"alpha":1,
										"x":ErrorPanel.PANEL_POS.x,
										"y":ErrorPanel.PANEL_POS.y,
										"overwrite":"none",
										"ease":Strong.easeOut
								});
						});
				}
				
				private function PlayHideAnim(e:Object = null) : void {
						var w:MovieClip = this.PANEL;
						w.BTN_OK.SetEnabled(false);
						TweenMax.to(w,0.3,{
								"alpha":0,
								"x":-w.width,
								"overwrite":"none",
								"onComplete":this.Hide
						});
				}
				
				public function Draw() : void {
						Imitation.CollectChildrenAll(this);
						var w:MovieClip = this.PANEL.GRAPHICS;
						Util.SetText(w.MSG.FIELD,this.msg);
						this.PANEL.BTN_OK.SetCaption(Lang.Get("ok"));
						Imitation.Combine(w,true);
						this.Activate();
				}
				
				private function Activate() : void {
						Imitation.AddButtonStop(this.BACK);
						var w:MovieClip = this.PANEL;
						w.BTN_OK.AddEventClick(this.PlayHideAnim);
						w.BTN_OK.SetEnabled(true);
				}
				
				private function InActivate() : void {
						Imitation.DeleteEventGroup(this);
				}
				
				public function Hide() : void {
						TweenMax.killTweensOf(this);
						Util.StopAllChildrenMov(this);
						this.visible = false;
						ErrorPanel.active = false;
						Clan.HideErrorPanel();
						if(this.callback != null) {
								this.callback();
						}
				}
		}
}

