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
    private var _timerListeners:Vector.<Function>;
    private var _timerListenersWithParams:Dictionary;
    private var timer:Timer;

    public function FarmDispatcher(stage:Stage) {
        _enterFrameListeners = new Vector.<Function>;
        _timerListeners = new Vector.<Function>;
        _timerListenersWithParams = new Dictionary();

        timer = new Timer(1000);
        stage.addEventListener(Event.ENTER_FRAME, enterFrame);
        timer.addEventListener(TimerEvent.TIMER, timerTimerHandler);
        timer.start();
    }

    public function addEnterFrame(listener:Function):void {
        if (!hasListener(listener, _enterFrameListeners)) {
            _enterFrameListeners.push(listener);
        }
    }

    public function removeEnterFrame(listener:Function):void {
        removeListener(listener, _enterFrameListeners);
    }

    public function addToTimer(listener:Function):void {
        if (!hasListener(listener, _timerListeners)) {
            _timerListeners.push(listener);
        }
    }

    public function removeFromTimer(listener:Function):void {
        removeListener(listener, _timerListeners);
    }

    private function enterFrame(e:Event):void {
        for (var i:int = 0; i < _enterFrameListeners.length; i++) {
            (_enterFrameListeners[i] as Function).apply();
        }
    }

    private function timerTimerHandler(e:TimerEvent):void {
        for (var i:int = 0; i < _timerListeners.length; i++) {
            (_timerListeners[i] as Function).apply();
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

    private function timerTimerWithParamsHandler(e:TimerEvent):void {
        for (var key:String in _timerListenersWithParams) {
            var cObject:Object = _timerListenersWithParams[key];
            cObject.cDelay += 1000;
            if (cObject.delay <= cObject.cDelay) {
                cObject.cDelay = 0;
                if (cObject.callback != null) {
                    (cObject.callback as Function).apply(null, cObject.params);
                    ++cObject.cLoop;
                    if (cObject.loop <= cObject.cLoop) {
                        removeFromTimerWithParams(key);
                    }
                }
            }
        }
    }
}
}