/**
 * Created by andy on 5/28/15.
 */
package build.testBuild {
import build.AreaObject;

import com.junkbyte.console.Cc;

import map.TownArea;

import mouse.ToolsModifier;

import starling.filters.BlurFilter;
import starling.utils.Color;

public class TestBuild extends AreaObject{


    public function TestBuild(_data:Object) {
        super(_data);
        createBuild();

        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _source.releaseContDrag = true;
        _dataBuild.isFlip = _flip;
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.RED, 10, 2, 1);
        g.hint.showIt(_dataBuild.name);

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

        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }

    }

    private function onOut():void {
        _source.filter = null;
        g.hint.hideIt();
    }

}
}
