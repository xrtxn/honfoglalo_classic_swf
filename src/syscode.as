package
{
    import flash.display.MovieClip;

    import syscode.SysInit;

    import com.xrt.Includer;

    public class syscode extends MovieClip
    {
        protected var _dummy:Class = Includer;
        
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
