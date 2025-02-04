package tutorial
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import syscode.*;

	[Embed(source="/modules/tutorial_assets.swf", symbol="symbol438")]
	public class Tutorial extends MovieClip
	{
		public static var currentaction:String = "";

		public static var currentclass:Object = null;

		public static var lastactmc:MovieClip = null;

		public static var lastaction:String = "";

		public static var lastclass:Object = "";

		public function Tutorial()
		{
			super();
		}

		public static function Init(ok:*):void
		{
			trace("Tutorial.Init");
		}

		public static function TutorialCheck(notSysActionName:String = ""):Boolean
		{
			if (notSysActionName == "")
			{
				if (currentaction != "")
				{
					return true;
				}
				if (Sys.mydata.action == null || Sys.mydata.action == "")
				{
					return false;
				}
				currentaction = Sys.mydata.action;
			}
			else
			{
				lastaction = currentaction;
				currentaction = notSysActionName;
			}
			trace("########## New Tutorial: \"" + currentaction + "\"");
			if ("UL:SELHALF" == currentaction)
			{
				currentclass = Selhalf;
			}
			else if ("UL:TIPRANG" == currentaction)
			{
				currentclass = Tiprang;
			}
			else if ("UL:AIRBORNE" == currentaction)
			{
				currentclass = Airborne;
			}
			else if ("UL:SELANSW" == currentaction)
			{
				currentclass = Selansw;
			}
			else if ("UL:SUBJECT" == currentaction)
			{
				currentclass = Subject;
			}
			else if ("UL:FORTRESS" == currentaction)
			{
				currentclass = Fortress;
			}
			else if ("UL:TIPAVER" == currentaction)
			{
				currentclass = Tipaver;
			}
			else if ("WIN:CASTLE" == currentaction)
			{
				currentclass = Castle;
			}
			else if ("UL:TAXCOLLECT" == currentaction)
			{
				currentclass = Taxcollect;
			}
			else if ("LVL:LEVELUP" == currentaction)
			{
				currentclass = Lvlup;
			}
			else if ("GIFT:SELHALF_UP" == currentaction)
			{
				currentclass = SelhalfGiftUp;
			}
			else if ("UL:BADGES" == currentaction)
			{
				currentclass = Badges;
			}
			else
			{
				if ("WIN:NAME" == currentaction)
				{
					if (Sys.codereg)
					{
						WinMgr.OpenWindow("settings.AvatarWin", {"callback": function():*
								{
									TutorialFinished();
								}
							});
						return true;
					}
					WinMgr.OpenWindow("settings.AvatarWin", {
								"strdef": Sys.mydata.customavatar,
								"previewmc": null,
								"callback": function():*
								{
									TutorialFinished();
								}
							});
					return true;
				}
				if ("WIN:AVATAR" == currentaction)
				{
					if (Util.StringVal(Sys.mydata.avatar) == "")
					{
						WinMgr.OpenWindow("settings.AvatarWin", {
									"strdef": Sys.mydata.customavatar,
									"previewmc": null,
									"callback": function():*
									{
										TutorialFinished();
									}
								});
						return true;
					}
					TutorialFinished();
					return false;
				}
				if (currentaction.indexOf("TUTORIALMISSION:") <= -1)
				{
					trace("Unhandled tutorial action: " + currentaction);
					TutorialFinished();
					return false;
				}
				currentclass = TutorialMission;
			}
			trace("currentclass: " + currentclass);
			if (currentclass)
			{
				currentclass.StartMe();
				return true;
			}
			return false;
		}

		public static function TutorialMissionCheck():Boolean
		{
			trace("TutorialMissionCheck - action :" + Sys.mydata.tutorialmission);
			if (Sys.mydata.tutorialmission == null || Sys.mydata.tutorialmission == "")
			{
				return false;
			}
			trace("########## New TutorialMission: \"" + currentaction + "\"");
			currentclass = TutorialMission;
			currentclass.StartMe();
			return true;
		}

		public static function TutorialFinished():void
		{
			trace("TutorialFinished");
			trace("currentaction:" + currentaction);
			if (currentaction == "")
			{
				return;
			}
			trace("TutorialFinished: \"" + currentaction + "\"");
			var sendcommandstr:String = currentaction;
			if (currentaction == "BANK:FIRST_VISIT")
			{
				currentaction = lastaction;
				currentclass = lastclass;
			}
			else
			{
				currentaction = "";
				currentclass = null;
			}
			Sys.villageautplaytutorial = true;
			DBG.Trace("TutorialFinished: ", "SEENWINDOW: WINDOW=\"" + sendcommandstr + "\"");
			trace("SEENWINDOW: WINDOW=\"" + sendcommandstr + "\"");
			Comm.SendCommand("SEENWINDOW", "WINDOW=\"" + sendcommandstr + "\"");
		}

		public static function ObjectTrace(_obj:Object, sPrefix:String = ""):void
		{
			var i:* = undefined;
			if (sPrefix == "")
			{
				sPrefix = "-->";
			}
			else
			{
				sPrefix += " -->";
			}
			for (i in _obj)
			{
				trace(sPrefix, i + ":" + _obj[i], " ");
				if (typeof _obj[i] == "object")
				{
					ObjectTrace(_obj[i], sPrefix);
				}
			}
		}

		public static function MovieClipHasLabel(movieClip:MovieClip, labelName:String):Boolean
		{
			var label:FrameLabel = null;
			var labels:Array = movieClip.currentLabels;
			var a:Boolean = false;
			var i:uint = 0;
			while (i < labels.length)
			{
				label = labels[i];
				if (label.name == labelName)
				{
					a = true;
					break;
				}
				i++;
			}
			return a;
		}
	}
}
