/**
 * Created by user on 5/13/15.
 */
package manager {
import achievement.ManagerAchievement;

import additional.butterfly.ManagerButterfly;
import additional.buyerNyashuk.ManagerBuyerNyashuk;
import additional.lohmatik.ManagerLohmatik;
import additional.mouse.ManagerMouse;
import analytic.AnalyticManager;
import build.TownAreaTouchManager;
import build.farm.FarmGrid;
import data.AllData;
import data.BuildType;
import data.OwnEvent;
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
import manager.ownError.ErrorConst;
import manager.ownError.OwnErrorManager;
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
import starling.core.Starling;
import starling.display.Stage;
import temp.catCharacters.DataCat;
import temp.dataTemp.DataLevel;
import temp.deactivatedArea.DeactivatedAreaManager;
import temp.EditorButtonInterface;
import temp.MapEditorInterface;
import tutorial.IManagerTutorial;
import tutorial.helpers.ManagerHelpers;
import tutorial.managerCutScenes.ManagerCutScenes;
import tutorial.miniScenes.ManagerMiniScenes;
import tutorial.newTuts.ManagerTutorialNew;
import tutorial.tips.ManagerTips;
import ui.achievementPanel.AchievementPanel;
import ui.bottomInterface.MainBottomPanel;
import ui.catPanel.CatPanel;
import ui.couponePanel.CouponePanel;
import ui.craftPanel.CraftPanel;
import ui.party.PartyPanel;
import ui.friendPanel.FriendPanel;
import ui.optionPanel.OptionPanel;
import ui.sale.SalePanel;
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
import utils.Utils;
import windows.WindowsManager;
import build.WorldObject;
import build.ambar.Ambar;
import com.junkbyte.console.Cc;
import dragonBones.animation.WorldClock;

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
    public var managerSalePack:ManagerSalePack;
    public var managerLanguage:ManagerLanguage;
    public var cont:Containers;
    public var ownMouse:OwnMouse;
    public var toolsModifier:ToolsModifier;

    public var matrixGrid:MatrixGrid;
    public var townArea:TownArea;
    public var townAreaTouchManager:TownAreaTouchManager;
    public var farmGrid:FarmGrid;
    public var background:BackgroundArea;

    public var allData:AllData;
    public var dataLevel:DataLevel;
    public var dataCats:Array;
    public var dataOrderCats:DataCat;

    public var timerHint:TimerHint;
    public var wildHint:WildHint;
    public var hint:Hint;
    public var buyHint:BuyHint;
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
    public var salePanel:SalePanel;
    public var achievementPanel:AchievementPanel;

    public var windowsManager:WindowsManager;
    public var managerHitArea:ManagerHitArea;
    public var selectedBuild:WorldObject;

    public var server:Server;
    public var directServer:DirectServer;
    public var startPreloader:StartPreloader;
    public var dataPath:DataPath;
    public var event:OwnEvent;

    public var errorManager:OwnErrorManager;
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
    public var managerAchievement:ManagerAchievement;

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

    public function startUserLoad():void {
        townArea = new TownArea();
        farmGrid = new FarmGrid();
        dataLevel = new DataLevel();
        userValidates = new UserValidateResources();
        soundManager = new SoundManager();
        userTimer = new UserTimer();
        managerDailyBonus = new ManagerDailyBonus();
        managerChest = new ManagerChest();
        managerMouseHero = new ManagerMouse();
        gameDispatcher = new FarmDispatcher(mainStage);

        loadMap();
    }

    private function loadMap():void {
        startPreloader.setProgress(76);
        background = new BackgroundArea(onLoadMap);
    }

    private function onLoadMap():void {
        startPreloader.setProgress(77);
        directServer.getDataOutGameTiles(onGetOutGameTiles);
    }

    private function onGetOutGameTiles():void {
        startPreloader.setProgress(78);
        directServer.getDataLevel(onDataLevel);
    }

    public function onDataLevel():void {
        directServer.getUserInfo(loadManagerLanguqage);
        startPreloader.setProgress(79);
    }

    private function loadManagerLanguqage():void {
        managerLanguage = new ManagerLanguage(initInterface);
    }

    public function initInterface():void {
        try {
            (user as User).createNeighbor();
            cont.hideAll(true);
            startPreloader.setProgress(80);
            event = new OwnEvent();
            dataOrderCats = new DataCat();
            userInventory = new UserInventory();

            managerTutorial = new ManagerTutorialNew();
            managerCutScenes = new ManagerCutScenes();
            managerWallPost = new ManagerWallPost();
            managerInviteFriend = new ManagerInviteFriend();
            managerTimerSkip = new ManagerTimerSkip();
            managerMouseHero = new ManagerMouse();
            managerMiniScenes = new ManagerMiniScenes();
            managerAchievement = new ManagerAchievement();

            new ManagerFilters();
            ownMouse = new OwnMouse();
            toolsModifier = new ToolsModifier();
            toolsModifier.setTownArray();

            managerCats = new ManagerCats();
            managerOrderCats = new ManagerOrderCats();
            catPanel = new CatPanel();
            townAreaTouchManager = new TownAreaTouchManager();
            achievementPanel = new AchievementPanel();
            initInterface2();

        } catch (e:Error) {
            errorManager.onGetError(ErrorConst.ON_INIT2, true, true);
            Cc.stackch('error', 'initVariables::', 10);
        }
    }

    private function initInterface2():void {
        soundManager.load();
        managerCats.addAllHeroCats();
        managerSalePack = new ManagerSalePack();
        startPreloader.setProgress(81);
        if (managerTutorial.isTutorial) {
            loadAnimation.load('animations_json/x1/cat_tutorial', 'tutorialCat', onLoadCatTutorial); // no need for loading this
        } else {
            if ((user as User).level == 3) {
                onLoadCatTutorial();
            } else directServer.getDataResource(onDataResource);
        }
    }
    
    private function onLoadCatTutorial():void {
        startPreloader.setProgress(82);
        loadAnimation.load('animations_json/x1/cat_tutorial_big', 'tutorialCatBig', onLoadCatTutorialBig);
    }
    
    private function onLoadCatTutorialBig():void {
        startPreloader.setProgress(83);
        directServer.getDataResource(onDataResource);
    }

    private function onDataResource():void {
        directServer.getDataRecipe(onDataRecipe);
        startPreloader.setProgress(84);
    }

    private function onDataRecipe():void {
        directServer.getDataAnimal(onDataAnimal);
        startPreloader.setProgress(85);
    }

    private function onDataAnimal():void {
        startPreloader.setProgress(86);
        directServer.getDataCats(onDataCats);
    }

    private function onDataCats():void {
        directServer.getDataBuyMoney(onDataBuyMoney);
        startPreloader.setProgress(87);
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
//        if (socialNetworkID == SocialNetworkSwitch.SN_OK_ID || ( socialNetworkID == SocialNetworkSwitch.SN_FB_ID && (user as User).isTester) ||
//               ( socialNetworkID == SocialNetworkSwitch.SN_VK_ID && (user as User).isTester)) useQuests = true; // для ТЕСТЕРІВ ОНЛІ ДЛЯ ТЕСТЕРІВ АХТУНГ АХТУНГ АХТУНГ АХТУНГ АХТУНГ АХТНУГ АХТУНГ АХТУНГ
        useQuests = true;
        timerHint = new TimerHint();
        wildHint = new WildHint();
        hint = new Hint();
        buyHint = new BuyHint();
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

        if ((user as User).level >= 5 && userTimer.saleTimerToEnd <= 0 && softHardCurrency.actionON) {
            stock = new StockPanel();
        }
        managerQuest = new ManagerQuest();
//        gameDispatcher.addNextFrameFunction();
        managerParty = new ManagerPartyNew();
        directServer.getDataParty(afterLoadAll);
    }

    private function afterLoadAll():void {
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
        gameDispatcher.addNextFrameFunction(afterLoadAll_2);
    }

    private function afterLoadAll_2():void {
        townArea.zSort();
        townArea.decorTailSort();
        gameDispatcher.addNextFrameFunction(afterLoadAll_3);
    }

    private function afterLoadAll_3():void {
        townArea.sortAtLockedLands();
        managerOrder.checkForFullOrder();
        if ((user as User).level >= allData.getBuildingById(45).blockByLevel[0]) managerDailyBonus.generateDailyBonusItems();
        townArea.addTownAreaSortCheking();

        managerHelpers = new ManagerHelpers();
        managerPendingRequest = new ManagerPendingRequest();
        managerChest.createChest();
        managerVisibleObjects = new ManagerVisibleObjects();
        managerVisibleObjects.checkInStaticPosition();
        gameDispatcher.addNextFrameFunction(afterLoadAll_4);
    }

    private function afterLoadAll_4():void {
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
                if (!(user as User).salePack && userTimer.saleTimerToEnd > 0 && (managerSalePack.dataSale.timeToStart - int(new Date().getTime() / 1000)) <= 0 && (user as User).level >= 6) {
                    windowsManager.openWindow(WindowsManager.WO_SALE_PACK, null, true);
                } else if (((user as User).level >= 6) && ((user as User).starterPack == 0)) {
                   windowsManager.openWindow(WindowsManager.WO_STARTER_PACK, null);
               } else {
                   if ((user as User).level >= 5 && (user as User).dayDailyGift == 0) directServer.getDailyGift(null);
                   else {
                       todayDailyGift = new Date((user as User).dayDailyGift * 1000);
                       today = new Date((user as User).day * 1000);
                       if ((user as User).level >= 5 && todayDailyGift.date != today.date) directServer.getDailyGift(null);
                       else managerCats.helloCats();
                   }
               }
            var f1:Function = function ():void {
                if (!windowsManager.currentWindow && userTimer.partyToEndTimer <= 0 && managerParty.userParty && !managerParty.userParty.showWindow
                        && (managerParty.dataParty.typeParty == 3 || managerParty.dataParty.typeParty == 4)) managerParty.endPartyWindow();
            };
               Utils.createDelay(5,f1);
            }
            if ((user as User).miniScenes[3] == 0) friendPanel.hideIt(true);
            managerMiniScenes.updateMiniScenesLengthOnGameStart();
            managerButterfly = new ManagerButterfly();
            managerButterfly.createBFlyes();
            managerButterfly.startButterflyFly();
            managerLohmatic = new ManagerLohmatik();
            if ((user as User).level >= 5) managerBuyerNyashuk = new ManagerBuyerNyashuk();

            analyticManager = new AnalyticManager();
            analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.ACTION_ON_LOAD_GAME, {id: 1});
    }

    private function onEnterFrameGlobal():void {
        try {
            WorldClock.clock.advanceTime(-1);
        } catch (e:Error) {
            errorManager.onGetError(ErrorConst.WORLD_CLOCK, true);
        }
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

    public function createSaleUi():void {
        salePanel = new SalePanel();
    }
}
}

class SingletonEnforcer{}
