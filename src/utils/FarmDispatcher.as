/**
 * Created by andriy.grynkiv on 8/8/14.
 */
package utils {
import flash.events.TimerEvent;
import flash.utils.Dictionary;
import flash.utils.Timer;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;

import starling.display.Stage;
import starling.events.Event;

public class FarmDispatcher {
    private var _enterFrameListeners:Vector.<Function>;
    private var _enterFrameListenersLength:int;
    private var _timerListeners:Vector.<Function>;
    private var _timerListenersLength:int;
    private var _nextFrameFunctions:Vector.<Function>;
    private var _nextFrameFunctionsLength:int;
    private var _timerListenersWithParams:Dictionary;
    private var timer:Timer;

    public function FarmDispatcher(stage:Stage) {
        _enterFrameListeners = new Vector.<Function>;
        _enterFrameListenersLength = 0;
        _timerListeners = new Vector.<Function>;
        _timerListenersLength = 0;
        _nextFrameFunctions = new Vector.<Function>;
        _nextFrameFunctionsLength = 0;
        _timerListenersWithParams = new Dictionary();

        timer = new Timer(1000);
        stage.addEventListener(Event.ENTER_FRAME, enterFrame);
        timer.addEventListener(TimerEvent.TIMER, timerTimerHandler);
        timer.start();
    }

    public function addEnterFrame(listener:Function):void {
        if (!hasListener(listener, _enterFrameListeners)) {
            _enterFrameListeners.push(listener);
            _enterFrameListenersLength = _enterFrameListeners.length;
        }
    }
    
    public function addNextFrameFunction(f:Function):void {
        _nextFrameFunctions.push(f);
        _nextFrameFunctionsLength = _nextFrameFunctions.length;
    }

    public function removeEnterFrame(listener:Function):void {
        removeListener(listener, _enterFrameListeners);
        _enterFrameListenersLength = _enterFrameListeners.length;
    }

    public function addToTimer(listener:Function):void {
        if (!hasListener(listener, _timerListeners)) {
            _timerListeners.push(listener);
            _timerListenersLength = _timerListeners.length;
        }
    }

    public function removeFromTimer(listener:Function):void {
        removeListener(listener, _timerListeners);
        _timerListenersLength = _timerListeners.length;
    }

    private var i:int;
    private function enterFrame(e:Event):void {
        for (i = 0; i < _enterFrameListenersLength; i++) {
            (_enterFrameListeners[i] as Function).apply();
        }
        if (_nextFrameFunctionsLength) {
            for (i = 0; i < _nextFrameFunctionsLength; i++) {
                (_nextFrameFunctions[i] as Function).apply();
            }
            _nextFrameFunctions.length = 0;
            _nextFrameFunctionsLength = 0;
        }
    }

    private var k:int;
    private function timerTimerHandler(e:TimerEvent):void {
        for (k = 0; k < _timerListenersLength; k++) {
            (_timerListeners[k] as Function).apply();
        }
        timerTimerWithParamsHandler(e);
    }

    private function hasListener(listener:Function, listeners:Vector.<Function>):Boolean {
        return Boolean(listeners.indexOf(listener) + 1);
    }

    private function removeListener(listener:Function, listeners:Vector.<Function>):void {
        var index:int;

        index = listeners.indexOf(listener);
        if (index + 1) {
            listeners.splice(index, 1);
        }
    }

    public function addToTimerWithParams(listener:Function, delay:uint = 1000, loop:uint = int.MAX_VALUE, ...params):void {
        var key:String = getQualifiedClassName(listener) + "-" + getTimer();
        _timerListenersWithParams[key] = {callback:listener, delay:delay, cDelay:0, loop:loop, cLoop: 0, params:params};
    }

    public function removeFromTimerWithParams(key:String):void {
        if (_timerListenersWithParams[key]) {
            _timerListenersWithParams[key] = null;
            delete _timerListenersWithParams[key];
        }
    }

    private var _key:String;
    private var _cObject:Object;
    private function timerTimerWithParamsHandler(e:TimerEvent):void {
        for (_key in _timerListenersWithParams) {
            _cObject = _timerListenersWithParams[_key];
            _cObject.cDelay += 1000;
            if (_cObject.delay <= _cObject.cDelay) {
                _cObject.cDelay = 0;
                if (_cObject.callback != null) {
                    (_cObject.callback as Function).apply(null, _cObject.params);
                    ++_cObject.cLoop;
                    if (_cObject.loop <= _cObject.cLoop) {
                        removeFromTimerWithParams(_key);
                    }
                }
            }
        }
    }
}
}