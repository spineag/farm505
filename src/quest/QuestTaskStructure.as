/**
 * Created by user on 12/30/16.
 */
package quest {
import build.ridge.Ridge;

import com.junkbyte.console.Cc;

import data.BuildType;
import data.StructureDataBuilding;

import manager.Vars;
import starling.display.Image;

public class QuestTaskStructure {
    private var g:Vars = Vars.getInstance();
    private var _taskId:int;
    private var _questId:int;
    private var _taskData:Object;
    private var _isDone:Boolean;
    private var _taskUserDbId:String;
    private var _countDone:int;
    private var _isSavedOnServerAfterFinish:Boolean;

    public function QuestTaskStructure() {}

    public function fillIt(d:Object):void {
        _isSavedOnServerAfterFinish = false;
        _taskId = int(d.task_id);
        _questId = int(d.quest_id);
        _isDone = Boolean(d.is_done == '1');
        _taskUserDbId = d.id;
        _countDone = int(d.count_done);
        _taskData = d.task_data;   // adds, count_resource, description, icon_task, id, quest_id, type_action, type_resource, id_resource
        if (!_taskData) {
            Cc.error('no task data for taskID: ' + _taskId + '   dor questID: ' + _questId);
            return;
        }
        if (!_isDone) checkDone();
    }

    private function checkDone():void {
        if (!_taskData) return;
        var maxCountAtCurrentLevel:int = 0;
        if (_taskData.type_action == ManagerQuest.BUILD_BUILDING) {
            var arr:Array = g.townArea.getCityObjectsById(_taskData.id_resource);
            if (arr[0] && arr[0] is Ridge) {
                for (i = 0; arr[0].dataBuild.blockByLevel.length; i++) {
                    if (arr[0].dataBuild.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                    } else break;
                }
                maxCountAtCurrentLevel = maxCountAtCurrentLevel * arr[0].dataBuild.countUnblock;
                if (arr.length >= maxCountAtCurrentLevel) {
                    _isDone = true;
                    return;
                } else {
                    _isDone = false;
                    return;
                }
            }
            if (arr && arr.length > 0) _isDone = true;
        } else if (_taskData.type_action == ManagerQuest.BUY_ANIMAL) {
            var b:StructureDataBuilding = g.allData.getBuildingById(g.allData.getFarmIdForAnimal(_taskData.id_resource));
            if (!b) return;
            maxCountAtCurrentLevel = 0;
            arr = g.townArea.getCityObjectsById(b.id);
            if (!arr.length) {
                _isDone = false;
                return;
            }
            for (var i:int = 0; b.blockByLevel.length; i++) {
                if (b.blockByLevel[i] <= g.user.level) {
                    if (b.id == 39) maxCountAtCurrentLevel += 4; // farm_bee
                    else maxCountAtCurrentLevel += 5;
                } else break;
            }
            var count:int;
            if (arr.length == 1) count = arr[0].arrAnimals.length;
                else if (arr.length == 2) count = arr[0].arrAnimals.length + arr[1].arrAnimals.length;
                else if (arr.length == 2) count = arr[0].arrAnimals.length + arr[1].arrAnimals.length + arr[2].arrAnimals.length;
            if (count >= maxCountAtCurrentLevel) _isDone = true;
                else if (maxCountAtCurrentLevel - count < countNeed) _countDone = countNeed - (maxCountAtCurrentLevel - count);
        } else if (_taskData.type_action == ManagerQuest.BUY_CAT) {
            if (g.managerCats.curCountCats == g.managerCats.maxCountCats) _isDone = true;
                else if (g.managerCats.maxCountCats - g.managerCats.curCountCats < countNeed) _countDone = countNeed - (g.managerCats.maxCountCats - g.managerCats.curCountCats);
        }
    }

    public function upgradeCount():void {
        _countDone++;
        if (_countDone >= countNeed) _isDone = true;
    }

    public function get icon():String { return _taskData.icon_task; } // if =='0' -> get from resource
    public function get countDone():int { return _countDone; }
    public function get countNeed():int { return int(_taskData.count_resource); }
    public function get typeResource():int { return int(_taskData.type_resource); }
    public function get typeAction():int { return int(_taskData.type_action); }
    public function get taskId():int { return _taskId; }
    public function get questId():int { return _questId; }
    public function get isDone():Boolean { return _isDone; }
    public function get description():String { return g.managerLanguage.allTexts[int(_taskData.text_id)]}
    public function get adds():String { return _taskData.adds; }
    public function get dbID():String { return _taskUserDbId; }
    public function get resourceId():int { return _taskData.id_resource; }
    public function get isSavedOnServerAfterFinish():Boolean { return _isSavedOnServerAfterFinish; }
    public function onSaveOnServerAfterFinish():void { _isSavedOnServerAfterFinish = true; }

    public function get iconImageFromAtlas():Image {
        var im:Image;
        var ob:*;
        switch (int(_taskData.type_resource)) {
            case BuildType.PLANT:
                ob = g.allData.getResourceById(int(_taskData.id_resource));
                if (ob) im = new Image(g.allData.atlas['resourceAtlas'].getTexture(ob.imageShop + '_icon'));
                break;
            case BuildType.RESOURCE:
                ob = g.allData.getResourceById(int(_taskData.id_resource));
                if (ob) im = new Image(g.allData.atlas[ob.url].getTexture(ob.imageShop));
                break;
            case BuildType.FABRICA:
                ob = g.allData.getBuildingById(int(_taskData.id_resource));
                if (ob) im = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.url + '_icon'));
                break;
            case BuildType.FARM:
                ob = g.allData.getBuildingById(int(_taskData.id_resource));
                if (ob) im = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                break;
            case BuildType.WILD:
                ob = g.allData.getBuildingById(int(_taskData.id_resource));
                if (ob) im = new Image(g.allData.atlas['wildAtlas'].getTexture(ob.image));
                if (!im) im = new Image(g.allData.atlas['wildAtlas'].getTexture('swamp'));
                break;
            case BuildType.ANIMAL:
                ob = g.allData.getAnimalById(int(_taskData.id_resource));
                if (ob) im = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.url + '_icon'));
                break;
            case BuildType.RIDGE:
                im = new Image(g.allData.atlas['iconAtlas'].getTexture('ridge_icon'));
                break;
            case BuildType.DECOR:
            case BuildType.DECOR_ANIMATION:
            case BuildType.DECOR_FENCE_ARKA:
            case BuildType.DECOR_FENCE_GATE:
            case BuildType.DECOR_FULL_FENСE:
            case BuildType.DECOR_POST_FENCE:
            case BuildType.DECOR_POST_FENCE_ARKA:
            case BuildType.DECOR_TAIL:
                ob = g.allData.getBuildingById(int(_taskData.id_resource));
                if (ob) im = new Image(g.allData.atlas[ob.url].getTexture(ob.image));
                break;
            case 0:
                if (int(_taskData.type_action) == ManagerQuest.SET_IN_PAPER) {
                    im = new Image(g.allData.atlas['iconAtlas'].getTexture('road_shop_icon'));
                } else if (int(_taskData.type_action) == ManagerQuest.BUY_PAPER) {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newspaper_icon_small'));
                } else if (int(_taskData.type_action) == ManagerQuest.RELEASE_ORDER) {

                } else if (int(_taskData.type_action) == ManagerQuest.NIASH_BUYER) {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('nyash_blue'));
                } else if (int(_taskData.type_action) == ManagerQuest.KILL_LOHMATIC) {

                } else if (int(_taskData.type_action) == ManagerQuest.KILL_MOUSE) {

                } else if (int(_taskData.type_action) == ManagerQuest.OPEN_TERRITORY) {

                } else im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_quest_icon'));
                break;
        }
        return im;
    }

}
}
