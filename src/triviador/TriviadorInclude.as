package triviador
{
    import triviador.compat.TriviadorCompatInclude;
    import triviador.gfx.TriviadorGfxInclude;

    public class TriviadorInclude
    {
        private var _tc:TriviadorCompatInclude;
        private var _tg:TriviadorGfxInclude;

        public function TriviadorInclude():void
        {
            throw new Error("This is an include file, do not instantiate it.");
        }
    }
}
