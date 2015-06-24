/**
 * Created by user on 6/11/15.
 */
package build.tree {
import build.AreaObject;
import resourceItem.CraftItem;

import com.junkbyte.console.Cc;

import resourceItem.ResourceItem;

import mouse.ToolsModifier;

import starling.display.Sprite;

import starling.filters.BlurFilter;
import starling.utils.Color;

public class Tree extends AreaObject{
    private const GROW1:int = 1;
    private const GROWED1:int = 2;
    private const GROW2:int = 3;
    private const GROWED2:int = 4;
    private const GROW3:int = 5;
    private const GROWED3:int = 6;
    private const GROW4:int = 7;
    private const GROWED4:int = 8;
    private const DEAD:int = 9;
    private const ASK_FIX:int = 10;
    private const FIXED:int = 11;
    private const GROW_FIXED:int = 12;
    private const GROWED_FIXED:int = 13;
    private const FULL_DEAD:int = 14;

    private var _state:int;
    private var _resourceItem:ResourceItem;

    public function Tree(_data:Object) {
        super(_data);

        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _dataBuild.isFlip = _flip;

        _craftSprite = new Sprite();
        _source.addChild(_craftSprite);
        _resourceItem = new ResourceItem();
        _resourceItem.fillIt(g.dataResource.objectResources[_dataBuild.craftIdResource]);
        startGrow(GROW1);
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1);
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
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {

        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function startGrow(state:int):void {
        _state = state;
        g.gameDispatcher.addToTimer(render);
    }

    private function render():void {
        _resourceItem.leftTime--;
        if (_resourceItem.leftTime <=0) {
            _resourceItem.leftTime = _resourceItem.buildTime;
            craftResource();
            g.gameDispatcher.removeFromTimer(render);
            switch (_state) {
                case GROW1: _state = GROWED1; break;
                case GROW2: _state = GROWED2; break;
                case GROW3: _state = GROWED3; break;
                case GROW4: _state = GROWED4; break;
                case GROW_FIXED: _state = GROWED_FIXED; break;
            }
        }
    }

    private function craftResource():void {
        var item:CraftItem = new CraftItem(0, 0, _resourceItem, _craftSprite, 1);
    }
}
}
