/**
 * Created by user on 5/21/15.
 */
package utils {
import flash.geom.Point;
import flash.ui.Mouse;

import manager.ManagerFilters;

import manager.ManagerFilters;
import manager.ManagerFilters;
import manager.Vars;
import manager.hitArea.ManagerHitArea;
import manager.hitArea.OwnHitArea;

import media.SoundConst;

import mouse.OwnMouse;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.ColorMatrixFilter;
import starling.filters.GlowFilter;
import starling.styles.DistanceFieldStyle;
import starling.text.TextField;
import windows.WOComponents.WOSimpleButtonTexture;

public class CButton extends Sprite {
    public static const GREEN:int = 1;
    public static const BLUE:int = 2;
    public static const YELLOW:int = 3;
    public static const PINK:int = 4;

    private var _clickCallback:Function;
    private var _hoverCallback:Function;
    private var _outCallback:Function;
    private var _startClickCallback:Function;
    private var _onMovedCallback:Function;
    private var _scale:Number;
    private var _bg:Sprite;
    private var _hitArea:OwnHitArea;
    private var _hitAreaState:int;
    private var _isHover:Boolean;
    private var g:Vars = Vars.getInstance();

    public function CButton() {
        super();
        _scale = 1;
        _bg = new Sprite();
        _isHover = false;
        this.addChild(_bg);
        this.addEventListener(TouchEvent.TOUCH, onTouch);
    }

    public function setPivots():void {
        this.pivotX = this.width/2;
        this.pivotY = this.height/2;
    }

    public function addButtonTexture(w:int, h:int, type:int, setP:Boolean = false):void {
        var t:Sprite = new WOSimpleButtonTexture(w, h, type);
        _bg.addChild(t);
        if (setP) setPivots();
    }

    public function addDisplayObject(d:DisplayObject):void {
        _bg.addChild(d);
    }

    private function onTouch(te:TouchEvent):void {
        te.stopPropagation();
        te.stopImmediatePropagation();
        if (_hitArea) {
            var localPos:Point = te.data[0].getLocation(this);
            if (_hitArea.isTouchablePoint(localPos.x, localPos.y)) _hitAreaState = 2; // state -> mouse is under visible point
                else _hitAreaState = 3; // state -> mouse is not under visible point
        } else {
            _hitAreaState = 1; //state -> don't have hitArea
        }

        if (te.getTouch(this, TouchPhase.MOVED)) {
            if (_onMovedCallback != null) {
                _onMovedCallback.apply(null, [te.touches[0].globalX, te.touches[0].globalY]);
            }
        } else if (te.getTouch(this, TouchPhase.BEGAN)) {
            if (_hitAreaState != 3) {
                te.stopImmediatePropagation();
                te.stopPropagation();
                onBeganClickAnimation();
                if (_startClickCallback != null) {
                    _startClickCallback.apply();
                }
                Mouse.cursor = OwnMouse.CLICK_CURSOR;
            }
        } else if (te.getTouch(this, TouchPhase.ENDED)) {
            if (_hitAreaState != 3) {
                if (_clickCallback != null) {
                    te.stopImmediatePropagation();
                    te.stopPropagation();
                    onEndClickAnimation();
                    _clickCallback.apply();
                }
            }
        } else if (te.getTouch(this, TouchPhase.HOVER)) {
            if (_hitAreaState != 3) {
                te.stopImmediatePropagation();
                te.stopPropagation();
                Mouse.cursor = OwnMouse.HOVER_CURSOR;
                onHoverAnimation();
                if (_hoverCallback != null) {
                    _hoverCallback.apply();
                }
            } else {
                Mouse.cursor = OwnMouse.USUAL_CURSOR;
                onOutAnimation();
                if (_outCallback != null) {
                    _outCallback.apply();
                }
            }
        } else {
            if (_hitAreaState != 2) {
                Mouse.cursor = OwnMouse.USUAL_CURSOR;
                onOutAnimation();
                if (_outCallback != null) {
                    _outCallback.apply();
                }
            }
        }
    }

    public function set startClickCallback(f:Function):void {
        _startClickCallback = f;
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

    public function set setEnabled(v:Boolean):void {
        this.isTouchable = v;
        if (v) {
            this.filter = null;
        } else {
            this.filter = ManagerFilters.getButtonDisableFilter();
        }
    }

    public function deleteIt():void {
        filter = null;
        _hitArea = null;
        _bg.filter = null;
        if (this.hasEventListener(TouchEvent.TOUCH)) this.removeEventListener(TouchEvent.TOUCH, onTouch);
        _bg.dispose();
        _bg = null;
        dispose();
        _clickCallback = null;
        _hoverCallback = null;
        _outCallback = null;
        _onMovedCallback = null;
        _startClickCallback = null;
    }

    private function onBeganClickAnimation():void {
        _bg.filter = ManagerFilters.getButtonClickFilter();
        this.scaleX = this.scaleY = _scale*.95;
    }

    private function onEndClickAnimation():void {
        g.soundManager.playSound(SoundConst.ON_BUTTON_CLICK);
        _bg.filter = null;
        this.scaleX = this.scaleY = _scale;
    }

    private function onHoverAnimation():void {
        if (_isHover) return;
        _isHover = true;
        _bg.filter = ManagerFilters.getButtonHoverFilter();
        g.soundManager.playSound(SoundConst.ON_BUTTON_HOVER);
    }

    private function onOutAnimation():void {
        _isHover = false;
        this.scaleX = this.scaleY = _scale;
        _bg.filter = null;
    }

    public function createHitArea(name:String):void {
        _hitArea = g.managerHitArea.getHitArea(this, name, ManagerHitArea.TYPE_CREATE);
    }

}
}
