/**
 * Created by user on 6/9/15.
 */
package build.fabrica {
import build.AreaObject;

import com.junkbyte.console.Cc;

import mouse.ToolsModifier;

import starling.filters.BlurFilter;
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

        fillRecipes();
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.RED, 10, 2, 1);
    }

    private function onOut():void {
        _source.filter = null;
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

    private function callbackOnChooseRecipe(dataRecipe:Object):void {
        _arrList.push(dataRecipe);
        if (_arrList.length == 1) {
            g.gameDispatcher.addToTimer(render);
        }
    }

    private function render():void {
        _arrList[0].leftTime--;
        if (_arrList[0].leftTime <= 0) {
            _arrList[0].leftTime = _arrList[0].buildTime;
            craftRecipe(_arrList[0]);
            _arrList.shift();
            if (_arrList.length) {
                _arrList[0].timeLeft = _arrList[0].buildTime;
            } else {
                g.gameDispatcher.removeFromTimer(render);
            }
        }
    }

    private function craftRecipe(recipe:Object):void {

    }

}
}
