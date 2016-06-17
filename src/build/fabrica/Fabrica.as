/**
 * Created by user on 6/9/15.
 */
package build.fabrica {
import analytic.AnalyticManager;

import build.WorldObject;
import data.BuildType;
import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import flash.geom.Point;
import heroes.BasicCat;
import heroes.HeroCat;
import manager.ManagerFilters;
import resourceItem.CraftItem;
import com.junkbyte.console.Cc;
import resourceItem.RawItem;
import resourceItem.ResourceItem;
import mouse.ToolsModifier;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import tutorial.TutorialAction;
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
        _source.addChild(_craftSprite);
        checkBuildState();

        _arrRecipes = [];
        _arrList = [];
        _arrCrafted = [];
        _source.releaseContDrag = true;
        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        }
        updateRecipes();
    }

    private function checkBuildState():void {
        try {
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
        } catch (e:Error) {
            Cc.error('AreaObject checkBuildState:: error: ' + e.errorID + ' - ' + e.message);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'AreaObject checkBuildState');
        }
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        stopAnimation();
        _hitArea = g.managerHitArea.getHitArea(_source, 'fabrica' + _dataBuild.image);
        _source.registerHitArea(_hitArea);
        _source.setChildIndex(_craftSprite, _source.numChildren - 1);
        onHeroAnimation();
    }


    public function showShopView():void {
        createAnimatedBuild(onCreateBuild);
        _craftSprite.visible = false;
    }

    public function removeShopView():void {
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }
        _craftSprite.visible = true;
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (g.managerTutorial.isTutorial && !g.managerTutorial.isTutorialBuilding(this)) return;
        if (g.isActiveMapEditor) return;
        _count = 20;
        if (_stateBuild == STATE_ACTIVE) {
            g.hint.showIt(_dataBuild.name);
            if (!_isOnHover && !_arrList.length && _armature) {
                var fEndOver:Function = function():void {
                    _armature.removeEventListener(AnimationEvent.COMPLETE, fEndOver);
                    _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
                    _armature.animation.gotoAndStop('idle', 0);
                };
                _armature.addEventListener(AnimationEvent.COMPLETE, fEndOver);
                _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndPlay('over');
            }
        } else if (_stateBuild == STATE_BUILD) {
            if (!_isOnHover) {
                buildingBuildFoundationOver();
                if (g.managerTutorial.isTutorial) {
                    return;
                } else {
                    _countTimer = 5;
                    g.timerHint.managerHide();
                    g.wildHint.managerHide();
                    g.treeHint.managerHide();
                    g.gameDispatcher.addEnterFrame(countEnterFrame);
                }
            }
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            if (!_isOnHover) buildingBuildDoneOver();
        }
        if (!_isOnHover) _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        _isOnHover = true;
    }

    override public function onOut():void {
        super.onOut();
        _source.filter = null;
        if (g.managerTutorial.isTutorial) {
            if (g.managerTutorial.currentAction == TutorialAction.FABRICA_SKIP_FOUNDATION) return;
            if (!g.managerTutorial.isTutorialBuilding(this)) return;
        }
        if (g.isActiveMapEditor) return;
        _isOnHover = false;
        if (_stateBuild == STATE_BUILD) {
            g.gameDispatcher.addEnterFrame(countEnterFrame);
        } else {
            g.hint.hideIt();
        }
    }

    private function countEnterFrame():void {
        _countTimer--;
        if (_countTimer <= 0) {
            g.gameDispatcher.removeEnterFrame(countEnterFrame);
            if (_isOnHover == true) {
                g.timerHint.needMoveCenter = true;
                g.timerHint.showIt(90, g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + (_source.y - _source.height / 3) * g.currentGameScale, _leftBuildTime, _dataBuild.priceSkipHard, _dataBuild.name, callbackSkip, onOut);
            }
            if (_isOnHover == false) {
                if(_source)_source.filter = null;
                g.timerHint.hideIt();
                g.gameDispatcher.removeEnterFrame(countEnterFrame);
            }
        }
    }

    public function openFabricaWindow():void {
        g.windowsManager.openWindow(WindowsManager.WO_FABRICA, callbackOnChooseRecipe, _arrRecipes.slice(), _arrList.slice(), this);
    }

    private function onClick():void {
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
                        var item:CraftItem = _arrCrafted.pop();
                        item.flyIt();
                    }
                } else {
                    if (!_arrRecipes.length) updateRecipes();
                    if (!g.managerTutorial.isTutorial) g.cont.moveCenterToXY(_source.x, _source.y);
                    onOut();
                    openFabricaWindow();
                }
            } else {
                Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
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
                                _leftBuildTime, _dataBuild.priceSkipHard, _dataBuild.name, callbackSkip, onOut);
                    } else return;
                } else {
                    g.timerHint.needMoveCenter = true;
                    g.timerHint.showIt(90, g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + (_source.y - _source.height/3) * g.currentGameScale,
                            _leftBuildTime, _dataBuild.priceSkipHard, _dataBuild.name, callbackSkip, onOut);
                }
            }
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.PUT_FABRICA) return;
            _stateBuild = STATE_ACTIVE;
            g.user.userBuildingData[_dataBuild.id].isOpen = 1;
            if (g.useDataFromServer) {
                g.directServer.openBuildedBuilding(this, onOpenBuilded);
            }
            clearCraftSprite();
            onOut();
            createAnimatedBuild(onCreateBuild);
            _source.setChildIndex(_craftSprite, _source.numChildren-1);
            if (_dataBuild.xpForBuild) {
                var start:Point = new Point(int(_source.x), int(_source.y));
                start = _source.parent.localToGlobal(start);
                new XPStar(start.x, start.y, _dataBuild.xpForBuild);
            }
            showBoom();
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.PUT_FABRICA && g.managerTutorial.isTutorialBuilding(this)) {
                g.managerTutorial.checkTutorialCallback();
            } else g.windowsManager.openWindow(WindowsManager.POST_OPEN_FABRIC,null,_dataBuild);

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

    public function callbackOnChooseRecipe(resItem:ResourceItem, dataRecipe:Object, isFromServer:Boolean = false, deltaTime:int = 0):void {
        if (!_heroCat) _heroCat = g.managerCats.getFreeCat();
        if (!_arrList.length && !_heroCat) {
            if (g.managerCats.curCountCats == g.managerCats.maxCountCats) {
                g.windowsManager.openWindow(WindowsManager.WO_WAIT_FREE_CATS);
            } else {
                g.windowsManager.openWindow(WindowsManager.WO_NO_FREE_CATS);
            }
            return;
        }

        _heroCat.isFree = false;
        _arrList.push(resItem);
        resItem.leftTime -= deltaTime;
        resItem.currentRecipeID = dataRecipe.id;
        if (_arrList.length == 1) {
            g.gameDispatcher.addToTimer(render);
        }

        if (isFromServer) {
            _heroCat.setPosition(new Point(posX, posY));
            _heroCat.updatePosition();
            onHeroAnimation();
        } else {
            var i:int;
            if (_arrList.length > 1) {
                onHeroAnimation();
            } else {
                g.managerCats.goCatToPoint(_heroCat, new Point(posX, posY), onHeroAnimation);
            }

            // send to server
            if (g.user.userBuildingData) {
                var delay:int = 0;  // delay before start make this new recipe
                if (_arrList.length > 1) {
                    for (i = 0; i < _arrList.length - 1; i++) {
                        delay += _arrList[i].buildTime;
                    }
                }

            }
            var f1:Function = function(t:String):void {
                resItem.idFromServer = t;
                for (var i:int = 0; i < dataRecipe.ingridientsId.length; i++) {
                    g.userInventory.addResource(int(dataRecipe.ingridientsId[i]), -int(dataRecipe.ingridientsCount[i]));
                }
            };
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
    }

    private function onHeroAnimation():void {
        if (_arrList.length && _heroCat) {
            startAnimation();
            _heroCat.visible = false;
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
                g.gameDispatcher.removeFromTimer(render);
                stopAnimation();
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
        var f1:Function = function():void {
            if (g.useDataFromServer) g.managerFabricaRecipe.onCraft(item);
        };
        var craftItem:CraftItem = new CraftItem(0, 135*g.scaleFactor, item, _craftSprite, countResources, f1);
        _arrCrafted.push(craftItem);
        craftItem.removeDefaultCallbacks();
        craftItem.addParticle();
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
    }

    public function awayImitationOfWork():void {
        startAnimation();
    }

    private function startAnimation():void {
        if(_armature) _armature.addEventListener(AnimationEvent.COMPLETE, chooseAnimation);
        if(_armature) _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, chooseAnimation);
        releaseHeroCatWoman();
        chooseAnimation();
    }

    private function stopAnimation():void {
        if (_armature.hasEventListener(AnimationEvent.COMPLETE)) _armature.removeEventListener(AnimationEvent.COMPLETE, chooseAnimation);
        if (_armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, chooseAnimation);
        if (_armature) _armature.animation.gotoAndStop('idle', 0);
    }

    private function chooseAnimation(e:AnimationEvent = null):void {
        if (_armature) if (!_armature.hasEventListener(AnimationEvent.COMPLETE)) _armature.addEventListener(AnimationEvent.COMPLETE, chooseAnimation);
        if (_armature) if (!_armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, chooseAnimation);
        if (_armature) {
            var k:int = int(Math.random() * 6);
            switch (k) {
                case 0:
                    _armature.animation.gotoAndPlay('idle1');
                    break;
                case 1:
                    _armature.animation.gotoAndPlay('idle1');
                    break;
                case 2:
                    _armature.animation.gotoAndPlay('idle1');
                    break;
                case 3:
                    _armature.animation.gotoAndPlay('idle2');
                    break;
                case 4:
                    _armature.animation.gotoAndPlay('idle3');
                    break;
                case 5:
                    _armature.animation.gotoAndPlay('idle4');
                    break;
            }
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
        if (_armature) _armature.dispose();
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
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.SKIP_TIMER, {id: AnalyticManager.SKIP_TIMER_FABRICA_ID, info: _arrList[0].id});
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
        changeTexture("head", "heads/head");
        changeTexture("body", "bodys/body");
        changeTexture("handLeft", "left_hand/handLeft");
        changeTexture("legLeft", "left_leg/legLeft");
        changeTexture("handRight", "right_hand/handRight");
        changeTexture("legRight", "right_leg/legRight");
        changeTexture("tail", "tails/tail");
        if (_dataBuild.id == 10) {
            changeTexture("handRight2", "right_hand/handRight");
        }
        var viyi:Bone = _armature.getBone('viyi'); {
            if (viyi) {
                viyi.visible = false;
            }
        }
    }

    private function releaseManBackTexture():void {
        changeTexture("head", "heads_b/head_b");
        changeTexture("body", "bodys_b/body_b");
        changeTexture("handLeft", "left_hand_b/handLeft_b");
        changeTexture("legLeft", "left_leg_b/legLeft_b");
        changeTexture("handRight", "right_hand_b/handRight_b");
        changeTexture("legRight", "right_leg_b/legRight_b");
        changeTexture("tail", "tails/tail");
    }

    private function releaseWomanFrontTexture():void {
        if (!_armature) return;
        changeTexture("head", "heads/head_w");
        changeTexture("body", "bodys/body_w");
        changeTexture("handLeft", "left_hand/handLeft_w");
        changeTexture("legLeft", "left_leg/legLeft_w");
        changeTexture("handRight", "right_hand/handRight_w");
        changeTexture("legRight", "right_leg/legRight_w");
        changeTexture("tail", "tails/tail_w");
        if (_dataBuild.id == 10) {
            changeTexture("handRight2", "right_hand/handRight_w");
        }
        var viyi:Bone = _armature.getBone('viyi'); {
            if (viyi) {
                viyi.visible = true;
            }
        }
    }

    private function releaseWomanBackTexture():void {
        changeTexture("head", "heads_b/head_w_b");
        changeTexture("body", "bodys_b/body_w_b");
        changeTexture("handLeft", "left_hand_b/handLeft_w_b");
        changeTexture("legLeft", "left_leg_b/legLeft_w_b");
        changeTexture("handRight", "right_hand_b/handRight_w_b");
        changeTexture("legRight", "right_leg_b/legRight_w_b");
        changeTexture("tail", "tails/tail_w");
    }

    private function changeTexture(oldName:String, newName:String):void {
        var im:Image = g.allData.factory['cat'].getTextureDisplay(newName) as Image;
        if (_armature) var b:Bone = _armature.getBone(oldName);
        if (b) {
            im.pivotX = b.display.pivotX;
            im.pivotY = b.display.pivotY;
            b.display.dispose();
            b.display = im;
        } else {
            Cc.error('Fabrica changeTexture:: null Bone for oldName= '+oldName + ' for fabricaId= '+String(_dataBuild.id));
        }
    }

    private function showBoom():void {
        _armatureOpen = g.allData.factory['explode'].buildArmature("expl");
        if (!_armatureOpen) return;
        _armatureOpen.display.scaleX = _armatureOpen.display.scaleY = 1.5;
        _source.addChild(_armatureOpen.display as Sprite);
        WorldClock.clock.add(_armatureOpen);
        _armatureOpen.addEventListener(AnimationEvent.COMPLETE, onBoom);
        _armatureOpen.addEventListener(AnimationEvent.LOOP_COMPLETE, onBoom);
        _armatureOpen.animation.gotoAndPlay("start");
    }

    private function onBoom(e:AnimationEvent=null):void {
        if (_armatureOpen.hasEventListener(AnimationEvent.COMPLETE)) _armatureOpen.removeEventListener(AnimationEvent.COMPLETE, onBoom);
        if (_armatureOpen.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armatureOpen.removeEventListener(AnimationEvent.LOOP_COMPLETE, onBoom);
        WorldClock.clock.remove(_armatureOpen);
        _source.removeChild(_armatureOpen.display as Sprite);
        _armatureOpen.dispose();
        _armatureOpen = null;
        if (!g.managerTutorial.isTutorial) {
            g.windowsManager.openWindow(WindowsManager.POST_OPEN_FABRIC,null,_dataBuild);
        }

    }

}
}
