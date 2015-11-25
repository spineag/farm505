/**
 * Created by user on 5/13/15.
 */
package manager {
import build.WorldObject;
import build.farm.FarmGrid;

import com.junkbyte.console.Cc;

import dragonBones.animation.WorldClock;

import heroes.HeroCat;
import heroes.ManagerCats;

import hint.ResourceHint;
import hint.TreeHint;
import hint.fabricHint.FabricHint;
import hint.FarmHint;
import hint.Hint;
import hint.MouseHint;
import hint.TimerHint;
import hint.WildHint;

import map.BackgroundArea;
import map.MatrixGrid;
import map.TownArea;

import mouse.OwnMouse;
import mouse.ToolsModifier;

import preloader.StartPreloader;

import server.DirectServer;
import server.NodeServer;
import server.Server;

import social.SocialNetwork;
import social.SocialNetworkEvent;
import social.SocialNetworkSwitch;

import starling.core.Starling;
import starling.display.Stage;
import starling.textures.TextureAtlas;

import temp.dataTemp.DataAnimal;
import temp.dataTemp.DataLevel;
import temp.dataTemp.DataRecipe;
import temp.dataTemp.DataResources;
import temp.dataTemp.DataBuildings;
import temp.deactivatedArea.DeactivatedAreaManager;
import temp.EditorButtonInterface;
import temp.MapEditorInterface;

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

import utils.FarmDispatcher;

import windows.Window;
import windows.ambar.WOAmbars;
import windows.ambarFilled.WOAmbarFilled;
import windows.buyCoupone.WOBuyCoupone;
import windows.buyCurrency.WOBuyCurrency;
import windows.buyForHardCurrency.WOBuyForHardCurrency;
import windows.buyPlant.WOBuyPlant;
import windows.cave.WOCave;
import windows.dailyBonusWindow.WODailyBonus;
import windows.fabricaWindow.WOFabrica;
import windows.gameError.WOGameError;
import windows.lastResource.WOLastResource;
import windows.levelUp.WOLevelUp;
import windows.lockedLand.WOLockedLand;
import windows.market.WOMarket;
import windows.noFreeCats.WONoFreeCats;
import windows.noFreeCats.WOWaitFreeCats;
import windows.noPlaces.WONoPlaces;
import windows.noResources.WONoResources;
import windows.orderWindow.WOOrder;
import windows.paperWindow.WOPaper;
import windows.reloadPage.WOReloadPage;
import windows.shop.WOShop;
import windows.train.WOTrain;
import windows.train.WOTrainOrder;

public class Vars {
    private static var _instance:Vars;

    public var starling:Starling;
    public var mainStage:Stage;
    public var currentGameScale:Number = 1;
    public var stageWidth:int = 1000;
    public var stageHeight:int = 640;
//    public var realGameWidth:int = 2048;
//    public var realGameHeight:int = 1500;
    public var realGameWidth:int = 7600;
    public var realGameHeight:int = 5000;
    public var realGameTilesWidth:int = 6782;
    public var realGameTilesHeight:int = 3400;
    public var gameDispatcher:FarmDispatcher;
    public var user:User;
    public var userInventory:UserInventory;
    public var managerDropResources:ManagerDropBonusResource;

    public var isAway:Boolean = false;
    public var visitedUser:Someone;
    public var isActiveMapEditor:Boolean = false;
    public var socialNetwork:SocialNetwork;
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
    public var load:LoaderManager;
    public var pBitmaps:Object;
    public var managerOrder:ManagerOrder;

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
    public var selectedBuild:WorldObject;

    public var timerHint:TimerHint;
    public var wildHint:WildHint;
    public var hint:Hint;
//    public var farmHint:FarmHint;
    public var mouseHint:MouseHint;
    public var fabricHint:FabricHint;
    public var treeHint:TreeHint;
    public var resourceHint:ResourceHint;
    public var xpPanel:XPPanel;
    public var softHardCurrency:SoftHardCurrency;
    public var couponePanel:CouponePanel;
    public var bottomPanel:MainBottomPanel;
    public var craftPanel:CraftPanel;
    public var optionPanel:OptionPanel;
    public var friendPanel:FriendPanel;
    public var toolsPanel:ToolsPanel;
    public var catPanel:CatPanel;

    public var currentOpenedWindow:Window;
    public var woBuyPlant:WOBuyPlant;
    public var woFabrica:WOFabrica;
    public var woAmbars:WOAmbars;
    public var woShop:WOShop;
    public var woLevelUp:WOLevelUp;
    public var woBuyCoupone:WOBuyCoupone;
    public var woNoResources:WONoResources;
    public var woNoPlaces:WONoPlaces;
    public var woBuyCurrency:WOBuyCurrency;
    public var woOrder:WOOrder;
    public var woMarket:WOMarket;
    public var woCave:WOCave;
    public var woDailyBonus:WODailyBonus;
    public var woPaper:WOPaper;
    public var woTrain:WOTrain;
    public var woAmbarFilled:WOAmbarFilled;
    public var woLastResource:WOLastResource;
    public var woTrainOrder:WOTrainOrder;
    public var woLockedLand:WOLockedLand;
    public var windowsPool:Array;
    public var woGameError:WOGameError;
    public var woNoFreeCats:WONoFreeCats;
    public var woWaitFreeCats:WOWaitFreeCats;
    public var woBuyForHardCurrency:WOBuyForHardCurrency;

    public var server:Server;
    public var directServer:DirectServer;
    public var useHttps:Boolean;
    public var startPreloader:StartPreloader;
    public var useDataFromServer:Boolean;
    public var dataPath:DataPath;

    public var managerCats:ManagerCats;
    public var activeCat:HeroCat;
    public var aStar:AStar;

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
        useDataFromServer = true;
        //server = new Server();
        directServer = new DirectServer();
        dataPath = new DataPath();
        pBitmaps = {};
        load = LoaderManager.getInstance();

        dataBuilding = new DataBuildings();
        dataRecipe = new DataRecipe();
        dataResource = new DataResources();
        dataAnimal = new DataAnimal();
        dataLevel = new DataLevel();

        user = new User();
        userInventory = new UserInventory();
        gameDispatcher = new FarmDispatcher(mainStage);

        windowsPool = [];
        woGameError = new WOGameError();

        matrixGrid = new MatrixGrid();
        matrixGrid.createMatrix();
        townArea = new TownArea();
        farmGrid = new FarmGrid();

        ownMouse = new OwnMouse();
        toolsModifier = new ToolsModifier();
        toolsModifier.setTownArray();

        managerCats = new ManagerCats();
        catPanel = new CatPanel();

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
        socialNetwork.removeEventListener(SocialNetworkEvent.INIT, onSocialNetworkInit);
        socialNetwork.addEventListener(SocialNetworkEvent.GET_PROFILES, authoriseUser);
        socialNetwork.getProfile(socialNetwork.currentUID);
    }

    private function authoriseUser(e:SocialNetworkEvent = null):void {
        socialNetwork.removeEventListener(SocialNetworkEvent.GET_PROFILES, authoriseUser);
        directServer.authUser(onAuthUser);
    }

    private function onAuthUser():void {
        startPreloader.setProgress(87);
        directServer.getDataLevel(onDataLevel);
    }

    private function onDataLevel():void {
        directServer.getUserInfo(onUserInfo);
        startPreloader.setProgress(88);
    }

    private function onUserInfo():void {
        managerCats.addAllHeroCats();
        directServer.getDataAnimal(onDataAnimal);
        startPreloader.setProgress(89);
    }

    private function onDataAnimal():void {
        directServer.getDataResource(onDataResource);
        startPreloader.setProgress(90);
    }

    private function onDataResource():void {
        directServer.getDataRecipe(onDataRecipe);
        startPreloader.setProgress(91);
    }

    private function onDataRecipe():void {
        directServer.getDataCats(onDataCats);
    }

    private function onDataCats():void {
        aStar = new AStar();
        managerCats.calculateMaxCountCats();
        catPanel.checkCat();
        directServer.getDataLockedLand(onDataLockedLand);
    }

    private function onDataLockedLand():void {
        directServer.getDataBuilding(onDataBuilding);
        startPreloader.setProgress(92);
    }

    private function onDataBuilding():void {
        startPreloader.setProgress(93);
        directServer.getUserResource(onUserResource);
    }

    private function onUserResource():void {
        startPreloader.setProgress(94);
        directServer.getUserBuilding(onUserBuilding);
    }

    private function onUserBuilding():void {
        startPreloader.setProgress(95);
        directServer.getUserFabricaRecipe(onUserFabricaRecipe);
    }

    private function onUserFabricaRecipe():void {
        startPreloader.setProgress(96);
        directServer.getUserPlantRidge(onUserPlantRidge);
    }

    private function onUserPlantRidge():void {
        startPreloader.setProgress(97);
        directServer.getUserTree(onUserTree);
    }

    private function onUserTree():void {
        startPreloader.setProgress(98);
        directServer.getUserAnimal(onUserAnimal);
    }

    private function onUserAnimal():void {
        directServer.getUserTrain(onUserTrain);
    }

    private function onUserTrain():void {
        directServer.getUserWild(onUserWild);
    }

    private function onUserWild():void {
        managerOrder = new ManagerOrder();
        directServer.getUserOrder(onUserOrder);
    }

    private function onUserOrder():void {
        startPreloader.setProgress(99);
        (user as User).friendAppUser();
        initVariables2();
    }

    private function initVariables2():void {
        managerCats.setAllCatsToRandomPositions();

        startPreloader.setProgress(100);
        startPreloader.hideIt();
        startPreloader = null;

        (user as User).checkUserLevel();
        timerHint = new TimerHint();
        wildHint = new WildHint();
        hint = new Hint();
//        farmHint = new FarmHint();
        mouseHint = new MouseHint();
        fabricHint = new FabricHint();
        treeHint = new TreeHint();
        resourceHint = new ResourceHint();
        xpPanel = new XPPanel();
        couponePanel = new CouponePanel();
        softHardCurrency = new SoftHardCurrency();
        bottomPanel = new MainBottomPanel();
        craftPanel = new CraftPanel();
        optionPanel = new OptionPanel();
        friendPanel = new FriendPanel();
        toolsPanel = new ToolsPanel();

        continueInitGame();
    }

    private function continueInitGame():void {
        background = new BackgroundArea(afterCreateMapBackground);
    }

    private function afterCreateMapBackground():void {

        if (currentGameScale != 1) {
            optionPanel.makeScaling(currentGameScale, false, true);
        }
        cont.moveCenterToXY(0, realGameTilesHeight/2, true);

        woCave = new WOCave();
        woTrain = new WOTrain();
        woNoResources = new WONoResources();
        woNoPlaces = new WONoPlaces();
        woBuyPlant = new WOBuyPlant();
        woFabrica = new WOFabrica();
        woAmbars = new WOAmbars();
        woShop = new WOShop();
        woLevelUp = new WOLevelUp();
        woBuyCoupone = new WOBuyCoupone();
        woBuyCurrency = new WOBuyCurrency();
        woOrder = new WOOrder();
        woMarket = new WOMarket();
        woDailyBonus = new WODailyBonus();
        woPaper = new WOPaper();
        woAmbarFilled = new WOAmbarFilled();
        woLastResource = new WOLastResource();
        woTrainOrder = new WOTrainOrder();
        woLockedLand = new WOLockedLand();
        woNoFreeCats = new WONoFreeCats();
        woWaitFreeCats = new WOWaitFreeCats();
        woBuyForHardCurrency = new WOBuyForHardCurrency();

        managerDropResources = new ManagerDropBonusResource();
        managerPaper = new ManagerPaper();
        managerPaper.getPaperItems();

        if (!useDataFromServer) temporaryFillUserInventory();

        if ((user as User).isMegaTester) {
            Cc.addSlashCommand("openMapEditor", openMapEditorInterface);
            Cc.addSlashCommand("closeMapEditor", closeMapEditorInterface);
        }

        if ((user as User).isTester) {
            var f1:Function = function():void {
                directServer.deleteUser(f2);
            };
            var f2:Function = function():void {
                new WOReloadPage();
            };
            Cc.addSlashCommand("deleteUser", f1);
        }

        managerOrder.checkOrders();
        gameDispatcher.addEnterFrame(onEnterFrameGlobal);
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
        }
    }

    private function closeMapEditorInterface():void {
        isActiveMapEditor = false;
        matrixGrid.deleteDebugGrid();
        mapEditor.deleteIt();
        cont.interfaceContMapEditor.visible = false;
        toolsModifier.modifierType = ToolsModifier.NONE;
    }

    private function temporaryFillUserInventory():void {
        var k:int;
        var i:int = 50;

        while (i>0) {
            k = int(Math.random()*129) + 1;
            if (dataResource.objectResources[k]) {
                userInventory.addResource(k, 1, false);
            }
            i--;
        }
    }

    public function hideAllHints():void {
        if (timerHint) timerHint.hideIt();
        if (wildHint) wildHint.hideIt();
//        if (farmHint) farmHint.hideIt();
        if (mouseHint) mouseHint.hideHintMouse();
        if (fabricHint) fabricHint.clearIt();
        if (treeHint) treeHint.hideIt();
        if (resourceHint) resourceHint.hideIt();
        if (hint) (hint as Hint).hideIt();
    }
}
}

class SingletonEnforcer{}
