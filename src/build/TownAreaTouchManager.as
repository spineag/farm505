/**
 * Created by user on 6/8/16.
 */
package build {
import build.decor.DecorFence;
import build.decor.DecorPostFence;
import build.lockedLand.LockedLand;
import flash.geom.Point;
import heroes.BasicCat;
import heroes.OrderCat;
import manager.Vars;
import manager.hitArea.OwnHitArea;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchPhase;
import utils.CSprite;

public class TownAreaTouchManager {
    private var g:Vars = Vars.getInstance();
    private var cont:CSprite;
    private var contTail:CSprite;
    private var _touch:Touch;
    private var _curBuild:WorldObject;
    private var _prevBuild:WorldObject;
    private var _startDragPoint:Point;
    private var _arrTown:Array;

    public function TownAreaTouchManager() {
        _arrTown = g.townArea.cityObjects;

        cont = g.cont.contentCont;
        cont.endClickCallback = onEndClick;
        cont.startClickCallback = onStartClick;
        cont.hoverCallback = onHover;
        cont.outCallback = onOut;

        contTail = g.cont.tailCont;
        contTail.endClickCallback = onEndClickTail;
        contTail.startClickCallback = onStartClickTail;
        contTail.hoverCallback = onHoverTail;
        contTail.outCallback = onOutTail;
    }

    private function onEndClick():void {
        _touch = cont.getCurTouch;
        if (!_touch) return;
        _curBuild = getWorldObject(_touch);
        if (_curBuild) {
            var hitAreaState:int = _curBuild.source.getHitAreaState(_touch);
            if (hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT && _curBuild.source.isTouchable) {
                _curBuild.source.releaseEndClick();
            } else {
                checkForTouches();
            }
        }
    }

    private function onStartClick():void {
        _touch = cont.getCurTouch;
        if (!_touch) return;
        _curBuild = getWorldObject(_touch);
        if (_curBuild) {
            var hitAreaState:int = _curBuild.source.getHitAreaState(_touch);
            if (hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT && _curBuild.source.isTouchable) {
                _curBuild.source.releaseStartClick();
            } else {
                checkForTouches();
            }
        }
    }

    private function onHover():void {
        _touch = cont.getCurTouch;
        if (!_touch) {
            if (_curBuild) _curBuild.source.releaseOut();
            _curBuild = null;
            return;
        }
        _curBuild = getWorldObject(_touch);
        if (_prevBuild && _prevBuild != _curBuild) {
            if (_prevBuild.source.isTouchable) _prevBuild.source.releaseOut();
            _prevBuild = _curBuild;
        }
        if (_curBuild) {
            var hitAreaState:int = _curBuild.source.getHitAreaState(_touch);
            if (hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT && _curBuild.source.isTouchable) {
                _curBuild.source.releaseHover();
            } else {
                _curBuild.source.releaseOut();
                checkForTouches();
            }
        }
    }

    private function onOut():void {
        _touch = cont.getCurTouch;
        if (!_touch) return;
        _curBuild = getWorldObject(_touch);
        if (_curBuild) {
            _curBuild.source.releaseOut();
        }
    }

    private function onEndClickTail():void {

    }

    private function onStartClickTail():void {

    }

    private function onHoverTail():void {

    }

    private function onOutTail():void {

    }

    public function get wasGameContMoved():Boolean {
        if (_curBuild) {
            if (_curBuild.source.isContDrag && _startDragPoint) {
                var distance:int = Math.abs(g.cont.gameCont.x - _startDragPoint.x) + Math.abs(g.cont.gameCont.y - _startDragPoint.y);
                _startDragPoint = null;
                return distance > 5;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    private function getWorldObject(t:Touch):WorldObject {
        var b:DisplayObject = t.target;
        if (!b) return null;
        if (b is TownAreaBuildSprite) return (b as TownAreaBuildSprite).woObject;

        var isFind:Boolean = false;
        while (!isFind) {
            if (b.parent) {
                b = b.parent;
                if (b is TownAreaBuildSprite) {
                    isFind = true;
                }
            } else {
                break;
            }
        }

        if (isFind)
            return (b as TownAreaBuildSprite).woObject;
        else
            return null;
    }

    public function checkForTouches():void {
        var i:int;
        var p:Point = new Point(_touch.globalX, _touch.globalY);
        p = cont.globalToLocal(p);
        var l:int = _arrTown.length;
        var ar:Array = [];
        for (i=0; i< l; i++) {
            if (_arrTown[i] == _curBuild) continue;
            if (_arrTown[i] is BasicCat || _arrTown[i] is OrderCat || _arrTown[i] is DecorFence || _arrTown[i] is DecorPostFence || _arrTown[i] is LockedLand) continue;
            if (!(_arrTown[i] as WorldObject).useIsometricOnly) continue;
            if ((_arrTown[i] as WorldObject).depth > _curBuild.depth) continue;
            if (containsPoint((_arrTown[i] as WorldObject).source as Sprite, (_arrTown[i] as WorldObject).rect, p)) ar.push(_arrTown[i]);
        }

        if (ar.length) {
            if (ar.length > 1) {
                ar.sortOn('depth', Array.NUMERIC);
                ar.reverse();
            }
            if ((ar[0] as WorldObject).source.isTouchable) {
                var hitAreaState:int = (ar[0] as WorldObject).source.getHitAreaState(_touch);
                if (_touch.phase == TouchPhase.BEGAN) {
                    if (hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT)
                        (ar[0] as WorldObject).source.releaseStartClick();
                } else if (_touch.phase == TouchPhase.ENDED) {
                    if (hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT)
                        (ar[0] as WorldObject).source.releaseEndClick();
                } else if (_touch.phase == TouchPhase.HOVER) {
                    if (hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT)
                        (ar[0] as WorldObject).source.releaseHover();
                    else (ar[0] as WorldObject).source.releaseOut();
                } else {
                    (ar[0] as WorldObject).source.releaseOut();
                }
            }
            ar.length = 0;
        }
    }

    private function containsPoint(sp:Sprite, rect:flash.geom.Rectangle, p:Point):Boolean {
        if (p.x < sp.x + rect.x) return false;
        if (p.x > sp.x + rect.x + rect.width) return false;
        if (p.y < sp.y + rect.y) return false;
        if (p.y > sp.y + rect.y + rect.height) return false;
        return true;
    }

}
}
