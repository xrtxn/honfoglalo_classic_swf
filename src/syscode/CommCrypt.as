package syscode
{
    import com.hurlant.crypto.prng.Random;
    import com.hurlant.crypto.rsa.RSAKey;
    import com.hurlant.util.*;

    import flash.display.*;
    import flash.text.*;
    import flash.utils.*;

    public class CommCrypt
    {
        public static var SharedKeyTmp:ByteArray = null;
        public static var ChaChaCipher:ChaCha = null;
        public static var Encrypted:Boolean = false;
        internal static var RsaPubKey:* = "3|21d713c41f17097aec6ab979d8a28d4ccfd73dc885a31199e891570033e0a1651ccacc283f241c17ac1f702c1ed7cfeeca2e519851f0e2ce97f4cabdee3fef67";
        internal static var SharedKey:ByteArray = null;
        internal static var DefaultSharedKey:ByteArray = null;
        private static var qpic:Boolean = false;

        private static var qtext:ByteArray = new ByteArray();

        private static var qivec:ByteArray = new ByteArray();

        private static var qhide:ChaCha = new ChaCha();

        private static var qpadd:Vector.<uint> = new <uint>[1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159];

        public static function printbytes(byteArray:ByteArray):ByteArray
        {
            trace("bytes");
            var printbytes:String = "";
            var i:int = 0;
            while (i < byteArray.length)
            {
                trace(byteArray[i]);
                printbytes += byteArray[i];
                i++;
            }
            trace(printbytes);
            return undefined;
        }

        public static function BinaryEncrypt(str:String, defkey:Boolean = false):ByteArray
        {
            trace("FIXME: using encryption BinaryEncrypt, string: " + str);
            var i:int = 0;
            var bytes:ByteArray = new ByteArray();
            bytes.endian = Endian.LITTLE_ENDIAN;
            bytes.writeUnsignedInt(Math.floor(Math.random() * 2147483647));
            bytes.writeUnsignedInt(Math.floor(Math.random() * 2147483647));
            bytes.writeUTFBytes(str);
            if (defkey || SharedKey == null)
            {
                if (DefaultSharedKey == null)
                {
                    DefaultSharedKey = new ByteArray();
                    i = 1;
                    while (i <= 32)
                    {
                        DefaultSharedKey.writeByte(i);
                        i++;
                    }
                    trace("for encryption using new DefaultSharedKey: ");
                    printbytes(DefaultSharedKey);
                }
                trace("for encryption using DefaultSharedKey: ");
                printbytes(DefaultSharedKey);
                ChaChaCipher.KeySetup(DefaultSharedKey);
            }
            else
            {
                trace("for encryption using SharedKey: ");
                printbytes(SharedKey);
                ChaChaCipher.KeySetup(SharedKey);
            }
            trace("bytes: ");
            printbytes(bytes);
            ChaChaCipher.IvSetup(bytes);
            ChaChaCipher.EncryptByteArray(bytes, 8);
            return bytes;
        }

        public static function BinaryDecrypt(bytes:ByteArray, defkey:Boolean = false):String
        {
            trace("FIXME: using encryption BinaryDecrypt");
            var i:int = 0;
            if (bytes.length < 8)
            {
                return "";
            }
            if (defkey || SharedKey == null)
            {
                if (DefaultSharedKey == null)
                {
                    DefaultSharedKey = new ByteArray();
                    i = 1;
                    while (i <= 32)
                    {
                        DefaultSharedKey.writeByte(i);
                        i++;
                    }
                }
                ChaChaCipher.KeySetup(DefaultSharedKey);
            }
            else
            {
                ChaChaCipher.KeySetup(SharedKey);
            }
            bytes.endian = Endian.LITTLE_ENDIAN;
            bytes.position = 0;
            ChaChaCipher.IvSetup(bytes);
            ChaChaCipher.EncryptByteArray(bytes, 8);
            SaveQuestion(bytes);
            bytes.position = 8;
            return bytes.readUTFBytes(bytes.bytesAvailable);
        }

        public static function Encrypt(asrc:String):String
        {
            trace("FIXME: using encryption Encrypt, string: " + asrc);
            var ba:* = new ByteArray();
            ba.writeUTFBytes(asrc);
            if (SharedKey == null)
            {
                return Base64.encodeByteArray(ba);
            }
            var iv:ByteArray = new ByteArray();
            var i:* = 0;
            while (i < 4)
            {
                iv.writeByte(Math.round(Math.random() * 255));
                i++;
            }
            var tmp:ByteArray = new ByteArray();
            tmp.writeBytes(iv);
            tmp.writeBytes(iv);
            ChaChaCipher.IvSetup(tmp);
            var res:* = new ByteArray();
            res.writeByte(42);
            res.writeBytes(iv);
            res.writeBytes(ChaChaCipher.Encrypt(ba));
            return Base64.encodeByteArray(res);
        }

        public static function Decrypt(asrc:String):String
        {
            trace("FIXME: using encryption Decrypt, string: " + asrc);
            var ba:ByteArray = Base64.decodeToByteArray(asrc);
            if (ba.length <= 0)
            {
                return "";
            }
            if (ba[0] != 42)
            {
                return ba.readUTFBytes(ba.length);
            }
            ++ba.position;
            var iv:ByteArray = new ByteArray();
            ba.readBytes(iv, 0, 4);
            ba.position -= 4;
            ba.readBytes(iv, 4, 4);
            ChaChaCipher.IvSetup(iv);
            var dec:ByteArray = ChaChaCipher.Encrypt(ba, ba.position, ba.bytesAvailable);
            SaveQuestion(dec);
            dec.position = 0;
            return dec.readUTFBytes(dec.length);
        }

        public static function GenerateSharedKey():Array
        {
            trace("FIXME: using encryption GenerateSharedKeyDecrypt");
            Reset();
            SharedKeyTmp = RandomKey(32);
            ChaChaCipher.KeySetup(SharedKeyTmp);
            return EncryptSharedKey(SharedKeyTmp);
        }

        public static function StartEncryption():*
        {
            trace("FIXME: using encryption StartEncryption");
            if (SharedKey == null)
            {
                SharedKey = SharedKeyTmp;
            }
            Encrypted = true;
        }

        public static function GetQuestionPic(data:String, color:uint):Bitmap
        {
            var magic:uint;
            var width:uint;
            var height:uint;
            var bd:BitmapData;
            var x:int;
            var y:int;
            var a:uint;
            var qdat:ByteArray;
            trace("FIXME: using encryption GetQuestionPic, data: " + data);
            a = 0;
            qdat = Base64.decodeToByteArray(data);
            try
            {
                qdat.uncompress();
            }
            catch (err:Error)
            {
                return null;
            }
            qdat.position = 0;
            qdat.endian = Endian.LITTLE_ENDIAN;
            magic = qdat.readUnsignedInt();
            if (magic != 1196247377)
            {
                return null;
            }
            width = qdat.readUnsignedInt();
            height = qdat.readUnsignedInt();
            if (width * height != qdat.bytesAvailable)
            {
                return null;
            }
            bd = new BitmapData(width, height, true, 0);
            x = 0;
            y = 0;
            while (qdat.bytesAvailable > 0)
            {
                a = uint(color | qdat.readByte() << 24);
                bd.setPixel32(x, y, a);
                if (++x >= width)
                {
                    x = 0;
                    y++;
                }
            }
            return new Bitmap(bd, "auto", true);
        }

        public static function SetQuestionText(tf:TextField, qt:String):void
        {
            trace("FIXME: using encryption SetQuestionText, question: " + qt);
            var s:String = null;
            tf.text = "";
            var pic:DisplayObject = tf.parent.getChildByName("QPIC");
            if (pic)
            {
                tf.parent.removeChild(pic);
            }
            if (qtext.length > 0)
            {
                qtext.position = 0;
                qtext.position = 0;
                qhide.IvSetup(qivec);
                qhide.EncryptByteArray(qtext);
                qtext.position = 0;
                if (Config.rtl)
                {
                    Util.LoadArabicText(tf, Util.RemoveInvisibleChars(qtext.readUTFBytes(qtext.bytesAvailable)));
                }
                else
                {
                    tf.text = Util.RemoveInvisibleChars(qtext.readUTFBytes(qtext.bytesAvailable));
                }
                qhide.IvSetup(qivec);
                qhide.EncryptByteArray(qtext);
            }
            else
            {
                s = Util.RemoveInvisibleChars(Util.StringVal(qt == "mcq" ? Sys.tag_question.QUESTION : Sys.tag_tipquestion.QUESTION));
                if (Config.rtl)
                {
                    Util.LoadArabicText(tf, s);
                }
                else
                {
                    tf.text = s;
                }
            }
        }

        public static function Reset():*
        {
            trace("FIXME: using encryption Reset");
            Encrypted = false;
            SharedKeyTmp = null;
            SharedKey = null;
            ChaChaCipher = new ChaCha();
        }

        internal static function EncryptSharedKey(shk:ByteArray):Array
        {
            trace("FIXME: using encryption EncryptSharedKey");
            var key:* = RsaPubKey.split("|");
            var rsa:* = RSAKey.parsePublicKey(key[1], "10001");
            var dst:* = new ByteArray();
            dst.position = 0;
            shk.position = 0;
            rsa.encrypt(shk, dst, shk.length);
            return [String(key[0]), Hex.fromArray(dst)];
        }

        internal static function RandomKey(bytecount:int):ByteArray
        {
            trace("FIXME: using encryption RandomKey");
            var res:ByteArray = new ByteArray();
            var rnd:Random = new Random();
            rnd.nextBytes(res, bytecount);
            if (res[0] == 0)
            {
                res[0] = Math.floor(Math.random() * 254) + 1;
            }
            if (res[31] == 0)
            {
                res[31] = Math.floor(Math.random() * 254) + 1;
            }
            return res;
        }

        private static function RandomPadding(ba:ByteArray):void
        {
            trace("FIXME: using encryption RandomPadding");
            var code:uint = 0;
            if (Config.rtl)
            {
                return;
            }
            var cnt:int = 3 + Math.round(Math.random() * 7);
            while (cnt > 0)
            {
                code = qpadd[Math.floor(Math.random() * qpadd.length)];
                if (code <= 127)
                {
                    qtext.writeByte(code);
                }
                else
                {
                    qtext.writeByte(0xC0 | code >> 6 & 0x1F);
                    qtext.writeByte(0x80 | code & 0x3F);
                }
                cnt--;
            }
        }

        private static function SaveQuestion(ba:ByteArray):void
        {
            trace("FIXME: using encryption SaveQuestion");
            var idx:uint = 0;
            var val:int = 0;
            var pos:uint = 0;
            var len:uint = 0;
            idx = 0;
            while (idx < ba.length - 12)
            {
                ba.position = idx;
                if (ba.readUTFBytes(11) == " QUESTION=\"")
                {
                    pos = uint(idx + 11);
                    while (ba.readByte() != 34)
                    {
                        len++;
                    }
                    break;
                }
                idx++;
            }
            if (len == 0)
            {
                return;
            }
            qpic = false;
            qtext.clear();
            ba.position = pos;
            if (ba.readUTFBytes(8) == "UVBJQ1pM")
            {
                qpic = true;
                qtext.writeUTFBytes(ba.readUTFBytes(len));
                ba.position = pos;
                idx = uint(pos + len);
                while (idx < ba.length)
                {
                    ba.writeByte(ba[idx]);
                    idx++;
                }
                while (ba.bytesAvailable > 0)
                {
                    ba.writeByte(32);
                }
                ba.length = idx - len;
                return;
            }
            qtext.clear();
            RandomPadding(qtext);
            ba.position = pos;
            while (ba.position < pos + len)
            {
                val = int(ba.readUnsignedByte());
                if ((val & 0xE0) == 192)
                {
                    qtext.writeByte(val);
                    val = int(ba.readUnsignedByte());
                    qtext.writeByte(val);
                }
                else if ((val & 0xF0) == 224)
                {
                    qtext.writeByte(val);
                    val = ba.readByte();
                    qtext.writeByte(val);
                    val = ba.readByte();
                    qtext.writeByte(val);
                }
                else if (val != 38)
                {
                    qtext.writeByte(val);
                }
                else
                {
                    val = ba.readByte();
                    if (val == 113)
                    {
                        ba.position += 4;
                        qtext.writeByte(34);
                    }
                    else if (val == 108)
                    {
                        ba.position += 2;
                        qtext.writeByte(60);
                    }
                    else if (val == 103)
                    {
                        ba.position += 2;
                        qtext.writeByte(62);
                    }
                    else if (val == 97)
                    {
                        val = ba.readByte();
                        if (val == 112)
                        {
                            ba.position += 3;
                            qtext.writeByte(39);
                        }
                        else if (val == 109)
                        {
                            ba.position += 2;
                            qtext.writeByte(38);
                        }
                        else
                        {
                            while (ba.readByte() != 59)
                            {
                                val = 0;
                            }
                        }
                    }
                    else
                    {
                        while (ba.readByte() != 59)
                        {
                            val = 0;
                        }
                    }
                }
                RandomPadding(qtext);
            }
            qivec.clear();
            idx = 0;
            while (idx < 8)
            {
                qivec.writeByte(Math.round(Math.random() * 255));
                idx++;
            }
            qhide.IvSetup(qivec);
            qhide.EncryptByteArray(qtext);
            ba.position = pos;
            idx = uint(pos + len);
            while (idx < ba.length)
            {
                ba.writeByte(ba[idx]);
                idx++;
            }
            while (ba.bytesAvailable > 0)
            {
                ba.writeByte(32);
            }
            ba.length = idx - len;
        }

        public function CommCrypt()
        {
            super();
        }
    }
}
