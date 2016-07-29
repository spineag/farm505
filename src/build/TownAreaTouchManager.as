/**
 * Created by user on 6/8/16.
 */
package build {
import build.decor.DecorFence;
import build.decor.DecorPostFence;
import build.decor.DecorTail;
import build.farm.Farm;
import build.lockedLand.LockedLand;
import build.ridge.Ridge;

import flash.geom.Point;
import heroes.BasicCat;
import heroes.OrderCat;
import manager.Vars;
import manager.hitArea.OwnHitArea;

import mouse.ToolsModifier;

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
    private var _arrTown:Array;

    public function TownAreaTouchManager() {
        cont = g.cont.contentCont;
        cont.endClickCallback = onEndClick;
        cont.startClickCallback = onStartClick;
        cont.hoverCallback = onHover;
        cont.outCallback = onOut;
        cont.releaseContDrag = true;

        contTail = g.cont.tailCont;
        contTail.endClickCallback = onEndClickTail;
        contTail.startClickCallback = onStartClickTail;
        contTail.hoverCallback = onHoverTail;
        contTail.outCallback = onOutTail;
        contTail.isTouchable = false;
        contTail.releaseContDrag = true;
    }

    public function set tailAreTouchable(v:Boolean):void {
        contTail.isTouchable = v;
    }

    private function onEndClick():void {
        _touch = cont.getCurTouch;
        if (!_touch) return;
        _curBuild = getWorldObject(_touch);
        if (_curBuild && _curBuild.source) {
            var hitAreaState:int = _curBuild.source.getHitAreaState(_touch);
            if (hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT &&  _curBuild.source.isTouchable) {
                _curBuild.source.releaseEndClick();
            } else {
                if (_curBuild is Ridge && g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
                    _curBuild.source.releaseEndClick();
                } else checkForTouches();
            }
        } else {
            g.cont.onEnded();
        }
    }

    private function onStartClick():void {
        _touch = cont.getCurTouch;
        if (!_touch) return;
        _curBuild = getWorldObject(_touch);
        if (_curBuild && _curBuild.source) {
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
            if (_curBuild && _curBuild.source) _curBuild.source.releaseOut();
            _curBuild = null;
            if (_prevBuild && _curBuild.source) _prevBuild.source.releaseOut();
            _prevBuild = null;
            return;
        }
        _curBuild = getWorldObject(_touch);
        if (_curBuild && _curBuild.source) {
            if (!_prevBuild) _prevBuild = _curBuild;
            var hitAreaState:int = _curBuild.source.getHitAreaState(_touch);
            if (hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT &&  _curBuild.source.isTouchable) {
                _curBuild.source.releaseHover();
                if (_prevBuild && _prevBuild != _curBuild) {
                    if (_prevBuild.source) _prevBuild.source.releaseOut();
                    _prevBuild = _curBuild;
                }
            } else {
                _curBuild.source.releaseOut();
                checkForTouches();
            }
        }
    }

    private function onOut():void {
        _touch = cont.getCurTouch;
        if (!_touch) {
            if (_curBuild && _curBuild.source) {
                _curBuild.source.releaseOut();
                _curBuild = null;
            }
            return;
        }
        _curBuild = getWorldObject(_touch);
        if (_curBuild && _curBuild.source) {
            _curBuild.source.releaseOut();
        }
    }

    private function onEndClickTail():void {
        _touch = contTail.getCurTouch;
        if (!_touch) {
            return;
        }
        _curBuild = getWorldObject(_touch);
        if (_curBuild && _curBuild.source) {
            var hitAreaState:int = _curBuild.source.getHitAreaState(_touch);
            if (hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT && _curBuild.source.isTouchable) {
                _curBuild.source.releaseEndClick();
            } else {
                checkForTouches();
            }
        }
    }

    private function onStartClickTail():void {

    }

    private function onHoverTail():void {
        _touch = contTail.getCurTouch;
        if (!_touch) {
            if (_curBuild) _curBuild.source.releaseOut();
            _curBuild = null;
            return;
        }
        _curBuild = getWorldObject(_touch);
        if (!_prevBuild) _prevBuild = _curBuild;
        if (_curBuild) {
            var hitAreaState:int = _curBuild.source.getHitAreaState(_touch);
            if (hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT && _curBuild.source.isTouchable) {
                _curBuild.source.releaseHover();
                if (_prevBuild && _prevBuild != _curBuild) {
                    if (_prevBuild.source) _prevBuild.source.releaseOut();
                    _prevBuild = _curBuild;
                }
            } else {
                _curBuild.source.releaseOut();
                checkForTouches();
            }
        }
    }

    private function onOutTail():void {
        _touch = contTail.getCurTouch;
        if (!_touch) {
            if (_prevBuild.source) {
                if (_prevBuild && _prevBuild.source.isTouchable) {
                    _prevBuild.source.releaseOut();
                    _prevBuild = null;
                }
            }
            return;
        }
        _curBuild = getWorldObject(_touch);
        if (_curBuild) {
            _curBuild.source.releaseOut();
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
        if (g.isAway) {
            _arrTown = g.townArea.cityAwayObjects;
        } else {
            _arrTown = g.townArea.cityObjects;
        }
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
                    if (hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT) {
                        if (ar[0] is Farm && g.toolsModifier.modifierType == ToolsModifier.NONE) {
                            (ar[0] as Farm).releaseMouseEventForAnimalFromTouchManager('start');
                        } else (ar[0] as WorldObject).source.releaseStartClick();
                    }
                } else if (_touch.phase == TouchPhase.ENDED) {
                    if (hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT) {
                        if (ar[0] is Farm && g.toolsModifier.modifierType == ToolsModifier.NONE) {
                            (ar[0] as Farm).releaseMouseEventForAnimalFromTouchManager('end');
                        } else (ar[0] as WorldObject).source.releaseEndClick();
                    }
                } else if (_touch.phase == TouchPhase.HOVER) {
                    if (hitAreaState != OwnHitArea.UNDER_INVISIBLE_POINT) {
                        if (ar[0] is Farm && g.toolsModifier.modifierType == ToolsModifier.NONE) {
                            (ar[0] as Farm).releaseMouseEventForAnimalFromTouchManager('hover');
                        } else (ar[0] as WorldObject).source.releaseHover();
                    } else {
                        if (ar[0] is Farm && g.toolsModifier.modifierType == ToolsModifier.NONE) {
                            (ar[0] as Farm).releaseMouseEventForAnimalFromTouchManager('out');
                        } else (ar[0] as WorldObject).source.releaseOut();
                    }
                } else {
                    if (ar[0] is Farm && g.toolsModifier.modifierType == ToolsModifier.NONE) {
                        (ar[0] as Farm).releaseMouseEventForAnimalFromTouchManager('out');
                    } else (ar[0] as WorldObject).source.releaseOut();
                }
            }
            ar.length = 0;
        } else {
            if (_touch.phase == TouchPhase.ENDED) {
                if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
                    g.toolsModifier.modifierType = ToolsModifier.PLANT_SEED;
                }
                g.cont.onEnded();
//            } else if (_touch.phase == TouchPhase.BEGAN) {
//            } else if (_touch.phase == TouchPhase.HOVER) {
//            } else {
            }
        }
    }

    private function containsPoint(sp:Sprite, rect:flash.geom.Rectangle, p:Point):Boolean {
        if (!sp || !rect || !p) return false;
        if (p.x < sp.x + rect.x) return false;
        if (p.x > sp.x + rect.x + rect.width) return false;
        if (p.y < sp.y + rect.y) return false;
        if (p.y > sp.y + rect.y + rect.height) return false;
        return true;
    }

    public function get wasGameContMoved():Boolean {
        if (_curBuild) {
            if (_curBuild is DecorTail) return contTail.wasGameContMoved;
                else return cont.wasGameContMoved;
        } else {
            return false;
        }
    }

}
}
