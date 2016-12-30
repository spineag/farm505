/**
 * Created by user on 12/30/16.
 */
package quest {
public class QuestStructure {
    private var _tasks:Array;
    private var _questUserDbId:int;
    private var _questData:Object;
    private var _isGetAward:Boolean;
    private var _isDone:Boolean;
    private var _questId:int;

    public function QuestStructure() {
        _tasks = [];
    }

    public function fillIt(ob:Object):void {
        _questUserDbId = int(ob.id);
        _questData = ob.quest_data; // date_finish, date_start, description, icon_quest, id, level, only_testers, prev_quest_id, use_it
        _isGetAward = Boolean(ob.get_award == '1');
        _isDone = Boolean(ob.is_done == '1');
        _questId = int(ob.quest_id);
    }

    public function get questId():int {
        return _questId;
    }

    public function addTask(d:Object):void {
        var t:QuestTaskStructure = new QuestTaskStructure();
        t.fillIt(d);
        _tasks.push(t);
    }
}
}
