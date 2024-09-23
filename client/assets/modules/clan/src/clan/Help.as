package clan {
		import flash.display.MovieClip;
		import flash.text.*;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol30")]
		public class Help extends MovieClip {
				public var HELP_TEXT:MovieClip;
				
				public var HELP_TITLE:MovieClip;
				
				public function Help() {
						super();
				}
				
				public function Init() : * {
						syscode.Help.Set(this.HELP_TITLE.FIELD,"clan_help_title");
						syscode.Help.Set(this.HELP_TEXT.FIELD,"clan_help_text");
				}
				
				public function Show() : * {
						this.visible = true;
				}
				
				public function Hide() : * {
						this.visible = false;
				}
		}
}

