package com.xrt
{
    import uibase.*;
    import tournament.TournamentWin;

    public class Includer
    {

        private var _dummy:Class = ConnectWait;
        private var _dummy2:Class = LoginScreen;
        private var _dummy3:Class = LoadWait;
        private var _dummy4:Class = Notifications;
        private var _dummy5:Class = TournamentWin;

        public static function Include():void
        {
            throw new Error("This is an include file, do not instantiate it.");
        }
    }
}
