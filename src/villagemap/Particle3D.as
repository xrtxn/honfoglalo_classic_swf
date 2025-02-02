package villagemap
{
	public class Particle3D
	{
		public var size:Number;

		public var color:uint;

		public var pos:Point3D;

		public var vel:Point3D;

		public var accel:Point3D;

		public var airResistanceFactor:Number;

		public var age:Number;

		public var lifeSpan:Number;

		public var next:Particle3D;

		public var prev:Particle3D;

		public var envelopeTime1:Number;

		public var envelopeTime2:Number;

		public var envelopeTime3:Number;

		public var paramInit:Number;

		public var paramHold:Number;

		public var paramLast:Number;

		public var dead:Boolean;

		public function Particle3D(x0:Number = 0, y0:Number = 0, z0:Number = 0, velX:Number = 0, velY:Number = 0, velZ:Number = 0)
		{
			super();
			this.pos = new Point3D(x0, y0, z0);
			this.vel = new Point3D(velX, velY, velZ);
			this.accel = new Point3D();
			this.size = 1;
			this.color = 16777215;
			this.airResistanceFactor = 0.03;
			this.dead = false;
		}
	}
}
