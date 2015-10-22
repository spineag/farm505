/**
 * Created by user on 5/21/15.
 */
package utils {
import flash.ui.Mouse;

import manager.Vars;

import mouse.OwnMouse;

import starling.display.Button;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class CButton extends Button{
    private var g:Vars = Vars.getInstance();
    private var _hoverState:Texture;
    private var _upState:Texture;
    private var _endClickCallback:Function;
    private var _startClickCallback:Function;
    private var _hoverCallback:Function;
    private var _outCallback:Function;
    private var _onMovedCallback:Function;

    public function CButton(upState:Texture, text:String = "", downState:Texture = null, hoverState:Texture = null) {
        super (upState,text,downState);

        _upState = upState;
        _hoverState = hoverState;
        this.addEventListener(TouchEvent.TOUCH, onTouch);
    }

    private function onTouch(te:TouchEvent):void {
//        if (te.getTouch(this, TouchPhase.MOVED)) {
//        }

        if (te.getTouch(this, TouchPhase.BEGAN)) {
            Mouse.cursor = OwnMouse.CLICK_CURSOR;
            if (_startClickCallback != null) {
                _startClickCallback.apply();
            }
        } else if (te.getTouch(this, TouchPhase.ENDED)) {
            Mouse.cursor = OwnMouse.USUAL_CURSOR;
            super.upState = _upState;
            if (_endClickCallback != null) {
                _endClickCallback.apply();
            }
        } else if (te.getTouch(this, TouchPhase.HOVER)) {
            Mouse.cursor = OwnMouse.HOVER_CURSOR;
            if (_hoverState) super.upState = _hoverState;
            if (_hoverCallback != null) {
                _hoverCallback.apply();
            }
        } else {
            Mouse.cursor = OwnMouse.USUAL_CURSOR;
            super.upState = _upState;
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

    public function set onMovedCallback(f:Function):void {
        _onMovedCallback = f;
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

    public function deleteIt():void {
        this.removeEventListener(TouchEvent.TOUCH, onTouch);
        _endClickCallback = null;
        _hoverCallback = null;
        _startClickCallback = null;
        _outCallback = null;
        this.dispose();
        _upState = null;
        _hoverState = null;
    }
}
}
