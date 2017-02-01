/**
 * Created by user on 10/24/16.
 */
package additional.lohmatik {
import com.junkbyte.console.Cc;
import flash.geom.Point;
import manager.AStar.AStar;
import manager.Vars;

public class ManagerLohmatik {
    private var g:Vars = Vars.getInstance();
    private var _arr:Array;
    private var _timerCounter:int;

    public function ManagerLohmatik() {
        _timerCounter = 0;
        _arr = [];
        addLohmatics();
    }

    private function addLohmatics():void {
        if (g.isAway) return;
        if (g.user.level < 5) return;
        if (g.allData.factory['lohmatik']) {
            onLoad();
        } else {
            g.loadAnimation.load('animations_json/x1/lohmatik', 'lohmatik', onLoad);
        }
    }

    private function onLoad():void {
        var l:Lohmatik;
        var count:int = 1;
        if (Math.random()>.5) count++;
        for (var i:int=0; i<count; i++) {
            l = new Lohmatik(onLohClick);
            _arr.push(l);
            l.setPosition(g.townArea.getRandomFreeCell());
            makeAnyAction(l);
        }
    }

    private function onLohClick(l:Lohmatik):void {
        l.deleteIt();
        if (_arr.indexOf(l) > -1) _arr.removeAt(_arr.indexOf(l));
        if (!_arr.length) {
            _timerCounter = 15*60;
            g.gameDispatcher.addToTimer(onTimer);
        }
    }

    private function makeAnyAction(l:Lohmatik):void {
        var m:int = int(Math.random()*10);
        if (m < 5) {
            goIdleLohmatikToPoint(l, g.townArea.getRandomFreeCell(), makeAnyAction);
        } else if (m<7) {
            l.idleAnimation('idle_1', makeAnyAction);
        } else if (m<9) {
            l.idleAnimation('idle_2', makeAnyAction);
        } else {
            l.idleAnimation('idle_7', makeAnyAction);
        }
    }

    private function goIdleLohmatikToPoint(l:Lohmatik, p:Point, callback:Function = null):void {
        try {
            if (l.posX == p.x && l.posY == p.y) {
                if (callback != null) {
                    callback.apply(null, [l]);
                }
                return;
            }

            var f2:Function = function ():void {
                if (callback != null) {
                    callback.apply(null, [l]);
                }
            };
            var f1:Function = function (arr:Array):void {
                l.goWithPath(arr, f2);
            };
            var a:AStar = new AStar();
            a.getPath(l.posX, l.posY, p.x, p.y, f1, l);
        } catch (e:Error) {
            Cc.error('ManagerLohmatik goIdleCatToPoint error: ' + e.errorID + ' - ' + e.message);
        }
    }
    
    private function onTimer():void {
        _timerCounter--;
        if (_timerCounter < 0) {
            g.gameDispatcher.removeFromTimer(onTimer);
            addLohmatics();
        }
    }

    public function onGoAway():void {
            g.gameDispatcher.removeFromTimer(onTimer);
            if (_arr.length) {
                for (var i:int = 0; i < _arr.length; i++) {
                    (_arr[i] as Lohmatik).deleteIt();
                }
            }
            _arr.length = 0;
    }

    public function onBackHome():void {
            if (_timerCounter <= 0) _timerCounter = 15 * 60;
            g.gameDispatcher.addToTimer(onTimer);
    }

    public function checkAllLohAfterPasteBuilding(buildPosX:int, buildPosY:int, buildWidth:int, buildHeight:int):void {
        for (var i:int=0; i<_arr.length; i++) {
            if (_arr[i] is Lohmatik) {
                checkCatAfterPasteBuilding(_arr[i] as Lohmatik, buildPosX, buildPosY, buildWidth, buildHeight);
            }
        }
    }

    private function checkCatAfterPasteBuilding(l:Lohmatik, buildPosX:int, buildPosY:int, buildWidth:int, buildHeight:int):void {
        if (g.isAway) return;
                if (l.posX > buildPosX && l.posX < buildPosX + buildWidth && l.posY > buildPosY && l.posY < buildPosY + buildHeight) {
                    var afterRunFree2:Function = function (_cat:Lohmatik):void {
                        makeAnyAction(l);
                    };
                    l.stopAnimation();
                    forceRunToXYPoint(l, buildPosX + buildWidth, buildPosY, afterRunFree2);
                }
            }

    private function forceRunToXYPoint(l:Lohmatik, posX:int, posY:int, callback:Function):void {
        var p:Point = new Point(posX, posY);
        p = g.matrixGrid.getXYFromIndex(p);
        l.goLohToXYPoint(p, 1, callback);
    }

    public function addArrowForLohmatics():void {
        for (var i:int=0; i<_arr.length; i++) {
            (_arr[i] as Lohmatik).showArrow(3);
        }
    }
}
}
