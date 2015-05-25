/**
 * Created by user on 5/21/15.
 */
package utils {
import flash.ui.Mouse;

import mouse.OwnMouse;

import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class CSprite extends Sprite {
    private var _endClickCallback:Function;
    private var _startClickCallback:Function;
    private var _hoverCallback:Function;
    private var _outCallback:Function;

    public function CSprite() {
        super();
        this.addEventListener(TouchEvent.TOUCH, onTouch);
    }

    private function onTouch(te:TouchEvent):void {
        if (te.getTouch(this, TouchPhase.MOVED)) {

        } else if (te.getTouch(this, TouchPhase.BEGAN)) {
            Mouse.cursor = OwnMouse.CLICK_CURSOR;
            if (_startClickCallback != null) {
                _startClickCallback.apply();
            }
        } else if (te.getTouch(this, TouchPhase.ENDED)) {
            Mouse.cursor = OwnMouse.USUAL_CURSOR;
            if (_endClickCallback != null) {
                _endClickCallback.apply();
            }
        } else if (te.getTouch(this, TouchPhase.HOVER)) {
            Mouse.cursor = OwnMouse.HOVER_CURSOR;
            if (_hoverCallback != null) {
                _hoverCallback.apply();
            }
        } else {
            Mouse.cursor = OwnMouse.USUAL_CURSOR;
            if (_outCallback != null) {
                _outCallback.apply();
            }
        }
    }

    public function set endClickCallback(f:Function):void {
        _endClickCallback = f;
    }

    public function set startClickCallback(f:Function):void {
        _startClickCallback = f;
    }

    public function set hoverCallback(f:Function):void {
        _hoverCallback = f;
    }

    public function set outCallback(f:Function):void {
        _outCallback = f;
    }
}
}
