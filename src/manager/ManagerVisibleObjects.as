/**
 * Created by user on 10/3/16.
 */
package manager {
import build.WorldObject;
import flash.geom.Point;
import flash.geom.Rectangle;

import heroes.OrderCat;

import starling.core.Starling;
import starling.display.Quad;

import utils.CSprite;

public class ManagerVisibleObjects {
    private var g:Vars = Vars.getInstance();
    private var _arr:Array;
    private var _arrAway:Array;
    private var _p1:Point;
    private var _p2:Point;
    private var _useThis:Boolean = true;

    public function ManagerVisibleObjects() {
        _arr = g.townArea.cityObjects;
        _arrAway = g.townArea.cityAwayObjects;
        _p1 = new Point();
        _p2 = new Point();
    }

    private function enableIt(needShowAll:Boolean):void {
        var i:int;
        if (needShowAll) {
            for (i = 0; i < _arr.length; i++) {
                if (_arr[i] is WorldObject) {
                    (_arr[i] as WorldObject).showForOptimisation(needShowAll);
                } else if (_arr[i] is OrderCat) {
                    (_arr[i] as OrderCat).showForOptimisation(needShowAll);
                }
            }
        } else {
            for (i = 0; i < _arr.length; i++) {
                if (_arr[i] is WorldObject) {
                    if (isWorldObjectOnScreen(_arr[i] as WorldObject)) {
                        (_arr[i] as WorldObject).showForOptimisation(true);
                    } else {
                        (_arr[i] as WorldObject).showForOptimisation(false);
                    }
                } else if (_arr[i] is OrderCat) {
                    if (isWorldObjectOnScreen(_arr[i] as OrderCat)) {
                        (_arr[i] as OrderCat).showForOptimisation(true);
                    } else {
                        (_arr[i] as OrderCat).showForOptimisation(false);
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
        _p1.x = rect.x;
        _p1.y = rect.y;
        _p1 = someBuild.source.localToGlobal(_p1);
        _p2.x = rect.x + rect.width;
        _p2.y = rect.y + rect.height;
        _p2 = someBuild.source.localToGlobal(_p2);

        if (_p2.x < 0) return false;
        if (_p1.x > Starling.current.nativeStage.stageWidth) return false;
        if (_p2.y < 0) return false;
        if (_p1.y > Starling.current.nativeStage.stageHeight) return false;
        return true;
    }

    public function onResize():void {
        checkInStaticPosition();
    }
}
}
