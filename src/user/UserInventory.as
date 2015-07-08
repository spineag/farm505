/**
 * Created by user on 6/12/15.
 */
package user {
import data.BuildType;

import manager.Vars;

public class UserInventory {
    private var _inventoryResource:Object;

    private var g:Vars = Vars.getInstance();

    public function UserInventory() {
        _inventoryResource = new Object();
    }

    public function getCountResourceById(id:int):int {
        if (_inventoryResource[id])  return _inventoryResource[id];
         else return 0;
    }

    public function addResource(id:int, count:int):void {
        if (!_inventoryResource[id]) _inventoryResource[id] = 0;
        _inventoryResource[id] += count;
        if (_inventoryResource[id] == 0) delete(_inventoryResource[id]);
    }

    public function getResourcesForAmbar():Array {
        var obj:Object;
        var arr:Array;
        var res:Object = g.dataResource.objectResources;

        arr = [];
        for (var id:String in _inventoryResource) {
            if (res[id].placeBuild == BuildType.PLACE_AMBAR) {
                obj = {};
                obj.id = id;
                obj.count = _inventoryResource[id];
                arr.push(obj);
            }
        }
        return arr;
    }

    public function getResourcesForSklad():Array {
        var obj:Object;
        var arr:Array;
        var res:Object = g.dataResource.objectResources;

        arr = [];
        for (var id:String in _inventoryResource) {
            if (res[id].placeBuild == BuildType.PLACE_SKLAD) {
                obj = {};
                obj.id = id;
                obj.count = _inventoryResource[id];
                arr.push(obj);
            }
        }
        return arr;
    }

    public function addMoney(_data:Object, money:int):void {
        if (_data.currency == data.BuildType.SOFT_CURRENCY) {
            g.user.softCurrencyCount += money;
            g.softHardCurrency.checkSoft();
        }
        if (_data.currency == data.BuildType.HARD_CURRENCY) {
            g.user.hardCurrency += money;
            g.softHardCurrency.checkHard();
        }

    }

}
}
