/**
 * Created by user on 5/13/15.
 */
package manager {
import flash.geom.Matrix;

import map.BackgroundArea;

import map.MatrixGrid;

import mouse.OwnMouse;
import mouse.ToolsModifier;

import starling.core.Starling;
import starling.display.Stage;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

import temp.DataBuildings;
import temp.DataTrees;
import temp.EditorButtonInterface;
import temp.MapEditorInterface;

import utils.FarmDispatcher;

public class Vars {
    private static var _instance:Vars;

    public var starling:Starling;
    public var mainStage:Stage;
    public var stageWidth:int = 1000;
    public var stageHeight:int = 640;
    public var realGameWidth:int = 2048;
    public var realGameHeight:int = 1500;
    public var isDebug:Boolean = true;
    public var showMapEditor:Boolean = true;
    public var showButtonEditor:Boolean = true;
    public var mapEditor:MapEditorInterface;
    public var editorButtons:EditorButtonInterface;
    public var gameDispatcher:FarmDispatcher;

    public var mapAtlas:TextureAtlas;
    public var tempBuildAtlas:TextureAtlas;

    public var cont:Containers;
    public var ownMouse:OwnMouse;
    public var toolsModifier:ToolsModifier;

    public var matrixGrid:MatrixGrid;

    public var background:BackgroundArea;

    public var dataBuilding:DataBuildings;
    public var dataTree:DataTrees;
//    public var selectedBuild:

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
        gameDispatcher = new FarmDispatcher(mainStage);
        cont = new Containers();
        matrixGrid = new MatrixGrid();
        dataBuilding = new DataBuildings();
        dataTree = new DataTrees();
        ownMouse = new OwnMouse();
        toolsModifier = new ToolsModifier();

        continueInitGame();
    }

    private function continueInitGame():void {
        matrixGrid.createMatrix();

        background = new BackgroundArea();

        cont.moveCenterToXY(realGameWidth/2, realGameHeight/2, true);

        if(showMapEditor) {
            mapEditor = new MapEditorInterface();
        }
        if(showButtonEditor) {
            editorButtons = new EditorButtonInterface();
            matrixGrid.drawDebugGrid();
        }

    }


}
}

class SingletonEnforcer{}
