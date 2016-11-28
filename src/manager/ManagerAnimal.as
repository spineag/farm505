/**
 * Created by andy on 8/6/15.
 */
package manager {
import build.farm.Animal;
import build.farm.Farm;
import com.junkbyte.console.Cc;
import flash.geom.Point;
import heroes.HeroCat;
import media.SoundConst;

import mouse.ToolsModifier;

import windows.WindowsManager;

public class ManagerAnimal {
    private var _arrFarm:Array;  // все фермы юзера, которые стоят на поляне и построенны
    private var _catsForFarm:Object;
    private var _tempPoint:Point;
    private var _arrAnimals:Array;
    public var activeFeedAnimalId:int = 0;

    private var g:Vars = Vars.getInstance();

    public function ManagerAnimal() {
        _tempPoint = new Point();
        var arr:Array = g.townArea.cityObjects;
        _arrFarm = [];
        _catsForFarm = {};
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i] is Farm) {
                _arrFarm.push(arr[i]);
            }
        }
    }

    public function onAddNewFarm(fa:Farm):void {
        if (g.isAway) return;
        if (_arrFarm.indexOf(fa) < 0) {
            _arrFarm.push(fa);
        }
    }

    public function addAnimal(ob:Object):void {
        var i:int;
        var curFarm:Farm;
        for (i = 0; i < _arrFarm.length; i++) {
            if (_arrFarm[i].dbBuildingId == int(ob.user_db_building_id)) {
                curFarm = _arrFarm[i];
                break;
            }
        }
        if (!curFarm) {
            Cc.error('no such Farm with dbId: ' + ob.user_db_building_id);
            return;
        }
        curFarm.addAnimal(true, ob);
    }

    public function checkIsCat(farmDbId:int):Boolean {
        if (_catsForFarm[farmDbId]) return true;
        if (g.managerCats.countFreeCats > 0) return true;
        return false;
    }

    public function addCatToFarm(fa:Farm):void {
        if (_catsForFarm[fa.dbBuildingId]) return;

        var cat:HeroCat = g.managerCats.getFreeCat();
        _catsForFarm[fa.dbBuildingId] = cat;
        if (cat) {
            cat.isFree = false;
            cat.curActiveFarm = fa;
            if (cat.isOnMap) {
                g.managerCats.goCatToPoint(cat, new Point(fa.posX, fa.posY), onArrivedCatToFarm, cat);
            } else {
                cat.setPosition(new Point(fa.posX, fa.posY));
                cat.addToMap();
                onArrivedCatToFarm(cat);
            }
        } else {
            Cc.error('ManagerAnimal addCatToFarm:: cat = null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerAnimal');
        }
    }

    private function onArrivedCatToFarm(cat:HeroCat):void {
        var p:Point = new Point();
        var k:int = 3 + int(Math.random()*3);
        cat.isLeftForFeedAndWatering = Math.random() > .5;
        if (cat.isLeftForFeedAndWatering) {
            p.x = cat.curActiveFarm.posX;
            p.y = cat.curActiveFarm.posY + k;
        } else {
            p.x = cat.curActiveFarm.posX + k;
            p.y = cat.curActiveFarm.posY;
        }
        g.managerCats.goCatToPoint(cat, p, onArrivedCatToFarmPoint, cat);
    }

    public function onGoAwayCats(v:Boolean):void {
        var c:HeroCat;
        var s:String;
        for (s in _catsForFarm) {
            c = _catsForFarm[s];
            if (v) {
                if (c.curActiveFarm) {
                    c.setPosition(new Point(c.curActiveFarm.posX, c.curActiveFarm.posY));
                    c.updatePosition();
                }
                c.killAllAnimations();
            } else {
                onArrivedCatToFarm(c);
            }
        }
    }

    private function onArrivedCatToFarmPoint(cat:HeroCat):void {
        var onFinishWork:Function = function():void {
            onArrivedCatToFarm(cat);
        };
        g.townArea.zSort();
        cat.workWithFarm(onFinishWork);
    }

    public function freeFarmCat(farmDbId:int):void {
        if (_catsForFarm[farmDbId]) {
            (_catsForFarm[farmDbId] as HeroCat).forceStopWork();
            (_catsForFarm[farmDbId] as HeroCat).isFree = true;
            delete _catsForFarm[farmDbId];
        } else {
            Cc.error('ManagerAnimal freeFarmCat:: empty _catsForFarm[farmDbId] for farmDbId: ' + farmDbId);
        }
    }

    public function onFarmStartMove(farmDbId:int):void {
        if (_catsForFarm[farmDbId]) {
            var f:Function = function ():void {
                (_catsForFarm[farmDbId] as HeroCat).showSimpleIdle();
            };
            (_catsForFarm[farmDbId] as HeroCat).showFailCat(f);
            g.soundManager.playSound(SoundConst.FARM_HERO_AWAY);
        }
    }

    public function onFarmFinishMove(fa:Farm):void {
        if (_catsForFarm[fa.dbBuildingId]) {
            g.managerCats.goCatToPoint(_catsForFarm[fa.dbBuildingId] as HeroCat, new Point(fa.posX, fa.posY), onArrivedCatToFarm, _catsForFarm[fa.dbBuildingId] as HeroCat);
        }
    }

    public function getAllAnimals():Array {
        var arr:Array = [];
        for (var i:int=0; i<_arrFarm.length; i++) {
            arr = arr.concat((_arrFarm[i] as Farm).arrAnimals);
        }
        return arr;
    }

    public function getAllAnimalsById(id:int):Array {
        var arr:Array = [];
        var ans:Array;
        for (var i:int=0; i<_arrFarm.length; i++) {
            ans = (_arrFarm[i] as Farm).arrAnimals;
            if (ans[0] && (ans[0] as Animal).animalData.id == id) {
                arr = arr.concat(ans);
            }
        }
        return arr;
    }

    public function getAllHungryAnimalsForTipsWithPossibleForRaw():Array {
        var arr:Array = [];
        var ob:Object;
        for (var i:int=0; i<_arrFarm.length; i++) {
            if (!(_arrFarm[i] as Farm).isAnyCrafted) {
                ob = (_arrFarm[i] as Farm).dataAnimal;
                if (ob.id == 6 && g.userInventory.getCountResourceById(ob.idResourceRaw) > 1) {
                    arr = arr.concat((_arrFarm[i] as Farm).arrHungryAnimals);
                } else if (g.userInventory.getCountResourceById(ob.idResourceRaw) > 0) {
                    arr = arr.concat((_arrFarm[i] as Farm).arrHungryAnimals);
                }
            } 
        }
        return arr;
    }

    public function onStartFeedAnimal(isStart:Boolean):void {
        if (g.managerTutorial.isBlockForTutorial) return;
        if (!activeFeedAnimalId && isStart) {
            Cc.error('startFeedAnimal:: activeFeedAnimalId == 0');
            return;
        }
        g.cont.contentCont.releaseContDrag = !isStart;
        g.cont.tailCont.releaseContDrag = !isStart;
        g.cont.deleteDragPoint();
        if (isStart) {
            _arrAnimals = getAllAnimalsById(activeFeedAnimalId);
            g.gameDispatcher.addEnterFrame(checkForFeeding);
        } else {
            activeFeedAnimalId = 0;
            _arrAnimals.length = 0;
            g.gameDispatcher.removeEnterFrame(checkForFeeding);
        }
    }

    private function checkForFeeding():void {
        _tempPoint.x = g.ownMouse.mouseX;
        _tempPoint.y = g.ownMouse.mouseY;
        for (var i:int=0; i<_arrAnimals.length; i++) {
            if ((_arrAnimals[i] as Animal).state == Animal.HUNGRY) {  // используем ИФ, ибо тварь могли только что покормить уже, но она ведь есть все еще в масиве
                if (isMouseUnderAnimal(_arrAnimals[i] as Animal)) {
                    (_arrAnimals[i] as Animal).feedAnimal();
                    break;
                }
            } else {
                _arrAnimals.splice(i, 1);
                i--;
            }
        }
        if (!_arrAnimals.length) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        }
    }

    private var pTemp:Point = new Point();
    private var rectTemp:flash.geom.Rectangle;
    public function isMouseUnderAnimal(an:Animal):Boolean {
        rectTemp = an.rect;
        pTemp.x = 0;
        pTemp.y = 0;
        pTemp = an.source.localToGlobal(pTemp);
        if (_tempPoint.x > pTemp.x+rectTemp.x && _tempPoint.x < pTemp.x+rectTemp.x+rectTemp.width &&
                _tempPoint.y > pTemp.y+rectTemp.y && _tempPoint.y < pTemp.y+rectTemp.y+rectTemp.height) {
            return true;
        } else return false;
    }

}
}
