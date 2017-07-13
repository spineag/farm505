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
import starling.events.Touch;
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
    private var _currentTouch:Touch;
    private var _startDragPoint:Point;
    private var _isHover:Boolean;
    private var _useCheckForHover:Boolean;
    private var _itsName:String; // use for testing

    private var g:Vars = Vars.getInstance();
    public function CSprite() {
        super();

        _needStrongCheckHitTest = false;
        _needStrongCheckByteArray = false;
        _useContDrag = false;
        _isHover = false;
        _useCheckForHover = true;
        _scale = 1;
        this.addEventListener(TouchEvent.TOUCH, onTouch);
    }

    public function set nameIt(s:String):void { _itsName = s; }
    public function set releaseContDrag(value:Boolean):void { _useContDrag = value; }
    public function get isContDrag():Boolean { return _useContDrag; }
    public function get getCurTouch():Touch { return _currentTouch; }
    public function set useCheckForHover(v:Boolean):void { _useCheckForHover = v; }
    public function set endClickParams(a:*):void { _params = a; }
    public function set endClickCallback(f:Function):void { _endClickCallback = f; }
    public function set startClickCallback(f:Function):void { _startClickCallback = f; }
    public function set hoverCallback(f:Function):void { _hoverCallback = f; }
    public function set outCallback(f:Function):void { _outCallback = f; }
    public function set onMovedCallback(f:Function):void { _onMovedCallback = f; }
    public function removeMainListener():void { this.removeEventListener(TouchEvent.TOUCH, onTouch); }
    public function registerHitArea(hArea:OwnHitArea):void { _hitArea = hArea; }

    public function onTouch(te:TouchEvent):void {
        _currentTouch = te.getTouch(this);
        if (_currentTouch == null) {
            _isHover = false;
            Mouse.cursor = OwnMouse.USUAL_CURSOR;
            if (_outCallback != null) {
                _outCallback.apply();
            }
            return;
        }

        if (_hitArea) {
            var p:Point = new Point(_currentTouch.globalX, _currentTouch.globalY);
            p = this.globalToLocal(p);
            if (_hitArea.isTouchablePoint(p.x, p.y)) _hitAreaState = OwnHitArea.UNDER_VISIBLE_POINT; // state -> mouse is under visible point
            else _hitAreaState = OwnHitArea.UNDER_INVISIBLE_POINT; // state -> mouse is not under visible point
        } else {
            _hitAreaState = OwnHitArea.NO_HIT_AREA; //state -> don't have hitArea
        }

        if (_currentTouch.phase == TouchPhase.MOVED) {
            if (_useContDrag) {
                if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE || g.toolsModifier.modifierType == ToolsModifier.CRAFT_PLANT) return;
                g.cont.dragGameCont(_currentTouch.getLocation(g.mainStage));
            }
            if (_onMovedCallback != null) {
                _onMovedCallback.apply(null, [_currentTouch.globalX, _currentTouch.globalY]);
            }
        } else if (_currentTouch.phase == TouchPhase.BEGAN) {
            if (_hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT) {
                te.stopPropagation();
                Mouse.cursor = OwnMouse.CLICK_CURSOR;
                if (_startClickCallback != null) {
                    _startClickCallback.apply();
                }
                if (g.toolsModifier.modifierType == ToolsModifier.CRAFT_PLANT || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
                    _startDragPoint = null;
                    return;
                }
                if (_useContDrag) {
                    _startDragPoint = new Point();
                    _startDragPoint.x = g.cont.gameCont.x;
                    _startDragPoint.y = g.cont.gameCont.y;
                    g.cont.setDragPoints(_currentTouch.getLocation(g.mainStage));
                }
            }
        } else if (_currentTouch.phase == TouchPhase.ENDED) {
            g.cont.checkOnDragEnd();
            Mouse.cursor = OwnMouse.USUAL_CURSOR;
            if (_hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT) {
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
        } else if (te.touches[0].phase == TouchPhase.HOVER) {
            if (_hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT) {
                te.stopPropagation();
                if (_isHover) return;
                _isHover = true && _useCheckForHover;
                Mouse.cursor = OwnMouse.HOVER_CURSOR;
                if (_hoverCallback != null) {
                    _hoverCallback.apply();
                }
            } else {
                Mouse.cursor = OwnMouse.USUAL_CURSOR;
                _isHover = false;
                if (_outCallback != null) {
                    _outCallback.apply();
                }
            }
        } else {
            if (_hitAreaState != OwnHitArea.UNDER_VISIBLE_POINT) {
                _isHover = false;
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

    public function set isTouchable(value:Boolean):void {
        this.touchable = value;
        if (value)  this.addEventListener(TouchEvent.TOUCH, onTouch);
        else this.removeEventListener(TouchEvent.TOUCH, onTouch);
    }

    public function deleteIt():void {
        if (this.hasEventListener(TouchEvent.TOUCH)) removeEventListener(TouchEvent.TOUCH, onTouch);
        while (this.numChildren) this.removeChildAt(0);
        filter = null;
        _currentTouch = null;
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
