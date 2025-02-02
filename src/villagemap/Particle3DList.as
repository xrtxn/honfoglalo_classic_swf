package villagemap
{
	public class Particle3DList
	{
		public var first:Particle3D;

		public var recycleBinListFirst:Particle3D;

		public var numOnStage:Number;

		public var numInRecycleBin:Number;

		public function Particle3DList()
		{
			super();
			this.numOnStage = 0;
			this.numInRecycleBin = 0;
		}

		public function addParticle(x0:Number = 0, y0:Number = 0, z0:Number = 0, velX:Number = 0, velY:Number = 0, velZ:Number = 0):Particle3D
		{
			var particle:Particle3D = null;
			++this.numOnStage;
			if (this.recycleBinListFirst != null)
			{
				--this.numInRecycleBin;
				particle = this.recycleBinListFirst;
				if (particle.next != null)
				{
					this.recycleBinListFirst = particle.next;
					particle.next.prev = null;
				}
				else
				{
					this.recycleBinListFirst = null;
				}
				particle.pos.x = x0;
				particle.pos.y = y0;
				particle.pos.z = z0;
				particle.vel.x = velX;
				particle.vel.y = velY;
				particle.vel.z = velZ;
			}
			else
			{
				particle = new Particle3D(x0, y0, z0, velX, velY, velZ);
			}
			particle.age = 0;
			particle.dead = false;
			if (this.first == null)
			{
				this.first = particle;
				particle.prev = null;
				particle.next = null;
			}
			else
			{
				particle.next = this.first;
				this.first.prev = particle;
				this.first = particle;
				particle.prev = null;
			}
			return particle;
		}

		public function recycleParticle(particle:Particle3D):void
		{
			--this.numOnStage;
			++this.numInRecycleBin;
			if (this.first == particle)
			{
				if (particle.next != null)
				{
					particle.next.prev = null;
					this.first = particle.next;
				}
				else
				{
					this.first = null;
				}
			}
			else if (particle.next == null)
			{
				particle.prev.next = null;
			}
			else
			{
				particle.prev.next = particle.next;
				particle.next.prev = particle.prev;
			}
			if (this.recycleBinListFirst == null)
			{
				this.recycleBinListFirst = particle;
				particle.prev = null;
				particle.next = null;
			}
			else
			{
				particle.next = this.recycleBinListFirst;
				this.recycleBinListFirst.prev = particle;
				this.recycleBinListFirst = particle;
				particle.prev = null;
			}
		}
	}
}
