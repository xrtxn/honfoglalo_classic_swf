package uibase.stub
{
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    public class Pool
    {
        public static var pool:Dictionary = new Dictionary();

        public static function Get(cls:Class):*
        {
            var className:String = getQualifiedClassName(cls);
            if (!pool[className] || pool[className].length === 0)
            {
                return new cls();
            }
            return pool[className].pop();
        }

        public static function Put(obj:*):void
        {
            var className:String = getQualifiedClassName(obj);
            if (!pool[className])
            {
                pool[className] = [];
            }
            pool[className].push(obj);
        }

        public static function Clear(cls:Class):void
        {
            var className:String = getQualifiedClassName(cls);
            delete pool[className];
        }
    }
}