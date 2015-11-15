/**
 * Created by andy on 11/14/15.
 */
package manager {
public class ManagerOrder {
    private var _countCellOnLevel:Array;
    private var _countResourceOnLevelAtCell:Array;
    private var _arrOrders:Array;
    private var _curMaxCountOrders:int;
    private var _curMaxCountResoureAtOrder:int;

    private var g:Vars = Vars.getInstance();

    public function ManagerOrder() {
        _countCellOnLevel = [
            {level: 1, count: 1},
            {level: 4, count: 2},
            {level: 6, count: 3},
            {level: 8, count: 4},
            {level: 10, count: 5},
            {level: 12, count: 6},
            {level: 14, count: 7},
            {level: 16, count: 8},
            {level: 18, count: 9}];
        _countResourceOnLevelAtCell = [
            {level: 1, count: 1},
            {level: 2, count: 2},
            {level: 4, count: 3},
            {level: 8, count: 4},
            {level: 15, count: 5}
        ];
        _arrOrders = [];
    }

    public function checkOrders():void {
        updateMaxCounts();
        if (_arrOrders.length < _curMaxCountOrders) {
            addNewOrders(_curMaxCountOrders - _arrOrders.length);
        }
    }

    private function updateMaxCounts():void {
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

    private function addNewOrders(n:int):void {
        var order:Object;
        var arrOrderType1:Array = new Array();
        var arrOrderType2:Array = new Array();
        var arrOrderType3:Array = new Array();
        var arr:Array;
        var countResources:int;

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
                        order.resourceId.push( arr.splice() );
                }
            } else {
                order.addCoupone = false;
            }
        }


    }
}
}
