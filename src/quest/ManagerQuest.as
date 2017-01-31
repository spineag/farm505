/**
 * Created by andy on 9/9/16.
 */
package quest {
import com.junkbyte.console.Cc;
import data.DataMoney;
import manager.ManagerWallPost;
import manager.Vars;
import social.SocialNetworkSwitch;
import utils.Link;
import windows.WindowsManager;

public class ManagerQuest {
    public static const ICON_PATH:String = 'https://505.ninja/content/quest_icon/';

    public static const ADD_TO_GROUP:int = 1;      // +vstyputu v grypy
    public static const ADD_LEFT_MENU:int = 2;     // +dodatu v live menu na VK
    public static const POST:int = 3;              // +zapostutu na stiny
    public static const CRAFT_PLANT:int = 4;       // zibratu rosluny
    public static const BUILD_BUILDING:int = 5;    // pobydyvatu zdanie
    public static const RAW_PRODUCTS:int = 6;      // zavantajutu na fabriky
    public static const INVITE_FRIENDS:int = 7;    // zaprosutu dryziv
    public static const KILL_LOHMATIC:int = 8;     // zlovutu lohmatuciv
    public static const GRAFT_PRODUCT:int = 9;     // zibratu resurs fabriki
    public static const RAW_PLANT:int = 10;        // posadutu rosluny
    public static const RELEASE_ORDER:int = 11;    // zakaz lavku
    public static const BUY_ANIMAL:int = 12;       // kyputu tvar'
    public static const FEED_ANIMAL:int = 13;      // pogodyvatu tvar'
    public static const REMOVE_WILD:int = 14;      // remove wild
    public static const OPEN_TERRITORY:int = 15;   // open territory
    public static const BUY_CAT:int = 16;          // buy cat
    public static const NIASH_BUYER:int = 17;      // vukonatu zamovlennia niawuka-pokyptsia
    public static const KILL_MOUSE:int = 18;       // zlovutu muwei
    public static const BUY_PAPER:int = 19;        // kyputu v gazeti
    public static const SET_IN_PAPER:int = 20;     // vustavutu v gazety


    private var g:Vars = Vars.getInstance();
    private var _questUI:QuestIconUI;
    private var _userQuests:Array;
    private var _currentOpenedQuestInWO:QuestStructure;
    private var _activeTask:QuestTaskStructure;

    public function ManagerQuest() {
        if (!g.useQuests) return;
        _userQuests = [];
        g.load.loadAtlas('questAtlas', 'questAtlas', addUI);
    }

    public function get userQuests():Array {
        return _userQuests;
    }

    public function addUI():void {
        if (g.user.level >= 5 && g.useQuests) {
            _questUI = new QuestIconUI(openWOList);
        }
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
//        if (g.useQuests) g.directServer.getUserNewQuests(onGetNewQuests);
    }

    private function onGetNewQuests(d:Object):void {
        addQuests(d, true);
        if (_userQuests.length) {
            if (!_questUI.isShow) _questUI.showItAnimate();
        } else {
            if (_questUI.isShow) _questUI.hideItAnimate();
        }
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

    public function checkQuestContPosition():void { if (_questUI) _questUI.checkContPosition(); }
    public function onHideWO():void {
        _currentOpenedQuestInWO = null;
        g.gameDispatcher.removeFromTimer(checkWithTimer);
    }

    public function checkOnClickAtWoQuestItem(t:QuestTaskStructure):void {
        switch (t.typeAction) {
            case ADD_LEFT_MENU:
                if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
                    _activeTask = t;
                    g.socialNetwork.checkLeftMenu();
                }
                break;
            case ADD_TO_GROUP:
                _activeTask = t;
                Link.openURL(g.socialNetwork.urlForAnySocialGroup + t.adds);
                _timer = 3;
                g.gameDispatcher.addToTimer(checkWithTimer);
                break;
            case POST:
                _activeTask = t;
                g.managerWallPost.openWindow(ManagerWallPost.POST_FOR_QUEST, null, 0, DataMoney.SOFT_CURRENCY);
                break;
        }
    }

    private function checkQuestAfterFinishTask(questId:int):void {
        var q:QuestStructure = getUserQuesrById(questId);
        var tasks:Array = q.tasks;
        for (var i:int=0; i<tasks.length; i++) {
            if (!(tasks[i] as QuestTaskStructure).isDone) return;
        }
        q.isDone = true;
        g.directServer.completeUserQuest(q.id, q.idDB, null);
        g.windowsManager.closeAllWindows();
        g.windowsManager.openWindow(WindowsManager.WO_QUEST_AWARD, onGetAward, q);
    }

    private function onGetAward(q:QuestStructure):void {
        if (_userQuests.indexOf(q) > -1) _userQuests.removeAt(_userQuests.indexOf(q));
        g.directServer.getUserQuestAward(q.id, q.idDB, onGetUserQuestAward);
    }

    private function onGetUserQuestAward():void {
//        g.directServer.getUserNewQuests(onGetNewQuests);
    }
    
    public function onActionForTaskType(type:int, adds:Object=null):void {
        if (type == ADD_LEFT_MENU) {
            if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
                if (_activeTask && _activeTask.typeAction == ADD_LEFT_MENU) {
                    _activeTask.upgradeCount();
                    g.directServer.updateUserQuestTask(_activeTask, onUpdateQuestTask);
                    _activeTask = null;
                }
            }
        } else if (type == ADD_TO_GROUP) {
            if (_activeTask && _activeTask.typeAction == ADD_TO_GROUP) {
                _activeTask.upgradeCount();
                g.gameDispatcher.removeFromTimer(checkWithTimer);
                g.directServer.updateUserQuestTask(_activeTask, onUpdateQuestTask);
                _activeTask = null;
            }
        } else if (type == POST) {
            if (_activeTask && _activeTask.typeAction == POST) {
                _activeTask.upgradeCount();
                g.directServer.updateUserQuestTask(_activeTask, onUpdateQuestTask);
                _activeTask = null;
            }
        } else {
            
        }
    }

    private function onUpdateQuestTask(task:QuestTaskStructure):void {
        if (task.isDone) {
            checkQuestAfterFinishTask(task.questId);
        }
    }

    public function checkInGroup():void {
        if (_activeTask) {
            g.socialNetwork.checkIsInSocialGroup(_activeTask.adds);
        } else {
            g.gameDispatcher.removeFromTimer(checkWithTimer);
        }
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
