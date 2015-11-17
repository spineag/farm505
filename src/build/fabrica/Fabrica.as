/**
 * Created by user on 6/9/15.
 */
package build.fabrica {
import build.AreaObject;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import data.BuildType;

import flash.geom.Point;

import heroes.HeroCat;

import resourceItem.CraftItem;

import com.junkbyte.console.Cc;

import resourceItem.RawItem;

import resourceItem.ResourceItem;

import mouse.ToolsModifier;

import starling.core.Starling;

import starling.display.Sprite;

import starling.filters.BlurFilter;
import starling.textures.Texture;
import starling.utils.Color;

import ui.xpPanel.XPStar;

public class Fabrica extends AreaObject {
    private var _arrRecipes:Array;  // массив всех рецептов, которые можно изготовить на этой фабрике
    private var _arrList:Array; // массив заказанных для изготовления ресурсов
    private var _tween:TweenMax;
    private var _isAnim:Boolean;
    private var _isOnHover:Boolean;
    private var _heroCat:HeroCat;
    private var _count:int;
    private var _arrCrafted:Array;

    public function Fabrica(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for Fabrica');
            g.woGameError.showIt();
            return;
        }
        _craftSprite = new Sprite();
        _source.addChild(_craftSprite);
        checkBuildState();
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;
        _source.setChildIndex(_craftSprite, _source.numChildren-1);

        _isAnim = false;
        _arrRecipes = [];
        _arrList = [];
        _arrCrafted = [];
        _source.releaseContDrag = true;
        _dataBuild.isFlip = _flip;
        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        }
        fillRecipes();
    }

    private function onHover():void {
        if (g.isActiveMapEditor) return;
        _isOnHover = true;
        _count = 20;
        _source.filter = BlurFilter.createGlow(Color.RED, 10, 2, 1);
        if (_stateBuild == STATE_ACTIVE) {
            g.hint.showIt(_dataBuild.name, "0");
        } else if (_stateBuild == STATE_BUILD) {
            g.gameDispatcher.addEnterFrame(countEnterFrame);
        }
    }

    private function countEnterFrame():void {
        _count--;
        if(_count <=0){
            g.gameDispatcher.removeEnterFrame(countEnterFrame);
            if (_isOnHover == true) {
                g.timerHint.needMoveCenter = true;
                g.timerHint.showIt(g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + _source.y * g.currentGameScale, _leftBuildTime, 5, _dataBuild.name,callbackSkip);
            }
            if (_isOnHover == false) {
                _source.filter = null;
                g.timerHint.hideIt();
            }
        }
    }

    private function onOut():void {
        if (g.isActiveMapEditor) return;
        _isOnHover = false;
        _source.filter = null;
        if (_stateBuild == STATE_BUILD) {
            g.gameDispatcher.addEnterFrame(countEnterFrame);
        } else {
            g.hint.hideIt();
        }
    }

    private function onClick():void {
        if (g.isActiveMapEditor) return;
        if (_stateBuild == STATE_ACTIVE) {
            if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
                g.townArea.moveBuild(this);
                _isOnHover = false;
                g.gameDispatcher.addEnterFrame(countEnterFrame);
            } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
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
                if (_source.wasGameContMoved) return;
                if (_arrCrafted.length) {
                    (_arrCrafted.pop() as CraftItem).flyIt();
                } else {
                    g.cont.moveCenterToXY(_source.x, _source.y);
                    g.woFabrica.showItWithParams(_arrRecipes.slice(), _arrList.slice(), this, callbackOnChooseRecipe);
                    _source.filter = null;
                    g.hint.hideIt();
                }
            } else {
                Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
            }
        } else if (_stateBuild == STATE_BUILD) {
            if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
                g.townArea.moveBuild(this);
            }
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            _stateBuild = STATE_ACTIVE;
            g.user.userBuildingData[_dataBuild.id].isOpen = 1;
            if (g.useDataFromServer) {
                g.directServer.openBuildedBuilding(this, onOpenBuilded);
            }
            clearCraftSprite();
            _source.filter = null;
            createBuild();
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

    private function fillRecipes():void {
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
                texture = g.allData.atlas[obj.url].getTexture(obj.imageShop);
                new RawItem(p, texture, int(dataRecipe.ingridientsCount[i]), i * .1);
            }
        }
    }

    private function onHeroAnimation():void {
        startTempAnimation();
        _heroCat.visible = false;
    }

    private function render():void {
        _arrList[0].leftTime--;
        if (_arrList[0].leftTime <= 0) {
            craftResource(_arrList.shift());
            if (!_arrList.length) {
                g.gameDispatcher.removeFromTimer(render);
                stopTempAnimation();
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
        var craftItem:CraftItem = new CraftItem(0, 0, item, _craftSprite, countResources, f1);
        _arrCrafted.push(craftItem);
        craftItem.removeDefaultCallbacks();
        if (!_arrList.length && _heroCat) {
            _heroCat.visible = true;
            _heroCat.isFree = true;
            g.managerCats.goCatToPoint(_heroCat, g.managerCats.getRandomFreeCell());
            _heroCat = null;
        }
    }

    public function awayImitationOfWork():void {
        startTempAnimation();
    }

    private function startTempAnimation():void {
        _isAnim = true;
        TweenMax.killTweensOf(_build);
        anim1();
    }

    private function anim1():void {
        if (_isAnim) {
            _tween = new TweenMax(_build, .5, {scaleX:.97, scaleY:1.03, ease:Linear.easeOut, onComplete: anim2});
        }
    }

    private function anim2():void {
        if (_isAnim) {
            _tween = new TweenMax(_build, .5, {scaleX:1.03, scaleY:.97, ease:Linear.easeOut, onComplete: anim1});
        }
    }

    private function stopTempAnimation():void {
        _isAnim = false;
        if (_tween) {
            TweenMax.killTweensOf(_build);
        }
        _build.scaleX = _build.scaleY = 1;
        _tween = null;
    }

    override public function clearIt():void {
        onOut();
        stopTempAnimation();
        g.gameDispatcher.removeEnterFrame(countEnterFrame);
        g.gameDispatcher.removeFromTimer(render);
        _source.touchable = false;
        _arrList.length = 0;
        _arrRecipes.length = 0;
        super.clearIt();
    }

    private function callbackSkip():void {
        _stateBuild = STATE_WAIT_ACTIVATE;
//        createBuild();
        clearCraftSprite();
        addTempGiftIcon();
//        checkBuildState();
    }

    public function onBuyNewCell():void {
        _dataBuild.countCell++;
        g.directServer.buyNewCellOnFabrica(_dbBuildingId, _dataBuild.countCell, null);
    }

    public function skipRecipe():void {
        g.woFabrica.onClickExit();
        g.directServer.skipRecipeOnFabrica(_arrList[0].idFromServer, _arrList[0].leftTime, _dbBuildingId, null);
        _arrList.shift();
        g.woFabrica.showItWithParams(_arrRecipes, _arrList, this, callbackOnChooseRecipe);
    }

}
}
