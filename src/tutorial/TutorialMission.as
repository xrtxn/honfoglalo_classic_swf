package tutorial
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;

	import flash.display.MovieClip;

	import uibase.gfx.lego_button_1x1_ok;
	import syscode.WinMgr;
	import syscode.Lang;
	import syscode.Sys;
	import syscode.Modules;
	import syscode.Util;
	import syscode.LegoAvatarMov;
	import uibase.gfx.UIIconset;
	import uibase.gfx.LegoCharacters;
	import syscode.Comm;

	[Embed(source="/modules/tutorial_assets.swf", symbol="symbol416")]
	public class TutorialMission extends MovieClip
	{
		public static var mc:TutorialMission = null;

		public var AVATAR:LegoAvatarMov;

		public var AVATARTEXT:MovieClip;

		public var BOOSTERBG:MovieClip;

		public var BTN_NEXT:lego_button_1x1_ok;

		public var CNT:MovieClip;

		public var ICON:UIIconset;

		public var NPC:LegoCharacters;

		public var NPCTEXT:MovieClip;

		private var id:String;

		private var status:String;

		private var booster:String;

		private var booster_number:int = -1;

		public var texts:Array;

		public var index:int = 0;

		public function TutorialMission()
		{
			this.texts = new Array();
			super();
			addFrameScript(0, this.frame1);
		}

		public static function StartMe():void
		{
			WinMgr.OpenWindow(TutorialMission, {});
		}

		public function Prepare(aparams:Object):*
		{
			trace("TutorialMission.Prepare");
			var spl:Array = Sys.mydata.tutorialmission.split(";");
			var id_status:String = spl[0].split("TUTORIALMISSION:").join("");
			var ida:Array = id_status.split(",");
			this.id = ida[0];
			this.status = ida[1];
			trace("TUTORIALMISSION:");
			trace("ID: " + this.id);
			trace("STATUS: " + this.status);
			var boo_num:Array = spl[1].split("=");
			this.booster = boo_num[0];
			this.booster_number = int(boo_num[1]);
			trace("BOOSTER: " + this.booster);
			trace("BOOSTER_NUMBER: " + this.booster_number);
			if (this.status == "START" || this.status == "FIRSTRUN" || this.status == "RUNNING")
			{
				this.texts[0] = [Lang.Get("tmission_" + this.booster.toLowerCase() + "_start_1").replace("$num", this.booster_number), Lang.Get("ok_get_it")];
			}
			else if (this.status == "END")
			{
				this.texts[0] = [Lang.Get("tmission_generic_end_1"), Lang.Get("thx_bye")];
			}
			this.AVATAR.ShowUID(Sys.mydata.id);
			this.NPC.Set(this.booster, "DEFAULT");
			this.ICON.Set(this.booster);
			this.BTN_NEXT.AddEventClick(this.OnNextClicked);
			this.BTN_NEXT.SetIcon("PLAY");
			this.CNT.FIELD.text = "X" + this.booster_number;
			this.DrawPage();
		}

		public function AfterOpen():void
		{
		}

		public function DrawPage():void
		{
			if (this.index > this.texts.length - 1)
			{
				if (this.status == "END")
				{
					this.BoosterAnim();
					return;
				}
				WinMgr.CloseWindow(this);
				return;
			}
			if (this.index <= 0)
			{
				this.index = 0;
			}
			this.NPC.Set(this.booster, "DEFAULT");
			this.BOOSTERBG.visible = this.index > 0 ? true : false;
			Util.SetText(this.NPCTEXT.FIELD, this.texts[this.index][0].replace("$1", Sys.mydata.name));
			Util.SetText(this.AVATARTEXT.FIELD, this.texts[this.index][1].replace("$1", Sys.mydata.name));
			if (this.NPCTEXT.FIELD.numLines >= 4)
			{
				this.NPCTEXT.FIELD.y = 9;
			}
			if (this.NPCTEXT.FIELD.numLines == 3)
			{
				this.NPCTEXT.FIELD.y = 18;
			}
			if (this.NPCTEXT.FIELD.numLines == 2)
			{
				this.NPCTEXT.FIELD.y = 29;
			}
			if (this.NPCTEXT.FIELD.numLines == 1)
			{
				this.NPCTEXT.FIELD.y = 39;
			}
			if (this.AVATARTEXT.FIELD.numLines >= 3)
			{
				this.AVATARTEXT.FIELD.y = 0;
			}
			if (this.AVATARTEXT.FIELD.numLines == 2)
			{
				this.AVATARTEXT.FIELD.y = 10;
			}
			if (this.AVATARTEXT.FIELD.numLines == 1)
			{
				this.AVATARTEXT.FIELD.y = 20;
			}
		}

		public function OnNextClicked(arg:Object):void
		{
			++this.index;
			this.DrawPage();
		}

		public function OnPrevClicked(arg:Object):void
		{
			--this.index;
			this.DrawPage();
		}

		public function BoosterAnim():void
		{
			var animdelay:Number = NaN;
			this.BTN_NEXT.SetEnabled(false);
			animdelay = 0.1;
			var flybooster:MovieClip = null;
			for (var i:uint = 0; i < this.booster_number; i++)
			{
				animdelay += 0.3;
				flybooster = new UIIconset();
				flybooster.scaleX = flybooster.scaleY = this.ICON.scaleX;
				addChild(flybooster);
				flybooster.Set(this.booster);
				flybooster.tx = this.AVATAR.x;
				flybooster.ty = this.AVATAR.y;
				flybooster.x = this.ICON.x;
				flybooster.y = this.ICON.y;
				flybooster.visible = false;
				TweenMax.fromTo(flybooster, 1, {"visible": true}, {
							"x": flybooster.tx,
							"y": flybooster.ty,
							"visible": false,
							"delay": animdelay,
							"scaleX": 1,
							"scaleY": 1,
							"bezier": [ {
									"x": this.ICON.x,
									"y": -30
								}, {
									"x": flybooster.tx,
									"y": flybooster.ty,
									"scaleX": 3,
									"scaleY": 3
								}],
							"ease": Sine.easeInOut
						});
			}
			TweenMax.delayedCall(animdelay + 1, this.Hide);
		}

		public function Hide(e:* = null):void
		{
			WinMgr.CloseWindow(this);
		}

		public function AfterClose():void
		{
			var sendcommandstr:String = null;
			if (this.status != "RUNNING")
			{
				sendcommandstr = this.id;
				trace("TutorialMissionFinished: ", "WINDOW=\"TUTORIALMISSION:" + sendcommandstr + "\"");
				Comm.SendCommand("SEENWINDOW", "WINDOW=\"TUTORIALMISSION:" + sendcommandstr + "\"");
			}
		}

		internal function frame1():*
		{
			stop();
		}
	}
}
