package uibase
{
	import flash.display.*;
	import flash.events.*;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.*;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol1200")]
	public class FPSIndicator extends MovieClip
	{
		public static var mc:FPSIndicator = null;

		public static var fps:int = 0;

		public static var fpstime:int = 0;

		public var NUM:TextField;

		public function FPSIndicator()
		{
			super();
		}

		public static function Show():void
		{
			if (mc)
			{
				return;
			}
			mc = new FPSIndicator();
			fps = 0;
			fpstime = getTimer();
			mc.addEventListener("enterFrame", OnEnterFrame);
			Imitation.rootmc.addChild(mc);
		}

		public static function Hide():void
		{
			if (!mc)
			{
				return;
			}
			mc.removeEventListener("enterFrame", OnEnterFrame);
			if (mc.parent)
			{
				mc.parent.removeChild(mc);
			}
			mc = null;
		}

		public static function OnEnterFrame(e:*):*
		{
			var stat:Object = null;
			var avgt:int = 0;
			var text:* = null;
			if (!mc || !mc.parent)
			{
				return;
			}
			++ fps;
			var elapsed:int = getTimer() - fpstime;
			if (elapsed >= 1000)
			{
				stat = Imitation.GetRenderStat();
				avgt = Math.round(stat.renderTimes / Math.max(1, stat.renderCycles));
				text = Math.round(fps * (1000 / elapsed)) + "/" + Math.round(100 * stat.updateTimes / elapsed) + "-" + Math.round(100 * stat.renderTimes / elapsed) + "/" + Math.round(System.totalMemory / 1048576);
				text += " [" + stat.textureCount + "/" + Math.round(stat.textureSurface / 1048576) + "|" + stat.renderCount + "/" + Math.round(stat.renderSurface / 1048576) + "]";
				text += "\n";
				text += " (" + stat.touchHandlers + "/" + stat.touchMasks + "/" + stat.touchFrozens + ")";
				text += " {" + stat.generateCount + "/" + stat.generateTime + "/" + Math.round(stat.generateTime / Math.max(1, stat.generateCount)) + "}";
				mc.NUM.text = text;
				fps = 0;
				fpstime = getTimer();
			}
			var runlength:Number = Imitation.stage.stageWidth - mc.width;
			var xstep:Number = runlength / 60 / 6;
			mc.y = Imitation.stage.stageHeight - mc.height - 2;
			mc.x += xstep;
			if (mc.x > runlength)
			{
				mc.x = 0;
			}
			if (Boolean(mc.parent) && mc.parent.getChildIndex(mc) < mc.parent.numChildren - 1)
			{
				mc.parent.removeChild(mc);
				Imitation.rootmc.addChild(mc);
			}
		}
	}
}
