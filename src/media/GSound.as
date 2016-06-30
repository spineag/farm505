/**
 * Created by andriy.grynkiv on 9/16/14.
 */
package media {
import com.greensock.TweenMax;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;

public class GSound {
    private var _sound:Sound;
    private var _soundChanell:SoundChannel;
    private var _isPlaying:Boolean = true;

    public function GSound(snd:Sound = null):void {
        _soundChanell = new SoundChannel();
        snd ? _sound = snd : _sound = new Sound();

        _sound.addEventListener(IOErrorEvent.IO_ERROR, ioError);
    }

    public function load(stream:URLRequest):void {
        _sound.load(stream);
    }

    public function play(count:int = 0, useVolume:Boolean = false):void {
        var sd:SoundTransform;

        if (useVolume) {
            sd = new SoundTransform(0);
        } else {
            sd = null;
        }

        if (useVolume) {
            _soundChanell = _sound.play(0, count, sd);
            if (!_soundChanell) return;
            TweenMax.to(_soundChanell, 1.5, {volume:1});
        } else {
            _soundChanell = _sound.play(0, count);
        }
    }

    public function stop():void {
        if (!_soundChanell) return;

        TweenMax.killTweensOf(_soundChanell);
        _soundChanell.stop();
    }

    public function get isPlaying():Boolean {
        return _isPlaying;
    }

    private function ioError(e:IOErrorEvent):void {
        _isPlaying = false;
    }
}
}