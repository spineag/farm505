/**
 * Created by user on 5/21/15.
 */
package utils {

import flash.display.Bitmap;
import flash.ui.Mouse;

import manager.ManagerFilters;
import mouse.OwnMouse;

import starling.display.DisplayObject;

import starling.display.Image;

import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.Texture;

import windows.WOComponents.WOButtonTexture;

public class CButton extends Sprite {
    public static const GREEN:int = 1;
    public static const BLUE:int = 2;
    public static const YELLOW:int = 3;

    private var _clickCallback:Function;
    private var _hoverCallback:Function;
    private var _outCallback:Function;
    private var _startClickCallback:Function;
    private var _onMovedCallback:Function;
    private var _scale:Number;
    private var _bg:Sprite;
    private var _arrTextFields:Array;

    public function CButton() {
        super();
        _scale = 1;
        _arrTextFields = [];
        _bg = new Sprite();
        this.addChild(_bg);
        this.addEventListener(TouchEvent.TOUCH, onTouch);
    }

    public function setPivots():void {
        this.pivotX = this.width/2;
        this.pivotY = this.height/2;
    }

    public function addButtonTexture(w:int, h:int, type:int, needMakeSimpleShadow:Boolean = false):void {
        var t:Sprite = new WOButtonTexture(w, h, type);
        _bg.addChild(t);
        _bg.flatten();
        if (needMakeSimpleShadow) {
            setPivots();
            makeSimpleShadow(w, h, type);
            addCloneShadow();
        }
    }

    public function addDisplayObject(d:DisplayObject, addShadow:Boolean = false):void {
        _bg.unflatten();
        _bg.addChild(d);
        if (addShadow) {
            d.filter = ManagerFilters.SHADOW_TINY;
        }
        _bg.flatten();
    }

    public function registerTextField(tx:TextField, strokeFilter:Array):void {
        _arrTextFields.push({t:tx, c:strokeFilter});
    }

    public function deregisterTextField(tx:TextField):void {
        for (var i:int=0; i<_arrTextFields.length; i++) {
            if (_arrTextFields[i].t == tx) {
                _arrTextFields.splice(i, 1);
                return;
            }
        }
    }

    private function onTouch(te:TouchEvent):void {
        te.stopImmediatePropagation();
        te.stopPropagation();

        if (te.getTouch(this, TouchPhase.MOVED)) {
            if (_onMovedCallback != null) {
                _onMovedCallback.apply(null, [te.touches[0].globalX, te.touches[0].globalY]);
            }
        } else if (te.getTouch(this, TouchPhase.BEGAN)) {
            if (_startClickCallback != null) {
                _startClickCallback.apply();
            }
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
        var i:int;
        this.isTouchable = v;
        if (v) {
            _bg.filter = null;
            for (i=0; i<_arrTextFields.length; i++) {
                _arrTextFields[i].t.nativeFilters = _arrTextFields[i].c;
            }
        } else {
            _bg.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
            for (i=0; i<_arrTextFields.length; i++) {
                _arrTextFields[i].t.nativeFilters = ManagerFilters.TEXT_STROKE_GRAY;
            }
        }
    }

    public function deleteIt():void {
        deleteShadow();
        _bg.unflatten();
        _bg.filter = null;
        while (_bg.numChildren) _bg.removeChildAt(0);
        if (this.hasEventListener(TouchEvent.TOUCH)) this.removeEventListener(TouchEvent.TOUCH, onTouch);
        while (this.numChildren) this.removeChildAt(0);
        _bg = null;
        _arrTextFields.length = 0;
        _clickCallback = null;
        _hoverCallback = null;
        _outCallback = null;
        _onMovedCallback = null;
        _startClickCallback = null;
    }

    private function onBeganClickAnimation():void {
        _bg.filter = ManagerFilters.BUTTON_CLICK_FILTER;
        this.scaleX = this.scaleY = _scale*.95;
    }

    private function onEndClickAnimation():void {
        _bg.filter = null;
        this.scaleX = this.scaleY = _scale;
    }

    private function onHoverAnimation():void {
        _bg.filter = ManagerFilters.BUTTON_HOVER_FILTER;
    }

    private function onOutAnimation():void {
        this.scaleX = this.scaleY = _scale;
        _bg.filter = null;
    }

    private var _clone:Sprite;
    public function makeShadowFromBitmap():void {
        if (_clone) return;
        var bitmap:Bitmap = DrawToBitmap.drawToBitmap(_bg);
        var im:Image = new Image(Texture.fromBitmap(bitmap));
        _clone = new Sprite();
        _clone.addChild(im);
        _clone.flatten();
    }

    public function makeSimpleShadow(w:int, h:int, type:int):void {
        var t:Sprite = new WOButtonTexture(w, h, type);
        _clone = new Sprite();
        _clone.addChild(t);
        _clone.flatten();
    }

    public function addCloneShadow():void {
        if (!_clone) return;
        this.addChildAt(_clone, 0);
        _clone.filter = ManagerFilters.SHADOW_LIGHT;
    }

    public function deleteShadow():void {
        if (!_clone) return;
        _clone.unflatten();
        _clone.filter = null;
        if (this.contains(_clone)) this.removeChild(_clone);
        _clone.dispose();
        _clone = null;
    }

}
}
