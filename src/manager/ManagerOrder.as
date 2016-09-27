/**
 * Created by andy on 11/14/15.
 */
package manager {
import build.orders.Order;

import com.junkbyte.console.Cc;

import data.BuildType;

import dragonBones.Bone;

import flash.utils.getTimer;

import tutorial.TutorialAction;

import utils.Utils;

public class ManagerOrder {
    public static const TIME_FIRST_DELAY:int = 3 * 60;
    public static const TIME_SECOND_DELAY:int = 5 * 60;
    public static const TIME_THIRD_DELAY:int = 10 * 60;
    public static const TIME_FOURTH_DELAY:int = 15 * 60;
    public static const TIME_FIFTH_DELAY:int = 20 * 60;

    public static const TIME_DELAY:int = 15 * 60;

    public static const COST_FIRST_SKIP_WAIT:int = 2;
    public static const COST_SECOND_SKIP_WAIT:int = 3;
    public static const COST_THIRD_SKIP_WAIT:int = 5;
    public static const COST_FOURTH_SKIP_WAIT:int = 6;
    public static const COST_FIFTH_SKIP_WAIT:int = 8;

    public static const COST_SKIP_WAIT:int = 8;

    private var _countCellOnLevel:Array;
    private var _countResourceOnLevelAtCell:Array;
    private var _arrOrders:Array;
    private var _curMaxCountOrders:int;
    private var _curMaxCountResoureAtOrder:int;
    private var _orderBuilding:Order;
//    private var _arrNames:Array;

    private var g:Vars = Vars.getInstance();

    public function ManagerOrder() {
        _countCellOnLevel = [
            {level: 1, count: 0},
            {level: 2, count: 1},
            {level: 4, count: 2},
            {level: 6, count: 3},
            {level: 7, count: 4},
            {level: 8, count: 5},
            {level: 9, count: 6},
            {level: 10, count: 7},
            {level: 22, count: 8},
            {level: 32, count: 9}];
        _countResourceOnLevelAtCell = [
            {level: 1, count: 1},
            {level: 2, count: 2},
            {level: 6, count: 3},
            {level: 8, count: 4},
            {level: 17, count: 5}
        ];
        _arrOrders = [];
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.ORDER);
        if (arr.length) _orderBuilding = arr[0];
//        _arrNames = ['Булавка', 'Петелька', 'Шпилька', 'Ниточка', 'Иголочка', 'Пряжа', 'Ленточка', 'Ирис', 'Наперсток', 'Кристик', 'Акрил', 'Стежок', 'Шнурочек', 'Ажур'];
    }

    public function get arrOrders():Array {
        return _arrOrders;
    }

    public function checkOrders():void {
        updateMaxCounts();
        if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction <= TutorialAction.ORDER) return;
        if (_arrOrders.length < _curMaxCountOrders) {
            addNewOrders(_curMaxCountOrders - _arrOrders.length);
            checkForNewCats();
        }
    }

    public function checkOrderForTutorial(onArriveCallback:Function = null):void {
        if (g.managerTutorial.currentAction == TutorialAction.ORDER) {
            _arrOrders.length = 0;
            updateMaxCounts();
            if (_arrOrders.length < _curMaxCountOrders) {
                addNewTutorialOrder();
                checkForNewCats(onArriveCallback);
            }
        }
        checkOrders();
    }

    private function checkForNewCats(onArriveCallback:Function = null):void {
        for (var i:int=0; i<_arrOrders.length; i++) {
            if (!_arrOrders[i].cat) {
                _arrOrders[i].cat = g.managerOrderCats.getNewCatForOrder(onArriveCallback,_arrOrders[i].catOb);
            }
        }
    }

    public function get countOrders():int {
        return _arrOrders.length;
    }

    public function get maxCountOrders():int {
        return _curMaxCountOrders;
    }

    public function addFromServer(ob:Object):void {
        if (_arrOrders.length >= _curMaxCountOrders) return;
        var order:ManagerOrderItem = new ManagerOrderItem();
        order.dbId = ob.id;
        order.resourceIds = ob.ids.split('&');
        order.resourceCounts = ob.counts.split('&');
//        order.catName = g.dataOrderCats.arrCats[int(Math.random()*g.dataOrderCats.arrCats.length)].name;
        order.catOb = g.dataOrderCats.arrCats[int(Math.random()*g.dataOrderCats.arrCats.length)];
        order.coins = int(ob.coins);
        order.xp = int(ob.xp);
        order.addCoupone = ob.add_coupone == '1';
        order.startTime = int(ob.start_time) || 0;
        order.placeNumber = int(ob.place);
        order.fasterBuy = Boolean(ob.faster_buyer);
        if (order.startTime - int(new Date().getTime()/1000) > 0 ) order.delOb = true;
        Utils.intArray(order.resourceCounts);
        Utils.intArray(order.resourceIds);
        _arrOrders.push(order);
        _arrOrders.sortOn('placeNumber', Array.NUMERIC);
    }

    public function updateMaxCounts():void {
        _curMaxCountOrders = 1;
        _curMaxCountResoureAtOrder = 1;
        for (var i:int=0; i<_countCellOnLevel.length; i++) {
            if (_countCellOnLevel[i].level <= g.user.level) {
                _curMaxCountOrders = _countCellOnLevel[i].count;
            } else {
                break;
            }
        }
        for (i=0; i<_countResourceOnLevelAtCell.length; i++) {
            if (_countResourceOnLevelAtCell[i].level <= g.user.level) {
                _curMaxCountResoureAtOrder = _countResourceOnLevelAtCell[i].count;
            } else {
                break;
            }
        }
    }

    public function getMaxCountForLevel(l:int):int {
        var c:int = 1;
        for (var i:int=0; i<_countCellOnLevel.length; i++) {
            if (_countCellOnLevel[i].level <= l) {
                c = _countCellOnLevel[i].count;
            } else {
                break;
            }
        }
        return c;
    }

    //types for order:
    // 1 - usual resource fromFabrica
    // 2 - resources made from resources from cave
    // 3 - resource plants
    private function addNewOrders(n:int, delay:int = 0, f:Function = null, place:int = -1,del:Boolean = false):void {
        var order:ManagerOrderItem;
        var arrOrderType1:Array = new Array(); //products
        var arrOrderType2:Array = new Array(); //cave res
        var arrOrderType3:Array = new Array(); // plants
        var arrTemp:Array = new Array();
        var arr:Array = new Array();
        var countResources:int;
        var k:int;
        var i:int=0;
        var id:String;
        var level:int = g.user.level;
        var countFastBuyer:int = 0;
        for (i = 0; i < n; i++) {
            if (_arrOrders && !g.managerTutorial.isTutorial && level < 10 && _arrOrders.length > 0) {
                order = new ManagerOrderItem();
                order.resourceIds = [];
                order.resourceCounts = [];
                order.addCoupone = false;
                for (i = 0; i < _arrOrders.length; i++) {
                    if (_arrOrders[i].fasterBuy == true) {
                        countFastBuyer++;
                    }
                }
            } else countFastBuyer = 1;
                if (countFastBuyer == 0) {
                    arrTemp = g.userInventory.getResourcesForAmbarAndSklad();
                    if (arrTemp.length >= 1) {
                        for (i = 0; i < arrTemp.length; i++) {
                            if (g.dataResource.objectResources[arrTemp[i].id].orderType != 0) {
                                arr.push(arrTemp[i]);
                            }
                        }
                        if (arr.length >= 1) {
                            if (arr.length == 1) {
                                order.resourceIds.push(arr[0].id);
                                order.resourceCounts.push(int(arr[0].count / 2 + 1));
                            } else {
                                arr.sortOn('count', Array.DESCENDING | Array.NUMERIC);
                                if (Math.random() < .5) {
                                    k = Math.random();
                                    if (k < .5) {
                                        order.resourceIds.push(arr[0].id);
                                        order.resourceCounts.push(int(arr[0].count / 2 + 1));
                                    } else if (k < .7) {
                                        order.resourceIds.push(arr[0].id);
                                        order.resourceCounts.push(int(arr[0].count - 1 ));
                                        if ( order.resourceCounts[0] <= 0) {
                                            order.resourceCounts[0] = 1
                                        }
                                    } else {
                                        order.resourceIds.push(arr[0].id);
                                        order.resourceCounts.push(int(arr[0].count) + 3);
                                    }
                                } else {
                                    order.resourceIds.push(arr[1].id);
                                    order.resourceCounts.push(int(arr[1].count / 2 + 1));
                                }
                            }
                        } else {
                            for (id in g.dataResource.objectResources) if (g.dataResource.objectResources[id].blockByLevel <= level) if (g.dataResource.objectResources[id].orderType == 1) arrOrderType1.push(int(id));
                            order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                            order.resourceCounts.push(int(Math.random() * 10) + 1);
                        }
                    } else {
                        for (id in g.dataResource.objectResources) if (g.dataResource.objectResources[id].blockByLevel <= level) if (g.dataResource.objectResources[id].orderType == 1) arrOrderType1.push(int(id));
                        order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                        order.resourceCounts.push(int(Math.random() * 10) + 1);
                    }
                    order.fasterBuy = true;

            } else {
                for (id in g.dataResource.objectResources) {
                    if (g.dataResource.objectResources[id].blockByLevel <= g.user.level) {
                        if (g.dataResource.objectResources[id].orderType == 1) {
                            arrOrderType1.push(int(id));
                        } else if (g.dataResource.objectResources[id].orderType == 2) {
                            arrOrderType2.push(int(id));
                        } else if (g.dataResource.objectResources[id].orderType == 3) {
                            arrOrderType3.push(int(id));
                        }
                    }
                }


                order = new ManagerOrderItem();
                order.resourceIds = [];
                order.resourceCounts = [];
                if (Math.random() < .2 && arrOrderType2.length) {
                    order.addCoupone = true;
                    countResources = int(Math.random() * 3) + 1;
                    if (countResources > arrOrderType2.length) countResources = arrOrderType2.length;
                    switch (countResources) {
                        case 1:
                            order.resourceIds.push(arrOrderType2[int(Math.random() * arrOrderType2.length)]);
                            order.resourceCounts.push(int(Math.random() * 2) + 5);
                            break;
                        case 2:
                            arr = arrOrderType2.slice();
                            k = int(Math.random() * arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k, 1);
                            order.resourceCounts.push(int(Math.random() * 2) + 2);
                            k = int(Math.random() * arr.length);
                            order.resourceIds.push(arr[k]);
                            order.resourceCounts.push(int(Math.random() * 2) + 2);
                            break;
                        case 3:
                            arr = arrOrderType2.slice();
                            k = int(Math.random() * arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k, 1);
                            order.resourceCounts.push(2);
                            k = int(Math.random() * arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k, 1);
                            order.resourceCounts.push(2);
                            k = int(Math.random() * arr.length);
                            order.resourceIds.push(arr[k]);
                            order.resourceCounts.push(2);
                            break;
                    }
                } else {
                    order.addCoupone = false;
                    countResources = int(Math.random() * _curMaxCountResoureAtOrder) + 1;
                    switch (countResources) {
                        case 1:
                            if (level <= 4) {
                                if (Math.random() < .6) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else {
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 4) + 4);
                                }
                            } else if (level == 5) {
                                if (Math.random() < .6) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else {
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 6) + 4);
                                }
                            } else if (level == 6) {
                                if (Math.random() < .6) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else {
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 5) + 6);
                                }
                            } else if (level == 7) {
                                if (Math.random() < .6) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else {
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 7) + 6);
                                }
                            } else if (level == 8) {
                                if (Math.random() < .6) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 3) + 2);
                                } else {
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 12) + 6);
                                }
                            } else if (level == 9) {
                                if (Math.random() < .6) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 3) + 2);
                                } else {
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 13) + 7);
                                }
                            } else if (level == 10) {
                                if (Math.random() < .6) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 4) + 2);
                                } else {
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 13) + 7);
                                }
                            } else if (level == 11) {
                                if (Math.random() < .6) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 4) + 2);
                                } else {
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 14) + 7);
                                }
                            } else {
                                if (Math.random() < .6) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 4) + 2);
                                } else {
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 18) + 7);
                                }
                            }
                            break;
                        case 2:
                            k = Math.random();
                            if (level <= 4) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 3) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 3) + 2);
                                }
                            } else if (level <= 5) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 3);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 5) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 5) + 2);
                                }
                            } else if (level <= 6) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 7) + 3);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 5) + 3);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 5) + 3);
                                }
                            } else if (level <= 7) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 7) + 3);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 6) + 4);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 6) + 4);
                                }
                            } else if (level <= 8) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 7) + 3);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 5) + 6);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 5) + 6);
                                }
                            } else if (level <= 9) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 7) + 3);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 5) + 6);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 5) + 6);
                                }
                            } else if (level <= 10) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else if (Math.random() < .3) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 7) + 6);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 9) + 7);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 9) + 7);
                                }
                            } else if (level <= 11) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else if (Math.random() < .3) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 12) + 7);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 12) + 7);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 12) + 7);
                                }
                            } else {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else if (Math.random() < .3) {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 12) + 7);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 12) + 7);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 12) + 7);
                                }
                            }
                            break;
                        case 3:
                            k = Math.random();
                            if (level == 6) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 5) + 3);
                                } else {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 5) + 3);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 5) + 3);
                                }
                            } else if (level == 7) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 5) + 3);
                                } else {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 5) + 3);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 5) + 3);
                                }
                            } else if (level == 8) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else if (Math.random() < .3) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 6) + 3);
                                } else {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 6) + 3);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 6) + 3);
                                }
                            } else if (level == 9) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else if (Math.random() < .3) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 6) + 3);
                                } else {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 6) + 3);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 6) + 3);
                                }
                            } else if (level == 10) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else if (Math.random() < .3) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 8) + 4);
                                } else {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 8) + 4);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 8) + 4);
                                }
                            } else {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else if (Math.random() < .3) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 8) + 5);
                                } else {
                                    order.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 8) + 5);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 8) + 5);
                                }
                            }
                            break;
                        case 4:
                            k = Math.random();
                            if (level == 8) {
                                if (k < .7) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 5) + 3);
                                }
                            } else if (level == 9) {
                                if (k < .7) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 5) + 3);
                                }
                            } else {
                                if (k < .7) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    order.resourceIds.push(arr[k]);
                                    order.resourceCounts.push(int(Math.random() * 2) + 1);
                                    order.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    order.resourceCounts.push(int(Math.random() * 5) + 3);
                                }
                            }
                            break;
                        case 5:
                            arr = arrOrderType1.slice();
                            k = int(Math.random() * arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k, 1);
                            order.resourceCounts.push(1);
                            k = int(Math.random() * arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k, 1);
                            order.resourceCounts.push(1);
                            k = int(Math.random() * arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k, 1);
                            order.resourceCounts.push(1);
                            k = int(Math.random() * arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k, 1);
                            order.resourceCounts.push(1);
                            k = int(Math.random() * arr.length);
                            order.resourceIds.push(arr[k]);
                            order.resourceCounts.push(1);
                            break;
                    }
                }
            }

