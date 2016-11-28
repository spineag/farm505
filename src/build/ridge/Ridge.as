/**
 * Created by user on 6/2/15.
 */
package build.ridge {
import analytic.AnalyticManager;

import build.WorldObject;
import com.junkbyte.console.Cc;

import dragonBones.Slot;

import flash.geom.Point;
import hint.MouseHint;
import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;

import media.SoundConst;

import mouse.ToolsModifier;
import resourceItem.CraftItem;
import resourceItem.RawItem;
import resourceItem.ResourceItem;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;
import tutorial.TutorialAction;
import utils.CSprite;
import windows.WindowsManager;

public class Ridge extends WorldObject{
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
    public var lastBuyResource:Boolean;

    public function Ridge(_data:Object) {
        super(_data);
        if (!_data) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            Cc.error('no data for Ridge');
            return;
        }
        _plantSprite = new Sprite();
        _stateRidge = EMPTY;
        _isOnHover = false;
        _dataBuild.url = 'plant'; // temp
        _dataBuild.image = 'ridge'; // temp
        createAnimatedBuild(onCreateBuild);
    }

    private function onCreateBuild():void {
        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onEndClick;
            _source.startClickCallback = onStartClick;
            _source.outCallback = onOut;
            updateRidgeHitArea();
            _source.nameIt = 'ridge';
        }
        _source.releaseContDrag = true;
        _armature.animation.stop();
        var sl:Slot = _armature.getSlot('craft');
        if (sl) {
            sl.displayList = null;
        } else {
            Cc.error('Ridge onCreateBuild: no slot CRAFT at ridge');
        }
        _source.addChild(_plantSprite);
    }

    override public function isContDrag():Boolean {
        return _source.isContDrag;
    }

    public function addChildPlant(s:Sprite):void {
        _plantSprite.addChild(s);
    }

    public function plantThePlant():void {
        g.soundManager.playSound(SoundConst.CRAFT_RAW_PLANT);
        fillPlant(g.dataResource.objectResources[g.toolsModifier.plantId]);
        g.managerPlantRidge.checkFreeRidges();
    }

    public function fillPlant(data:Object, isFromServer:Boolean = false, timeWork:int = 0):void {
        try {
            if (_stateRidge != EMPTY) {
                Cc.error('Try to plant already planted ridge data.name: ' + data.name);
                return;
            }
            if (!data) {
                Cc.error('no data for fillPlant at Ridge');
                g.toolsModifier.modifierType = ToolsModifier.NONE;
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
                new RawItem(p, g.allData.atlas['resourceAtlas'].getTexture(_dataPlant.imageShop + '_icon'), 1, 0);
                var ob:Object;
                ob = {};
                ob.dbId = dbBuildingId;
                ob.plantId = _dataPlant.id;
                ob.state = _stateRidge;
                g.user.userDataCity.plants.push(ob);
            }
            updateRidgeHitArea();

        } catch (e:Error) {
            if (_stateRidge != EMPTY) {
                Cc.error('Try to plant already planted ridge');
                return;
            }
        }
    }

    public function craftThePlant():void {
        if (_stateRidge != GROWED) return;
        if (g.userInventory.currentCountInAmbar + 2 > g.user.ambarMaxCount){
            _source.filter = null;
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            if (!g.windowsManager.currentWindow){
                g.mouseHint.hideIt();
                g.windowsManager.openWindow(WindowsManager.WO_AMBAR_FILLED, null, true);
            }
        } else {
            _stateRidge = EMPTY;
            var arr:Array = g.user.userDataCity.plants;
            for (var i:int = 0; i < arr.length; i++) {
                if (int(arr[i].dbId) == dbBuildingId) {
                    g.user.userDataCity.plants.splice(i,1);
                    break;
                }
            }

            g.soundManager.playSound(SoundConst.CRAFT_RAW_PLANT);
            _plant.onCraftPlant();
            _plant.checkStateRidge();
            _resourceItem = new ResourceItem();
            _resourceItem.fillIt(_dataPlant);
            var f1:Function = function():void {
                g.managerPlantRidge.onCraft(_plant.idFromServer);
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
        g.managerPlantRidge.checkGrowedRidges();
    }

    override public function onHover():void {
        if(_isOnHover) return;
        if (g.selectedBuild) return;
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) {
            if (_tutorialCallback == null) return;
            if ((g.managerTutorial.currentAction == TutorialAction.NEW_RIDGE || g.managerTutorial.currentAction == TutorialAction.PLANT_RIDGE) && g.managerTutorial.isTutorialBuilding(this)) {

            } else if (!g.managerTutorial.isTutorialBuilding(this) || _tutorialCallback == null) return;
        }
        if (g.isActiveMapEditor || g.isAway){
            return;
        }
        super.onHover();
        _isOnHover = true;
        if (_stateRidge == GROWED) _plant.hoverGrowed();
        _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        if (_stateRidge == EMPTY && g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
        } else {
            if (g.toolsModifier.modifierType != ToolsModifier.NONE) return;
//            _count = 10;
//            _countMouse = 7;
//            if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
//                g.timerHint.managerHide();
//                g.wildHint.managerHide();
//                g.treeHint.managerHide();
//            }
            if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                    g.mouseHint.showMouseHint(MouseHint.CLOCK);
            } else if (_stateRidge == GROWED) {
                g.mouseHint.showMouseHint(MouseHint.SERP);
            }
//            if (g.toolsModifier.modifierType != ToolsModifier.PLANT_SEED && g.toolsModifier.modifierType != ToolsModifier.PLANT_SEED_ACTIVE)
//                g.gameDispatcher.addEnterFrame(countMouseEnterFrame);
        }
    }

    override public function onOut():void {
        if (!_isOnHover) return;
        g.timerHint.hideIt(true);
        if (g.toolsModifier.modifierType != ToolsModifier.CRAFT_PLANT) g.mouseHint.hideIt();
        if (_source) {
            super.onOut();
            _isOnHover = false;
            if (_source.filter) _source.filter.dispose();
            _source.filter = null;
//            g.gameDispatcher.addEnterFrame(countMouseEnterFrame);
        }
    }

    private function onStartClick():void {
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial && (!g.managerTutorial.isTutorialBuilding(this) || _tutorialCallback == null)) return;
        if (g.isActiveMapEditor || g.isAway) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
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
            return;
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            return;
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
            g.directServer.userBuildingFlip(_dbBuildingId, int(_flip), null);
            return;
        }
        if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED) {
            if (g.toolsModifier.plantId <= 0 || _stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                return;
            }
            if (_stateRidge == GROWED) {
                g.toolsModifier.modifierType = ToolsModifier.CRAFT_PLANT;
                return;
            }
            var arr:Array = g.user.userDataCity.plants;
            for (var i:int = 0; i < arr.length; i++) {
                if (int(arr[i].dbId) == dbBuildingId) {
                    Cc.error('this ridhe have plant in data');
                    return;
                }
            }
            lastBuyResource = true;
            _source.filter = null;
            plantThePlant();
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.PLANT_RIDGE) {
                if (_tutorialCallback != null) {
                    _tutorialCallback.apply(null, [this]);
                }
            } else {
                g.toolsModifier.modifierType = ToolsModifier.PLANT_SEED_ACTIVE;
            }
        } else if (_stateRidge == GROWED) {
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.CRAFT_RIDGE) return;
            craftThePlant();
            g.timerHint.hideIt(true);
            if (!g.managerTutorial.isTutorial) g.toolsModifier.modifierType = ToolsModifier.CRAFT_PLANT;
        }
    }

    public function stopDragMapDuringPlanting(isPlantingNow:Boolean):void {
        _source.releaseContDrag = !isPlantingNow;
    }

    public function onEndClick():void {
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) {
            if (g.managerTutorial.currentAction == TutorialAction.PLANT_RIDGE && g.managerTutorial.isTutorialBuilding(this) && _tutorialCallback != null) {
                g.managerTutorial.checkTutorialCallback();
            } else if (g.managerTutorial.currentAction == TutorialAction.NEW_RIDGE) {
//                if (g.selectedBuild != this) return;
            } else if (!g.managerTutorial.isTutorialBuilding(this) || _tutorialCallback == null) return;
        }
        if (g.isActiveMapEditor || g.isAway) return;
        if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
