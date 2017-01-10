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
}
}
