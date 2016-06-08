/**
 * Created by user on 6/8/16.
 */
package build {
import flash.geom.Point;

import manager.hitArea.OwnHitArea;

import starling.display.Sprite;
import starling.events.Touch;

public class TownAreaBuildSprite extends Sprite {
    public var woObject:WorldObject;
    private var _endClickCallback:Function;
    private var _startClickCallback:Function;
    private var _hoverCallback:Function;
    private var _outCallback:Function;
    private var _onMovedCallback:Function;
    private var _useContDrag:Boolean = false;
    private var _hitArea:OwnHitArea;
    private var _isTouchable:Boolean = true;

    public function TownAreaBuildSprite() {
        super();
    }

    public function set releaseContDrag(value:Boolean):void { _useContDrag = value; }
    public function get isContDrag():Boolean { return _useContDrag; }
    public function set endClickCallback(f:Function):void { _endClickCallback = f; }
    public function set startClickCallback(f:Function):void { _startClickCallback = f; }
    public function set hoverCallback(f:Function):void { _hoverCallback = f; }
    public function set outCallback(f:Function):void { _outCallback = f; }
    public function set onMovedCallback(f:Function):void { _onMovedCallback = f; }
    public function releaseEndClick():void {  if (_endClickCallback != null) _endClickCallback.call(); }
    public function releaseStartClick():void {  if (_startClickCallback != null) _startClickCallback.call(); }
    public function releaseHover():void { if (_hoverCallback != null) _hoverCallback.call(); }
    public function releaseOut():void { if (_outCallback != null) _outCallback.call(); }
    public function registerHitArea(hArea:OwnHitArea):void { _hitArea = hArea; }

    public function deleteIt():void {
        _endClickCallback = null;
        _startClickCallback = null;
        _hoverCallback = null;
        _outCallback = null;
        _onMovedCallback = null;
        _hitArea = null;
        this.dispose();
    }

    public function get wasGameContMoved():Boolean {
        return false;
    }

    public function getHitAreaState(t:Touch):int {
        var hitAreaState:int = 1;
        if (_hitArea) {
            var p:Point = new Point(t.globalX, t.globalY);
            p = this.globalToLocal(p);
            if (_hitArea.isTouchablePoint(p.x, p.y)) hitAreaState = OwnHitArea.UNDER_VISIBLE_POINT;
            else hitAreaState = OwnHitArea.UNDER_INVISIBLE_POINT;
        } else {
            hitAreaState = OwnHitArea.NO_HIT_AREA;
        }
        return hitAreaState;
    }

    public function set isTouchable(value:Boolean):void {
        this.touchable = value;
        _isTouchable = value;
    }

    public function get isTouchable():Boolean { return _isTouchable; }

}
}
