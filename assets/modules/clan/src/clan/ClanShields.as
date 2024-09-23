package clan {
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import syscode.*;
		import uibase.ScrollBarMov7;
		import uibase.lego_button_2x1_ok;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol494")]
		public class ClanShields extends MovieClip {
				public static var active:Boolean = false;
				
				public var BTNSAVE:lego_button_2x1_ok;
				
				public var RB_S1:RadioButton;
				
				public var RB_S2:RadioButton;
				
				public var RB_S3:RadioButton;
				
				public var S1:MovieClip;
				
				public var S2:MovieClip;
				
				public var S3:MovieClip;
				
				public var SHIELD:MovieClip;
				
				public var SHIELDS:clanshieldlist;
				
				public var SHIELDS_MASK:MovieClip;
				
				public var SSB:ScrollBarMov7;
				
				private var bg:int = 0;
				
				private var symbol:int = 0;
				
				public function ClanShields() {
						super();
				}
				
				public function Hide() : void {
						active = false;
				}
				
				public function Show() : void {
						active = true;
						this.bg = Clan.shield_bg;
						this.symbol = Clan.shield_symbol;
						var a:Array = [];
						var w:* = this;
						for(var i:int = 0; i < w.SHIELDS.S1.SYMBOL.totalFrames; a[i] = [],i++) {
						}
						w.SHIELDS.Set("S",a,90,6,this.OnClickShield,this.OnDrawShield,w.SHIELDS_MASK,w.SSB);
						w.SSB.ScrollTo(0,0);
						w.SSB.dragging = true;
						this.S1.gotoAndStop(1);
						this.S2.gotoAndStop(2);
						this.S3.gotoAndStop(3);
						this.S1.SYMBOL.gotoAndStop(Math.max(1,this.symbol));
						this.S2.SYMBOL.gotoAndStop(Math.max(1,this.symbol));
						this.S3.SYMBOL.gotoAndStop(Math.max(1,this.symbol));
						var n:int = this.bg + 1;
						if(this.symbol) {
								this.SHIELD.gotoAndStop(n);
								this.SHIELD.SYMBOL.gotoAndStop(this.symbol);
						} else {
								this.SHIELD.gotoAndStop(4);
						}
						Imitation.AddEventClick(w.RB_S1,this.OnRadio,{"n":1});
						Imitation.AddEventClick(w.RB_S2,this.OnRadio,{"n":2});
						Imitation.AddEventClick(w.RB_S3,this.OnRadio,{"n":3});
						this.BTNSAVE.SetLang("save");
						Imitation.AddEventClick(w.BTNSAVE,this.OnSave);
						this.RB_S1.CHECK.visible = n == 1;
						this.RB_S2.CHECK.visible = n == 2;
						this.RB_S3.CHECK.visible = n == 3;
						this.BTNSAVE.SetEnabled(false);
				}
				
				public function Draw() : * {
				}
				
				private function OnSave(e:*) : void {
						var updateproperties:Object = new Object();
						updateproperties.cmd = "update";
						updateproperties.shield = this.symbol + this.bg * 256;
						Clan.shield_symbol = this.symbol;
						Clan.shield_bg = this.bg;
						this.BTNSAVE.SetEnabled(false);
						List.billboardhot100datas = [null,null,null,null,null];
						Clan.OnUpdateMyClanShield(updateproperties);
				}
				
				private function OnRadio(e:*) : void {
						var n:int = Util.NumberVal(e.params.n);
						this.bg = n - 1;
						if(this.symbol < 1) {
								this.symbol = 1;
						}
						this.RB_S1.CHECK.visible = n == 1;
						this.RB_S2.CHECK.visible = n == 2;
						this.RB_S3.CHECK.visible = n == 3;
						this.SHIELD.gotoAndStop(n);
						this.SHIELD.SYMBOL.gotoAndStop(this.symbol);
						Imitation.FreeBitmapAll(this.SHIELD);
						this.BTNSAVE.SetEnabled(true);
				}
				
				private function OnDrawShield(item:*, id:*) : void {
						if(id >= this.SHIELDS.S1.SYMBOL.totalFrames) {
								item.visible = false;
								return;
						}
						item.SYMBOL.gotoAndStop(id + 1);
						item.SELECTED.visible = id + 1 == this.symbol;
				}
				
				private function OnClickShield(item:*, id:*) : void {
						this.symbol = id + 1;
						this.SHIELD.gotoAndStop(this.bg + 1);
						this.SHIELD.SYMBOL.gotoAndStop(this.symbol);
						this.S1.SYMBOL.gotoAndStop(this.symbol);
						this.S2.SYMBOL.gotoAndStop(this.symbol);
						this.S3.SYMBOL.gotoAndStop(this.symbol);
						Imitation.FreeBitmapAll(this.SHIELD);
						Imitation.FreeBitmapAll(this.S1);
						Imitation.FreeBitmapAll(this.S2);
						Imitation.FreeBitmapAll(this.S3);
						this.BTNSAVE.SetEnabled(true);
						this.SHIELDS.Draw();
				}
		}
}

