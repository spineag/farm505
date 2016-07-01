/**
 * Created by andriy.grynkiv on 9/16/14.
 */
package media {
import com.junkbyte.console.Cc;

import flash.media.Sound;
import flash.system.ApplicationDomain;

import manager.Vars;

public class SoundManager {
    private var musics:Object = {};
    private var sounds:Object = {};
    private var _isPlayingMusic:Boolean = true;
    private var _isPlayingSound:Boolean = true;
    private var g:Vars = Vars.getInstance();

    public function SoundManager() {}

    public function load():void {
        var url:String = g.dataPath.getGraphicsPath() + 'sounds/sounds.swf';
        g.load.loadSWFModule(url, loaded);
    }

    private function loaded(response:ApplicationDomain):void {
        var i:int;
        var sound:Sound;
        var cl:Class;
        try {
            if (response.hasDefinition("farm_music")) {
                cl = response.getDefinition("farm_music") as Class;
                sound = new cl();
                addMusic(SoundConst.MAIN_MUSIC, sound);
            }

            i = 0;
            while (response.hasDefinition("Sound" + String(++i))) {
                cl = response.getDefinition("Sound" + String(i)) as Class;
                sound = new cl();
                addSound(i, sound);
            }
        } catch (e:Error) {
            Cc.error('soundManagerError after loaded: ' + e.message);
        }
        if (_isPlayingMusic) playMusic();
    }

    private function addMusic(id:int, snd:Sound):void {
        musics[id] = new GSound(snd);
    }

    private function addSound(id:int, snd:Sound):void {
        sounds[id] = new GSound(snd);
    }

    public function enabledMusic(value:Boolean):void {
        _isPlayingMusic = value;
        if (!_isPlayingMusic) {
            stopAllMusics();
        }
    }

    public function enabledSound(value:Boolean):void {
        _isPlayingSound = value;
        if (!_isPlayingSound) {
            stopAllSounds();
        }
    }

    public function playMusic(count:int = int.MAX_VALUE):void {
        var sound:GSound;
        if (_isPlayingMusic) {
            sound = musics[SoundConst.MAIN_MUSIC];
            if (sound && sound.isPlaying) {
                sound.play(count, true);
            }
        }
    }

    public function playSound(id:int, count:int = 1):void {
        var sound:GSound;
        if (_isPlayingSound) {
            sound = sounds[id];
            if (sound && sound.isPlaying) {
                sound.play(count);
            }
        }
    }

    public function stopSound(id:int):void {
        var sound:GSound;
        if (_isPlayingSound) {
            sound = sounds[id];

            if (sound && sound.isPlaying) {
                sound.stop();
            }
        }
    }

    public function stopAllMusics():void {
        var sound:GSound;
        for (var key:String in musics) {
            sound = musics[key];
            sound.stop();
        }
    }

    public function stopAllSounds():void {
        var sound:GSound;
        var key:String;
        for (key in sounds) {
            sound = sounds[key];
            sound.stop();
        }
    }

    public function get isPlayingMusic():Boolean {
        return _isPlayingMusic;
    }

    public function get isPlayingSound():Boolean {
        return _isPlayingSound;
    }

}
}