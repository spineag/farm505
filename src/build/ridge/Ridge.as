/**
 * Created by user on 6/2/15.
 */
package build.ridge {
import build.AreaObject;

import com.junkbyte.console.Cc;

import mouse.ToolsModifier;

import starling.filters.BlurFilter;
import starling.utils.Color;

import utils.CSprite;

public class Ridge extends AreaObject{
    public static const EMPTY:int = 1;
    public static const GROW1:int = 2;
    public static const GROW2:int = 3;
    public static const GROW3:int = 4;
    public static const GROWED:int = 5;

    private var _dataPlant:Object;
    private var _plant:PlantOnRidge;
    private var _stateRidge:int;

    public function Ridge(_data:Object) {
        super(_data);
        _stateRidge = EMPTY;

        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.GREEN, 10, 2, 1);
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            // скидываем на дефолтный NONE
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_stateRidge == EMPTY) {
                _source.filter = null;
                g.woBuyPlant.showItWithParams(this);
            } else if (_stateRidge == GROWED) {
                // собираем урожай
            }
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function onOut():void {
        _source.filter = null;
    }

    public function fillPlant(data:Object):void {
        _stateRidge = GROW1;
        _dataPlant = data;
        _plant = new PlantOnRidge(this, _dataPlant);
    }

    public function get stateRidge():int {
        return _stateRidge;
    }

    public function set stateRidge(a:int):void {
        _stateRidge = a;
    }
}
}
