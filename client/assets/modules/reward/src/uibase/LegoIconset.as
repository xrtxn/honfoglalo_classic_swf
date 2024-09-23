package uibase {
		import flash.display.MovieClip;
		import syscode.Config;
		import syscode.Imitation;
		
		public class LegoIconset extends MovieClip {
				public function LegoIconset() {
						super();
				}
				
				public function Set(param1:String) : void {
						var _loc3_:uint = 0;
						if(param1 == "" || param1 == null) {
								return;
						}
						var _loc2_:String = param1.toUpperCase();
						gotoAndStop(_loc2_);
						if(String("|tr|xa|").indexOf(Config.siteid) >= 0) {
								_loc3_ = 0;
								while(_loc3_ < this.currentLabels.length) {
										if(this.currentLabels[_loc3_].name == _loc2_ + "_TR") {
												gotoAndStop(_loc2_ + "_TR");
												break;
										}
										_loc3_++;
								}
						}
						Imitation.FreeBitmapAll(this);
				}
		}
}