//             order.catName = g.dataOrderCats.arrCats[int(Math.random()*g.dataOrderCats.arrCats.length)].name;
            order.catOb = g.dataOrderCats.arrCats[int(Math.random() * g.dataOrderCats.arrCats.length)];
            order.coins = 0;
            order.xp = 0;
            for (k = 0; k < order.resourceIds.length; k++) {
                order.coins += g.dataResource.objectResources[order.resourceIds[k]].orderPrice * order.resourceCounts[k];
                order.xp += g.dataResource.objectResources[order.resourceIds[k]].orderXP * order.resourceCounts[k];
            }
            order.startTime = int(new Date().getTime() / 1000);
            if (place == -1) {
                order.placeNumber = getFreePlace();
            } else {
                order.placeNumber = place;
            }
            order.delOb = del;
            _arrOrders.push(order);
            _arrOrders.sortOn('placeNumber', Array.NUMERIC);
            g.directServer.addUserOrder(order, delay, f);
        }
    }

    private function addNewTutorialOrder():void {
        var order:ManagerOrderItem = new ManagerOrderItem();
        order.resourceIds = [26];
        order.resourceCounts = [2];
        order.addCoupone = false;
//         order.catName = g.dataOrderCats.arrCats[int(Math.random()*g.dataOrderCats.arrCats.length)].name;
        order.catOb = g.dataOrderCats.arrCats[int(Math.random()*g.dataOrderCats.arrCats.length)];
        order.coins = g.dataResource.objectResources[order.resourceIds[0]].orderPrice * order.resourceCounts[0];
        order.xp = g.dataResource.objectResources[order.resourceIds[0]].orderXP * order.resourceCounts[0];
        order.startTime = int(new Date().getTime()/1000);
        order.placeNumber = 1;
        _arrOrders.push(order);
        g.directServer.addUserOrder(order, 0, null);
    }

    private function getFreePlace():int {
        var k:int;
        var find:Boolean;
        for (var i:int=0; i < _curMaxCountOrders; i++) {
            find = true;
            for (k=0; k<_arrOrders.length; k++) {
                if (_arrOrders[k].placeNumber == i) {
                    find = false;
                    break;
                }
            }
            if (find) return i;
        }
        return -1;
    }

    public function deleteOrder(order:ManagerOrderItem, f:Function):void {
        for (var i:int=0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].dbId == order.dbId) {
                g.managerOrderCats.onReleaseOrder(_arrOrders[i].cat, false);
                _arrOrders[i].cat = null;
                _arrOrders.splice(i, 1);
                break;
            }
        }
        if (i == _arrOrders.length) Cc.error('ManagerOrder deleteOrder:: no order');
        var pl:int = order.placeNumber;
        g.directServer.deleteUserOrder(order.dbId, null);

        if (g.user.level <= 6) addNewOrders(1, TIME_FIRST_DELAY, f, order.placeNumber,true);
        else if (g.user.level <= 9) addNewOrders(1, TIME_SECOND_DELAY, f, order.placeNumber,true);
        else if (g.user.level <= 15) addNewOrders(1, TIME_THIRD_DELAY, f, order.placeNumber,true);
        else if (g.user.level <= 19) addNewOrders(1, TIME_FOURTH_DELAY, f, order.placeNumber,true);
        else if (g.user.level >= 20) addNewOrders(1, TIME_FIFTH_DELAY, f, order.placeNumber,true);
    }

    public function sellOrder(order:ManagerOrderItem, f:Function):void {
        for (var i:int=0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].dbId == order.dbId) {
                g.managerOrderCats.onReleaseOrder(_arrOrders[i].cat, true);
                _arrOrders[i].cat = null;
                _arrOrders.splice(i, 1);
                break;
            }
        }
        g.directServer.deleteUserOrder(order.dbId,null);
        var pl:int = order.placeNumber;
        order = null;
        addNewOrders(1, 0, f, pl);
        for (i = 0; i < _arrOrders.length; i++) {
            if (!_arrOrders[i].cat) {
                _arrOrders[i].cat = g.managerOrderCats.getNewCatForOrder(null,_arrOrders[i].catOb);
                break;
            }
        }
    }

    public function checkIsAnyFullOrder():Boolean {  // check if there any order that already can be fulled
        var b:Boolean = false;
        var k:int;
        var order:ManagerOrderItem;

        if (!_arrOrders.length) return false;
        for (var i:int=0; i<_arrOrders.length; i++) {
           order = _arrOrders[i];
            if (!order || !order.resourceIds || !order.resourceIds.length) continue;
            b = true;
        if (order.cat != null && order.startTime - int(new Date().getTime() / 1000) <= 0) {
            for (k = 0; k < order.resourceIds.length; k++) {
                if (g.userInventory.getCountResourceById(order.resourceIds[k]) < order.resourceCounts[k]) {
                    b = false;
                    break;
                }
            }
        } else b = false;
            if (b) return true;
        }

        return false;

//        if (!_arrOrders.length) return false;
//        for (var i:int=0; i<_arrOrders.length; i++) {
//            order = _arrOrders[i];
//            if (!order || !order.resourceIds || !order.resourceIds.length) continue;
//            if (order.cat != null && order.startTime - int(new Date().getTime() / 1000) <= 0) {
//                for (k = 0; k < order.resourceIds.length; k++) {
//                    if (g.userInventory.getCountResourceById(order.resourceIds[k]) < order.resourceCounts[k]) {
//                        b = true;
////                        break;
//                    }
//                }
//            }
//            if (b)return true;
//        }
//        return false;
    }
    
    public function checkForFullOrder():void {
        if (checkIsAnyFullOrder()) {
            g.bottomPanel.onFullOrder(true);
            _orderBuilding.animateSmallHero(true);
        } else {
            g.bottomPanel.onFullOrder(false);
            _orderBuilding.animateSmallHero(false);
        }
    }

    public function cancelAnimateSmallHero():void {
        g.bottomPanel.onFullOrder(false);
        _orderBuilding.animateSmallHero(false);
    }

    public function onSkipTimer(order:ManagerOrderItem):void {
        g.directServer.skipOrderTimer(order.dbId, null);
        var pl:int = order.placeNumber;
        var orderDbId:String = order.dbId;
        for (var i:int = 0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].placeNumber == pl) {
                _arrOrders[i].cat = g.managerOrderCats.getNewCatForOrder(null,_arrOrders[i].catOb);
                break;
            }
        }
        for (i = 0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].dbId == orderDbId) {
//                if (g.user.level <= 6) _arrOrders[i].startTime -= 2* TIME_FIRST_DELAY;
//                else if (g.user.level <= 9) _arrOrders[i].startTime -= 2*  TIME_SECOND_DELAY;
//                else if (g.user.level <= 15) _arrOrders[i].startTime -= 2* TIME_THIRD_DELAY;
//                else if (g.user.level <= 19) _arrOrders[i].startTime -= 2* TIME_FOURTH_DELAY;
//                else if (g.user.level >= 20) _arrOrders[i].startTime -= 2* TIME_FIFTH_DELAY;
                break;
            }
        }
        if (i == _arrOrders.length) Cc.error('ManagerOrder onSkipTimer:: no order');
    }
}
}