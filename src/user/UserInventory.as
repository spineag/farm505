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
        var arr:Array;
//        var res:Object = g.dataResource.objectResources;

        arr = [];
        for (var i:int = 0; i < g.allData.resource.length; i++) {
            if (g.allData.resource[i] && g.allData.resource[i].placeBuild == BuildType.PLACE_AMBAR && g.allData.resource[i].blockByLevel <= g.user.level && _inventoryResource[i]>0) {
                obj = {};
                obj.id = i;
                obj.count = _inventoryResource[i];
                arr.push(obj);
            }
        }
//        for (var id:String in _inventoryResource) {
//            if (res[id] && res[id].placeBuild == BuildType.PLACE_AMBAR && res[id].blockByLevel <= g.user.level && _inventoryResource[id]>0) {
//                obj = {};
//                obj.id = id;
//                obj.count = _inventoryResource[id];
//                arr.push(obj);
//            }
//        }
        return arr;
    }

    public function getResourcesForSklad():Array {
        var obj:Object;
        var arr:Array;
//        var res:Object = g.dataResource.objectResources;

        arr = [];
        for (var i:int = 0; i < g.allData.resource.length; i++) {
            if (g.allData.resource[i] && g.allData.resource[i].placeBuild == BuildType.PLACE_SKLAD  && g.allData.resource[i].blockByLevel <= g.user.level && _inventoryResource[i]>0) {
                obj = {};
                obj.id = int(i);
                obj.count = _inventoryResource[i];
                arr.push(obj);
            }

        }
//        for (var id:String in _inventoryResource) {
//
//        }
        return arr;
    }

    public function getResourcesForAmbarAndSklad():Array {
        var obj:Object;
        var arr:Array;
//        var res:Object = g.dataResource.objectResources;

        arr = [];
        for (var i:int = 0; i < g.allData.resource.length; i++) {
            if (g.allData.resource[i] && (g.allData.resource[i].placeBuild == BuildType.PLACE_SKLAD || g.allData.resource[i].placeBuild == BuildType.PLACE_AMBAR) && g.allData.resource[i].blockByLevel <= g.user.level && _inventoryResource[i]>0) {
                obj = {};
                obj.id = int(i);
                obj.count = _inventoryResource[i];
                arr.push(obj);
            }
        }

//        for (var id:String in _inventoryResource) {
//            if ((res[id].placeBuild == BuildType.PLACE_SKLAD || res[id].placeBuild == BuildType.PLACE_AMBAR) && res[id].blockByLevel <= g.user.level && _inventoryResource[id]>0) {
//                obj = {};
//                obj.id = int(id);
//                obj.count = _inventoryResource[id];
//                arr.push(obj);
//            }
//        }
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
//         = g.dataResource.objectResources;
//        for (var id:String in res) {
//            if (res[id].buildType == BuildType.PLANT && res[id].blockByLevel == g.user.level) {
//                addResource(int(id), 3);
//            }
//        }
        for (var i:int = 0; i < g.allData.resource.length; i++) {
            if (g.allData.resource[i] && g.allData.resource[i].buildType == BuildType.PLANT && g.allData.resource[i].blockByLevel == g.user.level) {
                addResource(i, 3);
            }

//            var buil2d:Object = g.dataBuilding.objectBuilding;
            var res:Object = g.dataAnimal.objectAnimal;
            for (i = 0; i < g.allData.building.length; i++) {
                if (g.allData.building[i] && g.allData.building[i].buildType == BuildType.FARM) {
                    for (var k:int = 0; k < g.allData.building[i].blockByLevel.length; k++) {
                        if (g.allData.building[i].blockByLevel[k] == g.user.level) {
                            for (var idA:String in res) {
                                if (g.allData.building[i].id == res[idA].buildId) {
                                    addResource(res[idA].idResourceRaw, 3);  // add feed for animals
                                    return;
                                }
                            }
                        }
                    }
                }
            }
//            for (var id:String in build) {
//                if (build[id].buildType == BuildType.FARM) {
//                    for (i = 0; i < build[id].blockByLevel.length; i++) {
//                        if (build[id].blockByLevel[i] == g.user.level) {
//                            for (var idA:String in res) {
//                                if (build[id].id == res[idA].buildId) {
//                                    addResource(res[idA].idResourceRaw, 3);  // add feed for animals
//                                    return;
//                                }
//                            }
//                        }
//                    }
//                }
//            }

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
