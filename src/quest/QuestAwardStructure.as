/**
 * Created by user on 1/13/17.
 */
package quest {
public class QuestAwardStructure {
    private var _countResource:int;
    private var _idResource:int;
    private var _questId:int;
    private var _typeResource:String;

    public function QuestAwardStructure() {
    }

    public function fillIt(d:Object):void {
        _countResource = int(d.count_resource);
        _idResource = int(d.id_resource);
        _questId = int(d.quest_id);
        _typeResource = String(d.type_resource);
    }

    public function get countResource():int { return _countResource; }
    public function get idResource():int { return _idResource; }
    public function get typeResource():String { return _typeResource; }
}
}
