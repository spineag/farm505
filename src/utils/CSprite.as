/**
 * Created by user on 5/21/15.
 */
package utils {
import flash.display.BitmapData;
import flash.geom.Point;
import flash.ui.Mouse;
import manager.Vars;
import manager.hitArea.OwnHitArea;
import mouse.OwnMouse;
import mouse.ToolsModifier;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class CSprite extends Sprite {
    private var _endClickCallback:Function;
    private var _startClickCallback:Function;
    private var _hoverCallback:Function;
    private var _outCallback:Function;
    private var _onMovedCallback:Function;
    private var _needStrongCheckHitTest:Boolean;
    private var _needStrongCheckByteArray:Boolean;
    private var _bmd:BitmapData;
    private var _scale:Number;
    private var _useContDrag:Boolean = false;
    private var _params:*;
    private var _hitArea:OwnHitArea;
    private var _hitAreaState:int;

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

    public function get isContDrag():Boolean {
        return _useContDrag;
    }

    private var _startDragPoint:Point;
    private function onTouch(te:TouchEvent):void {
//        te.stopImmediatePropagation();    ???
//        te.stopPropagation();   ???

        if (_hitArea) {
            var localPos:Point = te.data[0].getLocation(this);
            if (_hitArea.isTouchablePoint(localPos.x, localPos.y)) _hitAreaState = 2; // state -> mouse is under visible point
            else _hitAreaState = 3; // state -> mouse is not under visible point
        } else {
            _hitAreaState = 1; //state -> don't have hitArea
        }

        if (te.getTouch(this, TouchPhase.MOVED)) {
            if (_useContDrag) {
                if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) return;
                g.cont.dragGameCont(te.touches[0].getLocation(g.mainStage));
            }
            if (_onMovedCallback != null) {
                _onMovedCallback.apply(null, [te.touches[0].globalX, te.touches[0].globalY]);
            }
        } else if (te.getTouch(this, TouchPhase.BEGAN)) {
            if (_hitAreaState != 3) {
                te.stopImmediatePropagation();
                te.stopPropagation();
                if (_useContDrag) {
                    _startDragPoint = new Point();
                    _startDragPoint.x = g.cont.gameCont.x;
                    _startDragPoint.y = g.cont.gameCont.y;
                }
                Mouse.cursor = OwnMouse.CLICK_CURSOR;
                if (_startClickCallback != null) {
                    _startClickCallback.apply();
                }
                if (_useContDrag) {
                    g.cont.setDragPoints(te.touches[0].getLocation(g.mainStage));
                }
            }
        } else if (te.getTouch(this, TouchPhase.ENDED)) {
            if (_hitAreaState != 3) {
                te.stopImmediatePropagation();
                te.stopPropagation();

                if (wasGameContMoved) return;
                if (_endClickCallback != null) {
                    if (_params) {
                        _endClickCallback.apply(null, [_params]);
                    } else {
                        _endClickCallback.apply();
                    }
                }
            }
            Mouse.cursor = OwnMouse.USUAL_CURSOR;
        } else if (te.getTouch(this, TouchPhase.HOVER)) {
            if (_hitAreaState != 3) {
                te.stopImmediatePropagation();
                te.stopPropagation();
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
        } else {
            if (_hitAreaState != 2) {
                Mouse.cursor = OwnMouse.USUAL_CURSOR;
                if (_outCallback != null) {
                    _outCallback.apply();
                }
            }
        }
    }

    public function get wasGameContMoved():Boolean {
        if (_useContDrag && _startDragPoint) {
            var distance:int = Math.abs(g.cont.gameCont.x - _startDragPoint.x) + Math.abs(g.cont.gameCont.y - _startDragPoint.y);
            _startDragPoint = null;
            return distance > 5;
        } else {
            return false;
        }
    }

    public function set endClickParams(a:*):void {
        _params = a;
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
            this.addEventListener(TouchEvent.TOUCH, onTouch);
        } else {
            this.removeEventListener(TouchEvent.TOUCH, onTouch);
        }
    }

    public function removeMainListener():void {
        this.removeEventListener(TouchEvent.TOUCH, onTouch);
    }

    public function registerHitArea(hArea:OwnHitArea):void {
        _hitArea = hArea;
    }

    public function deleteIt():void {
        if (this.hasEventListener(TouchEvent.TOUCH)) removeEventListener(TouchEvent.TOUCH, onTouch);
        while (this.numChildren) this.removeChildAt(0);
        _endClickCallback = null;
        _startClickCallback = null;
        _hoverCallback = null;
        _outCallback = null;
        _onMovedCallback = null;
        if (_bmd) _bmd.dispose();
        dispose();
        _hitArea = null;
    }
}
}
