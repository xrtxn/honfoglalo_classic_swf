package syscode
{
    import flash.external.ExternalInterface;

    public class BrowserVideoad
    {
        public static var videoad_data:* = null;

        public static var need_in_village_autoplay:Boolean = false;

        public static function OpenExternalInterface(callback:Function = null):void
        {
            if (Config.inbrowser)
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.addCallback("ClientVisible", callback);
                }
            }
        }

        public static function CheckBrowserVideoAd():Boolean
        {
            if (Sys.mydata.xplevel < 11)
            {
                return false;
            }
            if (Config.inbrowser)
            {
                if (ExternalInterface.available)
                {
                    videoad_data = Util.ExternalCall("client_CheckVideoAds");
                    if (videoad_data && videoad_data != false)
                    {
                        if (videoad_data.total > 0)
                        {
                            return true;
                        }
                        return false;
                    }
                    return false;
                }
                return false;
            }
            return false;
        }

        public function BrowserVideoad()
        {
            super();
        }
    }
}
