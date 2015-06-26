/**
 * Created by user on 6/9/15.
 */
package build.fabrica {
import build.AreaObject;

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

public class Fabrica extends AreaObject {
    private var _arrRecipes:Array;  // массив всех рецептов, которые можно изготовить на этой фабрике
    private var _arrList:Array; // массив заказанных для изготовления ресурсов
    private var _maxListCount:int = 3;

    public function Fabrica(_data:Object) {
        super(_data);

        _arrRecipes = [];
        _arrList = [];
        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _dataBuild.isFlip = _flip;

        _craftSprite = new Sprite();
        _source.addChild(_craftSprite);
        fillRecipes();
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.RED, 10, 2, 1);
        g.hint.showIt(_dataBuild.name, "0");
    }

    private function onOut():void {
        _source.filter = null;
        g.hint.hideIt();
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            g.townArea.moveBuild(this);
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
            g.woFabrica.showItWithParams(_arrRecipes, _arrList, _maxListCount, callbackOnChooseRecipe);
            _source.filter = null;
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }

    }

    private function fillRecipes():void {
        var obj:Object = g.dataRecipe.objectRecipe;
        for(var id:String in obj) {
            if (obj[id].buildingId == _dataBuild.id) {
                _arrRecipes.push(obj[id]);
            }
        }
    }

    private function callbackOnChooseRecipe(resourceItem:ResourceItem, dataRecipe:Object):void {
        _arrList.push(resourceItem);
        if (_arrList.length == 1) {
            g.gameDispatcher.addToTimer(render);
        }
        var p:Point = new Point(source.x, source.y);
        p = source.parent.localToGlobal(p);
        var obj:Object;
        var texture:Texture;
        for (var i:int = 0; i < dataRecipe.ingridientsId.length; i++) {
            obj = g.dataResource.objectResources[dataRecipe.ingridientsId[i]];
            if (obj.buildType == BuildType.PLANT) {
                texture = g.plantAtlas.getTexture(g.dataResource.objectResources[dataRecipe.ingridientsId[i]].imageShop);
            } else if (obj.buildType == BuildType.RESOURCE) {
                texture = g.resourceAtlas.getTexture(g.dataResource.objectResources[dataRecipe.ingridientsId[i]].imageShop);
            } else if (obj.buildType == BuildType.INSTRUMENT) {
                texture = g.instrumentAtlas.getTexture(g.dataResource.objectResources[dataRecipe.ingridientsId[i]].imageShop);
            }
            new RawItem(p, texture, dataRecipe.ingridientsCount[i], i*.1);
        }
    }

    private function render():void {
        _arrList[0].leftTime--;
        if (_arrList[0].leftTime <= 0) {
            craftResource(_arrList[0]);
            _arrList.shift();
            if (!_arrList.length) {
                g.gameDispatcher.removeFromTimer(render);
            }
        }
    }

    private function craftResource(item:ResourceItem):void {
        var countResources:int = 1;
        for(var id:String in g.dataRecipe.objectRecipe) {
            if (g.dataRecipe.objectRecipe[id].buildingId == _dataBuild.id &&
                    item.resourceID == g.dataRecipe.objectRecipe[id].idResource) {
                countResources = g.dataRecipe.objectRecipe[id].numberCreate;
            }
        }
        var craftItem:CraftItem = new CraftItem(0, 0, item, _craftSprite, countResources);
    }

}
}
