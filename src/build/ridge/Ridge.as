/**
 * Created by user on 6/2/15.
 */
package build.ridge {
import build.AreaObject;

import com.junkbyte.console.Cc;

import mouse.ToolsModifier;

import starling.filters.BlurFilter;
import starling.utils.Color;

public class Ridge extends AreaObject{
    public function Ridge(_data:Object) {
        super(_data);

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

        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }

    }

    private function onOut():void {
        _source.filter = null;
    }
}
}
