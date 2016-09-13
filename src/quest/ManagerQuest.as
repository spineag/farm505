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
    private var _qAllData:QuestData;

    public function ManagerQuest() {
        _qAllData = new QuestData();
        _quests = [];
        _questUI = new QuestUI();
        return;
        //g.directServer.getUserQuests(checkQuestsOnStart);
    }

    public function checkQuestsOnStart():void {
        return;  //add for testers
        var qArr:Array = _qAllData.arrQuests;
        for (var i:int=0; i<qArr.length; i++) {
            if (qArr[i].level <= g.user.level && !qArr[i].isAdded && g.user.releasedQuestsIds.indexOf(qArr[i].id) == -1) {
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

    public function checkOnClick(qData:Object):void {
        switch (qData.type) {
            case QuestData.TYPE_ADD_LEFT_MENU:
                g.socialNetwork.checkLeftMenu();
                break;

        }
    }

    private function onReleaseQuest(qData:Object):void {
//        g.user.releasedQuestsIds.push(qData.id);
//        if (_quests.indexOf(qData) > -1) {
//            _quests.removeAt(_quests.indexOf(qData));
//            _questUI.onComplete
//        }
//        qData.isAdded = false;
    }
    
    public function onAddToLeftMenu():void {
        for (var i:int=0; i<_quests.length; i++) {
            if (_quests[i].type == QuestData.TYPE_ADD_LEFT_MENU) {
                onReleaseQuest(_quests[i]);
                break;
            }
        }
    }
    
}
}
