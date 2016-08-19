/**
 * Created by user on 2/23/16.
 */
package heroes {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import starling.display.Sprite;

public class HeroCatsAnimation {
    private var STATE_FRONT:int = 1;
    private var STATE_BACK:int = 2;
    private var STATE_WORKER:int = 3;

    private var _armature:Armature;
    private var _armatureBack:Armature;
    private var _armatureWorker:Armature;
    private var _catImage:Sprite;
    private var _catBackImage:Sprite;
    private var _catWorkerImage:Sprite;
    private var _callback:Function;
    private var _callbackParams:Array;
    private var _state:int;
    private var _label:String;
    private var _playOnce:Boolean;
    private var _isFlip:Boolean;

    public function HeroCatsAnimation() {
        _state = 0;
        _playOnce = false;
        _isFlip = false;
    }

    public function set catImage(s:Sprite):void { _catImage = s }
    public function set catBackImage(s:Sprite):void { _catBackImage = s }
    public function set catWorkerImage(s:Sprite):void { _catWorkerImage = s }
    public function set catArmature(a:Armature):void { _armature = a; }
    public function set catBackArmature(a:Armature):void { _armatureBack = a; }

    public function set catWorkerArmature(a:Armature):void {
        _catWorkerImage.visible = true;
        _catImage.visible = false;
        _catBackImage.visible = false;
        _armatureWorker = a;
        _catWorkerImage.addChild(_armatureWorker.display as Sprite);
        _state = STATE_WORKER;
    }

    public function get catArmature():Armature { return _armature; }
    public function get catBackArmature():Armature { return _armatureBack; }
    public function get catWorkerArmature():Armature { return _armatureWorker; }

    public function playIt(label:String, playOnce:Boolean = false, callback:Function = null, ...params):void {
        _callback = callback;
        _callbackParams = params;
        _playOnce = playOnce;
        _label = label;
        if(_label == null || _label == '') _label = 'idle';

        removeListener();
        addListener();
        startAnimation();
    }

    private function startAnimation():void {
        WorldClock.clock.remove(_armature);
        WorldClock.clock.remove(_armatureBack);
        if (_armatureWorker) WorldClock.clock.remove(_armatureWorker);

        if (_state == STATE_FRONT) {
            if (_catWorkerImage) _catWorkerImage.visible = false;
            _catImage.visible = true;
            _catBackImage.visible = false;
            WorldClock.clock.add(_armature);
            _armature.animation.gotoAndPlayByFrame(_label);
        } else if (_state == STATE_BACK) {
            if (_catWorkerImage) _catWorkerImage.visible = false;
            _catImage.visible = false;
            _catBackImage.visible = true;
            WorldClock.clock.add(_armatureBack);
            _armatureBack.animation.gotoAndPlayByFrame(_label);
        } else if (_state == STATE_WORKER && _armatureWorker) {
            if (_catWorkerImage) _catWorkerImage.visible = true;
            _catImage.visible = false;
            _catBackImage.visible = false;
            WorldClock.clock.add(_armatureWorker);
            _armatureWorker.animation.gotoAndPlayByFrame(_label);
        }
    }

    private function addListener():void {
        if (_state == STATE_FRONT) {
            if (_armature && !_armature.hasEventListener(EventObject.COMPLETE)) _armature.addEventListener(EventObject.COMPLETE, onCompleteAnimation);
            if (_armature && !_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.addEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation);
        } else if (_state == STATE_BACK) {
            if (_armatureBack && !_armatureBack.hasEventListener(EventObject.COMPLETE)) _armatureBack.addEventListener(EventObject.COMPLETE, onCompleteAnimation);
            if (_armatureBack && !_armatureBack.hasEventListener(EventObject.LOOP_COMPLETE)) _armatureBack.addEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation);
        } else if (_state == STATE_WORKER) {
            if (_armatureWorker && !_armatureWorker.hasEventListener(EventObject.COMPLETE)) {
                _armatureWorker.addEventListener(EventObject.COMPLETE, onCompleteAnimation);
            }
            if (_armatureWorker && !_armatureWorker.hasEventListener(EventObject.LOOP_COMPLETE)) {
                _armatureWorker.addEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation);
            }
        }
    }

    private function removeListener():void {
        if (_armature && _armature.hasEventListener(EventObject.COMPLETE)) {
            _armature.removeEventListener(EventObject.COMPLETE, onCompleteAnimation);
        }
        if (_armature && _armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation);
        if (_armatureBack && _armatureBack.hasEventListener(EventObject.COMPLETE)) {
            _armatureBack.removeEventListener(EventObject.COMPLETE, onCompleteAnimation);
        }
        if (_armatureBack && _armatureBack.hasEventListener(EventObject.LOOP_COMPLETE)) _armatureBack.removeEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation);
        if (_armatureWorker && _armatureWorker.hasEventListener(EventObject.COMPLETE)) {
            _armatureWorker.removeEventListener(EventObject.COMPLETE, onCompleteAnimation);
        }
        if (_armatureWorker && _armatureWorker.hasEventListener(EventObject.LOOP_COMPLETE)) _armatureWorker.removeEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation);
    }

    private function onCompleteAnimation(e:EventObject):void {
        if (_playOnce) {
            stopIt();
            if (_callback != null) {
                _callback.apply(null, _callbackParams);
            }
        } else {
            removeListener();
            addListener();
            startAnimation();
        }
    }

    public function stopIt():void {
        removeListener();
        if (_state == STATE_FRONT) {
            WorldClock.clock.remove(_armature);
        } else if (_state == STATE_BACK) {
            WorldClock.clock.remove(_armatureBack);
        } else if (_state == STATE_WORKER) {
            WorldClock.clock.remove(_armatureWorker);
        }
    }

    public function flipIt(v:Boolean):void {
        v ? _catImage.scaleX = -1: _catImage.scaleX = 1;
        v ? _catBackImage.scaleX = -1: _catBackImage.scaleX = 1;
        if (_catWorkerImage) v ? _catWorkerImage.scaleX = -1: _catWorkerImage.scaleX = 1;
    }

    public function showFront(v:Boolean):void {
        if (_state == STATE_WORKER) {
            return;
        }

        if (v) {
            if (_state == STATE_FRONT) return;
            stopIt();
            _state = STATE_FRONT;
            _catImage.visible = true;
            WorldClock.clock.add(_armature);
            _catBackImage.visible = false;
            WorldClock.clock.remove(_armatureBack);
        } else {
            if (_state == STATE_BACK) return;
            stopIt();
            _state = STATE_BACK;
            _catBackImage.visible = true;
            WorldClock.clock.add(_armatureBack);
            _catImage.visible = false;
            WorldClock.clock.remove(_armature);
        }
        if (_label) {
            addListener();
            startAnimation();
        }
    }

    public function deleteArmature(arma:Armature):void {
        WorldClock.clock.remove(arma);
        if (arma.hasEventListener(EventObject.COMPLETE)) arma.removeEventListener(EventObject.COMPLETE, onCompleteAnimation);
        if (arma.hasEventListener(EventObject.LOOP_COMPLETE)) arma.removeEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation);
        arma.dispose();
        arma = null;
    }

    public function clearIt():void {
        _armature = null;
        _armatureBack = null;
        _armatureWorker = null;
        _catImage = null;
        _catBackImage = null;
        _catWorkerImage = null;
    }

    public function deleteWorker():void {
        if (_armatureWorker) {
            while (_catWorkerImage.numChildren) _catWorkerImage.removeChildAt(0);
            deleteArmature(_armatureWorker);
            _catWorkerImage.visible = false;
            _state = STATE_FRONT;
            _label = '';
            showFront(true);
        }
    }
}
}
