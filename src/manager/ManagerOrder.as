/**
 * Created by andy on 11/14/15.
 */
package manager {
import com.junkbyte.console.Cc;

public class ManagerOrder {
    public static const TIME_DELAY:int = 15 * 60;
    public static const COST_SKIP_WAIT:int = 8;

    private var _countCellOnLevel:Array;
    private var _countResourceOnLevelAtCell:Array;
    private var _arrOrders:Array;
    private var _curMaxCountOrders:int;
    private var _curMaxCountResoureAtOrder:int;
    private var _arrNames:Array;

    private var g:Vars = Vars.getInstance();

    public function ManagerOrder() {
        _countCellOnLevel = [
            {level: 1, count: 0},
            {level: 2, count: 1},
            {level: 5, count: 2},
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
            {level: 4, count: 3},
            {level: 8, count: 4},
            {level: 15, count: 5}
        ];
        _arrOrders = [];
        _arrNames = ['Жозефина', 'Катаракта', 'Мария', 'Педретто', 'Хуан Пискуан', 'Доздроперма', 'Всеволод', 'Мздюк', 'Варан'];
    }

    public function get arrOrders():Array {
        return _arrOrders;
    }

    public function checkOrders():void {
        updateMaxCounts();
        if (_arrOrders.length < _curMaxCountOrders) {
            addNewOrders(_curMaxCountOrders - _arrOrders.length);
        }
    }

    public function get maxCountOrders():int {
        return _curMaxCountOrders;
    }

    public function addFromServer(ob:Object):void {
        if (_arrOrders.length >= _curMaxCountOrders) return;
        var order:Object = {};
        order.dbId = ob.id;
        order.resourceIds = ob.ids.split('&');
        order.resourceCounts = ob.counts.split('&');
        order.catName = _arrNames[int(Math.random()*_arrNames.length)];
        order.coins = int(ob.coins);
        order.xp = int(ob.xp);
        order.addCoupone = ob.add_coupone == '1';
        order.startTime = int(ob.start_time) || 0;
        order.placeNumber = int(ob.place);
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

    //types for order:
    // 1 - usual resource fromFabrica
    // 2 - resources made from resources from cave
    // 3 - resource plants
    private function addNewOrders(n:int, delay:int = 0, f:Function = null, place:int = -1):void {
        var order:Object;
        var arrOrderType1:Array = new Array();
        var arrOrderType2:Array = new Array();
        var arrOrderType3:Array = new Array();
        var arr:Array;
        var countResources:int;
        var k:int;

        for(var id:String in g.dataResource.objectResources) {
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
        for (var i:int=0; i<n; i++) {
            order = {};
            order.resourceIds = [];
            order.resourceCounts = [];
            if (Math.random() < .2 && arrOrderType2.length) {
                order.addCoupone = true;
                countResources = int(Math.random()*3) + 1;
                if (countResources > arrOrderType2.length) countResources = arrOrderType2.length;
                switch (countResources) {
                    case 1:
                        order.resourceIds.push( arrOrderType2[int(Math.random()*arrOrderType2.length)] );
                        order.resourceCounts.push( int(Math.random()*2)+5 );
                        break;
                    case 2:
                        arr = arrOrderType2.slice();
                        k = int(Math.random()*arr.length);
                        order.resourceIds.push(arr[k]);
                        arr.splice(k,1);
                        order.resourceCounts.push(int(Math.random()*2) + 2);
                        k = int(Math.random()*arr.length);
                        order.resourceIds.push(arr[k]);
                        order.resourceCounts.push(int(Math.random()*2) + 2);
                        break;
                    case 3:
                        arr = arrOrderType2.slice();
                        k = int(Math.random()*arr.length);
                        order.resourceIds.push(arr[k]);
                        arr.splice(k,1);
                        order.resourceCounts.push(2);
                        k = int(Math.random()*arr.length);
                        order.resourceIds.push(arr[k]);
                        arr.splice(k,1);
                        order.resourceCounts.push(2);
                        k = int(Math.random()*arr.length);
                        order.resourceIds.push(arr[k]);
                        order.resourceCounts.push(2);
                        break;
                }
            } else {
                order.addCoupone = false;
                countResources = int(Math.random()*_curMaxCountResoureAtOrder) + 1;
                switch (countResources) {
                    case 1:
                        if (Math.random() < .6) {
                            order.resourceIds.push( arrOrderType1[int(Math.random()*arrOrderType1.length)] );
                            order.resourceCounts.push( int(Math.random()*3)+2 );
                        } else {
                            order.resourceIds.push( arrOrderType3[int(Math.random()*arrOrderType3.length)] );
                            order.resourceCounts.push( int(Math.random()*18)+7 );
                        }
                        break;
                    case 2:
                        k = Math.random();
                        if (k > .5) {
                            arr = arrOrderType1.slice();
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k,1);
                            order.resourceCounts.push(int(Math.random()*2) + 2);
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            order.resourceCounts.push(int(Math.random()*2) + 2);
                        } else if (Math.random() < .3) {
                            order.resourceIds.push( arrOrderType1[int(Math.random()*arrOrderType1.length)] );
                            order.resourceCounts.push( int(Math.random()*3)+2 );
                            order.resourceIds.push( arrOrderType3[int(Math.random()*arrOrderType3.length)] );
                            order.resourceCounts.push( int(Math.random()*14)+7 );
                        } else {
                            arr = arrOrderType3.slice();
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k,1);
                            order.resourceCounts.push(int(Math.random()*16) + 7);
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            order.resourceCounts.push(int(Math.random()*16) + 7);
                        }
                        break;
                    case 3:
                        k = Math.random();
                        if (k > .5) {
                            arr = arrOrderType1.slice();
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k,1);
                            order.resourceCounts.push(int(Math.random()*2) + 2);
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k,1);
                            order.resourceCounts.push(int(Math.random()*2) + 2);
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            order.resourceCounts.push(int(Math.random()*2) + 2);
                        } else if (Math.random() < .3) {
                            arr = arrOrderType1.slice();
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k,1);
                            order.resourceCounts.push(int(Math.random()*2) + 2);
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            order.resourceCounts.push(int(Math.random()*2) + 2);
                            order.resourceIds.push( arrOrderType3[int(Math.random()*arrOrderType3.length)] );
                            order.resourceCounts.push( int(Math.random()*8)+5 );
                        } else {
                            order.resourceIds.push( arrOrderType1[int(Math.random()*arrOrderType1.length)] );
                            order.resourceCounts.push( int(Math.random()*2)+2 );
                            arr = arrOrderType3.slice();
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k,1);
                            order.resourceCounts.push(int(Math.random()*8) + 5);
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            order.resourceCounts.push(int(Math.random()*8) + 5);
                        }
                        break;
                    case 4:
                        k = Math.random();
                        if (k < .7) {
                            arr = arrOrderType1.slice();
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k,1);
                            order.resourceCounts.push(int(Math.random()*2) + 2);
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k,1);
                            order.resourceCounts.push(int(Math.random()*2) + 2);
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k,1);
                            order.resourceCounts.push(int(Math.random()*2) + 2);
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            order.resourceCounts.push(int(Math.random()*2) + 2);
                        } else {
                            arr = arrOrderType1.slice();
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k,1);
                            order.resourceCounts.push(int(Math.random()*2) + 1);
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            arr.splice(k,1);
                            order.resourceCounts.push(int(Math.random()*2) + 1);
                            k = int(Math.random()*arr.length);
                            order.resourceIds.push(arr[k]);
                            order.resourceCounts.push(int(Math.random()*2) + 1);
                            order.resourceIds.push( arrOrderType3[int(Math.random()*arrOrderType3.length)] );
                            order.resourceCounts.push( int(Math.random()*5)+3 );
                        }
                        break;
                    case 5:
                        arr = arrOrderType1.slice();
                        k = int(Math.random()*arr.length);
                        order.resourceIds.push(arr[k]);
                        arr.splice(k,1);
                        order.resourceCounts.push(1);
                        k = int(Math.random()*arr.length);
                        order.resourceIds.push(arr[k]);
                        arr.splice(k,1);
                        order.resourceCounts.push(1);
                        k = int(Math.random()*arr.length);
                        order.resourceIds.push(arr[k]);
                        arr.splice(k,1);
                        order.resourceCounts.push(1);
                        k = int(Math.random()*arr.length);
                        order.resourceIds.push(arr[k]);
                        arr.splice(k,1);
                        order.resourceCounts.push(1);
                        k = int(Math.random()*arr.length);
                        order.resourceIds.push(arr[k]);
                        order.resourceCounts.push(1);
                        break;
                }
            }
            order.catName = _arrNames[int(Math.random()*_arrNames.length)];
            order.coins = 0;
            order.xp = 0;
            for (k=0; k<order.resourceIds.length; k++) {
                order.coins += g.dataResource.objectResources[order.resourceIds[k]].orderPrice * order.resourceCounts[k];
                order.xp += g.dataResource.objectResources[order.resourceIds[k]].orderXP * order.resourceCounts[k];
            }
            order.startTime = int(new Date().getTime()/1000);
            if (place == -1) {
                order.placeNumber = getFreePlace();
            } else {
                order.placeNumber = place;
            }
            _arrOrders.push(order);
            _arrOrders.sortOn('placeNumber', Array.NUMERIC);
            g.directServer.addUserOrder(order, delay, f);
        }
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

    public function deleteOrder(order:Object, f:Function):void {
        for (var i:int=0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].dbId == order.dbId) {
                _arrOrders.splice(i, 1);
                break;
            }
        }
        if (i == _arrOrders.length) Cc.error('ManagerOrder deleteOrder:: no order');
        g.directServer.deleteUserOrder(order.dbId, null);
        addNewOrders(1, TIME_DELAY, f, order.placeNumber);
    }

    public function sellOrder(order:Object, f:Function):void {
        for (var i:int=0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].dbId == order.dbId) {
                g.managerOrderCats.onReleaseOrder(_arrOrders[i].cat);
                _arrOrders[i].cat = null;
                _arrOrders.splice(i, 1);
                break;
            }
        }
        if (i == _arrOrders.length) Cc.error('ManagerOrder cellOrder:: no order');
        g.directServer.deleteUserOrder(order.dbId, null);
        var pl:int = order.placeNumber;
        order = null;
        addNewOrders(1, 0, f, pl);
        for (i=0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].placeNumber == pl) {
                _arrOrders[i].cat = g.managerOrderCats.getNewCatForOrder();
                break;
            }
        }
    }

    public function chekIsAnyFullOrder():Boolean {  // check if there any order that already can be fulled
        var b:Boolean;
        var k:int;
        var order:Object;

        if (!_arrOrders.length) return false;
        for (var i:int=0; i<_arrOrders.length; i++) {
            order = _arrOrders[i];
            if (!order || !order.resourceIds || !order.resourceIds.length) continue;
            b = true;
            for (k=0; k<order.resourceIds.length; k++) {
                if (g.userInventory.getCountResourceById(order.resourceIds[k]) < order.resourceCounts[k]) {
                    b = false;
                    break;
                }
            }
            if (b) return true;
        }

        return false;
    }

    public function onSkipTimer(orderDbId:int):void {
        g.directServer.skipOrderTimer(orderDbId, null);
        for (var i:int=0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].dbId == orderDbId) {
                _arrOrders[i].startTime -= 2*ManagerOrder.TIME_DELAY;
                break;
            }
        }
        if (i == _arrOrders.length) Cc.error('ManagerOrder onSkipTimer:: no order');
    }
}
}
