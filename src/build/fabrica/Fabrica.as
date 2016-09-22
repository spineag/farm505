/**
 * Created by user on 6/9/15.
 */
package build.fabrica {
import analytic.AnalyticManager;
import build.WorldObject;
import data.BuildType;

import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.geom.Point;
import heroes.BasicCat;
import heroes.HeroCat;
import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;

import media.SoundConst;
import resourceItem.CraftItem;
import com.junkbyte.console.Cc;
import resourceItem.RawItem;
import resourceItem.ResourceItem;
import mouse.ToolsModifier;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import tutorial.TutorialAction;
import tutorial.helpers.HelperReason;
import ui.xpPanel.XPStar;
import windows.WindowsManager;

public class Fabrica extends WorldObject {
    private var _arrRecipes:Array;  // массив всех рецептов, которые можно изготовить на этой фабрике
    private var _arrList:Array; // массив заказанных для изготовления ресурсов
    private var _isOnHover:Boolean;
    private var _heroCat:HeroCat;
    private var _count:int;
    private var _arrCrafted:Array;
    private var _armatureOpen:Armature;
    private var _countTimer:int;
    private var _fabricWork:Boolean;
    public function Fabrica(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for Fabrica');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Fabrica');
            return;
        }
        if (!_dataBuild.countCell) {
            _dataBuild.countCell = g.dataBuilding.objectBuilding[_dataBuild.id].startCountCell;
        }
        _craftSprite = new Sprite();
        if (g.isAway) {
            g.cont.craftAwayCont.addChild(_craftSprite);
        } else {
            g.cont.craftCont.addChild(_craftSprite);
        }
        _buildingBuildSprite = new Sprite();
        _source.addChild(_buildingBuildSprite);
        checkBuildState();
        _fabricWork = true;
        _arrRecipes = [];
        _arrList = [];
        _arrCrafted = [];
        _source.releaseContDrag = true;
        if (!g.isAway) _source.endClickCallback = onClick;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;

        updateRecipes();
    }

    override public function afterPasteBuild():void {
        if (_arrCrafted.length) _craftSprite.visible = true;
        _craftSprite.x = _source.x;
        _craftSprite.y = 100*g.scaleFactor + _source.y;
        super.afterPasteBuild();
    }

    private function checkBuildState():void {
        try {
            if (g.isAway) {
                    _stateBuild = STATE_ACTIVE;
                    createAnimatedBuild(onCreateBuild);
            } else {
                if (g.user.userBuildingData[_dataBuild.id]) {
                    if (g.user.userBuildingData[_dataBuild.id].isOpen) {
                        _stateBuild = STATE_ACTIVE;
                        createAnimatedBuild(onCreateBuild);                                                     // уже построенно и открыто
                    } else {
                        _leftBuildTime = int(g.user.userBuildingData[_dataBuild.id].timeBuildBuilding); // сколько времени уже строится
                        var arr:Array = g.townArea.getCityObjectsById(_dataBuild.id);
                        _leftBuildTime = int(_dataBuild.buildTime[arr.length]) - _leftBuildTime;        // сколько времени еще до конца стройки
                        if (_leftBuildTime <= 0) {  // уже построенно, но не открыто
                            _stateBuild = STATE_WAIT_ACTIVATE;
                            addDoneBuilding();
                        } else {  // еще строится
                            _stateBuild = STATE_BUILD;
                            addFoundationBuilding();
                            g.gameDispatcher.addToTimer(renderBuildProgress);
                        }
                    }
                } else {
                    _stateBuild = STATE_ACTIVE;
                    createAnimatedBuild(onCreateBuild);
                }
            }
        } catch (e:Error) {
            Cc.error('Fabric checkBuildState:: error: ' + e.errorID + ' - ' + e.message);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'Fabric checkBuildState');
        }
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        stopAnimation();
        _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.url, ManagerHitArea.TYPE_LOADED);
        _source.registerHitArea(_hitArea);
        if (!g.isAway) onHeroAnimation();
    }


    public function showShopView():void {
        _buildingBuildSprite.visible = false;
        createAnimatedBuild(onCreateBuild);
    }

    public function removeShopView():void {
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }
        _buildingBuildSprite.visible = true;
        _rect = _buildingBuildSprite.getBounds(_buildingBuildSprite);
        if (_rect.width) {
            _hitArea = g.managerHitArea.getHitArea(_source, 'buildingBuild');
            _source.registerHitArea(_hitArea);
        }
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (g.isAway) {
            g.hint.showIt(_dataBuild.name);
            return;
        }
        if (g.managerTutorial.isTutorial && !g.managerTutorial.isTutorialBuilding(this)) return;
        if (g.isActiveMapEditor) return;
        _count = 20;
        if (_stateBuild == STATE_ACTIVE) {
            if (_arrList.length > 0) g.hint.showIt(_dataBuild.name,'fabric',0,_arrList[0].leftTime);
            else g.hint.showIt(_dataBuild.name);

            if (!_isOnHover && !_arrList.length && _armature) {
                var fEndOver:Function = function(e:Event=null):void {
                    _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                    _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
//                    _armature.animation.gotoAndStopByFrame('idle');
                    _armature.animation.gotoAndPlayByFrame('idle');
                };
                _armature.addEventListener(EventObject.COMPLETE, fEndOver);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndPlayByFrame('over');
            }
        } else if (_stateBuild == STATE_BUILD) {
            if (!_isOnHover) {
                buildingBuildFoundationOver();
                if (g.managerTutorial.isTutorial) {
                    return;
                }
// else {
//                    _countTimer = 5;
//                    g.timerHint.managerHide();
//                    g.wildHint.managerHide();
//                    g.treeHint.managerHide();
//                    g.gameDispatcher.addEnterFrame(countEnterFrame);
//                }
            }
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            if (!_isOnHover) buildingBuildDoneOver();
        }
        if (!_isOnHover) _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        _isOnHover = true;
    }

    override public function onOut():void {
        super.onOut();
        if (g.isAway) {
            g.hint.hideIt();
            return;
        }
        _source.filter = null;
        if (g.managerTutorial.isTutorial) {
            if (g.managerTutorial.currentAction == TutorialAction.FABRICA_SKIP_FOUNDATION) return;
            if (!g.managerTutorial.isTutorialBuilding(this)) return;
        }
        if (g.isActiveMapEditor) return;
        _isOnHover = false;
//        if (_stateBuild == STATE_BUILD) {
//            g.gameDispatcher.addEnterFrame(countEnterFrame);
//        } else {
            g.hint.hideIt();
//        }
    }

