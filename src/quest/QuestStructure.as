/**
 * Created by user on 12/30/16.
 */
package quest {
import com.junkbyte.console.Cc;
import starling.display.Image;

public class QuestStructure {
    private var _tasks:Array;
    private var _awards:Array;
    private var _questUserDbId:String;
    private var _questData:Object;
    private var _isGetAward:Boolean;
    private var _isDone:Boolean;
    private var _questId:int;

    public function QuestStructure() {
        _tasks = [];
        _awards = [];
    }

    public function fillIt(ob:Object):void {
        _questUserDbId = ob.id;
        _questData = ob.quest_data; // date_finish, date_start, description, icon_quest, id, level, only_testers, prev_quest_id, use_it, name
        _isGetAward = Boolean(ob.get_award == '1');
        _isDone = Boolean(ob.is_done == '1');
        _questId = int(ob.quest_id);
    }

    public function get questId():int { return _questId; }

    public function addTask(d:Object):void {
        var t:QuestTaskStructure = getTasksById(d.task_id);
        if (t) {
            Cc.info('QuestStructure addTask:: already has task with id: ' + d.task_id + '  for questId: ' + _questId);
            return;
        }
        t = new QuestTaskStructure();
        t.fillIt(d);
        _tasks.push(t);
    }

    public function addAward(d:Object):void {
        var aw:QuestAwardStructure = getAwardById(d.id);
        if (aw) {
            Cc.info('QuestStructure addAward:: already has award with id: ' + d.id + '  for questId: ' + _questId);
            return;
        }
        aw = new QuestAwardStructure();
        aw.fillIt(d);
        _awards.push(aw);
    }
    
    public function checkQuestForDone():void {
        for (var i:int=0; i<_tasks.length; i++) {
            if (!(_tasks[i] as QuestTaskStructure).isDone) {
                _isDone = false;
                return;
            }
        }
        _isDone = true;
    }

    public function getTasksByType(t:int):Array {
        var ar:Array = [];
        for (var i:int=0; i<_tasks.length; i++) {
            if ((_tasks[i] as QuestTaskStructure).typeAction == t) ar.push(_tasks[i]);
        }
        return ar;
    }

    private function getTasksById(id:int):QuestTaskStructure {
        for (var i:int=0; i<_tasks.length; i++) {
            if ((_tasks[i] as QuestTaskStructure).taskId == id) return _tasks[i];
        }
        return null;
    }

    private function getAwardById(id:int):QuestAwardStructure {
        for (var i:int=0; i<_awards.length; i++) {
            if ((_awards[i] as QuestAwardStructure).awardId == id) return _awards[i];
        }
        return null;
    }
    
    public function get iconPath():String { return _questData.icon_quest; }
    public function get id():int { return _questId; }
    public function get idDB():String { return _questUserDbId; }
    public function get description():String { return _questData.description; }
    public function get awards():Array { return _awards; }
    public function get tasks():Array { return _tasks; }
    public function get questName():String { return _questData.name; }
    public function get isDone():Boolean { return _isDone; }  
    public function set isDone(v:Boolean):void { _isDone = v; }

    public function getUrlFromTask():String {
        if (!_tasks.length) {
            Cc.error('QuestStructure no tasks for questId: ' + _questId);
            return null;
        }
        return (_tasks[0] as QuestTaskStructure).icon;
    }

    public function iconImageFromAtlas():Image {
        if (!_tasks.length) {
            Cc.error('QuestStructure no tasks for questId: ' + _questId);
            return null;
        }
        return (_tasks[0] as QuestTaskStructure).iconImageFromAtlas;
    }

}
}
