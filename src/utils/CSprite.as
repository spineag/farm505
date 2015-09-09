/**
 * Created by user on 5/21/15.
 */
package utils {
import com.junkbyte.console.Cc;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Mouse;
import flash.utils.ByteArray;

import manager.Vars;

import mouse.OwnMouse;

import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class CSprite extends Sprite {
    private var _endClickCallback:Function;
    private var _startClickCallback:Function;
    private var _hoverCallback:Function;
    private var _outCallback:Function;
    private var _onMovedCallback:Function;
    private var _needStrongCheckHitTest:Boolean;
    private var _needStrongCheckByteArray:Boolean;
    private var _byteArray:ByteArray;
    private var _bmd:BitmapData;
    private var _scale:Number;
    private var _useContDrag:Boolean = false;

    private var g:Vars = Vars.getInstance();
    public function CSprite() {
        super();

        _needStrongCheckHitTest = false;
        _needStrongCheckByteArray = false;
        _useContDrag = false;
        _scale = 1;
        this.addEventListener(TouchEvent.TOUCH, onTouch);

    }

    public function set releaseContDrag(value:Boolean):void {
        _useContDrag = value;
    }

    private var b:Boolean;
    private var p:Point;
    private function onTouch(te:TouchEvent):void {
        te.stopImmediatePropagation();
        te.stopPropagation();
        if (_needStrongCheckHitTest && te.getTouch(this, TouchPhase.ENDED)) {
            p = new Point(te.touches[0].globalX, te.touches[0].globalY);
            p = this.globalToLocal(p);
            b = hitTestOwn(p, true);
            if (!b) return;
        }

//        if (_needStrongCheckByteArray && te.getTouch(this, TouchPhase.ENDED)) {
//            p = new Point(te.touches[0].globalX, te.touches[0].globalY);
//            p = this.globalToLocal(p);
//            b = checkTransparent(p);
//            if (!b) return;
//        }

        if (te.getTouch(this, TouchPhase.MOVED)) {
            if (_useContDrag) g.cont.dragGameCont(te.touches[0].getLocation(g.mainStage));
            if (_onMovedCallback != null) {
                _onMovedCallback.apply(null, [te.touches[0].globalX, te.touches[0].globalY]);
            }
        } else if (te.getTouch(this, TouchPhase.BEGAN)) {
            te.stopImmediatePropagation();
            Mouse.cursor = OwnMouse.CLICK_CURSOR;
            if (_startClickCallback != null) {
                _startClickCallback.apply();
            }
        } else if (te.getTouch(this, TouchPhase.ENDED)) {
            te.stopImmediatePropagation();
            Mouse.cursor = OwnMouse.USUAL_CURSOR;
            if (_endClickCallback != null) {
                _endClickCallback.apply();
            }
        } else if (te.getTouch(this, TouchPhase.HOVER)) {
            te.stopImmediatePropagation();
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

    // method via byteArray ------------------------------------------------------------------------
//    public function createOwnHitAreaViaBitmap():void {
//        if (!this.numChildren) {
//            Cc.error('CSprite:: empty source1');
//            return;
//        }
//        _needStrongCheckByteArray = true;
//        _bmd = Screenshot.copyToBitmap(this, _scale);                     // all this function need remake
//        _byteArray = _bmd.getPixels(_bmd.rect);
//        _bmd = null;
//    }
//
//    private function checkTransparent(_p:Point):Boolean {
//        var pos:int = int(_p.y) * this.height + int(_p.x);
//        _byteArray.position = pos;
//        return _byteArray.readBoolean();
//    }

    // method via hitTest --------------------------------------------------------------------------
    public function createStrongCheckHitTest():void {
        if (!this.numChildren) {
            Cc.error('CSprite:: empty source2');
            return;
        }
        _needStrongCheckHitTest = true;
        _bmd = DrawToBitmap.drawToBitmap(this).bitmapData;
    }

    private function hitTestOwn(localPoint:Point, forTouch:Boolean=false):Boolean { // some analogy to hitTest logic
        if (forTouch && (!visible || !touchable)) { return false; } // test fails if the object is invisible or not touchable

        if (! getBounds(this).containsPoint(localPoint)) { return false; } // likewise if touch is outside bounds of the object

        var color:uint = _bmd.getPixel32(localPoint.x * _scale, localPoint.y * _scale);
//        if (Color.getAlpha(color) > 1) {
        if (color) return true;
            else return false;
    }
}
}
