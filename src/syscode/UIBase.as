package syscode
{
    public class UIBase
    {
        public static function Init():*
        {
        }

        public static function ShowWaitAnim():*
        {
            Modules.GetClass("uibase", "uibase.WaitAnim").ShowWaitAnim();
        }

        public static function HideWaitAnim():*
        {
            Modules.GetClass("uibase", "uibase.WaitAnim").HideWaitAnim();
        }

        public static function ShowMessage(atitle:String, amessage:String, acallbackfunc:Function = null, icon:int = 1):void
        {
            Modules.GetClass("uibase", "uibase.MessageWin").Show(atitle, amessage, acallbackfunc, icon);
        }

        public static function AskYesNo(atitle:String, amsg:String, abtn1:String, abtn2:String, acallbackfunc:Function, acallbackparams:Array = null):void
        {
            Modules.GetClass("uibase", "uibase.MessageWin").AskYesNo(atitle, amsg, abtn1, abtn2, acallbackfunc, acallbackparams);
        }

        public function UIBase()
        {
            super();
        }
    }
}
