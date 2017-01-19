/**
 * Created by user on 12/30/16.
 */
package quest {
public class QuestTaskStructure {
    private var _questId:int;
    private var _taskData:Object;
    private var _isDone:Boolean;
    private var _taskUserDbId:String;
    private var _countDone:int;

    public function QuestTaskStructure() {
    }

    public function fillIt(d:Object):void {
        _questId = int(d.quest_id);
        _isDone = Boolean(d.is_done == '1');
        _taskUserDbId = d.id;
        _countDone = int(d.count_done);
        _taskData = d.task_data;   // adds, count_resource, description, icon_task, id, quest_id, type_action, type_resource
    }

    public function upgradeCount():void {
        _countDone++;
        if (_countDone >= countNeed) {
            _isDone = 1;
        }
    }

    public function get icon():String { return _taskData.icon_task; }
    public function get countDone():int { return _countDone; }
    public function get countNeed():int { return int(_taskData.count_resource); }
    public function get typeResource():int { return int(_taskData.type_resource); }
    public function get typeAction():int { return int(_taskData.type_action); }
    public function get questId():int { return _questId; }
    public function get isDone():Boolean { return _isDone; }
    public function get description():String { return _taskData.description; }
    public function get adds():String { return _taskData.adds; }

}
}
