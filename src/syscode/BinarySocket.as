package syscode
{
    import flash.events.*;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    internal class BinarySocket
    {
        public function BinarySocket(atype:String)
        {
            super();
            if (Comm.commlog >= 2)
            {
                DBG.Trace("BinarySocket(" + this.type + "), CREATED");
            }
            this.type = atype;
            this.buffer = new ByteArray();
            this.buffer.endian = Endian.LITTLE_ENDIAN;
            this.socket = new Socket();
            this.socket.endian = Endian.LITTLE_ENDIAN;
            this.socket.timeout = 5000;
            this.socket.addEventListener(Event.CONNECT, this.OnConnect);
            this.socket.addEventListener(Event.CLOSE, this.OnClose);
            this.socket.addEventListener(ProgressEvent.SOCKET_DATA, this.OnData);
            this.socket.addEventListener(IOErrorEvent.IO_ERROR, this.OnIOError);
            this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.OnSecurityError);
            this.Reset();
        }
        public var type:String = "";
        public var socket:Socket = null;
        public var buffer:ByteArray = null;
        public var connstate:int = 0;

        public function Update():void
        {
            if (Comm.xsocketport > 0)
            {
                if (this.connstate == 0)
                {
                    this.Connect(Comm.xsocketaddress, Comm.xsocketport);
                }
                else if (this.connstate == 2 && Comm.connid != "" && Comm.clientcc > 0)
                {
                    this.Identify();
                }
            }
        }

        public function Reset():void
        {
            if (Comm.commlog >= 2)
            {
                DBG.Trace("BinarySocket(" + this.type + "), RESET");
            }
            this.Close();
        }

        public function Send(adata:ByteArray):void
        {
            try
            {
                this.socket.writeBytes(adata);
                this.socket.flush();
                if (Comm.commlog >= 2)
                {
                    DBG.Trace("BinarySocket(" + this.type + "), SEND:" + adata.length + ", PENDING:" + this.socket.bytesPending);
                }
            }
            catch (err:Error)
            {
                if (Comm.commlog >= 2)
                {
                    DBG.Trace("BinarySocket(" + this.type + "), SEND ERROR:" + err.toString());
                }
                this.Close();
            }
        }

        public function Connect(aaddress:String, aport:int):void
        {
            trace("Comm.Connect", aaddress, aport);
            if (this.connstate != 0)
            {
                return;
            }
            this.connstate = 1;
            try
            {
                this.socket.connect(aaddress, aport);
                if (Comm.commlog >= 2)
                {
                    DBG.Trace("BinarySocket(" + this.type + "), CONNECT");
                }
            }
            catch (err:Error)
            {
                if (Comm.commlog >= 2)
                {
                    DBG.Trace("BinarySocket(" + this.type + "), CONNECT ERROR:" + err.toString());
                }
                this.connstate = -1;
            }
        }

        public function Identify():void
        {
            if (this.connstate != 2)
            {
                return;
            }
            if (Comm.commlog >= 2)
            {
                DBG.Trace("BinarySocket(" + this.type + "), IDENTIFY");
            }
            this.connstate = 3;
            var string:* = "<IDENTIFY CID=\"" + Comm.connid + "\" CC=\"" + Comm.clientcc + "\" />";
            var buffer:ByteArray = CommCrypt.BinaryEncrypt(string, true);
            var encreq:ByteArray = new ByteArray();
            encreq.endian = Endian.LITTLE_ENDIAN;
            var header:uint = uint(buffer.length + 4 << 8);
            encreq.writeUnsignedInt(header);
            encreq.writeBytes(buffer);
            this.Send(encreq);
        }

        public function Close():void
        {
            if (Comm.commlog >= 2)
            {
                DBG.Trace("BinarySocket(" + this.type + ") CLOSE");
            }
            if (this.connstate > 0)
            {
                this.connstate = 0;
                if (this.socket.connected)
                {
                    this.socket.close();
                }
            }
        }

        public function ProcessIdentify(adata:ByteArray):void
        {
            var dec:String;
            var xml:XML;
            var nodelist:XMLList;
            var tag:Object;
            var res:int;
            if (this.connstate != 3)
            {
                return;
            }
            dec = CommCrypt.BinaryDecrypt(adata, true);
            xml = null;
            try
            {
                xml = new XML("<?xml version=\"1.0\" encoding=\"utf-8\"?><ROOT>" + dec + "</ROOT>");
            }
            catch (e:Error)
            {
                if (Comm.commlog >= 2)
                {
                    DBG.Trace("BinarySocket(" + this.type + "), xml error in process identify");
                }
                this.Close();
                this.connstate = 0;
                return;
            }
            nodelist = xml.children();
            tag = Util.XMLTagToObject(nodelist[0]);
            res = Util.NumberVal(tag.R);
            if (res == 0)
            {
                if (Comm.commlog >= 2)
                {
                    DBG.Trace("BinarySocket(" + this.type + "), successfully identified");
                }
                this.connstate = 5;
            }
            else
            {
                if (Comm.commlog >= 2)
                {
                    DBG.Trace("BinarySocket(" + this.type + "), identify result error:" + res);
                }
                this.connstate = 2;
            }
        }

        public function OnData(event:ProgressEvent):void
        {
            var header:uint = 0;
            var length:uint = 0;
            var flags:uint = 0;
            var data:ByteArray = null;
            this.socket.readBytes(this.buffer, this.buffer.length);
            while (this.buffer.length >= 4)
            {
                this.buffer.position = 0;
                header = this.buffer.readUnsignedInt();
                length = uint(header >> 8);
                flags = uint(header & 0xFF);
                if (length > this.buffer.length)
                {
                    return;
                }
                data = new ByteArray();
                data.endian = Endian.LITTLE_ENDIAN;
                data.writeBytes(this.buffer, 4, length - 4);
                if (this.connstate == 3)
                {
                    this.ProcessIdentify(data);
                }
                else if (this.connstate >= 4)
                {
                    if (this.connstate == 4)
                    {
                        this.connstate = 5;
                    }
                    Comm.DataReceived(data, this.type, flags, "TCP");
                }
                else if (Comm.commlog >= 2)
                {
                    DBG.Trace("BinarySocket(" + this.type + "), data received in wrong state:" + this.connstate);
                }
                data.clear();
                data.writeBytes(this.buffer, length);
                this.buffer = data;
            }
        }

        public function OnConnect(event:Event):void
        {
            if (event && event.target && Boolean(event.target.connected))
            {
                if (Comm.commlog >= 2)
                {
                    DBG.Trace("BinarySocketConnected(" + this.type + "), event:" + event.toString());
                }
                this.connstate = 2;
                if (Comm.connstate >= 4 && Comm.connid != "")
                {
                    this.Identify();
                }
            }
        }

        public function OnClose(event:Event):void
        {
            var cs:int = this.connstate;
            this.Close();
            this.connstate = 0;
            if (cs < 4)
            {
                DBG.Trace("BinarySocketClosed(" + this.type + ") BEFORE IDENTIFY. CHECK THE XSOCKETPORT VALUE IN clientparams.xml");
            }
        }

        public function OnIOError(event:IOErrorEvent):void
        {
            if (Comm.commlog >= 2)
            {
                DBG.Trace("BinarySocketIOError(" + this.type + ")");
            }
            this.Close();
        }

        public function OnSecurityError(event:SecurityErrorEvent):void
        {
            if (Comm.commlog >= 2)
            {
                DBG.Trace("BinarySocketSecurityError(" + this.type + ")");
            }
            this.Close();
        }
    }
}
