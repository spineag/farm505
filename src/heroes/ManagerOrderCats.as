/**
 * Created by user on 2/5/16.
 */
package heroes {
import com.junkbyte.console.Cc;
import flash.geom.Point;
import manager.AStar.AStar;
import manager.AStar.DirectWay;
import manager.Vars;
import windows.WindowsManager;

public class ManagerOrderCats {
    [ArrayElementType('heroes.OrderCat')]
    public var _arrCats:Array;
    private var g:Vars = Vars.getInstance();

    public function ManagerOrderCats() {
        _arrCats = [];
    }

    public function addCatsOnStartGame():void {
        var arr:Array = g.managerOrder.arrOrders;
        var cat:OrderCat;
        var leftSeconds:int;
        var r:int = 0;
        for (var i:int=0; i<arr.length; i++) {
            leftSeconds = arr[i].startTime - int(new Date().getTime()/1000);
            if (leftSeconds <= 0) {
                cat = new OrderCat(arr[i].catOb);
                cat.setTailPositions(30, 25 - r*2);
                cat.walkPosition = OrderCat.STAY_IN_QUEUE;
                cat.setPositionInQueue(r);
                g.townArea.addOrderCatToCont(cat);
                g.townArea.addOrderCatToCityObjects(cat);
                _arrCats.push(cat);
                arr[r].cat = cat;
                cat.idleFrontAnimation();
                r++;
            }
        }
    }

    public function onGoAwayToUser(v:Boolean):void {
        for (var i:int=0; i<_arrCats.length; i++) {
            if (v)
                (_arrCats[i] as OrderCat).stopAnimation();
            else
                if ((_arrCats[i] as OrderCat).walkPosition == OrderCat.STAY_IN_QUEUE) {
                    (_arrCats[i] as OrderCat).idleFrontAnimation();
                } else (_arrCats[i] as OrderCat).runAnimation();
        }
    }

   // ------- cat go away -----------
    public function onReleaseOrder(cat:OrderCat, isOrderSelled:Boolean):void {
        if (!cat) {
           Cc.error('ManagerOrderCats onReleaseOrder:: cat == null');
           return;
        }
        var i:int = _arrCats.indexOf(cat);
        if (i > -1) _arrCats.splice(i, 1);
        cat.forceStopAnimation();
        if (cat.walkPosition == OrderCat.STAY_IN_QUEUE) {
            if (isOrderSelled) {
                cat.walkPackAnimation();
            } else {
                cat.walkAnimation();
            }
            goCatToPoint(cat, new Point(cat.posX + 1, cat.posY), goAwayPart1, cat);
        } else {

            var onFinishArrive:Function = function():void {
                if (isOrderSelled) {
                    cat.walkPackAnimation();
                } else {
                    cat.walkAnimation();
                }
                if (cat.walkPosition == OrderCat.TILE_WALKING) {
                    cat.showFront(false);
                    goAwayPart1(cat);
                } else if (cat.walkPosition == OrderCat.SHORT_OUTTILE_WALKING) {
                    cat.flipIt(true);
                    cat.showFront(true);
                    goAwayPart2(cat);
                } else if (cat.walkPosition == OrderCat.LONG_OUTTILE_WALKING) {
                    var time:int = 20 * (3600*g.scaleFactor - cat.source.x)/(3600*g.scaleFactor - 1500*g.scaleFactor);
                    goAwayPart3(cat,time);
                }
            };
            cat.flipIt(false);
            cat.showFront(true);
            cat.sayHIAnimation(onFinishArrive);
        }

// move queue
        var pos:int = cat.queuePosition;
        for (i=0; i<_arrCats.length; i++) {
            if (_arrCats[i].queuePosition > pos) {
                if (_arrCats[i].walkPosition == OrderCat.STAY_IN_QUEUE) {
                    moveQueue(_arrCats[i]);
                } else {
                    _arrCats[i].setPositionInQueue(_arrCats[i].queuePosition-1);
                }
            }
        }
    }

    private function moveQueue(cat:OrderCat):void {
        cat.forceStopAnimation();
        cat.walkAnimation();
        goCatToPoint(cat, new Point(cat.posX, cat.posY+2), afterMoveQueue, cat);
    }

    private function afterMoveQueue(cat:OrderCat):void {
        cat.forceStopAnimation();
        cat.idleFrontAnimation();
        cat.setPositionInQueue(cat.queuePosition-1);
    }

    private function goAwayPart1(cat:OrderCat):void {
        goCatToPoint(cat, new Point(cat.posX, 0), goAwayPart2, cat);
    }

    private function goAwayPart2(cat:OrderCat):void {
        cat.flipIt(true);
        cat.showFront(true);
        cat.goCatToXYPoint(new Point(1500*g.scaleFactor, 676*g.scaleFactor), 2, goAwayPart3);
    }

    private function goAwayPart3(cat:OrderCat, time:int = -1):void {
        if (time == -1) time = 20;
        cat.goCatToXYPoint(new Point(3600*g.scaleFactor, 1760*g.scaleFactor), time, onGoAway);
    }

    private function onGoAway(cat:OrderCat):void {
        cat.deleteIt();
        cat = null;
    }

    public function goCatToPoint(cat:OrderCat, p:Point, callback:Function = null, ...callbackParams):void {
        var f2:Function = function ():void {
            try {
                if (callback != null) {
                    callback.apply(null, callbackParams);
                }
            } catch (e:Error) {
                Cc.error('ManagerOrderCats goCatToPoint f2 error: ' + e.errorID + ' - ' + e.message);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerOrderCats goCatToPoint2');
            }
        };

        var f1:Function = function (arr:Array):void {
            try {
                cat.goWithPath(arr, f2);
            } catch (e:Error) {
                Cc.error('ManagerOrderCats goCatToPoint f1 error: ' + e.errorID + ' - ' + e.message);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerOrderCats goCatToPoint1');
            }
        };

//        try {
//            var a:AStar = new AStar();
//            a.getPath(cat.posX, cat.posY, p.x, p.y, f1);
//        } catch (e:Error) {
//            Cc.error('ManagerOrderCats goCatToPoint error: ' + e.errorID + ' - ' + e.message);
//            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerOrderCats goCatToPoint cat == null');
//        }
        
        //new variant without astar
        var arrPath:Array = DirectWay.getDirectXYWay(cat.posX, cat.posY, p.x, p.y);
        f1(arrPath);
    }


    // ------ new Cat arrived --------
    public function getNewCatForOrder(onArriveCallback:Function = null,ob:Object = null):OrderCat{
        var cat:OrderCat = new OrderCat(ob);
        cat.arriveCallback = onArriveCallback;
        cat.setPositionInQueue(getFreeQueuePosition());
        _arrCats.push(cat);
        arriveNewCat(cat);
        return cat;
    }

    private function getFreeQueuePosition():int {
//        var max:int = g.managerOrder.maxCountOrders;
//        var arr:Array = [];
//        for (var i:int=0; i<max; i++) {
//            arr.push(i);
//        }
//        for (i=0; i<_arrCats.length; i++) {
//             if (arr.indexOf(_arrCats[i].queuePosition)>-1) {
//                 arr.splice(arr.indexOf(_arrCats[i].queuePosition), 1);
//             } else {
//                 Cc.error("ManagerOrderCats:: getFreeQueuePosition error: mismatch with queue position: " + _arrCats[i].queuePosition);
//             }
//        }
//
//        if (!arr.length) {
//            Cc.error("ManagerOrderCats:: getFreeQueuePosition error: no free queue position, so use next: " + String(max));
//            return max;
//        } else {
//            return arr[0];
//        }

        var ar:Array = g.managerOrder.arrOrders.slice();
        var b:Boolean = false;
        var max:int = g.managerOrder.maxCountOrders;
        var r:int = 0;
        for (var i:int = 0; i < ar.length; i++) {
            if (!b) b = false;
            if (!ar[i].cat) {
                r++;
                b = true;
            }
        }
        if (b) {
            return max - r;
        }
        else {
            return int(max);
        }
//        return 5;
    }

    private function arriveNewCat(cat:OrderCat):void {
        cat.source.x = 3600*g.scaleFactor;
        cat.source.y = 1760*g.scaleFactor;
        g.townArea.addOrderCatToCont(cat);
        g.townArea.addOrderCatToCityObjects(cat);
        cat.flipIt(true);
        cat.showFront(false);
        cat.runAnimation();
        cat.walkPosition = OrderCat.LONG_OUTTILE_WALKING;
        cat.goCatToXYPoint(new Point(1500*g.scaleFactor, 676*g.scaleFactor), 7, arrivePart1);
    }

    private function arrivePart1(cat:OrderCat):void {
        cat.flipIt(false);
        cat.showFront(true);
        var p:Point = new Point(30, 0);
        p = g.matrixGrid.getXYFromIndex(p);
        cat.walkPosition = OrderCat.SHORT_OUTTILE_WALKING;
        if (g.managerTutorial.isTutorial) {
            cat.runAnimation();
            cat.goCatToXYPoint(p, 1, arrivePart2);
        } else {
//            cat.walkAnimation();
            cat.runAnimation();
            cat.goCatToXYPoint(p, 2, arrivePart2);
        }
    }

    private function arrivePart2(cat:OrderCat):void {
        cat.setTailPositions(30, 0);
        cat.walkPosition = OrderCat.TILE_WALKING;
        goCatToPoint(cat, new Point(30, 25 - cat.queuePosition*2), afterArrive, cat);
    }

    private function afterArrive(cat:OrderCat):void {
        if (cat.posY != 25 - cat.queuePosition*2) {
            goCatToPoint(cat, new Point(30, 25 - cat.queuePosition*2), afterArrive, cat);
        } else {
            var onFinishArrive:Function = function():void {
                cat.forceStopAnimation();
                cat.idleFrontAnimation();
                cat.walkPosition = OrderCat.STAY_IN_QUEUE;
            };
            cat.sayHIAnimation(onFinishArrive);
            cat.checkArriveCallback();
        }
    }


}
}
