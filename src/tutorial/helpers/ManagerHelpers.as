/**
 * Created by andy on 6/28/16.
 */
package tutorial.helpers {
import build.fabrica.Fabrica;
import build.farm.Animal;
import build.farm.Farm;
import build.ridge.Ridge;
import data.BuildType;
import manager.Vars;

public class ManagerHelpers {
    private const MAX_SECONDS:int = 7;
    private var _countSeconds:int;
    private var _isActiveHelper:Boolean;
    private var _isCheckingForHelper:Boolean;
    private var _helper:GameHelper;
    private var _curReason:Object;
    private var _helperReason:HelperReason;
    private var g:Vars = Vars.getInstance();

    public function ManagerHelpers() {
        _isCheckingForHelper = false;
        _isActiveHelper = false;
        _helperReason = new HelperReason();
        checkIt();
    }

    public function checkIt():void {
        if (_isActiveHelper) {

        } else if (g.user.level >= 4 && g.user.level < 9) {
            startIt();
        }
    }

    public function disableIt():void {
        g.gameDispatcher.removeFromTimer(onTimer);
        _isActiveHelper = false;
        _isCheckingForHelper = false;
    }

    private function startIt():void {
        if (!_isCheckingForHelper && !_isActiveHelper) {
            _isCheckingForHelper = true;
            _countSeconds = 0;
            g.gameDispatcher.addToTimer(onTimer);
        }
    }

    private function onTimer():void {
        _countSeconds++;
        if (_countSeconds >= MAX_SECONDS) {
            lookForHelperReason();
            _countSeconds = 0;
            if (_isActiveHelper) {
                g.gameDispatcher.removeFromTimer(onTimer);
            }
        }
    }

    private function lookForHelperReason():void {
        var arr:Array =  _helperReason.reasons;
        var wasFinded:Boolean;

        for (var i:int = 0; i < arr.length; i++) {
            _curReason = arr[i];
            wasFinded = checkPosibleReason();
            if (wasFinded) break;
        }

        if (wasFinded) {
            _isActiveHelper = true;
            releaseReason();
        }
    }

    private function checkPosibleReason():Boolean {
        var wasFindedReason:Boolean;
        switch (_curReason.reason) {
            case HelperReason.REASON_ORDER: wasFindedReason = checkForOrder(); break;
            case HelperReason.REASON_FEED_ANIMAL: wasFindedReason = checkForFeedAnimal(); break;
            case HelperReason.REASON_CRAFT_PLANT: wasFindedReason = checkForCraftPlant(); break;
            case HelperReason.REASON_RAW_PLANT: wasFindedReason = checkForRawPlant(); break;
            case HelperReason.REASON_RAW_FABRICA: wasFindedReason = checkFabricaForRaw(); break;
            case HelperReason.REASON_BUY_FABRICA: wasFindedReason = checkForBuyFabrica(); break;
            case HelperReason.REASON_BUY_FARM: wasFindedReason = checkForBuyFarm(); break;
            case HelperReason.REASON_BUY_HERO: wasFindedReason = checkForBuyHero(); break;
            case HelperReason.REASON_BUY_ANIMAL: wasFindedReason = checkForBuyAnimal(); break;
            case HelperReason.REASON_BUY_RIDGE: wasFindedReason = checkForBuyRidge(); break;
        }
        trace('wasFindedReason:: ' + wasFindedReason);
        return wasFindedReason;
    }

    private function checkForOrder():Boolean {
        var isOrder:Boolean = g.managerOrder.chekIsAnyFullOrder();
        if (isOrder) {
            _curReason.build = g.townArea.getCityObjectsByType(BuildType.ORDER)[0];
        }
        return isOrder;
    }

    private function checkForFeedAnimal():Boolean {
        if (g.managerCats.countFreeCats <= 0) return false;
        var an:Animal;
        var animals:Array = g.managerAnimal.getAllAnimals();
        for (var i:int=0; i<animals.length; i++) {
            an = animals[i] as Animal;
            if (an.state == Animal.HUNGRY &&
                    (an.animalData.buildType == BuildType.PLANT && g.userInventory.getCountResourceById(an.animalData.idResourceRaw) >= 2 ||
                    an.animalData.buildType != BuildType.PLANT && g.userInventory.getCountResourceById(an.animalData.idResourceRaw) > 0)) {
                _curReason.animal = an;
                _curReason.build = an.farm;
                return true;
            }
        }
        return false;
    }

    private function checkForCraftPlant():Boolean {
        if (g.userInventory.currentCountInAmbar + 2 < g.user.ambarMaxCount) {
            var arr:Array = g.managerPlantRidge.getRidgesForCraft();
            if (arr.length) {
                _curReason.build = arr[0];
                return true;
            } else return false;
        } else return false;
    }

    private function checkForRawPlant():Boolean {
        if (g.managerCats.countFreeCats <= 0) return false;
        if (g.userInventory.currentCountInAmbar > 0) {
            var arr:Array = g.managerPlantRidge.getEmptyRidges();
            if (arr.length) {
                _curReason.build = arr[0];
                return true;
            } else return false;
        } else return false;
    }

    private function checkFabricaForRaw():Boolean {
        if (g.managerCats.countFreeCats <= 0) return false;
        var f:Fabrica = g.managerFabricaRecipe.getFabricaWithPossibleRecipe();
        if (f) {
            _curReason.build = f;
            return true;
        } else return false;
    }

    private function checkForBuyFabrica():Boolean {
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.FABRICA);
        var ids:Array = [];
        for (var i:int=0; i<arr.length; i++) {
            ids.push((arr[i] as Fabrica).dataBuild.id);
        }
        var obj:Object = g.dataBuilding.objectBuilding;
        arr = [];
        for (var st:String in obj) {
            if (obj[st].buildType == BuildType.FABRICA && obj[st].blockByLevel[0] <= g.user.level && ids.indexOf(obj[st].id) == -1 && obj[st].cost[0] <= g.user.softCurrencyCount) {
                arr.push(obj[st]);
                break;
            }
        }
        if (arr.length) {
            _curReason.id = arr[0].id;
            _curReason.type = BuildType.FABRICA;
            return true;
        } else return false;
    }

    private function checkForBuyFarm():Boolean {
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.FARM);
        var ids:Array = [];
        for (var i:int=0; i<arr.length; i++) {
            ids.push((arr[i] as Farm).dataBuild.id);
        }
        var obj:Object = g.dataBuilding.objectBuilding;
        arr = [];
        for (var st:String in obj) {
            if (obj[st].buildType == BuildType.FARM && obj[st].blockByLevel[0] <= g.user.level && ids.indexOf(obj[st].id) == -1  && obj[st].cost[0] <= g.user.softCurrencyCount) {
                arr.push(obj[st]);
                break;
            }
        }
        if (arr.length) {
            _curReason.id = arr[0].id;
            _curReason.type = BuildType.FARM;
            return true;
        } else return false;
    }

    private function checkForBuyHero():Boolean {
        if (g.managerCats.curCountCats < g.managerCats.maxCountCats && g.dataCats[g.managerCats.curCountCats].cost <= g.user.softCurrencyCount) {
            return true;
        } else return false;
    }

    private function checkForBuyAnimal():Boolean {
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.FARM);
        for (var i:int=0; i<arr.length; i++) {
            if (!(arr[i] as Farm).isFull && g.dataAnimal[(arr[i] as Farm).dataAnimal.id].cost <= g.user.softCurrencyCount) {
                _curReason.id = (arr[i] as Farm).dataAnimal.id;
                _curReason.type = BuildType.ANIMAL;
                return true;
            }
        }
        return false;
    }

    private function checkForBuyRidge():Boolean {
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        var maxCountAtCurrentLevel:int = 0;
        var _data:Object = (arr[0] as Ridge).dataBuild;
        if (_data.cost > g.user.softCurrencyCount) return false;

        for (var i:int = 0; _data.blockByLevel.length; i++) {
            if (_data.blockByLevel[i] <= g.user.level) {
                maxCountAtCurrentLevel++;
            } else break;
        }
        if (maxCountAtCurrentLevel * _data.countUnblock <= arr.length) {
            return false;
        } else {
            _curReason.id = _data.id;
            _curReason.type = BuildType.RIDGE;
            return true;
        }
    }

    private function releaseReason():void {
        _helper = new GameHelper();
        _helper.showIt(onEnd, _curReason);
    }

    private function onEnd():void {

    }
}
}
