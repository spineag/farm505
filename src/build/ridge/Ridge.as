/**
 * Created by user on 6/2/15.
 */
package build.ridge {
import build.AreaObject;

import com.junkbyte.console.Cc;

import flash.geom.Point;

import hint.MouseHint;


import hint.TimerHint;

import manager.ManagerFilters;

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

import tutorial.TutorialAction;

import tutorial.TutorialAction;

import tutorial.TutorialAction;

import utils.CSprite;

import windows.WindowsManager;

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
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Ridge');
            return;
        }
        createBuild(false);
        _stateRidge = EMPTY;

        _source.removeMainListener();
        _isOnHover = false;

        _bgClicked = new CSprite();
        var tempSprite:Sprite = new Sprite();
        var q:Quad = new Quad(120 * g.scaleFactor, 120 * g.scaleFactor, Color.BLACK);
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
        if (g.managerTutorial.isTutorial) {
            if (_tutorialCallback == null) return;
            if ((g.managerTutorial.currentAction == TutorialAction.NEW_RIDGE || g.managerTutorial.currentAction == TutorialAction.PLANT_RIDGE) && g.managerTutorial.isTutorialBuilding(this)) {
            } else if (!g.managerTutorial.isTutorialBuilding(this) || _tutorialCallback == null) return;
        }
        if (g.selectedBuild) return;
        if (g.isActiveMapEditor || g.isAway){
            return;
        }
        if(_isOnHover) return;
        _isOnHover = true;
        if (_stateRidge == GROWED) _plant.hoverGrowed();
        _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        if (_stateRidge == EMPTY && g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
            if (g.managerTutorial.isTutorial) return;
            fillPlant(g.dataResource.objectResources[g.toolsModifier.plantId]);
            g.managerPlantRidge.checkFreeRidges();
//            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.PLANT_RIDGE) {
//                if (_tutorialCallback != null) {
//                    _tutorialCallback.apply(null, [this]);
//                }
//            }
        } else {
            if (g.toolsModifier.modifierType != ToolsModifier.NONE) return;
            _count = 10;
            _countMouse = 7;
            if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                g.timerHint.managerHide();
                g.wildHint.managerHide();
                g.treeHint.managerHide();
            }
            g.gameDispatcher.addEnterFrame(countMouseEnterFrame);
        }
    }

    private function onOut():void {
        if (g.isActiveMapEditor || g.isAway) return;
        _source.filter = null;
        _isOnHover = false;
        g.gameDispatcher.addEnterFrame(countMouseEnterFrame);
//        g.mouseHint.hideIt();
//        g.timerHint.hideIt();

    }

    private function onStartClick():void {
        if (g.managerTutorial.isTutorial && (!g.managerTutorial.isTutorialBuilding(this) || _tutorialCallback == null)) return;
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
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.PLANT_RIDGE) {
                if (_tutorialCallback != null) {
                    _tutorialCallback.apply(null, [this]);
                }
            }
        }
    }

    private function onEndClick():void {
        if (g.managerTutorial.isTutorial) {
            if (g.managerTutorial.currentAction == TutorialAction.PLANT_RIDGE && g.managerTutorial.isTutorialBuilding(this)) {
                g.managerTutorial.checkTutorialCallback();
            } else if (g.managerTutorial.currentAction == TutorialAction.NEW_RIDGE) {
//                if (g.selectedBuild != this) return;
            } else if (!g.managerTutorial.isTutorialBuilding(this) || _tutorialCallback == null) return;
        }
        if (g.isActiveMapEditor || g.isAway) return;
        if (g.toolsModifier.modifierType == ToolsModifier.ADD_NEW_RIDGE) {
            onOut();
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (!g.managerTutorial.isTutorial) onOut();
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3 || _stateRidge == GROWED) {
                    g.toolsModifier.ridgeId = _dataPlant.id;
                }
                checkBeforeMove();
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED) {
            g.toolsModifier.activatePlantState = false;
            g.managerPlantRidge.checkFreeRidges();
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
            g.directServer.userBuildingFlip(_dbBuildingId, int(_flip), null);
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                onOut();
                g.timerHint.showIt(50, g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + (_source.y +_source.height/2 -  _plantSprite.height) /*_source.height/10) */* g.currentGameScale, _plant.getTimeToGrowed(), _dataPlant.priceSkipHard, _dataPlant.name,callbackSkip,onOut, true);
            }
            if (_stateRidge == EMPTY) {
                onOut();
                if (g.managerTutorial.isTutorial && _tutorialCallback != null) {
                    hideArrow();
                }
                g.windowsManager.openWindow(WindowsManager.WO_BUY_PLANT, onBuy, this);
            } else if (_stateRidge == GROWED) {
                 if (g.userInventory.currentCountInAmbar + 2 > g.user.ambarMaxCount){
                     _source.filter = null;
                     g.windowsManager.openWindow(WindowsManager.WO_AMBAR_FILLED, null, true);
                 } else {
                     _stateRidge = EMPTY;
                     _plant.onCraftPlant();
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
                 }
                if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.CRAFT_RIDGE) {
                    if (_tutorialCallback != null) {
                        _tutorialCallback.apply(null, [this]);
                    }
                }
            }
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    public function checkBuildRect(isEmpty:Boolean):void {
        if (isEmpty) {
            _rect = _build.getBounds(_build);
        } else {
            _rect = _plantSprite.getBounds(_plantSprite);
        }
    }

    private function onBuy():void {
        g.toolsModifier.plantId = _dataPlant.id;
        g.toolsModifier.modifierType = ToolsModifier.PLANT_SEED;
        g.managerPlantRidge.checkFreeRidges();
        if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.PLANT_RIDGE) {
            if (_tutorialCallback != null) {
                _tutorialCallback.apply(null, [this]);
            }
        }
    }

    public function fillPlant(data:Object, isFromServer:Boolean = false, timeWork:int = 0):void {
        try {
            var b:Boolean = false;
            if (_stateRidge != EMPTY) {
                Cc.error('Try to plant already planted ridge');
                Cc.error(data.name);
                b = true;
                return;
            }
            if (!data) {
                Cc.error('no data for fillPlant at Ridge');
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for fillPlant');
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
                var f1:Function = function (s:String):void {
                    _plant.idFromServer = s;
                };
                g.directServer.rawPlantOnRidge(_dataPlant.id, _dbBuildingId, f1);
                var p:Point = new Point(_source.x, _source.y);
                p = _source.parent.localToGlobal(p);
                var rawItem:RawItem = new RawItem(p, g.allData.atlas['resourceAtlas'].getTexture(_dataPlant.imageShop + '_icon'), 1, 0);
            }

        } catch (e:Error) {
            if (_stateRidge != EMPTY) {
                Cc.error('Try to plant already planted ridge');
                return;
            }
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

    public function countMouseEnterFrame():void {
        _countMouse--;
        if (_countMouse <= 5) {
            if (_isOnHover == true) {
                if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                    g.mouseHint.checkMouseHint(MouseHint.CLOCK);
                } else if (_stateRidge == GROWED) {
                    g.mouseHint.checkMouseHint(MouseHint.SERP);
                    g.gameDispatcher.removeEnterFrame(countMouseEnterFrame);
                }
            }
        }
        if(_countMouse <= 0){
            g.gameDispatcher.removeEnterFrame(countMouseEnterFrame);
            if (_isOnHover == true) {
                if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                    g.timerHint.showIt(50, g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + (_source.y +_source.height/2 -  _plantSprite.height) /*_source.height/10) */* g.currentGameScale, _plant.getTimeToGrowed(), _dataPlant.priceSkipHard, _dataPlant.name,callbackSkip,onOut,true);
                    g.mouseHint.checkMouseHint(MouseHint.CLOCK);
                } else if (_stateRidge == GROWED) {
                    g.mouseHint.checkMouseHint(MouseHint.SERP);
                }
            }

            if(_isOnHover == false){
//                _source.filter = null;
                g.timerHint.hideIt();
                g.mouseHint.hideIt();
             g.gameDispatcher.removeEnterFrame(countMouseEnterFrame);
            }
        }
    }

    public function get plant():PlantOnRidge {
        return _plant;
    }

    public function get isFreeRidge():Boolean {
        return _stateRidge == EMPTY;
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
        _source.filter = null;
        _isOnHover = false;
        _plant.checkStateRidge(false);
        g.directServer.skipTimeOnRidge(_plant._timeToEndState,_dbBuildingId,null);
        _plant.renderSkip();
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

    private function checkBeforeMove():void {
        if (_plant)
            g.managerPlantRidge.onRidgeStartMove(_dataPlant.id, this);
    }

    public function checkAfterMove():void {
        if (_plant)
            g.managerPlantRidge.onRidgeFinishMove(_dataPlant.id, this);
    }

    override public function showArrow():void {
        super.showArrow();
        if (_arrow) _arrow.scaleIt(.7);
    }
}
}
