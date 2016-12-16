/**
 * Created by andy on 9/9/16.
 */
package quest {
import data.DataMoney;

import manager.ManagerWallPost;
import manager.Vars;

import social.SocialNetworkSwitch;

import utils.Link;

import windows.WindowsManager;
import windows.quest.WOQuest;

public class ManagerQuest {
    public static const ADD_TO_GROUP:int = 1;
    public static const ADD_LEFT_MENU:int = 2;
    public static const POST:int = 3;
    public static const GET_PLANTS:int = 4;
    public static const BUILD_BUILDING:int = 5;
    public static const MAKE_PRODUCTS:int = 6;
    public static const INVITE_FRIENDS:int = 7;
    public static const KILL_LOHMATICS:int = 8;

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
        if (!g.user.isMegaTester) return;
        var ob:Object;
        for (var i:int=0; i<ar.length; i++) {
            ob = {};
            ob.questId = int(ar[i].quest_id); 
            ob.isDone = Boolean(int(ar[i].is_done)); 
            ob.getAward = Boolean(int(ar[i].get_award));
            _userQuests[ob.questId] = ob;
        }
    }
    
    public function hideQuestsIcons(v:Boolean):void {
        if (_questUI) _questUI.hideQuestsIcons(v);
    }

    public function checkQuestsOnStart():void {
        if (!g.user.isMegaTester) return;
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
            if (qData.type == ADD_TO_GROUP) {
                g.gameDispatcher.removeFromTimer(checkWithTimer);
            }
        }
    }
    
    public function checkQuestContPosition():void { if (_questUI) _questUI.checkContPosition(); }
    public function onHideWO():void {
        _currentOpenedQuestInWO = null;
        g.gameDispatcher.removeFromTimer(checkWithTimer);
    }

    public function checkOnClickAtWoQuestItem(qData:Object):void {
        switch (qData.type) {
            case ADD_LEFT_MENU:
                g.socialNetwork.checkLeftMenu();
                break;
            case ADD_TO_GROUP:
                Link.openURL(g.socialNetwork.urlSocialGroup);
                _timer = 3;
                g.gameDispatcher.addToTimer(checkWithTimer);
                break;
            case POST:
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

    public function checkInGroup():void {
        g.socialNetwork.checkIsInSocialGroup();
    }

    private var _timer:int;
    private function checkWithTimer():void {
        _timer--;
        if (_timer <= 0) {
            checkInGroup();
            _timer = 3;
        }
    }
    
}
}
