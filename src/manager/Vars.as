/**
 * Created by user on 5/13/15.
 */
package manager {
import flash.geom.Matrix;

import map.BackgroundArea;

import map.MatrixGrid;

import starling.core.Starling;
import starling.display.Stage;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

import utils.FarmDispatcher;

public class Vars {
    private static var _instance:Vars;

    public var starling:Starling;
    public var mainStage:Stage;
    public var stageWidth:int = 1000;
    public var stageHeight:int = 640;
    public var realGameWidth:int = 2000;
    public var realGameHeight:int = 1500;
    public var isDebug:Boolean = true;
    public var gameDispatcher:FarmDispatcher;

    public var mapAtlas:TextureAtlas;

    public var cont:Containers;

    public var matrixGrid:MatrixGrid;

    public var background:BackgroundArea;

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
        cont = new Containers();
        matrixGrid = new MatrixGrid();


        continueInitGame();
    }

    private function continueInitGame():void {
        matrixGrid.createMatrix();

        background = new BackgroundArea();
    }


}
}

class SingletonEnforcer{}
