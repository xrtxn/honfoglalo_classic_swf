package syscode.imitation
{
    import com.mywebzz.utils.text.TextFieldHealer;

    import flash.display.*;
    import flash.events.*;
    import flash.filters.BlurFilter;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.filters.GradientBevelFilter;
    import flash.filters.GradientGlowFilter;
    import flash.geom.*;
    import flash.text.*;

    import syscode.Imitation;

    public class Imitator
    {
        public static var imid:int = 0;

        public static var count:int = 0;

        public static var containers:int = 0;

        public static var nulls:int = 0;

        public static var instances:* = {};

        public function Imitator(aparent:Imitator, aobj:DisplayObject, act:ColorTransform = null)
        {
            this.drawmat = new Matrix();
            this.lastmat = new Matrix();
            super();
            ++Imitator.imid;
            this.id = Imitator.imid;
            this.parent = aparent;
            this.obj = aobj;
            Imitation.imitators[aobj] = this;
            if (this.obj)
            {
                ++Imitator.count;
            }
            if (!Imitation.usegpu && this.fspr == null)
            {
                this.fspr = new Sprite();
            }
            if (this.children == null)
            {
                this.children = new Vector.<Imitator>();
            }
            if (this.fchildren == null)
            {
                this.fchildren = new Vector.<DisplayObject>();
            }
            this.colorTransform = act;
            this.CollectChildren();
            if (this.obj is DisplayObjectContainer)
            {
                ++Imitator.containers;
            }
        }
        public var id:int = 0;
        public var path:String = "";
        public var time:int = 0;
        public var next:Imitator;
        public var parent:Imitator;
        public var obj:DisplayObject;
        public var children:Vector.<Imitator> = null;
        public var fchildren:Vector.<DisplayObject> = null;
        public var changed:Boolean = false;
        public var bitmapscale:Number = 0;
        public var lastbitmapscale:Number = 0;
        public var boundsborder:Number = 0;
        public var bitmapped:Boolean = false;
        public var combined:Boolean = false;
        public var bitmapdata:BitmapData = null;
        public var fbitmap:Bitmap = null;
        public var gimage:GpuImage = null;
        public var maskedgimage:GpuImage = null;
        public var colorTransform:ColorTransform = null;
        public var colorMultiplier:ColorTransform = null;
        public var fspr:Sprite = null;
        public var text:String = null;
        public var input:TextField = null;
        public var inputenabled:Boolean = true;
        public var maskedchild:Imitator = null;
        public var mask:Imitator = null;
        public var alphamask:Boolean = false;
        public var changingmask:Boolean = false;
        public var cloneof:Imitator = null;
        public var drawmat:Matrix;
        public var lastmat:Matrix;
        public var animcnt:int = 0;
        public var hot_updated:Number = 0;
        public var hot2:Number = 0;
        public var rtl:Boolean = false;
        public var rtl_util:RtlUtil = null;

        public function Dispose():*
        {
            --Imitator.count;
            this.FreeBitmap();
            if (this.input != null)
            {
                if (this.input.parent)
                {
                    this.input.parent.removeChild(this.input);
                }
                this.input = null;
            }
            if (this.rtl_util)
            {
                this.rtl_util.Dispose();
            }
            if (this.obj)
            {
                delete Imitation.imitators[this.obj];
                if (this.obj is DisplayObjectContainer)
                {
                    --Imitator.containers;
                }
            }
            var i:* = 0;
            while (i < this.children.length)
            {
                this.children[i].Dispose();
                i++;
            }
            this.children.length = 0;
            this.fchildren.length = 0;
            this.obj = null;
            this.parent = null;
            this.maskedchild = null;
            this.mask = null;
            this.alphamask = false;
            this.changingmask = false;
            this.cloneof = null;
        }

        public function FindImitator(dobj:DisplayObject):Imitator
        {
            return Imitation.imitators[dobj];
        }

        public function UpdateInput(tf:TextField):void
        {
            if (!this.inputenabled)
            {
                if (this.input)
                {
                    if (this.input.parent)
                    {
                        this.input.parent.removeChild(this.input);
                    }
                    this.input = null;
                }
                return;
            }
            if (this.input == null)
            {
                this.input = new TextField();
                this.input.type = TextFieldType.INPUT;
                this.input.defaultTextFormat = tf.defaultTextFormat;
                this.input.multiline = tf.multiline;
                this.input.wordWrap = tf.wordWrap;
                this.input.textColor = tf.textColor;
                this.input.backgroundColor = tf.backgroundColor;
                this.input.background = tf.background;
                this.input.border = tf.border;
                this.input.borderColor = tf.borderColor;
                this.input.embedFonts = tf.embedFonts;
                this.input.displayAsPassword = tf.displayAsPassword;
                this.input.filters = tf.filters;
                this.input.restrict = tf.restrict;
                this.input.maxChars = tf.maxChars;
                this.input.x = tf.x;
                this.input.y = tf.y;
                this.input.width = tf.width;
                this.input.height = tf.height;
                Imitation.stage.addChild(this.input);
                this.input.name = tf.name;
                if (this.rtl)
                {
                    if (this.rtl_util != null)
                    {
                        this.rtl_util.Dispose();
                    }
                    this.rtl_util = new RtlUtil();
                    this.rtl_util.RTLEditSetup(this.input);
                }
                else
                {
                    new TextFieldHealer(this.input);
                }
                this.text = tf.text;
                this.input.text = this.text;
            }
            if (this.rtl && this.rtl_util != null && this.rtl_util.eo != null)
            {
                if (this.rtl_util.eo.realtext != tf.text)
                {
                    if (tf.text == this.text)
                    {
                        this.text = this.rtl_util.eo.realtext;
                        tf.text = this.text;
                        tf.dispatchEvent(new Event(Event.CHANGE, true));
                    }
                    else
                    {
                        this.text = tf.text;
                        this.rtl_util.SetRTLEditText(this.text);
                    }
                }
            }
            else if (this.input.text != tf.text)
            {
                if (tf.text == this.text)
                {
                    this.text = this.input.text;
                    tf.text = this.text;
                    tf.dispatchEvent(new Event(Event.CHANGE, true));
                }
                else
                {
                    this.text = tf.text;
                    this.input.text = this.text;
                }
            }
            var m1:Matrix = this.input.transform.matrix;
            var m2:Matrix = this.BuildMatrix(tf);
            if (m1.a != m2.a || m1.b != m2.b || m1.c != m2.c || m1.d != m2.d || m1.tx != m2.tx || m1.ty != m2.ty)
            {
                this.input.transform.matrix = m2;
            }
            if (this.input.alpha != tf.alpha)
            {
                this.input.alpha = tf.alpha;
            }
            if (this.input.visible != tf.visible)
            {
                this.input.visible = tf.visible;
            }
            if (this.input.restrict != tf.restrict)
            {
                this.input.restrict = tf.restrict;
            }
            if (this.input.maxChars != tf.maxChars)
            {
                this.input.maxChars = tf.maxChars;
            }
        }

        public function UpdateProperties():*
        {
            var tf:TextField = null;
            var v:Boolean = false;
            var m1:Matrix = null;
            var m2:Matrix = null;
            var mp:* = undefined;
            if (this.obj is TextField)
            {
                tf = this.obj as TextField;
                if (tf.type == TextFieldType.DYNAMIC)
                {
                    if (tf.text != this.text)
                    {
                        this.FreeBitmap();
                    }
                    this.text = tf.text;
                }
                else if (tf.type == TextFieldType.INPUT)
                {
                    this.UpdateInput(tf);
                    if (this.inputenabled)
                    {
                        return;
                    }
                }
            }
            if (this.fspr)
            {
                if (this.obj.transform.matrix)
                {
                    m1 = this.fspr.transform.matrix;
                    m2 = this.obj.transform.matrix;
                    if (m1.a != m2.a || m1.b != m2.b || m1.c != m2.c || m1.d != m2.d || m1.tx != m2.tx || m1.ty != m2.ty)
                    {
                        this.fspr.transform.matrix = m2;
                    }
                }
                if (Boolean(this.colorMultiplier) && this.colorMultiplier != this.fspr.transform.colorTransform)
                {
                    this.fspr.transform.colorTransform = this.colorMultiplier;
                }
                if (Imitation.showregions)
                {
                    mp = Imitation.GetMousePos();
                    this.fspr.x += (mp.x - Imitation.stage.stageWidth / 2) / 50;
                    this.fspr.y += (mp.y - Imitation.stage.stageHeight / 2) / 50;
                }
                if (this.fspr.alpha != this.obj.alpha)
                {
                    this.fspr.alpha = this.obj.alpha;
                }
                v = this.obj.visible;
                if (Boolean(this.parent) && this.parent.combined)
                {
                    v = false;
                }
                if (this.fspr.visible != v)
                {
                    this.fspr.visible = v;
                }
                m1 = null;
                m2 = null;
            }
        }

        public function UpdateAll():*
        {
            var len:int = 0;
            var i:int = 0;
            if (this.changed)
            {
                this.changed = false;
                this.CollectChildren();
            }
            this.UpdateProperties();
            if (this.obj is TextField && (this.obj as TextField).type == TextFieldType.INPUT)
            {
                if (this.inputenabled)
                {
                    this.FreeBitmap();
                    return;
                }
            }
            if (!this.obj.visible)
            {
                return;
            }
            if (!this.bitmapped && !this.combined && !this.obj.cacheAsBitmap)
            {
                len = int(this.children.length);
                i = 0;
                while (i < len)
                {
                    this.children[i].UpdateAll();
                    i++;
                }
            }
            else if (this.children.length > 0)
            {
                this.CollectChildren();
            }
            if (Boolean(this.maskedchild) && Imitation.usegpu)
            {
                this.UpdateMaskedTexture();
            }
            else if (this.combined)
            {
                if (!this.bitmapped)
                {
                    i = 0;
                    while (i < this.children.length)
                    {
                        this.children[i].UpdateAll();
                        i++;
                    }
                    if (Imitation.usegpu)
                    {
                        if (Imitation.texturerendering)
                        {
                            this.CombineToTexture();
                        }
                        else
                        {
                            this.CombineToBitmap();
                        }
                    }
                    else
                    {
                        this.CombineToBitmap();
                    }
                }
            }
            else if (!this.bitmapped && (!(this.obj is DisplayObjectContainer) || this.obj.cacheAsBitmap))
            {
                this.UpdateBitmap();
            }
        }

        public function FreeBitmap():void
        {
            if (this.bitmapped)
            {
            }
            if (this.gimage)
            {
                this.gimage.Dispose();
                this.gimage = null;
            }
            if (this.maskedgimage)
            {
                this.maskedgimage.Dispose();
                this.maskedgimage = null;
            }
            if (this.bitmapdata)
            {
                this.bitmapdata.dispose();
                this.bitmapdata = null;
            }
            if (this.fbitmap)
            {
                if (this.fbitmap.parent)
                {
                    this.fbitmap.parent.removeChild(this.fbitmap);
                }
                this.fbitmap = null;
            }
            this.bitmapped = false;
        }

        public function FreeBitmapAll():void
        {
            this.FreeBitmap();
            var i:int = 0;
            while (i < this.children.length)
            {
                this.children[i].FreeBitmapAll();
                i++;
            }
        }

        public function EnableInput(aenable:Boolean):void
        {
            var i:int = 0;
            if (this.obj is TextField)
            {
                this.inputenabled = aenable;
                this.UpdateProperties();
            }
            else
            {
                i = 0;
                while (i < this.children.length)
                {
                    this.children[i].EnableInput(aenable);
                    i++;
                }
            }
        }

        public function SetBitmapScale(ascale:Number):void
        {
            if (ascale == this.bitmapscale)
            {
                return;
            }
            this.bitmapscale = ascale;
            if (this.bitmapped)
            {
                this.FreeBitmap();
            }
        }

        public function CalculateBitmapScale(aobj:DisplayObject):Number
        {
            var bounds:Rectangle = this.GetFilteredBounds(this.obj);
            var displaybounds:Rectangle = this.obj.getBounds(Imitation.rootmc);
            displaybounds.width *= Imitation.rootmc.scaleX;
            displaybounds.height *= Imitation.rootmc.scaleY;
            if (displaybounds.width < 1)
            {
                displaybounds.width = 1;
            }
            if (displaybounds.height < 1)
            {
                displaybounds.height = 1;
            }
            var bestbmpscale:Number = displaybounds.width / bounds.width;
            var bmsy:Number = displaybounds.height / bounds.height;
            if (bmsy > bestbmpscale)
            {
                bestbmpscale = bmsy;
            }
            var bmpsmod:Number = 1;
            var im:Imitator = this;
            while (im)
            {
                if (im.bitmapscale > 0)
                {
                    bmpsmod *= im.bitmapscale;
                }
                else if (im.bitmapscale < 0)
                {
                    bestbmpscale = -im.bitmapscale;
                }
                im = im.parent;
            }
            var bmpscale:Number = bestbmpscale * bmpsmod;
            if (bounds.width * bmpscale > Imitation.maxtexturesize)
            {
                bmpscale = Imitation.maxtexturesize / bounds.width;
            }
            if (bounds.height * bmpscale > Imitation.maxtexturesize)
            {
                bmpscale = Imitation.maxtexturesize / bounds.height;
            }
            if (Imitation.restoring)
            {
                bmpscale = Math.max(this.lastbitmapscale, bmpscale);
            }
            this.lastbitmapscale = bmpscale;
            return bmpscale;
        }

        public function GpuMaskedRender(rmatrix:Matrix, ralpha:Number, animated:Boolean):void
        {
            var pscale:Number = NaN;
            var dmat:Matrix = null;
            if (!this.alphamask)
            {
                pscale = this.gimage.imagewidth / this.gimage.drawmatrix.a;
                Imitation.SetRenderTarget(this, this.gimage.texwidth, this.gimage.texheight);
                dmat = new Matrix();
                dmat.concat(rmatrix);
                this.maskedchild.GpuRender(dmat, ralpha, false);
                Imitation.SetRenderTarget(null);
            }
        }

        public function GpuRender(rmatrix:Matrix, ralpha:Number, skipmask:Boolean = true):void
        {
            var cm:ColorTransform = null;
            var cmult:Vector.<Number> = null;
            var clipbounds:Rectangle = null;
            var maskbounds:Rectangle = null;
            var ma:Matrix = null;
            var im:Imitator = null;
            if (!this.obj || !this.obj.visible)
            {
                return;
            }
            var dalpha:Number = ralpha * this.obj.alpha;
            if (this.maskedchild)
            {
                dalpha = ralpha * this.maskedchild.obj.alpha;
            }
            if (dalpha <= 0)
            {
                return;
            }
            if (Boolean(this.mask) && skipmask)
            {
                return;
            }
            this.drawmat.copyFrom(this.obj.transform.matrix);
            this.drawmat.concat(rmatrix);
            if (this.lastmat.a != this.drawmat.a || this.lastmat.b != this.drawmat.b || this.lastmat.c != this.drawmat.c || this.lastmat.d != this.drawmat.d)
            {
                ++this.animcnt;
                this.lastmat.copyFrom(this.drawmat);
            }
            else
            {
                this.animcnt = 0;
            }
            var gimage:* = this.gimage;
            var cobj:* = this.obj;
            if (this.cloneof)
            {
                if (!this.cloneof.gimage)
                {
                    return;
                }
                gimage = this.cloneof.gimage;
                cobj = this.cloneof.obj;
            }
            if (gimage)
            {
                if (this.maskedchild)
                {
                    this.GpuMaskedRender(rmatrix, dalpha, this.animcnt >= 3);
                    return;
                }
                if (Imitation.activerendertarget)
                {
                    clipbounds = Imitation.activerendertarget.obj.getBounds(this.obj);
                    maskbounds = this.GetFilteredBounds(cobj);
                    gimage.texx = Math.max(0, (clipbounds.left - maskbounds.left) / gimage.drawmatrix.a * gimage.imagewidth);
                    gimage.texy = Math.max(0, (clipbounds.top - maskbounds.top) / gimage.drawmatrix.d * gimage.imageheight);
                    gimage.clipwidth = Math.min(gimage.imagewidth, (clipbounds.right - maskbounds.left) / gimage.drawmatrix.a * gimage.imagewidth);
                    gimage.clipheight = Math.min(gimage.imageheight, (clipbounds.bottom - maskbounds.top) / gimage.drawmatrix.d * gimage.imageheight);
                }
                else
                {
                    gimage.texx = 0;
                    gimage.texy = 0;
                    gimage.clipwidth = gimage.imagewidth;
                    gimage.clipheight = gimage.imageheight;
                }
                cm = this.colorMultiplier;
                if (cm)
                {
                    cmult = new <Number>[cm.redMultiplier * dalpha, cm.greenMultiplier * dalpha, cm.blueMultiplier * dalpha, dalpha];
                }
                else
                {
                    cmult = new <Number>[dalpha, dalpha, dalpha, dalpha];
                }
                gimage.Render(this.drawmat, cmult, this.animcnt >= 3);
                if (Boolean(Imitation.color_gimage) && this.hot_updated > 0)
                {
                    ma = new Matrix();
                    ma.scale(gimage.drawmatrix.a / 8, gimage.drawmatrix.d / 8);
                    ma.translate(gimage.drawmatrix.tx, gimage.drawmatrix.ty);
                    ma.concat(this.obj.transform.matrix);
                    ma.concat(rmatrix);
                    Imitation.color_gimage.Render(ma, new <Number>[1, 1, 1, Math.min(0.9, this.hot_updated / 1.5)], this.animcnt >= 3);
                    if (this.hot_updated > 1)
                    {
                        Imitation.color_gimage2.Render(ma, new <Number>[1, 1, 1, Math.min(0.9, this.hot_updated / 4)], this.animcnt >= 3);
                    }
                    this.hot_updated -= 0.05;
                    this.hot2 -= 0.05;
                    if (this.hot_updated <= 0)
                    {
                        this.hot2 = 0;
                    }
                }
            }
            if (!this.combined && !this.obj.cacheAsBitmap)
            {
                for each (im in this.children)
                {
                    im.GpuRender(this.drawmat, dalpha);
                }
            }
        }

        public function CombineToTexture():void
        {
            var im:Imitator = null;
            if (!Imitation.CheckContext())
            {
                return;
            }
            var bmpscale:Number = this.CalculateBitmapScale(this.obj);
            var bounds:Rectangle = this.GetFilteredBounds(this.obj);
            if (bounds.width * bmpscale > Imitation.maxtexturesize)
            {
                bmpscale = Imitation.maxtexturesize / bounds.width;
            }
            if (bounds.height * bmpscale > Imitation.maxtexturesize)
            {
                bmpscale = Imitation.maxtexturesize / bounds.height;
            }
            bounds.width *= bmpscale;
            bounds.height *= bmpscale;
            bounds.x *= bmpscale;
            bounds.y *= bmpscale;
            var objwidth:Number = bounds.width;
            var objheight:Number = bounds.height;
            if (!this.gimage || !this.gimage.rendertarget || this.gimage.texwidth < objwidth || this.gimage.texheight < objheight)
            {
                if (this.gimage)
                {
                    this.gimage.Dispose();
                }
                this.gimage = new GpuImage(objwidth, objheight, true);
            }
            else
            {
                this.gimage.SetImageSize(objwidth, objheight);
            }
            Imitation.context.setRenderToTexture(this.gimage.tex);
            Imitation.context.clear(0, 0, 0, 0);
            this.gimage.drawmatrix.a = this.gimage.imagewidth / bmpscale;
            this.gimage.drawmatrix.d = this.gimage.imageheight / bmpscale;
            this.gimage.drawmatrix.tx = bounds.x / bmpscale;
            this.gimage.drawmatrix.ty = bounds.y / bmpscale;
            var dmat:Matrix = new Matrix(1, 0, 0, 1, -bounds.x / bmpscale, -bounds.y / bmpscale);
            var pmat:Matrix = new Matrix(bmpscale * 2 / this.gimage.texwidth, 0, 0, -2 * bmpscale / this.gimage.texheight, -1, 1);
            dmat.concat(pmat);
            for each (im in this.children)
            {
                im.GpuRender(dmat, 1);
            }
            Imitation.context.setRenderToBackBuffer();
            this.bitmapped = true;
        }

        public function CombineToBitmap():void
        {
            var mat:Matrix = null;
            var bmpscale:Number = this.CalculateBitmapScale(this.obj);
            var bounds:Rectangle = this.GetFilteredBounds(this.obj);
            if (bounds.width * bmpscale > Imitation.maxtexturesize)
            {
                bmpscale = Imitation.maxtexturesize / bounds.width;
            }
            if (bounds.height * bmpscale > Imitation.maxtexturesize)
            {
                bmpscale = Imitation.maxtexturesize / bounds.height;
            }
            bounds.width *= bmpscale;
            bounds.height *= bmpscale;
            bounds.x *= bmpscale;
            bounds.y *= bmpscale;
            var objwidth:int = Math.ceil(bounds.width);
            var objheight:int = Math.ceil(bounds.height);
            if (this.bitmapdata && this.bitmapdata.width == objwidth && this.bitmapdata.height == objheight)
            {
                this.bitmapdata.fillRect(new Rectangle(0, 0, objwidth, objheight), 0);
            }
            else
            {
                this.FreeBitmap();
                this.bitmapdata = new BitmapData(objwidth, objheight, true, 0);
                this.fbitmap = new Bitmap(this.bitmapdata, "auto", true);
                this.fbitmap.scaleX = 1 / bmpscale;
                this.fbitmap.scaleY = 1 / bmpscale;
                this.fbitmap.x = this.fbitmap.scaleX * bounds.x;
                this.fbitmap.y = this.fbitmap.scaleY * bounds.y;
                if (this.fspr)
                {
                    this.fspr.addChild(this.fbitmap);
                }
            }
            var n:int = 0;
            while (n < this.children.length)
            {
                if (!(!this.children[n].obj.visible || Boolean(this.children[n].maskedchild)))
                {
                    mat = !this.children[n].fspr ? this.children[n].obj.transform.matrix : this.children[n].fspr.transform.matrix;
                    mat.scale(bmpscale, bmpscale);
                    mat.translate(-bounds.x, -bounds.y);
                    if (bmpscale <= 0.1)
                    {
                        mat.scale(1 + 0.5 / objwidth, 1 + 0.5 / objheight);
                    }
                    if (!this.children[n].fspr)
                    {
                        this.bitmapdata.draw(this.children[n].obj, mat, this.children[n].obj.transform.colorTransform, null, null, false);
                    }
                    else
                    {
                        this.bitmapdata.draw(this.children[n].fspr, mat, this.children[n].fspr.transform.colorTransform, null, null, false);
                    }
                }
                n++;
            }
            if (Imitation.usegpu)
            {
                if (!this.gimage || this.gimage.texwidth < objwidth || this.gimage.texheight < objheight)
                {
                    if (this.gimage)
                    {
                        this.gimage.Dispose();
                    }
                    this.gimage = new GpuImage(objwidth, objheight);
                }
                else
                {
                    this.gimage.SetImageSize(objwidth, objheight);
                }
                mat = new Matrix(bmpscale, 0, 0, bmpscale, -bounds.x, -bounds.y);
                this.gimage.DrawObj(this.fbitmap, new Matrix(), null, null, null, true);
                this.gimage.UpdateDrawMatrix(mat);
            }
            this.bitmapped = true;
        }

        public function Combine(acombined:Boolean):void
        {
            var i:int = 0;
            var im:Imitator = null;
            var prevvisible:Boolean = false;
            var v:Boolean = false;
            if (this.obj.cacheAsBitmap || this.children.length <= 0)
            {
                return;
            }
            this.combined = acombined;
            if (this.fspr)
            {
                i = 0;
                while (i < this.children.length)
                {
                    im = this.children[i];
                    prevvisible = this.fspr.visible;
                    v = !this.combined && im.obj.visible;
                    if (v != prevvisible)
                    {
                        this.fspr.visible = v;
                    }
                    i++;
                }
            }
            this.FreeBitmap();
            this.UpdateAll();
        }

        public function UpdateMaskedTexture():void
        {
            if (!Imitation.usegpu)
            {
                return;
            }
            if (!Imitation.CheckContext())
            {
                return;
            }
            if (!this.obj.visible)
            {
                return;
            }
            if (!this.bitmapped || this.changingmask)
            {
                if (this.obj.cacheAsBitmap)
                {
                    this.UpdateBitmap();
                }
                else if (!this.combined)
                {
                    this.Combine(true);
                }
                else if (Imitation.texturerendering)
                {
                    this.CombineToTexture();
                }
                else
                {
                    this.CombineToBitmap();
                }
            }
        }

        public function SetMaskedMov(aobj:DisplayObject, aalphamask:Boolean = false, achangingmask:Boolean = false):void
        {
            if (this.obj == aobj || !this.parent)
            {
                return;
            }
            if (!aobj)
            {
                if (this.maskedchild)
                {
                    if (!Imitation.usegpu)
                    {
                        this.UpdateAll();
                        this.maskedchild.fspr.cacheAsBitmap = false;
                        this.fspr.cacheAsBitmap = false;
                        this.maskedchild.fspr.mask = null;
                    }
                    else
                    {
                        this.FreeBitmap();
                        this.maskedchild.obj.mask = null;
                    }
                    this.maskedchild.mask = null;
                    this.maskedchild = null;
                }
                return;
            }
            var im:Imitator = this.parent.FindImitator(aobj);
            if (!im)
            {
                return;
            }
            if (Boolean(im.mask) && im.mask == this)
            {
                return;
            }
            this.maskedchild = im;
            this.maskedchild.mask = this;
            this.alphamask = aalphamask;
            this.changingmask = achangingmask;
            if (!Imitation.usegpu)
            {
                this.maskedchild.fspr.cacheAsBitmap = true;
                this.fspr.cacheAsBitmap = true;
                this.maskedchild.fspr.mask = this.fspr;
            }
            else
            {
                this.FreeBitmap();
                this.maskedchild.obj.mask = this.obj;
            }
        }

        public function GetFilteredBounds(obj:DisplayObject):Rectangle
        {
            var l:int = 0;
            var t:int = 0;
            var r:int = 0;
            var d:int = 0;
            var fx:int = 0;
            var fy:int = 0;
            var f:Object = null;
            var bounds:Rectangle = obj.getBounds(obj);
            if (bounds.width == 0 || bounds.height == 0)
            {
                return bounds;
            }
            for each (f in obj.filters)
            {
                l = 0;
                t = 0;
                r = 0;
                d = 0;
                fx = 0;
                fy = 0;
                if (!((f is GlowFilter || f is DropShadowFilter) && f.inner || (f is GradientGlowFilter || f is GradientBevelFilter) && f.type == "inner"))
                {
                    if (f is BlurFilter || f is DropShadowFilter || f is GlowFilter || f is GradientGlowFilter || f is GradientBevelFilter)
                    {
                        l = r = f.blurX / 2 * f.quality;
                        t = d = f.blurY / 2 * f.quality;
                    }
                    if (f is DropShadowFilter || f is GradientGlowFilter || f is GradientBevelFilter)
                    {
                        fx = f.distance * Math.cos(f.angle / 180 * Math.PI);
                        fy = f.distance * Math.sin(f.angle / 180 * Math.PI);
                    }
                    l = Math.max(0, l - fx);
                    r = Math.max(0, r + fx);
                    t = Math.max(0, t - fy);
                    d = Math.max(0, d + fy);
                    bounds.width += l + r;
                    bounds.height += t + d;
                    bounds.x -= l;
                    bounds.y -= t;
                }
            }
            if (this.boundsborder)
            {
                bounds.width += this.boundsborder * 2;
                bounds.height += this.boundsborder * 2;
                bounds.x -= this.boundsborder;
                bounds.y -= this.boundsborder;
            }
            return bounds;
        }

        public function UpdateBitmap():void
        {
            var texw:int = 0;
            var texh:int = 0;
            var ax:* = undefined;
            var ay:* = undefined;
            this.FreeBitmap();
            if (!Imitation.CheckContext())
            {
                return;
            }
            if (this.cloneof)
            {
                if (!this.cloneof.bitmapped)
                {
                    this.cloneof.UpdateBitmap();
                }
                if (!Imitation.usegpu)
                {
                    this.fbitmap = new Bitmap(this.cloneof.bitmapdata, "auto", true);
                    this.fbitmap.scaleX = this.cloneof.fbitmap.scaleX;
                    this.fbitmap.scaleY = this.cloneof.fbitmap.scaleY;
                    this.fbitmap.x = this.cloneof.fbitmap.x;
                    this.fbitmap.y = this.cloneof.fbitmap.y;
                    if (this.fspr)
                    {
                        this.fspr.addChild(this.fbitmap);
                    }
                }
                this.bitmapped = true;
                return;
            }
            var bounds:Rectangle = this.GetFilteredBounds(this.obj);
            if (bounds.width == 0 || bounds.height == 0)
            {
                return;
            }
            var bmpscale:Number = this.CalculateBitmapScale(this.obj);
            bounds.width *= bmpscale;
            bounds.height *= bmpscale;
            bounds.x *= bmpscale;
            bounds.y *= bmpscale;
            var matrix:Matrix = new Matrix(bmpscale, 0, 0, bmpscale, -bounds.x, -bounds.y);
            var ct:ColorTransform = this.obj.cacheAsBitmap ? this.obj.transform.concatenatedColorTransform : this.colorTransform;
            if (Imitation.usegpu && !this.maskedchild)
            {
                this.gimage = new GpuImage(bounds.width, bounds.height);
                this.gimage.DrawObj(this.obj, matrix, ct, null, null, true);
            }
            else
            {
                texw = Math.ceil(bounds.width);
                texh = Math.ceil(bounds.height);
                this.bitmapdata = new BitmapData(texw, texh, true, !!Imitation.showregions ? 1426063496 : 0);
                ax = 1;
                ay = 1;
                if (matrix.a <= 0.1)
                {
                    matrix.scale(1 + 1 / texw, 1 + 1 / texh);
                    ax = bounds.width / texw;
                    ay = bounds.height / texh;
                }
                this.bitmapdata.draw(this.obj, matrix, ct, null, null, true);
                this.fbitmap = new Bitmap(this.bitmapdata, "auto", true);
                this.fbitmap.scaleX = 1 / bmpscale * ax;
                this.fbitmap.scaleY = 1 / bmpscale * ay;
                this.fbitmap.x = this.fbitmap.scaleX * bounds.x / ax;
                this.fbitmap.y = this.fbitmap.scaleY * bounds.y / ay;
                if (this.fspr)
                {
                    this.fspr.addChild(this.fbitmap);
                }
            }
            if (this.obj.name != "DEBUG_TXT")
            {
            }
            this.bitmapped = true;
            if (this.hot_updated < 2)
            {
                ++this.hot_updated;
            }
            ++this.hot2;
        }

        public function CollectChildrenAll():void
        {
            this.CollectChildren();
            var i:int = 0;
            while (i < this.children.length)
            {
                if (this.children[i] != null)
                {
                    this.children[i].CollectChildrenAll();
                }
                i++;
            }
        }

        public function CollectChildren():void
        {
            var doc:DisplayObjectContainer;
            var i:int;
            var im:Imitator = null;
            var dobj:* = undefined;
            var fi:int = 0;
            if (!(this.obj is DisplayObjectContainer) || this.obj.cacheAsBitmap)
            {
                while (this.children.length > 0)
                {
                    im = this.children[0];
                    if (Boolean(this.fspr) && Boolean(im.fspr))
                    {
                        this.fspr.removeChild(im.fspr);
                    }
                    im.Dispose();
                    im = null;
                    this.children.splice(0, 1);
                    this.fchildren.splice(0, 1);
                }
                return;
            }
            doc = this.obj as DisplayObjectContainer;
            i = 0;
            for (; i < doc.numChildren; i++)
            {
                dobj = doc.getChildAt(i);
                if (dobj != null)
                {
                    fi = int(this.fchildren.indexOf(dobj));
                    if (fi < 0)
                    {
                        im = new Imitator(this, dobj, this.obj.transform.concatenatedColorTransform);
                        this.children.splice(i, 0, im);
                        this.fchildren.splice(i, 0, dobj);
                        if (Boolean(this.fspr) && Boolean(im.fspr))
                        {
                            try
                            {
                                this.fspr.addChildAt(im.fspr, i);
                            }
                            catch (e:Error)
                            {
                                trace("imitator: outOfBoundsError");
                            }
                            continue;
                        }
                    }
                    if (fi != i)
                    {
                        im = this.children[fi];
                        this.children.splice(fi, 1);
                        this.children.splice(i, 0, im);
                        this.fchildren.splice(fi, 1);
                        this.fchildren.splice(i, 0, dobj);
                        if (Boolean(this.fspr) && Boolean(im.fspr))
                        {
                            try
                            {
                                if (im.fspr.parent == this.fspr)
                                {
                                    this.fspr.setChildIndex(im.fspr, i);
                                }
                            }
                            catch (e:Error)
                            {
                                trace("imitator: outOfBoundsError 2");
                                continue;
                            }
                        }
                    }
                }
            }
            while (this.children.length > doc.numChildren)
            {
                im = this.children[doc.numChildren];
                if (Boolean(this.fspr) && Boolean(im.fspr))
                {
                    if (im.fspr.parent == this.fspr)
                    {
                        this.fspr.removeChild(im.fspr);
                    }
                }
                im.Dispose();
                im = null;
                this.children.splice(doc.numChildren, 1);
                this.fchildren.splice(doc.numChildren, 1);
            }
        }

        public function CollectStats(statobj:Object, detailed:Boolean = false):*
        {
            ++statobj.imitatornum;
            if (detailed && (this.bitmapped || this.combined))
            {
                statobj.details.push([this.obj, [!!this.gimage ? this.gimage.texwidth : 0, !!this.gimage ? this.gimage.texheight : 0, this.combined]]);
            }
            if (this.obj is DisplayObjectContainer)
            {
                ++statobj.container;
            }
            if (!this.obj.visible)
            {
                ++statobj.invisibles;
                return;
            }
            if (this.maskedchild)
            {
                ++statobj.masks;
            }
            if (this.mask)
            {
                ++statobj.maskedchilds;
            }
            if (this.obj.cacheAsBitmap)
            {
                ++statobj.caches;
                return;
            }
            statobj.childrens += this.children.length;
            ++statobj.parents;
            var i:int = 0;
            while (i < this.children.length)
            {
                this.children[i].CollectStats(statobj, detailed);
                i++;
            }
            return statobj;
        }

        public function CollectInteractiveObjects(objects:Object):void
        {
            if (this.obj is InteractiveObject)
            {
                objects.push(this.obj);
            }
            var i:int = 0;
            while (i < this.children.length)
            {
                this.children[i].CollectInteractiveObjects(objects);
                i++;
            }
        }

        private function BuildMatrix(obj:DisplayObject):Matrix
        {
            var m:Matrix = obj.transform.matrix.clone();
            while (Boolean(obj.parent) && obj.parent != Imitation.rootmc)
            {
                obj = obj.parent;
                m.concat(obj.transform.matrix);
            }
            if (obj.parent == Imitation.rootmc && Imitation.stage.scaleMode == StageScaleMode.NO_SCALE)
            {
                obj = obj.parent;
                m.concat(obj.transform.matrix);
            }
            m.tx = int(m.tx * 20) / 20;
            m.ty = int(m.ty * 20) / 20;
            return m;
        }
    }
}
