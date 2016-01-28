/**
 * Created by user on 6/9/15.
 */
package build.fabrica {
import build.AreaObject;

import data.BuildType;
import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.animation.WorldClock;

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

import ui.xpPanel.XPStar;

public class Fabrica extends AreaObject {
    private var _arrRecipes:Array;  // массив всех рецептов, которые можно изготовить на этой фабрике
    private var _arrList:Array; // массив заказанных для изготовления ресурсов
    private var _isOnHover:Boolean;
    private var _heroCat:HeroCat;
    private var _count:int;
    private var _arrCrafted:Array;
    private var _armature:Armature;

    public function Fabrica(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for Fabrica');
            g.woGameError.showIt();
            return;
        }
        if (!_dataBuild.countCell) {
            _dataBuild.countCell = g.dataBuilding.objectBuilding[_dataBuild.id].startCountCell;
        }
        _craftSprite = new Sprite();
        _source.addChild(_craftSprite);
        checkBuildState();
        _source.setChildIndex(_craftSprite, _source.numChildren - 1);

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

    override public function createBuild(isImageClicked:Boolean = true):void {
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }
        _armature = g.allData.factory[_dataBuild.image].buildArmature("fabrica");
        _build.addChild(_armature.display as Sprite);
        _rect = _build.getBounds(_build);
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;
        (_build as Sprite).alpha = 1;
        _source.addChild(_build);
        WorldClock.clock.add(_armature);
        stopAnimation();
    }

    public function showShopView():void {
        createBuild();
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

    private function onHover():void {
        if (g.selectedBuild) return;
        if (g.isActiveMapEditor) return;
        _isOnHover = true;
        _count = 20;
        _source.filter = ManagerFilters.BUILD_STROKE;
        if (_stateBuild == STATE_ACTIVE) {
            g.hint.showIt(_dataBuild.name);
        }
    }

    private function onOut():void {
        if (g.isActiveMapEditor) return;
        _isOnHover = false;
        _source.filter = null;
        if (_stateBuild == STATE_BUILD) {
            g.timerHint.hideIt();
        } else {
            g.hint.hideIt();
        }
    }

    private function onClick():void {
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            onOut();
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
                        g.woAmbarFilled.showAmbarFilled(false);
                    } else {
                        var item:CraftItem = _arrCrafted.pop();
                        item.flyIt();
                    }
                } else {
                    if (!_arrRecipes.length) updateRecipes();
                    g.cont.moveCenterToXY(_source.x, _source.y);
                    onOut();
                    g.woFabrica.showItWithParams(_arrRecipes.slice(), _arrList.slice(), this, callbackOnChooseRecipe);
                }
            } else {
                Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
            }
        } else if (_stateBuild == STATE_BUILD) {
            g.timerHint.needMoveCenter = true;
            g.timerHint.showIt(90, g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + _source.y * g.currentGameScale, _leftBuildTime, _dataBuild.priceSkipHard, _dataBuild.name, callbackSkip, onOut);
            if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
                onOut();
                g.townArea.moveBuild(this);
            }
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            _stateBuild = STATE_ACTIVE;
            g.user.userBuildingData[_dataBuild.id].isOpen = 1;
            if (g.useDataFromServer) {
                g.directServer.openBuildedBuilding(this, onOpenBuilded);
            }
            clearCraftSprite();
            onOut();
            createBuild();
            _source.setChildIndex(_craftSprite, _source.numChildren-1);
            if (_dataBuild.xpForBuild) {
                var start:Point = new Point(int(_source.x), int(_source.y));
                start = _source.parent.localToGlobal(start);
                new XPStar(start.x, start.y, _dataBuild.xpForBuild);
            }
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
            g.woGameError.showIt();
        }
    }

    public function get heroCat():HeroCat {
        return _heroCat;
    }

    public function callbackOnChooseRecipe(resItem:ResourceItem, dataRecipe:Object, isFromServer:Boolean = false, deltaTime:int = 0):void {
        if (!_heroCat) _heroCat = g.managerCats.getFreeCat();

        if (!_arrList.length && !_heroCat) {
            if (g.managerCats.curCountCats == g.managerCats.maxCountCats) {
                g.woWaitFreeCats.showIt();
            } else {
                g.woNoFreeCats.showIt();
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
        _armature.animation.gotoAndPlay('work');
        releaseHeroCatWoman();
    }

    private function stopAnimation():void {
       _armature.animation.gotoAndStop('idle', 0);
    }

    override public function clearIt():void {
        onOut();
        stopAnimation();
        WorldClock.clock.remove(_armature);
        g.gameDispatcher.removeFromTimer(render);
        _source.touchable = false;
        _arrList.length = 0;
        _arrRecipes.length = 0;
        _armature.dispose();
        super.clearIt();
    }

    private function callbackSkip():void { // for building build
        _stateBuild = STATE_WAIT_ACTIVATE;
        g.directServer.skipTimeOnFabricBuild(_leftBuildTime,dbBuildingId,null);
        _leftBuildTime = 0;
        renderBuildProgress();
    }

    public function onBuyNewCell():void {
        _dataBuild.countCell++;
        g.directServer.buyNewCellOnFabrica(_dbBuildingId, _dataBuild.countCell, null);
    }

    public function skipRecipe():void { // for making recipe
        if (_arrList[0]) {
            g.directServer.skipRecipeOnFabrica(_arrList[0].idFromServer, _arrList[0].leftTime, _dbBuildingId, null);
            craftResource(_arrList.shift());
        } else {
            Cc.error('Fabrica skipRecipe:: _arrList[0] == null');
        }
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
        var b:Bone = _armature.getBone(oldName);
        if (b) {
            b.display.dispose();
            b.display = im;
        } else {
            Cc.error('Fabrica changeTexture:: null Bone for oldName= '+oldName + ' for fabricaId= '+String(_dataBuild.id));
        }
    }

}
}
