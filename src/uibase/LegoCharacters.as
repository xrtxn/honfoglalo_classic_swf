package uibase
{
	import flash.display.MovieClip;
	import syscode.Config;
	import syscode.Imitation;
	import uibase.assets.CharacterJOKER;
	import uibase.assets.CharacterMESSENGER;

	public class LegoCharacters extends MovieClip
	{
		public var JOKER:CharacterJOKER;

		public var MESSENGER:CharacterMESSENGER;

		public var names:Object;

		public function LegoCharacters()
		{
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

		public function Set(_name:String, _emotion:String = "DEFAULT"):void
		{
			var frameid:String = null;
			var key:* = undefined;
			var i:uint = 0;
			if (_name == "" || _name == null)
			{
				return;
			}
			var small_name:String = _name.toLowerCase();
			for (key in this.names)
			{
				if (key == small_name)
				{
					frameid = this.names[key];
					break;
				}
			}
			if (frameid != null)
			{
				gotoAndStop(frameid);
			}
			else
			{
				gotoAndStop(1);
			}
			if (String("|tr|xa|").indexOf(Config.siteid) >= 0)
			{
				for (i = 0; i < this.currentLabels.length; i++)
				{
					if (this.currentLabels[i].name == frameid + "_TR")
					{
						gotoAndStop(frameid + "_TR");
						break;
					}
				}
			}
			MovieClip(this.getChildAt(0)).gotoAndStop(_emotion);
			Imitation.FreeBitmapAll(this);
		}
	}
}
