package syscode
{
    import flash.events.*;
    import flash.media.*;

    public class Sounds
    {
        public static var sounds:Object = {};

        public static var baseurl:String = "sounds/";

        public static var langid:String = "en/";

        public static var loadqueue:Array = [];

        public static var loadcallback:Function = null;

        public static var loading:Boolean = false;

        public static var buffered:Boolean = true;

        public static var newname:String = "";

        public static var newsound:Sound = null;

        public static var newurl:String = "";

        public static var voiceid:String = "";

        public static var volume_master:Number = 1;

        public static var volume_effect:Number = 0.75;

        public static var volume_voice:Number = 0.75;

        public static var volume_music:Number = 0.75;

        public static var playlist:Array = [];

        public static var increment:int = 0;

        public static function Init():void
        {
            SetSound("Click", "sounds/click.mp3", "general");
            SetSound("gold", "sounds/gold.mp3", "general");
            SetSound("fortress_using", "sounds/booster-using-architect.mp3", "triviador");
            SetSound("selhalf_using", "sounds/booster-using-blacksmith.mp3", "triviador");
            SetSound("subject_using", "sounds/booster-using-general.mp3", "triviador");
            SetSound("selansw_using", "sounds/booster-using-innkeeper.mp3", "triviador");
            SetSound("tipaver_using", "sounds/booster-using-petmerchant.mp3", "triviador");
            SetSound("tiprang_using", "sounds/booster-using-scientist.mp3", "triviador");
            SetSound("airborne_using", "sounds/booster-using-wizard.mp3", "triviador");
            SetSound("arrow_shoot", "sounds/arrow1.mp3", "triviador");
            SetSound("arrow_hit", "sounds/arrow2.mp3", "triviador");
            SetSound("board_appear", "sounds/board_appear.mp3", "triviador");
            SetSound("score_change", "sounds/change_points.mp3", "triviador");
            SetSound("question_in", "sounds/qwindow_appear.mp3", "triviador");
            SetSound("question_out", "sounds/qwindow_out.mp3", "triviador");
            SetSound("guess_good_answer", "sounds/guess_good_answer.mp3", "triviador");
            SetSound("fanfare_win", "sounds/fanfare_win.mp3", "triviador");
            SetSound("fanfare_lose", "sounds/fanfare_lose.mp3", "triviador");
            SetSound("fanfare_draw", "sounds/fanfare_draw.mp3", "triviador");
            SetSound("gong", "sounds/gong.mp3", "triviador");
            SetSound("explosion", "sounds/explosion.mp3", "triviador");
            SetSound("explosion_reverse", "sounds/explosion_reverse.mp3", "triviador");
            SetSound("swords_drawn", "sounds/swords_drawn.mp3", "triviador");
            SetSound("territory_select", "sounds/territory_select.mp3", "triviador");
            SetSound("answer_tiktak", "sounds/answer_it.mp3", "triviador");
            SetSound("drum_roll_loop", "sounds/drum_roll_loop.mp3", "triviador");
            SetSound("area_selection", "sounds/select_area.mp3", "triviador");
            SetSound("select_base", "sounds/base_selection.mp3", "triviador");
            SetSound("battle_begin", "sounds/battle_begin.mp3", "triviador");
            SetSound("passive_player", "sounds/passive_player.mp3", "triviador");
            SetSound("help_clicked", "sounds/help_clicked.mp3", "triviador");
            SetSound("fortress_using", "sounds/booster-using-architect.mp3", "triviador");
            if (Config.siteid == "xe" || Config.siteid == "us")
            {
                voiceid = "en";
            }
            if (Config.siteid == "xs" || Config.siteid == "ar")
            {
                voiceid = "xs";
            }
            if (Config.siteid == "es")
            {
                voiceid = "es";
            }
            if (Config.siteid == "br")
            {
                voiceid = "br";
            }
            if (Config.siteid == "tr")
            {
                voiceid = "tr";
            }
            if (Config.siteid == "de")
            {
                voiceid = "de";
            }
            if (Config.siteid == "ru")
            {
                voiceid = "ru";
            }
            if (Config.siteid == "xa")
            {
                voiceid = "xa";
            }
            if (Config.siteid == "hu")
            {
                voiceid = "hu";
            }
            if (voiceid == "")
            {
                return;
            }
            SetSound("voice_answer_it", "sounds/voices_" + voiceid + "/voice_answer_it.mp3", "triviador");
            SetSound("voice_base_selection", "sounds/voices_" + voiceid + "/voice_base_selection.mp3", "triviador");
            SetSound("voice_castle_attack", "sounds/voices_" + voiceid + "/voice_castle_attack.mp3", "triviador");
            SetSound("voice_defeat_laughter", "sounds/voices_" + voiceid + "/voice_defeat_laughter.mp3", "triviador");
            SetSound("voice_draw", "sounds/voices_" + voiceid + "/voice_draw.mp3", "triviador");
            SetSound("voice_en_garde", "sounds/voices_" + voiceid + "/voice_en_garde.mp3", "triviador");
            SetSound("voice_expand_your_empire", "sounds/voices_" + voiceid + "/voice_expand_your_empire.mp3", "triviador");
            SetSound("voice_fall_back", "sounds/voices_" + voiceid + "/voice_fall_back.mp3", "triviador");
            SetSound("voice_final_guess", "sounds/voices_" + voiceid + "/voice_final_guess.mp3", "triviador");
            SetSound("voice_final_round", "sounds/voices_" + voiceid + "/voice_final_round.mp3", "triviador");
            SetSound("voice_first_round", "sounds/voices_" + voiceid + "/voice_first_round.mp3", "triviador");
            SetSound("voice_fourth_round", "sounds/voices_" + voiceid + "/voice_fourth_round.mp3", "triviador");
            SetSound("voice_full_map_victory", "sounds/voices_" + voiceid + "/voice_full_map_victory.mp3", "triviador");
            SetSound("voice_game_over", "sounds/voices_" + voiceid + "/voice_game_over.mp3", "triviador");
            SetSound("voice_glorious_victory", "sounds/voices_" + voiceid + "/voice_glorious_victory.mp3", "triviador");
            SetSound("voice_go_for_the_win", "sounds/voices_" + voiceid + "/voice_go_for_the_win.mp3", "triviador");
            SetSound("voice_guess_fast", "sounds/voices_" + voiceid + "/voice_guess_fast.mp3", "triviador");
            SetSound("voice_hurry", "sounds/voices_" + voiceid + "/voice_hurry.mp3", "triviador");
            SetSound("voice_in_the_lead", "sounds/voices_" + voiceid + "/voice_in_the_lead.mp3", "triviador");
            SetSound("voice_last_chance_to_win", "sounds/voices_" + voiceid + "/voice_last_chance_to_win.mp3", "triviador");
            SetSound("voice_last_tower", "sounds/voices_" + voiceid + "/voice_last_tower.mp3", "triviador");
            SetSound("voice_let_the_battle_begin", "sounds/voices_" + voiceid + "/voice_let_the_battle_begin.mp3", "triviador");
            SetSound("voice_second_round", "sounds/voices_" + voiceid + "/voice_second_round.mp3", "triviador");
            SetSound("voice_spreading", "sounds/voices_" + voiceid + "/voice_spreading.mp3", "triviador");
            SetSound("voice_third_round", "sounds/voices_" + voiceid + "/voice_third_round.mp3", "triviador");
            SetSound("voice_too_slow", "sounds/voices_" + voiceid + "/voice_too_slow.mp3", "triviador");
            SetSound("voice_victory", "sounds/voices_" + voiceid + "/voice_victory.mp3", "triviador");
            SetSound("voice_yess", "sounds/voices_" + voiceid + "/voice_yess.mp3", "triviador");
            SetSound("voice_you_are_the_last", "sounds/voices_" + voiceid + "/voice_you_are_the_last.mp3", "triviador");
            SetSound("voice_you_came_in_second", "sounds/voices_" + voiceid + "/voice_you_came_in_second.mp3", "triviador");
            SetSound("voice_you_have_been_destroyed", "sounds/voices_" + voiceid + "/voice_you_have_been_destroyed.mp3", "triviador");
            SetSound("voice_you_have_conquered_the_blue_empire", "sounds/voices_" + voiceid + "/voice_you_have_conquered_the_blue_empire.mp3", "triviador");
            SetSound("voice_you_have_conquered_the_green_empire", "sounds/voices_" + voiceid + "/voice_you_have_conquered_the_green_empire.mp3", "triviador");
            SetSound("voice_you_have_conquered_the_red_empire", "sounds/voices_" + voiceid + "/voice_you_have_conquered_the_red_empire.mp3", "triviador");
        }

        public static function LogSoundObj(sn:Object):void
        {
            trace("---Logging sound---: " + sn.name);
            trace("snd: " + sn.snd);
            trace("url: " + sn.url);
            trace("tags: " + sn.tags);
            trace("loaded: " + sn.loaded);
        }

        public static function LoadSounds(atag:String, acallback:Function = null):void
        {
            var so:Object = null;
            var stags:* = null;
            var tag:* = "," + atag.toUpperCase() + ",";
            for each (so in sounds)
            {
                stags = "," + so.tags + ",";
                if (stags.indexOf(tag) >= 0)
                {
                    loadqueue.push(so.name);
                }
            }
            loadcallback = acallback;
            InternalLoadSounds();
        }

        public static function SetSound(aname:String, aurl:String, atags:String):Object
        {
            var ucname:String = aname.toUpperCase();
            var o:Object = {
                    "name": ucname,
                    "snd": null,
                    "url": aurl,
                    "tags": atags.toUpperCase(),
                    "loaded": false
                };
            sounds[ucname] = o;
            return o;
        }

        public static function InternalLoadSounds():void
        {
            var OnSoundLoaded:Function;
            var ucname:String = null;
            var sobj:Object = null;
            while (loadqueue.length > 0)
            {
                ucname = loadqueue.shift();
                sobj = sounds[ucname];
                if (!sobj)
                {
                    trace("Sounds.LoadSounds error: Invalid sound name: \"" + ucname + "\"");
                }
                else if (!sobj.loaded)
                {
                    OnSoundLoaded = function(asnd:Sound):void
                    {
                        sobj.snd = asnd;
                        InternalLoadSounds();
                    };
                    sobj.loaded = true;
                    MyLoader.LoadSound(Config.bootparams.appbaseurl + "assets/" + sobj.url, OnSoundLoaded);
                    return;
                }
            }
            if (loadcallback != null)
            {
                loadcallback();
            }
        }

        public static function InternalPlaySound(aname:String, type:String, startTime:Number, loops:int, onReadyCallback:Function = null):int
        {
            var sn:Sound;
            var mul:Number;
            var tr:SoundTransform;
            var ch:SoundChannel = null;
            var pid:int = 0;
            var func:* = undefined;
            var id3:ID3Info = null;
            var error:String = "";
            var name:String = aname.toUpperCase();
            var overdub:Boolean = false;
            if (type == "voice")
            {
                overdub = Boolean(Sounds.IsPlaying(name));
            }
            if (Sounds.sounds[name] === undefined || Sounds.sounds[name] == null || overdub)
            {
                if (typeof onReadyCallback == "function" && onReadyCallback != null)
                {
                    onReadyCallback.apply(null, null);
                }
                return 0;
            }
            sn = null;
            try
            {
                sn = Sounds.sounds[name].snd as Sound;
            }
            catch (err:Error)
            {
                error = String(err.toString());
                sn = null;
            }
            LogSoundObj(Sounds.sounds[name]);
            if (sn == null)
            {
                Comm.ClientTrace(23, "Sounds.InternalPlaySound(\"" + name + "\"):\"sound - skip\" " + error);
                if (typeof onReadyCallback == "function" && onReadyCallback != null)
                {
                    onReadyCallback.apply(null, null);
                }
                return 0;
            }
            mul = 1;
            try
            {
                id3 = sn.id3;
                if (Boolean(id3) && Boolean(id3.comment))
                {
                    mul = Util.NumberVal(id3.comment, mul);
                }
            }
            catch (err:Error)
            {
                mul = 1;
            }
            ch = null;
            try
            {
                trace("replacing `ch = sn.play(startTime * 1000,loops), removing starting time`");
                trace("FIXME: not assigning to variable ch -> sound volume doesn't work'");
                ch = Sounds.sounds[name].snd.play(0, loops);
            }
            catch (err:Error)
            {
                trace("sn.play error: " + err.toString());
                error = String(err.toString());
                ch = null;
            }
            if (ch == null)
            {
                if (typeof onReadyCallback == "function" && onReadyCallback != null)
                {
                    onReadyCallback.apply(null, null);
                }
                return 0;
            }
            tr = ch.soundTransform;
            if (type == "effect")
            {
                tr.volume = mul * Sounds.volume_effect * Sounds.volume_master;
            }
            if (type == "voice")
            {
                tr.volume = mul * Sounds.volume_voice * Sounds.volume_master;
            }
            if (type == "music")
            {
                tr.volume = mul * Sounds.volume_music * Sounds.volume_master;
            }
            trace("volume: " + tr.volume);
            trace("Sounds.volume_master " + Sounds.volume_master);
            trace("Sounds.volume_effect " + Sounds.volume_effect);
            trace("Sounds.volume_voice " + Sounds.volume_voice);
            trace("Sounds.volume_music " + Sounds.volume_music);
            ch.soundTransform = tr;
            pid = int(++Sounds.increment);
            func = function(event:Event):void
            {
                trace("sound completed");
                var i:int = 0;
                while (i < Sounds.playlist.length)
                {
                    if (Sounds.playlist[i].id == pid)
                    {
                        Sounds.playlist.splice(i, 1);
                    }
                    else
                    {
                        i++;
                    }
                }
                if (typeof onReadyCallback == "function" && onReadyCallback != null)
                {
                    onReadyCallback.apply(null, null);
                }
                Util.RemoveEventListener(ch, Event.SOUND_COMPLETE, func);
            };
            Util.AddEventListener(ch, Event.SOUND_COMPLETE, func);
            Sounds.playlist.push({
                        "name": name,
                        "type": type,
                        "channel": ch,
                        "id": pid,
                        "volmul": mul,
                        "func": func
                    });
            return pid;
        }

        public static function InternalStopSound(aname:String, type:String):void
        {
            var ch:SoundChannel = null;
            var name:String = aname.toUpperCase();
            if (Sounds.sounds[name] === undefined)
            {
                return;
            }
            if (Sounds.sounds[name] == null)
            {
                return;
            }
            var i:int = 0;
            while (i < Sounds.playlist.length)
            {
                if (name == Sounds.playlist[i].name && (type == Sounds.playlist[i].type || type == ""))
                {
                    ch = Sounds.playlist[i].channel;
                    ch.stop();
                    Util.RemoveEventListener(ch, Event.SOUND_COMPLETE, Sounds.playlist[i].func);
                    Sounds.playlist.splice(i, 1);
                }
                else
                {
                    i++;
                }
            }
        }

        public static function PlayEffect(name:String, startTime:Number = 0, onReadyCallback:Function = null):int
        {
            trace("PlayEffect: " + name);
            try
            {
                return InternalPlaySound(name, "effect", startTime, 1, onReadyCallback);
            }
            catch (err:Error)
            {
                Comm.ClientTrace(24, "Sounds.PlayEffect(\"" + name + "\"): " + err.toString());
                if (typeof onReadyCallback == "function" && onReadyCallback != null)
                {
                    onReadyCallback.apply(null, null);
                }
            }
            return 0;
        }

        public static function StopEffect(name:String):void
        {
            try
            {
                InternalStopSound(name, "effect");
            }
            catch (err:Error)
            {
                Comm.ClientTrace(24, "Sounds.StopEffect(\"" + name + "\"): " + err.toString());
            }
        }

        public static function PlayVoice(name:String, startTime:Number = 0, onReadyCallback:Function = null):int
        {
            trace("PlayVoice: " + name);
            try
            {
                return InternalPlaySound(name, "voice", startTime, 1, onReadyCallback);
            }
            catch (err:Error)
            {
                Comm.ClientTrace(24, "Sounds.PlayVoice(\"" + name + "\"): " + err.toString());
                if (typeof onReadyCallback == "function" && onReadyCallback != null)
                {
                    onReadyCallback.apply(null, null);
                }
            }
            return 0;
        }

        public static function StopVoice(name:String):void
        {
            try
            {
                InternalStopSound(name, "voice");
            }
            catch (err:Error)
            {
                Comm.ClientTrace(24, "Sounds.StopVoice(\"" + name + "\"): " + err.toString());
            }
        }

        public static function PlayMusic(name:String, startTime:Number = 0, loops:int = 999999, onReadyCallback:Function = null):int
        {
            trace("PlayMusic: " + name);
            try
            {
                return InternalPlaySound(name, "music", startTime, loops, onReadyCallback);
            }
            catch (err:Error)
            {
                Comm.ClientTrace(24, "Sounds.PlayMusic(\"" + name + "\"): " + err.toString());
                if (typeof onReadyCallback == "function" && onReadyCallback != null)
                {
                    onReadyCallback.apply(null, null);
                }
            }
            return 0;
        }

        public static function StopMusic(name:String):void
        {
            try
            {
                InternalStopSound(name, "music");
            }
            catch (err:Error)
            {
                Comm.ClientTrace(24, "Sounds.StopMusic(\"" + name + "\"): " + err.toString());
            }
        }

        public static function StopAll(name:String):void
        {
            try
            {
                InternalStopSound(name, "");
            }
            catch (err:Error)
            {
                Comm.ClientTrace(24, "Sounds.StopAll(\"" + name + "\"): " + err.toString());
            }
        }

        public static function SetVolume(vol_eff:Number, vol_voi:Number, vol_mus:Number):void
        {
            var ch:SoundChannel = null;
            var tr:SoundTransform = null;
            var vm:Number = NaN;
            var i:int = 0;
            Sounds.volume_effect = vol_eff;
            Sounds.volume_voice = vol_voi;
            Sounds.volume_music = vol_mus;
            i = 0;
            while (i < Sounds.playlist.length)
            {
                vm = Number(Sounds.playlist[i].volmul);
                ch = Sounds.playlist[i].channel;
                tr = ch.soundTransform;
                if (Sounds.playlist[i].type == "effect")
                {
                    tr.volume = vm * Sounds.volume_effect * Sounds.volume_master;
                }
                if (Sounds.playlist[i].type == "voice")
                {
                    tr.volume = vm * Sounds.volume_voice * Sounds.volume_master;
                }
                if (Sounds.playlist[i].type == "music")
                {
                    tr.volume = vm * Sounds.volume_music * Sounds.volume_master;
                }
                ch.soundTransform = tr;
                i++;
            }
        }

        public static function IsPlaying(aname:String):Boolean
        {
            var name:String = aname.toUpperCase();
            var run:* = false;
            var i:int = 0;
            while (i < Sounds.playlist.length)
            {
                if (Sounds.playlist[i].name == name)
                {
                    run = true;
                    break;
                }
                i++;
            }
            return run;
        }

        public function Sounds()
        {
            super();
        }
    }
}
