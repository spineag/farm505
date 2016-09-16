/**
 * Created by andy on 9/9/16.
 */
package quest {
import data.DataMoney;

import manager.ManagerWallPost;
import manager.Vars;

import windows.WindowsManager;
import windows.quest.WOQuest;

public class ManagerQuest {
    public static const DELTA_ICONS:int = 110;
    
    private var g:Vars = Vars.getInstance();
    private var _questUI:QuestUI;
    private var _quests:Array;
    private var _qAllData:QuestData;
    private var _userQuests:Object;
    private var _currentOpenedQuestInWO:Object;

    public function ManagerQuest() {
        _qAllData = new QuestData();
        _quests = [];
        _questUI = new QuestUI();
        _userQuests = {};
    }

    public function fromServer(ar:Array):void {
        var ob:Object = {};
        for (var i:int=0; i<ar.length; i++) {
            ob.questId = int(ar[i].quest_id); 
            ob.isDone = Boolean(int(ar[i].is_done)); 
            ob.getAward = Boolean(int(ar[i].get_award));
            _userQuests[ob.questId] = ob;
        }
    }

    public function checkQuestsOnStart():void {
        if (g.user.isMegaTester || g.user.isTester) {
            var qArr:Array = _qAllData.arrQuests;
            for (var i:int = 0; i < qArr.length; i++) {
                if (qArr[i].level <= g.user.level && !qArr[i].isAdded) {
                    if (_userQuests[qArr[i].id] && _userQuests[qArr[i].id].getAward) continue;
                    qArr[i].isAdded = true;
                    if (_userQuests[qArr[i].id] && _userQuests[qArr[i].id].isDone) qArr[i].isDone = true;
                    else qArr[i].isDone = false;
                    _quests.push(qArr[i]);
                    _questUI.addQuest(qArr[i], onQuestIconClick);
                    if (!_userQuests[qArr[i].id]) {
                        _userQuests[qArr[i].id] = qArr[i];
                    }
                }
            }
        }
    }
    
    private function onQuestIconClick(qData:Object):void {
        _currentOpenedQuestInWO = qData;
        g.windowsManager.openWindow(WindowsManager.WO_QUEST, null, qData);
    }

    private function onReleaseQuest(qData:Object):void {
        _userQuests[qData.id].isDone = true;
        g.directServer.releaseUserQuest(qData.id, null);
        if (_currentOpenedQuestInWO == qData) {
            if (_currentOpenedQuestInWO.questIcon) _currentOpenedQuestInWO.questIcon.updateInfo();
            if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_QUEST) {
                (g.windowsManager.currentWindow as WOQuest).updateInfo();
            }
        }
    }
    
    public function checkQuestContPosition():void { _questUI.checkContPosition(); }
    public function onHideWO():void { _currentOpenedQuestInWO = null; } 

    public function checkOnClickAtWoQuestItem(qData:Object):void {
        switch (qData.type) {
            case QuestData.TYPE_ADD_LEFT_MENU:
                g.socialNetwork.checkLeftMenu();
                break;
            case QuestData.TYPE_ADD_TO_GROUP:
                g.socialNetwork.checkIsInSocialGroup();
                break;
            case QuestData.TYPE_POST:
                g.managerWallPost.openWindow(ManagerWallPost.POST_FOR_QUEST,null,0,DataMoney.SOFT_CURRENCY);
                break;
        }
    }

    public function onGetAwardFromQuest():void {
        _userQuests[_currentOpenedQuestInWO.id].getAward = true;
        g.directServer.releaseUserQuestAward(_currentOpenedQuestInWO.id, null);
        _questUI.removeIconWithShiftAll(_currentOpenedQuestInWO.questIcon);
    }
    
    public function onFinishActionForQuestByType(type:int):void {
        for (var i:int=0; i<_quests.length; i++) {
            if (_quests[i].type == type) {
                onReleaseQuest(_quests[i]);
                break;
            }
        }
    }
    
}
}
