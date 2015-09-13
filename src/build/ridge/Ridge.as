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
        _source.endClickCallback = onEndClick;
        _source.startClickCallback = onStartClick;
        _source.outCallback = onOut;
        _source.releaseContDrag = true;
        _isOnHover = false;

        _craftSprite = new Sprite();
        _source.addChild(_craftSprite);
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.GREEN, 10, 2, 1);
        if (_stateRidge == EMPTY && g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
            fillPlant(g.dataResource.objectResources[g.toolsModifier.plantId]);
            checkFreeRidges();
        } else {
            if (g.toolsModifier.modifierType != ToolsModifier.NONE) return;
            _isOnHover = true;
            _count = 10;
            _countMouse = 5;
            if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                g.gameDispatcher.addEnterFrame(countEnterFrame);
            }
            g.gameDispatcher.addEnterFrame(countMouseEnterFrame);
        }
    }

    private function onStartClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED) {
            if (g.toolsModifier.plantId <= 0) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                return;
            }
            g.toolsModifier.activatePlantState = true;
            fillPlant(g.dataResource.objectResources[g.toolsModifier.plantId]);
            _source.filter = null;
            checkFreeRidges();
        }
    }

    private function onEndClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            g.townArea.moveBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED) {
            g.toolsModifier.activatePlantState = false;
            checkFreeRidges();
//            if (_stateRidge == EMPTY) {
//                if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
//                    g.toolsModifier.modifierType = ToolsModifier.NONE;
//                    if (g.toolsModifier.plantId <= 0) {
//                        g.toolsModifier.modifierType = ToolsModifier.NONE;
//                        return;
//                    }
//                    fillPlant(g.dataResource.objectResources[g.toolsModifier.plantId]);
//                    _source.filter = null;
//                    checkFreeRidges();
//                    return;
//                }
//            } else {
//                g.toolsModifier.modifierType = ToolsModifier.NONE;
//            }
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
                g.mouseHint.hideHintMouse();
                g.woBuyPlant.showItWithParams(this, onBuy);
            } else if (_stateRidge == GROWED) {
                if (g.userInventory.currentCountInAmbar >= g.user.ambarMaxCount - 1) {
                    _isOnHover = false;
                    g.mouseHint.hideHintMouse();
                    g.gameDispatcher.addEnterFrame(countMouseEnterFrame);
                    g.woAmbarFilled.showAmbarFilled(true);
                    return;
                }
                _stateRidge = EMPTY;
                _plant.checkStateRidge();
                _resourceItem = new ResourceItem();
                _resourceItem.fillIt(_dataPlant);
                var f1:Function = function():void {
                    if (g.useDataFromServer) g.managerPlantRidge.onCraft(_plant.idFromServer);
                    _plant = null;
                };
                var item:CraftItem = new CraftItem(0, 0, _resourceItem, _craftSprite, 2, f1);
                item.flyIt();
                onOut();
//
                g.mouseHint.hideHintMouse();
            }
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function onBuy():void {
        g.toolsModifier.plantId = _dataPlant.id;
        g.toolsModifier.modifierType = ToolsModifier.PLANT_SEED;
        checkFreeRidges();
    }

    private function checkFreeRidges():void {
        var arr:Array = g.townArea.cityObjects;
        var b:Boolean = false;
        var i:int;
        for (i=0; i<arr.length; i++) {  // check if there are at least one EMPTY ridge
            if (arr[i] is Ridge) {
                if (arr[i].stateRidge == EMPTY) {
                    b = true;
                    break;
                }
            }
        }

        if (b) {
            if (g.userInventory.getCountResourceById(g.toolsModifier.plantId) <= 0) b = false;  // cehak if there are at least one current resource for plant
        }

        if (!b) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        }
    }


    private function onOut():void {
        _source.filter = null;
        _isOnHover = false;
        g.mouseHint.hideHintMouse();
        g.timerHint.hideIt();
//        if (g.toolsModifier.modifierType != ToolsModifier.NONE) return;
//        g.gameDispatcher.addEnterFrame(countEnterFrame);
//        g.gameDispatcher.addEnterFrame(countMouseEnterFrame);
    }

    public function fillPlant(data:Object, isFromServer:Boolean = false, timeWork:int = 0):void {
        if (_stateRidge != EMPTY) {
            Cc.error('Try to plant already planted ridge');
            return;
        }
        _stateRidge = GROW1;
        if (!isFromServer && !g.userInventory.checkResource(data,1)) return;
        if (!isFromServer) g.userInventory.addResource(data.id, -1);
        _dataPlant = data;
        _plant = new PlantOnRidge(this, _dataPlant);
        if (timeWork < _dataPlant.buildTime) {
            _plant.checkTimeGrowing(timeWork);
            _plant.activateRender();
            _plant.checkStateRidge(false);
        } else {
            _stateRidge = GROWED;
            _plant.checkStateRidge();
        }

        if (!isFromServer) {
            var f1:Function = function(s:String):void {
                _plant.idFromServer = s;
            };
            g.directServer.rawPlantOnRidge(_dataPlant.id, _dbBuildingId, f1);
            var p:Point = new Point(_source.x, _source.y);
            p = _source.parent.localToGlobal(p);
            var rawItem:RawItem = new RawItem(p, g.plantAtlas.getTexture(_dataPlant.imageShop), 1, 0);
        }
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
                } else if (_stateRidge == GROWED) {
                    g.mouseHint.checkMouseHint(MouseHint.SERP);
                }
            }
            if(_isOnHover == false){
             g.gameDispatcher.removeEnterFrame(countMouseEnterFrame);
            }
        }
    }

    public function get plant():PlantOnRidge {
        return _plant;
    }
}
}
