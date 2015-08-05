/**
 * Created by user on 6/2/15.
 */
package build.ridge {
import build.AreaObject;

import com.junkbyte.console.Cc;

import flash.geom.Point;

import hint.MouseHint;


import hint.TimerHint;

import map.MatrixGrid;

import mouse.ToolsModifier;

import resourceItem.CraftItem;
import resourceItem.RawItem;
import resourceItem.ResourceItem;

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
    private var _resourceItem:ResourceItem;
    private var _plant:PlantOnRidge;
    private var _stateRidge:int;
    private var _isOnHover:Boolean;
    private var _count:int;
    private var _countMouse:int;

   // private var _openHint:Sprite;

    public function Ridge(_data:Object) {
        super(_data);
        createBuild();
        _stateRidge = EMPTY;

        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _isOnHover = false;

        _craftSprite = new Sprite();
        _source.addChild(_craftSprite);
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.GREEN, 10, 2, 1);
        _isOnHover = true;
        _count = 20;
        _countMouse =10;
            if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                g.gameDispatcher.addEnterFrame(countEnterFrame);

        }
        g.gameDispatcher.addEnterFrame(countMouseEnterFrame);
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
                _resourceItem = new ResourceItem();
                _resourceItem.fillIt(_dataPlant);
                var item:CraftItem = new CraftItem(0, 0, _resourceItem, _craftSprite, 2);
                g.mouseHint.hideHintMouse();
            }
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function onOut():void {
        _source.filter = null;
        _isOnHover = false;
        g.gameDispatcher.addEnterFrame(countEnterFrame);
        g.mouseHint.hideHintMouse();
        g.gameDispatcher.addEnterFrame(countMouseEnterFrame);


    }

    public function fillPlant(data:Object):void {
        if (!g.userInventory.checkResource(data,1)) return;
        g.userInventory.addResource(data.id,-1);
        _stateRidge = GROW1;
        _dataPlant = data;
        _plant = new PlantOnRidge(this, _dataPlant);
        var p:Point = new Point(_source.x, _source.y);
        p = _source.parent.localToGlobal(p);
        var rawItem:RawItem = new RawItem(p, g.plantAtlas.getTexture(_dataPlant.imageShop), 1, 0);
    }

    public function get stateRidge():int {
        return _stateRidge;
    }

    public function set stateRidge(a:int):void {
        _stateRidge = a;
    }

    private function countEnterFrame():void {
        _count--;
        if(_count <=0){
            g.gameDispatcher.removeEnterFrame(countEnterFrame);
            if (_isOnHover == true) {
                if (_plant)
                    g.timerHint.showIt(g.cont.gameCont.x + _source.x, g.cont.gameCont.y + _source.y, _plant.getTimeToGrowed(), _dataPlant.priceSkipHard, _dataPlant.name);
            }
            if (_isOnHover == false) {
                _source.filter = null;
                g.timerHint.hideIt();
            }
        }
    }

    private function countMouseEnterFrame():void {
        _countMouse--;
        if(_countMouse <= 0){
            g.gameDispatcher.removeEnterFrame(countMouseEnterFrame);
            if (_isOnHover == true) {
                if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                    g.mouseHint.checkMouseHint(MouseHint.CLOCK);
                }
                if (_stateRidge == GROWED) {
                    g.mouseHint.checkMouseHint(MouseHint.SERP);
                }
            }
            if(_isOnHover == false){
             g.gameDispatcher.removeEnterFrame(countMouseEnterFrame);
            }
        }
    }
}
}
