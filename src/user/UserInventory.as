/**
 * Created by user on 6/12/15.
 */
package user {
import com.junkbyte.console.Cc;

import data.BuildType;
import data.DataMoney;
import data.OwnEvent;
import data.StructureDataAnimal;
import data.StructureDataResource;

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

    public function getResourceforTypetoOrder(type:int):Array {
        var arr:Array = [];
        var ob:Object;
        for(var id:String in _inventoryResource) {
            if (g.allData.getResourceById(int(id)).buildType == type && int(id) != 21 && int(id) != 25 && int(id) != 27 && int(id) != 29 && _inventoryResource[id] > 0) {
                ob = {};
                ob.id = id;
                ob.count = _inventoryResource[id];
                arr.push(ob);
            }
        }
        if (arr.length > 0) return arr;
        else return null;
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
        if (!g.userValidates.checkInfo('ambarMax', g.user.ambarMaxCount)) return;
        if (!g.userValidates.checkInfo('skladMax', g.user.skladMaxCount)) return;
        if (!_inventoryResource[id]) _inventoryResource[id] = 0;
        if (!g.userValidates.checkResources(id, _inventoryResource[id])) return;
        _inventoryResource[id] += count;
        if (_inventoryResource[id] < 0) {
            _inventoryResource[id] = 0;
            Cc.error('UserInventory addResource:: count resource < 0 for resource id: ' + id + ' after addResource count: ' + count);
        }
        g.userValidates.updateResources(id, _inventoryResource[id]);
        g.updateAmbarIndicator();
        if (g.managerPendingRequest && g.managerPendingRequest.isActive) {
            g.managerPendingRequest.updateResource(id);
        } else {
            g.directServer.addUserResource(id, _inventoryResource[id], f);
        }
        g.managerOrder.checkForFullOrder();
        if (g.managerTips) g.managerTips.calculateAvailableTips();
    }

    public function addResourceFromServer(id:int, count:int):void {
        if (_inventoryResource[id]) {
            Cc.error('UserInventory addResourceFromServer:: duplicate for resourceId: ' + id);
        }
        _inventoryResource[id] = count;
        g.userValidates.updateResources(id, count);
    }

    public function getResourcesForAmbar():Array {
        var obj:Object;
        var arr:Array = [];
        var r:StructureDataResource;
        var arR:Array = g.allData.resource;
        for (var i:int = 0; i < arR.length; i++) {
            r = arR[i];
            if (r.placeBuild == BuildType.PLACE_AMBAR && r.blockByLevel <= g.user.level && _inventoryResource[r.id]>0) {
                obj = {};
                obj.id = r.id;
                obj.count = _inventoryResource[r.id];
                arr.push(obj);
            }
        }
        return arr;
    }

    public function getResourcesForSklad():Array {
        var obj:Object;
        var arr:Array = [];
        var r:StructureDataResource;
        var arR:Array = g.allData.resource;
        for (var i:int = 0; i < arR.length; i++) {
            r = arR[i];
            if (r.placeBuild == BuildType.PLACE_SKLAD  && r.blockByLevel <= g.user.level && _inventoryResource[r.id]>0) {
                obj = {};
                obj.id = r.id;
                obj.count = _inventoryResource[r.id];
                arr.push(obj);
            }

        }
        return arr;
    }

    public function getResourcesForAmbarAndSklad():Array {
        var obj:Object;
        var arr:Array = [];
        var r:StructureDataResource;
        var arR:Array = g.allData.resource;
        for (var i:int = 0; i < arR.length; i++) {
            r = arR[i];
            if ((r.placeBuild == BuildType.PLACE_SKLAD || r.placeBuild == BuildType.PLACE_AMBAR) && r.blockByLevel <= g.user.level && _inventoryResource[r.id]>0) {
                obj = {};
                obj.id = r.id;
                obj.count = _inventoryResource[r.id];
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
        var newCount:int = 0;
        switch (typeCurrency) {
            case DataMoney.HARD_CURRENCY:
                if (!g.userValidates.checkInfo('hardCount', g.user.hardCurrency)) return;
                g.soundManager.playSound(SoundConst.COINS_PLUS);
                g.user.hardCurrency += count;
                g.userValidates.updateInfo('hardCount', g.user.hardCurrency);
                g.softHardCurrency.checkHard();
                newCount = g.user.hardCurrency;
                break;
            case DataMoney.SOFT_CURRENCY:
                if (!g.userValidates.checkInfo('softCount', g.user.softCurrencyCount)) return;
                g.soundManager.playSound(SoundConst.COINS_PLUS);
                g.user.softCurrencyCount += count;
                g.userValidates.updateInfo('softCount', g.user.softCurrencyCount);
                g.softHardCurrency.checkSoft();
                newCount = g.user.softCurrencyCount;
                break;
            case DataMoney.BLUE_COUPONE:
                if (!g.userValidates.checkInfo('blueCount', g.user.blueCouponCount)) return;
                g.user.blueCouponCount += count;
                g.userValidates.updateInfo('blueCount', g.user.blueCouponCount);
                newCount = g.user.blueCouponCount;
                break;
            case DataMoney.YELLOW_COUPONE:
                if (!g.userValidates.checkInfo('yellowCount', g.user.yellowCouponCount)) return;
                g.user.yellowCouponCount += count;
                g.userValidates.updateInfo('yellowCount', g.user.yellowCouponCount);
                newCount = g.user.yellowCouponCount;
                break;
            case DataMoney.RED_COUPONE:
                if (!g.userValidates.checkInfo('redCount', g.user.redCouponCount)) return;
                g.user.redCouponCount += count;
                g.userValidates.updateInfo('redCount', g.user.redCouponCount);
                newCount = g.user.redCouponCount;
                break;
            case DataMoney.GREEN_COUPONE:
                if (!g.userValidates.checkInfo('greenCount', g.user.greenCouponCount)) return;
                g.user.greenCouponCount += count;
                g.userValidates.updateInfo('greenCount', g.user.greenCouponCount);
                newCount = g.user.greenCouponCount;
                break;
        }

        if (needSendToServer)
            g.directServer.addUserMoney(typeCurrency, newCount, null);
    }

    public function dropItemMoney(typeCurrency:int, count:int):void {
        if (count == 0) return;
        var newCount:int = 0;
        switch (typeCurrency) {
            case DataMoney.HARD_CURRENCY:
                g.user.hardCurrency += count;
                g.userValidates.updateInfo('hardCount', g.user.hardCurrency);
                newCount = g.user.hardCurrency;
                break;
            case DataMoney.SOFT_CURRENCY:
                g.user.softCurrencyCount += count;
                g.userValidates.updateInfo('softCount', g.user.softCurrencyCount);
                newCount = g.user.softCurrencyCount;
                break;
            case DataMoney.BLUE_COUPONE:
                g.user.blueCouponCount += count;
                g.userValidates.updateInfo('blueCount', g.user.blueCouponCount);
                newCount = g.user.blueCouponCount;
                break;
            case DataMoney.YELLOW_COUPONE:
                g.user.yellowCouponCount += count;
                g.userValidates.updateInfo('yellowCount', g.user.yellowCouponCount);
                newCount = g.user.yellowCouponCount;
                break;
            case DataMoney.RED_COUPONE:
                g.user.redCouponCount += count;
                g.userValidates.updateInfo('redCount', g.user.redCouponCount);
                newCount = g.user.redCouponCount ;
                break;
            case DataMoney.GREEN_COUPONE:
                g.user.greenCouponCount += count;
                g.userValidates.updateInfo('greenCount', g.user.greenCouponCount);
                newCount = g.user.greenCouponCount;
                break;
        }
        g.directServer.addUserMoney(typeCurrency, newCount, null);
    }

    public function updateMoneyTxt(typeCurrency:int):void {
        switch (typeCurrency) {
            case DataMoney.HARD_CURRENCY:
                g.soundManager.playSound(SoundConst.COINS_PLUS);
                g.softHardCurrency.checkHard();
                break;
            case DataMoney.SOFT_CURRENCY:
                g.soundManager.playSound(SoundConst.COINS_PLUS);
                g.softHardCurrency.checkSoft();
                break;
            case DataMoney.BLUE_COUPONE:
                if (!g.userValidates.checkInfo('blueCount', g.user.blueCouponCount)) return;
                g.userValidates.updateInfo('blueCount', g.user.blueCouponCount);
                break;
            case DataMoney.YELLOW_COUPONE:
                if (!g.userValidates.checkInfo('yellowCount', g.user.yellowCouponCount)) return;
                g.userValidates.updateInfo('yellowCount', g.user.yellowCouponCount);
                break;
            case DataMoney.RED_COUPONE:
                if (!g.userValidates.checkInfo('redCount', g.user.redCouponCount)) return;
                g.userValidates.updateInfo('redCount', g.user.redCouponCount);
                break;
            case DataMoney.GREEN_COUPONE:
                if (!g.userValidates.checkInfo('greenCount', g.user.greenCouponCount)) return;
                g.userValidates.updateInfo('greenCount', g.user.greenCouponCount);
                break;
        }
    }

    public function addNewElementsAfterGettingNewLevel():void {
        var arR:Array = g.allData.resource;
        for (var i:int = 0; i < arR.length; i++) {
            if (arR[i].buildType == BuildType.PLANT && arR[i].blockByLevel == g.user.level) {
                addResource(arR[i].id, 3);
            }
        }

        var k:int;
        arR = g.allData.building;
        var animal:StructureDataAnimal;
        for (i = 0; i < arR.length; i++) {
            if (arR[i].buildType == BuildType.FARM) {
                for (k = 0; k < arR[i].blockByLevel.length; k++) {
                    if (arR[i].blockByLevel[k] == g.user.level) {
                        animal = g.allData.getAnimalByFarmId(arR[i].id);
                        if (animal) {
                            addResource(animal.idResourceRaw, 3);  // add feed for animals
                        }
                        break;
                    }
                }
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
