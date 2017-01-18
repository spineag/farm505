/**
 * Created by andy on 9/9/16.
 */
package quest {
import com.junkbyte.console.Cc;
import data.DataMoney;
import manager.ManagerWallPost;
import manager.Vars;
import utils.Link;
import windows.WindowsManager;

public class ManagerQuest {
    public static const ICON_PATH:String = 'https://505.ninja/content/quest_icon/';

    public static const ADD_TO_GROUP:int = 1;
    public static const ADD_LEFT_MENU:int = 2;
    public static const POST:int = 3;
    public static const GET_PLANTS:int = 4;
    public static const BUILD_BUILDING:int = 5;
    public static const MAKE_PRODUCTS:int = 6;
    public static const INVITE_FRIENDS:int = 7;
    public static const KILL_LOHMATICS:int = 8;

    private var g:Vars = Vars.getInstance();
    private var _questUI:QuestIconUI;
    private var _userQuests:Array;
    private var _currentOpenedQuestInWO:QuestStructure;

    public function ManagerQuest() {
        if (!g.useQuests) return;
        _userQuests = [];
        g.load.loadAtlas('questAtlas', 'questAtlas', addUI);
    }

    public function get userQuests():Array {
        return _userQuests;
    }

    public function addUI():void {
        if (g.user.level >= 5 && g.useQuests) _questUI = new QuestIconUI(openWOList);
    }

    private function openWOList():void {
        g.windowsManager.openWindow(WindowsManager.WO_QUEST_LIST, null);
    }

    public function hideQuestsIcons(v:Boolean):void {
        if (_questUI) _questUI.hideIt(v);
    }

    public function getQuestsOnStart():void {
        if (g.user.level < 5) return;
        if (g.useQuests) g.directServer.getUserQuests(onGetUserQuests);
    }

    private function onGetUserQuests(d:Object):void {
        addQuests(d, false);
        getNewQuests();
    }

    public function getNewQuests():void {
        if (g.user.level < 5) return;
        if (g.useQuests) g.directServer.getUserNewQuests(onGetNewQuests);
    }

    private function onGetNewQuests(d:Object):void {
        addQuests(d, true);
    }

    private function getUserQuesrById(id:int):QuestStructure {
        for (var i:int=0; i<_userQuests.length; i++) {
            if ((_userQuests[i] as QuestStructure).questId == id) return _userQuests[i];
        }
        return null;
    }

    private function addQuests(d:Object, isNew:Boolean):void {
        if (d.quests.length) {
            var q:QuestStructure;
            var i:int;
            for (i=0; i<d.quests.length; i++) {
                q = new QuestStructure();
                q.fillIt(d.quests[i]);
                _userQuests.push(q);
            }
            for (i=0; i<d.tasks.length; i++) {
                q = getUserQuesrById(int(d.tasks[i].quest_id));
                if (q) {
                    q.addTask(d.tasks[i]);
                } else {
                    Cc.error('ManagerQuests addQuest task:: no quest with id: ' + d);
                }
            }
            if (d.awards) {
                for (i = 0; i < d.awards.length; i++) {
                    q = getUserQuesrById(int(d.awards[i].quest_id));
                    if (q) {
                        q.addAward(d.awards[i]);
                    } else {
                        Cc.error('ManagerQuests addQuest award:: no quest with id: ' + d);
                    }
                }
            } else {
                Cc.error('ManagerQuests addQuest award:: no awards');
            }
        }
    }

    public function showWOForQuest(d:QuestStructure):void {
        _currentOpenedQuestInWO = d;
        g.windowsManager.openWindow(WindowsManager.WO_QUEST, null, d);
    }


    private function onReleaseQuest(qData:Object):void {
        return;
//        _userQuests[qData.id].isDone = true;
//        g.directServer.releaseUserQuest(qData.id, null);
//        if (_currentOpenedQuestInWO == qData) {
//            if (_currentOpenedQuestInWO.questIcon) _currentOpenedQuestInWO.questIcon.updateInfo();
//            if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_QUEST) {
//                (g.windowsManager.currentWindow as WOQuest).updateInfo();
//            }
//            if (qData.type == ADD_TO_GROUP) {
//                g.gameDispatcher.removeFromTimer(checkWithTimer);
//            }
//        }
    }
    
    public function checkQuestContPosition():void { if (_questUI) _questUI.checkContPosition(); }
    public function onHideWO():void {
        _currentOpenedQuestInWO = null;
        g.gameDispatcher.removeFromTimer(checkWithTimer);
    }

    public function checkOnClickAtWoQuestItem(t:QuestTaskStructure):void {
        switch (t.typeAction) {
            case ADD_LEFT_MENU:
                g.socialNetwork.checkLeftMenu();
                break;
            case ADD_TO_GROUP:
                Link.openURL(g.socialNetwork.urlSocialGroup);
                _timer = 3;
                g.gameDispatcher.addToTimer(checkWithTimer);
                break;
            case POST:
                g.managerWallPost.openWindow(ManagerWallPost.POST_FOR_QUEST, null, 0, DataMoney.SOFT_CURRENCY);
                break;
        }
    }

    public function onGetAwardFromQuest():void {
//        _userQuests[_currentOpenedQuestInWO.id].getAward = true;
//        g.directServer.releaseUserQuestAward(_currentOpenedQuestInWO.id, null);
//        _questUI.removeIconWithShiftAll(_currentOpenedQuestInWO.questIcon);
    }
    
    public function onActionForTaskType(type:int, adds:Object):void {
        if (type == ADD_LEFT_MENU) {

        }
//        for (var i:int=0; i<_quests.length; i++) {
//            if (_quests[i].type == type) {
//                onReleaseQuest(_quests[i]);
//                break;
//            }
//        }
    }

    public function checkInGroup():void {
//        g.socialNetwork.checkIsInSocialGroup();
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
