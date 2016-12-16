///**
// * Created by user on 12/14/16.
// */
//package additional.buyerNyashuk {
//import com.junkbyte.console.Cc;
//
//import dragonBones.Armature;
//
//import flash.geom.Point;
//
//import manager.*;
//
//import additional.buyerNyashuk.BuyerNyashuk;
//
//import manager.AStar.DirectWay;
//
//import windows.WindowsManager;
//
//public class ManagerBuyerNyashuk {
//
//    private var _arr:Array;
//    private var g:Vars = Vars.getInstance();
//    private var _arrayNya:Array;
//
//    public function ManagerBuyerNyashuk() {
//        _arrayNya = [];
//    }
//
//    public function fillBot(ar:Array):void {
//        var ob:Object;
//        _arr = null;
//        _arr = [];
//        if (ar.length > 0) {
//            for (var i:int = 0; i < ar.length; i++) {
//                if (ar[i].visible == true) {
//                    if (int(ar[i].user_id == g.user.userId)) continue;
//                    ob = {};
//                    ob.buyerId = int(ar[i].buyer_id);
//                    ob.resourceId = int(ar[i].resource_id);
//                    ob.resourceCount = int(ar[i].resource_count);
//                    ob.cost = int(ar[i].cost);
//                    ob.xp = int(ar[i].xp);
//                    ob.type = int(ar[i].type_resource);
//                    ob.timeToNext = int(ar[i].time_to_new);
//                    ob.isBuyed = false;
//                    ob.isBotBuy = true;
//                    ob.visible = Boolean(ar[i].visible);
//                    _arr.push(ob);
//                } else if (ar[i].visible == false && (ar[i].time_to_new - int(new Date().getTime()/1000)) * (-1) >= 1800) {
//                    newBot(false,ar[i]);
//                }
//            }
//        } else newBot(true);
//        var b:BuyerNyashuk;
//        for (i = 0; i < _arr.length; i++) {
//            b = new BuyerNyashuk(_arr[i].buyerId, _arr[i]);
//            _arrayNya.push(b);
//        }
//    }
//
//    private function newBot(firstBot:Boolean = false, objectNew:Object = null):void {
//        var id:String;
//        var obData:Object = g.dataResource.objectResources;
//        var arrMin:Array = [];
//        var arr:Array;
//        var arrMax:Array = [];
//        var ob:Object;
//        var ra:int;
//        var i:int;
//        if (firstBot) {
//            for (id in obData) {
//                if (obData[id].blockByLevel <= g.user.level && !g.userInventory.getCountResourceById(obData[id].id) && obData[id].visitorPrice > 0) {
//                    arrMin.push(obData[id]);
//                }
//            }
//            arr = g.userInventory.getResourcesForAmbarAndSklad();
//            arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
//            for (i = 0; i < arr.length; i++) {
//                if (arrMax.length >= 3) break;
//                if (g.dataResource.objectResources[arr[i].id].visitorPrice > 0) arrMax.push(arr[i]);
//            }
//            ra =  Math.random() * arrMin.length;
//            ob = {};
//            ob.buyerId = 1;
//            ob.resourceId = arrMin[ra].id;
//            ob.resourceCount = 1;
//            ob.cost = arrMin[ra].visitorPrice * ob.resourceCount;
//            ob.xp = 5;
//            ob.type = arrMin[ra].buildType;
//            ob.timeToNext = 0;
//            ob.isBuyed = false;
//            ob.isBotBuy = true;
//            ob.visible = true;
//            _arr.push(ob);
//
//            ra = Math.random() * arrMax.length;
//            ob = {};
//            ob.buyerId = 2;
//            ob.resourceId = arrMax[ra].id;
//            ob.resourceCount = int(Math.random()*arrMax[ra].count) + 1;
//            ob.cost = g.dataResource.objectResources[arrMax[ra].id].visitorPrice * ob.resourceCount;
//            ob.xp = 5;
//            ob.type = g.dataResource.objectResources[arrMax[ra].id].buildType;
//            ob.timeToNext = 0;
//            ob.isBuyed = false;
//            ob.isBotBuy = true;
//            ob.visible = true;
//            _arr.push(ob);
//            for (i = 0; i < 2; i++) {
//                g.directServer.addUserPapperBuy(_arr[i].buyerId, _arr[i].resourceId, _arr[i].resourceCount, _arr[i].xp, _arr[i].cost, 1);
//            }
//        } else  {
//            if (objectNew.buyer_id == 1) {
//                for (id in obData) {
//                    if (obData[id].blockByLevel <= g.user.level && !g.userInventory.getCountResourceById(obData[id].id) && obData[id].visitorPrice > 0) {
//                        arrMin.push(obData[id]);
//                    }
//                }
//                ra = Math.random() * arrMin.length;
//                ob = {};
//                ob.buyerId = 1;
//                ob.resourceId = arrMin[ra].id;
//                ob.resourceCount = 1;
//                ob.cost = arrMin[ra].visitorPrice * ob.resourceCount;
//                ob.xp = 5;
//                ob.type = arrMin[ra].buildType;
//                ob.timeToNext = 0;
//                ob.isBuyed = false;
//                ob.isBotBuy = true;
//                ob.visible = true;
//            } else {
//                arr = g.userInventory.getResourcesForAmbarAndSklad();
//                arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
//                for (i = 0; i < arr.length; i++) {
//                    if (arrMax.length >= 3) break;
//                    if (g.dataResource.objectResources[arr[i].id].visitorPrice > 0) arrMax.push(arr[i]);
//                }
//                ra = Math.random() * arrMax.length;
//                ob = {};
//                ob.buyerId = 2;
//                ob.resourceId = arrMax[ra].id;
//                ob.resourceCount = int(Math.random()*arrMax[ra].count) + 1;
//                ob.cost = g.dataResource.objectResources[arrMax[ra].id].visitorPrice * ob.resourceCount;
//                ob.xp = 5;
//                ob.type = g.dataResource.objectResources[arrMax[ra].id].buildType;
//                ob.timeToNext = 0;
//                ob.isBuyed = false;
//                ob.isBotBuy = true;
//                ob.visible = true;
//            }
//            _arr.push(ob);
//            g.directServer.updateUserPapperBuy(ob.buyerId,ob.resourceId,ob.resourceCount,ob.xp,ob.cost,1,ob.type);
//        }
//    }
//
//    public function get arr():Array {
//        return _arr;
//    }
//
//    public function getPaperItems():void {
//        g.directServer.getUserPapperBuy(getUserPapperBuy);
//
//    }
//
//    private function getUserPapperBuy ():void {
//        g.directServer.getPaperItems(null);
//    }
//
//    public function addCatsOnStartGame():void {
//        var leftSeconds:int;
//        var r:int = 0;
//        for (var i:int=0; i<_arrayNya.length; i++) {
//            leftSeconds = arr[i].startTime - int(new Date().getTime()/1000);
//            if (leftSeconds <= 0) {
//                _arrayNya[i].setTailPositions(30, 25 - r*2);
//                _arrayNya[i].walkPosition = BuyerNyashuk.STAY_IN_QUEUE;
//                _arrayNya[i].setPositionInQueue(r);
//                g.townArea.addOrderCatToCont(_arrayNya[i]);
//                g.townArea.addOrderCatToCityObjects(_arrayNya[i]);
//                _arrayNya[i].idleFrontAnimation();
//                r++;
//            }
//        }
//    }
//
//    public function onGoAwayToUser(v:Boolean):void {
//        for (var i:int=0; i<_arrayNya[i].length; i++) {
//            if (v)
//                (_arrayNya[i] as BuyerNyashuk).stopAnimation();
//            else
//            if ((_arrayNya[i] as BuyerNyashuk).walkPosition == BuyerNyashuk.STAY_IN_QUEUE) {
//                (_arrayNya[i] as BuyerNyashuk).idleFrontAnimation();
//            } else (_arrayNya[i] as BuyerNyashuk).runAnimation();
//        }
//    }
//
//    // ------- cat go away -----------
//    public function onReleaseOrder(cat:BuyerNyashuk, isOrderSelled:Boolean):void {
//        if (!cat) {
//            Cc.error('ManagerOrderCats onReleaseOrder:: cat == null');
//            return;
//        }
//        var i:int = _arrayNya.indexOf(cat);
//        if (i > -1) _arrayNya.splice(i, 1);
//        cat.forceStopAnimation();
//        if (cat.walkPosition == BuyerNyashuk.STAY_IN_QUEUE) {
//            if (isOrderSelled) {
//                cat.walkPackAnimation();
//            } else {
//                cat.walkAnimation();
//            }
//            goCatToPoint(cat, new Point(cat.posX + 1, cat.posY), goAwayPart1,true, cat );
//        } else {
//
//            var onFinishArrive:Function = function():void {
//                if (isOrderSelled) {
//                    cat.walkPackAnimation();
//                } else {
//                    cat.walkAnimation();
//                }
//                if (cat.walkPosition == BuyerNyashuk.TILE_WALKING) {
//                    cat.showFront(false);
//                    goAwayPart1(cat);
//                } else if (cat.walkPosition == BuyerNyashuk.SHORT_OUTTILE_WALKING) {
//                    cat.flipIt(true);
//                    cat.showFront(true);
//                    goAwayPart2(cat);
//                } else if (cat.walkPosition == BuyerNyashuk.LONG_OUTTILE_WALKING) {
//                    var time:int = 20 * (3600*g.scaleFactor - cat.source.x)/(3600*g.scaleFactor - 1500*g.scaleFactor);
//                    goAwayPart3(cat,time);
//                }
//            };
//            cat.flipIt(false);
//            cat.showFront(true);
//            cat.sayHIAnimation(onFinishArrive);
//        }
//
//// move queue
//        var pos:int = cat.queuePosition;
//        for (i=0; i<_arrayNya.length; i++) {
//            if (_arrayNya[i].queuePosition > pos) {
//                if (_arrayNya[i].walkPosition == BuyerNyashuk.STAY_IN_QUEUE) {
//                    moveQueue(_arrayNya[i]);
//                } else {
//                    _arrayNya[i].setPositionInQueue(_arrayNya[i].queuePosition-1);
//                }
//            }
//        }
//    }
//
//    private function moveQueue(cat:BuyerNyashuk):void {
//        cat.forceStopAnimation();
//        cat.walkAnimation();
//        goCatToPoint(cat, new Point(cat.posX, cat.posY+2), afterMoveQueue,true, cat );
//    }
//
//    private function afterMoveQueue(cat:BuyerNyashuk):void {
//        cat.forceStopAnimation();
//        cat.idleFrontAnimation();
//        cat.setPositionInQueue(cat.queuePosition-1);
//    }
//
//    private function goAwayPart1(cat:BuyerNyashuk):void {
//        goCatToPoint(cat, new Point(cat.posX, 0), goAwayPart2,true, cat);
//    }
//
//    private function goAwayPart2(cat:BuyerNyashuk):void {
//        cat.flipIt(true);
//        cat.showFront(true);
//        cat.goCatToXYPoint(new Point(1500*g.scaleFactor, 676*g.scaleFactor), 2, goAwayPart3);
//    }
//
//    private function goAwayPart3(cat:BuyerNyashuk, time:int = -1):void {
//        if (time == -1) time = 20;
//        cat.goCatToXYPoint(new Point(3600*g.scaleFactor, 1760*g.scaleFactor), time, onGoAway);
//    }
//
//    private function onGoAway(cat:BuyerNyashuk):void {
//        cat.deleteIt();
//        cat = null;
//    }
//
//    public function goCatToPoint(cat:BuyerNyashuk, p:Point, callback:Function = null, goAway:Boolean = false, ...callbackParams):void {
//        var f2:Function = function ():void {
//            try {
//                if (callback != null) {
//                    callback.apply(null, callbackParams);
//                }
//            } catch (e:Error) {
//                Cc.error('ManagerOrderCats goCatToPoint f2 error: ' + e.errorID + ' - ' + e.message);
//                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerOrderCats goCatToPoint2');
//            }
//        };
//
//        var f1:Function = function (arr:Array, goAway:Boolean):void {
//            try {
//                cat.goWithPath(arr, f2, goAway);
//            } catch (e:Error) {
//                Cc.error('ManagerOrderCats goCatToPoint f1 error: ' + e.errorID + ' - ' + e.message);
//                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerOrderCats goCatToPoint1');
//            }
//        };
//
////        try {
////            var a:AStar = new AStar();
////            a.getPath(cat.posX, cat.posY, p.x, p.y, f1);
////        } catch (e:Error) {
////            Cc.error('ManagerOrderCats goCatToPoint error: ' + e.errorID + ' - ' + e.message);
////            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerOrderCats goCatToPoint cat == null');
////        }
//
//        //new variant without astar
//        var arrPath:Array = DirectWay.getDirectXYWay(cat.posX, cat.posY, p.x, p.y);
//        f1(arrPath, goAway);
//    }
//
//
//    // ------ new Cat arrived --------
//    public function getNewCatForOrder(onArriveCallback:Function = null, ob:Object = null):BuyerNyashuk{
//        var nya:BuyerNyashuk = new BuyerNyashuk(1,ob);
//        nya.arriveCallback = onArriveCallback;
//        nya.setPositionInQueue(getFreeQueuePosition());
//        _arrayNya.push(cat);
//        arriveNewCat(nya);
//        return nya;
//    }
//
//    private function getFreeQueuePosition():int {
////        var max:int = g.managerOrder.maxCountOrders;
////        var arr:Array = [];
////        for (var i:int=0; i<max; i++) {
////            arr.push(i);
////        }
////        for (i=0; i<_arrCats.length; i++) {
////             if (arr.indexOf(_arrCats[i].queuePosition)>-1) {
////                 arr.splice(arr.indexOf(_arrCats[i].queuePosition), 1);
////             } else {
////                 Cc.error("ManagerOrderCats:: getFreeQueuePosition error: mismatch with queue position: " + _arrCats[i].queuePosition);
////             }
////        }
////
////        if (!arr.length) {
////            Cc.error("ManagerOrderCats:: getFreeQueuePosition error: no free queue position, so use next: " + String(max));
////            return max;
////        } else {
////            return arr[0];
////        }
//
//        var ar:Array = g.managerOrder.arrOrders.slice();
//        var b:Boolean = false;
//        var max:int = g.managerOrder.maxCountOrders;
//        var r:int = 0;
//        for (var i:int = 0; i < ar.length; i++) {
//            if (!b) b = false;
//            if (!ar[i].cat) {
//                r++;
//                b = true;
//            }
//        }
//        if (b) {
//            return max - r;
//        }
//        else {
//            return int(max);
//        }
//    }
//
//    private function arriveNewCat(cat:BuyerNyashuk):void {
//        cat.source.x = 3600*g.scaleFactor;
//        cat.source.y = 1760*g.scaleFactor;
//        g.townArea.addBuyerNyashukToCont(cat);
//        g.townArea.addBuyerNyashukToCityObjects(cat);
//        cat.flipIt(true);
//        cat.showFront(false);
//        cat.runAnimation();
//        cat.walkPosition = BuyerNyashuk.LONG_OUTTILE_WALKING;
//        cat.goCatToXYPoint(new Point(1500*g.scaleFactor, 676*g.scaleFactor), 7, arrivePart1);
//    }
//
//    private function arrivePart1(cat:BuyerNyashuk):void {
//        cat.flipIt(false);
//        cat.showFront(true);
//        var p:Point = new Point(30, 0);
//        p = g.matrixGrid.getXYFromIndex(p);
//        cat.walkPosition = BuyerNyashuk.SHORT_OUTTILE_WALKING;
//        if (g.managerTutorial.isTutorial) {
//            cat.runAnimation();
//            cat.goCatToXYPoint(p, 1, arrivePart2);
//        } else {
////            cat.walkAnimation();
//            cat.runAnimation();
////            cat.goCatToXYPoint(p, 2, arrivePart2);
//            cat.goCatToXYPoint(p, 1, arrivePart2);
//        }
//    }
//
//    private function arrivePart2(cat:BuyerNyashuk):void {
//        cat.setTailPositions(30, 0);
//        cat.walkPosition = BuyerNyashuk.TILE_WALKING;
//        goCatToPoint(cat, new Point(30, 25 - cat.queuePosition*2), afterArrive, false, cat);
//    }
//
//    private function afterArrive(cat:BuyerNyashuk):void {
//        if (cat.posY != 25 - cat.queuePosition*2) {
//            goCatToPoint(cat, new Point(30, 25 - cat.queuePosition*2), afterArrive, false, cat);
//        } else {
//            var onFinishArrive:Function = function():void {
//                cat.forceStopAnimation();
//                cat.idleFrontAnimation();
//                cat.walkPosition = BuyerNyashuk.STAY_IN_QUEUE;
//            };
//            cat.sayHIAnimation(onFinishArrive);
//            cat.checkArriveCallback();
////            cat.forceStopAnimation();
////            cat.idleFrontAnimation();
////            cat.walkPosition = OrderCat.STAY_IN_QUEUE;
//        }
//    }
//
////    public function addAwayCats():void {
////        if (!g.isAway) return;
////        if (!g.visitedUser) return;
////        try {
////            var cat:OrderCat;
////            var ob:Object;
////            var l:int = g.managerOrder.getMaxCountForLevel(g.visitedUser.level);
////            if (l > 5) l = 5;
////            for (var i:int = 0; i < l; i++) {
////                ob = g.dataOrderCats.arrCats[int(Math.random() * g.dataOrderCats.arrCats.length)];
////                cat = new OrderCat(ob);
////                cat.setTailPositions(30, 25 - i * 2);
////                cat.walkPosition = OrderCat.STAY_IN_QUEUE;
////                cat.setPositionInQueue(i);
////                g.townArea.addOrderCatToCont(cat);
////                g.townArea.addOrderCatToAwayCityObjects(cat);
////                _arrAwayCats.push(cat);
////                cat.idleFrontAnimation();
////            }
////        } catch (e:Error) {
////            Cc.error('ManagerOrderCats addAWayCats:: error ' + e.errorID);
////        }
////    }
////
////    public function removeAwayCats():void {
////        for (var i:int=0; i<_arrAwayCats.length; i++) {
////            g.townArea.addOrderCatToCont(_arrAwayCats[i]);
////            g.townArea.addOrderCatToAwayCityObjects(_arrAwayCats[i]);
////            (_arrAwayCats[i] as OrderCat).deleteIt();
////        }
////        _arrAwayCats.length = 0;
////    }
//}
//}
