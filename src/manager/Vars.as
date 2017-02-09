/**
 * Created by user on 5/13/15.
 */
package manager {
import additional.butterfly.ManagerButterfly;
import additional.buyerNyashuk.ManagerBuyerNyashuk;
import additional.lohmatik.ManagerLohmatik;
import additional.mouse.ManagerMouse;

import analytic.AnalyticManager;
import build.TownAreaTouchManager;
import build.WorldObject;
import build.ambar.Ambar;
import build.farm.FarmGrid;
import com.junkbyte.console.Cc;

import data.AllData;
import data.BuildType;
import data.OwnEvent;

import dragonBones.animation.WorldClock;
import heroes.ManagerCats;
import heroes.ManagerOrderCats;
import hint.BuyHint;
import hint.LevelUpHint;
import hint.MarketHint;
import hint.ResourceHint;
import hint.TreeHint;
import hint.fabricHint.FabricHint;
import hint.Hint;
import hint.MouseHint;
import hint.TimerHint;
import hint.WildHint;

import loaders.DataPath;

import loaders.LoadAnimationManager;
import loaders.LoaderManager;
import loaders.allLoadMb.AllLoadMb;

import manager.hitArea.ManagerHitArea;
import map.BackgroundArea;
import map.Containers;
import map.MatrixGrid;
import map.TownArea;

import media.SoundManager;

import mouse.OwnMouse;
import mouse.ToolsModifier;
import preloader.StartPreloader;

import quest.ManagerQuest;

import server.DirectServer;
import server.ManagerPendingRequest;
import server.Server;
import social.SocialNetwork;
import social.SocialNetworkEvent;
import social.SocialNetworkSwitch;
import social.SocialNetworkSwitch;
import starling.core.Starling;
import starling.display.Stage;

import temp.TestTime;

import temp.catCharacters.DataCat;
import temp.dataTemp.DataAnimal;
import temp.dataTemp.DataLevel;
import temp.dataTemp.DataRecipe;
import temp.dataTemp.DataResources;
import temp.dataTemp.DataBuildings;
import temp.deactivatedArea.DeactivatedAreaManager;
import temp.EditorButtonInterface;
import temp.MapEditorInterface;

import tutorial.IManagerTutorial;
import tutorial.ManagerTutorial;
import tutorial.helpers.ManagerHelpers;
import tutorial.managerCutScenes.ManagerCutScenes;
import tutorial.miniScenes.ManagerMiniScenes;
import tutorial.newTuts.ManagerTutorialNew;
import tutorial.tips.ManagerTips;

import ui.bottomInterface.MainBottomPanel;
import ui.catPanel.CatPanel;
import ui.couponePanel.CouponePanel;
import ui.craftPanel.CraftPanel;
import ui.party.PartyPanel;
import ui.friendPanel.FriendPanel;
import ui.optionPanel.OptionPanel;
import ui.softHardCurrencyPanel.SoftHardCurrency;
import ui.stock.StockPanel;
import ui.toolsPanel.ToolsPanel;
import ui.xpPanel.XPPanel;
import user.Someone;
import user.User;
import user.UserInventory;
import user.UserTimer;
import user.UserValidateResources;

import utils.FarmDispatcher;
import windows.WindowsManager;

public class Vars {
    private static var _instance:Vars;
    public const HARD_IN_SOFT:int = 20; // 1 хард стоит 20 софт

    public var starling:Starling;
    public var mainStage:Stage;
    public var scaleFactor:Number;
    public var currentGameScale:Number = 1;
    public var realGameWidth:int = 7468;
    public var realGameHeight:int = 5000;
    public var realGameTilesWidth:int = 6782;
    public var realGameTilesHeight:int = 3400;
    public var isAway:Boolean = false;
    public var visitedUser:Someone;
    public var isActiveMapEditor:Boolean = false;
    public var socialNetwork:SocialNetwork;
    public var isGameLoaded:Boolean = false;
    public var flashVars:Object;
    public var socialNetworkID:int;
    public var isDebug:Boolean = false;
    public var version:Object;

    public var mapEditor:MapEditorInterface;
    public var editorButtons:EditorButtonInterface;
    public var deactivatedAreaManager:DeactivatedAreaManager;
    public var managerFabricaRecipe:ManagerFabricaRecipe;
    public var managerPlantRidge:ManagerPlantRidge;
    public var managerTree:ManagerTree;
    public var managerAnimal:ManagerAnimal;
    public var managerPaper:ManagerPaper;
    public var managerChest:ManagerChest;
    public var lateAction:ManagerLateAction;
    public var loadMb:AllLoadMb;
    public var load:LoaderManager;
    public var loadAnimation:LoadAnimationManager;
    public var pBitmaps:Object;
    public var pXMLs:Object;
    public var pJSONs:Object;
    public var managerOrder:ManagerOrder;
    public var managerOrderCats:ManagerOrderCats;
    public var managerDailyBonus:ManagerDailyBonus;
    public var managerCutScenes:ManagerCutScenes;
    public var managerMiniScenes:ManagerMiniScenes;
    public var managerWallPost:ManagerWallPost;
    public var managerInviteFriend:ManagerInviteFriend;
    public var managerTimerSkip:ManagerTimerSkip;
    public var managerParty:ManagerPartyNew;
    public var cont:Containers;
    public var ownMouse:OwnMouse;
    public var toolsModifier:ToolsModifier;

    public var matrixGrid:MatrixGrid;
    public var townArea:TownArea;
    public var townAreaTouchManager:TownAreaTouchManager;
    public var farmGrid:FarmGrid;
    public var background:BackgroundArea;

    public var allData:AllData;
    public var dataBuilding:DataBuildings;
    public var dataResource:DataResources;
    public var dataRecipe:DataRecipe;
    public var dataAnimal:DataAnimal;
    public var dataLevel:DataLevel;
    public var dataCats:Array;
    public var dataOrderCats:DataCat;

    public var timerHint:TimerHint;
    public var wildHint:WildHint;
    public var hint:Hint;
    public var buyHint:BuyHint;
//    public var farmHint:FarmHint;
    public var mouseHint:MouseHint;
    public var fabricHint:FabricHint;
    public var treeHint:TreeHint;
    public var resourceHint:ResourceHint;
    public var marketHint:MarketHint;
    public var levelUpHint:LevelUpHint;
    public var xpPanel:XPPanel;
    public var softHardCurrency:SoftHardCurrency;
    public var couponePanel:CouponePanel;
    public var bottomPanel:MainBottomPanel;
    public var craftPanel:CraftPanel;
    public var optionPanel:OptionPanel;
    public var friendPanel:FriendPanel;
    public var toolsPanel:ToolsPanel;
    public var catPanel:CatPanel;
    public var stock:StockPanel;
    public var partyPanel:PartyPanel;

    public var windowsManager:WindowsManager;
    public var managerHitArea:ManagerHitArea;
    public var selectedBuild:WorldObject;

    public var server:Server;
    public var directServer:DirectServer;
    public var startPreloader:StartPreloader;
    public var dataPath:DataPath;
    public var event:OwnEvent;

    public var analyticManager:AnalyticManager;
    public var managerCats:ManagerCats;
    public var managerTutorial:IManagerTutorial;
    public var managerButterfly:ManagerButterfly;
    public var managerHelpers:ManagerHelpers;
    public var soundManager:SoundManager;
    public var managerTips:ManagerTips;
    public var gameDispatcher:FarmDispatcher;
    public var user:User;
    public var userInventory:UserInventory;
    public var userValidates:UserValidateResources;
    public var userTimer:UserTimer;
    public var managerDropResources:ManagerDropBonusResource;
    public var managerLohmatic:ManagerLohmatik;
    public var managerBuyerNyashuk:ManagerBuyerNyashuk;
    public var managerMouseHero:ManagerMouse;
    public var managerQuest:ManagerQuest;
    public var managerPendingRequest:ManagerPendingRequest;
    public var managerVisibleObjects:ManagerVisibleObjects;
    public var managerResize:ManagerResize;

//    private var testersArrayTuts:Array = ['191561520', '14663166', '33979940', '201166703', '23038255', '155912975' ,'272989922', '168207096', '8024599',
//        '102042944',  '206512584',  '34667267', '208452662', '201152139', '148154256', '122302536', '82812915', '202427318', '216083575', '382171121'];
    private var testersArrayQuests:Array = ['191561520'];
    public var useNewTuts:Boolean = false;
    public var useQuests:Boolean = false;

    public static function getInstance():Vars {
        if (!_instance) {
            _instance = new Vars(new SingletonEnforcer());
        }
        return _instance;
    }

    public function Vars(se:SingletonEnforcer) {
        if (!se) {
            throw(new Error("use Objects.getInstance() instead!!"));
        }
    }

    public function initInterface():void {
        initVariables();
    }

    private function initVariables():void {
//        try {
            cont.hideAll(true);
            startPreloader.setProgress(77);

            event = new OwnEvent();
            userValidates = new UserValidateResources();

            dataBuilding = new DataBuildings();
            dataRecipe = new DataRecipe();
            dataResource = new DataResources();
            dataAnimal = new DataAnimal();
            dataLevel = new DataLevel();
            dataOrderCats = new DataCat();
            userInventory = new UserInventory();
            userTimer = new UserTimer();
            gameDispatcher = new FarmDispatcher(mainStage);

            townArea = new TownArea();
            farmGrid = new FarmGrid();
            managerDailyBonus = new ManagerDailyBonus();
            socialNetwork = new SocialNetwork(flashVars);
            if (isDebug) {
                socialNetworkID = SocialNetworkSwitch.SN_VK_ID;
            } else {
                socialNetworkID = int(flashVars['channel']);
            }
            SocialNetworkSwitch.init(socialNetworkID, flashVars, isDebug);
            useNewTuts = true;
            if (useNewTuts) {
                managerTutorial = new ManagerTutorialNew();
            } else {
                managerTutorial = new ManagerTutorial();
            }
            managerCutScenes = new ManagerCutScenes();
            managerWallPost = new ManagerWallPost();
            managerInviteFriend = new ManagerInviteFriend();
            managerTimerSkip = new ManagerTimerSkip();
            managerMouseHero = new ManagerMouse();
            managerMiniScenes = new ManagerMiniScenes();

            new ManagerFilters();
            ownMouse = new OwnMouse();
            toolsModifier = new ToolsModifier();
            toolsModifier.setTownArray();

            managerCats = new ManagerCats();
            managerOrderCats = new ManagerOrderCats();
            catPanel = new CatPanel();
            managerChest = new ManagerChest();
            townAreaTouchManager = new TownAreaTouchManager();
            soundManager = new SoundManager();

            socialNetwork.addEventListener(SocialNetworkEvent.INIT, onSocialNetworkInit);
            socialNetwork.init();
//        } catch (e:Error) {
//            Cc.stackch('error', 'initVariables::', 10);
//        }
    }

    private function onSocialNetworkInit(e:SocialNetworkEvent = null):void {
        startPreloader.setProgress(78);
        socialNetwork.removeEventListener(SocialNetworkEvent.INIT, onSocialNetworkInit);
        socialNetwork.addEventListener(SocialNetworkEvent.GET_PROFILES, authoriseUser);
        socialNetwork.getProfile(socialNetwork.currentUID);
    }

    private function authoriseUser(e:SocialNetworkEvent = null):void {
        startPreloader.setProgress(79);
        socialNetwork.removeEventListener(SocialNetworkEvent.GET_PROFILES, authoriseUser);
        directServer.authUser(loadMap);
    }

    private function loadMap():void {
        startPreloader.setProgress(80);
        background = new BackgroundArea(onAuthUser);
    }

    private function onAuthUser():void {
        startPreloader.setProgress(81);
        directServer.getDataOutGameTiles(onGetOutGameTiles);
    }

    private function onGetOutGameTiles():void {
        startPreloader.setProgress(82);
        directServer.getDataLevel(onDataLevel);
    }

    private function onDataLevel():void {
        directServer.getUserInfo(onUserInfo);
        startPreloader.setProgress(83);
    }

    private function onUserInfo():void {
        soundManager.load();
        managerCats.addAllHeroCats();
        startPreloader.setProgress(84);
        if (managerTutorial.isTutorial) {
            loadAnimation.load('animations_json/x1/cat_tutorial', 'tutorialCat', onLoadCatTutorial); // no need for loading this
        } else {
            if ((user as User).level == 3) {
                onLoadCatTutorial();
            } else directServer.getDataAnimal(onDataAnimal);
        }
    }
    
    private function onLoadCatTutorial():void {
        loadAnimation.load('animations_json/x1/cat_tutorial_big', 'tutorialCatBig', onLoadCatTutorialBig);
    }
    
    private function onLoadCatTutorialBig():void {
        directServer.getDataAnimal(onDataAnimal);
    }

    private function onDataAnimal():void {
        directServer.getDataResource(onDataResource);
        startPreloader.setProgress(85);
    }

    private function onDataResource():void {
        directServer.getDataRecipe(onDataRecipe);
        startPreloader.setProgress(86);
    }

    private function onDataRecipe():void {
        startPreloader.setProgress(87);
        directServer.getDataCats(onDataCats);
    }

    private function onDataCats():void {
        directServer.getDataBuyMoney(onDataBuyMoney);
    }

    private function onDataBuyMoney():void {
        startPreloader.setProgress(88);
        managerCats.calculateMaxCountCats();
        catPanel.checkCat();
        directServer.getDataLockedLand(onDataLockedLand);
    }

    private function onDataLockedLand():void {
        directServer.getDataBuilding(onDataBuilding);
        startPreloader.setProgress(89);
    }

    private function onDataBuilding():void {
        startPreloader.setProgress(90);
        directServer.getUserResource(onUserResource);
    }

    private function onUserResource():void {
        startPreloader.setProgress(91);
        directServer.getUserBuilding(onUserBuilding);
//        onUserBuilding();
    }

    private function onUserBuilding():void {
        startPreloader.setProgress(92);
        directServer.getUserFabricaRecipe(onUserFabricaRecipe);
    }

    private function onUserFabricaRecipe():void {
        startPreloader.setProgress(93);
        directServer.getUserPlantRidge(onUserPlantRidge);
    }

    private function onUserPlantRidge():void {
        startPreloader.setProgress(94);
        directServer.getUserTree(onUserTree);
    }

    private function onUserTree():void {
        startPreloader.setProgress(95);
        directServer.getUserAnimal(onUserAnimal);
    }

    private function onUserAnimal():void {
        startPreloader.setProgress(96);
        directServer.getUserTrain(onUserTrain);
    }

    private function onUserTrain():void {
        startPreloader.setProgress(97);
        directServer.getUserWild(onUserWild);
    }

    private function onUserWild():void {
        startPreloader.setProgress(98);
        managerOrder = new ManagerOrder();
        managerOrder.updateMaxCounts();
        directServer.getUserOrder(onUserOrder);
    }

    private function onUserOrder():void {
        managerOrderCats.addCatsOnStartGame();
        startPreloader.setProgress(99);
        (user as User).friendAppUser();
        initVariables2();
    }

    private function initVariables2():void {
//        try {
            if (socialNetworkID == SocialNetworkSwitch.SN_OK_ID ||
                   ( socialNetworkID == SocialNetworkSwitch.SN_VK_ID && (user as User).isTester)) useQuests = true;

            timerHint = new TimerHint();
            wildHint = new WildHint();
            hint = new Hint();
            buyHint = new BuyHint();
//        farmHint = new FarmHint();
            mouseHint = new MouseHint();
            fabricHint = new FabricHint();
            treeHint = new TreeHint();
            resourceHint = new ResourceHint();
            marketHint = new MarketHint();
            levelUpHint = new LevelUpHint();
            xpPanel = new XPPanel();
            couponePanel = new CouponePanel();
            softHardCurrency = new SoftHardCurrency();
            bottomPanel = new MainBottomPanel();
            craftPanel = new CraftPanel();
            optionPanel = new OptionPanel();
            friendPanel = new FriendPanel();
            toolsPanel = new ToolsPanel();
            if ((user as User).level >= 6) {
                managerParty = new ManagerPartyNew();
                directServer.getDataParty(null);
            }
            if ((user as User).level >= 5 && socialNetworkID == SocialNetworkSwitch.SN_VK_ID) stock = new StockPanel();
            managerQuest = new ManagerQuest();
//        } catch (e:Error) {
//            Cc.stackch('error', 'initVariables2::', 10);
//        }
        afterLoadAll();
    }

    public function party():void {
        partyPanel = new PartyPanel();
        if (!windowsManager.currentWindow) windowsManager.openWindow(WindowsManager.WO_PARTY,null);
    }

import build.WorldObject;
import build.ambar.Ambar;

import com.junkbyte.console.Cc;

import dragonBones.animation.WorldClock;

import temp.TestTime;

private function afterLoadAll():void {
//        try {
            var test:TestTime = new TestTime();
            cont.onLoadAll();
            startPreloader.setProgress(100);
            if (currentGameScale != 1) {
                optionPanel.makeScaling(currentGameScale, false, true);
            }
            cont.moveCenterToXY(0, realGameTilesHeight / 2 - 400 * scaleFactor, true);

            windowsManager = new WindowsManager();
            managerDropResources = new ManagerDropBonusResource();
            managerPaper = new ManagerPaper();
            managerPaper.getPaperItems();
            managerCats.setAllCatsToRandomPositions();
            managerDailyBonus.checkDailyBonusStateBuilding();
            lateAction = new ManagerLateAction();
            isGameLoaded = true;

            if ((user as User).isMegaTester) {
                Cc.addSlashCommand("openMapEditor", openMapEditorInterface);
                Cc.addSlashCommand("closeMapEditor", closeMapEditorInterface);
            }

            if ((user as User).isTester) {
                var f1:Function = function ():void {
                    directServer.deleteUser(f2);
                };
                var f2:Function = function ():void {
                    windowsManager.openWindow(WindowsManager.WO_RELOAD_GAME);
                };
                Cc.addSlashCommand("deleteUser", f1);
            }

            softHardCurrency.checkHard();
            softHardCurrency.checkSoft();
            xpPanel.checkXP();
            managerOrder.checkOrders();
            gameDispatcher.addEnterFrame(onEnterFrameGlobal);
            updateAmbarIndicator();
            townArea.zSort();
            townArea.decorTailSort();
            townArea.sortAtLockedLands();
            managerOrder.checkForFullOrder();
            if ((user as User).level >= dataBuilding.objectBuilding[45].blockByLevel) managerDailyBonus.generateDailyBonusItems();
            townArea.addTownAreaSortCheking();

            managerHelpers = new ManagerHelpers();
            managerPendingRequest = new ManagerPendingRequest();
            managerChest.createChest();
            managerVisibleObjects = new ManagerVisibleObjects();
            managerVisibleObjects.checkInStaticPosition();
            if (managerTutorial.isTutorial) {
                if ((user as User).tutorialStep > 1) {
                    startPreloader.hideIt();
                    startPreloader = null;
                }
                managerOrder.showSmallHeroAtOrder(false);
                managerTutorial.onGameStart();
                managerTutorial.checkDefaults();
            } else {
                startPreloader.hideIt();
                startPreloader = null;
                managerCutScenes.checkAvailableCutScenes();
                managerMiniScenes.checkAvailableMiniScenesOnNewLevel();
                var todayDailyGift:Date;
                var today:Date;
               if ((socialNetworkID == SocialNetworkSwitch.SN_OK_ID)) {
//                   if ((user as User).userSocialId == '252433337505') {
//                       windowsManager.openWindow(WindowsManager.WO_STARTER_PACK, null);
//                   }
                   if ((user as User).level >= 5 && (user as User).dayDailyGift == 0) directServer.getDailyGift(null);
                   else {
                       todayDailyGift = new Date((user as User).dayDailyGift * 1000);
                       today = new Date((user as User).day * 1000);
                       if ((user as User).level >= 5 && todayDailyGift.date != today.date) {
                           directServer.getDailyGift(null);
                       } else {
                           managerCats.helloCats();
                       }
                   }
               } else {
                    if (((user as User).level >= 6) && ((user as User).starterPack == 0)) {
                        windowsManager.openWindow(WindowsManager.WO_STARTER_PACK, null);
                    } else {
                        if ((user as User).level >= 5 && (user as User).dayDailyGift == 0) directServer.getDailyGift(null);
                        else {
                            todayDailyGift = new Date((user as User).dayDailyGift * 1000);
                            today = new Date((user as User).day * 1000);
                            if ((user as User).level >= 5 && todayDailyGift.date != today.date) {
                                directServer.getDailyGift(null);
                            } else managerCats.helloCats();
                        }
                    }
                }
            }
            managerMiniScenes.updateMiniScenesLengthOnGameStart();
            managerButterfly = new ManagerButterfly();
            managerButterfly.createBFlyes();
            managerButterfly.startButterflyFly();
            managerLohmatic = new ManagerLohmatik();
            if ((user as User).level >= 5) managerBuyerNyashuk = new ManagerBuyerNyashuk();

            analyticManager = new AnalyticManager();
            analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.ACTION_ON_LOAD_GAME, {id: 1});
//        } catch (e:Error) {
//            Cc.stackch('error', 'afterAllLoaded::', 10);
//        }
    }

    private function onEnterFrameGlobal():void {
        WorldClock.clock.advanceTime(-1);
    }

    private function openMapEditorInterface():void {
        if((user as User).isMegaTester) {
            mapEditor = new MapEditorInterface();
            editorButtons = new EditorButtonInterface();
            deactivatedAreaManager = new DeactivatedAreaManager();
            cont.interfaceContMapEditor.visible = true;
            matrixGrid.drawDebugGrid();
            isActiveMapEditor = true;
            townArea.onOpenMapEditor(true);
        }
    }

    private function closeMapEditorInterface():void {
        deactivatedAreaManager.clearIt();
        isActiveMapEditor = false;
        matrixGrid.deleteDebugGrid();
        mapEditor.deleteIt();
        cont.interfaceContMapEditor.visible = false;
        toolsModifier.modifierType = ToolsModifier.NONE;
        townArea.onOpenMapEditor(false);
    }

    public function hideAllHints():void {
        if (timerHint) timerHint.managerHide();
        if (wildHint) wildHint.managerHide();
//        if (farmHint) farmHint.hideIt();
        if (mouseHint) mouseHint.hideIt();
        if (fabricHint) fabricHint.hideIt();
        if (treeHint) treeHint.managerHide();
        if (resourceHint) resourceHint.hideIt();
        if (hint) (hint as Hint).hideIt();
    }

    public function updateAmbarIndicator():void {
        var a:WorldObject = townArea.getCityObjectsByType(BuildType.AMBAR)[0];
        if (a) (a as Ambar).updateIndicatorProgress();
    }

    public function getVersion(st:String):String {
        if (version[st]) return '?v='+version[st];
            else return '';
    }
}
}

class SingletonEnforcer{}
