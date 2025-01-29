package
{
    import flash.display.MovieClip;

    import syscode.SysInit;

    public class syscode extends MovieClip
    {
        public function syscode()
        {
            super();
        }

        public function Start(arootmc:MovieClip, aloadermc:MovieClip, abootparams:Object):*
        {
            abootparams.syscodemc = this;
            SysInit.StartLoading(arootmc, aloadermc, abootparams);
        }
    }
}
