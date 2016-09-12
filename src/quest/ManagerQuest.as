/**
 * Created by andy on 9/9/16.
 */
package quest {
import manager.Vars;

import windows.WindowsManager;

public class ManagerQuest {
    public static const DELTA_ICONS:int = 110;
    
    private var g:Vars = Vars.getInstance();
    private var _questUI:QuestUI;
    private var _quests:Array;
    private var _qData:QuestData;

    public function ManagerQuest() {
        _qData = new QuestData();
        _quests = [];
        _questUI = new QuestUI();
        checkQuestsOnStart();
    }

    public function checkQuestsOnStart():void {
        return;
        var qArr:Array = _qData.arrQuests;
        for (var i:int=0; i<qArr.length; i++) {
            if (qArr[i].level <= g.user.level && !qArr[i].isAdded) {  // also check is quest unfinished
                qArr[i].isAdded = true;
                _quests.push(qArr[i]);
                _questUI.addQuest(qArr[i], onQuestIconClick);
            }
        }
    }
    
    private function onQuestIconClick(qData:Object):void {
        g.windowsManager.openWindow(WindowsManager.WO_QUEST, null, qData);
    }
    
    public function checkQuestContPosition():void { _questUI.checkContPosition(); } 
}
}
