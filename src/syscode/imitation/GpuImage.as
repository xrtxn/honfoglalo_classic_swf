package syscode.imitation
{
    import flash.display.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.geom.*;
    import flash.utils.getTimer;

    import syscode.Imitation;

    public class GpuImage
    {
        public static var textureCount:uint = 0;

        public static var textureSurface:uint = 0;

        public static var renderCount:uint = 0;

        public static var renderSurface:uint = 0;

        public static var renderCollect:Boolean = false;

        public static var generateCount:uint = 0;

        public static var generateTime:uint = 0;

        private static var bdpool:Object = {};

        private static var clearrect:Rectangle = new Rectangle(0, 0, 1, 1);

        public static function AllocateBitmapData(texw:int, texh:int, clrw:int, clrh:int):BitmapData
        {
            var bd:BitmapData = bdpool[(texw << 16) + texh];
            if (bd)
            {
                clearrect.width = clrw + 2;
                clearrect.height = clrh + 2;
                bd.fillRect(clearrect, 0);
            }
            else
            {
                bd = new BitmapData(texw, texh, true, 0);
            }
            return bd;
        }

        public static function ReleaseBitmapData(bd:BitmapData):void
        {
            if (bd.width * bd.height <= 131072)
            {
                bdpool[(bd.width << 16) + bd.height] = bd;
            }
            else
            {
                bd.dispose();
            }
        }

        public static function CalculatePot(asize:Number):int
        {
            var e:int = Math.ceil(Math.log(Math.ceil(asize)) / Math.LN2);
            var res:* = 1 << e;
            if (res > Imitation.maxtexturesize)
            {
                res = Imitation.maxtexturesize;
            }
            return res;
        }

        public function GpuImage(awidth:Number, aheight:Number, arendertarget:Boolean = false)
        {
            super();
            this.imagewidth = awidth;
            this.imageheight = aheight;
            this.rendertarget = arendertarget;
            this.texwidth = CalculatePot(this.imagewidth);
            if (this.texwidth < 1)
            {
                this.texwidth = 1;
            }
            this.texheight = CalculatePot(this.imageheight);
            if (this.texheight < 1)
            {
                this.texheight = 1;
            }
            var c:Context3D = Imitation.context;
            if (!Imitation.texturerendering)
            {
                arendertarget = false;
            }
            this.tex = c.createTexture(this.texwidth, this.texheight, Context3DTextureFormat.BGRA, this.rendertarget);
            this.drawmatrix = new Matrix();
            this.drawmatrix.a = this.imagewidth;
            this.drawmatrix.d = this.imageheight;
            this.tmatrix = new Matrix();
            ++GpuImage.textureCount;
            GpuImage.textureSurface += this.texwidth * this.texheight * 4;
        }
        public var tex:Texture = null;
        public var rendertarget:Boolean = false;
        public var texwidth:int = 1;
        public var texheight:int = 1;
        public var texx:Number = 0;
        public var texy:Number = 0;
        public var imagewidth:Number = 1;
        public var imageheight:Number = 1;
        public var clipwidth:Number = 1;
        public var clipheight:Number = 1;
        public var drawmatrix:Matrix = null;
        private var tmatrix:Matrix = null;

        public function Dispose():void
        {
            if (this.tex)
            {
                this.tex.dispose();
            }
            this.tex = null;
            this.drawmatrix = null;
            this.tmatrix = null;
            --GpuImage.textureCount;
            GpuImage.textureSurface -= this.texwidth * this.texheight * 4;
        }

        public function SetImageSize(awidth:Number, aheight:Number):void
        {
            this.imagewidth = awidth;
            this.imageheight = aheight;
            this.drawmatrix.a = this.imagewidth;
            this.drawmatrix.d = this.imageheight;
        }

        public function DrawObj(aobj:DisplayObject, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:String = null, clipRect:Rectangle = null, smoothing:Boolean = false):void
        {
            var t1:int = getTimer();
            var bd:BitmapData = AllocateBitmapData(this.texwidth, this.texheight, this.imagewidth, this.imageheight);
            var m2:Matrix = matrix.clone();
            if (m2.a <= 0.1 || aobj.transform.matrix.a >= 10)
            {
                m2.scale(1 + 1 / this.texwidth, 1 + 1 / this.texheight);
            }
            bd.draw(aobj, m2, colorTransform, blendMode, clipRect, smoothing);
            var t2:int = getTimer();
            this.tex.uploadFromBitmapData(bd, 0);
            ReleaseBitmapData(bd);
            bd = null;
            this.UpdateDrawMatrix(matrix);
            var t3:int = getTimer();
            ++GpuImage.generateCount;
            GpuImage.generateTime += t3 - t1;
        }

        public function UpdateDrawMatrix(matrix:Matrix):void
        {
            this.drawmatrix.a = this.imagewidth / matrix.a;
            this.drawmatrix.b = 0;
            this.drawmatrix.c = 0;
            this.drawmatrix.d = this.imageheight / matrix.d;
            this.drawmatrix.tx = -matrix.tx / matrix.a;
            this.drawmatrix.ty = -matrix.ty / matrix.d;
        }

        public function Render(rmatrix:Matrix, cmul:Vector.<Number>, animated:Boolean):void
        {
            if (!this.tmatrix || !this.drawmatrix)
            {
                return;
            }
            this.tmatrix.copyFrom(this.drawmatrix);
            this.tmatrix.tx += this.texx * this.tmatrix.a / this.imagewidth;
            this.tmatrix.ty += this.texy * this.tmatrix.d / this.imageheight;
            var sx:* = (this.clipwidth - this.texx) / this.imagewidth * this.tmatrix.a;
            var sy:* = (this.clipheight - this.texy) / this.imageheight * this.tmatrix.d;
            if (sx < 0 || sy < 0)
            {
                return;
            }
            if (sx < 1.5 && sy < 1.5)
            {
                return;
            }
            this.tmatrix.a = sx;
            this.tmatrix.d = sy;
            this.tmatrix.concat(rmatrix);
            var AW:Number = Imitation.activerenderhalfwidth;
            var AH:Number = Imitation.activerenderhalfheight;
            var MW:Number = AW - int(AW);
            var MH:Number = AH - int(AH);
            if (this.tmatrix.b != 0 || this.tmatrix.c != 0 || Math.abs(this.tmatrix.a - this.clipwidth / Imitation.activerenderhalfwidth) > Imitation.activerenderpix || Math.abs(this.tmatrix.d + this.clipheight / Imitation.activerenderhalfheight) > Imitation.activerenderpix || animated)
            {
                GpuShader.Select(true);
            }
            else
            {
                this.tmatrix.tx = (Math.round(this.tmatrix.tx * AW) - MW) / AW;
                this.tmatrix.ty = (Math.round(this.tmatrix.ty * AH) - MH) / AH;
                GpuShader.Select(true);
            }
            GpuShader.SetMatrixAlpha(this.tmatrix, cmul);
            GpuShader.SetTexture(this.tex, 1 / (this.texwidth / (this.clipwidth - this.texx)), 1 / (this.texheight / (this.clipheight - this.texy)), this.texx / this.texwidth, this.texy / this.texheight);
            Imitation.DrawQuad();
            if (GpuImage.renderCollect)
            {
                ++GpuImage.renderCount;
                GpuImage.renderSurface += this.clipwidth * this.clipheight;
            }
        }
    }
}
