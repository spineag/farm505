/**
 * Created by andy on 9/9/16.
 */
package quest {
import build.WorldObject;
import build.ridge.Ridge;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import flash.geom.Point;
import hint.FlyMessage;
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
    public static const RAW_PRODUCT:int = 6;      // zavantajutu na fabriky
    public static const INVITE_FRIENDS:int = 7;    // zaprosutu dryziv
    public static const KILL_LOHMATIC:int = 8;     // zlovutu lohmatuciv
    public static const CRAFT_PRODUCT:int = 9;     // zibratu resurs fabriki abo fermu
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
        if (g.useQuests) g.directServer.getUserNewQuests(onGetNewQuests);
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
        var arrT:Array;
        var arr:Array;
        var i:int;
        var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2 - 50);
        _activeTask = t;
        switch (t.typeAction) {
            case ADD_LEFT_MENU:
                if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
                    g.socialNetwork.checkLeftMenu();
                }
                break;
            case ADD_TO_GROUP:
                Link.openURL(g.socialNetwork.urlForAnySocialGroup + t.adds);
                _timer = 3;
                g.gameDispatcher.addToTimer(checkWithTimer);
                break;
            case POST:
                g.managerWallPost.openWindow(ManagerWallPost.POST_FOR_QUEST, null, 0, DataMoney.SOFT_CURRENCY);
                break;
            case CRAFT_PLANT:
                g.windowsManager.closeAllWindows();
                arrT = g.townArea.getCityObjectsByType(BuildType.RIDGE);
                arr = [];
                for (i=0; i<arrT.length; i++) {
                    if ((arrT[i] as Ridge).isFreeRidge) continue;
                    if (t.resourceId == 0 || (arrT[i] as Ridge).plant.dataPlant.id == t.resourceId) {
                        arr.push(arrT[i]);
                    }
                }
                if (arr.length) {
                    for (i=0; i<arr.length; i++) {
                        (arr[i] as Ridge).showArrow(3);
                    }
                    g.cont.moveCenterToPos((arr[0] as Ridge).posX, (arr[0] as Ridge).posY);
                } else {
                    new FlyMessage(p,'Нету подходящих засеянных грядок');
                }
                break;
            case RAW_PLANT:
                g.windowsManager.closeAllWindows();
                arrT = g.townArea.getCityObjectsByType(BuildType.RIDGE);
                arr = [];
                for (i=0; i<arrT.length; i++) {
                    if ((arrT[i] as Ridge).isFreeRidge) {
                        arr.push(arrT[i]);
                    }
                }
                if (arr.length) {
                    for (i=0; i<arr.length; i++) {
                        (arr[i] as Ridge).showArrow(3);
                    }
                    g.cont.moveCenterToPos((arr[0] as Ridge).posX, (arr[0] as Ridge).posY);
                } else {
                    new FlyMessage(p,'Нету свободных грядок');
                }
                break;
            case BUILD_BUILDING:
                g.windowsManager.closeAllWindows();
                g.bottomPanel.addArrow('shop', 3);
                break;
            case RAW_PRODUCT:
                g.windowsManager.closeAllWindows();
                arrT = g.townArea.getCityObjectsById(g.allData.getFabricaIdForResourceIdFromRecipe(t.resourceId));
                if (arrT.length) {
                    (arrT[0] as WorldObject).showArrow(3);
                    g.cont.moveCenterToPos((arr[0] as WorldObject).posX - 1, (arr[0] as Ridge).posY - 1);
                } else {
                    new FlyMessage(p,'Нужное здание еще не построено');
                }
                break;
            case INVITE_FRIENDS:
                g.windowsManager.closeAllWindows();
                g.socialNetwork.showInviteWindow();
                break;
            case KILL_LOHMATIC:
                g.windowsManager.closeAllWindows();
                g.managerLohmatic.addArrowForLohmatics();
                break;
            case CRAFT_PRODUCT:
                g.windowsManager.closeAllWindows();
                //..
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
        g.directServer.getUserNewQuests(onGetNewQuests);
    }

//    g.managerQuest.onActionForTaskType(ManagerQuest.CRAFT_PRODUCT, {id:(_arrCrafted[0] as CraftItem).resourceId});
    public function onActionForTaskType(type:int, adds:Object=null):void {
        if (!g.useQuests) return;

        var tArr:Array;
        var tasks:Array;
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
        } else if (type == RAW_PLANT || type == CRAFT_PLANT || type == BUILD_BUILDING || type == CRAFT_PRODUCT || type == RAW_PRODUCT
                || type == BUY_ANIMAL || type == FEED_ANIMAL || type == REMOVE_WILD) {
            tArr = getTasksByTypeFromCurrentQuests(type);
            tasks = [];
            for (var i:int=0; i<tArr.length; i++) {
                if ((tArr[i] as QuestTaskStructure).resourceId == adds.id || (tArr[i] as QuestTaskStructure).resourceId == 0) {
                    tasks.push(tArr[i]);
                }
            }
            if (tasks.length) {
                for (i=0; i<tasks.length; i++) {
                    (tasks[i] as QuestTaskStructure).upgradeCount();
                    g.directServer.updateUserQuestTask(tasks[i], onUpdateQuestTask);
                }
            }
        } else if (type == KILL_LOHMATIC || type == KILL_MOUSE || type == INVITE_FRIENDS || type == BUY_CAT || type == RELEASE_ORDER
                || type == NIASH_BUYER || type == OPEN_TERRITORY || SET_IN_PAPER || BUY_PAPER) {
            tArr = getTasksByTypeFromCurrentQuests(type);
            if (tArr.length) {
                for (i=0; i<tArr.length; i++) {
                    (tArr[i] as QuestTaskStructure).upgradeCount();
                    g.directServer.updateUserQuestTask(tArr[i], onUpdateQuestTask);
                }
            }
        }
    }

    private function onUpdateQuestTask(task:QuestTaskStructure):void {
        if (task.isDone && !task.isSavedOnServerAfterFinish) {
            task.onSaveOnServerAfterFinish();
            checkQuestAfterFinishTask(task.questId);
        }
    }
    
    private function getTasksByTypeFromCurrentQuests(type:int):Array {
        var ar:Array = [];
        var arT:Array;
        for (var i:int=0; i<_userQuests.length; i++) {
            arT = (_userQuests[i] as QuestStructure).getTasksByType(type);
            if (arT.length) ar = ar.concat(arT);
        }
        return ar;
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
