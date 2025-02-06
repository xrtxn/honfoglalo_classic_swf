package uibase.stub
{
    import flash.display.BitmapData;

    public class BitmapDataPool
    {
        public static var pool:Array = [];
        public static var stat_pop:int = 0;
        public static var stat_new:int = 0;
        public static var stat_push:int = 0;

        public static function Get(width:int, height:int, transparent:Boolean = true, fillColor:uint = 0xFFFFFFFF):BitmapData
        {
            if (pool.length > 0)
            {
                stat_pop++;
                var bmd:BitmapData = pool.pop();
                bmd.fillRect(bmd.rect, fillColor);
                return bmd;
            }
            stat_new++;
            return new BitmapData(width, height, transparent, fillColor);
        }

        public static function Put(bmd:BitmapData):void
        {
            stat_push++;
            if (pool.indexOf(bmd) === -1)
            {
                pool.push(bmd);
            }
        }

        public static function Clear():void
        {
            while (pool.length > 0)
            {
                pool.pop().dispose();
            }
            stat_pop = 0;
            stat_new = 0;
            stat_push = 0;
        }
    }
}