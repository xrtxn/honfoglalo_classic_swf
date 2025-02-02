package com.xrt
{
    import uibase.*;

    public class Includer
    {

        private var _dummy:Class = ConnectWait;
        private var _dummy2:Class = LoginScreen;
        private var _dummy3:Class = LoadWait;
        private var _dummy4:Class = Notifications;

        public static function Include():void
        {
            throw new Error("This is an include file, do not instantiate it.");
        }
    }
}
