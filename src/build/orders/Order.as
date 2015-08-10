/**
 * Created by user on 7/22/15.
 */
package build.orders {
import build.AreaObject;

import com.junkbyte.console.Cc;


import mouse.ToolsModifier;

import starling.filters.BlurFilter;
import starling.utils.Color;


public class Order extends AreaObject{

    public function Order (data:Object) {
        super (data);
        createBuild();
        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _dataBuild.isFlip = _flip;
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
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            g.woOrder.showItMenu();
            g.hint.hideIt();
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }

    }
}
}
