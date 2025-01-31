package uibase
{
	import flash.display.*;
	import flash.events.*;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol1426")]
	public class Building extends MovieClip
	{
		public static var forge_classnames:Array = ["", "Blacksmith", "Inn", "Petmerchant", "Scientist", "Wizard", "General", "Architect", "Pirate", "University", "University", "University", "University"];

		public var category:String = "general";

		public var classdefinition:Object = null;

		public var type:int = 0;

		public var level:int = 1;

		public var data:Object;

		public var mc:MovieClip = null;

		public var ox:Number;

		public var oy:Number;

		public var BUILDINGGRAPH:MovieClip;

		public var BG:MovieClip;

		public function Building(classname:* = "")
		{
			super();
			var placeholder:DisplayObject = getChildAt(0);
			removeChild(placeholder);
			if (classname != "")
			{
				if (forge_classnames.indexOf(classname) > -1)
				{
					this.category = "forge";
				}
				this.CreateMC(classname);
				this.type = forge_classnames.indexOf(classname);
			}
		}

		public static function LoadGFX(completefunc:Function):void
		{
			Modules.ScheduleLoadModule("buildings");
			Modules.LoadScheduledModules(completefunc);
		}

		public function SetupForge(atype:int, alevel:int):*
		{
			this.category = "forge";
			if (this.type != atype && Boolean(this.mc))
			{
				this.RemoveMC();
			}
			this.type = atype;
			if (this.mc)
			{
				this.SetLevel(alevel);
			}
			else
			{
				this.CreateMC(forge_classnames[this.type]);
				this.SetLevel(alevel);
			}
		}

		public function SetLevel(alevel:int):*
		{
			this.level = alevel;
			if (this.MovieClipHasLabel(this.mc, "l" + this.level))
			{
				this.mc.gotoAndStop("l" + this.level);
			}
			else
			{
				this.mc.gotoAndStop(this.mc.totalFrames);
			}
			this.BUILDINGGRAPH = this.mc.BUILDINGGRAPH;
			if (this.mc.BG)
			{
				this.BG = this.mc.BG;
			}
			else
			{
				this.BG = new MovieClip();
			}
		}

		public function CreateMC(classname:*):*
		{
			if (classname == "Castle")
			{
				this.category = "castle";
			}
			this.classdefinition = Modules.GetClass("buildings", classname) as Class;
			this.mc = new this.classdefinition();
			addChild(this.mc);
			this.mc.stop();
			this.BUILDINGGRAPH = this.mc.BUILDINGGRAPH;
			if (this.mc.BG)
			{
				this.BG = this.mc.BG;
			}
			else
			{
				this.BG = new MovieClip();
			}
		}

		public function RemoveMC():*
		{
			if (this.mc.parent)
			{
				removeChild(this.mc);
			}
			this.mc = null;
			this.BUILDINGGRAPH = null;
			this.BG = null;
		}

		public function MovieClipHasLabel(movieClip:MovieClip, labelName:String):Boolean
		{
			var label:FrameLabel = null;
			var labels:Array = movieClip.currentLabels;
			var a:Boolean = false;
			for (var i:uint = 0; i < labels.length; i++)
			{
				label = labels[i];
				if (label.name == labelName)
				{
					a = true;
					break;
				}
			}
			return a;
		}
	}
}
