package triviador {
		import flash.display.MovieClip;
		import flash.events.Event;
		import flash.text.TextField;
		import syscode.Util;
		
		[Embed(source="/modules/triviador_assets.swf", symbol="symbol1349")]
		public class WaitAnimMov extends MovieClip {
				public var ANIM:MovieClip;
				
				public var C_LOADING:TextField;
				
				public var rotationspeed:Number = 10;
				
				public function WaitAnimMov() {
						super();
						this.visible = false;
				}
				
				public function Show(atext:*) : * {
						Util.SetText(this.C_LOADING,atext);
						Util.AddEventListener(this,Event.ENTER_FRAME,this.OnEnterFrame);
						this.visible = true;
				}
				
				public function Hide() : * {
						this.visible = false;
						Util.RemoveEventListener(this,Event.ENTER_FRAME,this.OnEnterFrame);
				}
				
				public function OnEnterFrame(e:*) : * {
						this.ANIM.rotation += this.rotationspeed;
				}
		}
}

