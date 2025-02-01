package com.xrt
{
    import uibase.*;

    public class Includer
    {

        private var _dummy:Class = ConnectWait;
        private var _dummy2:Class = LoginScreen;

        public static function Include():void
        {
            throw new Error("This is an include file, do not instantiate it.");
        }
    }
}
