/**
 * Created by user on 5/21/15.
 */
package utils {

import flash.ui.Mouse;

import manager.ManagerFilters;
import mouse.OwnMouse;

import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class CButton extends Sprite {
    private var _clickCallback:Function;
    private var _hoverCallback:Function;
    private var _outCallback:Function;
    private var _scale:Number;

    public function CButton() {
        super();
        _scale = 1;
        this.addEventListener(TouchEvent.TOUCH, onTouch);
    }

    public function setPivots():void {
        pivotX = width/2;
        pivotY = height/2;
    }

    private function onTouch(te:TouchEvent):void {
        te.stopImmediatePropagation();
        te.stopPropagation();

        if (te.getTouch(this, TouchPhase.BEGAN)) {
            Mouse.cursor = OwnMouse.CLICK_CURSOR;
            onBeganClickAnimation();
        } else if (te.getTouch(this, TouchPhase.ENDED)) {
            Mouse.cursor = OwnMouse.USUAL_CURSOR;
            if (_clickCallback != null) {
                _clickCallback.apply();
            }
            onEndClickAnimation();
        } else if (te.getTouch(this, TouchPhase.HOVER)) {
            Mouse.cursor = OwnMouse.HOVER_CURSOR;
            if (_hoverCallback != null) {
                _hoverCallback.apply();
            }
            onHoverAnimation();
        } else {
            Mouse.cursor = OwnMouse.USUAL_CURSOR;
            if (_outCallback != null) {
                _outCallback.apply();
            }
            onOutAnimation();
        }
    }

    public function set clickCallback(f:Function):void {
        _clickCallback = f;
    }

    public function set hoverCallback(f:Function):void {
        _hoverCallback = f;
    }

    public function set outCallback(f:Function):void {
        _outCallback = f;
    }

    public function set isTouchable(value:Boolean):void {
        this.touchable = value;
        if (value) {
            if(!this.hasEventListener(TouchEvent.TOUCH))
                this.addEventListener(TouchEvent.TOUCH, onTouch);
        } else {
            if(this.hasEventListener(TouchEvent.TOUCH))
                this.removeEventListener(TouchEvent.TOUCH, onTouch);
        }
    }

    public function set setEnabled(v:Boolean):void {
        isTouchable = v;
        if (v) {
            filter = null;
        } else {
            filter = ManagerFilters.BUTTON_DISABLE_FILTER;
        }
    }

    public function deleteIt():void {
        filter = null;
        if (this.hasEventListener(TouchEvent.TOUCH)) removeEventListener(TouchEvent.TOUCH, onTouch);
        while (this.numChildren) this.removeChildAt(0);
        _clickCallback = null;
        _hoverCallback = null;
        _outCallback = null;
    }

    private function onBeganClickAnimation():void {
        filter = ManagerFilters.BUTTON_CLICK_FILTER;
        scaleX = scaleY = _scale*.9;
    }

    private function onEndClickAnimation():void {
        filter = null;
        scaleX = scaleY = _scale;
    }

    private function onHoverAnimation():void {
        filter = ManagerFilters.BUTTON_HOVER_FILTER;
    }

    private function onOutAnimation():void {
        filter = null;
    }
}
}
