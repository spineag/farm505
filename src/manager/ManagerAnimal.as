/**
 * Created by andy on 8/6/15.
 */
package manager {
import build.farm.Farm;

import com.junkbyte.console.Cc;

import flash.geom.Point;

import heroes.HeroCat;

import media.SoundConst;

import windows.WindowsManager;

public class ManagerAnimal {
    private var _arrFarm:Array;  // все фермы юзера, которые стоят на поляне и построенны
    private var _catsForFarm:Object;

    private var g:Vars = Vars.getInstance();

    public function ManagerAnimal() {
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

}
}
