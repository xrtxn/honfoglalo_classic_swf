package syscode.imitation
{
    import com.adobe.utils.AGALMiniAssembler;

    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.geom.*;
    import flash.utils.*;

    import syscode.Imitation;

    public class GpuShader
    {
        public static var active_program:Program3D = null;

        public static var programs:Vector.<Program3D> = null;

        public static var alphamaskprogram:Program3D = null;

        private static var alphavec:Vector.<Number> = new <Number>[1, 1, 1, 1];

        private static var m44vec:Vector.<Number> = new <Number>[1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];

        private static var lastalpha:Number = 0;

        private static var texalignvec:Vector.<Number> = new <Number>[1, 1, 0, 0];

        public static function Init():void
        {
            programs = new Vector.<Program3D>();
            programs[0] = CreateProgram(["m44  op, va0, vc0", "mul  vt0, va0, vc4.xy", "add  v0, vt0, vc4.zw"].join("\n"), ["tex   ft0, v0, fs0 <2d,nearest,nomip,clamp>", "mul   oc, ft0, fc0"].join("\n"));
            programs[1] = CreateProgram(["m44  op, va0, vc0", "mul  vt0, va0, vc4.xy", "add  v0, vt0, vc4.zw"].join("\n"), ["tex   ft0, v0, fs0 <2d,linear,nomip,clamp>", "mul   oc, ft0, fc0"].join("\n"));
            Select(true);
            Imitation.context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1, 1, 1, 1]));
            Imitation.context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, m44vec, 4);
            Imitation.context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, texalignvec);
        }

        public static function Select(texfilter:Boolean):void
        {
            var prg:Program3D = programs[texfilter ? 1 : 0];
            UseProgram(prg);
        }

        public static function UseProgram(prg:Program3D):void
        {
            if (prg != active_program)
            {
                active_program = prg;
                Imitation.context.setProgram(prg);
                Imitation.context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            }
        }

        public static function CreateProgram(vsrc:String, fsrc:String):Program3D
        {
            var prg:Program3D = Imitation.context.createProgram();
            var assembler:AGALMiniAssembler = new AGALMiniAssembler();
            var vertexShader:ByteArray = assembler.assemble(Context3DProgramType.VERTEX, vsrc);
            var fragmentShader:ByteArray = assembler.assemble(Context3DProgramType.FRAGMENT, fsrc);
            prg.upload(vertexShader, fragmentShader);
            Imitation.context.setProgram(prg);
            return prg;
        }

        public static function SetMatrixAlpha(mat:Matrix, cmul:Vector.<Number>):void
        {
            m44vec[0] = mat.a;
            m44vec[1] = mat.c;
            m44vec[3] = mat.tx;
            m44vec[4] = mat.b;
            m44vec[5] = mat.d;
            m44vec[7] = mat.ty;
            Imitation.context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, m44vec, 4);
            Imitation.context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, cmul);
        }

        public static function SetTexture(atex:Texture, aw:Number, ah:Number, ax:Number = 0, ay:Number = 0):void
        {
            Imitation.context.setTextureAt(0, atex);
            texalignvec[0] = aw;
            texalignvec[1] = ah;
            texalignvec[2] = ax;
            texalignvec[3] = ay;
            Imitation.context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, texalignvec);
        }

        public static function SetMaskTexture(atex:Texture):void
        {
            Imitation.context.setTextureAt(1, atex);
        }

        public function GpuShader()
        {
            super();
        }
    }
}
