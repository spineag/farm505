/**
 * Created by user on 5/13/15.
 */
package manager {
import additional.butterfly.ManagerButterfly;

import analytic.AnalyticManager;

import build.BuildTouchManager;

import build.WorldObject;
import build.ambar.Ambar;
import build.farm.FarmGrid;
import com.junkbyte.console.Cc;
import data.BuildType;
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

import manager.hitArea.ManagerHitArea;

import map.BackgroundArea;
import map.MatrixGrid;
import map.TownArea;
import mouse.OwnMouse;
import mouse.ToolsModifier;
import preloader.AwayPreloader;
import preloader.StartPreloader;
import server.DirectServer;
import server.Server;
import social.SocialNetwork;
import social.SocialNetworkEvent;
import social.SocialNetworkSwitch;
import starling.core.Starling;
import starling.display.Stage;
import temp.dataTemp.DataAnimal;
import temp.dataTemp.DataLevel;
import temp.dataTemp.DataRecipe;
import temp.dataTemp.DataResources;
import temp.dataTemp.DataBuildings;
import temp.deactivatedArea.DeactivatedAreaManager;
import temp.EditorButtonInterface;
import temp.MapEditorInterface;
import tutorial.ManagerTutorial;
import tutorial.managerCutScenes.ManagerCutScenes;

import ui.bottomInterface.MainBottomPanel;
import ui.catPanel.CatPanel;
import ui.couponePanel.CouponePanel;
import ui.craftPanel.CraftPanel;
import ui.friendPanel.FriendPanel;
import ui.optionPanel.OptionPanel;
import ui.softHardCurrencyPanel.SoftHardCurrency;
import ui.toolsPanel.ToolsPanel;
import ui.xpPanel.XPPanel;
import user.Someone;
import user.User;
import user.UserInventory;
import user.UserTimer;

import utils.FarmDispatcher;
import windows.WindowsManager;

public class Vars {
    private static var _instance:Vars;
    public const HARD_IN_SOFT:int = 20; // 1 хард стоит 20 софт

    public var starling:Starling;
    public var mainStage:Stage;
    public var scaleFactor:Number;
    public var currentGameScale:Number = 1;
    public var stageWidth:int = 1000;
    public var stageHeight:int = 640;
    public var realGameWidth:int = 7468;
    public var realGameHeight:int = 5000;
    public var realGameTilesWidth:int = 6782;
    public var realGameTilesHeight:int = 3400;
    public var gameDispatcher:FarmDispatcher;
    public var user:User;
    public var userInventory:UserInventory;
    public var userTimer:UserTimer;
    public var managerDropResources:ManagerDropBonusResource;

    public var isAway:Boolean = false;
    public var visitedUser:Someone;
    public var isActiveMapEditor:Boolean = false;
    public var socialNetwork:SocialNetwork;
    public var isGameLoaded:Boolean = false;
    public var flashVars:Object;
    public var socialNetworkID:int;
    public var isDebug:Boolean = false;
    public var mapEditor:MapEditorInterface;
    public var editorButtons:EditorButtonInterface;
    public var deactivatedAreaManager:DeactivatedAreaManager;
    public var managerFabricaRecipe:ManagerFabricaRecipe;
    public var managerPlantRidge:ManagerPlantRidge;
    public var managerTree:ManagerTree;
    public var managerAnimal:ManagerAnimal;
    public var managerPaper:ManagerPaper;
    public var managerChest:ManagerChest;
    public var load:LoaderManager;
    public var loadAnimation:LoadAnimationManager;
    public var pBitmaps:Object;
    public var pXMLs:Object;
    public var managerOrder:ManagerOrder;
    public var managerOrderCats:ManagerOrderCats;
    public var managerDailyBonus:ManagerDailyBonus;
    public var managerCutScenes:ManagerCutScenes;
    public var managerWallPost:ManagerWallPost;
    public var managerInviteFriend:ManagerInviteFriend;
    public var cont:Containers;
    public var ownMouse:OwnMouse;
    public var toolsModifier:ToolsModifier;

    public var matrixGrid:MatrixGrid;
    public var townArea:TownArea;
    public var farmGrid:FarmGrid;
    public var background:BackgroundArea;

    public var allData:AllData;
    public var dataBuilding:DataBuildings;
    public var dataResource:DataResources;
    public var dataRecipe:DataRecipe;
    public var dataAnimal:DataAnimal;
    public var dataLevel:DataLevel;
    public var dataCats:Array;

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

    public var windowsManager:WindowsManager;
    public var managerHitArea:ManagerHitArea;
    public var buildTouchManager:BuildTouchManager;
    public var selectedBuild:WorldObject;
    public var currentInteractiveBuild:WorldObject;

    public var server:Server;
    public var directServer:DirectServer;
    public var useHttps:Boolean;
    public var startPreloader:StartPreloader;
    public var useDataFromServer:Boolean;
    public var dataPath:DataPath;
    public var event:OwnEvent;

    public var analyticManager:AnalyticManager;
    public var managerCats:ManagerCats;
    public var aStar:AStar;
    public var managerTutorial:ManagerTutorial;
    public var managerButterfly:ManagerButterfly;

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
        startPreloader.setProgress(77);

        event = new OwnEvent();
        useDataFromServer = true;
        directServer = new DirectServer();

        dataBuilding = new DataBuildings();
        dataRecipe = new DataRecipe();
        dataResource = new DataResources();
        dataAnimal = new DataAnimal();
        dataLevel = new DataLevel();

        userInventory = new UserInventory();
        userTimer = new UserTimer();
        gameDispatcher = new FarmDispatcher(mainStage);

        matrixGrid = new MatrixGrid();
        matrixGrid.createMatrix();
        townArea = new TownArea();
        farmGrid = new FarmGrid();
        managerDailyBonus = new ManagerDailyBonus();
        managerTutorial = new ManagerTutorial();
        managerHitArea = new ManagerHitArea();
        managerCutScenes = new ManagerCutScenes();
        managerWallPost = new ManagerWallPost();
        managerInviteFriend = new ManagerInviteFriend();

        new ManagerFilters();
        ownMouse = new OwnMouse();
        toolsModifier = new ToolsModifier();
        toolsModifier.setTownArray();

        aStar = new AStar();
        managerCats = new ManagerCats();
        managerOrderCats = new ManagerOrderCats();
        catPanel = new CatPanel();
        managerChest = new ManagerChest();

        if (useDataFromServer) {
            socialNetwork = new SocialNetwork(flashVars);
            socialNetworkID = SocialNetworkSwitch.SN_VK;
            SocialNetworkSwitch.init(socialNetworkID, flashVars, isDebug);
            socialNetwork.addEventListener(SocialNetworkEvent.INIT, onSocialNetworkInit);
            socialNetwork.init();
        } else {
            dataLevel.fillDataLevels();
            dataAnimal.fillDataAnimal();
            dataRecipe.fillDataRecipe();
            dataBuilding.fillDataBuilding();
            dataResource.fillDataResources();
            initVariables2();
        }
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
        managerCats.addAllHeroCats();
        directServer.getDataAnimal(onDataAnimal);
        startPreloader.setProgress(84);
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
        afterLoadAll();
    }

    private function afterLoadAll():void {
        startPreloader.setProgress(100);
        if (currentGameScale != 1) {
            optionPanel.makeScaling(currentGameScale, false, true);
        }
        cont.moveCenterToXY(0, realGameTilesHeight/2 - 400*scaleFactor, true);

        windowsManager = new WindowsManager();
        managerDropResources = new ManagerDropBonusResource();
        managerPaper = new ManagerPaper();
        managerPaper.getPaperItems();
        managerCats.setAllCatsToRandomPositions();
        managerDailyBonus.checkDailyBonusStateBuilding();
        isGameLoaded = true;

        if ((user as User).isMegaTester) {
            Cc.addSlashCommand("openMapEditor", openMapEditorInterface);
            Cc.addSlashCommand("closeMapEditor", closeMapEditorInterface);
        }

        if ((user as User).isTester) {
            var f1:Function = function():void {
                directServer.deleteUser(f2);
            };
            var f2:Function = function():void {
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
        bottomPanel.checkIsFullOrder();
        if ((user as User).level >= dataBuilding.objectBuilding[45].blockByLevel) managerDailyBonus.generateDailyBonusItems();
        townArea.addTownAreaSortCheking();

        startPreloader.hideIt();
        startPreloader = null;

        managerChest.createChest();
        if (managerTutorial.isTutorial) {
            managerTutorial.initScenes();
            managerTutorial.checkDefaults();
        } else {
            managerCutScenes.checkAvailableCutScenes();
        }

        buildTouchManager = new BuildTouchManager();

        managerButterfly = new ManagerButterfly();
        managerButterfly.createBFlyes();
        managerButterfly.startButterflyFly();

        analyticManager = new AnalyticManager();
        analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.ACTION_ON_LOAD_GAME, {id:1});
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
}
}

class SingletonEnforcer{}
