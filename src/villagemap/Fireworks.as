package villagemap
{
	import flash.display.*;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import syscode.*;

	public class Fireworks extends MovieClip
	{
		internal var flareList:Particle3DList;

		internal var sparkList:Particle3DList;

		internal var sparkBitmapData:BitmapData;

		internal var sparkBitmap:Bitmap;

		internal var waitCount:int;

		internal var count:int;

		internal var darken:ColorTransform;

		internal var origin:Point;

		internal var blur:BlurFilter;

		internal var sky:Sprite;

		internal var minWait:Number;

		internal var maxWait:Number;

		internal var colorList:Vector.<uint>;

		internal var maxDragFactorFlare:Number;

		internal var maxDragFactorSpark:Number;

		internal var maxNumSparksAtNewFirework:Number;

		internal var displayHolder:Sprite;

		internal var displayWidth:Number;

		internal var displayHeight:Number;

		internal var starLayer:Sprite;

		internal var particle:Particle3D;

		internal var nextParticle:Particle3D;

		internal var spark:Particle3D;

		internal var nextSpark:Particle3D;

		internal var phi:Number;

		internal var theta:Number;

		internal var mag:Number;

		internal var dragFactor:Number;

		internal var flareOriginX:Number;

		internal var flareOriginY:Number;

		internal var numFlares:Number;

		internal var numSparks:Number;

		internal var sparkAlpha:Number;

		internal var sparkColor:uint;

		internal var randDist:Number;

		internal var presentAlpha:Number;

		internal var colorParam:Number;

		internal var fireworkColor:uint;

		internal var grayAmt:Number;

		internal var gravity:Number;

		internal var maxNumFlares:Number;

		internal var maxNumSparksPerFlare:int;

		internal var topMargin:Number;

		internal var target:MovieClip;

		public var maxNumber:Number = 3;

		internal var actNumber:Number = 0;

		internal var pos:Boolean = true;

		public function Fireworks(atarget:MovieClip, amaxnum:Number = 3, _pos:Boolean = true)
		{
			super();
			this.pos = _pos;
			this.target = atarget;
			this.maxNumber = amaxnum;
			this.init();
		}

		private function init():void
		{
			this.displayWidth = 200;
			this.displayHeight = 200;
			this.waitCount = 100;
			this.minWait = 10;
			this.maxWait = 130;
			this.count = this.waitCount - 1;
			this.flareList = new Particle3DList();
			this.sparkList = new Particle3DList();
			this.maxDragFactorFlare = 0.6;
			this.maxDragFactorSpark = 0.6;
			this.maxNumSparksAtNewFirework = 500;
			this.gravity = 0.03;
			this.maxNumFlares = 30;
			this.maxNumSparksPerFlare = 2;
			this.topMargin = 6;
			this.displayHolder = new Sprite();
			this.displayHolder.x = 0;
			this.displayHolder.y = 0;
			this.sparkBitmapData = new BitmapData(this.displayWidth, this.displayHeight, true, 0);
			this.sparkBitmap = new Bitmap(this.sparkBitmapData);
			var alphaToWhite:Number = 0.5;
			var alphaMult:Number = 1.6;
			var cmf:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, alphaToWhite, 0, 0, 1, 0, alphaToWhite, 0, 0, 0, 1, alphaToWhite, 0, 0, 0, 0, alphaMult, 0]);
			this.sparkBitmap.filters = [cmf];
			this.addChild(this.displayHolder);
			this.displayHolder.addChild(this.sparkBitmap);
			this.scaleX = this.scaleY = this.target.scaleX;
			if (this.pos)
			{
				this.x = this.target.x - this.width / 2;
				this.y = this.target.y - (this.height / 2 + this.height / 4);
			}
			this.darken = new ColorTransform(1, 1, 1, 0.87);
			this.blur = new BlurFilter(4, 4, 1);
			this.origin = new Point(0, 0);
			this.colorList = new <uint>[6881028, 15721069, 16535120, 16775911, 16777215, 16761088, 14688802, 16753152, 16711680, 9087741, 3437541, 12670903, 10173578, 16374936, 14457925, 15635256];
			Util.AddEventListener(this, Event.ENTER_FRAME, this.onEnter);
		}

		private function onEnter(evt:Event):void
		{
			var i:int = 0;
			var sizeFactor:Number = NaN;
			var thisParticle:Particle3D = null;
			var thisSpark:Particle3D = null;
			++this.count;
			if (this.count >= this.waitCount && this.sparkList.numOnStage < this.maxNumSparksAtNewFirework && this.actNumber < this.maxNumber)
			{
				++this.actNumber;
				this.waitCount = this.minWait + Math.random() * (this.maxWait - this.minWait);
				this.fireworkColor = this.randomColor();
				this.count = 0;
				this.flareOriginX = this.displayWidth / 2 + Math.random() * 100 - 50;
				this.flareOriginY = this.displayHeight / 2 + -(Math.random() * 10);
				sizeFactor = 0.1 + Math.random() * 0.9;
				this.numFlares = (0.25 + 0.75 * Math.random() * sizeFactor) * this.maxNumFlares;
				for (i = 0; i < this.numFlares; i++)
				{
					thisParticle = this.flareList.addParticle(this.flareOriginX, this.flareOriginY, 0);
					this.theta = 2 * Math.random() * Math.PI;
					this.phi = Math.acos(2 * Math.random() - 1);
					this.mag = 8 + sizeFactor * sizeFactor * 10;
					thisParticle.vel.x = this.mag * Math.sin(this.phi) * Math.cos(this.theta);
					thisParticle.vel.y = this.mag * Math.sin(this.phi) * Math.sin(this.theta);
					thisParticle.vel.z = this.mag * Math.cos(this.phi);
					thisParticle.airResistanceFactor = 0.05;
					thisParticle.envelopeTime1 = 45 + 60 * Math.random();
					thisParticle.color = this.fireworkColor;
				}
			}
			this.particle = this.flareList.first;
			while (this.particle != null)
			{
				this.nextParticle = this.particle.next;
				this.dragFactor = this.particle.airResistanceFactor * Math.sqrt(this.particle.vel.x * this.particle.vel.x + this.particle.vel.y * this.particle.vel.y + this.particle.vel.z * this.particle.vel.z);
				if (this.dragFactor > this.maxDragFactorFlare)
				{
					this.dragFactor = this.maxDragFactorFlare;
				}
				this.particle.vel.x += 0.05 * (Math.random() * 2 - 1);
				this.particle.vel.y += 0.05 * (Math.random() * 2 - 1) + this.gravity;
				this.particle.vel.z += 0.05 * (Math.random() * 2 - 1);
				this.particle.vel.x -= this.dragFactor * this.particle.vel.x;
				this.particle.vel.y -= this.dragFactor * this.particle.vel.y;
				this.particle.vel.z -= this.dragFactor * this.particle.vel.z;
				this.particle.pos.x += this.particle.vel.x;
				this.particle.pos.y += this.particle.vel.y;
				this.particle.pos.z += this.particle.vel.z;
				this.particle.age += 1;
				if (this.particle.age > this.particle.envelopeTime1)
				{
					this.particle.dead = true;
				}
				if (this.particle.dead || this.particle.pos.x > this.displayWidth || this.particle.pos.x < 0 || this.particle.pos.y > this.displayHeight || this.particle.pos.y < -this.topMargin)
				{
					this.flareList.recycleParticle(this.particle);
				}
				else
				{
					this.numSparks = Math.floor(Math.random() * (this.maxNumSparksPerFlare + 1) * (1 - this.particle.age / this.particle.envelopeTime1));
					for (i = 0; i < this.maxNumSparksPerFlare; i++)
					{
						this.randDist = Math.random();
						thisSpark = this.sparkList.addParticle(this.particle.pos.x - this.randDist * this.particle.vel.x, this.particle.pos.y - this.randDist * this.particle.vel.y, 0, 0);
						thisSpark.vel.x = 0.2 * (Math.random() * 2 - 1);
						thisSpark.vel.y = 0.2 * (Math.random() * 2 - 1);
						thisSpark.envelopeTime1 = 10 + Math.random() * 40;
						thisSpark.envelopeTime2 = thisSpark.envelopeTime1 + 6 + Math.random() * 6;
						thisSpark.airResistanceFactor = 0.2;
						thisSpark.color = this.particle.color;
					}
				}
				this.particle = this.nextParticle;
			}
			this.sparkBitmapData.lock();
			this.sparkBitmapData.colorTransform(this.sparkBitmapData.rect, this.darken);
			this.sparkBitmapData.applyFilter(this.sparkBitmapData, this.sparkBitmapData.rect, this.origin, this.blur);
			this.spark = this.sparkList.first;
			while (this.spark != null)
			{
				this.nextSpark = this.spark.next;
				this.dragFactor = this.spark.airResistanceFactor * Math.sqrt(this.spark.vel.x * this.spark.vel.x + this.spark.vel.y * this.spark.vel.y);
				if (this.dragFactor > this.maxDragFactorSpark)
				{
					this.dragFactor = this.maxDragFactorSpark;
				}
				this.spark.vel.x += 0.07 * (Math.random() * 2 - 1);
				this.spark.vel.y += 0.07 * (Math.random() * 2 - 1) + this.gravity;
				this.spark.vel.x -= this.dragFactor * this.spark.vel.x;
				this.spark.vel.y -= this.dragFactor * this.spark.vel.y;
				this.spark.pos.x += this.spark.vel.x;
				this.spark.pos.y += this.spark.vel.y;
				this.spark.age += 1;
				if (this.spark.age < this.spark.envelopeTime1)
				{
					this.sparkAlpha = 255;
				}
				else if (this.spark.age < this.spark.envelopeTime2)
				{
					this.sparkAlpha = -255 / this.spark.envelopeTime2 * (this.spark.age - this.spark.envelopeTime2);
				}
				else
				{
					this.spark.dead = true;
				}
				if (this.spark.dead || this.spark.pos.x > this.displayWidth || this.spark.pos.x < 0 || this.spark.pos.y > this.displayHeight || this.spark.pos.y < -this.topMargin)
				{
					this.sparkList.recycleParticle(this.spark);
				}
				this.sparkColor = this.sparkAlpha << 24 | this.spark.color;
				this.presentAlpha = this.sparkBitmapData.getPixel32(this.spark.pos.x, this.spark.pos.y) >> 24 & 0xFF;
				if (this.sparkAlpha > this.presentAlpha)
				{
					this.sparkBitmapData.setPixel32(this.spark.pos.x, this.spark.pos.y, this.sparkColor);
				}
				this.spark = this.nextSpark;
			}
			this.sparkBitmapData.unlock();
			if (this.sparkList.numOnStage < 1)
			{
				this.destroyMe();
			}
			Imitation.FreeBitmapAll(this);
			Imitation.UpdateAll(this);
		}

		public function destroyMe():void
		{
			trace("Fireworks: destroyMe()");
			if (Boolean(this.displayHolder) && contains(this.displayHolder))
			{
				removeChild(this.displayHolder);
			}
			this.flareList = null;
			this.sparkList = null;
			this.displayHolder = null;
			this.sparkBitmapData = null;
			this.sparkBitmap = null;
			if (parent)
			{
				parent.removeChild(this);
			}
			Util.RemoveEventListener(this, Event.ENTER_FRAME, this.onEnter);
		}

		private function randomColor():uint
		{
			var index:int = Math.floor(Math.random() * this.colorList.length);
			return this.colorList[index];
		}
	}
}
