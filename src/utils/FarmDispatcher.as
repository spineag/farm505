/**
 * Created by andriy.grynkiv on 8/8/14.
 */
package utils {
import flash.events.TimerEvent;
import flash.utils.Dictionary;
import flash.utils.Timer;

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
}
}