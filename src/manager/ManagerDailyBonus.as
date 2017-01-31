/**
 * Created by andy on 1/18/16.
 */
package manager {
import build.WorldObject;
import build.dailyBonus.DailyBonus;

import data.BuildType;

public class ManagerDailyBonus {
    public static const RESOURCE:int = 1;
    public static const PLANT:int = 2;
    public static const SOFT_MONEY:int = 3;
    public static const HARD_MONEY:int = 4;
    public static const DECOR:int = 5;
    public static const INSTRUMENT:int = 6;

    private var _arrItems:Array;
    private var _count:int;
    private var g:Vars = Vars.getInstance();

    public function ManagerDailyBonus() {
        super();
    }

    public function fillFromServer(day:String, lastCount:int):void {
        var lastDayNumber:int = int(day);
        var curDayNumber:int = new Date(g.user.day * 1000).dateUTC;
        if (curDayNumber != lastDayNumber)
            _count = 0;
        else
            _count = int(lastCount);
    }

    public function updateCount():void {
        _count++;
        checkDailyBonusStateBuilding();
    }

    public function get count():int {
        return _count;
    }

    public function generateDailyBonusItems():void {
        _arrItems = [];
        var arr:Array = [];
        for(var id:String in g.dataResource.objectResources) {
            if (g.dataResource.objectResources[id].blockByLevel <= g.user.level &&
                    (g.dataResource.objectResources[id].buildType == BuildType.PLANT ||
                    g.dataResource.objectResources[id].buildType == BuildType.RESOURCE)) {
                arr.push(int(id));
            }
        }
        var k:int;
        var obj:Object;
        for (var i:int = 0; i<8; i++) {
            k = int(Math.random()*arr.length);  // get random position
            k = arr.splice(k, 1);  // get random id resource or plant
            obj = {};
            obj.id = k;
            if (g.dataResource.objectResources[k].buildType == BuildType.PLANT) {
                obj.count = 3;
                obj.type = PLANT;
            } else {
                obj.count = 1;
                obj.type = RESOURCE;
            }
            _arrItems.push(obj);
        }

        obj = {};
        if (Math.random() > .5) {
            obj.count = 500;
            obj.id = 0;
            obj.type = SOFT_MONEY;
        } else {
            obj.count = 10;
            obj.id = 0;
            obj.type = HARD_MONEY;
        }
        _arrItems.push(obj);

        obj = {};
        arr = [];
        for(id in g.dataBuilding.objectBuilding) {
            if (g.dataBuilding.objectBuilding[id].blockByLevel && g.dataBuilding.objectBuilding[id].blockByLevel[0] <= g.user.level &&
                    g.dataBuilding.objectBuilding[id].buildType == BuildType.DECOR) {
                arr.push(int(id));
            }
        }
        obj.id = arr[int(Math.random()*arr.length)];
        obj.count = 1;
        obj.type = DECOR;
        _arrItems.push(obj);

        obj = {};
        arr = [1, 5, 6];
        obj.id = arr[int(Math.random()*arr.length)];
        obj.count = 1;
        obj.type = INSTRUMENT;
        _arrItems.push(obj);

        obj = {};
        arr = [2, 3, 4, 7, 8, 9];
        obj.id = arr[int(Math.random()*arr.length)];
        obj.count = 1;
        obj.type = INSTRUMENT;
        _arrItems.push(obj);
    }

    public function get dailyBonusItems():Array {
        return _arrItems.slice();
    }

    public function checkDailyBonusStateBuilding():void {
        var b:WorldObject = g.townArea.getCityObjectsByType(BuildType.DAILY_BONUS)[0];
        if (b) {
            if (_count <= 0) {
                (b as DailyBonus).showLights();
            } else {
                (b as DailyBonus).hideLights();
            }
        }
    }
}
}