//            g.toolsModifier.modifierType = ToolsModifier.NONE;
            g.toolsModifier.modifierType = ToolsModifier.PLANT_SEED;
            return;
        } else if (g.toolsModifier.modifierType == ToolsModifier.CRAFT_PLANT) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            return;
        } else if (g.toolsModifier.modifierType == ToolsModifier.ADD_NEW_RIDGE) {
            onOut();
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            }
//        } else if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
//            if (!g.managerTutorial.isTutorial) onOut();
//            if (g.selectedBuild) {
//                if (g.selectedBuild == this) {
//                    g.toolsModifier.onTouchEnded();
//                } else return;
//            } else {
//                if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3 || _stateRidge == GROWED) {
//                    g.toolsModifier.ridgeId = _dataPlant.id;
//                }
//                checkBeforeMove();
//                g.townArea.moveBuild(this);
//            }
//        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
//            g.toolsModifier.modifierType = ToolsModifier.NONE;
//        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
//            releaseFlip();
//            g.directServer.userBuildingFlip(_dbBuildingId, int(_flip), null);
        }  else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                if (g.managerTutorial.isBlockForTutorial) return;
                onOut();

                if (!lastBuyResource) {
                    if (g.timerHint.isShow) g.timerHint.managerHide(onClickCallbackWhenWork);
                     else g.timerHint.showIt(50, g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + (_source.y +_source.height/2 -  _plantSprite.height) /*_source.height/10) */* g.currentGameScale,_dataPlant.buildTime, _plant.getTimeToGrowed(), _dataPlant.priceSkipHard, _dataPlant.name,callbackSkip,onOut, true);
                }
                lastBuyResource = false;
            }
            if (_stateRidge == EMPTY) {
                onOut();
                if (g.managerTutorial.isTutorial && _tutorialCallback != null) {
                    hideArrow();
                }
                g.windowsManager.openWindow(WindowsManager.WO_BUY_PLANT, onBuy, this);
//            } else if (_stateRidge == GROWED) {
//                craftThePlant();
            }
        }
    }

    private function onClickCallbackWhenWork():void {
        g.timerHint.showIt(50, g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + (_source.y +_source.height/2 -  _plantSprite.height) /*_source.height/10) */* g.currentGameScale,_dataPlant.buildTime, _plant.getTimeToGrowed(), _dataPlant.priceSkipHard, _dataPlant.name,callbackSkip,onOut, true);
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

    public function updateRidgeHitArea():void {
        if (_stateRidge == EMPTY) {
            _hitArea = g.managerHitArea.getHitArea(_source, 'ridgeBuild', ManagerHitArea.TYPE_RIDGE);
        } else {
            _hitArea = g.managerHitArea.getHitArea(_source, 'ridgeBuild_' + String(_dataPlant.id) + '_' + String(_stateRidge), ManagerHitArea.TYPE_RIDGE, 2, 2, _plantSprite);
        }
        _source.registerHitArea(_hitArea);
    }

    public function get stateRidge():int {
        return _stateRidge;
    }

    public function set stateRidge(a:int):void {
        _stateRidge = a;
        if (_stateRidge == GROWED) {
            g.managerPlantRidge.removeCatFromRidge(_dataPlant.id, this);
            if (g.managerTips) g.managerTips.calculateAvailableTips();
        }
        updateRidgeHitArea();
    }

//    public function countMouseEnterFrame():void {
//        if(_isOnHover == false) {
////                _source.filter = null;
//            g.timerHint.hideIt();
//            g.mouseHint.hideIt();
//            g.gameDispatcher.removeEnterFrame(countMouseEnterFrame);
//            return;
//        }
//        _countMouse--;
//        if (_countMouse <= 5) {
//            if (_isOnHover == true) {
//                if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
//                    g.mouseHint.checkMouseHint(MouseHint.CLOCK);
//                } else if (_stateRidge == GROWED) {
//                    g.mouseHint.checkMouseHint(MouseHint.SERP);
//                    g.gameDispatcher.removeEnterFrame(countMouseEnterFrame);
//                }
//            }
//        }
//        if(_countMouse <= 0){
//            g.gameDispatcher.removeEnterFrame(countMouseEnterFrame);
//            if (_isOnHover == true) {
//                if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
//                    g.timerHint.showIt(50, g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + (_source.y +_source.height/2 -  _plantSprite.height) /*_source.height/10) */* g.currentGameScale, _plant.getTimeToGrowed(), _dataPlant.priceSkipHard, _dataPlant.name,callbackSkip,onOut,true);
//                    g.mouseHint.checkMouseHint(MouseHint.CLOCK);
//                } else if (_stateRidge == GROWED) {
//                    g.mouseHint.checkMouseHint(MouseHint.SERP);
//                }
//            }
//        }
//    }

    public function get plant():PlantOnRidge {
        return _plant;
    }

    public function get isFreeRidge():Boolean {
        return _stateRidge == EMPTY;
    }

    override public function clearIt():void {
//        _bg.touchable = false;
//        while (_bg.numChildren) _bg.removeChildAt(0);
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
        g.directServer.skipTimeOnRidge(_plant._timeToEndState, _dbBuildingId, null);
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.SKIP_TIMER, {id: AnalyticManager.SKIP_TIMER_PLANT_ID, info: _plant.dataPlant.id});
        _plant.renderSkip();
    }

    public function lockIt(v:Boolean):void {
        if (v) {
            if (_stateRidge != EMPTY) {
                _source.isTouchable = false;
            }
        } else {
            _source.isTouchable = true;
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

    override public function showArrow(t:Number=0):void {
        super.showArrow(t);
        if (_arrow) _arrow.scaleIt(.7);
    }

    public function forceGrowPlant():void {
        if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
            _plant.renderSkip();
        }
    }
}
}
