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
    private var _plantSprite:Sprite;
    private var _stateRidge:int;
    private var _isOnHover:Boolean;
    private var _count:int;
    private var _countMouse:int;
    private var _bgClicked:CSprite;

    public function Ridge(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for Ridge');
            g.woGameError.showIt();
            return;
        }
        createBuild(false);
        _stateRidge = EMPTY;

        _source.removeMainListener();
        _isOnHover = false;

        _bgClicked = new CSprite();
        var tempSprite:Sprite = new Sprite();
        var q:Quad = new Quad(120, 120, Color.BLACK);
        q.rotation = Math.PI / 4;
        q.alpha = 0;
        q.y = -45;
        tempSprite.addChild(q);
        q = new Quad(120, 120, Color.BLACK);
        q.rotation = Math.PI / 4;
        q.alpha = 0;
        tempSprite.addChild(q);
        tempSprite.scaleY = .5;
        tempSprite.flatten();
        _bgClicked.addChild(tempSprite);
        _source.addChild(_bgClicked);

        if (!g.isAway) {
            _bgClicked.hoverCallback = onHover;
            _bgClicked.endClickCallback = onEndClick;
            _bgClicked.startClickCallback = onStartClick;
            _bgClicked.outCallback = onOut;
        }
        _bgClicked.releaseContDrag = true;

        _plantSprite = new Sprite();
        _bgClicked.addChild(_plantSprite);
    }

    override public function isContDrag():Boolean {
        return _bgClicked.isContDrag;
    }

    public function addChildPlant(s:Sprite):void {
        _plantSprite.addChild(s);
    }

    private function onHover():void {
        if (g.isActiveMapEditor || g.isAway) return;
        _source.filter = BlurFilter.createGlow(Color.GREEN, 10, 2, 1);
        if (_stateRidge == EMPTY && g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
            fillPlant(g.dataResource.objectResources[g.toolsModifier.plantId]);
            g.managerPlantRidge.checkFreeRidges();
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
        if (g.isActiveMapEditor || g.isAway) return;
        if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED) {
            if (g.toolsModifier.plantId <= 0 || _stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                return;
            }
            g.toolsModifier.activatePlantState = true;
            fillPlant(g.dataResource.objectResources[g.toolsModifier.plantId]);
            _source.filter = null;
            g.managerPlantRidge.checkFreeRidges();
        }
    }

    private function onEndClick():void {
        if (g.isActiveMapEditor || g.isAway) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3 || _stateRidge == GROWED) {
                g.toolsModifier.ridgeId = _dataPlant.id;
            }
            g.townArea.moveBuild(this,1,_stateRidge);
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED) {
            g.toolsModifier.activatePlantState = false;
            g.managerPlantRidge.checkFreeRidges();
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
                 if (g.userInventory.currentCountInAmbar + 2 > g.user.ambarMaxCount){
                      g.woAmbarFilled.showAmbarFilled(true);
                 } else {
                     _stateRidge = EMPTY;
                     _plant.checkStateRidge();
                     _resourceItem = new ResourceItem();
                     _resourceItem.fillIt(_dataPlant);
                     var f1:Function = function():void {
                         if (g.useDataFromServer) g.managerPlantRidge.onCraft(_plant.idFromServer);
                         _plant = null;
                     };
                     var item:CraftItem = new CraftItem(0, 0, _resourceItem, _plantSprite, 2, f1);
                     item.flyIt();
                     onOut();

                     g.mouseHint.hideHintMouse();
                 }
            }
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function onBuy():void {
        g.toolsModifier.plantId = _dataPlant.id;
        g.toolsModifier.modifierType = ToolsModifier.PLANT_SEED;
        g.managerPlantRidge.checkFreeRidges();
    }

    private function onOut():void {
        if (g.isActiveMapEditor || g.isAway) return;
        _source.filter = null;
        _isOnHover = false;
        g.mouseHint.hideHintMouse();
//        g.timerHint.hideIt();
        g.gameDispatcher.addEnterFrame(countEnterFrame);

    }

    public function fillPlant(data:Object, isFromServer:Boolean = false, timeWork:int = 0):void {
        if (_stateRidge != EMPTY) {
            Cc.error('Try to plant already planted ridge');
            return;
        }
        if (!data) {
            Cc.error('no data for fillPlant at Ridge');
            g.woGameError.showIt();
            return;
        }

        _stateRidge = GROW1;
        if (!isFromServer) g.userInventory.addResource(data.id, -1);
        if (!isFromServer) g.toolsModifier.updateCountTxt();
        _dataPlant = data;
        _plant = new PlantOnRidge(this, _dataPlant);
        if (timeWork < _dataPlant.buildTime) {
            _plant.checkTimeGrowing(timeWork);
            if (!g.isAway) {
                _plant.activateRender();
                g.managerPlantRidge.addCatForPlant(_dataPlant.id, this);
            }
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
            var rawItem:RawItem = new RawItem(p, g.allData.atlas[_dataPlant.url].getTexture(_dataPlant.imageShop), 1, 0);
        }
    }

    public function get stateRidge():int {
        return _stateRidge;
    }

    public function set stateRidge(a:int):void {
        _stateRidge = a;
        if (_stateRidge == GROWED) {
            g.managerPlantRidge.removeCatFromRidge(_dataPlant.id, this);
        }
    }

    private function countEnterFrame():void {
        _count--;
        if(_count <=0){
            g.gameDispatcher.removeEnterFrame(countEnterFrame);
            if (_isOnHover == true) {
                if (_plant)
                    g.timerHint.showIt(g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + _source.y * g.currentGameScale, _plant.getTimeToGrowed(), _dataPlant.priceSkipHard, _dataPlant.name,callbackSkip);
            }
            if (_isOnHover == false) {
                _source.filter = null;
                g.timerHint.hideIt();
            }
        }
    }

    public function countMouseEnterFrame():void {
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
                _source.filter = null;
                g.timerHint.hideIt();
             g.gameDispatcher.removeEnterFrame(countMouseEnterFrame);
            }
        }
    }

    public function get plant():PlantOnRidge {
        return _plant;
    }

    override public function clearIt():void {
        _bgClicked.touchable = false;
        while (_bgClicked.numChildren) _bgClicked.removeChildAt(0);
        while (_plantSprite.numChildren) _plantSprite.removeChildAt(0);
        if (_plant) _plant.clearIt();
        _plant = null;
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

    private function callbackSkip():void {
        _stateRidge = GROWED;
        g.managerPlantRidge.removeCatFromRidge(_dataPlant.id, this);
//        _plant.checkStateRidge();
        _plant.render();
    }

    public function lockIt(v:Boolean):void {
        if (v) {
            if (_stateRidge != EMPTY) {
                _bgClicked.isTouchable = false;
            }
        } else {
            _bgClicked.isTouchable = true;
        }
    }
}
}