//    private function countEnterFrame():void {
//        _countTimer--;
//        if (_countTimer <= 0) {
//            g.gameDispatcher.removeEnterFrame(countEnterFrame);
//            if (_isOnHover == true) {
//                g.timerHint.needMoveCenter = true;
//                g.timerHint.showIt(90, g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + (_source.y - _source.height / 3) * g.currentGameScale, _leftBuildTime, _dataBuild.priceSkipHard, _dataBuild.name, callbackSkip, onOut);
//            }
//            if (_isOnHover == false) {
//                if(_source)_source.filter = null;
//                g.timerHint.hideIt();
//                g.gameDispatcher.removeEnterFrame(countEnterFrame);
//            }
//        }
//    }

    public function openFabricaWindow():void {
        if (g.managerHelpers && g.managerHelpers.isActiveHelper && g.managerHelpers.activeReason.reason == HelperReason.REASON_RAW_FABRICA && g.managerHelpers.activeReason.build == this) {
            g.managerHelpers.onOpenFabricaWithDelay();
        }
        var needShowArrow:Boolean;
        _arrow ? needShowArrow = true : needShowArrow = false;
        hideArrow();
        g.windowsManager.openWindow(WindowsManager.WO_FABRICA, callbackOnChooseRecipe, _arrRecipes.slice(), _arrList.slice(), this, needShowArrow);
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) g.toolsModifier.modifierType = ToolsModifier.NONE;
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) {
            if (g.managerTutorial.currentAction == TutorialAction.RAW_RECIPE && g.managerTutorial.isTutorialBuilding(this)) {
                g.managerTutorial.checkTutorialCallback();
                g.toolsModifier.modifierType = ToolsModifier.NONE;
            } else if (g.managerTutorial.currentAction == TutorialAction.FABRICA_SKIP_FOUNDATION && g.managerTutorial.isTutorialBuilding(this)) {

            } else if (g.managerTutorial.currentAction == TutorialAction.PUT_FABRICA && g.managerTutorial.isTutorialResource(_dataBuild.id)) {

            } else if (g.managerTutorial.currentAction == TutorialAction.FABRICA_CRAFT && g.managerTutorial.isTutorialBuilding(this)) {

            } else return;
        }
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (!g.managerTutorial.isTutorial) onOut();
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                _craftSprite.visible = false;
                g.townArea.moveBuild(this);
                g.timerHint.hideIt();
            }
            return;
        }
        if (_stateBuild == STATE_ACTIVE) {
            if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
                onOut();
                g.townArea.deleteBuild(this);
            } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
                releaseFlip();
                g.directServer.userBuildingFlip(_dbBuildingId, int(_flip), null);
            } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {

            } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
                // ничего не делаем вообще
            } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
            } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
                if (_source.wasGameContMoved) {
                    onOut();
                    return;
                }
                if (_arrCrafted.length) {
                    if (g.userInventory.currentCountInSklad + _arrCrafted[0].count > g.user.skladMaxCount) {
                        g.windowsManager.openWindow(WindowsManager.WO_AMBAR_FILLED, null, false);
                    } else {
                        (_arrCrafted[0] as CraftItem).flyIt();
                    }
                } else {
                    if (!_arrRecipes.length) updateRecipes();
                    if (!g.managerTutorial.isTutorial) g.cont.moveCenterToXY(_source.x, _source.y);
                    onOut();
                    openFabricaWindow();
                }
            } else {
                Cc.error('Fabrica:: unknown g.toolsModifier.modifierType and convert to NONE');
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                onClick();
                return;
            }
        } else if (_stateBuild == STATE_BUILD) {
            if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
                onOut();
                g.townArea.moveBuild(this);
            } else {
                if (g.managerTutorial.isTutorial) {
                    if (g.managerTutorial.currentAction == TutorialAction.FABRICA_SKIP_FOUNDATION && g.managerTutorial.subStep == 1) {
                        g.timerHint.canHide = false;
                        g.timerHint.addArrow();
                        g.managerTutorial.checkTutorialCallback();
                        g.timerHint.showIt(90, g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + (_source.y - _source.height/3) * g.currentGameScale,
                                _dataBuild.buildTime, _leftBuildTime, _dataBuild.priceSkipHard, _dataBuild.name, callbackSkip, onOut);
                    } else return;
                } else {
                    g.timerHint.needMoveCenter = true;
                    g.timerHint.showIt(90, g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + (_source.y - _source.height/3) * g.currentGameScale,
                            _dataBuild.buildTime, _leftBuildTime, _dataBuild.priceSkipHard, _dataBuild.name, callbackSkip, onOut);
                }
            }
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.PUT_FABRICA) return;
            _stateBuild = STATE_ACTIVE;
            g.user.userBuildingData[_dataBuild.id].isOpen = 1;
            if (g.useDataFromServer) {
                g.directServer.openBuildedBuilding(this, onOpenBuilded);
            }
            clearBuildingBuildSprite();
            onOut();
            createAnimatedBuild(onCreateBuild);
            if (_dataBuild.xpForBuild) {
                var start:Point = new Point(int(_source.x), int(_source.y));
                start = _source.parent.localToGlobal(start);
                new XPStar(start.x, start.y, _dataBuild.xpForBuild);
            }
            showBoom();
            g.managerFabricaRecipe.onAddNewFabrica(this);
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.PUT_FABRICA && g.managerTutorial.isTutorialBuilding(this)) {
                g.managerTutorial.checkTutorialCallback();
            }
            g.soundManager.playSound(SoundConst.OPEN_BUILD);
        }
    }

    public function get arrRecipes():Array {
        return _arrRecipes;
    }

    public function get arrList():Array {
        return _arrList;
    }

    private function onOpenBuilded(value:Boolean):void { }

    private function updateRecipes():void {
        _arrRecipes.length = 0;
        try {
            var obj:Object = g.dataRecipe.objectRecipe;
            for(var id:String in obj) {
                if (obj[id].buildingId == _dataBuild.id) {
                    _arrRecipes.push(obj[id]);
                }
            }
            _arrRecipes.sortOn('blockByLevel', Array.NUMERIC);
        } catch (e:Error) {
            Cc.error('fabrica recipe error: ' + e.errorID + ' - ' + e.message);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'fabrica update recipe');
        }
    }

    public function get heroCat():HeroCat {
        return _heroCat;
    }

    public function onRecipeFromServer(resItem:ResourceItem, dataRecipe:Object, timeInWork:int, delayTime:int):void {
        resItem.leftTime -= timeInWork;
        resItem.delayTime = delayTime;
        resItem.currentRecipeID = dataRecipe.id;
        _arrList.push(resItem);
    }

    public function onLoadFromServer():void {
        if (!_arrList.length) return;
        _arrList.sortOn('delayTime', Array.NUMERIC);
        if (!_heroCat) _heroCat = g.managerCats.getFreeCat();
        if (_heroCat) {
            _heroCat.isFree = false;
            _heroCat.setPosition(new Point(posX, posY));
            _heroCat.updatePosition();
            onHeroAnimation();
        } else {
            Cc.error('Fabrica onLoadFromServer:: _heroCat == null');
        }
        g.gameDispatcher.addToTimer(render);
    }

    public function callbackOnChooseRecipe(resItem:ResourceItem, dataRecipe:Object):void {
        if (!_heroCat) _heroCat = g.managerCats.getFreeCat();
        if (!_arrList.length && !_heroCat) {
            if (g.managerCats.curCountCats == g.managerCats.maxCountCats) {
                g.windowsManager.openWindow(WindowsManager.WO_WAIT_FREE_CATS);
            } else {
                g.windowsManager.openWindow(WindowsManager.WO_NO_FREE_CATS);
            }
            return;
        }
        var i:int;
        var delay:int = 0;
        _heroCat.isFree = false;
        _arrList.push(resItem);
        resItem.currentRecipeID = dataRecipe.id;
        if (_arrList.length == 1) {
            g.gameDispatcher.addToTimer(render);
        }
        if (_arrList.length > 1) {
            onHeroAnimation();
            // delay before start make this new recipe
            for (i = 0; i < _arrList.length - 1; i++) {
                delay += _arrList[i].buildTime;
            }
        } else g.managerCats.goCatToPoint(_heroCat, new Point(posX, posY), onHeroAnimation);

        var f1:Function = function(t:String):void {
            resItem.idFromServer = t;
        };
        Cc.ch('temp', 'fabrica delay: ' + delay);
        for (i = 0; i < dataRecipe.ingridientsId.length; i++) {
            g.userInventory.addResource(int(dataRecipe.ingridientsId[i]), -int(dataRecipe.ingridientsCount[i]));
        }
        g.directServer.addFabricaRecipe(dataRecipe.id, _dbBuildingId, delay, f1);
        // animation of uploading resources to fabrica
        var p:Point = new Point(source.x, source.y);
        p = source.parent.localToGlobal(p);
        var obj:Object;
        var texture:Texture;
        for (i = 0; i < dataRecipe.ingridientsId.length; i++) {
            obj = g.dataResource.objectResources[int(dataRecipe.ingridientsId[i])];
            if (obj.buildType == BuildType.PLANT)
                texture = g.allData.atlas['resourceAtlas'].getTexture(obj.imageShop + '_icon');
            else
                texture = g.allData.atlas[obj.url].getTexture(obj.imageShop);
            new RawItem(p, texture, int(dataRecipe.ingridientsCount[i]), i * .1);
        }
    }

    private function onHeroAnimation():void {
        if (_fabricWork) return;
        if (_arrList.length && _heroCat) {
            startAnimation();
            _fabricWork = true;
            _heroCat.visible = false;
        }
    }

    public function onGoAway(v:Boolean):void {
        if (v) {
            if (_heroCat) {
                _heroCat.killAllAnimations();
                stopAnimation();
            }
        } else {
            onHeroAnimation();
        }
    }

    private function render():void {
        if (!_arrList.length) {
            if (_heroCat) {
                _heroCat.visible = true;
                _heroCat.isFree = true;
            }
            stopAnimation();
            g.gameDispatcher.removeFromTimer(render);
            return;
        }
        _arrList[0].leftTime--;
        if (_arrList[0].leftTime <= 0) {
            craftResource(_arrList.shift());
            if (!_arrList.length) {
                if (_heroCat) {
                    _heroCat.visible = true;
                    _heroCat.isFree = true;
                }
                stopAnimation();
                g.gameDispatcher.removeFromTimer(render);
            }
        }
    }

    public function craftResource(item:ResourceItem):void {
        var countResources:int = 1;
        for(var id:String in g.dataRecipe.objectRecipe) {
            if (g.dataRecipe.objectRecipe[id].buildingId == _dataBuild.id &&
                    item.resourceID == g.dataRecipe.objectRecipe[id].idResource) {
                countResources = g.dataRecipe.objectRecipe[id].numberCreate;
            }
        }
        _craftSprite.visible = true;
        var craftItem:CraftItem = new CraftItem(0, 0, item, _craftSprite, countResources, useCraftedResource, true);
        _arrCrafted.push(craftItem);
        craftItem.addParticle();
        craftItem.animIt();
        if (!_arrList.length && _heroCat) {
            if (_heroCat.visible) {
                _heroCat.killAllAnimations();
                _heroCat.isFree = true;
            } else {
                _heroCat.visible = true;
                _heroCat.isFree = true;
            }
            _heroCat = null;
        }
        if (g.managerTips) g.managerTips.calculateAvailableTips();
    }

    public function addAnimForCraftItem(v:Boolean):void {
        if (_arrCrafted.length) {
            var i:int;
            if (v) {
                for (i=0; i<_arrCrafted.length; i++) {
                    (_arrCrafted[i] as CraftItem).animIt();
                }
            } else {
                for (i=0; i<_arrCrafted.length; i++) {
                    (_arrCrafted[i] as CraftItem).removeAnimIt();
                }
            }
        }
    }
    
    private function useCraftedResource(item:ResourceItem, crItem:CraftItem):void {
        _arrCrafted.splice(_arrCrafted.indexOf(crItem), 1);
        g.managerFabricaRecipe.onCraft(item);
    }

    public function awayImitationOfWork():void {
        startAnimation();
    }

    private function startAnimation():void {
        if (!_armature) return;
        _armature.addEventListener(EventObject.COMPLETE, chooseAnimation);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, chooseAnimation);
        releaseHeroCatWoman();
        chooseAnimation();
    }

    private function stopAnimation():void {
        _fabricWork = false;
        if (_armature) _armature.animation.gotoAndStopByFrame('idle');
        if (_armature && _armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, chooseAnimation);
        if (_armature && _armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, chooseAnimation);
    }

    private function chooseAnimation(e:Event=null):void {
        if (!_armature) return;
        if (!_armature.hasEventListener(EventObject.COMPLETE)) _armature.addEventListener(EventObject.COMPLETE, chooseAnimation);
        if (!_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.addEventListener(EventObject.LOOP_COMPLETE, chooseAnimation);
        var k:int = int(Math.random() * 6);
        switch (k) {
            case 0:
                _armature.animation.gotoAndPlayByFrame('idle1');
                break;
            case 1:
                _armature.animation.gotoAndPlayByFrame('idle1');
                break;
            case 2:
                _armature.animation.gotoAndPlayByFrame('idle1');
                break;
            case 3:
                _armature.animation.gotoAndPlayByFrame('idle2');
                break;
            case 4:
                _armature.animation.gotoAndPlayByFrame('idle3');
                break;
            case 5:
                if (_armature.animation.hasAnimation('idle4')) _armature.animation.gotoAndPlayByFrame('idle4');
                else _armature.animation.gotoAndPlayByFrame('idle3');
                break;
        }
    }

    override public function clearIt():void {
        onOut();
        stopAnimation();
        if (_armature) WorldClock.clock.remove(_armature);
        g.gameDispatcher.removeFromTimer(render);
        _source.touchable = false;
        _arrList.length = 0;
        _arrRecipes.length = 0;
        super.clearIt();
    }

    private function callbackSkip():void { // for building build
        _stateBuild = STATE_WAIT_ACTIVATE;
        g.directServer.skipTimeOnFabricBuild(_leftBuildTime, _dbBuildingId, null);
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.SKIP_TIMER, {id: AnalyticManager.SKIP_TIMER_BUILDING_BUILD_ID, info: _dataBuild.id});
        _leftBuildTime = 0;
        renderBuildProgress();
        onOut();
    }

    public function onBuyNewCell():void {
        _dataBuild.countCell++;
        g.directServer.buyNewCellOnFabrica(_dbBuildingId, _dataBuild.countCell, null);
    }

    public function skipRecipe():void { // for making recipe
        if (_arrList[0]) {
            g.directServer.skipRecipeOnFabrica(_arrList[0].idFromServer, _arrList[0].leftTime, _dbBuildingId, null);
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.SKIP_TIMER, {id: AnalyticManager.SKIP_TIMER_FABRICA_ID, info: _arrList[0].resourceID});
            craftResource(_arrList.shift());
        } else {
            Cc.error('Fabrica skipRecipe:: _arrList[0] == null');
        }
    }

    public function addArrowToCraftItem(f:Function):void {
        if (_arrCrafted.length) {
            (_arrCrafted[0] as CraftItem).addArrow(f);
        }
    }

    public function get isAnyCrafted():Boolean {
        return _arrCrafted.length > 0;
    }

    private function releaseHeroCatWoman():void {
        if (_heroCat) {
            if (_heroCat.typeMan == BasicCat.MAN) {
                if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 7)
                    releaseManBackTexture();
                else releaseManFrontTexture();
            } else if (_heroCat.typeMan == BasicCat.WOMAN) {
                if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 7)
                    releaseWomanBackTexture();
                else releaseWomanFrontTexture();
            }
        } else {
            if (g.isAway) {
                if (Math.random() < .5) {
                    if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 7)
                        releaseManBackTexture();
                    else releaseManFrontTexture();
                } else {
                    if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 7)
                        releaseWomanBackTexture();
                    else releaseWomanFrontTexture();
                }
            }
        }
    }

    private function releaseManFrontTexture():void {
        if (!_armature) return;
        changeTexture("head", "head");
        changeTexture("body", "body");
        changeTexture("handLeft", "hand_l");
        changeTexture("legLeft", "leg_l");
        changeTexture("handRight", "hand_r");
        changeTexture("legRight", "leg_r");
        changeTexture("tail", "tail");
        if (_dataBuild.id == 10) {
            changeTexture("handRight2", "hand_r");
        }
        var viyi:Bone = _armature.getBone('viyi'); {
            if (viyi) {
                viyi.visible = false;
            }
        }
    }

    private function releaseManBackTexture():void {
        changeTexture("head", "head_b");
        changeTexture("body", "body_b");
        changeTexture("handLeft", "hand_l_b");
        changeTexture("legLeft", "leg_l_b");
        changeTexture("handRight", "hand_r_b");
        changeTexture("legRight", "leg_r_b");
        changeTexture("tail", "tail");
        if (_dataBuild.id == 10) {
            changeTexture("handRight2", "hand_r_b");
        }
    }

    private function releaseWomanFrontTexture():void {
        if (!_armature) return;
        changeTexture("head", "head_w");
        changeTexture("body", "body_w");
        changeTexture("handLeft", "hand_w_l");
        changeTexture("legLeft", "leg_w_r");
        changeTexture("handRight", "hand_w_r");
        changeTexture("legRight", "leg_w_r");
        changeTexture("tail", "tail_w");
        if (_dataBuild.id == 10) {
            changeTexture("handRight2", "hand_w_r");
        }
        var viyi:Bone = _armature.getBone('viyi'); {
            if (viyi) {
                viyi.visible = true;
            }
        }
    }

    private function releaseWomanBackTexture():void {
        changeTexture("head", "head_w_b");
        changeTexture("body", "body_w_b");
        changeTexture("handLeft", "hand_w_l_b");
        changeTexture("legLeft", "leg_w_l_b");
        changeTexture("handRight", "hand_w_r_b");
        changeTexture("legRight", "leg_w_r_b");
        changeTexture("tail", "tail_w");
    }

    private function changeTexture(oldName:String, newName:String):void {
        var im:Image = new Image(g.allData.atlas['customisationAtlas'].getTexture(newName));
        if (_armature) var b:Slot = _armature.getSlot(oldName);
        if (im && b) {
            b.displayList = null;
            b.display = im;
        } else {
            Cc.error('Fabrica changeTexture:: null Bone for oldName= '+oldName + ' for fabricaId= '+String(_dataBuild.id));
        }
    }

    private function showBoom():void {
        _armatureOpen = g.allData.factory['explode'].buildArmature("expl");
        if (!_armatureOpen) return;
        (_armatureOpen.display as Sprite).scaleX = (_armatureOpen.display as StarlingArmatureDisplay).scaleY = 1.5;
        _source.addChild(_armatureOpen.display as Sprite);
        WorldClock.clock.add(_armatureOpen);
        _armatureOpen.addEventListener(EventObject.COMPLETE, onBoom);
        _armatureOpen.addEventListener(EventObject.LOOP_COMPLETE, onBoom);
        _armatureOpen.animation.gotoAndPlayByFrame("start");

    }

    private function onBoom(e:Event=null):void {
        if (_armatureOpen.hasEventListener(EventObject.COMPLETE)) _armatureOpen.removeEventListener(EventObject.COMPLETE, onBoom);
        if (_armatureOpen.hasEventListener(EventObject.LOOP_COMPLETE)) _armatureOpen.removeEventListener(EventObject.LOOP_COMPLETE, onBoom);
        WorldClock.clock.remove(_armatureOpen);
        _source.removeChild(_armatureOpen.display as Sprite);
        _armatureOpen = null;
        if (!g.managerTutorial.isTutorial) {
            g.windowsManager.openWindow(WindowsManager.POST_OPEN_FABRIC,null,_dataBuild);
        }
    }

}
}
