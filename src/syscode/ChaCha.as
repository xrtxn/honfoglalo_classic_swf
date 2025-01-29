package syscode
{
    import flash.utils.ByteArray;

    public class ChaCha
    {
        public function ChaCha()
        {
            super();
            this.input = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        }
        private var input:Array;

        public function WordToByte():*
        {
            var x00:uint = 0;
            var x01:uint = 0;
            var x02:uint = 0;
            var x03:uint = 0;
            var x04:uint = 0;
            var x05:uint = 0;
            var x06:uint = 0;
            var x07:uint = 0;
            var x08:uint = 0;
            var x09:uint = 0;
            var x10:uint = 0;
            var x11:uint = 0;
            var x12:uint = 0;
            var x13:uint = 0;
            var x14:uint = 0;
            var x15:uint = 0;
            var tmp:uint = 0;
            var i:int = 0;
            x00 = uint(this.input[0]);
            x01 = uint(this.input[1]);
            x02 = uint(this.input[2]);
            x03 = uint(this.input[3]);
            x04 = uint(this.input[4]);
            x05 = uint(this.input[5]);
            x06 = uint(this.input[6]);
            x07 = uint(this.input[7]);
            x08 = uint(this.input[8]);
            x09 = uint(this.input[9]);
            x10 = uint(this.input[10]);
            x11 = uint(this.input[11]);
            x12 = uint(this.input[12]);
            x13 = uint(this.input[13]);
            x14 = uint(this.input[14]);
            x15 = uint(this.input[15]);
            for (i = 0; i < 4; i++)
            {
                x00 += x04;
                tmp = uint(x12 ^ x00);
                x12 = uint(tmp << 16 | tmp >>> 16);
                x08 += x12;
                tmp = uint(x04 ^ x08);
                x04 = uint(tmp << 12 | tmp >>> 20);
                x00 += x04;
                tmp = uint(x12 ^ x00);
                x12 = uint(tmp << 8 | tmp >>> 24);
                x08 += x12;
                tmp = uint(x04 ^ x08);
                x04 = uint(tmp << 7 | tmp >>> 25);
                x01 += x05;
                tmp = uint(x13 ^ x01);
                x13 = uint(tmp << 16 | tmp >>> 16);
                x09 += x13;
                tmp = uint(x05 ^ x09);
                x05 = uint(tmp << 12 | tmp >>> 20);
                x01 += x05;
                tmp = uint(x13 ^ x01);
                x13 = uint(tmp << 8 | tmp >>> 24);
                x09 += x13;
                tmp = uint(x05 ^ x09);
                x05 = uint(tmp << 7 | tmp >>> 25);
                x02 += x06;
                tmp = uint(x14 ^ x02);
                x14 = uint(tmp << 16 | tmp >>> 16);
                x10 += x14;
                tmp = uint(x06 ^ x10);
                x06 = uint(tmp << 12 | tmp >>> 20);
                x02 += x06;
                tmp = uint(x14 ^ x02);
                x14 = uint(tmp << 8 | tmp >>> 24);
                x10 += x14;
                tmp = uint(x06 ^ x10);
                x06 = uint(tmp << 7 | tmp >>> 25);
                x03 += x07;
                tmp = uint(x15 ^ x03);
                x15 = uint(tmp << 16 | tmp >>> 16);
                x11 += x15;
                tmp = uint(x07 ^ x11);
                x07 = uint(tmp << 12 | tmp >>> 20);
                x03 += x07;
                tmp = uint(x15 ^ x03);
                x15 = uint(tmp << 8 | tmp >>> 24);
                x11 += x15;
                tmp = uint(x07 ^ x11);
                x07 = uint(tmp << 7 | tmp >>> 25);
                x00 += x05;
                tmp = uint(x15 ^ x00);
                x15 = uint(tmp << 16 | tmp >>> 16);
                x10 += x15;
                tmp = uint(x05 ^ x10);
                x05 = uint(tmp << 12 | tmp >>> 20);
                x00 += x05;
                tmp = uint(x15 ^ x00);
                x15 = uint(tmp << 8 | tmp >>> 24);
                x10 += x15;
                tmp = uint(x05 ^ x10);
                x05 = uint(tmp << 7 | tmp >>> 25);
                x01 += x06;
                tmp = uint(x12 ^ x01);
                x12 = uint(tmp << 16 | tmp >>> 16);
                x11 += x12;
                tmp = uint(x06 ^ x11);
                x06 = uint(tmp << 12 | tmp >>> 20);
                x01 += x06;
                tmp = uint(x12 ^ x01);
                x12 = uint(tmp << 8 | tmp >>> 24);
                x11 += x12;
                tmp = uint(x06 ^ x11);
                x06 = uint(tmp << 7 | tmp >>> 25);
                x02 += x07;
                tmp = uint(x13 ^ x02);
                x13 = uint(tmp << 16 | tmp >>> 16);
                x08 += x13;
                tmp = uint(x07 ^ x08);
                x07 = uint(tmp << 12 | tmp >>> 20);
                x02 += x07;
                tmp = uint(x13 ^ x02);
                x13 = uint(tmp << 8 | tmp >>> 24);
                x08 += x13;
                tmp = uint(x07 ^ x08);
                x07 = uint(tmp << 7 | tmp >>> 25);
                x03 += x04;
                tmp = uint(x14 ^ x03);
                x14 = uint(tmp << 16 | tmp >>> 16);
                x09 += x14;
                tmp = uint(x04 ^ x09);
                x04 = uint(tmp << 12 | tmp >>> 20);
                x03 += x04;
                tmp = uint(x14 ^ x03);
                x14 = uint(tmp << 8 | tmp >>> 24);
                x09 += x14;
                tmp = uint(x04 ^ x09);
                x04 = uint(tmp << 7 | tmp >>> 25);
            }
            var x:* = [x00, x01, x02, x03, x04, x05, x06, x07, x08, x09, x10, x11, x12, x13, x14, x15];
            var output:* = [];
            var j:* = 0;
            for (i = 0; i < 16; i++)
            {
                tmp = uint(x[i] + this.input[i] >>> 0);
                output.push(tmp >> 0 & 0xFF);
                output.push(tmp >> 8 & 0xFF);
                output.push(tmp >> 16 & 0xFF);
                output.push(tmp >> 24 & 0xFF);
            }
            return output;
        }

        public function BytesToLong(arr:ByteArray, idx:int):uint
        {
            return (arr[idx + 3] << 24 & 4278190080 | arr[idx + 2] << 16 & 0xFF0000 | arr[idx + 1] << 8 & 0xFF00 | arr[idx + 0] << 0 & 0xFF) >>> 0;
        }

        public function KeySetup(key:ByteArray):Boolean
        {
            var kbits:int = 0;
            var c:ByteArray = null;
            var k:int = 0;
            this.input[0] = 1634760805;
            this.input[1] = 824206446;
            this.input[2] = 2036477238;
            this.input[3] = 1797285236;
            if (key.length == 16)
            {
                kbits = 128;
            }
            else
            {
                if (key.length != 32)
                {
                    return false;
                }
                kbits = 256;
                k = 16;
                this.input[1] = 857760878;
                this.input[2] = 2036477234;
            }
            this.input[4] = this.BytesToLong(key, 0);
            this.input[5] = this.BytesToLong(key, 4);
            this.input[6] = this.BytesToLong(key, 8);
            this.input[7] = this.BytesToLong(key, 12);
            this.input[8] = this.BytesToLong(key, k + 0);
            this.input[9] = this.BytesToLong(key, k + 4);
            this.input[10] = this.BytesToLong(key, k + 8);
            this.input[11] = this.BytesToLong(key, k + 12);
            return true;
        }

        public function IvSetup(iv:ByteArray):void
        {
            this.input[12] = 0;
            this.input[13] = 0;
            this.input[14] = this.BytesToLong(iv, 0);
            this.input[15] = this.BytesToLong(iv, 4);
        }

        public function Encrypt(m:ByteArray, midx:int = 0, cnt:int = 0):ByteArray
        {
            var output:Array = null;
            var c:ByteArray = null;
            var i:int = 0;
            var bytes:* = cnt;
            var idx:* = midx;
            c = new ByteArray();
            if (cnt == 0)
            {
                bytes = m.length;
            }
            if (bytes <= 0)
            {
                return c;
            }
            while (true)
            {
                output = this.WordToByte();
                ++this.input[12];
                if (this.input[12] == 0)
                {
                    ++this.input[13];
                }
                if (bytes <= 64)
                {
                    break;
                }
                for (i = 0; i < 64; i++)
                {
                    c.writeByte(m[idx] ^ output[i]);
                    idx++;
                }
                bytes -= 64;
            }
            for (i = 0; i < bytes; i++)
            {
                c.writeByte(m[idx] ^ output[i]);
                idx++;
            }
            return c;
        }

        public function EncryptByteArray(bytes:ByteArray, offset:uint = 0, length:uint = 0):void
        {
            var tmp:uint = 0;
            var output:Array = [];
            var outptr:int = 1;
            var maxidx:uint = uint(offset + bytes.length - offset);
            if (length > 0)
            {
                maxidx = offset + length;
            }
            for (var idx:uint = offset; idx < maxidx; idx++)
            {
                if (outptr >= output.length)
                {
                    output = this.WordToByte();
                    outptr = 0;
                    ++this.input[12];
                }
                bytes.position = idx;
                tmp = uint(bytes.readByte());
                bytes.position = idx;
                bytes.writeByte(tmp ^ output[outptr]);
                outptr++;
            }
        }
    }
}
