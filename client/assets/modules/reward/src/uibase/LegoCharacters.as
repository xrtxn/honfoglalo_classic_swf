package uibase {
		import flash.display.MovieClip;
		import syscode.Config;
		import syscode.Imitation;
		
		public class LegoCharacters extends MovieClip {
				public var JOKER:CharacterJOKER;
				
				public var MESSENGER:CharacterMESSENGER;
				
				public var names:Object;
				
				public function LegoCharacters() {
						super();
						this.names = new Object();
						this.names.archer = "ARCHER";
						this.names.architect = "ARCHITECT";
						this.names.fortress = "ARCHITECT";
						this.names.bishop = "BISHOP";
						this.names.series5 = "BISHOP";
						this.names.blacksmith = "BLACKSMITH";
						this.names.selhalf = "BLACKSMITH";
						this.names.ceremony_master = "CEREMONY_MASTER";
						this.names.clan_girl = "CLAN_GIRL";
						this.names.general = "GENERAL";
						this.names.subject = "GENERAL";
						this.names.headsman = "HEADSMAN";
						this.names.innkeeper = "INNKEEPER";
						this.names.selansw = "INNKEEPER";
						this.names.joker = "JOKER";
						this.names.king = "KING";
						this.names.librarian = "LIBRARIAN";
						this.names.merchant = "MERCHANT";
						this.names.messenger = "MESSENGER";
						this.names.minister = "MINISTER";
						this.names.series3 = "MINISTER";
						this.names.officer = "OFFICER";
						this.names.series2 = "OFFICER";
						this.names.pet_merchant = "PET_MERCHANT";
						this.names.tipaver = "PET_MERCHANT";
						this.names.pirate = "PIRATE";
						this.names.series1 = "PIRATE";
						this.names.prince = "PRINCE";
						this.names.series4 = "PRINCE";
						this.names.professor = "PROFESSOR";
						this.names.tiprang = "PROFESSOR";
						this.names.veteran = "VETERAN";
						this.names.wizard = "WIZARD";
						this.names.airborne = "WIZARD";
				}
				
				public function Set(param1:String, param2:String = "DEFAULT") : void {
						var _loc4_:String = null;
						var _loc5_:* = undefined;
						var _loc6_:uint = 0;
						if(param1 == "" || param1 == null) {
								return;
						}
						var _loc3_:String = param1.toLowerCase();
						for(_loc5_ in this.names) {
								if(_loc5_ == _loc3_) {
										_loc4_ = this.names[_loc5_];
										break;
								}
						}
						if(_loc4_ != null) {
								gotoAndStop(_loc4_);
						} else {
								gotoAndStop(1);
						}
						if(String("|tr|xa|").indexOf(Config.siteid) >= 0) {
								_loc6_ = 0;
								while(_loc6_ < this.currentLabels.length) {
										if(this.currentLabels[_loc6_].name == _loc4_ + "_TR") {
												gotoAndStop(_loc4_ + "_TR");
												break;
										}
										_loc6_++;
								}
						}
						MovieClip(this.getChildAt(0)).gotoAndStop(param2);
						Imitation.FreeBitmapAll(this);
				}
		}
}

