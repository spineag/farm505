/**
 * Created by user on 6/12/15.
 */
package user {
import com.junkbyte.console.Cc;

import data.BuildType;
import data.DataMoney;
import data.OwnEvent;
import manager.Vars;

import media.SoundConst;

import starling.events.Event;

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

    public function getDecorInventory(id:int):Boolean {
        if (_decorInventory[id]) {
            return true;
        } return false;
    }

    public function addToDecorInventory(id:int, dbId:int):void {
        if (_decorInventory[id]) {
            _decorInventory[id].count++;
            _decorInventory[id].ids.push(dbId);
        } else {
            _decorInventory[id] = {count: 1, ids:[dbId]};
        }
        g.event.dispatchEvent(new Event(OwnEvent.UPDATE_REPOSITORY));
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
        if (_inventoryResource[id])  {
            return _inventoryResource[id];
        } else return 0;
    }

    public function addResource(id:int, count:int, f:Function = null):void {
        if (count == 0) {
            Cc.error('UserInventory addResource:: try to add count=0 for resource id: ' + id);
            return;
        }
        if (!_inventoryResource[id]) _inventoryResource[id] = 0;
        _inventoryResource[id] += count;
        if (_inventoryResource[id] < 0) {
            _inventoryResource[id] = 0;
            Cc.error('UserInventory addResource:: count resource < 0 for resource id: ' + id + ' after addResource count: ' + count);
        }
        g.updateAmbarIndicator();
        g.directServer.addUserResource(id, _inventoryResource[id], f);
        g.managerOrder.checkForFullOrder();
        if (g.managerTips) g.managerTips.calculateAvailableTips();
    }

    public function addResourceFromServer(id:int, count:int):void {
        if (_inventoryResource[id]) {
            Cc.error('UserInventory addResourceFromServer:: duplicate for resourceId: ' + id);
        }
        _inventoryResource[id] = count;
    }

    public function getResourcesForAmbar():Array {
        var obj:Object;
        var arr:Array;
        var res:Object = g.dataResource.objectResources;

        arr = [];
        for (var id:String in _inventoryResource) {
            if (res[id] && res[id].placeBuild == BuildType.PLACE_AMBAR && res[id].blockByLevel <= g.user.level && _inventoryResource[id]>0) {
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
            if (res[id].placeBuild == BuildType.PLACE_SKLAD  && res[id].blockByLevel <= g.user.level && _inventoryResource[id]>0) {
                obj = {};
                obj.id = int(id);
                obj.count = _inventoryResource[id];
                arr.push(obj);
            }
        }
        return arr;
    }

    public function getResourcesForAmbarAndSklad():Array {
        var obj:Object;
        var arr:Array;
        var res:Object = g.dataResource.objectResources;

        arr = [];
        for (var id:String in _inventoryResource) {
            if ((res[id].placeBuild == BuildType.PLACE_SKLAD || res[id].placeBuild == BuildType.PLACE_AMBAR) && res[id].blockByLevel <= g.user.level && _inventoryResource[id]>0) {
                obj = {};
                obj.id = int(id);
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

    public function addMoney(typeCurrency:int, count:int, needSendToServer:Boolean = true):void {
        if (count == 0) return;
        switch (typeCurrency) {
            case DataMoney.HARD_CURRENCY:
                g.soundManager.playSound(SoundConst.COINS_PLUS);
                g.user.hardCurrency += count;
                g.softHardCurrency.checkHard();
                break;
            case DataMoney.SOFT_CURRENCY:
                g.soundManager.playSound(SoundConst.COINS_PLUS);
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

        if (needSendToServer)
            g.directServer.addUserMoney(typeCurrency, count, null);
    }

    public function addNewElementsAfterGettingNewLevel():void {
        var res:Object = g.dataResource.objectResources;
        for (var id:String in res) {
            if (res[id].buildType == BuildType.PLANT && res[id].blockByLevel == g.user.level) {
                addResource(int(id), 3);
            }
        }
        res = g.dataAnimal.objectAnimal;
        for (id in res) {
            if (res[id].idResourceRaw == res.id){
                g.userInventory.addResource(res.id,3);  // add feed for animals
                break;
            }
        }
    }

    public function checkLastResource(id:int):Boolean {
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        for (var i:int = 0; i < arr.length; i++) {
           if (arr[i].plant && arr[i].plant.dataPlant.id == id){
               return true;
           }
        }
        return false;
    }
}
}
