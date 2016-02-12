/**
 * Created by andy on 8/6/15.
 */
package manager {
import build.ridge.Ridge;
import com.junkbyte.console.Cc;
import flash.geom.Point;
import heroes.HeroCat;
import mouse.ToolsModifier;

public class ManagerPlantRidge {
    private var _arrRidge:Array; // список всех грядок юзера
    private var _catsForPlant:Object; // _catsForPlant['id plant'] = { cat: HeroCat, ridges: array(ridge1, ridge2..) };

    private var g:Vars = Vars.getInstance();

    public function ManagerPlantRidge() {
        var arr:Array = g.townArea.cityObjects;
        _arrRidge = [];
        _catsForPlant = {};
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i] is Ridge) {
                _arrRidge.push(arr[i]);
            }
        }
    }

    public function addRidge(r:Ridge):void {
        _arrRidge.push(r);
    }

    public function addPlant(ob:Object):void {
        var curRidge:Ridge;
        var i:int;
        for (i=0; i<_arrRidge.length; i++) {
            if (_arrRidge[i].dbBuildingId == int(ob.user_db_building_id)) {
                curRidge = _arrRidge[i];
                break;
            }
        }
        if (!curRidge) {
            Cc.error('no such Ridge with dbId: ' + ob.user_db_building_id);
            return;
        }
        curRidge.fillPlant(g.dataResource.objectResources[int(ob.plant_id)], true, int(ob.time_work));
        curRidge.plant.idFromServer = ob.id;
    }

    public function onCraft(plantIdFromServer:String):void {
        g.directServer.craftPlantRidge(plantIdFromServer, null);
    }

    public function checkIsCat(plantId:int):Boolean {
        if (_catsForPlant[plantId]) return true;
        if (g.managerCats.countFreeCats > 0) return true;
        return false;
    }

    public function addCatForPlant(plantId:int, ridge:Ridge):void {
        if (_catsForPlant[plantId]) {
            _catsForPlant[plantId].ridges.push(ridge);
        } else {
            var cat:HeroCat = g.managerCats.getFreeCat();
            if (cat) {
                cat.curActiveRidge = ridge;
                cat.isFree = false;
                if (cat.isOnMap) {
                    g.managerCats.goCatToPoint(cat, new Point(ridge.posX, ridge.posY), onArrivedCatToRidge, cat, plantId);
                } else {
                    cat.setPosition(new Point(ridge.posX,ridge.posY));
                    cat.addToMap();
                    onArrivedCatToRidge(cat, plantId);
                }
                _catsForPlant[plantId] = {cat: cat, ridges:[ridge]};
            } else {
                Cc.error('ManagerPlantRidge addCatForPlant:: cat = null');
                g.woGameError.showIt();
            }
        }
    }

    public function removeCatFromRidge(plantId:int, ridge:Ridge):void {
        if (_catsForPlant[plantId]) {
            if (_catsForPlant[plantId].ridges.length) {
                if (_catsForPlant[plantId].ridges.indexOf(ridge) > -1) {
                    _catsForPlant[plantId].ridges.splice(_catsForPlant[plantId].ridges.indexOf(ridge), 1);
                    if (!_catsForPlant[plantId].ridges.length) {
                        removeCatFromPlant(plantId, _catsForPlant[plantId].cat as HeroCat);
                    }
                } else {
                    Cc.error('ManagerPlantRidge removeCatFromRidge:: _catsForPlant[plantId].ridges.indexOf(ridge) = -1 for plantId: ' + plantId);
                }
            } else {
                Cc.error('ManagerPlantRidge removeCatFromRidge:: _catsForPlant[plantId].ridges.length = 0 for plantId: ' + plantId);
            }
        } else {
            Cc.error('ManagerPlantRidge removeCatFromRidge:: _catsForPlant[plantId] = null for plantId: ' + plantId);
        }
    }

    private function removeCatFromPlant(plantId:int, cat:HeroCat):void {
        cat.curActiveRidge = null;
        if (cat.visible) {
            cat.killAllAnimations();
        } else {
            cat.forceStopWork();
        }
        cat.isFree = true;
        cat.additionalRemoveWorker();
        delete _catsForPlant[plantId];
    }

    private function onArrivedCatToRidge(cat:HeroCat, plantId:int):void {
        var p:Point = new Point();
        cat.isLeftForFeedAndWatering = Math.random() > .5;
        if (cat.isLeftForFeedAndWatering) {
            p.x = cat.curActiveRidge.posX;
            p.y = cat.curActiveRidge.posY + 1;
        } else {
            p.x = cat.curActiveRidge.posX + 1;
            p.y = cat.curActiveRidge.posY;
        }
        g.managerCats.goCatToPoint(cat, p, onArrivedCatToRidgePoint, cat, plantId);
    }

    private function onArrivedCatToRidgePoint(cat:HeroCat, plantId:int):void {
        var onFinishWork:Function = function():void {
            if (_catsForPlant[plantId] && _catsForPlant[plantId].ridges && _catsForPlant[plantId].ridges.length) {
                var p:Point = new Point();
                if (_catsForPlant[plantId].ridges.length == 1) {
                    cat.isLeftForFeedAndWatering = !cat.isLeftForFeedAndWatering;
                } else {
                    var randomRidge:Ridge = _catsForPlant[plantId].ridges[int(_catsForPlant[plantId].ridges.length * Math.random())];
                    if (randomRidge == cat.curActiveRidge) {
                        cat.isLeftForFeedAndWatering = !cat.isLeftForFeedAndWatering;
                    } else {
                        cat.curActiveRidge = randomRidge;
                        cat.isLeftForFeedAndWatering = Math.random() > .5;
                    }
                }
                if (cat.isLeftForFeedAndWatering) {
                    p.x = cat.curActiveRidge.posX;
                    p.y = cat.curActiveRidge.posY + 1;
                } else {
                    p.x = cat.curActiveRidge.posX + 1;
                    p.y = cat.curActiveRidge.posY;
                }
                g.managerCats.goCatToPoint(cat, p, onArrivedCatToRidgePoint, cat, plantId);
            } else {
                removeCatFromPlant(plantId, cat);
            }
        };
        if (_catsForPlant[plantId] && _catsForPlant[plantId].ridges && _catsForPlant[plantId].ridges.length) {
            g.townArea.zSort();
            cat.workWithPlant(onFinishWork);
        } else {
            removeCatFromPlant(plantId, cat);
        }
    }

    public function lockAllFillRidge(value:Boolean):void {
        for (var i:int=0; i<_arrRidge.length; i++) {
            (_arrRidge[i] as Ridge).lockIt(value);
        }
    }

    public function checkFreeRidges():void {
        var b:Boolean = false;
        var i:int;
        for (i=0; i<_arrRidge.length; i++) {  // check if there are at least one HUNGRY ridge
            if (_arrRidge[i].stateRidge == Ridge.EMPTY) {
                b = true;
                break;
            }
        }
            g.bottomPanel.cancelBoolean(true);
        if (b) {
            if (g.userInventory.getCountResourceById(g.toolsModifier.plantId) <= 0) b = false;  // cehak if there are at least one current resource for plant
        }

        if (!b) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            g.bottomPanel.cancelBoolean(false);
        }
    }

}
}
