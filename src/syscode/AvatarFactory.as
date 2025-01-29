package syscode
{
    import com.greensock.TweenMax;
    import com.greensock.easing.Linear;

    import fl.transitions.easing.Regular;

    import flash.display.*;
    import flash.filters.DropShadowFilter;
    import flash.geom.Matrix;

    public class AvatarFactory
    {
        public static var propcounts:Array = [null, {}, {}];

        public static var sexcount:int = 2;

        public static var headcount:int = 6;

        public static var back_colors:Array = [16777215, 11918264, 12313327, 16776136, 16763379, 15263976, 10780768, 8434615, 14662005, 16096256, 4693059, 12352963, 8618883, 2518197];

        public static var head_colors:Array = [16773360, 16767449, 16243127, 15968120, 12154929, 7621407];

        public static var hair_colors:Array = [16769924, 13541120, 16358443, 13192477, 6827550, 2102541, 15658734];

        public static var eye_colors:Array = [0, 8026746, 1600173, 3188644, 2193437, 9656380];

        public static var male_facial_colors:Array = [16769924, 13541120, 16358443, 13192477, 6827550, 2102541, 15658734];

        public static var female_hairdecor_colors:Array = [16769924, 16742263, 11158783, 15289629, 5614165, 3355443, 15658734, 5605631];

        private static var avatarmc:MovieClip = null;

        private static var symbolsmc:MovieClip = null;

        private static var data:Object = [null, {}, {}];

        private static var anims:* = {
                "eyeanim": 1,
                "mouthanim": 1
            };

        public static function Init():void
        {
            AnalyzeAssetMov();
        }

        public static function AnalyzeAssetMov():*
        {
            var pc:Object = null;
            var j:int = 0;
            var i:int = 0;
            var cmov:MovieClip = null;
            var nameparts:Array = null;
            var propname:String = null;
            var colorcode:int = 0;
            var propnum:int = 0;
            var n:int = 0;
            var mc:MovieClip = NewAvatarMC();
            for (var sex:int = 2; sex >= 1; sex--)
            {
                mc.gotoAndStop(sex);
                pc = propcounts[sex];
                pc.head = 0;
                pc.backcolor = back_colors.length;
                pc.headcolor = head_colors.length;
                pc.haircolor = hair_colors.length;
                pc.eyecolor = eye_colors.length;
                pc.facialcolor = sex == 1 ? male_facial_colors.length : female_hairdecor_colors.length;
                for (j = 1; j < mc.HEAD.totalFrames; j++)
                {
                    mc.HEAD.gotoAndStop(j);
                    data[sex][j] = [];
                    pc.hair = 0;
                    pc.eye = 0;
                    pc.eyeanim = 0;
                    pc.ear = 0;
                    pc.mouth = 0;
                    pc.mouthanim = 0;
                    pc.nose = 0;
                    pc.facial = 0;
                    pc.armor = 0;
                    pc.armorb = 0;
                    pc.hairb = 0;
                    for (i = 0; i < mc.HEAD.numChildren; i++)
                    {
                        cmov = MovieClip(mc.HEAD.getChildAt(i));
                        nameparts = cmov.name.split("_");
                        propname = Util.StringVal(nameparts[0]).toLowerCase();
                        colorcode = Util.NumberVal(nameparts[1]);
                        propnum = Util.NumberVal(nameparts[3]);
                        if (nameparts.length >= 3 && pc[propname] !== undefined)
                        {
                            n = pc[propname] + 1;
                            data[sex][j].push({
                                        "id": n,
                                        "classdef": cmov.constructor,
                                        "name": propname,
                                        "color": colorcode,
                                        "num": propnum,
                                        "x": cmov.x,
                                        "y": cmov.y,
                                        "scaleX": cmov.scaleX,
                                        "scaleY": cmov.scaleY,
                                        "rotation": cmov.rotation
                                    });
                            pc[propname] += 1;
                        }
                    }
                }
            }
            mc = null;
        }

        public static function GetSymbolIndex(sex:int, head:int, m:MovieClip):*
        {
            var assets:Array = data[sex][head];
            for (var i:int = 0; i < assets.length; i++)
            {
                if (assets[i].classdef == m.constructor)
                {
                    return assets[i].id;
                }
            }
        }

        public static function NewSymbols(aname:String, asex:int):Array
        {
            var i:int = 0;
            var symbols:* = undefined;
            var cmov:MovieClip = null;
            var mcclass:Class = Modules.GetClass("avatars", "AVATARHEAD");
            if (mcclass)
            {
                if (!symbolsmc)
                {
                    symbolsmc = new mcclass() as MovieClip;
                }
                symbols = [];
                symbolsmc.gotoAndStop(asex);
                symbolsmc.TOOLS.gotoAndStop("CLEAR");
                symbolsmc.TOOLS.gotoAndStop(1);
                for (i = 0; i < symbolsmc.TOOLS.numChildren; i++)
                {
                    cmov = MovieClip(symbolsmc.TOOLS.getChildAt(i));
                    if (cmov.name.split("_")[0] == aname)
                    {
                        symbols.push(cmov);
                    }
                }
                return symbols;
            }
            return [];
        }

        public static function NewAvatarMC():MovieClip
        {
            var mc:MovieClip = null;
            var mcclass:Class = Modules.GetClass("avatars", "AVATARHEAD");
            if (mcclass)
            {
                return new mcclass() as MovieClip;
            }
            return null;
        }

        public static function StartAnim(members:Object, anim:int = 0, repeat:int = 10):*
        {
            var m:MovieClip = null;
            var k:* = undefined;
            var eyes:MovieClip = null;
            var eyesanim:MovieClip = null;
            var ex:Number = NaN;
            var ey:Number = NaN;
            var Blink:Function = null;
            TweenMax.killChildTweensOf(members.mc, false);
            switch (anim)
            {
                case 0:
                    eyes = members.eye[members.properties.eye - 1];
                    if (Boolean(eyes) && Boolean(eyes.BASE))
                    {
                        Blink = function():*
                        {
                            TweenMax.delayedCall(0.1, function():*
                                {
                                    eyes.gotoAndStop(1);
                                    eyes.BASE.visible = true;
                                    var d:Number = Math.random() * 10 < 1 ? 0.2 : Math.random() * 4;
                                    TweenMax.to(eyes.BASE, d / 6, {
                                                "x": ex + Math.random() * 7 - 6,
                                                "y": ey + Math.random() * 6 - 4
                                            });
                                    TweenMax.to(eyes.BASE, 0, {
                                                "visible": false,
                                                "ease": Linear.easeNone,
                                                "delay": d + 0.1
                                            });
                                    TweenMax.fromTo(eyes, 0.1, {"frame": 1}, {
                                                "frame": 2,
                                                "ease": Linear.easeNone,
                                                "delay": d,
                                                "onComplete": Blink
                                            });
                                });
                        };
                        ex = Number(eyes.BASE.x);
                        ey = Number(eyes.BASE.y);
                        Blink();
                    }
                    break;
                case 1:
                    for (k in members.properties)
                    {
                        if (members[k] && k != "armor" && k != "armorb")
                        {
                            if (anims[k])
                            {
                                m = members[k][anim - 1];
                            }
                            else if (k == "hairb")
                            {
                                m = members[k][members.properties["hair"] - 1];
                            }
                            else
                            {
                                m = members[k][members.properties[k] - 1];
                            }
                            if (m)
                            {
                                TweenMax.to(m, 0.2, {
                                            "y": m.y - 10,
                                            "repeat": repeat,
                                            "yoyo": true,
                                            "ease": Regular.easeInOut,
                                            "onComplete": RestoreDefaultAnim,
                                            "onCompleteParams": [members]
                                        });
                            }
                        }
                    }
                    break;
                case 2:
                    for (k in members.properties)
                    {
                        if (members[k] && k != "armor" && k != "armorb")
                        {
                            if (anims[k])
                            {
                                m = members[k][anim - 1];
                            }
                            else if (k == "hairb")
                            {
                                m = members[k][members.properties["hair"] - 1];
                            }
                            else
                            {
                                m = members[k][members.properties[k] - 1];
                            }
                            if (m)
                            {
                                TweenMax.to(m, 0.1, {
                                            "x": m.x - 5,
                                            "repeat": (repeat == -1 ? -1 : repeat * 2),
                                            "yoyo": true,
                                            "ease": Regular.easeInOut,
                                            "onComplete": RestoreDefaultAnim,
                                            "onCompleteParams": [members]
                                        });
                            }
                        }
                    }
                    break;
                case 3:
                    for (k in members.properties)
                    {
                        if (members[k] && k != "armor" && k != "armorb")
                        {
                            if (anims[k])
                            {
                                m = members[k][anim - 1];
                            }
                            else if (k == "hairb")
                            {
                                m = members[k][members.properties["hair"] - 1];
                            }
                            else
                            {
                                m = members[k][members.properties[k] - 1];
                            }
                            if (m)
                            {
                                TweenMax.to(m, 0.12, {
                                            "y": m.y - 3,
                                            "repeat": (repeat == -1 ? -1 : repeat * 2),
                                            "yoyo": true,
                                            "ease": Regular.easeInOut,
                                            "onComplete": RestoreDefaultAnim,
                                            "onCompleteParams": [members]
                                        });
                            }
                        }
                    }
                    eyesanim = members.eyeanim[anim - 1];
                    if (eyesanim)
                    {
                        TweenMax.fromTo(eyesanim, 0.8, {"frame": 1}, {
                                    "frame": 20,
                                    "ease": Linear.easeNone,
                                    "repeat": -1
                                });
                    }
            }
        }

        public static function PreviewAnim(members:Object, anim:int = 0):*
        {
            var m:MovieClip = null;
            var k:* = undefined;
            TweenMax.killChildTweensOf(members.mc, false);
            switch (anim)
            {
                case 0:
                case 1:
                case 2:
                    break;
                case 3:
                    for (k in members.properties)
                    {
                        if (Boolean(members[k]) && k == "eyeanim")
                        {
                            m = members[k][anim - 1];
                            if (m)
                            {
                                m.gotoAndStop(15);
                            }
                        }
                    }
            }
        }

        public static function RestoreDefaultAnim(members:*):*
        {
            UpdateProperties(members.mc, members.properties, members, 0);
            StartAnim(members);
        }

        public static function CloneProperties(p:Object):Object
        {
            var prop:String = null;
            var p2:Object = {};
            for (prop in p)
            {
                p2[prop] = p[prop];
            }
            return p2;
        }

        public static function CreateProperties(astr:String = ""):Object
        {
            var p:Object = {};
            p.sex = 1;
            p.head = 1;
            p.hair = 1;
            p.eye = 1;
            p.eyeanim = 0;
            p.ear = 1;
            p.mouth = 1;
            p.mouthanim = 0;
            p.nose = 1;
            p.facial = 1;
            p.armor = 1;
            p.armorb = 1;
            p.backcolor = 1;
            p.headcolor = 1;
            p.haircolor = 1;
            p.eyecolor = 1;
            p.facialcolor = 1;
            if (astr != "")
            {
                ChangeSex(p, Util.NumberVal(astr.substr(0, 1)));
                SetProperty(p, "head", Util.HexToInt(astr.substr(2, 2)));
                SetProperty(p, "hair", Util.HexToInt(astr.substr(4, 2)));
                SetProperty(p, "eye", Util.HexToInt(astr.substr(6, 2)));
                SetProperty(p, "ear", Util.HexToInt(astr.substr(8, 2)));
                SetProperty(p, "mouth", Util.HexToInt(astr.substr(10, 2)));
                SetProperty(p, "nose", Util.HexToInt(astr.substr(12, 2)));
                SetProperty(p, "facial", Util.HexToInt(astr.substr(14, 2)));
                SetProperty(p, "backcolor", Util.HexToInt(astr.substr(17, 2)));
                SetProperty(p, "headcolor", Util.HexToInt(astr.substr(19, 2)));
                SetProperty(p, "haircolor", Util.HexToInt(astr.substr(21, 2)));
                SetProperty(p, "eyecolor", Util.HexToInt(astr.substr(23, 2)));
                SetProperty(p, "facialcolor", Util.HexToInt(astr.substr(25, 2)));
            }
            else
            {
                RandomizeProperties(p, Util.NumberVal(astr.substr(0, 1)));
            }
            return p;
        }

        public static function RandomizeProperties(p:Object, asex:int):*
        {
            var prop:String = null;
            ChangeSex(p, asex);
            var pc:Object = AvatarFactory.propcounts[p.sex];
            for (prop in pc)
            {
                p[prop] = Util.Random(pc[prop], 1);
            }
        }

        public static function ChangeSex(p:Object, asex:int):*
        {
            var pname:* = undefined;
            var maxvalue:int = 0;
            p.sex = asex;
            if (p.sex < 1)
            {
                p.sex = 1;
            }
            if (p.sex > sexcount)
            {
                p.sex = sexcount;
            }
            for (pname in propcounts[p.sex])
            {
                maxvalue = int(propcounts[p.sex][pname]);
                if (Util.NumberVal(p[pname]) < 1)
                {
                    p[pname] = 1;
                }
                else if (Util.NumberVal(p[pname]) > maxvalue)
                {
                    p[pname] = maxvalue;
                }
            }
        }

        public static function SetProperty(p:Object, propname:String, value:int):int
        {
            var maxvalue:int = int(propcounts[p.sex][propname]);
            p[propname] = value;
            if (p[propname] < 1)
            {
                p[propname] = 1;
            }
            if (p[propname] > maxvalue)
            {
                p[propname] = maxvalue;
            }
            return p[propname];
        }

        public static function FormatProperties(p:Object):String
        {
            var s:* = "";
            s += p.sex;
            s += ".";
            s += Util.IntToHex(p.head, 2);
            s += Util.IntToHex(p.hair, 2);
            s += Util.IntToHex(p.eye, 2);
            s += Util.IntToHex(p.ear, 2);
            s += Util.IntToHex(p.mouth, 2);
            s += Util.IntToHex(p.nose, 2);
            s += Util.IntToHex(p.facial, 2);
            s += ".";
            s += Util.IntToHex(p.backcolor, 2);
            s += Util.IntToHex(p.headcolor, 2);
            s += Util.IntToHex(p.haircolor, 2);
            s += Util.IntToHex(p.eyecolor, 2);
            return s + Util.IntToHex(p.facialcolor, 2);
        }

        public static function CreateAvatarMov(p:Object, amembers:Object = null, anim_id:int = 0):MovieClip
        {
            var mc:MovieClip = new MovieClip();
            if (!mc)
            {
                return null;
            }
            UpdateProperties(mc, p, amembers, anim_id);
            return mc;
        }

        public static function CreateAvatarAnim(astr:String, bg:Boolean, amembers:Object = null, anim_id:int = 0):MovieClip
        {
            var properties:Object = CreateProperties(astr);
            var amc:* = CreateAvatarMov(properties, amembers, anim_id);
            if (amembers)
            {
                amembers.mc = amc;
                amembers.properties = properties;
            }
            amc.scaleX = 60 / 250;
            amc.scaleY = amc.scaleX;
            if (!bg)
            {
                amc.BACK.visible = false;
            }
            return amc;
        }

        public static function CreateAvatarBitmap(astr:String, size:int = 35, scale:Number = 1):Bitmap
        {
            var properties:Object = CreateProperties(astr);
            if (!avatarmc)
            {
                avatarmc = CreateAvatarMov(properties);
                avatarmc.scaleX = size / 250;
                avatarmc.scaleY = avatarmc.scaleX;
            }
            else
            {
                UpdateProperties(avatarmc, properties);
            }
            var bmdata:BitmapData = new BitmapData(Math.round(size * scale), Math.round(size * scale), true, 4294967295);
            var m:Matrix = new Matrix();
            var drawsize:Number = size * scale;
            if (size < 70)
            {
                drawsize = size * 1.25 * scale;
            }
            m.scale(drawsize / 250, drawsize / 250);
            m.translate(size / 2 * scale, size / 2 * scale + drawsize / 2);
            bmdata.draw(avatarmc, m, null, null, null, true);
            return new Bitmap(bmdata, "auto", true);
        }

        public static function UpdateProperties(mc:MovieClip, p:Object, amembers:Object = null, anim:int = 0):void
        {
            var a:Object = null;
            var propname:String = null;
            var colorcode:int = 0;
            var k:* = undefined;
            var cmov:MovieClip = null;
            var propnum:int = 0;
            var maxpc:Object = propcounts[p.sex];
            if (!maxpc)
            {
                trace("AvatarFactory: invalid sex: " + p.sex);
                return;
            }
            if (p.head < 1 || p.head > maxpc.head)
            {
                trace("AvatarFactory: invalid head shape: " + p.head);
                return;
            }
            var assets:Object = data[p.sex][p.head];
            Util.RemoveChildren(mc);
            var backclass:Object = Modules.GetClass("avatars", "AvatarBackground");
            mc.BACK = new backclass();
            mc.HEAD = new MovieClip();
            mc.addChild(mc.BACK);
            mc.addChild(mc.HEAD);
            Imitation.SetColor(mc.BACK, back_colors[p.backcolor - 1]);
            var members:Object = amembers;
            if (!members)
            {
                members = {};
            }
            members.hair = [];
            members.hairb = [];
            members.eye = [];
            members.eyeanim = [];
            members.ear = [];
            members.mouth = [];
            members.mouthanim = [];
            members.nose = [];
            members.facial = [];
            members.armor = [];
            members.armorb = [];
            members.head = [];
            for (var i:int = 0; i < assets.length; i++)
            {
                a = assets[i];
                propname = a.name;
                colorcode = int(a.color);
                for (k in p)
                {
                    if (propname == k && (!!anims[propname] ? anim > 0 && a.id == anim : (anim == 0 || !anims[propname + "anim"]) && a.id == p[k]))
                    {
                        // this throws the error: definition classdef could not be found.
                        var tmp:Object = new assets[i];
                        cmov = tmp.classdef();
                        mc.HEAD.addChild(cmov);
                        cmov.x = a.x;
                        cmov.y = a.y;
                        cmov.scaleX = a.scaleX;
                        cmov.scaleY = a.scaleY;
                        cmov.rotation = a.rotation;
                        cmov.gotoAndStop(1);
                        if (propname != "eye" && propname != "eyeanim" && propname != "mouthanim")
                        {
                            cmov.cacheAsBitmap = true;
                        }
                        propnum = int(a.num);
                        if (propname == "armor")
                        {
                            mc.HEAD.ARMOR = cmov;
                        }
                        if (members[propname] !== undefined)
                        {
                            if (propname == "hairb")
                            {
                                cmov.visible = propnum == p.hair;
                                members[propname][propnum - 1] = cmov;
                            }
                            else
                            {
                                members[propname][a.id - 1] = cmov;
                                cmov.visible = true;
                            }
                        }
                        if (propname == "head")
                        {
                            if (cmov.visible && Boolean(cmov.BASE))
                            {
                                cmov.filters = [new DropShadowFilter(6, 45, 0, 0.05, 0, 0)];
                            }
                        }
                        if (cmov.visible && Boolean(cmov.BASE))
                        {
                            if (propname == "head" || propname == "ear" || propname == "nose")
                            {
                                Imitation.SetColor(cmov.BASE, head_colors[p.headcolor - 1]);
                            }
                            else if (propname == "hair" || propname == "hairb")
                            {
                                Imitation.SetColor(cmov.BASE, hair_colors[p.haircolor - 1]);
                            }
                            else if (propname == "eye" || propname == "eyeanim")
                            {
                                Imitation.SetColor(cmov.BASE, eye_colors[p.eyecolor - 1]);
                            }
                            else if (propname == "facial")
                            {
                                Imitation.SetColor(cmov.BASE, p.sex == 2 ? uint(female_hairdecor_colors[p.facialcolor - 1]) : uint(male_facial_colors[p.facialcolor - 1]));
                            }
                        }
                        if (mc != avatarmc)
                        {
                            Imitation.Update(cmov);
                        }
                    }
                }
            }
            Util.StopAllChildrenMov(mc);
        }

        public function AvatarFactory()
        {
            super();
        }
    }
}
