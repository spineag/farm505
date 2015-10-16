/**
 * Created by user on 6/9/15.
 */
package build.fabrica {
import build.AreaObject;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import data.BuildType;

import flash.geom.Point;

import resourceItem.CraftItem;

import com.junkbyte.console.Cc;

import resourceItem.RawItem;

import resourceItem.ResourceItem;

import mouse.ToolsModifier;

import starling.display.Sprite;

import starling.filters.BlurFilter;
import starling.textures.Texture;
import starling.utils.Color;

import ui.xpPanel.XPStar;

public class Fabrica extends AreaObject {
    private var _arrRecipes:Array;  // массив всех рецептов, которые можно изготовить на этой фабрике
    private var _arrList:Array; // массив заказанных для изготовления ресурсов
    private var _maxListCount:int = 3;
    private var _tween:TweenMax;
    private var _isAnim:Boolean;
    private var _isOnHover:Boolean;
    private var _count:int;

    public function Fabrica(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for Fabrica');
            g.woGameError.showIt();
            return;
        }
        _craftSprite = new Sprite();
        checkBuildState();

        _isAnim = false;
        _arrRecipes = [];
        _arrList = [];
        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _source.releaseContDrag = true;
        _dataBuild.isFlip = _flip;

        _source.addChild(_craftSprite);
        fillRecipes();
    }

    private function onHover():void {
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
                g.timerHint.showIt(g.cont.gameCont.x + _source.x, g.cont.gameCont.y + _source.y, _leftBuildTime, _dataBuild.cost, _dataBuild.name);
            }
            if (_isOnHover == false) {
                _source.filter = null;
                g.timerHint.hideIt();
            }
        }
    }

    private function onOut():void {
        _isOnHover = false;
        _source.filter = null;
        if (_stateBuild == STATE_BUILD) {
            g.gameDispatcher.addEnterFrame(countEnterFrame);
        } else {
            g.hint.hideIt();
        }
    }

    private function onClick():void {
        if (_stateBuild == STATE_ACTIVE) {
            if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
                g.townArea.moveBuild(this);
                _isOnHover = false;
                g.gameDispatcher.addEnterFrame(countEnterFrame);
            } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
                g.townArea.deleteBuild(this);
            } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
                releaseFlip();
            } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {

            } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
                // ничего не делаем вообще
            } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
            } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
                if (_source.wasGameContMoved) return;
                g.woFabrica.showItWithParams(_arrRecipes, _arrList, _maxListCount, callbackOnChooseRecipe);
                _source.filter = null;
                g.hint.hideIt();
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

    private function onOpenBuilded(value:Boolean):void { }

    private function fillRecipes():void {
        try {
        var obj:Object = g.dataRecipe.objectRecipe;
        for(var id:String in obj) {
            if (obj[id].buildingId == _dataBuild.id) {
                _arrRecipes.push(obj[id]);
            }
        }
        } catch (e:Error) {
            Cc.error('fabrica recipe error: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    public function callbackOnChooseRecipe(resItem:ResourceItem, dataRecipe:Object, isFromServer:Boolean = false, deltaTime:int = 0):void {
        var i:int;
        if (g.user.userBuildingData && !isFromServer) {
            var delay:int = 0;
            for (i=0; i<_arrList.length; i++) {
                delay += _arrList[i].buildTime;
            }
            var f1:Function = function(t:String):void {
                resItem.idFromServer = t;
            };
            g.directServer.addFabricaRecipe(dataRecipe.id, _dbBuildingId, delay, f1);
        }
        _arrList.push(resItem);
        resItem.leftTime -= deltaTime;
        resItem.currentRecipeID = dataRecipe.id;
        if (_arrList.length == 1) {
            g.gameDispatcher.addToTimer(render);
            startTempAnimation();
        }
        var p:Point = new Point(source.x, source.y);
        p = source.parent.localToGlobal(p);
        var obj:Object;
        var texture:Texture;
        for (i = 0; i < dataRecipe.ingridientsId.length; i++) {
            obj = g.dataResource.objectResources[int(dataRecipe.ingridientsId[i])];
            if (obj.buildType == BuildType.PLANT) {
                texture = g.plantAtlas.getTexture(g.dataResource.objectResources[int(dataRecipe.ingridientsId[i])].imageShop);
            } else if (obj.buildType == BuildType.RESOURCE) {
                texture = g.resourceAtlas.getTexture(g.dataResource.objectResources[int(dataRecipe.ingridientsId[i])].imageShop);
            } else if (obj.buildType == BuildType.INSTRUMENT) {
                texture = g.instrumentAtlas.getTexture(g.dataResource.objectResources[int(dataRecipe.ingridientsId[i])].imageShop);
            }
            if (!isFromServer) new RawItem(p, texture, int(dataRecipe.ingridientsCount[i]), i*.1);
        }
    }

    private function render():void {
        _arrList[0].leftTime--;
        if (_arrList[0].leftTime <= 0) {
            craftResource(_arrList[0]);
            _arrList.shift();
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
    }

    private function startTempAnimation():void {
        _isAnim = true;
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

}
}
