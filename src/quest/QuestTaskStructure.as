/**
 * Created by user on 12/30/16.
 */
package quest {
import data.BuildType;
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
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(ob.imageShop + '_icon'));
                break;
            case BuildType.RESOURCE:
                ob = g.allData.getResourceById(int(_taskData.id_resource));
                im = new Image(g.allData.atlas[ob.url].getTexture(ob.imageShop));
                break;
            case BuildType.FABRICA:
                ob = g.allData.getBuildingById(int(_taskData.id_resource));
                im = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.url + '_icon'));
                break;
            case BuildType.FARM:
                ob = g.allData.getBuildingById(int(_taskData.id_resource));
                im = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                break;
            case BuildType.WILD:
                im = new Image(g.allData.atlas['wildAtlas'].getTexture('swamp'));
                break;
            case BuildType.ANIMAL:
                ob = g.allData.getAnimalById(int(_taskData.id_resource));
                im = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.url + '_icon'));
                break;
            case BuildType.RIDGE:
                im = new Image(g.allData.atlas['iconAtlas'].getTexture('ridge_icon'));
                break;
            case 0:
                if (int(_taskData.type_action == ManagerQuest.SET_IN_PAPER || int(_taskData.type_action) == ManagerQuest.BUY_PAPER)) {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newspaper_icon_small'));
                }
                break;
        }
        return im;
    }

}
}
