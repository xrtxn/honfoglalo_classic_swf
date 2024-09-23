package library {
		import com.greensock.TweenMax;
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol305")]
		public class UserQuestionStats extends MovieClip {
				public static var active:Boolean = false;
				
				public var CONTENT:MovieClip;
				
				public function UserQuestionStats() {
						super();
				}
				
				public function Show() : void {
						Util.StopAllChildrenMov(this);
						this.visible = true;
						UserQuestionStats.active = true;
						this.Draw();
				}
				
				public function Draw() : void {
						Imitation.CollectChildrenAll(this);
						var tag:Object = null;
						var p:MovieClip = null;
						var w:MovieClip = this.CONTENT;
						for(var i:int = 0; i <= 10; i++) {
								p = new StatSample();
								Imitation.GotoFrame(p,Config.rtl ? 2 : 1);
								if(i == 0) {
										Lang.Set(p.SUBJECT,"summary");
										p.THEMEICON.gotoAndStop(1);
										p.THEMEICON.visible = false;
								} else {
										Lang.Set(p.SUBJECT,"question_subject_" + i);
										p.THEMEICON.gotoAndStop(i);
										p.THEMEICON.visible = true;
								}
								tag = Library.themes[i];
								Util.SetText(p.C_ACTIVE,Lang.Get("active_usq") + ":");
								Util.SetText(p.C_LASTCLOSED,Lang.Get("recently_closed_usq") + ":");
								Util.SetText(p.C_ALLCLOSED,Lang.Get("all_closed_usq") + ":");
								Lang.Set(p.C_WAITING,"waiting");
								Lang.Set(p.C_QUALIFYING,"qualifying");
								Lang.Set(p.C_FINAL,"final");
								Lang.Set(p.C_INGAME,"usq_state_ingame");
								p.CURW.text = Util.NumberVal(tag.CURW);
								p.CURQ.text = Util.NumberVal(tag.CURQ);
								p.CURF.text = Util.NumberVal(tag.CURF);
								p.LASTQ.text = Util.NumberVal(tag.LASTQ);
								p.LASTF.text = Util.NumberVal(tag.LASTF);
								p.LASTG.text = Util.NumberVal(tag.LASTG);
								p.ALLQ.text = Util.NumberVal(tag.ALLQ);
								p.ALLF.text = Util.NumberVal(tag.ALLF);
								p.ALLG.text = Util.NumberVal(tag.ALLG);
								p.y = 175 * i;
								w.NFO.addChild(p);
						}
						Imitation.Combine(w.NFO,true);
						if(w.NFO.height > 370) {
								w.MASK.visible = w.SB.visible = true;
								w.SB.Set(w.NFO.height,366,0);
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
						var w:MovieClip = this.CONTENT;
						if(w) {
								w.NFO.y = 0 + _pos * -1;
						}
				}
				
				private function InActivate() : void {
						Imitation.DeleteEventGroup(this);
				}
				
				public function Hide() : void {
						TweenMax.killTweensOf(this);
						this.InActivate();
						this.visible = false;
						UserQuestionStats.active = false;
				}
		}
}

