/**
 * Created by user on 6/12/15.
 */
package user {
import data.BuildType;
import data.DataMoney;

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

    public function addResource(id:int, count:int, needSendToServer:Boolean = true):void {
        if (count == 0) return;
        if (!_inventoryResource[id]) _inventoryResource[id] = 0;
        _inventoryResource[id] += count;
        if (_inventoryResource[id] == 0) delete(_inventoryResource[id]);
        if (needSendToServer) {
            g.directServer.addUserResource(id, count, null);
        }
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

    public function checkMoney(_data:Object):Boolean {
        var count:int;
        var bol:Boolean = true;
        if (_data.currency == DataMoney.SOFT_CURRENCY) {
            if (g.user.softCurrencyCount < _data.cost) {
                count = _data.cost - g.user.softCurrencyCount;
                bol = false;
            }
        }
        if (_data.currency == DataMoney.HARD_CURRENCY) {
            if (g.user.hardCurrency < _data.cost) {
                count = _data.cost - g.user.hardCurrency;
                bol = false;
            }
        }
//        if(yellowCouponCount < ) {
//            bol = false
//        }
//        if(redCouponCount < ) {
//            bol = false
//        }
//        if(blueCouponCount < ) {
//            bol = false
//        }
//        if(greenCouponCount < ) {
//            bol = false
//        }
        if (!bol) g.woNoResources. showItMoney(_data, count);
        return bol;
    }

    public function checkRecipe(_data:Object):Boolean {
        var count:int = 0;
        for (var i:int = 0; i < _data.ingridientsId.length; i++) {
            count =  g.userInventory.getCountResourceById(int(_data.ingridientsId[i]));
            if (count < int(_data.ingridientsCount[i])) {
                g.woNoResources.showItMenu(_data, int(_data.ingridientsCount[i]) - count);
                return false;
            }
        }
        return true;
    }

    public function checkResource(_data:Object, countResource:int):Boolean {
        var count:int;
        if(_data.buildType == BuildType.ANIMAL){
            count = g.userInventory.getCountResourceById(_data.idResourceRaw);
            if (count < countResource) {
                g.woNoResources.showItMenu(_data, countResource - count);
                return false;
            }
        }
        count = g.userInventory.getCountResourceById(_data.id);
        if (count < countResource) {
            g.woNoResources.showItMenu(_data, countResource - count);
            return false;
        }
        return true;
    }

//    public function checkZakaz():Boolean {
//
//    }

}
}
