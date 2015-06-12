/**
 * Created by user on 5/13/15.
 */
package manager {
import build.WorldObject;

import com.junkbyte.console.Cc;

import hint.Hint;

import hint.TimerHint;

import map.BackgroundArea;
import map.MatrixGrid;
import map.TownArea;

import mouse.OwnMouse;
import mouse.ToolsModifier;

import starling.core.Starling;
import starling.display.Stage;
import starling.textures.TextureAtlas;

import temp.dataTemp.DataRecipe;
import temp.dataTemp.DataResources;
import temp.dataTemp.DataBuildings;
import temp.deactivatedArea.DeactivatedAreaManager;
import temp.EditorButtonInterface;
import temp.MapEditorInterface;

import user.User;

import utils.FarmDispatcher;

import windows.buyPlant.WOBuyPlant;
import windows.fabricaWindow.WOFabrica;

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

    public var isDebug:Boolean = true;
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

    public var cont:Containers;
    public var ownMouse:OwnMouse;
    public var toolsModifier:ToolsModifier;

    public var matrixGrid:MatrixGrid;
    public var townArea:TownArea;

    public var background:BackgroundArea;

    public var dataBuilding:DataBuildings;
    public var dataResource:DataResources;
    public var dataRecipe:DataRecipe;
    public var selectedBuild:WorldObject;

    public var timerHint:TimerHint;
    public var hint:Hint;

    public var woBuyPlant:WOBuyPlant;
    public var woFabrica:WOFabrica;

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
        user = new User();
        gameDispatcher = new FarmDispatcher(mainStage);
        cont = new Containers();
        matrixGrid = new MatrixGrid();
        dataBuilding = new DataBuildings();
        dataRecipe = new DataRecipe();
        dataResource = new DataResources();
        ownMouse = new OwnMouse();
        toolsModifier = new ToolsModifier();
        timerHint = new TimerHint();
        hint = new Hint();

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

        woBuyPlant = new WOBuyPlant();
        woFabrica = new WOFabrica();

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
}
}

class SingletonEnforcer{}
