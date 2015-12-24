/**
 * Created by user on 6/12/15.
 */
package user {
import com.junkbyte.console.Cc;

import data.BuildType;
import data.DataMoney;

import manager.Vars;

public class UserInventory {
    private var _inventoryResource:Object;
    private var _decorInventory:Object;

    private var g:Vars = Vars.getInstance();

    public function UserInventory() {
        _inventoryResource = new Object();
        _decorInventory = new Object();
    }

    public function get decorInventory():Object {
        return _decorInventory;
    }

    public function addToDecorInventory(id:int, dbId:int):void {
        if (_decorInventory[id]) {
            _decorInventory[id].count++;
            _decorInventory[id].ids.push(dbId);
        } else {
            _decorInventory[id] = {count: 1, ids:[dbId]};
        }
    }

    public function removeFromDecorInventory(id:int):int {
        var dbId:int = 0;
        if (_decorInventory[id]) {
            _decorInventory[id].count--;
            dbId = _decorInventory[id].ids.shift();
            if (_decorInventory[id].count <= 0) delete _decorInventory[id];
        }
        return dbId;
    }

    public function getCountResourceById(id:int):int {
        if (_inventoryResource[id])  return _inventoryResource[id];
         else return 0;
    }

    public function addResource(id:int, count:int, needSendToServer:Boolean = true):void {
        if (count == 0) return;
        if (!_inventoryResource[id]) _inventoryResource[id] = 0;
        _inventoryResource[id] += count;
        if (_inventoryResource[id] == 0) delete(_inventoryResource[id]);
        if (needSendToServer) {
            g.updateAmbarIndicator();
            g.directServer.addUserResource(id, count, null);
        }
    }

    public function getResourcesForAmbar():Array {
        var obj:Object;
        var arr:Array;
        var res:Object = g.dataResource.objectResources;

        arr = [];
        for (var id:String in _inventoryResource) {
            if (res[id].placeBuild == BuildType.PLACE_AMBAR && res[id].blockByLevel <= g.user.level) {
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
            if (res[id].placeBuild == BuildType.PLACE_SKLAD  && res[id].blockByLevel <= g.user.level) {
                obj = {};
                obj.id = id;
                obj.count = _inventoryResource[id];
                arr.push(obj);
            }
        }
        return arr;
    }

    public function get currentCountInAmbar():int {
        var count:int = 0;
        var arr:Array = getResourcesForAmbar();
        for (var i:int = 0; i < arr.length; i++) {
            count += arr[i].count;
        }
        return count;
    }

    public function get currentCountInSklad():int {
        var count:int = 0;
        var arr:Array = getResourcesForSklad();
        for (var i:int = 0; i < arr.length; i++) {
            count += arr[i].count;
        }
        return count;
    }

    public function addMoney(typeCurrency:int, count:int):void {
        switch (typeCurrency) {
            case DataMoney.HARD_CURRENCY:
                g.user.hardCurrency += count;
                g.softHardCurrency.checkHard();
                break;
            case DataMoney.SOFT_CURRENCY:
                g.user.softCurrencyCount += count;
                g.softHardCurrency.checkSoft();
                break;
            case DataMoney.BLUE_COUPONE:
                g.user.blueCouponCount += count;
                break;
            case DataMoney.YELLOW_COUPONE:
                g.user.yellowCouponCount += count;
                break;
            case DataMoney.RED_COUPONE:
                g.user.redCouponCount += count;
                break;
            case DataMoney.GREEN_COUPONE:
                g.user.greenCouponCount += count;
                break;
        }

        if (count)
            g.directServer.addUserMoney(typeCurrency, count, onAddUserMoney);
    }

    private function onAddUserMoney(b:Boolean = true):void { }

}
}
