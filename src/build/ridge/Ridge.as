/**
 * Created by user on 6/2/15.
 */
package build.ridge {
import build.AreaObject;

import com.junkbyte.console.Cc;



import hint.TimerHint;

import map.MatrixGrid;

import mouse.ToolsModifier;

import starling.display.BlendMode;

import starling.display.Quad;
import starling.display.Sprite;

import starling.filters.BlurFilter;
import starling.utils.Color;

import utils.CSprite;

public class Ridge extends AreaObject{
    public static const EMPTY:int = 1;
    public static const GROW1:int = 2;
    public static const GROW2:int = 3;
    public static const GROW3:int = 4;
    public static const GROWED:int = 5;

    private var _dataPlant:Object;
    private var _plant:PlantOnRidge;
    private var _stateRidge:int;
    private var _isOnHover:Boolean;
   // private var _openHint:Sprite;

    public function Ridge(_data:Object) {
        super(_data);
        _stateRidge = EMPTY;

        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _isOnHover = false;
//        _openHint = new Sprite();
//        _openHint.x = -93;
//        _openHint.y = MatrixGrid.FACTOR - 155;
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.GREEN, 10, 2, 1);
        _isOnHover = true;
//        var inner:int;
//        if(_stateRidge == GROW1) {
//            inner = _dataPlant.innerPositions[2];
//        }if(_stateRidge == GROW2) {
//            inner = _dataPlant.innerPositions[4];
//        }if(_stateRidge == GROW3) {
//            inner = _dataPlant.innerPositions[6];
//        }
            if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                var f:Function = function():void{
                    if (_isOnHover == true) {
                        g.timerHint.showIt(g.cont.gameCont.x + _source.x, g.cont.gameCont.y + _source.y, _plant.getTimeToGrowed(), _dataPlant.priceSkipHard, _dataPlant.name);
                    }
                    g.gameDispatcher.removeFromTimer(f);
                };
                g.gameDispatcher.addToTimer(f);
        }
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_stateRidge == EMPTY) {
                _source.filter = null;
                g.woBuyPlant.showItWithParams(this);
            } else if (_stateRidge == GROWED) {
                _stateRidge = EMPTY;
                _plant.checkStateRidge();
                _plant = null;
            }
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function onOut():void {

        _isOnHover = false;
        var f:Function = function():void{
            if (_isOnHover == false) {
                _source.filter = null;
                g.timerHint.hideIt();
            }
            g.gameDispatcher.removeFromTimer(f);
            }
        g.gameDispatcher.addToTimer(f);
    }

    public function fillPlant(data:Object):void {
        _stateRidge = GROW1;
        _dataPlant = data;
        _plant = new PlantOnRidge(this, _dataPlant);
    }

    public function get stateRidge():int {
        return _stateRidge;
    }

    public function set stateRidge(a:int):void {
        _stateRidge = a;
    }
}
}
