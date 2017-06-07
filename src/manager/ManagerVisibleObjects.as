/**
 * Created by user on 10/3/16.
 */
package manager {
import build.WorldObject;
import build.missing.Missing;
import build.train.Train;
import build.wild.Wild;

import flash.geom.Point;
import flash.geom.Rectangle;
import heroes.OrderCat;
import starling.core.Starling;
import starling.display.Quad;

import windows.ambarFilled.WOAmbarFilled;

public class ManagerVisibleObjects {
    private var g:Vars = Vars.getInstance();
    private var _p1:Point;
    private var _p2:Point;
    private var _useThis:Boolean = true;

    public function ManagerVisibleObjects() {
        _p1 = new Point();
        _p2 = new Point();
    }

    private function enableIt(needShowAll:Boolean):void {
        var i:int;
        var ar:Array;
        if (g.isAway) {
            ar = g.townArea.cityAwayObjects;
        } else {
            ar = g.townArea.cityObjects;
        }
        if (needShowAll) {
            for (i = 0; i < ar.length; i++) {
                if (ar[i] is WorldObject) {
                    if (ar[i] is Missing) continue;
                    (ar[i] as WorldObject).showForOptimisation(needShowAll);
                } else if (ar[i] is OrderCat) {
                    (ar[i] as OrderCat).showForOptimisation(needShowAll);
                }
            }
        } else {
            for (i = 0; i < ar.length; i++) {
                if (ar[i] is WorldObject) {
                    if (isWorldObjectOnScreen(ar[i] as WorldObject)) {
                        if (ar[i] is Missing) continue;
                        (ar[i] as WorldObject).showForOptimisation(true);
                    } else {
                        if (ar[i] is Missing) continue;
                        (ar[i] as WorldObject).showForOptimisation(false);
                    }
                } else if (ar[i] is OrderCat) {
                    if (g.user.level < 4 || isWorldObjectOnScreen(ar[i] as OrderCat)) {
                        (ar[i] as OrderCat).showForOptimisation(true);
                    } else {
                        if (ar[i] is Missing) continue;
                        (ar[i] as OrderCat).showForOptimisation(false);
                    }
                }
            }
        }
    }

    public function checkInStaticPosition():void {
        if (_useThis) enableIt(false);
    }

    public function onActivateDrag(needShow:Boolean):void {
        if (_useThis) enableIt(needShow);
    }

    private function isWorldObjectOnScreen(someBuild:*):Boolean { // worldObject or OrderCat
        if (!someBuild) return true;
        if (!someBuild.source) return true;
        var rect:Rectangle = someBuild.rect;
        if (!rect) return true;
        if (!rect.width || !rect.height) return true;
        if (someBuild is Train) return true;


        if (someBuild is WorldObject && (someBuild as WorldObject).flip) {
            _p1.x = rect.x + rect.width;
            _p1.y = rect.y;
            _p2.x = rect.x;
            _p2.y = rect.y + rect.height;
        } else {
            _p1 = rect.topLeft;
            _p2 = rect.bottomRight;
        }
        _p1 = someBuild.source.localToGlobal(_p1);
        _p2 = someBuild.source.localToGlobal(_p2);

        if (_p2.x < 0) return false;
        if (_p1.x > g.managerResize.stageWidth) return false;
        if (_p2.y < 0) return false;
        if (_p1.y > g.managerResize.stageHeight) return false;
        return true;
    }

    public function onResize():void {
        checkInStaticPosition();
    }
}
}
