/**
 * Created by user on 4/15/16.
 */
package build.farm {
import com.junkbyte.console.Cc;
import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

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
    public function animalArmature(a:Armature, id:int):void {
        if (!a) {
            Cc.error('Animal:: no armature for animalId');
            return;
        }
        _armature = a;
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        if (id!=6) tryUnTouchableZZZ();
    }

    private function tryUnTouchableZZZ():void {
        try {
            var b:Slot = _armature.getSlot('zzz');
            if (b && b.display is Image) {
                (b.display as Image).touchable = false;
            }
            b = _armature.getSlot('zzz copy');
            if (b && b.display is Image) {
                (b.display as Image).touchable = false;
            }
            b = _armature.getSlot('zzz copy 2');
            if (b && b.display is Image) {
                (b.display as Image).touchable = false;
            }
        } catch (e:Error) { 
            Cc.error('Error at animalAnimation: try untouchable ZZZ');
        }
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
        if (!WorldClock.clock.contains(_armature)) WorldClock.clock.add(_armature);
        _armature.animation.stop(_label);
    }

    private function startAnimation():void {
        if (!WorldClock.clock.contains(_armature)) WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlayByFrame(_label);
    }

    private function addListener():void {
        if (_armature && !_armature.hasEventListener(EventObject.COMPLETE)) _armature.addEventListener(EventObject.COMPLETE, onCompleteAnimation);
        if (_armature && !_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.addEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation);
    }

    private function removeListener():void {
        if (_armature && _armature.hasEventListener(EventObject.COMPLETE)) {
            _armature.removeEventListener(EventObject.COMPLETE, onCompleteAnimation);
        }
    }

    private function onCompleteAnimation(e:Event=null):void {
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
