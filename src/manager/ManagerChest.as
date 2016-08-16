/**
 * Created by user on 4/27/16.
 */
package manager {
import build.WorldObject;
import data.BuildType;
import flash.geom.Point;

public class ManagerChest {
    public static const RESOURCE:int = 1;
    public static const PLANT:int = 2;
    public static const SOFT_MONEY:int = 3;
    public static const HARD_MONEY:int = 4;
    public static const INSTRUMENT:int = 6;
    public static const MAX_CHEST:int = 5;
    public static const COST_OPEN:int = 5;
    private var _data:Object;
    private var _count:int;
    private var _chestBuildID:int = -1;
    private var g:Vars = Vars.getInstance();

    public function ManagerChest() {}

    private function findChestID():void {
        for (var id:String in g.dataBuilding.objectBuilding) {
            if (g.dataBuilding.objectBuilding[id].buildType == BuildType.CHEST) {
                _chestBuildID = int(id);
                break;
            }
        }
    }

    public function fillFromServer(day:String, lastCount:int):void {
        var lastDayNumber:int = int(day);
        var curDayNumber:int = new Date().dateUTC;
        if (curDayNumber != lastDayNumber)
            _count = 0;
        else
            _count = int(lastCount);
    }

    private function generateChestItems():void {
        var obj:Object = {};
        if (Math.random()<.2) {
            obj.count = 100;
            obj.id = 0;
            obj.type = SOFT_MONEY;
        } else {
            var arr:Array = [1, 5, 6, 124, 125, 2, 3, 4, 7, 8, 9];
            obj.id = arr[int(Math.random()*arr.length)];
            obj.count = 1;
            obj.type = INSTRUMENT;
        }
        _data = obj;
    }

    public function createChest(away:Boolean = false):void {
        if (_count >= MAX_CHEST) return;
        if (g.user.level < 5) return;
        generateChestItems();
        if (_chestBuildID == -1) findChestID();
        var p:Point = g.townArea.getRandomFreeCell();
        if (away) {
            g.townArea.createAwayNewBuild(g.dataBuilding.objectBuilding[_chestBuildID], p.x, p.y, 0);
        } else {
            p = g.matrixGrid.getXYFromIndex(p);
            var build:WorldObject = g.townArea.createNewBuild(g.dataBuilding.objectBuilding[_chestBuildID], 0);
            g.townArea.pasteBuild(build, p.x, p.y, false);
        }
    }

    public function get dataPriseChest():Object {
        return _data;
    }

    public function get getCount():int {
        return _count;
    }

    public function set setCount(count:int):void {
        _count += count;
    }

    public function makeTutorialChest():WorldObject {
        var p:Point = new Point(33, 33);
        p = g.matrixGrid.getXYFromIndex(p);
        if (_chestBuildID == -1) findChestID();
        var build:WorldObject = g.townArea.createNewBuild(g.dataBuilding.objectBuilding[_chestBuildID], 0);
        g.townArea.pasteBuild(build, p.x, p.y, false);
        return build;
    }
}
}
