/**
 * Created by user on 5/13/15.
 */
package manager {
import build.WorldObject;

import com.junkbyte.console.Cc;

import data.BuildType;

import hint.FlyMessage;
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
import ui.couponePanel.CouponePanel;
import ui.craftPanel.CraftPanel;
import ui.optionPanel.OptionPanel;
import ui.softHardCurrencyPanel.SoftHardCurrency;

import ui.xpPanel.XPPanel;

import user.User;
import user.UserInventory;

import utils.FarmDispatcher;

import windows.Window;

import windows.ambar.WOAmbar;
import windows.ambar.WOSklad;
import windows.buyCoupone.WOBuyCoupone;
import windows.buyCurrency.WOBuyCurrency;

import windows.buyPlant.WOBuyPlant;
import windows.cave.WOCave;
import windows.dailyBonusWindow.WODailyBonus;
import windows.fabricaWindow.WOFabrica;
import windows.levelUp.WOLevelUp;
import windows.market.WOMarket;
import windows.noResources.WONoResources;
import windows.orderWindow.WOOrder;
import windows.paperWindow.WOPaper;
import windows.shop.WOShop;
import windows.train.WOTrain;

public class Vars {
    private static var _instance:Vars;

    public var starling:Starling;
    public var mainStage:Stage;
    public var stageWidth:int = 1000;
    public var stageHeight:int = 640;
    public var realGameWidth:int = 2048;
    public var realGameHeight:int = 1500;
    public var gameDispatcher:FarmDispatcher;
    public var user:User;
    public var userInventory:UserInventory;
    public var managerDropResources:ManagerDropBonusResource;

    public var socialNetwork:SocialNetwork;
    public var flashVars:Object;
    public var socialNetworkID:int;
    public var isDebug:Boolean = false;
    public var showMapEditor:Boolean = true;
    public var mapEditor:MapEditorInterface;
    public var editorButtons:EditorButtonInterface;
    public var deactivatedAreaManager:DeactivatedAreaManager;

    public var mapAtlas:TextureAtlas;
    public var tempBuildAtlas:TextureAtlas;
    public var plantAtlas:TextureAtlas;
    public var interfaceAtlas:TextureAtlas;
    public var instrumentAtlas:TextureAtlas;
    public var resourceAtlas:TextureAtlas;
    public var treeAtlas:TextureAtlas;
//    public var preloaderAtlas:TextureAtlas;

    public var cont:Containers;
    public var ownMouse:OwnMouse;
    public var toolsModifier:ToolsModifier;

    public var matrixGrid:MatrixGrid;
    public var townArea:TownArea;

    public var background:BackgroundArea;

    public var dataBuilding:DataBuildings;
    public var dataResource:DataResources;
    public var dataRecipe:DataRecipe;
    public var dataAnimal:DataAnimal;
    public var dataLevel:DataLevel;
    public var selectedBuild:WorldObject;

    public var timerHint:TimerHint;
    public var wildHint:WildHint;
    public var hint:Hint;
    public var farmHint:FarmHint;
    public var mouseHint:MouseHint;
    public var fabricHint:FabricHint;
    public var treeHint:TreeHint;
    public var resourceHint:ResourceHint;
    public var flyMessage:FlyMessage;
    public var xpPanel:XPPanel;
    public var softHardCurrency:SoftHardCurrency;
    public var couponePanel:CouponePanel;
    public var bottomPanel:MainBottomPanel;
    public var craftPanel:CraftPanel;
    public var optionPanel:OptionPanel;

    public var currentOpenedWindow:Window;
    public var woBuyPlant:WOBuyPlant;
    public var woFabrica:WOFabrica;
    public var woAmbar:WOAmbar;
    public var woSklad:WOSklad;
    public var woShop:WOShop;
    public var woLevelUp:WOLevelUp;
    public var woBuyCoupone:WOBuyCoupone;
    public var woNoResources:WONoResources;
    public var woBuyCurrency:WOBuyCurrency;
    public var woOrder:WOOrder;
    public var woMarket:WOMarket;
    public var woCave:WOCave;
    public var woDailyBonus:WODailyBonus;
    public var woPaper:WOPaper;
    public var woTrain:WOTrain;

    public var server:Server;
    public var directServer:DirectServer;
    public var useHttps:Boolean;
    public var startPreloader:StartPreloader;
    public var useDataFromServer:Boolean;
    public var dataPath:DataPath;

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

        dataBuilding = new DataBuildings();
        dataRecipe = new DataRecipe();
        dataResource = new DataResources();
        dataAnimal = new DataAnimal();
        dataLevel = new DataLevel();

        user = new User();
        userInventory = new UserInventory();
        gameDispatcher = new FarmDispatcher(mainStage);

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
        directServer.getDataLevel(onDataLevel);
    }

    private function onDataLevel():void {
        directServer.getUserInfo(onUserInfo);
        startPreloader.setProgress(90);
    }

    private function onUserInfo():void {
        directServer.getDataAnimal(onDataAnimal);
        startPreloader.setProgress(92);
    }

    private function onDataAnimal():void {
        directServer.getDataRecipe(onDataRecipe);
        startPreloader.setProgress(94);
    }

    private function onDataRecipe():void {
        directServer.getDataResource(onDataResource);
        startPreloader.setProgress(96);
    }

    private function onDataResource():void {
        directServer.getDataBuilding(onDataBuilding);
        startPreloader.setProgress(98);
    }

    private function onDataBuilding():void {
        directServer.getUserResource(onUserResource);
    }

    private function onUserResource():void {
        directServer.getUserBuilding(onUserBuilding);
    }

    private function onUserBuilding():void {
        initVariables2();
    }

    private function initVariables2():void {
        startPreloader.setProgress(100);
        startPreloader.hideIt();
        startPreloader = null;

        (user as User).checkUserLevel();
        matrixGrid = new MatrixGrid();
        ownMouse = new OwnMouse();
        toolsModifier = new ToolsModifier();
        timerHint = new TimerHint();
        wildHint = new WildHint();
        hint = new Hint();
        farmHint = new FarmHint();
        mouseHint = new MouseHint();
        fabricHint = new FabricHint();
        treeHint = new TreeHint();
        resourceHint = new ResourceHint();
        flyMessage = new FlyMessage();
        xpPanel = new XPPanel();
        couponePanel = new CouponePanel();
        softHardCurrency = new SoftHardCurrency();
        bottomPanel = new MainBottomPanel();
        craftPanel = new CraftPanel();
        optionPanel = new OptionPanel();
        woCave = new WOCave();
        woTrain = new WOTrain();

        continueInitGame();
    }

    private function continueInitGame():void {
        matrixGrid.createMatrix();
        townArea = new TownArea();
        toolsModifier.setTownArray();

        background = new BackgroundArea();

        cont.moveCenterToXY(0, realGameHeight/2 + matrixGrid.offsetY, true);

        if(showMapEditor) {
            mapEditor = new MapEditorInterface();
            editorButtons = new EditorButtonInterface();
            matrixGrid.drawDebugGrid();
            deactivatedAreaManager = new DeactivatedAreaManager();
        }

        woNoResources = new WONoResources();
        woBuyPlant = new WOBuyPlant();
        woFabrica = new WOFabrica();
        woAmbar = new WOAmbar();
        woSklad = new WOSklad();
        woShop = new WOShop();
        woLevelUp = new WOLevelUp();
        woBuyCoupone = new WOBuyCoupone();
        woBuyCurrency = new WOBuyCurrency();
        woOrder = new WOOrder();
        woMarket = new WOMarket();
        woDailyBonus = new WODailyBonus();
        woPaper = new WOPaper();

        managerDropResources = new ManagerDropBonusResource();

        if (!useDataFromServer) temporaryFillUserInventory();

        Cc.addSlashCommand("openMapEditor", openMapEditorInterface);
        Cc.addSlashCommand("closeMapEditor", closeMapEditorInterface);
    }

    private function openMapEditorInterface():void {
        cont.interfaceContMapEditor.visible = true;
    }

    private function closeMapEditorInterface():void {
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
}
}

class SingletonEnforcer{}
