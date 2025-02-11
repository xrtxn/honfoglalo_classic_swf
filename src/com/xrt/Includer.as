package com.xrt
{
    import uibase.*;
    import tournament.TournamentWin;
    import friendlygame.FriendlyGame;
    import tutorial.Tutorial;
    import minitournament.MinitournamentWin;
    import wrongquestion.WrongQuestion;
    import gameover.GameOver;
    import uibase.gfx.conn_error_graphics;
    import villagemap.compat.VillagemapInclude;
    import uibase.gfx.gold;
    import uibase.gfx.invalidgfx;
    import friendlygame.compat.ScrollBarMov8;
    import friendlygame.FriendlyInclude;
    import triviador.TriviadorInclude;

    public class Includer
    {
        private var _ui:UIInclude;
        private var _fr:FriendlyInclude;
        private var _tr:TriviadorInclude;

        private var _dummy1:ConnectWait;
        private var _dummy2:LoginScreen;
        private var _dummy3:LoadWait;
        private var _dummy4:Notifications;
        private var _dummy5:TournamentWin;
        private var _dummy7:NotificationsOpener;
        private var _dummy8:NotificationsBg;
        private var _dummy9:MessageWin;
        private var _dummy10:FriendlyGame;
        private var _dummy12:WaitAnim;
        private var _dummy27:ShineEffect;
        private var _dummy28:WaveAnim;
        private var _dummy29:Tutorial;
        private var _dummy30:MinitournamentWin;
        private var _dummy31:WrongQuestion;
        private var _dummy32:DebugInfo;
        private var _dummy33:GameOver;
        private var _dummy34:conn_error_graphics;
        private var _dummy35:VillagemapInclude;
        private var _dummy37:gold;
        private var _dummy38:invalidgfx;

        private var _dummy39:friendlygame.compat.ScrollBarMov7;
        private var _dummy40:friendlygame.compat.ScrollBarMov8;
        private var _dummy41:friendlygame.compat.ScrollBarMov9;
        private var _dummy42:TabMov;

        public static function Include():void
        {
            throw new Error("This is an include file, do not instantiate it.");
        }
    }
}
