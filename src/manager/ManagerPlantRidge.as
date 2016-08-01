/**
 * Created by andy on 8/6/15.
 */
package manager {
import build.ridge.Ridge;
import com.junkbyte.console.Cc;
import flash.geom.Point;
import heroes.HeroCat;

import media.SoundConst;

import mouse.ToolsModifier;

import windows.WindowsManager;

public class ManagerPlantRidge {
    private var _arrRidge:Array; // список всех грядок юзера
    private var _catsForPlant:Object; // _catsForPlant['id plant'] = { cat: HeroCat, ridges: array(ridge1, ridge2..) };
    private var _movingRidgePlantId:int;
    private var _tempPoint:Point;

    private var g:Vars = Vars.getInstance();

    public function ManagerPlantRidge() {
        var arr:Array = g.townArea.cityObjects;
        _movingRidgePlantId = -1;
        _arrRidge = [];
        _catsForPlant = {};
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i] is Ridge) {
                _arrRidge.push(arr[i]);
            }
        }
        _tempPoint = new Point();
    }

    public function onAddNewRidge(r:Ridge):void {
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
        if (curRidge.plant) {
            curRidge.plant.idFromServer = ob.id;
        } else {
            Cc.error('ManagerPlantRidge:: plant = null');
        }
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
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerPlantRidge');
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
                        delete _catsForPlant[plantId];
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
        }
        cat.isFree = true;
        cat.additionalRemoveWorker();
        delete _catsForPlant[plantId];
    }

    public function onGoAwayCats(v:Boolean):void {
        var c:HeroCat;
        var s:String;
        for (s in _catsForPlant) {
            c = _catsForPlant[s].cat;
            if (v) {
                if (c.curActiveRidge) {
                    c.setPosition(new Point(c.curActiveRidge.posX, c.curActiveRidge.posY));
                    c.updatePosition();
                }
                c.killAllAnimations();
            } else {
                onArrivedCatToRidge(c, int(s));
            }
        }
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
            takePlantForWork(plantId, cat);
        };
        if (_catsForPlant[plantId] && _catsForPlant[plantId].ridges && _catsForPlant[plantId].ridges.length) {
            g.townArea.zSort();
            cat.workWithPlant(onFinishWork);
        } else {
            removeCatFromPlant(plantId, cat);
        }
    }

    private function takePlantForWork(plantId:int, cat:HeroCat):void {
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
            if (_movingRidgePlantId == -1) {
                removeCatFromPlant(plantId, cat);
            } else {
                (_catsForPlant[plantId].cat as HeroCat).showSimpleIdle();
            }
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
            if (g.userInventory.getCountResourceById(g.toolsModifier.plantId) <= 0) b = false;  // check if there are at least one current resource for plant
        }

        if (!b) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            g.bottomPanel.cancelBoolean(false);
        }
    }

    public function onRidgeStartMove(plantId:int, r:Ridge):void {
        if (_catsForPlant[plantId] && _catsForPlant[plantId].ridges && _catsForPlant[plantId].ridges.indexOf(r) > -1) {
            var f:Function = function ():void {
                takePlantForWork(plantId, _catsForPlant[plantId].cat as HeroCat);
            };

            _movingRidgePlantId = plantId;
            _catsForPlant[plantId].ridges.splice(_catsForPlant[plantId].ridges.indexOf(r), 1);
            if ((_catsForPlant[plantId].cat as HeroCat).curActiveRidge == r) {
                (_catsForPlant[plantId].cat as HeroCat).showFailCat(f);
                g.soundManager.playSound(SoundConst.FARM_HERO_AWAY);
            }
        }
    }


    public function onRidgeFinishMove(plantId:int, r:Ridge):void {
        if (_catsForPlant[plantId]) {
            _movingRidgePlantId = -1;
            _catsForPlant[plantId].ridges.push(r);
            if (_catsForPlant[plantId].ridges.length == 1) {
                takePlantForWork(plantId, _catsForPlant[plantId].cat as HeroCat);
            }
        }
    }

    public function onStartActivePlanting(isStart:Boolean):void {
        if (g.managerTutorial.isTutorial) return;
        if (isStart) {
            g.gameDispatcher.addEnterFrame(checkForPlanting);
        } else {
            g.gameDispatcher.removeEnterFrame(checkForPlanting);
        }
        g.cont.deleteDragPoint();
        g.townArea.onStartPlanting(isStart);
    }

    private function checkForPlanting():void {
        if (g.managerTutorial.isTutorial) return;
        _tempPoint.x = g.ownMouse.mouseX;
        _tempPoint.y = g.ownMouse.mouseY;
        _tempPoint = g.cont.contentCont.globalToLocal(_tempPoint);
        for (var i:int=0; i<_arrRidge.length; i++) {
            if ((_arrRidge[i] as Ridge).isFreeRidge) {
                if (isMouseUnderRidge(_tempPoint, _arrRidge[i] as Ridge)) {
                    (_arrRidge[i] as Ridge).plantThePlant();
                    break;
                }
            }
        }
    }

    public function onStartCraftPlanting(isStart:Boolean):void {
        if (g.managerTutorial.isTutorial) return;
        g.cont.contentCont.releaseContDrag = !isStart;
        g.cont.tailCont.releaseContDrag = !isStart;
        g.cont.deleteDragPoint();
        if (isStart) {
            g.gameDispatcher.addEnterFrame(checkForCrafting);
        } else {
            g.gameDispatcher.removeEnterFrame(checkForCrafting);
        }
    }

    private function checkForCrafting():void {
        _tempPoint.x = g.ownMouse.mouseX;
        _tempPoint.y = g.ownMouse.mouseY;
        _tempPoint = g.cont.contentCont.globalToLocal(_tempPoint);
        for (var i:int=0; i<_arrRidge.length; i++) {
            if ((_arrRidge[i] as Ridge).stateRidge == Ridge.GROWED) {
                if (isMouseUnderRidge(_tempPoint, _arrRidge[i] as Ridge)) {
                    (_arrRidge[i] as Ridge).craftThePlant();
                    break;
                }
            }
        }
    }

    private function isMouseUnderRidge(p:Point, r:Ridge):Boolean {
        var b:Boolean = r.hitArea.isTouchablePoint(p.x - r.source.x, p.y - r.source.y);
        return b;
    }

    public function checkGrowedRidges():void {
        var b:Boolean = false;
        var i:int;
        for (i=0; i<_arrRidge.length; i++) {  // check if there are at least one GROWED ridge
            if (_arrRidge[i].stateRidge == Ridge.GROWED) {
                b = true;
                break;
            }
        }

        if (!b) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        }
    }

    public function getRidgesForCraft():Array {
        var arr:Array = [];
        for (var i:int=0; i<_arrRidge.length; i++) {
            if (_arrRidge[i].stateRidge == Ridge.GROWED) {
                arr.push(_arrRidge[i]);
            }
        }
        return arr;
    }

    public function getEmptyRidges():Array {
        var arr:Array = [];
        for (var i:int=0; i<_arrRidge.length; i++) {
            if (_arrRidge[i].stateRidge == Ridge.EMPTY) {
                arr.push(_arrRidge[i]);
            }
        }
        return arr;
    }
}
}
