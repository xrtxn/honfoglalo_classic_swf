package syscode
{
    public class MyTrace
    {
        public static var hilights:* = ["!", "FriendlyGame", "error", "OpenWindow"];

        public static var hides:* = ["global error logger ready", "WARNING: For content targeting Flash Player version 14 or higher"];

        public static var tracelog:Array = [];

        public static function myTrace(param1:*):void
        {
            var _loc3_:* = undefined;
            var _loc4_:* = String(param1 += " ");
            var _loc5_:Boolean = false;
            for (_loc3_ in hilights)
            {
                if (_loc4_.indexOf(hilights[_loc3_]) > -1)
                {
                    _loc5_ = true;
                }
            }
            for (_loc3_ in hides)
            {
                if (_loc4_.indexOf(hides[_loc3_]) > -1)
                {
                    return;
                }
            }
            tracelog.push("•" + _loc4_.replace(/\n/g, "|"));
            if (tracelog.length > 10)
            {
                tracelog = tracelog.slice(1, 10);
            }
            if (_loc5_)
            {
                _loc4_ = "│ " + _loc4_ + " │";
                trace("┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────".substr(0, _loc4_.length - 2) + "─┐");
                trace(_loc4_);
                trace("└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────".substr(0, _loc4_.length - 2) + "─┘");
            }
            else
            {
                trace("•", _loc4_);
            }
        }

        public function MyTrace()
        {
            super();
        }
    }
}
