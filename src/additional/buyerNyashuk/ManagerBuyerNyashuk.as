/**
 * Created by user on 12/14/16.
 */
package additional.buyerNyashuk {
import com.junkbyte.console.Cc;

import dragonBones.Armature;

import flash.geom.Point;

import manager.*;

import additional.buyerNyashuk.BuyerNyashuk;

import manager.AStar.DirectWay;

import windows.WindowsManager;

public class ManagerBuyerNyashuk {
    private var _arr:Array;
    private var g:Vars = Vars.getInstance();
    private var _arrayNya:Array;
    private var _timer:int;
    private var afterNewLvl:Boolean;
    
    public function ManagerBuyerNyashuk(first:Boolean = false) {
        afterNewLvl = first;
        _arrayNya = [];
        g.loadAnimation.load('animations_json/x1/red_n', 'red_n', null);
        g.loadAnimation.load('animations_json/x1/blue_n', 'blue_n', null);
        g.directServer.getUserPapperBuy(null);
    }

    public function fillBot(ar:Array):void {
        var ob:Object;
        var i:int;
        _arr = null;
        _arr = [];
        if (ar.length > 0) {
            for (i = 0; i < ar.length; i++) {
                if (ar[i].visible == true) {
                    if (int(ar[i].user_id == g.user.userId)) continue;
                    ob = {};
                    ob.buyerId = int(ar[i].buyer_id);
                    ob.resourceId = int(ar[i].resource_id);
                    ob.resourceCount = int(ar[i].resource_count);
                    ob.cost = int(ar[i].cost);
                    ob.xp = int(ar[i].xp);
                    ob.type = int(ar[i].type_resource);
                    ob.timeToNext = int(ar[i].time_to_new);
                    ob.isBuyed = false;
                    ob.isBotBuy = true;
                    ob.visible = Boolean(ar[i].visible);
                    _arr.push(ob);

            } else if (ar[i].visible == false && (ar[i].time_to_new - int(new Date().getTime()/1000)) * (-1) >= 1200) {
                    newBot(false,ar[i]);
                } else {
                    if (ar[i].buyer_id == 1) g.userTimer.buyerNyashukBlue((ar[i].time_to_new - int(new Date().getTime()/1000)) * (-1));
                    else g.userTimer.buyerNyashukRed((ar[i].time_to_new - int(new Date().getTime()/1000)) * (-1));
                }
            }
        } else newBot(true);
        if (!afterNewLvl) {
            var b:BuyerNyashuk;
            for (i = 0; i < _arr.length; i++) {
                b = new BuyerNyashuk(_arr[i].buyerId, _arr[i]);
                _arrayNya.push(b);
            }
        }
        _timer = 0;
        g.gameDispatcher.addToTimer(timeToCreate);
    }

    private function timeToCreate():void {
        _timer++;
        if (_timer >= 5) {
            if (!afterNewLvl) {
                g.gameDispatcher.removeFromTimer(timeToCreate);
                _timer = 0;
                addNyashukOnStartGame();
            } else {
            if (_arr.length > 0 && _timer == 5) getNewNyaForOrder(null, _arr[0], _arr[0].buyerId);
                if (_arr.length == 2) {
                    if (_timer >= 7) {
                        g.gameDispatcher.removeFromTimer(timeToCreate);
                        _timer = 0;
                        getNewNyaForOrder(null, _arr[1], _arr[1].buyerId);
                    }
                }
            }
        }
    }

    public function addNyashukOnStartGame():void {
        var leftSeconds:int;
        var r:int = 0;
        for (var i:int=0; i<_arrayNya.length; i++) {
            leftSeconds = arr[i].startTime - int(new Date().getTime()/1000);
            if (leftSeconds <= 0) {
                if (_arrayNya[i].id == 1) _arrayNya[i].setTailPositions(28, -5);
                else _arrayNya[i].setTailPositions(30, -5);
                _arrayNya[i].setTailPositions(30 - r*2 , -5 );
                _arrayNya[i].walkPosition = BuyerNyashuk.STAY_IN_QUEUE;
                _arrayNya[i].setPositionInQueue(r);
                g.townArea.addBuyerNyashukToCont(_arrayNya[i]);
                g.townArea.addBuyerNyashukToCityObjects(_arrayNya[i]);
                _arrayNya[i].idleFrontAnimation();
                r++;
            }
        }
    }

    public function timeToNewNyashuk():void {
        var ob:Object = {};
        if (_arr.length == 0) ob.buyer_id = 1;
        else if (_arr[0].buyerId == 1) ob.buyer_id = 2;
            else ob.buyer_id = 1;
        newBot(false,ob);
        getNewNyaForOrder(null,_arr[arr.length-1],_arr[_arr.length-1].buyerId);
    }

    private function newBot(firstBot:Boolean = false, objectNew:Object = null):void {
        var id:String;
        var obData:Object = g.dataResource.objectResources;
        var arrMin:Array = [];
        var arr:Array;
        var arrMax:Array = [];
        var ob:Object;
        var ra:int;
        var i:int;
        if (firstBot) {
            for (id in obData) {
                if (obData[id].blockByLevel <= g.user.level && !g.userInventory.getCountResourceById(obData[id].id) && obData[id].visitorPrice > 0) {
                    arrMin.push(obData[id]);
                }
            }
            arr = g.userInventory.getResourcesForAmbarAndSklad();
            arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
            for (i = 0; i < arr.length; i++) {
                if (arrMax.length >= 3) break;
                if (g.dataResource.objectResources[arr[i].id].visitorPrice > 0) arrMax.push(arr[i]);
            }
            ra =  Math.random() * arrMin.length;
            ob = {};
            ob.buyerId = 1;
            ob.resourceId = arrMin[ra].id;
            ob.resourceCount = 1;
            ob.cost = arrMin[ra].visitorPrice * ob.resourceCount;
            ob.xp = 5;
            ob.type = arrMin[ra].buildType;
            ob.timeToNext = 0;
            ob.isBuyed = false;
            ob.isBotBuy = true;
            ob.visible = true;
            _arr.push(ob);

            ra = Math.random() * arrMax.length;
            ob = {};
            ob.buyerId = 2;
            ob.resourceId = arrMax[ra].id;
            ob.resourceCount = int(Math.random()*arrMax[ra].count) + 1;
            ob.cost = g.dataResource.objectResources[arrMax[ra].id].visitorPrice * ob.resourceCount;
            ob.xp = 5;
            ob.type = g.dataResource.objectResources[arrMax[ra].id].buildType;
            ob.timeToNext = 0;
            ob.isBuyed = false;
            ob.isBotBuy = true;
            ob.visible = true;
            _arr.push(ob);
            for (i = 0; i < 2; i++) {
                g.directServer.addUserPapperBuy(_arr[i].buyerId, _arr[i].resourceId, _arr[i].resourceCount, _arr[i].xp, _arr[i].cost, 1);
            }
        } else  {
            if (objectNew.buyer_id == 1) {
                for (id in obData) {
                    if (obData[id].blockByLevel <= g.user.level && !g.userInventory.getCountResourceById(obData[id].id) && obData[id].visitorPrice > 0) {
                        arrMin.push(obData[id]);
                    }
                }
                ra = Math.random() * arrMin.length;
                ob = {};
                ob.buyerId = 1;
                ob.resourceId = arrMin[ra].id;
                ob.resourceCount = 1;
                ob.cost = arrMin[ra].visitorPrice * ob.resourceCount;
                ob.xp = 5;
                ob.type = arrMin[ra].buildType;
                ob.timeToNext = 0;
                ob.isBuyed = false;
                ob.isBotBuy = true;
                ob.visible = true;
            } else {
                arr = g.userInventory.getResourcesForAmbarAndSklad();
                arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
                for (i = 0; i < arr.length; i++) {
                    if (arrMax.length >= 3) break;
                    if (g.dataResource.objectResources[arr[i].id].visitorPrice > 0) arrMax.push(arr[i]);
                }
                ra = Math.random() * arrMax.length;
                ob = {};
                ob.buyerId = 2;
                ob.resourceId = arrMax[ra].id;
                ob.resourceCount = int(Math.random()*arrMax[ra].count) + 1;
                ob.cost = g.dataResource.objectResources[arrMax[ra].id].visitorPrice * ob.resourceCount;
                ob.xp = 5;
                ob.type = g.dataResource.objectResources[arrMax[ra].id].buildType;
                ob.timeToNext = 0;
                ob.isBuyed = false;
                ob.isBotBuy = true;
                ob.visible = true;
            }
            _arr.push(ob);
            g.directServer.updateUserPapperBuy(ob.buyerId,ob.resourceId,ob.resourceCount,ob.xp,ob.cost,1,ob.type);
        }
    }

    public function get arr():Array { return _arr; }
    public function addArrows(t:Number = 0):void {
        for (var i:int=0; i<_arrayNya.length; i++) {
            (_arrayNya[i] as BuyerNyashuk).addArrow(t);
        }
    }

    public function onGoAwayToUser(v:Boolean):void {
        for (var i:int=0; i<_arrayNya[i].length; i++) {
            if (v)
                (_arrayNya[i] as BuyerNyashuk).stopAnimation();
            else
            if ((_arrayNya[i] as BuyerNyashuk).walkPosition == BuyerNyashuk.STAY_IN_QUEUE) {
                (_arrayNya[i] as BuyerNyashuk).idleFrontAnimation();
            } else (_arrayNya[i] as BuyerNyashuk).walkAnimation();
        }
    }

    // ------- cat go away -----------
    public function onReleaseOrder(nya:BuyerNyashuk, isOrderSelled:Boolean):void {
        if (!nya) {
            Cc.error('ManagerBuyerNyashuk onReleaseOrder:: nya == null');
            return;
        }
        nya.noClick();
        var i:int = _arrayNya.indexOf(nya);
        if (i > -1) {
            _arrayNya.splice(i, 1);
            _arr.splice(i, 1);
        }

        nya.forceStopAnimation();
        if (nya.walkPosition == BuyerNyashuk.STAY_IN_QUEUE) {
            if (isOrderSelled) {
                nya.walkPackAnimation();
            } else {
                nya.walkAnimation();
            }
//            goNyaToPoint(nya, new Point(nya.posX + 1, nya.posY), goAwayPart1,true, nya );
            goAwayPart2(nya);
        } else {

            var onFinishArrive:Function = function():void {
                if (isOrderSelled) {
                    nya.walkPackAnimation();
                } else {
                    nya.walkAnimation();
                }
                if (nya.walkPosition == BuyerNyashuk.TILE_WALKING) {
                    nya.showFront(false);
                    goAwayPart1(nya);
                } else if (nya.walkPosition == BuyerNyashuk.SHORT_OUTTILE_WALKING) {
                    nya.flipIt(true);
                    nya.showFront(true);
                    goAwayPart2(nya);
                } else if (nya.walkPosition == BuyerNyashuk.LONG_OUTTILE_WALKING) {
                    var time:int = 20 * (3600*g.scaleFactor - nya.source.x)/(3600*g.scaleFactor - 1500*g.scaleFactor);
                    goAwayPart3(nya,time);
                }
            };
            nya.flipIt(false);
            nya.showFront(true);
        }
    }

    private function goAwayPart1(nya:BuyerNyashuk):void {
        goNyaToPoint(nya, new Point(nya.posX, -5), goAwayPart2,true, nya);
    }

    private function goAwayPart2(nya:BuyerNyashuk):void {
        nya.flipIt(true);
        nya.showFront(true);
        nya.goNyaToXYPoint(new Point(1500*g.scaleFactor, 676*g.scaleFactor), 6, goAwayPart3);
    }

    private function goAwayPart3(nya:BuyerNyashuk, time:int = -1):void {
        if (time == -1) time = 28;
        nya.goNyaToXYPoint(new Point(3600*g.scaleFactor, 1760*g.scaleFactor), 28, onGoAway);
    }

    private function onGoAway(nya:BuyerNyashuk,id:int):void {
        nya.deleteIt();
        nya = null;
    }

    public function goNyaToPoint(nya:BuyerNyashuk, p:Point, callback:Function = null, goAway:Boolean = false, ...callbackParams):void {
        var f2:Function = function ():void {
            try {
                if (callback != null) {
                    callback.apply(null, callbackParams);
                }
            } catch (e:Error) {
                Cc.error('ManagerBuyerNyashuk goNyaToPoint f2 error: ' + e.errorID + ' - ' + e.message);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerBuyerNyashuk goNyaToPoint2');
            }
        };

        var f1:Function = function (arr:Array, goAway:Boolean):void {
            try {
            if (arr.length == 1 || !arr) {
                nya.forceStopAnimation();
                nya.idleFrontAnimation();
                nya.walkPosition = BuyerNyashuk.STAY_IN_QUEUE;
                return;
            }
                nya.goWithPath(arr, f2, goAway);
            } catch (e:Error) {
                Cc.error('ManagerBuyerNyashuk goNyaToPoint f1 error: ' + e.errorID + ' - ' + e.message);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerBuyerNyashuk goNyaToPoint1');
            }
        };

        var arrPath:Array = DirectWay.getDirectXYWay(nya.posX, nya.posY, p.x, p.y);
        f1(arrPath, goAway);
    }


    // ------ new Nyashuk arrived --------
    public function getNewNyaForOrder(onArriveCallback:Function = null, ob:Object = null, id:int = 1):BuyerNyashuk{
        var nya:BuyerNyashuk = new BuyerNyashuk(id,ob);
        nya.noClick();
        nya.arriveCallback = onArriveCallback;
        nya.setPositionInQueue(getFreeQueuePosition());
        _arrayNya.push(nya);
        arriveNewCat(nya);
        return nya;
    }

    private function getFreeQueuePosition():int {
        if (!_arrayNya) return 0;
        else return _arrayNya.length - 1;
    }

    private function arriveNewCat(nya:BuyerNyashuk):void {
        nya.source.x = 3600*g.scaleFactor;
        nya.source.y = 1760*g.scaleFactor;
        g.townArea.addBuyerNyashukToCont(nya);
        g.townArea.addBuyerNyashukToCityObjects(nya);
        nya.flipIt(true);
        nya.showFront(false);
        nya.walkAnimation();
        nya.walkPosition = BuyerNyashuk.LONG_OUTTILE_WALKING;
        nya.goNyaToXYPoint(new Point(1500*g.scaleFactor, 676*g.scaleFactor), 28, arrivePart1);
    }

    private function arrivePart1(nya:BuyerNyashuk,id:int):void {
        var p:Point;
        if (id == 1)  p = new Point(30, -5);
        else p = new Point(28, -5);
        p = g.matrixGrid.getXYFromIndex(p);
        nya.walkPosition = BuyerNyashuk.SHORT_OUTTILE_WALKING;
        nya.flipIt(true);
        nya.showFront(false);
        if (g.managerTutorial.isTutorial) {
            nya.walkAnimation();
            nya.goNyaToXYPoint(p, 6, arrivePart2);
        } else {
//            cat.walkAnimation();
            nya.walkAnimation();
//            cat.goCatToXYPoint(p, 2, arrivePart2);
            nya.goNyaToXYPoint(p, 6, arrivePart2);
        }
    }

    private function arrivePart2(nya:BuyerNyashuk, id:int):void {
        if (id == 1) nya.setTailPositions(30, -5);
        else nya.setTailPositions(28, -5);

//
//        nya.walkPosition = BuyerNyashuk.TILE_WALKING;
//        if (id == 1) goNyaToPoint(nya, new Point(30, -5 ), afterArrive, false, nya);
//        else goNyaToPoint(nya, new Point(28, -5 ), afterArrive, false, nya);
        nya.flipIt(false);
        nya.yesClick();
        nya.forceStopAnimation();
        nya.idleFrontAnimation();
        nya.walkPosition = BuyerNyashuk.STAY_IN_QUEUE;
    }

//    private function afterArrive(nya:BuyerNyashuk):void {
//        if (nya.posY != -5) {
//            goNyaToPoint(nya, new Point(30 - nya.queuePosition*2, -5), afterArrive, false, nya);
//        } else {
//            var onFinishArrive:Function = function():void {
//                nya.forceStopAnimation();
//                nya.idleFrontAnimation();
//                nya.walkPosition = BuyerNyashuk.STAY_IN_QUEUE;
//            };
//            nya.checkArriveCallback();
//            nya.forceStopAnimation();
//            nya.idleFrontAnimation();
////            nya.flipIt(false);
//            nya.walkPosition = BuyerNyashuk.STAY_IN_QUEUE;
//        }
//
//    }
}
}
