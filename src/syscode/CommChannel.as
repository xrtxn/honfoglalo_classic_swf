package syscode
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import flash.utils.getTimer;

    internal class CommChannel
    {
        public function CommChannel(aid:String, axsocket:BinarySocket)
        {
            this.http_requests = [];
            super();
            this.id = aid;
            this.bsocket = axsocket;
            this.encrypted = this.id != "H";
            this.Reset();
        }
        public var id:String = "";
        public var bsocket:BinarySocket = null;
        public var encrypted:Boolean = false;
        public var ready:Boolean = true;
        public var ignoreready:Boolean = false;
        public var msgnum:int = 0;
        public var trynum:int = 0;
        public var http_requests:Array;
        public var rqbody:String = "";
        public var rqtext:String = "";
        public var rqtextenc:ByteArray = null;
        public var msgtime:int = 0;

        public function Reset():*
        {
            this.ready = true;
            this.msgnum = 0;
            this.trynum = 0;
            var i:* = 0;
            while (i < this.http_requests.length)
            {
                this.http_requests[i].close();
                i++;
            }
            this.http_requests = [];
            this.rqbody = "";
            this.rqtext = "";
            this.rqtextenc = null;
        }

        public function XMLReceived(xml:XML):void
        {
            var nodelist:* = xml.children();
            var htagname:String = String(nodelist[0].name());
            var htag:Object = Util.XMLTagToObject(nodelist[0]);
            var mn:int = Util.NumberVal(htag.MN);
            var res:int = Util.NumberVal(htag.R);
            trace("mn: " + mn + " == this.msgnum: " + this.msgnum);
            if (mn == 0 || mn == this.msgnum)
            {
                trace("RESETTING READY STATE FOR CHANNEL " + this.id);
                this.ready = true;
                ++this.msgnum;
                if (res != 0)
                {
                    trace(htagname + " result: " + res);
                }
                if ("C" == this.id)
                {
                    Comm.ProcessCommandAnswer(xml);
                }
                else if ("L" == this.id)
                {
                    Comm.ProcessListenAnswer(xml);
                }
                else if ("H" == this.id)
                {
                    Comm.ProcessHeartBeatAnswer(xml);
                }
            }
        }

        public function CreateHeader(aextra:String):String
        {
            return "<" + this.id + " CID=\"" + Comm.connid + "\" MN=\"" + this.msgnum + "\" " + aextra + " />";
        }

        public function SendRequest(arqbody:String, aextrahead:String = ""):Boolean
        {
            trace("CommChannel.SendRequest");
            trace("arqbody" + arqbody + " aextrahead: " + aextrahead);
            this.rqbody = arqbody;
            this.rqtext = this.CreateHeader(aextrahead) + "\r\n";
            if (this.rqbody != "")
            {
                this.rqtext += this.rqbody + "\r\n";
            }
            if (!this.ready && !this.ignoreready)
            {
                trace("ERROR: Channel " + this.id + " is not ready!");
                return false;
            }
            if (!Comm.xrt_bypass_encryption)
            {
                trace("This will be the encrypted buffer: " + this.rqtext);
                var buffer:ByteArray = CommCrypt.BinaryEncrypt(this.rqtext, !this.encrypted);
                this.rqtextenc = new ByteArray();
                this.rqtextenc.endian = Endian.LITTLE_ENDIAN;
                var header:uint = uint(buffer.length + 4 << 8 | (this.encrypted && CommCrypt.Encrypted ? 1 : 0));
                trace("This will be the encrypted header: " + uint(buffer.length + 4 << 8));
                this.rqtextenc.writeUnsignedInt(header);
                this.rqtextenc.writeBytes(buffer);
            }
            else
            {
                trace("bypassing encryption!");
                var byteArray:ByteArray = new ByteArray();
                byteArray.writeUTFBytes(this.rqtext);
                this.rqtextenc = byteArray;
            }
            this.trynum = 0;
            this.ready = false;
            this.msgtime = getTimer();
            this.TransmitRequest();
            return true;
        }

        public function TransmitRequest():*
        {
            ++this.trynum;
            if (Semu.enabled)
            {
                if (Comm.commlog >= 1)
                {
                    DBG.Trace("SendXML(" + this.id + "/SEMU) at " + Util.FormatTimeStamp(true, true) + ":", this.rqtext.replace(/[\r\n]+/g, "\n"));
                }
                Semu.ProcessMessage(this.rqtext, this.id);
                return;
            }
            this.bsocket.Update();
            if (this.trynum == 1 && this.bsocket.connstate > 3)
            {
                if (Comm.commlog >= 1)
                {
                    DBG.Trace("SendXML(" + this.id + "/TCP) at " + Util.FormatTimeStamp(true, true) + ":", this.rqtext.replace(/[\r\n]+/g, "\n"));
                }
                this.bsocket.Send(this.rqtextenc);
                if (this.bsocket.connstate >= 5)
                {
                    return;
                }
            }
            this.SendHTTP(this.rqtextenc);
        }

        public function SendHTTP(data:ByteArray):void
        {
            trace("SendHTTP data: " + data);
            var mlp:String = this.id == "H" && Comm.ModuleLoadingPhase ? "&MLP=1" : "";
            var uri:String = Config.extdatauribase + "game" + "?CID=" + Comm.connid + "&CH=" + this.id + "&MN=" + this.msgnum + "&TRY=" + this.trynum + mlp;
            if (Comm.commlog >= 1)
            {
                DBG.Trace("SendXML(" + this.id + "/HTTP) at " + Util.FormatTimeStamp(true, true) + ":", uri + "\n" + this.rqtext.replace(/[\r\n]+/g, "\n"));
            }
            var urq:URLRequest = new URLRequest(uri);
            urq.method = "POST";
            urq.contentType = "application/octet-stream";
            urq.data = data;
            var httprq:URLLoader = new URLLoader();
            Util.AddEventListener(httprq, "complete", this.OnHTTPData);
            Util.AddEventListener(httprq, "ioError", this.OnHTTPConnectError);
            Util.AddEventListener(httprq, "securityError", this.OnHTTPConnectError);
            httprq.dataFormat = "binary";
            httprq.load(urq);
            this.http_requests.push(httprq);
        }

        public function OnHTTPData(e:Event):void
        {
            var data:ByteArray = null;
            var uldr:URLLoader = e.target as URLLoader;
            var i:int = 0;
            while (i < this.http_requests.length)
            {
                if (this.http_requests[i] == uldr)
                {
                    this.http_requests.splice(i, 1);
                    Util.RemoveEventListener(uldr, "complete", this.OnHTTPData);
                    Util.RemoveEventListener(uldr, "ioError", this.OnHTTPConnectError);
                    Util.RemoveEventListener(uldr, "securityError", this.OnHTTPConnectError);
                    break;
                }
                i++;
            }
            uldr.data.position = 0;
            uldr.data.endian = Endian.LITTLE_ENDIAN;
            if (!Comm.xrt_bypass_encryption)
            {
                var header:uint = uint(uldr.data.readUnsignedInt());
                var length:uint = uint(header >> 8);
                var flags:uint = uint(header & 0xFF);
            }
            if (Comm.xrt_bypass_encryption)
            {
                Comm.DataReceived(e.target.data, this.id, null, "HTTP");
            }
            else if (length == uldr.data.length)
            {
                data = new ByteArray();
                data.writeBytes(e.target.data, 4);
                if (Comm.connstate >= 1)
                {
                    Comm.DataReceived(data, this.id, flags, "HTTP");
                }
            }
            else
            {
                trace("OnHTTPData(" + this.id + "/HTTP, length:", length, ", datalength:", uldr.data.length);
            }
        }

        public function OnHTTPConnectError(e:Event):void
        {
            var uldr:URLLoader = e.target as URLLoader;
            var i:int = 0;
            while (i < this.http_requests.length)
            {
                if (this.http_requests[i] == uldr)
                {
                    this.http_requests.splice(i);
                    break;
                }
                i++;
            }
            if (Comm.commlog >= 2)
            {
                DBG.Trace("HTTPError(" + this.id + "), event:" + e.toString());
            }
        }
    }
}
