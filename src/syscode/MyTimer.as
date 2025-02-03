package syscode
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import syscode.Util;

	// this class was originally in Lobby but I thouht this would be the better place for it
	public class MyTimer
	{
		public var timer:Timer;

		public var queue:Array;

		public var onReady:Function;

		public var running:Boolean;

		public function MyTimer()
		{
			super();
			this.onReady = null;
			this.timer = new Timer(50);
			Util.AddEventListener(this.timer, TimerEvent.TIMER, this.OnTimer);
			this.timer.reset();
			this.queue = [];
			this.running = false;
		}

		public function Start():*
		{
			var curr:* = new Date().getTime();
			for (var i:* = 0; i < this.queue.length; i++)
			{
				if (!this.queue[i].runs)
				{
					this.queue[i].endt = curr + this.queue[i].time;
					this.queue[i].runs = true;
				}
			}
			this.timer.start();
			this.running = true;
		}

		public function Stop():void
		{
			if (this.running)
			{
				this.timer.reset();
				this.running = false;
			}
		}

		public function OnTimer(e:TimerEvent):void
		{
			var tmp:* = undefined;
			var curr:* = new Date().getTime();
			var i:* = 0;
			while (i < this.queue.length)
			{
				if (Boolean(this.queue[i].runs) && this.queue[i].endt <= curr)
				{
					tmp = this.queue[i];
					this.queue.splice(i, 1);
					tmp.func.apply(tmp.inst, tmp.vars);
					tmp = null;
				}
				else
				{
					i++;
				}
			}
			if (this.queue.length < 1)
			{
				this.timer.reset();
				this.running = false;
				if (typeof this.onReady == "function")
				{
					this.onReady.apply(null, []);
				}
			}
		}

		public function AddFunction(atime:Number, afunc:Function, avars:Array = null):*
		{
			var curr:* = new Date().getTime();
			var to:* = {};
			to.time = atime * 1000;
			to.endt = 0;
			to.inst = null;
			to.func = afunc;
			to.vars = avars;
			to.runs = false;
			this.queue.push(to);
		}

		public function AddMethod(atime:Number, ainst:Object, afunc:Function, avars:Array = null):*
		{
			var curr:* = new Date().getTime();
			var to:* = {};
			to.time = atime * 1000;
			to.endt = 0;
			to.inst = ainst;
			to.func = afunc;
			to.vars = avars;
			to.runs = false;
			this.queue.push(to);
		}
	}
}
