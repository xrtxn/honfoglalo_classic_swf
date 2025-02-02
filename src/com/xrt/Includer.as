package com.xrt
{
    import uibase.*;
    import tournament.TournamentWin;
    import villagemap.VillageMap;
    import friendlygame.FriendlyGame;

    public class Includer
    {

        private var _dummy1:Class = ConnectWait;
        private var _dummy2:Class = LoginScreen;
        private var _dummy3:Class = LoadWait;
        private var _dummy4:Class = Notifications;
        private var _dummy5:Class = TournamentWin;
        private var _dummy6:Class = VillageMap;
        private var _dummy7:Class = NotificationsOpener;
        private var _dummy8:Class = NotificationsBg;
        private var _dummy9:Class = MessageWin;
        private var _dummy10:Class = FriendlyGame;

        public static function Include():void
        {
            throw new Error("This is an include file, do not instantiate it.");
        }
    }
}
