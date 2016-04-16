/**
 * Created by user on 4/15/16.
 */
package build.farm {
import com.junkbyte.console.Cc;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;

import starling.display.Sprite;

public class AnimalAnimation {
    private var _source:Sprite;
    private var _armature:Armature;
    private var _callback:Function;
    private var _playOnce:Boolean;
    private var _label:String;

    public function AnimalAnimation() {
        _source = new Sprite();
    }

    public function get source():Sprite { return _source; }
    public function animalArmature(a:Armature):void {
        if (!a) {
            Cc.error('Animal:: no armature for animalId');
            return;
        }
        _armature = a;
        _source.addChild(_armature.display as Sprite);
    }

    public function playIt(label:String, playOnce:Boolean = false, callback:Function = null):void {
        _callback = callback;
        _playOnce = playOnce;
        _label = label;
        if(_label == null || _label == '') _label = 'idle';

        removeListener();
        addListener();
        startAnimation();
    }

    public function stopItAtLabel(label:String):void {
        _label = label;
        _armature.animation.gotoAndStop(_label, 0);
    }

    private function startAnimation():void {
        if (!WorldClock.clock.contains(_armature)) WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlay(_label);
    }

    private function addListener():void {
        if (_armature && !_armature.hasEventListener(AnimationEvent.COMPLETE)) _armature.addEventListener(AnimationEvent.COMPLETE, onCompleteAnimation);
        if (_armature && !_armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, onCompleteAnimation);
    }

    private function removeListener():void {
        if (_armature && _armature.hasEventListener(AnimationEvent.COMPLETE)) {
            _armature.removeEventListener(AnimationEvent.COMPLETE, onCompleteAnimation);
        }
    }

    private function onCompleteAnimation(e:AnimationEvent):void {
        if (_playOnce) {
            stopIt();
            if (_callback != null) {
                _callback.apply();
            }
        } else {
            removeListener();
            addListener();
            startAnimation();
        }
    }

    public function stopIt():void {
        removeListener();
        WorldClock.clock.remove(_armature);
    }

    public function deleteIt():void {
        _source.removeChild(_armature.display as Sprite);
        _armature.dispose();
        _armature = null;
        _source.dispose();
        _source = null;
    }
}
}
