package library {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import flash.geom.Point;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol390")]
		public class WarningPanel extends MovieClip {
				public static var active:Boolean = false;
				
				public static var ERROR_POS:Point = new Point();
				
				public static var WARNING_POS:Point = new Point();
				
				public static const ERROR:uint = 1;
				
				public static const WARNING:uint = 2;
				
				public var BACK:MovieClip;
				
				public var ERROR_PANEL:MovieClip;
				
				public var WARNING_PANEL:MovieClip;
				
				public var msg:String;
				
				public var callback:Function;
				
				private var currentpage:uint = 0;
				
				public function WarningPanel() {
						super();
						WarningPanel.ERROR_POS = new Point(this.ERROR_PANEL.x,this.ERROR_PANEL.y);
						WarningPanel.WARNING_POS = new Point(this.WARNING_PANEL.x,this.WARNING_PANEL.y);
						this.Hide();
				}
				
				public function Show(_msg:String, _keyframe:uint, _callback:Function = null, _anim:Boolean = true) : void {
						this.msg = _msg;
						this.currentpage = _keyframe;
						this.callback = _callback;
						Util.StopAllChildrenMov(this);
						this.visible = true;
						WarningPanel.active = true;
						this.Draw(_keyframe);
						if(_anim) {
								this.PlayShowAnim();
						}
				}
				
				private function PlayShowAnim() : void {
						var w:MovieClip = null;
						var pos:Point = null;
						w = this.currentpage == WarningPanel.ERROR ? this.ERROR_PANEL : this.WARNING_PANEL;
						pos = this.currentpage == WarningPanel.ERROR ? WarningPanel.ERROR_POS : WarningPanel.WARNING_POS;
						w.alpha = 0;
						w.x = -w.width;
						TweenMax.delayedCall(0.001,function():* {
								TweenMax.to(w,0.5,{
										"alpha":1,
										"x":pos.x,
										"y":pos.y,
										"overwrite":"none",
										"ease":Strong.easeOut
								});
						});
				}
				
				private function PlayHideAnim(e:Object = null) : void {
						var w:MovieClip = this.currentpage == WarningPanel.ERROR ? this.ERROR_PANEL : this.WARNING_PANEL;
						w.BTN_OK.SetEnabled(false);
						TweenMax.to(w,0.3,{
								"alpha":0,
								"x":-w.width,
								"overwrite":"none",
								"onComplete":this.Hide
						});
				}
				
				public function Draw(_keyframe:uint = 1) : void {
						Imitation.CollectChildrenAll(this);
						this.WARNING_PANEL.visible = this.ERROR_PANEL.visible = false;
						if(_keyframe == WarningPanel.ERROR) {
								this.DrawError();
						} else {
								this.DrawWarning();
						}
						this.Activate();
				}
				
				private function DrawError() : void {
						this.ERROR_PANEL.visible = true;
						this.ERROR_PANEL.BTN_OK.SetCaption(Lang.Get("ok"));
						var w:MovieClip = this.ERROR_PANEL.GRAPHICS;
						Util.SetText(w.MSG,this.msg);
						w.MSG.y = 30 + (183 - w.MSG.textHeight) / 2;
						TweenMax.delayedCall(0.6,Imitation.Combine,[w,true]);
				}
				
				private function DrawWarning() : void {
						this.WARNING_PANEL.visible = true;
						this.WARNING_PANEL.BTN_OK.SetCaption(Lang.Get("ok"));
						var w:MovieClip = this.WARNING_PANEL.CONTENT;
						w.NFO.TITLE.autoSize = "center";
						w.NFO.TITLE.htmlText = Lang.get("question_sending_info_title");
						if(Config.rtl) {
								Util.SetText(w.NFO.TITLE,Lang.Get("question_sending_info_title"));
						}
						w.NFO.TXT.autoSize = "center";
						w.NFO.TXT.htmlText = this.msg;
						if(Config.rtl) {
								Util.SetText(w.NFO.TXT,this.msg);
						}
						if(w.NFO.height > 256) {
								w.MASK.visible = w.SB.visible = true;
								w.SB.Set(w.NFO.height,252,0);
								w.SB.OnScroll = this.OnScrolling;
								Imitation.CollectChildrenAll(Library.mc);
								Imitation.SetMaskedMov(w.MASK,w.NFO);
								Imitation.AddEventMask(w.MASK,w.NFO);
								w.SB.SetScrollRect(w.NFO);
								w.SB.isaligned = false;
								w.SB.buttonstep = 25;
						} else {
								w.MASK.visible = w.SB.visible = false;
						}
				}
				
				private function OnScrolling(_pos:Number) : void {
						var w:MovieClip = this.WARNING_PANEL.CONTENT;
						if(w) {
								w.NFO.y = 0 + _pos * -1;
						}
				}
				
				private function Activate() : void {
						Imitation.AddButtonStop(this.BACK);
						var w:MovieClip = this.currentpage == WarningPanel.ERROR ? this.ERROR_PANEL : this.WARNING_PANEL;
						w.BTN_OK.AddEventClick(this.PlayHideAnim);
						w.BTN_OK.SetEnabled(true);
				}
				
				private function InActivate() : void {
						Imitation.DeleteEventGroup(this);
				}
				
				public function Hide() : void {
						TweenMax.killTweensOf(this);
						this.visible = false;
						WarningPanel.active = false;
						if(Boolean(Library.mc) && Boolean(Library.mc.currentpage)) {
								Imitation.Combine(Library.mc.currentpage,false);
						}
						if(this.callback != null) {
								this.callback();
						}
				}
		}
}

