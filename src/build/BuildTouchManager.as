/**
 * Created by user on 5/16/16.
 */
package build {
import build.decor.DecorFence;
import build.decor.DecorPostFence;
import build.lockedLand.LockedLand;
import build.ridge.Ridge;

import flash.geom.Point;
import heroes.BasicCat;
import heroes.OrderCat;

import manager.Vars;
import starling.display.Sprite;
import starling.events.TouchEvent;

public class BuildTouchManager {
    private var _cont:Sprite;
    private var _arr:Array;
    private var _p:Point = new Point();
    private var g:Vars = Vars.getInstance();

    public function BuildTouchManager() {
        _cont = g.cont.contentCont;
        _arr = g.townArea.cityObjects;
    }

    public function checkForTouches(gX:int, gY:int, woObject:WorldObject, te:TouchEvent):void {
        if (!woObject || !te) return;
        var i:int;
        _p.x = gX;
        _p.y = gY;
        _p = _cont.globalToLocal(_p);
        var l:int = _arr.length;
        var ar:Array = [];
        for (i=0; i< l; i++) {
            if (_arr[i] == woObject) continue;
            if (_arr[i] is BasicCat || _arr[i] is OrderCat || _arr[i] is DecorFence || _arr[i] is DecorPostFence || _arr[i] is LockedLand) continue;
            if (!(_arr[i] as WorldObject).useIsometricOnly) continue;
            if ((_arr[i] as WorldObject).depth > woObject.depth) continue;
            if (containsPoint((_arr[i] as WorldObject).source as Sprite, _p)) ar.push(_arr[i]);
        }
        if (ar.length) {
            if (ar.length > 1) {
                ar.sortOn('depth', Array.NUMERIC);
                ar.reverse();
            }
            if (ar[0] is Ridge) {
                (ar[0] as Ridge).bgClicked.onTouch(te);
            } else {
                (ar[0] as WorldObject).source.onTouch(te);
            }
            ar.length = 0;
        }
    }

    private function containsPoint(sp:Sprite, p:Point):Boolean {
        if (p.x < sp.x) return false;
        if (p.x > sp.x + sp.width) return false;
        if (p.y < sp.y) return false;
        if (p.y > sp.y + sp.height) return false;
        return true;
    }
}
}
