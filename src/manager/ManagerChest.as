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
        var aR:Number = Math.random();
        var iR:Number = Math.random();

        if (aR < .2) {
            if (iR < .16) {
                obj.count = 1;
                obj.id = 7;
                obj.type = INSTRUMENT;
            } else if (iR <.32) {
                obj.count = 1;
                obj.id = 9;
                obj.type = INSTRUMENT;
            } else if (iR < .48){
                obj.count = 1;
                obj.id = 2;
                obj.type = INSTRUMENT;
            } else if (iR < .64) {
                obj.count = 1;
                obj.id = 8;
                obj.type = INSTRUMENT;
            } else if (iR < .8) {
                obj.count = 1;
                obj.id = 4;
                obj.type = INSTRUMENT;
            } else {
                obj.count = 1;
                obj.id = 3;
                obj.type = INSTRUMENT;
            }
        } else if (aR < .3) {
            if (iR < .25) {
                if (g.userInventory.getCountResourceById(1) > 5 &&  Math.random() < .5) {
                     obj = instrumentRandom();
                } else {
                    obj.count = 1;
                    obj.id = 1;
                    obj.type = INSTRUMENT;
                }
            } else if (iR <.5) {
                if (g.userInventory.getCountResourceById(124) > 5 &&  Math.random() < .5) {
                    obj = instrumentRandom();
                } else {
                    obj.count = 1;
                    obj.id = 124;
                    obj.type = INSTRUMENT;
                }
            } else if (iR < .75){
                if (g.userInventory.getCountResourceById(6) > 5 &&  Math.random() < .5) {
                    obj = instrumentRandom();
                } else {
                    obj.count = 1;
                    obj.id = 6;
                    obj.type = INSTRUMENT;
                }
            } else if (iR < .9) {
                if (g.userInventory.getCountResourceById(5) > 5 &&  Math.random() < .5) {
                    obj = instrumentRandom();
                } else {
                    obj.count = 1;
                    obj.id = 5;
                    obj.type = INSTRUMENT;
                }
            } else {
                if (g.userInventory.getCountResourceById(125) > 5 &&  Math.random() < .5) {
                    obj = instrumentRandom();
                } else {
                    obj.count = 1;
                    obj.id = 125;
                    obj.type = INSTRUMENT;
                }
            }
        } else {
            if (iR < .7) {
                obj.count = 100;
                obj.id = 0;
                obj.type = SOFT_MONEY;
            } else if (iR< .9) {
                obj.count = 1;
                obj.id = 0;
                obj.type = HARD_MONEY;
            } else {
                obj.count = 3;
                obj.id = 0;
                obj.type = HARD_MONEY;
            }
        }
        _data = obj;
    }

    private function instrumentRandom():Object {
        var obj:Object = {};
        var iR:int = Math.random();
        if (iR < .25) {
            obj.count = 1;
            obj.id = 1;
            obj.type = INSTRUMENT;
        } else if (iR <.5) {
            obj.count = 1;
            obj.id = 124;
            obj.type = INSTRUMENT;
        } else if (iR < .75){
            obj.count = 1;
            obj.id = 6;
            obj.type = INSTRUMENT;
        } else if (iR < .9) {
            obj.count = 1;
            obj.id = 5;
            obj.type = INSTRUMENT;
        } else {
            obj.count = 1;
            obj.id = 125;
            obj.type = INSTRUMENT;
        }

        return obj;
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
