package uibase
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import syscode.*;

	[Embed(source="/modules/uibase_assets.swf", symbol="symbol1254")]
	public class CountryFlagMov extends MovieClip
	{
		public var IDTEXT:TextField;

		public var PLACE:MovieClip;

		public var SHADER:MovieClip;

		public var currentid:String = "";

		public var currentbitmap:Bitmap = null;

		public var flagloaded:Boolean = false;

		public function CountryFlagMov()
		{
			super();
			this.Clear();
		}

		public function Set(aflagid:String):*
		{
			this.Clear();
			this.currentid = aflagid;
			this.IDTEXT.text = this.currentid;
			if (aflagid == null || aflagid.length != 2)
			{
				return;
			}
			var c:Object = Extdata.GetCountryData(this.currentid);
			if (c)
			{
				ImageCache.LoadImage(this.OnFlagLoaded, this, [this.currentid], c.flag);
			}
		}

		public function OnFlagLoaded(bitmap:Bitmap, aflagid:String):*
		{
			if (aflagid != this.currentid || this.flagloaded)
			{
				return;
			}
			this.flagloaded = true;
			this.currentbitmap = Bitmap(this.addChild(bitmap));
			this.currentbitmap.visible = true;
			this.currentbitmap.transform.matrix = this.PLACE.transform.matrix;
			this.currentbitmap.x = this.PLACE.width / 2 - this.currentbitmap.width / 2 - 1;
			this.PLACE.visible = false;
			this.IDTEXT.text = "";
			this.SHADER.visible = this.currentbitmap.width > 30;
			this.setChildIndex(this.SHADER, this.numChildren - 1);
			Imitation.CollectChildrenAll(this);
			Imitation.FreeBitmapAll(this);
			Imitation.UpdateAll(this);
		}

		public function Clear():*
		{
			if (this.currentbitmap != null)
			{
				this.removeChild(this.currentbitmap);
				this.currentbitmap = null;
			}
			this.currentid = "";
			this.flagloaded = false;
			this.PLACE.visible = true;
			this.SHADER.visible = false;
			this.IDTEXT.text = "";
			Imitation.CollectChildrenAll(this);
			Imitation.FreeBitmapAll(this);
			Imitation.UpdateAll(this);
		}
	}
}
